# ASTRA auditor REPORT — 20260907T1215Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-N4096-STREAM-02
LAW        = qse-v2-stream-intersect-02  (SAME named RTL as STREAM-02 N=256; N=4096 late-gold stress)
KEEP       = ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; GOLDEN 10:46:42 verified)
           + ASTRA-C1-STREAM-INTERSECT-02 N=256 (must be unmodified; GOLDEN 11:43:45 verified)
           + ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-AXI-BEAT-ACCOUNTING-01 (must be unmodified; verified)
           + R1 / R2 / R3 / KEY-RELBIND (verified)
           + C0 RTL hashes (extract/lexicon/sparse/dir/gate; verified MATCH)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (KEEP; not compiled as DUT)
           + stream DUT a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (instantiate; not edited)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1145Z/REPORT.md
           ACCEPT_PARTIAL (N=256 STREAM-INTERSECT-02; P1 none; parent MAY open N=4096 SAME law)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag3 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-N4096-STREAM-02.md
EVIDENCE   = raw xsim.log CLASS_* / LATE_GOLD_HIT / STREAM_HIT / CAP_THEN_AND_WOULD_MISS /
             ASTRA_C1_N4096_STREAM_02_XSIM_PASS / NOT_SELECTIVE / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes + STREAM-02 SHA256.txt
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP N4096-INTERSECT / STREAM-02 / KEY-INTERSECT / AXI-BEAT)
           + DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv (mtime vs N=256 bag)
           + TB tb_astra_c1_n4096_stream.sv (poke_v, leftover A09, CAND_CAP override, LATE_GOLD / incomp gate)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_n4096_stream.py
           + independent corpus exact-key postings for nid 4094 and nid 4095 (not RESULTS)
           + KEEP intersect DUT a912786f… (buf0/buf1 cap-then-AND) NOT compiled
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_16384      = NOT STARTED (this audit does not start it)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP N4096-INTERSECT / STREAM-02 N=256 / KEY-INTERSECT / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start N=16384 / dir-full16 / page-skip / context / C1 800k, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=4096 late-gold stress** bag `ASTRA-C1-N4096-STREAM-02` after auditor `20260907T1145Z` ACCEPT_PARTIAL of N=256 `qse-v2-stream-intersect-02` (P1 none) allowed parent to open the same stream law at N=4096.

`results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=4096, same law `qse-v2-stream-intersect-02` (postings sorted by nid; two-pointer merge; 1-beat page buffer; rare-list-first; CAND_CAP after emit), does LATE gold (posting index ≥16 on **both** k0 and k1, so cap-then-AND would miss; include a sentinel near 4095) HIT, and do retrieve classes with `gold_n>=1` FAIL the bag if `SEARCH_INCOMPLETE` / emit miss?

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_N4096_STREAM_02_XSIM_PASS` present.
2. LATE gold nid in emit (`LATE_GOLD_HIT`); `SEARCH_INCOMPLETE` **ABSENT** on any retrieve class with `gold_n>=1` (WO: present ⇒ FAIL; do not emit PASS marker).
3. CLASS_direct gold hits `{110,144,145}` (records remain); CLASS_high_id_sentinel nid **4095** tp=1 incomp=0.
4. Walker is the frozen STREAM-02 DUT `14f75db7…` (sorted-nid two-pointer AND, 1-beat page, rare-first, CAND_CAP **after emit**) — **not** KEY-INTERSECT `buf0`/`buf1` cap-then-AND; RTL mtime **not newer** than the N=256 stream bag.
5. Frozen C0 dir instantiated not patched; leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
6. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / N=16384 / BOARD_PASS.

This bag **cannot** close C1 800k, cannot promote N=16384, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. 12-entity clone + 12-bit directory remain promotion stops.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN `095ca715…` timestamp **10:46:42**; old-law sentinel miss remains)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**)
- R1 / R2 / R3 / KEY-RELBIND
- C0 hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **instantiate only**)

**Not** this bag: C1 800k close, N=16384 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys, context keys, 65k directory, page-skip, loading full posting into BRAM, patching KEEP bags, editing stream RTL.

Hunt (dispatch, none dropped):

1. Prefix luck (late gold in first16∩first16, or planted on only one list)
2. `SEARCH_INCOMPLETE` swallowed / used to PASS a retrieve class with `gold_n>=1`
3. 12-entity clone still (latent dir 12-bit — note REJECT C1 800k)
4. C0 dir patched (`09334e42` drift)
5. Independent audit tree written by this implementer
6. Marker-only PASS with incomp
7. DUT edited (hash ≠ STREAM-02 `14f75db7…`, or mtime newer than N=256 stream bag)
8. Late gold only on one posting list
9. Merge still caps each list first (`buf0`/`buf1`)
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. Gold hashed after first xvlog / rewritten after FAIL
12. KEEP N4096-INTERSECT GOLDEN 10:46:42 / STREAM-02 / KEY-INTERSECT / AXI-BEAT rewritten
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=16384 started
15. CAP_THEN_AND_WOULD_MISS print-only tautology (gold bit, not corpus)
16. Hash theatre (SHA256.txt vs live Get-FileHash)

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=4096 same-law late-gold** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-PAGE-SKIP-01` / context keys **or** semantic corpus restart. Do **not** auto-start C1 800k / N=16384. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. N4096-STREAM-02 bag is untracked (`??`). KEEP KEY-INTERSECT / N4096-INTERSECT / STREAM-02 / AXI-BEAT remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…`. KEEP intersect DUT remains untracked with **unchanged** hash `a912786f…`. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1145Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T12:15:00+07:00` `acceptance=PENDING_AUDITOR_C1_N4096_STREAM_02` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `n4096_intersect_01=KEEP_UNEDITED` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), N4096-STREAM-02 bag:

```text
12:04:03.677  PREREG.md ACK.json
12:07:13.881  host_astra_c1_n4096_stream.py
12:10:13.573  run_xsim.ps1 tb_astra_c1_n4096_stream.sv
12:10:22.761  corpus.json
12:10:22.762  GOLDEN.json
12:10:22.766  query_gold.svh
12:10:22.768  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xvlog
12:10:40.612  SHA256.txt                 ← freeze immediately before first xvlog
12:10:41.681  xvlog.log
12:11:02.301  xelab.log
12:11:06.297  xsim.log                   PID 57252; session 12:11:03–12:11:06
12:12:27.498  RESULTS.md CLOSEOUT.md
```

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag (GOLDEN 11:43:45 / CLOSEOUT 11:45:37). This bag starts 12:04. DUT was not rewritten for N=4096.

Single XSim session. No second xvlog. Gold files were **not** rewritten between 12:10:22 and 12:12:27 (hash MATCH PRE; LastWriteTime still 12:10:22). `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `dd1a151a6f4be2713088901e1f24b1f8295d78813b8e6afd266571e5f83e9947` MATCH RESULTS `XSIM_SHA`.

N=16384 bag paths **ABSENT**.

### 2) Live hashes vs C0 / SHA256.txt / PRE / STREAM-02 DUT

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  qse_role_lexicon.svh                (C0 MATCH; mtime 2026-09-05 20:51:03)
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (mtime 09:43:58)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv
                                                                  (STREAM-02 MATCH; mtime 11:43:39; NOT edited this bag)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
```

STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH.

`GOLD_HASH_PRE_XVLOG.txt` mtime **12:10:22.768** vs live gold (all MATCH):

```text
2a2db8c8dcb7ac1c9fb322a7d59d407a8892ef087499f96784f71c9f1dd5df06  GOLDEN.json
7a37e1761406136e723fade5caf8eb006004364cc6127e9d649fd8d8664b3237  query_gold.svh
d342084b3de7ff579c116609f3f4f473bbf1e24c06193b2de61ac6657434062f  corpus.json
```

`xvlog.log` mtime **12:10:41.681**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 12:10:22). SHA256.txt freeze stamp `2026-09-07T12:10:40.5697816+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **0 mismatches** (C0 five, relbind keys, KEEP intersect, stream DUT `14f75db7…`, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple). No invented hash.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 12:04+ |
|---|---|---|---|
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |
| R1 | GOLDEN **08:31:44** | CLOSEOUT **08:37:00.181** | **UNMODIFIED** |
| R2 | GOLDEN **08:59:20** | RESULTS **09:01:39.446** | **UNMODIFIED** |
| R3 | GOLDEN **09:24:14** | CLOSEOUT **09:26:23.833** | **UNMODIFIED** |
| KEY-RELBIND | GOLDEN **09:48:35** | CLOSEOUT **09:51:03.157** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** N4096-STREAM-02 implementer did **not** write that tree. This auditor did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / KEY-INTERSECT not DUT

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_stream_intersect.sv
tb_astra_c1_n4096_stream.sv
```

`xelab.log` compiled the same modules (frozen dir `a7ng_sparse_dir_axi(CAND_CAP=32'…` instantiated AXI-idle; stream DUT is the walker). Work `*.sdb`: extract, relbind keys, gate, dir, mem model, **stream_intersect**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_relbind`.

TB holds `poke_v=0` (assigned 0; never `<= 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0`. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + relbind `93811ed1…`; throws if leftover / frozen sparse / KEY-INTERSECT / relbind-sparse on xvlog list; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / LATE_GOLD_MISS / DISTRACTOR_LEAK / SEARCH_INCOMPLETE / diverge. PASS session ⇒ r0 ABSENT.

TB instantiates `.CAND_CAP(CAND_CAP)` with `localparam CAND_CAP = G_CAND_CAP` and `G_CAND_CAP = 16`. Banner `CAND_CAP=16`. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<4096). `MEM_DEPTH=65536` TB-only (`G_MEM_DEPTH`). `.MERGE_POST_AR_MAX(256)`. `.N_BUCKETS(4096)`.

PASS marker conjunct (TB lines 524–525): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0) && late_hit && late_ok && (incomp_retrieve == 0)`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `SEARCH_INCOMPLETE` on `gold_n>=1` (hit or miss) sets `incomp_retrieve=1` and **blocks the PASS marker**. Hunt “marker-only PASS with incomp”: **MISS** this bag (no `SEARCH_INCOMPLETE` line; no `incomp=1`; marker present).

### 5) Stream RTL freeze (hunts DUT-edit / cap-then-AND)

KEEP KEY-INTERSECT DUT `a7ng_query_axi_sparse_intersect.sv` (NOT compiled this bag) still has `buf0`/`buf1` collect-to-cap then AND. Unchanged hash `a912786f…` mtime **10:13:02**.

Live DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**:

- Instantiates frozen extract → relbind keys (not edited) → frozen `a7ng_route_valid_gate`.
- Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle (hash-gate geometry; **not** the merge walker).
- Own AXI master: posting AR `arlen=0` (1-beat page, 4 IDs). No `buf0`/`buf1`. No `n0 < CAND_CAP` collect-then-AND.
- Two-pointer in `S_NEXT`: `id0==id1` → emit if `nemit < CAND_CAP`; `id0 < id1` → `adv0`; else `adv1`. After emit, advance **both**.
- `CAND_CAP` checked **at emit**, not per-list collect.
- Rare-first: when both pages empty, `fetch_sel <= (occ0 <= occ1) ? 0 : 1`.
- `MERGE_POST_AR_MAX=256` exhaust → `acc_incomp` / `q_incomplete_o`.
- Parameter default `CAND_CAP = 64` in the RTL source. **TB overrides 16.** Do not treat 64 as `CAND_CAP_FINAL`.
- Emit-cap still **can** set `acc_incomp` if a 17th AND-hit is attempted. Not fired this bag (`incomp=0`; hoc ∩ size is exactly 16).

Hunt “DUT edited this bag”: **MISS.** Hunt “new filename, old cap-then-AND”: **MISS.**

### 6) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 12:11:03 2026**; exit **12:11:06**; PID **57252**; `$finish` at **59405 ns**.

Banner:

```text
C1_N4096_STREAM_02_N=4096 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-stream-intersect-02 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=65536
```

Named lines (verbatim authority):

```text
CLASS_direct gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=108 ovf=1 trunc=0 dirB=32 postB=832 discB=0 descB=0 incomp=0
EMIT_direct n=3
  CAND direct i=0 id=110 ev=1
  CAND direct i=1 id=144 ev=1
  CAND direct i=2 id=145 ev=1
CLASS_paraphrase … emit {110,144,145} incomp=0
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 id=146 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=114 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct … keys_match=1 emit_match=1 law=qse-v2-stream-intersect-02 xid_not_directory_key
CLASS_wrong_context gold_n=1 emit_n=3 tp=1 fp_ev1=2 prec_all_x1000=333 rec_x1000=1000 incomp=0
CLASS_distractor gold_n=22 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {110,144,145}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 occ=116 postB=880 trunc=0 incomp=0
EMIT_high_occupancy {147…162}
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=167 ovf=1 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=4095 incomp=0
LATE_GOLD_HIT id=4094 k0_idx=115 k1_idx=109
STREAM_HIT id=4094 k0_idx=115 k1_idx=109
CAP_THEN_AND_WOULD_MISS id=4094 k0_idx=115 k1_idx=109 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 prec_all_x1000=1000 rec_x1000=1000 occ=116 ovf=1 trunc=0 dirB=32 postB=912 discB=0 descB=0 incomp=0
EMIT_late_gold n=1
  CAND late_gold i=0 id=4094 ev=1
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_N4096_STREAM_02_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `LATE_GOLD_HIT=1`; `STREAM_HIT=1`; `CAP_THEN_AND_WOULD_MISS=1`; `ASTRA_C1_N4096_STREAM_02_XSIM_PASS=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` = **0**; `FIRST_DIVERGENCE` = **0**; `incomp=1` = **0**. `incomp=0` on `CLASS_late_gold`, `CLASS_high_id_sentinel`, and `CLASS_direct`.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. WO: presence would be FAIL. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS.**

`G_BYTES[10]` LSB-first (char0 at bits[7:0]) decodes to `"compressor requires tower"`; `G_LEN[10]=25`; `G_K0[10]=16'h0402=1026`; `G_K1[10]=16'h0902=2306`; `G_LATE_GOLD_ID=4094`; `G_LATE_K0_IDX=115`; `G_LATE_K1_IDX=109`; `G_CAP_THEN_AND_MISS[10]=1`; `G_SENTINEL_ID=4095`. TB print `CAP_THEN_AND_WOULD_MISS` is gated on that gold bit (print tautology). **The corpus posting math independently confirms the bit is true.**

### 7) Independent corpus — nid 4094 on **both** lists at index ≥16 (hunts prefix-luck / one-list)

Authority = live `corpus.json` records (hash `d342084b…`), **not** the JSON header fields and **not** RESULTS.

Packing: `k0==(subj<<8)|rel`, `k1==(obj<<8)|rel` on all 4096 records: **0** failures. Five pad_synth records have some k2/k3/k0 **numerically equal** to nid (e.g. nid 1795, subj=7 rel=3 ⇒ k0=`(7<<8)|3`=1795). That is packing coincidence, not a nid-derived key law. Hunt nid-derived keys: **MISS as law.**

Record 4094:

```text
nid=4094 text="compressor requires tower" evidence=1 kind=late_gold
subj=4 rel=2 obj=9 ctx=0  k0=1026 k1=2306
```

Exact-key postings (sorted by nid; unsorted_posting_lists=0):

```text
k0=1026 occ=116
  index of 4094 = 115  (>=16)
  last8 = [4071, 4072, 4073, 4074, 4075, 4076, 4077, 4094]

k1=2306 occ=110
  index of 4094 = 109  (>=16)
  last8 = [4087, 4088, 4089, 4090, 4091, 4092, 4093, 4094]
```

```text
full(k0) ∩ full(k1)              = {4094}
first_16(k0) ∩ first_16(k1)      = {}          4094 NOT in first16 of either list
complete ∩ then cap16            = {4094}       HIT
4094 in only one list?           NO
k0-only n                        = 115
k1-only n                        = 109
late_k0_fill (ev=0)              = "compressor requires valve"   k0-only
late_k1_fill (ev=0)              = "condenser requires tower"    k1-only
```

**FACT:** nid 4094 sits at posting index **115** on k0 **and** **109** on k1. Cap-then-AND (`first16 ∩ first16`) **misses**. AND-then-cap / two-pointer **hits**. Planted on **both** lists. Prefix-luck hunt: **MISS** for the registered unknown.

1-beat occupancy model for late_gold: `ceil(116/4)+ceil(110/4)=29+28=57` posting beats; `postB=57*16=912`; `dirB=32`. Live CLASS `dirB=32 postB=912`. **MATCH.** Cap-then-AND that fetched only 16 ids/list would be 4+4=8 posting beats = 128 B. Live 912 B is full walk of both lists to the late nid — consistent with stream merge, not prefix-cap.

Record 4095 (sentinel, also required this bag):

```text
nid=4095 text="sensor connects tower" evidence=1 kind=high_id_sentinel
subj=12 rel=3 obj=9 ctx=0  k0=3075 k1=2307
k0 occ=96  index=95  (>=16)
k1 occ=106 index=105 (>=16)
full ∩ = {4095}
first16 ∩ = {}
complete ∩ then cap = {4095}
```

Raw `CLASS_high_id_sentinel` emit `{4095}` tp=1 incomp=0. **Not** the N4096-INTERSECT-01 cap-then-AND miss (that KEEP bag still has sentinel emit_n=0 on the old law; GOLDEN 10:46:42 unedited).

Direct control (k0=2561, k1=257):

```text
k0 occ=103
k1 occ=108
k0 ∩ k1   {110,144,145}
first16 ∩ first16  {110,144,145}     (control is prefix-resident; intended)
```

MATCH raw `EMIT_direct`. Records 110/144/145 remain PSC (`pump supplies chiller` / water / indirectly). Direct is **not** the late-gold unknown; it is the identity control. Prefix-luck on direct is expected and not a FAIL.

High occupancy (k0=1538, k1=258): full ∩ n=**16** `{147…162}`; first16 ∩ n=**12** `{147…158}`; stream emit n=**16**. Live MATCH ∩-then-cap, **not** cap-then-AND’s 12. Gold 147 is **early** (k0/k1 index 4) — supporting operator split, not the registered late-gold unknown. ∩ size exactly 16 ⇒ emit-cap does not attempt a 17th AND-hit ⇒ `incomp=0` consistent.

Distractor excluded (GOLDEN n=22): `{99,108,109,111,114,118,121,132,188,208,229,248,269,289,310,352,353,354,355,356,357,358}`. `excluded ∩ emit = {}`. MATCH raw `leak_n=0 gold_n=22`. Polarity meter intact.

### 8) Independent n_post vs live (host full-drain overcount)

Host `n_post` is full-occupancy `nbeats(len(k0))+nbeats(len(k1))`. RTL two-pointer may stop earlier. Live `postB/16`:

| class | occ | host full beats | live n_post | delta |
|---|---|---:|---:|---:|
| direct | 103,108 | 53 | **52** | 1 |
| wrong_relation | 101,111 | 54 | **53** | 1 |
| high_occupancy | 116,111 | 57 | **55** | 2 |
| late_gold | 116,110 | 57 | **57** | 0 |
| high_id_sentinel | 96,106 | 51 | **51** | 0 |
| overflow_page | 96,110 | 52 | **52** | 0 |

**FACT:** late_gold and sentinel **MATCH** full-walk beats (must consume both lists to the last nid). Other classes overcount 1–2 beats (AND early-exit / last partial beat). Emit IDs bit-exact vs `G_EMIT`. **Do not freeze `DDR_QUERY_BOUND_FINAL` from host `n_post` or from this XSim.** `MERGE_POST_AR_MAX=256` is not stressed (max live ~57). Occupancy stuffing to ~116 is **not** 800k-like.

### 9) 12-entity clone / 12-bit directory (promotion stop, not this-unknown FAIL)

Independent from `corpus.json` records:

```text
unique entity ids     = {1..12} n=12
names (ev1)           = chiller, condenser, evaporator, compressor, refrigerant,
                        ahu, duct, vav, tower, pump, valve, sensor
unique rel ids        = {1,2,3}
unique ctx ids        = {0,1,2}
n records             = 4096 (nid 0..4095)
kinds                 = pad_synth 3649 / fill 245 / block_a 144 / late fills 32 / …
evidence=1            = 396
N_BUCKETS             = 4096   (12-bit directory)
keys                  = 16-bit (subj<<8)|rel with subj in 1..12
```

This is **stress-on-12-entities** with occupancy padding, not an 800k-representative semantic corpus. Latent directory width is 12-bit. PLAN.md: “N=4096 today is stress-on-12-entities. Do not call it 800k-representative.” Hunt 12-entity clone: **HIT as promotion bound.** Not a FAIL of the registered late-gold unknown. **REJECT C1 800k / N=16384** from this bag.

### 10) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {110,144,145}` tp=3 incomp=0; `late_gold {4094}` `LATE_GOLD_HIT` `CAP_THEN_AND_WOULD_MISS k0_idx=115 k1_idx=109` incomp=0; sentinel `{4095}` tp=1 incomp=0; distractor `leak_n=0 gold_n=22`; hoc emit_n=16 prec_all=62; unrelated empty-walk; wrong_context `NOT_SELECTIVE`). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD.

CLOSEOUT MATCH raw: marker present, DUT `14f75db7…` mtime 11:43:39 not edited, KEEP intersect `a912786f…` not DUT, leftover not compiled, poke_v=0, N4096-INTERSECT GOLDEN 10:46:42 KEEP, STREAM-02 GOLDEN 11:43:45 KEEP, AXI-BEAT KEEP, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`. LATE_GOLD indices 115/109 MATCH independent corpus.

Implementer prose that stream retrieves nid 4094 that first16∩first16 misses, while direct still `{110,144,145}` and sentinel 4095 hits incomp=0: **HONEST vs raw and vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat).

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Prefix luck on late gold | **MISS.** 4094 at k0 115 and k1 109; first16∩={}; not in first16 of either list. | Direct control **is** prefix-resident `{110,144,145}` — intended, not the unknown. |
| 2. SEARCH_INCOMPLETE swallowed | **MISS.** Zero `SEARCH_INCOMPLETE` lines; `incomp=0` on late_gold, sentinel, direct, hoc; TB FAILs gold miss even if incomp **and** blocks marker if `incomp_retrieve`. | Keep this as FAIL law on later bags. |
| 3. 12-entity clone / 12-bit dir | **HIT as promotion bound.** Entity ids {1..12}; `N_BUCKETS=4096`; pad_synth 3649/4096. | **REJECT C1 800k / N=16384.** Not a FAIL of late-gold. |
| 4. C0 dir patched | **MISS.** Live `09334e42…`; mtime 2026-09-05 19:31:03. git `M` vs HEAD is the historical C0 blob (same as 1145Z). | Do not edit `a7ng_sparse_dir_axi.sv`. |
| 5. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 12:04. | Keep that tree read-only. |
| 6. Marker-only PASS with incomp | **MISS.** Marker gated on `incomp_retrieve==0`; raw incomp=0; `SEARCH_INCOMPLETE` ABSENT. | Do not reopen a hole like N4096-INTERSECT-01. |
| 7. DUT edited | **MISS.** SHA `14f75db7…` MATCH STREAM-02; mtime 11:43:39 **not newer** than N=256 bag 11:45:37. | Instantiate only. Hash mismatch ⇒ FAIL, do not patch. |
| 8. Late gold on only one list | **MISS.** 4094 ∈ p0 and p1; full ∩ = {4094}; 115 k0-only + 109 k1-only fillers. Sentinel 4095 also both-list (idx 95 and 105). | Keep both-list index ≥16 as the scale stress. |
| 9. Merge still caps each list first | **MISS.** No buf0/buf1; CAND_CAP at emit; hoc emit 16 vs cap-then 12; late postB=912 not 128. KEY-INTERSECT DUT not compiled. | Do not silent-patch KEEP intersect. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 11. Gold after FAIL / after xvlog | **MISS.** PRE 12:10:22; xvlog 12:10:41; gold still 12:10:22; no r0. | Do not regenerate gold. |
| 12. KEEP bags mutated | **MISS.** N4096-INTERSECT GOLDEN **10:46:42** `095ca715…`; STREAM-02 11:43:45; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk (old-law sentinel miss remains). |
| 13. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. | Authority = raw CLASS_* + LATE_GOLD_HIT + independent postings. |
| 14. C1 800k / bounds / ACCEPT_BOARD / N=16384 | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. N=16384 dirs ABSENT. | Never grant. Never freeze. Never auto-start 800k. |
| 15. CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩={} and 4094 at 115 and 109). | Corpus postings are the proof, not the `$display`. |
| 16. Hash theatre | **MISS** on listed gold/RTL paths (live MATCH PRE + SHA256.txt + C0 + STREAM-02 DUT). | SHA256.txt 12:10:40 is the first-xvlog freeze. |
| Host n_post not bit-exact | **HIT as measurement caveat, not law FAIL.** Direct 53 vs live 52; hoc 57 vs live 55; late MATCH 57=57. | Do not freeze DDR bounds from host `n_post`. |
| CAND_CAP default 64 vs TB 16 | **MISS as this-bag behavior** (TB override 16; banner 16; 16<4096). **HIT as reuse caveat.** | Default 64 is not `CAND_CAP_FINAL`. |
| Banner RARE_LIST_FIRST=1 is a constant | **HIT as print, not as a probe.** | Keep rare-first as scheduler, not a second unknown. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** | Do not call idle dir “the merge”. |
| Direct prec=1000 is 3-id identity | **HIT as quality caveat.** PSC labels = k0∩k1. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=4096 XSim. | Illegal as BOARD_PASS / 800k / DDR freeze. |
| RTL emit-cap can set `q_incomplete_o` | **HIT as residual.** Mixes emit budget with SEARCH_INCOMPLETE. Not fired (`incomp=0`; hoc ∩ n=16). | At later scale: gold miss / incomp on gold_n>=1 must still FAIL. |
| wrong_context still NOT_SELECTIVE | **HIT as law, MISS as overclaim** (labeled). xid still not a key. | Do not fake ctx keys in dir-full16/page-skip/800k. |
| Occupancy ~116 / MERGE_POST_AR_MAX=256 not stressed | **HIT as scale caveat.** | Not a 800k bandwidth claim. |
| k_eq_nid=5 pad_synth collisions | **MISS as nid-derived-key law.** Packing `(subj<<8)|rel` coincidentally equals nid. | Keep pack check; do not treat as cheat. |

qstack-validation-adversary one-liner: **N4096-STREAM-02 XSim is a real same-law late-gold scale lock on unpatched C0 hashes: frozen walker `14f75db7…` (mtime 11:43:39, not newer than N=256 STREAM-02) is nid-sorted two-pointer AND with 1-beat pages and CAND_CAP-after-emit; independent corpus puts nid 4094 at k0 index 115 and k1 index 109 so first16∩first16 is empty while complete∩ then cap hits {4094}; sentinel 4095 also both-list (idx 95/105) tp=1 incomp=0; raw `LATE_GOLD_HIT id=4094 k0_idx=115 k1_idx=109` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0` and CLASS_direct `{110,144,145}` tp=3; `SEARCH_INCOMPLETE` ABSENT; leftover A09 off; poke_v=0; gold PRE 12:10:22 before xvlog 12:10:41; KEEP N4096-INTERSECT GOLDEN 10:46:42 unedited; that is not C1 800k, not N=16384, not a DDR/CAND freeze, not ACCEPT_BOARD, and still a 12-entity / 12-bit-dir clone.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted late_gold tp=1 / direct {110,144,145} / sentinel {4095}). Findings are **law-quality / promotion bounds**, not “patch frozen QSE” and not “fix TB packing”:

1. **Stream law is instantiated as claimed, not rewritten.** Frozen extract unpatched. Relbind keys instantiated not edited. Frozen dir instantiated AXI-idle. Two-pointer compare-and-advance; 1-beat `arlen=0`; rare-first fetch; CAND_CAP at emit. k2/k3 not probed. leftover A09 off. poke_v=0. SHA MATCH STREAM-02.
2. **Late gold is a real discriminator at N=4096, not a one-list plant and not prefix luck.** Independent postings: 4094 at 115 and 109; first16∩={}; complete∩={4094}; live emit={4094} incomp=0. Fillers occupy prefixes without being AND hits. postB=912 MATCH full 57-beat walk.
3. **High-id sentinel 4095 also hits** (both-list idx 95 and 105; first16∩={}; tp=1 incomp=0). This closes the hole that N4096-INTERSECT-01 left on `qse-v2-intersect-01` (KEEP; do not patch that bag).
4. **Direct control survived the corpus rebuild.** `{110,144,145}` still PSC and still k0∩k1. Distractor leak_n=0 on a 22-id excluded set. Polarity meter intact.
5. **hoc emit_n=16 vs cap-then-AND 12** is the same operator split measured at N=256. Gold 147 is early. Supporting evidence, not the registered unknown. ∩ n=16 explains incomp=0 at emit-cap.
6. **Host AR-count twin is not bit-exact** except on late/sentinel full walks. Emit IDs are the twin lock. Bytes are not this bag’s freeze.
7. **CAND_CAP default 64 in RTL source is a future-bag hazard**, not a this-bag cheat (TB 16). Do not freeze 16 as `CAND_CAP_FINAL`.
8. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). Later bags must still FAIL gold_n>=1 + incomp.
9. **Index is `axi_mem_model`, not MIG/DDR.** Honest for N=4096 XSim; illegal as C2 / production retrieval / 800k close.
10. **Frozen keys still omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`.
11. **12-entity clone + 12-bit `N_BUCKETS=4096` + pad_synth majority** is the promotion stop. PLAN bag3 is “scale of merge, not prefix luck” — **closed**. PLAN bags 4–7 (dir-full16 / page-skip / context / semantic 16k→800k) are **not** closed and **not** started by this audit.
12. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
13. **N=4096 KEEP INTERSECT still exhibits sentinel miss on `qse-v2-intersect-01`.** This bag does not repair that archive. GOLDEN 10:46:42 unedited.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start N=16384 / 800k / dir-full16 / page-skip / context in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 hashes, leftover off, poke_v=0, CAND_CAP=16<4096, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| Stream DUT freeze (`14f75db7…`, mtime 11:43:39 not newer than N=256 stream bag, two-pointer AND, not buf0/buf1) | **PASS_NARROW** | Instantiate only. Not rewritten. |
| Independent nid 4094 at k0 index ≥16 **and** k1 index ≥16; first16∩first16 miss; complete∩ then cap hit | **PASS_NARROW** | idx 115 and 109; first16∩={}; stream={4094}. |
| Sentinel nid 4095 both-list late; tp=1 incomp=0 | **PASS_NARROW** | idx 95 and 105; first16∩={}; raw emit={4095}. |
| Registered unknown (`LATE_GOLD_HIT` **and** CLASS_direct `{110,144,145}` **and** SEARCH_INCOMPLETE ABSENT on gold retrieve) | **PASS_NARROW** | Raw `LATE_GOLD_HIT id=4094 k0_idx=115 k1_idx=109` `incomp=0`; direct tp=3; sentinel tp=1; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_N4096_STREAM_02_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or N=16384. |
| Marker-only PASS with incomp | **MISS (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; TB would have blocked. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; hoc prec_all=62; 12-entity clone; context not in keys; reduction not emitted. |
| C1 800k / N=16384 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 12-entity / 12-bit dir / axi_mem_model. This audit does not start next bags. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 12:10:22; xvlog 12:10:41; gold 12:10:22 KEEP `2a2db8c8…`; no r0. |
| KEEP N4096-INTERSECT + STREAM-02 + KEY-INTERSECT + AXI-BEAT + C0 hashes + intersect DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1145Z / C0. N4096-INTERSECT GOLDEN **10:46:42**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=4096 `qse-v2-stream-intersect-02` late-gold: nid 4094 at both-list index ≥16 hits; cap-then-AND would miss; sentinel 4095 hits incomp=0; direct `{110,144,145}` remains; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; C0 MATCH; gold-before-xvlog; DUT `14f75db7…` unedited; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=16384, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS. **Not** FAIL_LOOP (hashes real, C0 unpatched, gold not rewritten, 800k not claimed, walker is not cap-then-AND relabeled, PASS is honest, late gold is both-list, SEARCH_INCOMPLETE absent, DUT not edited). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k). **Not** FAIL.

**P1 for this unknown: none.** Parent next is **OPTIONAL** dir-full16 / page-skip / context **or** semantic corpus restart. Do **not** auto-start 800k / N=16384. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-N4096-STREAM-02` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_intersect.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or late_gold postB=912.

**P1 — none for this unknown** (late gold independently at k0 index 115 and k1 index 109; first16∩first16 miss; stream hit; sentinel 4095 tp=1 incomp=0; direct `{110,144,145}`; SEARCH_INCOMPLETE ABSENT; DUT SHA MATCH STREAM-02 and mtime not newer than N=256 bag).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=4096 same-law late-gold. Authority = raw `LATE_GOLD_HIT` / `CLASS_direct` / `CLASS_high_id_sentinel incomp=0` / `CLASS_late_gold incomp=0` + independent postings. Archive `qse-v2-intersect-01` N=4096 (KEEP GOLDEN 10:46:42); do not silent-patch it.
2. **Parent MAY open OPTIONAL next:** `ASTRA-C1-DIR-FULL16-01` (16-bit exact bucket) **or** `ASTRA-C1-PAGE-SKIP-01` (min/max page skip) **or** `qse-v2-intersect-context-02` **or** a **semantic** corpus restart (not another synthetic 12-entity clone). One unknown each. Not this audit.
3. **Do not auto-start C1 800k / N=16384 / BOARD_PASS.** 12-entity clone + 12-bit dir + `axi_mem_model` are the stop. Semantic ladder 16k→800k is PLAN bag 7, after a frozen stream law **and** after (optional) dir/page/context — not a clone upsample.
4. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64 is unused this bag; TB 16 is not FINAL. Host `n_post` overcounts AND early-exit. Index is `axi_mem_model`. MERGE_POST_AR_MAX=256 was not stressed.
5. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE`; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; KEY-INTERSECT DUT not compiled; frozen sparse not compiled; stream DUT instantiate-only; relbind keys instantiated not edited; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag.
6. Next bag should instantiate `.CAND_CAP(16)` explicitly (do not rely on RTL default 64). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02 N=256.
7. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
8. KEEP bags including N4096-INTERSECT GOLDEN 10:46:42 sentinel miss, STREAM-02 N=256 nid 254 at 20/22, KEY-INTERSECT gold 10:16:50, AXI-BEAT hoc 256/96/2666, R3 `leak_n=10`, and relbind `leak_n=9` stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=4096 qse-v2-stream-intersect-02 late-gold;
                         DUT a7ng_query_axi_sparse_stream_intersect 14f75db7…
                           MATCH STREAM-02; mtime 11:43:39 NOT newer than N=256 bag;
                           two-pointer AND, 1-beat page, rare-first, CAND_CAP after emit;
                           NOT KEY-INTERSECT buf0/buf1 cap-then-AND;
                         LATE_GOLD nid 4094 at k0 index 115 AND k1 index 109;
                         first16∩first16 = {}; complete∩ then cap = {4094};
                         raw LATE_GOLD_HIT id=4094 k0_idx=115 k1_idx=109
                           STREAM_HIT CAP_THEN_AND_WOULD_MISS stream_hit=1;
                         CLASS_late_gold emit={4094} tp=1 rec=1000 incomp=0;
                         CLASS_high_id_sentinel emit={4095} tp=1 incomp=0
                           (independent idx 95 and 105; first16∩={});
                         CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 hashes MATCH;
                         gold 2a2db8c8… 12:10:22 PRE before xvlog 12:10:41;
                         KEEP N4096-INTERSECT GOLDEN 10:46:42 095ca715…;
                         KEEP STREAM-02 GOLDEN 11:43:45 05c6e087…;
                         KEEP KEY-INTERSECT d3b5b883… 10:16:50;
                         KEEP AXI-BEAT max 11:11:09;
                         independent tree UNMODIFIED (≤10:52:29);
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN)
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not N=16384,
                            not Master ≥95% recall, not Master ≥90% reduction,
                            not ACCEPT_BOARD, not BOARD_PASS;
                            12-entity clone + 12-bit N_BUCKETS=4096 remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL dir-full16 / page-skip / context
                   OR semantic corpus restart
                   (do NOT auto-start C1 800k / N=16384;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
N_16384          = NOT_STARTED
N4096_STREAM_02_XSIM = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_N4096_STREAM_02_XSIM_PASS PRESENT
                   PID 57252; 59405 ns; 12:11:03–12:11:06
                   xsim.log SHA256 dd1a151a6f4be2713088901e1f24b1f8295d78813b8e6afd266571e5f83e9947
                   LATE_GOLD_HIT id=4094 k0_idx=115 k1_idx=109 incomp=0
                   CLASS_direct {110,144,145} tp=3 incomp=0
                   CLASS_high_id_sentinel {4095} tp=1 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 12:10:22; PRE MATCH live;
                                no r0; PASS session
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_PATCH         = MISS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N4096_INTERSECT_KEEP = UNMODIFIED GOLDEN 10:46:42 095ca7156c1f8efe60d1a2d689f93192271eb79bfb2747f3f12d2b90ea0f9dd3
STREAM02_N256_KEEP   = UNMODIFIED GOLDEN 11:43:45 05c6e087… CLOSEOUT 11:45:37
KEY_INTERSECT_KEEP   = UNMODIFIED d3b5b883… 10:16:50
AXI_BEAT_KEEP        = UNMODIFIED max 11:11:09
INDEP_TREE           = UNMODIFIED PLAN/EVIDENCE ≤ 10:52:29
LEFTOVER_A09         = not compiled
POKE_V               = 0
NID_4094_K0_IDX      = 115 (>=16)  EVIDENCE from corpus.json records
NID_4094_K1_IDX      = 109 (>=16)
FIRST16_AND          = {}          would miss
STREAM_AND_CAP       = {4094}      hits
BOTH_LISTS           = YES
NID_4095_K0_IDX      = 95  (>=16)
NID_4095_K1_IDX      = 105 (>=16)
ENTITY_N             = 12 (clone; REJECT 800k)
N_BUCKETS            = 4096 (12-bit dir; REJECT 800k)
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=16384 / dir-full16 / page-skip / context / 800k in this audit.
