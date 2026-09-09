# CLOSEOUT — ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F2R4_AXI_DRAIN_XSIM_PASS
SIM_TIME_NS          = 20625
FAIL_COUNT           = 0
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f2r4_axi_drain
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited; run_f2r2.ps1 not rerun
F2R3_BAG             = preserved, not edited; run_f2r3.ps1 not rerun
F2R3_DUT             = a7ng_astra_f2r3_sem_guard.sv not patched
CONTRACT             = abort/drain/reset on fact AXI; local RID abandon after drain timeout
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
F3 / LM06 / BOARD_PASS / item6 / post_timeout_recovery = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this item-5 bag. Do not open F3, LM06, or BOARD from this
bag. PROGRAM=NO.
