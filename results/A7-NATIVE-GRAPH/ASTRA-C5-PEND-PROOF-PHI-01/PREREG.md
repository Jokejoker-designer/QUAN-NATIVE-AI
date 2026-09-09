# PREREG — ASTRA-C5-PEND-PROOF-PHI-01

PROGRAM=NO. Named WO-01B pending revision. Instantiates new
`a7ng_astra_c5_sgd32_ckpt_pend` and SGD KEEP. Does not edit C2 KEEP,
live prod_top, C3 wrap, or existing `a7ng_astra_c5_sgd32_ckpt`.

Schema byte is bag-local 2. PERSIST_SCHEMA_VERSION stays NOT_FROZEN.

TB may plant weights/pending as independent baseline before the exam.
Exam: persist → clear live bank and pending → AXI reload. No TB write
of weights or pending during the exam window.

Unknown: restore matches 32 weights, high-ID proofs, non-uniform phi,
and pending flags. CRC/schema fail must not install. BRESP fail must
not set PERSISTED.

Does not stamp C5_MASTER. Does not install pending into KEEP C3 wrap
(no load_phi ports on KEEP wrap).
