# PREREG — ASTRA-C5-PROD-TOP-QPTEXT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live C3 wrap,
live `a7ng_astra_c5_prod_top.sv`, TinyGPT, or `a7lm06_wmem.hex`.
Does not freeze `LM06_BYTE256` or `DDR_QUERY_BOUND_FINAL`.

## One unknown

In one production hierarchy (UART + C3 + 6-port arb + C2 + BYTE256 qptext),
is tok0 the weight-loaded glue byte (61) and tok1 the FPGA hop-2 object name
of live C3 ANSWER (not dest-name as tok0)?

TB plants graph facts only. Host next-token=0. Modeled AXI, not MIG.

## FAIL if

- KEEP C0/C1/C2 or live C3 wrap or live prod_top hashes drift
- TinyGPT / compose / dict DUT / A09 / synth mig compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
