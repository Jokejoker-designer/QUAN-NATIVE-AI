# CLOSEOUT — ASTRA-09-R7-UART-QUERY-REW-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-R7-UART-QUERY-REW-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_R7_UART_QUERY_REW_PASS
SIM_TIME_NS          = 11975335
FAIL_COUNT           = 0
FAIL_R0              = xsim_fail_r0.log (retire re-TX; one wrap sent-hold corrective)
CORRECTIVE_PASSES    = 1
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (inside instantiated frozen A09-R2)
WRAP                 = a7ng_astra_09_r7_uart_query_rew_wrap (bag-local; not PRODUCTION_TOP)
DUT                  = a7ng_astra_09_r2_cand_ovf (instantiated; hash 15a919f1… unchanged)
INSTANCE             = u_a09r2
INNER_SGD            = u_a09r2.u_sgd (a7ng_shared_rank_sgd_q8_sym_f2r2; hash b66ef328… unchanged)
SIBLING_SGD          = none
ISO_PUB_DUT          = none
INNER_FROZEN_A09     = a7ng_astra_09_integ_path (NOT instantiated; hash 9fdbe0d6… unchanged)
UART                 = 115200 8N1 MAGIC=A2 CMD_REW=A6 CMD_RET=A7 OBS_TAG=57
MMCM                 = UNISIM_MMCME2_BASE (NOT silicon MMCM)
CAND_CAP             = 16
OVF_PLANT_N          = 20 (> CAND_CAP)
SMOKE_UART           = FRAME A2 st=0 ans=4 p0=17 p1=34 npath=2 tbl=0 phi0=50 w0=0
REW_M3               = FRAME A2 OBS w0=-5 phi0=50 nupd=1 tbl=0 hier_sgd_w0=-5
OVF_UART             = FRAME A2 st=6 ans=0 p0=0 ntrunc=4 rov=1 tbl=0
UNREL_UART           = FRAME A2 st=1 ans=0 p0=0 npath=0 tbl=0
LOAD_FROM_TB         = 0
FORCE_PRESENT        = NO
ASTRA-09-R6 / ASTRA-09-R5 / ASTRA-09-R4 / ASTRA-09-R3 / ASTRA-12-R3 / ASTRA-11-A09R3* / ASTRA-09-R2 / ASTRA-09 / ASTRA-12* / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / LM06 / BOARD_PASS / ASTRA-13 / wrap_route_bit = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- First-sim fail (preserved): `xsim_fail_r0.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- MMCM mode: `MMCM_MODE.txt`
- Contract: `PREREG.md` / `ACK.json`

## Next dependency

Independent auditor of this UART query-learn XSim bag. Do not open LM06,
BOARD, DDR, Master F3, or ASTRA-13 from this bag. Do not freeze
PRODUCTION_TOP. Do not patch frozen A09, A09-R2, or SGD. PROGRAM=NO.
