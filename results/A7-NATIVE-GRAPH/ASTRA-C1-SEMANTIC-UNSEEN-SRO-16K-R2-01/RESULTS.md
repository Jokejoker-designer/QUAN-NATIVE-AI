# RESULTS — ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01

```text
RESULT               = PASS_THIS_GATE_ONLY
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833; not C0 59-word runtime)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 127
N_RELS               = 8
PLANTED_N            = 8 (ALL queried; nids 123..130)
CAND_CAP             = 16 (after emit; NOT FINAL)
MEM_DEPTH            = 286514 (TB-only; 4*65536 directory + postings)
POKE_V               = 0
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
MARKER               = ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS
UNSEEN_SRO_8_OF_8_HIT = PRESENT
PID                  = 22308
SIM_TIME             = 16545 ns
XSIM                 = 18:33:12–18:33:22 local+07; Vivado 2026.1
XSIM_SHA             = ea8581ee5bc7b28891b6643cd0f9ff148917a1e0cc3c5e23f79446294e921627
GOLD_PRE             = 18:19:54 (GOLDEN/svh) BEFORE xvlog 18:20:11
                       corpus KEEP copy mtime 17:29:38 SHA 6991adc7
                       named lex mtime 14:49:07 (copied; not rewritten)
GOLDEN               = be1eb641931e7666b4751b71dfaa309030aa3ac3ba454f92ac7768e5a9bcd8bc
SVH                  = d24a983bfc5d704bb35c1223729c90a2b728ccae5b62c5bb884a4d05553b6251
CORPUS               = 6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597
LEX_NAMED            = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
FAIL_R0              = ABSENT (PASS session)
FAIL_COUNT           = 0
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
UNBOUND_FILL_GRID_LEAK = ABSENT
N_DROP               = ABSENT (N actually 16384; not silent 256)
TWELVE_ENTITY_CLONE  = NO
KEEP_16K             = UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43)
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / FILL_TEMPLATE_HIT /
UNSEEN_SRO_HIT (8 lines, nids 123–130) / UNSEEN_SRO_8_OF_8_HIT /
UNBOUND_EMPTY_WALK / UNRELATED_EMPTY_WALK /
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS. This file is hunted, not
authority.

## Registered unknown (closed this bag only)

N=16384 same KEEP plants 123–130; query **each** of 8 off-grid SROs;
each HIT its nid; unbound SRO still `UNBOUND_EMPTY_WALK` and must **not**
emit fill-grid `{120,121,122}`. Instantiate ctx keys `124be808…` + DUT
`8255a798…` (not edited). `SEARCH_INCOMPLETE` on any of 8 retrieve =
FAIL. Corpus/lexicon copied hashed from KEEP UNSEEN-SRO-16K-01 (KEEP
not edited). C1 800k stays OPEN.

Raw:

```text
C1_SEMANTIC_UNSEEN_SRO_16K_R2_N=16384 N_BUCKETS=65536 … MEM_DEPTH=286514
  N_SUBJECTS=127 N_RELS=8 PLANTED_N=8 UNSEEN_SRO=8 FILL_GRID=120,121,122
  PLANTED_NIDS=123,124,125,126,127,128,129,130
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 occ=121 incomp=0
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=123
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=124
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=125
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=126
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=127
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=128
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=129
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=130
UNBOUND_EMPTY_WALK gold_n=0 emit_n=0
CLASS_unbound_sro gold_n=0 emit_n=0 occ=121 incomp=0
UNRELATED_EMPTY_WALK
UNSEEN_SRO_HIT_N=8 OF 8
UNSEEN_SRO_8_OF_8_HIT
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

Fill-template control `"boiler feeds header"` still emits `{120,121,122}`
with k0 occupancy **121**. All 8 planted SROs retrieve their nids.
Unbound `"boiler feeds chiller"` SRO=(13,4,1) is **not indexed**, shares
fill-grid k0=3332 (occ=121; k0-only would leak `{120,121,122}`), k1=260
occ=0, AND empty. N actually 16384. Not nid-derived. Not
`relevant=router_union`. Not a 12-entity HVAC clone.

## Honesty / not claimed

N=16384 **was hosted** (banner, `G_N=16384`, MEM_DEPTH=286514 TB-only,
`N_DROP` ABSENT). 8/8 planted retrieve is this bag's unknown. It does
**not** close C1 800k, Master evidence-recall ≥95%, candidate-reduction
≥90%, BOARD_PASS, ACCEPT_BOARD, N=65536, or true NL hold-out.

Unseen retrieves remain occupancy-small (AND identity). Fill-template
gold is still the 3-id reserved plant `{120,121,122}`. Unbound negative
is a hard-empty k1. Index is `axi_mem_model`, not MIG/DDR.
`CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN.

## CLASS table (raw)

| class | gold | emit | tp | incomp | notes |
|---|---|---|---|---|---|
| fill_template | {120,121,122} | {120,121,122} | 3 | 0 | cartesian control; occ=121 |
| unseen_sro_123 | {123} | {123} | 1 | 0 | SRO=(1,1,2) ∉ cart; k1 occ=2 via nid 125 share |
| unseen_sro_124 | {124} | {124} | 1 | 0 | SRO=(1,2,3) ∉ cart |
| unseen_sro_125 | {125} | {125} | 1 | 0 | SRO=(4,1,2) ∉ cart; k1 occ=2 |
| unseen_sro_126 | {126} | {126} | 1 | 0 | SRO=(6,3,7) ∉ cart |
| unseen_sro_127 | {127} | {127} | 1 | 0 | SRO=(10,1,11) ∉ cart; not psc clone |
| unseen_sro_128 | {128} | {128} | 1 | 0 | SRO=(9,8,2) ∉ cart |
| unseen_sro_129 | {129} | {129} | 1 | 0 | SRO=(12,5,6) ∉ cart |
| unseen_sro_130 | {130} | {130} | 1 | 0 | SRO=(3,6,4) ∉ cart |
| unbound_sro | [] | [] | 0 | 0 | SRO=(13,4,1) not indexed; no {120,121,122} |
| unrelated | [] | [] | 0 | 0 | UNRELATED_EMPTY_WALK |

## Instantiation / KEEP

- Ctx keys `a7ng_query_role_keys_ctx.sv` `124be808…` instantiate, mtime 14:03:07, **not edited**.
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` `8255a798…` instantiate as DUT, mtime 14:03:24, **not edited**.
- STREAM-02 `14f75db7…` mtime 11:43:39 **not compiled as DUT**.
- PAGE-SKIP `dab15d76…` **not compiled**.
- leftover A09 **not compiled**. `poke_v=0`.
- Named lexicon `df0e8833…` copied mtime 14:49:07 (byte-identical KEEP 16k).
- Corpus `6991adc7…` copied mtime 17:29:38 (KEEP 16K GOLDEN stamp).
- KEEP `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` unmodified (CLOSEOUT 17:52:43).
- Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` unmodified (max 10:52:29).
