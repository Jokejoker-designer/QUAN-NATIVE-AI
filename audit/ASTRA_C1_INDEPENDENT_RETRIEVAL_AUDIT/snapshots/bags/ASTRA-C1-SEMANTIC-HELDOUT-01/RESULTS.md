# RESULTS — ASTRA-C1-SEMANTIC-HELDOUT-01

```text
RESULT               = PASS_THIS_GATE_ONLY
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833; not C0 59-word runtime)
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
MARKER               = ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS
PID                  = 61968
SIM_TIME             = 39395 ns
XSIM                 = 16:05:09–16:05:21 local+07; Vivado 2026.1
XSIM_SHA             = 38ed2631d50c650791d87334141465f39d3b19b2497b18f3967b8ce0d425b446
GOLD_PRE             = 15:44:21 (GOLDEN/svh/corpus) BEFORE xvlog 15:45:15
                       named lex mtime 14:49:07 (copied; not rewritten)
GOLDEN               = 3c1eda7d1639ef1d90e06d8eb799cd7f2a382cd42de1a4dd4319d131d3bcfcb4
SVH                  = 95be8b1b172096c16e4fe8b668e4f50b8bcaad0b116669edd513d9848800988a
CORPUS               = 45d239c792b616fb355b8d7c661e733879b8deb3776870aa800eedb8eccb5ed8
LEX_NAMED            = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
FAIL_R0              = ABSENT (PASS session)
FAIL_COUNT           = 0
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
NOT_SELECTIVE        = ABSENT (this bag)
CONTEXT_SELECTIVE    = PRESENT
FILL_TEMPLATE_HIT    = PRESENT tp=3 emit={120,121,122}
PARAPHRASE_HIT       = PRESENT tp=3 emit={120,121,122}
TWELVE_ENTITY_CLONE  = NO
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / FILL_TEMPLATE_HIT /
PARAPHRASE_HIT / CONTEXT_SELECTIVE / LATE_GOLD_HIT /
UNRELATED_EMPTY_WALK / ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS. This file is
hunted, not authority.

## Registered unknown (closed this bag only)

Held-out gold queries whose surface form is **not** the cartesian
`{ent} {rel} {ent}` fill used to build the N=16384 index, yet independent
labeled nids still retrieve under instantiate ctx keys `124be808…` + DUT
`8255a798…` (not edited); plus a fill-template control still hits.
`SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL. C1 800k stays OPEN.

Raw:

```text
C1_SEMANTIC_HELDOUT_N=16384 … HELDOUT=1 FILL_TEMPLATE_CONTROL=1
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template emit={120,121,122} tp=3 incomp=0
PARAPHRASE_HIT tp=3 emit_n=3
CLASS_paraphrase emit={120,121,122} tp=3 incomp=0
  text="what does the boiler feed to the header"
CONTEXT_SELECTIVE class=wrong_context k0=3380 k1=3636 vs_fill_template k0=3332 k1=3588
                  keys_match=0 emit_match=0
CLASS_wrong_context emit={121} gold_n=1 tp=1 incomp=0
  text="does the boiler feed the header glycol"
LATE_GOLD_HIT id=16382 CLASS_late_gold emit={16382} incomp=0
  text="does the cyclone discharges the beacon"
UNRELATED_EMPTY_WALK
CLASS_distractor leak_n=0 gold_n=16
ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

Fill-template control `"boiler feeds header"` (cartesian `{ent} {rel} {ent}`)
still emits `{120,121,122}`. Held-out paraphrase uses skip-class function
words + RELCTX `feed` (not the fill verb `feeds`) and still emits the same
labeled nids. Frozen extract binds both to subj=13 rel=4 obj=14. Index
rows remain the cartesian generator. Not nid-derived. Not
`relevant=router_union`. Not a 12-entity HVAC clone.

Named lexicon law `qse-v2-lex-semantic-16k-01`: bag
`qse_role_lexicon_semantic_16k.svh` copied SHA `df0e8833…` (mtime 14:49:07,
not rewritten). xvlog `-i $bag` FIRST. C0 FILE
`rtl/.../qse_role_lexicon.svh` `38189974…` unedited and is **not** the
runtime table this bag.

## CLASS table (raw)

| class | gold | emit | tp | notes |
|---|---|---|---|---|
| fill_template | 3 | {120,121,122} | 3 | cartesian control `"boiler feeds header"`; FILL_TEMPLATE_HIT |
| paraphrase | 3 | {120,121,122} | 3 | held-out `"what does the boiler feed to the header"`; PARAPHRASE_HIT |
| role_reversal | 1 | {123} | 1 | held-out `"what does the header feed to the boiler"` |
| wrong_relation | 1 | {124} | 1 | held-out `"does the boiler isolates the header"` |
| wrong_context | 1 | {121} | 1 | held-out + glycol; CONTEXT_SELECTIVE vs fill_template |
| distractor | 16 excl | {120,121,122} | 0 | leak_n=0; polarity=excluded |
| unrelated | 0 | {} | 0 | UNRELATED_EMPTY_WALK |
| high_occupancy | 1 | 16 ids 125..140 | 1 | held-out; fp_fill0=15; rec=1000; incomp=0 |
| overflow_page | 1 | {149..153} | 1 | held-out; gold 153; ovf=1 |
| high_id_sentinel | 1 | {16383} | 1 | held-out |
| late_gold | 1 | {16382} | 1 | held-out; LATE_GOLD_HIT; k0_idx=16 k1_idx=33; incomp=0 |

`SEARCH_INCOMPLETE` ABSENT. `incomp=0` on every CLASS line that reports it.
`FAIL ` line count = 0. Marker conjunct required fill_tp>0, para_tp>0,
`incomp_retrieve==0`.

## Instantiate / KEEP

```text
CTX_KEYS     = 124be808… mtime 14:03:07 NOT this bag; instantiated; NOT edited
CTX_DUT      = 8255a798… mtime 14:03:24 NOT this bag; instantiated as DUT; NOT edited
STREAM-02    = 14f75db7… mtime 11:43:39; NOT compiled as DUT; sdb ABSENT
PAGE-SKIP    = dab15d76… mtime 13:31:29; NOT compiled as DUT; sdb ABSENT
C0 extract   = cd7baf49… unedited
C0 lexicon FILE = 38189974… unedited; NOT runtime
C0 dir FILE  = 09334e42… unedited; N_BUCKETS=65536 parameter
leftover A09 = not compiled
poke_v       = 0
```

xvlog units: pkg, extract, keys_ctx, gate, dir, mem_model, intersect_context,
TB. ABSENT: leftover A09, frozen sparse DUT, KEY-INTERSECT DUT, STREAM-02 DUT,
PAGE-SKIP DUT, relbind keys.

KEEP SEMANTIC-16K GOLDEN 14:49:09 / CLOSEOUT 15:18:52 unmodified.
KEEP CONTEXT-02 GOLDEN 14:12:02 unmodified.
Independent tree max mtime 10:52:29 unmodified.

## Honesty bounds

This bag does **not** close C1 800k, Master evidence-recall ≥95%,
candidate-reduction ≥90%, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`,
BOARD_PASS, or ACCEPT_BOARD. Index is still a cartesian HVAC-word grid
hosted on `axi_mem_model`. The unknown closed here is only: held-out
query **surface** (not fill regex) still retrieves the same independent
labels, with fill-template control still hitting, and no
`SEARCH_INCOMPLETE` hide.

Gold hashed 15:44:21; SHA256.txt freeze 15:45:14; first xvlog 15:45:15.
Gold files still 15:44:21 after xsim. Named lex still 14:49:07.
`xsim_fail_r0.log` ABSENT.
