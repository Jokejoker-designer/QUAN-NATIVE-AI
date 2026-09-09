# CLOSEOUT — ASTRA-09-R2-CAND-OVF-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-R2-CAND-OVF-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_R2_CAND_OVF_XSIM_PASS
SIM_TIME_NS          = 9025
FAIL_COUNT           = 0
FAIL_R0              = xvlog_fail_r0.log (file 0 from PROGRAM_FPGA=0); one xvlog-arg corrective
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_09_r2_cand_ovf
INNER_FROZEN_A09     = a7ng_astra_09_integ_path (NOT instantiated; hash 9fdbe0d6… unchanged)
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
CAND_CAP             = 16
MAX_PATH             = 4
OVF_PLANT_N          = 20 (> CAND_CAP)
OVERFLOW             = DUT INCOMP ans=0 p0=0 ntrunc=4 r_ovf=1 w_ovf=0; hier_ans=0 hier_best=0
MAXPATH              = S_GUARD INCOMP n_legal=5>4 r_ovf=0
SMOKE                = two-proof ans=4 p0=17 after overflow retire and after MAX_PATH
UNREL                = UNKNOWN npath=0 ans=0 p0=0
ISO                  = +3 x0=50 dw0=+5
LOAD_FROM_TB         = 0
ASTRA-07 / ASTRA-09 / ASTRA-12* / ASTRA-11* / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-07_65536_800k / Master_ASTRA-09 / Master_F3 / LM06 / BOARD_PASS / ASTRA-13 = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- FAIL_R0: `xvlog_fail_r0.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md`

## Next dependency

Independent auditor of this ntrunc→INCOMP bag. Do not open LM06, BOARD, DDR,
Master F3, Master ASTRA-07 65536/800k, or ASTRA-13 from this bag. Do not freeze
PRODUCTION_TOP. Do not patch frozen A09. PROGRAM=NO.
