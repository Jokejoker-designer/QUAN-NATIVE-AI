# CLOSEOUT — ASTRA-C3-PEND-LOAD-01

PROGRAM=NO. Named `a7ng_astra_c3_held_out_pendld` SHA
`2346ca6beb01271887b73cf27e1ee7a8ce019c988b9aaeec6e16378a7e41619e`.
KEEP C3 wrap still `cfb89632…`. `ckpt_pend` still `94e97329…`. C2 and live
prod_top unedited. Does **not** stamp C3_MASTER.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C3-PEND-LOAD-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `c850bdc5894e31378314705dcf8a40b757b6783e96d7d7889313722709cf5320` (hashed before first xvlog)
- `$finish` 3575 ns
- Marker `ASTRA_C3_PEND_LOAD_XSIM_PASS`
- Reload into C3 load ports: exact 32 weights, p0=799999, non-uniform phi, HOLD visible

## Classes HIT

exact32_reload, c3_pend_phi_reload.

Modeled AXI, not MIG. Not NVM. Not board. KEEP C3 wrap still has no pending-load ports.

REVIEW_PENDING. self_accept=false.
