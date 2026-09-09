# ASTRA-11-A09R7-BTN-IDELAY-01. PROGRAM=NO. BIT=NO.
# BTN input delays FROZEN in PREREG before impl. KEEP 2.000/0.500 from FAIL bag
# ASTRA-11-A09R7-BTN-IO-01 (not retuned; not invented after this bag's WHS).
# Applied AFTER synth when MMCM-derived clk50u exists.
# Buttons are related on-board inputs of clk50u.
# Do not time against uart_io_vclk. Do not false-path btn[*].
# Do not false-path-hold btn[*]. Do not retune 2.000/0.500 after WNS/WHS.
# IDELAYE2 tap 31 / REFCLK 200 MHz is frozen in wrap RTL + PREREG, not here.
#
# BTN_IN_MAX_NS = 2.000
# BTN_IN_MIN_NS = 0.500
# BTN_CLK_REF   = clk50u 20.000 ns

set_input_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {btn[*]}]
set_input_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {btn[*]}]
