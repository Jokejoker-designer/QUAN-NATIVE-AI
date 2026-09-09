# ASTRA-06-R2-EVICT-HIGHID-01

Parent dispatch 2026-09-06 after auditor 20260906T0945Z ACCEPT_PARTIAL on ASTRA-06-WARM-PERSIST-01.
That bag CLOSED_NARROW modeled rst_n persist. Master ASTRA-06 OPEN: high-bit IDs untested, reload_i untested, capacity/eviction OPEN, schemaV2/migration OPEN, DDR OPEN.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit. No DDR/NVM claim.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit ASTRA-06-WARM-PERSIST-01, F2R-*, or F3-* bags/RTL. Do not rerun their scripts. Do not patch frozen F2R2 SGD or a7ng_astra_06_warm_persist.sv.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-06-R2-EVICT-HIGHID-01/ACK.json

## One unknown

Can persist store 20-bit eids with bits[19:8] nonzero, honor an explicit `reload_i`, and evict/refuse a second pending when capacity=1 (or N slots with a written eviction policy) — without silent [7:0] slice or half-commit?

## Required (auditor 0945Z residuals 2, 7, capacity)

1. Plant and persist proof eids ≥ 256 (e.g. 20'hA0011). After restore, proof ports / persist_*_o must show the full 20-bit value.
2. Pulse `reload_i` as a distinct path from auto `need_rl` after rst; delayed matching reward still commits.
3. Written capacity N (PREREG). Test: second live pending while first uncommitted → refuse or evict per policy; persist must not keep two committed snapshots if N=1.
4. Optional schema byte: foreign VER does not restore into live weights.
5. Keep ISO +5, UNREL no stale proof, persist-disable stale. Instantiate frozen SGD. New named DUT/TB.

Do not close Master F3 10pp, LM06, BOARD, DDR, QSPI.

PREREG + .svh hashes before xvlog. Raw XSim. One corrective if FAIL. No golden edits. PROGRAM=NO.
