# CLOSEOUT — ASTRA-06-WARM-PERSIST-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-06-WARM-PERSIST-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_06_WARM_PERSIST_XSIM_PASS
SIM_TIME_NS          = 24055
FAIL_COUNT           = 0
FAIL_R0              = none (first run PASS; no golden edits)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_06_warm_persist
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited; run_f2r2.ps1 not rerun
F2R3_BAG             = preserved, not edited; run_f2r3.ps1 not rerun
F2R4_BAG             = preserved, not edited; run_xsim.ps1 not rerun
F2R5_BAG             = preserved, not edited; run_xsim.ps1 not rerun
F3 / F3R2 / F3R3 / F3R4 bags = preserved, not edited
CONTRACT             = rst_n clears live FSM/AXI ost/in-flight SGD; persist store keeps weights+pending {sess,gen,txn,phi,v_pred}+20-bit eids+epoch
SURVIVES_RST_N       = committed weights, pending key/phi/v_pred, 20-bit eids, epoch (on-chip journal, not DDR)
DOES_NOT_SURVIVE     = AXI ost, in-flight SGD, live FSM, HOLD result, live n_upd
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
Master_F3_10pp_CI / LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / NVM_QSPI / host_sess_id_reuse_without_restore = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `5f739df0778415567a16c80fdb7ccea6fca503600869cfc442fa5dafb7198804`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this modeled persist bag. Do not open LM06, BOARD,
Master F3 10pp, or DDR from this bag. PROGRAM=NO.
