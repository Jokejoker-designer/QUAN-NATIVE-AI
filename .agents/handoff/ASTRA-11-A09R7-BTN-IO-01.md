# ASTRA-11-A09R7-BTN-IO-01

Parent dispatch 2026-09-07 after auditor 20260907T0430Z ACCEPT_PARTIAL on ASTRA-12-R6-LED-CANDIDATES-01.
LED table CLOSED_NARROW. PRODUCTION_TOP stays UNKNOWN. ASTRA-13 BLOCKED. Board is plugged; PROGRAM=NO.

Next residual that still fits impl (not freeze, not 65536): **button I/O** on a new named wrap instantiating frozen A09-R2. Cite Arty A7 XDC in this clone for BTN0–BTN3. Freeze input delays in PREREG. implement+route, no bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R7-LED-IO-01, UART impl, 12-R6. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap. UART+LED pins may stay.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-BTN-IO-01/ACK.json

## One unknown

With BTN0–BTN3 mapped from the cited clone XDC plus frozen input delays, after implement+route at 50 MHz, is WNS ≥ 0 and WHS ≥ 0 — without a bitstream?

## Required

1. PREREG freeze button pinout + delays **before** impl. Cite clone XDC.
2. Hash before impl. impl+route, no write_bitstream. Quote raw WNS/WHS. io.rpt shows button IOB.
3. If WNS<0 or WHS<0: FAIL, keep report, one bounded experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO. No JTAG/xsdb/COM12.
