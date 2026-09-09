# CLOSEOUT — ASTRA-06-R4-SESS-REUSE-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-06-R4-SESS-REUSE-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_06_R4_SESS_REUSE_XSIM_PASS
SIM_TIME_NS          = 13555
FAIL_COUNT           = 0 (pass run)
FAIL_R0              = none (first xvlog/xelab/xsim PASS; no corrective)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_06_r4_sess_reuse
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PERSIST_DUT          = a7ng_astra_06_warm_persist NOT PATCHED (SHA 52ebde52…)
R2_DUT               = a7ng_astra_06_r2_evict_highid NOT PATCHED (SHA c671f98b…)
R3_DUT               = a7ng_astra_06_r3_multi_slot NOT PATCHED (SHA 99ee5d93…)
F2R / F3 / persist / R2 / R3 bags = preserved, not edited; their run scripts not rerun
SESS_LIFETIME        = sess_id in pending/persist key; rst without restore refuses same-sess PICK (n_sess_reuse) and stale delayed rew (n_stale); matching reload commits
EID20_OBSERVED       = s0 p0=20'hA0011 ans=20'hA00B4 (bits[19:8] nonzero)
W_DELTA              = matching restore delayed rew dw0=-5; no-restore reuse does not write persist
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
Master_ASTRA-06 / Master_F3_10pp_CI / LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / NVM_QSPI / DDR_index_N_gt_1 / power_loss_NVM_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this host sess_id reuse-without-restore bag.
Do not open LM06, BOARD, Master F3 10pp, or DDR from this bag. PROGRAM=NO.
