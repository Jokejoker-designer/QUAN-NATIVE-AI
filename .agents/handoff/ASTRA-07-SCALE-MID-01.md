# ASTRA-07-SCALE-MID-01

Parent dispatch 2026-09-07 after auditor 20260907T0300Z ACCEPT_PARTIAL on ASTRA-12-R5-FREEZE-BRIEF-01.
PRODUCTION_TOP stays UNKNOWN (parent will not silent-freeze). ASTRA-13 stays BLOCKED. Board is plugged; PROGRAM=NO.

Next Master residual that still fits XSim: **ASTRA-07 scale-mid** — posting N=64 (> CAND_CAP=16) on instantiated frozen A09-R2 (INCOMP path already in A09-R2). Not 65536. Not 800k. Not BOARD.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-07-SCALE-NARROW-01, ASTRA-09-R2, frozen A09 leftover, 12-R5 brief. Instantiate `a7ng_astra_09_r2_cand_ovf`. New TB. Do not patch frozen RTL.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-07-SCALE-MID-01/ACK.json

## One unknown

With posting N=64 and CAND_CAP=16, does **A09-R2 itself** (not a wrap around leftover A09) publish INCOMP ans=0, and does smoke two-proof still ANSWER 4 after reset?

## Required

1. PREREG: N=64, CAND_CAP=16, expected DUT INCOMP. Frozen A09 leftover not the DUT.
2. Tests: overflow INCOMP ans=0 p0=0; smoke after reset ans=4 p0=17; UNREL no stale; ISO +5 if inner SGD reachable without force.
3. Do not claim ASTRA-07 65536/800k, BOARD, PRODUCTION_TOP freeze.
4. PROGRAM=NO. No JTAG/xsdb/COM12/write_bitstream.

SHA including .svh before xvlog. One corrective if FAIL.
