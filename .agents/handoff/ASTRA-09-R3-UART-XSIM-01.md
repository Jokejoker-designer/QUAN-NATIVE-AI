# ASTRA-09-R3-UART-XSIM-01

Parent dispatch 2026-09-06 after auditor 20260906T1630Z ACCEPT_PARTIAL on ASTRA-11-A09R2-IMPL-ROUTE-01.
Routed WNS=+0.648 on A09R2 wrap. PRODUCTION_TOP stays UNKNOWN. Parent does **not** freeze a top and does **not** open ASTRA-13. Residual 5 mentions SoC UART wrap as a *candidate* production path. This bag is **XSim UART glue around instantiated A09-R2**, not a bit, not a freeze.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R2-IMPL-ROUTE-01, ASTRA-SOC-RTP-WRAP-UART-XSIM, frozen A09, A09-R2 DUT source. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named UART TB/wrap. Do not rerun impl scripts. No .bit.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R3-UART-XSIM-01/ACK.json

## One unknown

Can a UART-side XSim (UNISIM or behavioral host) drive tokens into instantiated A09-R2 and observe a smoke ANSWER / overflow INCOMP on the byte stream — with load_from_tb=0 — without claiming BOARD_PASS?

## Required

1. Instantiate frozen A09-R2 DUT (hash 15a919f1… or live SHA256 of that file). New named wrap/TB.
2. Tests: smoke two-proof visible on UART-facing result bytes or status; CAND_CAP overflow INCOMP ans=0; UNREL no stale; load_from_tb=0.
3. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06, wrap-route bit.
4. PROGRAM=NO.

SHA including .svh before xvlog. One corrective if FAIL.
