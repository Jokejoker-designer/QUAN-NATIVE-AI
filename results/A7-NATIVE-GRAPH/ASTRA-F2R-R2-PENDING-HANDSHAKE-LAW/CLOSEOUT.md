# CLOSEOUT — ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F2R2_HS_LAW_XSIM_PASS
SIM_TIME_NS          = 67695
R0_FAIL_PRESERVED    = xsim_fail_r0.log / FAIL_R0.md
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (Master symmetric RSH)
DUT                  = a7ng_astra_f2r2_hs_law
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2
F2R01_BAG            = preserved, not edited
FEATURE              = min(src_conf)>>2 + shared flags; not IDs
PENDING              = gen+txn+sel_idx+full scored phi+v_pred
HANDSHAKE            = latch rew on valid cycle; next-cycle bus ignored
INTEGER              = full 32-weight oracle match on +/-/0
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
F3 / F4 / F5 / LM06 / BOARD_PASS = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- Raw first fail: `xsim_fail_r0.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Oracles: `oracle.json` / `PREREG.md`

## Next dependency

Independent manager acceptance of this handshake/law gate. Do not open F3, conflict, AXI recovery, LM06, or BOARD from this bag. PROGRAM=NO.
