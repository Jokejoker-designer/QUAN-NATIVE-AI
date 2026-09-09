# CLOSEOUT — ASTRA-F2R-R5-TXN-WRAP-RESET-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-F2R-R5-TXN-WRAP-RESET-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F2R5_TXN_WRAP_RESET_XSIM_PASS
SIM_TIME_NS          = 43815
FAIL_COUNT           = 0
FAIL_R0              = preserved (RETIRE_A_NO_UPD_B); one corrective; no golden edits
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f2r5_txn_wrap
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited; run_f2r2.ps1 not rerun
F2R3_BAG             = preserved, not edited; run_f2r3.ps1 not rerun
F2R4_BAG             = preserved, not edited; run_xsim.ps1 not rerun
F2R4_DUT             = a7ng_astra_f2r4_axi_drain.sv not patched
CONTRACT             = {sess_id,gen,txn} lifetime; wrap refuse; rst_n abort; delayed replay reject
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
F3 / LM06 / BOARD_PASS / post_timeout_recovery / interconnect_cancel / power_loss_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- Fail r0: `xsim_fail_r0.log` / `FAIL_R0.md` / `SHA256_fail_r0.txt`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this item-6 bag. Do not open F3, LM06, or BOARD from this
bag. PROGRAM=NO.
