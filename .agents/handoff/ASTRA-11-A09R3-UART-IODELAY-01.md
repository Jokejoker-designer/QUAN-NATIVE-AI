# ASTRA-11-A09R3-UART-IODELAY-01

Parent dispatch 2026-09-06 after auditor 20260906T1730Z ACCEPT_PARTIAL on ASTRA-11-A09R3-UART-IMPL-ROUTE-01.
That bag CLOSED_NARROW WNS=+0.305 with UART IOB A9/D10. Residual 5: UART I/O unconstrained (no input/output delay; no IOB FF). New named bag. Do not patch the +0.305 route evidence. Do not freeze PRODUCTION_TOP.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R3-UART-IMPL-ROUTE-01 or frozen A09/A09-R2. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap/XDC.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IODELAY-01/ACK.json

## One unknown

With `set_input_delay` / `set_output_delay` on `uart_txd_in` A9 and `uart_rxd_out` D10 (values frozen in PREREG, board-UART-class, not invented after seeing WNS), after implement+route at 50 MHz, is WNS ≥ 0 — without a bitstream?

## Required

1. PREREG freeze delay numbers **before** impl. Hash XDC+RTL+tcl before impl.
2. impl+route, no write_bitstream. Quote routed WNS including UART I/O paths if they appear in timing.
3. If WNS<0: FAIL, keep report, one bounded delay/clock experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO.
