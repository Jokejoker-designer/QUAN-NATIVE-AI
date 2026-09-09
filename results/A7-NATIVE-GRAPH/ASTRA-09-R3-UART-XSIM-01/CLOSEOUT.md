# CLOSEOUT — ASTRA-09-R3-UART-XSIM-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-R3-UART-XSIM-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_R3_UART_XSIM_PASS
SIM_TIME_NS          = 9631755
FAIL_COUNT           = 0
FAIL_R0              = none
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (inside instantiated frozen A09-R2)
WRAP                 = a7ng_astra_09_r3_uart_wrap (bag-local; not PRODUCTION_TOP)
DUT                  = a7ng_astra_09_r2_cand_ovf (instantiated; hash 15a919f1… unchanged)
INSTANCE             = u_a09r2
INNER_FROZEN_A09     = a7ng_astra_09_integ_path (NOT instantiated; hash 9fdbe0d6… unchanged)
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate inside A09-R2)
UART                 = 115200 8N1 MAGIC=A2
MMCM                 = UNISIM_MMCME2_BASE (NOT silicon MMCM)
CAND_CAP             = 16
OVF_PLANT_N          = 20 (> CAND_CAP)
OVF_UART             = FRAME A2 st=6 ans=0 p0=0 ntrunc=4 rov=1 tbl=0
SMOKE_UART           = FRAME A2 st=0 ans=4 p0=17 p1=34 npath=2 tbl=0
UNREL_UART           = FRAME A2 st=1 ans=0 p0=0 npath=0 tbl=0
LOAD_FROM_TB         = 0
ASTRA-11-A09R2 / WRAP-UART-XSIM / ASTRA-09-R2 / ASTRA-09 / ASTRA-12* / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / LM06 / BOARD_PASS / ASTRA-13 / wrap_route_bit = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- MMCM mode: `MMCM_MODE.txt`
- Contract: `PREREG.md` / `ACK.json`

## Next dependency

Independent auditor of this UART-glue XSim bag. Do not open LM06, BOARD,
DDR, Master F3, or ASTRA-13 from this bag. Do not freeze PRODUCTION_TOP.
Do not patch frozen A09 or A09-R2. PROGRAM=NO.
