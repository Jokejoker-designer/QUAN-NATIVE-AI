# ASTRA-10-RESOURCE-BOUND-01

Parent dispatch 2026-09-06 after auditor 20260906T1300Z ACCEPT_PARTIAL on ASTRA-09-INTEGRATED-PATH-01.
That bag CLOSED_NARROW XSim smoke. Master ASTRA-09 OPEN. Auditor residual 3: next XSim-class gate is ASTRA-07 / ASTRA-08 / ASTRA-10 — **not** silent 09 close. Parent chooses **ASTRA-10 resources** (no LM06 language, no 65536-scale overnight, no BOARD).

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/bitstream/write_bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-*, F3-*, ASTRA-06-*, ASTRA-09-INTEGRATED-PATH-01 bags or frozen RTL. Do not rerun their xsim scripts. Do not overwrite ASTRA-11 wrap-route timing bag.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-10-RESOURCE-BOUND-01/ACK.json

## One unknown

For `a7ng_astra_09_integ_path` (or a new named synth wrapper that **instantiates** that DUT, not a copy-paste) on xc7a100tcsg324-1, what are post-synth LUT/FF/BRAM/DSP and a WNS at a declared clock — without a bitstream?

## Required

1. Freeze PREREG: part xc7a100tcsg324-1, clock (50 MHz unless you justify), DUT instance name, synth-only (no write_bitstream).
2. Run Vivado synth (and optionally opt/place if you stay PROGRAM=NO and do not stream a bit). Save utilization + timing reports raw.
3. Compare to DESIGN_CANDIDATE / prior wrap-route BRAM=2 if the instance is comparable; do not claim BOARD_PASS or WNS of a different wrapper.
4. Hash RTL+XDC+tcl before synth. PROGRAM=NO.

Do not close ASTRA-11 SoC UART wrap, LM06, Master F3, persist DDR.

If synth FAIL: keep the log; one bounded re-run in this bag.
