# CLOSEOUT — ASTRA-09-INTEGRATED-PATH-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-INTEGRATED-PATH-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_INTEGRATED_PATH_XSIM_PASS
SIM_TIME_NS          = 12705
FAIL_COUNT           = 0
FAIL_R0              = none (first xvlog/xelab/xsim PASS)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_09_integ_path
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
PATH                 = QSE+sparse retrieve+2-hop enum+SGD rank+pending {sess,gen,txn,phi}+handshake
SEMANTIC             = CONFLICT dest 4 vs 7 refused; wrong-object UNKNOWN; no rank-away
AXI                  = one SLVERR abort (RLAST+SLVERR → S_ABORT; ans/p0/pending cleared)
LOAD_FROM_TB         = 0
F2R*_BAG / F3*_BAG / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
Master_F3 / Master_ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / persist_DDR = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this integrated-path bag. Do not open LM06, BOARD, DDR,
or Master F3 from this bag. PROGRAM=NO.
