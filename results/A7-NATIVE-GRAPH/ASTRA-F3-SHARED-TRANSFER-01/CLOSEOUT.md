# CLOSEOUT — ASTRA-F3-SHARED-TRANSFER-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-F3-SHARED-TRANSFER-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F3_SHARED_TRANSFER_XSIM_PASS
SIM_TIME_NS          = 103615
FAIL_COUNT           = 0
FAIL_R0              = none (first run PASS; no golden edits)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f3_shared_xfer
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited
F2R3_BAG             = preserved, not edited
F2R4_BAG             = preserved, not edited
F2R5_BAG             = preserved, not edited
SEEDS                = 5 structural (quality / ctx / object-bound / dead-end / 1-hop water)
MASTER_F3_10pp_CI    = OPEN (not claimed)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / power_loss_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `b6da5fce37c6710f59dfad1ed8e691c7b3bf967f915180f4cf9ecde4955a46ce`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md` (Master thresholds frozen as not-claimed)
- Metrics formulas: `metrics_prereg.json`; observed: `metrics.json`

## Next dependency

Independent auditor of this F3 plumbing bag. Master F3 remains OPEN.
Do not open LM06 or BOARD from this bag. PROGRAM=NO.
