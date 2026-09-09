# ASTRA-11-A09R3-UART-IOBFF-HOLD-01

Parent dispatch 2026-09-06 after auditor 20260906T1830Z ACCEPT_PARTIAL on ASTRA-11-A09R3-UART-IOBFF-01.
That bag CLOSED_NARROW for WNS≥0 + IOB FF packed. Residual 2: UART IOB input **hold** vs virtual `uart_io_vclk` WHS=−4.915. New named bag. Do **not** retune frozen 2.000/0.500 inside the +0.115 bag. Do not patch `uart_rx.sv`. Do not freeze PRODUCTION_TOP.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R3-UART-IOBFF-01 or frozen A09/A09-R2/uart_rx. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap/XDC.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R3-UART-IOBFF-HOLD-01/ACK.json

## One unknown

Can a **new** STA envelope (frozen in PREREG before impl: false-path-hold, async UART exception, extra IOB sample, or a different virtual clock — pick one and write it) keep IOB FFs packed and make Design Timing Summary **WHS ≥ 0** as well as WNS ≥ 0 — without a bitstream and without claiming BOARD_PASS?

## Required

1. PREREG freeze the hold policy **before** impl. Do not copy-paste 2.000/0.500 min delay then hide WHS.
2. Hash before impl. impl+route, no write_bitstream.
3. Quote raw Design Timing Summary WNS **and** WHS. FAIL this bag if WHS<0. One bounded experiment if FAIL.
4. IOB FF still packed. PRODUCTION_TOP=UNKNOWN.

PROGRAM=NO.
