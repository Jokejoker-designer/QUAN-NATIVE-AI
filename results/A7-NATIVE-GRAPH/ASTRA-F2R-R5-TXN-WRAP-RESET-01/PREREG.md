# PREREG — ASTRA-F2R-R5-TXN-WRAP-RESET-01

Frozen before xvlog. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`).
Does not rerun `run_f2r.ps1` / `run_f2r2.ps1` / `run_f2r3.ps1` /
F2R4 `run_xsim.ps1`.

## Claim this revision may close

F2R_ACCEPTANCE item **6 remainder** only: pending identity lifetime after
8-bit wrap and after `rst_n`, with a written epoch/lifetime contract — not
in-episode `{gen,txn}` equality only.

Smoke: retrieval→proof still works. UNREL no stale proof.
In-episode dup / wrong txn / stale gen / reward=-4 still reject.

Does **not** close F3 transfer, LM06, SoC/timing, BOARD_PASS, post-timeout
recovery, interconnect cancel, or power-loss journal.

## One unknown

Can a delayed reward with an old `{gen,txn}` after 8-bit wrap or after `rst_n`
fail to update a new pending that reused `{1,1}` — with a written
epoch/lifetime contract, not in-episode equality only?

## Law (regression, instantiated not copied)

Same frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.
Smoke path phi0=50, reward=-3, w=0 → dw0=-5.

## Identity / lifetime contract

Pending snapshot (explicit fields, latched at PICK):

```text
pending = {epoch[15:0], gen[7:0], txn[7:0], sel_idx, p0, p1, ans,
           phi[0:31], v_pred, accepted, committed}
```

`epoch` is `sess_id_i` captured at birth. It is **host session nonce /
transport metadata**, not a semantic cue and not an entity/proof feature.
`live_epoch_i` stays the sparse-walker generation and is **not** the pending
key (mixing them made retrieval miss when the TB bumped epoch).

Reward bus: `{rew_v, rew signed[3:0], rew_txn[7:0], rew_gen[7:0], rew_epoch[15:0]}`.
On the valid cycle only, if pending accepted && !committed && SGD ready:

| Check | Counter | Update |
|-------|---------|--------|
| `!pend_acc` | n_bad | no |
| `rew_epoch != pend_epoch` | n_stale | no |
| `rew_gen != pend_gen` | n_stale | no |
| `rew_txn != pend_id` | n_bad | no |
| `rew` not in [-3,+3] (includes **-4**) | n_oor | no |
| already committed | n_dup | no |
| else | latch `rew_lat`, SGD go_upd next cycle | yes, commit after done |

Key is `{epoch, gen, txn}`. Matching gen/txn with a different epoch is a
**lifetime miss**, not an in-episode hit.

### Wrap (in-session, DUT fail-closed)

`txn`/`gen` are 8-bit and increment together on each successful PICK
(0 → first pending `{epoch,1,1}`). They **do not wrap** in a session.

If `live_epoch_i == sess_epoch` and `txn == TXN_MAX`, PICK **refuses** a new
pending: `pend_acc=0`, `txn_exh=1`, `n_exh++`. Proof/ANSWER may still be
reported (retrieval not sacrificed); learning is fail-closed. The pair
`{epoch,1,1}` is **not** reissued. Exhaustion is a clear status (`txn_exh`,
`n_exh`), not a silent reuse.

A new `sess_id_i` (≠ `sess_epoch`, ≠ 0) recycles the 8-bit counters:
next pending is `{new_epoch,1,1}`. Old delayed `{old_epoch,1,1}` is n_stale.

Default `TXN_MAX=255`. TB instantiates `TXN_MAX=2` as the **documented wrap
setup**; it does not poke production counters during the exam.

Epoch 0 is invalid and never issued as a pending key.

### Hard reset

`rst_n` clears weights, pending (`accepted=0`,`committed=0`), `txn`/`gen`=0,
`pend_epoch=0`, `sess_epoch=0`, `n_upd` and identity counters. This is an
**abort**, not a silent half-commit: in-flight SGD writes are discarded
because the frozen SGD shares `rst_n`.

DUT does **not** journal across power-loss / bitstream reload. After `rst_n`,
anti-replay of a delayed `{gen,txn}` requires the host to supply a **fresh**
`sess_id_i` not equal to any in-flight reward's epoch. Reusing `sess_id_i`
after `rst_n` is a host protocol violation, not a DUT uniqueness guarantee.
Width increase of txn alone is not this contract.

Retire in HOLD drops pending and keeps weights. Hard reset clears both.
Those are distinct.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| SMOKE_TWO_PROOFS | `pump requires indirect`, epoch=7, TXN_MAX=2 | ANSWER npath=2 p0=17 ans=4 txn=1 gen=1 epoch=7 acc=1 tbl=0 |
| HS_LATCH_NUPD | one-cycle rew=-3 then bus invert | n_upd=1 cmt=1 w0=-5 |
| DUP / WRONG_TXN / STALE_GEN / STALE_EPOCH / OOR_M4 | in-episode after commit | counters increment; n_upd stays 1; w0 unchanged |
| RETIRE_A_NO_UPD_B | hold A, retire, birth B, send A | B not updated (`n_stale` and/or `n_bad`); send B updates once |
| WRAP_EXHAUST | births A `{20,1,1}` B `{20,2,2}` then third PICK | txn_exh=1 n_exh>=1 acc=0; still ANSWER 4 (retrieval) |
| WRAP_NO_REUSE_11 | same | no live pending `{20,1,1}` |
| WRAP_REPLAY_NO_UPD | delayed A after exhaust | n_upd unchanged, w0=0 |
| EPOCH_RECYCLE_11 | bump sess_id to 21, live_epoch stays 7, no rst | pending `{21,1,1}` |
| EPOCH_REPLAY_STALE | delayed `{20,1,1}` | n_stale, no update |
| EPOCH_FRESH_UPD | reward `{21,1,1}` | n_upd++ w0=-5 |
| POST_RST_REUSED_NUMERIC | rst, epoch 30→31, new pending `{31,1,1}` | numeric gen/txn reused, epoch differs |
| POST_RST_REPLAY_NO_UPD | delayed `{30,1,1}` | n_stale, w0=0, not committed |
| POST_RST_FRESH_UPD | reward `{31,1,1}` | n_upd=1 w0=-5 |
| RST_UPD_IN_FLIGHT / CLEARED | reward then rst_n mid SGD | acc=0 cmt=0 n_upd=0 w0=0 epoch_o=0 |
| RST_UPD_FRESH_OK | new epoch 41 after abort | one update, w0=-5 |
| SMOKE_AFTER / UNREL_NO_STALE | ANSWER then `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 |

## Out of scope

F3 multi-seed transfer. LM06. BOARD. Same-query AXI recovery. Interconnect
cancel. Power-loss persistence. Sparse-walker timeout. Production MIG/DDR.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
