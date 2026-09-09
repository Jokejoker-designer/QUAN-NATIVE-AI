# ASTRA-12-PREPROGRAM-PACK-01

Parent dispatch 2026-09-06 after auditor 20260906T1400Z ACCEPT_PARTIAL on ASTRA-11-A09-IMPL-ROUTE-01.
Routed WNS=+1.041 ≥ 0 on named A09 wrap. **Not** BOARD_PASS. **Not** ASTRA-13. Auditor residual: do not silent-close ASTRA-11/13; remaining is production top / bitstream policy / board. Parent chooses **ASTRA-12 pre-program pack** (Master DAG), still PROGRAM=NO.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream/hw_server/fpga.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09-IMPL-ROUTE-01, ASTRA-11-SOC-WRAP*, wrap-route, ASTRA-09, F2R-*, F3-*, ASTRA-06-* bags. Do not rerun impl/xsim scripts that wipe logs. Do not generate a .bit.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-12-PREPROGRAM-PACK-01/ACK.json

## One unknown

Can a frozen evidence pack list, with hashes, the routed A09 wrap WNS, the A09 XSim marker, persist/handshake bags, and **explicit missing items** (UART/LED I/O, SoC top identity, bitstream, auditor ACCEPT_BOARD) — without claiming BOARD_PASS?

## Required

1. PACK.md + SHA256 of: ASTRA-11-A09-IMPL-ROUTE-01 timing_route.rpt (quote WNS), ASTRA-09 xsim.log marker, ASTRA-10 util_synth, ASTRA-06-R4 sess reuse marker. Copy hashes, do not rewrite those files.
2. MISSING.md: UART, pinout vs wrap-route SoC top, bitstream SHA, ASTRA-13, LM06, Master F3 10pp.
3. POLICY.md: PROGRAM=NO until ASTRA-13 + owner + WNS≥0 on **the frozen production top** + auditor ACCEPT_BOARD. A09 wrap WNS=+1.041 is **not** that top (SoC UART wrap remains a different bag).
4. No write_bitstream. No JTAG.

If you cannot freeze a production top identity, say so. Do not pick a top silently.
