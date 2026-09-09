# RESULTS — ASTRA-C1-N800000-SCALE-01

Authority = raw `xsim.log` (SHA `92aad0c74ff2941fa9f6831be506f25f16dfd01fbd5de394a4477edbba1b93c1`). PROGRAM=NO.

```text
RESULT               = PASS_THIS_GATE_ONLY
MARKER               = ASTRA_C1_N800000_SCALE_XSIM_PASS PRESENT
N                    = 800000
G_NQ                 = 11 Master §7 class set
FILL                 = {120,121,122}
PARAPHRASE           = {120,121,122}
NL                   = {120,121,122} synonym remap; not nid 131
ROLE_REVERSAL        = 4602
WRONG_RELATION       = 802
WRONG_CONTEXT        = 121
DISTRACTOR           = 603
HIGH_OCCUPANCY       = 17206
LATE                 = 799998
HIGH-ID              = 799999
REDUCTION_VS_N_X1000 = 999
MAX_TOTAL_AXI_BYTES  = 1632 (late_gold; R-path bytes not AR×16)
SEARCH_INCOMPLETE    = absent on gold retrieve
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
C1_800K_CLOSE        = NOT_CLAIMED
C2                   = NOT_STARTED
```

Does **not** edit `ASTRA-C1-SEMANTIC-800K-01`. Does **not** close Master C1.
Cartesian `{ent}{rel}{ent}` + 1-pair synonym + procedural AXI is not mass / BOARD_PASS.
Reduction is occupancy-vs-N, not a cap-over-N tautology.
