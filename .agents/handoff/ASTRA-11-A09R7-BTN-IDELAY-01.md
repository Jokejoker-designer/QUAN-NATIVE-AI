# ASTRA-11-A09R7-BTN-IDELAY-01

Parent dispatch 2026-09-07 after auditor 20260907T0500Z **FAIL_LOOP** on ASTRA-11-A09R7-BTN-IO-01.
P1: BTN pad hold `btn[*] → btn_q_reg[*]/D` vs clk50u Input Delay min 0.500, WHS=−2.068. New named bag. Do **not** retune 2.000/0.500 inside the FAIL bag. Do **not** `set_false_path` on `btn[*]`. Do **not** `set_false_path -hold` on BTN. Do not patch frozen A09-R2/uart. `phys_opt` exhausted.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-11-A09R7-BTN-IO-01 (keep fail_r0 + WHS=−2.068). Instantiate `a7ng_astra_09_r2_cand_ovf`. New named wrap.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-11-A09R7-BTN-IDELAY-01/ACK.json

## One unknown

With **IDELAYE2** on BTN0–BTN3, tap **frozen in PREREG before impl** (do not invent after WHS), same pins D9/C9/B9/B8 and same 2.000/0.500 related-clock delays, after implement+route at 50 MHz, is Design Timing Summary **WHS ≥ 0** as well as WNS ≥ 0 — without a bitstream and without false-path on btn?

## Required

1. PREREG freeze IDELAYE2 tap (and REFCLK policy) **before** impl. Keep 2.000/0.500. No set_false_path on btn.
2. Hash before impl. impl+route, no write_bitstream. Quote raw WNS **and** WHS. FAIL this bag if WHS<0. One bounded tap experiment if FAIL (new PREREG tap, not silent).
3. PRODUCTION_TOP=UNKNOWN. Do not close ASTRA-13, BOARD.

PROGRAM=NO.
