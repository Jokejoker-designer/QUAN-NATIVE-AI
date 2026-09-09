# ASTRA-06-R4-SESS-REUSE-01

Parent dispatch 2026-09-06 after auditor 20260906T1200Z ACCEPT_PARTIAL on ASTRA-06-R3-MULTI-SLOT-01.
R3 CLOSED_NARROW on-chip CAP_N=2. Master ASTRA-06 OPEN. Next leftover that still fits XSim: **host sess_id reuse after rst without restore**. Not DDR. Not BOARD.

Board is plugged. **PROGRAM=NO.** No JTAG/xsdb/COM12/bitstream.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-06-WARM-PERSIST-01, R2, R3, F2R-*, F3-* bags/RTL. Do not patch those DUT files. Do not rerun their scripts.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-06-R4-SESS-REUSE-01/ACK.json

## One unknown

After rst_n, if the host reuses the same `sess_id_i` **without** a persist restore, is a delayed reward with that sess+txn **n_stale / refused** — while restore with matching sess still commits the snapshot?

## Required

1. Written sess lifetime: sess_id is part of the pending/persist key; rst without restore must not accept a replay of the pre-rst {sess,txn} as if it were a new live pending.
2. Tests: persist+rst+reload matching sess → delayed rew commits; persist+rst **no restore**, host drives same sess_id → delayed rew n_stale; new sess_id after rst without restore does not pull old weights; UNREL no stale proof; ISO +5.
3. Instantiate frozen SGD. New named DUT/TB. Keep 20-bit eids if pending stores them.
4. Do not close DDR, QSPI, Master F3, LM06, BOARD.

SHA including .svh before xvlog. Raw XSim. One corrective if FAIL. No golden edits. PROGRAM=NO.
