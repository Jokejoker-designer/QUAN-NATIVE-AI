# PLAN — ASTRA-C3-PEND-LOAD-01

Observed: ckpt_pend restores a sidecar bank; KEEP C3 has no pending-load ports.

Change: named C3 copy with phi/pend load in IDLE then HOLD. Wire ckpt_pend
outputs to those ports. Keep KEEP wrap unedited.
