# CLOSEOUT — ASTRA-F3-R2-INDEPENDENT-WORLDS-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-F3-R2-INDEPENDENT-WORLDS-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_PASS
SIM_TIME_NS          = 148845
FAIL_COUNT           = 0
FAIL_R0              = none (first run PASS; no golden edits)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f3r2_ind_worlds
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited
F2R3_BAG             = preserved, not edited
F2R4_BAG             = preserved, not edited
F2R5_BAG             = preserved, not edited
F3_SHARED_XFER_BAG   = preserved, not edited
SEEDS                = 5 independent world/role/relation/support (quality-hop, ctx-match, obj-ctx, mixed+dead-end, ctx_nz)
MASTER_F3_10pp_CI    = OPEN (not claimed)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / power_loss_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `5ba49f7d0838a4bf8abb1135cb7229e1e0b1c49fedbe268ba7c1c29b2db2dd56`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md` (Master thresholds frozen as not-claimed; no Wilson CI as Master)
- Metrics formulas: `metrics_prereg.json`; observed: `metrics.json`

## Residuals addressed in this bag (plumbing)

1. Independent world/role/relation/support draws; `PHI_NEQ` 5/5; no S0/S3 quality twins.
2. Shuffle = +3 on DUT-selected train **distractor** (permuted pairing), not `−3` on gold φ.
3. Per-ID = dest-keyed `pid[ans]+=3` scored on hold dests (0/5).
4. Retention = hold after epoch-2 and after `w_o` snapshot / rst / `load_v_i` (5/5 and 5/5).
5. Master 10pp/CI frozen not-claimed before xvlog.
7. `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`. ISO +3,x0=50 → dw0=+5.

## Next dependency

Independent auditor of this bag. Master F3 remains OPEN.
Do not open LM06 or BOARD from this bag. PROGRAM=NO.
