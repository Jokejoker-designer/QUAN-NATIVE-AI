# ASTRA auditor REPORT — 20260906T0815Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F3R2_INDEPENDENT_WORLDS_INDEPENDENT_AUDIT; f3_r2=IMPLEMENTER_CLAIM_PASS_NARROW_MASTER_F3_LEFT_OPEN
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER §8 Transfer + work order ASTRA-F3-R2-INDEPENDENT-WORLDS-01 + auditor 20260906T0735Z residuals 1–5,7
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, F2R5 `run_xsim.ps1`, F3 `run_xsim.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4/F2R5/F3 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F3-R2-INDEPENDENT-WORLDS-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f3r2_ind_worlds.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract `rtl/native_graph/integrate/a7ng_astra_f3r2_ind_worlds.svh`. TB `tb_astra_f3r2_ind_worlds.sv` + `tb_oracles.svh` (bag-local). Isolated SGD instance in TB (not DUT weights).

Gate under review is **auditor 20260906T0735Z residuals 1–5 and 7** (handoff `ASTRA-F3-R2-INDEPENDENT-WORLDS-01`), judged against **Master §8 Transfer**, not the implementer headline:

> Transfer: ≥5 seeds; shared learner gain target≥10 percentage points over no-update, paired CI lower bound>0, retention drop≤5pp. Also compare shuffled reward and per-ID controls. UNKNOWN should reject unrelated queries; report selective accuracy and answer coverage so always-UNKNOWN cannot PASS.
> Use held-out entity/world/role combinations, randomized IDs, support-edge interventions and same-query opposite-context cases.

Parent dispatched this bag because F3 shared-transfer (`20260906T0735Z`) was **PASS_NARROW plumbing only**: quality twins + identical-φ ID remaps; shuffle was `−3` on gold; per-ID was `train_ans==hold_gold`; retention was train re-query; tautological `ISO_DUT_W0_CLEARED_LAST`.

**Master F3 (10 pp vs no-update, paired CI lower bound > 0, retention drop ≤ 5 pp) is not this bag’s close**, even if compact XSim counts look large.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, MIG/DDR production retrieval, power-loss journal, host `sess_id` reuse, 3-hop, patching live F2R2–F2R5 or `a7ng_astra_f3_shared_xfer`.

Frozen `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv` must remain **unpatched**. This DUT is a **new named** ranker.

Prior bags `ASTRA-07-HELD-OUT-TRANSFER`, `ASTRA-RTP-F2T-SHARED-TRANSFER`, and `ASTRA-F3-SHARED-TRANSFER-01` are **not** this evidence.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T14:51:53.2206373+07:00`.
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T14:52:01.7377123+07:00` (matches raw log exit `Sun Sep 6 14:52:01 2026`).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_f3r2_ind_worlds.svh` and bag `tb_oracles.svh`. CONFIG includes `PREREG.md`, `metrics_prereg.json`, `expected_vectors.json` **before** xvlog.

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
| `rtl/native_graph/integrate/a7ng_astra_f3r2_ind_worlds.sv` | `16519bf03400e178684cb86eda515a212314b38778ca4b93af18f0d67020f1b2` |
| `.../tb_astra_f3r2_ind_worlds.sv` | `efc7e945b73ab87276d29ee0b1db5b6e63e659879b143c4641d172c1f8688227` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f3r2_ind_worlds.svh` | `c53ea8217b96298b2ae5efe3705daa8b2bcc8b6706f594ec67902069dc81732d` |
| `.../tb_oracles.svh` | `c93d67ae9e04e10cada463b1a6dc2ddbbe6803a4116386a043c1974cc0e1a465` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `b620b62e523abd84b1c10dbb344f8535fc69ec0b59954a58f36149fcdb73026f` |
| `ACK.json` | `47416976163f938f554da299415a825069a0995a14e728e3abcf7a8ffb643891` |
| `run_xsim.ps1` | `33fca387d02b509b080bc238c130bbd7a5d77d257bf2541edba21b82f45ab083` |
| `metrics_prereg.json` | `8fab9ba27445e874828b893f03065c51a4b7d97eaaf2b2fffe14957d1b791a5d` |
| `expected_vectors.json` | `b620d9e62cdbc681ea81e57cff8650fc27bb95561c033a65b0df8a61e2deaa5a` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.sv` | `c3183e7a69459e326ab1a1a1cfcb55de4703fef7a75b3f7458a427b044b75bb4` |
| `.../a7ng_astra_f3_shared_xfer.svh` | `0ffbe950745f9fd23a0161e78ac81aff251f9d716fb549d8ea1f3e09dab7aa3b` |
| `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |
| `.../a7ng_astra_f2r5_txn_wrap.svh` | `1db76fcc01170f5abd38958228416e543900b98e76c8db3f895fcbac35e8ab9a` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `.../a7ng_astra_f2r4_axi_drain.svh` | `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` |
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` |

Overlapping hashes vs F3 freeze `ASTRA-F3-SHARED-TRANSFER-01/SHA256.txt`, F2R5 freeze, F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, F3 DUT `c3183e7a…` / `.svh` `0ffbe950…`, F2R5 DUT `41c77e76…` / `.svh` `1db76fcc…`, F2R4 DUT `5cdb3da8…` / `.svh` `94887bd4…`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live F3R2 DUT is a **new** module `a7ng_astra_f3r2_ind_worlds`. `load_from_tb_o = 1'b0` (`a7ng_astra_f3r2_ind_worlds.sv:114`). `poke_v_i(1'b0)` into sparse (`:234`). `fphi` uses conf/ctx/trans/pol/hop2 only (`:162-194`) — no eid, gold bit, proof index, query ID, or one-hot entity.
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends, `SHIFT=6`, `rsh40` symmetric, async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:8`, `:41-48`, `:76-79`, `:85-90`). DUT ties `freeze_i(1'b0)` (`a7ng_astra_f3r2_ind_worlds.sv:261`). `load_v_i` accepted in SGD `IDLE` (`:94-95`); DUT gates it with `st==S_IDLE` (`:263`).
- Live F3 DUT `a7ng_astra_f3_shared_xfer` still `load_from_tb_o=1'b0` (`:114`), `poke_v_i(1'b0)` (`:234`), `freeze_i(1'b0)` (`:261`). Manifest hash **unchanged** vs T0735Z. **Not patched.**
- Live F2R5 still has `sess_id_i` / `S_DRAIN` (`a7ng_astra_f2r5_txn_wrap.sv:21`, `:93`). **Not patched.**
- Live F2R4 still has `S_DRAIN` / `S_ABORT` and **no** `sess_id_i`. **Not patched.**
- Live F2R3 still has **no** `S_DRAIN` and **no** `sess_id`. **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` reward match only (no epoch port on reward) (`a7ng_astra_f2r2_hs_law.sv:24-25`, `:376-377`). **Not patched.**
- Live TB `$finish` at line **522** — raw pass log cites that line.
- `.svh` exists at freeze path. `tb_oracles.svh` identities match `expected_vectors.json` (`0x211=529`, `0x411=1041`, `0x611=1553`, `0x811=2065`, `0xC10=3088`).

Bag-claimed log hash (from `metrics.json` / CLOSEOUT; **not** re-hashed here):

```text
xsim.log           5ba49f7d0838a4bf8abb1135cb7229e1e0b1c49fedbe268ba7c1c29b2db2dd56
```

No `xsim_fail.log` / `xsim_fail_r0.log` / `FAIL_R0.md` in the bag. CLOSEOUT: first run PASS; no golden edits. `xsim_work/xsim.dir/f3r2/xsimcrash.log` is **empty**.

Prior bags **not** overwritten (raw session stamps still present):

- F3 `ASTRA-F3-SHARED-TRANSFER-01/xsim.log` still session `Sun Sep 6 14:19:48 2026` PID **28280**.
- F2R5 `xsim.log` still session `Sun Sep 6 13:53:26 2026` PID **5776**.
- F2R4 `xsim.log` still session `Sun Sep 6 13:24:12 2026` PID **47768**.
- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026` PID **34860**.
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026` PID **32496**.
- F2R-01 `ASTRA-F2R-SHARED-RANK-PENDING-01/xsim.log` still `Sun Sep 6 11:40:10 2026` PID **27464**.

Those bags’ run scripts were not rerun.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 14:51:59–14:52:01 2026**, PID **47144**, snapshot `f3r2`, `$finish` at **148845 ns**, TB line **522**.

Zero `FAIL` lines. Marker **present**. `tbl=0` on every dump including UNREL.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
S0_FR_HOLD ... ans=129 p0=273 ... phi0=2 vbest=0 w0=0 tbl=0 obj=0 ctx=1
PASS S0_FR_ANSWER
PASS S0_FR_DIST
S0_EN_TRAIN ... ans=20 p0=17 p1=34 ... phi0=50 vbest=0 w0=0 tbl=0 obj=0 ctx=2
PASS S0_EN_TRAIN_GOLD
PASS NUPD_1
S0_EN_HOLD_E1 ... ans=128 p0=529 ... nupd=1 phi0=50 vbest=26 w0=5 tbl=0 obj=0 ctx=1
PASS S0_EN_HOLD_GOLD
PASS S0_PHI_NEQ
S0_PID pg=0 pd=0 pick_gold=0
S0_EN_TRAIN_E2 ... p0=17 ... nupd=1 vbest=38 w0=5
PASS NUPD_2
S0_EN_HOLD_E2 ... p0=529 ... nupd=2 vbest=50 w0=9
S0_EN_HOLD_RL ... p0=529 ... nupd=0 vbest=50 w0=9 tbl=0
PASS S0_EN_HOLD_RL_GOLD
S0_SH_TRAIN ... ans=21 p0=16 p1=33 ... phi0=2 vbest=0 w0=0 ctx=2
PASS S0_SH_TRAIN_DIST
S0_SH_HOLD ... ans=129 p0=273 ... nupd=1 phi0=2 vbest=15 w0=0 tbl=0 ctx=1
PASS S0_SH_HOLD_NOT_GOLD
S1_FR_HOLD ... ans=131 p0=785 p1=802 ... ctx=2
S1_EN_TRAIN ... ans=34 p0=40 ... ctx=1
S1_EN_HOLD_E1 ... ans=130 p0=1041 p1=1058 ... vbest=26 w0=5 ctx=2
PASS S1_PHI_NEQ
S1_PID pg=0 pd=0 pick_gold=0
S1_EN_HOLD_E2 ... vbest=52 w0=10
S1_EN_HOLD_RL ... nupd=0 vbest=52 w0=10
S1_SH_TRAIN ... ans=35 p0=39 ... phi0=50 ctx=1
S1_SH_HOLD ... ans=131 p0=785 ... vbest=15 w0=5 ctx=2
S2_FR_HOLD ... ans=3 p0=1297 p1=1314 ... obj=3 ctx=2
S2_EN_TRAIN ... ans=4 p0=50 p1=51 ... obj=4 ctx=2
S2_EN_HOLD_E1 ... ans=3 p0=1553 p1=1570 ... vbest=30 w0=5 obj=3
PASS S2_PHI_NEQ
S2_PID pg=0 pd=0 pick_gold=0
S2_EN_HOLD_E2 / RL ... vbest=60 w0=10
S2_SH_TRAIN ... ans=4 p0=48 p1=49
S2_SH_HOLD ... ans=3 p0=1297 ... vbest=24 w0=5
S3_FR_HOLD ... ans=133 p0=1809 p1=1826 ... npath=2
S3_EN_TRAIN ... ans=36 p0=60 p1=61
S3_EN_HOLD_E1 ... ans=132 p0=2065 p1=2082 ... vbest=27 w0=5
PASS S3_PHI_NEQ
S3_EN_HOLD_E2 / RL ... vbest=54 w0=10
S3_SH_TRAIN ... ans=37 p0=58 p1=59
S3_SH_HOLD ... ans=133 p0=1809 ... vbest=27 w0=5
S4_FR_HOLD ... ans=135 p0=3072 p1=3073 ... ctx=2
S4_EN_TRAIN ... ans=38 p0=70 ... ctx=1
S4_EN_HOLD_E1 ... ans=134 p0=3088 p1=3089 ... vbest=21 w0=5 ctx=2
PASS S4_PHI_NEQ
S4_EN_HOLD_E2 / RL ... vbest=42 w0=10
S4_SH_TRAIN ... ans=39 p0=68 ... ctx=1
S4_SH_HOLD ... ans=135 p0=3072 ... vbest=15 w0=5
UNREL st=1 npath=0 ans=0 p0=0 ... tbl=0 obj=0 ctx=0 w0=0
PASS UNREL_UNKNOWN
PASS ISO_DUT_W0_CLEARED_LAST
METRICS en_e1=5/5 en_e2=5/5 en_rl=5/5 fr=0/5 sh=0/5 pid=0/5 phi_neq=5/5 n_rank=40 n_ans=40
PASS EN_E1_5
PASS FR_HOLD_0
PASS SH_HOLD_0
PASS PID_HOLD_0
PASS PHI_NEQ_5
PASS EN_E2_5
PASS EN_RL_5
ASTRA_F3R2_INDEPENDENT_WORLDS_XSIM_PASS
$finish called at time : 148845 ns : File ".../tb_astra_f3r2_ind_worlds.sv" Line 522
```

Hold p0 identities vs frozen `expected_vectors.json` / `tb_oracles.svh`:

| Seed | FR p0 (dist) | EN e1 p0 (gold) | SH p0 (not gold) | SH train p0 (dist selected) |
|------|-------------:|----------------:|-----------------:|----------------------------:|
| S0 | 273 = 0x111 | 529 = 0x211 | 273 | 16 |
| S1 | 785 = 0x311 | 1041 = 0x411 | 785 | 39 |
| S2 | 1297 = 0x511 | 1553 = 0x611 | 1297 | 48 |
| S3 | 1809 = 0x711 | 2065 = 0x811 | 1809 | 58 |
| S4 | 3072 = 0xC00 | 3088 = 0xC10 | 3072 | 68 |

RESULTS.md / `metrics.json` match this raw METRICS line (en_e1 5/5, en_e2 5/5, en_rl 5/5, fr 0/5, sh 0/5, pid 0/5, phi_neq 5/5, n_rank=40 n_ans=40). No RESULTS-vs-log mismatch on counts, PID, sim time, marker, per-seed p0, vbest, or w0 (S0 reload w0=9; S1–S4 reload w0=10).

`xvlog.log` analyzed `a7ng_astra_f3r2_ind_worlds` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB + query/sparse stack. `xelab.log` built snapshot `f3r2`. Work library has `a7ng_astra_f3r2_ind_worlds.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f3_shared_xfer.sdb` / `a7ng_astra_f2r5_txn_wrap.sdb` / `a7ng_astra_f2r4_axi_drain.sdb` / `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. Frozen integrators were **not** compiled into this run.

Directory keys in `tb_oracles.svh` match LAW_SEL=1 `k0=(subj<<8)|rel` (pump-requires 2562, valve-supplies 2817, chiller-requires 258, ahu-connects 1539, tower-requires 2306, compressor-supplies 1025, sensor-requires 3074, evaporator-requires 770). Queries are tokens, not poked keys.

### PREREG vs scores (opened)

`metrics_prereg.json` `observed: null`, `master_f3_claimed: false`, Master thresholds recorded as **not retargeted** (`gain_pp_vs_no_update: 10`, `paired_ci_lo: 0`, `retention_drop_pp_max: 5`). `do_not_print_wilson_ci_as_master: true`. Plumbing targets include `phi_neq_c: 5`, `shuffle_is_action_pair_permute: true`, `per_id_is_dest_keyed_scored_on_hold: true`, `retention_is_hold_after_epoch2_and_reload: true`. PREREG § “Master transfer numbers — not claimed” states the compact protocol cannot close Master F3 **before xvlog**, and is in the PRE hash. ACK `does_not_close` includes `Master_F3_10pp_CI`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`. RESULTS prints **no** Wilson/paired CI.

---

## Overclaim / cheat / tautology (qstack adversary)

### Hunt 1 — PHI_NEQ 5/5: is hold gold φ actually ≠ train gold φ per seed, or still ID remap?

**Hold gold φ ≠ train gold φ on all 5 seeds. Not five ID-permutations of one plant. Not the T0735Z S0/S3 quality-twin + identical-φ remap.**

`PHI_NEQ` compares the 32-byte **selected** `pend_phi` after EN_TRAIN (train gold) vs EN_HOLD_E1 (hold gold) (`tb_astra_f3r2_ind_worlds.sv:387-441`). Raw log: `PASS S0_PHI_NEQ` … `PASS S4_PHI_NEQ` and `PASS PHI_NEQ_5`. Dump `phi0` is only `pend_phi[0]=conf_min`; it is **50** on both train gold and hold gold for every seed (conf 200→`>>2`=50). φ0 equality does **not** mean vector equality. Full 32-φ is not printed; reconstruction from `wr_f` plants + DUT `fphi` (`a7ng_astra_f3r2_ind_worlds.sv:162-194`) plus 1-hop copy law (`S_ED` copies c2=c1, ctx2=ctx1, t2=0, hop2=0):

| Seed | Train gold φ (selected) | Hold gold φ (selected) | Why ≠ | Shared overlapping features that can transfer |
|------|-------------------------|------------------------|-------|-----------------------------------------------|
| S0 | 2-hop, qctx=2, cx=2/2, trans=1, path2, ctx_match | 1-hop, qctx=1, cx=1, trans=0, path1, ctx_match | hop2 / both_trans / pol_x_trans / path_len | conf_min=50, conf_hi, both_pos, ctx_match |
| S1 | 1-hop valve-supplies, qctx=1, cx=1, ctx_match, path1 | 2-hop chiller-requires, qctx=2, cx=2/2, ctx_match, path2 | hop/trans/path + subj/rel | ctx_match, conf (equal on hold gold vs dist — does not discriminate hold) |
| S2 | 2-hop obj-bound dest=4, cx=0/3, mixed, obj_ctx_h2, ctx_nz=0 | 2-hop obj-bound dest=3, cx=1/5, mixed, obj_ctx_h2, ctx_nz=64 | ctx_nz (and dest/obj) | obj_ctx_h2, mixed, hop2, conf |
| S3 | 2-hop mixed cx=1/0, ctx_nz=0, obj_ctx=0 | 2-hop mixed cx=3/1, ctx_nz=64, obj_ctx=64 | ctx_nz / obj_ctx | mixed_ctx, hop2, conf |
| S4 | 1-hop ctx_nz (fact cx=3, qctx=1 so **not** ctx_match), path1 | 2-hop ctx_nz (cx=1/1, qctx=2, not match), path2 | hop/trans/path | ctx_nz, conf, both_pos |

S0 hold query is `pump requires water` with **obj=0 ctx=1** (water is context, not object-bound). Train is `pump requires indirect` ctx=2. Same subject-relation, **structure/hop/ctx changed**, dests remapped (20 vs 0x80). That is **not** “same φ, new eids.”

S2 and S3 are both 2-hop, so PHI_NEQ is **not** vacuous hop-bit inequality; it is ctx_nz (and obj_ctx on S3) from the hold plant. The **discriminant** that ranking uses can still be shared (obj_ctx / mixed). That is the intended transfer mechanism, not a cheat.

**Not Master-scale “5 independent worlds.”** Still five designed 2-path TB-AXI plants. S0 reuses pump+requires (held-out dests + hop/ctx intervention, not a new subject-relation world). No sampled generator, no 16 queries, no shared+private fact worlds. Plumbing residual 1 is **met**. Master §8 population transfer remains **OPEN**.

### Hunt 2 — independent world/role/relation/support (S0..S4)

Raw queries + plants (`plant_world` / `send_q`):

| Seed | Train query / graph | Hold query / graph | Discriminant | Support / polarity / hop |
|------|---------------------|--------------------|--------------|--------------------------|
| S0 | `pump requires indirect` 2-hop conf 200 vs 8 | `pump requires water` 1-hop conf 200 vs 8 | conf_min / conf_hi | hop 2→1, ctx 2→1, dest 20 vs 0x80 |
| S1 | `valve supplies water` 1-hop ctx-match vs ctx=0 | `chiller requires indirect` 2-hop ctx-match vs ctx=1/1 | ctx_match | subj 11→1, rel supplies→requires, hop 1→2 |
| S2 | `pump requires indirect compressor` hop2-ctx 3 vs 0, dest=4 | `valve requires indirect evaporator` hop2-ctx 5 vs 0, dest=3 | obj_ctx_h2 | subj/obj change; mixed hop1 on hold; object-bound |
| S3 | `ahu connects indirect` mixed cx 1/0 + 1 dead-end | `tower requires indirect` mixed cx 3/1 + 2 dead-ends | mixed_ctx | rel connects→requires; npath=2 (dead-ends do not form 2-hop) |
| S4 | `compressor supplies air` 1-hop ctx_nz (fact cx=3, qctx=1) vs 0 | `sensor requires indirect` 2-hop ctx_nz vs 0 | ctx_nz | subj 4→12, rel supplies→requires, hop 1→2 |

S0 and S3 are **not** quality twins (T0735Z residual): S0 quality+hop; S3 mixed_ctx+dead-ends. Raw EN hold vbest differs (S0=26, S3=27 is coincidence of different feature sets, not identical φ — S0 hold is 1-hop, S3 is 2-hop mixed). S3 hold npath=2 with 6 planted facts (`wr_f` 0x711..0x834) — dead-ends do not become extra paths.

Within each seed, hold gold is still the unique 2-path (or 1-hop pair) member that carries the trained discriminant, and hold dist is planted with **lower p0** so w=0 min-proof0 **must** pick dist (`FR_DIST`). That is designed, disclosed in PREREG, and is **not** five XOR-eid copies of one φ.

### Hunt 3 — Shuffle = permute pairing across actions/stream, not only −3 on gold?

**Letter of residual 2 is met. Not a Master shuffled-reward stream.**

Enabled: plant TRAIN so min p0 = gold, `pulse_rew(3)` on that action.
Shuffle: **independent** `hard_rst` + plant kind=2 with **distractor eids first** (lower p0) and gold-quality path at higher p0; DUT selects dist; `pulse_rew(+3)` on **that** action. Raw:

```text
S0_SH_TRAIN ... ans=21 p0=16 ... phi0=2     (low-conf dist)
S1_SH_TRAIN ... ans=35 p0=39 ... phi0=50    (high-conf, ctx=0)
S2_SH_TRAIN ... ans=4  p0=48
S3_SH_TRAIN ... ans=37 p0=58
S4_SH_TRAIN ... ans=39 p0=68
```

No `pulse_rew(-3)` anywhere in the TB. Not the T0735Z sign-flip.

Adversary note (not a plumbing FAIL): on S0 the selected shuffle action is **low-conf** (`phi0=2`). Symmetric RSH(768×2, 13)=0, so `w0` does not move (`S0_SH_HOLD w0=0`). Hold 1-hop then ties on untrained conf and falls back to min p0=dist. On S1/S2/S4 the selected shuffle action **lacks** the transferable discriminant (ctx_match / obj_ctx / ctx_nz), so those overlapping weights stay 0 and hold 0/5 is mostly min-p0. **S3 is stronger:** shuffle trains `ctx_pair` on dist; hold dist has ctx_pair (cx=2/2=qctx) and gold does not; raw `S3_SH_HOLD vbest=27` on dist vs enabled gold v=27 — ranking is actually reversed, not only tie-break.

This is on-policy +3 on the distractor action of a two-path plant, not a permutation of a multi-step (query, action, reward) stream. PREREG described it before xvlog. Sufficient for residual 2 plumbing. Insufficient for Master §8 shuffled-reward.

### Hunt 4 — Per-ID = dest/eid-keyed predictor on hold, not train_ans==hold_gold?

**Yes, a TB dest-keyed table scored on hold dests. Not an FPGA competing ranker.**

```text
if (ans[19:8]==12'd0) pidmap[ans[7:0]] = pidmap[ans[7:0]] + 3;   // after EN_TRAIN
pg = pidmap[gold_ans_h(seed)[7:0]];
pd = pidmap[dist_ans_h(seed)[7:0]];
pid_picks_hold_gold = (pg > pd) || ((pg==pd) && (gold_p0(seed,1) < dist_p0(seed,1)));
```

(`tb_astra_f3r2_ind_worlds.sv:406-445`)

Raw: `S*_PID pg=0 pd=0 pick_gold=0` on all five, `pid=0/5`. Train dests (20, 0x22, 4, 0x24, 0x26) are disjoint from hold dests (0x80, 0x82, 3, 0x84, 0x86). S2 gold and dist **share** dest=3 (object-bound), so a dest table cannot separate them. Tie → min p0, and hold is planted with dist lower p0, so pid **never** picks hold gold when scores tie.

That is the correct **control outcome** for disjoint-entity transfer (per-ID should not transfer; shared φ should). Residual 4 letter is met. It is **not** a DUT per-ID learner, keys only `ans[7:0]` and only if `ans<256`, and 0/5 is partly by disjoint tables + the same min-p0 tie-break as frozen. Do not read `pid=0/5` as “an on-FPGA per-ID model scored 0/5 on a competing hypothesis class.”

### Hunt 5 — Retention = second epoch/reload on hold, not train re-query?

**Yes.** After EN_HOLD_E1, TB does **not** re-query train as the retention metric. Protocol (`run_seed`): no rst → plant TRAIN again → +3 → `wait_upd(2)` → plant HOLD (`EN_HOLD_E2`); then `snap_w` → `hard_rst` → `load_w_snap` (32× `load_v_i` on SGD IDLE) → plant HOLD (`EN_HOLD_RL`).

Raw S0: e2 hold p0=529 nupd=2 w0=9 vbest=50; reload hold p0=529 nupd=0 w0=9 vbest=50 (txn/gen reset to 1). Hold gold is 0x211=529, **not** train gold 17. Same pattern S1–S4 (reload w0=10 matches e2). Residual 5 letter is met.

This is two SGD updates on the same train φ plus a register reload, **not** ASTRA-07 8-epoch retention. PREREG said so. Descriptive drop e1−reload = 0 on n=5 designed plants is **not** Master ≤5 pp.

### Hunt 6 — PREREG: Master 10pp/CI claimed or left OPEN before xvlog?

**Honestly capped before xvlog.** PREREG / ACK / `metrics_prereg.json` all say Master 10 pp / paired CI / retention **will not be claimed**, with reasons (designed plants, n=5 TB-AXI, not ASTRA-07, two updates + reload ≠ population curve). Those files are in `SHA256.txt` CONFIG before xvlog `14:51:53`. Implementer did **not** lower Master 10 pp after scores. Did **not** print Wilson/paired CI. Did **not** relabel the bag Master F3 closed. `metrics.json` `master_f3_claimed: false`.

### Hunt 7 — Tautology / designed 5/5; RESULTS vs raw log; load_from_tb; hash after scores; ISO +5

- **Designed 5/5 vs 0/5 vs 0/5 is still constructed**, but the construction is no longer “copy train φ onto hold with new eids.” Gold = the hold path that shares the trained non-ID discriminant; frozen min p0 = dist. That **is** the plumbing unknown (shared w moves the pick across a φ that is not an ID remap). It is **not** Master confirmation. Always-UNKNOWN cannot PASS (`FR_ANSWER` / `EN_HOLD_GOLD` require `ST_ANSWER`). Coverage 40/40 is 5 seeds × 8 ranking `q_s` calls (FR hold, EN train, EN hold e1, EN train e2, EN hold e2, EN hold rl, SH train, SH hold) — by construction, not a retrieval stress test.
- **RESULTS vs raw log:** match on METRICS, ISO, UNREL, `$finish` 148845 ns, PID 47144, line 522, per-seed p0/vbest/w0, `tbl=0`, marker.
- **`load_from_tb_o`** hardwired `1'b0`. Every dump `tbl=0`. Sparse `poke_v_i=1'b0`. Queries are `send_text` tokens. TB plants AXI postings (disclosed TB-AXI; PREREG). DUT `load_v` is used **after rst** to restore snapped `w_o` for the reload arm — that is the retention test, not query authority.
- **Hash stamp** before xvlog (`14:51:53`) then xsim (`14:51:59–14:52:01`) then POST (`14:52:01`). PREREG/oracles in PRE. RESULTS/`metrics.json` after (not in PRE). No evidence the freeze was taken after looking at scores on **this** hashed run. Cannot prove there was no private dry-run before the freeze (standard limit; no fail archive). No second-pass golden edit (`expected_vectors.json` / `tb_oracles.svh` hashed before xvlog; live identities match log p0s).
- **`ISO_DUT_W0_CLEARED_LAST`** is now `wdut[0]===16'sd0` after UNREL (`tb_astra_f3r2_ind_worlds.sv:508`). Replaces T0735Z tautology `chk(..., 1'b1)`. UNREL is preceded by `hard_rst` then plant S0 train facts then `payroll tax form`; dump `st=1 npath=0 ans=0 p0=0 w0=0`. Non-empty BRAM UNKNOWN. Residual 7 letter is met.
- **ISO +3, x0=50 → dw0=+5:** raw `ISO_P3 w0=5 viso=0` then `PASS ISO_P3_X50_DW5` (`wiso[0]===5 && wiso[1]===0`). Isolated `u_iso`, not DUT weights. Law: `target=768`, `dw0=RSH(768*50,13)`; symmetric `rsh40`: `(38400+4096)>>>13=5`. `viso=0` is the **pre-update** score latched in `DONE` from `v_sat` — expected.

Coverage vs selective accuracy vs UNKNOWN are **separate** in the raw METRICS line (`en_e1=5/5` vs `n_rank=40 n_ans=40` vs `UNREL_UNKNOWN`). UNREL is **outside** `n_rank` (`send_text` not `q_s`).

---

## Logic bugs

No DUT logic bug that falsifies the residual-1–5,7 plumbing marker.

Noted, not P1 for this bag:

1. DUT SGD `freeze_i` tied to `1'b0`; `freeze_q` from `ctrl_i` only skips `go_upd` in `S_HOLD`. TB never sets `ctrl≠0`. Out of F3R2 scope.
2. Shuffle is an independent two-path on-policy run, not a shuffled multi-step stream. On 4/5 seeds the selected shuffle action lacks the transferable overlapping feature (hunt 3).
3. Per-ID is TB `pidmap[7:0]`, not a DUT module (hunt 4).
4. F3R2 AXI timeout goes to INCOMP `S_HOLD` without F2R4 drain. Out of this gate (new named ranker).
5. Full 32-φ is not dumped; PHI_NEQ is TB-internal (reconstructable from plants; hunt 1).
6. S0 reuses pump+requires (hunt 2). Still a hop/ctx intervention, not a new world draw.

Path legality is independent of score (parser latch; `r_two` iff `ctx==2`; no unique-dest CONFLICT — required so same-dest S2 ranking is not vacuous). S3 dead-ends do not form 2-hop (`npath=2`). S4 1-hop `trans=0` accepted (`S_ED` does not require trans). Matches PREREG.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F3-R2-INDEPENDENT-WORLDS-01`

**Master F3 is OPEN.** Not CLOSED.

Narrow = FPGA-owned frozen symmetric SGD (`ISO +3,x0=50 → dw0=+5`), new named ranker, `load_from_tb_o=0`, token queries, 5 plants that are **not** five XOR copies / identical-φ ID remaps / S0–S3 quality twins, `PHI_NEQ` 5/5 (hold gold φ ≠ train gold φ), enabled hold e1 5/5 vs no-update 0/5 vs distractor-pairing shuffle 0/5, dest-keyed per-ID control 0/5 scored on hold dests, hold gold after epoch-2 5/5 and after `w_o` snapshot/rst/`load_v_i` 5/5, coverage 40/40 reported separately from selective accuracy, UNREL UNKNOWN on a non-empty plant, `ISO_DUT_W0_CLEARED_LAST` is `wdut[0]===0`, `tbl=0`, RESULTS match raw log, PRE hash includes `.svh` + PREREG, frozen F2R2 SGD and F2R2–F2R5 + F3 shared-xfer integrators **not** compiled into this snapshot and **not** patched in live sources.

Narrow **excludes**: Master §8 10 pp / paired population CI / retention-over-reload curve; shuffled multi-step reward stream; FPGA per-ID competing learner; sampled held-out worlds with shared+private facts and 16 queries; LM06; BOARD; ASTRA-13; DDR production retrieval.

Descriptive 5/5 on n=5 designed plants is **not** accepted as Master evidence (and was not claimed as such in PREREG).

T0735Z residuals **1–5 and 7 are CLOSED_NARROW on this bag.** Residual 6 (do not print Wilson as Master) was already honored in F3 shared-transfer and is honored here.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this **plumbing** bag as PASS_NARROW with Master F3 left OPEN.

Do not dispatch a DUT “fix” against the pass evidence. Do not edit goldens. Do not rerun this bag’s `run_xsim.ps1` in a way that wipes `xsim.log`. Do not patch frozen F2R2–F2R5 or F3 shared-xfer RTL.

Residuals below are **not** P1 for this bag. They are the Master F3 / next-bag queue (parent chooses a **new** named bag if it wants Master §8 closed):

1. Unit of analysis is still 5 designed 2-path TB-AXI plants, not a sampled world generator (ASTRA-07: 24 queries × 8 epochs, shared+private facts). S0 is a hop/ctx intervention on pump+requires, not a new subject-relation world.
2. Shuffled-reward for Master = permute φ→reward pairing on a stream where the **transferred overlapping features** get the wrong label — not only independent +3 on a distractor that often **lacks** those features (S0/S1/S2/S4). S3 ctx_pair reversal is the stronger pattern.
3. Per-ID for Master = a competing dest/eid-keyed predictor with overlapping IDs where it could actually win; keep it off the shared `w`. Current 0/5 is disjoint-dest vacuity plus min-p0 tie-break.
4. Retention for Master = held-out gain after reload/epochs on a population protocol, not two updates + register reload on n=5.
5. Do not print Wilson/paired CI on 5 designed binary plants as Master confirmation (already omitted here — keep it that way).
6. Optional: dump the 32-φ (or a hash of it) on PHI_NEQ so the log, not only TB internals, shows vector inequality.

Parent: treat **F3R2 independent-worlds plumbing** as CLOSED_NARROW on **this bag only**. F3 shared-transfer plumbing remains CLOSED_NARROW (`20260906T0735Z`). F2R items 1–6 remain CLOSED_NARROW on their bags. **Master F3 stays OPEN.** Do not open LM06 or BOARD from this report. Preserve F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 / ASTRA-F3-SHARED-TRANSFER-01 and this bag. PROGRAM=NO.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

**Master F3 OPEN.** Promotion of Master F3 10 pp/CI/retention / LM06 / BOARD / COM12 / ASTRA-13 / persistence-DDR / power-loss journal remains **REJECT_PROMOTION**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0815Z\REPORT.md  ACCEPT_PARTIAL ; Master F3 OPEN ; REJECT_PROMOTION
