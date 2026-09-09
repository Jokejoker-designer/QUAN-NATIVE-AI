# CLOSEOUT — ASTRA-09-R6-UART-ISO-PUBLIC-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-R6-UART-ISO-PUBLIC-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_R6_UART_ISO_PUBLIC_PASS
SIM_TIME_NS          = 3471735
FAIL_COUNT           = 0
FAIL_R0              = xelab_fail_r0.log (shared integer k; one corrective)
CORRECTIVE_PASSES    = 1
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (inner named DUT u_sgd)
WRAP                 = a7ng_astra_09_r6_uart_iso_public_wrap (bag-local; not PRODUCTION_TOP)
DUT                  = a7ng_astra_09_r6_iso_pub (new named; bag-local)
INSTANCE             = u_r6
INNER_SGD            = u_r6.u_sgd (a7ng_shared_rank_sgd_q8_sym_f2r2; hash b66ef328… unchanged)
SIBLING_SGD          = none
FROZEN_A09R2         = UNUSED (hash 15a919f1… unchanged; not compiled)
INNER_FROZEN_A09     = a7ng_astra_09_integ_path (NOT instantiated; hash 9fdbe0d6… unchanged)
UART                 = 115200 8N1 CMD=A5 MAGIC=A2
MMCM                 = UNISIM_MMCME2_BASE (NOT silicon MMCM)
ISO_P3               = UART FRAME inner w0=+5 v=0 x0=50 rew=+3 tbl=0
ISO_M3               = UART FRAME inner w0=-6 v=0 x0=64 rew=-3 tbl=0
LOAD_FROM_TB         = 0
FORCE_PRESENT        = NO
ASTRA-09-R5 / ASTRA-09-R4 / ASTRA-09-R3 / ASTRA-12-R3 / ASTRA-11-A09R3* / ASTRA-09-R2 / ASTRA-09 / ASTRA-12* / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / LM06 / BOARD_PASS / ASTRA-13 / wrap_route_bit = OPEN
```

## Evidence

- Raw pass: `xsim.log`
- First-elab fail (preserved): `xelab_fail_r0.log`
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- MMCM mode: `MMCM_MODE.txt`
- Contract: `PREREG.md` / `ACK.json`

## Next dependency

Independent auditor of this UART-facing PUBLIC ISO XSim bag. Do not open
LM06, BOARD, DDR, Master F3, or ASTRA-13 from this bag. Do not freeze
PRODUCTION_TOP. Do not patch frozen A09, A09-R2, or SGD. PROGRAM=NO.
