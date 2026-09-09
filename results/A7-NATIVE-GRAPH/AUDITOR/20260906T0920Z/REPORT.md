# ASTRA auditor REPORT — 20260906T0920Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F3R4_DISTINCT_HOLD_PHI_INDEPENDENT_AUDIT; f3_r4=IMPLEMENTER_CLAIM_PASS_NARROW_MASTER_F3_LEFT_OPEN
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER §8 Transfer + work order ASTRA-F3-R4-DISTINCT-HOLD-PHI-01 + auditor 20260906T0850Z residuals 1–2 (npath/HASH) and 6
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, F2R5 `run_xsim.ps1`, F3 `run_xsim.ps1`, F3R2 `run_xsim.ps1`, F3R3 `run_xsim.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4/F2R5/F3/F3R2/F3R3 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F3-R4-DISTINCT-HOLD-PHI-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f3r4_distinct_hold_phi.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract `rtl/native_graph/integrate/a7ng_astra_f3r4_distinct_hold_phi.svh`. TB `tb_astra_f3r4_distinct_hold_phi.sv` + `tb_oracles.svh` (bag-local). Isolated SGD instance in TB (not DUT weights).

Gate under review is **auditor 20260906T0850Z residuals 1–2** (plus residual 6 / work-order items 1–6), judged against **Master §8 Transfer**, not the implementer headline:

> Transfer: ≥5 seeds; shared learner gain target≥10 percentage points over no-update, paired CI lower bound>0, retention drop≤5pp. Also compare shuffled reward and per-ID controls. UNKNOWN should reject unrelated queries; report selective accuracy and answer coverage so always-UNKNOWN cannot PASS.
> Use held-out entity/world/role combinations, randomized IDs, support-edge interventions and same-query opposite-context cases.

Parent dispatched this bag because F3R3 sampled-worlds (`20260906T0850Z`) was **PASS_NARROW plumbing only**: eight holds printed **identical** `HASH=42d33003` × 8 (dest-remaps of one hold φ); `npath=2` ignored planted shared/private facts (hop-1 stubs, no completing hop2). Master F3 remained OPEN.

**Master F3 (10 pp vs no-update, paired CI lower bound > 0, retention drop ≤ 5 pp) is not this bag’s close**, even if compact XSim counts look large (8/8) and hold HASH values are now unique.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, MIG/DDR production retrieval, power-loss journal, host `sess_id` reuse, 3-hop, patching live F2R2–F2R5 / `a7ng_astra_f3_shared_xfer` / `a7ng_astra_f3r2_ind_worlds` / `a7ng_astra_f3r3_sampled_worlds`.

Frozen `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`, `a7ng_astra_f3r2_ind_worlds.sv`, `a7ng_astra_f3r3_sampled_worlds.sv` must remain **unpatched**. This DUT is a **new named** ranker.

Prior bags `ASTRA-07-HELD-OUT-TRANSFER`, `ASTRA-RTP-F2T-SHARED-TRANSFER`, `ASTRA-F3-SHARED-TRANSFER-01`, `ASTRA-F3-R2-INDEPENDENT-WORLDS-01`, and `ASTRA-F3-R3-SAMPLED-WORLDS-01` are **not** this evidence.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T15:48:23.4426738+07:00`.
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T15:48:31.3979716+07:00` (matches raw log exit `Sun Sep 6 15:48:31 2026`).
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_f3r4_distinct_hold_phi.svh` and bag `tb_oracles.svh`. CONFIG includes `PREREG.md`, `metrics_prereg.json`, `expected_vectors.json` **before** xvlog.

Pass-run compiled + transitive includes vs `SHA256_POST.txt`: **14/14 MATCH** (opened manifests; not re-hashed).

| Path | SHA256.txt / POST |
|------|-------------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_f3r4_distinct_hold_phi.sv` | `d12144a99a53f46e71067babcd6250b0080fb6e424e45ef64037773c10d2379c` |
| `.../tb_astra_f3r4_distinct_hold_phi.sv` | `2911320006c4d43cd281e24717f983a66fc5da6fc407ebd812a7a1ba90f98262` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f3r4_distinct_hold_phi.svh` | `9f0e5dbd733be694f29db76a1461628c88284edd5b3f8834fc5c8bfb39591d79` |
| `.../tb_oracles.svh` | `c0d66f2bf48e3d65f0de8442c267c07fa0dda77559df7f10363231f7a7bcfbe4` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `d2bceb87add0ada6bbb8e1bb17eb55a716534d1b9106846caaaf7c7b3aa19495` |
| `ACK.json` | `e771bc56e6f718906619fcec87067d8bb229077c12f70a215bc7cafa5c08679e` |
| `run_xsim.ps1` | `c31b8ee046224c5e65c8718fe4342ce38c125a78695ed1985897a59bc1d95b44` |
| `metrics_prereg.json` | `0caed4b84e831115466f2b787182447eddad8bd159803d9a227a85257a445574` |
| `expected_vectors.json` | `7730a449fa41d0dba3f25e844074d050e3cc0ca2290691e7e8e42f4a4aa50958` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f3r3_sampled_worlds.sv` | `beaa4bc104706c3a9aad4c06f041e4ed0e675acfa7741a8839a0e0a810111d6e` |
| `.../a7ng_astra_f3r3_sampled_worlds.svh` | `7a692ab9519bec0171ce7f14dad61da266d6ea5eb7f0866e55e047f22dfb39fa` |
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

Overlapping hashes vs F3R3 freeze `ASTRA-F3-R3-SAMPLED-WORLDS-01/SHA256.txt`, F3R2 freeze, F3 freeze, F2R5 freeze, F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, F3R3 DUT `beaa4bc1…` / `.svh` `7a692ab9…`, F3R2 DUT `16519bf0…` / `.svh` `c53ea821…`, F3 DUT `c3183e7a…` / `.svh` `0ffbe950…`, F2R5 DUT `41c77e76…` / `.svh` `1db76fcc…`, F2R4 DUT `5cdb3da8…` / `.svh` `94887bd4…`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live F3R4 DUT is a **new** module `a7ng_astra_f3r4_distinct_hold_phi`. `load_from_tb_o = 1'b0` (`a7ng_astra_f3r4_distinct_hold_phi.sv:115`). `poke_v_i(1'b0)` into sparse (`:235`). `fphi` uses conf/ctx/trans/pol/hop2 only (`:163-196`) — no eid, gold bit, proof index, query ID, or one-hot entity. Ranker FSM/`fphi` is a renamed clone of F3R3 (`a7ng_astra_f3r3_sampled_worlds.sv:162-194` identical packing). `A7NG_F3R4_MAX_PATH=4` (`a7ng_astra_f3r4_distinct_hold_phi.svh:7`). F3R3 already had `A7NG_F3R3_MAX_PATH=4`; the T0850Z `npath=2` residual was **plant completeness**, not a DUT cap of 2.
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends, `SHIFT=6`, `rsh40` symmetric, async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:8`, `:41-48`, `:76-79`, `:85-90`). DUT ties `freeze_i(1'b0)` (`a7ng_astra_f3r4_distinct_hold_phi.sv:262`). `load_v_i` accepted in SGD `IDLE` (`:94-95`); DUT gates it with `st==S_IDLE` (`:264`).
- Live F3R3 DUT `a7ng_astra_f3r3_sampled_worlds` still `load_from_tb_o=1'b0` (`:114`), `poke_v_i(1'b0)`, `freeze_i(1'b0)` (`:261`). Manifest hash **unchanged** vs T0850Z. **Not patched.**
- Live F3R2 DUT `a7ng_astra_f3r2_ind_worlds` still `load_from_tb_o=1'b0` (`:114`). Manifest hash **unchanged**. **Not patched.**
- Live F3 DUT `a7ng_astra_f3_shared_xfer` still `load_from_tb_o=1'b0` (`:114`). Manifest hash **unchanged**. **Not patched.**
- Live F2R5 still has `sess_id_i` / `S_DRAIN` (`a7ng_astra_f2r5_txn_wrap.sv:21`, `:93`). **Not patched.**
- Live F2R4 still has `S_DRAIN` / `S_ABORT` and **no** `sess_id_i`. **Not patched.**
- Live F2R3 still has **no** `S_DRAIN` and **no** `sess_id`. **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` reward match (no epoch port on reward) (`a7ng_astra_f2r2_hs_law.sv:376-377`). **Not patched.**
- Live TB `$finish` at line **523** — raw pass log cites that line.
- `.svh` exists at freeze path. `tb_oracles.svh` identities match `expected_vectors.json` (`TR_W={0,1,2,3,4,0,1,2}`, `HO_W={4,3,0,1,2,4,3,1}`, train gold p0 `{16,20,24,28,32,36,40,44}`, hold dist p0 `{256..284}`, hold gold p0 `{258..286}`, overlap dest 64 on q6/q7, per-world train conf `{200,204,208,212,216}`, per-query hold conf `{220..248}`, hold cx pairs `[(3,1),(3,2),(4,1),(4,2),(5,1),(3,0),(4,0),(5,2)]`).

Bag-claimed log hash (from `metrics.json` / CLOSEOUT; **not** re-hashed here):

```text
xsim.log           27d60953674ba7a693efae37bb7c47bec5a769746d482c4b1bf596a98b9af6b2
```

No `xsim_fail.log` / `xsim_fail_r0.log` / `FAIL_R0.md` in the bag. CLOSEOUT: first run PASS; no golden edits. `xsim_work/xsim.dir/f3r4/xsimcrash.log` is **empty**.

Prior bags **not** overwritten (raw session stamps still present):

- F3R3 `ASTRA-F3-R3-SAMPLED-WORLDS-01/xsim.log` still session `Sun Sep 6 15:22:22 2026` PID **27400**.
- F3R2 `ASTRA-F3-R2-INDEPENDENT-WORLDS-01/xsim.log` still session `Sun Sep 6 14:51:59 2026` PID **47144**.
- F3 `ASTRA-F3-SHARED-TRANSFER-01/xsim.log` still session `Sun Sep 6 14:19:48 2026` PID **28280**.
- F2R5 `xsim.log` still session `Sun Sep 6 13:53:26 2026` PID **5776**.
- F2R4 `xsim.log` still session `Sun Sep 6 13:24:12 2026` PID **47768**.
- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026` PID **34860**.
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026` PID **32496**.
- F2R-01 `ASTRA-F2R-SHARED-RANK-PENDING-01/xsim.log` still `Sun Sep 6 11:40:10 2026` PID **27464**.

Those bags’ run scripts were not rerun.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 15:48:29–15:48:31 2026**, PID **20428**, snapshot `f3r4`, `$finish` at **328365 ns**, TB line **523**.

Zero `FAIL` lines. Marker **present**. `tbl=0` on every dump including UNREL. Ranking dumps `npath=4` (gold 2-hop + dist 2-hop + shared complete 2-hop + private complete 2-hop). INCOMP fifth-path `st=6 npath=4`.

```text
GEN seed=a5f34001 N_WORLDS=5 N_SHARED_2HOP=1 N_PRIVATE_2HOP=1 N_TRAIN=8 N_HOLD=8 N_EPOCH=2 NPATH_RANK=4 MAX_PATH=4
GEN_HO q=0 w=4 ov=0 dst=112 conf=220 cx=3/1 qry=tower requires indirect
...
GEN_HO q=6 w=3 ov=1 dst=64 conf=244 cx=4/0 qry=ahu connects indirect
GEN_HO q=7 w=1 ov=1 dst=64 conf=248 cx=5/2 qry=valve requires indirect
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
FR_Q0_W4 ... ans=144 p0=256 ... nupd=0 phi0=55 vbest=0 w0=0 tbl=0 obj=0 ctx=2 npath=4
PASS FR_Q0_DIST
...
EN_TR_Q0_W0 ... ans=64 p0=16 ... vbest=0 w0=0
EN_TR_Q0_PHI32 50 64 64 0 0 0 64 64 64 0 50 50 64 0 0 64 ... HASH=42d34000
TR_WORLD_HASH w=0 HASH=42d34000
TR_WORLD_HASH w=1 HASH=c2e34000
TR_WORLD_HASH w=2 HASH=42734003
TR_WORLD_HASH w=3 HASH=c2434003
TR_WORLD_HASH w=4 HASH=42134002
PASS UNIQUE_TRAIN_WORLD_HASH_5
EN_HO_E1_Q0_W4 ... ans=112 p0=258 ... nupd=8 vbest=196 w0=35 HASH=c2234001
HOLD_HASH q=0 HASH=c2234001
PHI_NEQ_Q0 train_hash=42d34000 hold_hash=c2234001 neq=1
...
HOLD_HASH_SET c2234001 43334006 c3034006 43534007 c3634007 43f34007 c3c34007 43934005
PASS UNIQUE_HOLD_HASH_8
EN_HO_E2_Q0 ... p0=258 nupd=16 vbest=340 w0=60
EN_HO_RL_Q0 ... p0=258 nupd=0 vbest=340 w0=60 tbl=0 txn=1
SH_TR_Q0 ... ans=144 p0=128 ... HASH=42d34000
PASS SH_TR_Q0_DIST
SH_HO_Q0 ... ans=144 p0=386 ... vbest=196 w0=35 HASH=c2234001
PASS SH_HO_Q0_NOT_GOLD
PASS SH_HO_Q0_DIST
UNREL st=1 npath=0 ans=0 p0=0 ... tbl=0 w0=0
PASS UNREL_UNKNOWN
INCOMP5 st=6 npath=4 ans=0 p0=0 ... tbl=0 obj=0 ctx=2
PASS INCOMP_FIFTH
METRICS en_e1=8/8 en_e2=8/8 en_rl=8/8 fr=0/8 sh=0/8 pid_ov=2/2 pid_dj=0/6 phi_neq=8/8 npath4=64/64 uniq_ho=1 uniq_trw=1 incomp=1 n_rank=64 n_ans=64
PASS EN_E1_8
PASS FR_HOLD_0
PASS SH_HOLD_0
PASS UNIQUE_HOLD_HASH_8 / UNIQ_HO_1
PASS UNIQUE_TRAIN_WORLD_HASH_5 / UNIQ_TRW_1
PASS NPATH4_64
PASS INCOMP_OK
ASTRA_F3R4_DISTINCT_HOLD_PHI_XSIM_PASS
$finish called at time : 328365 ns : File ".../tb_astra_f3r4_distinct_hold_phi.sv" Line 523
```

Hold / train identities vs frozen `expected_vectors.json` / `tb_oracles.svh`:

| q | HO world | FR p0 (dist) | EN e1 p0 (gold) | SH hold p0 (dist) | gold dest | dist dest | EN_HO_E1 HASH |
|---|----------|-------------:|----------------:|------------------:|----------:|----------:|---------------|
| 0 | W4 tower | 256 / ans=144 | 258 / ans=112 | 386 / ans=144 | 112 | 144 | `c2234001` |
| 1 | W3 ahu | 260 / 145 | 262 / 113 | 390 | 113 | 145 | `43334006` |
| 2 | W0 pump | 264 / 146 | 266 / 114 | 394 | 114 | 146 | `c3034006` |
| 3 | W1 valve | 268 / 147 | 270 / 115 | 398 | 115 | 147 | `43534007` |
| 4 | W2 chiller | 272 / 148 | 274 / 116 | 402 | 116 | 148 | `c3634007` |
| 5 | W4 tower | 276 / 149 | 278 / 117 | 406 | 117 | 149 | `43f34007` |
| 6 | W3 ahu overlap | 280 / 150 | 282 / 64 | 410 | 64 | 150 | `c3c34007` |
| 7 | W1 valve overlap | 284 / 151 | 286 / 64 | 414 | 64 | 151 | `43934005` |

Train gold dest is **64** on all 8 (`EN_TR_Q*_W* ans=64`). LAW_SEL=1 `k0=(subj<<8)|rel`: pump-requires 2562, valve-requires 2818, chiller-requires 258, ahu-connects 1539, tower-requires 2306 — matches `F3R4_W_K0` / PREREG catalog. Queries are tokens, not poked keys.

RESULTS.md / `metrics.json` match this raw METRICS line (en_e1 8/8, en_e2 8/8, en_rl 8/8, fr 0/8, sh 0/8, pid_ov 2/2, pid_dj 0/6, phi_neq 8/8, npath4=64/64, uniq_ho=1, uniq_trw=1, incomp=1, n_rank=64 n_ans=64). No RESULTS-vs-log mismatch on counts, PID, sim time, marker, per-query p0, vbest, w0 (reload w0=60 matches e2), or φ hashes. Implementer-claimed hold HASH set **matches raw** `HOLD_HASH_SET` exactly.

`xvlog.log` analyzed `a7ng_astra_f3r4_distinct_hold_phi` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB + query/sparse stack. Zero `ERROR`/`WARNING`. `xelab.log` built snapshot `f3r4`. Work library has `a7ng_astra_f3r4_distinct_hold_phi.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f3r3_sampled_worlds.sdb` / `a7ng_astra_f3r2_ind_worlds.sdb` / `a7ng_astra_f3_shared_xfer.sdb` / `a7ng_astra_f2r5_txn_wrap.sdb` / `a7ng_astra_f2r4_axi_drain.sdb` / `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. Frozen integrators were **not** compiled into this run.

### PREREG vs scores (opened)

`metrics_prereg.json` `observed: null`, `master_f3_claimed: false`, `astra07_24x8_run: false`, Master thresholds recorded as **not retargeted** (`gain_pp_vs_no_update: 10`, `paired_ci_lo: 0`, `retention_drop_pp_max: 5`). `do_not_print_wilson_ci_as_master: true`. Plumbing targets include `en_e1_c: 8`, `phi_neq_c: 8`, `unique_hold_hash: 8`, `unique_train_world_hash: 5`, `npath_rank_c: 64`, `incomp_fifth: 1`, `pid_ov_c_ge: 1`, `pid_dj_c: 0`, `shuffle_mislabels_overlapping_mixed_ctx: true`, `shared_private_in_npath: true`, `phi32_dumped_on_log: true`. PREREG § “Master transfer numbers — not claimed” states the compact protocol cannot close Master F3 **before xvlog**, and is in the PRE hash. ACK `does_not_close` includes `Master_F3_10pp_CI`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`. RESULTS prints **no** Wilson/paired CI. Raw log has **no** Wilson/CI tokens.

---

## Overclaim / cheat / tautology (qstack adversary)

### Hunt 1 — Extract every hold HASH= from raw xsim.log. Are they 8 unique values?

**Yes. Eight pairwise-distinct `HASH=` values on `EN_HO_E1_Q*_PHI32` / `HOLD_HASH q=*`. Implementer claim matches raw log. T0850Z residual 1 (identical `HASH=42d33003` × 8) is CLOSED_NARROW on this bag.**

Raw `HOLD_HASH_SET` (and per-query `HOLD_HASH` / `EN_HO_E1_Q*_PHI32`):

| q | HASH | equals claimed? |
|--:|------|-----------------|
| 0 | `c2234001` | yes |
| 1 | `43334006` | yes |
| 2 | `c3034006` | yes |
| 3 | `43534007` | yes |
| 4 | `c3634007` | yes |
| 5 | `43f34007` | yes |
| 6 | `c3c34007` | yes |
| 7 | `43934005` | yes |

Not `42d33003` × 8. `dump_phi` hashes DUT `pend_phi_o` (`tb:165-172`, `hash32` of 32 signed bytes, seed `F3R4_GEN_SEED=0xA5F34001`). `HOLD_HASH` is the same `hash32(pphi)` (`tb:418-419`), not a TB constant table. `PHI_NEQ` 8/8 vs paired train HASH.

Uniqueness is **constructed knobs**, not independent world-conditioned φ (hunt 6). Letter of residual 1 is met.

### Hunt 2 — Extract train-world HASH uniqueness (5/5?)

**Yes. Five pairwise-distinct train-world HASH values. Letter of work-order item 2 is met.**

Raw `TR_WORLD_HASH`:

| W | HASH | query | conf>>2 = φ[0] |
|--:|------|-------|---------------:|
| 0 | `42d34000` | pump requires indirect | 50 |
| 1 | `c2e34000` | valve requires indirect | 51 |
| 2 | `42734003` | chiller requires indirect | 52 |
| 3 | `c2434003` | ahu connects indirect | 53 |
| 4 | `42134002` | tower requires indirect | 54 |

`EN_TR_Q5` repeats W0 `HASH=42d34000`; `EN_TR_Q6` repeats W1; `EN_TR_Q7` repeats W2. TB `TR_W*_HASH_STABLE` requires that. Unique **per world**, not per train query. Worlds 0–4 differ in φ **only** by conf (`F3R4_TR_CONF_W={200,204,208,212,216}` → `φ[0]=φ[10]=φ[11]=50..54`). All other 32-φ bytes are identical (`64 64 0 0 0 64 64 64 0 … 64 0 0 64`). Query text/keys do not enter `fphi` (non-ID by design). 5/5 uniqueness is a conf knob, not five distinct transferable features.

### Hunt 3 — npath: actually >2 because extra legal hops participate, or still decorative facts? Fifth path INCOMP?

**npath=4 on all 64 ranking dumps because shared and private facts now form complete legal 2-hops that the DUT enumerates and scores. Not stuck at 2. Fifth legal 2-hop → `ST_INCOMP` at cap 4. Extra hops are guaranteed ranking losers (no mixed_ctx, higher p0). Letter of residual 2 / work-order item 3 is met.**

T0850Z F3R3 plant (`tb_astra_f3r3_sampled_worlds.sv:255-258`) wrote hop-1 stubs from `subj` to `0x50`/`0x51` and hop-1 private dead-ends from `subj` — `S_EJ` needs `hop2.src==hop1.obj`; no such edge; raw `npath=2`. F3R3 DUT already had `MAX_PATH=4`. The residual was plant completeness.

F3R4 `plant_q` (`tb:271-274`) now plants **complete** 2-hops:

- shared: `subj → SHARED_MID=80 → SHARED_BG_DST=96`, conf 160, ctx 0/0, trans=1, pol=1
- private: `subj → (0xA0+2W) → (0xB0+2W)`, conf 160, ctx 0/0, trans=1, pol=1

DUT `S_EJ` (`a7ng_astra_f3r4_distinct_hold_phi.sv:381-408`) increments `np` for each legal 2-hop with `np < MAX_PATH`. `S_SC`/`S_SW` scores **all** `np` paths (`:410-416`). Raw ranking dumps: `npath=4` × 64 (`FR` 8 + `EN_TR` 8 + `EN_HO_E1` 8 + `EN_TR_E2` 8 + `EN_HO_E2` 8 + `EN_HO_RL` 8 + `SH_TR` 8 + `SH_HO` 8). `npath4=64/64`. `PASS NPATH4_64`.

Selected `ans` is never dest 96 (shared) or `0xB0+2W` (private). Winners are gold dest 64/112–117 or dist dest 144–151. Extra hops lose because (a) at `w=0` min-p0 tie-break: gold/dist fact IDs 16..286 ≪ shared `0x200+` / private `0x300+`; (b) after +3 on mixed_ctx, extra hops have `phi[12]=0` (ctx 0/0). They **participate** as legal ranked paths; they are **designed losers**. That is not T0850Z “decorative facts ignored by npath.”

Fifth path: `plant_incomp5` (`tb:278-300`) plants 10 facts = 5 complete 2-hops (`plant_post10` + extra `x0/x1` `subj→0x58→0x68`). Raw:

```text
INCOMP5 st=6 npath=4 ans=0 p0=0 ... tbl=0 obj=0 ctx=2
PASS INCOMP_FIFTH
```

`st=6` is `A7NG_F3R4_ST_INCOMP`. `path_ovf` on the 5th legal hop (`:405`) then `S_EI` → INCOMP with `np==4` (`:350`). Not scored (`ans=0`). Cap behavior is real.

### Hunt 4 — Shuffle / per-ID / retention still present or dropped?

**Still present. Not dropped.**

**Shuffle:** independent on-policy stream; mixed_ctx on dist; `pulse_rew(3)` only (no `−3`). Raw `SH_TR_Q*` selected dist (`p0=128..156`, `HASH` = enabled train gold of that world). `SH_HO_Q*` selected dist (`p0=386..414`); `PASS SH_HO_Q*_NOT_GOLD` and `PASS SH_HO_Q*_DIST` 8/8. `sh=0/8`. Shuffle-hold gold lacks mixed_ctx and has min p0 (`SHH_G0=384 < SHH_D0=386`); trained mixed_ctx still picks dist. At w=0 min-p0 would have picked gold; ranking is reversed. Letter of work-order item 5 (mislabels overlapping mixed_ctx) is met. Still **not** a Master shuffled multi-step (query, action, reward) stream.

**Per-ID:** TB dest-keyed `pidmap[ans[7:0]] += 3` after EN_TRAIN (`tb:401`). Raw:

```text
PID_Q0..Q5 ov=0 pg=0 pd=0 pick_gold=0 gdst=112..117
PID_Q6 ov=1 pg=24 pd=0 pick_gold=1 gdst=64 ddst=150
PID_Q7 ov=1 pg=24 pd=0 pick_gold=1 gdst=64 ddst=151
```

`pid_ov=2/2 pid_dj=0/6`. Overlap is the single shared dest 64 used as **every** train gold and hold q6/q7 gold. Not a DUT competing ranker. Same plumbing as F3R3.

**Retention:** after EN_HO_E1, TB does **not** re-query train as the metric. Protocol: no rst → 8 train +3 (`wait_upd(9..16)`) → 8 hold (`EN_HO_E2`); then `snap_w` on q=7 → `hard_rst` → `load_w_snap` (32× `load_v_i` on SGD IDLE) → 8 hold (`EN_HO_RL`). Raw: e2 hold p0=258..286, `nupd=16`, `w0=60`, `vbest=340..350`. Reload hold same p0s, `nupd=0`, `w0=60`, `vbest` match, txn/gen reset to 1. `en_e2=8/8 en_rl=8/8`. Descriptive drop e1−reload = 0 on n=8 is **not** Master ≤5 pp. Not ASTRA-07 8-epoch retention. PREREG said so.

### Hunt 5 — PREREG: Master 10pp/CI claimed or left OPEN before xvlog?

**Honestly capped before xvlog. ASTRA-07 24×8 was not run. Master F3 left OPEN.**

PREREG / ACK / `metrics_prereg.json` all say Master 10 pp / paired CI / retention **will not be claimed**, with reasons (compact TB-AXI, n=8, not ASTRA-07, two epochs + register reload ≠ population curve). `protocol_frozen.astra07_24x8_run: false`. Those files are in `SHA256.txt` CONFIG before xvlog `15:48:23`. Implementer did **not** lower Master 10 pp after scores. Did **not** print Wilson/paired CI. Did **not** relabel the bag Master F3 closed. `metrics.json` `master_f3_claimed: false`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`. RESULTS `MASTER_F3 = OPEN`.

### Hunt 6 — Tautology: unique HASH but still one template with knobs; RESULTS vs log; load_from_tb; ISO +5

**Unique HASH is one mixed_ctx 2-path template with conf/ctx knobs. RESULTS match raw log. `load_from_tb_o=0`. ISO +3,x0=50 → dw0=+5. Not Master confirmation. Not OVERCLAIM of Master F3 (PREREG disclosed the knobs).**

Hold gold 32-φ (idx 0..15; 16–31 zero) from raw `EN_HO_E1_Q*_PHI32`:

| q | φ vector | HASH | knob |
|--:|----------|------|------|
| 0 | 55 64 64 0 **64 64** 64 64 64 0 55 55 **64** 0 0 64 | `c2234001` | conf=220, cx=3/1 |
| 1 | 56 64 64 0 **64 64** 64 64 64 0 56 56 **64** 0 0 64 | `43334006` | conf=224, cx=3/2 |
| 2 | 57 64 64 0 **64 64** 64 64 64 0 57 57 **64** 0 0 64 | `c3034006` | conf=228, cx=4/1 |
| 3 | 58 64 64 0 **64 64** 64 64 64 0 58 58 **64** 0 0 64 | `43534007` | conf=232, cx=4/2 |
| 4 | 59 64 64 0 **64 64** 64 64 64 0 59 59 **64** 0 0 64 | `c3634007` | conf=236, cx=5/1 |
| 5 | 60 64 64 0 **0 0** 64 64 64 0 60 60 **64** 0 0 64 | `43f34007` | conf=240, cx=3/0 |
| 6 | 61 64 64 0 **0 0** 64 64 64 0 61 61 **64** 0 0 64 | `c3c34007` | conf=244, cx=4/0 |
| 7 | 62 64 64 0 **64 64** 64 64 64 0 62 62 **64** 0 0 64 | `43934005` | conf=248, cx=5/2 |

`phi[12]=64` mixed_ctx on **all eight** enabled hold golds. Q0 vs Q1 uniqueness is `φ[0]` 55 vs 56 only (same flags). Q5/Q6 additionally clear `phi[4]`/`phi[5]` because `cx2=0`. Two flag templates × a conf ladder, not eight independent worlds. Train uniqueness is the same ladder at 50..54 with flags `ctx_nz=0` (train cx 1/0). `PHI_NEQ` is paired-query conf/ctx inequality, not a different transferable feature (`phi[12]` is 64 on both sides). `vbest` on EN_HO_E1 now varies 196..201 (conf enters the score) — unlike T0850Z’s identical 190 × 8 — but the **pick** is still mixed_ctx vs dist. Designed 8/8 vs 0/8 vs 0/8 remains constructed: gold = mixed_ctx path; frozen min p0 = dist (`HO_D0=256 < HO_G0=258`). Shuffle plants the opposite.

`GEN_SEED=0xA5F34001` seeds `hash32` and the banner. `TR_W`/`HO_W` are hand-written constants. No runtime sampler. `reset_mem()` every query (`tb:264`) — still designed 2-path (+2 extra) TB-AXI twins, not a persistent sampled corpus.

- **RESULTS vs raw log:** match on METRICS, ISO, UNREL, INCOMP, `$finish` 328365 ns, PID 20428, line 523, per-query p0/vbest/w0/ans, `tbl=0`, `npath=4`, hold HASH set, train-world HASH set, PID pg/pd, marker. No RESULTS-vs-log cheat.
- **`load_from_tb_o`** hardwired `1'b0`. Every dump `tbl=0`. Sparse `poke_v_i=1'b0`. Queries are `send_text` tokens. TB plants AXI postings (disclosed TB-AXI; PREREG). DUT `load_v` is used **after rst** to restore snapped `w_o` for the reload arm — that is the retention test, not query authority.
- **Hash stamp** before xvlog (`15:48:23`) then xsim (`15:48:29–15:48:31`) then POST (`15:48:31`). PREREG/oracles in PRE. RESULTS/`metrics.json` after (not in PRE). No evidence the freeze was taken after looking at scores on **this** hashed run. Cannot prove there was no private dry-run before the freeze (standard limit; no fail archive). No second-pass golden edit (`expected_vectors.json` / `tb_oracles.svh` hashed before xvlog; live identities match log p0s). PREREG disclosed per-query conf/ctx as the HASH mechanism **before** xvlog — not a post-hoc relabel.
- **`ISO_DUT_W0_CLEARED_LAST`** is `wdut[0]===16'sd0` after UNREL (`tb:494`). UNREL is preceded by `hard_rst` then plant q0 train facts then `payroll tax form`; dump `st=1 npath=0 ans=0 p0=0 w0=0`. Non-empty BRAM UNKNOWN.
- **ISO +3, x0=50 → dw0=+5:** raw `ISO_P3 w0=5 viso=0` then `PASS ISO_P3_X50_DW5` (`wiso[0]===5 && wiso[1]===0`). Isolated `u_iso`, not DUT weights. Law: `target=768`, `dw0=RSH(768*50,13)`; symmetric `rsh40`: `(38400+4096)>>>13=5`. `viso=0` is the **pre-update** score latched in `DONE` — expected.

Coverage vs selective accuracy vs UNKNOWN are **separate** in the raw METRICS line (`en_e1=8/8` vs `n_rank=64 n_ans=64` vs `UNREL_UNKNOWN`). UNREL and INCOMP5 are **outside** `n_rank` (`send_text` not `q_s`). Always-UNKNOWN cannot PASS (`FR_Q*_ANSWER` / `EN_HO_E1_Q*_GOLD` require `ST_ANSWER`).

---

## Logic bugs

No DUT logic bug that falsifies the residual-1–2 plumbing marker on this bag (unique hold HASH, unique train-world HASH, `npath=4` from complete extra 2-hops, fifth-path INCOMP).

Noted, not P1 for this bag:

1. DUT SGD `freeze_i` tied to `1'b0`; `freeze_q` from `ctrl_i` only skips `go_upd` in `S_HOLD`. TB never sets `ctrl≠0`. Out of F3R4 scope.
2. No runtime world sampler; `GEN_SEED` hashes φ, does not draw `TR_W`/`HO_W` (hunts 1–2, 6).
3. Extra legal hops enter `npath` and are scored, but are guaranteed losers (high proof IDs, no mixed_ctx). Ranking unknown remains mixed_ctx gold vs dist (hunt 3).
4. Eight hold HASH values are conf/ctx knobs on one mixed_ctx template; `PHI_NEQ` 8/8 is paired-query inequality of that template, not eight independent transferable φ (hunts 1, 6). Train 5/5 HASH is the same conf ladder (hunt 2).
5. Shuffle is an independent two-path on-policy run, not a shuffled multi-step stream (hunt 4). Overlapping mixed_ctx **is** mislabeled here — same plumbing strength as F3R3.
6. Per-ID is TB `pidmap[7:0]`, not a DUT module (hunt 4). Overlap is the single shared dest 64 used as all train gold.
7. F3R4 AXI timeout goes to INCOMP `S_HOLD` without F2R4 drain. Out of this gate (new named ranker).
8. F3R4 DUT is a renamed clone of the F3R3 ranker (`fphi` / FSM / `MAX_PATH=4`). Acceptable as a new named instantiate; npath residual was closed by **plant** completeness, not a new hop engine.
9. `reset_mem()` every query: extra hops exist only inside that query’s AXI image, not as a persistent shared corpus.

Path legality is independent of score (parser latch; `r_two` iff `ctx==2`; no unique-dest CONFLICT). Extra complete 2-hops do form 2-hop (`hop2.src==hop1.obj`). Matches PREREG. Fifth hop INCOMP matches PREREG.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F3-R4-DISTINCT-HOLD-PHI-01`

**Master F3 is OPEN.** Not CLOSED.

Narrow = FPGA-owned frozen symmetric SGD (`ISO +3,x0=50 → dw0=+5`), new named ranker, `load_from_tb_o=0`, token queries, 5 distinct subject-relation **query/keys**, 8 hold queries with **8 unique** `HASH=` on the raw log (`c2234001 43334006 c3034006 43534007 c3634007 43f34007 c3c34007 43934005` — not `42d33003` × 8), 5 unique train-world HASH (`42d34000 c2e34000 42734003 c2434003 42134002`), `npath=4` on 64 ranking queries because shared+private **complete** 2-hops are enumerated and scored (not stuck at 2), fifth legal hop `ST_INCOMP` at cap 4, enabled hold e1 8/8 vs no-update 0/8 vs mixed_ctx-mislabeled shuffle 0/8 (ranking reversed on a min-p0 gold), dest-keyed per-ID 2/2 on overlapping dest 64 and 0/6 on disjoint dests scored on hold, 32-φ + HASH on the log, `PHI_NEQ` 8/8, hold gold after epoch-2 8/8 and after `w_o` snapshot/rst/`load_v_i` 8/8, coverage 64/64 reported separately from selective accuracy, UNREL UNKNOWN on a non-empty plant, `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`, `tbl=0`, RESULTS match raw log, PRE hash includes `.svh` + PREREG, frozen F2R2 SGD and F2R2–F2R5 + F3 shared-xfer + F3R2 + F3R3 integrators **not** compiled into this snapshot and **not** patched in live sources, Master 10 pp/CI **left OPEN before xvlog**, ASTRA-07 24×8 **not run**.

Narrow **excludes**: Master §8 10 pp / paired population CI / retention-over-reload curve; ASTRA-07 24×8; a live sampled-world generator; independent world-conditioned φ (HASH uniqueness is conf/ctx knobs on one mixed_ctx template); shuffled multi-step reward stream; FPGA per-ID competing learner; extra hops that can win; LM06; BOARD; ASTRA-13; DDR production retrieval.

Descriptive 8/8 on n=8 TB-AXI plants with unique HASH knobs is **not** accepted as Master evidence (and was not claimed as such in PREREG). Disclosed “conf/ctx in φ, not dest remaps” is accurate; it is **not** an OVERCLAIM of Master F3.

T0850Z residuals **1–2 are CLOSED_NARROW on this bag** (unique hold HASH; extra legal hops in `npath`; fifth-path INCOMP). Residual 6 (32-φ + HASH on the log, hold ≠ train) remains closed. Shuffle / per-ID / retention plumbing **not dropped**. Residual “do not print Wilson as Master” remains honored.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this **plumbing** bag as PASS_NARROW with Master F3 left OPEN.

Do not dispatch a DUT “fix” against the pass evidence. Do not edit goldens. Do not rerun this bag’s `run_xsim.ps1` in a way that wipes `xsim.log`. Do not patch frozen F2R2–F2R5, F3 shared-xfer, F3R2, or F3R3 RTL.

Residuals below are **not** P1 for this bag. They are the Master F3 / next-bag queue (parent chooses a **new** named bag if it wants Master §8 closed):

1. Unit of analysis is still a designed mixed_ctx 2-path TB-AXI plant. Unique HASH is per-query conf `{220..248}` and cx-pair knobs on **one** transferable feature (`phi[12]=64` × 8). Train 5/5 HASH is conf `{200..216}` only. No runtime sampler (`GEN_SEED` hashes φ, does not draw worlds). Not ASTRA-07 24×8. Not ≥5 Master seeds.
2. Extra legal hops now enter `npath=4` and are scored, but cannot win (designed high p0, `mixed_ctx=0`). Ranking unknown is still gold vs dist mixed_ctx.
3. Shuffled-reward for Master = permute φ→reward pairing on a multi-step stream. This bag’s S3-style mixed_ctx reversal is the right **feature**, still an independent on-policy two-path run.
4. Per-ID for Master = a competing dest/eid-keyed **DUT** predictor. Current 2/2 vs 0/6 is a TB `pidmap[7:0]` on one shared dest 64.
5. Retention for Master = held-out gain after reload/epochs on a population protocol, not 16 updates + register reload on n=8 queries.
6. Do not print Wilson/paired CI on 8 designed binary plants as Master confirmation (already omitted here — keep it that way). Do not relabel unique HASH knobs as Master-scale distinct worlds.

Parent: treat **F3R4 distinct-hold-φ plumbing** as CLOSED_NARROW on **this bag only**. F3R3 sampled-worlds plumbing remains CLOSED_NARROW (`20260906T0850Z`). F3R2 independent-worlds plumbing remains CLOSED_NARROW (`20260906T0815Z`). F3 shared-transfer plumbing remains CLOSED_NARROW (`20260906T0735Z`). F2R items 1–6 remain CLOSED_NARROW on their bags. **Master F3 stays OPEN.** Do not open LM06 or BOARD from this report. Preserve F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 / ASTRA-F3-SHARED-TRANSFER-01 / ASTRA-F3-R2-INDEPENDENT-WORLDS-01 / ASTRA-F3-R3-SAMPLED-WORLDS-01 and this bag. PROGRAM=NO.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

**Master F3 OPEN.** Promotion of Master F3 10 pp/CI/retention / LM06 / BOARD / COM12 / ASTRA-13 / persistence-DDR / power-loss journal remains **REJECT_PROMOTION**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0920Z\REPORT.md  ACCEPT_PARTIAL ; Master F3 OPEN ; hold HASH unique yes
