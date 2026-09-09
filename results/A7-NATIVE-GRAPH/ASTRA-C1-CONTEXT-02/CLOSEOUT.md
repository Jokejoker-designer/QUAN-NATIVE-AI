# CLOSEOUT — ASTRA-C1-CONTEXT-02

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-CONTEXT-02
LAW                  = qse-v2-intersect-context-02
XSIM                 = ASTRA_C1_CONTEXT_02_XSIM_PASS emitted
FAIL_R0              = not written (PASS session)
FAIL_COUNT_FINAL     = 0
DIRECT_EMIT          = {110,144,145} bit-identical (tp=3 prec_all=1000 incomp=0)
WRONG_CONTEXT_EMIT   = {144}  ≠ direct; CONTEXT_SELECTIVE
WRONG_CONTEXT_KEYS   = k0=2577 k1=273 vs direct k0=2561 k1=257
LATE_GOLD_NID        = 254
LATE_GOLD_HIT        = 1  (emit={254}; SEARCH_INCOMPLETE ABSENT)
N                    = 256
N_BUCKETS            = 4096
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
KEY_INTERSECT_DUT    = not compiled as DUT; KEEP MATCH a912786f…
STREAM02_DUT         = not compiled as DUT; KEEP MATCH 14f75db7… mtime 11:43:39
PAGE_SKIP_DUT        = not compiled as DUT; KEEP MATCH dab15d76… mtime 13:31:29
RELBIND_KEYS         = not compiled; KEEP MATCH 93811ed1…
C0_DIR_FILE          = UNEDITED 09334e42…
C0_LEXICON_FILE      = UNEDITED 38189974… (runtime table; no bag shadow)
C0_EXTRACT           = UNEDITED cd7baf49…
NEW_RTL_KEYS         = a7ng_query_role_keys_ctx.sv 124be808…
NEW_RTL_DUT          = a7ng_query_axi_sparse_intersect_context.sv 8255a798…
PROGRAM              = NO
C1_800K              = OPEN
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK
WRONG_CONTEXT        = CONTEXT_SELECTIVE (C0 water ctx_id=1 folded into k0/k1)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 14:12:02; xvlog 14:12:24; live MATCH PRE)
PID                  = 25508
SIM_TIME             = 16565 ns
XSIM_SHA             = e749c9b0314c69f4b706655348b07505adf13c1ae8d7faaeeff00e76cd010f66
PRIOR_BAG_PAGE_SKIP  = ASTRA-C1-PAGE-SKIP-01 NOT edited (GOLDEN 13:34:19)
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited (GOLDEN 11:43:45)
PRIOR_BAG_DIR_FULL16 = ASTRA-C1-DIR-FULL16-01 NOT edited (GOLDEN 12:44:33)
PRIOR_BAG_N4096_S02  = ASTRA-C1-N4096-STREAM-02 NOT edited (GOLDEN 12:10:22)
PRIOR_BAG_KEY_IX     = ASTRA-C1-KEY-INTERSECT-01 NOT edited (GOLDEN 10:16:50)
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = C0 59-word lexicon already has CLS_CTX tokens
                       (water/air/… id=1, indirect/indirectly id=2). New key
                       module folds ctx into k0/k1 when ctx_valid without
                       patching extract/lexicon. Host dual-indexes plain keys
                       so CLASS_direct still emits {110,144,145}. Wrong-context
                       "pump supplies chiller water" emits {144} only.
                       Does not close C1 800k / Master ≥95%.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not edit STREAM-02 walker `14f75db7…`. Do not edit PAGE-SKIP `dab15d76…`.
Do not patch `a7ng_sparse_dir_axi.sv`. Do not write the independent audit tree.
