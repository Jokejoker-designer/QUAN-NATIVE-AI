# FAIL_R0 — ASTRA-F2R-R5-TXN-WRAP-RESET-01

Preserved first-run fail. Do not edit this log or its SHA to manufacture PASS.

```text
xsim_fail_r0.log
SHA256_fail_r0.txt
first_divergence = RETIRE_A_NO_UPD_B
sim_time_ns      = 31935
marker           = ASTRA_F2R5_TXN_WRAP_RESET_XSIM_FAIL n=14
```

## Cause (not golden edits)

1. **TB over-specified `n_bad`.** Delayed A `{7,1,1}` vs live B `{7,2,2}`: gen and txn both differ. Handshake checks epoch, then gen, then txn. DUT counted `n_stale` (gen), not `n_bad`. B was not updated (`nupd=0`, `w0=0`). Check was wrong, DUT reject was right.

2. **`live_epoch_i` is the sparse-walker generation, not a txn session nonce.** TB reused it as the pending epoch and set 20/21/30/31/40/41/50. Retrieval then returned UNKNOWN (`st=1 npath=0`) for WRAP/POST_RST/SMOKE_AFTER. First smoke at epoch=7 had worked. Contract requires host session nonce as **transport metadata, not a semantic cue**.

## Corrective (one pass)

- New `sess_id_i` latched into pending epoch. Walker still sees `live_epoch_i`.
- TB keeps `live_epoch_i=7`. Bumps `sess_id_i` for wrap recycle and post-reset.
- RETIRE_A check accepts `n_stale|n_bad` reject with no weight update.
