# PREREG — ASTRA-06-WARM-PERSIST-01

Frozen before xvlog. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 or any F3 bags
or frozen RTL (`a7ng_astra_f2r2_hs_law.sv`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`,
`a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`,
`a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`,
`a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv`).
Does not rerun those bags' run scripts. Does not patch F3-R4 pass evidence.
Does not open LM06 / BOARD / Master F3 10pp / DDR.

## Claim this revision may close

F2R5 remainder **power-loss journal** as a **modeled on-chip persist store**
(not DDR, not MIG, not QSPI, not ASTRA-07 index image):

After `rst_n` that clears the live FSM, do SGD weights and pending
`{sess,gen,txn,phi,v_pred}` restore so a delayed matching reward still
updates the **same** snapshot — and a pre-loss key without restore is
stale?

Does **not** close Master F3 (10pp / paired CI / retention), LM06,
BOARD_PASS, ASTRA-13, production DDR/MIG persistence, NVM/QSPI journal,
or host `sess_id` reuse after `rst_n` **without** restore.

## One unknown

After a modeled power-loss (`rst_n` that clears live FSM but **not** a
persist store), do SGD weights and pending `{sess,gen,txn,phi,v_pred}`
restore so a delayed matching reward still updates the **same** snapshot
— and a pre-loss key without restore is stale?

## Law (regression, instantiated not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.
Smoke path phi0=50, reward=-3, w=0 → dw0=-5.

## Persist contract (written; fail-closed)

Two domains:

| Domain | Reset | Contents |
|--------|-------|----------|
| Live FSM / AXI ost / in-flight SGD | `rst_n` (async) | walker, drain, `axi_ost`, `dead_mask`, SGD MAC/weights, `n_upd` and identity counters, HOLD result ports |
| Persist journal | `persist_clr_i` only (not `rst_n`) | last committed weights[0:31]; pending `{epoch=sess, gen, txn, phi[0:31], v_pred, sel, acc, cmt}` and 20-bit `{ans,p0,p1}` |

`persist_clr_i` is a **test/isolation wipe**, not modeled power-loss.
Modeled power-loss = `rst_n` low, `persist_clr_i` held 0.

This journal is **on-chip registers**. It is **not** DDR, MIG, QSPI, or
an ASTRA-07 index image. No production durability claim.

### Survives `rst_n` (if `persist_en_i` had snapshotted)

- SGD weights last **committed** into persist (`snap_w` only on SGD
  `done` of an accepted update — never during SCORE/UPD).
- Pending key `{sess_id/epoch, gen, txn}`.
- `phi[0:31]` copy and `v_pred` at PICK.
- 20-bit pending eids `{ans, proof0, proof1}` (full ID_W, not 8-bit).
- `pend_acc` / `pend_cmt` flags as of last snap.
- `sess_epoch` so wrap counters restore with the snapshot.

### Does **not** survive `rst_n`

- AXI outstanding (`axi_ost`, `ost_rid`, `dead_mask`, drain/abort).
- In-flight SGD (frozen SGD shares `rst_n`; MAC/partial `w` discarded).
- Live FSM state, HOLD `ans_o`/`n_path`/`status` (query result, not journal).
- Live `n_upd` / `n_stale` / `n_bad` / `n_dup` / `n_oor` (session counters).
- Uncommitted weight writes: persist must not half-commit.

### Enable / restore

- `persist_en_i` gates **checkpoint** (PICK snap pending; SGD-done snap weights).
- `restore_en_i` gates **reload** after `rst_n` if `persist_valid`.
- Reload walks idx 0..31 into frozen SGD `load_*` then copies pending into live.
- `reload_i` pulses an explicit reload from a valid journal.
- If `persist_en_i=0`, no snapshot: after `rst_n` journal is empty/invalid.
- If journal valid but `restore_en_i=0`, live pending stays empty (epoch 0).

### Reward handshake (live, after restore or not)

On `rew_v_i` in `S_IDLE` or `S_HOLD`, if SGD ready:

| Check | Counter | Update |
|-------|---------|--------|
| `!pend_acc` && (`pend_epoch==0` \|\| `rew_epoch != pend_epoch`) | n_stale | no |
| `!pend_acc` | n_bad | no |
| `rew_epoch != pend_epoch` | n_stale | no |
| `rew_gen != pend_gen` | n_stale | no |
| `rew_txn != pend_id` | n_bad | no |
| `rew` not in [-3,+3] (includes **-4**) | n_oor | no |
| already committed | n_dup | no |
| else | latch `rew_lat`, SGD `go_upd` | yes, commit after done; then snap_w if persist_en |

Empty pending after power-loss (epoch 0) vs a pre-loss key is a
**lifetime miss** (`n_stale`), not an in-episode `n_bad`.

Epoch 0 is invalid and never issued as a pending key.
`sess_id_i` is host session nonce / transport metadata, not `live_epoch_i`.

After restore, host **may** keep the same `sess_id` because the journaled
epoch is the identity. Host reuse of `sess_id` after `rst_n` **without**
restore remains a protocol violation (OPEN, not this close).

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| SMOKE_TWO_PROOFS | `pump requires indirect`, epoch=7 | ANSWER npath=2 p0=17 ans=4 txn=1 gen=1 ep=7 acc=1 tbl=0 |
| PEND_EID20 | same | persist/pending eids 20-bit ans=4 p0=17 (not truncated) |
| HS_LATCH_NUPD | one-cycle rew=-3 then bus invert | n_upd=1 cmt=1 w0=-5 |
| PERSIST_SNAP | persist_en=1, pending uncommitted, w=0 | persist_valid=1 persist_w0=0 persist_acc=1 persist_cmt=0 |
| EN_RST_LIVE_CLEAR | power-loss rst_n, restore_en=1 | live w0=0 acc=0 axi_ost=0; persist still valid w0=0 |
| EN_RELOAD_KEY | auto reload | pend {7,1,1} acc=1 cmt=0 phi0=50 v_pred restored |
| EN_DELAYED_UPD | delayed matching rew=-3 | n_upd=1 cmt=1 w0=-5 (same snapshot) |
| DIS_RST_STALE | persist_en=0, pending, rst, same numeric {7,1,1} | n_stale++, n_upd=0 w0=0 !cmt |
| NO_RESTORE_STALE | persist_en=1 capture, rst restore_en=0 | persist_valid=1; delayed key n_stale; live acc=0 |
| RST_UPD_IN_FLIGHT | persist_en, rew then rst mid SGD | live busy then cleared |
| NO_HALF_COMMIT | same | persist_w0 still 0 (not partial UPD) |
| RST_UPD_RELOAD_OK | restore then delayed matching rew | n_upd=1 w0=-5 (full, not half) |
| AXI_OST_CLEARED | after any rst_n | axi_ost=0 |
| UNREL_NO_STALE | after restore, `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 tbl=0 |

## Out of scope

Master F3 10pp/CI. LM06. BOARD. ASTRA-13. Production MIG/DDR. ASTRA-07
index image. QSPI/SD NVM journal. Host `sess_id` reuse without restore.
Sparse-walker timeout recovery. Interconnect cancel.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
