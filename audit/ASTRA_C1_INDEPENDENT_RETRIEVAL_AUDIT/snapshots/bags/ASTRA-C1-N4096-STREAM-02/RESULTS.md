# RESULTS — ASTRA-C1-N4096-STREAM-02

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK /
`LATE_GOLD_HIT` / `STREAM_HIT` / `CAP_THEN_AND_WOULD_MISS` /
`ASTRA_C1_N4096_STREAM_02_XSIM_PASS`. This file does not promote C1 800k,
N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, or BOARD_PASS.

```text
GATE             = ASTRA-C1-N4096-STREAM-02
N                = 4096
CAND_CAP         = 16   (< 4096; emit budget after AND; not CAND_CAP_FINAL)
LAW              = qse-v2-stream-intersect-02
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
WALKER           = sorted-nid two-pointer AND; 1-beat page (arlen=0); rare-list-first;
                   CAND_CAP after emit; SEARCH_INCOMPLETE on budget exhaust
DUT              = a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (STREAM-02 SHA MATCH; not edited)
k0,k1            = {subj,rel}/{obj,rel}
k2,k3            = relbind (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
MEM_DEPTH        = 65536 (TB-only; fits 4096-record index)
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_stream_intersect, tb_astra_c1_n4096_stream)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_intersect.sv NOT compiled as DUT (KEEP)
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (12:10:22, before first xvlog 12:10:41)
GOLD_LIVE        = MATCH 2a2db8c8… / 7a37e176… / d342084b…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no LATE_GOLD_MISS; no DISTRACTOR_LEAK;
                   no SEARCH_INCOMPLETE)
XSIM_MARKER      = ASTRA_C1_N4096_STREAM_02_XSIM_PASS emitted
SIM_TIME         = 59405 ns
PID              = 57252
SESSION          = Mon Sep 7 12:11:03–12:11:06 2026
XSIM_SHA         = dd1a151a6f4be2713088901e1f24b1f8295d78813b8e6afd266571e5f83e9947
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_16384          = NOT this bag
CAND_CAP_FINAL   = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS       = NOT_CLAIMED
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-KEY-INTERSECT-01` GOLDEN 10:16:50 hash d3b5b883…
- KEEP `ASTRA-C1-N4096-INTERSECT-01` GOLDEN 10:46:42 hash 095ca715… CLOSEOUT 10:49:24
- KEEP `ASTRA-C1-STREAM-INTERSECT-02` GOLDEN 11:43:45 hash 05c6e087… CLOSEOUT 11:45:37
- KEEP `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` CLOSEOUT 11:11:09
- KEEP intersect DUT `a7ng_query_axi_sparse_intersect.sv` 10:13:02 hash a912786f…
- Independent audit tree PLAN.md 10:52:29 (not written)

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL LATE_GOLD_MISS / FAIL DISTRACTOR_LEAK / SEARCH_INCOMPLETE). Gold was **not**
regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
Relbind keys `93811ed1…`. KEEP intersect `a912786f…` not compiled as DUT.

DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` MATCH STREAM-02
(mtime 11:43:39; not edited this bag).

## Unknown (this bag)

At N=4096, same law `qse-v2-stream-intersect-02` (sorted-nid two-pointer,
1-beat page, rare-list-first, CAND_CAP after emit), does LATE gold
(posting index ≥16 on both k0 and k1 so cap-then-AND would miss; sentinel
near 4095) HIT, and do retrieve classes with `gold_n>=1` FAIL the bag if
`SEARCH_INCOMPLETE` / emit miss?

LATE gold retrieve: **yes** (`LATE_GOLD_HIT id=4094`; `STREAM_HIT`; `tp=1`;
`rec_x1000=1000`; `prec_all_x1000=1000`; `incomp=0`). Host/TB indices:
k0=115, k1=109 (both ≥16). Raw
`CAP_THEN_AND_WOULD_MISS id=4094 k0_idx=115 k1_idx=109 stream_hit=1`.

High-id sentinel retrieve: **yes** (`id=4095`; `tp=1`; `incomp=0`). Not the
old N4096-INTERSECT cap-then-AND miss.

Direct retrieve: **yes** (`tp=3` of gold `{110,144,145}`; `rec_x1000=1000`;
`prec_all_x1000=1000`; `incomp=0`).

SEARCH_INCOMPLETE was **not** printed on any class. No retrieve class with
`gold_n>=1` missed. `incomp=0` on late_gold, sentinel, and direct.

Gate requires FAIL=0 **and** late gold in emit **and** no SEARCH_INCOMPLETE
on `gold_n>=1` retrieve classes **and** direct gold hits >0 for
`PASS_THIS_GATE_ONLY`. Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, N=16384, Master evidence-recall ≥95%,
candidate-reduction ≥90%, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`,
BOARD_PASS, or ACCEPT_BOARD.

## CLASS table (raw xsim.log)

| class | gold_n | emit_n | tp | prec_all_x1000 | rec_x1000 | incomp | notes |
|---|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 3 | 3 | 1000 | 1000 | 0 | `{110,144,145}` |
| paraphrase | 3 | 3 | 3 | 1000 | 1000 | 0 | `{110,144,145}` |
| role_reversal | 1 | 1 | 1 | 1000 | 1000 | 0 | id=146 |
| wrong_relation | 1 | 1 | 1 | 1000 | 1000 | 0 | id=114 |
| wrong_context | 1 | 3 | 1 | 333 | 1000 | 0 | NOT_SELECTIVE; keys=direct |
| distractor | 22 | 3 | 0 | 0 | undef | 0 | EXCLUDED leak_n=0 |
| unrelated | 0 | 0 | 0 | — | — | — | UNRELATED_EMPTY_WALK |
| high_occupancy | 1 | 16 | 1 | 62 | 1000 | 0 | gold 147; 15 fill0; occ=116 |
| overflow_page | 1 | 5 | 1 | 200 | 1000 | 0 | gold 167; ovf=1 |
| high_id_sentinel | 1 | 1 | 1 | 1000 | 1000 | 0 | id=4095 |
| late_gold | 1 | 1 | 1 | 1000 | 1000 | 0 | id=4094; k0=115 k1=109 |

Headline `precision_all=TP/emit_n`. `prec_ev1` diagnostic. `REDUCTION_X1000=NOT_EMITTED`
(not `1-16/4096`). hoc prec_all=62 is 1/16, not Master ≥90%.

Host independent postings (not RESULTS authority; corroboration): nid 4094 ∈
k0 at index 115 and k1 at index 109; first16∩first16={}; stream AND={4094}.
