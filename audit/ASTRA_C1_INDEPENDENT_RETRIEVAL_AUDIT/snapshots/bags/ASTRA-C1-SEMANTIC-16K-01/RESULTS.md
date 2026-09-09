# RESULTS — ASTRA-C1-SEMANTIC-16K-01

```text
RESULT               = PASS_THIS_GATE_ONLY
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (NEW named; not C0 59-word runtime)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 120
N_RELS               = 8
CAND_CAP             = 16 (after emit; NOT FINAL)
MEM_DEPTH            = 286517 (TB-only; 4*65536 directory + postings)
POKE_V               = 0
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
MARKER               = ASTRA_C1_SEMANTIC_16K_XSIM_PASS
PID                  = 59468
SIM_TIME             = 35035 ns
XSIM                 = 15:17:09–15:17:20 local+07; Vivado 2026.1
XSIM_SHA             = bc03a39b8376b72da3d6ed845999cf83a95e87aa3b6e35f482d43b5b60651d3e
GOLD_PRE             = 14:49:09 (GOLDEN/svh/corpus/lex) BEFORE xvlog 14:50:35
GOLDEN               = 0e539d48be5862d006e5785cf3c74355d5540dff09bec5e8c738ac842ea83b99
SVH                  = cfa165c0f9921f0c19802dc5e25a247aa93eb1d19f43155b715f111706336e5b
CORPUS               = 2b5d3028b95205213aa359fdafde86153ae07aae92e4349597a194ff716c81d9
LEX_NAMED            = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
FAIL_R0              = ABSENT (PASS session)
FAIL_COUNT           = 0
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
NOT_SELECTIVE        = ABSENT (this bag)
CONTEXT_SELECTIVE    = PRESENT
TWELVE_ENTITY_CLONE  = NO (direct is boiler/feeds/header, not pump/supplies/chiller)
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / CONTEXT_SELECTIVE / LATE_GOLD_HIT /
UNRELATED_EMPTY_WALK / ASTRA_C1_SEMANTIC_16K_XSIM_PASS. This file is hunted, not
authority.

## Registered unknown (closed this bag only)

At N=16384, law `qse-v2-intersect-context-02` (instantiate ctx keys `124be808…`
+ STREAM-02 walker via context wrapper `8255a798…`; STREAM-02 file `14f75db7…`
unedited and not compiled as DUT) on a semantic corpus with ≥100 distinct
subject ids and ≥8 relation ids, independent gold not cloned
“pump supplies chiller” × N: does labeled-gold recall hold on required
retrieve classes without `SEARCH_INCOMPLETE` hiding misses?

Raw:

```text
C1_SEMANTIC_16K_N=16384 N_BUCKETS=65536 CAND_CAP=16 … N_SUBJECTS=120 N_RELS=8
CLASS_direct emit={120,121,122} tp=3 prec_all=1000 incomp=0
CONTEXT_SELECTIVE class=wrong_context k0=3380 k1=3636 vs_direct k0=3332 k1=3588
                  keys_match=0 emit_match=0
CLASS_wrong_context emit={121} gold_n=1 tp=1 prec_all=1000 incomp=0
LATE_GOLD_HIT id=16382 CLASS_late_gold emit={16382} incomp=0
UNRELATED_EMPTY_WALK
CLASS_distractor leak_n=0 gold_n=16
ASTRA_C1_SEMANTIC_16K_XSIM_PASS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

Direct query `"boiler feeds header"` (NEW lexicon entities 13/14, rel 4).
Host dual-indexes plain keys so unbound direct still sees the glycol/steam
ctx rows 121/122. Wrong-context `"boiler feeds header glycol"` binds NEW
CLS_CTX glycol id=3 and walks packed k0=3380. Not nid-derived. Not
`relevant=router_union`. Not a 12-entity HVAC clone.

NEW lexicon law `qse-v2-lex-semantic-16k-01`: bag
`qse_role_lexicon_semantic_16k.svh` is the runtime table. xvlog `-i $bag`
FIRST. C0 FILE `rtl/.../qse_role_lexicon.svh` `38189974…` unedited and is
**not** the runtime table this bag.

## CLASS table (raw)

| class | gold | emit | tp | notes |
|---|---|---|---|---|
| direct | {120,121,122} | {120,121,122} | 3 | boiler feeds header ± ctx; independent |
| paraphrase | {120,121,122} | {120,121,122} | 3 | "the boiler feeds the header" |
| role_reversal | {123} | {123} | 1 | header feeds boiler |
| wrong_relation | {124} | {124} | 1 | boiler isolates header |
| wrong_context | {121} | {121} | 1 | CONTEXT_SELECTIVE; ≠ direct |
| distractor | 16 excluded | {120,121,122} | 0 | leak_n=0 |
| unrelated | {} | {} | 0 | UNRELATED_EMPTY_WALK |
| high_occupancy | {125} | {125…140} n=16 | 1 | prec_all=62; incomp=0 |
| overflow_page | {153} | {149…153} | 1 | ovf=1 |
| high_id_sentinel | {16383} | {16383} | 1 | |
| late_gold | {16382} | {16382} | 1 | LATE_GOLD_HIT; k0 idx=16 k1 idx=33; cap-then-AND would miss |

Headline `precision_all=TP/emit_n`. `REDUCTION_X1000=NOT_EMITTED`.

## Instantiates / KEEP (not edited)

```text
DUT                 = a7ng_query_axi_sparse_intersect_context 8255a798… MATCH instantiate
CTX_KEYS            = a7ng_query_role_keys_ctx 124be808… MATCH instantiate
STREAM-02 file      = 14f75db7… MATCH; NOT compiled as DUT; NOT edited
PAGE-SKIP           = dab15d76… MATCH; NOT compiled; NOT edited
C0 extract          = cd7baf49… MATCH; NOT edited
C0 lexicon FILE     = 38189974… MATCH; NOT edited; NOT runtime
C0 dir FILE         = 09334e42… MATCH; N_BUCKETS=65536 parameter instantiate; NOT patched
leftover A09        = not compiled
```

Does **not** close C1 800k. Does **not** freeze `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL`. BOARD_PASS not claimed. Independent audit tree
not written. KEEP CONTEXT-02 / PAGE-SKIP / STREAM-02 / DIR-FULL16 /
N4096-STREAM-02 / KEY-INTERSECT / AXI-BEAT unmodified.
