import os
import platform
import re
import shlex
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from pprint import pprint
from textwrap import dedent

from importlib_metadata import files
from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext


def check_env(build):
    return os.environ.get(build, 0) in {"1", "true", "True", "ON", "YES"}


def get_exe_suffix():
    if platform.system() == "Windows":
        suffix = ".exe"
    else:
        suffix = ""
    return suffix


class CMakeExtension(Extension):
    def __init__(self, name: str, sourcedir: str = "") -> None:
        super().__init__(name, sources=[])
        self.sourcedir = os.fspath(Path(sourcedir).resolve())


def get_cross_cmake_args():
    cmake_args = {}

    def native_tools():
        nonlocal cmake_args

        mlir_tblgen_host = next(
            f.locate()
            for f in files("mlir-native-tools")
            if f.name.startswith("mlir-tblgen")
        )
        mlir_tblgen_target = next(
            f.locate() for f in files("mlir") if f.name.startswith("mlir-tblgen")
        )
        shutil.copy(mlir_tblgen_host, mlir_tblgen_target)
        mlir_pdll_host = next(
            f.locate()
            for f in files("mlir-native-tools")
            if f.name.startswith("mlir-pdll")
        )
        mlir_pdll_target = next(
            f.locate() for f in files("mlir") if f.name.startswith("mlir-pdll")
        )
        shutil.copy(mlir_pdll_host, mlir_pdll_target)

    CIBW_ARCHS = os.environ.get("CIBW_ARCHS")
    if CIBW_ARCHS in {"arm64", "aarch64", "ARM64"}:
        ARCH = cmake_args["LLVM_TARGETS_TO_BUILD"] = "AArch64"
    elif CIBW_ARCHS in {"x86_64", "AMD64"}:
        ARCH = cmake_args["LLVM_TARGETS_TO_BUILD"] = "X86"
    else:
        raise ValueError(f"unknown CIBW_ARCHS={CIBW_ARCHS}")
    if CIBW_ARCHS != platform.machine():
        cmake_args["CMAKE_SYSTEM_NAME"] = platform.system()

    if platform.system() == "Darwin":
        if ARCH == "AArch64":
            cmake_args["CMAKE_OSX_ARCHITECTURES"] = "arm64"
            cmake_args["LLVM_HOST_TRIPLE"] = "arm64-apple-darwin21.6.0"
            native_tools()
        elif ARCH == "X86":
            cmake_args["CMAKE_OSX_ARCHITECTURES"] = "x86_64"
            cmake_args["LLVM_HOST_TRIPLE"] = "x86_64-apple-darwin"
    elif platform.system() == "Linux":
        if ARCH == "AArch64":
            cmake_args["LLVM_HOST_TRIPLE"] = "aarch64-linux-gnu"
            cmake_args["CMAKE_C_COMPILER"] = "aarch64-linux-gnu-gcc"
            cmake_args["CMAKE_CXX_COMPILER"] = "aarch64-linux-gnu-g++"
            cmake_args["CMAKE_CXX_FLAGS"] = "-static-libgcc -static-libstdc++"
            native_tools()
        elif ARCH == "X86":
            cmake_args["LLVM_HOST_TRIPLE"] = "x86_64-unknown-linux-gnu"

    return cmake_args


class CMakeBuild(build_ext):
    def build_extension(self, ext: CMakeExtension) -> None:
        ext_fullpath = Path.cwd() / self.get_ext_fullpath(ext.name)
        extdir = ext_fullpath.parent.resolve()
        install_dir = extdir / "mlir_air"
        cfg = "Release"

        cmake_generator = os.environ.get("CMAKE_GENERATOR", "Ninja")
        cmake_module_path = f"-DCMAKE_MODULE_PATH={Path(__file__).parent.absolute() / 'cmake' / 'modules'}"
        if platform.system() == "Windows":
            cmake_module_path = cmake_module_path.replace("\\", "\\\\")

        import mlir_aie
        import mlir

        MLIR_AIE_INSTALL_ABS_PATH = Path(mlir_aie.__path__[0]).absolute()
        MLIR_INSTALL_ABS_PATH = Path(mlir.__path__[0]).absolute()
        if platform.system() == "Windows":
            # fatal error LNK1170: line in command file contains 131071 or more characters
            shutil.move(MLIR_AIE_INSTALL_ABS_PATH, "/tmp/a")
            MLIR_AIE_INSTALL_ABS_PATH = Path("/tmp/a").absolute()
            shutil.move(MLIR_INSTALL_ABS_PATH, "/tmp/m")
            MLIR_INSTALL_ABS_PATH = Path("/tmp/m").absolute()

        BOOST_ROOT = os.environ.get("BOOST_ROOT")

        cmake_args = [
            f"-G {cmake_generator}",
            cmake_module_path,
            "-DLLVM_CCACHE_BUILD=ON",
            f"-DCMAKE_INSTALL_PREFIX={install_dir}",
            f"-DMLIR_DIR={MLIR_INSTALL_ABS_PATH / 'lib' / 'cmake' / 'mlir'}",
            f"-DAIE_DIR={MLIR_AIE_INSTALL_ABS_PATH / 'lib' / 'cmake' / 'aie'}",
            f"-DPython3_EXECUTABLE={sys.executable}",
            "-DMLIR_DETECT_PYTHON_ENV_PRIME_SEARCH=ON",
            # not used on MSVC, but no harm
            f"-DCMAKE_BUILD_TYPE={cfg}",
            # prevent symbol collision that leads to multiple pass registration and such
            "-DCMAKE_VISIBILITY_INLINES_HIDDEN=ON",
            "-DCMAKE_C_VISIBILITY_PRESET=hidden",
            "-DCMAKE_CXX_VISIBILITY_PRESET=hidden",
        ]
        if platform.system() == "Windows":
            cmake_args += [
                "-DCMAKE_C_COMPILER_LAUNCHER=ccache",
                "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
                "-DCMAKE_C_COMPILER=cl",
                "-DCMAKE_CXX_COMPILER=cl",
                "-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded",
            ]

        cmake_args_dict = get_cross_cmake_args()
        cmake_args += [f"-D{k}={v}" for k, v in cmake_args_dict.items()]

        if "CMAKE_ARGS" in os.environ:
            cmake_args += [item for item in os.environ["CMAKE_ARGS"].split(" ") if item]

        build_args = []
        if self.compiler.compiler_type != "msvc":
            if not cmake_generator or cmake_generator == "Ninja":
                try:
                    import ninja

                    ninja_executable_path = Path(ninja.BIN_DIR) / "ninja"
                    cmake_args += [
                        "-GNinja",
                        f"-DCMAKE_MAKE_PROGRAM:FILEPATH={ninja_executable_path}",
                    ]
                except ImportError:
                    pass

        else:
            single_config = any(x in cmake_generator for x in {"NMake", "Ninja"})
            contains_arch = any(x in cmake_generator for x in {"ARM", "Win64"})
            if not single_config and not contains_arch:
                PLAT_TO_CMAKE = {
                    "win32": "Win32",
                    "win-amd64": "x64",
                    "win-arm32": "ARM",
                    "win-arm64": "ARM64",
                }
                cmake_args += ["-A", PLAT_TO_CMAKE[self.plat_name]]
            if not single_config:
                cmake_args += [
                    f"-DCMAKE_LIBRARY_OUTPUT_DIRECTORY_{cfg.upper()}={extdir}"
                ]
                build_args += ["--config", cfg]

        if sys.platform.startswith("darwin"):
            cmake_args += ["-DCMAKE_OSX_DEPLOYMENT_TARGET=11.6"]
            # Cross-compile support for macOS - respect ARCHFLAGS if set
            archs = re.findall(r"-arch (\S+)", os.environ.get("ARCHFLAGS", ""))
            if archs:
                cmake_args += ["-DCMAKE_OSX_ARCHITECTURES={}".format(";".join(archs))]

        if "PARALLEL_LEVEL" not in os.environ:
            build_args += [f"-j{str(2 * os.cpu_count())}"]
        else:
            build_args += [f"-j{os.environ.get('PARALLEL_LEVEL')}"]

        build_temp = Path(self.build_temp) / ext.name
        if not build_temp.exists():
            build_temp.mkdir(parents=True)

        print("ENV", pprint(os.environ), file=sys.stderr)
        print("CMAKE_ARGS", cmake_args, file=sys.stderr)

        subprocess.run(
            ["cmake", ext.sourcedir, *cmake_args], cwd=build_temp, check=True
        )
        subprocess.run(
            ["cmake", "--build", ".", "--target", "install", *build_args],
            cwd=build_temp,
            check=True,
        )


commit_hash = None
try:
    commit_hash = (
        subprocess.check_output(shlex.split("git rev-parse --short HEAD"))
        .decode()
        .strip()
    )
except subprocess.CalledProcessError:
    pass
if not bool(commit_hash):
    commit_hash = "deadbeef"

release_version = "0.0.1"
now = datetime.now()
datetime = os.environ.get(
    "DATETIME", f"{now.year}{now.month:02}{now.day:02}{now.hour:02}"
)
version = f"{release_version}.{datetime}+{commit_hash}"

setup(
    version=version,
    author="",
    name="mlir-air",
    include_package_data=True,
    # note the name here isn't relevant because it's the install (CMake install target) directory that'll be used to
    # actually build the wheel.
    ext_modules=[CMakeExtension("_mlir_air", sourcedir="mlir-air")],
    cmdclass={"build_ext": CMakeBuild},
    zip_safe=False,
    python_requires=">=3.8",
)
