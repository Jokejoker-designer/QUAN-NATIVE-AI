# PREREG — ASTRA-C3-PEND-LOAD-01

PROGRAM=NO. Named `a7ng_astra_c3_held_out_pendld` plus existing
`a7ng_astra_c5_sgd32_ckpt_pend`. Does not edit KEEP C3 wrap, C2, live
prod_top, or old sgd32_ckpt.

TB may plant weights/pending as baseline. Exam: persist from C3 outputs
→ clear on-chip bank and pending → AXI reload through C3 load ports.

Unknown: exact 32-weight + high-ID proofs + 32 phi match after reload.

Does not stamp C3_MASTER. Modeled AXI, not MIG.
