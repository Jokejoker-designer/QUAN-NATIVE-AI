# PREREG — ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01

Frozen before xvlog. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`). Does not rerun `run_f2r.ps1` / `run_f2r2.ps1` /
`run_f2r3.ps1`.

## Claim this revision may close

F2R_ACCEPTANCE item **5** only: abort / drain / reset on the **actual** fact-AXI
path after AR timeout, R timeout / no-response, SLVERR, missing RLAST, late R
after timeout, and late R crossing a subsequent query. Written contract, not
drop-ARVALID-and-hope.

Smoke: retrieval→proof still works. UNREL no stale proof.

Does **not** close F3 transfer, LM06, SoC/timing, BOARD_PASS, gen/txn wrap
(item 6), or post-timeout **recovery** of remaining facts on the same query.

## One unknown

After AR timeout / SLVERR / missing RLAST / late R after timeout / late R
crossing the next query: does the DUT abort, drain, and reset without a stale
proof or hung ARVALID?

## Law (regression, instantiated not copied)

Same frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5.

## AXI abort / drain / reset contract

AXI4 has no AR cancel. After `ARVALID && ARREADY` the slave owes R beats
through `RLAST`. This DUT never issues a new fact-AR while `axi_ost=1`, never
loads a late/error beat as a proof edge, and never forwards a discarded beat
to the sparse walker.

Constants (`a7ng_astra_f2r4_axi_drain.svh`): `TO_CYC=64`, `DRAIN_TO=64`,
sparse RID=1, fact RID base=2 (rotates 2..15 around abandoned IDs).

| Event | DUT action | status | pending | ARVALID after result |
|-------|------------|--------|---------|----------------------|
| AR handshake | `axi_ost=1`, remember `ost_rid` | — | — | — |
| AR timeout (`ARVALID` held `TO_CYC` without `ARREADY`; handshake wins if same cycle) | drop ARVALID, `n_ar_to++`, abort, **no** further facts | 6 INCOMP | no | 0 |
| R timeout / no-response (`axi_ost`, no completing R for `TO_CYC`) | `n_r_to++`, enter **S_DRAIN**: ARVALID=0, RREADY=1, discard `RID==ost_rid` | 6 INCOMP | no | 0 |
| Drain completes (`RVALID && RID==ost_rid && RLAST`) | `n_drain++`, `axi_ost=0`, HOLD INCOMP | 6 | no | 0 |
| Drain timeout (`DRAIN_TO` without RLAST) | **local abandon**: `dead_mask[ost_rid]=1`, `axi_ost=0`, `n_abandon++`. Not interconnect cancel. Later R with that RID discarded until its RLAST (then bit clears). Next fact-AR uses a free RID in 2..15. | 6 | no | 0 |
| SLVERR/DECERR (`RRESP!=OKAY`, matching ost) | do not load; `n_axi_err++`; if RLAST clear ost else S_DRAIN | 6 | no | 0 |
| NOLAST (expected `arlen=0`, `RVALID && !RLAST`) | do not load; `n_axi_err++`; S_DRAIN until RLAST or drain timeout | 6 | no | 0 |
| Late R after timeout | consumed only in drain/dead intercept; **not** a fact; **not** ANSWER | 6 | no | 0 |
| Late R crossing next query | `dead_mask` intercept: RREADY=1, not given to walker or fact loader | next query independent | no stale | 0 |
| LATE_R 20 cycles (`< TO_CYC`) | still a good beat | 0 ANSWER | yes if legal | 0 |
| AR_STALL (fact `ARREADY` never) | AR timeout path | 6, `n_ar_to>=1` | no | 0 |

Abort **does not** continue remaining facts to manufacture an answer (no
post-timeout recovery). `S_ABORT` zeros ans/proof, `pend_acc=0`, `n_legal=0`.

Hung-ARVALID ban: after `result_v`, top-level `m_axi_arvalid=0` and
`axi_ost=0`.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| SMOKE | `pump requires indirect`, two 2-hops dest 4 | ANSWER npath=2 p0=17 ans=4 tbl=0 |
| LATE_R_OK | fact RVALID after 20 cycles (`<64`) | ANSWER npath>=2 |
| AR_STALL | fact ARREADY never | INCOMP `n_ar_to>=1`, !arvalid, !ost, !pend |
| SLVERR | fact RRESP=SLVERR | INCOMP `n_axi_err>=1` ans=0 !pend |
| NOLAST | fact RLAST=0 then extra RLAST | INCOMP `n_axi_err>=1` `n_drain>=1` ans=0 |
| NORESP | AR accepted, no R | INCOMP `n_r_to>=1` ost=0 (abandon or drain) |
| R_AFTER_TO | good R after 80 cycles (`>64`) | INCOMP **not** ANSWER 4; drain or abandon consumed it |
| CROSS | NORESP query, retire, next smoke, delayed old RID during next query | next query ANSWER 4; `n_drain` increased; no stale |
| SMOKE_AFTER | healthy plant after the negatives | ANSWER 4 |
| UNREL | `payroll tax form` after ANSWER | UNKNOWN npath=0 ans=0 p0=0 |

## Out of scope

F3 multi-seed transfer. LM06. BOARD. Gen/txn wrap. Same-query recovery after
timeout. Sparse-walker timeout (fact path only). Production MIG/DDR.

`load_from_tb_o=0`. Queries are tokens, not poked roles.
