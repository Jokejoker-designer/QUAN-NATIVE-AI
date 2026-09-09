# ASTRA-F2R-R3-SEMANTIC-GUARD-01

Parent dispatch 2026-09-06 after auditor 20260906T0530Z ACCEPT_PARTIAL on ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW.

You are ONE implementer. No extra sessions. PROGRAM=NO. No JTAG/COM12/bitstream.

Root: D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
Branch grok-orch/astra-native-v1-00 base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

- Do not edit ASTRA-F2R-SHARED-RANK-PENDING-01 or ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW evidence/RTL.
- Do not patch a7ng_astra_f2r2_hs_law.sv or a7ng_shared_rank_sgd_q8_sym_f2r2.sv.
- Do not rerun run_f2r.ps1 or run_f2r2.ps1 (wipes logs).
- Instantiate the frozen F2R2 SGD by name if needed, or copy to a new module name. Do not change the integer law.

## ACK first

Write ACK.json in results/A7-NATIVE-GRAPH/ASTRA-F2R-R3-SEMANTIC-GUARD-01/ before RTL. If another writer exists, stop.

## One unknown

Can the FPGA refuse to rank away contradiction, honor query object/context/polarity, distinguish direct vs 2-hop, and declare incomplete when a fifth legal path exists — without using IDs/gold as features and without breaking F2R2 handshake/law regressions?

## Required (F2R_ACCEPTANCE item 4 only)

1. Latch and use query object and context, not only subject/relation.
2. Proof legality independent of score. Do not rank away two contradictory conclusions; emit declared conflict/ambiguity/incomplete before selection.
3. Tests: wrong-object; direct-vs-indirect; opposing polarity/context; fifth legal path (must not silent-drop as if only four exist).
4. Keep F2R2 smoke: two same-conclusion 2-hops, handshake latch still works, UNREL no stale proof, ISO law still +5 on +3,x0=50 if SGD is in the path.
5. Features still not query/answer/entity ID, proof index, class-byte, or gold.

Do **not** close item 5 (post-timeout AXI), F3, LM06, BOARD.

## Evidence

PREREG + schema + hashes including .svh before xvlog. Raw XSim, first divergence, RESULTS/CLOSEOUT. If FAIL: keep the fail log; one bounded corrective in this bag. Never edit goldens to pass.

Finish with evidence. Do not open another gate. PROGRAM=NO.
