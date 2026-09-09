# RESULTS — ASTRA-C1-PAGE-SKIP-01

Authority = raw `xsim.log` CLASS_* / EMIT_* / AXI_BEAT / HOC_POST_R_BEATS /
`LATE_GOLD_HIT` / `ASTRA_C1_PAGE_SKIP_XSIM_PASS`. This file does not promote
C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, or BOARD_PASS.

```text
GATE             = ASTRA-C1-PAGE-SKIP-01
N                = 256
N_BUCKETS        = 4096
CAND_CAP         = 16   (< 256; emit budget after AND; not CAND_CAP_FINAL)
PAGE_N           = 16   IDs / posting page (1 header beat + ceil(nrec/4) data)
LAW              = qse-v2-page-skip-01
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RUNTIME_LEXICON  = C0 59-word 38189974… (xvlog -i C0 query FIRST; no bag shadow)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
WALKER           = sorted-nid two-pointer AND; page header {min,max,nrec};
                   skip remaining POST AR/R when page.max < other cursor;
                   CAND_CAP after emit; SEARCH_INCOMPLETE on budget exhaust
DUT              = a7ng_query_axi_sparse_page_skip.sv dab15d76…
STREAM02_KEEP    = a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… NOT compiled
DIR_FILE         = a7ng_sparse_dir_axi.sv 09334e42… NOT patched
k0,k1            = {subj,rel}/{obj,rel}
k2,k3            = relbind (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_page_skip, query_axi_rbeat_probe,
                   tb_astra_c1_page_skip)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_intersect.sv NOT compiled as DUT (KEEP)
                   a7ng_query_axi_sparse_stream_intersect.sv NOT compiled as DUT (KEEP)
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (13:34:19, before first xvlog 13:38:05)
GOLD_LIVE        = MATCH 86b536fb… / 390dd3de… / 1f0ae9a6…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no LATE_GOLD_MISS; no HOC_POST_R fail;
                   no HOC_NO_PAGE_SKIP; no DISTRACTOR_LEAK)
XSIM_MARKER      = ASTRA_C1_PAGE_SKIP_XSIM_PASS emitted
SIM_TIME         = 18185 ns
PID              = 39224
SESSION          = Mon Sep 7 13:38:10–13:38:12 2026
XSIM_SHA         = 29e38918262536b7f03db9ddb77681b8906ce9db1debc6564548ca2d982bc8d9
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
CAND_CAP_FINAL   = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS       = NOT_CLAIMED
AXI_BEAT_HOC_POST_R_BASELINE = 14
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-DIR-FULL16-01` CLOSEOUT 12:46:50
- KEEP `ASTRA-C1-STREAM-INTERSECT-02` CLOSEOUT 11:45:37 GOLDEN 11:43:45
- KEEP `ASTRA-C1-N4096-STREAM-02` CLOSEOUT 12:12:27 GOLDEN 12:10:22
- KEEP `ASTRA-C1-KEY-INTERSECT-01` CLOSEOUT 10:18:37 GOLDEN 10:16:50
- KEEP `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` CLOSEOUT 11:11:09
- KEEP stream DUT `14f75db7…` (not compiled as DUT)
- KEEP dir FILE `09334e42…` (not patched)
- Independent audit tree not written

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL LATE_GOLD_MISS / FAIL DISTRACTOR_LEAK / FAIL HOC_POST_R / FAIL HOC_NO_PAGE_SKIP).
Gold was **not** regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
Relbind keys `93811ed1…`. KEEP intersect `a912786f…` not compiled as DUT.
KEEP STREAM-02 `14f75db7…` not compiled as DUT.

NEW RTL `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…`.

## Unknown (this bag)

At N=256, new named walker `qse-v2-page-skip-01` (posting page min/max skip):

1. CLASS_direct emit IDs bit-identical `{110,144,145}`?
2. high_occupancy `POST_R_BEATS` strictly `< 14` (AXI-BEAT baseline, 256 B)?
3. STREAM-02 late-gold nid 254 in this corpus remains in emit (not hidden by SEARCH_INCOMPLETE)?

Plus: skip must be real (pages not fetched after header). Headers-only with skip=0 is FAIL even if POST_R < 14.

(1) Direct emit: **yes** (`EMIT_direct n=3` ids `110,144,145`; `tp=3`; `prec_all_x1000=1000`; `incomp=0`).

(2) hoc POST_R: **yes** (raw `HOC_POST_R_BEATS=12 AXI_BEAT_BASELINE=14 LT14=1 PAGE_SKIP=2`).
`AXI_BEAT class=high_occupancy DIR_R=2 POST_R=12 R_BYTES=224`.
12 < 14. Two pages skipped (k0 head max=67 < k1 min=103; k1 head max=136 < k0 overflow min=147).
Not packing-density theatre: STREAM-02 hoc already used 10 posting beats; this bag pays header cost and still drops two data pages.

(3) Late gold 254: **yes** (`LATE_GOLD_HIT id=254`; `tp=1`; `incomp=0`; `CAP_THEN_AND_WOULD_MISS id=254 stream_hit=1`).
SEARCH_INCOMPLETE **ABSENT**.

Gate requires FAIL=0 **and** (1)(2)(3) **and** hoc skip>=1 for `PASS_THIS_GATE_ONLY`.
Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, Master evidence-recall ≥95%, or candidate-reduction ≥90%.
Does **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.

## Per-class (authority = xsim.log)

Headline quality number is **precision_all** (`TP/emit_n`). `prec_ev1` is
diagnostic only. AXI_BEAT: `R_BYTES=16*(DIR_R+POST_R)` on `rvalid&&rready`.

| class | emit | DIR_R | POST_R | R_BYTES | skip | notes |
|---|---|---:|---:|---:|---:|---|
| direct | 110,144,145 | 2 | 8 | 160 | 0 | gold {110,144,145} bit-identical |
| paraphrase | 110,144,145 | 2 | 8 | 160 | 0 | same walk as direct |
| role_reversal | 146 | 2 | 7 | 144 | 2 | |
| wrong_relation | 114 | 2 | 4 | 96 | 0 | |
| wrong_context | 110,144,145 | 2 | 8 | 160 | 0 | NOT_SELECTIVE |
| distractor | 110,144,145 | 2 | 8 | 160 | 0 | leak_n=0 excluded |
| unrelated | (empty) | 0 | 0 | 0 | 0 | UNRELATED_EMPTY_WALK |
| high_occupancy | 147..162 | 2 | 12 | 224 | 2 | POST_R 12<14; skip=2 |
| overflow_page | 163..167 | 2 | 8 | 160 | 2 | ovf=1 |
| high_id_sentinel | 255 | 2 | 7 | 144 | 2 | |
| late_gold | 254 | 2 | 16 | 288 | 2 | LATE_GOLD_HIT incomp=0 |

## Not claimed

```text
C1_800K
N_16384
CAND_CAP_FINAL
DDR_QUERY_BOUND_FINAL
BOARD_PASS
ACCEPT_BOARD
ASTRA-13
PRODUCTION_TOP
qse-v2-intersect-context-02
Master_evidence_recall_ge95
Master_candidate_reduction_ge90
relevant=router_union
nid-derived keys
threshold drop
silent C0 patch
bag lexicon shadow
reduction_x1000 as 1-CAND_CAP/N
STREAM-02 walker edit
sparse_dir patch
```
