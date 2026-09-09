# PREREG — ASTRA-06-R2-EVICT-HIGHID-01

Frozen before xvlog. PROGRAM=NO. No board.
Does not edit ASTRA-06-WARM-PERSIST-01, F2R-01 / F2R-R2 / F2R-R3 /
F2R-R4 / F2R-R5 or any F3 bags or frozen RTL
(`a7ng_astra_06_warm_persist.sv`, `a7ng_astra_f2r2_hs_law.sv`,
`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`,
`a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`,
`a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`,
`a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv`).
Does not rerun those bags' run scripts. Does not patch persist-bag
pass evidence. Does not open LM06 / BOARD / Master F3 10pp / DDR.

## Claim this revision may close

Auditor `20260906T0945Z` residuals **2** (high-bit IDs), **7**
(`reload_i` untested), and **capacity/eviction** on a **new named**
DUT — not a patch of `a7ng_astra_06_warm_persist.sv`.

Does **not** close Master ASTRA-06 (schemaV2 DDR store, N>1 index,
DDR-across-BRAM-loss, NVM/QSPI), Master F3, LM06, BOARD_PASS,
ASTRA-13, or host `sess_id` reuse after `rst_n` without restore.

## One unknown

Can persist store 20-bit eids with bits[19:8] nonzero, honor an
explicit `reload_i`, and evict/refuse a second pending when
capacity=1 — without silent [7:0] slice or half-commit?

## Law (regression, instantiated not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.
Smoke path phi0=50, reward=-3, w=0 → dw0=-5.

## Persist contract (inherited, still fail-closed)

Two domains, same as persist bag: live FSM / AXI ost / in-flight SGD
on `rst_n`; on-chip persist journal on `persist_clr_i` only.
Not DDR, MIG, QSPI. `sess_id_i` is host session nonce.

## Capacity N=1 — REFUSE_UNCOMMITTED_EVICT_COMMITTED

Written policy. Single persist slot (`CAP_N=1`). Persist never holds
two snapshots.

Live FSM is still single-issue (HOLD until `retire_i`). Capacity is
the **persist slot**, which keeps `{acc,cmt,eids,key}` across retire
and across `rst_n`.

| Persist slot | New PICK (persist_en=1) | Live pending | Persist |
|--------------|-------------------------|--------------|---------|
| empty | install | acc=1 cmt=0 | one uncommitted snapshot |
| occupied uncommitted (`p_valid && p_acc && !p_cmt`) | **REFUSE** `n_cap_ref++` | acc=0 | **unchanged** |
| occupied committed (`p_valid && p_cmt`) | **EVICT** `n_cap_evict++` then install | new acc=1 cmt=0 | **one** new uncommitted snapshot (old committed gone) |

`cap_full_o` = occupied uncommitted. Retrieval ANSWER may still be
reported on refuse (learning fail-closed). `persist_en=0` does not
apply this policy (no journal occupancy).

## High-bit eids

Proof/answer identities are full `ID_W=20`. Plant uses eids
`20'hA0011` / `20'hA0022` / answer `20'hA00B4` (bits[19:8] nonzero).
No silent `[7:0]` slice on persist or proof ports. Query parser
roles stay 8-bit (QSE); fact eids/objects in the AXI corpus are 20-bit.

## `reload_i` vs auto `need_rl`

| Path | Condition | Counter |
|------|-----------|---------|
| auto | after `rst_n`, `need_rl && persist_valid && restore_en && native schema` | `n_rl_auto` |
| explicit | `reload_i` pulse, `persist_valid && native schema` (restore_en not required) | `n_rl_cmd` |

Explicit path is the residual-7 test: `restore_en=0` so auto does not
fire; pulse `reload_i`; delayed matching reward still commits.
Foreign schema rejects both paths (`n_schema_rej++`, no weight reload).

## Schema byte (optional residual)

Persist stores `schema_i` at snap. Native `SCHEMA_VER=8'h01` restores.
Foreign VER (`8'hA5`, via `schema_poke_i` host rewrite of the journal
byte only — not a weight poke, `load_from_tb_o=0`) does **not** restore
into live weights. Persist payload stays; live SGD stays reset-zero.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| SMOKE_HIGHID | `pump requires indirect`, plant 20'hA0011 | ANSWER npath>=2 ans=20'hA00B4 p0=20'hA0011 bits[19:8]!=0 tbl=0 |
| HIGHID_EID20 | same | persist/live full 20-bit, not [7:0] |
| PERSIST_SNAP | persist_en=1 uncommitted | pval=1 pver=1 cap_full=1 |
| EN_RST_LIVE_CLEAR | rst_n restore_en=1 | live nupd=0 ost=0; persist still valid |
| EN_RELOAD_AUTO | auto need_rl | n_rl_auto=1 n_rl_cmd=0; pend key + 20-bit proof ports |
| EN_DELAYED_UPD | delayed matching rew=-3 | n_upd=1 cmt=1 w0=-5 |
| RELOAD_I_PATH | restore_en=0, pulse reload_i | n_rl_cmd=1 n_rl_auto=0; delayed matching w0=-5 |
| CAP_REFUSE_SECOND | retire without commit, second query | n_cap_ref=1 live acc=0 persist txn unchanged |
| CAP_EVICT_COMMITTED | commit, retire, second query | n_cap_evict=1 persist one new snapshot txn=2 cmt=0 |
| SCHEMA_FOREIGN_NO_RESTORE | poke VER=A5 after commit w0=-5, rst restore | n_schema_rej>=1 live w0=0 acc=0 persist_w0=-5 |
| DIS_RST_STALE | persist_en=0, rst, same numeric key | n_stale++ n_upd=0 w0=0 |
| UNREL_NO_STALE | after restore, `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 tbl=0 |
| AXI_OST_CLEARED | after rst_n | axi_ost=0 |

## Out of scope

Master ASTRA-06 as a whole. Master F3 10pp/CI. LM06. BOARD. ASTRA-13.
Production MIG/DDR. ASTRA-07 index image. QSPI/SD NVM journal.
Host `sess_id` reuse without restore. Multi-slot N>1 index. Full32
DDR identity authority. schemaV2 migration of a DDR store.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
