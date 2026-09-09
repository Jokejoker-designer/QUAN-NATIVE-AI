# ASTRA auditor REPORT — 20260906T0850Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F3R3_SAMPLED_WORLDS_INDEPENDENT_AUDIT; f3_r3=IMPLEMENTER_CLAIM_PASS_NARROW_MASTER_F3_LEFT_OPEN
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER §8 Transfer + work order ASTRA-F3-R3-SAMPLED-WORLDS-01 + auditor 20260906T0815Z residuals 1–4, 6
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, F2R5 `run_xsim.ps1`, F3 `run_xsim.ps1`, F3R2 `run_xsim.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4/F2R5/F3/F3R2 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F3-R3-SAMPLED-WORLDS-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f3r3_sampled_worlds.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract `rtl/native_graph/integrate/a7ng_astra_f3r3_sampled_worlds.svh`. TB `tb_astra_f3r3_sampled_worlds.sv` + `tb_oracles.svh` (bag-local). Isolated SGD instance in TB (not DUT weights).

Gate under review is **auditor 20260906T0815Z residuals 1–4 and 6** (handoff `ASTRA-F3-R3-SAMPLED-WORLDS-01`), judged against **Master §8 Transfer**, not the implementer headline:

> Transfer: ≥5 seeds; shared learner gain target≥10 percentage points over no-update, paired CI lower bound>0, retention drop≤5pp. Also compare shuffled reward and per-ID controls. UNKNOWN should reject unrelated queries; report selective accuracy and answer coverage so always-UNKNOWN cannot PASS.
> Use held-out entity/world/role combinations, randomized IDs, support-edge interventions and same-query opposite-context cases.

ASTRA-07 24 queries × 8 epochs is the **scale reference**, not a required close on this bag if PREREG froze a smaller protocol and left Master F3 OPEN.

Parent dispatched this bag because F3R2 independent-worlds (`20260906T0815Z`) was **PASS_NARROW plumbing only**: unit of analysis still 5 designed 2-path plants; shuffle often lacked overlapping features; per-ID disjoint-dest vacuity; retention two updates on n=5; 32-φ not dumped on the log. Master F3 remained OPEN.

**Master F3 (10 pp vs no-update, paired CI lower bound > 0, retention drop ≤ 5 pp) is not this bag’s close**, even if compact XSim counts look large (8/8).

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, MIG/DDR production retrieval, power-loss journal, host `sess_id` reuse, 3-hop, patching live F2R2–F2R5 / `a7ng_astra_f3_shared_xfer` / `a7ng_astra_f3r2_ind_worlds`.

Frozen `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv` must remain **unpatched**. This DUT is a **new named** ranker.

Prior bags `ASTRA-07-HELD-OUT-TRANSFER`, `ASTRA-RTP-F2T-SHARED-TRANSFER`, `ASTRA-F3-SHARED-TRANSFER-01`, and `ASTRA-F3-R2-INDEPENDENT-WORLDS-01` are **not** this evidence.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T15:22:16.3866102+07:00`.
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T15:22:24.3788427+07:00` (matches raw log exit `Sun Sep 6 15:22:24 2026`).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_f3r3_sampled_worlds.svh` and bag `tb_oracles.svh`. CONFIG includes `PREREG.md`, `metrics_prereg.json`, `expected_vectors.json` **before** xvlog.

Pass-run compiled + transitive includes vs `SHA256_POST.txt`: **14/14 MATCH** (opened manifests; not re-hashed). `SOURCE_HASHES.txt` is a copy of PRE.

| Path | SHA256.txt / POST |
|------|-------------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_f3r3_sampled_worlds.sv` | `beaa4bc104706c3a9aad4c06f041e4ed0e675acfa7741a8839a0e0a810111d6e` |
| `.../tb_astra_f3r3_sampled_worlds.sv` | `8f0cb672ef3a6921dae3783f63c3d27d3e64de75b71398a41d232780f6ba7456` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f3r3_sampled_worlds.svh` | `7a692ab9519bec0171ce7f14dad61da266d6ea5eb7f0866e55e047f22dfb39fa` |
| `.../tb_oracles.svh` | `9bf81acf45a8caf827679dc5c4474ec8445c1c8a1cb1690c89ae303fba968ebe` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `e77362f11f0a5945a9495a5c610d1e150600303590a669ef87d7c4d436ad8688` |
| `ACK.json` | `37d85f21266b12480d93b62269cf243313ea132aa6c99059e9b4cb143648126c` |
| `run_xsim.ps1` | `7f0143e21d2c6b1353d5a424ba917b8ab0a73366f633e422fa5afed1fb9a4b5a` |
| `metrics_prereg.json` | `ed7a9a82b2a27490ff03fc2c12a7a8f7bce4afd7d219f4ec51989028bdb47cf2` |
| `expected_vectors.json` | `85f51ad4c480c452bc493b3818e20b75e7ae24e13f645f5f98f2b3553364c9f2` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f3r2_ind_worlds.sv` | `16519bf03400e178684cb86eda515a212314b38778ca4b93af18f0d67020f1b2` |
| `.../a7ng_astra_f3r2_ind_worlds.svh` | `c53ea8217b96298b2ae5efe3705daa8b2bcc8b6706f594ec67902069dc81732d` |
| `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.sv` | `c3183e7a69459e326ab1a1a1cfcb55de4703fef7a75b3f7458a427b044b75bb4` |
| `.../a7ng_astra_f3_shared_xfer.svh` | `0ffbe950745f9fd23a0161e78ac81aff251f9d716fb549d8ea1f3e09dab7aa3b` |
| `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |
| `.../a7ng_astra_f2r5_txn_wrap.svh` | `1db76fcc01170f5abd38958228416e543900b98e76c8db3f895fcbac35e8ab9a` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `.../a7ng_astra_f2r4_axi_drain.svh` | `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` |
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` |

Overlapping hashes vs F3R2 freeze `ASTRA-F3-R2-INDEPENDENT-WORLDS-01/SHA256.txt`, F3 freeze, F2R5 freeze, F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, F3R2 DUT `16519bf0…` / `.svh` `c53ea821…`, F3 DUT `c3183e7a…` / `.svh` `0ffbe950…`, F2R5 DUT `41c77e76…` / `.svh` `1db76fcc…`, F2R4 DUT `5cdb3da8…` / `.svh` `94887bd4…`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live F3R3 DUT is a **new** module `a7ng_astra_f3r3_sampled_worlds`. `load_from_tb_o = 1'b0` (`a7ng_astra_f3r3_sampled_worlds.sv:114`). `poke_v_i(1'b0)` into sparse (`:234`). `fphi` uses conf/ctx/trans/pol/hop2 only (`:162-194`) — no eid, gold bit, proof index, query ID, or one-hot entity. Ranker FSM/`fphi` is a renamed clone of F3R2 (`a7ng_astra_f3r2_ind_worlds.sv:162-194` identical packing).
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends, `SHIFT=6`, `rsh40` symmetric, async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:8`, `:41-48`, `:76-79`, `:85-90`). DUT ties `freeze_i(1'b0)` (`a7ng_astra_f3r3_sampled_worlds.sv:261`). `load_v_i` accepted in SGD `IDLE` (`:94-95`); DUT gates it with `st==S_IDLE` (`:263`).
- Live F3R2 DUT `a7ng_astra_f3r2_ind_worlds` still `load_from_tb_o=1'b0` (`:114`), `poke_v_i(1'b0)` (`:234`), `freeze_i(1'b0)` (`:261`). Manifest hash **unchanged** vs T0815Z. **Not patched.**
- Live F3 DUT `a7ng_astra_f3_shared_xfer` still `load_from_tb_o=1'b0` (`:114`). Manifest hash **unchanged**. **Not patched.**
- Live F2R5 still has `sess_id_i` / `S_DRAIN` (`a7ng_astra_f2r5_txn_wrap.sv:21`, `:93`). **Not patched.**
- Live F2R4 still has `S_DRAIN` / `S_ABORT` and **no** `sess_id_i`. **Not patched.**
- Live F2R3 still has **no** `S_DRAIN` and **no** `sess_id`. **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` reward match only (no epoch port on reward) (`a7ng_astra_f2r2_hs_law.sv:24-25`, `:376-377`). **Not patched.**
- Live TB `$finish` at line **443** — raw pass log cites that line.
- `.svh` exists at freeze path. `tb_oracles.svh` identities match `expected_vectors.json` (`TR_W={0,1,2,3,4,0,1,2}`, `HO_W={4,3,0,1,2,4,3,1}`, train gold p0 `{16,20,24,28,32,36,40,44}`, hold dist p0 `{256..284}`, hold gold p0 `{258..286}`, overlap dest 64 on q6/q7).

Bag-claimed log hash (from `metrics.json` / CLOSEOUT; **not** re-hashed here):

```text
xsim.log           7db52dbe79cdde396174f322200d3176b700350699fa8a5c390a072d92ee83d4
```

No `xsim_fail.log` / `xsim_fail_r0.log` / `FAIL_R0.md` in the bag. CLOSEOUT: first run PASS; no golden edits. `xsim_work/xsim.dir/f3r3/xsimcrash.log` is **empty**.

Prior bags **not** overwritten (raw session stamps still present):

- F3R2 `ASTRA-F3-R2-INDEPENDENT-WORLDS-01/xsim.log` still session `Sun Sep 6 14:51:59 2026` PID **47144**.
- F3 `ASTRA-F3-SHARED-TRANSFER-01/xsim.log` still session `Sun Sep 6 14:19:48 2026` PID **28280**.
- F2R5 `xsim.log` still session `Sun Sep 6 13:53:26 2026` PID **5776**.
- F2R4 `xsim.log` still session `Sun Sep 6 13:24:12 2026` PID **47768**.
- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026` PID **34860**.
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026` PID **32496**.
- F2R-01 `ASTRA-F2R-SHARED-RANK-PENDING-01/xsim.log` still `Sun Sep 6 11:40:10 2026` PID **27464**.

Those bags’ run scripts were not rerun.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 15:22:22–15:22:24 2026**, PID **27400**, snapshot `f3r3`, `$finish` at **278245 ns**, TB line **443**.

Zero `FAIL` lines. Marker **present**. `tbl=0` on every dump including UNREL. Ranking dumps `npath=2` (gold 2-hop + dist 2-hop only).

```text
GEN seed=a5f33001 N_WORLDS=5 N_SHARED=3 N_PRIVATE=2 N_TRAIN=8 N_HOLD=8 N_EPOCH=2
GEN_TR q=0 w=0 qry=pump requires indirect
...
GEN_HO q=0 w=4 ov=0 dst=112 qry=tower requires indirect
GEN_HO q=6 w=3 ov=1 dst=64 qry=ahu connects indirect
GEN_HO q=7 w=1 ov=1 dst=64 qry=valve requires indirect
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
FR_Q0_W4 ... ans=144 p0=256 ... nupd=0 phi0=50 vbest=0 w0=0 tbl=0 obj=0 ctx=2 npath=2
PASS FR_Q0_DIST
...
FR_Q7_W1 ... ans=151 p0=284 ... vbest=0 w0=0
EN_TR_Q0_W0 ... ans=64 p0=16 ... vbest=0 w0=0
EN_TR_Q0_PHI32 50 64 64 0 0 0 64 64 64 0 50 50 64 0 0 64 ... HASH=42d33000
PASS NUPD_1
EN_TR_Q7_W2 ... ans=64 p0=44 ... vbest=168 w0=30
EN_TR_Q7_PHI32 ... HASH=42d33000
EN_HO_E1_Q0_W4 ... ans=112 p0=258 ... nupd=8 vbest=190 w0=34
EN_HO_E1_Q0_PHI32 50 64 64 0 64 64 64 64 64 0 50 50 64 0 0 64 ... HASH=42d33003
PASS PHI_NEQ_Q0
PHI_NEQ_Q0 train_hash=42d33000 hold_hash=42d33003 neq=1
PID_Q0 ov=0 pg=0 pd=0 pick_gold=0 gdst=112 ddst=144
...
PID_Q6 ov=1 pg=24 pd=0 pick_gold=1 gdst=64 ddst=150
PID_Q7 ov=1 pg=24 pd=0 pick_gold=1 gdst=64 ddst=151
EN_TR_E2_Q7 ... nupd=15 vbest=318 w0=56
EN_HO_E2_Q0 ... p0=258 nupd=16 vbest=335 w0=59
EN_HO_RL_Q0 ... p0=258 nupd=0 vbest=335 w0=59 tbl=0 txn=1
SH_TR_Q0 ... ans=144 p0=128 ... HASH=42d33000
PASS SH_TR_Q0_DIST
SH_HO_Q0 ... ans=144 p0=386 ... vbest=190 w0=34 HASH=42d33003
PASS SH_HO_Q0_NOT_GOLD
PASS SH_HO_Q0_DIST
UNREL st=1 npath=0 ans=0 p0=0 ... tbl=0 w0=0
PASS UNREL_UNKNOWN
PASS ISO_DUT_W0_CLEARED_LAST
METRICS en_e1=8/8 en_e2=8/8 en_rl=8/8 fr=0/8 sh=0/8 pid_ov=2/2 pid_dj=0/6 phi_neq=8/8 n_rank=64 n_ans=64
PASS EN_E1_8
PASS FR_HOLD_0
PASS SH_HOLD_0
PASS PID_OV_GE1
PASS PID_DJ_0
PASS PHI_NEQ_8
PASS EN_E2_8
PASS EN_RL_8
ASTRA_F3R3_SAMPLED_WORLDS_XSIM_PASS
$finish called at time : 278245 ns : File ".../tb_astra_f3r3_sampled_worlds.sv" Line 443
```

Hold / train identities vs frozen `expected_vectors.json` / `tb_oracles.svh`:

| q | HO world | FR p0 (dist) | EN e1 p0 (gold) | SH hold p0 (dist) | gold dest | dist dest |
|---|----------|-------------:|----------------:|------------------:|----------:|----------:|
| 0 | W4 tower | 256 / ans=144 | 258 / ans=112 | 386 / ans=144 | 112 | 144 |
| 1 | W3 ahu | 260 / 145 | 262 / 113 | 390 | 113 | 145 |
| 2 | W0 pump | 264 / 146 | 266 / 114 | 394 | 114 | 146 |
| 3 | W1 valve | 268 / 147 | 270 / 115 | 398 | 115 | 147 |
| 4 | W2 chiller | 272 / 148 | 274 / 116 | 402 | 116 | 148 |
| 5 | W4 tower | 276 / 149 | 278 / 117 | 406 | 117 | 149 |
| 6 | W3 ahu overlap | 280 / 150 | 282 / 64 | 410 | 64 | 150 |
| 7 | W1 valve overlap | 284 / 151 | 286 / 64 | 414 | 64 | 151 |

Train gold dest is **64** on all 8 (`EN_TR_Q*_W* ans=64`). LAW_SEL=1 `k0=(subj<<8)|rel`: pump-requires 2562, valve-requires 2818, chiller-requires 258, ahu-connects 1539, tower-requires 2306 — matches `F3R3_W_K0` / PREREG catalog. Queries are tokens, not poked keys.

RESULTS.md / `metrics.json` match this raw METRICS line (en_e1 8/8, en_e2 8/8, en_rl 8/8, fr 0/8, sh 0/8, pid_ov 2/2, pid_dj 0/6, phi_neq 8/8, n_rank=64 n_ans=64). No RESULTS-vs-log mismatch on counts, PID, sim time, marker, per-query p0, vbest, w0 (reload w0=59 matches e2), or φ hashes.

`xvlog.log` analyzed `a7ng_astra_f3r3_sampled_worlds` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB + query/sparse stack. `xelab.log` built snapshot `f3r3`. Work library has `a7ng_astra_f3r3_sampled_worlds.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f3r2_ind_worlds.sdb` / `a7ng_astra_f3_shared_xfer.sdb` / `a7ng_astra_f2r5_txn_wrap.sdb` / `a7ng_astra_f2r4_axi_drain.sdb` / `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. Frozen integrators were **not** compiled into this run.

### PREREG vs scores (opened)

`metrics_prereg.json` `observed: null`, `master_f3_claimed: false`, `astra07_24x8_run: false`, Master thresholds recorded as **not retargeted** (`gain_pp_vs_no_update: 10`, `paired_ci_lo: 0`, `retention_drop_pp_max: 5`). `do_not_print_wilson_ci_as_master: true`. Plumbing targets include `en_e1_c: 8`, `phi_neq_c: 8`, `pid_ov_c_ge: 1`, `pid_dj_c: 0`, `shuffle_mislabels_overlapping_mixed_ctx: true`, `per_id_overlap_ids_where_it_could_win: true`, `phi32_dumped_on_log: true`. PREREG § “Master transfer numbers — not claimed” states the compact protocol cannot close Master F3 **before xvlog**, and is in the PRE hash. ACK `does_not_close` includes `Master_F3_10pp_CI`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`. RESULTS prints **no** Wilson/paired CI.

---

## Overclaim / cheat / tautology (qstack adversary)

### Hunt 1 — Are 5 worlds distinct subject-relation, with shared+private facts — or still 2-path designed twins?

**Distinct (subj,rel) query strings: yes. Persistent sampled worlds: no. Ranking unit is still a designed 2-path mixed_ctx plant.**

Frozen catalog (`tb_oracles.svh` / raw `GEN_*`):

| W | Query | subj | rel | k0 |
|---|-------|-----:|----:|---:|
| 0 | `pump requires indirect` | 10 | 2 | 2562 |
| 1 | `valve requires indirect` | 11 | 2 | 2818 |
| 2 | `chiller requires indirect` | 1 | 2 | 258 |
| 3 | `ahu connects indirect` | 6 | 3 | 1539 |
| 4 | `tower requires indirect` | 9 | 2 | 2306 |

Five distinct (subj,rel) tuples. Four share relation `requires`. All queries are `ctx=indirect` 2-hop (`obj=0 ctx=2` on every ranking dump). Not the T0815Z S0 hop/ctx intervention on a single pump-requires text as the *only* world.

There is **no runtime generator**. `F3R3_GEN_SEED=0xA5F33001` seeds `hash32` and the `GEN seed=` banner. `F3R3_TR_W` / `F3R3_HO_W` are hand-written constants `{0,1,2,3,4,0,1,2}` / `{4,3,0,1,2,4,3,1}` designed so `TR_W[i] != HO_W[i]`. PREREG labels this “generator output of seed”; the seed does not draw worlds.

`plant_q` (`tb_astra_f3r3_sampled_worlds.sv:208-259`) does `reset_mem()` **every query**, then plants 8 facts: gold 2-hop, dist 2-hop, two hop-1 stubs (`0x50`/`0x51`), two hop-1 private dead-ends (`0xA0+2W`/`0xA1+2W`). Shared stubs/private never complete 2-hop (`S_EJ` needs hop2.src==hop1.obj; no such edge). Raw `npath=2` on **every** ranking dump. Shared dest `0x40` is the train-gold dest, not a background corpus: hold q0–q5 plants do **not** contain dest 64.

Letter of residual 1 (distinct subj-rel, shared+private planted, N_worlds=5 / N_hold=8 / N_epoch=2 frozen in PREREG, ASTRA-07 not claimed): **met**. Master §8 sampled held-out worlds: **not met**. Still designed 2-path TB-AXI twins with dest remaps.

### Hunt 2 — 8 hold queries: independent draws vs 8 copies of one hold?

**8 copies of one hold-φ template on 5 directory keys, not 8 independent world draws.**

`HO_W = {4,3,0,1,2,4,3,1}`: W4 twice (q0,q5), W3 twice (q1,q6), W1 twice (q3,q7). Identities differ (dests 112–117 vs overlap 64; p0 258,262,…286). φ does **not**.

All 8 enabled-hold gold dumps are bit-identical:

```text
EN_HO_E1_Q*_PHI32 50 64 64 0 64 64 64 64 64 0 50 50 64 0 0 64 ... HASH=42d33003
```

All 8 train gold dumps are bit-identical `HASH=42d33000`. `PHI_NEQ` 8/8 is the **same** hash pair copied eight times. `vbest=190` on every EN_HO_E1 query. Worlds do not enter `fphi` (non-ID by design). Eight hold queries therefore do not multiply the ranking experiment.

Not “8 copies of one hold identity” (dests/p0s/query text differ). Yes “8 copies of one hold template.” Residual 1’s floor of ≥8 hold queries is met. Independence of draws is not.

### Hunt 3 — Shuffle mislabels overlapping transferable features (mixed_ctx), not only +3 on a featureless distractor?

**Yes on this bag. S3-style mixed_ctx reversal on all 8. Letter of residual 2 is met. Not a Master shuffled-reward stream.**

Enabled: gold has mixed_ctx (`cx=1/0` train, `cx=3/1` hold), dist has `cx=0/0`. Shuffle (`kind=2/3`): `gold_has_f=0`, `dist_has_f=1`. No `pulse_rew(-3)` anywhere — only `pulse_rew(3)` (`tb:351,380,409`).

Raw shuffle train selected **dist with mixed_ctx** (same φ as enabled train gold):

```text
SH_TR_Q0 ... ans=144 p0=128 ... HASH=42d33000
```

Shuffle hold: gold **lacks** mixed_ctx and has **min p0** (`SHH_G0=384 < SHH_D0=386`). Trained mixed_ctx still picks dist (`p0=386`, `vbest=190`, `HASH=42d33003` = enabled hold gold φ). `PASS SH_HO_Q*_NOT_GOLD` and `PASS SH_HO_Q*_DIST` 8/8. At w=0, min-p0 would have picked gold; ranking is reversed, not a tie-break.

This fixes T0815Z hunt 3 (S0/S1/S2/S4 shuffle actions often lacked the transferable feature). It is still an independent on-policy two-path run, not a permutation of a multi-step (query, action, reward) stream. PREREG described it before xvlog. Sufficient for residual 2 plumbing. Insufficient for Master §8 shuffled-reward.

### Hunt 4 — Per-ID overlapping IDs where it could win (claim 2/2 overlap, 0/6 disjoint) — TB table or DUT? Overlap real in plant?

**TB dest-keyed table. Overlap is real in the plant (dest 64). Not a DUT competing ranker.**

```text
if (ans[19:8]==12'd0) pidmap[ans[7:0]] = pidmap[ans[7:0]] + 3;   // after EN_TRAIN
pg = pidmap[F3R3_HO_GDST[qi][7:0]];
pd = pidmap[F3R3_HO_DDST[qi][7:0]];
pid_picks_hold = (pg > pd) || ((pg==pd) && (G0 < D0));
```

(`tb_astra_f3r3_sampled_worlds.sv:350,294-299`)

Train gold dest is always `0x40=64` (`EN_TR ans=64` × 8) → `pidmap[64]=24`. Hold q0–q5 gold dests 112–117 disjoint: raw `PID_Q0..Q5 ov=0 pg=0 pd=0 pick_gold=0`. Hold q6/q7 gold dest=64, dist 150/151: raw `PID_Q6/Q7 ov=1 pg=24 pd=0 pick_gold=1`. `pid_ov=2/2 pid_dj=0/6` matches METRICS.

Overlap is **in the plant**: hold q6/q7 `gdst=F3R3_HO_GDST=64` and train `gdst=F3R3_SHARED_DST=64`. It is not diverse entity overlap — it is the single shared dest used as **every** train gold. Disjoint 0/6 is the correct control outcome (shared φ can explain 8/8; dest table cannot explain q0–q5). Residual 4 letter is met. Do not read `pid_ov=2/2` as “an on-FPGA per-ID model scored 2/2.”

### Hunt 5 — PHI/HASH of 32-φ on the **log**, hold ≠ train?

**Yes. 32 signed bytes + HASH on the xsim log. Hold ≠ train. T0815Z residual 6 closed.**

`dump_phi` prints all 32 `pend_phi` bytes and `hash32` (`tb:163-170`). Raw `EN_TR_Q*_PHI32` and `EN_HO_E1_Q*_PHI32` plus `PHI_NEQ_Q* train_hash=... hold_hash=... neq=1`.

| | φ vector (idx 0..15; 16–31 zero) | HASH |
|--|----------------------------------|------|
| train gold (all 8) | 50 64 64 0 **0 0** 64 64 64 0 50 50 **64** 0 0 64 | `42d33000` |
| hold gold (all 8) | 50 64 64 0 **64 64** 64 64 64 0 50 50 **64** 0 0 64 | `42d33003` |

Inequality is `phi[4]` ctx_nz and `phi[5]` obj_ctx from designed hold `cx=3/1` vs train `cx=1/0`. Shared transferable `phi[12]=64` mixed_ctx is **equal**. `PHI_NEQ` is therefore not “hold has a different transferable feature”; it is a designed ctx-pair tweak of the same mixed_ctx path. Still satisfies “hold ≠ train on the log, not TB-internal only.”

### Hunt 6 — Retention epoch-2 + reload on hold queries of this protocol?

**Yes. Hold queries, not train re-query. Letter of residual 4 (0815Z / handoff item 4) is met.**

After EN_HO_E1, TB does **not** re-query train as the retention metric. Protocol: no rst → 8 train +3 (`wait_upd(9..16)`) → 8 hold (`EN_HO_E2`); then `snap_w` on q=7 → `hard_rst` → `load_w_snap` (32× `load_v_i` on SGD IDLE) → 8 hold (`EN_HO_RL`).

Raw: e2 hold p0=258..286 (hold gold, **not** train 16..44), `nupd=16`, `w0=59`, `vbest=335`. Reload hold same p0s, `nupd=0`, `w0=59`, `vbest=335`, txn/gen reset to 1. `en_e2=8/8 en_rl=8/8`. Descriptive drop e1−reload = 0 on n=8 identical-φ plants is **not** Master ≤5 pp. Not ASTRA-07 8-epoch retention. PREREG said so.

### Hunt 7 — PREREG: Master 10pp/CI claimed or left OPEN before xvlog? ASTRA-07 24×8 actually run?

**Honestly capped before xvlog. ASTRA-07 24×8 was not run.**

PREREG / ACK / `metrics_prereg.json` all say Master 10 pp / paired CI / retention **will not be claimed**, with reasons (compact TB-AXI, n=8, not ASTRA-07, two epochs + register reload ≠ population curve). `protocol_frozen.astra07_24x8_run: false`. Those files are in `SHA256.txt` CONFIG before xvlog `15:22:16`. Implementer did **not** lower Master 10 pp after scores. Did **not** print Wilson/paired CI. Did **not** relabel the bag Master F3 closed. `metrics.json` `master_f3_claimed: false`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`.

### Hunt 8 — Tautology 8/8 constructed; RESULTS vs raw log; load_from_tb; hash after scores; ISO +5

- **Designed 8/8 vs 0/8 vs 0/8 is constructed.** Gold = the hold path that carries mixed_ctx; frozen min p0 = dist (`HO_D0=256 < HO_G0=258`). Shuffle plants the opposite. That **is** the plumbing unknown (shared w moves the pick across a non-ID mixed_ctx feature that is not an ID remap). It is **not** Master confirmation. Always-UNKNOWN cannot PASS (`FR_Q*_ANSWER` / `EN_HO_E1_Q*_GOLD` require `ST_ANSWER`). Coverage 64/64 is 8 queries × 8 ranking `q_s` calls (FR hold, EN train, EN hold e1, EN train e2, EN hold e2, EN hold rl, SH train, SH hold) — by construction, not a retrieval stress test. Eight “worlds” do not diversify φ: 8 SGD steps on `HASH=42d33000` then 8 more in epoch-2 (`w0` 0→5→10→14→18→22→26→30→34 then 38→41→44→47→50→53→56→59).
- **RESULTS vs raw log:** match on METRICS, ISO, UNREL, `$finish` 278245 ns, PID 27400, line 443, per-query p0/vbest/w0/ans, `tbl=0`, `npath=2`, φ hashes `42d33000`/`42d33003`, PID pg/pd, marker.
- **`load_from_tb_o`** hardwired `1'b0`. Every dump `tbl=0`. Sparse `poke_v_i=1'b0`. Queries are `send_text` tokens. TB plants AXI postings (disclosed TB-AXI; PREREG). DUT `load_v` is used **after rst** to restore snapped `w_o` for the reload arm — that is the retention test, not query authority.
- **Hash stamp** before xvlog (`15:22:16`) then xsim (`15:22:22–15:22:24`) then POST (`15:22:24`). PREREG/oracles in PRE. RESULTS/`metrics.json` after (not in PRE). No evidence the freeze was taken after looking at scores on **this** hashed run. Cannot prove there was no private dry-run before the freeze (standard limit; no fail archive). No second-pass golden edit (`expected_vectors.json` / `tb_oracles.svh` hashed before xvlog; live identities match log p0s).
- **`ISO_DUT_W0_CLEARED_LAST`** is `wdut[0]===16'sd0` after UNREL (`tb:427`). UNREL is preceded by `hard_rst` then plant q0 train facts then `payroll tax form`; dump `st=1 npath=0 ans=0 p0=0 w0=0`. Non-empty BRAM UNKNOWN.
- **ISO +3, x0=50 → dw0=+5:** raw `ISO_P3 w0=5 viso=0` then `PASS ISO_P3_X50_DW5` (`wiso[0]===5 && wiso[1]===0`). Isolated `u_iso`, not DUT weights. Law: `target=768`, `dw0=RSH(768*50,13)`; symmetric `rsh40`: `(38400+4096)>>>13=5`. `viso=0` is the **pre-update** score latched in `DONE` — expected.

Coverage vs selective accuracy vs UNKNOWN are **separate** in the raw METRICS line (`en_e1=8/8` vs `n_rank=64 n_ans=64` vs `UNREL_UNKNOWN`). UNREL is **outside** `n_rank` (`send_text` not `q_s`).

---

## Logic bugs

No DUT logic bug that falsifies the residual-1–4,6 plumbing marker on this bag.

Noted, not P1 for this bag:

1. DUT SGD `freeze_i` tied to `1'b0`; `freeze_q` from `ctrl_i` only skips `go_upd` in `S_HOLD`. TB never sets `ctrl≠0`. Out of F3R3 scope.
2. No runtime world sampler; `GEN_SEED` does not draw `TR_W`/`HO_W` (hunt 1).
3. Shared+private facts never enter `npath` (always 2). Decorative relative to the ranker unknown (hunt 1).
4. Eight hold queries share one φ; `PHI_NEQ` 8/8 is one designed ctx-pair inequality copied eight times (hunts 2, 5).
5. Shuffle is an independent two-path on-policy run, not a shuffled multi-step stream (hunt 3). Overlapping mixed_ctx **is** mislabeled here — stronger than F3R2.
6. Per-ID is TB `pidmap[7:0]`, not a DUT module (hunt 4). Overlap is the single shared dest 64 used as all train gold.
7. F3R3 AXI timeout goes to INCOMP `S_HOLD` without F2R4 drain. Out of this gate (new named ranker).
8. F3R3 DUT is a renamed clone of the F3R2 ranker (`fphi` / FSM). Acceptable as a new named instantiate; it does not add world-conditioned features.

Path legality is independent of score (parser latch; `r_two` iff `ctx==2`; no unique-dest CONFLICT). Hop-1 stubs/private do not form 2-hop. Matches PREREG.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F3-R3-SAMPLED-WORLDS-01`

**Master F3 is OPEN.** Not CLOSED.

Narrow = FPGA-owned frozen symmetric SGD (`ISO +3,x0=50 → dw0=+5`), new named ranker, `load_from_tb_o=0`, token queries, 5 distinct subject-relation **query/keys** (not five XOR copies / identical-φ ID remaps / S0–S3 quality twins of T0735Z), 8 hold queries frozen in PREREG, enabled hold e1 8/8 vs no-update 0/8 vs mixed_ctx-mislabeled shuffle 0/8 (ranking reversed on a min-p0 gold), dest-keyed per-ID 2/2 on overlapping dest 64 and 0/6 on disjoint dests scored on hold, 32-φ + HASH on the log (`42d33000` vs `42d33003`), `PHI_NEQ` 8/8, hold gold after epoch-2 8/8 and after `w_o` snapshot/rst/`load_v_i` 8/8, coverage 64/64 reported separately from selective accuracy, UNREL UNKNOWN on a non-empty plant, `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`, `tbl=0`, RESULTS match raw log, PRE hash includes `.svh` + PREREG, frozen F2R2 SGD and F2R2–F2R5 + F3 shared-xfer + F3R2 integrators **not** compiled into this snapshot and **not** patched in live sources, Master 10 pp/CI **left OPEN before xvlog**, ASTRA-07 24×8 **not run**.

Narrow **excludes**: Master §8 10 pp / paired population CI / retention-over-reload curve; ASTRA-07 24×8; a live sampled-world generator; shuffled multi-step reward stream; FPGA per-ID competing learner; shared+private facts that participate in ranking; LM06; BOARD; ASTRA-13; DDR production retrieval.

Descriptive 8/8 on n=8 identical-φ TB-AXI plants is **not** accepted as Master evidence (and was not claimed as such in PREREG). Mild language “sampled” / “generator output of seed” is a stretch of a frozen designed catalog; it is **not** an OVERCLAIM of Master F3.

T0815Z residuals **1–4 and 6 are CLOSED_NARROW on this bag.** Residual 5 (do not print Wilson as Master) remains honored.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this **plumbing** bag as PASS_NARROW with Master F3 left OPEN.

Do not dispatch a DUT “fix” against the pass evidence. Do not edit goldens. Do not rerun this bag’s `run_xsim.ps1` in a way that wipes `xsim.log`. Do not patch frozen F2R2–F2R5, F3 shared-xfer, or F3R2 RTL.

Residuals below are **not** P1 for this bag. They are the Master F3 / next-bag queue (parent chooses a **new** named bag if it wants Master §8 closed):

1. Unit of analysis is still a designed 2-path mixed_ctx TB-AXI plant copied across 5 directory keys. `npath=2` ignores planted shared/private facts. No runtime sampler (`GEN_SEED` hashes φ, does not draw worlds). Not ASTRA-07 24×8.
2. Eight hold queries are eight dest-remapped copies of one hold φ (`HASH=42d33003` × 8), not independent world draws.
3. Shuffled-reward for Master = permute φ→reward pairing on a multi-step stream. This bag’s S3-style mixed_ctx reversal is the right **feature**, still an independent on-policy two-path run.
4. Per-ID for Master = a competing dest/eid-keyed **DUT** predictor. Current 2/2 vs 0/6 is a TB `pidmap[7:0]` on one shared dest 64.
5. Retention for Master = held-out gain after reload/epochs on a population protocol, not 16 updates + register reload on n=8 identical-φ queries.
6. Do not print Wilson/paired CI on 8 designed binary plants as Master confirmation (already omitted here — keep it that way). Do not relabel “sampled” as Master-scale worlds.

Parent: treat **F3R3 sampled-worlds plumbing** as CLOSED_NARROW on **this bag only**. F3R2 independent-worlds plumbing remains CLOSED_NARROW (`20260906T0815Z`). F3 shared-transfer plumbing remains CLOSED_NARROW (`20260906T0735Z`). F2R items 1–6 remain CLOSED_NARROW on their bags. **Master F3 stays OPEN.** Do not open LM06 or BOARD from this report. Preserve F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 / ASTRA-F3-SHARED-TRANSFER-01 / ASTRA-F3-R2-INDEPENDENT-WORLDS-01 and this bag. PROGRAM=NO.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

**Master F3 OPEN.** Promotion of Master F3 10 pp/CI/retention / LM06 / BOARD / COM12 / ASTRA-13 / persistence-DDR / power-loss journal remains **REJECT_PROMOTION**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0850Z\REPORT.md  ACCEPT_PARTIAL ; Master F3 OPEN ; REJECT_PROMOTION
