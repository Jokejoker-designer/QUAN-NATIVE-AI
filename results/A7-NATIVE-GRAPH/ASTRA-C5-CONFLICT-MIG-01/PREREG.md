# PREREG — ASTRA-C5-CONFLICT-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, leftover A09,
`a7ng_lm_graph_arb.sv`, frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not this top.
Does not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

## One unknown

On the same C5 production hierarchy through official Digilent AXI MIG PHY
(`mig_sim` + `ddr3_model`), does a planted positive 2-hop ANSWER remain ANSWER,
and after planting an opposing negative-polarity 2-hop to the **same dest**,
does C3 `status_o` become CONFLICT with ans=0 and no pending reward commit?

Two positive destinations still rank. Polarity contradiction only.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_base_two_hop
CLASS_conflict
CLASS_conflict_no_upd
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
```

## FAIL if

- KEEP C0/C1/C2 or official `mig.prj` hashes drift
- A09 or `tiny_gpt803k_core` compiled as DUT, or synth `mig_7series_0_mig.v` is DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- bag claims C5_MASTER closed
