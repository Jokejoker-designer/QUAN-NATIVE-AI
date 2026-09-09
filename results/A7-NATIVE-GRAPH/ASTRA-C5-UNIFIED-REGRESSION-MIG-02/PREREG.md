# PREREG — ASTRA-C5-UNIFIED-REGRESSION-MIG-02

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, leftover A09,
`a7ng_lm_graph_arb.sv`, frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.
Does not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

Live C3 wrap already emits `A7NG_C3_ST_CONFLICT=5`. TB-only `defparam TO_CYC=65535`.
`plant=0` after AXI plant. After CONFLICT, restore distractor facts 18/19 only
(do not rewrite C2 checkpoint).

## One unknown

Can the same C5 production hierarchy, through official `mig_sim` + `ddr3_model`,
emit polarity CONFLICT (`st=5`, ans=0, no persist commit) on dest 64 in the
same UART session that then still measures flush/reload, UNKNOWN, role reversal,
parser AMB, teacher-off, and SEARCH_INCOMPLETE?

Two positive destinations still rank. Polarity contradiction only.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_two_hop_answer
CLASS_conflict
CLASS_conflict_no_upd
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

- TinyGPT-802k / 90% grounded language
- Silicon UART baud / C7
- C6 whole-chip rebuild
- 800k corpus

## FAIL if

- KEEP hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- bag claims C5_MASTER closed
