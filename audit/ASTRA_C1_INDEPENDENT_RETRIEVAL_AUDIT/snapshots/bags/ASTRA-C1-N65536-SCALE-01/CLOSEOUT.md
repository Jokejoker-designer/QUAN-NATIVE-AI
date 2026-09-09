# CLOSEOUT — ASTRA-C1-N65536-SCALE-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-N65536-SCALE-01
LAW                  = qse-v2-relctx-synonym-01
CTX_LAW              = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-800k-01
XSIM                 = ASTRA_C1_N65536_SCALE_XSIM_PASS PRESENT
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header"
NL_PROBE             = "what does the boiler supply to the header"
NL_GOLD_HIT          = tp=3 emit={120,121,122} emit_has_131=0
LATE_GOLD_HIT        = nid=65534 emit_n=1
HIGH_ID_HIT          = nid=65535 emit_n=1
N                    = 65536
N_ADDRESSABLE        = 65536 (procedural cartesian; not 16k clone)
N_BUCKETS            = 65536
N_SUBJECTS           = 101
N_RELS               = 8
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
PROC_MEM             = bag a7ng_axi_mem_proc_800k.sv; C0 dense mem NOT compiled
POKE_V               = 0
PROGRAM              = NO
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_VS_N_X1000 = 998 (fill/nl/late/high); 1000 unrelated
REDUCTION_X1000      = not printed as cap-over-N tautology
UNRELATED            = UNRELATED_EMPTY_WALK
SEARCH_INCOMPLETE    = absent on gold_n>=1 retrieve
GOLD_AFTER_FAIL      = gold hashed BEFORE xvlog; fail_r0 was TB gen
                       (g_cidx then G_SEN_NID); gold not regenerated
SIM_TIME             = 15625 ns
XSIM_SHA             = deb617d59fd27b2ef1df35b87f76c4e5e4e81b2f60aba312b14e964e4ec67c1b
PRIOR_BAG_800K       = ASTRA-C1-SEMANTIC-800K-01 NOT edited
                       (Grok auditor ACCEPT_PARTIAL 20260907T2045Z)
QUALITY_NOTE         = Master §7 65k rung only. Does not close 800k /
                       BOARD_PASS / CAND_CAP_FINAL / DDR / C2 / Master C1.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
