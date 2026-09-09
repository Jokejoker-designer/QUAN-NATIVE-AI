# CLOSEOUT — ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_GROUNDED_GEN_HELDOUT20_XSIM_PASS` on raw `xsim.log`.
`CLASS_grounded_acc_ge90 HIT acc=20/20` measured.

```text
TINYGPT_802K     = RETIRED_PER_GROK_550
LM06_BYTE256     = NOT_FROZEN
C4_MASTER        = OPEN
BOARD_PASS       = REJECT
```

This bag expands the compact `grounded_gen` head to 20 held-out object IDs
(20..39) plus four ablations. It does **not** rewrite frozen GOLDEN of
`ASTRA-C4-LM06-GROUNDED-GEN-01`.

It does **not** close letter §10. First token equals `evid_obj` (class ID).
Grok LM06 claim law forbids treating class-ID emission as FPGA language.
Do not freeze `LM06_BYTE256=FROZEN_C4G_V1`.
