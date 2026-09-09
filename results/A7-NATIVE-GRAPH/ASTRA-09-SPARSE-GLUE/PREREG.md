# PREREG — ASTRA-09-SPARSE-GLUE

```text
GATE        = ASTRA-09-SPARSE-GLUE
ROLE        = SPARSE09_GLUE
BIT         = NO
PROGRAM     = NO
COM12       = UNTOUCHED
LM06        = LANGUAGE_UNPROVEN
QSE_LAW     = qse-v2-role-00 (LAW_SEL=1)
QSE_CONTROL = qse-v1-lexicon-hdc-00 UNCHANGED (SHA ede064f0…)
WALKER      = a7ng_query_axi_sparse + a7ng_sparse_dir_axi 4×4096
MEM         = a7ng_axi_mem_model behavioral (no MIG)
ENGINE      = a7ng_rel_engine_2hop loaded edges, not exam ROM
RANK        = a7ng_shared_rank_sgd_q8 freeze_i=1
```

## Residual this gate closes

ASTRA-09 PASS_NARROW omitted the sparse AXI walker. Master path:

```text
raw tokens → qse-v2-role-00 → sparse 4×4096 dir/post walk → 2-hop → frozen rank → evidence
```

Wire the missing sparse step in THIS clone. Do not retarget qse-v1 keys. Do not poke host winners.

## Primary unknown

Can one XSim path run UART-like bytes through `a7ng_query_axi_sparse` (`LAW_SEL=1`) into the 4×4096 AXI walker, then into `a7ng_rel_engine_2hop` on **loaded** edges, with directory AR count ≤ valid tables (no 0..N scan), `n_host_*=0`, reverse packets still distinct, payroll UNKNOWN, and A→C not stored?

## Mandatory cases

1. Role reverse packets still differ after glue (`pump supplies chiller` vs reverse).
2. Unrelated `payroll tax form` → emit 0 / UNKNOWN, not ANSWER.
3. 2-hop still requires loaded edges; A→C not stored.
4. `n_host_* = 0`.
5. Walker directory AR ≤ valid tables (no 0..N scan).

## Host may / must not

Host may: tokenize, build independent gold, load behavioral index image, compare logs.
Host must not: drive subject/object/winner/answer, poke walker keys, store exam pair A→C as a fact.

## Not claimed

Gate14, board, NLU, fullchip, LM language, 800k DDR graph, bitstream, COM12.

## Cuts (stop at first divergence)

| Cut | Fail code |
|-----|-----------|
| Reverse packet collapse | ROLE_COLLAPSE |
| Key/valid mismatch vs twin | KEY_MISMATCH |
| Payroll ANSWER or n_emit≠0 | UNRELATED_ANSWER |
| 1-hop A→C ANSWER | EXAM_PAIR_STORED |
| n_host≠0 | HOST_SEMANTIC_LEAK |
| Dir AR outside dir/post or > n_valid | HIDDEN_FULL_SCAN |
| Walker cand used as 2-hop answer | CANDIDATE_AS_ANSWER |
