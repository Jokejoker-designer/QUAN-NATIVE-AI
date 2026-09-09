# PREREG — ASTRA-C5-QPTEXT-UNIFIED-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
live `a7ng_astra_c5_prod_top.sv`, `a7ng_astra_c5_prod_top_c4q.sv`,
`a7ng_lm_graph_arb.sv`, TinyGPT, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `LM06_BYTE256`.

## One unknown

Can the existing named hierarchy `a7ng_astra_c5_prod_top_c4q` (not edited),
through official `mig_sim` + `ddr3_model`, emit polarity CONFLICT
(`st=5`, ans=0, no persist commit) on dest 64 in the same UART session that
then still measures flush/reload, UNKNOWN, role reversal, parser AMB,
teacher-off, and SEARCH_INCOMPLETE — with Q1 tok0 still weight glue 61 and
tok1 the hop-2 object FPGA name?

TB-only `defparam TO_CYC=65535`. `plant=0` after AXI plant. After CONFLICT,
restore distractor facts 18/19 only (do not rewrite C2 checkpoint).

## FAIL if

- KEEP / live C3 wrap / live prod_top / c4q hashes drift
- GOLDEN edited after xvlog
- TinyGPT / compose / grounded_gen / live prod_top compiled as DUT
- PROGRAM=YES
