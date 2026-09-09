# ASTRA-F3-SHARED-TRANSFER-01

Parent dispatch 2026-09-06 after auditor 20260906T0705Z ACCEPT_PARTIAL on ASTRA-F2R-R5-TXN-WRAP-RESET-01 (F2R_ACCEPTANCE item 6 CLOSED narrow). F2R items 1–5 already auditor PASS_NARROW on their bags. Next Master residual: shared-learner held-out transfer (Master §8 Transfer), **not** board.

Sole implementer. PROGRAM=NO. No JTAG/COM12/bit.

Root D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1

## Preserve

Do not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`).
Do not rerun their run scripts.

## ACK first

results/A7-NATIVE-GRAPH/ASTRA-F3-SHARED-TRANSFER-01/ACK.json

## One unknown

After one (or few) FPGA-owned reward updates on train worlds, do shared non-ID features improve held-out selection vs (a) no-update and (b) shuffled-reward, on ≥5 **independent** seeds — not 5 ID-permutations of one plant?

## Required

1. Freeze PREREG: seed list, train vs hold-out split, metrics (selective accuracy, coverage, UNKNOWN on unrelated), controls (no-update, shuffled reward, per-ID if claimed). Freeze Master transfer numbers if you will claim them: gain ≥10pp vs no-update, paired CI lower bound >0, retention drop ≤5pp. If the experiment cannot meet that, say so in PREREG and cap the claim at PASS_NARROW plumbing; **do not** lower thresholds after seeing scores.
2. Worlds must differ in relation/mid/support structure or role/context, not only eid XOR / ID permutation.
3. Features remain non-ID (quality/flags/object-context as already legal). No gold, class-winner, proof index.
4. Instantiate frozen symmetric SGD (ISO +3,x0=50 → dw0=+5). New named ranker/TB only.
5. Report accuracy, coverage, uncertainty separately. UNKNOWN must reject unrelated queries.
6. Do not close LM06, BOARD, persistence/DDR, ASTRA-13.

## Evidence

Hashes including .svh before xvlog. Raw XSim. First divergence. RESULTS/CLOSEOUT. If FAIL: keep fail log; one corrective; never edit goldens.

PROGRAM=NO. Do not open another gate after this bag.
