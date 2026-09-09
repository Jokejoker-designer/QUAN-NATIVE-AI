# PREREG — ASTRA-C5-FLUSH-RELOAD-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, KEEP C3,
C4 adapters, C5 DDR arbiter, C5 prod_top, `a7ng_lm_graph_arb.sv`, leftover
A09, frozen LM-06 `tiny_gpt803k_core`, official `mig.prj`, `ddr3_model`,
or `mig_native_wrap`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C5_MASTER`.

Plant stays in this TB (MIG AW mux while DUT held in reset).
TB-only `defparam u_dut.u_c3.TO_CYC=65535`.

## One unknown

After official MIG `init_calib_complete` and one learn-mode 2-hop ANSWER
that persists w0, do UART flush then reload restore that w0 when AXI goes
through `mig_sim` + `ddr3_model`?

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_two_hop_answer
CLASS_flush_w0_zero
CLASS_c2_persist_reload
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
```

## Out of scope

CONFLICT opcode, silicon, 90% TinyGPT, 800k, UART 115200, held-out dest change.

## FAIL if

KEEP hashes drift, GOLDEN edited after xvlog, PROGRAM=YES, C5_MASTER claimed,
synth `mig_7series_0_mig.v` compiled as DUT.
