# ASTRA-C2-PERSIST-MULTI-SLOT-01

Parent after C2 identity bag PASS_THIS_GATE_ONLY. Owner: OK tiếp đi.

Sole implementer Cursor. PROGRAM=NO. No JTAG. No MIG.

## Preserve

Do not edit C0 hashes, C1 KEEP, `a7ng_astra_c2_persist_commit.sv` (identity KEEP),
ASTRA-06, `a7ng_learned_prior_store`. Do not freeze DDR_QUERY_BOUND_FINAL or
PERSIST_SCHEMA_VERSION.

## One unknown

CAP_N=2: miss allocate, cache hit, full capacity, dirty eviction with AXI
write-back of the oldest committed victim. Address = PERSIST_BASE+axi_idx*16.

## Not this bag

DDR stall, write-back under AW/W/B backpressure, MIG, held-out, BOARD, Master C2 close.
