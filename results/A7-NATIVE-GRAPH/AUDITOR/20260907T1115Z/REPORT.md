# ASTRA auditor REPORT — 20260907T1115Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-AXI-BEAT-ACCOUNTING-01
LAW        = qse-v2-intersect-01 (replay; not a new retrieval law)
KEEP       = ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-N256-ROLE-RETRIEVAL-01 / R2 / R3 / KEY-RELBIND (verified)
           + C0 RTL hashes (extract/lexicon/sparse/dir/gate; verified MATCH)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (not edited)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1020Z/REPORT.md
           ACCEPT_PARTIAL (intersect N=256 leak_n=0 + direct {110,144,145})
           Independent P0-2 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md §P0-2 + EVIDENCE.md P0-2 + results/recompute.json
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-AXI-BEAT-ACCOUNTING-01.md
EVIDENCE   = raw xsim.log AXI_BEAT / EMIT_IDS / EMIT_IDENTICAL /
             ASTRA_C1_AXI_BEAT_XSIM_PASS / NOT_SELECTIVE / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP KEY-INTERSECT / N4096)
           + NEW probe rtl/native_graph/integrate/a7ng_query_axi_rbeat_probe.sv
           + TB tb_astra_c1_axi_beat_accounting.sv (poke_v, leftover A09, rbeat_ok, emit ident)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + DUT a7ng_query_axi_sparse_intersect.sv (instantiate, not edited)
           + frozen extract / relbind keys / dir / gate / sparse (not patched)
           + independent corpus occupancy → R-beat model vs live AXI_BEAT
           + independent audit recompute.json model_bytes
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = KEEP unedited (not this bag; not promoted)
STREAM_INTERSECT_02 = NOT STARTED (this audit does not start it)
DDR_QUERY_BOUND_FINAL = NOT_FROZEN (must stay not frozen)
CAND_CAP_FINAL        = NOT_FROZEN
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP KEY-INTERSECT / N4096 / R1 / R2 / R3 / KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **P0-2 measurement** bag `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` after independent PLAN §P0-2 required accepted R-beats (`m_axi_rvalid && m_axi_rready`) instead of host-only AR×16, on frozen N=256 KEY-INTERSECT queries through the **same** intersect DUT.

`results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> On frozen N=256 KEY-INTERSECT queries, through the same intersect DUT, do accepted R-beats (`rvalid && rready`) measure AXI bytes as `R_BYTES=16*(DIR_R_BEATS+POST_R_BEATS)` (not host-only `AR×16`), and are emit IDs bit-identical to KEY-INTERSECT GOLDEN (direct `{110,144,145}`)?

PASS this bag only if:

1. Per-class emit ID lists equal KEY-INTERSECT GOLDEN (direct **must** be `{110,144,145}`).
2. RTL-visible counters: `DIR_R_BEATS` / `POST_R_BEATS` / `TOTAL_AXI_BYTES=16*(dir+post R-beats)` printed.
3. R-beat counters nonzero on classes that issued AXI reads, and `R_BYTES >= AR_BYTES`.
4. Do **not** freeze `DDR_QUERY_BOUND_FINAL` / `CAND_CAP_FINAL`.
5. Do **not** introduce `qse-v2-stream-intersect-02` in this bag.

This bag **cannot** close C1 800k, cannot promote N=4096, cannot freeze a DDR byte bound, cannot start stream-intersect-02, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` gold/corpus/TB/RTL/xsim (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN timestamp **10:46:42**)
- R1 / R2 / R3 / KEY-RELBIND
- C0 hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c`

**Not** this bag: C1 800k close, N>256 generation, C2 DDR persist, stream-intersect-02, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys.

Hunt (dispatch, none dropped):

1. Counters only in the host twin (no RTL `rvalid&&rready`)
2. `R_BYTES == AR_BYTES` always (probe fake / AR×16 relabeled)
3. Emit not identical to KEY-INTERSECT GOLDEN (direct not `{110,144,145}`)
4. `DDR_QUERY_BOUND_FINAL` claimed / frozen from this ratio
5. `qse-v2-stream-intersect-02` claimed or compiled
6. C0 patched / intersect DUT edited (`a912786f` drift)
7. KEY-INTERSECT gold/timestamps rewritten; N4096 bag edited
8. Gold hashed after first xvlog / rewritten after FAIL
9. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
10. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
11. C1 800k closed / `ACCEPT_BOARD` / BOARD_PASS
12. `reduction_x1000` as `1-CAND_CAP/N`
13. Frozen / relbind sparse compiled as DUT
14. Hash theatre (SHA256.txt vs live Get-FileHash)

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is **measurement authority** only.

If P1 is none for this unknown, parent **may** open `ASTRA-C1-STREAM-INTERSECT-02` at **N=256** (late gold **must** hit). This audit does **not** start that bag. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. AXI-BEAT bag is untracked (`??`). KEY-INTERSECT and N4096 bags remain untracked (`??`). NEW probe `a7ng_query_axi_rbeat_probe.sv` is untracked (`??`). Intersect DUT remains untracked at HEAD with **unchanged** hash vs KEY-INTERSECT SHA256.txt. Frozen extract / lexicon / `query_axi_sparse` remain untracked at HEAD. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z/0915Z/0940Z/0955Z/1020Z — **not** a silent patch in this bag). `PROGRAM=NO` this process and this bag (no `.bit`, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T11:15:00+07:00` file mtime **11:12:00.614** `acceptance=PENDING_AUDITOR_C1_AXI_BEAT` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `n4096_bag=KEEP_UNEDITED` `next_law=qse-v2-stream-intersect-02 AFTER beat auditor` `final_promotion=REJECT`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), AXI-BEAT bag:

```text
10:16:50.144  corpus.json          (copy; timestamp preserved from KEY-INTERSECT)
10:16:50.145  GOLDEN.json          (copy; timestamp preserved)
10:16:50.146  query_gold.svh       (copy; timestamp preserved)
11:06:54.487  PREREG.md ACK.json GOLD_HASH_PRE_XVLOG.txt
11:08:04.967  tb_astra_c1_axi_beat_accounting.sv
11:09:05.667  run_xsim.ps1
11:09:47.388  rtl/.../a7ng_query_axi_rbeat_probe.sv   (NEW)
11:09:54.740  SHA256.txt           (script: freeze immediately before xvlog)
11:09:55.831  xvlog.log
11:09:58.317  xelab.log
11:10:01.966  xsim.log             (session Mon Sep 7 11:09:59–11:10:01 2026, PID 53316)
11:11:09.523  RESULTS.md CLOSEOUT.md
```

Intersect DUT LastWriteTime **2026-09-07 10:13:02.641** — **before** KEY-INTERSECT xvlog (10:17:23) and **not** touched in the AXI-BEAT window. Probe is the only new RTL (11:09:47, before SHA freeze 11:09:54 and xvlog 11:09:55).

`fail_r0` / `xsim_fail_r0.log`: **ABSENT**. `a7ng_query_axi_sparse_stream_intersect.sv`: **MISSING**.

### 2) Live hashes vs C0 / KEY-INTERSECT / SHA256.txt / PRE

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  qse_role_lexicon.svh                (C0 MATCH; mtime 2026-09-05 20:51:03)
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (0955Z MATCH; mtime 09:43:58)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02)
a5d0eb3c4df33c36128782295aea06480241e6e0cd85b19594b3ff15bd3b78b2  a7ng_query_axi_rbeat_probe.sv       (NEW; MATCH SHA256.txt)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
```

AXI-BEAT gold copies **byte-identical** to KEY-INTERSECT originals (same hash **and** same LastWriteTime 10:16:50):

```text
d3b5b88356bd2fc691398a794b2e8b6470d7b3eef2fd56a5d7aeddab8ccb5625  GOLDEN.json        BOTH bags 10:16:50.145
f16119179191036ba1eb2bd8e451e8fd6691095a08d0ec5f9ff81533a9000f55  query_gold.svh     BOTH bags 10:16:50.146
e8b4f8ea3a66bee35c0f10c8f23b91bba851933d3764696a7cd573116e300825  corpus.json        BOTH bags 10:16:50.144
```

`GOLD_HASH_PRE_XVLOG.txt` mtime **11:06:54.487** contains those three hashes. `xvlog.log` mtime **11:09:55.831**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 10:16:50). SHA256.txt freeze stamp `2026-09-07T11:09:54.6958908+07:00` is immediately before xvlog.

Live xsim.log SHA256 `4ab47b52232770fc3afeb98c2f172a1f134db750c5ef6ef8eb86027ab0689905` MATCH RESULTS `XSIM_SHA`.

FINAL_CONTRACT still records `DDR_QUERY_BOUND_FINAL=NOT_FROZEN` / `CAND_CAP_FINAL=NOT_FROZEN`. Extract/sparse hashes MATCH C0 contract.

### 3) KEEP KEY-INTERSECT / N4096 / prior C1 bags unmodified

KEY-INTERSECT bag files all mtime **10:14:24–10:18:37**. No file in that bag is newer than the AXI-BEAT window (11:06+). Gold 10:16:50 / xsim 10:17:28 SHA `4b17320d…` unchanged vs 1020Z.

N4096 bag files all mtime **10:40:50–10:49:24**. GOLDEN **10:46:42.851** hash `095ca715…`. xsim **10:48:02.198**. RESULTS/CLOSEOUT **10:49:24.999**. **No N4096 file is after 10:49:24.** AXI-BEAT did not edit that bag.

KEEP R1 GOLDEN 08:31:44 / R2 GOLDEN 08:59:20 / R3 GOLDEN 09:24:14 xsim 09:24:43 / RELBIND GOLDEN 09:48:35 xsim 09:49:11 — all before 1020Z and untouched by this bag.

### 4) Compile list / leftover A09 / poke_v / stream-02

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_intersect.sv
a7ng_query_axi_rbeat_probe.sv
tb_astra_c1_axi_beat_accounting.sv
```

`xelab.log` compiled the same modules (probe `a7ng_query_axi_rbeat_probe_defau…`). Work `*.sdb`: extract, relbind keys, gate, dir, mem model, **intersect**, **rbeat_probe**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_relbind`, any `stream_intersect`.

xvlog/xelab/xsim: no `a7ng_astra_09`, no `stream_intersect`. TB holds `poke_v=0` and diverges `HOST_SEMANTIC_LEAK` if `poke_v!=0`. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

### 5) Probe RTL — `rvalid && rready`, not host-only

`rtl/native_graph/integrate/a7ng_query_axi_rbeat_probe.sv` (NEW; hash `a5d0eb3c…`):

- Increments `dir_r_beats_o` / `post_r_beats_o` on **`rvalid && rready`** (lines 60–66).
- Classifies dir vs posting from **latched AR address** (`[INDEX_BASE, POST_HEAP)` dir; `>= POST_HEAP` posting). `INDEX_BASE=NG_DDR_INDEX_BASE=28'h0500_0000`, `POST_HEAP=INDEX_BASE+N_TABLES*N_BUCKETS*ENTRY_BYTES`.
- `total_axi_bytes_o = (dir_r + post_r) * 16`.
- Ports: `araddr/arvalid/arready/rvalid/rready/rlast`. **No `arlen` port** — cannot be an AR×(arlen+1) calculator pretending to be R.
- Single `pending_dir`/`pending_post` pair (not an outstanding-AR FIFO). Frozen walker `a7ng_sparse_dir_axi` is **one-outstanding** (S_ARDIR→S_RDIR, S_ARPOST→S_RPOST→S_DRAIN; next AR only after R). Sufficient for **this** DUT. Not a general multi-outstanding AXI monitor.

TB instantiates the probe on the **same** DUT AXI wires (`araddr/arvalid/arready/rvalid/rready/rlast`). `AR_BYTES = 16*(n_dir+n_post)` from DUT AR counters. `R_BYTES = 16*(dir_r_beats+post_r_beats)` from probe. `rbeat_ok` fails on unclassified beats, probe-AR vs DUT-AR mismatch, R=0 when AR>0, or `R_BYTES < AR_BYTES`. Not a tautology that forces `R==AR`.

### 6) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 11:09:59 2026**; exit **11:10:01**; PID **53316**; `$finish` at **18305 ns**.

Banner:

```text
C1_AXI_BEAT_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-01 POKE_V=0 REDUCTION_X1000=NOT_EMITTED DDR_QUERY_BOUND_FINAL=NOT_FROZEN
```

Per-class **EMIT_IDS** + **AXI_BEAT** (verbatim):

| class | EMIT_IDS | EMIT_IDENTICAL | DIR_R | POST_R | R_BYTES | AR_BYTES | RATIO_x1000 | n_dir_ar | n_post_ar | rbeat_ok |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| direct | 110,144,145 | 1 | 2 | 5 | 112 | 96 | 1166 | 2 | 4 | 1 |
| paraphrase | 110,144,145 | 1 | 2 | 5 | 112 | 96 | 1166 | 2 | 4 | 1 |
| role_reversal | 146 | 1 | 2 | 5 | 112 | 96 | 1166 | 2 | 4 | 1 |
| wrong_relation | 114 | 1 | 2 | 8 | 160 | 80 | 2000 | 2 | 3 | 1 |
| wrong_context | 110,144,145 | 1 | 2 | 5 | 112 | 96 | 1166 | 2 | 4 | 1 |
| distractor | 110,144,145 | 1 | 2 | 5 | 112 | 96 | 1166 | 2 | 4 | 1 |
| unrelated | (empty) | 1 | 0 | 0 | 0 | 0 | NA | 0 | 0 | 1 |
| high_occupancy | 147,148,149,150,151,152,153,154,155,156,157,158 | 1 | 2 | 14 | 256 | 96 | 2666 | 2 | 4 | 1 |
| overflow_page | 168,169,170,171,172 | 1 | 2 | 6 | 128 | 96 | 1333 | 2 | 4 | 1 |
| high_id_sentinel | 255 | 1 | 2 | 6 | 128 | 96 | 1333 | 2 | 4 | 1 |

Marker:

```text
ASTRA_C1_AXI_BEAT_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_gt_256,qse-v2-stream-intersect-02
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO DDR_QUERY_BOUND_FINAL=NOT_FROZEN CAND_CAP_FINAL=NOT_FROZEN
REDUCTION_X1000=NOT_EMITTED
STREAM_INTERSECT_02=NOT_THIS_BAG
```

No `FAIL ` lines. No `FIRST_DIVERGENCE`. No `FAIL DISTRACTOR_LEAK`. No `AXI_R_BEATS_ZERO`. No `AXI_R_LT_AR`. No `AXI_UNCLASSIFIED`. No `ASTRA_C1_KEY_INTERSECT_XSIM_PASS` (wrong marker). `wrong_context` still `NOT_SELECTIVE`. `unrelated` still `UNRELATED_EMPTY_WALK`. Distractor `leak_n=0 gold_polarity=excluded`.

**high_occupancy (required RAW):** `R_BYTES=256 AR_BYTES=96 RATIO_x1000=2666`. 256/96 = 8/3 = 2.666…; integer `RATIO_x1000=2666`. Independent EVIDENCE P0-2 expected **~2.67×** (model 256 vs reported AR 96). **MATCH as measurement.**

**direct (required RAW):** `R_BYTES=112 AR=96 list=110,144,145`. Independent model 112 vs AR 96 (1.167×). **MATCH.**

CLASS lines still print AR-side `dirB/postB` (`direct dirB=32 postB=64`; `high_occupancy dirB=32 postB=64`; `wrong_relation dirB=32 postB=48`). That is the **old** AR×16 accounting. P0-2 authority is the `AXI_BEAT` line, not `dirB/postB`.

### 7) Emit identity vs KEY-INTERSECT GOLDEN / prior xsim

AXI-BEAT CAND lists are **bit-identical** to KEY-INTERSECT `xsim.log` CAND lists and to `GOLDEN.json` `emit` / `G_EMIT`:

```text
direct / paraphrase / wrong_context / distractor  {110,144,145}
role_reversal                                      {146}
wrong_relation                                     {114}
unrelated                                          {}
high_occupancy                                     {147…158}
overflow_page                                      {168…172}
high_id_sentinel                                   {255}
```

Direct hard-gated in TB: `got[0..2]=={110,144,145}`. Raw `EMIT_IDENTICAL=1` on all 10 classes. Hunt “emit not identical”: **MISS.**

### 8) Independent occupancy → R-beat model (not RESULTS)

Corpus `n_records=256`. Key pack `{id,rel}=(id<<8)|rel`. Live occupancies MATCH GOLDEN `occupancies`:

```text
direct           k0=2561 occ=6   k1=257  occ=9    p0={108,109,110,111,144,145}
wrong_relation   k0=2562 occ=4   k1=258  occ=28
high_occupancy   k0=1538 occ=25  k1=258  occ=28
overflow_page    k0=3075 occ=10  k1=2051 occ=12
high_id_sentinel k0=3075 occ=10  k1=2307 occ=9
```

Walker geometry (frozen dir, not edited): directory AR `arlen=0` (1 beat); posting segment `arlen_post=ceil(post_count/4)-1`; INDEX_HEAD=4 ⇒ head 1 beat + overflow `ceil((occ-4)/4)` if `occ>4`; `S_DRAIN` accepts leftover beats after CAND_CAP. DUT is sequential two-table walk when both keys valid ⇒ **2 dir R-beats**.

Model `post_beats(occ)=0 if occ<=0; 1 if occ<=4; 1+ceil((occ-4)/4) otherwise`; `R_BYTES=16*(2+post0+post1)`:

| class | model DIR_R | model POST_R | model R_BYTES | live R_BYTES | live AR_BYTES |
|---|---:|---:|---:|---:|---:|
| direct | 2 | 2+3=5 | 112 | **112** | 96 |
| wrong_relation | 2 | 1+7=8 | 160 | **160** | 80 |
| high_occupancy | 2 | 7+7=14 | 256 | **256** | 96 |
| overflow_page | 2 | 3+3=6 | 128 | **128** | 96 |
| high_id_sentinel | 2 | 3+3=6 | 128 | **128** | 96 |
| unrelated | 0 | 0 | 0 | **0** | 0 |

Independent audit `recompute.json` N256 `model_bytes`: direct **112**, wrong_relation **160**, high_occupancy **256**, overflow/sentinel **128**. **Exact match to live probe R_BYTES.**

That is the P0-2 fact: AR×16 undercounts drain (hoc **2.666×**; EVIDENCE ~2.67×). Live R-beats equal the **full-drain occupancy model**, not the emit cap (hoc emit 12 / CAND_CAP=16, but POST_R=14 = full 25+28 drain). Bytes are not bounded by `CAND_CAP`.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS per-class table **MATCH** raw `AXI_BEAT` / `EMIT_IDS` exactly (including hoc 256/96/2666 and direct 112/96/`110,144,145`). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N4096 promotion, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, stream-intersect-02.

CLOSEOUT MATCH raw: marker present, DUT `a912786f…`, probe `a5d0eb3c…`, leftover not compiled, poke_v=0, KEY-INTERSECT timestamps 10:16:50 KEEP, N4096 KEEP, `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

Implementer prose that hoc 2666 “matches independent P0-2 ~2.67× as a *measurement*, not a bound freeze”: **HONEST** vs raw and vs `recompute.json`. Hunt RESULTS-vs-xsim: **MISS.** Hunt DDR-bound freeze: **MISS as claim.**

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Counters only in host | **MISS.** Named RTL probe compiled + sdb present; TB wires DUT AXI; increment is `rvalid&&rready`; no `arlen` port. | Do not move counters back into host occupancy math. |
| 2. `R_BYTES==AR_BYTES` always (probe fake) | **MISS.** 9/10 classes differ. hoc 256≠96; direct 112≠96; wrong_relation 160≠80; overflow/sentinel 128≠96. unrelated 0=0 is empty walk, not a fake. | Equality would have been the cheat. Observed inequality **is** the measurement. |
| 3. Emit not identical | **MISS.** All 10 `EMIT_IDENTICAL=1`. Direct `{110,144,145}` MATCH KEY-INTERSECT xsim + GOLDEN + `G_EMIT`. | Keep emit identity as a PASS conjunct. |
| 4. `DDR_QUERY_BOUND_FINAL` claimed | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / FINAL_CONTRACT all `NOT_FROZEN`. Ratio 2666 is live N=256 hoc drain/issue, not a bound. | **Do not freeze** DDR bound from 2666 or from 256 B. |
| 5. stream-intersect-02 claimed / compiled | **MISS.** File missing. xvlog/xelab/sdb have no stream unit. Marker `STREAM_INTERSECT_02=NOT_THIS_BAG`. | Parent may open it **after** this ACCEPT_PARTIAL; this audit did not start it. |
| 6. C0 patched / DUT edited | **MISS.** Five C0 SHAs MATCH live. Intersect `a912786f…` MATCH KEY-INTERSECT SHA256.txt; mtime still 10:13:02. Relbind keys `93811ed1…` mtime 09:43:58. | Do not silently patch extract/lexicon/dir/sparse/gate/intersect. |
| 7. KEY-INTERSECT / N4096 edited | **MISS.** KEY-INTERSECT gold 10:16:50 hashes `d3b5b883`/`f1611917`/`e8b4f8ea`. N4096 all files ≤10:49:24; GOLDEN 10:46:42. | Leave both bags on disk. |
| 8. Gold after FAIL / after xvlog | **MISS.** PRE 11:06:54 before xvlog 11:09:55. Gold files still 10:16:50. No fail_r0. Copies byte-identical to KEY-INTERSECT. | Do not regenerate gold. |
| 9. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0; no HOST_SEMANTIC_LEAK. | Keep off. |
| 10. RESULTS vs xsim / 800k overclaim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. 800k listed under Not claimed. | Authority = raw `AXI_BEAT` + `EMIT_IDS` + marker. |
| 11. C1 800k / ACCEPT_BOARD / BOARD_PASS | **MISS as claim.** | Never grant. Never C1 800k from this bag. |
| 12. `reduction_x1000` as cap/N | **MISS.** `REDUCTION_X1000=NOT_EMITTED`. `RATIO_x1000` is `R_BYTES*1000/AR_BYTES`. | Do not carry 16/256 as Master ≥90%. |
| 13. Frozen/relbind sparse as DUT | **MISS.** sdb list is extract + relbind keys + gate + dir + mem + **intersect** + **probe** + TB. | Keep frozen sparse and relbind sparse off xvlog. |
| 14. Hash theatre | **MISS** on listed gold/RTL paths (live MATCH PRE + SHA256.txt + C0 + KEY-INTERSECT DUT). | SHA256.txt 11:09:54 is the first-xvlog freeze. |
| CLASS `dirB/postB` still AR×16 | **HIT as leftover print, not as RESULTS claim.** CLASS still `dirB=32 postB=64` on hoc while `AXI_BEAT R_BYTES=256`. | Authority is `AXI_BEAT`, not CLASS `dirB/postB`. Do not freeze bounds from CLASS bytes. |
| Probe is 1-outstanding pending, not FIFO | **HIT as reuse caveat, not as this-bag FAIL.** Frozen walker is 1-outstanding. | Do not reuse this probe on a multi-outstanding master without an AR FIFO. |
| Cap-before-AND still the retrieval law | **HIT as P0-1 residual, not this unknown.** hoc emit 12 vs full ∩ 21; R-beats still full drain 256 B. | Next law is stream-intersect-02, not a silent C0 patch. |
| Index is `axi_mem_model`, not MIG/DDR | **HIT as bound.** Honest XSim measurement; illegal as `DDR_QUERY_BOUND_FINAL`. | Do not freeze a DDR bound from this bag. |

qstack-validation-adversary one-liner: **AXI-BEAT XSim is a real P0-2 measurement on the unedited intersect DUT `a912786f…`: probe counts accepted `rvalid&&rready` (not host-only AR×16); live hoc `R_BYTES=256 AR_BYTES=96 RATIO_x1000=2666` matches independent occupancy drain ~2.67×; direct `R_BYTES=112 AR=96` emit `{110,144,145}` bit-identical to KEY-INTERSECT GOLDEN; gold `d3b5b883…` 10:16:50 KEEP; N4096 unedited; leftover A09 off; poke_v=0; marker `ASTRA_C1_AXI_BEAT_XSIM_PASS` present; that is not a DDR bound freeze, not stream-intersect-02, not C1 800k, and not ACCEPT_BOARD.**

---

## Logic bugs

No DUT vs KEY-INTERSECT emit mismatch (this bag is a replay). Findings are **measurement / promotion bounds**, not “patch frozen intersect” and not “fix TB packing”:

1. **R-beat probe is implemented as claimed on this frozen walker.** RTL-visible `rvalid&&rready`. AR-address class. Wired to DUT AXI. Compiled. `R_BYTES != AR_BYTES` on AXI classes. Independent occupancy model equals live counts class-by-class.
2. **AR×16 is not AXI drain.** hoc 96→256 (2.666×); wrong_relation 80→160 (2.0×); direct 96→112 (1.167×). Independent EVIDENCE P0-2 predicted these. Live probe **confirms** them. CLASS `dirB/postB` still reports the undercount.
3. **CAND_CAP does not bound DDR beats.** hoc emit 12 after cap-then-AND, but POST_R=14 = full 25+28 posting drain via `S_DRAIN`. Bounded candidates ≠ bounded bytes. This bag **measured** that; it did **not** fix P0-1 (cap-before-AND).
4. **Probe pending pair is 1-outstanding.** Correct for `a7ng_sparse_dir_axi` (AR then R; drain; then next AR). Residual if a future master issues stacked ARs.
5. **Index is `axi_mem_model`, not MIG.** Honest for N=256 XSim. Illegal as `DDR_QUERY_BOUND_FINAL` / production retrieval / 800k close.
6. **Retrieval law is still `qse-v2-intersect-01`.** wrong_context still `NOT_SELECTIVE`. hoc still prefix-intersect. N4096 sentinel SEARCH_INCOMPLETE is **unchanged** in the KEEP bag. This measurement does not repair scale.
7. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start stream-intersect-02 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim measurement lock (C0 hashes, DUT `a912786f` unedited, leftover off, poke_v=0, gold PRE MATCH live, KEY-INTERSECT/N4096 KEEP, probe compiled, marker present) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| Probe as claimed (`rvalid&&rready`; AR-addr class; not host-only) | **PASS_NARROW** | RTL + TB wiring + no arlen port + live R≠AR + occupancy model MATCH. |
| Registered unknown (emit-identical to KEY-INTERSECT GOLDEN **and** R-beat counters printed **and** `R_BYTES>=AR_BYTES`) | **PASS_NARROW** | All 10 `EMIT_IDENTICAL=1`; direct `{110,144,145}`; hoc 256≥96; marker present. |
| hoc RAW `R_BYTES=256 AR_BYTES=96 RATIO_x1000=2666` vs independent ~2.67× | **PASS_NARROW** | Exact 256 vs model 256; 2666 = floor(256000/96). Measurement, **not** a bound. |
| direct RAW `R_BYTES=112 AR=96 list=110,144,145` | **PASS_NARROW** | MATCH KEY-INTERSECT emit + independent model 112. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_AXI_BEAT_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or DDR freeze. |
| `DDR_QUERY_BOUND_FINAL` / `CAND_CAP_FINAL` | **NOT FROZEN / REJECT freeze** | Explicitly not claimed. Ratio is N=256 XSim drain/issue on `axi_mem_model`. |
| `qse-v2-stream-intersect-02` | **NOT THIS BAG** | File missing; not compiled; not claimed. |
| C1 800k / N=4096 promotion / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED** | N4096 KEEP unedited (sentinel miss remains in that bag). This audit does not start stream-02. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 11:06:54; xvlog 11:09:55; gold 10:16:50 KEEP `d3b5b883…`; no r0. |
| KEEP KEY-INTERSECT + KEEP N4096 + C0 hashes + DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1020Z / C0 / KEY-INTERSECT SHA256. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (P0-2 measurement: accepted R-beats on frozen N=256 KEY-INTERSECT replay through unedited intersect DUT; emit-identical; hoc 256/96/2666 MATCH independent model; gold-before-xvlog; leftover off; poke_v=0; RESULT=`PASS_THIS_GATE_ONLY` honest). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=4096 scale, stream-intersect-02-as-done, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS. **Not** FAIL_LOOP (hashes real, DUT unpatched, gold not rewritten, 800k not claimed, probe is not AR×16 relabeled, PASS is honest). **Not** `ACCEPT_BOARD`.

**P1 for this unknown: none.** Parent **may** open `ASTRA-C1-STREAM-INTERSECT-02` at **N=256** (one unknown: CAP_AFTER + sorted merge + rare-first; **late gold must hit**; early-gold classes stay exact vs this control). Not context keys. Not 65k dir. Not N=800k. This audit does **not** start that bag.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-KEY-INTERSECT-01` or `ASTRA-C1-N4096-INTERSECT-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_intersect.sv`. **Do not freeze** `DDR_QUERY_BOUND_FINAL` from RATIO 2666 / 256 B / 112 B.

**P1 — none for this unknown** (emit-identical + live `rvalid&&rready` counters + `R_BYTES>=AR_BYTES` + independent occupancy MATCH, independently confirmed).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound or silent-patch C0):**

1. **Keep this bag as PASS_THIS_GATE_ONLY measurement evidence.** Authority = raw `AXI_BEAT` / `EMIT_IDS` / marker. CLASS `dirB/postB` remains AR×16 and is **not** the byte authority.
2. **Do not freeze `DDR_QUERY_BOUND_FINAL` or `CAND_CAP_FINAL`.** hoc 2666 is N=256 XSim full-drain / AR-issue on `axi_mem_model`. Directionally it falsifies AR×16 as AXI bytes; it is not a silicon DDR bound.
3. **If parent opens `ASTRA-C1-STREAM-INTERSECT-02`, do it at N=256 first.** New named RTL. Instantiate frozen extract + relbind keys. **Do not edit** C0 dir/sparse or this intersect DUT. Late-id gold **must hit**. Early-gold classes stay exact vs KEY-INTERSECT / this bag’s emit lists. Hash gold before xvlog. leftover A09 off. poke_v=0. PROGRAM=NO. C1 800k stays OPEN. This audit does **not** write that bag.
4. **P0-1 remains open** (cap-before-AND). N4096 KEEP still exhibits sentinel `SEARCH_INCOMPLETE` / emit_n=0. Do not promote N=4096 on `qse-v2-intersect-01`. Restart 256→4096 only from one frozen **stream** law after bag-2 PASS.
5. **Keep** the reporting machinery: `RATIO_x1000=R_BYTES*1000/AR_BYTES`; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; frozen `a7ng_query_axi_sparse.sv` not compiled as DUT; relbind sparse not compiled as DUT; intersect DUT instantiate-only.
6. If a future probe is reused on a multi-outstanding master, replace the 1-pending pair with an AR-class FIFO. Not required to PASS this bag.
7. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `n4096_bag` stays KEEP_UNEDITED. `next_law` may move to an opened stream-intersect-02 bag **by parent**, not by this report writing those files.
8. KEEP bags including KEY-INTERSECT gold 10:16:50, N4096 sentinel miss, R3 `leak_n=10`, and relbind `leak_n=9` stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: P0-2 measurement;
                         accepted R-beats rvalid&&rready on frozen N=256
                         KEY-INTERSECT replay through unedited DUT a912786f…;
                         NEW probe a7ng_query_axi_rbeat_probe a5d0eb3c…;
                         all 10 EMIT_IDENTICAL=1; direct {110,144,145};
                         hoc R_BYTES=256 AR_BYTES=96 RATIO_x1000=2666
                           MATCH independent occupancy model / EVIDENCE ~2.67×;
                         direct R_BYTES=112 AR=96 MATCH model 112;
                         R_BYTES != AR_BYTES on AXI classes (probe not fake);
                         counters not host-only; leftover A09 off; poke_v=0;
                         gold d3b5b883… 10:16:50 KEEP; PRE 11:06:54 before xvlog;
                         N4096 KEEP unedited (GOLDEN 10:46:42);
                         C0 hashes MATCH; marker PRESENT;
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         DDR_QUERY_BOUND_FINAL NOT_FROZEN)
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not N=4096 closed,
                            not stream-intersect-02 done, not Master ≥95% recall,
                            not Master ≥90% reduction, not ACCEPT_BOARD)
FAIL_LOOP        = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = ASTRA-C1-STREAM-INTERSECT-02 at N=256
                   (late gold MUST hit; this audit did NOT start it)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
N_4096           = KEEP_UNEDITED (not promoted)
STREAM_02        = NOT_THIS_BAG / NOT_STARTED_HERE
C1_AXI_BEAT_XSIM = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_AXI_BEAT_XSIM_PASS PRESENT
                   PID 53316; 18305 ns; 11:09:59–11:10:01
                   xsim.log SHA256 4ab47b52232770fc3afeb98c2f172a1f134db750c5ef6ef8eb86027ab0689905
                   hoc R_BYTES=256 AR_BYTES=96 RATIO_x1000=2666
                   direct R_BYTES=112 AR_BYTES=96 list=110,144,145
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 10:16:50; PRE MATCH live;
                                no r0; PASS session
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02
PROBE            = NEW RTL      rvalid&&rready; not host-only; not arlen
C0_PATCH         = MISS
KEY_INTERSECT_KEEP = UNMODIFIED d3b5b883… / f1611917… / e8b4f8ea…  10:16:50
N4096_KEEP       = UNMODIFIED   GOLDEN 10:46:42; bag files ≤ 10:49:24
```
