# CLOSEOUT — ASTRA-C5-UNIFIED-REGRESSION-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_UNIFIED_REGRESSION_MIG_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: same C5 production hierarchy through official `mig_sim` + `ddr3_model`.
UART classes after flush (`0x0C`) / reload (`0x12`): UNKNOWN, role reversal,
parser AMB, teacher-off (`0x14`), SEARCH_INCOMPLETE (overflow dir `rdata[48]`).
GOLDEN hash unchanged `74a40c30a66dd8d403618c3a41e476f15d5672056220967ae11213c51e749a24`.
KEEP C0/C1/C2 unedited (`a7ng_astra_c2_persist_commit.sv` `86a7a069…`). Plant stays in TB.
TB-only `defparam TO_CYC=65535`. UART sim baud 8000/800.

r1 TB-only: `plant_index_ovf` clears `plant=0` after AXI writes and waits DUT AXI idle
before Q6. r0 archived FAIL (`xsim_fail_r0.log`): `plant` stuck 1 after overflow writes,
DUT AR muxed off MIG, Q6 hung. GOLDEN not regenerated.

Measured (not Master close, not silicon):
- `CLASS_mig_calib_complete HIT t=122810625.0 ps`
- `CLASS_two_hop_answer HIT` Q1 dest=64 w0=3 pvalid=1
- `CLASS_flush_w0_zero HIT` pvalid=0
- `CLASS_c2_persist_reload HIT` w0=3 saved=3 pvalid=1 guard=0 owner=5 pph=4
- `CLASS_unrelated_unknown HIT` Q2 st=1
- `CLASS_role_reversal HIT` Q3 st=1 obj=10
- `CLASS_parser_amb HIT` Q4 st=7
- `CLASS_teacher_off HIT` Q5 cap=0 w0=3 pcmt=0
- `CLASS_search_incomp HIT` Q6 st=6
- `CLASS_one_ddr_owner HIT` nsw=42 dual=0
- `CLASS_no_qid_map` / `CLASS_no_host_winner` / `CLASS_no_a09_top` / `CLASS_no_plant_in_dut` HIT
- `$finish` 314642625 ps
- Wrapper `ASTRA_C5_UNIFIED_REGRESSION_MIG_RUN_OK` exit=0 ~974 s wall

Quality bound: UART sim baud, KEEP C3 has no CONFLICT opcode, compact LM not 802k.
Does not freeze `DDR_QUERY_BOUND_FINAL` or program silicon.
