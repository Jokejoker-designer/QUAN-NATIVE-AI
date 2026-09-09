# PREREG — ASTRA-C5-PROD-TOP-QPTEXT-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
live `a7ng_astra_c5_prod_top.sv`, `a7ng_astra_c5_prod_top_c4q.sv`,
`a7ng_lm_graph_arb.sv`, TinyGPT, official `mig.prj`, `ddr3_model`, or
`mig_native_wrap`. Does not freeze `DDR_QUERY_BOUND_FINAL` or `LM06_BYTE256`.
Does not overwrite routed `a7ng_astra_c6_wholechip.sv`.

## One unknown

After `init_calib_complete`, can UART → C3 2-hop ANSWER → BYTE256 qptext
still emit tok0 = weight-loaded glue (61) and tok1 = FPGA hop-2 object name
of planted dest 64 in the **existing** named hierarchy
`a7ng_astra_c5_prod_top_c4q` (not edited) when the exclusive-owner AXI path
goes through official Digilent AXI MIG (`mig_7series_0_mig_sim` + `ddr3_model`)
instead of the modeled 1-beat TB slave from `ASTRA-C5-PROD-TOP-QPTEXT-01`?

TB-only: `defparam u_dut.u_c3.TO_CYC = 65535`. Plant stays in TB (MIG AW mux
while DUT held in reset). No in-DUT plant. Live `a7ng_astra_c5_prod_top.sv`
is hash-gated unedited and is **not** the DUT.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_gen_tok0_glue_from_weights
CLASS_gen_tok1_hop2_obj_name
CLASS_tok0_not_ans_dict
CLASS_ans_matches_planted_dest
UART + sparse index + descriptor + scorer + persist + six clients
```

Letter §10 TinyGPT language and silicon C7 remain **out of scope**.
UART baud remains C5 sim 8000/800. Compact glue-plus-object copy, not 802k.
This bag must not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2, live C3 wrap, live prod_top, or c4q hashes drift
- TinyGPT / compose / dict DUT / grounded_gen / ctxcopy / A09 / synth mig compiled
- GOLDEN edited after xvlog
- PROGRAM=YES
