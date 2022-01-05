
proc numberOfCPUs {} {
    return 8

    # Windows puts it in an environment variable
    global tcl_platform env
    if {$tcl_platform(platform) eq "windows"} {
        return $env(NUMBER_OF_PROCESSORS)
    }

    # Check for sysctl (OSX, BSD)
    set sysctl [auto_execok "sysctl"]
    if {[llength $sysctl]} {
        if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
            return $cores
        }
    }

    # Assume Linux, which has /proc/cpuinfo, but be careful
    if {![catch {open "/proc/cpuinfo"} f]} {
        set cores [regexp -all -line {^processor\s} [read $f]]
        close $f
        if {$cores > 0} {
            return $cores
        }
    }

    # No idea what the actual number of cores is; exhausted all our options
    # Fall back to returning 1; there must be at least that because we're running on it!
    return 1
}

################################################################
# This is a generated script based on design: project_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

set_param board.repoPaths ../../boards/boards/Xilinx/vck190/es/1.4

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source project_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S-es1
   set_property BOARD_PART xilinx.com:vck190_es:part0:1.4 [current_project]
}

set_property ip_repo_paths {../../../segment-architecture/hardware/dma_subsystem} [current_project]
update_ip_catalog


# CHANGE DESIGN NAME HERE
variable design_name
set design_name project_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:versal_cips:2.0\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:ai_engine:1.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_cdma:4.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_dbg_hub:1.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:axis_ila:1.1\
xilinx.com:ip:clk_wizard:1.0\
user.org:user:dma_subsystem_ipi_wrap:1.0\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr4_dimm1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_dimm1 ]

  set ddr4_dimm1_sma_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_dimm1_sma_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $ddr4_dimm1_sma_clk

  set uart2_bank306 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart2_bank306 ]


  # Create ports

  # Create instance: CIPS_0, and set properties
  set CIPS_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.0 CIPS_0 ]
  set_property -dict [ list \
   CONFIG.CPM_PCIE0_EXT_PCIE_CFG_SPACE_ENABLED {None} \
   CONFIG.CPM_PCIE0_MODES {None} \
   CONFIG.CPM_PCIE1_EXT_PCIE_CFG_SPACE_ENABLED {None} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_DFT_OSC_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_DFT_OSC_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {36} \
   CONFIG.PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {9} \
   CONFIG.PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {949.990479} \
   CONFIG.PMC_CRP_NOC_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_NPI_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_NPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_NPLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PMC_CRP_NPLL_CTRL_FBDIV {114} \
   CONFIG.PMC_CRP_NPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PMC_CRP_NPLL_TO_XPD_CTRL_DIVISOR0 {1} \
   CONFIG.PMC_CRP_OSPI_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_OSPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_PL1_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PL2_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL2_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PL3_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL3_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PPLL_CTRL_CLKOUTDIV {2} \
   CONFIG.PMC_CRP_PPLL_CTRL_FBDIV {72} \
   CONFIG.PMC_CRP_PPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PMC_CRP_PPLL_TO_XPD_CTRL_DIVISOR0 {2} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {199.998001} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SDIO0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_SDIO0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.998001} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1199.988037} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_DIVISOR0 {1} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_TEST_PATTERN_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_TEST_PATTERN_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_GPIO0_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_GPIO1_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_HSM0_CLOCK_ENABLE {1} \
   CONFIG.PMC_HSM1_CLOCK_ENABLE {1} \
   CONFIG.PMC_MIO_0_DIRECTION {out} \
   CONFIG.PMC_MIO_0_SCHMITT {1} \
   CONFIG.PMC_MIO_10_DIRECTION {inout} \
   CONFIG.PMC_MIO_11_DIRECTION {inout} \
   CONFIG.PMC_MIO_12_DIRECTION {out} \
   CONFIG.PMC_MIO_12_SCHMITT {1} \
   CONFIG.PMC_MIO_13_DIRECTION {out} \
   CONFIG.PMC_MIO_13_SCHMITT {1} \
   CONFIG.PMC_MIO_14_DIRECTION {inout} \
   CONFIG.PMC_MIO_15_DIRECTION {inout} \
   CONFIG.PMC_MIO_16_DIRECTION {inout} \
   CONFIG.PMC_MIO_17_DIRECTION {inout} \
   CONFIG.PMC_MIO_19_DIRECTION {inout} \
   CONFIG.PMC_MIO_1_DIRECTION {inout} \
   CONFIG.PMC_MIO_20_DIRECTION {inout} \
   CONFIG.PMC_MIO_21_DIRECTION {inout} \
   CONFIG.PMC_MIO_22_DIRECTION {inout} \
   CONFIG.PMC_MIO_24_DIRECTION {out} \
   CONFIG.PMC_MIO_24_SCHMITT {1} \
   CONFIG.PMC_MIO_26_DIRECTION {inout} \
   CONFIG.PMC_MIO_27_DIRECTION {inout} \
   CONFIG.PMC_MIO_29_DIRECTION {inout} \
   CONFIG.PMC_MIO_2_DIRECTION {inout} \
   CONFIG.PMC_MIO_30_DIRECTION {inout} \
   CONFIG.PMC_MIO_31_DIRECTION {inout} \
   CONFIG.PMC_MIO_32_DIRECTION {inout} \
   CONFIG.PMC_MIO_33_DIRECTION {inout} \
   CONFIG.PMC_MIO_34_DIRECTION {inout} \
   CONFIG.PMC_MIO_35_DIRECTION {inout} \
   CONFIG.PMC_MIO_36_DIRECTION {inout} \
   CONFIG.PMC_MIO_37_DIRECTION {out} \
   CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
   CONFIG.PMC_MIO_37_PULL {pullup} \
   CONFIG.PMC_MIO_37_USAGE {GPIO} \
   CONFIG.PMC_MIO_3_DIRECTION {inout} \
   CONFIG.PMC_MIO_40_DIRECTION {out} \
   CONFIG.PMC_MIO_40_SCHMITT {1} \
   CONFIG.PMC_MIO_43_DIRECTION {out} \
   CONFIG.PMC_MIO_43_SCHMITT {1} \
   CONFIG.PMC_MIO_44_DIRECTION {inout} \
   CONFIG.PMC_MIO_45_DIRECTION {inout} \
   CONFIG.PMC_MIO_46_DIRECTION {inout} \
   CONFIG.PMC_MIO_47_DIRECTION {inout} \
   CONFIG.PMC_MIO_48_DIRECTION {out} \
   CONFIG.PMC_MIO_48_PULL {pullup} \
   CONFIG.PMC_MIO_48_USAGE {GPIO} \
   CONFIG.PMC_MIO_49_DIRECTION {out} \
   CONFIG.PMC_MIO_49_PULL {pullup} \
   CONFIG.PMC_MIO_49_USAGE {GPIO} \
   CONFIG.PMC_MIO_4_DIRECTION {inout} \
   CONFIG.PMC_MIO_51_DIRECTION {out} \
   CONFIG.PMC_MIO_51_SCHMITT {1} \
   CONFIG.PMC_MIO_5_DIRECTION {out} \
   CONFIG.PMC_MIO_5_SCHMITT {1} \
   CONFIG.PMC_MIO_6_DIRECTION {out} \
   CONFIG.PMC_MIO_6_SCHMITT {1} \
   CONFIG.PMC_MIO_7_DIRECTION {out} \
   CONFIG.PMC_MIO_7_SCHMITT {1} \
   CONFIG.PMC_MIO_8_DIRECTION {inout} \
   CONFIG.PMC_MIO_9_DIRECTION {inout} \
   CONFIG.PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#GPIO 1###CAN 1#CAN 1#UART 0#UART 0#I2C 1#I2C 1#I2C 0#I2C 0#GPIO 1#GPIO 1##SD1/eMMC1#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 0#Enet 0} \
   CONFIG.PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#gpio_1_pin[37]###phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda#gpio_1_pin[48]#gpio_1_pin[49]##buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio} \
   CONFIG.PMC_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
   CONFIG.PMC_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
   CONFIG.PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PMC_SD1_GRP_CD_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_CD_IO {PMC_MIO 28} \
   CONFIG.PMC_SD1_GRP_POW_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_POW_IO {PMC_MIO 51} \
   CONFIG.PMC_SD1_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 26 .. 36} \
   CONFIG.PMC_SD1_SLOT_TYPE {SD 3.0} \
   CONFIG.PMC_SD1_SPEED_MODE {high speed} \
   CONFIG.PMC_USE_NOC_PMC_AXI0 {0} \
   CONFIG.PMC_USE_PMC_NOC_AXI0 {1} \
   CONFIG.PSPMC_MANUAL_CLOCK_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_IO {PMC_MIO 40 .. 41} \
   CONFIG.PS_CRF_ACPU_CTRL_ACT_FREQMHZ {999.989990} \
   CONFIG.PS_CRF_ACPU_CTRL_DIVISOR0 {1} \
   CONFIG.PS_CRF_ACPU_CTRL_SRCSEL {APLL} \
   CONFIG.PS_CRF_APLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PS_CRF_APLL_CTRL_FBDIV {120} \
   CONFIG.PS_CRF_APLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PS_CRF_APLL_TO_XPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_DBG_TRACE_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRF_DBG_TRACE_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {499.994995} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_SRCSEL {APLL} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {149.998505} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_FREQMHZ {150} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {474.995239} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {374.996246} \
   CONFIG.PS_CRL_CPU_R5_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_CPU_R5_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.998749} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {124.998749} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.997498} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_IOU_SWITCH_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_IOU_SWITCH_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {374.996246} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_PSM_REF_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_PSM_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_RPLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PS_CRL_RPLL_CTRL_FBDIV {90} \
   CONFIG.PS_CRL_RPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PS_CRL_RPLL_TO_XPD_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_UART0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_UART0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_UART1_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PS_CRL_UART1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999800} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {30} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_FREQMHZ {60} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_USB3_DUAL_REF_CTRL_ACT_FREQMHZ {9.999900} \
   CONFIG.PS_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PS_ENET0_GRP_MDIO_IO {PS_MIO 24 .. 25} \
   CONFIG.PS_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET0_PERIPHERAL_IO {PS_MIO 0 .. 11} \
   CONFIG.PS_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET1_PERIPHERAL_IO {PS_MIO 12 .. 23} \
   CONFIG.PS_GEM0_ROUTE_THROUGH_FPD {1} \
   CONFIG.PS_GEM1_ROUTE_THROUGH_FPD {1} \
   CONFIG.PS_GEN_IPI_0_ENABLE {1} \
   CONFIG.PS_GEN_IPI_0_MASTER {A72} \
   CONFIG.PS_GEN_IPI_1_ENABLE {1} \
   CONFIG.PS_GEN_IPI_1_MASTER {R5_0} \
   CONFIG.PS_GEN_IPI_2_ENABLE {1} \
   CONFIG.PS_GEN_IPI_2_MASTER {R5_1} \
   CONFIG.PS_GEN_IPI_3_ENABLE {1} \
   CONFIG.PS_GEN_IPI_3_MASTER {A72} \
   CONFIG.PS_GEN_IPI_4_ENABLE {1} \
   CONFIG.PS_GEN_IPI_4_MASTER {A72} \
   CONFIG.PS_GEN_IPI_5_ENABLE {1} \
   CONFIG.PS_GEN_IPI_5_MASTER {A72} \
   CONFIG.PS_GEN_IPI_6_ENABLE {1} \
   CONFIG.PS_GEN_IPI_6_MASTER {A72} \
   CONFIG.PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
   CONFIG.PS_GEN_IPI_PMC_ENABLE {1} \
   CONFIG.PS_GEN_IPI_PSM_ENABLE {1} \
   CONFIG.PS_GPIO2_MIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_GPIO_EMIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_GPIO_EMIO_WIDTH {2} \
   CONFIG.PS_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C0_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
   CONFIG.PS_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C1_PERIPHERAL_IO {PMC_MIO 44 .. 45} \
   CONFIG.PS_MIO_0_DIRECTION {out} \
   CONFIG.PS_MIO_0_SCHMITT {1} \
   CONFIG.PS_MIO_12_DIRECTION {out} \
   CONFIG.PS_MIO_12_SCHMITT {1} \
   CONFIG.PS_MIO_13_DIRECTION {out} \
   CONFIG.PS_MIO_13_SCHMITT {1} \
   CONFIG.PS_MIO_14_DIRECTION {out} \
   CONFIG.PS_MIO_14_SCHMITT {1} \
   CONFIG.PS_MIO_15_DIRECTION {out} \
   CONFIG.PS_MIO_15_SCHMITT {1} \
   CONFIG.PS_MIO_16_DIRECTION {out} \
   CONFIG.PS_MIO_16_SCHMITT {1} \
   CONFIG.PS_MIO_17_DIRECTION {out} \
   CONFIG.PS_MIO_17_SCHMITT {1} \
   CONFIG.PS_MIO_1_DIRECTION {out} \
   CONFIG.PS_MIO_1_SCHMITT {1} \
   CONFIG.PS_MIO_24_DIRECTION {out} \
   CONFIG.PS_MIO_24_SCHMITT {1} \
   CONFIG.PS_MIO_25_DIRECTION {inout} \
   CONFIG.PS_MIO_2_DIRECTION {out} \
   CONFIG.PS_MIO_2_SCHMITT {1} \
   CONFIG.PS_MIO_3_DIRECTION {out} \
   CONFIG.PS_MIO_3_SCHMITT {1} \
   CONFIG.PS_MIO_4_DIRECTION {out} \
   CONFIG.PS_MIO_4_SCHMITT {1} \
   CONFIG.PS_MIO_5_DIRECTION {out} \
   CONFIG.PS_MIO_5_SCHMITT {1} \
   CONFIG.PS_M_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_M_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_NUM_FABRIC_RESETS {1} \
   CONFIG.PS_S_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_S_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC0_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC1_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC1_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC2_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC2_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC2_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC3_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC3_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_UART0_BAUD_RATE {115200} \
   CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
   CONFIG.PS_USB3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_USE_BSCAN1 {1} \
   CONFIG.PS_USE_IRQ_0 {1} \
   CONFIG.PS_USE_IRQ_1 {0} \
   CONFIG.PS_USE_IRQ_2 {0} \
   CONFIG.PS_USE_IRQ_3 {0} \
   CONFIG.PS_USE_IRQ_4 {0} \
   CONFIG.PS_USE_IRQ_5 {0} \
   CONFIG.PS_USE_IRQ_6 {0} \
   CONFIG.PS_USE_IRQ_7 {0} \
   CONFIG.PS_USE_IRQ_8 {0} \
   CONFIG.PS_USE_M_AXI_GP0 {1} \
   CONFIG.PS_USE_M_AXI_GP2 {0} \
   CONFIG.PS_USE_NOC_PS_CCI_0 {0} \
   CONFIG.PS_USE_PMCPL_CLK0 {1} \
   CONFIG.PS_USE_PS_NOC_CCI {1} \
   CONFIG.PS_USE_PS_NOC_NCI_0 {1} \
   CONFIG.PS_USE_PS_NOC_NCI_1 {1} \
   CONFIG.PS_USE_PS_NOC_RPU_0 {1} \
   CONFIG.PS_USE_S_AXI_GP0 {0} \
   CONFIG.PS_USE_S_AXI_GP2 {0} \
   CONFIG.PS_WDT0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_WDT0_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_WDT0_REF_CTRL_SEL {APB} \
   CONFIG.PS_WWDT0_CLOCK_IO {APB} \
   CONFIG.PS_WWDT0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_WWDT0_PERIPHERAL_IO {EMIO} \
 ] $CIPS_0

  # Create instance: NOC_0, and set properties
  set NOC_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 NOC_0 ]
  set_property -dict [ list \
   CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} \
   CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC_BA_WIDTH {2} \
   CONFIG.MC_BG_WIDTH {2} \
   CONFIG.MC_CHAN_REGION0 {DDR_LOW0} \
   CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
   CONFIG.MC_COMPONENT_WIDTH {x8} \
   CONFIG.MC_CONFIG_NUM {config17} \
   CONFIG.MC_DATAWIDTH {64} \
   CONFIG.MC_DDR4_2T {Disable} \
   CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
   CONFIG.MC_F1_TRCD {13750} \
   CONFIG.MC_F1_TRCDMIN {13750} \
   CONFIG.MC_INPUTCLK0_PERIOD {5000} \
   CONFIG.MC_INPUT_FREQUENCY0 {200.000} \
   CONFIG.MC_INTERLEAVE_SIZE {128} \
   CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} \
   CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {625} \
   CONFIG.MC_NO_CHANNELS {Single} \
   CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_COLUMN_BANK} \
   CONFIG.MC_RANK {1} \
   CONFIG.MC_ROWADDRESSWIDTH {16} \
   CONFIG.MC_TRC {45750} \
   CONFIG.MC_TRCD {13750} \
   CONFIG.MC_TRCDMIN {13750} \
   CONFIG.MC_TRCMIN {45750} \
   CONFIG.MC_TRP {13750} \
   CONFIG.MC_TRPMIN {13750} \
   CONFIG.NUM_CLKS {27} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {5} \
   CONFIG.NUM_NMI {0} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {26} \
   CONFIG.sys_clk0_BOARD_INTERFACE {ddr4_dimm1_sma_clk} \
 ] $NOC_0

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {768} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/M01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.APERTURES {{0x202_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/M02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.APERTURES {{0x201_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/M03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/M04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /NOC_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /NOC_0/S00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /NOC_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /NOC_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /NOC_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /NOC_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /NOC_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /NOC_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /NOC_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M04_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M04_AXI:0x100:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S13_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S14_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S15_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S16_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S17_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S18_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S19_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S20_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S21_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S22_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S23_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x80:M02_AXI:0x0} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /NOC_0/S24_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0x140:M01_AXI:0x80:M02_AXI:0x0:M00_AXI:0x300} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /NOC_0/S25_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M03_AXI:M04_AXI:S08_AXI:S25_AXI} \
 ] [get_bd_pins /NOC_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /NOC_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /NOC_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /NOC_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /NOC_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /NOC_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /NOC_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /NOC_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /NOC_0/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /NOC_0/aclk9]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S09_AXI} \
 ] [get_bd_pins /NOC_0/aclk10]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S10_AXI} \
 ] [get_bd_pins /NOC_0/aclk11]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S11_AXI} \
 ] [get_bd_pins /NOC_0/aclk12]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S12_AXI} \
 ] [get_bd_pins /NOC_0/aclk13]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S13_AXI} \
 ] [get_bd_pins /NOC_0/aclk14]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S14_AXI} \
 ] [get_bd_pins /NOC_0/aclk15]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S15_AXI} \
 ] [get_bd_pins /NOC_0/aclk16]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S16_AXI} \
 ] [get_bd_pins /NOC_0/aclk17]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S17_AXI} \
 ] [get_bd_pins /NOC_0/aclk18]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S18_AXI} \
 ] [get_bd_pins /NOC_0/aclk19]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S19_AXI} \
 ] [get_bd_pins /NOC_0/aclk20]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S20_AXI} \
 ] [get_bd_pins /NOC_0/aclk21]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S21_AXI} \
 ] [get_bd_pins /NOC_0/aclk22]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S22_AXI} \
 ] [get_bd_pins /NOC_0/aclk23]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S23_AXI} \
 ] [get_bd_pins /NOC_0/aclk24]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S24_AXI} \
 ] [get_bd_pins /NOC_0/aclk25]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M01_AXI:M02_AXI} \
 ] [get_bd_pins /NOC_0/aclk26]

  # Create instance: ai_engine_0, and set properties
  set ai_engine_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ai_engine:1.0 ai_engine_0 ]
  set_property -dict [ list \
   CONFIG.CLK_NAMES {aclk0,aclk1,} \
   CONFIG.FIFO_TYPE_MI_AXIS {M00_AXIS{FIFO_TYPE 0}:M01_AXIS{FIFO_TYPE 0}:M02_AXIS{FIFO_TYPE 0}:M03_AXIS{FIFO_TYPE 0}:M04_AXIS{FIFO_TYPE 0}:M05_AXIS{FIFO_TYPE 0}:M06_AXIS{FIFO_TYPE 0}:M07_AXIS{FIFO_TYPE 0}:M08_AXIS{FIFO_TYPE 0}:M09_AXIS{FIFO_TYPE 0}:M10_AXIS{FIFO_TYPE 0}:M11_AXIS{FIFO_TYPE 0}} \
   CONFIG.FIFO_TYPE_SI_AXIS {S00_AXIS{FIFO_TYPE 0}:S01_AXIS{FIFO_TYPE 0}:S02_AXIS{FIFO_TYPE 0}:S03_AXIS{FIFO_TYPE 0}:S04_AXIS{FIFO_TYPE 0}:S05_AXIS{FIFO_TYPE 0}:S06_AXIS{FIFO_TYPE 0}:S07_AXIS{FIFO_TYPE 0}:S08_AXIS{FIFO_TYPE 0}:S09_AXIS{FIFO_TYPE 0}:S10_AXIS{FIFO_TYPE 0}:S11_AXIS{FIFO_TYPE 0}:S12_AXIS{FIFO_TYPE 0}:S13_AXIS{FIFO_TYPE 0}:S14_AXIS{FIFO_TYPE 0}:S15_AXIS{FIFO_TYPE 0}:S16_AXIS{FIFO_TYPE 0}:S17_AXIS{FIFO_TYPE 0}:S18_AXIS{FIFO_TYPE 0}:S19_AXIS{FIFO_TYPE 0}} \
   CONFIG.MI_DESTID_PINS {No,No,No,No,No,No,No,No} \
   CONFIG.NAME_MI_AXI {} \
   CONFIG.NAME_MI_AXIS {M00_AXIS,M01_AXIS,M02_AXIS,M03_AXIS,M04_AXIS,M05_AXIS,M06_AXIS,M07_AXIS,M08_AXIS,M09_AXIS,M10_AXIS,M11_AXIS,} \
   CONFIG.NAME_SI_AXI {S00_AXI,} \
   CONFIG.NAME_SI_AXIS {S00_AXIS,S01_AXIS,S02_AXIS,S03_AXIS,S04_AXIS,S05_AXIS,S06_AXIS,S07_AXIS,S08_AXIS,S09_AXIS,S10_AXIS,S11_AXIS,S12_AXIS,S13_AXIS,S14_AXIS,S15_AXIS,S16_AXIS,S17_AXIS,S18_AXIS,S19_AXIS,} \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI_AXI {16} \
   CONFIG.NUM_MI_AXIS {12} \
   CONFIG.NUM_SI_AXI {1} \
   CONFIG.NUM_SI_AXIS {20} \
 ] $ai_engine_0

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M00_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M01_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M01_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M02_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M02_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M03_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M03_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M04_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M04_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M05_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M05_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M06_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M06_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M07_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M07_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M08_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M08_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M09_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M09_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M10_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M10_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M11_AXI]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/M11_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M12_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M13_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M14_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/M15_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
   CONFIG.IS_REGISTERED {false} \
 ] [get_bd_intf_pins /ai_engine_0/S00_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
   CONFIG.IS_REGISTERED {false} \
 ] [get_bd_intf_pins /ai_engine_0/S01_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
   CONFIG.IS_REGISTERED {false} \
 ] [get_bd_intf_pins /ai_engine_0/S02_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
   CONFIG.IS_REGISTERED {false} \
 ] [get_bd_intf_pins /ai_engine_0/S03_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S04_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S05_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S06_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S07_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S08_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S09_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S10_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S11_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S12_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S13_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S14_AXIS]

  set_property -dict [ list \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S15_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S16_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S17_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S18_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.CATEGORY {PL} \
 ] [get_bd_intf_pins /ai_engine_0/S19_AXIS]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /ai_engine_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXIS:M01_AXIS:M02_AXIS:M03_AXIS:M04_AXIS:M05_AXIS:M06_AXIS:M07_AXIS:M08_AXIS:M09_AXIS:M10_AXIS:M11_AXIS:S00_AXIS:S01_AXIS:S02_AXIS:S03_AXIS:S04_AXIS:S05_AXIS:S06_AXIS:S07_AXIS:S08_AXIS:S09_AXIS:S10_AXIS:S11_AXIS:S12_AXIS:S13_AXIS:S14_AXIS:S15_AXIS:S16_AXIS:S17_AXIS:S18_AXIS:S19_AXIS} \
 ] [get_bd_pins /ai_engine_0/aclk1]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {64} \
   CONFIG.C_INCLUDE_SG {0} \
 ] $axi_cdma_0

  # Create instance: axi_cdma_0_smc, and set properties
  set axi_cdma_0_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_cdma_0_smc ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_cdma_0_smc

  # Create instance: axi_dbg_hub_0, and set properties
  set axi_dbg_hub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:1.0 axi_dbg_hub_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_DEBUG_CORES {0} \
 ] $axi_dbg_hub_0

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [ list \
   CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
   CONFIG.C_IRQ_CONNECTION {1} \
 ] $axi_intc_0

  # Create instance: axi_noc_kernel0, and set properties
  set axi_noc_kernel0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_kernel0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {0} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_SI {0} \
 ] $axi_noc_kernel0

  set_property -dict [ list \
   CONFIG.APERTURES {{0x201_4000_0000 1G}} \
 ] [get_bd_intf_pins /axi_noc_kernel0/M00_INI]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
   CONFIG.UARTLITE_BOARD_INTERFACE {uart2_bank306} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_uartlite_0

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_0

  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_1

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_2 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_2

  # Create instance: axis_data_fifo_3, and set properties
  set axis_data_fifo_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_3 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_3

  # Create instance: axis_data_fifo_4, and set properties
  set axis_data_fifo_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_4 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_4

  # Create instance: axis_data_fifo_5, and set properties
  set axis_data_fifo_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_5 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_5

  # Create instance: axis_data_fifo_6, and set properties
  set axis_data_fifo_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_6 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_6

  # Create instance: axis_data_fifo_7, and set properties
  set axis_data_fifo_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_7 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_7

  # Create instance: axis_data_fifo_8, and set properties
  set axis_data_fifo_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_8 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_8

  # Create instance: axis_data_fifo_9, and set properties
  set axis_data_fifo_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_9 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_9

  # Create instance: axis_data_fifo_10, and set properties
  set axis_data_fifo_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_10 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_10

  # Create instance: axis_data_fifo_11, and set properties
  set axis_data_fifo_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_11 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_11

  # Create instance: axis_data_fifo_12, and set properties
  set axis_data_fifo_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_12 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_12

  # Create instance: axis_data_fifo_13, and set properties
  set axis_data_fifo_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_13 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_13

  # Create instance: axis_data_fifo_14, and set properties
  set axis_data_fifo_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_14 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_14

  # Create instance: axis_data_fifo_15, and set properties
  set axis_data_fifo_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_15 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_15

  # Create instance: axis_data_fifo_16, and set properties
  set axis_data_fifo_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_16 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_16

  # Create instance: axis_data_fifo_17, and set properties
  set axis_data_fifo_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_17 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_17

  # Create instance: axis_data_fifo_18, and set properties
  set axis_data_fifo_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_18 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_18

  # Create instance: axis_data_fifo_19, and set properties
  set axis_data_fifo_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_19 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_19

  # Create instance: axis_data_fifo_20, and set properties
  set axis_data_fifo_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_20 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_20

  # Create instance: axis_data_fifo_21, and set properties
  set axis_data_fifo_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_21 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_21

  # Create instance: axis_data_fifo_22, and set properties
  set axis_data_fifo_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_22 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_22

  # Create instance: axis_data_fifo_23, and set properties
  set axis_data_fifo_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_23 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_23

  # Create instance: axis_data_fifo_24, and set properties
  set axis_data_fifo_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_24 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_24

  # Create instance: axis_data_fifo_25, and set properties
  set axis_data_fifo_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_25 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_25

  # Create instance: axis_data_fifo_26, and set properties
  set axis_data_fifo_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_26 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_26

  # Create instance: axis_data_fifo_27, and set properties
  set axis_data_fifo_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_27 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_27

  # Create instance: axis_data_fifo_28, and set properties
  set axis_data_fifo_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_28 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_28

  # Create instance: axis_data_fifo_29, and set properties
  set axis_data_fifo_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_29 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_29

  # Create instance: axis_data_fifo_30, and set properties
  set axis_data_fifo_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_30 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_30

  # Create instance: axis_data_fifo_31, and set properties
  set axis_data_fifo_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_31 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.IS_ACLK_ASYNC {1} \
 ] $axis_data_fifo_31

  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_0

  # Create instance: axis_dwidth_converter_1, and set properties
  set axis_dwidth_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_1

  # Create instance: axis_dwidth_converter_2, and set properties
  set axis_dwidth_converter_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_2 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_2

  # Create instance: axis_dwidth_converter_3, and set properties
  set axis_dwidth_converter_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_3 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_3

  # Create instance: axis_dwidth_converter_4, and set properties
  set axis_dwidth_converter_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_4 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_4

  # Create instance: axis_dwidth_converter_5, and set properties
  set axis_dwidth_converter_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_5 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_5

  # Create instance: axis_dwidth_converter_6, and set properties
  set axis_dwidth_converter_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_6 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_6

  # Create instance: axis_dwidth_converter_7, and set properties
  set axis_dwidth_converter_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_7 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_7

  # Create instance: axis_dwidth_converter_8, and set properties
  set axis_dwidth_converter_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_8 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_8

  # Create instance: axis_dwidth_converter_9, and set properties
  set axis_dwidth_converter_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_9 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_9

  # Create instance: axis_dwidth_converter_10, and set properties
  set axis_dwidth_converter_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_10 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_10

  # Create instance: axis_dwidth_converter_11, and set properties
  set axis_dwidth_converter_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_11 ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {8} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_converter_11

  # Create instance: axis_ila_0, and set properties
  set axis_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.1 axis_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {Interface_Monitor} \
   CONFIG.C_NUM_MONITOR_SLOTS {10} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_0_APC_EN {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_10_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_APC_EN {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_APC_EN {0} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_6_APC_EN {0} \
   CONFIG.C_SLOT_6_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_6_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_6_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_6_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_6_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_6_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_6_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_6_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_6_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_6_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_7_APC_EN {0} \
   CONFIG.C_SLOT_7_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_8_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_9_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $axis_ila_0

  # Create instance: axis_ila_1, and set properties
  set axis_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.1 axis_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {Interface_Monitor} \
   CONFIG.C_NUM_MONITOR_SLOTS {11} \
   CONFIG.C_SLOT {10} \
   CONFIG.C_SLOT_0_APC_EN {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_10_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_2_APC_EN {0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_APC_EN {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_4_APC_EN {0} \
   CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_5_APC_EN {0} \
   CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_6_APC_EN {0} \
   CONFIG.C_SLOT_6_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_7_APC_EN {0} \
   CONFIG.C_SLOT_7_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_8_APC_EN {0} \
   CONFIG.C_SLOT_8_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_9_APC_EN {0} \
   CONFIG.C_SLOT_9_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_9_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_9_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_9_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_9_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_9_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_9_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_9_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_9_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_9_AXI_W_SEL_TRIG {1} \
 ] $axis_ila_1

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_DIVIDE {20.000000} \
   CONFIG.CLKOUT3_DIVIDE {10.000000} \
   CONFIG.CLKOUT4_DIVIDE {15.000000} \
   CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
   CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
   CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
   CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
   CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
   CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
   CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {100.000,150,300,200,100.000,100.000,100.000} \
   CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
   CONFIG.CLKOUT_USED {true,true,true,true,false,false,false} \
   CONFIG.JITTER_SEL {Min_O_Jitter} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wizard_0

  # Create instance: dma_subsystem_ipi_wr_0, and set properties
  set dma_subsystem_ipi_wr_0 [ create_bd_cell -type ip -vlnv user.org:user:dma_subsystem_ipi_wrap:1.0 dma_subsystem_ipi_wr_0 ]

  # Create instance: emb_mem_gen_0, and set properties
  set emb_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 emb_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
 ] $emb_mem_gen_0

  # Create instance: emb_mem_gen_1, and set properties
  set emb_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 emb_mem_gen_1 ]
  set_property -dict [ list \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
 ] $emb_mem_gen_1

  # Create instance: emb_mem_gen_2, and set properties
  set emb_mem_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 emb_mem_gen_2 ]
  set_property -dict [ list \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
 ] $emb_mem_gen_2

  # Create instance: lmb_bram_if_cntlr_0, and set properties
  set lmb_bram_if_cntlr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_0 ]

  # Create instance: lmb_bram_if_cntlr_1, and set properties
  set lmb_bram_if_cntlr_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_1 ]

  # Create instance: lmb_bram_if_cntlr_2, and set properties
  set lmb_bram_if_cntlr_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_2 ]

  # Create instance: lmb_bram_if_cntlr_3, and set properties
  set lmb_bram_if_cntlr_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr_3 ]

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {64} \
   CONFIG.C_MB_DBG_PORTS {2} \
   CONFIG.C_M_AXI_ADDR_WIDTH {64} \
 ] $mdm_0

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {64} \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_BASE_VECTORS {0x0000000040000000} \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DATA_SIZE {64} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_HIGHADDR {0x000000003FFFFFFF} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ENABLE_DISCRETE_PORTS {1} \
   CONFIG.C_FSL_LINKS {8} \
   CONFIG.C_ICACHE_HIGHADDR {0x000000003FFFFFFF} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_MMU_PRIVILEGED_INSTR {0} \
   CONFIG.C_PVR {2} \
   CONFIG.C_PVR_USER1 {0x02} \
   CONFIG.C_PVR_USER2 {0x01000100} \
   CONFIG.C_USE_BARREL {1} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_ICACHE {0} \
 ] $microblaze_0

  # Create instance: microblaze_1, and set properties
  set microblaze_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {64} \
   CONFIG.C_ADDR_TAG_BITS {0} \
   CONFIG.C_BASE_VECTORS {0x0000000040000000} \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DATA_SIZE {64} \
   CONFIG.C_DCACHE_ADDR_TAG {0} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_HIGHADDR {0x000000003FFFFFFF} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ENABLE_DISCRETE_PORTS {1} \
   CONFIG.C_FSL_LINKS {4} \
   CONFIG.C_ICACHE_HIGHADDR {0x000000003FFFFFFF} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_MMU_PRIVILEGED_INSTR {0} \
   CONFIG.C_PVR {2} \
   CONFIG.C_PVR_USER1 {0x02} \
   CONFIG.C_PVR_USER2 {0x01000101} \
   CONFIG.C_USE_BARREL {1} \
   CONFIG.C_USE_DCACHE {0} \
   CONFIG.C_USE_ICACHE {0} \
 ] $microblaze_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {01} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net CIPS_0_BSCAN_USER2 [get_bd_intf_pins CIPS_0/BSCAN_USER2] [get_bd_intf_pins mdm_0/BSCAN]
  connect_bd_intf_net -intf_net CIPS_0_IF_PMC_NOC_AXI_0 [get_bd_intf_pins CIPS_0/PMC_NOC_AXI_0] [get_bd_intf_pins NOC_0/S07_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_0 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_0] [get_bd_intf_pins NOC_0/S00_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_1 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_1] [get_bd_intf_pins NOC_0/S01_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_2 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_2] [get_bd_intf_pins NOC_0/S02_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_3 [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_3] [get_bd_intf_pins NOC_0/S03_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_NCI_0 [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_0] [get_bd_intf_pins NOC_0/S04_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_NCI_1 [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_1] [get_bd_intf_pins NOC_0/S05_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_RPU_0 [get_bd_intf_pins CIPS_0/NOC_LPD_AXI_0] [get_bd_intf_pins NOC_0/S06_AXI]
  connect_bd_intf_net -intf_net CIPS_0_M_AXI_GP0 [get_bd_intf_pins CIPS_0/M_AXI_FPD] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net NOC_0_CH0_DDR4_0 [get_bd_intf_ports ddr4_dimm1] [get_bd_intf_pins NOC_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net NOC_0_M00_AXI [get_bd_intf_pins NOC_0/M00_AXI] [get_bd_intf_pins ai_engine_0/S00_AXI]
  connect_bd_intf_net -intf_net NOC_0_M01_AXI [get_bd_intf_pins NOC_0/M01_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net NOC_0_M02_AXI [get_bd_intf_pins NOC_0/M02_AXI] [get_bd_intf_pins dma_subsystem_ipi_wr_0/s_axi]
connect_bd_intf_net -intf_net [get_bd_intf_nets NOC_0_M02_AXI] [get_bd_intf_pins NOC_0/M02_AXI] [get_bd_intf_pins axis_ila_0/SLOT_6_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets NOC_0_M02_AXI]
  connect_bd_intf_net -intf_net NOC_0_M03_AXI [get_bd_intf_pins NOC_0/M03_AXI] [get_bd_intf_pins axi_dbg_hub_0/S_AXI]
  connect_bd_intf_net -intf_net NOC_0_M04_AXI [get_bd_intf_pins NOC_0/M04_AXI] [get_bd_intf_pins axi_cdma_0_smc/S00_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M00_AXI [get_bd_intf_pins NOC_0/S09_AXI] [get_bd_intf_pins ai_engine_0/M00_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M00_AXIS [get_bd_intf_pins ai_engine_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_8/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M01_AXI [get_bd_intf_pins NOC_0/S10_AXI] [get_bd_intf_pins ai_engine_0/M01_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M01_AXIS [get_bd_intf_pins ai_engine_0/M01_AXIS] [get_bd_intf_pins axis_data_fifo_9/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M02_AXI [get_bd_intf_pins NOC_0/S11_AXI] [get_bd_intf_pins ai_engine_0/M02_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M02_AXIS [get_bd_intf_pins ai_engine_0/M02_AXIS] [get_bd_intf_pins axis_data_fifo_10/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M03_AXI [get_bd_intf_pins NOC_0/S12_AXI] [get_bd_intf_pins ai_engine_0/M03_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M03_AXIS [get_bd_intf_pins ai_engine_0/M03_AXIS] [get_bd_intf_pins axis_data_fifo_11/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M04_AXI [get_bd_intf_pins NOC_0/S13_AXI] [get_bd_intf_pins ai_engine_0/M04_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M04_AXIS [get_bd_intf_pins ai_engine_0/M04_AXIS] [get_bd_intf_pins axis_data_fifo_12/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M05_AXI [get_bd_intf_pins NOC_0/S14_AXI] [get_bd_intf_pins ai_engine_0/M05_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M05_AXIS [get_bd_intf_pins ai_engine_0/M05_AXIS] [get_bd_intf_pins axis_data_fifo_13/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M06_AXI [get_bd_intf_pins NOC_0/S15_AXI] [get_bd_intf_pins ai_engine_0/M06_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M06_AXIS [get_bd_intf_pins ai_engine_0/M06_AXIS] [get_bd_intf_pins axis_data_fifo_14/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M07_AXI [get_bd_intf_pins NOC_0/S16_AXI] [get_bd_intf_pins ai_engine_0/M07_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M07_AXIS [get_bd_intf_pins ai_engine_0/M07_AXIS] [get_bd_intf_pins axis_data_fifo_15/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M08_AXI [get_bd_intf_pins NOC_0/S17_AXI] [get_bd_intf_pins ai_engine_0/M08_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M08_AXIS [get_bd_intf_pins ai_engine_0/M08_AXIS] [get_bd_intf_pins axis_dwidth_converter_9/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets ai_engine_0_M08_AXIS] [get_bd_intf_pins ai_engine_0/M08_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_8_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets ai_engine_0_M08_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M09_AXI [get_bd_intf_pins NOC_0/S18_AXI] [get_bd_intf_pins ai_engine_0/M09_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M09_AXIS [get_bd_intf_pins ai_engine_0/M09_AXIS] [get_bd_intf_pins axis_dwidth_converter_8/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M10_AXI [get_bd_intf_pins NOC_0/S19_AXI] [get_bd_intf_pins ai_engine_0/M10_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M10_AXIS [get_bd_intf_pins ai_engine_0/M10_AXIS] [get_bd_intf_pins axis_dwidth_converter_10/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M11_AXI [get_bd_intf_pins NOC_0/S20_AXI] [get_bd_intf_pins ai_engine_0/M11_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M11_AXIS [get_bd_intf_pins ai_engine_0/M11_AXIS] [get_bd_intf_pins axis_dwidth_converter_11/S_AXIS]
  connect_bd_intf_net -intf_net ai_engine_0_M12_AXI [get_bd_intf_pins NOC_0/S21_AXI] [get_bd_intf_pins ai_engine_0/M12_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M13_AXI [get_bd_intf_pins NOC_0/S22_AXI] [get_bd_intf_pins ai_engine_0/M13_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M14_AXI [get_bd_intf_pins NOC_0/S23_AXI] [get_bd_intf_pins ai_engine_0/M14_AXI]
  connect_bd_intf_net -intf_net ai_engine_0_M15_AXI [get_bd_intf_pins NOC_0/S24_AXI] [get_bd_intf_pins ai_engine_0/M15_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins NOC_0/S25_AXI] [get_bd_intf_pins axi_cdma_0/M_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_smc_M00_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins axi_cdma_0_smc/M00_AXI]
  connect_bd_intf_net -intf_net axi_noc_kernel0_M00_INI [get_bd_intf_pins NOC_0/S00_INI] [get_bd_intf_pins axi_noc_kernel0/M00_INI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart2_bank306] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins ai_engine_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_10_M_AXIS [get_bd_intf_pins axis_data_fifo_10/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_out_c]
  connect_bd_intf_net -intf_net axis_data_fifo_11_M_AXIS [get_bd_intf_pins axis_data_fifo_11/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_out_d]
  connect_bd_intf_net -intf_net axis_data_fifo_12_M_AXIS [get_bd_intf_pins axis_data_fifo_12/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_out_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_data_fifo_12_M_AXIS] [get_bd_intf_pins axis_data_fifo_12/M_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_1_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_data_fifo_12_M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_13_M_AXIS [get_bd_intf_pins axis_data_fifo_13/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_out_b]
  connect_bd_intf_net -intf_net axis_data_fifo_14_M_AXIS [get_bd_intf_pins axis_data_fifo_14/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_out_d]
  connect_bd_intf_net -intf_net axis_data_fifo_15_M_AXIS [get_bd_intf_pins axis_data_fifo_15/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_out_c]
  connect_bd_intf_net -intf_net axis_data_fifo_16_M_AXIS [get_bd_intf_pins ai_engine_0/S08_AXIS] [get_bd_intf_pins axis_data_fifo_16/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_17_M_AXIS [get_bd_intf_pins ai_engine_0/S09_AXIS] [get_bd_intf_pins axis_data_fifo_17/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_18_M_AXIS [get_bd_intf_pins ai_engine_0/S10_AXIS] [get_bd_intf_pins axis_data_fifo_18/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_19_M_AXIS [get_bd_intf_pins ai_engine_0/S11_AXIS] [get_bd_intf_pins axis_data_fifo_19/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins ai_engine_0/S01_AXIS] [get_bd_intf_pins axis_data_fifo_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_20_M_AXIS [get_bd_intf_pins ai_engine_0/S12_AXIS] [get_bd_intf_pins axis_data_fifo_20/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_21_M_AXIS [get_bd_intf_pins ai_engine_0/S13_AXIS] [get_bd_intf_pins axis_data_fifo_21/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_22_M_AXIS [get_bd_intf_pins ai_engine_0/S14_AXIS] [get_bd_intf_pins axis_data_fifo_22/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_23_M_AXIS [get_bd_intf_pins ai_engine_0/S15_AXIS] [get_bd_intf_pins axis_data_fifo_23/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_24_M_AXIS [get_bd_intf_pins axis_data_fifo_24/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_4/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_25_M_AXIS [get_bd_intf_pins axis_data_fifo_25/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_26_M_AXIS [get_bd_intf_pins axis_data_fifo_26/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_6/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_27_M_AXIS [get_bd_intf_pins axis_data_fifo_27/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_28_M_AXIS [get_bd_intf_pins axis_data_fifo_28/M_AXIS] [get_bd_intf_pins microblaze_0/S4_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_29_M_AXIS [get_bd_intf_pins axis_data_fifo_29/M_AXIS] [get_bd_intf_pins microblaze_0/S5_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins ai_engine_0/S02_AXIS] [get_bd_intf_pins axis_data_fifo_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_30_M_AXIS [get_bd_intf_pins axis_data_fifo_30/M_AXIS] [get_bd_intf_pins microblaze_0/S6_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_31_M_AXIS [get_bd_intf_pins axis_data_fifo_31/M_AXIS] [get_bd_intf_pins microblaze_0/S7_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_3_M_AXIS [get_bd_intf_pins ai_engine_0/S03_AXIS] [get_bd_intf_pins axis_data_fifo_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_4_M_AXIS [get_bd_intf_pins ai_engine_0/S04_AXIS] [get_bd_intf_pins axis_data_fifo_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_5_M_AXIS [get_bd_intf_pins ai_engine_0/S05_AXIS] [get_bd_intf_pins axis_data_fifo_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_6_M_AXIS [get_bd_intf_pins ai_engine_0/S06_AXIS] [get_bd_intf_pins axis_data_fifo_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_7_M_AXIS [get_bd_intf_pins ai_engine_0/S07_AXIS] [get_bd_intf_pins axis_data_fifo_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_8_M_AXIS [get_bd_intf_pins axis_data_fifo_8/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_out_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_data_fifo_8_M_AXIS] [get_bd_intf_pins axis_data_fifo_8/M_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_data_fifo_8_M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_9_M_AXIS [get_bd_intf_pins axis_data_fifo_9/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_out_b]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/cmd_in_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_dwidth_converter_0_M_AXIS] [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_dwidth_converter_0_M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_10_M_AXIS [get_bd_intf_pins axis_data_fifo_30/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_10/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_11_M_AXIS [get_bd_intf_pins axis_data_fifo_31/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_11/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_1_M_AXIS [get_bd_intf_pins axis_dwidth_converter_1/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/cmd_in_b]
  connect_bd_intf_net -intf_net axis_dwidth_converter_2_M_AXIS [get_bd_intf_pins axis_dwidth_converter_2/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/cmd_in_c]
  connect_bd_intf_net -intf_net axis_dwidth_converter_3_M_AXIS [get_bd_intf_pins axis_dwidth_converter_3/M_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/cmd_in_d]
  connect_bd_intf_net -intf_net axis_dwidth_converter_4_M_AXIS [get_bd_intf_pins ai_engine_0/S16_AXIS] [get_bd_intf_pins axis_dwidth_converter_4/M_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_dwidth_converter_4_M_AXIS] [get_bd_intf_pins axis_dwidth_converter_4/M_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_7_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_dwidth_converter_4_M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_5_M_AXIS [get_bd_intf_pins ai_engine_0/S17_AXIS] [get_bd_intf_pins axis_dwidth_converter_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_6_M_AXIS [get_bd_intf_pins ai_engine_0/S18_AXIS] [get_bd_intf_pins axis_dwidth_converter_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_7_M_AXIS [get_bd_intf_pins ai_engine_0/S19_AXIS] [get_bd_intf_pins axis_dwidth_converter_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_8_M_AXIS [get_bd_intf_pins axis_data_fifo_29/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_8/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_9_M_AXIS [get_bd_intf_pins axis_data_fifo_28/S_AXIS] [get_bd_intf_pins axis_dwidth_converter_9/M_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_dwidth_converter_9_M_AXIS] [get_bd_intf_pins axis_dwidth_converter_9/M_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_9_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_dwidth_converter_9_M_AXIS]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_id_resp_a [get_bd_intf_pins dma_subsystem_ipi_wr_0/id_resp_a] [get_bd_intf_pins microblaze_0/S0_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_a] [get_bd_intf_pins axis_ila_1/SLOT_1_AXIS] [get_bd_intf_pins microblaze_0/S0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_a]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_id_resp_b [get_bd_intf_pins dma_subsystem_ipi_wr_0/id_resp_b] [get_bd_intf_pins microblaze_0/S1_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_b] [get_bd_intf_pins axis_ila_1/SLOT_2_AXIS] [get_bd_intf_pins microblaze_0/S1_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_b]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_id_resp_c [get_bd_intf_pins dma_subsystem_ipi_wr_0/id_resp_c] [get_bd_intf_pins microblaze_0/S2_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_c] [get_bd_intf_pins axis_ila_1/SLOT_3_AXIS] [get_bd_intf_pins microblaze_0/S2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_c]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_id_resp_d [get_bd_intf_pins dma_subsystem_ipi_wr_0/id_resp_d] [get_bd_intf_pins microblaze_0/S3_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_d] [get_bd_intf_pins axis_ila_1/SLOT_4_AXIS] [get_bd_intf_pins microblaze_0/S3_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_id_resp_d]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part0_in_a [get_bd_intf_pins axis_data_fifo_16/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_in_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_part0_in_a] [get_bd_intf_pins axis_data_fifo_16/S_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_part0_in_a]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part0_in_b [get_bd_intf_pins axis_data_fifo_17/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_in_b]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part0_in_c [get_bd_intf_pins axis_data_fifo_18/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_in_c]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part0_in_d [get_bd_intf_pins axis_data_fifo_19/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part0_in_d]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part1_in_a [get_bd_intf_pins axis_data_fifo_20/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_in_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_part1_in_a] [get_bd_intf_pins axis_data_fifo_20/S_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_3_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_part1_in_a]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part1_in_b [get_bd_intf_pins axis_data_fifo_21/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_in_b]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part1_in_c [get_bd_intf_pins axis_data_fifo_22/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_in_c]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_part1_in_d [get_bd_intf_pins axis_data_fifo_23/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/part1_in_d]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim0_in_a [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim0_in_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_prim0_in_a] [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_4_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_prim0_in_a]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim0_in_b [get_bd_intf_pins axis_data_fifo_1/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim0_in_b]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim0_in_c [get_bd_intf_pins axis_data_fifo_2/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim0_in_c]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim0_in_d [get_bd_intf_pins axis_data_fifo_3/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim0_in_d]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim1_in_a [get_bd_intf_pins axis_data_fifo_4/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim1_in_a]
connect_bd_intf_net -intf_net [get_bd_intf_nets dma_subsystem_ipi_wr_0_prim1_in_a] [get_bd_intf_pins axis_data_fifo_4/S_AXIS] [get_bd_intf_pins axis_ila_0/SLOT_5_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets dma_subsystem_ipi_wr_0_prim1_in_a]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim1_in_b [get_bd_intf_pins axis_data_fifo_5/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim1_in_b]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim1_in_c [get_bd_intf_pins axis_data_fifo_6/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim1_in_c]
  connect_bd_intf_net -intf_net dma_subsystem_ipi_wr_0_prim1_in_d [get_bd_intf_pins axis_data_fifo_7/S_AXIS] [get_bd_intf_pins dma_subsystem_ipi_wr_0/prim1_in_d]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_0_BRAM_PORT [get_bd_intf_pins emb_mem_gen_1/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr_0/BRAM_PORT]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_1_BRAM_PORT [get_bd_intf_pins emb_mem_gen_1/BRAM_PORTB] [get_bd_intf_pins lmb_bram_if_cntlr_1/BRAM_PORT]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_2_BRAM_PORT [get_bd_intf_pins emb_mem_gen_2/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr_2/BRAM_PORT]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_3_BRAM_PORT [get_bd_intf_pins emb_mem_gen_2/BRAM_PORTB] [get_bd_intf_pins lmb_bram_if_cntlr_3/BRAM_PORT]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_0 [get_bd_intf_pins mdm_0/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net mdm_0_MBDEBUG_1 [get_bd_intf_pins mdm_0/MBDEBUG_1] [get_bd_intf_pins microblaze_1/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins lmb_bram_if_cntlr_0/SLMB] [get_bd_intf_pins microblaze_0/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins lmb_bram_if_cntlr_1/SLMB] [get_bd_intf_pins microblaze_0/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_M0_AXIS [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS] [get_bd_intf_pins microblaze_0/M0_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M0_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_5_AXIS] [get_bd_intf_pins microblaze_0/M0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M0_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M1_AXIS [get_bd_intf_pins axis_dwidth_converter_1/S_AXIS] [get_bd_intf_pins microblaze_0/M1_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M1_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_6_AXIS] [get_bd_intf_pins microblaze_0/M1_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M1_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M2_AXIS [get_bd_intf_pins axis_dwidth_converter_2/S_AXIS] [get_bd_intf_pins microblaze_0/M2_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M2_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_7_AXIS] [get_bd_intf_pins microblaze_0/M2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M2_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M3_AXIS [get_bd_intf_pins axis_dwidth_converter_3/S_AXIS] [get_bd_intf_pins microblaze_0/M3_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M3_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_8_AXIS] [get_bd_intf_pins microblaze_0/M3_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M3_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M4_AXIS [get_bd_intf_pins axis_data_fifo_24/S_AXIS] [get_bd_intf_pins microblaze_0/M4_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M4_AXIS] [get_bd_intf_pins axis_ila_1/SLOT_10_AXIS] [get_bd_intf_pins microblaze_0/M4_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M4_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M5_AXIS [get_bd_intf_pins axis_data_fifo_25/S_AXIS] [get_bd_intf_pins microblaze_0/M5_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M6_AXIS [get_bd_intf_pins axis_data_fifo_26/S_AXIS] [get_bd_intf_pins microblaze_0/M6_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M7_AXIS [get_bd_intf_pins axis_data_fifo_27/S_AXIS] [get_bd_intf_pins microblaze_0/M7_AXIS]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets microblaze_0_M_AXI_DP] [get_bd_intf_pins axis_ila_1/SLOT_9_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets microblaze_0_M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_1_DLMB [get_bd_intf_pins lmb_bram_if_cntlr_2/SLMB] [get_bd_intf_pins microblaze_1/DLMB]
  connect_bd_intf_net -intf_net microblaze_1_ILMB [get_bd_intf_pins lmb_bram_if_cntlr_3/SLMB] [get_bd_intf_pins microblaze_1/ILMB]
  connect_bd_intf_net -intf_net microblaze_1_M_AXI_DP [get_bd_intf_pins microblaze_1/M_AXI_DP] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins NOC_0/S08_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_ports ddr4_dimm1_sma_clk] [get_bd_intf_pins NOC_0/sys_clk0]

  # Create port connections
  connect_bd_net -net CIPS_0_lpd_gpio_o [get_bd_pins CIPS_0/lpd_gpio_o] [get_bd_pins microblaze_0/Wakeup] [get_bd_pins microblaze_1/Wakeup]
  connect_bd_net -net CIPS_0_pl_clk0 [get_bd_pins CIPS_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net CIPS_0_pl_resetn1 [get_bd_pins CIPS_0/pl0_resetn] [get_bd_pins clk_wizard_0/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in]
  connect_bd_net -net CIPS_0_ps_pmc_noc_axi0_clk [get_bd_pins CIPS_0/pmc_axi_noc_axi0_clk] [get_bd_pins NOC_0/aclk8]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi0_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi0_clk] [get_bd_pins NOC_0/aclk1]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi1_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi1_clk] [get_bd_pins NOC_0/aclk2]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi2_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi2_clk] [get_bd_pins NOC_0/aclk3]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi3_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi3_clk] [get_bd_pins NOC_0/aclk4]
  connect_bd_net -net CIPS_0_ps_ps_noc_nci_axi0_clk [get_bd_pins CIPS_0/fpd_axi_noc_axi0_clk] [get_bd_pins NOC_0/aclk5]
  connect_bd_net -net CIPS_0_ps_ps_noc_nci_axi1_clk [get_bd_pins CIPS_0/fpd_axi_noc_axi1_clk] [get_bd_pins NOC_0/aclk6]
  connect_bd_net -net CIPS_0_ps_ps_noc_rpu_axi0_clk [get_bd_pins CIPS_0/lpd_axi_noc_clk] [get_bd_pins NOC_0/aclk7]
  connect_bd_net -net ai_engine_0_m00_axi_aclk [get_bd_pins NOC_0/aclk10] [get_bd_pins ai_engine_0/m00_axi_aclk]
  connect_bd_net -net ai_engine_0_m01_axi_aclk [get_bd_pins NOC_0/aclk11] [get_bd_pins ai_engine_0/m01_axi_aclk]
  connect_bd_net -net ai_engine_0_m02_axi_aclk [get_bd_pins NOC_0/aclk12] [get_bd_pins ai_engine_0/m02_axi_aclk]
  connect_bd_net -net ai_engine_0_m03_axi_aclk [get_bd_pins NOC_0/aclk13] [get_bd_pins ai_engine_0/m03_axi_aclk]
  connect_bd_net -net ai_engine_0_m04_axi_aclk [get_bd_pins NOC_0/aclk14] [get_bd_pins ai_engine_0/m04_axi_aclk]
  connect_bd_net -net ai_engine_0_m05_axi_aclk [get_bd_pins NOC_0/aclk15] [get_bd_pins ai_engine_0/m05_axi_aclk]
  connect_bd_net -net ai_engine_0_m06_axi_aclk [get_bd_pins NOC_0/aclk16] [get_bd_pins ai_engine_0/m06_axi_aclk]
  connect_bd_net -net ai_engine_0_m07_axi_aclk [get_bd_pins NOC_0/aclk17] [get_bd_pins ai_engine_0/m07_axi_aclk]
  connect_bd_net -net ai_engine_0_m08_axi_aclk [get_bd_pins NOC_0/aclk18] [get_bd_pins ai_engine_0/m08_axi_aclk]
  connect_bd_net -net ai_engine_0_m09_axi_aclk [get_bd_pins NOC_0/aclk19] [get_bd_pins ai_engine_0/m09_axi_aclk]
  connect_bd_net -net ai_engine_0_m10_axi_aclk [get_bd_pins NOC_0/aclk20] [get_bd_pins ai_engine_0/m10_axi_aclk]
  connect_bd_net -net ai_engine_0_m11_axi_aclk [get_bd_pins NOC_0/aclk21] [get_bd_pins ai_engine_0/m11_axi_aclk]
  connect_bd_net -net ai_engine_0_m12_axi_aclk [get_bd_pins NOC_0/aclk22] [get_bd_pins ai_engine_0/m12_axi_aclk]
  connect_bd_net -net ai_engine_0_m13_axi_aclk [get_bd_pins NOC_0/aclk23] [get_bd_pins ai_engine_0/m13_axi_aclk]
  connect_bd_net -net ai_engine_0_m14_axi_aclk [get_bd_pins NOC_0/aclk24] [get_bd_pins ai_engine_0/m14_axi_aclk]
  connect_bd_net -net ai_engine_0_m15_axi_aclk [get_bd_pins NOC_0/aclk25] [get_bd_pins ai_engine_0/m15_axi_aclk]
  connect_bd_net -net ai_engine_0_s00_axi_aclk [get_bd_pins NOC_0/aclk9] [get_bd_pins ai_engine_0/s00_axi_aclk]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins CIPS_0/pl_ps_irq0] [get_bd_pins axi_intc_0/irq]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins CIPS_0/m_axi_fpd_aclk] [get_bd_pins NOC_0/aclk0] [get_bd_pins ai_engine_0/aclk0] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_cdma_0_smc/aclk] [get_bd_pins axi_dbg_hub_0/aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axis_data_fifo_24/s_axis_aclk] [get_bd_pins axis_data_fifo_25/s_axis_aclk] [get_bd_pins axis_data_fifo_26/s_axis_aclk] [get_bd_pins axis_data_fifo_27/s_axis_aclk] [get_bd_pins axis_data_fifo_28/m_axis_aclk] [get_bd_pins axis_data_fifo_29/m_axis_aclk] [get_bd_pins axis_data_fifo_30/m_axis_aclk] [get_bd_pins axis_data_fifo_31/m_axis_aclk] [get_bd_pins axis_dwidth_converter_0/aclk] [get_bd_pins axis_dwidth_converter_1/aclk] [get_bd_pins axis_dwidth_converter_2/aclk] [get_bd_pins axis_dwidth_converter_3/aclk] [get_bd_pins axis_ila_1/clk] [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins dma_subsystem_ipi_wr_0/clk1x] [get_bd_pins lmb_bram_if_cntlr_0/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr_1/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr_2/LMB_Clk] [get_bd_pins lmb_bram_if_cntlr_3/LMB_Clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_1/Clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk] [get_bd_pins smartconnect_1/aclk1]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out3 [get_bd_pins clk_wizard_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out4 [get_bd_pins NOC_0/aclk26] [get_bd_pins ai_engine_0/aclk1] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axis_data_fifo_10/s_axis_aclk] [get_bd_pins axis_data_fifo_11/s_axis_aclk] [get_bd_pins axis_data_fifo_12/s_axis_aclk] [get_bd_pins axis_data_fifo_13/s_axis_aclk] [get_bd_pins axis_data_fifo_14/s_axis_aclk] [get_bd_pins axis_data_fifo_15/s_axis_aclk] [get_bd_pins axis_data_fifo_16/s_axis_aclk] [get_bd_pins axis_data_fifo_17/s_axis_aclk] [get_bd_pins axis_data_fifo_18/s_axis_aclk] [get_bd_pins axis_data_fifo_19/s_axis_aclk] [get_bd_pins axis_data_fifo_2/s_axis_aclk] [get_bd_pins axis_data_fifo_20/s_axis_aclk] [get_bd_pins axis_data_fifo_21/s_axis_aclk] [get_bd_pins axis_data_fifo_22/s_axis_aclk] [get_bd_pins axis_data_fifo_23/s_axis_aclk] [get_bd_pins axis_data_fifo_24/m_axis_aclk] [get_bd_pins axis_data_fifo_25/m_axis_aclk] [get_bd_pins axis_data_fifo_26/m_axis_aclk] [get_bd_pins axis_data_fifo_27/m_axis_aclk] [get_bd_pins axis_data_fifo_28/s_axis_aclk] [get_bd_pins axis_data_fifo_29/s_axis_aclk] [get_bd_pins axis_data_fifo_3/s_axis_aclk] [get_bd_pins axis_data_fifo_30/s_axis_aclk] [get_bd_pins axis_data_fifo_31/s_axis_aclk] [get_bd_pins axis_data_fifo_4/s_axis_aclk] [get_bd_pins axis_data_fifo_5/s_axis_aclk] [get_bd_pins axis_data_fifo_6/s_axis_aclk] [get_bd_pins axis_data_fifo_7/s_axis_aclk] [get_bd_pins axis_data_fifo_8/s_axis_aclk] [get_bd_pins axis_data_fifo_9/s_axis_aclk] [get_bd_pins axis_dwidth_converter_10/aclk] [get_bd_pins axis_dwidth_converter_11/aclk] [get_bd_pins axis_dwidth_converter_4/aclk] [get_bd_pins axis_dwidth_converter_5/aclk] [get_bd_pins axis_dwidth_converter_6/aclk] [get_bd_pins axis_dwidth_converter_7/aclk] [get_bd_pins axis_dwidth_converter_8/aclk] [get_bd_pins axis_dwidth_converter_9/aclk] [get_bd_pins axis_ila_0/clk] [get_bd_pins clk_wizard_0/clk_out4] [get_bd_pins dma_subsystem_ipi_wr_0/clk2x]
  connect_bd_net -net clk_wizard_0_locked [get_bd_pins clk_wizard_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked]
  connect_bd_net -net mdm_0_Debug_SYS_Rst [get_bd_pins mdm_0/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins lmb_bram_if_cntlr_0/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_1/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_2/LMB_Rst] [get_bd_pins lmb_bram_if_cntlr_3/LMB_Rst] [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_1/Reset] [get_bd_pins proc_sys_reset_0/mb_reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_cdma_0_smc/aresetn] [get_bd_pins axi_dbg_hub_0/aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn] [get_bd_pins axis_data_fifo_10/s_axis_aresetn] [get_bd_pins axis_data_fifo_11/s_axis_aresetn] [get_bd_pins axis_data_fifo_12/s_axis_aresetn] [get_bd_pins axis_data_fifo_13/s_axis_aresetn] [get_bd_pins axis_data_fifo_14/s_axis_aresetn] [get_bd_pins axis_data_fifo_15/s_axis_aresetn] [get_bd_pins axis_data_fifo_16/s_axis_aresetn] [get_bd_pins axis_data_fifo_17/s_axis_aresetn] [get_bd_pins axis_data_fifo_18/s_axis_aresetn] [get_bd_pins axis_data_fifo_19/s_axis_aresetn] [get_bd_pins axis_data_fifo_2/s_axis_aresetn] [get_bd_pins axis_data_fifo_20/s_axis_aresetn] [get_bd_pins axis_data_fifo_21/s_axis_aresetn] [get_bd_pins axis_data_fifo_22/s_axis_aresetn] [get_bd_pins axis_data_fifo_23/s_axis_aresetn] [get_bd_pins axis_data_fifo_24/s_axis_aresetn] [get_bd_pins axis_data_fifo_25/s_axis_aresetn] [get_bd_pins axis_data_fifo_26/s_axis_aresetn] [get_bd_pins axis_data_fifo_27/s_axis_aresetn] [get_bd_pins axis_data_fifo_28/s_axis_aresetn] [get_bd_pins axis_data_fifo_29/s_axis_aresetn] [get_bd_pins axis_data_fifo_3/s_axis_aresetn] [get_bd_pins axis_data_fifo_30/s_axis_aresetn] [get_bd_pins axis_data_fifo_31/s_axis_aresetn] [get_bd_pins axis_data_fifo_4/s_axis_aresetn] [get_bd_pins axis_data_fifo_5/s_axis_aresetn] [get_bd_pins axis_data_fifo_6/s_axis_aresetn] [get_bd_pins axis_data_fifo_7/s_axis_aresetn] [get_bd_pins axis_data_fifo_8/s_axis_aresetn] [get_bd_pins axis_data_fifo_9/s_axis_aresetn] [get_bd_pins axis_dwidth_converter_0/aresetn] [get_bd_pins axis_dwidth_converter_1/aresetn] [get_bd_pins axis_dwidth_converter_10/aresetn] [get_bd_pins axis_dwidth_converter_11/aresetn] [get_bd_pins axis_dwidth_converter_2/aresetn] [get_bd_pins axis_dwidth_converter_3/aresetn] [get_bd_pins axis_dwidth_converter_4/aresetn] [get_bd_pins axis_dwidth_converter_5/aresetn] [get_bd_pins axis_dwidth_converter_6/aresetn] [get_bd_pins axis_dwidth_converter_7/aresetn] [get_bd_pins axis_dwidth_converter_8/aresetn] [get_bd_pins axis_dwidth_converter_9/aresetn] [get_bd_pins axis_ila_0/resetn] [get_bd_pins axis_ila_1/resetn] [get_bd_pins dma_subsystem_ipi_wr_0/rstn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins microblaze_0/Reset_Mode] [get_bd_pins microblaze_1/Reset_Mode] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs NOC_0/S00_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs NOC_0/S04_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs NOC_0/S00_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs NOC_0/S04_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs NOC_0/S05_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs NOC_0/S01_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs NOC_0/S05_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs NOC_0/S01_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs NOC_0/S06_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs NOC_0/S02_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs NOC_0/S02_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs NOC_0/S06_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs NOC_0/S07_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs NOC_0/S03_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs NOC_0/S07_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs NOC_0/S03_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/Data1] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs NOC_0/S12_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs NOC_0/S24_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs NOC_0/S20_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs NOC_0/S16_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs NOC_0/S12_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs NOC_0/S24_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs NOC_0/S20_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs NOC_0/S16_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs NOC_0/S17_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs NOC_0/S13_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs NOC_0/S09_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs NOC_0/S21_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs NOC_0/S09_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs NOC_0/S17_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs NOC_0/S13_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs NOC_0/S21_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs NOC_0/S22_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs NOC_0/S10_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs NOC_0/S18_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs NOC_0/S14_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs NOC_0/S18_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs NOC_0/S10_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs NOC_0/S22_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs NOC_0/S14_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs NOC_0/S11_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs NOC_0/S23_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs NOC_0/S19_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs NOC_0/S15_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs NOC_0/S15_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs NOC_0/S19_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs NOC_0/S23_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs NOC_0/S11_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M15_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M14_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M13_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M12_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M11_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M10_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M09_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M08_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M07_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M06_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M05_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M04_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M03_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M02_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M01_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ai_engine_0/M00_AXI] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs NOC_0/S25_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs NOC_0/S08_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x0202C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs lmb_bram_if_cntlr_0/SLMB/Mem] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs lmb_bram_if_cntlr_1/SLMB/Mem] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs NOC_0/S08_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x0202C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x020240000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem0] -force
  assign_bd_address -offset 0x020240020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem1] -force
  assign_bd_address -offset 0x020240040000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem2] -force
  assign_bd_address -offset 0x020240060000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem3] -force
  assign_bd_address -offset 0x020240080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem4] -force
  assign_bd_address -offset 0x0202400A0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem5] -force
  assign_bd_address -offset 0x0202400C0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem6] -force
  assign_bd_address -offset 0x0202400E0000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs dma_subsystem_ipi_wr_0/s_axi/mem7] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs lmb_bram_if_cntlr_2/SLMB/Mem] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_1/Instruction] [get_bd_addr_segs lmb_bram_if_cntlr_3/SLMB/Mem] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs NOC_0/S25_AXI/C0_DDR_LOW1]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs NOC_0/S25_AXI/C0_DDR_LOW1]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs NOC_0/S25_AXI/C0_DDR_LOW1]
  exclude_bd_addr_seg -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs NOC_0/S08_AXI/C0_DDR_LOW1]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces microblaze_1/Data] [get_bd_addr_segs NOC_0/S08_AXI/C0_DDR_LOW1]


  # Restore current instance
  current_bd_instance $oldCurInst

  # Create PFM attributes
  set_property PFM_NAME {xilinx:vck190:xilinx_vck190_air:1.0} [get_files [current_bd_design].bd]
  set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
  set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_0" status "fixed"} clk_out2 {id "0" is_default "true" proc_sys_reset "/proc_sys_reset_1" status "fixed"} clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"}} [get_bd_cells /clk_wizard_0]


  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


regenerate_bd_layout
save_bd_design

import_files -fileset sources_1 -norecurse ../lib/mb/acdc_agent.elf
set_property used_in_simulation 0 [get_files acdc_agent.elf]
set_property SCOPED_TO_REF project_1 [get_files -all -of_objects [get_fileset sources_1] {acdc_agent.elf}]
set_property SCOPED_TO_CELLS { microblaze_1 microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] {acdc_agent.elf}]

#import_files -fileset constrs_1 -norecurse ./constraints/ai_ph1.xdc
#import_files -fileset constrs_1 -norecurse ./constraints/default.xdc
#import_files -fileset constrs_1 -norecurse ./constraints/pl_clk_uncertainty.xdc
#import_files -fileset constrs_1 -norecurse ./constraints/vck190_vmk180_ddr4single_dimm1.xdc

import_files -fileset constrs_1 -norecurse ./constraints/hwflow/profiles/PL/xdc/default.xdc
import_files -fileset constrs_1 -norecurse ./constraints/hwflow/profiles/PL/xdc/pl_clk_uncertainty.xdc
import_files -fileset constrs_1 -norecurse ./constraints/hwflow/profiles/PL/xdc/pl_aie_axis_placement.xdc
import_files -fileset constrs_1 -norecurse ./constraints/vnc_xdcs/vck190_vmk180_ddr4single_dimm1.xdc
import_files -fileset constrs_1 -norecurse ./constraints/vnc_xdcs/ai_ph1.xdc

set_property generate_synth_checkpoint true [get_files -norecurse *.bd]
make_wrapper -files [get_files ./myproj/project_1.srcs/sources_1/bd/project_1/project_1.bd] -top
add_files -norecurse ./myproj/project_1.srcs/sources_1/bd/project_1/hdl/project_1_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1


##versal workarounds for bugs in device models
#
import_files -fileset utils_1 -norecurse ./aie_vnc/pre_place.tcl
import_files -fileset utils_1 -norecurse ./aie_vnc/post_place.tcl
import_files -fileset utils_1 -norecurse ./aie_vnc/post_route.tcl

set_property platform.run.steps.place_design.tcl.pre [get_files pre_place.tcl] [current_project]
set_property platform.run.steps.place_design.tcl.post [get_files post_place.tcl] [current_project]
set_property platform.run.steps.route_design.tcl.post [get_files post_route.tcl] [current_project]

##trace stuff.....
#
#set_property HDL_ATTRIBUTE.DPA_TRACE_SLAVE true [get_bd_cells CIPS_0]
#
##emulation stuff.....
#
set_property SELECTED_SIM_MODEL tlm [get_bd_cells CIPS_0]
set_property SELECTED_SIM_MODEL tlm [get_bd_cells NOC_0]
set_property SELECTED_SIM_MODEL tlm [get_bd_cells axi_noc_kernel0]


set_property platform.default_output_type "sd_card" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]
set_property platform.uses_pr  "false" [current_project]
#set_property platform.num_compute_units 15 [current_project]

#set_property platform.platform_state "pre_synth" [current_project]

generate_target all [get_files ./myproj/project_1.srcs/sources_1/bd/project_1/project_1.bd]

#launch_runs synth_1 -jobs 20
# added sub call to allow script to auto-determine best number of jobs to call
launch_runs synth_1 -jobs [numberOfCPUs]

wait_on_run synth_1

launch_runs impl_1 -jobs [numberOfCPUs]
wait_on_run impl_1

launch_runs impl_1 -jobs [numberOfCPUs] -to_step write_device_image
wait_on_run impl_1

open_run impl_1

write_hw_platform -unified -include_bit -force  xilinx_vck190_air.xsa
validate_hw_platform xilinx_vck190_air.xsa -verbose

