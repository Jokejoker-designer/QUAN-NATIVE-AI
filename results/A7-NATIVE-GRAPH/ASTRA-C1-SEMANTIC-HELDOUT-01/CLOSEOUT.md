# CLOSEOUT — ASTRA-C1-SEMANTIC-HELDOUT-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-SEMANTIC-HELDOUT-01
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
XSIM                 = ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS emitted
FAIL_R0              = not written (PASS session)
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header"
PARAPHRASE_HIT       = tp=3 emit={120,121,122} text="what does the boiler feed to the header"
WRONG_CONTEXT_EMIT   = {121}  ≠ fill_template; CONTEXT_SELECTIVE
WRONG_CONTEXT_KEYS   = k0=3380 k1=3636 vs fill_template k0=3332 k1=3588
LATE_GOLD_NID        = 16382
LATE_GOLD_HIT        = 1  (emit={16382}; SEARCH_INCOMPLETE ABSENT; k0_idx=16 k1_idx=33)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 120
N_RELS               = 8
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
MEM_DEPTH            = 286517 (TB-only)
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
WRONG_CONTEXT        = CONTEXT_SELECTIVE (glycol ctx_id=3 folded into k0/k1)
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 15:44:21; xvlog 15:45:15; live MATCH PRE)
PID                  = 61968
SIM_TIME             = 39395 ns
XSIM_SHA             = 38ed2631d50c650791d87334141465f39d3b19b2497b18f3967b8ce0d425b446
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited (GOLDEN 14:49:09 CLOSEOUT 15:18:52)
PRIOR_BAG_CONTEXT02  = ASTRA-C1-CONTEXT-02 NOT edited (GOLDEN 14:12:02)
PRIOR_BAG_PAGE_SKIP  = ASTRA-C1-PAGE-SKIP-01 NOT edited (GOLDEN 13:34:19)
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited (GOLDEN 11:43:45)
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = Index fill is still the SEMANTIC-16K cartesian
                       {ent} {rel} {ent} generator (N=16384, 120 subj, 8 rel).
                       Gold QUERIES for paraphrase / role-reversal /
                       wrong-relation / wrong-context / occupancy / overflow /
                       sentinel / late-gold do not match that regex. Frozen
                       extract still binds them to the labeled SRO. Fill-template
                       control still hits. Does not close C1 800k / Master ≥95%.
                       PLAN bag 7 remainder still OPEN (not 800k / N=65536).
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
Does not close C1 800k. Never ACCEPT_BOARD. Never BOARD_PASS.
Do not regenerate gold. Do not patch C0 RTL. Do not drop threshold.
Do not set `relevant=router_union`. Do not use nid-derived keys.
Do not freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`.
Do not edit STREAM-02 walker `14f75db7…`. Do not edit PAGE-SKIP `dab15d76…`.
Do not edit ctx keys `124be808…` / context DUT `8255a798…`.
Do not patch `a7ng_sparse_dir_axi.sv`. Do not write the independent audit tree.
Do not edit KEEP SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02.
