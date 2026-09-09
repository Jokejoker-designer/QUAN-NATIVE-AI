# CLOSEOUT — ASTRA-C1-STREAM-INTERSECT-02

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-STREAM-INTERSECT-02
LAW                  = qse-v2-stream-intersect-02
XSIM                 = ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS emitted
FAIL_R0              = not written (no LATE_GOLD_MISS; no DISTRACTOR_LEAK; PASS session)
FAIL_COUNT_FINAL     = 0
LATE_GOLD_NID        = 254
LATE_GOLD_K0_INDEX   = 20  (>=16)
LATE_GOLD_K1_INDEX   = 22  (>=16)
LATE_GOLD_HIT        = 1  (emit={254}; cap-then-AND would miss)
DIRECT_TP            = 3  (gold hits {110,144,145}; prec_all_x1000=1000)
LEAK_N               = 0
DISTRACTOR_GOLD_N    = 10 (EXCLUDED; query "pump supplies chiller")
N                    = 256
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
PAGE_BUFFER_BEATS    = 1
RARE_LIST_FIRST      = 1
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
KEY_INTERSECT_DUT    = not compiled as DUT; KEEP MATCH a912786f…
RELBIND_KEYS         = instantiated not edited 93811ed1…
NEW_RTL              = a7ng_query_axi_sparse_stream_intersect.sv 14f75db7…
PROGRAM              = NO
C1_800K              = OPEN
N_4096               = KEEP unedited
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK (not 0/0 as 1000/1000)
WRONG_CONTEXT        = NOT_SELECTIVE (k0–k3 match direct; emit_match=1; xid not a key)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 11:43:45; xvlog 11:43:59; live MATCH PRE)
PRIOR_BAG_KEY_IX     = ASTRA-C1-KEY-INTERSECT-01 NOT edited (GOLDEN 10:16:50 d3b5b883…)
PRIOR_BAG_N4096      = ASTRA-C1-N4096-INTERSECT-01 NOT edited (GOLDEN 10:46:42 095ca715…)
PRIOR_BAG_AXI_BEAT   = ASTRA-C1-AXI-BEAT-ACCOUNTING-01 NOT edited
QUALITY_NOTE         = stream AND-then-cap retrieves late nid 254 that first16∩first16
                       misses; CLASS_direct still retrieves {110,144,145};
                       does not close C1 800k / N=4096 / Master ≥95%
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Does not promote N=4096. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
