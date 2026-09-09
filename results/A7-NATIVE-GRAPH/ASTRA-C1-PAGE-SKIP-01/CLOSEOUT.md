# CLOSEOUT — ASTRA-C1-PAGE-SKIP-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-PAGE-SKIP-01
LAW                  = qse-v2-page-skip-01
XSIM                 = ASTRA_C1_PAGE_SKIP_XSIM_PASS emitted
FAIL_R0              = not written (no LATE_GOLD_MISS; no HOC_POST_R fail;
                       no HOC_NO_PAGE_SKIP; no DISTRACTOR_LEAK; PASS session)
FAIL_COUNT_FINAL     = 0
DIRECT_EMIT          = {110,144,145} bit-identical (tp=3 prec_all=1000 incomp=0)
HOC_POST_R_BEATS     = 12  (AXI-BEAT baseline 14; 12<14)
HOC_PAGE_SKIP        = 2   (real skip: header fetched, data beats omitted)
HOC_R_BYTES          = 224 = 16*(DIR_R=2 + POST_R=12)
LATE_GOLD_NID        = 254
LATE_GOLD_HIT        = 1  (emit={254}; SEARCH_INCOMPLETE ABSENT)
N                    = 256
N_BUCKETS            = 4096
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
PAGE_N               = 16
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
KEY_INTERSECT_DUT    = not compiled as DUT; KEEP MATCH a912786f…
STREAM02_DUT         = not compiled as DUT; KEEP MATCH 14f75db7…
RELBIND_KEYS         = instantiated not edited 93811ed1…
C0_DIR_FILE          = UNEDITED 09334e42…
C0_LEXICON_FILE      = UNEDITED 38189974… (runtime table; no bag shadow)
NEW_RTL              = a7ng_query_axi_sparse_page_skip.sv dab15d76…
PROGRAM              = NO
C1_800K              = OPEN
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK
WRONG_CONTEXT        = NOT_SELECTIVE (k0–k3 match direct; emit_match=1; xid not a key)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 13:34:19; xvlog 13:38:05; live MATCH PRE)
PID                  = 39224
SIM_TIME             = 18185 ns
XSIM_SHA             = 29e38918262536b7f03db9ddb77681b8906ce9db1debc6564548ca2d982bc8d9
PRIOR_BAG_DIR_FULL16 = ASTRA-C1-DIR-FULL16-01 NOT edited (CLOSEOUT 12:46:50)
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited (CLOSEOUT 11:45:37)
PRIOR_BAG_N4096_S02  = ASTRA-C1-N4096-STREAM-02 NOT edited (CLOSEOUT 12:12:27)
PRIOR_BAG_KEY_IX     = ASTRA-C1-KEY-INTERSECT-01 NOT edited (GOLDEN 10:16:50)
PRIOR_BAG_AXI_BEAT   = ASTRA-C1-AXI-BEAT-ACCOUNTING-01 NOT edited (CLOSEOUT 11:11:09)
INDEP_TREE           = UNMODIFIED (not written)
QUALITY_NOTE         = page min/max skip drops two hoc head pages (skip=2) so
                       POST_R=12 < AXI-BEAT 14 while CLASS_direct stays
                       {110,144,145} and late-gold 254 still emits;
                       does not close C1 800k / Master ≥95%
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not edit STREAM-02 walker `14f75db7…`. Do not patch `a7ng_sparse_dir_axi.sv`.
