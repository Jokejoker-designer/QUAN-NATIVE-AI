# CLOSEOUT — ASTRA-C1-SEMANTIC-NL-01

```text
RESULT               = FAIL NOT_SELECTIVE_NL
TASK                 = ASTRA-C1-SEMANTIC-NL-01
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
XSIM                 = ASTRA_C1_SEMANTIC_NL_XSIM_PASS NOT emitted
NO_MARKER            = ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER
NOT_SELECTIVE_NL     = PRESENT (keys_match=0 AND fill-meaning gold MISS)
FAIL_R0              = written (copy of xsim.log; gold NOT regenerated)
FAIL_COUNT_FINAL     = 1
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header" occ=121 incomp=0
NL_PROBE             = "what does the boiler supply to the header"
KEYS_VS_FILL         = k0=3329 k1=3585 vs fill k0=3332 k1=3588 keys_match=0
NL_GOLD_HIT          = 0 (emit={131} gold={120,121,122} tp=0 missed=3)
HELDOUT_NOT_THIS     = "what does the boiler feed to the header" same keys 3332/3588
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
GOLD_AFTER_FAIL      = NO (gold hashed 19:05:03; SHA256 19:05:31; xvlog 19:05:32;
                       live MATCH PRE; corpus/lex not regenerated; FAIL_R0 is
                       xsim.log copy only)
PID                  = 62740
SIM_TIME             = 9455 ns
XSIM_SHA             = 1ff11f304e579e954832c06e5fc2c5216f22f7f41df24cfa774151d872165db5
PRIOR_BAG_R2         = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 NOT edited
                       (GOLDEN 18:19:54 CLOSEOUT 18:34:48)
PRIOR_BAG_UNSEEN16K  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 NOT edited
                       (GOLDEN 17:29:38 CLOSEOUT 17:52:43)
PRIOR_BAG_UNSEEN256  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 NOT edited
PRIOR_BAG_HELDOUT    = ASTRA-C1-SEMANTIC-HELDOUT-01 NOT edited
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited
PRIOR_BAG_CONTEXT02  = ASTRA-C1-CONTEXT-02 NOT edited
PRIOR_BAG_PAGE_SKIP  = ASTRA-C1-PAGE-SKIP-01 NOT edited
PRIOR_BAG_STREAM02   = ASTRA-C1-STREAM-INTERSECT-02 NOT edited
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = Frozen QSE cannot bind a non-alias synonym to
                       different keys that still retrieve fill-meaning gold.
                       "supply"→rel id 1 vs "feeds"→rel id 4 produces
                       keys_match=0 and retrieves nid 131 (indexed
                       "boiler supplies header"), not {120,121,122}.
                       Fill-template control still hits. N=16384 hosted.
                       Does not close C1 800k / Master ≥95% / N=65536 /
                       BOARD_PASS. Do not fake keys. Do not edit C0 lexicon.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
