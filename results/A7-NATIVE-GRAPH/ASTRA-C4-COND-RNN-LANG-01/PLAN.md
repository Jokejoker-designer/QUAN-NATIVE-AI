# PLAN — ASTRA-C4-COND-RNN-LANG-01

Observed: both C4 rivals pass prefix/evidence causality and miss 90/95/5
because checkpoints were untrained LCG noise.

Change: local float-CE then int8 export onto the same Elman law. XSim the
frozen held-out set. Do not add a third architecture. Do not execute WO0550.

Invariant: rival-1 SV unedited. PROGRAM=NO. LM06_BYTE256 NOT_FROZEN.
