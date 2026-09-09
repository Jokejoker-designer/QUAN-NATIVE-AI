# ASTRA-11-A09R7-SW-IO-01. PROGRAM=NO. BIT=NO.
# Official Arty A7-100T pins (cite Digilent Arty-A7-100-Master / constraints/arty_a7_100.xdc).
# Do not edit that file. UART D10/A9 kept. LED LD4-LD7 = H5/J5/T9/T10 kept.
# BTN0-BTN3 = D9/C9/B9/B8 kept, false-pathed (BTN unknown already closed).
# SW0-SW3 = A8/C11/C10/A10 (this bag's residual). Do NOT set_false_path on sw[*].
# Pin CLK100MHZ E3 is the 100 MHz oscillator site (period 10.000 ns).
# Declared 50 MHz is the MMCM 100→50 pipe clock (clock-network included after route).
#
# SW pinout FROZEN in PREREG before impl (cited set; no other SW set in this clone):
#   sw[0]=A8  SW0 Sch=sw[0]
#   sw[1]=C11 SW1 Sch=sw[1]
#   sw[2]=C10 SW2 Sch=sw[2]
#   sw[3]=A10 SW3 Sch=sw[3]
# SW input delays FROZEN in PREREG: IN max 2.000 min 0.500 vs clk50u.
# Those delays bind after synth (sw_iodelay.xdc) when clk50u exists.
# LED delays FROZEN: OUT max 2.000 min 0.500 vs clk50u (led_iodelay.xdc post-synth).
# UART STA envelope FROZEN: IN/OUT max 2.000 min 0.500 + FALSE_PATH_HOLD_ASYNC_UART.
# Do NOT set_false_path on sw[*] (BTN/LED bag residual). btn[*] is false-pathed.

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports { CLK100MHZ }]

# SW0-SW3 (cited constraints/arty_a7_100.xdc) — this bag's unknown
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]
set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]
set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]

# LD4-LD7 (cited constraints/arty_a7_100.xdc) kept
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]

# BTN0-BTN3 kept, false-pathed (not this bag's unknown)
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]
set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]
set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]

# USB-UART (Digilent names: uart_rxd_out = FPGA TX on D10; uart_txd_in = FPGA RX on A9)
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]

set_false_path -from [get_ports {btn[*]}]
# sw[*] is timed (SW I/O delays vs clk50u). Do not false-path switches.

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

# Frozen IOB FF policy (PREREG). UART + LED + SW pad registers.
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports {led[*]}]
set_property IOB TRUE [get_ports {sw[*]}]
