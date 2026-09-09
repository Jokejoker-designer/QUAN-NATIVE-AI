# CLOSEOUT — ASTRA-C5-CONFLICT-01

PROGRAM=NO. Marker `ASTRA_C5_CONFLICT_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS).

## One unknown

Same C5 production hierarchy (modeled AXI): a planted positive 2-hop ANSWER
remains ANSWER; after planting an opposing negative-polarity 2-hop to the
**same dest**, C3 `status_o` is CONFLICT (5) with ans=0 and no persist commit.

Two positive destinations still rank (held-out law). Polarity contradiction only.

## Measured (XSim modeled AXI)

```text
CLASS_base_two_hop HIT     Q1 st=0 ans=64 p0=16 p1=17 cmt=0
CLASS_conflict HIT         Q2 st=5 ans=0 p0=0 p1=0
CLASS_conflict_no_upd HIT  cap_cmt=0 pcmt=0
CLASS_one_ddr_owner HIT nsw=14 dual=0
CLASS_no_qid_map HIT
CLASS_no_host_winner HIT
CLASS_no_a09_top HIT
CLASS_no_plant_in_dut HIT
```

`$finish` at 52715 ns. GOLDEN hash frozen before xvlog:
`c2eab022f2f40535ce6f30db391e8d956d80864b942d52338142a48357e32651  GOLDEN.json`

KEEP C0/C1/C2 MATCH. Live C3 wrap edited this bag (`cfb89632…`) to emit
`A7NG_C3_ST_CONFLICT=5`. `a7ng_lm_graph_arb` MATCH `04b5346e…`. C6 wrap not
overwritten. C6-02 bit predates this C3 hash and is stale.

## Quality bound

Modeled AXI, not MIG, not silicon. UART baud 8000/800. This bag must not
self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.
