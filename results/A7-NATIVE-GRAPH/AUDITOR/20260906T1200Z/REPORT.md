# ASTRA auditor REPORT — 20260906T1200Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA06_R3_MULTI_SLOT_INDEPENDENT_AUDIT; astra06_r3=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; master_astra06=OPEN
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-06 (§5 Transaction/storage + §7 table) + work order ASTRA-06-R3-MULTI-SLOT-01 + auditor 20260906T1125Z leftover N>1 persist slots
EVIDENCE   = raw xsim.log / xsim_fail_r0.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_xsim.ps1` or prior-bag scripts. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the persist-bag / R2 / F2R2–F2R5 / F3* freezes (overlapping hashes). Claimed `xsim.log` / `xsim_fail_r0.log` SHAs in `metrics.json` / CLOSEOUT are **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-06-R3-MULTI-SLOT-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_06_r3_multi_slot.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_06_r3_multi_slot.svh`. TB `tb_astra_06_r3_multi_slot.sv` (bag-local).

Gate under review is **auditor 20260906T1125Z leftover N>1 persist slots** on a **new named** DUT — not a patch of frozen persist DUT `a7ng_astra_06_warm_persist.sv` and not a patch of R2 DUT `a7ng_astra_06_r2_evict_highid.sv`:

1. `CAP_N≥2` actual array of persist rows, not N=1 renamed?
2. Two commits, rst+reload, delayed rew A vs B do not mix (quote w0/txn per slot from raw log). Fail r0 `MIX_B_WHILE_A` — was the fix DUT or TB-only?
3. Third commit/PICK evicts oldest/lowest txn; victim quoted?
4. High-bit eids ≥256 still?
5. Overclaim DDR / N>1 DDR index / BOARD?
6. PROGRAM=NO; hashes include `.svh` before xvlog.

Judged against:

1. Work order `.agents/handoff/ASTRA-06-R3-MULTI-SLOT-01.md` + PREREG written policy `REFUSE_ALL_UNCOMMITTED` / `EVICT_OLDEST_COMMITTED_LOWEST_TXN`.
2. Auditor `20260906T1125Z`: R2 bag **CLOSED_NARROW** (high-id + `reload_i` + persist N=1); Master ASTRA-06 **OPEN**; leftover **N>1 persist slots** (not DDR, not BOARD).
3. **Master ASTRA-06** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7 table + §5): pending/commit, **full-ID schema**, **migration**, **capacity/eviction**, and **warm persistence on chosen state architecture**. Master text: *“Full32 subject/object persistence schemaV2 is reusable with version/migration checks. No low8/low16 identity authority. DDR retention across BRAM loss is warm persistence; power-loss durability requires separately tested nonvolatile checkpoint/journal.”*

**Master ASTRA-06 as a whole is not this bag’s close**, even if compact XSim tags all PASS and the DUT is named `a7ng_astra_06_r3_multi_slot`.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, Master F3 10pp/CI, MIG/DDR production persistence, ASTRA-07 index image, QSPI/SD NVM journal, host `sess_id` reuse after `rst_n` without restore, schemaV2 DDR store, **DDR index N>1 eviction**, BRAM-kill-with-DDR-retained warm persist.

Frozen `a7ng_astra_06_warm_persist.sv` / `.svh`, `a7ng_astra_06_r2_evict_highid.sv` / `.svh`, `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv` must remain **unpatched**. This DUT is a **new named** integrator plus on-chip slot array / victim mux / per-slot observe ports.

Prior bags ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01 / F2R-* / F3* are **not** this evidence and must not have been rewritten.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T18:12:31.7047290+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T18:12:38.3525937+07:00` (matches raw pass-log exit `Sun Sep 6 18:12:38 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog (`run_xsim.ps1:37-73`). `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_06_r3_multi_slot.svh`.

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
| `rtl/native_graph/integrate/a7ng_astra_06_r3_multi_slot.sv` | `99ee5d93dd18b3f146b433d521ab706038141cb8648afab17d315bd1ce8c186f` |
| `.../tb_astra_06_r3_multi_slot.sv` | `80968ef9d31327446784f9f63519255226a7d46fb5887bcc205d8248aa283c4e` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_06_r3_multi_slot.svh` | `6b511c1571b6a70295e0578c1f46c5879d4f03c1142e93eb032f11d79fec29df` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `fd875d40bfb146d43a0463b9a500d49ff56204d026fe7df9d17eed869265a3be` |
| `ACK.json` | `b3193ee1a5b83b3e537569597087e28287a2ad36651642548e660d9ba2a898db` |
| `run_xsim.ps1` | `f004c3f775130620d2fd3682eed9ed2e9ffc443529eaaaf3ab6cb7b65ceda0c3` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt | vs prior freeze |
|------|------------|-----------------|
| `a7ng_astra_06_warm_persist.sv` / `.svh` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` / `cad5e606fe1cd9c1b378931714581a6ad5ed9d7fcce8b2643059d4d42fb7db21` | persist-bag **compiled DUT** identical |
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` / `4e96067cce0672189230dc6f79598c452ba4c13ef6ad62e8018b8d199060ff68` | R2-bag **compiled DUT** identical |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | `d12144a99…` / `9f0e5dbd7…` | F3R4 compiled DUT identical |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | `41c77e76f…` / `1db76fcc0…` | F2R5 compiled DUT identical |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…` | compiled here; identical to persist/R2/F2R2 freeze |
| `a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b5…` | floor-shift file, not compiled |

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R3 DUT has `parameter CAP_N = A7NG_A06R3_CAP_N` with `.svh` `A7NG_A06R3_CAP_N = 2`; slot array `ps_valid/ps_acc/ps_cmt/ps_txn/ps_w/ps_phi/ps_ans/ps_p0/ps_p1 [0:1]`; occupancy/victim comb; install zeros `ps_w`; SGD writeback only `live_slot`; `slot_sel_i` observe/reload mux; `n_cap_ref` / `n_cap_evict`; `s0_*` / `s1_*` observe ports (`a7ng_astra_06_r3_multi_slot.sv:15`, `:210-224`, `:321`, `:383-411`, `:489-532`, `:821-831`, `:883-901`).
- Live persist DUT still has **no** `ps_valid` array, **no** `n_cap_ref` / `n_cap_evict`, **no** `n_rl_cmd`. `S_RELOAD` still copies pending key/phi/weights only — **not** `p_ans` onto live HOLD (`a7ng_astra_06_warm_persist.sv:697-710`). `reload_i` pin still exists (`:24`). **Not patched.** Manifest SHA `52ebde52…` matches persist-bag compiled DUT.
- Live R2 DUT still has `CAP_N` **only** as the unused parameter (`a7ng_astra_06_r2_evict_highid.sv:16`); `.svh` still `A7NG_A06R2_CAP_N=1`. **Not patched.** Manifest SHA `c671f98b…` matches R2-bag compiled DUT.
- Live F2R5 still has **no** persist ports. Hash `41c77e76…`. **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`). Instantiated read-only (`r3:482-487`, `freeze_i=1'b0`).
- Live pass TB `$finish` at line **418** — raw pass log cites that line. Fail r0 `$finish` at the same line **418** (predicate-only MIX edit; tests continue after MIX FAIL).
- `.svh` exists at freeze path; `A7NG_A06R3_CAP_N=2`, `A7NG_A06R3_SCHEMA_VER=8'h01`.

R3 does **not** instantiate frozen persist DUT. It is a new named integrator with an on-chip 2-row array (same additive pattern as R2). `xvlog.log` / `xelab.log` analyze/compile `a7ng_astra_06_r3_multi_slot` + frozen SGD + bag TB only. Work library has `a7ng_astra_06_r3_multi_slot.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_06_warm_persist.sdb` / R2 / F2R5 / F3* integrator `.sdb`. Frozen persist DUT and prior integrators were **not** compiled into this run.

Bag-claimed log hashes (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           d6deb5ba22768fcd51c727ccd1df64413b9e3f2ac1b8cd3989735d9dba6536e6
xsim_fail_r0.log   579686f26ce318b97a03271ee1071878a1b65123b6e1409498b24ac769483348
```

Prior bags **not** overwritten (session headers still the auditor-cited runs):

| Bag | xsim session | PID |
|-----|--------------|-----|
| F2R-01 | Sun Sep 6 11:40:10 2026 | 27464 |
| F2R-R5 | Sun Sep 6 13:53:26 2026 | 5776 |
| F3R4 | Sun Sep 6 15:48:29 2026 | 20428 |
| ASTRA-06-WARM-PERSIST-01 | Sun Sep 6 16:12:12 2026 | 33088 (claimed SHA `5f739df0…`) |
| ASTRA-06-R2-EVICT-HIGHID-01 | Sun Sep 6 17:43:24 2026 | 24304 (claimed SHA `ff0770d3…`) |

Those bags’ `run_*.ps1` were not rerun. Persist-bag compiled DUT hash in this provenance is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_warm_persist.sv`. R2-bag compiled DUT hash is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_r2_evict_highid.sv`.

Fail-r0: **preserved**. First xvlog/xelab/xsim **FAIL** (`MIX_B_WHILE_A`), then one TB mix-class corrective, then PASS. `xsim_fail_r0.log` / `xsim_fail.log` / `xsim_47228.backup.log` share session **Sun Sep 6 18:11:42–18:11:44 2026**, PID **47228**. Pass run is a **later** session PID **14668** 18:12:36–38. `run_xsim.ps1:101-104` copies r0 only if absent — pass run did not wipe it.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 18:12:36–18:12:38 2026**, PID **14668**, snapshot `a06r3ms`, `$finish` at **20975 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
TWO_PICK_A st=0 npath=2 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 capn=2 occ=1 capf=0 vicv=0 vici=0 vict=255 ls=0 nref=0 nevict=0 nrlauto=0 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=0 s1c=0 s1txn=0 s1phi=0 s1w0=0 s1ans=0x00000 s1p0=0x00000
PASS TWO_PICK_A
TWO_PICK_B st=0 npath=2 ans=0xa0c55 p0=0xa0111 acc=1 cmt=0 txn=2 gen=2 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=1 vicv=0 vici=0 vict=255 ls=1 nref=0 nevict=0 nrlauto=0 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS TWO_PICK_B
RST_LIVE st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=0 nbad=0 w0=0 phi0=0 ost=0 tbl=0 capn=2 occ=2 capf=1 vicv=0 vici=0 vict=255 ls=0 nref=0 nevict=0 nrlauto=0 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS RST_LIVE_CLEAR
RELOAD_A st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 capn=2 occ=2 capf=1 vicv=0 vici=0 vict=255 ls=0 nref=0 nevict=0 nrlauto=0 nrlcmd=1 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS RELOAD_A
REW_A_ONLY st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=0 nbad=0 w0=-5 phi0=50 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=0 vict=1 ls=0 nref=0 nevict=0 nrlauto=0 nrlcmd=1 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS REW_A_ONLY
MIX_B_WHILE_A st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=1 nbad=0 w0=-5 phi0=50 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=0 vict=1 ls=0 nref=0 nevict=0 nrlauto=0 nrlcmd=1 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS MIX_B_WHILE_A
RELOAD_B st=1 npath=0 ans=0xa0c55 p0=0xa0111 acc=1 cmt=0 txn=2 gen=2 ep=7 nupd=1 nstale=1 nbad=0 w0=0 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=0 vict=1 ls=1 nref=0 nevict=0 nrlauto=0 nrlcmd=2 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS RELOAD_B
REW_B_ONLY st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=2 gen=2 ep=7 nupd=2 nstale=1 nbad=0 w0=-4 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=0 vict=1 ls=1 nref=0 nevict=0 nrlauto=0 nrlcmd=2 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=1 s1txn=2 s1phi=40 s1w0=-4 s1ans=0xa0c55 s1p0=0xa0111
PASS REW_B_ONLY
TWO_COMMIT_ROWS st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=2 gen=2 ep=7 nupd=2 nstale=1 nbad=0 w0=-4 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=0 vict=1 ls=1 nref=0 nevict=0 nrlauto=0 nrlcmd=2 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=1 s1txn=2 s1phi=40 s1w0=-4 s1ans=0xa0c55 s1p0=0xa0111
PASS TWO_COMMIT_ROWS
THIRD_EVICT st=0 npath=1 ans=0xa0d66 p0=0xa0311 acc=1 cmt=0 txn=3 gen=3 ep=7 nupd=2 nstale=1 nbad=0 w0=-4 phi0=30 ost=0 tbl=0 capn=2 occ=2 capf=0 vicv=1 vici=1 vict=2 ls=0 nref=0 nevict=1 nrlauto=0 nrlcmd=2 s0v=1 s0c=0 s0txn=3 s0phi=30 s0w0=0 s0ans=0xa0d66 s0p0=0xa0311 s1v=1 s1c=1 s1txn=2 s1phi=40 s1w0=-4 s1ans=0xa0c55 s1p0=0xa0111
PASS THIRD_EVICT
CAP_FULL_UNC st=0 npath=2 ans=0xa0c55 p0=0xa0111 acc=1 cmt=0 txn=2 gen=2 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=1 vicv=0 vici=0 vict=255 ls=1 nref=0 nevict=0 nrlauto=0 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS CAP_FULL_UNC
REFUSE_ALL_UNC st=0 npath=1 ans=0xa0d66 p0=0xa0311 acc=0 cmt=0 txn=2 gen=2 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=40 ost=0 tbl=0 capn=2 occ=2 capf=1 vicv=0 vici=0 vict=255 ls=1 nref=1 nevict=0 nrlauto=0 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=2 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS REFUSE_ALL_UNC
UNREL_PRE st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 capn=2 occ=1 capf=0 vicv=0 vici=0 vict=255 ls=0 nref=0 nevict=0 nrlauto=1 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=0 s1c=0 s1txn=0 s1phi=0 s1w0=0 s1ans=0x00000 s1p0=0x00000
UNREL st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 capn=2 occ=1 capf=0 vicv=0 vici=0 vict=255 ls=0 nref=0 nevict=0 nrlauto=1 nrlcmd=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=0 s1c=0 s1txn=0 s1phi=0 s1w0=0 s1ans=0x00000 s1p0=0x00000
PASS UNREL_NO_STALE
ASTRA_06_R3_MULTI_SLOT_XSIM_PASS
$finish called at time : 20975 ns : File ".../tb_astra_06_r3_multi_slot.sv" Line 418
```

Marker **present**. Zero `FAIL` lines on the pass log (grep). `tbl=0` on every dump. `capn=2` on every dump.

### Raw fail r0 `xsim_fail_r0.log`

```text
REW_A_ONLY ... s0c=1 s0w0=-5 s1c=0 s1w0=0 s1phi=40
PASS REW_A_ONLY
MIX_B_WHILE_A ... nstale=1 nbad=0 s0w0=-5 s1w0=0 s1c=0
FAIL MIX_B_WHILE_A
ASTRA_06_R3_MULTI_SLOT_XSIM_FAIL n=1 first=MIX_B_WHILE_A
$finish called at time : 20975 ns : File ".../tb_astra_06_r3_multi_slot.sv" Line 418
Exiting xsim at Sun Sep  6 18:11:44 2026
```

All other tags on r0 already PASS (ISO, TWO_PICK, RST_LIVE, RELOAD_A/B, REW_A_ONLY, REW_B_ONLY `s1w0=-4`, TWO_COMMIT_ROWS `vicv=1 vici=0 vict=1`, THIRD_EVICT `nevict=1` s0 txn=3 / s1 B remains, REFUSE_ALL_UNC `nref=1`, UNREL). Isolation fields on MIX already matched the pass dump **byte-for-byte** (`nstale=1 nbad=0 s0w0=-5 s1w0=0 s1c=0 s1phi=40`). Discriminator is TB mix-class (`nbad++` required vs F2R `rew_gen != pend_gen` → `nstale`), not a relaxed golden of w0/phi/eids/CAP_N/victim.

---

## Hunt 1 — CAP_N≥2 actual array of persist rows, not N=1 renamed?

`.svh` `A7NG_A06R3_CAP_N=2`. DUT `parameter CAP_N` is used: occupancy loop `for (kj = 0; kj < CAP_N; kj++)` counts `occ_n` / `occ_cmt`, selects free index and lowest-txn committed victim, `cap_full = (occ_n == CAP_N) && (occ_cmt == 0)`, `inst_evict = (occ_n == CAP_N) && has_vic`, persist_clr walks `si < CAP_N` (`r3:321`, `:383-411`, `:490-503`). `cap_n_o = 8'(CAP_N)`. Raw log `capn=2`.

Storage is two independent rows:

```text
ps_valid/ps_acc/ps_cmt/ps_txn/ps_w/ps_phi/ps_ans/ps_p0/ps_p1 [0:1]
```

(`r3:210-224`). Not a single `{p_*}` register file with `CAP_N` painted on the port. Observe ports `s0_*` / `s1_*` read `ps_*[0]` / `ps_*[1]` (`:327-346`). SGD commit writeback hits **only** `ps_w[live_slot]` / `ps_cmt[live_slot]` (`:529-532`). New install **zeros** that slot’s `ps_w` (`:524-527`) — R2 leftover-`p_w` on evict is **not** repeated here.

Raw log two distinct tuples:

| Dump | occ | s0 | s1 |
|------|-----|----|----|
| TWO_PICK_A | 1 | txn=1 phi=50 p0=0xa0011 ans=0xa00b4 w0=0 cmt=0 | invalid |
| TWO_PICK_B | 2 | **unchanged** txn=1 phi=50 p0=0xa0011 | txn=2 phi=40 p0=0xa0111 ans=0xa0c55 w0=0 cmt=0 |
| TWO_COMMIT_ROWS | 2 | txn=1 phi=50 w0=-5 cmt=1 | txn=2 phi=40 w0=-4 cmt=1 |

Hygiene (not a rename cheat): arrays are hardcoded `[0:1]`, not `[0:CAP_N-1]`; `obs_sel = (slot_sel_i==1) ? 1 : 0` (`:290`) clamps any other `slot_sel` to slot 0. Changing `CAP_N` to 3 without widening the arrays would not add a third row. For **this bag** `CAP_N=2` the store is an actual two-row array.

R3 does **not** wrap/instantiate frozen persist DUT (handoff parent note said wrap; work order required a new named DUT and “do not patch persist”). Same additive pattern as R2. Frozen persist remains a single-slot file. Not N=1 renamed.

**Finding:** hunt **1 CLOSED_NARROW**. On-chip persist is a real N=2 row array with independent `{txn,phi,20-bit eids,w}`. Not Master DDR index N>1. Not a fully parameterized `CAP_N` generator.

---

## Hunt 2 — two commits, rst+reload, delayed rew A vs B do not mix; fail r0 MIX_B_WHILE_A DUT or TB-only?

Law (PREREG + ISO): plant A phi0=50, rew=-3, w=0 → dw0=-5; plant B phi0=40, rew=-3, w=0 → dw0=-4; ISO +3,x0=50 → dw0=+5.

RTL: matching reward in S_IDLE/S_HOLD walks F2R handshake (`rew_gen != pend_gen` → `nstale`; `rew_txn != pend_id` → `nbad`) then `S_UW`; persist writeback is `ps_w[live_slot]` only (`:600-614`, `:855-868`, `:529-532`). Reload copies `rl_slot` into live pending + SGD walk + `live_slot <= rl_slot` (`:883-901`).

Raw log (w0/txn per slot):

```text
REW_A_ONLY     nupd=1  s0c=1 s0txn=1 s0w0=-5 s0phi=50 ; s1c=0 s1txn=2 s1w0=0  s1phi=40
MIX_B_WHILE_A  nstale=1 nbad=0  s0w0=-5 s0c=1 ; s1w0=0 s1c=0 s1phi=40   (B ids while live A)
RELOAD_B       nrlcmd=2 nrlauto=0 live txn=2 phi=40 ans=0xa0c55 ls=1 ; s0 still w0=-5 cmt=1
REW_B_ONLY     nupd=2  s1c=1 s1txn=2 s1w0=-4 s1phi=40 ; s0c=1 s0txn=1 s0w0=-5 s0phi=50
TWO_COMMIT_ROWS occ=2 both cmt ; distinct tuples
RST_LIVE_CLEAR  live w0=0 acc=0 ; both rows still valid 20-bit (restore_en=0, nrlauto=0 nrlcmd=0)
RELOAD_A        nrlcmd=1 nrlauto=0 live txn=1 phi=50 ans=0xa00b4 ls=0
```

Delayed B-ids while live A increment `nstale`, **do not** write slot B (`s1w0` stays 0, `s1c` stays 0) and **do not** disturb slot A (`s0w0=-5`). After reload B, delayed matching B commits only B (`s1w0=-4`) and A stays `-5`.

Fail r0 MIX dump is **identical** to the pass MIX dump (`nstale=1 nbad=0 s0w0=-5 s1w0=0 s1c=0`). r0 FAIL is the TB requiring `nbad++` while DUT F2R law counts `rew_gen != pend_gen` as **stale** (epoch same, gen 2 vs live 1; txn check is later). Pass TB `chk("MIX_B_WHILE_A", ((nbad>nbad0) || (nstale>nstale0)) && !s1c && (s1_w0===0) && … && (s0_w0===-5))` (`tb:353-354`). Isolation predicates **unchanged**. DUT RTL hash is only frozen on the pass run; r0 already exhibited two rows, `s0w0=-5` / `s1w0=0` on MIX, `s1w0=-4` after REW_B, `nevict=1` victim txn=1 — consistent with current DUT, not a post-fail DUT rewrite.

PREREG MIX line already allows `nstale++ or nbad++`. PREREG hash exists only on the **pass** freeze (18:12:31, after r0 18:11:44), so a PREREG wording tweak between r0 and pass cannot be independently excluded. Isolation fields on r0 already satisfied the work-order unknown. Not a golden-vector edit of w0/phi/eids/CAP_N/victim.

**Finding:** hunt **2 CLOSED**. Mix does not cross slots. Fail r0 `MIX_B_WHILE_A` fix is **TB-only** (mix-class `nstale || nbad`). DUT not changed on the corrective.

---

## Hunt 3 — third commit/PICK evicts oldest/lowest txn; victim quoted?

Written policy: victim = oldest committed / lowest txn among committed rows (tie → lowest index). Uncommitted rows are never victims. `has_vic` only if `ps_cmt[kj]`; min `ps_txn` then min index (`r3:394-401`). `inst_idx = has_free ? free_idx : vic_idx` (`:411`). S_PICK on evict: `n_cap_evict++` then install (`:828-831`). Install zeros that slot’s `w` (`:524-527`).

Work-order phrase “third commit” is implemented as **third PICK** after two committed rows (PREREG `THIRD_EVICT`: plant C, third PICK → victim replaced with uncommitted C). Occupancy-full eviction is the install event, not a third SGD commit. C remains `cmt=0` after evict.

Victim **quoted before** the third PICK:

```text
TWO_COMMIT_ROWS vicv=1 vici=0 vict=1   s0txn=1 s0w0=-5 cmt=1 ; s1txn=2 s1w0=-4 cmt=1
THIRD_EVICT     nevict=1 s0c=0 s0txn=3 s0p0=0xa0311 s0ans=0xa0d66 s0w0=0
                s1c=1 s1txn=2 s1w0=-4 s1ans=0xa0c55 s1p0=0xa0111
                vicv=1 vici=1 vict=2   (combinational victim of remaining committed B)
```

Victim of the eviction event = txn **1**, idx **0** (quoted on TWO_COMMIT_ROWS). After replace, current victim is remaining committed B (txn 2, idx 1). Slot B weights/eids **unchanged**. New slot 0 is C uncommitted with `s0w0=0` (no leftover A weights). `n_persist` stays 2.

Refuse path (separate wipe): two uncommitted, third PICK `nref=1` `acc=0` rows unchanged txn 1/2 p0 A/B `nevict=0`. Retrieval still reports C’s ANSWER (`ans=0xa0d66`) — fail-closed learning, same class as R2 refuse.

**Finding:** hunt **3 CLOSED_NARROW**. Victim txn=1 idx=0 quoted; third PICK evicts that row; B remains. Not DDR index eviction. Lowest-txn is the age proxy; txn-wrap / LRU-age counter untested. Mixed occupancy (1 committed + 1 uncommitted, third PICK) untested.

---

## Hunt 4 — high-bit eids ≥256 still?

TB plants 20-bit fact graphs, not an 8-bit parse path (`tb:8-28`, `:212-244`):

```text
HID_P0A=20'hA0011  HID_ANSA=20'hA00B4
HID_P0B=20'hA0111  HID_ANSB=20'hA0C55
HID_P0C=20'hA0311  HID_ANSC=20'hA0D66
```

`0xA0011 = 655377 ≥ 256`; bits[19:8] = `0xA00` ≠ 0. Persist/proof IDs are `[19:0]` (`r3:222-224`, `:106-108`, `:53-55`). Grep: **no** `[7:0]` slice on persist/proof eids. `ps_ans[inst_idx] <= c_best_a` copies 20-bit (`:521-523`). Reload copies `ps_ans/ps_p0/ps_p1` onto live HOLD (`:895-897`).

Raw:

```text
TWO_PICK_A     s0ans=0xa00b4 s0p0=0xa0011 ans=0xa00b4 p0=0xa0011
TWO_PICK_B     s1ans=0xa0c55 s1p0=0xa0111 ; s0 still 0xa00b4/0xa0011
RST_LIVE       persist still 20-bit both rows; live ans=0 (rst, restore_en=0)
RELOAD_A       live ans=0xa00b4 p0=0xa0011
RELOAD_B       live ans=0xa0c55 p0=0xa0111 ; s0 persist still 0xa00b4/0xa0011
THIRD_EVICT    s0ans=0xa0d66 s0p0=0xa0311 (bits[19:8]=0xA03)
```

An 8-bit store would have printed `p0=0x00011` / `ans=0x000b4`. After delayed SGD, live HOLD `ans=0` because `S_IDLE` forces `r_st<=ST_UNKNOWN` and `S_HOLD` with `np==0` zeros proofs (`:577`, `:852-854`) — persist rows stay 20-bit. Same class as R2 post-SGD HOLD wipe, not truncation.

`load_from_tb_o=1'b0` (`:231`); every dump `tbl=0`. `poke_v_i=1'b0` (`:456`). Queries are `send_text("pump requires indirect")` / `"payroll tax form"`.

**Finding:** hunt **4 CLOSED_NARROW**. eids ≥256 on persist rows **and** restore proof ports for A and B; C also 20-bit. Not Full32 DDR schemaV2; QSE entities remain 8-bit.

---

## Hunt 5 — overclaim DDR / N>1 DDR index / BOARD?

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 20975 ns, PASS tags, dump fields (`capn`/`occ`/`s0w0`/`s1w0`/`vict`/`nevict`/`nref`/`nrlcmd`/`tbl`) match. RESULTS is **not** used as evidence. RESULTS omits THIRD_EVICT leftover **live** `w0=-4` (persist `s0w0=0`) — incomplete, not a false PASS. |
| Editing goldens to PASS | **Not found.** r0 vs pass: same w0/phi/eids/CAP_N/victim integers; only MIX class accepts `nstale \|\| nbad`. Isolation already held on r0. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0`. Every dump `tbl=0`. `poke_v_i=1'b0`. Queries are tokens. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). |
| Hash theatre / hash after scores | Freeze **18:12:31** is before xsim **18:12:36–38**. POST **18:12:38** matches compiled bytes. `.svh` in PRE. TB hash PRE=POST `80968ef9…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| DDR / MIG / QSPI / NVM | **Not claimed closed.** ACK `does_not_close` + PREREG + CLOSEOUT list `persistence_DDR`, `NVM_QSPI_journal`, `index_eviction_DDR_N_gt_1`. DUT has no MIG/QSPI/DDR persist port. AXI is retrieval only. On-chip no-reset FF array. |
| Master F3 10pp / LM06 / BOARD / ASTRA-13 | **Not claimed closed.** |
| N>1 DDR index eviction | **Not claimed closed.** ACK `index_eviction_DDR_N_gt_1`. This bag is on-chip persist rows N=2. |
| Master ASTRA-06 as a whole | **Not claimed closed.** ACK `gate_claim` and RESULTS “Open (unchanged): Master ASTRA-06 as a whole”. Implementer `PASS_NARROW (this gate only: on-chip persist CAP_N=2)`. |
| Persist DUT patched | **Not found.** Provenance SHA `52ebde52…` = persist-bag compiled DUT. Live persist `S_RELOAD` still omits HOLD eids. R3 work dir has no persist `.sdb`. |
| R2 DUT patched | **Not found.** Provenance SHA `c671f98b…` = R2-bag compiled DUT. Live R2 `CAP_N` still unused; `.svh` still N=1. |
| F2R / F3 / persist / R2 bag wipe | **Not found.** Prior `xsim.log` session headers unchanged. |
| Naming `ASTRA-06-R3` | **Scope risk, not RESULTS overclaim.** Parent must not promote the filename to Master ASTRA-06 CLOSED. |

**Finding:** **not OVERCLAIM** on the stated bag gate. Master ASTRA-06 / DDR / DDR-index N>1 / BOARD remain OPEN as claimed.

---

## Hunt 6 — PROGRAM=NO; hashes include .svh before xvlog?

`ACK.json`: `"PROGRAM": false`, `"jtag": "NO_CALLS"`. CLOSEOUT `BIT=NOT_BUILT PROGRAM=NO`. metrics `"program": false, "bitstream": false`. Bag listing: no `.bit` / `.bin` / program log / `TIMING_EXTRACT.txt`. `run_xsim.ps1` is xvlog/xelab/xsim only.

`.svh` in PRE `TRANSITIVE_INCLUDES` (`a7ng_astra_06_r3_multi_slot.svh` + crc + both lexicons) written at 18:12:31 **before** xvlog (`run_xsim.ps1:37-73`).

LOOP_STATE `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`, `jtag=NO_CALLS`. This auditor did not open COM12 / JTAG `210319BE776EA`.

**Finding:** PROGRAM=NO. `.svh` hashed before xvlog. No bitstream in this bag.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated **bag** gate. Checks that are **weaker than the dump** and must not be mistaken for extra proof:

1. **Work-order “third commit”** is a **third PICK** after two commits (PREREG). C is uncommitted after evict (`s0c=0`). Do not read THIRD_EVICT as a third SGD commit or as three committed snapshots.
2. **TWO_COMMIT_ROWS `vict=1 vici=0`** is the combinational victim of current occupancy (quoted). After THIRD_EVICT the dump’s `vici=1 vict=2` is the **new** remaining committed B, not a rewrite of the evicted victim id. Evicted victim is inferred from pre-quote + `s0` replacement + `nevict=1`.
3. **THIRD_EVICT live `w0=-4`** is leftover live SGD from B. Persist `s0w0=0`. Scoring plant C used leftover B weights. Delayed-rew-on-C-after-evict is **untested**. Do not read live `w0=-4` as C’s persisted weights.
4. **MIX `nstale` vs `nbad`** is F2R handshake class, not slot isolation. Isolation is `s1w0=0 s1c=0` / `s0w0=-5`. TB OR is not a tautology of those fields.
5. **RST_LIVE_CLEAR** uses `restore_en=0`. Independent restore of two rows is **explicit** `reload_i` + `slot_sel_i`. Auto `need_rl` with two occupied slots is untested (UNREL_PRE auto-reloads a single occupied slot, `nrlauto=1`).
6. **UNREL_NO_STALE** does not require `pend_acc=0`. Dump `acc=1` is leftover pending (same class as persist/R2). Proof ports are the hunt (`ans=0 p0=0 tbl=0`).
7. **REFUSE_ALL_UNC** still reports ANSWER `ans=0xa0d66` with `acc=0`. Learning fail-closed; retrieval not refused.
8. **`CAP_N` arrays `[0:1]`** are N=2, not a parameterized N-entry generator. Do not rename this Master DDR index eviction.
9. **s0/s1 observe ports** are DUT outputs of the real array, not TB-poked persist state. Still not DDR.
10. **On-chip no-reset FFs** are **not** board power-loss and **not** DDR-across-BRAM-loss.
11. **Persist DUT not instantiated.** New named fork, frozen persist unpatched. Do not claim “wrapped persist DUT” as compiled evidence.
12. ISO `viso=0` is an isolated `go_upd` without a prior displayed score; `w0=5` is the law check.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify the work-order unknown on this bag’s tests.

Residuals (not P1 for this gate):

1. **Not Master ASTRA-06 (schemaV2 DDR / DDR index N>1 / DDR warm persist / NVM) — 0/10 as this bag, 9/10 if parent ticks Master ASTRA-06 CLOSED.** On-chip CAP_N=2. No CRC A-B journal. No MIG/QSPI.

2. **Slot arrays hardcoded `[0:1]`, `obs_sel` clamps to {0,1} — 3/10 hygiene, 0/10 as this TB (`CAP_N=2`).** `r3:210-224`, `:290`. Changing `CAP_N` would not add rows.

3. **Persist DUT not instantiated (integrator fork) — 2/10 architecture vs parent “wrap” note, 0/10 vs work-order “new named DUT / do not patch persist”.** Frozen persist SHA `52ebde52…` unpatched.

4. **Evict-install does not reset live SGD weights — 4/10 hygiene, 1/10 as this TB.** THIRD_EVICT live `w0=-4` under new C pending; persist `s0w0=0`. Restore-after-evict / delayed-rew-on-C untested.

5. **Victim = lowest txn, not LRU/age; txn wrap untested — 2/10.** `TXN_MAX=255`. This TB txn 1 then 2.

6. **Mixed occupancy eviction (1 committed + 1 uncommitted, third PICK) untested — 2/10 as residual, 0/10 as this unknown** (work order is two commits then third install).

7. **Auto `need_rl` with two occupied rows untested — 2/10.** Explicit `reload_i` per `slot_sel` is the tested independent restore.

8. **Foreign schema VER not retested this bag — 0/10 as this unknown** (R2 CLOSED_NARROW; `schema_poke_i` still present `r3:505-506`).

9. **Post-reload HOLD proof wipe after SGD — 2/10 hygiene.** Restore dumps still 20-bit. Persist dumps stay 20-bit.

10. **`schema_poke_i` can rewrite journal VER whenever `persist_en_i=1` — 2/10 test-hook.** Documented. Not a weight poke.

11. **UNREL leaves `pend_acc=1` — 3/10.** Same class as F2R UNKNOWN not retiring. Not a stale proof.

12. **QSE entities remain 8-bit — 0/10 as this high-id hunt** (proof/fact eids were the target), **8/10 if renamed Full32 subject persistence.**

13. **Host `sess_id_i` reuse after `rst_n` without restore — 0/10 as this gate (documented OPEN).**

14. **On-chip no-reset FFs are not board power-loss — 0/10 as this modeled gate, 9/10 as silicon durability.**

15. **Copied F2R5 semantic/drain FSM not re-audited here — 3/10 as residual, 0/10 as this unknown.** Smoke+UNREL+high-id plant only. Items 4/5 remain closed on the F2R3/F2R4 bags.

16. **Persist SGD writeback gated by `persist_en_i` (`:504`, `:529-532`) — 1/10 as this TB** (stays 1). Dropping `persist_en` mid-update would skip slot commit.

No remaining **demonstrated** P1 that falsifies the work-order tests.

---

## ASTRA-06 this bag vs Master ASTRA-06 (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| Work-order unknown (CAP_N≥2 two distinct snapshots, independent restore, delayed rew A≠B, third-PICK evict lowest-txn victim, refuse all-uncommitted, high-bit eids, ISO +5, UNREL) | **CLOSED (narrow)** on **ASTRA-06-R3-MULTI-SLOT-01 only** | Raw log: two rows `s0 txn=1 w0=-5 p0=0xa0011` / `s1 txn=2 w0=-4 p0=0xa0111`; MIX `nstale=1` s1 still 0; `RELOAD_A/B` distinct; `TWO_COMMIT vict=1 vici=0`; `THIRD_EVICT nevict=1` s0=C s1=B; `REFUSE nref=1`; ISO `w0=5`; UNREL `ans=0 p0=0 tbl=0`. |
| Auditor 1125Z leftover **N>1 persist slots** | **CLOSED_NARROW** | On-chip CAP_N=2 row array. Not DDR index N>1. |
| Auditor 1125Z R2 high-id / `reload_i` / persist N=1 | **still CLOSED_NARROW**; **not re-opened** | Frozen R2 SHA match; bag xsim session untouched. High-id still ≥256 on this DUT. |
| Persist bag ASTRA-06-WARM-PERSIST-01 | **still CLOSED_NARROW** (0945Z); **not re-opened** | Frozen DUT SHA match; bag xsim session untouched. |
| Master ASTRA-06 **pending/commit** | **PARTIAL** | Two committed on-chip rows + single-issue live pending. Not a DDR commit store. |
| Master ASTRA-06 **full-ID schema** | **PARTIAL (narrow)** | 20-bit persist/proof with bits[19:8] tested on two slots. Parser still 8-bit. Not Full32 DDR schemaV2. |
| Master ASTRA-06 **migration** | **PARTIAL (narrow, inherited R2)** | On-chip schema byte exists; foreign VER not retested here. Not schemaV2 DDR store migration. |
| Master ASTRA-06 **capacity/eviction** | **PARTIAL (narrow)** | On-chip persist N=2 oldest-committed/lowest-txn. **DDR / index N>1 still OPEN.** |
| Master **warm persistence** (DDR retention across BRAM loss) | **OPEN** | Not this experiment. |
| Master **power-loss durability** (NVM checkpoint/journal) | **OPEN** | Not QSPI/SD, no CRC/generation/wear. |
| F3 / LM06 / BOARD / ASTRA-13 | **OPEN** | Not claimed. |
| F2R items 1–6 / persist modeled journal / R2 N=1 | **not re-opened** | Frozen files unpatched. Prior auditor grades stand. |

Narrow = XSim TB-planted AXI 20-bit fact graph + modeled `rst_n` (not chip POR, not BRAM kill, not NVM) + on-chip persist CAP_N=2 (not DDR index N>1) + one TB mix-class corrective after fail r0. Not Master ASTRA-06, not F3, not LM06, not BOARD, not a patch of live persist DUT / R2 DUT / F2R5.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_06_r3_multi_slot.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_06_warm_persist.sv` / `.svh` | **Not patched.** Hash `52ebde52…` / `cad5e606…` matches persist-bag compiled DUT. Not in R3 snapshot. Live `S_RELOAD` still omits HOLD eid restore. No `ps_*` array / `n_cap_*`. |
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | **Not patched.** Hash `c671f98b…` / `4e96067c…` matches R2-bag compiled DUT. `CAP_N` still unused; `.svh` still N=1. |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | **Not patched.** Hash `41c77e76…` / `1db76fcc…`. |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | **Not patched.** Hash `5cdb3da8…` / `94887bd4…`. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…`. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | **Not patched.** Hash `d12144a99…` / `9f0e5dbd7…`. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-01 / F2R-R5 / F3R4 / ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-06-R3-MULTI-SLOT-01`

Narrow = work-order leftover N>1 **on-chip persist slots**: raw log CAP_N=2 actual two-row array (`TWO_PICK_A` occ=1 / `TWO_PICK_B` occ=2 s0 unchanged); independent restore after rst (`RELOAD_A` txn=1 phi=50 ans=0xa00b4; `RELOAD_B` txn=2 phi=40 ans=0xa0c55); delayed rew A `s0w0=-5` leaves `s1w0=0`; MIX B-ids while live A `nstale=1` does not write B; delayed rew B `s1w0=-4` leaves `s0w0=-5`; TWO_COMMIT victim quoted `vict=1 vici=0`; THIRD_EVICT `nevict=1` s0=C txn=3 p0=0xa0311 w0=0, s1 still B w0=-4; refuse all-uncommitted `nref=1`; high-bit eids `0xa00b4/0xa0011` and `0xa0c55/0xa0111` bits[19:8]≠0; ISO +5; UNREL no stale proof IDs; fail r0 preserved with **TB-only** mix-class corrective, no golden edits of w0/phi/eids/CAP_N/victim; persist DUT SHA `52ebde52…` and R2 DUT SHA `c671f98b…` unpatched. Not Master ASTRA-06 (schemaV2 DDR / DDR index N>1 / DDR warm persist / NVM), not F3, not LM06, not timing, not BOARD_PASS, not host `sess_id` reuse without restore, not a patch of live persist DUT / R2 DUT.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this on-chip persist CAP_N=2 bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (hardcoded `[0:1]` arrays, persist DUT not instantiated, leftover live SGD `w0` after evict, lowest-txn≠LRU, mixed-occupancy eviction untested, auto-reload of two rows untested, post-SGD HOLD proof wipe, `schema_poke` test hook, QSE 8-bit entities, Master ASTRA-06 still OPEN) are **not** P1 for this gate.

Parent: treat auditor **1125Z leftover N>1 persist slots** as CLOSED narrow on **this bag only**. Do **not** tick Master ASTRA-06 CLOSED. Do not reopen the persist modeled-journal bag, R2 high-id/`reload_i`/N=1, F2R2 handshake, F2R3 semantic-guard, F2R4 drain, F2R5 wrap/reset, or F3R4 unique-HASH bags. Do not treat this as F3/LM06/BOARD/DDR/QSPI/DDR-index N>1. Preserve F2R-*, F3*, ASTRA-06-WARM-PERSIST-01, ASTRA-06-R2-EVICT-HIGHID-01, and this bag. Do not rerun those `run_*.ps1` in a way that wipes `xsim.log` / `xsim_fail_r0.log`. Next Master ASTRA-06 leftover is schemaV2 DDR store / DDR index N>1 eviction / DDR-across-BRAM-loss / NVM journal **or** host `sess_id` reuse-without-restore **or** the LM06/BOARD queue — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of Master ASTRA-06 (full: migration + DDR/index N>1 eviction + schemaV2 DDR + DDR warm persist + NVM) / Master F3 / LM06 / BOARD / COM12 / DDR/MIG production persistence / QSPI journal / host `sess_id_i` reuse after `rst_n` without restore / live persist-DUT or R2-DUT patch remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

ASTRA-06 **this bag** = **CLOSED_NARROW** (on-chip persist CAP_N=2: two distinct committed rows, independent reload, delayed-rew isolation, lowest-txn victim evict, refuse all-uncommitted, 20-bit high-id).  
ASTRA-06 **Master** = **OPEN** (on-chip N>1 persist-slot **narrow-closed here**; DDR / DDR index N>1 / NVM / Full32 schemaV2 still OPEN).

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1200Z\REPORT.md  ACCEPT_PARTIAL  ASTRA-06-R3 bag=CLOSED_NARROW (on-chip persist CAP_N=2) / Master ASTRA-06=OPEN
