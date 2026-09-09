# CLOSEOUT — ASTRA-C5-PROD-TOP-C3PROOF-01

PROGRAM=NO. Marker `ASTRA_C5_PROD_TOP_C3PROOF_XSIM_PASS` start-of-line on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: new named production hierarchy `a7ng_astra_c5_prod_top_c4p` (not live
`a7ng_astra_c5_prod_top.sv` `c4fcca30…`, which is unedited). UART + live C3 wrap
`cfb89632…` + 6-port arb + C2 persist + BYTE256 ctxcopy. First gen token is the
FPGA dest-name image of C3 ANSWER dest 64 (`tok0=77`). Modeled AXI, not MIG.
GOLDEN hashed before xvlog `807f829a…`. `$finish` 29415 ns.

Measured: C3 ans=64, gen tok0=77 gold0=77, n_host=0, six clients, ckpt 0x06000000.
Quality bound: extractive dest-dict copy in a C5 hierarchy, not TinyGPT, not silicon.
Does not replace the C6-03 live prod_top.
