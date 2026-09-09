# RESULTS — ASTRA-C1-N65536-SCALE-01

Authority = raw `xsim.log` (SHA `deb617d59fd27b2ef1df35b87f76c4e5e4e81b2f60aba312b14e964e4ec67c1b`)
+ `GOLD_HASH_PRE_XVLOG.txt` + live Get-FileHash. PROGRAM=NO.

```text
RESULT               = PASS_THIS_GATE_ONLY
MARKER               = ASTRA_C1_N65536_SCALE_XSIM_PASS PRESENT
FAIL                 = 0
N                    = 65536
N_ADDRESSABLE        = 65536
N_BUCKETS            = 65536
CAND_CAP             = 16
PROC_MEM             = 1
LAW                  = qse-v2-relctx-synonym-01
LEX                  = qse-v2-lex-semantic-800k-01
EXTRACT              = qse-v2-role-00 frozen cd7baf49 unedited
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
SEARCH_INCOMPLETE    = absent on gold retrieve
C1_800K_CLOSE        = NOT_CLAIMED
```

## CLASS table (raw xsim.log)

| class | gold | emit | tp | rec_x1000 | notes |
|---|---|---|---|---|---|
| fill_template | {120,121,122} | {120,121,122} | 3 | 1000 | FILL_TEMPLATE_HIT occ=102 REDUCTION_VS_N_X1000=998 |
| nl_synonym | {120,121,122} | {120,121,122} | 3 | 1000 | NL_GOLD_HIT; not nid 131 |
| late_gold | {65534} | {65534} | 1 | 1000 | LATE_GOLD_HIT nid=65534 |
| high_id_sentinel | {65535} | {65535} | 1 | 1000 | HIGH_ID_HIT nid=65535 |
| unrelated | {} | {} | 0 | n/a | UNRELATED_EMPTY_WALK |

Does **not** close Master C1, BOARD_PASS, C2, or the Grok 800k-01 ACCEPT_PARTIAL bound.
