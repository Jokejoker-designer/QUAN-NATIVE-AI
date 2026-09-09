# CLOSEOUT — ASTRA-06-R3-MULTI-SLOT-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-06-R3-MULTI-SLOT-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_06_R3_MULTI_SLOT_XSIM_PASS
SIM_TIME_NS          = 20975
FAIL_COUNT           = 0 (pass run)
FAIL_R0              = MIX_B_WHILE_A (TB nbad vs F2R nstale on gen mismatch); one TB mix-class corrective; no golden edits
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_06_r3_multi_slot
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PERSIST_DUT          = a7ng_astra_06_warm_persist NOT PATCHED (SHA 52ebde52…)
R2_DUT               = a7ng_astra_06_r2_evict_highid NOT PATCHED (SHA c671f98b…)
F2R / F3 / persist / R2 bags = preserved, not edited; their run scripts not rerun
CAP_N                = 2
EVICTION_VICTIM      = oldest committed / lowest txn (raw: txn=1 idx=0; after evict s0=txn3 C, s1=B remains)
POLICY               = REFUSE_ALL_UNCOMMITTED / EVICT_OLDEST_COMMITTED_LOWEST_TXN
EID20_OBSERVED       = s0 p0=20'hA0011 ans=20'hA00B4 ; s1 p0=20'hA0111 ans=20'hA0C55 ; C p0=20'hA0311 ans=20'hA0D66
W_DELTA              = A dw0=-5 (phi=50) ; B dw0=-4 (phi=40) ; no mix across slots
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
Master_ASTRA-06 / Master_F3_10pp_CI / LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / NVM_QSPI / host_sess_id_reuse_without_restore / DDR_index_N_gt_1 = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `d6deb5ba22768fcd51c727ccd1df64413b9e3f2ac1b8cd3989735d9dba6536e6`)
- Fail r0: `xsim_fail_r0.log` (SHA256 `579686f26ce318b97a03271ee1071878a1b65123b6e1409498b24ac769483348`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this N>1 on-chip persist-slot bag.
Do not open LM06, BOARD, Master F3 10pp, or DDR from this bag. PROGRAM=NO.
