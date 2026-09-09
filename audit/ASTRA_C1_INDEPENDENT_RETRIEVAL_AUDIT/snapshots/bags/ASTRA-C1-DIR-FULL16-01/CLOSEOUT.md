# CLOSEOUT — ASTRA-C1-DIR-FULL16-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-DIR-FULL16-01
LAW                  = qse-v2-stream-intersect-02
N_BUCKETS            = 65536 (16-bit exact bucket = key[15:0])
XSIM                 = ASTRA_C1_DIR_FULL16_XSIM_PASS emitted
FAIL_R0              = not written (no ALIAS_12BIT_COLLISION_EMIT;
                       no DISTRACTOR_LEAK; no SEARCH_INCOMPLETE; PASS session)
FAIL_COUNT_FINAL     = 0
ALIAS_HIGH_NID       = 221  (subj=26 boiler rel=1 obj=27 header)
ALIAS_HIGH_K0        = 6657 = 0x1A01
ALIAS_HIGH_K1        = 6913 = 0x1B01
ALIAS_LOW_NID        = 108  (subj=10 pump  rel=1 obj=11 valve)
ALIAS_LOW_K0         = 2561 = 0x0A01  (share bits[11:0] with high)
FULL16_HIT           = 1  (emit={221})
FULL16_NO_12BIT_COLLISION = 1  (nid 108 absent from high emit)
ALIAS12_WOULD_COLLIDE    = 1  (12-bit AND would emit {108,221})
DIR16_AR_HIGH_NIBBLE = 1  (table-0 directory AR key >= 4096)
DIRECT_TP            = 3  (gold hits {110,144,145}; prec_all_x1000=1000)
LEAK_N               = 0
SEARCH_INCOMPLETE    = ABSENT
N                    = 256
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
PAGE_BUFFER_BEATS    = 1
RARE_LIST_FIRST      = 1
MEM_DEPTH            = 272384 (TB-only; 4*65536*16 directory + postings)
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
KEY_INTERSECT_DUT    = not compiled as DUT; KEEP MATCH a912786f…
RELBIND_KEYS         = instantiated not edited 93811ed1…
DUT_STREAM           = a7ng_query_axi_sparse_stream_intersect.sv 14f75db7…
                       MATCH STREAM-02; mtime 11:43:39; NOT edited this bag
                       instantiated .N_BUCKETS(65536) (parameter; no wrapper)
DUT_DIR              = a7ng_sparse_dir_axi.sv 09334e42… mtime 2026-09-05 19:31:03
                       instantiated N_BUCKETS=65536; FILE not patched
C0_LEXICON_FILE      = qse_role_lexicon.svh 38189974… mtime 2026-09-05 20:51:03
                       FILE unedited; bag include-path copy adds boiler=26
                       header=27 so extract can emit keys with bits[15:12]!=0
PROGRAM              = NO
C1_800K              = OPEN
N_16384              = NOT this bag
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK (not 0/0 as 1000/1000)
WRONG_CONTEXT        = NOT_SELECTIVE (k0–k3 match direct; emit_match=1; xid not a key)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 12:44:33; xvlog 12:44:47; live MATCH PRE)
PRIOR_BAG_KEY_IX     = ASTRA-C1-KEY-INTERSECT-01 NOT edited (GOLDEN 10:16:50 d3b5b883…)
PRIOR_BAG_N4096      = ASTRA-C1-N4096-INTERSECT-01 NOT edited (GOLDEN 10:46:42 095ca715…)
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited (GOLDEN 11:43:45 05c6e087…)
PRIOR_BAG_N4096ST    = ASTRA-C1-N4096-STREAM-02 NOT edited (GOLDEN 12:10:22 2a2db8c8…)
PRIOR_BAG_AXI_BEAT   = ASTRA-C1-AXI-BEAT-ACCOUNTING-01 NOT edited (CLOSEOUT 11:11:09)
INDEP_TREE           = UNMODIFIED (PLAN.md 10:52:29)
QUALITY_NOTE         = FULL16 65536-bucket walk retrieves nid 221 for
                       "boiler supplies header" (k0=6657) and does not emit
                       12-bit alias nid 108 (pump supplies valve, k0=2561);
                       same pair on 4096 buckets would AND-merge {108,221};
                       DUT AR proved key>=4096; CLASS_direct still {110,144,145};
                       does not close C1 800k / N=16384 / Master ≥95%
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Does not promote N=16384. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not start page-skip / context / 800k from this closeout.
