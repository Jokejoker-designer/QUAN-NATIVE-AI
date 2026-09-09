# PREREG — ASTRA-C2-PERSIST-MIG-01

Owner Anh 2026-09-07: next C2 after modeled stall. PROGRAM=NO.
ONE UNKNOWN: after init_calib_complete, a 20-bit persist identity + w0 written
through official Digilent AXI MIG (`mig_7series_0_mig_sim` + ddr3_model)
survives on-chip persist_clr and reloads exact identity+w0. Address is
PERSIST_BASE, not low16(subject). Not BOARD. Not Master C2 close.

Does not edit KEEP persist RTL, mig.prj, ddr3_model, or mig_native_wrap.
Does not freeze DDR_QUERY_BOUND_FINAL or PERSIST_SCHEMA_VERSION.
Marker ASTRA_C2_PERSIST_MIG_XSIM_PASS only if FAIL=0 and those classes HIT.
