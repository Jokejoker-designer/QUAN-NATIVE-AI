# ASTRA auditor REPORT — 20260906T1125Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA06_R2_EVICT_HIGHID_INDEPENDENT_AUDIT; astra06_r2=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; master_astra06=OPEN
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-06 (§5 Transaction/storage + §7 table) + work order ASTRA-06-R2-EVICT-HIGHID-01 + auditor 20260906T0945Z residuals 2, 7, capacity
EVIDENCE   = raw xsim.log / xsim_fail_r0.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_xsim.ps1`, `run_f2r*.ps1`, or persist-bag scripts. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the persist-bag / F2R2–F2R5 / F3* freezes (overlapping hashes). Claimed `xsim.log` / `xsim_fail_r0.log` SHAs in `metrics.json` / CLOSEOUT are **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-06-R2-EVICT-HIGHID-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_06_r2_evict_highid.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_06_r2_evict_highid.svh`. TB `tb_astra_06_r2_evict_highid.sv` (bag-local).

Gate under review is **auditor 20260906T0945Z residuals 2, 7, and capacity/eviction** on a **new named** DUT — not a patch of frozen persist DUT `a7ng_astra_06_warm_persist.sv`:

1. Persist and proof ports store 20-bit eids with bits[19:8] nonzero (claimed `ans=0xa00b4 p0=0xa0011 p1=0xa0022`). After restore, persist_* and proof ports still 20-bit?
2. `reload_i` distinct from auto `need_rl` (`n_rl_cmd` vs `n_rl_auto`)? Delayed matching reward `w0=-5`?
3. Capacity N=1: refuse uncommitted (`n_cap_ref`) and evict committed (`n_cap_evict`) — one persist snapshot?
4. Foreign VER does not restore live weights?
5. Fail r0 preserved; TB goldens not edited?
6. Overclaim DDR / N>1 index / Master ASTRA-06 / BOARD?
7. PROGRAM=NO in ACK; no bitstream.

Judged against:

1. Work order `.agents/handoff/ASTRA-06-R2-EVICT-HIGHID-01.md` + PREREG written policy `REFUSE_UNCOMMITTED_EVICT_COMMITTED`.
2. Auditor `20260906T0945Z`: persist bag **CLOSED_NARROW**; Master ASTRA-06 **OPEN** (high-bit IDs untested, `reload_i` untested, capacity/eviction OPEN, schemaV2/migration OPEN, DDR OPEN).
3. **Master ASTRA-06** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7 table + §5): pending/commit, **full-ID schema**, **migration**, **capacity/eviction**, and **warm persistence on chosen state architecture**. Master text: *“Full32 subject/object persistence schemaV2 is reusable with version/migration checks. No low8/low16 identity authority. DDR retention across BRAM loss is warm persistence; power-loss durability requires separately tested nonvolatile checkpoint/journal.”*

**Master ASTRA-06 as a whole is not this bag’s close**, even if compact XSim tags all PASS and the DUT is named `a7ng_astra_06_r2_evict_highid`.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, Master F3 10pp/CI, MIG/DDR production persistence, ASTRA-07 index image, QSPI/SD NVM journal, host `sess_id` reuse after `rst_n` without restore, schemaV2 DDR store, multi-slot N>1 index eviction, BRAM-kill-with-DDR-retained warm persist.

Frozen `a7ng_astra_06_warm_persist.sv` / `.svh`, `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv` must remain **unpatched**. This DUT is a **new named** integrator plus persist-slot policy / schema byte / reload counters.

Prior bags ASTRA-06-WARM-PERSIST-01 / F2R-* / F3* are **not** this evidence and must not have been rewritten.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T17:43:19.3021271+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T17:43:26.1606865+07:00` (matches raw pass-log exit `Sun Sep 6 17:43:26 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog (`run_xsim.ps1:37-71`). `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_06_r2_evict_highid.svh`.

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
| `rtl/native_graph/integrate/a7ng_astra_06_r2_evict_highid.sv` | `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` |
| `.../tb_astra_06_r2_evict_highid.sv` | `329562cbd421da0dd98b71144885c12dc4db02fefe4159e0d23d729a2941cd9b` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_06_r2_evict_highid.svh` | `4e96067cce0672189230dc6f79598c452ba4c13ef6ad62e8018b8d199060ff68` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `bd53f7d2b7b8c434392a556107d9680cf90b0f19be9831e68104af85c7f5c652` |
| `ACK.json` | `6ae9bac52406ea0385547a3896a0bdf6fd7fc51923c9a763beb29062367460cf` |
| `run_xsim.ps1` | `43c615f2356646b1f85914738eea08b110221b17e6ec717bfe1624ff400fd12f` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt | vs prior freeze |
|------|------------|-----------------|
| `a7ng_astra_06_warm_persist.sv` / `.svh` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` / `cad5e606fe1cd9c1b378931714581a6ad5ed9d7fcce8b2643059d4d42fb7db21` | persist-bag **compiled DUT** identical |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | `d12144a99…` / `9f0e5dbd7…` | F3R4 compiled DUT identical |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | `41c77e76f…` / `1db76fcc0…` | F2R5 compiled DUT identical |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…` | compiled here; identical to persist/F2R2 freeze |
| `a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b5…` | floor-shift file, not compiled |

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R2 DUT has `reload_i`, `schema_i`/`schema_poke_i`, persist 20-bit `p_ans/p_p0/p_p1`, `n_rl_auto`/`n_rl_cmd`, `n_cap_ref`/`n_cap_evict`, `n_schema_rej`, `keep_proof`, two-domain persist (`a7ng_astra_06_r2_evict_highid.sv:26-28`, `:106-115`, `:179`, `:185`, `:258-272`, `:366-403`, `:445-463`, `:674-706`, `:745-763`).
- Live persist DUT still has **no** `n_rl_cmd` / `n_cap_*` / `schema_poke` / `keep_proof`. `S_RELOAD` still copies pending key/phi/weights only — **not** `p_ans` onto live HOLD (`a7ng_astra_06_warm_persist.sv:697-710`). `reload_i` pin still exists (`:24`, `:422-424`) and was the 0945Z untested residual. **Not patched.** Manifest SHA `52ebde52…` matches persist-bag compiled DUT.
- Live F2R5 still has **no** persist ports. Hash `41c77e76…`. **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`). Instantiated read-only (`r2:359-364`, `freeze_i=1'b0`).
- Live pass TB `$finish` at line **372** — raw pass log cites that line. Fail r0 `$finish` at line **365**.
- `.svh` exists at freeze path; `A7NG_A06R2_CAP_N=1`, `A7NG_A06R2_SCHEMA_VER=8'h01`, `A7NG_A06R2_SCHEMA_BAD=8'hA5`.

Bag-claimed log hashes (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           ff0770d36b2972c4fae126589920d3ba490e40c060cb5c4017927186887bf7d3
xsim_fail_r0.log   a93c0313ee5f809c10f2cf1f259e8d18027dff533bbcf9e35e0cbfdc2c8ca0b7
```

Prior bags **not** overwritten (session headers still the auditor-cited runs):

| Bag | xsim session | PID |
|-----|--------------|-----|
| F2R-01 | Sun Sep 6 11:40:10 2026 | 27464 |
| F2R-R5 | Sun Sep 6 13:53:26 2026 | 5776 |
| F3R4 | Sun Sep 6 15:48:29 2026 | 20428 |
| ASTRA-06-WARM-PERSIST-01 | Sun Sep 6 16:12:12 2026 | 33088 (claimed SHA `5f739df0…`) |

Those bags’ `run_*.ps1` were not rerun. Persist-bag compiled DUT hash in this provenance is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_warm_persist.sv`.

Fail-r0: **preserved**. First xvlog/xelab/xsim **FAIL** (`RELOAD_I_PATH`), then one TB handshake corrective, then PASS. `xsim_fail_r0.log` / `xsim_fail.log` / `xsim_31544.backup.log` share session **Sun Sep 6 17:41:00–17:41:02 2026**, PID **31544**. Pass run is a **later** session PID **24304** 17:43:24–26. `run_xsim.ps1:99-102` copies r0 only if absent — pass run did not wipe it.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 17:43:24–17:43:26 2026**, PID **24304**, snapshot `a06r2eh`, `$finish` at **32035 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
SMOKE_HIGHID st=0 npath=2 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 vpred=0 ost=0 tbl=0 pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 pgen=1 pw0=0 pans=0xa00b4 pp0=0xa0011 pphi0=50 pver=1 capf=1 nref=0 nevict=0 nrlauto=0 nrlcmd=0 nsch=0
PASS SMOKE_HIGHID
PASS HIGHID_EID20
HIGHID_OBS pans=0xa00b4 pp0=0xa0011 pp1=0xa0022 ans=0xa00b4 p0=0xa0011 p1=0xa0022 bits19_8_p0=a00
PASS PERSIST_SNAP
EN_RST_LIVE st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 vpred=0 ost=0 tbl=0 pval=1 ... pans=0xa00b4 pp0=0xa0011 ... nrlauto=1 nrlcmd=0
PASS EN_RST_LIVE_CLEAR
PASS AXI_OST_CLEARED
EN_RELOAD_AUTO st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 ... nrlauto=1 nrlcmd=0
PASS EN_RELOAD_AUTO
EN_DELAYED_UPD st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=0 nbad=0 w0=-5 phi0=50 ... pval=1 pcmt=1 pw0=-5 pans=0xa00b4 pp0=0xa0011 ... nrlauto=1 nrlcmd=0
PASS EN_DELAYED_UPD
RELOAD_I_PRE ... ans=0xa00b4 p0=0xa0011 acc=1 ... nrlauto=0 nrlcmd=0
PASS RELOAD_I_PRE_HIGHID
RELOAD_I_AFTER_RST st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 ... pval=1 pacc=1 pcmt=0 pep=7 ptxn=1 ... pans=0xa00b4 pp0=0xa0011 ... nrlauto=0 nrlcmd=0
PASS RELOAD_I_NO_AUTO
RELOAD_I_PATH st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 ... w0=0 phi0=50 ... nrlauto=0 nrlcmd=1
PASS RELOAD_I_PATH
RELOAD_I_DELAYED_UPD st=1 ... acc=1 cmt=1 nupd=1 w0=-5 phi0=50 ... pw0=-5 pans=0xa00b4 pp0=0xa0011 ... nrlauto=0 nrlcmd=1
PASS RELOAD_I_DELAYED_UPD
CAP_OCCUPIED ... capf=1 nref=0 nevict=0 ptxn=1 pcmt=0
PASS CAP_OCCUPIED
CAP_REFUSE_SECOND st=0 npath=2 ans=0xa00b4 p0=0xa0011 acc=0 cmt=0 txn=1 ... pval=1 pacc=1 pcmt=0 ptxn=1 pans=0xa00b4 pp0=0xa0011 capf=1 nref=1 nevict=0
PASS CAP_REFUSE_SECOND
CAP_COMMITTED ... acc=1 cmt=1 txn=1 nupd=1 w0=-5 ... pcmt=1 pw0=-5 capf=0 nref=0 nevict=0
PASS CAP_COMMITTED
CAP_EVICT_COMMITTED st=0 npath=2 ans=0xa00b4 p0=0xa0033 acc=1 cmt=0 txn=2 gen=2 ep=7 nupd=1 ... w0=-5 phi0=2 vpred=-12 ... pval=1 pacc=1 pcmt=0 pep=7 ptxn=2 pgen=2 pw0=-5 pans=0xa00b4 pp0=0xa0033 pphi0=2 capf=1 nref=0 nevict=1
PASS CAP_EVICT_COMMITTED
SCHEMA_NATIVE_CMT ... w0=-5 pw0=-5 pver=1 pcmt=1
PASS SCHEMA_NATIVE_CMT
SCHEMA_POKE ... pw0=-5 pver=165
PASS SCHEMA_POKE
SCHEMA_FOREIGN_NO_RESTORE st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 ... w0=0 phi0=0 ... pval=1 pacc=1 pcmt=1 pep=7 pw0=-5 pans=0xa00b4 pp0=0xa0011 pver=165 nrlauto=0 nrlcmd=0 nsch=1
PASS SCHEMA_FOREIGN_NO_RESTORE
DIS_PRE ... pval=0 pans=0x00000
PASS DIS_NO_SNAP
DIS_RST ... acc=0 pval=0
DIS_STALE ... nupd=0 nstale=1 nbad=0 w0=0
PASS DIS_RST_STALE
UNREL_PRE ... ans=0xa00b4 p0=0xa0011 acc=1 tbl=0 pans=0xa00b4
UNREL st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ... tbl=0 pval=1 pans=0xa00b4 pp0=0xa0011
PASS UNREL_NO_STALE
ASTRA_06_R2_EVICT_HIGHID_XSIM_PASS
$finish called at time : 32035 ns : File ".../tb_astra_06_r2_evict_highid.sv" Line 372
```

Marker **present**. Zero `FAIL` lines on the pass log (grep). `tbl=0` on every dump.

`xvlog.log` analyzed `a7ng_astra_06_r2_evict_highid` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB. `xelab.log` built snapshot `a06r2eh`. Work library has `a7ng_astra_06_r2_evict_highid.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_06_warm_persist.sdb` / F2R5 / F3* integrator `.sdb` in this snapshot. Frozen persist DUT and prior integrators were **not** compiled into this run.

### Raw fail r0 `xsim_fail_r0.log`

```text
RELOAD_I_PATH st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 ... w0=0 phi0=0 ... nrlauto=0 nrlcmd=1 ... pans=0xa00b4 pp0=0xa0011
FAIL RELOAD_I_PATH
RELOAD_I_DELAYED_UPD st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 w0=0 phi0=50 ... nrlcmd=1
FAIL RELOAD_I_DELAYED_UPD
ASTRA_06_R2_EVICT_HIGHID_XSIM_FAIL n=2 first=RELOAD_I_PATH
$finish called at time : 31715 ns : File ".../tb_astra_06_r2_evict_highid.sv" Line 365
Exiting xsim at Sun Sep  6 17:41:02 2026
```

All other tags on r0 already PASS (ISO, HIGHID, CAP_REFUSE, CAP_EVICT, SCHEMA_FOREIGN, DIS_RST_STALE, UNREL) with the **same numeric fields** as the pass run (`ans=0xa00b4`, `nref=1`, `nevict=1`, `pver=165`, `nstale=1`). Discriminator is TB sample timing, not a relaxed golden.

---

## Hunt 1 — raw log proof ports with eid ≥256; after restore still 20-bit?

TB plants a 20-bit fact graph, not an 8-bit parse path (`tb:8-14`, `:186-198`):

```text
HID_P0=20'hA0011  HID_P1=20'hA0022  HID_ANS=20'hA00B4  HID_MID=20'hA0100
FACT_BASE+{HID_P0,4'b0}  fact_pack(s=10, o=HID_MID, e=HID_P0, conf=200)
```

Parser roles stay 8-bit (`r_subj` from QSE). Fact compare zero-extends (`r2:619` `fs=={{12{1'b0}}, r_subj}`). Proof/answer IDs are fact eids/objects: `pp0<=fe[ei]`, `pp1<=fe[ej]`, `pans<=fo[ej]` (`:632-634`) — all `[19:0]`. Persist copies `c_best_a/p0/p1` into `logic [19:0] p_ans, p_p0, p_p1` (`:179`, `:393-395`). Outputs `ans_o`/`proof*_o`/`persist_*_o` are `ID_W-1:0` with `ID_W=20` (`:10`, `:53-55`, `:106-108`, `:218-220`, `:254-256`). Grep: **no** `[7:0]` slice on persist/proof eids.

Raw `HIGHID_OBS`: `pans=0xa00b4 pp0=0xa0011 pp1=0xa0022 ans=0xa00b4 p0=0xa0011 p1=0xa0022 bits19_8_p0=a00`.  
`0xA0011 = 655377 ≥ 256`; bits[19:8]=`0xA00` ≠ 0. An 8-bit store would have printed `p0=0x00011` / `ans=0x000b4`.

After auto restore (`EN_RELOAD_AUTO`): live `ans=0xa00b4 p0=0xa0011` and persist `pans=0xa00b4 pp0=0xa0011`. R2 `S_RELOAD` **does** copy persist eids onto live HOLD and sets `keep_proof` (`:757-760`) — this is new-DUT behavior, not a patch of persist DUT (persist DUT still omits that copy at `:697-710`).

After delayed SGD (`EN_DELAYED_UPD` / `RELOAD_I_DELAYED_UPD`): live HOLD `ans=0x00000 p0=0x00000` because post-reload `r_st` stays UNKNOWN and `S_HOLD` with `np==0` zeros proofs (`:714-716`). **Persist** ports remain `pans=0xa00b4 pp0=0xa0011`. Hunt asked persist_* **and** proof ports after restore: the restore dumps (`EN_RELOAD_AUTO`, `RELOAD_I_PATH`) still show 20-bit live proofs. The later SGD HOLD wipe is not a `[7:0]` slice.

`load_from_tb_o=1'b0` (`:185`); every dump `tbl=0`. `poke_v_i=1'b0` (`:333`). Queries are `send_text("pump requires indirect")`.

**Finding:** residual **2 CLOSED_NARROW** on this bag. Full 20-bit persist + live proof IDs with bits[19:8] nonzero, including after restore. Not Full32 DDR schemaV2; QSE entities remain 8-bit.

---

## Hunt 2 — `reload_i` distinct from auto `need_rl`; delayed reward `w0=-5`?

RTL two paths (`:446-460`):

| Path | Guard | Counter |
|------|-------|---------|
| auto | `need_rl && p_valid && restore_en_i && schema_ok && sgd_ready` | `n_rl_auto` |
| explicit | `reload_i && p_valid && schema_ok && sgd_ready` (no `restore_en_i`) | `n_rl_cmd` |

`reload_busy_o = (st==S_RELOAD) || (need_rl && p_valid && restore_en_i)` (`:247`). When `restore_en=0`, busy is 0 in IDLE until `st` enters `S_RELOAD`.

Raw log:

```text
EN_RELOAD_AUTO  nrlauto=1 nrlcmd=0  acc=1 phi0=50 ans=0xa00b4
EN_DELAYED_UPD  nupd=1 cmt=1 w0=-5  nrlauto=1 nrlcmd=0  pans=0xa00b4
RELOAD_I_NO_AUTO restore_en=0 after rst: nrlauto=0 nrlcmd=0 acc=0  persist still pans=0xa00b4 pp0=0xa0011
RELOAD_I_PATH   nrlcmd=1 nrlauto=0 acc=1 ans=0xa00b4 p0=0xa0011 phi0=50
RELOAD_I_DELAYED_UPD nupd=1 cmt=1 w0=-5 nrlcmd=1 nrlauto=0
```

Oracle: smoke `phi0=50`, `w=0`, reward `-3` → symmetric `dw0=-5`. After restore, live SGD is rst-zero; delayed matching `{7,1,1}` produces `w0=-5` only if `pend_phi` reloaded. Observed on **both** auto and explicit paths.

**Finding:** residual **7 CLOSED** on this bag. Explicit `reload_i` is a distinct counter path from auto `need_rl`, and delayed matching reward still commits `w0=-5`.

---

## Hunt 3 — capacity N=1 refuse uncommitted / evict committed — one persist snapshot?

Written policy PREREG + `.svh` `A7NG_A06R2_CAP_N=1`. Live occupancy `cap_full = p_valid && p_acc && !p_cmt` (`:258`). `pick_ok` excludes `persist_en_i && cap_full` (`:266-268`). Persist is a **single** `{p_*}` register file, not an N-entry array. `CAP_N` is declared (`:16`) and **never referenced** in the body — N=1 is the hardcoded slot, not a parameterized N>1 store.

S_PICK (`:685-693`): occupied uncommitted → `n_cap_ref++`, `pend_acc<=0`, persist unchanged; occupied committed → `n_cap_evict++` then install.

Raw log:

```text
CAP_OCCUPIED        capf=1 ptxn=1 pcmt=0 pans=0xa00b4
CAP_REFUSE_SECOND   nref=1 acc=0 ptxn=1 pcmt=0 pans=0xa00b4 pp0=0xa0011 capf=1 nevict=0
CAP_COMMITTED       pcmt=1 capf=0 ptxn=1 pw0=-5
CAP_EVICT_COMMITTED nevict=1 ptxn=2 pcmt=0 pacc=1 capf=1 pans=0xa00b4 pp0=0xa0033 pphi0=2 pw0=-5
```

Refuse: second query reports ANSWER (`ans=0xa00b4 npath=2`) but **does not** ACK a new pending (`acc=0`); persist txn/eids unchanged. Matches PREREG “Retrieval ANSWER may still be reported on refuse (learning fail-closed).”

Evict: one new uncommitted snapshot `ptxn=2 pcmt=0`. Not two committed snapshots. Live/persist `p0` becomes `0xa0033` (HID_P0B) because after commit `w0=-5` the high-phi path (`phi0=50`) scores worse than the low-conf twin (`phi0=2`) — a real re-score, not a copy of the first persist eids.

**Residual (not a second snapshot):** pick-install copies eids/phi/`p_cmt<=0` but **does not zero `p_w`** (`:379-397`). `CAP_EVICT` dump keeps `pw0=-5` (old committed weights) under the new uncommitted identity. PREREG “old committed gone” holds for `{cmt,txn,eids,phi}`; weight bytes linger until the next `sgd_done`. Restore-after-evict-before-new-commit is **untested**. Still one slot; `pcmt=0`.

**Finding:** persist-slot N=1 policy **CLOSED_NARROW**. `n_cap_ref=1` and `n_cap_evict=1` in the raw log. Master multi-slot index eviction N>1 remains **OPEN**. `CAP_N` unused in RTL is hygiene, not an N>1 implementation.

---

## Hunt 4 — foreign VER does not restore live weights?

`schema_ok = p_valid && (p_ver == SCHEMA_VER)` (`:260`, `SCHEMA_VER=8'h01`). Auto and explicit reload both reject `!schema_ok` with `n_schema_rej++` and **do not** enter `S_RELOAD` (`:451-453`, `:461-463`). Persist stores `schema_i` at snap (`:383`). `schema_poke_i` rewrites **only** `p_ver` (`:377-378`) — documented host journal-byte rewrite, not a weight poke, `load_from_tb_o=0`.

Raw log:

```text
SCHEMA_NATIVE_CMT  w0=-5 pw0=-5 pver=1 pcmt=1
SCHEMA_POKE        pw0=-5 pver=165
SCHEMA_FOREIGN_NO_RESTORE nsch=1 live w0=0 acc=0 phi0=0  persist pw0=-5 pver=165 pans=0xa00b4 nrlauto=0 nrlcmd=0
```

`pver=165` = `8'hA5`. Live SGD stays rst-zero; persist payload stays. Optional 0945Z residual **fired**.

**Finding:** foreign VER does not restore into live weights. This is an on-chip journal byte, not schemaV2 DDR migration.

---

## Hunt 5 — fail r0 preserved; TB goldens not edited?

Fail r0 exists, is the first fail, and was not overwritten by the pass run (PID 31544 vs 24304; 31715 ns vs 32035 ns; TB line 365 vs 372).

r0 discriminator: `nrlcmd=1` already, persist eids already `0xa00b4/0xa0011`, live `acc=0 ans=0` — DUT had entered `S_RELOAD` (32-cycle weight walk). TB `wait(!rl_busy)` returned immediately because `restore_en=0` ⇒ `reload_busy_o` is 0 in IDLE (`:247`). Delayed reward was issued mid-reload (`RELOAD_I_DELAYED_UPD nupd=0 w0=0` even after proofs later appeared).

Pass TB `pulse_reload` waits `rl_busy` high then low (`tb:221-233`). Check predicates are **unchanged**: `nrlcmd===nrlcmd0+1`, `pend_acc`, `highid_ok()`, then delayed `nupd===1 && w0===-5` (`tb:303-309`). HIGHID expected IDs still `20'hA00B4` / `20'hA0011` (`tb:245-248`). CAP/SCHEMA/DIS/UNREL expected numbers on r0 already matched the pass run.

DUT RTL hash is only frozen on the **pass** run (17:43:19). r0 already exhibited `n_rl_cmd`, 20-bit persist, refuse/evict, foreign VER — consistent with current DUT, not a post-fail DUT rewrite. Implementer claim “DUT RTL not changed on the corrective” is **not contradicted** by the two logs.

**Finding:** fail r0 preserved. One TB handshake corrective. **No golden-vector edit** demonstrated.

---

## Hunt 6 — overclaim DDR / N>1 index / Master ASTRA-06 / BOARD?

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 32035 ns, PASS tags, dump fields (`w0`/`nrlcmd`/`nref`/`nevict`/`pver`/`pans`/`tbl`) match. RESULTS is **not** used as evidence. RESULTS omits `CAP_EVICT` leftover `pw0=-5` / `p0=0xa0033` — incomplete, not a false PASS. |
| Editing goldens to PASS | **Not found.** r0 vs pass: same HIGHID/CAP/SCHEMA integers; only reload handshake wait added. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0`. Every dump `tbl=0`. `poke_v_i=1'b0`. Queries are tokens. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). `schema_poke_i` is a journal-VER test pin, not a fact/weight poke. |
| Hash theatre / hash after scores | Freeze **17:43:19** is before xsim **17:43:24–26**. POST **17:43:26** matches compiled bytes. `.svh` in PRE. TB hash PRE=POST `329562cb…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| DDR / MIG / QSPI / NVM | **Not claimed closed.** ACK `does_not_close` + PREREG + CLOSEOUT list `persistence_DDR`, `NVM_QSPI_journal`. DUT has no MIG/QSPI/DDR persist port. AXI is retrieval only. On-chip no-reset FFs. |
| Master F3 10pp / LM06 / BOARD / ASTRA-13 | **Not claimed closed.** |
| N>1 index eviction | **Not claimed closed.** ACK `multi_slot_index_eviction_N_gt_1`. `CAP_N` unused; single slot. |
| Master ASTRA-06 as a whole | **Not claimed closed.** ACK `gate_claim` and RESULTS “Open (unchanged): Master ASTRA-06 as a whole”. Implementer `PASS_NARROW (this gate only: high-bit eids + reload_i + persist capacity N=1)`. |
| Persist DUT patched | **Not found.** Provenance SHA `52ebde52…` = persist-bag compiled DUT. Live persist `S_RELOAD` still does not restore HOLD eids. R2 work dir has no persist `.sdb`. |
| F2R / F3 / persist bag wipe | **Not found.** Prior `xsim.log` session headers unchanged. |
| Naming `ASTRA-06-R2` | **Scope risk, not RESULTS overclaim.** Parent must not promote the filename to Master ASTRA-06 CLOSED. |

**Finding:** **not OVERCLAIM** on the stated bag gate. Master ASTRA-06 / DDR / N>1 / BOARD remain OPEN as claimed.

---

## Hunt 7 — PROGRAM=NO in ACK; no bitstream?

`ACK.json`: `"PROGRAM": false`, `"jtag": "NO_CALLS"`. CLOSEOUT `BIT=NOT_BUILT PROGRAM=NO`. metrics `"program": false, "bitstream": false`. Bag listing: no `.bit` / `.bin` / program log / `TIMING_EXTRACT.txt`. `run_xsim.ps1` is xvlog/xelab/xsim only.

LOOP_STATE `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`, `jtag=NO_CALLS`. This auditor did not open COM12 / JTAG `210319BE776EA`.

**Finding:** PROGRAM=NO. No bitstream in this bag.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated **bag** gate. Checks that are **weaker than the dump** and must not be mistaken for extra proof:

1. **EN_RST_LIVE_CLEAR** dumps **after** `wait_reload()` inside `power_loss` (`tb:178-184`, `:278-280`). `acc=1 ans=0xa00b4` in that dump is **restored** pending/proofs, not “pending survived rst uncleared”. Live-clear evidence is `nupd=0 ost=0 w0=0`, then `EN_RELOAD_AUTO`.
2. **AXI_OST_CLEARED** after smoke+rst is `ost=0`. Smoke already completed AXI; rst also zeros `axi_ost`. Weak alone; contract still holds in RTL (`:409`, `:439`).
3. **UNREL_NO_STALE** does not require `pend_acc=0`. Dump `acc=1` is leftover pending (same class as persist bag). Proof ports are the hunt (`ans=0 p0=0 tbl=0`).
4. **CAP_EVICT_COMMITTED** does not check `pw0===0` or `p0===HID_P0`. Dump `pw0=-5 pp0=0xa0033` is leftover weights + re-scored twin path. One uncommitted snapshot still. Do not read this as N>1 or as wiped weights.
5. **CAP_N parameter** is dead. Policy is a single slot. Do not rename it Master index eviction.
6. **schema_poke_i** is a TB/host journal-byte backdoor. Valid for the optional VER test; not a schemaV2 DDR migrator and not `load_from_tb`.
7. **keep_proof** restores live HOLD eids (hunt 1 wanted that). After delayed SGD, `S_HOLD` zeros them. Persist ports stay 20-bit. Not a truncation cheat.
8. On-chip no-reset FFs are **not** board power-loss and **not** DDR-across-BRAM-loss.

ISO `viso=0` is an isolated `go_upd` without a prior displayed score; `w0=5` is the law check.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify the work-order unknown on this bag’s tests.

Residuals (not P1 for this gate):

1. **Not Master ASTRA-06 (schemaV2 DDR / N>1 index / DDR warm persist / NVM) — 0/10 as this bag, 9/10 if parent ticks Master ASTRA-06 CLOSED.** Single on-chip slot. No CRC A-B journal. No MIG/QSPI. `CAP_N` unused (`r2:16`).

2. **Evict-install does not wipe `p_w` — 4/10 hygiene, 2/10 as this TB.** `:379-397` copies eids/phi and clears `p_cmt`; `p_w` updates only on `(st==S_UW)&&sgd_done` (`:398-401`). `CAP_EVICT` `pw0=-5` under new `ptxn=2`. Restore-after-evict-before-commit untested. Not two committed snapshots.

3. **`CAP_N` never gates occupancy — 2/10 hygiene.** N=1 is hardcoded `cap_full`. Changing the parameter would not add slots.

4. **Post-reload HOLD proof wipe after SGD — 2/10 hygiene.** `S_RELOAD` sets `keep_proof` and live eids (`:757-760`); `S_IDLE` forces `r_st<=ST_UNKNOWN` (`:445`); `S_HOLD` with `np==0` zeros proofs (`:714-716`). Restore dumps still 20-bit. Persist dumps stay 20-bit.

5. **`reload_busy_o` ignores in-flight explicit reload until `st==S_RELOAD` — 1/10 as this pass TB** (handshake now waits high then low). Was the r0 FAIL. Not a remaining P1.

6. **`schema_poke_i` can rewrite journal VER whenever `persist_en_i=1` — 2/10 test-hook.** Documented. Not a weight poke.

7. **UNREL leaves `pend_acc=1` (`:658-661`) — 3/10.** Same class as F2R UNKNOWN not retiring. Not a stale proof.

8. **Live fact/path arrays not in the async rst list — 3/10 hygiene, 1/10 as this TB.** Gated by reset `nf`/`np` and `S_IDLE` `fv` clear. UNREL stayed UNKNOWN.

9. **QSE entities remain 8-bit — 0/10 as this residual-2 hunt** (proof/fact eids were the target), **8/10 if renamed Full32 subject persistence.** Master “No low8/low16 identity authority” for the **index/DDR record** is not this bag.

10. **Host `sess_id_i` reuse after `rst_n` without restore — 0/10 as this gate (documented OPEN).**

11. **On-chip no-reset FFs are not board power-loss — 0/10 as this modeled gate, 9/10 as silicon durability.**

12. **Copied F2R5 semantic/drain FSM not re-audited here — 3/10 as residual, 0/10 as this unknown.** Smoke+UNREL+high-id plant only. Items 4/5 remain closed on the F2R3/F2R4 bags.

No remaining **demonstrated** P1 that falsifies the work-order tests.

---

## ASTRA-06 this bag vs Master ASTRA-06 (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| Work-order unknown (20-bit high-id persist/proof, explicit `reload_i`, N=1 refuse/evict, foreign VER, ISO +5, UNREL, persist-disable stale) | **CLOSED (narrow)** on **ASTRA-06-R2-EVICT-HIGHID-01 only** | Raw log: `HIGHID_OBS bits19_8_p0=a00`; `RELOAD_I_PATH nrlcmd=1 nrlauto=0` + `w0=-5`; `CAP_REFUSE nref=1` / `CAP_EVICT nevict=1 ptxn=2 pcmt=0`; `SCHEMA_FOREIGN nsch=1 live w0=0 persist pw0=-5 pver=165`; `DIS_RST_STALE nstale=1`; `UNREL ans=0 p0=0 tbl=0`; ISO `w0=5`. |
| Auditor 0945Z residual **2** high-bit IDs | **CLOSED_NARROW** | eids ≥256 on persist **and** restore proof ports. Not Full32 DDR. |
| Auditor 0945Z residual **7** `reload_i` | **CLOSED** | Distinct `n_rl_cmd` vs `n_rl_auto`; delayed matching `w0=-5`. |
| Auditor 0945Z **capacity/eviction** (persist slot N=1) | **CLOSED_NARROW** | Written REFUSE_UNCOMMITTED_EVICT_COMMITTED; one snapshot. Leftover `p_w` on evict is residual. |
| Persist bag ASTRA-06-WARM-PERSIST-01 | **still CLOSED_NARROW** (0945Z); **not re-opened** | Frozen DUT SHA match; bag xsim session untouched. |
| Master ASTRA-06 **pending/commit** | **PARTIAL** | Single pending ACK vs commit + persist slot. Not a multi-slot commit store. |
| Master ASTRA-06 **full-ID schema** | **PARTIAL (narrow)** | 20-bit persist/proof with bits[19:8] tested. Parser still 8-bit. Not Full32 DDR schemaV2 / “no low8 identity authority” for the index record. |
| Master ASTRA-06 **migration** | **PARTIAL (narrow)** | On-chip schema byte foreign VER rejects restore. Not schemaV2 DDR store migration. |
| Master ASTRA-06 **capacity/eviction** | **PARTIAL (narrow)** | Persist-slot N=1 only. Multi-entry index N>1 **OPEN**. |
| Master **warm persistence** (DDR retention across BRAM loss) | **OPEN** | Not this experiment. |
| Master **power-loss durability** (NVM checkpoint/journal) | **OPEN** | Not QSPI/SD, no CRC/generation/wear. |
| F3 / LM06 / BOARD / ASTRA-13 | **OPEN** | Not claimed. |
| F2R items 1–6 / persist modeled journal | **not re-opened** | Frozen files unpatched. Prior auditor grades stand. |

Narrow = XSim TB-planted AXI 20-bit fact graph + modeled `rst_n` (not chip POR, not BRAM kill, not NVM) + persist-slot N=1 (not index N>1) + one TB handshake corrective after fail r0. Not Master ASTRA-06, not F3, not LM06, not BOARD, not a patch of live persist DUT / F2R5.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_06_warm_persist.sv` / `.svh` | **Not patched.** Hash `52ebde52…` / `cad5e606…` matches persist-bag compiled DUT. Not in R2 snapshot. Live `S_RELOAD` still omits HOLD eid restore. |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | **Not patched.** Hash `41c77e76…` / `1db76fcc…`. |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | **Not patched.** Hash `5cdb3da8…` / `94887bd4…`. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…`. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | **Not patched.** Hash `d12144a99…` / `9f0e5dbd7…`. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-01 / F2R-R5 / F3R4 / ASTRA-06-WARM-PERSIST-01 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-06-R2-EVICT-HIGHID-01`

Narrow = work-order residuals 2 / 7 / persist-slot N=1: raw log 20-bit eids `0xa00b4/0xa0011/0xa0022` with bits[19:8]≠0 on persist and restore proof ports; `reload_i` distinct (`n_rl_cmd=1`, `n_rl_auto=0`) with delayed `w0=-5`; refuse uncommitted `n_cap_ref=1` and evict committed `n_cap_evict=1` leaving one persist snapshot; foreign VER `pver=165` does not restore live weights; ISO +5; UNREL no stale proof IDs; persist-disable stale; fail r0 preserved with TB-handshake corrective, no golden edits; persist DUT SHA `52ebde52…` unpatched. Not Master ASTRA-06 (schemaV2 DDR / N>1 index / DDR warm persist / NVM), not F3, not LM06, not timing, not BOARD_PASS, not host `sess_id` reuse without restore, not a patch of live persist DUT.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this high-id / `reload_i` / N=1 persist-slot bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (evict leftover `p_w`, unused `CAP_N`, post-SGD HOLD proof wipe, `schema_poke` test hook, QSE 8-bit entities, Master ASTRA-06 still OPEN) are **not** P1 for this gate.

Parent: treat auditor **0945Z residual 2** (high-bit IDs), **residual 7** (`reload_i`), and **persist-slot N=1 capacity/eviction** as CLOSED narrow on **this bag only**. Do **not** tick Master ASTRA-06 CLOSED. Do not reopen the persist modeled-journal bag, F2R2 handshake, F2R3 semantic-guard, F2R4 drain, F2R5 wrap/reset, or F3R4 unique-HASH bags. Do not treat this as F3/LM06/BOARD/DDR/QSPI/N>1 index. Preserve F2R-*, F3*, ASTRA-06-WARM-PERSIST-01, and this bag. Do not rerun those `run_*.ps1` in a way that wipes `xsim.log` / `xsim_fail_r0.log`. Next Master ASTRA-06 leftover is schemaV2 DDR store / N>1 index eviction / DDR-across-BRAM-loss / NVM journal **or** host `sess_id` reuse-without-restore **or** the LM06/BOARD queue — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of Master ASTRA-06 (full: migration + N>1 eviction + schemaV2 DDR + DDR warm persist + NVM) / Master F3 / LM06 / BOARD / COM12 / DDR/MIG production persistence / QSPI journal / host `sess_id_i` reuse after `rst_n` without restore / live persist-DUT patch remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

ASTRA-06 **this bag** = **CLOSED_NARROW** (high-bit 20-bit persist/proof + explicit `reload_i` + persist-slot N=1 refuse/evict).  
ASTRA-06 **Master** = **OPEN** (eviction/high-id **narrow-closed here**; DDR / N>1 index / NVM / Full32 schemaV2 still OPEN).

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1125Z\REPORT.md  ACCEPT_PARTIAL  ASTRA-06-R2 bag=CLOSED_NARROW (high-id + reload_i + persist N=1) / Master ASTRA-06=OPEN
