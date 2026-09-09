# RESULTS — ASTRA-C1-N4096-INTERSECT-01

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK /
SEARCH_INCOMPLETE / `ASTRA_C1_N4096_INTERSECT_XSIM_PASS`. This file does
not promote C1 800k, N=16384, or BOARD_PASS.

```text
GATE             = ASTRA-C1-N4096-INTERSECT-01
N                = 4096
CAND_CAP         = 16   (< 4096; not CAND_CAP_FINAL)
LAW              = qse-v2-intersect-01
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
INTERSECT        = emit k0∩k1 when both valid; k2/k3 not probed; no k0∪k1 union
                   DUT a7ng_query_axi_sparse_intersect hash MATCH KEY-INTERSECT a912786f…
k0,k1            = {subj,rel}/{obj,rel}  (direct 2561 / 257)
k2,k3            = relbind 510 / 312 (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
MEM_DEPTH        = 65536 (TB-only; fits 4096-record index; G_N_WR=4308)
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_intersect, tb_astra_c1_n4096_intersect)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (10:46:42, before first xvlog 10:47:33)
GOLD_LIVE        = MATCH 095ca715… / 3f1fa714… / b21e55f4…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no DISTRACTOR_LEAK)
XSIM_MARKER      = ASTRA_C1_N4096_INTERSECT_XSIM_PASS emitted
SIM_TIME         = 35585 ns
PID              = 29188
SESSION          = Mon Sep 7 10:47:58–10:48:02 2026
XSIM_SHA         = a96552edb667dd81c0d51aee690922886e8429725bc3176d9571cfa15cb080c0
REDUCTION_X1000  = NOT_EMITTED
POSTING_SELECTIVITY = labeled emit_vs_posting_occupancy (not 1-16/4096)
C1_800K          = OPEN
N_16384          = NOT THIS BAG
BOARD_PASS       = NOT_CLAIMED
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` gold hash 414f9952…
- KEEP `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` gold hash e2091bac…
- KEEP `ASTRA-C1-N256-R3-DISTRACTOR-01` gold hash 96f445a9…
- KEEP `ASTRA-C1-KEY-RELBIND-01` gold hash 0f1ba57a…
- KEEP `ASTRA-C1-KEY-INTERSECT-01` gold hash d3b5b883…

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL DISTRACTOR_LEAK). Gold was **not** regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.

DUT `a7ng_query_axi_sparse_intersect.sv` SHA `a912786f…` MATCH KEY-INTERSECT
(instantiated, not edited). Relbind keys unit SHA `93811ed1…` (instantiated,
not edited).

## Unknown (this bag)

At N=4096, same law `qse-v2-intersect-01` (emit ids in k0∩k1 when both keys
valid) + independent gold + required classes, does CLASS_distractor
`leak_n=0` on excluded gold AND CLASS_direct still retrieve gold AND no
`CAND_CAP>=N` as selectivity?

Direct retrieve: **yes** (`tp=3` of gold `{296,393,394}`; `rec_x1000=1000`;
`prec_ev1_x1000=1000`).

Entity-context exclusion (`leak_n=0`): **yes** (`leak_n=0/22`; `tp=0`;
`rec_undef`; gold_polarity=excluded). Excluded nids are not in emit.
Emit is PSC `{296,393,394}` (same as CLASS_direct; not leaks).

`CAND_CAP>=N` selectivity: **no** (`CAND_CAP=16 < 4096`).

Gate requires `leak_n=0` **and** direct gold hits >0 for
`PASS_THIS_GATE_ONLY`. Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, N=16384, Master evidence-recall ≥95%, or
candidate-reduction ≥90% as `1-16/4096`. Posting-selectivity is reported
as emit vs posting occupancy, labeled.

Scale observation (not a FAIL of this unknown): CLASS_high_id_sentinel
nid 4095 is beyond CAND_CAP prefix (`SEARCH_INCOMPLETE` missed=1 trunc=182
ovf=1 emit_n=0). That is named incomplete, never a false UNKNOWN.

## Per-class (authority = xsim.log)

Quality number is **precision** (`prec_ev1` excludes evidence=0 fillers).
Recall on 1–3 retrieve-class gold ids inside CAND_CAP is not the quality
headline at Master 800k. Direct `prec_ev1=1000` is k0∩k1 (conjunctive),
not a numeric `reduction_x1000=1-CAND_CAP/N`.

| class | gold_n | emit_n | tp | leak_n | fp_ev1 | fp_fill0 | prec_ev1 | prec_all | rec | notes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 3 | 3 | — | 0 | 0 | 1000 | 1000 | 1000 | gold hits>0; emit `{296,393,394}` |
| paraphrase | 3 | 3 | 3 | — | 0 | 0 | 1000 | 1000 | 1000 | same walk as direct |
| role_reversal | 1 | 1 | 1 | — | 0 | 0 | 1000 | 1000 | 1000 | emit `{8}`; occ=121 trunc=208 |
| wrong_relation | 1 | 1 | 1 | — | 0 | 0 | 1000 | 1000 | 1000 | emit `{307}`; occ=147 trunc=226 |
| wrong_context | 1 | 3 | 1 | — | 2 | 0 | 333 | 333 | 1000 | **NOT_SELECTIVE** (xid still not a key) |
| distractor | 22 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | undef | **EXCLUDED**; leak_n=0; emit is PSC not excluded |
| unrelated | 0 | 0 | 0 | — | 0 | 0 | — | — | — | **UNRELATED_EMPTY_WALK** |
| high_occupancy | 1 | 6 | 1 | — | 0 | 5 | 1000 | 166 | 1000 | fillers split; occ=159>16 |
| overflow_page | 1 | 6 | 1 | — | 0 | 5 | 1000 | 166 | 1000 | gold 448 in emit; ovf=1 |
| high_id_sentinel | 1 | 0 | 0 | — | 0 | 0 | undef | — | 0 | **SEARCH_INCOMPLETE** nid 4095 beyond cap |

Posting-selectivity (labeled `emit_vs_posting_occupancy`; not cap/N):

| class | emit_n | posting_occ | n | cand_cap |
|---|---:|---:|---:|---:|
| direct | 3 | 13 | 4096 | 16 |
| paraphrase | 3 | 13 | 4096 | 16 |
| role_reversal | 1 | 121 | 4096 | 16 |
| wrong_relation | 1 | 147 | 4096 | 16 |
| wrong_context | 3 | 13 | 4096 | 16 |
| distractor | 3 | 13 | 4096 | 16 |
| unrelated | 0 | 0 | 4096 | 16 |
| high_occupancy | 6 | 159 | 4096 | 16 |
| overflow_page | 6 | 122 | 4096 | 16 |
| high_id_sentinel | 0 | 110 | 4096 | 16 |

Do not read `1-16/4096` as Master candidate-reduction ≥90%. Direct
posting-selectivity is emit 3 vs occupancy 13 on the conjunctive walk.

## Not claimed

```text
C1_800K
N_16384
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
high_id_sentinel retrieve (SEARCH_INCOMPLETE at scale; not this unknown FAIL)
```
