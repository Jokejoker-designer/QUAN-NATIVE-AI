# CLOSEOUT — ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01B

PROGRAM=NO. Named `a7ng_astra_c5_prod_top_ckpt` SHA
`9fd51ef767d2066ead1ab508a90c4f0a0da567ffa1f284eafdad01c475125fc7`.
Live `prod_top.sv` still `c4fcca30…`. C2 KEEP still `86a7a069…` and **not**
instantiated on `0x06000000`. C3 wrap still `cfb89632…`. Does **not** stamp
C5_MASTER. Pending proof/phi restore remains OPEN.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01B\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `7b5e6c0726013320ed57b41e5831379853a928e607fc4fdf7a49bfe54c2081b6` (hashed before first xvlog, not regenerated)
- `$finish` 46235 ns
- Marker `ASTRA_C5_SGD32_CKPT_TOP_XSIM_PASS`
- Last AW `0x06000050` (ckpt beat 5)
- After +3: nupd=1 pvalid=1 pph=4 w0=5 and 11 other nonzero weights
- After UART `0x0C`: all 32 weights 0, pacc=0, c3busy=0
- After UART `0x12`: crest=1 pph=7 exact 32-weight match, no TB force

## Classes HIT

query_no_sgd, rew_plus3, persist_after_sgd, snap_nonzero, clear_zero, exact32_reload.

Modeled AXI, not MIG. Not NVM. Not board.

REVIEW_PENDING for independent auditor. self_accept=false.
