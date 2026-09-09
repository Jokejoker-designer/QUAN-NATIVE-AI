# ASTRA-12-R4-R7-UART-CANDIDATES-01

Parent dispatch 2026-09-07 after auditor 20260907T0200Z ACCEPT_PARTIAL on ASTRA-11-A09R7-UART-IMPL-ROUTE-01.
That bag CLOSED_NARROW WNS=+0.336 WHS=+0.104 UART IOB YES. Parent does **not** freeze PRODUCTION_TOP. This bag only **extends the candidate table** with R7 XSim + A09R7 impl-route. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12-R2, ASTRA-12-R3, ASTRA-09-R7, ASTRA-11-A09R7-UART-IMPL-ROUTE-01. Do not rerun impl/xsim. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R4-R7-UART-CANDIDATES-01/ACK.json

## Required

1. CANDIDATES.md rows quoting raw reports:
   - ASTRA-09-R7-UART-QUERY-REW-01 (XSim, ans=4 then w0=-5, no routed WNS)
   - ASTRA-11-A09R7-UART-IMPL-ROUTE-01 WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD
   - Pointers to 12-R2 and 12-R3 tables, do not rewrite those files
2. PRODUCTION_TOP=UNKNOWN.
3. Do not close ASTRA-13, BOARD_PASS, LM06, Master F3.

PROGRAM=NO.
