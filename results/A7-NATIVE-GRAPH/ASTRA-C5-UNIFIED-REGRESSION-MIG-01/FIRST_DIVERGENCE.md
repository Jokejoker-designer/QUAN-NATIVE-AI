# FIRST_DIVERGENCE — ASTRA-C5-UNIFIED-REGRESSION-MIG-01

PROGRAM=NO. GOLDEN not regenerated.
Hash `74a40c30a66dd8d403618c3a41e476f15d5672056220967ae11213c51e749a24`.

## r0

FACT from stdout (UTF-16), not a live exclusive `xsim.log` read during run:

- `CLASS_mig_calib_complete HIT t=122810625.0 ps`
- Q1 dest=64, flush, C2 reload w0=3, UNKNOWN, role reversal, parser AMB, teacher-off all HIT
- No `MEAS Q6` / `CLASS_search_incomp`
- After Q5, DRAM repeated `Read bank 2 row 2045 col 3f0` (324+ times); sim ~438 ms; killed

INFERENCE: `plant_index_ovf` used `axi_wr` which sets `plant=1` and never cleared it (unlike `plant_train0`). DUT AR stayed muxed off MIG while Q6 waited for `done`.

r1 TB-only: `plant=1'b0` after overflow writes; wait DUT AXI idle before plant. GOLDEN frozen. KEEP unedited.

## r1 PASS (raw xsim.log)

FACT: marker `ASTRA_C5_UNIFIED_REGRESSION_MIG_XSIM_PASS`, `CLASS_search_incomp HIT`,
`MEAS Q6 st=6 cap=6`, `$finish` 314642625 ps. GOLDEN still
`74a40c30a66dd8d403618c3a41e476f15d5672056220967ae11213c51e749a24`.
Not C5_MASTER. Not BOARD_PASS.
