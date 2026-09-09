# CLOSEOUT — ASTRA-C4-LM06-BYTE256-QPTEXT-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_BYTE256_QPTEXT_XSIM_PASS` start-of-line on raw `xsim.log`.
`C4_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: new named BYTE256 head `a7ng_astra_c4_lm06_byte256_qptext` (live C3 wrap
`cfb89632…` unedited). QUERY/PROOF bytes are the FPGA dict of C3 subject + proof0
eid. First token is a weight-loaded glue byte (61), not dest-name ch0. Tokens 2–4
are the hop-2 object name (`ans=fo[ej]`). Modeled AXI, not MIG. GOLDEN hashed
before xvlog `ac324818…`. `$finish` 51265 ns.

Measured: acc=20/20, safe=20/20, hall=0/20, glue=20/20, tok0≠ans-dict 20/20,
query/proof mats 20/20, W=0 tok0=0, dest 40 vs 50 changes seq[1] 79 vs 89.
Quality bound: compact glue-plus-object copy, not TinyGPT, not silicon.
Does not freeze LM06_BYTE256.
