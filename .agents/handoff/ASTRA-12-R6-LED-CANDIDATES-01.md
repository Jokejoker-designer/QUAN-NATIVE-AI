# ASTRA-12-R6-LED-CANDIDATES-01

Parent dispatch 2026-09-07 after auditor 20260907T0400Z ACCEPT_PARTIAL on ASTRA-11-A09R7-LED-IO-01.
LED wrap CLOSED_NARROW WNS=+0.411 WHS=+0.027 LD4–LD7 H5/J5/T9/T10. Parent does **not** freeze PRODUCTION_TOP. This bag only **extends the candidate table** with the LED wrap. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12-R2/R3/R4/R5, ASTRA-11-A09R7-LED-IO-01, A09R7 UART impl. Do not rerun impl. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R6-LED-CANDIDATES-01/ACK.json

## Required

1. CANDIDATES.md one new row quoting raw timing_route.rpt WNS=+0.411 WHS=+0.027 LED H5/J5/T9/T10 UART A9/D10 kept. Pointers to 12-R4/R5, do not rewrite those files.
2. PRODUCTION_TOP=UNKNOWN.
3. Do not close ASTRA-13, BOARD_PASS, LM06.

PROGRAM=NO.
