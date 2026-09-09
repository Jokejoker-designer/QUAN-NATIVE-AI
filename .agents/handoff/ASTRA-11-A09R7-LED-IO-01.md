# ASTRA-11-A09R7-LED-IO-01

Parent dispatch 2026-09-07 after auditor 20260907T0330Z ACCEPT_PARTIAL on ASTRA-07-SCALE-MID-01.
Scale-mid CLOSED_NARROW. Do not repeat N=64. PRODUCTION_TOP stays UNKNOWN. ASTRA-13 BLOCKED. Board is plugged; PROGRAM=NO.

Next residual that still fits impl (not 65536, not freeze): **LED I/O** on a new named wrap instantiating frozen A09-R2, Arty A7 LED pins, I/O delay frozen in PREREG, implement+route, no bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R7-UART-IMPL-ROUTE-01, scale-mid, frozen A09-R2. New named wrap. Instantiate `a7ng_astra_09_r2_cand_ovf`. UART D10/A9 may stay if the wrap is UART-class; add LEDs.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-LED-IO-01/ACK.json

## One unknown

With LD4–LD7 mapped (Digilent Arty A7: H5/J5/T9/T10 unless a cited XDC in this clone already uses another set — then use that cited set) plus frozen LED I/O delays, after implement+route at 50 MHz, is WNS ≥ 0 and WHS ≥ 0 — without a bitstream?

## Required

1. PREREG freeze LED pinout + delay numbers **before** impl. Cite Arty A7 master XDC in this clone if present.
2. Hash before impl. impl+route, no write_bitstream. Quote raw WNS/WHS. io.rpt shows LED IOB.
3. If WNS<0 or WHS<0: FAIL, keep report, one bounded experiment, still no bit.
4. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD, LM06.

PROGRAM=NO. No JTAG/xsdb/COM12.
