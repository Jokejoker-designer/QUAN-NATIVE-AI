# PREREG — ASTRA-C4-LM06-RED-BYTE256-01

PROGRAM=NO. WO-02 rival 2. Named `a7ng_astra_c4_lm06_red`. Does **not**
instantiate TinyGPT-802k, edit grounded_gen KEEP, or execute WO0550.

One unknown: decoder-only BYTE256 with tied embed + one integer attention
block + FFN — do prefix and evidence both change the emitted sequence?

HIT if prefix/evidence/zero-weight interventions change the sequence, safety
gate emits `n,o,EOS` with evid_has=0, RTL matches the frozen integer
reference, host tokens stay 0.

Language 90/95/5 is **not** this-gate (synthetic checkpoint, no held-out
corpus). Does not stamp C4_MASTER. Does not freeze LM06_BYTE256.
