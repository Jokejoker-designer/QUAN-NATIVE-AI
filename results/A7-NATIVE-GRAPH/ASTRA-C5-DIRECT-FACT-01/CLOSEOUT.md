# CLOSEOUT — ASTRA-C5-DIRECT-FACT-01

PROGRAM=NO. Marker `ASTRA_C5_DIRECT_FACT_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`. `BOARD_PASS=REJECT`.

## One unknown

Same C5 production hierarchy: 1-hop UART line vs 2-hop "indirect" UART line.

## Measured (XSim modeled AXI)

```text
CLASS_direct_fact HIT     Q1 "pump requires valve" ans=11 p0=20 p1=0
CLASS_two_hop_novel HIT   Q2 "pump requires indirect" ans=64 p0=16 p1=17
CLASS_one_ddr_owner HIT nsw=14 dual=0
CLASS_no_qid_map / host_winner / a09 / plant_in_dut HIT
```

`$finish` at 51805 ns. GOLDEN hash frozen before xvlog:
`dd549080fcb89b29521393b860378f9c70bcba26aabd4a9427544b6c10445211  GOLDEN.json`

KEEP C0/C1/C2 MATCH. KEEP C3 unedited. No new DUT ports this bag.

## Quality bound

Modeled AXI, compact plant, not MIG/silicon/90% LM/CONFLICT opcode.
This bag must not self-stamp `C5_MASTER=CLOSED`.
