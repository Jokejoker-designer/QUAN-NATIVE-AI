# ASTRA-06-R3-MULTI-SLOT-01

Parent dispatch 2026-09-06 after auditor 20260906T1125Z ACCEPT_PARTIAL on ASTRA-06-R2-EVICT-HIGHID-01.
R2 CLOSED_NARROW high-id + reload_i + persist N=1. Master ASTRA-06 OPEN. Next leftover that still fits XSim: **N>1 persist slots**. Not DDR. Not BOARD.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-06-WARM-PERSIST-01, ASTRA-06-R2-EVICT-HIGHID-01, F2R-*, F3-* bags/RTL. Do not patch a7ng_astra_06_warm_persist.sv or a7ng_astra_06_r2*.sv. Do not rerun their scripts.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-06-R3-MULTI-SLOT-01/ACK.json

## One unknown

With persist capacity N≥2, can two committed snapshots keep distinct {txn,phi,20-bit eids,w-delta target}, restore independently after rst, and evict a written victim when a third commit arrives — without mixing delayed rewards across slots?

## Required

1. PREREG: CAP_N≥2, eviction victim (oldest committed / lowest txn), refuse policy if all uncommitted.
2. Tests: two PICKs + two commits → two persist rows; rst+reload; delayed rew for txn A updates only A’s phi; delayed rew for txn B updates only B; third commit evicts victim; high-bit eids still ≥256.
3. ISO +5, UNREL no stale proof. Frozen SGD instantiated. New named DUT/TB.
4. Do not close DDR, QSPI, Master F3, LM06, BOARD.

SHA including .svh before xvlog. Raw XSim. One corrective if FAIL. No golden edits. PROGRAM=NO.
