# CLOSEOUT — ASTRA-C1-SEMANTIC-800K-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-SEMANTIC-800K-01
LAW                  = qse-v2-relctx-synonym-01
CTX_LAW              = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-800k-01 (NEW named 023a6f81…)
XSIM                 = ASTRA_C1_SEMANTIC_800K_XSIM_PASS PRESENT
FAIL_COUNT_FINAL     = 0
FILL_TEMPLATE_HIT    = tp=3 emit={120,121,122} text="boiler feeds header" occ=202 incomp=0
NL_PROBE             = "what does the boiler supply to the header"
FROZEN_KEYS_VS_FILL  = k0=3329 k1=3585 vs fill k0=3332 k1=3588 keys_match=0
SYN_KEYS_VS_FILL     = k0=3332 k1=3588 keys_match=1 syn_hit=1
NL_GOLD_HIT          = tp=3 emit={120,121,122} gold={120,121,122} emit_has_131=0
HIGH_ID_HIT          = nid=799999 emit_n=1 incomp=0
N                    = 800000
N_ADDRESSABLE        = 800000 (procedural cartesian; not 16k clone labeled 800k)
N_BUCKETS            = 65536
N_SUBJECTS           = 201
N_RELS               = 20
CAND_CAP             = 16  (after emit; not CAND_CAP_FINAL)
PROC_MEM             = bag a7ng_axi_mem_proc_800k.sv; C0 a7ng_axi_mem_model NOT compiled
POKE_V               = 0
LEFTOVER_A09         = not compiled
FROZEN_AXI_SPARSE    = not compiled as DUT; hash MATCH C0 5a4ad04d…
STREAM02_DUT         = not compiled as DUT; KEEP MATCH 14f75db7…
PAGE_SKIP_DUT        = not compiled as DUT; KEEP MATCH dab15d76…
C0_DIR_FILE          = UNEDITED 09334e42… (parameter N_BUCKETS=65536 instantiate)
C0_LEXICON_FILE      = UNEDITED 38189974… (NOT runtime this bag)
C0_EXTRACT           = UNEDITED cd7baf49…
CTX_KEYS             = instantiate MATCH 124be808… NOT edited
CTX_DUT              = KEEP MATCH 8255a798… NOT compiled as DUT NOT edited
SYN_SVH              = qse_relctx_synonym_01.svh 551655a1… copied, not rewritten
SYN_MOD              = a7ng_query_role_relctx_synonym.sv e862208c… instantiate NOT edited
DUT                  = a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e… instantiate NOT edited
NEW_LEXICON          = qse_role_lexicon_semantic_800k.svh 023a6f81…
                       xvlog -i $bag FIRST; include-name bag shim
CORPUS               = procedural generator metadata SHA 33d9c387… not a 16k dump
PROGRAM              = NO
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
REDUCTION_X1000      = NOT_EMITTED
UNRELATED            = UNRELATED_EMPTY_WALK
SEARCH_INCOMPLETE    = ABSENT
GOLD_AFTER_FAIL      = gold hashed 20:41:44; PRE 20:42:01; fail_r0 20:43:43 was
                       procedural dir-pack (TB gen_800k.svh only); gold still
                       20:41:44 MATCH PRE after PASS
SIM_TIME             = 18825 ns
XSIM_SHA             = 7d0a52ac3a4c19ef8f3990b16294b52cc8d518a20f177058bd80954d6bc394d5
PRIOR_BAG_SYNLAW     = ASTRA-C1-SYNONYM-LAW-01 NOT edited (GOLDEN 19:49:47)
PRIOR_BAG_NL         = ASTRA-C1-SEMANTIC-NL-01 NOT edited
PRIOR_BAG_R2         = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 NOT edited
PRIOR_BAG_SEM16K     = ASTRA-C1-SEMANTIC-16K-01 NOT edited
HISTORICAL_U5        = ASTRA-02-U5-SCALE-SELECTIVITY-800K cannot close C1
INDEP_TREE           = this bag did not write D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
QUALITY_NOTE         = N=800000 hosted on synonym-law stack. Fill-template control
                       HIT {120,121,122}. Sentinel 799999 HIT. Frozen extract still
                       distinguishes supply≠feeds. Does not close BOARD_PASS /
                       Master ≥95% / CAND_CAP_FINAL / DDR.
```

Authority: `xsim.log`, `GOLD_HASH_PRE_XVLOG.txt`, `SHA256.txt`.
