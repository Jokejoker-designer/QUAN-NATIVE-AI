# CLOSEOUT — ASTRA-C5-PEND-PROOF-PHI-01

PROGRAM=NO. Named `a7ng_astra_c5_sgd32_ckpt_pend` SHA
`94e97329ec607c44aff6ff5fe4e2228301e300f1446e445919958f4f315dd8be`.
C2 KEEP still `86a7a069…`. Live prod_top still `c4fcca30…`. C3 wrap still
`cfb89632…`. Old `sgd32_ckpt` still `e419caef…`. Does **not** stamp C5_MASTER.
`PERSIST_SCHEMA_VERSION` stays NOT_FROZEN (bag-local schema 2).

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-PEND-PROOF-PHI-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `71a9aaa2c2b220d6834badb34032470c1fb3115a8bc6b8fc2be30f021e29c2c4` (hashed before first xvlog, not regenerated)
- `$finish` 5985 ns
- Marker `ASTRA_C5_PEND_PROOF_PHI_XSIM_PASS`
- After reload: exact 32 weights, p0=799999, p1=112, ans=144, non-uniform phi, flags restored
- CRC (pending beat flip) and schema=1: no install, live bank/pending remain 0
- BRESP SLVERR: persisted stays 0

## Classes HIT

exact32_reload, exact_pend_phi_reload, crc_no_install, schema1_reject, bresp_no_persist.

Modeled AXI, not MIG. Not NVM. Not board. KEEP C3 wrap has no pending-load ports, so this bag does not install pending into KEEP C3.

REVIEW_PENDING for independent auditor. self_accept=false.
