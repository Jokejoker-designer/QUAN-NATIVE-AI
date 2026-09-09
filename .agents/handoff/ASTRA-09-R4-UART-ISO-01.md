# ASTRA-09-R4-UART-ISO-01

Parent dispatch 2026-09-06 after auditor 20260906T1930Z ACCEPT_PARTIAL on ASTRA-12-R3-UART-WRAP-CANDIDATES-01.
Candidate table CLOSED_NARROW. PRODUCTION_TOP stays UNKNOWN (parent will not silent-freeze). ASTRA-13 stays BLOCKED. Board is plugged; PROGRAM=NO.

T1700 residual 6: ISO_P3 was not replayed on the UART byte stream. This bag is **UART-facing ISO** of frozen A09-R2 SGD law (+3, x0=50 → dw0=+5), not a bit, not a freeze.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-09-R3-UART-XSIM-01, ASTRA-12-R3, UART impl bags, frozen A09-R2/SGD. Instantiate frozen SGD + A09-R2 or UART wrap. New named TB. Do not rerun impl.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-09-R4-UART-ISO-01/ACK.json

## One unknown

Can UART 8N1 (or the existing UART wrap path) deliver an isolated SGD update x[0]=50 rew=+3 and show w0=+5 (and x[0]=64 rew=-3 → w0=-6) on the result stream or hierarchical w_o — with load_from_tb=0 — without claiming BOARD_PASS?

## Required

1. ISO_P3 and ISO_M3 on the UART-facing path. Quote raw log w0.
2. load_from_tb=0. PRODUCTION_TOP=UNKNOWN.
3. Do not close ASTRA-13, BOARD, silicon UART, wrap-route bit.
4. PROGRAM=NO. No JTAG/xsdb/COM12/write_bitstream.

SHA including .svh before xvlog. One corrective if FAIL.
