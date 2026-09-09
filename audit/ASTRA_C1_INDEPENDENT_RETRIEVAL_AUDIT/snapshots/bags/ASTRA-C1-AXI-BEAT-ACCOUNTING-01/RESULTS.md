# RESULTS — ASTRA-C1-AXI-BEAT-ACCOUNTING-01

Authority = raw `xsim.log` `EMIT_IDS` / `AXI_BEAT` / `ASTRA_C1_AXI_BEAT_XSIM_PASS`.
This file does not promote C1 800k, N=4096, `DDR_QUERY_BOUND_FINAL`,
`CAND_CAP_FINAL`, BOARD_PASS, or `qse-v2-stream-intersect-02`.

```text
GATE             = ASTRA-C1-AXI-BEAT-ACCOUNTING-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW              = qse-v2-intersect-01 (replay; not a new retrieval law)
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…)
INTERSECT_DUT    = instantiated not edited (a912786f… MATCH KEY-INTERSECT)
PROBE            = a7ng_query_axi_rbeat_probe (NEW; rvalid&&rready; AR-addr class)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_intersect, query_axi_rbeat_probe,
                   tb_astra_c1_axi_beat_accounting)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
                   stream-intersect-02 NOT compiled
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (11:06:54, before SHA freeze 11:09:54,
                   before xsim 11:09:59)
GOLD_LIVE        = MATCH d3b5b883… / f1611917… / e8b4f8ea…  (KEY-INTERSECT copy;
                   not rewritten after xsim)
FAIL_R0          = not written (PASS session)
XSIM_MARKER      = ASTRA_C1_AXI_BEAT_XSIM_PASS emitted
SIM_TIME         = 18305 ns
PID              = 53316
SESSION          = Mon Sep 7 11:09:59–11:10:01 2026
XSIM_SHA         = 4ab47b52232770fc3afeb98c2f172a1f134db750c5ef6ef8eb86027ab0689905
REDUCTION_X1000  = NOT_EMITTED
RATIO_x1000      = R_BYTES*1000/AR_BYTES (live R-beats; not 1-CAND_CAP/N)
C1_800K          = OPEN
N_4096           = KEEP unedited (not this bag)
BOARD_PASS       = NOT_CLAIMED
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
CAND_CAP_FINAL   = NOT_FROZEN
STREAM_INTERSECT_02 = NOT_THIS_BAG
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-KEY-INTERSECT-01` GOLDEN hash d3b5b883… timestamp 10:16:50 (unchanged)
- KEEP `ASTRA-C1-KEY-INTERSECT-01` corpus hash e8b4f8ea… timestamp 10:16:50 (unchanged)
- KEEP `ASTRA-C1-KEY-INTERSECT-01` query_gold.svh hash f1611917… timestamp 10:16:50 (unchanged)
- KEEP `ASTRA-C1-N4096-INTERSECT-01` GOLDEN timestamp 10:46:42 (unchanged)

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
Intersect DUT `a912786f…`. Relbind keys `93811ed1…`.
NEW probe `a5d0eb3c…`.

## Unknown (this bag)

On frozen N=256 KEY-INTERSECT queries, through the same intersect DUT, do
accepted R-beats (`rvalid && rready`) measure AXI bytes as
`R_BYTES=16*(DIR_R_BEATS+POST_R_BEATS)` (not host-only AR×16), and are emit
IDs bit-identical to KEY-INTERSECT GOLDEN (direct `{110,144,145}`)?

Emit identity: **yes** (all 10 classes `EMIT_IDENTICAL=1`; direct
`110,144,145`).

R-beat counters: **yes** (nonzero on every class that issued AXI reads;
unrelated AR=0 / RATIO=NA). `R_BYTES >= AR_BYTES` on all AXI classes.

Gate requires emit-identical **and** printed R-beat counters **and**
`R_BYTES >= AR_BYTES` for `PASS_THIS_GATE_ONLY`. Therefore
**RESULT=PASS_THIS_GATE_ONLY**.

This does **not** freeze `DDR_QUERY_BOUND_FINAL`. N256 hoc live ratio on
high_occupancy is `2666` (2.666× vs AR×16), matching the independent
P0-2 model (~2.67×) as a *measurement*, not a bound freeze.

## Per-class (authority = xsim.log)

| class | emit | EMIT_IDENTICAL | AR_BYTES | DIR_R | POST_R | R_BYTES | RATIO_x1000 | notes |
|---|---|---:|---:|---:|---:|---:|---:|---|
| direct | 110,144,145 | 1 | 96 | 2 | 5 | 112 | 1166 | gold {110,144,145} |
| paraphrase | 110,144,145 | 1 | 96 | 2 | 5 | 112 | 1166 | same walk as direct |
| role_reversal | 146 | 1 | 96 | 2 | 5 | 112 | 1166 | |
| wrong_relation | 114 | 1 | 80 | 2 | 8 | 160 | 2000 | AR undercount 2.0× |
| wrong_context | 110,144,145 | 1 | 96 | 2 | 5 | 112 | 1166 | NOT_SELECTIVE |
| distractor | 110,144,145 | 1 | 96 | 2 | 5 | 112 | 1166 | leak_n=0 excluded |
| unrelated | (empty) | 1 | 0 | 0 | 0 | 0 | NA | UNRELATED_EMPTY_WALK |
| high_occupancy | 147..158 | 1 | 96 | 2 | 14 | 256 | 2666 | AR undercount 2.666× |
| overflow_page | 168..172 | 1 | 96 | 2 | 6 | 128 | 1333 | |
| high_id_sentinel | 255 | 1 | 96 | 2 | 6 | 128 | 1333 | |

AR_BYTES = 16*(n_dir_ar+n_post_ar). R_BYTES = TOTAL_AXI_BYTES =
16*(DIR_R_BEATS+POST_R_BEATS). Probe AR class counts matched DUT
`n_dir_ar`/`n_post_ar` on every class.

## Not claimed

```text
C1_800K
N_4096_PROMOTION
CAND_CAP_FINAL
DDR_QUERY_BOUND_FINAL
BOARD_PASS
ACCEPT_BOARD
ASTRA-13
PRODUCTION_TOP
qse-v2-stream-intersect-02
Master_evidence_recall_ge95
Master_candidate_reduction_ge90
relevant=router_union
nid-derived keys
threshold drop
silent C0 patch
reduction_x1000 as 1-CAND_CAP/N
```
