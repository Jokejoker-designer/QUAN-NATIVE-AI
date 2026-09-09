# PREREG — ASTRA-C5-CONFLICT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, leftover A09,
`a7ng_lm_graph_arb.sv`, frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.
Does not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

Live C3 wrap `a7ng_astra_c3_held_out.sv` may emit `ST_CONFLICT=5` when a
**positive** 2-hop destination D and a **negative-polarity** 2-hop destination D
coexist. Two positive destinations still rank (held-out law). A09 is not DUT.

## One unknown

On the same C5 production hierarchy (modeled AXI, UART ingress), does a planted
positive 2-hop ANSWER remain ANSWER, and after planting an opposing negative
2-hop to the **same dest**, does C3 `status_o` become CONFLICT with ans=0 and
no pending reward commit?

## HIT letter this bag may measure (XSim modeled AXI)

```text
CLASS_base_two_hop     positive-only plant → ANSWER dest=64
CLASS_conflict         pos+neg same dest → status=5 ans=0 p0=0 p1=0
CLASS_conflict_no_upd  pend_cmt=0 after CONFLICT
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
```

## Out of scope (quality bound)

- Official MIG PHY
- Two-positive-dest ranking (held-out bags)
- Silicon / C7 / UART real baud
- C6 rebuild (C6-02 bit predates this C3 opcode)

## FAIL if

- KEEP C0/C1/C2 hashes drift
- A09 or `tiny_gpt803k_core` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- `a7ng_lm_graph_arb` edited
- bag claims C5_MASTER closed
