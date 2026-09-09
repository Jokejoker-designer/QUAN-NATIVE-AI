# ASTRA auditor REPORT — 20260906T1235Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA06_R4_SESS_REUSE_INDEPENDENT_AUDIT; astra06_r4=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra06_r3=AUDITOR_PASS_NARROW_ONCHIP_CAP_N2; master_astra06=OPEN
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-06 (§5 Transaction/storage + §7 table) + work order ASTRA-06-R4-SESS-REUSE-01 + auditor 20260906T1200Z leftover host sess_id reuse after rst_n without restore
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_xsim.ps1` or prior-bag scripts. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the persist-bag / R2 / R3 / F2R2–F2R5 / F3* freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-06-R4-SESS-REUSE-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_06_r4_sess_reuse.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract constants `rtl/native_graph/integrate/a7ng_astra_06_r4_sess_reuse.svh`. TB `tb_astra_06_r4_sess_reuse.sv` (bag-local).

Gate under review is **auditor 20260906T1200Z leftover host `sess_id` reuse after `rst_n` without restore** on a **new named** DUT — not a patch of frozen persist DUT `a7ng_astra_06_warm_persist.sv`, not a patch of R2 DUT `a7ng_astra_06_r2_evict_highid.sv`, and not a patch of R3 DUT `a7ng_astra_06_r3_multi_slot.sv`:

1. After rst without restore, delayed `{sess,txn}` is `n_stale` — quote raw log counters.
2. Same-sess PICK after rst without restore refused (`n_sess_reuse`)?
3. Matching restore + delayed rew still `w0=-5`?
4. New sess after rst does not copy old weights?
5. Overclaim DDR / BOARD / Master ASTRA-06?
6. PROGRAM=NO; `.svh` in SHA before xvlog.

Judged against:

1. Work order `.agents/handoff/ASTRA-06-R4-SESS-REUSE-01.md` + PREREG written policy: persist-owned sess; rst without restore must not accept a replay of pre-rst `{sess,txn}` as a new live pending; matching restore still commits.
2. Auditor `20260906T1200Z`: R3 bag **CLOSED_NARROW** (on-chip persist CAP_N=2); Master ASTRA-06 **OPEN**; leftover **host `sess_id` reuse after rst without restore** (not DDR, not BOARD).
3. **Master ASTRA-06** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7 table + §5): pending/commit, **full-ID schema**, **migration**, **capacity/eviction**, and **warm persistence on chosen state architecture**. Master text: *“Capacity miss, reset, duplicates and DDR stalls must not create false success.”* and *“Full32 subject/object persistence schemaV2 is reusable with version/migration checks. No low8/low16 identity authority. DDR retention across BRAM loss is warm persistence; power-loss durability requires separately tested nonvolatile checkpoint/journal.”*

**Master ASTRA-06 as a whole is not this bag’s close**, even if compact XSim tags all PASS and the DUT is named `a7ng_astra_06_r4_sess_reuse`.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, Master F3 10pp/CI, MIG/DDR production persistence, ASTRA-07 index image, QSPI/SD NVM journal, schemaV2 DDR store, **DDR index N>1 eviction**, BRAM-kill-with-DDR-retained warm persist, power-loss NVM journal.

Frozen `a7ng_astra_06_warm_persist.sv` / `.svh`, `a7ng_astra_06_r2_evict_highid.sv` / `.svh`, `a7ng_astra_06_r3_multi_slot.sv` / `.svh`, `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv`, `a7ng_astra_f3r4_distinct_hold_phi.sv` must remain **unpatched**. This DUT is a **new named** integrator (sess-reuse refuse + sess-match restore) plus on-chip slot array; it does **not** instantiate frozen R3.

Prior bags ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01 / ASTRA-06-R3-MULTI-SLOT-01 / F2R-* / F3* are **not** this evidence and must not have been rewritten.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T18:35:09.2021301+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T18:35:16.1510180+07:00` (matches raw pass-log exit `Sun Sep 6 18:35:16 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog (`run_xsim.ps1:37-75`). `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_06_r4_sess_reuse.svh`.

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
| `rtl/native_graph/integrate/a7ng_astra_06_r4_sess_reuse.sv` | `4bd94762c62c0d749ff85f35fb5523eab1c251c210daf9c42997802a25f696f4` |
| `.../tb_astra_06_r4_sess_reuse.sv` | `55f4daf725e6260237d3bb074be76e7ff04ece95480b295c328616859f2f29fb` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_06_r4_sess_reuse.svh` | `6530b921dc996597bfc43c04718b180df975d355e7a63bcd84f99284ee76eb0d` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `b80020a8090807c77953aaa409f26df0c4c6a420e44dafbaabbc1f95c381ec9a` |
| `ACK.json` | `9dce481fd965df11904625127c2bd219445ae11e4da899c556ab95274813dda1` |
| `run_xsim.ps1` | `217c9be21f612c26dafc3e977197ea2e0bed5b5366149dd311482df8aa35ecff` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt | vs prior freeze |
|------|------------|-----------------|
| `a7ng_astra_06_warm_persist.sv` / `.svh` | `52ebde5250a8740032667eea2ccd2fccc25f96ff6317d85fd06795ee6aa317b1` / `cad5e606fe1cd9c1b378931714581a6ad5ed9d7fcce8b2643059d4d42fb7db21` | persist-bag **compiled DUT** identical |
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | `c671f98b2518830d23a9a171bbf60386db2cbc628e9bbe30f7e970a3d83c037b` / `4e96067cce0672189230dc6f79598c452ba4c13ef6ad62e8018b8d199060ff68` | R2-bag **compiled DUT** identical |
| `a7ng_astra_06_r3_multi_slot.sv` / `.svh` | `99ee5d93dd18b3f146b433d521ab706038141cb8648afab17d315bd1ce8c186f` / `6b511c1571b6a70295e0578c1f46c5879d4f03c1142e93eb032f11d79fec29df` | R3-bag **compiled DUT** identical |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | `d12144a99…` / `9f0e5dbd7…` | F3R4 compiled DUT identical |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | `41c77e76f…` / `1db76fcc0…` | F2R5 compiled DUT identical |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…` | compiled here; identical to persist/R2/R3/F2R2 freeze |
| `a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b5…` | floor-shift file, not compiled |

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R4 DUT has `parameter CAP_N = A7NG_A06R4_CAP_N` with `.svh` `A7NG_A06R4_CAP_N = 2`; slot array `ps_valid/ps_acc/ps_cmt/ps_txn/ps_sess_epoch/ps_w/ps_phi/ps_ans/ps_p0/ps_p1 [0:1]`; `sess_reuse` comb walks persist rows (`ps_sess_epoch[kj]==sess_id_i && sess_epoch!=sess_id_i`); `pick_ok` includes `!(persist_en_i && sess_reuse)`; S_PICK refuse increments `n_sess_reuse` and does not mint pending; restore requires `sess_match` (`sess_id_i == p_sess_epoch` of `obs_sel`); mismatch increments `n_sess_rej` and does not enter `S_RELOAD` (`a7ng_astra_06_r4_sess_reuse.sv:17-18`, `:219-233`, `:358-375`, `:432-437`, `:605-628`, `:858-862`, `:920-938`).
- Live persist DUT still has **no** `n_sess_reuse` / `sess_reuse` / slot array. `S_RELOAD` still copies pending key/phi/weights only — **not** `p_ans` onto live HOLD (`a7ng_astra_06_warm_persist.sv:697-710`). `sess_id_i` pin still exists (`:26`). **Not patched.** Manifest SHA `52ebde52…` matches persist-bag compiled DUT.
- Live R3 DUT still has `sess_id_i` and `ps_sess_epoch[0:1]` **without** `n_sess_reuse` / `sess_reuse`. `pick_ok` is still only INV / TXN_MAX / `inst_refuse` (`a7ng_astra_06_r3_multi_slot.sv:353-355`). S_PICK after rst with `sess_id_i != sess_epoch` still **mints** `txn=1` (`:832-841`). Auto-reload still `p_valid && restore_en_i && schema_ok` **without** sess match (`:578`). **Not patched.** Manifest SHA `99ee5d93…` matches R3-bag compiled DUT. That is the leftover this bag exists to close on a **new named** DUT.
- Live R2 DUT still has `CAP_N` **only** as the unused parameter (`a7ng_astra_06_r2_evict_highid.sv:16`); `.svh` still `A7NG_A06R2_CAP_N=1`. **No** `n_sess_reuse`. **Not patched.** Manifest SHA `c671f98b…` matches R2-bag compiled DUT.
- Live F2R5 still has **no** persist ports. Hash `41c77e76…`. **Not patched.**
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends and async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`, `:85-90`). Instantiated read-only (`r4:508-513`, `freeze_i=1'b0`).
- Live pass TB `$finish` at line **382** — raw pass log cites that line.
- `.svh` exists at freeze path; `A7NG_A06R4_CAP_N=2`, `A7NG_A06R4_SCHEMA_VER=8'h01`, `A7NG_A06R4_EPOCH_INV=16'd0`.

R4 does **not** instantiate frozen persist DUT or frozen R3 DUT. It is a new named integrator with an on-chip 2-row array plus sess-reuse refuse (same additive fork pattern as R3 vs persist). `xvlog.log` / `xelab.log` analyze/compile `a7ng_astra_06_r4_sess_reuse` + frozen SGD + bag TB only. Work library has `a7ng_astra_06_r4_sess_reuse.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_06_warm_persist.sdb` / R2 / R3 / F2R5 / F3* integrator `.sdb`. Frozen persist/R2/R3 DUT and prior integrators were **not** compiled into this run.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log           cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f
xsim_fail_r0.log   none (first xvlog/xelab/xsim PASS; bag listing has no fail-r0 file)
```

Prior bags **not** overwritten (session headers still the auditor-cited runs):

| Bag | xsim session | PID |
|-----|--------------|-----|
| F2R-R5 | Sun Sep 6 13:53:26 2026 | 5776 |
| F3R4 | Sun Sep 6 15:48:29 2026 | 20428 |
| ASTRA-06-WARM-PERSIST-01 | Sun Sep 6 16:12:12 2026 | 33088 (claimed SHA `5f739df0…`) |
| ASTRA-06-R2-EVICT-HIGHID-01 | Sun Sep 6 17:43:24 2026 | 24304 (claimed SHA `ff0770d3…`) |
| ASTRA-06-R3-MULTI-SLOT-01 | Sun Sep 6 18:12:36 2026 | 14668 (claimed SHA `d6deb5ba…`) |

Those bags’ `run_*.ps1` were not rerun. Persist-bag compiled DUT hash in this provenance is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_warm_persist.sv`. R2-bag compiled DUT hash is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_r2_evict_highid.sv`. R3-bag compiled DUT hash is byte-identical to that bag’s `SHA256.txt` line for `a7ng_astra_06_r3_multi_slot.sv`.

Fail-r0: **none**. First compile+sim produced the marker. No `xsim_fail_r0.log` in the bag. Not a missing-file cheat: `run_xsim.ps1:100-108` only copies r0 on FAIL.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 18:35:14–18:35:16 2026**, PID **21060**, snapshot `a06r4sr`, `$finish` at **13555 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
PICK_A st=0 npath=2 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 bound=1 psess=7 s0sess=7 s1sess=0 nreuse=0 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=0
PASS PICK_A
RST_LIVE st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=0 nbad=0 w0=0 phi0=0 ost=0 tbl=0 bound=0 psess=7 s0sess=7 s1sess=0 nreuse=0 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011 s1v=0
PASS RST_LIVE_CLEAR
REUSE_REW_STALE st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=1 nbad=0 w0=0 phi0=0 ost=0 tbl=0 bound=0 psess=7 s0sess=7 nreuse=0 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
PASS REUSE_REW_STALE
REUSE_PICK_REFUSE st=0 npath=2 ans=0xa00b4 p0=0xa0011 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=1 nbad=0 w0=0 phi0=0 ost=0 tbl=0 bound=0 psess=7 s0sess=7 nreuse=1 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
PASS REUSE_PICK_REFUSE
RELOAD_MISMATCH st=1 npath=0 ans=0x00000 p0=0x00000 acc=0 cmt=0 txn=0 gen=0 ep=0 nupd=0 nstale=1 nbad=0 w0=0 phi0=0 ost=0 tbl=0 bound=0 psess=7 s0sess=7 nreuse=1 nrej=1 nrlcmd=0 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
PASS RELOAD_MISMATCH
MATCH_RELOAD st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=1 nbad=0 w0=0 phi0=50 ost=0 tbl=0 bound=1 psess=7 s0sess=7 nreuse=1 nrej=1 nrlcmd=1 nrlauto=0 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
PASS MATCH_RELOAD
MATCH_REW st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=1 txn=1 gen=1 ep=7 nupd=1 nstale=1 nbad=0 w0=-5 phi0=50 ost=0 tbl=0 bound=1 psess=7 s0sess=7 nreuse=1 nrej=1 nrlcmd=1 nrlauto=0 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011
PASS MATCH_REW
NEW_SESS_NO_PULL st=0 npath=2 ans=0xa0c55 p0=0xa0111 acc=1 cmt=0 txn=1 gen=1 ep=9 nupd=0 nstale=0 nbad=0 w0=0 phi0=40 ost=0 tbl=0 bound=1 psess=7 s0sess=7 s1sess=9 nreuse=0 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s0ans=0xa00b4 s0p0=0xa0011 s1v=1 s1c=0 s1txn=1 s1phi=40 s1w0=0 s1ans=0xa0c55 s1p0=0xa0111
PASS NEW_SESS_NO_PULL
NEW_SESS_OLD_REW st=0 npath=2 ans=0xa0c55 p0=0xa0111 acc=1 cmt=0 txn=1 gen=1 ep=9 nupd=0 nstale=1 nbad=0 w0=0 phi0=40 ost=0 tbl=0 bound=1 psess=7 s0sess=7 s1sess=9 nreuse=0 nrej=0 nrlcmd=0 nrlauto=0 s0v=1 s0c=1 s0txn=1 s0phi=50 s0w0=-5 s1v=1 s1c=0 s1w0=0
PASS NEW_SESS_OLD_REW
UNREL_PRE st=1 npath=0 ans=0xa00b4 p0=0xa0011 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 bound=1 psess=7 s0sess=7 nreuse=0 nrej=0 nrlcmd=0 nrlauto=1 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
UNREL st=1 npath=0 ans=0x00000 p0=0x00000 acc=1 cmt=0 txn=1 gen=1 ep=7 nupd=0 nstale=0 nbad=0 w0=0 phi0=50 ost=0 tbl=0 bound=1 psess=7 s0sess=7 nreuse=0 nrej=0 nrlcmd=0 nrlauto=1 s0v=1 s0c=0 s0txn=1 s0phi=50 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
PASS UNREL_NO_STALE
ASTRA_06_R4_SESS_REUSE_XSIM_PASS
$finish called at time : 13555 ns : File ".../tb_astra_06_r4_sess_reuse.sv" Line 382
```

Marker **present**. Zero `FAIL` lines on the pass log (grep). `tbl=0` on every dump.

---

## Hunt 1 — After rst without restore, delayed `{sess,txn}` is `n_stale`

Work-order unknown first half: persist+rst **no restore**, host drives same sess+txn delayed rew → `n_stale` / refused, persist not written.

RTL: after `rst_n`, live `pend_acc=0`, `pend_epoch=INV`, `sess_epoch=INV` (`r4:563-585`). Persist array is **not** on `rst_n`; only `persist_clr_i` (`:515-529`). Delayed rew in S_IDLE:

```text
if (!pend_acc && ((pend_epoch == INV) || (rew_epoch_i != pend_epoch)))
  nstale++;
```

(`r4:632-634`). Pre-rst key `{ep=7,txn=1,gen=1}` against empty post-rst pending is a **lifetime miss**.

TB: `power_loss` with `restore_en=0` (`tb:203-209`, `:304`). Then `pulse_rew_id(-3, sav_ep, sav_txn, sav_gen)` (`:310-316`).

Raw:

```text
RST_LIVE          acc=0 txn=0 ep=0 w0=0 bound=0 nrlcmd=0 nrlauto=0 nreuse=0
                  persist s0v=1 s0sess=7 s0txn=1 s0w0=0 s0ans=0xa00b4 s0p0=0xa0011
REUSE_REW_STALE   nstale=1 nupd=0 nbad=0 acc=0 cmt=0 w0=0
                  persist s0c=0 s0w0=0 s0txn=1 s0sess=7 (unchanged, not written)
```

`n_upd` stays 0. Persist remains uncommitted `w0=0`. Live SGD stays 0 (frozen SGD `rst_n` zeros `w[k]`).

**Finding:** hunt **1 CLOSED**. Quoted counters: `nstale=1 nupd=0 nbad=0`. Not DDR. Not chip POR.

---

## Hunt 2 — Same-sess PICK after rst without restore refused (`n_sess_reuse`)?

Work order: rst without restore must not accept a replay of pre-rst `{sess,txn}` as a new live pending.

RTL comb:

```text
sess_reuse = 1 if any ps_valid[kj] && (ps_sess_epoch[kj]==sess_id_i) && (sess_epoch != sess_id_i)
pick_ok   &= !(persist_en_i && sess_reuse)
```

(`r4:372-375`, `:432-437`). S_PICK:

```text
else if (persist_en_i && sess_reuse) begin
  n_sess_reuse++; pend_acc<=0; pend_cmt<=0;
end
```

(`:858-862`). Does **not** take the mint branch (`:863-880`: `pend_id<=1; txn<=1; pend_epoch<=sess_id_i`). Persist install is gated by `pick_ok` (`:533`).

After rst `sess_epoch=INV`, host `sess_id_i=7`, persist row sess=7 → `sess_reuse=1`.

Raw:

```text
REUSE_PICK_REFUSE nreuse=1 acc=0 cmt=0 txn=0 gen=0 ep=0 bound=0 w0=0
                  persist s0txn=1 s0sess=7 s0w0=0 s0c=0 (not replaced, not minted txn=1)
```

Live pending **not** reminted (`txn=0 acc=0`). Persist txn stays **1**. That is the hole R3 leaves open: frozen R3 S_PICK would have taken `sess_id_i != sess_epoch` and minted `txn=1` (`r3:832-841`).

Retrieval still reports ANSWER (`st=0 npath=2 ans=0xa00b4`). Learning fail-closed; query path not refused. Work order asked refuse **pending**, not retrieval.

**Finding:** hunt **2 CLOSED**. Quoted: `nreuse=1 acc=0 txn=0`; persist `txn=1 sess=7` unchanged. Not a TB-only counter.

---

## Hunt 3 — Matching restore + delayed rew still `w0=-5`?

Work-order unknown second half: persist+rst+reload matching sess → delayed rew commits.

RTL: `sess_match = p_valid && (sess_id_i != INV) && (sess_id_i == p_sess_epoch)` of `obs_sel` (`r4:358-359`). `reload_i && schema_ok && sess_match` → `n_rl_cmd++`, `S_RELOAD` (`:621-626`). Mismatch: `n_sess_rej++`, no `S_RELOAD` (`:627-628`). Reload copies persist `{epoch,gen,txn,sess,acc,cmt,phi,w via sgd_load, ans/p0/p1}` onto live (`:376-379`, `:920-938`). Matching delayed rew walks F2R handshake into `S_UW`; persist writeback `ps_w[live_slot]` / `ps_cmt` (`:555-558`, `:911-918`).

Law: plant A phi0=50, rew=-3, w=0 → dw0=-5 (PREREG; ISO +3,x0=50 → +5).

Raw:

```text
RELOAD_MISMATCH  sess_id=9 vs persist sess=7; nrej=1 nrlcmd=0 acc=0 live w0=0 persist s0sess=7 s0w0=0
MATCH_RELOAD     nrlcmd=1 nrlauto=0 acc=1 txn=1 gen=1 ep=7 phi0=50 bound=1
                 live ans=0xa00b4 p0=0xa0011 w0=0; persist s0 still uncommitted w0=0
MATCH_REW        nupd=1 nstale=1(leftover from hunt 1) nbad=0 cmt=1 w0=-5 phi0=50
                 persist s0c=1 s0w0=-5 s0sess=7 s0txn=1 s0ans=0xa00b4 s0p0=0xa0011
```

Matching restore rebinds the **same** `{sess=7,txn=1,gen=1}` (not a new mint). Delayed rew commits snapshot `w0=-5` into live **and** persist slot 0. Leftover `nstale=1` is hunt-1’s counter (no rst between REUSE_REW_STALE and MATCH_REW). `nupd` 0→1 is the commit.

RELOAD_MISMATCH is before any SGD commit, so persist `w0` is already 0 — it proves no rebind (`nrlcmd` unchanged, `nrej++`, `acc=0`), **not** a strong “did not copy nonzero weights” by itself. Nonzero no-pull is hunt 4.

**Finding:** hunt **3 CLOSED**. Matching restore + delayed rew `w0=-5` / persist `s0w0=-5`. Mismatch does not restore.

---

## Hunt 4 — New sess after rst does not copy old weights?

Work order: new `sess_id` after rst without restore does not pull old weights.

TB after MATCH_REW: `restore_en=0; power_loss(); sess_id=9; plant_b(); q_text()` (`tb:352-360`). Persist slot 0 holds committed A (`w0=-5 sess=7`). Slot 1 is free. `sess_reuse` is false for sess 9 (no persist row owns 9). PICK mints new pending `{ep=9,txn=1}` into slot 1 and **zeros** that slot’s `ps_w` (`r4:550-553`). Live SGD was rst-zeroed; `S_RELOAD` is not taken (`restore_en=0`, `need_rl` cleared `:619-620`).

Raw:

```text
NEW_SESS_NO_PULL  live acc=1 txn=1 ep=9 w0=0 phi0=40 ans=0xa0c55 p0=0xa0111 bound=1
                  s0 sess=7 cmt=1 w0=-5 ans=0xa00b4 p0=0xa0011 (old snapshot unchanged)
                  s1 sess=9 cmt=0 w0=0  ans=0xa0c55 p0=0xa0111 (new row, not a copy of -5)
NEW_SESS_OLD_REW  delayed {7,1,1} while live sess=9: nstale=1 nupd=0 live w0=0
                  persist s0 still w0=-5 sess=7; s1 still w0=0
```

Live `w0=0` ≠ persist A `-5`. New row does not inherit A weights. Old delayed rew is epoch-mismatch stale (`rew_epoch=7 != pend_epoch=9`, `:636`) and does not write either slot.

**Finding:** hunt **4 CLOSED**. New sess does not copy old weights. Old delayed rew does not commit onto the new pending.

---

## Hunt 5 — overclaim DDR / BOARD / Master ASTRA-06?

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 13555 ns, PASS tags, dump fields (`nstale`/`nreuse`/`nrej`/`nrlcmd`/`w0`/`s0w0`/`s0sess`/`s1sess`/`tbl`) match. RESULTS is **not** used as evidence. RESULTS omits REUSE_PICK_REFUSE leftover **retrieval** `ans=0xa00b4` and MATCH_REW leftover `nstale=1` — incomplete, not a false PASS. |
| Editing goldens to PASS | **Not found.** First xvlog/xelab/xsim produced the marker. No fail-r0, no second TB. PRE TB hash = POST `55f4daf7…`. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0` (`r4:241`). Every dump `tbl=0`. `poke_v_i=1'b0` (`:482`). Queries are `send_text("pump requires indirect")` / `"payroll tax form"`. |
| Hash theatre / hash after scores | Freeze **18:35:09** is before xsim **18:35:14–16**. POST **18:35:16** matches compiled bytes. `.svh` in PRE. DUT hash PRE=POST `4bd94762…`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD `b66ef328…`. ISO `w0=5` for +3,x0=50 (symmetric +5, not floor +4). Floor file hashed as not-compiled. |
| DDR / MIG / QSPI / NVM | **Not claimed closed.** ACK `does_not_close` + PREREG + CLOSEOUT list `persistence_DDR`, `NVM_QSPI_journal`, `schemaV2_DDR_store`, `index_eviction_DDR_N_gt_1`. DUT has no MIG/QSPI/DDR persist port. AXI is retrieval only. On-chip no-reset FF array. |
| Master F3 10pp / LM06 / BOARD / ASTRA-13 | **Not claimed closed.** |
| Master ASTRA-06 as a whole | **Not claimed closed.** ACK `gate_claim` and RESULTS “Open (unchanged): Master ASTRA-06 as a whole”. Implementer `PASS_NARROW (this gate only: host sess_id reuse without restore)`. |
| Persist / R2 / R3 DUT patched | **Not found.** Provenance SHAs match those bags’ compiled DUT lines. Live R3 still mints same-sess after rst. Live persist `S_RELOAD` still omits HOLD eids. R4 work dir has no persist/R2/R3 `.sdb`. |
| F2R / F3 / persist / R2 / R3 bag wipe | **Not found.** Prior `xsim.log` session headers unchanged. |
| Naming `ASTRA-06-R4` | **Scope risk, not RESULTS overclaim.** Parent must not promote the filename to Master ASTRA-06 CLOSED. |

**Finding:** **not OVERCLAIM** on the stated bag gate. Master ASTRA-06 / DDR / BOARD remain OPEN as claimed.

---

## Hunt 6 — PROGRAM=NO; hashes include .svh before xvlog?

`ACK.json`: `"PROGRAM": false`, `"jtag": "NO_CALLS"`. CLOSEOUT `BIT=NOT_BUILT PROGRAM=NO`. metrics `"program": false, "bitstream": false`. Bag listing: no `.bit` / `.bin` / program log / `TIMING_EXTRACT.txt`. `run_xsim.ps1` is xvlog/xelab/xsim only.

`.svh` in PRE `TRANSITIVE_INCLUDES` (`a7ng_astra_06_r4_sess_reuse.svh` + crc + both lexicons) written at 18:35:09 **before** xvlog (`run_xsim.ps1:37-75`).

LOOP_STATE `com12=USER_SAYS_PLUGGED_UNPROGRAMMED`, `jtag=NO_CALLS`. This auditor did not open COM12 / JTAG `210319BE776EA`.

**Finding:** PROGRAM=NO. `.svh` hashed before xvlog. No bitstream in this bag.

---

## Overclaim / cheat / tautology

**Not OVERCLAIM** on the stated **bag** gate. Checks that are **weaker than the dump** and must not be mistaken for extra proof:

1. **REUSE_PICK_REFUSE still displays ANSWER** `ans=0xa00b4 npath=2 st=0`. Learning pending is refused (`acc=0 txn=0 nreuse=1`). Retrieval is **not** fail-closed. Same class as R3 `REFUSE_ALL_UNC`. Do not read this as “query refused”.
2. **REUSE_PICK_REFUSE TB** `(txn!==sav_txn || !pend_acc)` is tautological with the required `!pend_acc`. Isolation of the hunt is the dump: `nreuse=1 acc=0 txn=0 persist txn=1`.
3. **NEW_SESS_NO_PULL TB** `(s0_w0 !== wdut[0] || s0_w0===-16'sd5)` is tautological given `s0_w0===-5`. Real no-pull is `wdut[0]===0` and `s1_w0===0` on the dump.
4. **RELOAD_MISMATCH** runs while persist `w0=0` (pre-commit). Proves no rebind, not “did not copy nonzero weights”. Nonzero no-pull is `NEW_SESS_NO_PULL` after `MATCH_REW`.
5. **MATCH_REW leftover `nstale=1`** is hunt-1’s counter (no rst between). Commit discriminator is `nupd=1 cmt=1 w0=-5 s0w0=-5`.
6. **NEW_SESS dump `nreuse=0 nupd=0 nstale=0`** is live-counter reset on `rst_n` (`r4:570-573`), not a wipe of persist (`s0w0=-5` survives).
7. **UNREL_NO_STALE** uses `wipe_rst()` (`persist_clr` + rst) then a **fresh** plant+PICK, then `power_loss` with `restore_en=1` (`nrlauto=1`). It is **not** UNREL on the reuse-refuse path. Proof ports are the hunt (`ans=0 p0=0 tbl=0`). `pend_acc=1` leftover pending (same class as persist/R2/R3).
8. **`sess_match` is `obs_sel` / `slot_sel_i`**, not a search of all persist rows. Auto/cmd restore of “the matching sess” with two occupied slots depends on `slot_sel`. This TB keeps `slot_sel=0` for sess 7.
9. **`sess_reuse` is gated by `persist_en_i`.** This TB `persist_en=1`. Persist-owned policy, not a global sess lock with persist off.
10. **R4 does not wrap/instantiate frozen R3.** New named fork (same pattern 1200Z already accepted for R3 vs persist). Do not claim “wrapped R3 DUT” as compiled evidence. R3 CAP_N=2 eviction is **not** re-proven on this R4 snapshot.
11. **On-chip no-reset FFs** are **not** board power-loss and **not** DDR-across-BRAM-loss. TB `power_loss` is modeled `rst_n` only.
12. **ISO `viso=0`** is an isolated `go_upd` without a prior displayed score; `w0=5` is the law check.
13. **Post-SGD HOLD proof wipe** on MATCH_REW (`ans=0` live) — persist rows stay 20-bit. Same class as R2/R3.
14. **`CAP_N` arrays `[0:1]`** are N=2 copied from R3, not a parameterized N-entry generator and not DDR index eviction.

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify the work-order unknown on this bag’s tests.

Residuals (not P1 for this gate):

1. **Not Master ASTRA-06 (schemaV2 DDR / DDR index N>1 / DDR warm persist / NVM) — 0/10 as this bag, 9/10 if parent ticks Master ASTRA-06 CLOSED.** On-chip sess-reuse refuse. No CRC A-B journal. No MIG/QSPI.

2. **R4 does not instantiate frozen R3 (integrator fork) — 2/10 architecture vs any “wrap R3” parent note, 0/10 vs work-order “new named DUT / do not patch R3”.** Frozen R3 SHA `99ee5d93…` unpatched; still mints same-sess after rst.

3. **`sess_match` / auto-reload keyed by `slot_sel` not by sess search — 2/10.** `r4:300-305`, `:358-359`, `:605-610`. Two-slot restore of sess 7 while `slot_sel` points at sess 9 is untested.

4. **Mismatch reload with **nonzero** persist weights untested — 2/10 as residual, 0/10 as this unknown.** RELOAD_MISMATCH is pre-commit `w0=0`. NEW_SESS is the nonzero no-pull.

5. **Same-sess PICK **after matching restore** (txn increment / second row) untested — 2/10.** PREREG allows it (`sess_epoch==sess_id` ⇒ `sess_reuse=0`). Could install a second persist row with the same sess_id. Not the leftover (leftover is **without** restore).

6. **`sess_reuse` only while `persist_en_i=1` — 1/10 as this TB** (stays 1). Persist-off remint untested.

7. **`n_sess_rej` can increment every cycle if `reload_i` is held on mismatch — 1/10.** `r4:627-628` is not a one-shot. TB pulses 1 cycle.

8. **Slot arrays hardcoded `[0:1]`, `obs_sel` clamps to {0,1} — 3/10 hygiene, 0/10 as this TB (`CAP_N=2`).** `r4:219-233`, `:300`. Changing `CAP_N` would not add rows.

9. **Post-reload HOLD proof wipe after SGD — 2/10 hygiene.** Restore dump MATCH_RELOAD still 20-bit. Persist dumps stay 20-bit.

10. **UNREL leaves `pend_acc=1` — 3/10.** Same class as F2R UNKNOWN not retiring. Not a stale proof.

11. **QSE entities remain 8-bit — 0/10 as this sess hunt** (proof/fact eids still 20-bit on dumps), **8/10 if renamed Full32 subject persistence.**

12. **On-chip no-reset FFs are not board power-loss — 0/10 as this modeled gate, 9/10 as silicon durability.**

13. **Copied F2R5 semantic/drain FSM + R3 slot occupancy not re-audited here — 3/10 as residual, 0/10 as this unknown.** Smoke+UNREL+high-id plant only. R3 CAP_N=2 eviction remains closed on the **R3 bag**, not re-proven on R4.

14. **`schema_poke_i` can rewrite journal VER whenever `persist_en_i=1` — 2/10 test-hook.** Documented. Not a weight poke.

15. **Persist SGD writeback gated by `persist_en_i` (`:530`, `:555-558`) — 1/10 as this TB** (stays 1).

No remaining **demonstrated** P1 that falsifies the work-order tests.

---

## ASTRA-06 this bag vs Master ASTRA-06 (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| Work-order unknown (rst without restore: delayed `{sess,txn}` `n_stale`; same-sess PICK `n_sess_reuse` not reminted; matching restore delayed rew `w0=-5`; new sess does not pull old w; ISO +5; UNREL no stale proof) | **CLOSED (narrow)** on **ASTRA-06-R4-SESS-REUSE-01 only** | Raw: `REUSE_REW_STALE nstale=1 nupd=0`; `REUSE_PICK_REFUSE nreuse=1 acc=0 txn=0` persist txn=1; `MATCH_RELOAD nrlcmd=1` then `MATCH_REW nupd=1 w0=-5 s0w0=-5`; `NEW_SESS_NO_PULL` live w0=0 ep=9 / s0 sess=7 w0=-5 / s1 sess=9 w0=0; `NEW_SESS_OLD_REW nstale=1`; ISO `w0=5`; UNREL `ans=0 p0=0 tbl=0`. |
| Auditor 1200Z leftover **host sess_id reuse after rst without restore** | **CLOSED_NARROW** | On-chip persist-owned sess. Not DDR session journal. Not BOARD. |
| Auditor 1200Z R3 on-chip persist CAP_N=2 | **still CLOSED_NARROW**; **not re-opened** | Frozen R3 SHA match; bag xsim session untouched. R3 still lacks `sess_reuse` (intentional leftover, closed here on R4). |
| Auditor 1125Z R2 high-id / `reload_i` / persist N=1 | **still CLOSED_NARROW**; **not re-opened** | Frozen R2 SHA match; bag xsim session untouched. High-id still ≥256 on this DUT (`0xa00b4/0xa0011`, `0xa0c55/0xa0111`). |
| Persist bag ASTRA-06-WARM-PERSIST-01 | **still CLOSED_NARROW** (0945Z); **not re-opened** | Frozen DUT SHA match; bag xsim session untouched. |
| Master ASTRA-06 **pending/commit** | **PARTIAL** | Single-issue live pending; rst without restore cannot remint owned sess; matching restore commits. Not a DDR commit store. |
| Master ASTRA-06 **full-ID schema** | **PARTIAL (narrow, inherited)** | 20-bit persist/proof with bits[19:8] tested. Parser still 8-bit. Not Full32 DDR schemaV2. |
| Master ASTRA-06 **migration** | **PARTIAL (narrow, inherited R2)** | On-chip schema byte exists; foreign VER not retested here. Not schemaV2 DDR store migration. |
| Master ASTRA-06 **capacity/eviction** | **PARTIAL (narrow, inherited R3)** | On-chip persist N=2 still present in this fork; **not retested** this bag. **DDR / index N>1 still OPEN.** |
| Master **warm persistence** (DDR retention across BRAM loss) | **OPEN** | Not this experiment. Modeled `rst_n` only. |
| Master **power-loss durability** (NVM checkpoint/journal) | **OPEN** | Not QSPI/SD, no CRC/generation/wear. |
| Master §5 “reset must not create false success” | **PARTIAL (narrow)** | False success = reminting pre-rst `{sess,txn}` / committing delayed rew without restore. Closed on this XSim. Not DDR stalls. |
| F3 / LM06 / BOARD / ASTRA-13 | **OPEN** | Not claimed. |
| F2R items 1–6 / persist modeled journal / R2 N=1 / R3 CAP_N=2 | **not re-opened** | Frozen files unpatched. Prior auditor grades stand. |

Narrow = XSim TB-planted AXI 20-bit fact graph + modeled `rst_n` (not chip POR, not BRAM kill, not NVM) + on-chip persist-owned sess (not DDR session table) + first xvlog/xelab/xsim PASS (no fail-r0). Not Master ASTRA-06, not F3, not LM06, not timing, not BOARD, not a patch of live persist DUT / R2 DUT / R3 DUT.

---

## Frozen-file / bag-preservation verdict

| Object | Verdict |
|--------|---------|
| `a7ng_astra_06_r4_sess_reuse.sv` / `.svh` | New named RTL. Compiled. |
| `a7ng_astra_06_warm_persist.sv` / `.svh` | **Not patched.** Hash `52ebde52…` / `cad5e606…` matches persist-bag compiled DUT. Not in R4 snapshot. Live `S_RELOAD` still omits HOLD eid restore. No `n_sess_reuse`. |
| `a7ng_astra_06_r2_evict_highid.sv` / `.svh` | **Not patched.** Hash `c671f98b…` / `4e96067c…` matches R2-bag compiled DUT. `CAP_N` still unused; `.svh` still N=1. No `n_sess_reuse`. |
| `a7ng_astra_06_r3_multi_slot.sv` / `.svh` | **Not patched.** Hash `99ee5d93…` / `6b511c157…` matches R3-bag compiled DUT. `pick_ok` still lacks `sess_reuse`; auto-reload still ignores sess match. |
| `a7ng_astra_f2r5_txn_wrap.sv` / `.svh` | **Not patched.** Hash `41c77e76…` / `1db76fcc…`. No persist ports. |
| `a7ng_astra_f2r4_axi_drain.sv` / `.svh` | **Not patched.** Hash `5cdb3da8…` / `94887bd4…`. |
| `a7ng_astra_f2r3_sem_guard.sv` | **Not patched.** Hash `9a7a5941…`. |
| `a7ng_astra_f2r2_hs_law.sv` | **Not patched.** Hash `5e2f23c3…`. |
| `a7ng_astra_f3r4_distinct_hold_phi.sv` / `.svh` | **Not patched.** Hash `d12144a99…` / `9f0e5dbd7…`. |
| `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | **Not patched.** Hash `b66ef328…`. Instantiated read-only. |
| F2R-R5 / F3R4 / ASTRA-06-WARM-PERSIST-01 / ASTRA-06-R2-EVICT-HIGHID-01 / ASTRA-06-R3-MULTI-SLOT-01 bags | `xsim.log` session headers unchanged. |

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-06-R4-SESS-REUSE-01`

Narrow = work-order leftover **host sess_id reuse after rst_n without restore**: raw log delayed `{sess=7,txn=1,gen=1}` after rst `nstale=1 nupd=0` persist not written; same-sess PICK `nreuse=1 acc=0 txn=0` persist txn stays 1 (not reminted); mismatch reload `nrej=1 nrlcmd=0` no pull; matching reload `nrlcmd=1` rebinds `{txn=1,gen=1,ep=7}` 20-bit eids; delayed rew `nupd=1 w0=-5` persist `s0w0=-5 sess=7`; new sess 9 after rst live `w0=0` / s0 still `-5` / s1 `w0=0`; old delayed rew while live sess=9 `nstale=1` persist A unchanged; ISO +5; UNREL no stale proof IDs; first sim PASS, no golden edits; persist DUT SHA `52ebde52…`, R2 DUT SHA `c671f98b…`, R3 DUT SHA `99ee5d93…` unpatched. Not Master ASTRA-06 (schemaV2 DDR / DDR index N>1 / DDR warm persist / NVM), not F3, not LM06, not timing, not BOARD_PASS, not a patch of live persist DUT / R2 DUT / R3 DUT, not retrieval-refuse.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this host sess_id reuse-without-restore bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (R4 fork not wrap of R3, `slot_sel` restore, mismatch-reload at w0=0, same-sess PICK after restore untested, retrieval still answers on refuse PICK, leftover live `pend_acc` on UNREL, hardcoded `[0:1]` arrays, post-SGD HOLD proof wipe, `schema_poke` test hook, QSE 8-bit entities, Master ASTRA-06 still OPEN) are **not** P1 for this gate.

Parent: treat auditor **1200Z leftover host sess_id reuse after rst without restore** as CLOSED narrow on **this bag only**. Do **not** tick Master ASTRA-06 CLOSED. Do not reopen the persist modeled-journal bag, R2 high-id/`reload_i`/N=1, R3 on-chip CAP_N=2, F2R2 handshake, F2R3 semantic-guard, F2R4 drain, F2R5 wrap/reset, or F3R4 unique-HASH bags. Do not treat this as F3/LM06/BOARD/DDR/QSPI/DDR-index N>1. Preserve F2R-*, F3*, ASTRA-06-WARM-PERSIST-01, ASTRA-06-R2-EVICT-HIGHID-01, ASTRA-06-R3-MULTI-SLOT-01, and this bag. Do not rerun those `run_*.ps1` in a way that wipes `xsim.log`. Next Master ASTRA-06 leftover is schemaV2 DDR store / DDR index N>1 eviction / DDR-across-BRAM-loss / NVM journal **or** the LM06/BOARD queue — parent chooses; auditor does not open those gates.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of Master ASTRA-06 (full: migration + DDR/index N>1 eviction + schemaV2 DDR + DDR warm persist + NVM) / Master F3 / LM06 / BOARD / COM12 / DDR/MIG production persistence / QSPI journal / live persist-DUT or R2-DUT or R3-DUT patch remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.

ASTRA-06 **this bag** = **CLOSED_NARROW** (host sess_id reuse after rst without restore: delayed `{sess,txn}` `n_stale`; same-sess PICK `n_sess_reuse` not reminted; matching restore delayed rew `w0=-5`; new sess does not copy old weights).  
ASTRA-06 **Master** = **OPEN** (sess-reuse-without-restore **narrow-closed here**; DDR / DDR index N>1 / NVM / Full32 schemaV2 still OPEN).

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1235Z\REPORT.md  ACCEPT_PARTIAL  ASTRA-06-R4 bag=CLOSED_NARROW (host sess_id reuse without restore) / Master ASTRA-06=OPEN
