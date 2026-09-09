# CLOSEOUT — ASTRA-C5-UNIFIED-REGRESSION-01

PROGRAM=NO. Marker `ASTRA_C5_UNIFIED_REGRESSION_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.

## One unknown

Same C5 production hierarchy after the first UART query: later UART lines
and flush/reload/freeze control bytes measure Master §11 classes that
`ASTRA-C5-PROD-TOP-01` left out of scope.

## Measured (XSim modeled AXI)

```text
CLASS_two_hop_answer HIT          Q1 "pump requires indirect" cap_st=0
CLASS_flush_w0_zero HIT           persist_valid=0 after UART 0x0C
CLASS_c2_persist_reload HIT       persist_w0 restored 3 after UART 0x12
CLASS_unrelated_unknown HIT       Q2 "zzzzqqqqxxxx" cap_st=1
CLASS_role_reversal HIT           Q3 "valve requires pump" cap_st=1 (not ANSWER)
CLASS_parser_amb HIT              Q4 "pump valve requires" cap_st=7
CLASS_teacher_off HIT             Q5 freeze ANSWER, persist_w0 unchanged 3
CLASS_search_incomp HIT           Q6 dir[48] overflow cap_st=6
CLASS_one_ddr_owner HIT nsw=43 dual=0
CLASS_no_qid_map / host_winner / a09 / plant_in_dut HIT
```

`$finish` at 149985 ns. GOLDEN hash frozen before xvlog:
`672c9166f63edd1f9857c262e0237c9f2a21f5f54537f7026e651e59292c137a  GOLDEN.json`

KEEP C0/C1/C2 MATCH. C3 held-out KEEP unedited. `a7ng_lm_graph_arb` unedited.
Live `a7ng_astra_c5_prod_top.sv` looped ST_DONE→ST_UART and muxed CKPT AR
during reload. First xvlog FAIL (reload dead: CKPT only in ST_PERS) is
`xsim_fail_r0.log`. GOLDEN was not regenerated.

## Quality bound (does not close Master C5)

- Modeled AXI, not MIG PHY
- Compact planted 96-slot TB mem, not 800k
- UART sim baud 8000/800
- KEEP C3 has no CONFLICT opcode (parser AMB ≠ ASTRA-05 contradiction)
- Compact LM, not TinyGPT 90%
- Causal edge delete/replace not this bag
- C6 routed bit is now also stale vs this prod_top loop/reload mux
- Independent auditor PENDING

This bag must not self-stamp `C5_MASTER=CLOSED`.
