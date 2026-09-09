# CLOSEOUT — ASTRA-C5-PROD-TOP-QPTEXT-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_PROD_TOP_QPTEXT_MIG_XSIM_PASS` start-of-line on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.
`DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: existing named production hierarchy `a7ng_astra_c5_prod_top_c4q`
(hash `e8b5d8e4…`, not edited) through official Digilent AXI MIG
(`mig_7series_0_mig_sim` + `ddr3_model`). Live `a7ng_astra_c5_prod_top.sv`
`c4fcca30…` unedited and not DUT. Live C3 wrap `cfb89632…` unedited.

Measured r0: CLASS_mig_calib_complete HIT t=122810625.0 ps; UART
`pump requires indirect`; C3 ans=64; tok0=61 (weight glue); tok1=77
(FPGA hop-2 object name); n_host=0; six clients seen=3f; ckpt 0x06000000.
GOLDEN hashed before xvlog `2ec86b4b…`. `$finish` 163262625 ps.

Quality bound: glue-plus-object copy through MIG PHY, UART sim baud 8000/800,
planted compact 2-hop, not TinyGPT, not silicon, not the C6-03 routed top.
Does not stamp C5_MASTER or BOARD_PASS.
