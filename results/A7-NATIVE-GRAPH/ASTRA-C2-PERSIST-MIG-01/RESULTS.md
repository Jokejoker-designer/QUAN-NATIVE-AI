# RESULTS — ASTRA-C2-PERSIST-MIG-01

ONE UNKNOWN: 20-bit persist identity + w0 through official Digilent AXI MIG
(`mig_7series_0_mig_sim` + ddr3_model) after `init_calib_complete`, then
on-chip clear + reload exact. Not BOARD. Not low16 address.

```text
MARKER               = ASTRA_C2_PERSIST_MIG_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = XSIM (official AXI MIG sim + ddr3_model)
CALIB                = HIT t=122810625 ps
SIM_PS               = 124094625
```

| Class | Result |
|---|---|
| mig_calib_complete | HIT t=122810625 ps |
| schema_mismatch | HIT fail_code=1 |
| persist_through_mig | HIT B 0xC34FF / 799998 / 0xABCDE w0=2 aw=0x06000000 |
| journal_addr_not_low16 | HIT |
| alias_attempt | HIT low16 0x034FF miss |
| bram_clear | HIT |
| reload_from_mig | HIT identity+w0=2 |
| false_success_zero | HIT n_false=0 |

HEADLINE `n_upd=1 n_schema=1 n_false=0 calib=1`

Does **not** close Master §8 (no held-out after reload; `PERSIST_SCHEMA_VERSION` /
`DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN; not BOARD).
Official `mig.prj` hash-gate MATCH. KEEP persist DUTs not edited.
Gold hashed before first xvlog. First XSim PASS (no xsim_fail_r0).
xelab `-mt off -O0` (known 2026.1 ACCESS_VIOLATION without it).
