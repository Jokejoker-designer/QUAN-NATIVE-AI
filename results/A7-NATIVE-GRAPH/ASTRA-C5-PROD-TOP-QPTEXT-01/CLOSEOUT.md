# CLOSEOUT — ASTRA-C5-PROD-TOP-QPTEXT-01

PROGRAM=NO. Marker `ASTRA_C5_PROD_TOP_QPTEXT_XSIM_PASS` start-of-line on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: new named production hierarchy `a7ng_astra_c5_prod_top_c4q` (not live
`a7ng_astra_c5_prod_top.sv` `c4fcca30…`, which is unedited). UART + live C3 wrap
`cfb89632…` + 6-port arb + C2 persist + BYTE256 qptext gen. tok0=61 (weight glue),
tok1=77 (FPGA hop-2 object name of dest 64). Modeled AXI, not MIG.
GOLDEN hashed before xvlog `ebf05cf1…`. `$finish` 29475 ns.

Measured: C3 ans=64, tok0=61≠77, tok1=77, n_host=0, six clients, ckpt 0x06000000.
Quality bound: glue-plus-object copy in a C5 hierarchy, not TinyGPT, not silicon.
Does not replace the C6-03 live prod_top.
