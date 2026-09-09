# ASTRA-06-WARM-PERSIST-01

Parent dispatch 2026-09-06 after auditor 20260906T0920Z ACCEPT_PARTIAL on ASTRA-F3-R4-DISTINCT-HOLD-PHI-01.
F3R4 plumbing CLOSED_NARROW (unique hold HASH, npath=4). Master F3 remains OPEN (template knobs, not 10pp/CI). Parent **stops the F3 plant ladder** and takes the next distinct Master residual: ASTRA-06 warm persist / power-loss journal (F2R5 listed host sess_id reuse and power-loss journal OPEN).

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit. No DDR production claim.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01/R2/R3/R4/R5 or any F3 bags/RTL. Do not rerun their scripts. Do not patch frozen F2R2 SGD / F2R2–F2R5 / F3* integrators.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-06-WARM-PERSIST-01/ACK.json

## One unknown

After a modeled power-loss (`rst_n` that clears live FSM but **not** a persist store), do SGD weights and pending `{sess,gen,txn,phi,v_pred}` restore so a delayed matching reward still updates the **same** snapshot — and a pre-loss key without restore is stale?

## Required

1. Written persist contract: what survives rst_n (weights, pending key, phi copy, epoch) vs what does not (AXI ost, in-flight SGD).
2. Tests: persist enable → rst → reload → delayed reward commits with expected dw; persist disable → rst → same numeric {gen,txn} is n_stale; rst during SGD upd does not half-commit into persist; UNREL no stale proof after restore.
3. Instantiate frozen symmetric SGD (ISO +5). New named DUT/TB. Full-ID 20-bit identities if pending stores eids.
4. Do not claim DDR/MIG, ASTRA-07 index image, LM06, BOARD, Master F3 10pp.

PREREG + .svh hashes before xvlog. Raw XSim. One corrective if FAIL. No golden edits. PROGRAM=NO.
