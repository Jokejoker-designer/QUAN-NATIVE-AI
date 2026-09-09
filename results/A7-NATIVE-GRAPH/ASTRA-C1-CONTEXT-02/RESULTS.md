# RESULTS — ASTRA-C1-CONTEXT-02

```text
RESULT               = PASS_THIS_GATE_ONLY
LAW                  = qse-v2-intersect-context-02
N                    = 256
N_BUCKETS            = 4096
CAND_CAP             = 16 (after emit; NOT FINAL)
POKE_V               = 0
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
MARKER               = ASTRA_C1_CONTEXT_02_XSIM_PASS
PID                  = 25508
SIM_TIME             = 16565 ns
XSIM                 = 14:12:28–14:12:31 local+07; Vivado 2026.1
XSIM_SHA             = e749c9b0314c69f4b706655348b07505adf13c1ae8d7faaeeff00e76cd010f66
GOLD_PRE             = 14:12:02 (GOLDEN/svh/corpus) BEFORE xvlog 14:12:24
GOLDEN               = 8fc931f5ac07a72fd146a8e429ab38aed7ce0952464514883b887049ce0c3165
SVH                  = 1dbd096a16d29578fa83ddcab67c161a68b2a51f6b3a9e8afc47e2b1ce68325f
CORPUS               = eee202e0ded1a2fa45c92b1671dd371e34cfccf8f5a8b0e722416de8d1418ebd
FAIL_R0              = ABSENT (PASS session)
FAIL_COUNT           = 0
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
NOT_SELECTIVE        = ABSENT (this bag)
CONTEXT_SELECTIVE    = PRESENT
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / CONTEXT_SELECTIVE / LATE_GOLD_HIT /
UNRELATED_EMPTY_WALK / ASTRA_C1_CONTEXT_02_XSIM_PASS. This file is hunted, not
authority.

## Registered unknown (closed this bag only)

At N=256, law `qse-v2-intersect-context-02` (C0 ctx token folded into k0/k1 when
`ctx_valid`; STREAM-02 two-pointer walker in a new named wrapper): does
CLASS_wrong_context emit differ from CLASS_direct `{110,144,145}` **and** does
CLASS_direct still retrieve those gold ids?

Raw:

```text
CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0
CONTEXT_SELECTIVE class=wrong_context k0=2577 k1=273 vs_direct k0=2561 k1=257
                  keys_match=0 emit_match=0
CLASS_wrong_context emit={144} gold_n=1 tp=1 prec_all=1000 incomp=0
LATE_GOLD_HIT id=254 CLASS_late_gold emit={254} incomp=0
UNRELATED_EMPTY_WALK
CLASS_distractor leak_n=0 gold_n=10
ASTRA_C1_CONTEXT_02_XSIM_PASS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

Direct k0=2561 (`{pump,supplies}`) unchanged vs STREAM-02. Wrong-context query
`"pump supplies chiller water"` binds C0 ctx id=1 (`water`) and walks packed
k0=2577=`{subj,ctx[3:0],rel[3:0]}`. Host dual-indexes plain keys (so unbound
direct still sees 110/144/145) and ctx-packed keys (so water-only 144 is the
AND). Not nid-derived. Not `relevant=router_union`.

## CLASS table (raw)

| class | gold | emit | tp | notes |
|---|---|---|---|---|
| direct | {110,144,145} | {110,144,145} | 3 | bit-identical control |
| paraphrase | {110,144,145} | {110,144,145} | 3 | |
| role_reversal | {146} | {146} | 1 | |
| wrong_relation | {114} | {114} | 1 | |
| wrong_context | {144} | {144} | 1 | CONTEXT_SELECTIVE; ≠ direct |
| distractor | 10 excluded | {110,144,145} | 0 | leak_n=0 |
| unrelated | {} | {} | 0 | UNRELATED_EMPTY_WALK |
| high_occupancy | {147} | {147…162} n=16 | 1 | prec_all=62 |
| overflow_page | {167} | {163…167} | 1 | |
| high_id_sentinel | {255} | {255} | 1 | |
| late_gold | {254} | {254} | 1 | LATE_GOLD_HIT; cap-then-AND would miss |

Headline `precision_all=TP/emit_n`. `REDUCTION_X1000=NOT_EMITTED`.

## RTL / compile

```text
NEW keys   a7ng_query_role_keys_ctx.sv
           124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1
NEW DUT    a7ng_query_axi_sparse_intersect_context.sv
           8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989
STREAM-02  14f75db7… mtime 11:43:39 NOT compiled as DUT
PAGE-SKIP  dab15d76… mtime 13:31:29 NOT compiled as DUT
C0 extract cd7baf49… mtime 2026-09-05 19:48:18 UNEDITED
C0 lexicon 38189974… mtime 2026-09-05 20:51:03 UNEDITED QSE2_N_LEX=59 runtime
C0 dir     09334e42… mtime 2026-09-05 19:31:03 UNEDITED (AXI-idle instantiate)
leftover A09 not compiled; relbind keys not compiled; poke_v=0
xvlog -i C0 query FIRST; bag qse_role_lexicon.svh ABSENT
```

## Not claimed

C1 800k. N=16384. `CAND_CAP_FINAL`. `DDR_QUERY_BOUND_FINAL`. BOARD_PASS.
ACCEPT_BOARD. Master evidence-recall ≥95%. Master candidate-reduction ≥90%.
Page-skip scheduler change. Semantic 800k corpus. This is a 12-entity
`axi_mem_model` clone with C0 HVAC ctx tokens `{water,air,…}=1` and
`{indirect,indirectly}=2`. Direct 1000 is 3-id identity. Wrong-context 1000
is 1-id identity (nid 144).
