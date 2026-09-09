# ASTRA-F3-R3-SAMPLED-WORLDS-01

Parent dispatch 2026-09-06 after auditor 20260906T0815Z ACCEPT_PARTIAL on ASTRA-F3-R2-INDEPENDENT-WORLDS-01.
F3R2 plumbing CLOSED_NARROW. Master F3 OPEN: unit of analysis is still 5 designed 2-path plants.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01/R2/R3/R4/R5, ASTRA-F3-SHARED-TRANSFER-01, or ASTRA-F3-R2-INDEPENDENT-WORLDS-01 bags/RTL.
Do not rerun their run scripts. Do not patch frozen F2R2 SGD or F2R2–F2R5 / F3R2 integrators.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-F3-R3-SAMPLED-WORLDS-01/ACK.json

## One unknown

On a **sampled** held-out protocol (shared+private facts, overlapping IDs allowed), do FPGA shared non-ID weights beat no-update and a shuffle that mislabels the transferred overlapping features — with accuracy, coverage, UNKNOWN, and uncertainty frozen before xvlog?

## Required (auditor 0815Z residuals 1–4, 6)

1. World generator: distinct subject-relation worlds, not hop/ctx tweaks of one query. Shared facts + private facts. Freeze N_worlds, N_hold_queries, epoch count in PREREG (≥8 hold queries if 24×8 ASTRA-07 does not fit this bag; do not claim ASTRA-07 scale unless actually run).
2. Shuffle: permute φ→reward on a stream where overlapping transferable features get the wrong label (S3-style at least; not only +3 on a distractor that lacks those features).
3. Per-ID: dest/eid-keyed predictor with **overlapping** IDs where it could win; keep it off shared `w`.
4. Retention: held-out after ≥2 epochs and a reload, on that sampled protocol.
5. Dump 32-φ or a hash of φ on the log for hold vs train (not TB-internal only).
6. Freeze Master 10pp / paired CI / retention≤5pp **before xvlog** if claiming Master F3. If the protocol is still too small, PREREG must leave Master F3 OPEN and cap PASS_NARROW. Do not print Wilson on n=5 designed plants as Master confirmation. Do not lower thresholds after scores.

Instantiate frozen symmetric SGD. New named DUT/TB. SHA including .svh before xvlog. One corrective if FAIL. No golden edits.

Do not close LM06/BOARD/ASTRA-13/DDR production retrieval.

PROGRAM=NO.
