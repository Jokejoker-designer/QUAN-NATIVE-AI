# CLOSEOUT — ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
XSIM                 = ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS emitted
FAIL_R0              = not written (PASS session)
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header" occ=121 incomp=0
UNSEEN_SRO_HIT       = tp=1 emit={123} text="chiller supplies condenser" SRO=(1,1,2)
UNBOUND_EMPTY_WALK   = emit_n=0 text="boiler feeds chiller" SRO=(13,4,1) occ_k0=121
UNBOUND_FILL_GRID    = ABSENT (did not emit {120,121,122})
PLANTED_N            = 8 (nids 123..130; C0 HVAC ids outside NEW_SUBJ_IDS)
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
PROGRAM              = NO
C1_800K              = OPEN
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 17:29:38; first xvlog 17:30:01;
                       PASS xvlog 17:37:44; live MATCH PRE)
PID                  = 24652
SIM_TIME             = 7265 ns
XSIM_SHA             = cee6e63d48b79cb15c8de492517f84d58fa239cbe34ffb6fc5391db218a50f28
PRIOR_BAG_UNSEEN256  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 NOT edited (CLOSEOUT 17:04:05)
PRIOR_BAG_HELDOUT    = ASTRA-C1-SEMANTIC-HELDOUT-01 NOT edited (CLOSEOUT 16:06:53)
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited (CLOSEOUT 15:18:52)
PRIOR_BAG_CONTEXT02  = ASTRA-C1-CONTEXT-02 NOT edited (CLOSEOUT 14:13:59)
PRIOR_BAG_PAGE_SKIP  = ASTRA-C1-PAGE-SKIP-01 NOT edited
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = N=16384 cartesian fill over NEW_SUBJ_IDS={13..132}
                       (114239 unique SRO generator) plus 8 off-grid C0 HVAC
                       plants at nids 123–130. Planted nid 123 SRO=(1,1,2) is
                       not in that generator and retrieves. Unbound SRO=(13,4,1)
                       is not indexed, shares fill-grid k0 (occ=121), emits
                       empty (not {120,121,122}). Fill-template control still
                       hits {120,121,122}. N was hosted (MEM_DEPTH=286514);
                       not a silent drop to N=256. Does not close C1 800k /
                       Master ≥95% / N=65536 / BOARD_PASS / true NL.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Never ACCEPT_BOARD. Never BOARD_PASS.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not edit STREAM-02 walker `14f75db7…`. Do not edit PAGE-SKIP `dab15d76…`.
Do not edit ctx keys `124be808…` / context DUT `8255a798…`.
Do not patch `a7ng_sparse_dir_axi.sv`. Do not write the independent audit tree.
Do not edit KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 /
PAGE-SKIP / STREAM-02.
