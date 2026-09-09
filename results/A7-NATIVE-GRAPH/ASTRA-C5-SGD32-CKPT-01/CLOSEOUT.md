# CLOSEOUT — ASTRA-C5-SGD32-CKPT-01

PROGRAM=NO. Unit WO-01B backend. Does **not** edit C2 KEEP. Does **not** stamp
C5_MASTER. Named C5 top integration remains OPEN (`01B_TOP=OPEN`).
`PERSIST_SCHEMA_VERSION` not frozen. REVIEW_PENDING. self_accept=false.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C5-SGD32-CKPT-01\run_xsim.ps1
exit=0 after one RTL corrective (sticky persisted_o)
```

## Raw

- GOLDEN.json SHA256 `608725d5ce155af58c7a54cf0cd541f744ea7a5bd666bae06a077890069d172e` (not regenerated)
- `$finish` 3865 ns
- Marker `ASTRA_C5_SGD32_CKPT_XSIM_PASS`
- C2 KEEP still `86a7a069…`; live prod_top still `c4fcca30…`

## Classes HIT

- `CLASS_exact32_reload` after persist → TB-zero bank → AXI reload
- `CLASS_crc_no_install` (payload XOR, no load, bank stays 0)
- `CLASS_bresp_no_persist` (SLVERR BRESP)

## First FAIL / corrective

`BRESP_NO_PERS`: `persisted_o` stayed 1 from the earlier successful persist.
Cause: HOLD/FAIL retire did not drop the flag; new persist did not arm-clear it.
Fix: clear `persisted` on `go_persist`, HOLD retire, and FAIL. GOLDEN unchanged.

## Limits

Modeled AXI, not MIG. TB loaded the 32-weight baseline (allowed for unit).
Not a UART/C3 hierarchy restore. Not power-loss NVM. Dual A/B slots not in this
unit. Independent auditor still required.
