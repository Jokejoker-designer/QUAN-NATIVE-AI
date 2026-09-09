# ASTRA-12-R7-BTN-CANDIDATES-01

Parent dispatch 2026-09-07 after auditor 20260907T0530Z ACCEPT_PARTIAL on ASTRA-11-A09R7-BTN-IDELAY-01.
P1 BTN pad hold CLOSED_NARROW TAP=31 WNS=+0.574 WHS=+0.131 related-clock MET +0.638. FAIL bag WHS=−2.068 stays on disk. Parent does **not** freeze PRODUCTION_TOP. This bag only **extends the candidate table**. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12-R6, ASTRA-11-A09R7-BTN-IO-01, ASTRA-11-A09R7-BTN-IDELAY-01. Do not rerun impl. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R7-BTN-CANDIDATES-01/ACK.json

## Required

1. CANDIDATES.md two rows quoting raw reports:
   - FAIL bag BTN-IO WNS=+0.452 WHS=−2.068
   - IDELAY bag TAP=31 WNS=+0.574 WHS=+0.131 BTN hold MET +0.638 false-path-btn NO
   Pointers to 12-R6, do not rewrite those files.
2. PRODUCTION_TOP=UNKNOWN.
3. Do not close ASTRA-13, BOARD_PASS, LM06.

PROGRAM=NO.
