# RESULTS — ASTRA-06-WARM-PERSIST-01

PROGRAM=NO. No JTAG/COM12/bit. F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5
and all F3 bags not edited. Frozen F2R2 SGD / F2R2–F2R5 / F3* integrators
not patched. Those bags' run scripts not rerun.

```text
XSIM_MARKER      = ASTRA_06_WARM_PERSIST_XSIM_PASS
VERDICT_PROPOSED = PASS_NARROW (this gate only: modeled on-chip warm persist / power-loss journal)
SIM_TIME         = 24055 ns
FAIL             = 0
FIRST_DIVERGENCE = none (first run PASS)
FAIL_R0          = none
BIT              = NOT_BUILT
PROGRAM          = false
```

## Contract (what survives `rst_n`)

Persist store is **on-chip registers**, not DDR/MIG/QSPI. `persist_clr_i`
is a test wipe. Modeled power-loss = `rst_n` low, `persist_clr_i` held 0.

**Survives `rst_n` (if snapshotted under persist_en):**
committed SGD weights; pending `{sess/epoch, gen, txn, phi[0:31], v_pred}`;
20-bit `{ans, p0, p1}`; `pend_acc`/`pend_cmt`; `sess_epoch`.

**Does not survive `rst_n`:**
AXI ost / drain / dead_mask; in-flight SGD (frozen SGD shares `rst_n`);
live FSM; HOLD result ports; live `n_upd` and identity counters.
Weight writes snap into persist **only** on SGD `done` of an accepted
update — never during SCORE/UPD (no half-commit).

Empty pending after power-loss (epoch 0) vs a pre-loss key is `n_stale`.
Journal valid + `restore_en=0` leaves live pending empty; delayed key is
`n_stale`. After restore, host may keep the same `sess_id`.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| SMOKE_TWO_PROOFS | st=0 npath=2 ans=4 p0=17 acc=1 txn=1 gen=1 ep=7 phi0=50 tbl=0 | PASS |
| PEND_EID20 | pans=4 pp0=17 (20-bit, not truncated) | PASS |
| PERSIST_SNAP | pval=1 pacc=1 pcmt=0 pw0=0 pep=7 ptxn=1 pgen=1 pphi0=50 | PASS |
| EN_RST_LIVE_CLEAR | after rst+reload live w0=0 nupd=0 ost=0; persist still valid | PASS |
| AXI_OST_CLEARED | ost=0 | PASS |
| EN_RELOAD_KEY | pend {7,1,1} acc=1 cmt=0 phi0=50 pw0=0 | PASS |
| EN_DELAYED_UPD | nupd=1 cmt=1 w0=-5 (same snapshot) | PASS |
| DIS_NO_SNAP / DIS_RST_STALE | persist_en=0; delayed {7,1,1} nstale=1 nupd=0 w0=0 | PASS |
| NO_RESTORE_KEEP / NO_RESTORE_STALE | pval=1 but live acc=0; delayed nstale=1 | PASS |
| RST_UPD_IN_FLIGHT | busy && !result_v | PASS |
| NO_HALF_COMMIT | MID_UPD live w0=-5 persist pw0=0 pcmt=0 | PASS |
| NO_HALF_AFTER_RST | persist pw0=0; live restored w0=0 acc=1 cmt=0 | PASS |
| RST_UPD_RELOAD_OK | delayed matching rew nupd=1 w0=-5 (full, not half) | PASS |
| HS_LATCH_NUPD | nupd=1 cmt=1 w0=-5 (one-cycle rew, bus invert) | PASS |
| UNREL_NO_STALE | after restore payroll tax form st=1 npath=0 ans=0 p0=0 tbl=0 | PASS |

Marker present. `$finish` at 24055 ns. No FAIL lines on the pass run.

## Fail r0

None. First xvlog/xelab/xsim PASS. No golden edits. No corrective RTL/TB pass.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T16:12:08.5517066+07:00`.
xsim session Sun Sep 6 16:12:12–16:12:14 2026 PID **33088**.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_06_warm_persist.svh`).
xsim.log SHA256 `5f739df0778415567a16c80fdb7ccea6fca503600869cfc442fa5dafb7198804`.
Frozen SGD `b66ef328…`. Frozen F2R5 DUT provenance `41c77e76…` (not compiled).
F2R5 bag `xsim.log` still `a93aaedc…`. F3R4 `27d60953…`. F2R4 `98297afc…`.

## Open (unchanged / not this close)

Master F3 10pp/CI, LM06, SoC/timing, BOARD_PASS, ASTRA-13, production
MIG/DDR persistence, ASTRA-07 index image, QSPI/SD NVM journal.
Host reuse of `sess_id_i` after `rst_n` **without** restore remains a
protocol violation, not a DUT uniqueness guarantee.
Do **not** claim DDR durability or BOARD_PASS. Manager independently
accepts. Do not autonomously open the next gate.
