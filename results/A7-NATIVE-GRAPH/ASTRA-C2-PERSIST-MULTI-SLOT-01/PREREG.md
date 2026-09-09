# PREREG — ASTRA-C2-PERSIST-MULTI-SLOT-01

Owner Anh 2026-09-07: continue C2 after identity bag. PROGRAM=NO.
ONE UNKNOWN: with persist capacity CAP_N=2, miss-allocate two distinct
20-bit identities, cache-hit the first, fill capacity, and dirty-evict the
oldest committed victim with AXI write-back — without mixing identities,
without low16 address, modeled AXI journal not MIG.

CAP_N=2 written here. N_AXI=4 lines at PERSIST_BASE+axi_idx*16.
Victim = oldest committed / lowest seq (tie lowest index). Uncommitted
rows are never victims. Same full tuple on a committed slot is in-place
dirty w0 (cache hit), not DUP. DUP remains KEEP `ASTRA-C2-PERSIST-COMMIT-01`.

Marker ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS only if FAIL=0 and those classes HIT.
Does not close Master C2 / BOARD_PASS / DDR_QUERY_BOUND_FINAL / MIG.
Does not edit C0, C1 KEEP, persist-commit KEEP, ASTRA-06, or prior_store.
Does not exercise DDR stall / MIG. Refuse-all-uncommitted is in RTL but
not this bag's unknown (single-issue + immediate commit).
