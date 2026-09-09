# ASTRA-11-A09R7-SW-IO-01. PROGRAM=NO. BIT=NO.
# SW input delays FROZEN in PREREG before impl. Copied 2.000/0.500 from repo
# 3.3 V CMOS I/O class (not invented after WNS). Applied AFTER synth when
# MMCM-derived clk50u exists. Slide switches are related on-board inputs of clk50u.
# Do not time against uart_io_vclk. Do not false-path-hold sw[*].
# Do not retune 2.000/0.500 after WNS/WHS. Do not set_false_path on sw[*].
#
# SW_IN_MAX_NS = 2.000
# SW_IN_MIN_NS = 0.500
# SW_CLK_REF   = clk50u 20.000 ns

set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {sw[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {sw[*]}]
