// (c) Copyright 2021 Xilinx Inc.

// RUN: air-opt %s -air-linalg-codegen='l1-tile-size=32,32,32 l2-tile-size=64,64,64' | FileCheck %s

// CHECK-LABEL: matmul_on_memref
// CHECK: scf.for %arg2 = %c0 to %c128 step %c64 {
// CHECK: scf.for %arg3 = %c0 to %c128 step %c64 {
// CHECK: scf.for %arg4 = %c0 to %c128 step %c64 {
// CHECK: memref.copy {{.*}} : memref<{{.*}}> to memref<64x64xi32, 1>
// CHECK: memref.copy {{.*}} : memref<{{.*}}> to memref<64x64xi32, 1>
// CHECK: memref.copy {{.*}} : memref<{{.*}}> to memref<64x64xi32, 1>
// CHECK: scf.parallel ({{.*}}) = (%c0, %c0) to (%c64, %c64) step (%c32, %c32) {
// CHECK: scf.for {{.*}} = %c0 to %c64 step %c32 {
// CHECK: memref.copy {{.*}} : memref<{{.*}}, 1> to memref<{{.*}}, 2>
// CHECK: memref.copy {{.*}} : memref<{{.*}}, 1> to memref<{{.*}}, 2>
// CHECK: memref.copy {{.*}} : memref<{{.*}}, 1> to memref<{{.*}}, 2>
// CHECK: memref.copy {{.*}} : memref<{{.*}}, 2> to memref<{{.*}}, 1>
// CHECK: scf.yield
// CHECK: memref.copy {{.*}} : memref<{{.*}}, 1> to memref<{{.*}}>
func @matmul_on_memref(%arg0: memref<128x128xi32>, %arg1: memref<128x128xi32>) -> memref<128x128xi32> {
    %c0_i32 = arith.constant 0 : i32
    %0 = memref.alloc() : memref<128x128xi32>
    linalg.fill ins(%c0_i32 : i32) outs(%0 : memref<128x128xi32>)
    %1 = memref.alloc() : memref<128x128xi32>
    linalg.copy ins(%0 : memref<128x128xi32>) outs(%1 : memref<128x128xi32>)
    linalg.matmul ins(%arg0, %arg1 : memref<128x128xi32>, memref<128x128xi32>) outs(%1 : memref<128x128xi32>)
    return %1 : memref<128x128xi32>
  }
