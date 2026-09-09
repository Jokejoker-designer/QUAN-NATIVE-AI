# PREREG — ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01

PROGRAM=NO. WO-03 this-gate. Reuses C1 KEEP extract and unedited 800k
procedural law (`gen_800k.svh` `cd327310…`). Does **not** edit C3 KEEP wrap
`cfb89632…`, C2 KEEP, live prod_top, or old bags. DUT is existing named
`a7ng_astra_c3_held_out_nb64k` plus named `a7ng_astra_c5_sgd32_ckpt`.

One unknown: after arm-A train on this image, persist → C3 reset (weights 0)
→ AXI reload restores the **same 32 weights** with **no TB write** of
w[1:31], and 5-seed held-out drop is ≤5pp versus pre-reload arm A.

Also reruns B/C/D arms. Does not freeze `DDR_QUERY_BOUND_FINAL`.
Dictionary DDR text image remains NOT_PINNED. Not MIG. Not board.
Does not stamp C1_MASTER or C3_MASTER.
