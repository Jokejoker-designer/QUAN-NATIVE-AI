# CLOSEOUT — ASTRA-C5-QPTEXT-UNIFIED-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_QPTEXT_UNIFIED_MIG_XSIM_PASS` start-of-line on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.
`DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: existing named hierarchy `a7ng_astra_c5_prod_top_c4q` (hash
`e8b5d8e4…`, not edited) through official Digilent AXI MIG. Live
`a7ng_astra_c5_prod_top.sv` `c4fcca30…` unedited and not DUT. Live C3 wrap
`cfb89632…` unedited.

Measured r0: calib t=122810625.0 ps; Q1 ans=64 tok0=61 tok1=77 gdone=1;
CONFLICT st=5 ans=0 no persist commit; flush w0=0; C2 reload w0=3;
UNKNOWN / role reversal / parser AMB / teacher-off / SEARCH_INCOMPLETE HIT.
GOLDEN hashed before xvlog `2612b186…`. `$finish` 349142625 ps.

Quality bound: glue-plus-object copy plus planted unified UART through MIG PHY,
UART sim baud 8000/800, not TinyGPT, not silicon, not the C6-03 routed top.
Does not stamp C5_MASTER or BOARD_PASS.
