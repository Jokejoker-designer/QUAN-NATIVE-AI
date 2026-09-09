# ASTRA auditor REPORT — 20260907T1340Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-PAGE-SKIP-01
LAW        = qse-v2-page-skip-01  (NEW named walker a7ng_query_axi_sparse_page_skip.sv)
KEEP       = ASTRA-C1-DIR-FULL16-01 (must be unmodified; GOLDEN 12:44:33 verified)
           + ASTRA-C1-STREAM-INTERSECT-02 N=256 (must be unmodified; GOLDEN 11:43:45 verified)
           + ASTRA-C1-N4096-STREAM-02 (must be unmodified; GOLDEN 12:10:22 verified)
           + ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; GOLDEN 10:46:42 verified)
           + ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-AXI-BEAT-ACCOUNTING-01 (must be unmodified; hoc POST_R=14 verified)
           + R1 / R2 / R3 / KEY-RELBIND (verified via prior 1250Z; mtimes unchanged)
           + C0 RTL FILE hashes (extract/lexicon FILE/sparse/dir/gate; verified MATCH)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (KEEP; not compiled as DUT)
           + stream DUT a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (KEEP; NOT compiled as DUT)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1250Z/REPORT.md
           ACCEPT_PARTIAL (DIR-FULL16 16-bit bucket; P1 none; parent MAY open OPTIONAL page-skip)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag5 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-PAGE-SKIP-01.md
EVIDENCE   = raw xsim.log CLASS_* / EMIT_* / AXI_BEAT / HOC_POST_R_BEATS /
             LATE_GOLD_HIT / ASTRA_C1_PAGE_SKIP_XSIM_PASS / NOT_SELECTIVE /
             UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + STREAM-02 SHA256.txt
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP bags)
           + NEW DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_page_skip.sv
             (S_ARHDR / can_skip / n_page_skip_o; not STREAM-02 clone)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime vs N=256 bag; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_page_skip.sv (poke_v, leftover A09, PAGE_N, PASS conjunct)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + xvlog include_dirs order in run_xsim.ps1 (`-i $incq -i $incc -i $bag`)
           + C0 qse_role_lexicon.svh QSE2_N_LEX=59 (no bag qse_role_lexicon.svh)
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_page_skip.py
           + independent corpus exact-key postings for hoc k0=1538/k1=258 and nid 254
             (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
CONTEXT_KEYS = NOT STARTED (this audit does not start it)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP DIR-FULL16 / STREAM-02 N=256 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start context / C1 800k / N=16384, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=256 posting page min/max skip** bag `ASTRA-C1-PAGE-SKIP-01` after auditor `20260907T1250Z` ACCEPT_PARTIAL of DIR-FULL16 (P1 none) allowed parent to open OPTIONAL PLAN bag 5.

`results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=256, **new named walker** `qse-v2-page-skip-01` (host + `a7ng_query_axi_sparse_page_skip.sv` only; posting page `{min,max,nrec}` headers; skip remaining POST AR/R when page.max < other-stream cursor) — does CLASS_direct emit stay bit-identical `{110,144,145}` **and** does high_occupancy `POST_R_BEATS` stay strictly **< AXI-BEAT baseline 14** **and** is at least one page actually skipped (not headers-only / packing-only) **and** if STREAM-02 late-gold nid **254** remains in this corpus, is it still in emit (`SEARCH_INCOMPLETE` must not hide a miss)?

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_PAGE_SKIP_XSIM_PASS` present.
2. CLASS_direct emit bit-identical `{110,144,145}`; `SEARCH_INCOMPLETE` **ABSENT** on gold retrieve.
3. hoc `POST_R_BEATS` strictly `< 14` (AXI-BEAT 16-byte R-beat baseline; hoc TOTAL_AXI_BYTES was 256 B) **and** hoc `n_page_skip >= 1` from live DUT (header fetched, data AR omitted).
4. STREAM-02 late-gold nid **254** in emit (`LATE_GOLD_HIT`); miss is FAIL, not `SEARCH_INCOMPLETE`.
5. NEW walker is real min/max skip — **not** a STREAM-02 re-label, **not** packing-only that just shrinks pages / densifies beats. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Frozen dir file `09334e42…` **not** patched. C0 59-word lexicon `38189974…` is the **runtime** table (xvlog `-i` C0 query **first**; **no** bag `qse_role_lexicon.svh` shadow).
6. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
7. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start context / 800k.

If skip is packing-only (POST_R drop without header skip / min-max AR omission), this bag is **FAIL** or **OVERCLAIM** with a required fix. This audit grades that hunt from corpus + RTL, not from RESULTS.

This bag **cannot** close C1 800k, cannot promote N=16384, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. Context keys remain a later bag.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/` (GOLDEN `2f6ab31e…` timestamp **12:44:33**; CLOSEOUT **12:46:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/` (GOLDEN `2a2db8c8…` timestamp **12:10:22**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN `095ca715…` timestamp **10:46:42**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**; raw hoc `POST_R_BEATS=14` `R_BYTES=256`)
- R1 / R2 / R3 / KEY-RELBIND
- C0 **FILE** hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **not** compiled as DUT)

**Not** this bag: C1 800k close, N=16384 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, bag lexicon shadow, threshold drop, `relevant=router_union`, nid-derived keys, context keys, loading full posting into BRAM, patching KEEP bags, editing stream RTL `14f75db7…`, editing `a7ng_sparse_dir_axi.sv`.

Hunt (dispatch, none dropped):

1. Skip fake: `POST_R` drop without header skip (packing-only / shrink pages)
2. NEW RTL is a STREAM-02 clone (no min/max; no `S_ARHDR`; skip counter gold-bit tautology)
3. Late-gold nid 254 miss hidden by `SEARCH_INCOMPLETE` / marker-only PASS
4. C0 lexicon FILE edited (`38189974` drift) **or** bag `qse_role_lexicon.svh` shadow (DIR-FULL16 61-word pattern)
5. xvlog `-i` order does **not** put C0 query first
6. STREAM-02 `14f75db7…` compiled as DUT or edited (mtime newer than N=256 STREAM-02)
7. Frozen dir `.sv` patched (`09334e42` drift)
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. Gold hashed after first xvlog / rewritten after FAIL
10. KEEP bags rewritten
11. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
12. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / context started
13. Hash theatre (SHA256.txt vs live Get-FileHash)
14. Independent audit tree written by this implementer
15. hoc skip=2 is print tautology (gold bit, not live `n_page_skip_o` / not corpus min-max)
16. Direct emit drift from `{110,144,145}`

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=256 page-skip** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** context keys **or** semantic corpus restart. Do **not** auto-start C1 800k / N=16384 / context from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. PAGE-SKIP bag is untracked (`??`). NEW DUT `a7ng_query_axi_sparse_page_skip.sv` is untracked (`??`). KEEP KEY-INTERSECT / N4096-INTERSECT / STREAM-02 / N4096-STREAM-02 / DIR-FULL16 / AXI-BEAT remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…`. KEEP intersect DUT remains untracked with **unchanged** hash `a912786f…`. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1250Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T13:45:00+07:00` `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-DIR-FULL16-01` `unblocked_item=ASTRA-C1-PAGE-SKIP-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), PAGE-SKIP bag:

```text
13:31:29.466  rtl/native_graph/integrate/a7ng_query_axi_sparse_page_skip.sv   ← NEW walker
13:34:09.999  host_astra_c1_page_skip.py
13:34:19.423  corpus.json
13:34:19.424  GOLDEN.json
13:34:19.425  query_gold.svh
13:34:19.426  GOLD_HASH_PRE_XVLOG.txt      ← gold hash BEFORE first xvlog
13:35:44.313  tb_astra_c1_page_skip.sv
13:37:43.060  run_xsim.ps1 ACK.json PREREG.md
13:38:04.541  SHA256.txt                   ← freeze immediately before first xvlog
13:38:05.894  xvlog.log
13:38:09.120  xelab.log
13:38:12.984  xsim.log                     PID 39224; session 13:38:10–13:38:12
13:39:47.345  RESULTS.md CLOSEOUT.md
```

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag (GOLDEN 11:43:45 / CLOSEOUT 11:45:37). This bag starts 13:34. STREAM-02 was not rewritten for PAGE-SKIP.

Frozen dir LastWriteTime **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. `role_lexicon.py` **2026-09-05 20:49:59.239**.

Single XSim session. No second xvlog. Gold files were **not** rewritten between 13:34:19 and 13:39:47 (hash MATCH PRE; LastWriteTime still 13:34:19). `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `29e38918262536b7f03db9ddb77681b8906ce9db1debc6564548ca2d982bc8d9` MATCH RESULTS `XSIM_SHA`.

Bag `qse_role_lexicon.svh` **ABSENT**. N=16384 / C1-800k bag paths **ABSENT**. Context-keys bag **ABSENT**.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / STREAM-02 DUT / NEW walker

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  rtl/.../qse_role_lexicon.svh        (C0 FILE MATCH; mtime 2026-09-05 20:51:03)
                                                                 **this IS the compiled runtime table**
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (mtime 09:43:58)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv
                                                                  (STREAM-02 MATCH; mtime 11:43:39; NOT compiled this bag)
dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817  a7ng_query_axi_sparse_page_skip.sv
                                                                  (NEW named DUT; mtime 13:31:29)
a5d0eb3c4df33c36128782295aea06480241e6e0cd85b19594b3ff15bd3b78b2  a7ng_query_axi_rbeat_probe.sv
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7  a7ng_gate14_crc.svh
6cd9c0734dddf2ff0999d06b270373d85c48a0ae145c109c645a2b61b46166b1  tb_astra_c1_page_skip.sv
```

STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH.

`GOLD_HASH_PRE_XVLOG.txt` mtime **13:34:19.426** vs live gold (all MATCH):

```text
86b536fb6ce46d7ba6ffb59947822bf245d3253647be17664d22565dd31a566e  GOLDEN.json
390dd3de727fde6c893d1e0deac425e28c5890e4adc164d0a0fc87139ab822ef  query_gold.svh
1f0ae9a6457729d5af64a4ff103c2719413de40f328d81dd9b7191ed941ae325  corpus.json
```

`xvlog.log` mtime **13:38:05.894**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 13:34:19). SHA256.txt freeze stamp `2026-09-07T13:38:04.4361963+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **29 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, NEW page-skip DUT `dab15d76…`, probe, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple, gate14 crc). No invented hash. SHA256.txt `# FORBIDDEN bag qse_role_lexicon.svh shadow` — bag copy **ABSENT** on disk.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 13:31+ |
|---|---|---|---|
| DIR-FULL16 | `2f6ab31e41837fd3…` **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** PAGE-SKIP implementer did **not** write that tree. This auditor did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / STREAM-02 not DUT / include_dirs

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_page_skip.sv
a7ng_query_axi_rbeat_probe.sv
tb_astra_c1_page_skip.sv
```

`xelab.log` compiled the same modules (`a7ng_query_axi_sparse_page_skip`, frozen dir AXI-idle, probe, TB). Work `*.sdb`: extract, relbind keys, gate, dir, mem model, **page_skip**, rbeat_probe, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_relbind`.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1` after that). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + relbind `93811ed1…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / relbind-sparse on xvlog list; throws if bag `qse_role_lexicon.svh` exists; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / HOC fail / LATE_GOLD miss / DISTRACTOR_LEAK / diverge. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` line 169, the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $incq -i $incc -i $bag $files
```

`$incq` = `rtl/native_graph/query` (C0 lexicon FILE) **first**. `$incc` = `rtl/native_graph/control`. `$bag` **third** (gold svh only). Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **C0** 59-word table. Opposite of DIR-FULL16 (`-i $bag` first). Hunt bag lexicon shadow: **MISS.**

TB instantiates `.N_BUCKETS(G_N_BUCKETS)` with `G_N_BUCKETS = 4096`, `.PAGE_N(G_PAGE_N)` with `G_PAGE_N = 16`, `.CAND_CAP(16)`, `.MERGE_POST_AR_MAX(256)`. Banner `N_BUCKETS=4096 PAGE_N=16 CAND_CAP=16`. `if (G_N_BUCKETS != 4096) diverge DIR_WIDTH` not taken. `if (G_PAGE_N != 16) diverge PAGE_CONTRACT` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<256). `MEM_DEPTH=32768` TB-only.

PASS marker conjunct (TB lines 567–568): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0) && direct_ids_ok && late_hit && late_ok && hoc_post_ok && hoc_skip_ok`. Direct IDs must be exactly `{110,144,145}` or `FAIL DIRECT_EMIT_NOT_BIT_IDENTICAL`. hoc `POST_R >= 14` → `FAIL HOC_POST_R_NOT_BELOW_AXI_BEAT`. hoc `n_skip < 1` → `FAIL HOC_NO_PAGE_SKIP` (“headers without skip is FAIL”). Late nid 254 miss → `FAIL LATE_GOLD_MISS` / `FAIL LATE_GOLD_254_MUST_EMIT` even if incomp. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`.

Caveat vs DIR-FULL16: this TB does **not** keep an `incomp_retrieve` flag that **blocks the marker** on gold-hit + `SEARCH_INCOMPLETE`. Gold-hit with `incomp=1` prints `SEARCH_INCOMPLETE` and does **not** increment `fail`. Live: `incomp=0` on every CLASS line; `SEARCH_INCOMPLETE` line count **0**. Hunt swallowed-incomp: **MISS this bag**; residual P2 vs DIR-FULL16 conjunct.

### 5) PRIMARY HUNT — C0 59-word runtime (no bag shadow)

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
```

Bag `results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/qse_role_lexicon.svh`: **ABSENT**. `run_xsim.ps1` throws `C1PAGESKIP_BAG_LEXICON_SHADOW_FORBIDDEN` if present. xvlog `-i` C0 query **first**.

Live extract on `"pump supplies chiller"` / `"ahu requires chiller"` / `"compressor requires tower"` produced CLASS lines with no `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. Independent packing `k0==(subj<<8)|rel` on all 256 records: **0** failures. Direct k0=2561=`0x0A01` (pump=10, rel=1) MATCH C0 HVAC ids 1..12. **Runtime table is C0 `38189974…` 59-word.** DIR-FULL16 61-word boiler/header shadow was **not** reused.

Hunt “C0 lexicon file edited”: **MISS.** Hunt “bag lexicon shadow”: **MISS.** Hunt “xvlog did not put C0 first”: **MISS.**

### 6) NEW walker vs STREAM-02 clone / packing-only (hunts 1–2, 6)

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**: 610 lines; **no** `S_ARHDR` / `can_skip` / `n_page_skip`. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

NEW DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**: 777 lines. Instantiates frozen extract → relbind keys (not edited) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle (`q_v=0`, k*_valid=0, `arready=0` — **not** the merge walker). Own AXI master: `arlen=0` (1-beat). States include `S_ARHDR` / `S_RHDR` / `S_ARPOST` / `S_RPOST`. No `buf0`/`buf1`. No per-list `n0 < CAND_CAP` collect-then-AND. `CAND_CAP` checked **at emit**. Two-pointer in `S_NEXT`. Skip:

```text
can_skip0 = hhdr0 && !have0 && !dfetched0 && (have1 || hhdr1) && (hmax0 < other_lo1)
can_skip1 = hhdr1 && !have1 && !dfetched1 && (have0 || hhdr0) && (hmax1 < other_lo0)
```

On skip: `pos += hnrec`; `hhdr=0`; `acc_nskip++`; **no** transition to `S_ARPOST` for that page. Header already paid (`S_ARHDR` increments `acc_npost` **and** `acc_nhdr`). Data AR omitted. `n_page_skip_o <= acc_nskip` at `S_DONE`. Probe `POST_R` counts `rvalid&&rready` on posting-heap addresses (headers **and** data); skip therefore drops data R-beats after a header R-beat.

Hunt “STREAM-02 clone / new filename old law”: **MISS.** Hunt “DUT STREAM-02 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime).

Parameter default `CAND_CAP = 64` remains in the NEW `.sv`. **TB overrides 16.** Do not treat 64 as `CAND_CAP_FINAL`. Default `N_BUCKETS=4096` MATCH this bag (unlike DIR-FULL16 instantiate 65536). Header magic `A7A1` is packed by the host (`rdata[95:80]`) and **not checked** in `S_RHDR` (walker uses min/max/nrec only). P2, not this-unknown FAIL.

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 13:38:10 2026**; exit **13:38:12**; PID **39224**; `$finish` at **18185 ns**.

Banner:

```text
C1_PAGE_SKIP_N=256 N_BUCKETS=4096 CAND_CAP=16 INDEX_HEAD=4 PAGE_N=16 LAW=qse-v2-page-skip-01 POKE_V=0 CAND_CAP_AFTER_EMIT=1 AXI_BEAT_HOC_POST_R=14 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN
```

Named lines (verbatim authority):

```text
CLASS_direct gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=8 ovf=1 trunc=0 dirB=32 postB=128 discB=0 descB=0 incomp=0
EMIT_direct n=3
  CAND direct i=0 id=110 ev=1
  CAND direct i=1 id=144 ev=1
  CAND direct i=2 id=145 ev=1
AXI_BEAT class=direct DIR_R=2 POST_R=8 R_BYTES=160 AR_DIR=2 AR_POST=8 skip=0 hdr_ar=4 vs_AXI_BEAT_hoc_POST_R=14
CLASS_paraphrase … emit {110,144,145} incomp=0
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 id=146 skip=2 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=114 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct … keys_match=1 emit_match=1 law=qse-v2-page-skip-01 xid_not_directory_key
CLASS_wrong_context gold_n=1 emit_n=3 tp=1 fp_ev1=2 prec_all_x1000=333 rec_x1000=1000 incomp=0
CLASS_distractor gold_n=10 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {110,144,145}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 occ=22 ovf=1 trunc=0 dirB=32 postB=192 discB=0 descB=0 incomp=0
EMIT_high_occupancy {147…162}
AXI_BEAT class=high_occupancy DIR_R=2 POST_R=12 R_BYTES=224 AR_DIR=2 AR_POST=12 skip=2 hdr_ar=4 vs_AXI_BEAT_hoc_POST_R=14
HOC_POST_R_BEATS=12 AXI_BEAT_BASELINE=14 LT14=1 PAGE_SKIP=2
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=167 ovf=1 skip=2 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=255 skip=2 incomp=0
LATE_GOLD_HIT id=254
CAP_THEN_AND_WOULD_MISS id=254 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 id=254 occ=23 ovf=1 trunc=0 dirB=32 postB=256 incomp=0
AXI_BEAT class=late_gold DIR_R=2 POST_R=16 R_BYTES=288 AR_DIR=2 AR_POST=16 skip=2 hdr_ar=6 vs_AXI_BEAT_hoc_POST_R=14
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_PAGE_SKIP_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384,CONTEXT_KEYS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_PAGE_SKIP_XSIM_PASS=1`; `LATE_GOLD_HIT=1`; `HOC_POST_R_BEATS=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` = **0**; `FIRST_DIVERGENCE` = **0**; `ROLE_COLLAPSE` = **0**; `incomp=1` = **0**. `incomp=0` on `CLASS_direct`, `CLASS_high_occupancy`, `CLASS_late_gold`, `CLASS_high_id_sentinel`.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. WO: presence would be FAIL. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_direct emit `{110,144,145}` tp=3. hoc `POST_R=12` `skip=2` `hdr_ar=4` `LT14=1`. Late emit `{254}` `LATE_GOLD_HIT`. Conjunctive gate holds on raw.

AXI-BEAT KEEP raw (not this bag): hoc `POST_R_BEATS=14` `R_BYTES=256` = `16*(DIR_R=2+POST_R=14)`. PAGE-SKIP hoc `R_BYTES=224` = `16*(2+12)`. Same 16-byte R-beat width. Registered baseline is beat count 14, not STREAM-02 density.

STREAM-02 N=256 KEEP raw hoc `postB=160` ⇒ **10** posting beats, skip n/a (no headers). PAGE-SKIP hoc **12** is **worse** than STREAM-02 dense packing and **better** than AXI-BEAT 14. Implementer RESULTS states this. Not a silent 800k claim.

### 8) Independent corpus — skip is real min/max, not packing-only

Authority = live `corpus.json` records (hash `1f0ae9a6…`), **not** the JSON header fields and **not** RESULTS.

Packing: `k0==(subj<<8)|rel`, `k1==(obj<<8)|rel` on all 256 records: **0** failures. `k_eq_nid=0`. Hunt nid-derived keys: **MISS.** Posting lists nid-sorted: `unsorted_posting_lists=0`.

```text
unique entity ids = {1..12} n=12
names             = C0 HVAC 1..12 (no boiler/header)
unique rel ids    = {1,2,3}
unique ctx ids    = {0,1,2}
n records         = 256 (nid 0..255)
kinds             = block_a 144 / fill 54 / late_k0_fill 16 / late_k1_fill 16 /
                    high_occ_synth 15 / ovf_synth 4 / …
evidence=1        = 205
N_BUCKETS         = 4096
PAGE_N            = 16
INDEX_HEAD        = 4
```

Direct control (k0=2561, k1=257):

```text
k0 occ=6  [108,109,110,111,144,145]
k1 occ=8  [99,121,132,…,144,145,208]
k0 ∩ k1   {110,144,145}
skip_walk emit {110,144,145} n_post=8 skip=0 hdr=4 data=4
```

MATCH raw `EMIT_direct`. Records 110/144/145 remain PSC (`pump supplies chiller` / water / indirectly). Direct **cannot** skip: k0 head `{108..111}` max=111 is not `<` k1 min=99. Skip=0 on direct is expected, not a FAIL.

High occupancy (k0=1538 `ahu requires *`, k1=258 `* requires chiller`):

```text
k0 occ=20  [64,65,66,67, 147…162]
k1 occ=22  [103,114,125,136, 147…162, 195,215]
full ∩                 = {147…162} n=16
first16 ∩ first16      = {147…158} n=12   (cap-then-AND would drop 159…162)
complete ∩ then cap16  = {147…162}

k0 pages: head nrec=4 min=64  max=67  ; ovf nrec=16 min=147 max=162
k1 pages: head nrec=4 min=103 max=136 ; ovf nrec=16 min=147 max=162 ; ovf nrec=2 min=195 max=215

Independent skip_walk (RTL can_skip law, not RESULTS):
  SKIP k0 head  nrec=4 min=64  max=67  because hmax0=67  < other_lo1=103 (k1 head min)
  SKIP k1 head  nrec=4 min=103 max=136 because hmax1=136 < other_lo0=147 (k0 overflow min)
  emit {147…162} n_post=12 skip=2 hdr=4 data=8
```

Skipped IDs `{64,65,66,67}` and `{103,114,125,136}` are **disjoint** from AND `{147…162}`. Skip does not drop a gold/AND hit.

`hdr_ar=4` = both heads (skipped after header) + both 16-ID overflow pages (data fetched). k1 last overflow `{195,215}` is **not** header-fetched: emit-cap 16 completes at nid 162. `n_data=8` = 4+4 data beats of the two 16-ID overflow pages. MATCH live `AXI_BEAT … skip=2 hdr_ar=4 POST_R=12`.

Counterfactuals (independent, same lists, same emit-cap stop):

```text
page-format WITH skip (live)          POST_R = 4 hdr + 8 data           = 12
page-format WITHOUT skip (emit-cap)   POST_R = 4 hdr + 8 data + 2 head data = 14
page-format full drain (no emit-cap)  POST_R = 16
STREAM-02 dense full-list nbeats      ceil(20/4)+ceil(22/4)             = 11
STREAM-02 KEEP live hoc postB/16                                      = 10
AXI-BEAT KEEP live hoc POST_R                                         = 14
```

**FACT:** without min/max skip, page-format POST_R = **14**, which is **not** strictly `< 14`. The two skipped head **data** beats are exactly the difference `14→12`. Headers-only packing (skip=0) would **FAIL** `HOC_POST_R_NOT_BELOW_AXI_BEAT` **and** `HOC_NO_PAGE_SKIP`. STREAM-02 already beats AXI-BEAT by denser packing (10) with **no** skip; PAGE-SKIP pays a header tax and still needs skip to clear the registered `< 14` gate.

Hunt “packing-only / shrink pages / POST_R drop without header skip”: **MISS.** Mechanism is header-then-omit on `hmax < other_lo`. `PAGE_N=16` is **larger** logical pages than STREAM-02’s 4 IDs/beat, not smaller. Skipped pages this bag are **INDEX_HEAD=4** prefix pages (1 data beat each), not 16-ID overflow pages — real skip, small traffic win vs AXI-BEAT, **not** a win vs STREAM-02. Quality bound, not FAIL of the registered unknown.

GOLDEN `noskip_post=11` for hoc is host `nbeats(len(a))+nbeats(len(b))` = STREAM-02 **full-list** packing, **not** page-format-without-skip (that would be 14). Naming caveat. P2.

Late gold nid 254 (`compressor requires tower`, k0=1026, k1=2306):

```text
k0 occ=21  index of 254 = 20  (>=16)
k1 occ=23  index of 254 = 22  (>=16)
full ∩              = {254}
first16 ∩ first16   = {}          254 NOT in first16 of either list
complete ∩ then cap = {254}
skip_walk emit {254} n_post=16 skip=2 hdr=6 data=10
```

MATCH raw `LATE_GOLD_HIT id=254` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0`. `CAP_THEN_AND_WOULD_MISS` **is** gated on gold bit `G_CAP_THEN_AND_MISS` (print tautology). Independent first16∩={} and indices 20/22 prove the bit is true. Same STREAM-02 N=256 late-gold plant (KEEP 11:43:45). Hunt late-gold miss hidden: **MISS.** Hunt one-list plant: **MISS.**

Sentinel nid 255 both-list; skip=2; emit `{255}` tp=1 incomp=0. MATCH raw.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {110,144,145}` tp=3 incomp=0; hoc `POST_R=12` `skip=2` `LT14=1`; `LATE_GOLD_HIT id=254` incomp=0; distractor `leak_n=0 gold_n=10`; unrelated empty-walk; wrong_context `NOT_SELECTIVE`). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, CONTEXT_KEYS.

Implementer prose that skip drops two hoc **head** pages (`k0 head max=67 < k1 min=103`; `k1 head max=136 < k0 overflow min=147`) so POST_R=12 < 14, that STREAM-02 hoc already used 10 posting beats, and that this is not packing-density theatre: **HONEST vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat).

CLOSEOUT MATCH raw: marker present, NEW DUT `dab15d76…`, STREAM-02 `14f75db7…` not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` runtime / no bag shadow, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 13:34:19 PRE before xvlog 13:38:05.

GOLDEN header `wrong_context_policy` still names `qse-v2-stream-intersect-02` — leftover string; live CLASS line names `qse-v2-page-skip-01`. Doc nit, not a law FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Skip fake / packing-only / shrink pages | **MISS.** Independent hoc: skip k0 head max=67 `<` k1 min=103 and k1 head max=136 `<` k0 ovf min=147; header fetched; data AR omitted; skipped IDs disjoint from AND. Without skip, page-format POST_R=14 (not `<` 14). STREAM-02 live hoc is already 10 **without** skip — PAGE-SKIP is not a denser-pack re-label. | Real min/max. Traffic win is vs AXI-BEAT 14, **not** vs STREAM-02 10. |
| 2. NEW RTL is STREAM-02 clone | **MISS.** 777 vs 610 lines; `S_ARHDR`/`can_skip`/`n_page_skip_o` present; STREAM-02 has none of those and was **not compiled**. | Instantiate STREAM-02 as DUT ⇒ FAIL. |
| 3. Late-gold 254 miss hidden by incomp | **MISS.** Raw `LATE_GOLD_HIT id=254` emit `{254}` `incomp=0`; `SEARCH_INCOMPLETE` ABSENT; independent idx 20 and 22; first16∩={}. | Keep miss as FAIL on later bags. |
| 4. C0 lexicon FILE edited / bag shadow | **MISS.** Live `38189974…` mtime 2026-09-05 20:51:03; `QSE2_N_LEX=59`; bag copy ABSENT; xvlog `-i` C0 query first. | DIR-FULL16 61-word shadow was **not** reused. Runtime **is** C0 59-word. |
| 5. xvlog `-i` order wrong | **MISS.** `-i $incq -i $incc -i $bag`; extract binds C0. | Keep C0 first on next bags unless a **named** lexicon law is registered. |
| 6. STREAM-02 DUT edited / compiled | **MISS.** SHA `14f75db7…` MATCH STREAM-02; mtime 11:43:39 **not newer** than N=256 bag; sdb ABSENT. | Hash mismatch ⇒ FAIL, do not patch. |
| 7. C0 dir file patched | **MISS.** Live `09334e42…`; mtime 2026-09-05 19:31:03. git `M` vs HEAD is the historical C0 blob (same as 1250Z). | Do not edit `a7ng_sparse_dir_axi.sv`. |
| 8. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 9. Gold after FAIL / after xvlog | **MISS.** PRE 13:34:19; xvlog 13:38:05; gold still 13:34:19; no r0. | Do not regenerate gold. |
| 10. KEEP bags mutated | **MISS.** DIR-FULL16 GOLDEN **12:44:33** `2f6ab31e…`; STREAM-02 11:43:45; N4096-STREAM-02 12:10:22; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 11. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Head-page skip prose MATCH independent. | Authority = raw CLASS_* + HOC_POST_R + LATE_GOLD_HIT + independent postings. |
| 12. C1 800k / bounds / ACCEPT_BOARD / context | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. Context / 800k / N=16384 dirs ABSENT. | Never grant. Never freeze. Never auto-start 800k. |
| 13. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 29/29 + C0 FILE + STREAM-02 DUT + NEW DUT). | SHA256.txt 13:38:04 is the first-xvlog freeze. |
| 14. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 13:31. | Keep that tree read-only. |
| 15. hoc skip=2 print tautology | **MISS as fact.** TB prints live `n_page_skip_o`; independent skip_walk skip=2 with the same min/max inequalities. GOLDEN `n_skip=2` was hashed **before** xvlog (prediction, then match). | Corpus min/max is the proof, not the `$display`. |
| 16. Direct emit drift | **MISS.** Raw `{110,144,145}` tp=3; independent AND `{110,144,145}`. | Identity control, not Master ≥95%. |
| CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩={} and 254 at 20 and 22). | Same as STREAM-02 N=256 KEEP. |
| Header magic A7A1 unchecked | **HIT as residual.** Host packs it; `S_RHDR` does not compare. | P2. Not a this-bag emit FAIL. |
| GOLDEN `noskip_post` name | **HIT as naming.** Value is STREAM-02 `nbeats` sum (hoc=11), not page-format-without-skip (14). | Do not cite `noskip_post` as the skip delta. |
| CAND_CAP default 64 vs TB 16 | **MISS as this-bag behavior** (TB override 16; banner 16; 16<256). **HIT as reuse caveat.** | Default 64 is not `CAND_CAP_FINAL`. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** Retrieve ARs are the page-skip DUT’s own master. | Do not call idle dir “the merge”. |
| Direct prec=1000 is 3-id identity | **HIT as quality caveat.** PSC labels = k0∩k1. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=256 XSim. | Illegal as BOARD_PASS / 800k / DDR freeze. |
| 12-entity clone (no boiler/header) | **HIT as promotion bound.** Entity ids {1..12}; `N_BUCKETS=4096`. | **REJECT C1 800k.** PLAN bag5 is “min/max page skip bytes”, not 800k-representative. |
| wrong_context still NOT_SELECTIVE | **HIT as law, MISS as overclaim** (labeled). xid still not a key. | Do not fake ctx keys in 800k. |
| Skip is INDEX_HEAD=4 pages, not PAGE_N=16 overflow | **HIT as scale caveat.** Two 1-beat data omissions. Overflow 16-ID pages still fully fetched on hoc. | Still real skip. Do not sell as 16-ID block-max bandwidth. |
| PAGE-SKIP hoc 12 > STREAM-02 hoc 10 | **HIT as quality bound, MISS as overclaim** (implementer stated STREAM-02=10). | Header tax. Registered gate is vs AXI-BEAT 14. |
| TB gold-hit+incomp does not block marker | **HIT as residual vs DIR-FULL16.** Live incomp=0 so not fired. | P2: add `incomp_retrieve==0` to the conjunct. |
| RTL emit-cap can set `q_incomplete_o` | **HIT as residual.** Mixes emit budget with SEARCH_INCOMPLETE. Not fired (`incomp=0`; hoc ∩ n=16). | At later scale: gold miss / incomp on gold_n>=1 must still FAIL. |

qstack-validation-adversary one-liner: **PAGE-SKIP-01 XSim is a real host+new-walker min/max skip lock on unpatched C0 59-word runtime (`38189974…`, no bag lexicon shadow, xvlog `-i` C0 query first): NEW DUT `dab15d76…` fetches a posting header then omits data AR when `hmax < other_lo`; independent hoc lists k0=`[64,65,66,67,147…162]` k1=`[103,114,125,136,147…162,195,215]` skip the two INDEX_HEAD=4 prefix pages (max 67 `<` 103 and max 136 `<` 147) so live `HOC_POST_R_BEATS=12` `PAGE_SKIP=2` `hdr_ar=4` strictly `<` AXI-BEAT 14, while page-format without that skip would be 14 (not `<` 14) and STREAM-02 KEEP already did 10 beats with no skip; CLASS_direct `{110,144,145}` tp=3 skip=0; late-gold nid 254 at k0 index 20 **and** k1 index 22 still emits (`LATE_GOLD_HIT`, first16∩={}, `SEARCH_INCOMPLETE` ABSENT); STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; leftover A09 off; poke_v=0; gold PRE 13:34:19 before xvlog 13:38:05; KEEP DIR-FULL16 / STREAM-02 / N4096-STREAM-02 / AXI-BEAT unmodified; that is not C1 800k, not a DDR/CAND freeze, not ACCEPT_BOARD, not better-than-STREAM-02 traffic, and still a 12-entity / axi_mem_model clone.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted hoc `{147…162}` / direct `{110,144,145}` / late `{254}`). Findings are **law-quality / promotion bounds / TB residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **Page-skip law is a new named walker as claimed, not a STREAM-02 re-label and not packing-only.** Frozen extract unpatched. Relbind keys instantiated not edited. Frozen dir instantiated AXI-idle. Two-pointer compare-and-advance; 1-beat `arlen=0`; header then optional data; `can_skip` omits `S_ARPOST`; CAND_CAP at emit. k2/k3 not probed. leftover A09 off. poke_v=0. STREAM-02 SHA MATCH and not compiled.
2. **hoc skip is a real discriminator vs AXI-BEAT 14.** Independent min/max inequalities; without skip page-format POST_R=14 (gate fail); with skip POST_R=12. Headers-only would fail `HOC_NO_PAGE_SKIP`. Skipped IDs are prefix fillers, not AND hits.
3. **Skip pages this bag are INDEX_HEAD=4, not PAGE_N=16 overflow.** Overflow 16-ID pages are fully fetched on hoc (`n_data=8`). Traffic delta vs AXI-BEAT is two 16-byte data beats. vs STREAM-02 KEEP (10 posting beats, no headers) PAGE-SKIP uses **more** beats. Honest vs registered baseline; not a bandwidth promotion.
4. **Late gold 254 survived skip.** Both-list index ≥16; first16∩={}; emit `{254}` incomp=0. Direct control `{110,144,145}` survived (no skip on that class). Distractor leak_n=0 on a 10-id excluded set. Polarity meter intact.
5. **Runtime lexicon is C0 59-word.** Opposite of DIR-FULL16 bag-first 61-word extension. P2 from 1250Z (named lexicon law id) is **not** re-opened by this bag.
6. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the page-skip DUT master. Same pattern as STREAM-02 / DIR-FULL16.
7. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
8. **CAND_CAP default 64 in RTL source is a future-bag hazard**, not a this-bag cheat (TB 16). Do not freeze 16 as `CAND_CAP_FINAL`.
9. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). Later bags must still FAIL gold_n>=1 + incomp. This TB’s PASS conjunct does not copy DIR-FULL16 `incomp_retrieve==0`.
10. **Frozen keys still omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`.
11. **12-entity clone + 12-bit `N_BUCKETS=4096` + axi_mem_model** is the promotion stop. PLAN bag5 is “min/max page skip bytes” — **closed as PASS_NARROW**. PLAN bags 6–7 (context / semantic 16k→800k) are **not** closed and **not** started by this audit.
12. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
13. **Header magic A7A1 is a host packing tag, not an RTL check.** Walker trusts min/max/nrec field placement. Not an emit bug on this gold image.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start context / 800k / N=16384 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 59-word runtime, leftover off, poke_v=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| NEW DUT skip (`dab15d76…`, `S_ARHDR`/`can_skip`, not STREAM-02 clone, not buf0/buf1) | **PASS_NARROW** | Real header-then-omit. |
| Independent hoc skip: k0 head max=67 `<` k1 min=103; k1 head max=136 `<` k0 ovf min=147; skip=2; without skip POST_R=14 | **PASS_NARROW** | Skip is what makes `< 14`. Not packing-only. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. |
| C0 lexicon **runtime** = `38189974…` 59-word; no bag shadow; xvlog `-i` C0 first | **PASS_NARROW** | Opposite of DIR-FULL16 include-path extension. |
| Registered unknown (CLASS_direct `{110,144,145}` **and** hoc POST_R=12 `<` 14 **and** skip≥1 **and** LATE_GOLD 254 **and** SEARCH_INCOMPLETE ABSENT) | **PASS_NARROW** | Raw CLASS_direct tp=3; `HOC_POST_R_BEATS=12` `PAGE_SKIP=2`; `LATE_GOLD_HIT id=254`; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_PAGE_SKIP_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k. |
| Packing-only / skip-fake | **MISS (not FAIL of this unknown)** | Independent min/max + without-skip POST_R=14. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT. Residual: TB would not block gold-hit+incomp. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; hoc prec_all=62; 12-entity clone; context not in keys; reduction not emitted. |
| C1 800k / context / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 12-entity / 12-bit dir / axi_mem_model. This audit does not start next bags. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 13:34:19; xvlog 13:38:05; gold 13:34:19 KEEP `86b536fb…`; no r0. |
| KEEP DIR-FULL16 + STREAM-02 + N4096-STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT + stream DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1250Z / C0. STREAM-02 GOLDEN **11:43:45**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |
| vs STREAM-02 hoc POST_R=10 | **PASS_NARROW as quality bound** | PAGE-SKIP 12 is not a traffic win vs STREAM-02. Registered gate is AXI-BEAT 14. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=256 `qse-v2-page-skip-01`: real posting-page min/max skip on a new named walker; CLASS_direct `{110,144,145}` remains; hoc `POST_R=12` strictly `<` AXI-BEAT 14 **because** two INDEX_HEAD pages were skipped after their headers; late-gold 254 still emits; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; C0 **runtime** 59-word MATCH; no bag lexicon shadow; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; dir file `09334e42…` unedited; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest; skip is **not** packing-only). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, context-as-closed, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “better than STREAM-02 bytes”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, gold not rewritten, 800k not claimed, walker is not a STREAM-02 clone, skip is real min/max, PASS is honest, late gold both-list, SEARCH_INCOMPLETE absent, STREAM-02 not compiled). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k; packing-theatre hunt fails). **Not** FAIL of the page-skip unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** context **or** semantic corpus restart. Do **not** auto-start 800k / N=16384 / context. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-PAGE-SKIP-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or hoc postB=192.

**P1 — none for this unknown** (independent hoc skip of two INDEX_HEAD pages with min/max inequalities; without skip page-format POST_R=14; with skip POST_R=12 `<` 14; CLASS_direct `{110,144,145}`; LATE_GOLD 254 at k0 index 20 and k1 index 22; SEARCH_INCOMPLETE ABSENT; NEW DUT not a STREAM-02 clone; STREAM-02 SHA MATCH and not compiled; C0 59-word runtime; no bag lexicon; gold PRE before xvlog).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=256 page min/max skip. Authority = raw `HOC_POST_R_BEATS=12` / `PAGE_SKIP=2` / `CLASS_direct {110,144,145}` / `LATE_GOLD_HIT id=254` / `SEARCH_INCOMPLETE` ABSENT + independent postings. Do not silent-patch STREAM-02 / DIR-FULL16.
2. **Do not sell PAGE-SKIP as a traffic win vs STREAM-02.** STREAM-02 KEEP hoc is already 10 posting beats with no headers. PAGE-SKIP hoc is 12 (header tax net of two 4-ID head skips). Registered gate was AXI-BEAT 14. Next skip bag that claims bytes must beat **STREAM-02 live POST_R**, not only AXI-BEAT.
3. **Parent MAY open OPTIONAL next:** `qse-v2-intersect-context-02` **or** a **semantic** corpus restart (not another synthetic 12-entity clone). One unknown each. **Not this audit. Do not start context / 800k from this close.**
4. **Do not auto-start C1 800k / N=16384 / BOARD_PASS.** 12-entity clone + 12-bit dir + `axi_mem_model` are the stop. Semantic ladder 16k→800k is PLAN bag 7, after a frozen stream/skip law **and** after (optional) context — not a clone upsample.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64 is unused this bag; TB 16 is not FINAL. hoc posting is 192 B on `axi_mem_model`. MERGE_POST_AR_MAX=256 was not stressed (max live POST_R=16 on late_gold).
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE`; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; KEY-INTERSECT / STREAM-02 **not** compiled as DUT; frozen sparse not compiled; C0 query `-i` first unless a **named** lexicon law is registered; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; hoc skip=0 FAILs the bag even if POST_R `<` 14.
7. Next bag should instantiate `.CAND_CAP(16)` and `.PAGE_N(16)` explicitly (do not rely on RTL default 64). Copy DIR-FULL16 `incomp_retrieve==0` into the PASS conjunct so gold-hit+incomp cannot emit the marker. If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02.
8. If a later walker must skip **PAGE_N=16 overflow pages** (not only INDEX_HEAD=4 prefixes), that is a **new** unknown / new bag. Do not relabel this N=256 head-page skip as 16-ID block-max bandwidth.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including DIR-FULL16 GOLDEN 12:44:33 (61-word include-path P2 archive), STREAM-02 N=256 nid 254 at 20/22, N4096-STREAM-02 GOLDEN 12:10:22 late-gold 4094, AXI-BEAT hoc POST_R=14 / R_BYTES=256 stay on disk as evidence of prior process.
11. Optional: check header magic `A7A1` in `S_RHDR` or drop it from the host contract. Not a this-bag FAIL. Optional: rename GOLDEN `noskip_post` so the next auditor does not treat STREAM-02 `nbeats` as page-format-without-skip.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=256 qse-v2-page-skip-01 min/max skip;
                         NEW DUT a7ng_query_axi_sparse_page_skip dab15d76…
                           S_ARHDR / can_skip / n_page_skip_o;
                           NOT STREAM-02 clone; NOT KEY-INTERSECT buf0/buf1;
                         STREAM-02 a7ng_query_axi_sparse_stream_intersect 14f75db7…
                           MATCH STREAM-02; mtime 11:43:39 NOT newer than N=256 bag;
                           NOT compiled as DUT;
                         frozen dir FILE 09334e42… mtime 2026-09-05 19:31:03 NOT patched;
                           instantiated AXI-idle (geometry, not walker);
                         C0 lexicon RUNTIME 38189974… QSE2_N_LEX=59
                           xvlog -i C0 query FIRST; bag qse_role_lexicon.svh ABSENT;
                         CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0 skip=0;
                         hoc k0=1538 occ=20 list=[64,65,66,67,147…162]
                             k1=258  occ=22 list=[103,114,125,136,147…162,195,215]
                             AND={147…162};
                         independent SKIP k0 head max=67 < k1 min=103
                                     SKIP k1 head max=136 < k0 ovf min=147;
                         live HOC_POST_R_BEATS=12 AXI_BEAT_BASELINE=14 LT14=1 PAGE_SKIP=2
                           hdr_ar=4 data=8 R_BYTES=224;
                         page-format WITHOUT skip (emit-cap) POST_R=14 (would FAIL <14);
                         STREAM-02 KEEP hoc postB=160 => 10 beats (no skip);
                         LATE_GOLD nid 254 at k0 index 20 AND k1 index 22;
                         first16∩first16 = {}; complete∩ then cap = {254};
                         raw LATE_GOLD_HIT id=254 CAP_THEN_AND_WOULD_MISS stream_hit=1
                           CLASS_late_gold emit={254} tp=1 incomp=0 POST_R=16 skip=2;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold 86b536fb… 13:34:19 PRE before xvlog 13:38:05;
                         KEEP DIR-FULL16 GOLDEN 12:44:33 2f6ab31e…;
                         KEEP STREAM-02 GOLDEN 11:43:45 05c6e087…;
                         KEEP N4096-STREAM-02 GOLDEN 12:10:22 2a2db8c8…;
                         KEEP N4096-INTERSECT GOLDEN 10:46:42 095ca715…;
                         KEEP KEY-INTERSECT d3b5b883… 10:16:50;
                         KEEP AXI-BEAT hoc POST_R=14 R_BYTES=256 max 11:11:09;
                         independent tree UNMODIFIED (≤10:52:29);
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN)
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not context closed,
                            not N=16384, not Master ≥95% recall,
                            not Master ≥90% reduction,
                            not ACCEPT_BOARD, not BOARD_PASS,
                            not better-than-STREAM-02 traffic;
                            12-entity clone + axi_mem_model remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   skip-fake / packing-only hunt MISS; STREAM-02=10 disclosed)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL context keys
                   OR semantic corpus restart
                   (do NOT auto-start C1 800k / N=16384 / context;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
CONTEXT_KEYS     = NOT_STARTED
N_16384          = NOT_STARTED
PAGE_SKIP_XSIM   = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_PAGE_SKIP_XSIM_PASS PRESENT
                   PID 39224; 18185 ns; 13:38:10–13:38:12
                   xsim.log SHA256 29e38918262536b7f03db9ddb77681b8906ce9db1debc6564548ca2d982bc8d9
                   CLASS_direct {110,144,145} tp=3 incomp=0
                   HOC_POST_R_BEATS=12 AXI_BEAT_BASELINE=14 LT14=1 PAGE_SKIP=2
                   LATE_GOLD_HIT id=254 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 13:34:19; PRE MATCH live;
                                no r0; PASS session
DUT_PAGE_SKIP    = NEW          dab15d76… mtime 13:31:29; real min/max skip
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02; NOT compiled
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_DIR_FILE      = UNEDITED     09334e42… mtime 2026-09-05 19:31:03
C0_LEXICON_FILE  = UNEDITED     38189974… mtime 2026-09-05 20:51:03
RUNTIME_LEXICON  = C0_59_WORD   38189974… QSE2_N_LEX=59; xvlog -i C0 FIRST
BAG_LEXICON      = ABSENT
C0_PATCH         = MISS
SKIP_FAKE        = MISS
PACKING_ONLY     = MISS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 4096
PAGE_N           = 16
INDEX_HEAD       = 4
HOC_K0_HEAD      = [64,65,66,67] max=67
HOC_K1_HEAD      = [103,114,125,136] max=136
HOC_SKIP         = 2 (both INDEX_HEAD pages; overflow 16-ID pages fetched)
HOC_WITHOUT_SKIP_POST_R = 14   (emit-cap; independent)
STREAM02_HOC_POST_R     = 10   (KEEP live postB=160)
AXI_BEAT_HOC_POST_R     = 14   (KEEP live)
NID_254_K0_IDX   = 20 (>=16)  EVIDENCE from corpus.json records
NID_254_K1_IDX   = 22 (>=16)
FIRST16_AND_LATE = {}          would miss
STREAM_AND_CAP   = {254}       hits
BOTH_LISTS       = YES
ENTITY_N         = 12 (clone; REJECT 800k)
N                = 256
DIR_FULL16_KEEP  = UNMODIFIED GOLDEN 12:44:33 2f6ab31e41837fd3fd283dab8ef57fea40602bd27719c07e0cd99f619a5eb6f5
STREAM02_N256_KEEP   = UNMODIFIED GOLDEN 11:43:45 05c6e087e567146fc3f8da058370d8bfc5f7a9acfdebc1efaf6659b594f4b86b CLOSEOUT 11:45:37
N4096_STREAM_02_KEEP = UNMODIFIED GOLDEN 12:10:22 2a2db8c8dcb7ac1c9fb322a7d59d407a8892ef087499f96784f71c9f1dd5df06
N4096_INTERSECT_KEEP = UNMODIFIED GOLDEN 10:46:42 095ca7156c1f8efe60d1a2d689f93192271eb79bfb2747f3f12d2b90ea0f9dd3
KEY_INTERSECT_KEEP   = UNMODIFIED d3b5b883… 10:16:50
AXI_BEAT_KEEP        = UNMODIFIED max 11:11:09 hoc POST_R=14 R_BYTES=256
INDEP_TREE           = UNMODIFIED PLAN/EVIDENCE ≤ 10:52:29
LEFTOVER_A09         = not compiled
POKE_V               = 0
SHA256_TXT_MISMATCHES = 0 / 29
```

Never ACCEPT_BOARD. Never close C1 800k. Never start context / 800k / N=16384 in this audit.
