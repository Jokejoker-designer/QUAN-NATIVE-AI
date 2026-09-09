# ASTRA-F3-R4-DISTINCT-HOLD-PHI-01

Parent dispatch 2026-09-06 after auditor 20260906T0850Z ACCEPT_PARTIAL on ASTRA-F3-R3-SAMPLED-WORLDS-01.
R3 plumbing CLOSED_NARROW. Master F3 OPEN: eight holds were dest-remaps of **one** hold φ (`HASH=42d33003` × 8); shared/private facts never entered `npath`.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01/R2/R3/R4/R5, F3, F3-R2, or F3-R3 bags/RTL. Do not rerun their scripts. Do not patch frozen F2R2 SGD or those integrators.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-F3-R4-DISTINCT-HOLD-PHI-01/ACK.json

## One unknown

If each hold query has a **distinct** 32-φ HASH on the raw log, and shared/private facts participate in legal `npath`, do shared non-ID weights still beat no-update and mixed_ctx-mislabeled shuffle?

## Required (auditor 0850Z residuals 1–2, plus 6)

1. ≥8 hold queries: **unique** `HASH=` line per hold on xsim.log (not one hash copied 8×). PHI_NEQ vs train still required.
2. ≥5 train worlds: unique train HASH per world (not one train φ copied across directory keys).
3. Shared and/or private facts must appear in `npath` when they form legal hops (`npath` not stuck at 2 if extra legal 2-hops exist). Fifth path still INCOMP if beyond cap.
4. Dump 32-φ + HASH on the log for train and hold.
5. Shuffle still mislabels overlapping transferable features.
6. Freeze Master 10pp/CI before xvlog if claiming; otherwise PREREG leaves Master F3 OPEN. Do not claim ASTRA-07 24×8 unless run. Do not lower thresholds after scores.

Instantiate frozen symmetric SGD. New named DUT/TB. SHA including .svh before xvlog. One corrective if FAIL. No golden edits. Do not close LM06/BOARD.

PROGRAM=NO.
