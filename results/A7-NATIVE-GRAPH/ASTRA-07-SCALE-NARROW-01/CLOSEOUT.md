# CLOSEOUT — ASTRA-07-SCALE-NARROW-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-07-SCALE-NARROW-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_07_SCALE_NARROW_XSIM_PASS
SIM_TIME_NS          = 13155
FAIL_COUNT           = 0
FAIL_R0              = none (first xvlog/xelab/xsim PASS)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_07_scale_narrow
INNER                = a7ng_astra_09_integ_path (READ-ONLY instantiate)
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
CAND_CAP             = 16
MAX_PATH             = 4
OVF_PLANT_N          = 20 (> CAND_CAP)
OVERFLOW             = wrap INCOMP cap_ovf=1; leftover A09 ans=4 not published
MAXPATH              = A09 S_GUARD INCOMP n_legal=5>4
SMOKE                = two-proof ans=4 p0=17 after overflow retire and after MAX_PATH
UNREL                = UNKNOWN npath=0 ans=0 p0=0
ISO                  = +3 x0=50 dw0=+5
LOAD_FROM_TB         = 0
ASTRA-12* / ASTRA-11* / ASTRA-09 / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-07_65536_800k / Master_ASTRA-09 / Master_F3 / LM06 / BOARD_PASS / ASTRA-13 = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this scale-narrow bag. Do not open LM06, BOARD, DDR,
Master F3, or ASTRA-13 from this bag. Do not freeze PRODUCTION_TOP. PROGRAM=NO.
