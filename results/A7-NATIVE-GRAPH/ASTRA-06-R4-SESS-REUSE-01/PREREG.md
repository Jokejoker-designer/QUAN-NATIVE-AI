# PREREG — ASTRA-06-R4-SESS-REUSE-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-06-WARM-PERSIST-01, ASTRA-06-R2-EVICT-HIGHID-01,
ASTRA-06-R3-MULTI-SLOT-01, F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5
or any F3 bags or frozen RTL (`a7ng_astra_06_warm_persist.sv`,
`a7ng_astra_06_r2_evict_highid.sv`, `a7ng_astra_06_r3_multi_slot.sv`,
`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`,
`a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`,
`a7ng_astra_f3r4_distinct_hold_phi.sv`).
Does not rerun those bags' run scripts. Does not patch persist/R2/R3
pass evidence. Does not open LM06 / BOARD / Master F3 10pp / DDR.

## Claim this revision may close

Auditor `20260906T1200Z` leftover **host sess_id reuse after rst_n
without restore** on a **new named** DUT — not a patch of
`a7ng_astra_06_warm_persist.sv`, `a7ng_astra_06_r2_evict_highid.sv`,
or `a7ng_astra_06_r3_multi_slot.sv`. Not Master ASTRA-06. Not DDR.

## One unknown

After rst_n, if the host reuses the same `sess_id_i` **without** a
persist restore, is a delayed reward with that sess+txn **n_stale /
refused** — while restore with matching sess still commits the snapshot?

## Law (regression, instantiated not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.
Plant A phi0=50, reward=-3, w=0 → dw0=-5.
Plant B phi0=40, reward=-3, w=0 → dw0=-4.

## Sess lifetime (written; fail-closed)

`sess_id_i` is a host session nonce and is **part of the pending/persist
key** `{sess, gen, txn}` (stored as persist `ps_sess_epoch` / live
`pend_epoch`). It is not `live_epoch_i`. Epoch 0 is invalid.

Two domains (inherited): live FSM / AXI ost / in-flight SGD on `rst_n`;
on-chip persist slot array on `persist_clr_i` only. Not DDR, MIG, QSPI.

| Event | Live pending | Persist row | SGD weights |
|-------|--------------|-------------|-------------|
| PICK with persist_en | mint `{sess,gen,txn}` | install uncommitted row with that sess | live (rst-zero unless restored) |
| rst_n | **dies** (acc=0, sess_epoch=0, txn=0) | **kept** `{sess,gen,txn,phi,w,eids}` | live zeroed (frozen SGD rst) |
| reload / auto restore **matching** `sess_id_i == persist sess` | rebind live to snapshot | unchanged | walk persist w into SGD |
| reload with **mismatched** sess | no rebind; `n_sess_rej++` | unchanged | not pulled |
| delayed rew, no live pending | `n_stale++`; no S_UW | **not** written | not updated |
| PICK same sess after rst **without** restore | **REFUSE** `n_sess_reuse++`; acc=0; do **not** mint a new `{sess,txn=1}` | unchanged | not pulled |
| PICK **new** sess after rst without restore | new live pending allowed | old sess row unchanged | live stays 0; **do not** copy old persist w |
| After restore, host may keep same sess | next PICK increments txn (bound) | writeback only `live_slot` | matching delayed rew commits |

Persist **owns** a sess while a valid row stores that `sess_id`.
Ownership is released by `persist_clr_i` or by replacing the row (evict),
not by `rst_n`. Restore is the only way to rebind live identity to that
owned sess. Reusing the host nonce without restore is a protocol
violation and must not look like a new live pending.

`sess_bound_o` = live `sess_epoch != 0` and `sess_epoch == sess_id_i`.

Reload (cmd `reload_i` or auto `need_rl` with `restore_en_i`) requires
`schema_ok` **and** `sess_id_i == persist sess` of `slot_sel_i`.
Mismatch does not copy weights or pending key.

Delayed-rew handshake (inherited F2R): empty pending / epoch miss /
gen miss → `n_stale`; txn miss → `n_bad`. A pre-rst key against a
post-rst empty pending is a **lifetime miss** (`n_stale`), not commit.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| PICK_A | persist_en=1 sess=7 plant A | acc=1 txn=1 gen=1 ep=7 phi0=50 p0=20'hA0011 ans=20'hA00B4 persist sess=7 |
| RST_LIVE_CLEAR | rst restore_en=0 | live w0=0 acc=0 bound=0; persist still valid sess=7 txn=1 20-bit |
| REUSE_REW_STALE | same sess_id, no reload, delayed rew {7,1,1} | n_stale++; n_upd=0; persist w0=0 cmt=0; live acc=0 |
| REUSE_PICK_REFUSE | same sess_id, new PICK, no restore | n_sess_reuse++; acc=0; persist txn=1 unchanged; live txn not a new pending 1 |
| RELOAD_MISMATCH | sess_id=9, reload_i slot0 | n_sess_rej++; acc=0; live w0=0; persist still sess=7 |
| MATCH_RELOAD | sess_id=7, reload_i | n_rl_cmd++; acc=1 txn=1 gen=1 ep=7 phi0=50 eids A; bound=1 |
| MATCH_REW | delayed rew -3 matching | n_upd=1 cmt=1 w0=-5 persist w0=-5 |
| NEW_SESS_NO_PULL | rst restore_en=0 sess=9 plant B | live w0=0 ep=9; persist s0 still w0=-5 sess=7; not a copy of old w |
| NEW_SESS_OLD_REW | delayed rew old {7,1,1} while live sess=9 | n_stale++; persist s0 still -5 |
| UNREL_NO_STALE | restore matching, `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 tbl=0 |

## Out of scope

Master ASTRA-06 as a whole. Master F3 10pp/CI. LM06. BOARD. ASTRA-13.
Production MIG/DDR. ASTRA-07 index image. QSPI/SD NVM journal.
DDR index N>1 eviction. Full32 DDR identity authority.
schemaV2 migration of a DDR store. Power-loss NVM journal.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
