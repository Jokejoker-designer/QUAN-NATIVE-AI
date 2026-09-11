# ASTRA-C6-WHOLECHIP-FINAL-V1. PROGRAM=NO.
# Official Arty A7-100T CLK/UART/LED/BTN: constraints/arty_a7_100.xdc (do not edit).
# Official DDR3 pads: unmodified MIG user_design XDC (do not edit).
# UART IOB FF forbidden. uart_io_vclk is an async FTDI reference.

set_property IOB FALSE [get_ports uart_txd_in]
set_property IOB FALSE [get_ports uart_rxd_out]

create_clock -name uart_io_vclk -period 12.000
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]

set_false_path -from [get_ports {sw[*]}]
set_false_path -from [get_ports {btn[*]}]
