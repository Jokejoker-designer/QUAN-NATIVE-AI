# ASTRA auditor REPORT — 20260906T0735Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F3_SHARED_TRANSFER_INDEPENDENT_AUDIT; f3_shared_transfer=IMPLEMENTER_CLAIM_PASS_NARROW_MASTER_F3_LEFT_OPEN
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER §8 Transfer + work order ASTRA-F3-SHARED-TRANSFER-01
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests / PREREG (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, `run_f2r3.ps1`, F2R4 `run_xsim.ps1`, F2R5 `run_xsim.ps1`, or this bag’s `run_xsim.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags. Did not spawn agents.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2/F2R3/F2R4/F2R5 freezes (overlapping hashes). Claimed `xsim.log` SHA in `metrics.json` / CLOSEOUT is **not** independently re-hashed here.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F3-SHARED-TRANSFER-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. Contract `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.svh`. TB `tb_astra_f3_shared_xfer.sv` + `tb_oracles.svh` (bag-local). Isolated SGD instance in TB (not DUT weights).

Gate under review is **Master §8 Transfer plumbing only**: after FPGA-owned reward updates on train worlds, do shared non-ID features improve held-out selection vs no-update and vs a shuffled/anti-reward control, on ≥5 seeds that are not five ID-permutations of one plant; UNKNOWN on unrelated; accuracy / coverage / uncertainty reported separately.

**Master F3 (10 pp vs no-update, paired CI lower bound > 0, retention drop ≤ 5 pp) is not this bag’s close**, even if compact XSim counts look large.

Out of this bag’s close: LM06, BOARD_PASS, ASTRA-13, MIG/DDR production retrieval, power-loss journal, host `sess_id` reuse, 3-hop, patching live F2R2–F2R5.

Frozen `a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`, `a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`, `a7ng_astra_f2r5_txn_wrap.sv` must remain **unpatched**. This DUT is a **new named** ranker. Work-order family `astra_f3st01_*` was implemented as `a7ng_astra_f3_shared_xfer` / `tb_astra_f3_shared_xfer`. Naming only.

Prior bags `ASTRA-07-HELD-OUT-TRANSFER` and `ASTRA-RTP-F2T-SHARED-TRANSFER` are **not** this evidence.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T14:19:42.0688048+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T14:19:50.4532859+07:00` (matches raw log exit `Sun Sep 6 14:19:50 2026`).

`run_xsim.ps1` writes `SHA256.txt` (compiled + `TRANSITIVE_INCLUDES` + CONFIG + provenance) **then** calls xvlog. `.svh` is in the pre-xvlog freeze, including new `a7ng_astra_f3_shared_xfer.svh` and bag `tb_oracles.svh`. CONFIG includes `PREREG.md`, `metrics_prereg.json`, `expected_vectors.json` **before** xvlog.

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
| `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.sv` | `c3183e7a69459e326ab1a1a1cfcb55de4703fef7a75b3f7458a427b044b75bb4` |
| `.../tb_astra_f3_shared_xfer.sv` | `7db1678a51e977d7da0203d11263f33f068ddf62b93dc96b5d7ee1575b8422aa` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_f3_shared_xfer.svh` | `0ffbe950745f9fd23a0161e78ac81aff251f9d716fb549d8ea1f3e09dab7aa3b` |
| `.../tb_oracles.svh` | `044ecbe277310aa35abf476b271ee9860dd8492e6dadf460becaa9d7a7c87449` |

CONFIG (PRE only, hashed before xvlog):

| Path | SHA256.txt |
|------|------------|
| `PREREG.md` | `9c5549a39cbcc747aed29127b13c48ae99e5a17777995c0ee502615860c5869a` |
| `ACK.json` | `5fb7dcd1c2f8113aeea459bcc7a6d7e4b8c5d244e0e3e9433bca63c779382d25` |
| `run_xsim.ps1` | `8c0c46d82465273452596bcd2323d8a8d1e817f7b3419018a154817b43a5bda8` |
| `metrics_prereg.json` | `fe2d11f218c45c6cbe21628a81b7b78136e171023f2a45c62a9d9c0983999418` |
| `expected_vectors.json` | `119cdccc54ffa09b174eddd0d139f2177a9279b3a020cca93a0b1d026155e5bb` |

Provenance (hashed in PRE, **not compiled**):

| Path | SHA256.txt |
|------|------------|
| `rtl/native_graph/integrate/a7ng_astra_f2r5_txn_wrap.sv` | `41c77e76fb5bc179b133bbdeba563f8484d3cc5e699438af3cfc521b2f75895b` |
| `.../a7ng_astra_f2r5_txn_wrap.svh` | `1db76fcc01170f5abd38958228416e543900b98e76c8db3f895fcbac35e8ab9a` |
| `rtl/native_graph/integrate/a7ng_astra_f2r4_axi_drain.sv` | `5cdb3da8c53d22333e2af847c839439f1a9e5ee05c4b307194c7236c70fe407b` |
| `.../a7ng_astra_f2r4_axi_drain.svh` | `94887bd4571a245113bfeef5dfe19e90a432cb383a1817f448cb26151646299d` |
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_v1_f2r.sv` | `d34f418b59e38f073f86c89b46b84e60367a154fc846c6725ccf2b3fd233486e` |

Overlapping hashes vs F2R5 freeze `ASTRA-F2R-R5-TXN-WRAP-RESET-01/SHA256.txt`, F2R3 freeze, F2R2 freeze: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD** `b66ef328…`, all three shared `.svh`, F2R5 DUT `41c77e76…` / `.svh` `1db76fcc…`, F2R4 DUT `5cdb3da8…` / `.svh` `94887bd4…`, F2R3 DUT `9a7a5941…`, F2R2 DUT `5e2f23c3…` are **byte-identical in the manifests**.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live F3 DUT is a **new** module `a7ng_astra_f3_shared_xfer`. `load_from_tb_o = 1'b0` (`a7ng_astra_f3_shared_xfer.sv:114`). `poke_v_i(1'b0)` into sparse (`:234`). `fphi` uses conf/ctx/trans/pol/hop2 only (`:162-194`) — no eid, gold bit, proof index, query ID, or one-hot entity.
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends, `SHIFT=6`, `rsh40` symmetric, async `rst_n` zeroing all `w[k]` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:8`, `:41-48`, `:76-79`, `:85-90`). DUT ties `freeze_i(1'b0)` (`a7ng_astra_f3_shared_xfer.sv:261`).
- Live F2R5 still has `sess_id_i` / `S_DRAIN` (`a7ng_astra_f2r5_txn_wrap.sv:21`, `:93`). **Not patched.**
- Live F2R4 still has `S_DRAIN` / `S_ABORT` and **no** `sess_id_i` (`a7ng_astra_f2r4_axi_drain.sv:19-29`, `:87`). **Not patched.**
- Live F2R3 still has **no** `S_DRAIN` and **no** `sess_id`. **Not patched.**
- Live F2R2 integrator still has `{gen,txn}` reward match only (no epoch port) (`a7ng_astra_f2r2_hs_law.sv:15-26`). **Not patched.**
- Live TB `$finish` at line **405** — raw pass log cites that line.
- `.svh` exists at freeze path. `tb_oracles.svh` identities match `expected_vectors.json` (`0x211=529`, `0xC10=3088`, …).

Bag-claimed log hash (from `metrics.json` / CLOSEOUT; **not** re-hashed here):

```text
xsim.log           b6da5fce37c6710f59dfad1ed8e691c7b3bf967f915180f4cf9ecde4955a46ce
```

No `xsim_fail.log` / `xsim_fail_r0.log` / `FAIL_R0.md` in the bag. CLOSEOUT: first run PASS; no golden edits. `xsim_work/xsim.dir/f3x/xsimcrash.log` is **empty**.

Prior bags **not** overwritten (raw session stamps still present):

- F2R5 `xsim.log` still session `Sun Sep 6 13:53:26 2026` PID **5776**.
- F2R4 `xsim.log` still session `Sun Sep 6 13:24:12 2026`.
- F2R3 `xsim.log` still session `Sun Sep 6 12:57:56 2026`.
- F2R2 `xsim.log` still session `Sun Sep 6 12:15:23 2026`.
- F2R-01 `ASTRA-F2R-SHARED-RANK-PENDING-01/xsim.log` still `Sun Sep 6 11:40:10 2026`.

Those bags’ run scripts were not rerun.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 14:19:48–14:19:50 2026**, PID **28280**, snapshot `f3x`, `$finish` at **103615 ns**, TB line **405**.

Zero `FAIL` lines. Marker **present**. `tbl=0` on every dump including UNREL.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
S0_FR_HOLD ... p0=273 ... vbest=0 w0=0 tbl=0 obj=0 ctx=2
PASS S0_FR_ANSWER
PASS S0_FR_DIST
S0_EN_TRAIN ... ans=4 p0=17 ... phi0=50 vbest=0 w0=0 tbl=0
PASS S0_EN_TRAIN_GOLD
PASS NUPD_1
S0_EN_HOLD ... ans=64 p0=529 ... nupd=1 phi0=50 vbest=27 w0=5 tbl=0
PASS S0_EN_HOLD_GOLD
S0_EN_RET ... ans=4 p0=17 ... nupd=1 vbest=27 w0=5 tbl=0
PASS S0_EN_RET_GOLD
S0_SH_HOLD ... p0=273 ... nupd=1 phi0=2 vbest=-18 w0=-5 tbl=0
PASS S0_SH_HOLD_NOT_GOLD
S1_FR_HOLD ... p0=785 ...
S1_EN_HOLD ... p0=1041 ... vbest=38 w0=5
S1_SH_HOLD ... p0=785 ... vbest=-33 w0=-5
S2_FR_HOLD ... ans=4 p0=1297 ... obj=4 ctx=2
S2_EN_HOLD ... ans=4 p0=1553 ... vbest=30 w0=5 obj=4
S2_SH_HOLD ... p0=1297 ... vbest=-24 w0=-5
S3_FR_HOLD ... ans=176 p0=1809 ...
S3_EN_HOLD ... ans=176 p0=2065 ... vbest=27 w0=5
S3_SH_HOLD ... p0=1809 ... vbest=-18 w0=-5
S4_FR_HOLD ... ans=200 p0=3072 p1=0 ... ctx=1
S4_EN_HOLD ... ans=193 p0=3088 p1=0 ... vbest=29 w0=5 ctx=1
S4_SH_HOLD ... ans=200 p0=3072 ... vbest=-18 w0=-5
UNREL st=1 npath=0 ans=0 p0=0 ... tbl=0 obj=0 ctx=0
PASS UNREL_UNKNOWN
METRICS en_hold=5/5 fr_hold=0/5 sh_hold=0/5 pid_hold=0/4 ret=5/5 n_rank=30 n_ans=30
PASS EN_HOLD_5
PASS FR_HOLD_0
PASS SH_HOLD_0
PASS PID_HOLD_0
PASS RET_5
PASS ISO_DUT_W0_CLEARED_LAST
ASTRA_F3_SHARED_TRANSFER_XSIM_PASS
$finish called at time : 103615 ns : File ".../tb_astra_f3_shared_xfer.sv" Line 405
```

Hold p0 identities vs frozen `expected_vectors.json` / `tb_oracles.svh`:

| Seed | FR p0 (dist) | EN p0 (gold) | SH p0 (not gold) |
|------|-------------:|-------------:|-----------------:|
| S0 | 273 = 0x111 | 529 = 0x211 | 273 |
| S1 | 785 = 0x311 | 1041 = 0x411 | 785 |
| S2 | 1297 = 0x511 | 1553 = 0x611 | 1297 |
| S3 | 1809 = 0x711 | 2065 = 0x811 | 1809 |
| S4 | 3072 = 0xC00 | 3088 = 0xC10 | 3072 |

RESULTS.md / `metrics.json` match this raw METRICS line (en 5/5, fr 0/5, sh 0/5, pid 0/4, ret 5/5, n_rank=30 n_ans=30). No RESULTS-vs-log mismatch on counts, PID, sim time, or marker.

`xvlog.log` analyzed `a7ng_astra_f3_shared_xfer` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB + query/sparse stack. `xelab.log` built snapshot `f3x`. Work library has `a7ng_astra_f3_shared_xfer.sdb` and frozen SGD `.sdb`. **No** `a7ng_astra_f2r5_txn_wrap.sdb` / `a7ng_astra_f2r4_axi_drain.sdb` / `a7ng_astra_f2r3_sem_guard.sdb` / `a7ng_astra_f2r2_hs_law.sdb` in this snapshot. Frozen integrators were **not** compiled into this run.

### PREREG vs scores (opened)

`metrics_prereg.json` `observed: null`, `master_f3_claimed: false`, Master thresholds recorded as **not retargeted** (`gain_pp_vs_no_update: 10`, `paired_ci_lo: 0`, `retention_drop_pp_max: 5`). PREREG § “Master transfer numbers — not claimed” states the compact protocol cannot close Master F3 **before xvlog**, and is in the PRE hash. ACK `does_not_close` includes `Master_F3_10pp_CI`. CLOSEOUT `MASTER_F3_10pp_CI = OPEN`.

---

## Overclaim / cheat / tautology (qstack adversary)

### Hunt 1 — 5 seeds: independent structure or 5 ID-permutations / XOR eids of one plant?

**Not 5 XOR-eid copies of one plant.** Across seeds the TB changes query/role/context/path-length and/or mid/support:

| Seed | Query tokens (raw TB) | Discriminant | Path | Dest train/hold |
|------|----------------------|--------------|------|-----------------|
| S0 | `pump requires indirect` | conf 200 vs 8 | 2-hop | 4 / 0x40 |
| S1 | `pump requires indirect` | ctx 2 vs 1, equal conf | 2-hop | 4 / 0x40 |
| S2 | `pump requires indirect compressor` | hop2 ctx 3 vs 0; `obj=4` | 2-hop object-bound | 4 / 4 |
| S3 | `pump requires indirect` | conf 200 vs 8 + dead-end | 2-hop | 11 / 0xB0 |
| S4 | `pump requires water` | 1-hop ctx 1 vs 0 | 1-hop `p1=0` | 11 / 0xC1 |

Train eids `< 80`; hold eids in `0x1xx..0xCxx`. Within each seed, hold is **not** a random world: it is the same 2-path (or 1-hop pair) graph with IDs remapped and p0 ordered so `w=0` min-proof0 picks **dist** on hold and **gold** on train (`tb_astra_f3_shared_xfer.sv:176-263`, `:323-362`).

S0 and S3 share the **same quality φ**. Raw `vbest=27` on both enabled holds (S1=38, S2=30, S4=29). S3’s extra dead-end does not change `npath=2`. That is two quality plants (dest/mid/dead-end decoration), not two independent feature laws.

**Master F3 seed independence is not met** if “5 seeds” is read as 5 independent structure/world draws. **Plumbing bar** (“not 5 ID-permutations of one plant”) **is met**: four distinct discriminants, plus a quality twin.

On S0/S1/S3 gold and distractor share the **same answer dest**; selection is path/`proof0`, not dest. Only S4 gold vs dist differ in answer entity (`ans` 193=0xC1 vs 200=0xC8). S2 dest=4 on train **and** hold (object-bound vocabulary). Held-out **entity** transfer of identical φ, not held-out **world** (shared+private facts, 16 queries).

### Hunt 2 — is “enabled 5/5 vs no-update 0/5 vs shuffle 0/5” circular?

**Yes as a statistical transfer claim; no as a pipeline/ID-disjoint smoke.** Gold **is** the path whose φ matches the trained quality/ctx/object-context rule.

By construction, frozen before xvlog (`PREREG.md:52-57`, `expected_vectors.json`):

1. Train gold has **lower** p0 than train dist → `w=0` picks gold → `+3` / `−3` attach to gold φ.
2. Hold gold has **higher** p0 than hold dist → `w=0` picks dist → frozen arm **must** be 0/5 if tie-break is min p0.
3. Hold gold φ equals train gold φ (IDs differ). After `+3` on that φ, enabled hold **must** pick gold if the ranker uses shared `w` and φ is non-ID.
4. After `−3` on the same φ, shuffle hold **must** not pick gold.

So 5/5 vs 0/5 vs 0/5 does **not** measure Master §8 population gain. It measures: FPGA SGD wrote non-ID weights, hold IDs were not memorized, and argmax `v_q8` moved. That **is** the declared plumbing unknown. It is **not** Master confirmation.

Enabled vs frozen is still causal evidence that **something other than ID / min-p0** moved the pick (hold IDs were absent at train). Shuffle-as-sign-flip is largely redundant with frozen on these 2-path plants (both pick dist if reward is ignored; enabled 5/5 is the arm that proves the update).

### Hunt 3 — did PREREG freeze Master 10 pp/CI then fail it, or honestly cap PASS_NARROW before xvlog?

**Honestly capped before xvlog.** PREREG / ACK / `metrics_prereg.json` all say Master 10 pp / paired CI / retention **will not be claimed**, with reasons (designed plants, n=5 TB-AXI, not ASTRA-07 host twin, retention is one-update smoke). Those files are in `SHA256.txt` CONFIG before xvlog `14:19:42`. Observed 100 pp / CI lo=1 is printed in RESULTS as **descriptive, not Master**. Implementer did **not** lower Master 10 pp after scores. Did **not** relabel the bag Master F3 closed.

Awkward RESULTS heading “Not claimed / Master F3 closed.” is a list of things **not claimed**, not a claim that Master F3 is closed. ACK/CLOSEOUT/`metrics.json` `master_f3_claimed: false`.

### Hunt 4 — coverage vs selective accuracy vs UNKNOWN-on-unrelated, in RAW log?

**Yes, separate.** Raw METRICS: `en_hold=5/5 fr_hold=0/5 sh_hold=0/5` (selective path-gold on ANSWER holds) and `n_rank=30 n_ans=30` (coverage) and `UNREL st=1 npath=0 ans=0 p0=0` + `PASS UNREL_UNKNOWN`. UNREL is **outside** `n_rank` (`tb_astra_f3_shared_xfer.sv:388-392` uses `send_text` not `q_s`). Coverage 30/30 is 5 seeds × (FR hold + EN train + EN hold + EN ret + SH train + SH hold), each plant built with two legal paths — **by construction**, not a retrieval stress test. Always-UNKNOWN cannot PASS this TB (`FR_ANSWER` / `EN_HOLD_GOLD` require `ST_ANSWER`). UNREL plants S0 train facts first, then `payroll tax form` (not in role lexicon as a typed route) → UNKNOWN with **non-empty** BRAM. Stronger than empty-memory UNKNOWN.

### Hunt 5 — per-ID control actually run?

**A TB diagnostic ran; a per-ID ranker did not.**

```text
pid_ans = ans;                    // train pick dest, after EN_TRAIN
...
if ((seed!=2) && (pid_ans===gold_ans(seed,1'b1))) pid_c = pid_c + 1;
chk("PID_HOLD_0", pid_c==0);
```

(`tb_astra_f3_shared_xfer.sv:339-345`, `:399`)

That counts whether **train dest == hold gold dest**. S0/S1/S3/S4 hold dests were planted disjoint from train dests, so `pid_c` is 0 **by ID tables**, not by scoring a per-ID prior on hold. S2 is excluded because dest=4 is shared. On S0/S1/S3 gold and dist **share dest**, so a dest-keyed per-ID model could not separate gold from dist anyway.

Master §8 “compare … per-ID controls” remains **OPEN**. PREREG called this a diagnostic, not mixed into shared `w`. Plumbing `PID_HOLD_0` is a disjointness check. Do not read `pid_hold=0/4` as “per-ID learner scored 0/4”.

### Hunt 6 — `load_from_tb`, golden edits, RESULTS vs log, hash after scores

- `load_from_tb_o` hardwired `1'b0`. Every dump `tbl=0`. Sparse `poke_v_i=1'b0`. Queries are `send_text` tokens. TB plants AXI postings (disclosed TB-AXI; PREREG). DUT `load_v` stays 0 in TB.
- No fail-r0 log; no second-pass golden edit. `tb_oracles.svh` / `expected_vectors.json` hashed before xvlog; live identities match the log p0s.
- RESULTS counts match raw METRICS / ISO / UNREL / `$finish` 103615 ns / PID 28280 / line 405.
- Hash stamp **before** xvlog (`14:19:42`) then xsim (`14:19:48–50`) then POST (`14:19:50`). PREREG/oracles in PRE. RESULTS/`metrics.json` after (not in PRE). No evidence the freeze was taken after looking at scores on **this** hashed run. Cannot prove there was no private dry-run before the freeze (standard limit; no fail archive).

`chk("ISO_DUT_W0_CLEARED_LAST", 1'b1)` (`tb_astra_f3_shared_xfer.sv:401`) is a **tautological named check** (always true). UNREL dump after `hard_rst` does show `w0=0`; the named chk does not test it. Not a manufactured METRICS pass.

### Hunt 7 — ISO +3, x0=50 → dw0=+5?

**Yes, on an isolated frozen SGD, not DUT weights.**

Raw: `ISO_P3 w0=5 viso=0` then `PASS ISO_P3_X50_DW5` (`wiso[0]===5 && wiso[1]===0`). TB: `xiso[0]=50`, `iso_rew=+3`, `go_upd` on `u_iso` (`tb_astra_f3_shared_xfer.sv:104-109`, `:376-379`).

Law (opened SGD, SHIFT=6): `target=3*256=768`, `v_q8=0` at `w=0`, `error=768`, `dw0=RSH(768*50, 13)=RSH(38400,13)`. Symmetric `rsh40`: `(38400+4096)>>>13 = 42496>>>13 = 5`. `viso=0` is the **pre-update** score latched in `DONE` from `v_sat` (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:108-120`) — expected, not a fail.

DUT SGD is a **separate** instance. ISO does not write DUT `w`. After UNREL `hard_rst`, dump `w0=0`.

---

## Logic bugs

No DUT logic bug that falsifies the plumbing marker.

Noted, not P1 for this bag:

1. `ISO_DUT_W0_CLEARED_LAST` condition is `1'b1` (hunt 6).
2. DUT SGD `freeze_i` tied to `1'b0`; `freeze_q` from `ctrl_i` only skips `go_upd` in `S_HOLD`. TB never sets `ctrl≠0`. Out of F3 scope.
3. “Shuffled” arm is on-policy **sign-flip** `pulse_rew(-3)` on the same train-gold φ (`tb_astra_f3_shared_xfer.sv:357`), not a permutation of reward across actions. PREREG describes `−3` and “independent on-policy run”; the name “shuffled” overstates Master shuffled-reward.
4. F3 AXI timeout goes to INCOMP `S_HOLD` without F2R4 drain. Out of this gate (new named ranker, not a drain bag).
5. S0/S3 quality twin (hunt 1).

Path legality is independent of score (parser latch; 1-hop vs 2-hop from `ctx==2`; no unique-dest CONFLICT — required so same-dest 2-path ranking is not vacuous). S3 dead-end does not form a 2-hop (`npath=2`). S4 1-hop `trans=0` accepted (`S_ED` does not require trans). Matches PREREG.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F3-SHARED-TRANSFER-01`

**Master F3 is OPEN.** Not CLOSED.

Narrow = FPGA-owned frozen symmetric SGD (`ISO +3,x0=50 → dw0=+5`), new named ranker, `load_from_tb_o=0`, token queries, 5 plants that are not five XOR copies of one graph, enabled hold 5/5 vs no-update 0/5 vs sign-flip 0/5, coverage 30/30 reported separately from selective accuracy, UNREL UNKNOWN on a non-empty plant, `tbl=0`, RESULTS match raw log, PRE hash includes `.svh` + PREREG, frozen F2R2 SGD and F2R2–F2R5 integrators **not** compiled into this snapshot and **not** patched in live sources.

Narrow **excludes**: Master §8 10 pp / paired population CI / retention-over-reload; true shuffled-reward; per-ID competing learner; held-out worlds with shared+private facts; LM06; BOARD; ASTRA-13; DDR production retrieval.

Descriptive 100 pp / CI lo=1 on n=5 designed plants is **not** accepted as Master evidence (and was not claimed as such in PREREG).

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this **plumbing** bag as PASS_NARROW with Master F3 left OPEN.

Do not dispatch a DUT “fix” against the pass evidence. Do not edit goldens. Do not rerun this bag’s `run_xsim.ps1` in a way that wipes `xsim.log`. Do not patch frozen F2R2–F2R5 RTL.

Residuals below are **not** P1 for this bag. They are the Master F3 / next-bag queue (parent chooses a **new** named bag if it wants Master §8 closed):

1. Seeds must be independent **world/role/relation/support** draws, not two quality twins (S0/S3) plus ID remaps of the same 2-path φ.
2. Hold must not be an identical-φ ID permutation if the claim is world transfer; if the claim is held-out **entities**, say so and still add role/context interventions that are not the train φ copied.
3. Shuffled-reward = permute reward/label pairing across actions (or across a stream), not only `−3` on gold φ.
4. Per-ID = a competing dest/eid-keyed predictor scored on hold, not `train_ans == hold_gold_ans`.
5. Retention = held-out gain after reload/epochs, not train re-query smoke (`ret=5/5`).
6. Do not print Wilson/paired CI on 5 designed binary plants as if it were Master confirmation (already labeled descriptive here — keep it that way).
7. Replace tautological `ISO_DUT_W0_CLEARED_LAST` with `wdut[0]===0` (or drop the name).

Parent: treat **F3 plumbing** as CLOSED_NARROW on **this bag only**. F2R items 1–6 remain CLOSED_NARROW on their bags. **Master F3 stays OPEN.** Do not open LM06 or BOARD from this report. Preserve F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 and this bag. PROGRAM=NO.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

**Master F3 OPEN.** Promotion of Master F3 10 pp/CI/retention / LM06 / BOARD / COM12 / ASTRA-13 / persistence-DDR / power-loss journal remains **REJECT_PROMOTION**. PROGRAM=NO. COM12 UNTOUCHED.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T0735Z\REPORT.md  ACCEPT_PARTIAL ; Master F3 OPEN ; REJECT_PROMOTION
