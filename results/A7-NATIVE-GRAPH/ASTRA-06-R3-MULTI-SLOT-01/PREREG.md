# PREREG — ASTRA-06-R3-MULTI-SLOT-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit ASTRA-06-WARM-PERSIST-01, ASTRA-06-R2-EVICT-HIGHID-01,
F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 or any F3 bags or frozen RTL
(`a7ng_astra_06_warm_persist.sv`, `a7ng_astra_06_r2_evict_highid.sv`,
`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`,
`a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`,
`a7ng_astra_f3r4_distinct_hold_phi.sv`).
Does not rerun those bags' run scripts. Does not patch persist/R2
pass evidence. Does not open LM06 / BOARD / Master F3 10pp / DDR.

## Claim this revision may close

Auditor `20260906T1125Z` leftover **N>1 persist slots** on a **new named**
DUT — not a patch of `a7ng_astra_06_warm_persist.sv` or
`a7ng_astra_06_r2_evict_highid.sv`. Not Master ASTRA-06 index/DDR eviction.

## One unknown

With persist capacity N≥2, can two committed snapshots keep distinct
{txn,phi,20-bit eids,w-delta target}, restore independently after rst,
and evict a written victim when a third commit arrives — without mixing
delayed rewards across slots?

## Law (regression, instantiated not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.
Plant A phi0=50, reward=-3, w=0 → dw0=-5.
Plant B phi0=40, reward=-3, w=0 → dw0=-4.

## Persist contract (inherited, still fail-closed)

Two domains: live FSM / AXI ost / in-flight SGD on `rst_n`; on-chip
persist **slot array** on `persist_clr_i` only. Not DDR, MIG, QSPI.
`sess_id_i` is host session nonce. `slot_sel_i` selects which row
`persist_*_o` observes and which row `reload_i` / auto `need_rl` restores.

## Capacity CAP_N=2 — REFUSE_ALL_UNCOMMITTED / EVICT_OLDEST_COMMITTED_LOWEST_TXN

Written policy. Persist is an N-entry array (`CAP_N=2`). Live FSM is
still single-issue (HOLD until `retire_i`). Each slot stores
`{valid,acc,cmt,txn,gen,epoch,phi[32],w[32],20-bit eids,vpred,ver}`.
New pending **zeros** that slot's `w` (no leftover weights).

| Occupancy | New PICK (persist_en=1) | Live pending | Persist |
|-----------|-------------------------|--------------|---------|
| free slot | install at free index | acc=1 cmt=0 | occ++ ; new uncommitted row |
| occ==N, ≥1 committed | **EVICT** victim then install | new acc=1 cmt=0 | victim row replaced; others unchanged |
| occ==N, all uncommitted | **REFUSE** `n_cap_ref++` | acc=0 | **unchanged** |

Victim = **oldest committed / lowest txn** among committed rows
(tie → lowest index). Uncommitted rows are never eviction victims.
`cap_full_o` = occ==N && n_committed==0.
`persist_en=0` does not apply this policy.

SGD commit writeback hits **only** `live_slot` (the row installed or
reloaded into live). Delayed reward matching live `{epoch,gen,txn}`
cannot update a different slot's `{phi,w,eids}`.

## Independent restore

`reload_i` + `slot_sel_i` restores that row into live pending + SGD
weights (32-cycle walk). Auto `need_rl` after rst restores `slot_sel_i`
when `restore_en_i` and native schema. Counters `n_rl_cmd` vs `n_rl_auto`.

## High-bit eids

Proof/answer identities are full `ID_W=20`. Plant A `20'hA0011` /
`20'hA00B4`; plant B `20'hA0111` / `20'hA0C55` (bits[19:8] nonzero).
No silent `[7:0]` slice on persist or proof ports.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| TWO_PICK_A | plant A, persist_en=1 | occ=1 s0 txn=1 phi0=50 p0=20'hA0011 acc=1 cmt=0 |
| TWO_PICK_B | retire, plant B | occ=2 s1 txn=2 phi0=40 p0=20'hA0111 ; s0 unchanged |
| RST_LIVE_CLEAR | rst restore_en=0 | live w0=0 acc=0 ; both rows still valid |
| RELOAD_A | slot_sel=0, reload_i | live txn=1 phi0=50 eids A ; n_rl_cmd++ |
| REW_A_ONLY | delayed rew A -3 | s0_w0=-5 s0_cmt=1 ; s1_w0=0 s1_cmt=0 s1_phi0=40 |
| MIX_B_WHILE_A | rew B ids while live A | nstale++ or nbad++ (gen/txn mismatch, F2R law); s1 still w0=0 cmt=0 |
| RELOAD_B | slot_sel=1, reload_i | live txn=2 phi0=40 eids B ; s0 still w0=-5 |
| REW_B_ONLY | delayed rew B -3 | s1_w0=-4 s1_cmt=1 ; s0_w0=-5 s0_phi0=50 |
| TWO_COMMIT_ROWS | after both commits | occ=2 both cmt distinct tuples |
| THIRD_EVICT | plant C, third PICK | n_cap_evict++ victim txn=1 idx=0 ; s0=C uncommitted ; s1 still B |
| REFUSE_ALL_UNC | two uncommitted, third PICK | n_cap_ref++ live acc=0 rows unchanged |
| UNREL_NO_STALE | restore A, `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 tbl=0 |

## Out of scope

Master ASTRA-06 as a whole. Master F3 10pp/CI. LM06. BOARD. ASTRA-13.
Production MIG/DDR. ASTRA-07 index image. QSPI/SD NVM journal.
Host `sess_id` reuse without restore. DDR index N>1 eviction.
Full32 DDR identity authority. schemaV2 migration of a DDR store.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
