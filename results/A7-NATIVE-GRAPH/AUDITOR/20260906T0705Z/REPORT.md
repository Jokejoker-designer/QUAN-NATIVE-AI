# ASTRA auditor REPORT — 20260906T0705Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F2R5_TXN_WRAP_INDEPENDENT_AUDIT; f2r_r5_txn_wrap=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER + F2R_ACCEPTANCE_20260906 item 6 + work order ASTRA-F2R-R5-TXN-WRAP-RESET-01
EVIDENCE   = raw xsim.log / xsim_fail_r0.log / xvlog.log / xelab.log / RTL / TB / SHA manifests (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F2R-R5-TXN-WRAP-RESET-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.svh`. TB `tb_astra_f2r5_txn_wrap.sv` (bag-local).

Gate under review is **only** F2R_ACCEPTANCE item **6 remainder**: pending identity lifetime after 8-bit wrap and after `rst_n`, with a written epoch/lifetime contract — **not** in-episode `{gen,txn}` equality only. Required tests: wrap or equivalent unique-key collision; post-reset replay of pre-reset `{gen,txn}`; reset-during-update abort (no silent half-commit); in-episode dup/wrong/stale/oor; smoke retrieval→proof; UNREL no stale.

Out of this bag’s close: F3 transfer, LM06, SoC/timing, BOARD_PASS, post-timeout recovery, interconnect cancel, power-loss journal, host `sess_id_i` reuse after `rst_n`.

Frozen `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r2_hs_law.sv`, and `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` must remain **unpatched**. This DUT is a **new named copy** of the F2R4 FSM plus `{sess_id,gen,txn}` lifetime; live F2R2/F2R3/F2R4 still have no `sess_id_i` / `rew_epoch_i`. That is expected (do not patch frozen RTL) and is **not** this candidate.

Work-order filenames `astra_f2r5_txn_wrap_reset.sv` / `tb_astra_f2r5_txn_wrap_reset.sv` were implemented as `a7ng_astra_f2r5_txn_wrap.sv` / `tb_astra_f2r5_txn_wrap.sv`. Naming only; still a new named source.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T13:53:22.8732673+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T13:53:28.5945478+07:00` (matches raw log exit `Sun Sep 6 13:53:28 2026`).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including the new `a7ng_astra_f2r5_txn_wrap.svh`.

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
| `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |
| `.../tb_astra_f2r5_txn_wrap.sv` | `503b680041cb1da44aeb60a66e1d89c59bc99176ee26d57ead83bc3ca4c7d809` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.svh` | `1db76fcc01170f5abd38958228416e543900b98e76c8db3f895fcbac35e8ab9a` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.svh` | `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` |
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` |

Overlapping hashes vs F2R4 freeze `ASTRA-F2R-R4-AXI-TIMEOUT-DRAIN-01/SHA256.txt`, F2R3 freeze, and F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, all three shared `.svh`, F2R4 DUT `5cdb3da8…` / `.svh` `94887bd4…`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R5 DUT has `sess_id_i`, `rew_epoch_i`, `pend_epoch`, `TXN_MAX` refuse, `n_exh` / `txn_exh` (`a7ng_astra_f2r5_txn_wrap.sv:21`, `:32`, `:136`, `:529-548`, `:560-564`).
- Live F2R4 still has **no** `sess_id_i` / `rew_epoch_i`; still `S_DRAIN` / `S_ABORT` (`a7ng_astra_f2r4_axi_drain.sv:19-29`, `:87`, `:392`). **Not patched.**
- Live F2R3 still has **no** `S_DRAIN`; AR/R timeout **continues** `fi++` / `S_EI` (`a7ng_astra_f2r3_sem_guard.sv:301-304`, `:329-332`). **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` reward match only (no epoch port) (`a7ng_astra_f2r2_hs_law.sv:15-26`, `:34-35`). **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`).
- Live TB `$finish` at line **319** — raw pass log cites that line. Fail-r0 cited line **318**.
- `.svh` exists at freeze path; `A7NG_F2R5_TXN_MAX=255`, `A7NG_F2R5_EPOCH_INV=0`. TB instantiates `#(.TXN_MAX(8'd2))`.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           a93aaedc559ae6bbb7bad36f088a5fa729ace77182d86bfc6c30bfe3cf0619b5
xsim_fail_r0.log   7a0a37e9f47bb16da859ba749b99d172fc3d33bf11cb6a840b24bec617977d67
```

Prior bags **not** overwritten:

- F2R4 `xsim.log` still session `Sun Sep 6 13:24:12 2026` PID **47768** (claimed SHA `98297afc…`).
- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026` PID **34860** (claimed SHA `806026f2…`).
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026` PID **32496** (claimed SHA `337ca164…`).
- F2R-01 `xsim.log` still session `Sun Sep 6 11:40:10 2026` PID **27464**.

`run_f2r.ps1` / `run_f2r2.ps1` / `run_f2r3.ps1` / F2R4 `run_xsim.ps1` were not rerun.

Fail-r0 freeze (before the one corrective) is a **different** DUT/TB/`.svh`/PREREG hash set:

| Path | SHA256_fail_r0.txt | pass SHA256.txt |
|------|--------------------|-----------------|
| DUT | `daf32e337f95c684…` | `41c77e76fb5bc179…` |
| TB | `2808c798ae93d249…` | `503b680041cb1da4…` |
| `.svh` | `2e36a3530099c505…` | `1db76fcc01170f5a…` |
| PREREG | `189a59597d43e134…` | `842cc0e2817fea94…` |
| ACK / `run_xsim.ps1` | unchanged `cc99abdf…` / `976dfb5f…` | same |

Frozen provenance hashes in fail-r0 match the pass freeze (F2R4/F2R3/F2R2/SGD-floor file). SGD compiled hash `b66ef328…` unchanged across fail-r0 and pass.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 13:53:26–13:53:28 2026**, PID **5776**, snapshot `f2r5`, `$finish` at **43815 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
SMOKE_TWO_PROOFS st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS SMOKE_TWO_PROOFS
HS_UPD st=0 npath=2 ans=4 p0=17 acc=1 cmt=1 txn=1 gen=1 ep=7 exh=0 nexh=0 nupd=1 ndup=0 nbad=0 nstale=0 noor=0 w0=-5 tbl=0
PASS HS_LATCH_NUPD
PASS DUP
PASS WRONG_TXN
PASS STALE_GEN
PASS STALE_EPOCH
PASS OOR_M4
RETIRE_A st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
B_AFTER_A st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=2 gen=2 ep=7 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
REPLAY_A_ON_B st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=2 gen=2 ep=7 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=1 noor=0 w0=0 tbl=0
PASS RETIRE_A_NO_UPD_B
PASS REWARD_B_ONCE
WRAP_A st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=20 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS WRAP_A_KEY
WRAP_B st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=2 gen=2 ep=20 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS WRAP_B_KEY
WRAP_C_EXH st=0 npath=2 ans=4 p0=17 acc=0 cmt=0 txn=2 gen=2 ep=20 exh=1 nexh=1 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS WRAP_EXHAUST
PASS WRAP_NO_REUSE_11
WRAP_REPLAY_A st=0 npath=2 ans=4 p0=17 acc=0 cmt=0 txn=2 gen=2 ep=20 exh=1 nexh=1 nupd=0 ndup=0 nbad=1 nstale=0 noor=0 w0=0 tbl=0
PASS WRAP_REPLAY_NO_UPD
EPOCH_RECYCLE st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=21 exh=0 nexh=1 nupd=0 ndup=0 nbad=1 nstale=0 noor=0 w0=0 tbl=0
PASS EPOCH_RECYCLE_11
EPOCH_REPLAY_OLD st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=21 exh=0 nexh=1 nupd=0 ndup=0 nbad=1 nstale=1 noor=0 w0=0 tbl=0
PASS EPOCH_REPLAY_STALE
PASS EPOCH_FRESH_UPD
PRE_RST_A st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=30 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS PRE_RST_KEY
POST_RST_B st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=31 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS POST_RST_REUSED_NUMERIC
POST_RST_REPLAY_A st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=31 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=1 noor=0 w0=0 tbl=0
PASS POST_RST_REPLAY_NO_UPD
PASS POST_RST_FRESH_UPD
RST_UPD_SETUP st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=40 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS RST_UPD_IN_FLIGHT
RST_UPD_ABORT st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS RST_UPD_CLEARED
RST_UPD_FRESH st=0 npath=2 ans=4 p0=17 acc=1 cmt=1 txn=1 gen=1 ep=41 exh=0 nexh=0 nupd=1 ndup=0 nbad=0 nstale=0 noor=0 w0=-5 tbl=0
PASS RST_UPD_FRESH_OK
SMOKE_AFTER st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=50 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS SMOKE_AFTER
UNREL st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=1 gen=1 ep=50 exh=0 nexh=0 nupd=0 ndup=0 nbad=0 nstale=0 noor=0 w0=0 tbl=0
PASS UNREL_NO_STALE
ASTRA_F2R5_TXN_WRAP_RESET_XSIM_PASS
$finish called at time : 43815 ns : File ".../tb_astra_f2r5_txn_wrap.sv" Line 319
```

Marker **present**. Zero `FAIL` lines. `tbl=0` on every dump.

`xvlog.log` / `xvlog_dut.log` analyzed `a7ng_astra_f2r5_txn_wrap` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB. `xelab.log` built snapshot `f2r5`. Work library has `a7ng_astra_f2r5_txn_wrap.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f2r4_axi_drain.sdb` / `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. Frozen integrators and floor-shift SGD were **not** compiled into this run.

### Raw fail-r0 `xsim_fail_r0.log` (preserved)

xsim v2026.1, session **Sun Sep 6 13:51:05–13:51:07 2026**, PID **16208**, `$finish` at **31935 ns**, line **318**. `xsim_fail.log` and `xsim_16208.backup.log` are the same session (PID 16208). `run_xsim.ps1` copies a failing `xsim.log` to `xsim_fail.log` only; it does **not** overwrite `xsim_fail_r0.log`.

```text
REPLAY_A_ON_B st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=2 gen=2 ep=7 ... nupd=0 nbad=0 nstale=1 ... w0=0 tbl=0
FAIL RETIRE_A_NO_UPD_B
PASS REWARD_B_ONCE
WRAP_A st=1 npath=0 ans=0 p0=0 acc=0 ... txn=0 gen=0 ep=0 ...
FAIL WRAP_A_KEY
...
ASTRA_F2R5_TXN_WRAP_RESET_XSIM_FAIL n=14 first=RETIRE_A_NO_UPD_B
```

First divergence **RETIRE_A_NO_UPD_B** matches `FAIL_R0.md`. Dump already shows the DUT rejected (`nstale=1 nupd=0 w0=0`); TB over-specified `n_bad`. Subsequent WRAP/POST_RST/SMOKE_AFTER dumps are `st=1 npath=0` (retrieval UNKNOWN) after the TB had reused `live_epoch_i` as the session nonce.

---

## Hunt 1 — pending key more than in-episode `{gen,txn}`? `sess_id`? wrap refuse at TXN_MAX?

PREREG is the written contract: pending key is `{epoch=sess_id_i, gen, txn}`; `sess_id_i` is host session nonce / transport metadata, **not** `live_epoch_i` (sparse-walker generation). Epoch 0 is invalid. In-session 8-bit counters **do not wrap**: at `TXN_MAX` PICK refuses a new pending (`txn_exh`, `n_exh`) and does not reissue `{epoch,1,1}`.

Live mux (not comments):

```524:548:rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv
        S_PICK: begin
          ...
          if ((sess_id_i == A7NG_F2R5_EPOCH_INV) ||
              ((sess_id_i == sess_epoch) && (txn == TXN_MAX))) begin
            nexh <= nexh + 16'd1;
            txn_exh <= 1'b1;
            pend_acc <= 1'b0;
            pend_cmt <= 1'b0;
          end else begin
            txn_exh <= 1'b0;
            if (sess_id_i != sess_epoch) begin
              sess_epoch <= sess_id_i;
              pend_id <= 8'd1; txn <= 8'd1;
              pend_gen <= 8'd1; gen <= 8'd1;
            end else begin
              pend_id <= txn + 8'd1; txn <= txn + 8'd1;
              pend_gen <= gen + 8'd1; gen <= gen + 8'd1;
            end
            pend_epoch <= sess_id_i;
            pend_acc <= 1'b1; pend_cmt <= 1'b0;
```

```560:571:rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv
          if (rew_v_i) begin
            if (!pend_acc) nbad <= nbad + 16'd1;
            else if (rew_epoch_i != pend_epoch) nstale <= nstale + 16'd1;
            else if (rew_gen_i != pend_gen) nstale <= nstale + 16'd1;
            else if (rew_txn_i != pend_id) nbad <= nbad + 16'd1;
            else if ((rew_i < -4'sd3) || (rew_i > 4'sd3)) noor <= noor + 16'd1;
            else if (pend_cmt) ndup <= ndup + 16'd1;
            else if (freeze_q) begin
            end else if (sgd_ready) begin
              rew_lat <= rew_i;
              sgd_upd <= 1'b1;
              st <= S_UW;
```

Walker still sees `live_epoch_i` (`:260`). Reward bus carries `rew_epoch_i`. Fail-r0 proved mixing walker generation with the pending key: WRAP dumps went `st=1 npath=0`. Pass WRAP holds `live_ep=7` and bumps `sess_id` to 20/21 — retrieval stays ANSWER 4 while epoch in the pending key changes.

In-session wrap is **refuse**, not 8-bit wrap-around + epoch bump. Work order allowed “wrap (or equivalent unique-key collision)”. TB `TXN_MAX=2` is the documented wrap setup (`tb:8`, `:84`); production default remains 255 in the `.svh`. Same `TXN_MAX` compare.

Raw log: WRAP_A `{20,1,1}` → WRAP_B `{20,2,2}` → WRAP_C `acc=0 exh=1 nexh=1` still `ans=4 p0=17`. WRAP_NO_REUSE: live pending is **not** `{20,1,1}` (`txn` stayed 2, `acc=0`).

EPOCH_RECYCLE (no `rst_n`): `sess_id` 21, `live_epoch` still 7, pending `{21,1,1}`. Delayed `{20,1,1}` → `nstale=1 w0=0`. Fresh `{21,1,1}` updates. That is the reused-numeric / different-epoch discriminator.

**Finding:** item 6 remainder is not in-episode `{gen,txn}` equality only. Key is `{sess_id,gen,txn}` with fail-closed refuse at `TXN_MAX`.

---

## Hunt 2 — post-reset delayed pre-reset `{gen,txn}` → `n_stale`, no weight update?

TB: birth `{30,1,1}`, `hard_rst`, birth `{31,1,1}` (numeric gen/txn reused, epoch differs), pulse delayed `{30,1,1}`.

Raw log:

```text
PRE_RST_A  ... txn=1 gen=1 ep=30 acc=1 w0=0
POST_RST_B ... txn=1 gen=1 ep=31 acc=1 w0=0
POST_RST_REPLAY_A ... ep=31 nupd=0 nstale=1 w0=0 acc=1 cmt=0
PASS POST_RST_REPLAY_NO_UPD
PASS POST_RST_FRESH_UPD
```

If the DUT ignored epoch, matching `gen=1,txn=1` would have taken the delayed reward (`nupd=1`, `w0=-5`). Observed `nstale=1 w0=0 !cmt` therefore requires the epoch compare. Fresh `{31,1,1}` then updates once.

Host reuse of the **same** `sess_id_i` after `rst_n` is **not** this test. PREREG/ACK/CLOSEOUT/metrics list `host_sess_id_reuse_after_rstn` **OPEN**. After `rst_n`, `sess_epoch`/`pend_epoch` are 0 (`:311`); the DUT cannot remember the pre-reset nonce. Anti-replay of a delayed `{gen,txn}` after reset is host-fresh-`sess_id_i`, not a DUT journal.

---

## Hunt 3 — rst-during-upd: abort, no silent half-commit?

DUT and frozen SGD share `rst_n`. Integrator reset clears `pend_acc/cmt`, `nupd`, `txn/gen`, `pend_epoch/sess_epoch` (`:304-316`). SGD reset zeros all `w[k]` (`sgd:85-90`). `nupd` increments only on `sgd_done` in `S_UW` (`:577-584`).

TB (`tb:292-306`): `q_smoke` → `pulse_rew(-3)` → 2 clocks → `chk RST_UPD_IN_FLIGHT` (`busy && !result_v`) → 50 clocks → `hard_rst` → dump `RST_UPD_ABORT`.

- `RST_UPD_IN_FLIGHT` **PASS** ⇒ not still `S_HOLD` (`result_v_o=(st==S_HOLD)`). Pulse took `S_UW`.
- Frozen SGD update is SCORE(32)+LATCH(1)+UPD(32)+DONE ≈ 66 cycles after `go_upd`. `sgd_upd` is a 1-cycle registered pulse, so SGD starts one cycle later. A 2+50 wait after `pulse_rew` lands in **UPD** (partial `w[ji]` writes), then `rst_n`.
- Raw dump **after** rst: `RST_UPD_ABORT st=1 ... acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 w0=0`.
- `RST_UPD_FRESH_OK`: new sess 41, one update, `w0=-5`. Learning works after abort.

The post-rst dump alone is consistent with “rst always zeros registers”. The non-tautological parts are IN_FLIGHT (entered `S_UW`) + SGD latency (rst during UPD, before `sgd_done`/`nupd++`) + FRESH_OK. There is **no** pre-rst dump of partial `w0`. For this vector `w[0]` is written on the first UPD cycle, so a commit-then-rst would also show `w0=0` after rst; `nupd` would also be 0 after rst. Discriminator is therefore the 50-cycle window vs ~66-cycle SGD, not a logged mid-update weight. Residual coverage, not a demonstrated half-commit.

**Finding:** rst-during-update is a live path; silent half-commit of pending/`nupd` across `rst_n` is not observed. Not a DUT journal across power-loss (OPEN).

---

## Hunt 4 — fail r0 preserved; TB goldens not edited to manufacture PASS?

Fail-r0 artifacts present and internally consistent: `xsim_fail_r0.log` / `xsim_fail.log` / `xsim_16208.backup.log` / `FAIL_R0.md` / `SHA256_fail_r0.txt` / `xvlog_fail_r0.log`. First divergence `RETIRE_A_NO_UPD_B` at 31935 ns, marker `ASTRA_F2R5_TXN_WRAP_RESET_XSIM_FAIL n=14`. Pass run did not wipe those files (`run_xsim.ps1` only copies fail to `xsim_fail.log`).

Two fail-r0 causes, both visible in the raw fail log:

1. **TB over-specified `n_bad`.** `REPLAY_A_ON_B` already `nstale=1 nupd=0 w0=0` — DUT reject was right (handshake order epoch→gen→txn; gen and txn both differ). Pass TB accepts `nbad|nstale` (`tb:232`). That is a check relaxation to the **observed DUT counter**, not a change of `nupd`/`w0` goldens.
2. **`live_epoch_i` used as session nonce.** Fail WRAP/POST_RST dumps are UNKNOWN (`st=1 npath=0`). Pass keeps `live_ep=7` and adds `sess_id_i`. WRAP expected remains ANSWER 4 / `{20,1,1}` — they did **not** edit the expected answer to UNKNOWN.

DUT/TB/`.svh`/PREREG hashes changed between fail-r0 and pass (one corrective: `sess_id_i` split + RETIRE check + written contract). ACK and `run_xsim.ps1` hashes did not. ISO golden `w0===5` and smoke `ans=4 p0=17` are unchanged. Not “edit expected scores to manufacture PASS”.

---

## Hunt 5 — cheat / overclaim (F3, LM06, BOARD, power-loss journal, host `sess_id` reuse)

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 43815 ns, all PASS tags, dump fields (ep/txn/gen/exh/nstale/nbad/nupd/w0/tbl) match what RESULTS summarized. RESULTS is **not** used as evidence. |
| Editing goldens to PASS | **Not found.** Fail-r0 preserved. RETIRE check now matches DUT `n_stale`. WRAP expected still ANSWER, not relaxed to UNKNOWN. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0` (`f2r5:143`). Every dump `tbl=0`. `poke_v_i=1'b0` (`:263`). Queries are `send_text` tokens. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). |
| Hash theatre / hash after scores | Freeze **13:53:22** is before xsim **13:53:26–28**. POST **13:53:28** matches compiled bytes. `.svh` in PRE. TB hash PRE=POST `503b6800…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| F3 / 5 seeds / BOARD_PASS / LM06 | **Not claimed closed.** ACK `does_not_close` includes F3, LM06, BOARD_PASS, post_timeout_recovery, interconnect_cancel, power_loss_journal. |
| Power-loss journal | **OPEN.** `rst_n` clears epoch; DUT does not persist pending keys. |
| Host `sess_id_i` reuse after `rst_n` | **OPEN**, explicitly. Not a DUT uniqueness guarantee. |
| F2R2 / F2R3 / F2R4 / F2R-01 wipe | **Not found.** Prior `xsim.log` session headers unchanged. Frozen DUT hashes unchanged vs those bags. R5 work dir has no F2R4/F2R3/F2R2 integrator `.sdb`. |
| ID one-hot as transfer | **Not claimed.** Smoke IDs 17/34/18/35 and ans=4 are the planted 2-hop graph. |
| Implementer `PASS (this gate only)` | Scoped. Not OVERCLAIM if auditor grade stays **narrow**. |

---

## Hunt 6 — `.svh` in SHA freeze before xvlog?

**Yes.** `run_xsim.ps1:37-59` writes SHA including four includes, then xvlog. PRE `TRANSITIVE_INCLUDES` has crc / role lexicon / lexicon / **`a7ng_astra_f2r5_txn_wrap.svh`**. Fail-r0 freeze also listed the `.svh` before that run’s xvlog. This keeps the F2R-01 residual closed **for this bag**.

---

## Hunt 7 — smoke retrieval + UNREL still in raw log?

**Yes.** `SMOKE_TWO_PROOFS` and `SMOKE_AFTER`: `st=0 npath=2 ans=4 p0=17 tbl=0`. `UNREL`: `st=1 npath=0 ans=0 p0=0` after `payroll tax form`. Marker `ASTRA_F2R5_TXN_WRAP_RESET_XSIM_PASS` present.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated gate. Checks that are **weaker than the dump** and must not be mistaken for extra proof:

1. **WRAP_NO_REUSE_11** is `!(pend_acc && txn==1 && epoch==20)` (`tb:253`). `acc=0` alone would pass. Fail-r0 WRAP_A was UNKNOWN (`acc=0`) and this check **passed** there too. Pass-run **dump** is the evidence: `WRAP_C_EXH acc=0 txn=2 gen=2 ep=20 exh=1` with `ans=4 p0=17` — refuse, not wrap-to-`{20,1,1}`, and retrieval not sacrificed.
2. **WRAP_REPLAY_NO_UPD** does not require `n_stale`. After exhaust `pend_acc=0`, handshake first branch is `!pend_acc` → `nbad=1` (dump). This is “no live pending”, **not** “delayed `{20,1,1}` vs a new pending that reused `{20,1,1}`”. In-session reuse is prevented by refuse. The reused-`{1,1}` discriminator is **EPOCH_REPLAY_STALE** / **POST_RST_REPLAY** (`nstale=1` against a live `{21,1,1}` / `{31,1,1}`).
3. **RST_UPD_CLEARED** after `hard_rst` will pass whenever `rst_n` zeros registers. Pair it with IN_FLIGHT + SGD latency, not with the post-rst dump alone.
4. **RETIRE_A** `nbad|nstale` OR is appropriate (both gen and txn differ). Dump: `nstale=1 nbad=0`.

ISO `viso=0` is an isolated `go_upd` without a prior displayed score; `w0=5` is the law check. DUT smoke does not re-run HS_ALL32; work order did not require it.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify item 6 remainder on this bag’s tests.

Residuals (not P1 for this gate):

1. **In-session policy is refuse-at-`TXN_MAX`, not wrap-and-advance-epoch — 3/10 as naming, 0/10 as item-6 fail.** Work order allowed equivalent unique-key collision. `{epoch,1,1}` is not reissued in-session. Production `TXN_MAX=255` is the same compare, **not** fired in this TB (`TXN_MAX=2`).

2. **`gen` and `txn` are lockstep on PICK (`:539-543`) — 4/10 hygiene.** Comparator treats them independently (STALE_GEN vs WRONG_TXN both fired). They are redundant identity bits in this assignment policy.

3. **`sess_id_i` is sampled at PICK, not at query fire — 4/10 coverage.** If the host changed `sess_id_i` mid-walk, pending epoch would be PICK-time. TB holds `sess_id` constant during a query.

4. **No pre-rst dump of `S_UW` / partial `w` — 5/10 TB, 2/10 DUT.** Hunt 3. Async `rst_n` on DUT+SGD still fail-closes pending and weights.

5. **`freeze_q` silently drops a matching reward (`:567-568`) — 3/10.** `ctrl_i=0` in this TB. No `n_lost` counter. Not item 6.

6. **After retire, `pend_id`/`pend_gen`/`pend_epoch` are not cleared (`:573-575`) — 3/10 hygiene.** `pend_acc=0` so a delayed pulse is `n_bad`. UNREL dump still shows `txn=1 gen=1 ep=50` with `acc=0`. RETIRE_A vs new B covers the live-pending case.

7. **Copied F2R4 semantic/drain FSM not re-audited here — 3/10 as residual, 0/10 as item 6.** Smoke+UNREL only. Items 4 and 5 remain closed on the **F2R3 / F2R4 bags**, not re-proven on this fork.

8. **Live F2R2/F2R3/F2R4 still lack epoch — 0/10 as this bag, 9/10 if someone promotes those DUTs for wrap/reset.** Additive candidate is F2R5 only.

9. **Host `sess_id_i` reuse after `rst_n` / power-loss journal — 2/10 as this gate (documented OPEN), 8/10 if renamed “DUT uniqueness across reset without host nonce”.** PREREG states the boundary.

10. **Reward pulse while `!sgd_ready` is dropped (`:568-571`) — 3/10.** After PICK, SGD is IDLE. Not this TB.

No remaining **demonstrated** P1 that falsifies item 6 remainder.

---

## F2R_ACCEPTANCE item 6 vs this bag (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| **6** pending identity lifetime | **CLOSED (narrow)** on **F2R5 only** | Written `{sess_id,gen,txn}` contract in PREREG + `.svh`. Live refuse at `TXN_MAX`. Raw log: in-episode DUP/WRONG_TXN/STALE_GEN/STALE_EPOCH/OOR_M4; RETIRE delayed A is `nstale` no update; WRAP exhaust `acc=0 exh=1` still ANSWER 4; EPOCH recycle `{21,1,1}` + delayed `{20,1,1}` `nstale`; POST_RST numeric `{1,1}` reuse with epoch 30→31 + delayed pre-reset `nstale w0=0`; rst-during-upd cleared; smoke; UNREL. Reward=-4 is `noor`. |
| **1,2,3,4,5** | **not re-opened** | Frozen F2R2/F2R3/F2R4 unpatched. ISO +5 only on isolated SGD; semantic/drain suites not rerun on this fork. Prior auditor grades stand on those bags. |
| F3 / LM06 / BOARD | **OPEN** | Not claimed. |
| power-loss journal / host sess_id reuse after rst | **OPEN** | Claimed open. Do not promote those sentences later. |

Narrow = bag-local `TXN_MAX=2` (not 255 fired) + XSim TB-planted AXI corpus + host-fresh-`sess_id_i` after `rst_n` + refuse rather than wrap-around + rst-during-upd inferred from SGD latency (no mid-update weight dump). Not F3, not LM06, not BOARD, not interconnect cancel, not a patch of live F2R4.

In-episode `{gen,txn}` handshake remains the F2R2 bag. Wrap/reset lifetime is this F2R5 bag. Together they close original item 6 **narrow**, with the documented host-nonce / no-journal boundary.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | **Not patched.** Hash `5cdb3da8…` / `94887bd4…` matches F2R4 compiled DUT. No `sess_id_i`. Not in R5 snapshot. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…`. Still drop-ARVALID-and-`fi++`. Not in R5 snapshot. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. Still `{gen,txn}` only. Not in R5 snapshot. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F2R-R5-TXN-WRAP-RESET-01`

Narrow = F2R_ACCEPTANCE item 6 remainder as shown in raw XSim on the new named DUT: `{sess_id,gen,txn}` lifetime, wrap refuse at `TXN_MAX`, post-reset replay `n_stale`, rst-during-update abort, in-episode guards, smoke, UNREL. Not F3, not LM06, not timing, not BOARD_PASS, not power-loss journal, not host `sess_id` reuse after rst, not a patch of live F2R4.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this item-6 remainder bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (`TXN_MAX=2` vs 255, WRAP_NO_REUSE weak chk, no mid-update weight dump, host sess_id reuse OPEN, live F2R4 still no epoch) are **not** P1 for this gate.

Parent: treat item **6** as CLOSED narrow on **F2R5 only**. Do not reopen F2R2 handshake, F2R3 semantic-guard, or F2R4 drain bags. Do not treat this as F3/LM06/BOARD/power-loss persistence. Preserve F2R-01, F2R-R2, F2R-R3, F2R-R4, and this bag. Do not rerun `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, or this bag’s `run_xsim.ps1` in a way that wipes `xsim.log` / `xsim_fail_r0.log`. Next residual is the Master F3 / LM06 / BOARD queue (or host-protocol/power-loss work if parent opens a new named bag) — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of F3 / LM06 / BOARD / COM12 / post-timeout recovery / interconnect cancel / power-loss journal / host `sess_id_i` reuse after `rst_n` / live F2R2–F2R4 wrap-lifetime remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0705Z\REPORT.md  ACCEPT_PARTIAL
