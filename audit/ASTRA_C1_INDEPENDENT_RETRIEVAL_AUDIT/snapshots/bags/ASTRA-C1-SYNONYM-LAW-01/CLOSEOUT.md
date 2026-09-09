# CLOSEOUT — ASTRA-C1-SYNONYM-LAW-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-SYNONYM-LAW-01
LAW                  = qse-v2-relctx-synonym-01
CTX_LAW              = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833)
XSIM                 = ASTRA_C1_SYNONYM_LAW_XSIM_PASS PRESENT
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header" occ=121 incomp=0
NL_PROBE             = "what does the boiler supply to the header"
FROZEN_KEYS_VS_FILL  = k0=3329 k1=3585 vs fill k0=3332 k1=3588 keys_match=0
SYN_KEYS_VS_FILL     = k0=3332 k1=3588 keys_match=1 syn_hit=1
NL_GOLD_HIT          = tp=3 emit={120,121,122} gold={120,121,122} emit_has_131=0
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
CTX_KEYS             = instantiate MATCH 124be808… NOT edited
CTX_DUT              = KEEP MATCH 8255a798… NOT compiled as DUT NOT edited
NEW_SYN_SVH          = qse_relctx_synonym_01.svh 551655a1…
NEW_SYN_MOD          = a7ng_query_role_relctx_synonym.sv e862208c…
NEW_DUT              = a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e…
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
GOLD_AFTER_FAIL      = N/A (PASS; gold hashed 19:49:47; SHA256 19:50:25; xvlog 19:50:26;
                       live MATCH PRE; corpus/lex not regenerated)
SIM_TIME             = 9535 ns
XSIM_SHA             = fe4b0ac4690868abed79a1a108d2bc566e75b5150fed2637088b24b24844068b
PRIOR_BAG_NL         = ASTRA-C1-SEMANTIC-NL-01 NOT edited (GOLDEN 19:05:03 SHA 6fa2a93f honest FAIL)
PRIOR_BAG_R2         = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 NOT edited
PRIOR_BAG_UNSEEN16K  = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 NOT edited
PRIOR_BAG_HELDOUT    = ASTRA-C1-SEMANTIC-HELDOUT-01 NOT edited
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited
PRIOR_BAG_CONTEXT02  = ASTRA-C1-CONTEXT-02 NOT edited
INDEP_TREE           = UNMODIFIED (max mtime 10:52:29; not written)
QUALITY_NOTE         = Named synonym overlay remaps supply REL id=1 → feeds id=4
                       after frozen extract. Frozen keys stay 3329/3585 (C0
                       unpatched). DUT keys 3332/3588 retrieve fill-meaning
                       gold {120,121,122}, not cartesian nid 131. Fill-template
                       control still hits. N=16384 hosted. Does not close
                       C1 800k / Master ≥95% / N=65536 / BOARD_PASS.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
