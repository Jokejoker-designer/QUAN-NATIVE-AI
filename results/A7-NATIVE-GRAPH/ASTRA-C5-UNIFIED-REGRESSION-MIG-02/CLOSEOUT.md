# CLOSEOUT — ASTRA-C5-UNIFIED-REGRESSION-MIG-02

PROGRAM=NO. Marker `ASTRA_C5_UNIFIED_REGRESSION_MIG_02_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS). Official MIG PHY (`mig_sim` + `ddr3_model`).

## One unknown

Same C5 production hierarchy through official MIG PHY: after Q1 ANSWER dest=64,
a planted negative-polarity 2-hop to the same dest yields CONFLICT (st=5, ans=0,
no persist commit). Distractor facts 18/19 restored (checkpoint not rewritten).
The same UART session then still measures flush/reload, UNKNOWN, role reversal,
parser AMB, teacher-off, and SEARCH_INCOMPLETE.

## Measured (XSim official MIG PHY)

```text
CLASS_mig_calib_complete HIT t=122810625.0 ps
CLASS_two_hop_answer HIT   Q1 st=0 ans=64 p0=16 w0=3
CLASS_conflict HIT         QC st=5 ans=0 p0=0 p1=0
CLASS_conflict_no_upd HIT
CLASS_flush_w0_zero HIT    w0=0
CLASS_c2_persist_reload HIT w0=3
CLASS_unrelated_unknown HIT
CLASS_role_reversal HIT    st=1 obj=10
CLASS_parser_amb HIT       st=7
CLASS_teacher_off HIT      cap=0 w0=3 pcmt=0
CLASS_search_incomp HIT    st=6
CLASS_one_ddr_owner HIT nsw=53 dual=0
CLASS_no_qid_map HIT
CLASS_no_host_winner HIT
CLASS_no_a09_top HIT
CLASS_no_plant_in_dut HIT
```

`$finish` at 349562625 ps. GOLDEN hash frozen before xvlog:
`4148d635074e8824abab4fefb5132b7e9a5cdc07bea8160de022445b7e4c380a  GOLDEN.json`

KEEP C0/C1/C2 MATCH. Live C3 wrap `cfb89632…`. `mig.prj` `914a9e4b…`.
Bit not programmed.

## Quality bound

MIG PHY XSim, not silicon. UART baud 8000/800. Compact LM not 802k.
This bag must not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.
