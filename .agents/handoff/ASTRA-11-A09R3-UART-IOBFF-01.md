# ASTRA-11-A09R3-UART-IOBFF-01

Parent dispatch 2026-09-06 after auditor 20260906T1800Z ACCEPT_PARTIAL on ASTRA-11-A09R3-UART-IODELAY-01.
That bag CLOSED_NARROW WNS=+0.681 with delays 2.000/0.500. Residual 5: IOB FF pack (and optional LED I/O delay). New named bag. Do not patch the +0.681 evidence. Do not freeze PRODUCTION_TOP.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R3-UART-IODELAY-01, UART-IMPL-ROUTE, frozen A09/A09-R2. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap/XDC.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IOBFF-01/ACK.json

## One unknown

With UART IOB FFs packed (`IOB=TRUE` or equivalent on `uart_txd_in` / `uart_rxd_out`) plus the same frozen delays 2.000/0.500, after implement+route at 50 MHz, is WNS ≥ 0 — without a bitstream?

## Required

1. PREREG: IOB FF policy + keep delays 2.000/0.500. Hash before impl.
2. impl+route, no write_bitstream. Quote routed WNS. io.rpt shows IOB FF / IOB register if Vivado packed them.
3. If WNS<0: FAIL, keep report, one bounded experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO.
