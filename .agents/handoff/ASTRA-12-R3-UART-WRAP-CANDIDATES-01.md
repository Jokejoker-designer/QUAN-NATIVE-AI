# ASTRA-12-R3-UART-WRAP-CANDIDATES-01

Parent dispatch 2026-09-06 after auditor 20260906T1900Z ACCEPT_PARTIAL on ASTRA-11-A09R3-UART-IOBFF-HOLD-01.
UART STA ladder CLOSED_NARROW as separate envelopes. Parent does **not** freeze PRODUCTION_TOP. This bag only **extends the candidate table** with the UART wraps (XSim + routed), hashes/WNS/WHS/IOB/hold-policy. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12-R2-TOP-CANDIDATES-01 or any ASTRA-11 UART bags. Do not rerun impl. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R3-UART-WRAP-CANDIDATES-01/ACK.json

## Required

1. CANDIDATES.md rows (quote WNS/WHS from raw reports, do not mix bags):
   - ASTRA-09-R3-UART-XSIM-01 (XSim only, no routed WNS)
   - ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305
   - ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 delays 2.000/0.500
   - ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 IOB FF YES
   - ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131 FALSE_PATH_HOLD
   - Keep the four 12-R2 routed tops as a pointer, do not rewrite those files
2. PRODUCTION_TOP=UNKNOWN in ACK/RESULTS/CLOSEOUT.
3. UART D10/A9 present yes/no per row.

Do not close ASTRA-13, BOARD_PASS, LM06, Master F3.
