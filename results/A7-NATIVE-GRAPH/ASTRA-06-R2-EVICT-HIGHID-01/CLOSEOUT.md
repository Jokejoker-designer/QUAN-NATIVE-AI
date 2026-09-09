# CLOSEOUT — ASTRA-06-R2-EVICT-HIGHID-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-06-R2-EVICT-HIGHID-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_06_R2_EVICT_HIGHID_XSIM_PASS
SIM_TIME_NS          = 32035
FAIL_COUNT           = 0 (pass run)
FAIL_R0              = RELOAD_I_PATH (TB sampled mid S_RELOAD); one TB handshake corrective; no golden edits
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_06_r2_evict_highid
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PERSIST_DUT          = a7ng_astra_06_warm_persist NOT PATCHED (SHA 52ebde52…)
F2R / F3 / persist bags = preserved, not edited; their run scripts not rerun
CAPACITY             = N=1 REFUSE_UNCOMMITTED_EVICT_COMMITTED
EID20_OBSERVED       = ans=20'hA00B4 p0=20'hA0011 p1=20'hA0022 bits[19:8]=0xA00
RELOAD_I             = distinct path n_rl_cmd=1 (auto n_rl_auto=1 on restore_en)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
Master_ASTRA-06 / Master_F3_10pp_CI / LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / NVM_QSPI / host_sess_id_reuse_without_restore / N_gt_1 = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `ff0770d36b2972c4fae126589920d3ba490e40c060cb5c4017927186887bf7d3`)
- Fail r0: `xsim_fail_r0.log` (SHA256 `a93c0313ee5f809c10f2cf1f259e8d18027dff533bbcf9e35e0cbfdc2c8ca0b7`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this high-bit / reload_i / N=1 eviction bag.
Do not open LM06, BOARD, Master F3 10pp, or DDR from this bag. PROGRAM=NO.
