# CLOSEOUT — ASTRA-C1-N800000-SCALE-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-N800000-SCALE-01
LAW                  = qse-v2-relctx-synonym-01
XSIM                 = ASTRA_C1_N800000_SCALE_XSIM_PASS PRESENT
FAIL_COUNT_FINAL     = 0
G_NQ                 = 11
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122}
PARAPHRASE           = tp=3 emit={120,121,122} (same keys as fill; not synonym)
NL_GOLD_HIT          = tp=3 emit_has_131=0 frozen keys_match=0 syn=1
ROLE_REVERSAL_HIT    = nid=4602 leak_fill=0
WRONG_RELATION       = nid=802
WRONG_CONTEXT        = nid=121 keys 3380/3636 (procedural occ=1 special-case)
DISTRACTOR           = nid=603 leak_fill=0
HIGH_OCCUPANCY       = nid=17206 list occ>=16 AND emit=1
LATE_GOLD_HIT        = nid=799998 emit_n=1
HIGH_ID_HIT          = nid=799999 emit_n=1
UNRELATED            = empty walk
N                    = 800000
N_SUBJECTS           = 201
N_RELS               = 20
CAND_CAP             = 16
PROC_MEM             = bag procedural AXI; not MIG
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
REDUCTION_VS_N_X1000 = 999 (retrieve classes; unrelated 1000)
SEARCH_INCOMPLETE    = absent on gold retrieve
SIM_TIME             = 59025 ns
XSIM_SHA             = 92aad0c74ff2941fa9f6831be506f25f16dfd01fbd5de394a4477edbba1b93c1
PRIOR_BAG_800K       = ASTRA-C1-SEMANTIC-800K-01 NOT edited
                       (Grok auditor ACCEPT_PARTIAL 20260907T2045Z)
QUALITY_NOTE         = Master §7 800k-scale class set on cartesian procedural
                       image. Does not close Master C1 / BOARD_PASS / C2.
                       Does not freeze CAND_CAP_FINAL. Cap sweep is next.
                       1-pair synonym. AXI mem not MIG. Cube truncated.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Do not regenerate gold. Do not stamp C1 CLOSED from this bag.
