# ASTRA-11-A09R7-LED-IO-01. PROGRAM=NO. BIT=NO.
# Official Arty A7-100T pins (cite Digilent Arty-A7-100-Master / constraints/arty_a7_100.xdc).
# Do not edit that file. UART D10/A9 kept (UART-class wrap). LED LD4-LD7 = H5/J5/T9/T10.
# Pin CLK100MHZ E3 is the 100 MHz oscillator site (period 10.000 ns).
# Declared 50 MHz is the MMCM 100→50 pipe clock (clock-network included after route).
#
# LED pinout FROZEN in PREREG before impl (cited set; no other LED set in this clone):
#   led[0]=H5 LD4 Sch=led[4]
#   led[1]=J5 LD5 Sch=led[5]
#   led[2]=T9 LD6 Sch=led[6]
#   led[3]=T10 LD7 Sch=led[7]
# LED I/O delays FROZEN in PREREG: OUT max 2.000 min 0.500 vs clk50u.
# Those delays bind after synth (led_iodelay.xdc) when clk50u exists.
# UART STA envelope FROZEN: IN/OUT max 2.000 min 0.500 + FALSE_PATH_HOLD_ASYNC_UART.

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports { CLK100MHZ }]

set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]
set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]
set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]

# LD4-LD7 (cited constraints/arty_a7_100.xdc)
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]

set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]
set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]
set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]

# USB-UART (Digilent names: uart_rxd_out = FPGA TX on D10; uart_txd_in = FPGA RX on A9)
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]

set_false_path -from [get_ports {sw[*]}]
set_false_path -from [get_ports {btn[*]}]

# ---------------------------------------------------------------------------
# UART STA envelope (PREREG). uart_io_vclk is the async FTDI I/O reference
# at the same 20.000 ns period as pipe clk50u. Pipe clock remains MMCM+BUFG
# clk50u (real, not virtual). IN/OUT max 2.000 min 0.500.
# HOLD POLICY: FALSE_PATH_HOLD_ASYNC_UART. Do not retune 0.500 after WNS/WHS.
# ---------------------------------------------------------------------------
create_clock -name uart_io_vclk -period 20.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]

set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]

# Frozen IOB FF policy (PREREG). UART + LED pad registers.
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports {led[*]}]
