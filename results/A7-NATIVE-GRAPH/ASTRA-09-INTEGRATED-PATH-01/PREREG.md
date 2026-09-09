# PREREG — ASTRA-09-INTEGRATED-PATH-01

Frozen before xvlog. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream.
Does not edit F2R-* / F3-* / ASTRA-06-* bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`, ASTRA-06 persist/R2/R3/R4 DUTs).
Does not rerun those bags' `run_*.ps1`. Does not open LM06 / BOARD / DDR /
Master F3.

## Claim this revision may close

One named FPGA path (this bag only): QSE + sparse retrieve + 2-hop enum +
symmetric SGD rank + pending `{sess,gen,txn,phi}` + handshake latch, plus
one semantic refuse and one AXI abort/drain smoke.

Does **not** close Master F3 10 packed pages, persist DDR, LM06, BOARD,
ASTRA-13, schemaV2 DDR store, NVM journal, or Master ASTRA-06.

## One unknown

Can a single FPGA path run retrieval→proof→rank→pending→reward **and**
refuse a conflict/wrong-object **and** abort/drain one AXI fault — without
`load_from_tb` and without claiming BOARD/LM06?

## Law (instantiated, not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. ISO +3, x0=50 → dw0=+5
(not floor-shift +4). Smoke path phi0=50, reward=-3, w=0 → dw0=-5.

## Path contract

Queries are token strings. `load_from_tb_o=0`. Walker fetches 20-bit fact
IDs over AXI. Proof legality is independent of score. Rank features are
path confidence / transitivity / polarity / hop-count (not query/answer
IDs, proof index, class-byte, or gold).

Pending snapshot at PICK: `{epoch=sess_id_i, gen, txn, sel, p0, p1, ans, phi[0:31]}`.
Reward bus `{rew_v, rew[-3,+3], rew_txn, rew_gen, rew_epoch}`. One-cycle
valid then bus invert must still commit (handshake latch). Duplicate /
wrong txn / stale gen / OOR do not extra-update.

Semantic: two legal 2-hops to **different** conclusions → `ST_CONFLICT=5`,
`ans=0`, `pend_acc=0`, no SGD update. Wrong object (`pump requires
indirect valve`) → `ST_UNKNOWN`, `npath=0`, `ans=0`.

AXI: SLVERR on first fact R → abort/drain, `ST_INCOMP=6`, `ans=0`, `p0=0`,
`pend_acc=0`, no hung ARVALID. No same-query post-timeout recovery claimed.

UNREL (`payroll tax form`) after ANSWER: `ST_UNKNOWN`, `npath=0`, `ans=0`,
`p0=0`.

## Tests

| Tag | Setup | Expect |
|-----|-------|--------|
| ISO_P3_X50_DW5 | isolated SGD +3 x0=50 | dw0=+5 |
| SMOKE_TWO_PROOFS | `pump requires indirect` | ANSWER npath=2 p0=17 ans=4 tbl=0 acc=1 |
| HS_LATCH_NUPD | one-cycle rew=-3 then bus invert | n_upd=1 cmt=1 w0=-5 |
| CONFLICT_DEST | two 2-hops dest 4 vs 7 | st=5 ans=0 p0=0 acc=0 npath>=2 |
| CONFLICT_NO_UPD | reward on conflict | n_upd=0 weights unchanged |
| WRONG_OBJ | `pump requires indirect valve` | st=1 npath=0 ans=0 obj=11 |
| SLVERR | fact RRESP=SLVERR | st=6 abort ans=0 p0=0 nerr>=1 ost=0 arvalid=0 |
| UNREL_NO_STALE | ANSWER then `payroll tax form` | UNKNOWN npath=0 ans=0 p0=0 |

## Out of scope

Master F3 10pp/CI. LM06. BOARD. DDR/MIG persist. NVM. ASTRA-13.
Same-query AXI recovery. Interconnect cancel. Power-loss journal.
`load_from_tb` retrieval.
