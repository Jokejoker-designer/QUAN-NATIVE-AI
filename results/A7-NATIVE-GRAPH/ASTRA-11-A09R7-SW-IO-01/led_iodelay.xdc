# ASTRA-11-A09R7-SW-IO-01. PROGRAM=NO. BIT=NO.
# LED I/O delays kept (handoff: UART+LED pins may stay). FROZEN in PREREG
# before impl. Copied 2.000/0.500 from repo 3.3 V CMOS I/O class (not invented
# after WNS). Applied AFTER synth when MMCM-derived clk50u exists.
# LEDs are related on-board outputs of clk50u. Do not time against uart_io_vclk.
# Do not false-path-hold led[*]. Do not retune 2.000/0.500 after WNS/WHS.
#
# LED_OUT_MAX_NS = 2.000
# LED_OUT_MIN_NS = 0.500
# LED_CLK_REF    = clk50u 20.000 ns

set_output_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {led[*]}]
