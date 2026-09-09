# ASTRA-11-A09R7-SW-IO-01

Parent dispatch 2026-09-07 after auditor 20260907T0600Z ACCEPT_PARTIAL on ASTRA-12-R7-BTN-CANDIDATES-01.
BTN table CLOSED_NARROW. PRODUCTION_TOP stays UNKNOWN. ASTRA-13 BLOCKED. Board is plugged; PROGRAM=NO.

Next residual that still fits impl (not freeze): **slide-switch I/O** on a new named wrap instantiating frozen A09-R2. Cite Arty A7 XDC in this clone for SW0–SW3. Freeze input delays in PREREG. implement+route, no bitstream. If pad hold fails like BTN, FAIL this bag honestly (do not false-path sw).

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R7-BTN-IDELAY-01, BTN-IO FAIL bag, LED bag, 12-R7. Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-SW-IO-01/ACK.json

## One unknown

With SW0–SW3 mapped from the cited clone XDC plus frozen input delays 2.000/0.500, after implement+route at 50 MHz, is WNS ≥ 0 and WHS ≥ 0 — without a bitstream and without set_false_path on sw[*]?

## Required

1. PREREG freeze switch pinout + delays **before** impl. Cite clone XDC. No set_false_path on sw.
2. Hash before impl. impl+route, no write_bitstream. Quote raw WNS **and** WHS. FAIL this bag if WHS<0. One bounded IDELAY experiment if FAIL (new PREREG tap).
3. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD.

PROGRAM=NO. No JTAG/xsdb/COM12.
