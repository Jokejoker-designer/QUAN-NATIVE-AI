# CLOSEOUT — ASTRA-C1-CAND-CAP-SWEEP-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-C1-CAND-CAP-SWEEP-01
GOLD                 = frozen copy of ASTRA-C1-N800000-SCALE-01 (not regenerated)
CAPS_RUN             = 16, 64, 128, 256
ALL_CAPS_PASS        = yes (identical emit_n / TOTAL_AXI_BYTES)
FILL_EMIT            = 3 at every cap
MAX_TOTAL_AXI_BYTES  = 1632 (late_gold; same at every cap)
REDUCTION_VS_N_X1000 = 999
CAND_CAP_CANDIDATE   = 16 (smallest tested; cartesian AND emit<=3)
DDR_QUERY_BOUND_CANDIDATE_BYTES = 1632 (max live TOTAL_AXI_BYTES = R-path)
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
C1_800K_CLOSE        = NOT_CLAIMED
C2                   = NOT_STARTED
COMBO_XSIM_SHA       = 9d95f83ecd3710060bf8d28dc08d98781d7dc5219add3dc466856ce716fe1b0a
QUALITY_NOTE         = Cap is not the binding constraint on this cartesian
                       image. Raising cap 16→256 does not change emit or AXI
                       bytes. Implementer does not freeze FINAL bounds.
                       cap<3 would fail fill gold_n=3; not a candidate.
```

Authority: `xsim_cap_16.log` … `xsim_cap_256.log`, concatenated `xsim.log`.
Do not stamp Master C1 CLOSED / BOARD_PASS from this sweep.
