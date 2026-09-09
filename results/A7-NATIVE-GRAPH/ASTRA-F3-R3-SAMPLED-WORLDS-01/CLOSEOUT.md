# CLOSEOUT — ASTRA-F3-R3-SAMPLED-WORLDS-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-F3-R3-SAMPLED-WORLDS-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
XSIM                 = ASTRA_F3R3_SAMPLED_WORLDS_XSIM_PASS
SIM_TIME_NS          = 278245
FAIL_COUNT           = 0
FAIL_R0              = none (first run PASS; no golden edits)
LAW                  = native-rank-sgd-q8-v1-sym-f2r2 (instantiated frozen F2R2 SGD)
DUT                  = a7ng_astra_f3r3_sampled_worlds
SGD                  = a7ng_shared_rank_sgd_q8_sym_f2r2 (READ-ONLY instantiate)
F2R01_BAG            = preserved, not edited
F2R2_BAG             = preserved, not edited
F2R3_BAG             = preserved, not edited
F2R4_BAG             = preserved, not edited
F2R5_BAG             = preserved, not edited
F3_SHARED_XFER_BAG   = preserved, not edited
F3R2_BAG             = preserved, not edited
SEEDS                = GEN 0xA5F33001; 5 distinct subj-rel worlds; 8 hold queries; 3 shared + 2 private facts; overlap dest 0x40 on q6/q7
MASTER_F3_10pp_CI    = OPEN (not claimed; protocol too small vs ASTRA-07 24×8)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
LM06 / BOARD_PASS / ASTRA-13 / persistence_DDR / power_loss_journal = OPEN
```

## Evidence

- Raw pass: `xsim.log` (SHA256 `7db52dbe79cdde396174f322200d3176b700350699fa8a5c390a072d92ee83d4`)
- SHA freeze (compiled + .svh + config): `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Contract: `PREREG.md` (Master thresholds frozen as not-claimed; no Wilson CI as Master)
- Metrics formulas: `metrics_prereg.json`; observed: `metrics.json`

## Residuals addressed in this bag (plumbing; auditor 0815Z 1–4, 6)

1. Sampled world generator: 5 distinct subject-relation worlds, 3 shared + 2 private facts, N_hold=8, N_epoch=2 frozen in PREREG. Not hop/ctx tweaks of one query. Not ASTRA-07 24×8 (not claimed).
2. Shuffle = +3 on DUT-selected train distractor **with mixed_ctx** (overlapping transferable feature mislabeled). Shuffle hold: gold lacks mixed_ctx and has min p0; dist has mixed_ctx; ranking reversed (`SH_HO_*_DIST` 8/8).
3. Per-ID = dest-keyed `pid[ans]+=3` scored on hold dests with **overlapping** IDs on q6/q7 (pid 2/2) where it could win; disjoint q0–q5 pid 0/6. Off shared `w`.
4. Retention = hold after epoch-2 and after `w_o` snapshot / rst / `load_v_i` (8/8 and 8/8) on this sampled protocol.
5. 32-φ + HASH dumped on the xsim log for train vs hold (`PHI_NEQ_Q*` hashes `42d33000` vs `42d33003`).
6. Master 10pp/CI/retention frozen not-claimed before xvlog. No Wilson printed.

## Next dependency

Independent auditor of this bag. Master F3 remains OPEN.
Do not open LM06 or BOARD from this bag. PROGRAM=NO.
