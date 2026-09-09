# CLOSEOUT — ASTRA-C5-EDGE-MUTATION-01

PROGRAM=NO. Marker `ASTRA_C5_EDGE_MUTATION_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.

## One unknown

Same C5 production hierarchy: after a planted 2-hop ANSWER, mutating the
decisive second-hop fact changes C3 status and `ans_o`.

## Measured (XSim modeled AXI)

```text
CLASS_base_two_hop HIT     Q1 ans=64 p0=16 p1=17 st=0
CLASS_edge_delete HIT      Q2 zero hop2 → UNKNOWN st=1 ans=0
CLASS_edge_replace HIT     Q3 hop2 dest 80 → ANSWER ans=80 p1=17
CLASS_edge_reverse HIT     Q4 hop2 S/O swap → UNKNOWN st=1
CLASS_one_ddr_owner HIT nsw=21 dual=0
CLASS_no_qid_map / host_winner / a09 / plant_in_dut HIT
```

`$finish` at 104125 ns. GOLDEN hash frozen before xvlog:
`1f3f9b8bbb09bc724cfc81c3439c8d516a93d21dc919863d01c5e7c8f4a8b664  GOLDEN.json`

KEEP C0/C1/C2 MATCH. KEEP C3 unedited. Observe ports `c3_ans_o`/`c3_p0_o`/`c3_p1_o`
on live prod_top only. C6 wrap not overwritten.

## Quality bound

Modeled AXI, compact 2-fact plant, no CONFLICT opcode, not MIG/silicon/90% LM.
This bag must not self-stamp `C5_MASTER=CLOSED`.
