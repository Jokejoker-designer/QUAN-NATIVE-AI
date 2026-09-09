# ASTRA auditor REPORT — 20260906T0635Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F2R4_AXI_DRAIN_INDEPENDENT_AUDIT; f2r_r4_axi_drain=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER + F2R_ACCEPTANCE_20260906 item 5 + work order ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.svh`. TB `tb_astra_f2r4_axi_drain.sv` (bag-local).

Gate under review is **only** F2R_ACCEPTANCE item **5**: written abort/drain/reset on the **actual** fact-AXI path after AR timeout, R timeout / no-response, SLVERR, missing RLAST, late R after timeout, and late R crossing a subsequent query — not drop-ARVALID-and-hope. Smoke retrieval→proof and UNREL no-stale. Keep the in-window LATE_R/stall observation.

Out of this bag’s close: F3 transfer, LM06, SoC/timing, BOARD_PASS, item **6** gen/txn wrap, same-query **post-timeout recovery** of remaining facts, sparse-walker timeout, production MIG/DDR.

Frozen `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r2_hs_law.sv`, and `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` must remain **unpatched**. This DUT is a **new named copy** of the F2R3 FSM plus drain states, not an instantiate-wrapper of F2R3. Live F2R3 still drop-ARVALID-and-continue; that is expected (do not patch frozen RTL) and is **not** this candidate.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T13:24:08.4678233+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T13:24:14.9145395+07:00` (matches raw log exit `Sun Sep 6 13:24:14 2026`).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including the new `a7ng_astra_f2r4_axi_drain.svh`.

Pass-run compiled + transitive includes vs `SHA256_POST.txt`: **13/13 MATCH**.

| Path | SHA256.txt / POST |
|------|-------------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `.../tb_astra_f2r4_axi_drain.sv` | `008f4617ff7f2199b0c25bdc010b5a20dad5ed5ad6eb71f489f175fb3fb0bd6d` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.svh` | `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` |

Overlapping hashes vs F2R3 freeze `ASTRA-F2R-R3-SEMANTIC-GUARD-01/SHA256.txt` and F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, all three shared `.svh`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R4 DUT has `S_DRAIN` / `S_ABORT`, `axi_ost`, `dead_mask`, RID rotate 2..15 (`a7ng_astra_f2r4_axi_drain.sv:87-88`, `:137-154`, `:339-413`).
- Live F2R3 still has **no** `S_DRAIN`; AR/R timeout **continues** `fi++` / `S_EI` after dropping `f_arvalid` (`a7ng_astra_f2r3_sem_guard.sv:75-76`, `:301-304`, `:329-332`). Fixed fact RID `4'd2` (`:122`). **Not patched.**
- Live F2R2 integrator still latches **only** `r_subj`/`r_rel` (`a7ng_astra_f2r2_hs_law.sv:267`). **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`).
- Live TB `$finish` at line **282** — raw log cites that line.
- `.svh` exists at freeze path; `TO_CYC=64`, `DRAIN_TO=64`, `FACT_RID0=2`.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log  98297afcbc9fe33053355b199cb29c3b3e90d66816ba45e7d08e7e63fd607f6b
```

Prior bags **not** overwritten:

- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026` PID **34860** (claimed SHA `806026f2…`).
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026` PID **32496** (claimed SHA `337ca164…`).
- F2R-01 `xsim.log` still session `Sun Sep 6 11:40:10 2026` PID **27464**.

`run_f2r.ps1` / `run_f2r2.ps1` / `run_f2r3.ps1` were not rerun. No `xsim_fail.log` in the R4 bag (fail-archive clause not triggered; first recorded run is the pass run).

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 13:24:12–13:24:14 2026**, PID **47768**, snapshot `f2r4`, `$finish` at **20625 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
SMOKE_TWO_PROOFS st=0 npath=2 ans=4 p0=17 acc=1 abort=0 ost=0 arvalid=0 narto=0 nrto=0 nerr=0 ndrain=0 naban=0 dead=0 tbl=0
PASS SMOKE_TWO_PROOFS
LATE_R_OK st=0 npath=2 ans=4 p0=17 acc=1 abort=0 ost=0 arvalid=0 narto=0 nrto=0 nerr=0 ndrain=0 naban=0 dead=0 tbl=0
PASS LATE_R_OK
AR_STALL st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=1 nrto=0 nerr=0 ndrain=0 naban=0 dead=0 tbl=0
PASS AR_STALL
PASS AR_STALL_NARTO
SLVERR st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=0 nrto=0 nerr=1 ndrain=0 naban=0 dead=0 tbl=0
PASS SLVERR
PASS SLVERR_NERR
NOLAST st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=0 nrto=0 nerr=1 ndrain=1 naban=0 dead=0 tbl=0
PASS NOLAST
PASS NOLAST_NERR
PASS NOLAST_NDRAIN
NORESP st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=0 nrto=1 nerr=0 ndrain=0 naban=1 dead=4 tbl=0
PASS NORESP
PASS NORESP_NRTO
PASS NORESP_ABANDON
R_AFTER_TO st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=0 nrto=1 nerr=0 ndrain=1 naban=0 dead=0 tbl=0
PASS R_AFTER_TO
PASS R_AFTER_TO_NOT_ANS4
PASS R_AFTER_TO_DRAIN
CROSS_SETUP st=6 npath=0 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0 narto=0 nrto=1 nerr=0 ndrain=0 naban=1 dead=4 tbl=0
PASS CROSS_SETUP
CROSS_NEXT_SMOKE st=0 npath=2 ans=4 p0=17 acc=1 abort=0 ost=0 arvalid=0 narto=0 nrto=1 nerr=0 ndrain=1 naban=1 dead=0 tbl=0
PASS CROSS_NEXT_SMOKE
PASS CROSS_DRAINED_OLD
SMOKE_AFTER st=0 npath=2 ans=4 p0=17 acc=1 abort=0 ost=0 arvalid=0 narto=0 nrto=0 nerr=0 ndrain=0 naban=0 dead=0 tbl=0
PASS SMOKE_AFTER
UNREL st=1 npath=0 ans=0 p0=0 acc=0 abort=0 ost=0 arvalid=0 narto=0 nrto=0 nerr=0 ndrain=0 naban=0 dead=0 tbl=0
PASS UNREL_NO_STALE
ASTRA_F2R4_AXI_DRAIN_XSIM_PASS
$finish called at time : 20625 ns : File ".../tb_astra_f2r4_axi_drain.sv" Line 282
```

Marker **present**. Zero `FAIL` lines. `tbl=0` on every dump. After every abort dump: `st=6 ans=0 p0=0 acc=0 abort=1 ost=0 arvalid=0`.

`xvlog.log` / `xvlog_dut.log` analyzed `a7ng_astra_f2r4_axi_drain` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB. `xelab.log` built snapshot `f2r4`. Work library has `a7ng_astra_f2r4_axi_drain.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. F2R3 integrator and floor-shift SGD were **not** compiled into this run.

### Hunt 1 — written abort/drain/reset contract vs only dropping ARVALID

PREREG table is the written contract: AXI4 has no AR cancel; after AR handshake the slave owes R..RLAST; DUT never issues a new fact-AR while `axi_ost=1`; never loads a late/error beat as a proof edge; never forwards a discarded beat to the walker; abort does **not** continue remaining facts.

Live R4 vs live F2R3 (unpatched) on the same timeout events:

| Event | Frozen F2R3 (still live) | R4 DUT |
|-------|--------------------------|--------|
| AR timeout, no handshake | drop `f_arvalid`, **continue** next fact / `S_EI` (`f2r3:301-304`) | drop `f_arvalid`, `narto++`, `S_ABORT` (`f2r4:347-350`) |
| R timeout after handshake | `nfto++`, **continue** next AR (`f2r3:329-332`); no ost/drain | `nfto++`, `S_DRAIN` then `S_ABORT` (`f2r4:387-390`, `:392-403`) |
| Fact RID | hardwired `4'd2` (`f2r3:122`) | `ost_rid` + rotate 2..15 around `dead_mask` |
| Error beat | `nferr++`, still `fi++` (`f2r3:323-328`) | do not load; SLVERR+RLAST → `S_ABORT`; NOLAST/wrong RID → `S_DRAIN` |

R4 mux/drain (not comments):

```137:154:rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv
  assign fetch_mode = (st==S_AR)||(st==S_R)||(st==S_DRAIN);
  assign kill_r = m_axi_rvalid && dead_mask[m_axi_rid];
  assign fact_take = (st==S_R)||(st==S_DRAIN);
  ...
  assign f_arready = (st==S_AR) ? m_axi_arready : 1'b0;
  ...
  assign sp_rvalid = (!fetch_mode && !kill_r) ? m_axi_rvalid : 1'b0;
  assign f_rvalid = (st==S_R && !kill_r) ? m_axi_rvalid : 1'b0;
  assign m_axi_rready = (fact_take || kill_r) ? 1'b1 : (fetch_mode ? 1'b0 : sp_rready);
```

```387:413:rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv
          end else if (tocnt >= TO_CYC[15:0]) begin
            nfto <= nfto + 16'd1; r_axi <= 1'b1; axi_abort <= 1'b1;
            tocnt <= '0; st <= S_DRAIN;
          end
        end
        S_DRAIN: begin
          f_arvalid <= 1'b0;
          ...
          if (m_axi_rvalid && (m_axi_rid==ost_rid)) begin
            ndrain <= ndrain + 16'd1;
            if (m_axi_rlast) begin
              axi_ost <= 1'b0; tocnt <= '0; st <= S_ABORT;
            end
          end else if (tocnt >= DRAIN_TO[15:0]) begin
            dead_mask[ost_rid] <= 1'b1;
            axi_ost <= 1'b0; naban <= naban + 16'd1; tocnt <= '0; st <= S_ABORT;
          end
        end
        S_ABORT: begin
          f_arvalid <= 1'b0;
          r_st <= ST_INCOMP;
          best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
          pend_acc <= 1'b0; pend_cmt <= 1'b0;
          np <= '0; n_legal <= '0;
          axi_abort <= 1'b1;
          st <= S_HOLD;
        end
```

S_DRAIN never writes `fs[]`/`fo[]`. S_R load path requires `rresp==OKAY`, `RLAST`, matching `ost_rid`, and `!axi_abort` (`:357-378`). AR-timeout drop-ARVALID remains **only** for the no-handshake case, which is the documented contract (nothing to drain).

**Finding:** item 5 is not “labels + drop ARVALID”. Drain/abort/dead-mask/reset-of-proof are live FSM paths.

### Hunt 2 — tests actually invoked (quote raw log, not RESULTS.md)

TB `inj` map (`tb_astra_f2r4_axi_drain.sv:62`, `:74-88`, `:222-278`): `0` healthy, `1` SLVERR, `2` NOLAST, `3` no R (NORESP/CROSS setup), `4` fact ARREADY never, `5` R after 20, `6` R after 80.

| Required case | TB | Raw log (authority) |
|---------------|----|---------------------|
| LATE_R 20 < TO_CYC64 (keep stall result) | `inj=5` | `LATE_R_OK st=0 npath=2 ans=4 ... nrto=0 ndrain=0` **PASS** |
| Stall (fact ARREADY never) | `inj=4` | `AR_STALL st=6 ... abort=1 ost=0 arvalid=0 narto=1` **PASS** |
| SLVERR | `inj=1` (RRESP=2'b10, good `rdata` still planted) | `SLVERR st=6 ans=0 nerr=1 abort=1 ndrain=0` **PASS** |
| NOLAST | `inj=2` then extra RLAST | `NOLAST st=6 ans=0 nerr=1 ndrain=1` **PASS** |
| no-response | `inj=3` | `NORESP st=6 nrto=1 naban=1 dead=4 ost=0` **PASS** (`dead=4` = RID 2) |
| late R after timeout (80 > 64) | `inj=6` | `R_AFTER_TO st=6 ans=0 nrto=1 ndrain=1 naban=0` **PASS R_AFTER_TO_NOT_ANS4** |
| late R crossing next query | CROSS_SETUP `inj=3` then `inj=0` + delayed old RID | `CROSS_NEXT_SMOKE st=0 npath=2 ans=4 ... ndrain=1 naban=1 dead=0` **PASS CROSS_DRAINED_OLD** |
| smoke retrieval→proof | `inj=0` plant2 + tokens | `SMOKE_TWO_PROOFS` / `SMOKE_AFTER` `st=0 npath=2 ans=4 p0=17 tbl=0` |
| UNREL no stale | `payroll tax form` after ANSWER | `UNREL st=1 npath=0 ans=0 p0=0` **PASS** |

All item-5 names that were **missing** in F2R-01 (SLVERR/NOLAST/no-response/post-timeout/cross) are **invoked** in this sequence. LATE_R_OK remains the in-window 20-cycle case; R_AFTER_TO is the after-timeout case.

### Hunt 3 — stale proof after abort? UNREL? CROSS still valid?

Abort dumps: `ans=0 p0=0 acc=0` and TB `chk_abort` also requires `st===INCOMP && !arvalid && !axi_ost && axi_abort` (`tb:189-194`).

UNREL after a healthy ANSWER 4: `st=1 npath=0 ans=0 p0=0 acc=0 abort=0`. No leftover proof.

CROSS: first query abandoned (`dead=4`, `naban=1`, `ans=0`). Next query **without** `hard_rst` of DUT counters: `ans=4 p0=17 npath=2`, `ndrain` 0→1, `dead` 4→0. Old RID was consumed (`kill_r` / drain counter), not used as the next proof. Next query is independently valid.

### Hunt 4 — overclaim of “post-timeout recovery”

ACK/PREREG/RESULTS/CLOSEOUT/metrics all list `post_timeout_recovery` **OPEN**. R_AFTER_TO is `ans=0` **not** ANSWER 4, with `abort=1`. S_ABORT zeros `n_legal`/`np`/`best_*`/`pend_acc` and goes HOLD INCOMP; it does not walk remaining `fi` (contrast F2R3 `fi++`).

No claim that remaining facts on the **same** query are recovered. Do not promote that sentence later.

### Hunt 5 — cheat (load_from_tb, golden edits, RESULTS vs log, hash after scores)

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 20625 ns, all PASS tags, smoke/LATE_R/AR_STALL/SLVERR/NOLAST/NORESP/R_AFTER_TO/CROSS/UNREL strings match the dump fields RESULTS summarized. RESULTS is **not** used as evidence. |
| Editing goldens to PASS | **Not found.** No fail-r0 / `xsim_fail.log`. No old-bag expected-value edit. TB checks DUT `status/ans/npath/abort/ost/arvalid/narto/nrto/nerr/ndrain/naban/dead`. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0` (`f2r4:136`). Every dump `tbl=0`. `poke_v_i=1'b0` (`:253`). Queries are `send_text` tokens. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). |
| Hash theatre / hash after scores | Freeze **13:24:08** is before xsim **13:24:12–14**. POST **13:24:14** matches compiled bytes. `.svh` in PRE. TB hash PRE=POST `008f4617…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| F3 / 5 seeds / BOARD_PASS / LM06 | **Not claimed closed.** ACK `does_not_close` includes F3, LM06, BOARD_PASS, item6, post_timeout_recovery. |
| F2R2 / F2R3 / F2R-01 wipe | **Not found.** Prior `xsim.log` session headers unchanged. Frozen DUT hashes unchanged vs those bags. R4 work dir has no F2R3/F2R2 integrator `.sdb`. |
| ID one-hot as transfer | **Not claimed.** Smoke IDs 17/34/18/35 and ans=4 are the planted 2-hop graph, not a transfer/F3 claim. |
| Implementer `PASS (this gate only)` | Scoped. Not OVERCLAIM if auditor grade stays **narrow**. |

### Hunt 6 — .svh in SHA freeze before xvlog?

**Yes.** `run_xsim.ps1:37-57` writes SHA including four includes, then xvlog. PRE `TRANSITIVE_INCLUDES` has crc / role lexicon / lexicon / **`a7ng_astra_f2r4_axi_drain.svh`**. This closes the F2R-01 residual (“included .svh dependencies are not all covered”) **for this bag**.

### Hunt 7 — F3 / LM06 / BOARD claimed closed?

**No.** CLOSEOUT: `F3 / LM06 / BOARD_PASS / item6 / post_timeout_recovery = OPEN`. No bitstream, no WNS, no JTAG, `PROGRAM=false`. Do not treat this plumbing bag as those gates.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated gate. Two TB checks are **weaker than the dump** and must not be mistaken for extra proof:

1. `R_AFTER_TO_DRAIN` is `(ndrain>=1) || (naban>=1) || (nrto>=1)` (`tb:257`). `nrto` alone would pass the chk. The **dump** is the evidence: `ndrain=1 nrto=1 naban=0` — drain actually happened.
2. `NORESP_ABANDON` is `(naban>=1) || (ndrain>=1)` (`tb:250`). Dump: `naban=1 ndrain=0 dead=4` — abandon actually happened.

CROSS is not tautological on `ans=4` alone (same plant would answer 4 if the stale beat were wrongly taken as a new fact). Discriminator is `ndrain` 0→1 with `dead` 4→0 on the same DUT instance (`nrto=1 naban=1` persist; no `hard_rst` between CROSS_SETUP and CROSS_NEXT_SMOKE).

ISO `viso=0` is an isolated `go_upd` without score; `w0=5` is the law check. DUT smoke does not re-run HS_ALL32; work order did not require it.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify item 5 on this bag’s tests.

Residuals (not P1 for this gate):

1. **CROSS late-R timing is token/IDLE-window, not overlapping next `axi_ost` — 7/10 as coverage narrowness, 2/10 as item-5 fail.** `cross_dly<=40` (`tb:68`) vs `send_text("pump requires indirect")` ≈22 chars × ≥2 clocks before `fire`. Late RID-2 beat is consumed by `kill_r` while the next query is still ingesting tokens (`S_IDLE`/`S_WALK`), **before** the next fact AR. That still proves dead-RID intercept + next query ANSWER. It does **not** prove a late beat arriving while the next query has `ost_rid` equal to the abandoned RID after `dead_mask` has already cleared on RLAST.

2. **All negatives fire on the first fact AR — 6/10 coverage.** `inj` applies to `araddr>=FACT_BASE` (`tb:74-88`). Mid-list timeout after `nf>0` is untested. S_ABORT skips `S_EI` so already-loaded `fs[]` are not scored (`:405-413`); RTL looks correct, TB does not show it.

3. **Weak OR on drain/abandon chks — 5/10 TB, 0/10 DUT.** See tautology section. Raw dumps still discriminate.

4. **`S_ABORT` does not itself clear `axi_ost` — 4/10 hygiene.** Tested abort paths clear ost in S_R/S_DRAIN before HOLD (`chk_abort` saw `ost=0`). S_IDLE also zeros ost (`:315`).

5. **Local RID abandon is not interconnect cancel — 3/10 as overclaim if renamed later.** PREREG states this. `dead_mask` + RID rotate is a master-side leak shield, not AXI AR KILL. Production MIG/DDR out of scope.

6. **`S_R` still increments `tocnt` on `kill_r` cycles — 3/10.** A storm of dead-RID beats could theoretically trip the live ost timeout (`:352-354`). Not in this TB.

7. **Copied F2R3 semantic FSM not re-audited here — 3/10 as residual, 0/10 as item 5.** Smoke+UNREL only. Item 4 remains closed on the **F2R3 bag**, not re-proven on this fork.

8. **Item 6 wrap/reset replay — 8/10 as lifetime, 0/10 as this gate.** Same 8-bit `txn`/`gen` (`:517-518`). PREREG leaves wrap OPEN.

9. **Live F2R3 still drop-and-continue — 0/10 as this bag, 9/10 if someone promotes F2R3.** Additive candidate is F2R4 only.

No remaining **demonstrated** P1 that falsifies item 5.

---

## F2R_ACCEPTANCE item 5 vs this bag (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| **5** AXI abort/drain/reset | **CLOSED (narrow)** | Written contract in PREREG + `.svh`. Live `S_DRAIN`/`S_ABORT`/`dead_mask`/`axi_ost` on the fact-AXI mux. Raw log invokes LATE_R_OK, AR_STALL, SLVERR, NOLAST, NORESP, R_AFTER_TO (80>64, **not** ANSWER 4), CROSS (next query ANSWER 4 + `ndrain` 0→1), smoke, UNREL. Hung ARVALID not observed (`arvalid=0` after every result). |
| **1,2,3,4** | **not re-opened** | Frozen F2R2/F2R3 unpatched. ISO +5 only on isolated SGD; semantic suite not rerun on this fork. Prior auditor grades stand on those bags. |
| **6** pending identity | **PARTIAL (unchanged)** | Not this bag. |
| F3 / LM06 / BOARD | **OPEN** | Not claimed. |

Narrow = bag-local TB slave `inj` modes + XSim TB-planted AXI corpus + fact-path only + CROSS intercept likely in IDLE/token window. Not production interconnect cancel, not sparse-walker timeout, not same-query recovery, not F3, not LM06, not BOARD.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…` matches F2R3 compiled DUT. Live timeout still continues `fi++`. Not in R4 snapshot. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. Still subj/rel latch. Not in R4 snapshot. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-01 / F2R-R2 / F2R-R3 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01`

Narrow = F2R_ACCEPTANCE item 5 as shown in raw XSim on the new named DUT: abort/drain/reset/dead-mask on the fact AXI path, with the required negative tests actually fired. Not F3, not LM06, not timing, not BOARD_PASS, not wrap-lifetime, not post-timeout recovery, not a patch of live F2R3.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this item-5 bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (CROSS overlapping-ost window, mid-list abort TB, stronger drain assertions, F2R3 still drop-and-continue until a later integrate, item 6 wrap) are **not** P1 for this gate.

Parent: treat item **5** as CLOSED narrow on **F2R4 only**. Do not reopen F2R2 handshake or F2R3 semantic-guard bags. Do not treat this as F3/LM06/BOARD. Preserve F2R-01, F2R-R2, F2R-R3, and this bag. Do not rerun `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, or this bag’s `run_xsim.ps1` in a way that wipes `xsim.log`. Next residual remains item **6** (gen/txn wrap / outstanding lifetime) or the Master F3/LM06/BOARD queue — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of F3 / LM06 / BOARD / COM12 / item 6 / post-timeout recovery / live F2R3 transport remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0635Z\REPORT.md  ACCEPT_PARTIAL
