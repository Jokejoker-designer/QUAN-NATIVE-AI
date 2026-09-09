# CLOSEOUT — ASTRA-F2R-R3-SEMANTIC-GUARD-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-F2R-R3-SEMANTIC-GUARD-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F2R3_SEM_GUARD_XSIM_PASS
SIM_TIME_NS          = 78905
FAIL_COUNT           = 0
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f2r3_sem_guard
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited; run_f2r2.ps1 not rerun
FEATURE              = min(src_conf)>>2 + shared flags; not IDs
QUERY_LATCH          = subj+obj+rel+ctx
POLICY               = CONFLICT/INCOMP/UNKNOWN before selection; n_legal>4 → INCOMP
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
item5 / F3 / LM06 / BOARD_PASS = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Oracles: `oracle.json` / `PREREG.md`

## Next dependency

Independent auditor of this item-4 bag. Do not open item 5, F3, LM06, or BOARD from this bag. PROGRAM=NO.
