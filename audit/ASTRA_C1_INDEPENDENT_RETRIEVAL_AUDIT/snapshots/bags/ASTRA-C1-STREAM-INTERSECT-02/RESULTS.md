# RESULTS — ASTRA-C1-STREAM-INTERSECT-02

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK /
`LATE_GOLD_HIT` / `CAP_THEN_AND_WOULD_MISS` /
`ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS`. This file does not promote C1 800k,
N=4096, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, or BOARD_PASS.

```text
GATE             = ASTRA-C1-STREAM-INTERSECT-02
N                = 256
CAND_CAP         = 16   (< 256; emit budget after AND; not CAND_CAP_FINAL)
LAW              = qse-v2-stream-intersect-02
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
WALKER           = sorted-nid two-pointer AND; 1-beat page (arlen=0); rare-list-first;
                   CAND_CAP after emit; SEARCH_INCOMPLETE on budget exhaust
k0,k1            = {subj,rel}/{obj,rel}
k2,k3            = relbind (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_stream_intersect, tb_astra_c1_stream_intersect)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_intersect.sv NOT compiled as DUT (KEEP)
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (11:43:45, before first xvlog 11:43:59)
GOLD_LIVE        = MATCH 05c6e087… / e6c88efe… / fe7a3d5a…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no LATE_GOLD_MISS; no DISTRACTOR_LEAK)
XSIM_MARKER      = ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS emitted
SIM_TIME         = 16765 ns
PID              = 56180
SESSION          = Mon Sep 7 11:44:03–11:44:06 2026
XSIM_SHA         = 9091c5a78d1e67ffb1683bfee8fe029b17fc1b6e6b965a20d7d328a400084c14
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_4096           = KEEP unedited (not this bag)
CAND_CAP_FINAL   = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS       = NOT_CLAIMED
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-KEY-INTERSECT-01` GOLDEN 10:16:50 hash d3b5b883…
- KEEP `ASTRA-C1-N4096-INTERSECT-01` GOLDEN 10:46:42 hash 095ca715…
- KEEP `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` GOLDEN 10:16:50 hash d3b5b883…
- KEEP intersect DUT `a7ng_query_axi_sparse_intersect.sv` 10:13:02 hash a912786f…

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL LATE_GOLD_MISS / FAIL DISTRACTOR_LEAK). Gold was **not** regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
Relbind keys `93811ed1…`. KEEP intersect `a912786f…` not compiled as DUT.

NEW RTL `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…`.

## Unknown (this bag)

At N=256, new law `qse-v2-stream-intersect-02` (sorted-nid two-pointer,
1-beat page, rare-list-first, CAND_CAP after emit), does LATE gold
(posting index ≥16 on both k0 and k1 so cap-then-AND would miss) HIT
while CLASS_direct still retrieves `{110,144,145}`?

LATE gold retrieve: **yes** (`LATE_GOLD_HIT id=254`; `tp=1`; `rec_x1000=1000`;
`prec_all_x1000=1000`; `incomp=0`). Host: k0 index=20, k1 index=22.
Raw `CAP_THEN_AND_WOULD_MISS id=254 stream_hit=1`.

Direct retrieve: **yes** (`tp=3` of gold `{110,144,145}`; `rec_x1000=1000`;
`prec_all_x1000=1000`).

SEARCH_INCOMPLETE was **not** used to hide a gold miss (no retrieve class
with `gold_n>=1` missed; `incomp=0` on late_gold and direct).

Gate requires FAIL=0 **and** late gold in emit **and** direct gold hits >0
for `PASS_THIS_GATE_ONLY`. Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, N=4096 promotion, Master evidence-recall ≥95%,
or candidate-reduction ≥90%. Does **not** freeze `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL`.

## Per-class (authority = xsim.log)

Headline quality number is **precision_all** (`TP/emit_n`). `prec_ev1` is
diagnostic only.

```text
direct            gold={110,144,145} emit={110,144,145} tp=3 prec_all=1000 incomp=0
paraphrase        same emit/gold as direct
role_reversal     gold={146} emit={146} tp=1 prec_all=1000
wrong_relation    gold={114} emit={114} tp=1 prec_all=1000
wrong_context     NOT_SELECTIVE keys_match=1 emit_match=1 (xid not a key)
distractor        gold_n=10 excluded leak_n=0 emit={110,144,145} rec_undef
unrelated         UNRELATED_EMPTY_WALK emit_n=0
high_occupancy    gold={147} emit_n=16 tp=1 prec_all=62 (fillers evidence=0)
overflow_page     gold={167} emit_n=5 tp=1 ovf=1
high_id_sentinel  gold={255} emit={255} tp=1
late_gold         gold={254} emit={254} tp=1 LATE_GOLD_HIT CAP_THEN_AND_WOULD_MISS
```

1-beat page buffer observed: TB diverges if any accepted AR has `arlen!=0`.
No such divergence. `postB` on late_gold = 192 = 12 posting beats × 16 B
(directory 32 B + posting 192 B).
