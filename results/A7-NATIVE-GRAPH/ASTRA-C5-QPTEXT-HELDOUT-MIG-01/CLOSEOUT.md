# CLOSEOUT — ASTRA-C5-QPTEXT-HELDOUT-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_QPTEXT_HELDOUT_MIG_XSIM_PASS` start-of-line on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.
`DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: existing named hierarchy `a7ng_astra_c5_prod_top_c4q` (hash
`e8b5d8e4…`, not edited) through official Digilent AXI MIG. Live
`a7ng_astra_c5_prod_top.sv` `c4fcca30…` unedited and not DUT. Live C3 wrap
`cfb89632…` unedited.

Measured r0: calib t=122810625.0 ps; PRE freeze `"ahu connects indirect"`
ans=144 p0=256; TRAIN `"pump requires indirect"` reward w0=3 pvalid=1
(ans=96, not dest 64); POST ans=112 p0=258; held-out changed 144→112.
GOLDEN hashed before xvlog `dc8382bc…`. `$finish` 229706625 ps.

Extra CLASS after TRAIN (not in GOLDEN `$need`): `CLASS_gen_tok0_glue_from_weights
MISS tok0=61 tok1=83` because TRAIN dest was 96 (FPGA dest-name pos0=83), not 64.

Quality bound: glue-plus-object copy plus planted held-out PRE/POST through MIG PHY,
UART sim baud 8000/800, not TinyGPT, not silicon, not the C6-03 routed top.
Does not stamp C5_MASTER or BOARD_PASS.
