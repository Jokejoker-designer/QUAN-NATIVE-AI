# CLOSEOUT — ASTRA-F3-R4-DISTINCT-HOLD-PHI-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-F3-R4-DISTINCT-HOLD-PHI-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F3R4_DISTINCT_HOLD_PHI_XSIM_PASS
SIM_TIME_NS          = 328365
FAIL_COUNT           = 0
FAIL_R0              = none (first run PASS; no golden edits)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f3r4_distinct_hold_phi
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited
F2R3_BAG             = preserved, not edited
F2R4_BAG             = preserved, not edited
F2R5_BAG             = preserved, not edited
F3_SHARED_XFER_BAG   = preserved, not edited
F3R2_BAG             = preserved, not edited
F3R3_BAG             = preserved, not edited (PID 27400, 15:22:22)
SEEDS                = GEN 0xA5F34001; 5 worlds unique train HASH; 8 unique hold HASH; 1 shared + 1 private complete 2-hop; npath=4; fifth hop INCOMP
MASTER_F3_10pp_CI    = OPEN (not claimed; protocol too small vs ASTRA-07 24×8)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / power_loss_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `27d60953674ba7a693efae37bb7c47bec5a769746d482c4b1bf596a98b9af6b2`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md` (Master thresholds frozen as not-claimed; no Wilson CI as Master)
- Metrics formulas: `metrics_prereg.json`; observed: `metrics.json`

## Residuals addressed in this bag (plumbing; auditor 0850Z 1–2, 6)

1. ≥8 hold queries with **unique** `HASH=` on xsim.log (`HOLD_HASH_SET` 8 distinct values). `PHI_NEQ` 8/8 vs train.
2. ≥5 train worlds with unique train HASH (`TR_WORLD_HASH` 5 distinct). Not one train φ copied across directory keys.
3. Shared and private complete 2-hops enter `npath` (`npath=4` on 64 ranking queries). Fifth legal hop → `ST_INCOMP` at cap 4.
4. 32-φ + HASH dumped on the log for train and hold.
5. Shuffle mislabels overlapping mixed_ctx (hold gold lacks it, min p0; dist picked 8/8).
6. Master 10pp/CI/retention frozen not-claimed before xvlog. No Wilson printed. ASTRA-07 24×8 not run.

## Next dependency

Independent auditor of this bag. Master F3 remains OPEN.
Do not open LM06 or BOARD from this bag. PROGRAM=NO.
