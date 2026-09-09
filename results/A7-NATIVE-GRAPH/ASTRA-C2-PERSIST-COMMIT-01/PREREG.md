# PREREG — ASTRA-C2-PERSIST-COMMIT-01

Owner Anh 2026-09-07: start C2 after C1 XSim close. PROGRAM=NO.
ONE UNKNOWN: FPGA-owned commit identity is the 20-bit tuple
{subject_id, relation_id, object_id, context, generation} with distinguishable
UPDATE_RECEIVED / ACCEPTED / COMMITTED / PERSISTED / FAILED, false success = 0,
journal AXI address is not low16(subject), modeled AXI journal is not MIG.
Marker ASTRA_C2_PERSIST_COMMIT_XSIM_PASS only if FAIL=0 and those classes HIT.
Does not close Master C2 / BOARD_PASS / DDR_QUERY_BOUND_FINAL / MIG.
Does not edit C0, C1 KEEP, ASTRA-06, or a7ng_learned_prior_store.
