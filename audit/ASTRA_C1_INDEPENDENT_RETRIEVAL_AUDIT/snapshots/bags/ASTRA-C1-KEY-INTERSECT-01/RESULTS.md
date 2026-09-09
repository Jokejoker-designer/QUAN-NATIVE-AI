# RESULTS — ASTRA-C1-KEY-INTERSECT-01

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK /
`ASTRA_C1_KEY_INTERSECT_XSIM_PASS`. This file does not promote C1 800k,
N=4096, or BOARD_PASS.

```text
GATE             = ASTRA-C1-KEY-INTERSECT-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW              = qse-v2-intersect-01
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
INTERSECT        = emit k0∩k1 when both valid; k2/k3 not probed; no k0∪k1 union
k0,k1            = {subj,rel}/{obj,rel}  (direct 2561 / 257)
k2,k3            = relbind 510 / 312 (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_intersect, tb_astra_c1_key_intersect)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (10:16:50, before first xvlog 10:17:22)
GOLD_LIVE        = MATCH d3b5b883… / f1611917… / e8b4f8ea…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no DISTRACTOR_LEAK)
XSIM_MARKER      = ASTRA_C1_KEY_INTERSECT_XSIM_PASS emitted
SIM_TIME         = 18105 ns
PID              = 51140
SESSION          = Mon Sep 7 10:17:26–10:17:28 2026
XSIM_SHA         = 4b17320d3692777f22393d936bab2e5db1513ec296d020a5c5d7c1cb27747b4b
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_4096           = NOT STARTED
BOARD_PASS       = NOT_CLAIMED
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` gold hash 414f9952…
- KEEP `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` gold hash e2091bac…
- KEEP `ASTRA-C1-N256-R3-DISTRACTOR-01` gold hash 96f445a9…
- KEEP `ASTRA-C1-KEY-RELBIND-01` gold hash 0f1ba57a…

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL DISTRACTOR_LEAK). Gold was **not** regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.

NEW RTL `a7ng_query_axi_sparse_intersect.sv` SHA `a912786f…`. Relbind keys
unit SHA `93811ed1…` (instantiated, not edited).

## Unknown (this bag)

At N=256, new law `qse-v2-intersect-01` (emit ids in k0∩k1 when both keys
valid), does CLASS_distractor `leak_n=0` on R3 excluded gold while
CLASS_direct still retrieves its gold ids (expect `{110,144,145}`)?

Direct retrieve: **yes** (`tp=3` of gold `{110,144,145}`; `rec_x1000=1000`;
`prec_ev1_x1000=1000`).

Entity-context exclusion (`leak_n=0`): **yes** (`leak_n=0/11`; `tp=0`;
`rec_undef`; gold_polarity=excluded). Excluded nids
`{99,108,109,111,114,118,121,132,193,214,235}` are not in emit.
Emit is PSC `{110,144,145}` (same as CLASS_direct; not leaks).

Gate requires `leak_n=0` **and** direct gold hits >0 for
`PASS_THIS_GATE_ONLY`. Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, N=4096, Master evidence-recall ≥95%, or
candidate-reduction ≥90%.

## Per-class (authority = xsim.log)

Quality number is **precision** (`prec_ev1` excludes evidence=0 fillers).
Recall on 1–3 retrieve-class gold ids inside CAND_CAP is not the quality
headline at Master 800k. Direct `prec_ev1=1000` is k0∩k1 (conjunctive),
not a numeric `reduction_x1000=1-CAND_CAP/N`.

| class | gold_n | emit_n | tp | leak_n | fp_ev1 | fp_fill0 | prec_ev1 | prec_all | rec | notes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 3 | 3 | — | 0 | 0 | 1000 | 1000 | 1000 | gold hits>0; emit `{110,144,145}` |
| paraphrase | 3 | 3 | 3 | — | 0 | 0 | 1000 | 1000 | 1000 | same walk as direct |
| role_reversal | 1 | 1 | 1 | — | 0 | 0 | 1000 | 1000 | 1000 | emit `{146}` |
| wrong_relation | 1 | 1 | 1 | — | 0 | 0 | 1000 | 1000 | 1000 | emit `{114}`; k1 trunc=12 |
| wrong_context | 1 | 3 | 1 | — | 2 | 0 | 333 | 333 | 1000 | **NOT_SELECTIVE** (xid still not a key) |
| distractor | 11 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | undef | **EXCLUDED**; leak_n=0; emit is PSC not excluded |
| unrelated | 0 | 0 | 0 | — | 0 | 0 | — | — | — | **UNRELATED_EMPTY_WALK** |
| high_occupancy | 1 | 12 | 1 | — | 0 | 11 | 1000 | 83 | 1000 | fillers counted separately; occ=28>16 |
| overflow_page | 1 | 5 | 1 | — | 0 | 4 | 1000 | 200 | 1000 | gold 172 in emit; ovf=1 |
| high_id_sentinel | 1 | 1 | 1 | — | 0 | 0 | 1000 | 1000 | 1000 | id 255 present |

## Not claimed

```text
C1_800K
N_4096
CAND_CAP_FINAL
BOARD_PASS
ACCEPT_BOARD
ASTRA-13
PRODUCTION_TOP
Master_evidence_recall_ge95
Master_candidate_reduction_ge90
relevant=router_union
nid-derived keys
threshold drop
silent C0 patch
k2/k3-only rebind as exclusion
reduction_x1000 as 1-CAND_CAP/N
wrong_context as context-selectivity win
```
