# PREREG — ASTRA-C5-UNIFIED-REGRESSION-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out
KEEP, C4 adapters, `a7ng_lm_graph_arb.sv`, leftover A09, frozen LM-06
`tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.
Does not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

Live DUT `a7ng_astra_c5_prod_top.sv` already holds CKPT grant across UART
`0x12`→EOL (`reload_pend || p_busy`). Plant stays in this TB (MIG AW mux).
TB-only `defparam TO_CYC=65535`.

## One unknown

Can the same C5 production hierarchy, through official `mig_sim` + `ddr3_model`,
measure the modeled unified UART classes (UNKNOWN, role reversal, parser AMB,
teacher-off, SEARCH_INCOMPLETE) after MIG flush/reload already PASSed?

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_two_hop_answer
CLASS_flush_w0_zero
CLASS_c2_persist_reload
CLASS_unrelated_unknown
CLASS_role_reversal
CLASS_parser_amb
CLASS_teacher_off
CLASS_search_incomp
CLASS_one_ddr_owner
CLASS_no_qid_map / host_winner / a09 / plant_in_dut
```

## Out of scope (quality bound)

- KEEP C3 has no CONFLICT opcode
- TinyGPT-802k / 90% grounded language
- Silicon UART baud / C7
- C6 whole-chip rebuild
- 800k corpus

## FAIL if

- KEEP hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- bag claims C5_MASTER closed
