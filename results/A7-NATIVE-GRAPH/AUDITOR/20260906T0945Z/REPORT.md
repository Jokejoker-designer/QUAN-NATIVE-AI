# ASTRA auditor REPORT — 20260906T0945Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA06_WARM_PERSIST_INDEPENDENT_AUDIT; astra06=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-06 + work order ASTRA-06-WARM-PERSIST-01 + F2R5 auditor 20260906T0705Z (power-loss journal OPEN; host sess_id reuse OPEN)
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4/F2R5/F3*/this bag `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4/F2R5/F3/F3R2/F3R3/F3R4 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-06-WARM-PERSIST-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_06_warm_persist.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_06_warm_persist.svh`. TB `tb_astra_06_warm_persist.sv` (bag-local).

Gate under review is the **F2R5 remainder** named in auditor `20260906T0705Z` and this work order: after a **modeled** power-loss (`rst_n` clears live FSM / AXI ost / in-flight SGD but **not** a persist store), do SGD weights and pending `{sess,gen,txn,phi,v_pred}` restore so a delayed matching reward still updates the **same** snapshot — and a pre-loss key without restore is `n_stale`?

Judged against:

1. Work order `ASTRA-06-WARM-PERSIST-01` required tests + written persist contract + frozen SGD ISO +5 + 20-bit eids if pending stores identities.
2. **Master ASTRA-06** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7 table + §5 Transaction and storage): pending/commit, **full-ID schema**, **migration**, **capacity/eviction**, and **warm persistence on chosen state architecture**. Master text: *“DDR retention across BRAM loss is warm persistence; power-loss durability requires separately tested nonvolatile checkpoint/journal.”* DESIGN_CANDIDATE §8.1: QSPI/SD A-B checkpoints with CRC/generation for board power-loss; DDR flush/reload + BRAM kill is the warm-persist experiment.

**Master ASTRA-06 as a whole is not this bag’s close**, even if compact XSim tags all PASS and the DUT is named `a7ng_astra_06_warm_persist`.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, Master F3 10pp/CI, MIG/DDR production persistence, ASTRA-07 index image, QSPI/SD NVM journal, host `sess_id` reuse after `rst_n` **without** restore, schemaV2 DDR store, capacity/eviction of a multi-entry pending/index, BRAM-kill-with-DDR-retained warm persist.

Frozen `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv` must remain **unpatched**. This DUT is a **new named** copy of the F2R5 integrator plus a no-reset persist register file.

Prior bags F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 / F3 / F3R2 / F3R3 / F3R4 are **not** this evidence and must not have been rewritten.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T16:12:08.5517066+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T16:12:14.2105127+07:00` (matches raw log exit `Sun Sep 6 16:12:14 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog (`run_xsim.ps1:37-69`). `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_06_warm_persist.svh`.

Pass-run compiled + transitive includes vs `SHA256_POST.txt`: **13/13 MATCH** (opened manifests; not re-hashed).

| Path | SHA256.txt / POST |
|------|-------------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_06_warm_persist.sv` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` |
| `.../tb_astra_06_warm_persist.sv` | `ddf301185f11d07128ed1c29d325acb098ab759312bdfb331d3fc1a35ef6123e` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_06_warm_persist.svh` | `cad5e606fe1cd9c1b378931714581a6ad5ed9d7fcce8b2643059d4d42fb7db21` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `c7c778979f064fdd8d0688317d93b7138cd43b6c11462e6c6f472a9d3e36b90a` |
| `ACK.json` | `060b75cccfd11027ace3bfa279ac621aa4b33645689c3de5391f1bbb8753119b` |
| `run_xsim.ps1` | `63eb69a498e400281ae68b52ea2360cf262ac7815bad4763b2cb9db509f0b160` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt | vs prior bag freeze |
|------|------------|---------------------|
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | `d12144a99…` / `9f0e5dbd7…` | F3R4 compiled DUT / include **identical** |
| `a7ng_astra_f3r3_sampled_worlds.sv` / `.svh` | `beaa4bc10…` / `7a692ab95…` | listed |
| `a7ng_astra_f3r2_ind_worlds.sv` / `.svh` | `16519bf03…` / `c53ea8217…` | listed |
| `a7ng_astra_f3_shared_xfer.sv` / `.svh` | `c3183e7a6…` / `0ffbe9507…` | listed |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | `41c77e76f…` / `1db76fcc0…` | F2R5 compiled DUT / include **identical** |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | `5cdb3da8c…` / `94887bd45…` | F2R4 compiled DUT **identical** |
| `a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b…` | F2R3 **identical** |
| `a7ng_astra_f2r2_hs_law.sv` | `5e2f23c31…` | F2R2 **identical** |
| `a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b5…` | floor-shift file, not compiled |

Overlapping compiled hashes vs F2R5 freeze and F3R4 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, shared crc/lexicon `.svh` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live A06 DUT has `persist_en_i` / `restore_en_i` / `persist_clr_i` / `reload_i`, persist outputs, `S_RELOAD`, and a **separate** `always_ff @(posedge clk)` persist domain (`a7ng_astra_06_warm_persist.sv:21-24`, `:92-104`, `:112`, `:344-378`, `:697-712`).
- Live F2R5 still has **no** `persist_en_i`; still `{sess_id,gen,txn}` wrap/refuse (`a7ng_astra_f2r5_txn_wrap.sv:20-32`, `:529-545`). **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` only, no `sess_id_i` (`a7ng_astra_f2r2_hs_law.sv:15-26`). **Not patched.**
- Live F3R4 still has no persist ports (`a7ng_astra_f3r4_distinct_hold_phi.sv:18-30`). **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`). Instantiated read-only (`a06:337-342`, `freeze_i=1'b0`).
- Live TB `$finish` at line **309** — raw pass log cites that line.
- `.svh` exists at freeze path; `A7NG_A06_TXN_MAX=255`, `A7NG_A06_EPOCH_INV=0`.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           5f739df0778415567a16c80fdb7ccea6fca503600869cfc442fa5dafb7198804
```

Prior bags **not** overwritten (session headers still the F2R5/F3R4 auditor-cited runs):

| Bag | xsim session | PID |
|-----|--------------|-----|
| F2R-01 | Sun Sep 6 11:40:10 2026 | 27464 |
| F2R-R2 | Sun Sep 6 12:15:23 2026 | 32496 |
| F2R-R3 | Sun Sep 6 12:57:56 2026 | 34860 |
| F2R-R4 | Sun Sep 6 13:24:12 2026 | 47768 |
| F2R-R5 | Sun Sep 6 13:53:26 2026 | 5776 (claimed SHA `a93aaedc…`) |
| F3 | Sun Sep 6 14:19:48 2026 | 28280 |
| F3R2 | Sun Sep 6 14:51:59 2026 | 47144 |
| F3R3 | Sun Sep 6 15:22:22 2026 | 27400 |
| F3R4 | Sun Sep 6 15:48:29 2026 | 20428 (claimed SHA `27d60953…`) |

Those bags’ `run_*.ps1` were not rerun.

Fail-r0: **none** in this bag. First xvlog/xelab/xsim PASS. No `xsim_fail_r0.log` / `FAIL_R0.md`. Not a golden-edit hunt (nothing to compare); not a fail.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 16:12:12–16:12:14 2026**, PID **33088**, snapshot `a06wp`, `$finish` at **24055 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
SMOKE_TWO_PROOFS st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 vpred=0 ost=0 tbl=0 pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=4 pp0=17 pphi0=50
PASS SMOKE_TWO_PROOFS
PASS PEND_EID20
PASS PERSIST_SNAP
EN_RST_LIVE st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 vpred=0 ost=0 tbl=0 pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=4 pp0=17 pphi0=50
PASS EN_RST_LIVE_CLEAR
PASS AXI_OST_CLEARED
EN_RELOAD st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 vpred=0 ost=0 tbl=0 pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=4 pp0=17 pphi0=50
PASS EN_RELOAD_KEY
EN_DELAYED_UPD st=1 npath=0 ans=0 p0=0 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=0 nbad=0 w0=-5 phi0=50 vpred=0 ost=0 tbl=0 pval=1 pacc=1 pcmt=1 pep=7 ptxn=1 pgen=1 pw0=-5 pans=4 pp0=17 pphi0=50
PASS EN_DELAYED_UPD
DIS_PRE st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 ... tbl=0 pval=0 pacc=0 pcmt=0 pep=0 ptxn=0 pgen=0 pw0=0 pans=0 pp0=0 pphi0=0
PASS DIS_NO_SNAP
DIS_RST st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 ... pval=0 ...
DIS_STALE st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=1 nbad=0 w0=0 ... pval=0
PASS DIS_RST_STALE
NO_RESTORE st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 ... pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=4 pp0=17 pphi0=50
PASS NO_RESTORE_KEEP
NO_RESTORE_STALE st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=1 nbad=0 w0=0 ... pval=1 pacc=1 pcmt=0 pep=7
PASS NO_RESTORE_STALE
PASS RST_UPD_IN_FLIGHT
MID_UPD st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=-5 phi0=50 ... pval=1 pacc=1 pcmt=0 pep=7 pw0=0 pans=4 pp0=17
PASS NO_HALF_COMMIT
RST_UPD_ABORT st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ... pval=1 pacc=1 pcmt=0 pep=7 pw0=0
PASS NO_HALF_AFTER_RST
RST_UPD_RELOAD st=1 npath=0 ans=0 p0=0 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=0 nbad=0 w0=-5 phi0=50 ... pval=1 pacc=1 pcmt=1 pw0=-5
PASS RST_UPD_RELOAD_OK
HS_PRE ... w0=0 ... pcmt=0 pw0=0
HS_UPD st=0 npath=2 ans=4 p0=17 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=0 nbad=0 w0=-5 ... pcmt=1 pw0=-5
PASS HS_LATCH_NUPD
UNREL_PRE st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 ... tbl=0 pval=1 ... pans=4 pp0=17
UNREL st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ... tbl=0 pval=1 pans=4 pp0=17
PASS UNREL_NO_STALE
ASTRA_06_WARM_PERSIST_XSIM_PASS
$finish called at time : 24055 ns : File ".../tb_astra_06_warm_persist.sv" Line 309
```

Marker **present**. Zero `FAIL` lines (grep). `tbl=0` on every dump.

`xvlog.log` analyzed `a7ng_astra_06_warm_persist` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB. `xelab.log` built snapshot `a06wp`. Work library has `a7ng_astra_06_warm_persist.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f2r5_txn_wrap.sdb` / F2R4 / F2R3 / F2R2 / F3* integrator `.sdb` in this snapshot. Frozen integrators and floor-shift SGD were **not** compiled into this run.

---

## Hunt 1 — written persist contract vs live RTL: non-reset flop vs `rst_n` zeros

PREREG two domains: live FSM / AXI ost / in-flight SGD on async `rst_n`; persist journal on `persist_clr_i` only. Modeled power-loss = `rst_n` low, `persist_clr_i` held 0. On-chip registers, not DDR/MIG/QSPI.

Live RTL is two `always_ff` blocks, not comments.

**Persist (no `rst_n` in sensitivity; wipe is `persist_clr_i`):**

```344:378:rtl/native_graph/integrate/a7ng_astra_06_warm_persist.sv
  always_ff @(posedge clk) begin
    if (persist_clr_i) begin
      p_valid <= 1'b0; p_acc <= 1'b0; p_cmt <= 1'b0;
      p_epoch <= A7NG_A06_EPOCH_INV; p_sess_epoch <= A7NG_A06_EPOCH_INV;
      ...
        p_w[pk] <= 16'sd0;
        p_phi[pk] <= 8'sd0;
    end else if (persist_en_i) begin
      if (pick_ok) begin
        p_valid <= 1'b1;
        p_acc <= 1'b1;
        p_cmt <= 1'b0;
        p_epoch <= sess_id_i;
        ...
        p_ans <= c_best_a;
        p_p0 <= c_best_p0;
        p_p1 <= c_best_p1;
        for (pk = 0; pk < 32; pk = pk + 1) p_phi[pk] <= phis[c_best_idx][pk];
      end
      if ((st == S_UW) && sgd_done) begin
        p_cmt <= 1'b1;
        for (pk = 0; pk < 32; pk = pk + 1) p_w[pk] <= w_o[pk];
      end
    end
  end
```

What **has a non-reset flop**: `p_valid`, `p_acc`, `p_cmt`, `p_epoch`, `p_sess_epoch`, `p_gen`, `p_txn`, `p_sel`, `p_vpred`, `p_ans`, `p_p0`, `p_p1`, `p_w[0:31]`, `p_phi[0:31]`.

What **`rst_n` zeros** (async live block `:380-401`): `st`, AXI `axi_ost`/`dead_mask`/`ost_rid`/`f_arvalid`, identity counters `nupd`/`nstale`/`nbad`/…, live pending `pend_acc`/`pend_cmt`/`pend_epoch`/`sess_epoch`/`txn`/`gen`, HOLD `best_a`/`best_p0`/`v_pred`, `pend_phi`, `need_rl<=1`. Frozen SGD shares `rst_n` and zeros all `w[k]` (`sgd:85-90`).

Reload (`S_RELOAD` `:697-712`) walks `rl_idx` 0..31 into SGD `load_*` from `p_w`, then copies `{p_epoch,p_gen,p_txn,p_sess_epoch,p_acc,p_cmt,p_sel,p_vpred,p_phi}` into live pending. It does **not** copy `p_ans`/`p_p0`/`p_p1` onto live HOLD ports (HOLD result is contracted as not surviving).

Grep of the DUT: **no** `CRC`, `journal` FSM, `evict`, `migrat`, `DDR`, `MIG`, `QSPI`, `persist_mem`, `schema`. `localparam VER=4'd1` (`:106`) is **unused**. This is a 1-cycle snapshot (PICK pending; SGD-`done` weights), not a 2-cycle CRC A-B NVM journal and not a 32-entry persist_mem.

TB: `wipe_rst` asserts `persist_clr`+`rst_n` (isolation); `power_loss` asserts `rst_n` only (`tb:158-170`). Matches the written contract.

**Finding:** live RTL matches the written two-domain contract for the signals named in PREREG. Not DDR. Not NVM.

Residual (not a contract lie): several **live** working arrays (`fs`/`fo`/`cbuf`/`phis`/`pans`, …) are assigned only in the `else` of the async-rst block and are **not** listed in the `if (!rst_n)` assignments. They can hold bits across `rst_n` as no-reset flops. Fail-closed in this TB because `nf`/`np`/`n_legal` **are** reset and `S_IDLE` clears `fv[]`. UNREL after restore is UNKNOWN with `npath=0`. Not a demonstrated stale-proof path.

---

## Hunt 2 — persist enable → rst → reload → delayed matching reward still dw as oracle?

TB (`tb:226-247`): `persist_en=1`, `restore_en=1`, smoke, `power_loss` (auto-reload), delayed `pulse_rew_id(-3, sav_ep, sav_txn, sav_gen)`.

Raw log:

```text
ISO_P3 w0=5 viso=0
SMOKE_TWO_PROOFS ... acc=1 txn=1 gen=1 ep=7 w0=0 phi0=50 pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=4 pp0=17 pphi0=50
EN_RST_LIVE ... nupd=0 w0=0 ost=0 acc=1 phi0=50 pval=1 pw0=0
EN_RELOAD ... acc=1 cmt=0 txn=1 gen=1 ep=7 phi0=50 pw0=0
EN_DELAYED_UPD ... nupd=1 cmt=1 w0=-5 phi0=50 pval=1 pcmt=1 pw0=-5
PASS EN_DELAYED_UPD
```

Oracle: isolated SGD `+3, x0=50 → dw0=+5` (symmetric, not floor +4). Smoke path `phi0=50`, `w=0`, reward `-3` → `dw0=-5`. After restore, live `w0` was 0 (SGD rst) and `phi0=50` (journal). Delayed matching `{7,1,1}` produces `w0=-5`. If `pend_phi` had not reloaded, `x[0]=0` ⇒ `dw=0` ⇒ `w0=0`. Observed `-5` therefore requires the restored snapshot, not an empty phi.

HOLD `ans` after reload is 0 (`EN_RELOAD st=1 npath=0 ans=0`) — query result did not survive; reward uses restored phi/key, not HOLD ports. That matches PREREG “HOLD result does not survive”.

**Finding:** work-order unknown is shown in the raw log. Quote: `EN_DELAYED_UPD ... w0=-5`.

---

## Hunt 3 — persist disable / no-restore → same numeric key `n_stale`?

**Disable** (`persist_en=0`, `wipe_rst` so journal empty, smoke, `power_loss`):

```text
DIS_PRE ... pval=0 ... pep=0
PASS DIS_NO_SNAP
DIS_RST ... acc=0 txn=0 gen=0 ep=0 pval=0
DIS_STALE ... nupd=0 nstale=1 nbad=0 w0=0 !cmt
PASS DIS_RST_STALE
```

**No-restore** (`persist_en=1` capture, `restore_en=0`, `power_loss` without clr):

```text
NO_RESTORE ... acc=0 ep=0 ... pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pans=4 pp0=17 pphi0=50
PASS NO_RESTORE_KEEP
NO_RESTORE_STALE ... nupd=0 nstale=1 nbad=0 w0=0 acc=0 ... pval=1 pep=7
PASS NO_RESTORE_STALE
```

Handshake (`:425-427`, same in `S_HOLD`): empty pending with `pend_epoch==0` vs a pre-loss key is **`n_stale`**, not `n_bad`. Dump `nbad=0 nstale=1`. Journal can remain valid while live pending stays empty if `restore_en=0`.

**Finding:** both numeric-key-is-stale vectors fire. Discriminator is the epoch-0 empty pending, not a TB-only counter.

---

## Hunt 4 — rst during SGD upd: persist not half-committed?

Frozen SGD: `IDLE → SCORE(32) → LATCH(1) → UPD(32) → DONE` (`sgd:92-122`). `go_upd` still **scores first**; `w[0]` writes on the first UPD cycle; `done_o` pulses only in DONE after all 32 UPD writes. Persist snaps weights **only** on `(st==S_UW) && sgd_done` (`:373-376`), never during SCORE/UPD.

TB (`tb:274-289`): `pulse_rew(-3)` → 2 clocks `RST_UPD_IN_FLIGHT` (`busy && !result_v`) → 38 more clocks `MID_UPD` → `power_loss`.

Raw log:

```text
PASS RST_UPD_IN_FLIGHT
MID_UPD ... nupd=0 cmt=0 w0=-5 ... pcmt=0 pw0=0
PASS NO_HALF_COMMIT
RST_UPD_ABORT ... nupd=0 w0=0 acc=1 cmt=0 ep=7 phi0=50 ... pcmt=0 pw0=0
PASS NO_HALF_AFTER_RST
RST_UPD_RELOAD ... nupd=1 cmt=1 w0=-5 ... pcmt=1 pw0=-5
PASS RST_UPD_RELOAD_OK
```

`MID_UPD` is the non-tautological discriminator: **live** SGD already wrote `w[0]=-5` (in UPD), **persist** still `pw0=0 pcmt=0 nupd=0` (no `sgd_done`). After rst, SGD zeros live `w`; reload installs persist 0 + pending `{7,1,1}`; delayed matching then does a **full** update `w0=-5`. A half-commit into persist would have shown `pw0=-5` at MID_UPD or after rst.

Rst was **not** aligned to the `sgd_done` cycle (single-cycle snap window still a residual, not fired).

**Finding:** persist did not absorb the in-flight partial UPD. In-flight SGD correctly does not survive `rst_n`.

---

## Hunt 5 — UNREL after restore, no stale proof?

TB (`tb:300-305`): restore path, then `payroll tax form`.

```text
UNREL_PRE ... acc=1 ... ans=0 p0=0 tbl=0 pval=1 pans=4 pp0=17
UNREL st=1 npath=0 ans=0 p0=0 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 ... tbl=0
PASS UNREL_NO_STALE
```

Live HOLD `ans=0 p0=0 npath=0 status=UNKNOWN`. Persist still holds `pans=4 pp0=17` (journal, not the query result). `S_GUARD` `np==0` goes HOLD without `S_PICK` (`:617-620`), so UNREL does not issue a new pending and does not copy persist eids onto HOLD. `load_from_tb_o=1'b0` (`:173`); dump `tbl=0`.

Residual: `pend_acc` stays 1 (pre-UNREL pending not retired). Hunt asked **no stale proof** (ans/p0), not pending-clear. `nstale` did not increment.

**Finding:** unrelated query after restore is UNKNOWN with zero proof IDs. Not a leak of persist `pans` onto live HOLD.

---

## Hunt 6 — overclaim DDR/MIG/QSPI/NVM/Master F3/LM06/BOARD?

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 24055 ns, all PASS tags, dump fields (`w0`/`nstale`/`pw0`/`phi0`/`tbl`/`pans`) match. RESULTS is **not** used as evidence. |
| Editing goldens to PASS | **Not found.** First run PASS; no fail-r0. ISO golden `w0===5` and smoke `ans=4 p0=17` are the same F2R numbers. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0` (`:173`). Every dump `tbl=0`. `poke_v_i=1'b0` (`:311`). Queries are `send_text` tokens. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). |
| Hash theatre / hash after scores | Freeze **16:12:08** is before xsim **16:12:12–14**. POST **16:12:14** matches compiled bytes. `.svh` in PRE. TB hash PRE=POST `ddf30118…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| DDR / MIG / QSPI / NVM | **Not claimed closed.** ACK `does_not_close` + PREREG + CLOSEOUT list `persistence_DDR`, `NVM_QSPI_journal`. DUT has no MIG/QSPI/DDR persist port. AXI is retrieval only. |
| Master F3 10pp / LM06 / BOARD / ASTRA-13 | **Not claimed closed.** |
| Host `sess_id` reuse without restore | **OPEN**, explicitly. After restore, host **may** keep the same `sess_id` (journaled epoch). That is this bag’s restore path (`sess_id=7` throughout), not the OPEN protocol item. |
| F2R5 / F3* bag wipe | **Not found.** Prior `xsim.log` session headers unchanged. Frozen DUT hashes unchanged vs those bags. A06 work dir has no F2R5/F3 integrator `.sdb`. |
| Naming `ASTRA-06` / `WARM-PERSIST` | **Scope risk, not RESULTS overclaim.** Implementer grades `PASS_NARROW (this gate only: modeled on-chip warm persist / power-loss journal)`. Master **warm persistence** is DDR-across-BRAM-loss; Master **power-loss durability** is NVM journal. This bag is **modeled `rst_n` on-chip regs**. Parent must not promote the filename to Master ASTRA-06 CLOSED. |
| Implementer `PASS_NARROW` | Scoped. Not OVERCLAIM if auditor grade stays **narrow** and Master ASTRA-06 stays OPEN. |

---

## Hunt 7 — full-ID 20-bit in pending store or 8-bit truncation?

Persist eids are `logic [19:0] p_ans, p_p0, p_p1` (`:168`), `ID_W=20` (`:10`), copied from `c_best_a/p0/p1` (20-bit path IDs, not `r_subj[7:0]`). Outputs `persist_ans_o` / `persist_p0_o` / `persist_p1_o` are `ID_W-1:0`.

Raw `PEND_EID20`: `pans=4 pp0=17` and live `ans=4 p0=17`. TB check is `p_ans===20'd4 && p_p0===20'd17` (`tb:231-232`). **IDs 4 and 17 fit in 8 bits.** That check does **not** fire bits[19:8]. It also does not prove truncation: an 8-bit store would still print 4 and 17.

Parser entities remain 8-bit (`qse_subj`/`r_subj`) zero-extended in fact compare (`:544`). That is the existing F2 retrieval law, not persist truncation.

**Finding:** pending persist store is **20-bit wide, not an 8-bit truncated snap**. High-bit identity (`ID>=256`) is **untested**. Master “Full32 subject/object persistence schemaV2” / “No low8/low16 identity authority” for the **index/DDR record** is **not** this bag.

---

## Hunt 8 — hash freeze including `.svh` before xvlog; RESULTS vs raw log; `load_from_tb`; ISO +5

**`.svh` in SHA freeze before xvlog:** yes. `run_xsim.ps1:37-69` writes SHA including four includes, then xvlog. PRE `TRANSITIVE_INCLUDES` has crc / role lexicon / lexicon / **`a7ng_astra_06_warm_persist.svh`**.

**RESULTS vs raw log:** match (Hunt 6).

**`load_from_tb`:** 0; `tbl=0`.

**ISO +5:** `ISO_P3 w0=5 viso=0` on the isolated TB SGD instance (`tb:122-127`, `:221-224`), not DUT weights. Symmetric F2R2 law.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated **bag** gate. Checks that are **weaker than the dump** and must not be mistaken for extra proof:

1. **PEND_EID20** does not exercise bits[19:8]. Width evidence is the RTL `[19:0]` field, not the numeric 4/17 check.
2. **EN_RST_LIVE_CLEAR** dumps **after** `wait_reload()` (`tb:164-169`). `acc=1 phi0=50` in that dump is restored pending, not “pending survived rst uncleared”. Live-clear evidence is `nupd=0 ost=0` HOLD `ans=0`, then reload. Pair with `EN_RELOAD_KEY` / `EN_DELAYED_UPD`.
3. **AXI_OST_CLEARED** after smoke+rst is `ost=0`. Smoke already completed AXI; rst also zeros `axi_ost`. Weak alone; contract still holds in RTL (`:384`, `:412`).
4. **UNREL_NO_STALE** does not require `pend_acc=0`. Dump `acc=1` is leftover pending. Proof ports are the hunt.
5. **`reload_i` pin** is never pulsed; auto-reload is `need_rl` after rst (`:400`, `:416-419`). Explicit-reload path untested.
6. **Single-cycle persist snap** is not a 2-cycle CRC commit window. Not claimed as QSPI. Do not rename it Master power-loss durability.

ISO `viso=0` is an isolated `go_upd` without a prior displayed score; `w0=5` is the law check.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify the work-order unknown on this bag’s tests.

Residuals (not P1 for this gate):

1. **Not Master ASTRA-06 (migration / eviction / schemaV2 / DDR warm persist / NVM) — 0/10 as this bag, 9/10 if parent ticks Master ASTRA-06 CLOSED.** `VER` unused (`:106`). No CRC, no capacity miss into an eviction policy, no DDR-across-BRAM-loss, no QSPI. Single pending object only (F2R5-shaped).

2. **PEND_EID20 does not fire high-bit IDs — 5/10 TB, 1/10 DUT.** Store is 20-bit (`:168`). Need `ID>=256` to prove no silent `[7:0]` slice.

3. **`S_RELOAD` does not restore live `ans_o`/`proof*_o` from `p_ans`/`p_p0`/`p_p1` — 3/10 hygiene.** Contract: HOLD result does not survive. Persist eids remain on `persist_*_o`. Delayed SGD does not need them.

4. **Live fact/path arrays not in the async rst list — 4/10 hygiene, 1/10 as this TB.** Gated by reset `nf`/`np` and `S_IDLE` `fv` clear. UNREL stayed UNKNOWN.

5. **`need_rl` stays 1 when `p_valid && !restore_en_i` (`:416-421`) — 3/10.** `busy_o`/`tok_ready` only block when `restore_en` is also 1 (`:192-196`). NO_RESTORE still accepts the delayed pulse. A later `restore_en` rise without rst would auto-reload; untested.

6. **UNREL leaves `pend_acc=1` (`:617-620`) — 3/10.** Same class as F2R UNKNOWN not retiring. Not a stale proof.

7. **`reload_i` untested — 2/10 coverage.** Auto-reload covers the work-order restore.

8. **Snap window is one cycle on `sgd_done` — 3/10 as NVM atomicity, 0/10 as this modeled rst.** MID_UPD was mid-UPD, not on DONE.

9. **Copied F2R5 semantic/drain FSM not re-audited here — 3/10 as residual, 0/10 as this unknown.** Smoke+UNREL only. Items 4/5 remain closed on the F2R3/F2R4 bags.

10. **Host `sess_id_i` reuse after `rst_n` without restore — 0/10 as this gate (documented OPEN), 8/10 if renamed “DUT uniqueness across reset without journal install”.**

11. **On-chip no-reset FFs are not board power-loss — 0/10 as this modeled gate, 9/10 as silicon durability.** FPGA POR typically zeros no-reset flops; QSPI/SD journal is the Master NVM path.

No remaining **demonstrated** P1 that falsifies the work-order tests.

---

## ASTRA-06 this bag vs Master ASTRA-06 (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| Work-order unknown (modeled `rst_n` persist, delayed matching dw, disable/no-restore stale, no half-commit, UNREL, ISO +5, 20-bit persist eids width) | **CLOSED (narrow)** on **ASTRA-06-WARM-PERSIST-01 only** | Written two-domain contract in PREREG + `.svh`. Live no-reset persist flops vs async live/`rst_n` SGD. Raw log: `EN_DELAYED_UPD w0=-5`; `DIS_RST_STALE` / `NO_RESTORE_STALE` `nstale=1 w0=0`; `MID_UPD` live `w0=-5` persist `pw0=0`; UNREL `ans=0 p0=0 tbl=0`; ISO `w0=5`. |
| F2R5 remainder **power-loss journal** (modeled on-chip) | **CLOSED_NARROW** | This is the remainder `20260906T0705Z` left OPEN. Not NVM. |
| F2R5 remainder **host `sess_id` reuse after rst without restore** | **OPEN** | Claimed open. Restore-with-same-`sess_id` is allowed here and tested. |
| Master ASTRA-06 **pending/commit** | **PARTIAL** | Single pending, ACK (`pend_acc`) vs commit (`pend_cmt`) exists (F2R lineage + this journal). Not a multi-slot commit store. |
| Master ASTRA-06 **full-ID schema** | **OPEN** | Persist eids are 20-bit; no schemaV2 version/migration; query IDs still 8-bit parser; high-bit IDs untested; not Full32 DDR identity authority. |
| Master ASTRA-06 **migration** | **OPEN** | `VER` unused. No invalidation of foreign-version state. |
| Master ASTRA-06 **capacity/eviction** | **OPEN** | Single pending. `TXN_MAX` refuse is F2R5 wrap policy, not persist eviction. Not fired in this TB (default 255, one pick). |
| Master **warm persistence** (DDR retention across BRAM loss) | **OPEN** | Not this experiment. On-chip regs surviving `rst_n` is a different mechanism. |
| Master **power-loss durability** (NVM checkpoint/journal) | **OPEN** | Not QSPI/SD, no CRC/generation/wear. |
| F3 / LM06 / BOARD / ASTRA-13 | **OPEN** | Not claimed. |
| F2R items 1–6 | **not re-opened** | Frozen F2R2–F2R5 unpatched. Prior auditor grades stand on those bags. |

Narrow = XSim TB-planted AXI corpus + modeled `rst_n` (not chip POR, not BRAM kill, not NVM) + auto-reload not `reload_i` + IDs 4/17 not high-bit + first-run PASS (no fail-r0). Not Master ASTRA-06, not F3, not LM06, not BOARD, not a patch of live F2R5.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_06_warm_persist.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | **Not patched.** Hash `41c77e76…` / `1db76fcc…` matches F2R5 compiled DUT. No persist ports. Not in A06 snapshot. |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | **Not patched.** Hash `5cdb3da8…` / `94887bd4…`. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…`. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. Still `{gen,txn}` only. |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | **Not patched.** Hash `d12144a99…` / `9f0e5dbd7…` matches F3R4 compiled DUT. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 / F3 / F3R2 / F3R3 / F3R4 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-06-WARM-PERSIST-01`

Narrow = work-order modeled on-chip persist across `rst_n`: written contract matches live no-reset flops; persist-enable reload delayed reward `w0=-5`; disable and no-restore same numeric key `n_stale`; mid-SGD rst does not half-commit persist; UNREL after restore has no stale proof IDs; ISO +5; persist eids 20-bit wide. Not Master ASTRA-06 (migration / eviction / schemaV2 / DDR warm persist / NVM), not F3, not LM06, not timing, not BOARD_PASS, not host `sess_id` reuse without restore, not a patch of live F2R5.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this modeled-persist bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (high-bit eids untested, `reload_i` unused, live fact arrays not in async rst, single-cycle snap ≠ CRC NVM, `VER` unused, Master ASTRA-06 still OPEN) are **not** P1 for this gate.

Parent: treat **F2R5 power-loss journal remainder** as CLOSED narrow on **this bag only**, as **modeled on-chip `rst_n` persist**. Do **not** tick Master ASTRA-06 CLOSED. Do not reopen F2R2 handshake, F2R3 semantic-guard, F2R4 drain, F2R5 wrap/reset, or F3R4 unique-HASH bags. Do not treat this as F3/LM06/BOARD/DDR/QSPI. Preserve F2R-01, F2R-R2, F2R-R3, F2R-R4, F2R-R5, F3*, and this bag. Do not rerun those `run_*.ps1` in a way that wipes `xsim.log`. Next residual is Master ASTRA-06 leftover (schemaV2 migration / capacity-eviction / DDR-across-BRAM-loss / NVM journal) **or** host `sess_id` reuse-without-restore **or** the LM06/BOARD queue — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of Master ASTRA-06 (full: migration + eviction + schemaV2 + DDR warm persist + NVM) / Master F3 / LM06 / BOARD / COM12 / DDR/MIG production persistence / QSPI journal / host `sess_id_i` reuse after `rst_n` without restore / live F2R2–F2R5 persist remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

ASTRA-06 **this bag** = **CLOSED_NARROW** (modeled on-chip `rst_n` persist / F2R5 power-loss journal remainder).  
ASTRA-06 **Master** = **OPEN**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0945Z\REPORT.md  ACCEPT_PARTIAL  ASTRA-06 bag=CLOSED_NARROW (modeled on-chip rst_n persist) / Master ASTRA-06=OPEN
