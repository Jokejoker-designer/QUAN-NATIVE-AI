# PLAN — ASTRA-C5-PEND-PROOF-PHI-01

Observed: 01B ckpt restores 32 weights only. Pending proof/phi remain OPEN.

Change: new named 9-beat AXI snapshot (header, 4 weight beats, pending IDs,
2 phi beats, commit). CRC covers weights+phi+pending. Schema 2 rejected if 1.

Invariants: do not edit C2, live prod_top, C3 wrap, old ckpt. PROGRAM=NO.
