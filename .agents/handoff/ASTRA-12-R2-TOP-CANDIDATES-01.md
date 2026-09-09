# ASTRA-12-R2-TOP-CANDIDATES-01

Parent dispatch 2026-09-06 after auditor 20260906T1430Z ACCEPT_PARTIAL on ASTRA-12-PREPROGRAM-PACK-01.
PRODUCTION_TOP stays UNKNOWN until a **named freeze**. Parent does **not** pick a top. This bag only **tables existing routed candidates** with hashes/WNS/IOB/UART. PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-12-PREPROGRAM-PACK-01, ASTRA-11-A09-IMPL-ROUTE-01, ASTRA-SOC-RTP-WRAP-ROUTE, ASTRA-11-SOC-WRAP*. Do not rerun impl. Do not generate a .bit. Do not write PRODUCTION_TOP= a module name.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-R2-TOP-CANDIDATES-01/ACK.json

## One unknown

What are the existing **routed** tops already in this clone (name, bag, WNS from raw timing, UART pins present?, IOB count, bit built?) — with hashes — while PRODUCTION_TOP remains UNKNOWN?

## Required

1. CANDIDATES.md table, at least:
   - `a7ng_astra_11_a09_impl_wrap` / ASTRA-11-A09-IMPL-ROUTE-01 / WNS from timing_route.rpt
   - wrap-route SoC UART top (`arty_a7_astra_rtp_soc_top` or actual module in that bag) / ASTRA-SOC-RTP-WRAP-ROUTE / WNS from that bag’s routed report
2. Quote UART pin names from each XDC if present (D10/A9 or absent).
3. PRODUCTION_TOP=UNKNOWN in ACK/RESULTS/CLOSEOUT.
4. No write_bitstream. No freeze of a winner.

Do not close ASTRA-13, BOARD_PASS, LM06, Master F3.
