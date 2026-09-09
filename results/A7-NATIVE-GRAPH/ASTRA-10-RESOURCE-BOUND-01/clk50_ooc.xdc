# ASTRA-10-RESOURCE-BOUND-01 OOC 50 MHz. PROGRAM=NO. No board pins.
# Declared clock for post-synth WNS. Not ASTRA-SOC-RTP-WRAP-ROUTE clk50u.
create_clock -period 20.000 -name clk50 [get_ports clk]
set_false_path -from [get_ports rst_n]
