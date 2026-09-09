# CLOSEOUT — ASTRA-C5-CONFLICT-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_CONFLICT_MIG_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS). Official MIG PHY (`mig_sim` + `ddr3_model`).

## One unknown

Same C5 production hierarchy through official MIG PHY: a planted positive 2-hop
ANSWER remains ANSWER; after planting an opposing negative-polarity 2-hop to
the **same dest**, C3 `status_o` is CONFLICT (5) with ans=0 and no persist commit.

Two positive destinations still rank (held-out law). Polarity contradiction only.

## Measured (XSim official MIG PHY)

```text
CLASS_mig_calib_complete HIT t=122810625.0 ps
CLASS_base_two_hop HIT     Q1 st=0 ans=64 p0=16 p1=17 cmt=0
CLASS_conflict HIT         Q2 st=5 ans=0 p0=0 p1=0
CLASS_conflict_no_upd HIT
CLASS_one_ddr_owner HIT nsw=14 dual=0
CLASS_no_qid_map HIT
CLASS_no_host_winner HIT
CLASS_no_a09_top HIT
CLASS_no_plant_in_dut HIT
```

`$finish` at 190958625 ps. GOLDEN hash frozen before xvlog:
`6787dd5f2f3cead8032aa3b6dd44032a2ae49a6a9aa9aad8f30af37708c8e096  GOLDEN.json`

KEEP C0/C1/C2 MATCH. Live C3 wrap `cfb89632…` (`A7NG_C3_ST_CONFLICT=5`).
`a7ng_lm_graph_arb` MATCH `04b5346e…`. Official `mig.prj` MATCH `914a9e4b…`.
`mig_native_wrap` MATCH `97c078b1…`. C6 wrap not overwritten. Bit not programmed.

## Quality bound

MIG PHY XSim, not silicon. UART baud 8000/800. TB `defparam u_dut.u_c3.TO_CYC=65535`.
`plant=0` after `axi_wr`. This bag must not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.
