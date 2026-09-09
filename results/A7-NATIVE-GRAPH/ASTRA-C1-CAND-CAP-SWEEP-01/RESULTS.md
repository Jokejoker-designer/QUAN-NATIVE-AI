# RESULTS — ASTRA-C1-CAND-CAP-SWEEP-01

Authority = concatenated `xsim.log` SHA `9d95f83ecd3710060bf8d28dc08d98781d7dc5219add3dc466856ce716fe1b0a`.
Gold copied from `ASTRA-C1-N800000-SCALE-01` (GOLDEN SHA `3b900979…`). Not regenerated.

```text
RESULT               = PASS_THIS_GATE_ONLY
N                    = 800000
CAPS                 = 16 / 64 / 128 / 256 all PASS
FILL_EMIT            = 3 at every cap
MAX_AXI_BYTES        = 1632 at every cap (late_gold)
REDUCTION_VS_N_X1000 = 999
CAND_CAP_CANDIDATE   = 16
DDR_BOUND_CANDIDATE  = 1632 bytes
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
BOARD_PASS           = NOT_CLAIMED
C1_800K_CLOSE        = NOT_CLAIMED
C2                   = NOT_STARTED
```

Reduction is occupancy-vs-N, not a cap-over-N tautology. Caps above 16 are invariant on this image because AND emit is 1 or 3.
