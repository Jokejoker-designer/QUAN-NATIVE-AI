# CLOSEOUT — ASTRA-C1-AXI-BEAT-ACCOUNTING-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-AXI-BEAT-ACCOUNTING-01
LAW                  = qse-v2-intersect-01 (replay; not a new retrieval law)
XSIM                 = ASTRA_C1_AXI_BEAT_XSIM_PASS emitted
FAIL_R0              = not written
FAIL_COUNT_FINAL     = 0
EMIT_IDENTICAL       = 1 (all 10 KEY-INTERSECT GOLDEN classes)
DIRECT_EMIT          = 110,144,145
N                    = 256
CAND_CAP             = 16
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
RELBIND_SPARSE       = not compiled as DUT
RELBIND_KEYS         = instantiated not edited 93811ed1…
INTERSECT_DUT        = instantiated not edited a912786f…
NEW_RTL              = a7ng_query_axi_rbeat_probe.sv a5d0eb3c…
PROGRAM              = NO
C1_800K              = OPEN
N_4096               = KEEP unedited (not this bag)
N_16384              = NOT THIS BAG
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
STREAM_INTERSECT_02  = NOT_THIS_BAG
UNRELATED            = UNRELATED_EMPTY_WALK
WRONG_CONTEXT        = NOT_SELECTIVE
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 11:06:54; SHA freeze 11:09:54;
                       xsim 11:09:59; live MATCH PRE; KEY-INTERSECT copy)
PRIOR_BAG_KEY_IX     = ASTRA-C1-KEY-INTERSECT-01 NOT edited
                       (GOLDEN/corpus/query_gold timestamps 10:16:50 KEEP)
PRIOR_BAG_N4096      = ASTRA-C1-N4096-INTERSECT-01 NOT edited
QUALITY_NOTE         = live R-beats (rvalid&&rready)*16 exceed AR×16:
                       direct 96→112 (RATIO 1166);
                       wrong_relation 80→160 (RATIO 2000);
                       high_occupancy 96→256 (RATIO 2666).
                       AR×16 is not AXI drain. Do not freeze
                       DDR_QUERY_BOUND_FINAL from this bag.
                       Does not close C1 800k / stream-intersect-02.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Does not start stream-intersect-02. Never ACCEPT_BOARD.
Do not regenerate gold. Do not patch C0 RTL. Do not edit KEY-INTERSECT gold.
Do not freeze DDR/CAND bounds.
