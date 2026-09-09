# CLOSEOUT — ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
XSIM                 = ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS emitted
UNSEEN_SRO_8_OF_8_HIT = PRESENT (nids 123..130)
FAIL_R0              = not written (PASS session)
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header" occ=121 incomp=0
UNSEEN_SRO_HIT       = 8/8
                       nid=123 text="chiller supplies condenser"        SRO=(1,1,2)
                       nid=124 text="chiller requires evaporator"       SRO=(1,2,3)
                       nid=125 text="compressor supplies condenser"     SRO=(4,1,2)
                       nid=126 text="ahu connects duct"                 SRO=(6,3,7)
                       nid=127 text="pump supplies valve"               SRO=(10,1,11)
                       nid=128 text="tower discharges condenser"        SRO=(9,8,2)
                       nid=129 text="sensor isolates ahu"               SRO=(12,5,6)
                       nid=130 text="evaporator bypasses compressor"    SRO=(3,6,4)
UNBOUND_EMPTY_WALK   = emit_n=0 text="boiler feeds chiller" SRO=(13,4,1) occ_k0=121
UNBOUND_FILL_GRID    = ABSENT (did not emit {120,121,122})
PLANTED_N            = 8 (nids 123..130; ALL queried this bag)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 127
N_RELS               = 8
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
MEM_DEPTH            = 286514 (TB-only)
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
KEY_INTERSECT_DUT    = not compiled as DUT; KEEP MATCH a912786f…
STREAM02_DUT         = not compiled as DUT; KEEP MATCH 14f75db7…
PAGE_SKIP_DUT        = not compiled as DUT; KEEP MATCH dab15d76…
RELBIND_KEYS         = not compiled; KEEP MATCH 93811ed1…
C0_DIR_FILE          = UNEDITED 09334e42… (parameter N_BUCKETS=65536 instantiate)
C0_LEXICON_FILE      = UNEDITED 38189974… (NOT runtime this bag)
C0_EXTRACT           = UNEDITED cd7baf49…
CTX_KEYS             = instantiate MATCH 124be808… NOT edited (mtime 14:03:07)
CTX_DUT              = instantiate MATCH 8255a798… NOT edited (mtime 14:03:24)
NEW_LEXICON          = qse_role_lexicon_semantic_16k.svh df0e8833… copied
                       mtime 14:49:07; xvlog -i $bag FIRST; include-name bag shim
CORPUS               = KEEP copy SHA 6991adc7… mtime 17:29:38 NOT rewritten
PROGRAM              = NO
C1_800K              = OPEN
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK
SEARCH_INCOMPLETE    = ABSENT
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 18:19:54; xvlog 18:20:11;
                       live MATCH PRE; corpus/lex not regenerated)
PID                  = 22308
SIM_TIME             = 16545 ns
XSIM_SHA             = ea8581ee5bc7b28891b6643cd0f9ff148917a1e0cc3c5e23f79446294e921627
PRIOR_BAG_UNSEEN16K  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 NOT edited
                       (GOLDEN 17:29:38 CLOSEOUT 17:52:43)
PRIOR_BAG_UNSEEN256  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 NOT edited
PRIOR_BAG_HELDOUT    = ASTRA-C1-SEMANTIC-HELDOUT-01 NOT edited
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited
PRIOR_BAG_CONTEXT02  = ASTRA-C1-CONTEXT-02 NOT edited
PRIOR_BAG_PAGE_SKIP  = ASTRA-C1-PAGE-SKIP-01 NOT edited
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = N=16384 cartesian fill over NEW_SUBJ_IDS={13..132}
                       plus 8 off-grid C0 HVAC plants at nids 123–130
                       (KEEP corpus copy). This bag queries ALL 8 plants
                       and each retrieves its nid (8/8 HIT). Unbound
                       SRO=(13,4,1) is not indexed, shares fill-grid k0
                       (occ=121), emits empty (not {120,121,122}).
                       Fill-template control still hits {120,121,122}.
                       N was hosted (MEM_DEPTH=286514); not a silent drop
                       to N=256. Does not close C1 800k / Master ≥95% /
                       N=65536 / BOARD_PASS / true NL.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Never ACCEPT_BOARD. Never BOARD_PASS.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not edit STREAM-02 walker `14f75db7…`. Do not edit PAGE-SKIP `dab15d76…`.
Do not edit ctx keys `124be808…` / context DUT `8255a798…`.
Do not patch `a7ng_sparse_dir_axi.sv`. Do not write the independent audit tree.
Do not edit KEEP UNSEEN-SRO-16K-01 / UNSEEN-SRO N=256 / HELDOUT /
SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02.
