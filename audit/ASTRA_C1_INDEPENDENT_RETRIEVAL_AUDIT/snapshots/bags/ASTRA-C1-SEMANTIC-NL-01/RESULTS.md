# RESULTS — ASTRA-C1-SEMANTIC-NL-01

```text
RESULT               = FAIL NOT_SELECTIVE_NL
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833; not C0 59-word runtime)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 127
N_RELS               = 8
CAND_CAP             = 16 (after emit; NOT FINAL)
MEM_DEPTH            = 286514 (TB-only; 4*65536 directory + postings)
POKE_V               = 0
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
MARKER               = ABSENT (ASTRA_C1_SEMANTIC_NL_XSIM_PASS not emitted)
NO_MARKER            = ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER
NOT_SELECTIVE_NL     = PRESENT keys_match=0 gold_miss=1
PID                  = 62740
SIM_TIME             = 9455 ns
XSIM                 = 19:18:38–19:18:47 local+07; Vivado 2026.1
XSIM_SHA             = 1ff11f304e579e954832c06e5fc2c5216f22f7f41df24cfa774151d872165db5
GOLD_PRE             = 19:05:03 (GOLDEN/svh) BEFORE xvlog 19:05:32
                       SHA256 freeze 19:05:31
                       corpus KEEP copy mtime 17:29:38 SHA 6991adc7
                       named lex mtime 14:49:07 (copied; not rewritten)
GOLDEN               = 6fa2a93f15a32b2135357c8876700b89c59dcb4972936ef79f130922c593b53b
SVH                  = b0dce42f501b875a4f21418a90dc5890108eb2ba8addd3c8e910fd11a3dd6a45
CORPUS               = 6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597
LEX_NAMED            = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
FAIL_R0              = PRESENT (copy of xsim.log; gold NOT regenerated)
FAIL_COUNT           = 1 (GOLD_MISS class=nl_synonym missed=3)
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
N_DROP               = ABSENT (N actually 16384; not silent 256)
TWELVE_ENTITY_CLONE  = NO
KEEP_R2              = UNMODIFIED (GOLDEN 18:19:54 CLOSEOUT 18:34:48)
KEEP_16K             = UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43)
KEEP_HELDOUT         = UNMODIFIED (GOLDEN 15:44:21 CLOSEOUT 16:06:53)
KEEP_SEM16K          = UNMODIFIED (GOLDEN 14:49:09 CLOSEOUT 15:18:52)
INDEP_TREE           = UNMODIFIED (max 10:52:29; not written)
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / FILL_TEMPLATE_HIT /
KEYS_VS_FILL / NL_GOLD_MISS / NOT_SELECTIVE_NL /
ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER. This file is hunted, not authority.

## Registered unknown (FAILED this bag; honest)

A query whose bound keys after frozen QSE are **not** identical to
fill-template `"boiler feeds header"` (k0=3332 k1=3588), yet still
retrieves labeled gold nids for that meaning `{120,121,122}`.
HELDOUT paraphrase `"what does the boiler feed to the header"` maps to
the **same** keys 3332/3588 after WH-drop + `feed` RELCTX id=4 — **not**
this unknown. If frozen extract cannot produce a different-key synonym,
FAIL `NOT_SELECTIVE_NL`. Do not fake keys. Do not edit C0 lexicon.

NL probe (not FILL_RE; not CLS_SKIP-only):

```text
nl_synonym  "what does the boiler supply to the header"
            supply RELCTX after subject → REL id=1 (not feeds id=4)
            k0=3329 k1=3585  SRO=(13,1,14)  keys_match=0
```

Independent gold for **that meaning** remains fill-grid `{120,121,122}`.
Walker AND of the different keys emits nid **131** (`"boiler supplies header"`,
cartesian-sample SRO=(13,1,14), k1 occ=18 — **not** hard-empty k1).
Fill-meaning gold missed (tp=0 missed=3). Marker not emitted.

Raw:

```text
C1_SEMANTIC_NL_N=16384 N_BUCKETS=65536 CAND_CAP=16 … MEM_DEPTH=286514
  N_SUBJECTS=127 N_RELS=8 FILL_GRID=120,121,122 FILL_K0=3332 FILL_K1=3588
  POKE_V=0
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 occ=121 incomp=0
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
FAIL GOLD_MISS class=nl_synonym missed=3 trunc=0 ovf=1 incomp=0
KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0
NL_GOLD_MISS tp=0 emit_n=1 gold_n=3 keys_match=0
CLASS_nl_synonym gold_n=3 emit_n=1 tp=0 fp_ev1=1 rec_x1000=0 occ=119 incomp=0
  CAND nl_synonym i=0 id=131 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
NL_SUMMARY keys_match=0 nl_hit=0 nl_tp=0 fill_tp=3 fail=1
NOT_SELECTIVE_NL keys_match=0 gold_miss=1 frozen_extract_cannot_bind_non_alias_synonym
ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER fail=1 … G_N=16384
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

| class | gold_n | emit | tp | note |
|---|---:|---|---:|---|
| fill_template | 3 | {120,121,122} | 3 | control `"boiler feeds header"` k0=3332 k1=3588; FILL_TEMPLATE_HIT |
| nl_synonym | 3 | {131} | 0 | `"what does the boiler supply to the header"` k0=3329 k1=3585; keys_match=0; gold meaning miss |
| unrelated | 0 | {} | 0 | UNRELATED_EMPTY_WALK |

## Honesty

- Frozen extract `cd7baf49…` + named lexicon `df0e8833…` bind `supply`/`supplies`
  as REL id=1 and `feeds`/`feed` as REL id=4. Those are **not** lexicon aliases.
  Different keys are real (`keys_match=0`). Same-meaning retrieve is **not**.
- HELDOUT `"what does the boiler feed to the header"` is CLS_SKIP + `feed`
  RELCTX id=4 → **same** keys 3332/3588. Explicitly excluded from this unknown.
- Glycol/steam ctx-fold (`k0=3380/3396`) is CONTEXT_SELECTIVE already closed
  on HELDOUT; not sold as NL synonym here.
- Walker emit `{131}` is the indexed cartesian row `"boiler supplies header"`.
  Relabeling gold as `{131}` would fake the unknown. Gold stayed fill-meaning
  `{120,121,122}` (hashed before xvlog; not rewritten after FAIL).
- k1 occupancy 18 / AND occupancy 1 is **not** hard-empty k1. The miss is
  selectivity of frozen QSE, not an empty posting.
- Do not nid-derived keys. DUT has no nid port. Keys are packed `{subj,rel}` /
  `{obj,rel}`.
- C1 800k remains OPEN. BOARD_PASS not claimed. N=16384 hosted. leftover A09
  off. poke_v=0. STREAM-02 `14f75db7…` not compiled as DUT. Ctx keys/DUT
  `124be808…` / `8255a798…` instantiated not edited. C0 lexicon FILE
  `38189974…` unedited and not runtime. KEEP bags unmodified. Independent
  tree not written.

`SEARCH_INCOMPLETE` ABSENT (incomp=0 on all CLASS lines). Gold miss is
reported as `FAIL GOLD_MISS` / `NL_GOLD_MISS` / `NOT_SELECTIVE_NL`, not hidden.
