# ASTRA-11-A09-IMPL-ROUTE-01

Parent dispatch 2026-09-06 after auditor 20260906T1330Z ACCEPT_PARTIAL on ASTRA-10-RESOURCE-BOUND-01.
OOC synth WNS=+2.283 is **not** implemented timing. Residual 1: next physical evidence must be **implemented/routed** (clock-network), not OOC. Not BOARD. Not bitstream.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream/hw_server.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-10, ASTRA-09, ASTRA-11-SOC-WRAP*, F2R-*, F3-*, ASTRA-06-* bags or frozen RTL. Do not overwrite wrap-route WNS=+5.733 evidence. Instantiate `a7ng_astra_09_integ_path` (via ASTRA-10 wrap or new named top). Do not copy-paste the graph.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09-IMPL-ROUTE-01/ACK.json

## One unknown

After implement+route of that instantiated A09 path on xc7a100tcsg324-1 at a declared 50 MHz constraint (clock-network delay included), is WNS ≥ 0 — without a bitstream?

## Required

1. PREREG: part, clk period, top name, no write_bitstream.
2. Hash RTL+XDC+tcl before impl. Run impl+route. Save raw timing_summary and utilization.
3. Quote WNS/TNS/WHS from **routed** report Design State. Do not quote synth OOC WNS as this result.
4. If WNS < 0: FAIL the bag, keep the report, one bounded clock/constraint experiment in this bag. Do not program a failing bit.
5. PROGRAM=NO.

Do not close ASTRA-13, BOARD_PASS, SoC UART wrap, LM06, Master F3.
