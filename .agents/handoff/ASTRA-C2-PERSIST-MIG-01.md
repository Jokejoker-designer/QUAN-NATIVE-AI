# ASTRA-C2-PERSIST-MIG-01

Parent after DDR-stall PASS_THIS_GATE_ONLY. Owner: ok next di.

Sole implementer Cursor. PROGRAM=NO. No JTAG.

## Preserve

Do not edit C0 hashes, C1 KEEP, persist-commit/multi-slot/stall KEEP, official
`mig.prj`, `ddr3_model`, `mig_native_wrap`. Do not freeze DDR_QUERY_BOUND_FINAL
or PERSIST_SCHEMA_VERSION.

## One unknown

Persist + on-chip clear + reload through official Digilent AXI MIG sim + ddr3_model
after init_calib_complete. 20-bit identity exact. Not low16 address.

## Not this bag

BOARD, Master C2 close, held-out, query-path DDR_QUERY_BOUND freeze.

## Result

```text
XSIM                 = ASTRA_C2_PERSIST_MIG_XSIM_PASS
RESULT               = PASS_THIS_GATE_ONLY
SIM_PS               = 124094625
CALIB_PS             = 122810625
xsim SHA256          = 7db9647b91fd27a7708ceec6c18289b7c97aa2d6dde30b99bf4286fc42c3bc8e
FAIL_R0              = none
```

Next named item: `ASTRA-C3-HELD-OUT-01` (not started). Master C2 remains OPEN.
