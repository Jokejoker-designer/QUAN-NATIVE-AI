# ASTRA-C2-PERSIST-DDR-STALL-01

Parent after multi-slot PASS_THIS_GATE_ONLY. Owner: ok.

Sole implementer Cursor. PROGRAM=NO. No JTAG. No MIG.

## Preserve

Do not edit C0 hashes, C1 KEEP, persist-commit KEEP, multi-slot KEEP, ASTRA-06,
`a7ng_learned_prior_store`. Do not freeze DDR_QUERY_BOUND_FINAL or
PERSIST_SCHEMA_VERSION.

## One unknown

Persist + dirty write-back under AW/W/B stall (reload under AR/R stall).
PERSISTED only after B OKAY. WDATA held. Address = PERSIST_BASE+axi_idx*16.

## Not this bag

MIG, Master C2 close, BOARD, held-out.
