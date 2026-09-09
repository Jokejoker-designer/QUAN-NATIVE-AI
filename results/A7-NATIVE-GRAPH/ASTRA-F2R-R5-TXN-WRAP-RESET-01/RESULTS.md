# RESULTS — ASTRA-F2R-R5-TXN-WRAP-RESET-01

PROGRAM=NO. No JTAG/COM12/bit. F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 bags not edited.
Frozen `a7ng_astra_f2r4_axi_drain.sv` / `a7ng_astra_f2r3_sem_guard.sv` /
`a7ng_astra_f2r2_hs_law.sv` / `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` not patched.
`run_f2r.ps1` / `run_f2r2.ps1` / `run_f2r3.ps1` / F2R4 `run_xsim.ps1` not rerun.

```text
XSIM_MARKER      = ASTRA_F2R5_TXN_WRAP_RESET_XSIM_PASS
VERDICT_PROPOSED = PASS (this gate only: F2R_ACCEPTANCE item 6 wrap/reset lifetime)
SIM_TIME         = 43815 ns
FAIL             = 0
FIRST_DIVERGENCE = none (pass run)
FAIL_R0          = RETIRE_A_NO_UPD_B (preserved xsim_fail_r0.log; one corrective)
BIT              = NOT_BUILT
PROGRAM          = false
```

## Contract (written epoch/lifetime, not in-episode equality only)

Pending key is `{epoch=sess_id_i, gen, txn}`. `sess_id_i` is host session nonce
(transport metadata), not `live_epoch_i` (sparse-walker generation). Epoch 0 is
invalid. In-session 8-bit counters do not wrap: at `TXN_MAX` PICK refuses a new
pending (`txn_exh`, `n_exh`) and does not reissue `{epoch,1,1}`. `rst_n` clears
weights and pending (abort, not half-commit). After reset the host must supply a
fresh `sess_id_i`. DUT does not journal power-loss. Reward=-4 is n_oor.

TB wrap setup: `TXN_MAX=2` (documented, not a poke of production 255).
`live_epoch_i` held at 7 so retrieval is not used as the session nonce.

## Raw XSim (`xsim.log`)

| Case | Log | Result |
|------|-----|--------|
| ISO_P3_X50_DW5 | w0=5 viso=0 | PASS |
| SMOKE_TWO_PROOFS | st=0 npath=2 ans=4 p0=17 txn=1 gen=1 ep=7 acc=1 tbl=0 | PASS |
| HS_LATCH_NUPD | nupd=1 cmt=1 w0=-5 (one-cycle rew, bus invert) | PASS |
| DUP / WRONG_TXN / STALE_GEN / STALE_EPOCH / OOR_M4 | nupd stays 1, w0=-5 | PASS |
| RETIRE_A_NO_UPD_B | delayed `{7,1,1}` vs B `{7,2,2}` nstale=1 nupd=0 w0=0 | PASS |
| REWARD_B_ONCE | nupd=1 w0=-5 | PASS |
| WRAP_A / WRAP_B | `{20,1,1}` then `{20,2,2}` ANSWER 4 | PASS |
| WRAP_EXHAUST | third PICK acc=0 exh=1 nexh=1 still ANSWER 4 p0=17 | PASS |
| WRAP_NO_REUSE_11 | no live pending `{20,1,1}` | PASS |
| WRAP_REPLAY_NO_UPD | delayed A after exhaust nupd=0 w0=0 nbad=1 | PASS |
| EPOCH_RECYCLE_11 | sess_id 21, live_epoch still 7, pending `{21,1,1}` | PASS |
| EPOCH_REPLAY_STALE | delayed `{20,1,1}` nstale=1 w0=0 | PASS |
| EPOCH_FRESH_UPD | reward `{21,1,1}` w0=-5 | PASS |
| POST_RST_REUSED_NUMERIC | after rst, `{31,1,1}` numeric reuse, epoch differs | PASS |
| POST_RST_REPLAY_NO_UPD | delayed `{30,1,1}` nstale=1 w0=0 | PASS |
| POST_RST_FRESH_UPD | reward `{31,1,1}` nupd=1 w0=-5 | PASS |
| RST_UPD_IN_FLIGHT / CLEARED | mid-SGD rst_n: acc=0 cmt=0 nupd=0 w0=0 ep=0 | PASS |
| RST_UPD_FRESH_OK | sess 41 after abort nupd=1 w0=-5 | PASS |
| SMOKE_AFTER | st=0 npath=2 ans=4 p0=17 tbl=0 | PASS |
| UNREL_NO_STALE | st=1 npath=0 ans=0 p0=0 | PASS |

Marker present. `$finish` at 43815 ns. No FAIL lines on the pass run.

## Fail r0 (preserved, not edited)

`xsim_fail_r0.log` SHA256 `7a0a37e9f47bb16da859ba749b99d172fc3d33bf11cb6a840b24bec617977d67`.
First divergence `RETIRE_A_NO_UPD_B`. TB expected `n_bad`; DUT counted `n_stale`
because gen and txn both differ (handshake order epoch→gen→txn). Subsequent WRAP
smokes were UNKNOWN because the TB had reused `live_epoch_i` as the session
nonce. One corrective: `sess_id_i` split + TB reject check. No golden edits.

## Hashes

SHA freeze BEFORE xvlog `2026-09-06T13:53:22.8732673+07:00`.
xsim session Sun Sep 6 13:53:26–13:53:28 2026 PID **5776**.
Compiled + `.svh` pre/post **13/13 MATCH** (includes `a7ng_astra_f2r5_txn_wrap.svh`).
xsim.log SHA256 `a93aaedc559ae6bbb7bad36f088a5fa729ace77182d86bfc6c30bfe3cf0619b5`.
Frozen F2R4 DUT provenance `5cdb3da8…` (not compiled). Frozen SGD `b66ef328…`.
F2R4 bag `xsim.log` still `98297afc…`. F2R3 `806026f2…`. F2R2 `337ca164…`.

## Open (unchanged)

F3 transfer, LM06, SoC/timing, BOARD_PASS, post-timeout recovery, interconnect
cancel, power-loss journal. Host reuse of `sess_id_i` after `rst_n` is a
protocol violation, not a DUT uniqueness guarantee.
Do **not** claim 5 independent training seeds or BOARD_PASS. Manager independently
accepts. Do not autonomously open the next gate.
