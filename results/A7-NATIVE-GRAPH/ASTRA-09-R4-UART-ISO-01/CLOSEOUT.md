# CLOSEOUT — ASTRA-09-R4-UART-ISO-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-09-R4-UART-ISO-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_09_R4_UART_ISO_PASS
SIM_TIME_NS          = 3471575
FAIL_COUNT           = 0
FAIL_R0              = none
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen SGD ISO)
WRAP                 = a7ng_astra_09_r4_uart_iso_wrap (bag-local; not PRODUCTION_TOP)
DUT                  = a7ng_astra_09_r2_cand_ovf (instantiated; hash 15a919f1… unchanged)
INSTANCE             = u_a09r2
ISO_SGD              = a7ng_shared_rank_sgd_q8_sym_f2r2 (u_iso; hash b66ef328… unchanged)
INNER_FROZEN_A09     = a7ng_astra_09_integ_path (NOT instantiated; hash 9fdbe0d6… unchanged)
UART                 = 115200 8N1 CMD=A5 MAGIC=A2
MMCM                 = UNISIM_MMCME2_BASE (NOT silicon MMCM)
ISO_P3               = UART FRAME w0=+5 viso=0 x0=50 rew=+3 tbl=0
ISO_M3               = UART FRAME w0=-6 viso=0 x0=64 rew=-3 tbl=0
LOAD_FROM_TB         = 0
ASTRA-09-R3 / ASTRA-12-R3 / ASTRA-11-A09R3* / ASTRA-09-R2 / ASTRA-09 / ASTRA-12* / F2R* / F3* / ASTRA-06-* = preserved, not edited; run scripts not rerun
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

Independent auditor of this UART-facing ISO XSim bag. Do not open LM06, BOARD,
DDR, Master F3, or ASTRA-13 from this bag. Do not freeze PRODUCTION_TOP.
Do not patch frozen A09, A09-R2, or SGD. PROGRAM=NO.
