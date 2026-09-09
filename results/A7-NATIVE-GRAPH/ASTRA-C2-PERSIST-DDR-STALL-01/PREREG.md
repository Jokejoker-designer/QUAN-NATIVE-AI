# PREREG — ASTRA-C2-PERSIST-DDR-STALL-01

Owner Anh 2026-09-07: continue C2. PROGRAM=NO.
ONE UNKNOWN: persist and dirty write-back complete under independent AW/W/B
backpressure (reload under AR/R stall) without dropping WDATA, without
PERSISTED before B OKAY, without mixing 20-bit identity, without low16
address. Modeled AXI journal is not MIG.

Stall counts written here: AW=8 W=5 B=6 AR=4 R=3.
On-chip N=1, N_AXI=2, cache/journal updates only on AXI B OKAY.
Does not edit persist-commit KEEP or multi-slot KEEP.

Marker ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS only if FAIL=0 and those classes HIT.
Does not close Master C2 / BOARD_PASS / DDR_QUERY_BOUND_FINAL / MIG.
