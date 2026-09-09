# RESULTS — ASTRA-C1-N256-ROLE-RETRIEVAL-01

Implementer session ended after XSim. This file quotes **raw `xsim.log`**, not a promotion.

```text
GATE             = ASTRA-C1-N256-ROLE-RETRIEVAL-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW_SEL          = 1
QUERY_LAW        = qse-v2-role-00 (hash cd7baf49… MATCH C0)
PROGRAM          = NO
BIT              = NOT_BUILT
FAIL_R0          = xsim_fail_r0.log  FIRST_DIVERGENCE ROLE_COLLAPSE q=0 (PID 47632, 08:30:36)
CORRECTIVE       = 1 (TB/gold packing; frozen RTL not patched)
XSIM_MARKER      = ASTRA_C1_N256_XSIM_PASS
SIM_TIME         = 15755 ns
PID              = 4532
SESSION          = Mon Sep 7 08:31:59–08:32:01 2026
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt
GOLD_POST        = MATCH (414f9952… / 4b61d88f… / 8c342aa2…)
C1_800K          = OPEN
BOARD_PASS       = NOT_CLAIMED
RESULT_PROPOSED  = PASS_THIS_GATE_ONLY (XSim FAIL=0 after r0; quality caveats below)
```

## Per-class (authority = xsim.log CLASS_* lines)

| class | P | R | prec_x1000 | rec_x1000 | emit | gold | occ | ovf | trunc | incomp | reduction_x1000 |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| direct | 3/16 | 3/3 | 187 | 1000 | 16 | 3 | 14 | 1 | 4 | 0 | 938 |
| paraphrase | 3/16 | 3/3 | 187 | 1000 | 16 | 3 | 14 | 1 | 4 | 0 | 938 |
| role_reversal | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 11 | 1 | 2 | 0 | 938 |
| wrong_relation | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 28 | 1 | 15 | 0 | 938 |
| wrong_context | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 14 | 1 | 4 | 0 | 938 |
| distractor | 0/12 | 0/0 | 0 | 0 | 12 | 0 | 12 | 1 | 0 | 0 | 954 |
| unrelated | 0/0 | 0/0 | 1000 | 1000 | 0 | 0 | 0 | 0 | 0 | 0 | 1000 |
| high_occupancy | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 25 | 1 | 9 | 0 | 938 |
| overflow_page | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 12 | 1 | 1 | 0 | 938 |
| high_id_sentinel | 1/16 | 1/1 | 62 | 1000 | 16 | 1 | 10 | 1 | 2 | 0 | 938 |

`reduction_x1000=938` is `1 - 16/256`. That is **cap/N**, not posting-selectivity. Do not use it as Master “candidate reduction ≥90%” for N≥4096.

Precision is low because occupancy fillers occupy `CAND_CAP`. Recall of labeled gold ids is 1.0 on classes with gold>0 except distractor (gold=0).

## Not claimed

C1 800k. N>256. CAND_CAP_FINAL. BOARD_PASS. ASTRA-13. DDR. Historical U5 close.
