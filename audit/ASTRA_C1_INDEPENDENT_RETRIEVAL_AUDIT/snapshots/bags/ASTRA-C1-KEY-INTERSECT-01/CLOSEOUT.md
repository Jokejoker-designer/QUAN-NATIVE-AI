# CLOSEOUT — ASTRA-C1-KEY-INTERSECT-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-KEY-INTERSECT-01
LAW                  = qse-v2-intersect-01
XSIM                 = ASTRA_C1_KEY_INTERSECT_XSIM_PASS emitted
FAIL_R0              = not written (no DISTRACTOR_LEAK; PASS session)
FAIL_COUNT_FINAL     = 0
LEAK_N               = 0
DISTRACTOR_GOLD_N    = 11 (EXCLUDED; query "pump supplies chiller")
DISTRACTOR_TP        = 0
DISTRACTOR_REC       = undef (not 1000)
DIRECT_TP            = 3  (gold hits {110,144,145}; prec_ev1_x1000=1000)
N                    = 256
CAND_CAP             = 16
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
RELBIND_SPARSE       = not compiled as DUT
RELBIND_KEYS         = instantiated not edited 93811ed1…
NEW_RTL              = a7ng_query_axi_sparse_intersect.sv a912786f…
PROGRAM              = NO
C1_800K              = OPEN
N_4096               = NOT STARTED
CAND_CAP_FINAL       = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK (not 0/0 as 1000/1000)
WRONG_CONTEXT        = NOT_SELECTIVE (k0–k3 match direct; emit_match=1; xid not a key)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 10:16:50; xvlog 10:17:22; live MATCH PRE)
PRIOR_BAG_C1         = ASTRA-C1-N256-ROLE-RETRIEVAL-01 NOT edited
PRIOR_BAG_R2         = ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01 NOT edited
PRIOR_BAG_R3         = ASTRA-C1-N256-R3-DISTRACTOR-01 NOT edited
PRIOR_BAG_RELBIND    = ASTRA-C1-KEY-RELBIND-01 NOT edited
QUALITY_NOTE         = k0∩k1 removes WO/WE union leak (leak 9→0 vs relbind);
                       CLASS_direct still retrieves {110,144,145};
                       does not close C1 800k / N=4096 / Master ≥95%
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Does not start N=4096. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
