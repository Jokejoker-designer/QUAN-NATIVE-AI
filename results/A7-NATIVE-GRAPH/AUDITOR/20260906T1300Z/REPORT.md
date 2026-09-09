# ASTRA auditor REPORT — 20260906T1300Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_INTEGRATED_PATH_INDEPENDENT_AUDIT; astra09=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra06_r4=AUDITOR_PASS_NARROW_SESS_REUSE; master_astra06=OPEN; master_f3=OPEN
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§4 One production path + §7 table) + work order ASTRA-09-INTEGRATED-PATH-01 + auditor 20260906T1235Z leftover that still fits XSim
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_xsim.ps1` or prior-bag scripts. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the persist / R2 / R3 / R4 / F2R2–F2R5 / F3* freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / RESULTS is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-INTEGRATED-PATH-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` plus frozen QSE/sparse walker (`a7ng_query_axi_sparse`). Contract `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh`. TB `tb_astra_09_integ_path.sv` (bag-local).

Gate under review is **work-order ASTRA-09-INTEGRATED-PATH-01 only** — one named XSim path: retrieve → legal 2-hop proofs → shared rank → pending `{sess,gen,txn,phi}` → handshake reward, plus one semantic refuse and one AXI SLVERR abort/drain smoke — **not** Master ASTRA-09 close:

1. One DUT that actually retrieves, enumerates 2-hops, scores SGD, latches pending, handshake-updates — or a TB that pokes internals?
2. CONFLICT dest 4 vs 7: DUT status **before** selection (not TB if/else)? Quote RTL + log `st=5 ans=0 acc=0`.
3. AXI SLVERR drain in DUT FSM or TB timeout only? `ost=0` after abort?
4. `load_from_tb=0`? ISO +5? UNREL no stale?
5. Overclaim of F2R3/F2R4/F2R5/persist **composition** if those modules are not instantiated?
6. PROGRAM=NO; `.svh` hashed before xvlog.

Judged against:

1. Work order `.agents/handoff/ASTRA-09-INTEGRATED-PATH-01.md` + PREREG written policy: one named integrator; instantiate frozen SGD; smoke two legal 2-hops + reward dw matches oracle; CONFLICT/wrong-object does not rank away contradiction; one AXI timeout/SLVERR drain without stale proof; UNREL no stale; ISO +5; `load_from_tb=0`; PROGRAM=NO.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“One integrated production path; remove fixture shortcuts; all functional regressions.”* Master §4 production path is `Raw bytes/tokens → query transaction → role-aware parser → valid typed route keys → sparse index/postings → bounded descriptors → PHYS4 scoring + shared learned ranker → retained Top-K/frontier → bounded relation expansion → proof validity/uncertainty → materialized evidence → LM06 generation → UART tokens/proof/status.`
3. Auditor `20260906T1235Z`: on-chip persist leftovers that fit XSim CLOSED_NARROW; Master ASTRA-06 DDR/NVM OPEN; parent did **not** open DDR, LM06, or BOARD.

**Master ASTRA-09 as a whole is not this bag’s close**, even if compact XSim tags all PASS and the DUT is named `a7ng_astra_09_integ_path`.

Out of this bag’s close: LM06, UART language, PHYS4 scorer array, BOARD_PASS, ASTRA-13, Master F3 10pp/CI, MIG/DDR production persistence, ASTRA-07 index image, QSPI/SD NVM journal, schemaV2 DDR store, same-query post-timeout recovery, interconnect cancel, power-loss NVM journal, **all functional regressions of F2R*/F3*/ASTRA-06-* bags** (those scripts were not rerun).

Frozen `a7ng_astra_06_warm_persist.sv` / `.svh`, `a7ng_astra_06_r2_evict_highid.sv` / `.svh`, `a7ng_astra_06_r3_multi_slot.sv` / `.svh`, `a7ng_astra_06_r4_sess_reuse.sv` / `.svh`, `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv` / `.svh`, `a7ng_astra_f2r5_txn_wrap.sv` / `.svh`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv` must remain **unpatched**. This DUT is a **new named** integrator. It does **not** instantiate frozen F2R3/F2R4/F2R5/persist/R4 modules.

Prior bags ASTRA-06-* / F2R-* / F3* / older `ASTRA-09-UNIFIED-PIPELINE` are **not** this evidence and must not have been rewritten.

Older file `rtl/native_graph/integrate/a7ng_astra09_pipe.sv` exists (ID_W=8, “loaded edges”) and was **not** compiled into this run. It is not this bag’s DUT.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T18:53:00.9388250+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T18:53:07.1754287+07:00` (matches raw pass-log exit `Sun Sep 6 18:53:07 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog (`run_xsim.ps1:37-77`). `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_09_integ_path.svh`.

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
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` |
| `.../tb_astra_09_integ_path.sv` | `897fab65ad0b0d9446999b9d2ba3b69b7b5d82350b3508e8c92608b513ad34e6` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh` | `ad2d66d4783bba33cfbd324fc0a9661fb2a46eeaffb5b4fb6989246fb4e94302` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `75bf596c9bd05f4cb9723c6f7a2015e0147a69f7c5cee84c29b4836eb3a57a3f` |
| `ACK.json` | `647fcd58309e2dd85e1a37fecf22e38e8d935ac3c2336e6e4336ae0f21336a2a` |
| `run_xsim.ps1` | `225aa0ff5c661d6fbf9616dd334346dfe7acfd378d9ed8addd322d447c1d2e70` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt | vs prior freeze |
|------|------------|-----------------|
| `a7ng_astra_06_warm_persist.sv` / `.svh` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` / `cad5e606fe1cd9c1b378931714581a6ad5ed9d7fcce8b2643059d4d42fb7db21` | persist-bag **compiled DUT** identical |
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` / `4e96067cce0672189230dc6f79598c452ba4c13ef6ad62e8018b8d199060ff68` | R2-bag **compiled DUT** identical |
| `a7ng_astra_06_r3_multi_slot.sv` / `.svh` | `99ee5d93dd18b3f146b433d521ab706038141cb8648afab17d315bd1ce8c186f` / `6b511c1571b6a70295e0578c1f46c5879d4f03c1142e93eb032f11d79fec29df` | R3-bag **compiled DUT** identical |
| `a7ng_astra_06_r4_sess_reuse.sv` / `.svh` | `4bd94762c62c0d749ff85f35fb5523eab1c251c210daf9c42997802a25f696f4` / `6530b921dc996597bfc43c04718b180df975d355e7a63bcd84f99284ee76eb0d` | R4-bag **compiled DUT** identical |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` / `1db76fcc01170f5abd38958228416e543900b98e76c8db3f895fcbac35e8ab9a` | F2R5 compiled DUT identical |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` / `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` | F2R4 compiled DUT identical |
| `a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` | F2R3 compiled DUT identical (no separate `.svh`) |
| `a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` | F2R2 compiled DUT identical |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` | compiled here; identical to persist/R2/R3/R4/F2R2 freeze |
| `a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` | floor-shift file, not compiled |

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live A09 DUT: `assign load_from_tb_o = 1'b0` (`a7ng_astra_09_integ_path.sv:144`). Instantiates `a7ng_query_axi_sparse u_sp` with `.poke_v_i(1'b0)` (`:257-266`) and frozen `a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd` with `.freeze_i(1'b0)` (`:290-294`). FSM `S_IDLE, S_WALK, S_AR, S_R, S_DRAIN, S_ABORT, S_EI, S_EJ, S_ED, S_GUARD, S_SC, S_SW, S_PICK, S_HOLD, S_UW` (`:93-96`). **No** instance of `a7ng_astra_f2r3_sem_guard`, `a7ng_astra_f2r4_axi_drain`, `a7ng_astra_f2r5_txn_wrap`, persist, R2, R3, or R4.
- Live F2R3 still has **no** `S_DRAIN` / `S_ABORT` in the enum (`a7ng_astra_f2r3_sem_guard.sv:75`). `S_GUARD` still sets `ST_CONFLICT` and skips `S_SC` (`:408-424`). **Not patched.** Manifest SHA `9a7a5941…` matches F2R3-bag compiled DUT.
- Live F2R4 still uses `A7NG_F2R4_RRESP_OK` and `S_DRAIN` (`a7ng_astra_f2r4_axi_drain.sv:87`, `:357-360`). **Not patched.** Manifest SHA `5cdb3da8…` matches F2R4-bag compiled DUT.
- Live F2R5 still has sess/gen/txn wrap and drain; header still F2R-R5 (`a7ng_astra_f2r5_txn_wrap.sv:1-16`). **No** persist slot array. **Not patched.** Manifest SHA `41c77e76…` matches F2R5-bag compiled DUT.
- Live persist DUT SHA `52ebde52…` matches persist-bag compiled DUT. Live R4 DUT SHA `4bd94762…` matches R4-bag compiled DUT. **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`). Instantiated read-only (`a09:290-294`).
- Live pass TB `$finish` at line **258** — raw pass log cites that line.
- `.svh` exists at freeze path; `A7NG_A09_TO_CYC=64`, `A7NG_A09_DRAIN_TO=64`, `A7NG_A09_RRESP_OK=2'b00`, `A7NG_A09_EPOCH_INV=16'd0`. Contract text: SLVERR / R timeout / NOLAST enter `S_DRAIN` then `S_ABORT`.

A09 does **not** instantiate frozen F2R3/F2R4/F2R5/persist. It is a new named integrator with inlined 2-hop enum + semantic guard + AXI drain + pending handshake (fork/copy of those FSMs, not module composition). `xvlog.log` / `xelab.log` analyze/compile `a7ng_astra_09_integ_path` + frozen SGD + QSE/sparse + bag TB only. Work library has `a7ng_astra_09_integ_path.sdb` and frozen SGD / sparse `.sdb`. **No** `a7ng_astra_f2r3_sem_guard.sdb` / F2R4 / F2R5 / persist / R4 / F3* integrator `.sdb`. Frozen F2R3/F2R4/F2R5/persist DUTs were **not** compiled into this run.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           445199d247c3f8e47ad2ea5204d46127f9c5eda9207239d7f4a800664b15caa7
xsim_fail_r0.log   none (first xvlog/xelab/xsim PASS; bag listing has no fail-r0 file)
```

Prior bags **not** overwritten (session headers still the auditor-cited runs):

| Bag | xsim session | PID |
|-----|--------------|-----|
| F2R-R3 | Sun Sep 6 12:57:56 2026 | 34860 |
| F2R-R4 | Sun Sep 6 13:24:12 2026 | 47768 |
| F2R-R5 | Sun Sep 6 13:53:26 2026 | 5776 |
| F3R4 | Sun Sep 6 15:48:29 2026 | 20428 |
| ASTRA-06-WARM-PERSIST-01 | Sun Sep 6 16:12:12 2026 | 33088 |
| ASTRA-06-R2-EVICT-HIGHID-01 | Sun Sep 6 17:43:24 2026 | 24304 |
| ASTRA-06-R3-MULTI-SLOT-01 | Sun Sep 6 18:12:36 2026 | 14668 |
| ASTRA-06-R4-SESS-REUSE-01 | Sun Sep 6 18:35:14 2026 | 21060 |
| ASTRA-09-INTEGRATED-PATH-01 (this) | Sun Sep 6 18:53:05 2026 | 40928 |

Those bags’ `run_*.ps1` were not rerun. Provenance DUT hashes are byte-identical to those bags’ compiled-DUT `SHA256.txt` lines.

Fail-r0: **none**. First compile+sim produced the marker. No `xsim_fail_r0.log` in the bag. Not a missing-file cheat: `run_xsim.ps1:102-110` only copies r0 on FAIL.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 18:53:05–18:53:07 2026**, PID **40928**, snapshot `a09ip`, `$finish` at **12705 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
SMOKE_TWO_PROOFS st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=0 phi0=50 obj=0 ctx=2 tbl=0
PASS SMOKE_TWO_PROOFS
HS_UPD st=0 npath=2 ans=4 p0=17 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=-5 phi0=50 obj=0 ctx=2 tbl=0
PASS HS_LATCH_NUPD
CONFLICT_DEST st=5 npath=2 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=-16 phi0=0 obj=0 ctx=2 tbl=0
PASS CONFLICT_DEST
CONFLICT_NO_UPD st=5 npath=2 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=-16 phi0=0 obj=0 ctx=2 tbl=0
PASS CONFLICT_NO_UPD
WRONG_OBJ st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=0 phi0=0 obj=11 ctx=2 tbl=0
PASS WRONG_OBJ
SLVERR st=6 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nerr=1 ndrain=0 abort=1 ost=0 arvalid=0 w0=0 phi0=0 obj=0 ctx=2 tbl=0
PASS SLVERR
PASS SLVERR_NERR
PASS SLVERR_NO_STALE
SMOKE_AFTER st=0 npath=2 ans=4 p0=17 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=0 phi0=50 obj=0 ctx=2 tbl=0
PASS SMOKE_AFTER
UNREL st=1 npath=0 ans=0 p0=0 acc=0 cmt=0 txn=1 gen=1 ep=7 nupd=0 nerr=0 ndrain=0 abort=0 ost=0 arvalid=0 w0=0 phi0=50 obj=0 ctx=0 tbl=0
PASS UNREL_NO_STALE
ASTRA_09_INTEGRATED_PATH_XSIM_PASS
$finish called at time : 12705 ns : File ".../tb_astra_09_integ_path.sv" Line 258
```

Zero `FAIL` lines in the pass log. Marker present. `tbl=0` on every dump.

RESULTS.md case table matches these raw lines (SMOKE/CONFLICT/SLVERR/UNREL integers). RESULTS omits UNREL leftover `txn=1 gen=1 ep=7 phi0=50` and SLVERR `ndrain=0`; those are in the raw dump. Not a RESULTS/log contradiction on the checked fields.

---

## Overclaim / cheat / tautology

### 1. One DUT path vs TB poke — **not a TB-internal poke**

DUT is a single named integrator. Tokens enter QSE/sparse (`u_sp`); walker AXI is muxed onto `m_axi_*`; facts are fetched in `S_AR`/`S_R`; 2-hops are enumerated in `S_EJ`; SGD scores in `S_SC`/`S_SW`; pending is minted only in `S_PICK`; handshake update is `S_HOLD`→`S_UW`.

TB drives only ports: token bytes, `fire`/`retire`, reward bus, AXI slave model, optional `load_w` in IDLE. No hierarchical `force`, no `load_from_tb` fact injection. `poke_v_i` tied off.

Anti-tautology: **same query string** `"pump requires indirect"` yields ANSWER on `plant2` (both 2-hops dest 4) and CONFLICT on `plant_shared` (dest 4 vs 7). Status is graph-dependent, not a query-string if/else in the TB.

Thin-wrap residual (not a cheat): 2-hop / guard / drain / pending FSMs are **inlined copies** of F2R3+F2R4+F2R5 logic, not instantiations of those frozen modules. Work order asked for one named DUT + frozen SGD instantiate. That is met. Do **not** read this as “F2R3+F2R4+F2R5+persist composed on one hierarchy.”

AXI plant in the TB is a simulation slave (directory/postings/facts at `INDEX_BASE`/`FACT_BASE`). That is an XSim fixture, not `load_from_tb` retrieval. Master ASTRA-09 “remove fixture shortcuts” is **not** closed by this (no DDR, no LM06, no UART, no PHYS4).

ISO +5 uses a **TB-local** second SGD instance (`u_iso`), not the DUT’s `u_sgd`. Same pattern as prior bags. DUT-path law is separately evidenced by `HS_LATCH_NUPD w0=-5` on the instantiated SGD.

### 2. CONFLICT dest 4 vs 7 — **DUT `S_GUARD` before selection**

TB `plant_shared` (`tb_astra_09_integ_path.sv:166-176`):

```text
fact 17: s=10 o=1  r=2 e=17  → hop1
fact 34: s=1  o=4  r=2 e=34  → hop2 dest 4
fact 36: s=1  o=7  r=2 e=36  → hop2 dest 7
```

DUT 2-hop match (`a7ng_astra_09_integ_path.sv:468-479`): `fs[ei]==subj`, `fs[ej]==fo[ei]`, `fo[ej]!=subj`. Second positive conclusion with `fo[ej] != concl0` sets `r_conf`.

`S_GUARD` **before** `S_SC`/`S_PICK` (`:500-516`):

```text
end else if (r_conf) begin
  r_st <= ST_CONFLICT;          // 4'd5
  best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
  st <= S_HOLD;                 // skips S_SC / S_PICK
```

Raw log:

```text
CONFLICT_DEST st=5 npath=2 ans=0 p0=0 acc=0 ... w0=-16 phi0=0 ... tbl=0
```

`npath=2` is `n_legal` counted during enum, then refuse. `pend_acc` never minted (`S_PICK` skipped). Reward after conflict: `!pend_acc` → `nbad++`, no `sgd_upd`; `nupd=0 w0=-16` (preloaded). **Not ranked away.** TB `chk` only compares DUT outputs; it does not compute dest 4 vs 7 itself.

`WRONG_OBJ` (`"pump requires indirect valve"`): `obj=11 ctx=2 npath=0 st=1 ans=0 acc=0`. `r_obj_v` requires `fo==obj`; dest-4 proofs filtered. Real QSE object latch, not TB status poke.

### 3. AXI SLVERR — **DUT FSM abort; drain unexercised**

TB slave: `inj==1` and `araddr>=FACT_BASE` returns `rresp=2'b10` with `rlast=1` (`tb:68-69`). Directory/posting walks (`INDEX_BASE`) still OKAY; first **fact** beat is SLVERR. Not a TB `wait_done` timeout (that 80000-cycle fork is only a hang watchdog).

DUT `S_R` (`:370-373`): `rresp != OK` + `RLAST` → `axi_ost<=0`, `st<=S_ABORT`. `S_ABORT` (`:418-425`) sets `r_st<=ST_INCOMP` (6), zeros `best_a/p0/p1`, `pend_acc<=0`, `n_legal<=0`, `axi_abort<=1`, `st<=S_HOLD`.

Raw log:

```text
SLVERR st=6 npath=0 ans=0 p0=0 acc=0 ... nerr=1 ndrain=0 abort=1 ost=0 arvalid=0 ... tbl=0
```

`ost=0` after abort: **yes**. No stale proof: **yes**. `S_DRAIN` exists (`:405-416`) but this stimulus is single-beat `ARLEN=0` + `RLAST`, so `ndrain=0`. CLOSEOUT honestly says `RLAST+SLVERR → S_ABORT`. Work-order “timeout/SLVERR drain” is satisfied as **SLVERR abort**; **timeout and multi-beat drain are not shown** in this log.

`.svh` text “SLVERR / R timeout / NOLAST enter S_DRAIN then S_ABORT” is slightly stronger than the RLAST-present implementation (skip drain when last beat already taken). AXI4-legal. Residual, not a FAIL of the abort smoke.

### 4. `load_from_tb=0`, ISO +5, UNREL no stale answer

- `load_from_tb_o` tied `0`. Every dump `tbl=0`.
- ISO: `xiso[0]=50`, `iso_rew=+3`, `wiso[0]=5`. Symmetric law, not floor-shift +4. TB-local instance (see §1).
- DUT smoke: `phi0=50` (`qphi0`: min conf 200>>2), `rew=-3`, `w=0` → `w0=-5`. Matches ISO sign-flip of the same law on the **DUT** SGD.
- UNREL after SMOKE_AFTER + `retire_q`: `st=1 npath=0 ans=0 p0=0 acc=0 tbl=0`. No stale ANSWER/proof. Leftover `txn=1 gen=1 ep=7 phi0=50` are uncleared HOLD snapshot fields (`S_IDLE` zeros `best_a/p0` and `r_st`, not `pend_id`/`pend_phi`). `acc=0` so not an accepted pending. PREREG UNREL contract (`ST_UNKNOWN`, `npath=0`, `ans=0`, `p0=0`) holds. Residual display, not a false success.

IDs are 20-bit fact identities 17/34/18/35/4/7, not one-hot transfer. Rank phi is conf/trans/polarity/hop (`phi[0:4]`), not query/answer IDs.

### 5. F2R3/F2R4/F2R5/persist composition — **not instantiated; not overclaimed as modules**

xvlog/xelab/sdb: only A09 DUT + SGD + QSE/sparse + TB.

ACK/RESULTS/CLOSEOUT state the DUT does **not** compile frozen F2R5/F3/ASTRA-06 integrators and does **not** close Master F3 / persist DDR / LM06 / BOARD. That is honest.

Capability language “QSE+sparse retrieve+2-hop enum+SGD rank+pending+handshake” matches the **inlined** DUT, not a hierarchy of frozen F2R3/F2R4/F2R5/persist. **No module-composition overclaim found.** Fork/copy is a maintenance residual for parent, not OVERCLAIM of this bag.

### 6. PROGRAM=NO; `.svh` before xvlog — **met**

ACK `PROGRAM: false`. PREREG/RESULTS/CLOSEOUT/LOOP_STATE `program=false`. `.svh` in PRE `TRANSITIVE_INCLUDES` before xvlog. COM12/JTAG untouched. BIT not built. Board plugged is irrelevant; this audit did not program.

Hash order: PRE `18:53:00` → xvlog/xelab → xsim start `18:53:05` → exit `18:53:07` → POST `18:53:07`. Not hash-after-scores theatre.

---

## Logic bugs

No compact-tag FAIL. No RESULTS vs raw-log contradiction on checked integers.

Residuals (not this-bag FAIL):

1. `S_DRAIN` / AR-timeout / R-timeout **untested** (`ndrain=0`, no `narto`/`nrto` in dumps).
2. UNREL leaves previous `pend_id`/`pend_gen`/`pend_epoch`/`pend_phi` visible with `acc=0`.
3. Inlined F2R3/F2R4/F2R5 FSM (drift vs frozen modules if those are later patched).
4. ISO +5 is not the DUT instance; DUT instance is proven by `HS_LATCH_NUPD` only.
5. `a7ng_astra09_pipe.sv` (old 8-bit-ID pipe) remains in tree; not this compile; do not confuse with `a7ng_astra_09_integ_path`.

Handshake: `pulse_rew` one-cycle `rew_v` then invert bus (`tb:182-188`). DUT latches `rew_lat` and `sgd_upd` then `S_UW` (`:569-584`). `nupd=1 cmt=1 w0=-5`. Real latch, not combinational score poke.

---

## This bag vs Master ASTRA-09

| Master ASTRA-09 requirement | This bag |
|---|---|
| One integrated **production** path (§4: parser→sparse→PHYS4+rank→proof→**LM06**→**UART**) | XSim-only named path through QSE+sparse+2-hop+SGD+pending. **No PHYS4, no LM06, no UART.** |
| Remove fixture shortcuts | `load_from_tb=0`, `poke_v=0`, token queries. TB AXI slave plant + TB-local ISO SGD + `load_w` preload remain. |
| All functional regressions | Does **not** rerun F2R*/F3*/ASTRA-06-* bags. Subset smokes only. |
| Board / WNS / unique bit | BIT not built. PROGRAM=NO. |

Master ASTRA-09 remains **OPEN**. Implementer did not claim otherwise.

Master ASTRA-06 DDR/NVM, Master F3 10pp/CI, LM06, BOARD_PASS, ASTRA-13 remain **OPEN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-INTEGRATED-PATH-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: a single named FPGA **XSim** DUT can retrieve → enumerate two legal 2-hops → score frozen symmetric SGD → latch pending `{sess,gen,txn,phi}` → handshake-update, refuse dest-4-vs-7 CONFLICT before selection, refuse wrong-object, abort one fact SLVERR without stale proof/`ost`, and not return the prior answer on UNREL — with `load_from_tb=0` and without BOARD/LM06.

Not PASS (Master ASTRA-09 production path, drain/timeout, module composition, all regressions).  
Not FAIL (raw marker, integers, DUT-side conflict/abort, hashes, frozen DUTs unpatched).  
Not OVERCLAIM (ACK/RESULTS keep Master F3 / ASTRA-06 / LM06 / BOARD / ASTRA-13 open; do not claim F2R3/F2R4/F2R5 instantiated).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared XSim claim.

**P2 / residuals (do not reopen this bag as FAIL):**

1. AXI **timeout** and **S_DRAIN** (`ndrain>0` or abandon) still untested here. Optional later smoke; not required to keep this PASS_NARROW.
2. UNREL leftover pending-key/phi display (`acc=0`). Optional clear on `S_IDLE`/UNKNOWN. Not a stale ANSWER.
3. Do **not** promote Master ASTRA-09, LM06, BOARD, persist-DDR, or “F2R3+F2R4+F2R5 composed.” Next Master residual that still fits XSim is parent’s choice among remaining §7 gates (ASTRA-07 scale, ASTRA-08 LM, ASTRA-10 resources) — **not** a silent close of ASTRA-09.
4. Keep PROGRAM=NO. Board plugged ≠ authority.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s XSim integrated-path smoke only (retrieve→proof→rank→pending→reward + CONFLICT refuse + SLVERR abort, `load_from_tb=0`).

`REJECT_PROMOTION` — Master **ASTRA-09** (production path, fixture-free, all functional regressions, LM06/UART/PHYS4) is **not** closed.

Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.

PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1300Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-INTEGRATED-PATH-01; Master ASTRA-09 OPEN (not closed).
