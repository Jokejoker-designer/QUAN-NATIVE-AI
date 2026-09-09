# ASTRA auditor REPORT — 20260907T1250Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-DIR-FULL16-01
LAW        = qse-v2-stream-intersect-02  (SAME named RTL as STREAM-02; instantiate .N_BUCKETS(65536); walker NOT edited)
KEEP       = ASTRA-C1-N4096-STREAM-02 (must be unmodified; GOLDEN 12:10:22 verified)
           + ASTRA-C1-STREAM-INTERSECT-02 N=256 (must be unmodified; GOLDEN 11:43:45 verified)
           + ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; GOLDEN 10:46:42 verified)
           + ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-AXI-BEAT-ACCOUNTING-01 (must be unmodified; verified)
           + R1 / R2 / R3 / KEY-RELBIND (verified)
           + C0 RTL FILE hashes (extract/lexicon FILE/sparse/dir/gate; verified MATCH)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (KEEP; not compiled as DUT)
           + stream DUT a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (instantiate .N_BUCKETS(65536); not edited)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1215Z/REPORT.md
           ACCEPT_PARTIAL (N=4096 STREAM-02 late-gold; P1 none; parent MAY open OPTIONAL dir-full16)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag4 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-DIR-FULL16-01.md
EVIDENCE   = raw xsim.log CLASS_* / FULL16_HIT / FULL16_NO_12BIT_COLLISION /
             ALIAS12_WOULD_COLLIDE / DIR16_AR_HIGH_NIBBLE /
             ASTRA_C1_DIR_FULL16_XSIM_PASS / NOT_SELECTIVE / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + STREAM-02 SHA256.txt + bag qse_role_lexicon.svh
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP bags)
           + DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv (mtime vs N=256 STREAM-02)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash + bucket = k_use[B_W-1:0])
           + TB tb_astra_c1_dir_full16.sv (poke_v, leftover A09, N_BUCKETS, saw_high_key_ar, PASS conjunct)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + C0 vs bag qse_role_lexicon.svh (QSE2_N_LEX 59 vs 61; prefix-59 MATCH)
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_dir_full16.py
           + independent corpus exact-key postings for nid 221 and nid 108 (not RESULTS)
           + independent G_WR_I mem-index (6144 + table*65536 + bucket) vs 4096-stride counterfactual
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
PAGE_SKIP    = NOT STARTED (this audit does not start it)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP N4096-STREAM-02 / STREAM-02 N=256 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start page-skip / context / C1 800k / N=16384, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **16-bit exact-bucket** bag `ASTRA-C1-DIR-FULL16-01` after auditor `20260907T1215Z` ACCEPT_PARTIAL of N=4096 `qse-v2-stream-intersect-02` (P1 none) allowed parent to open OPTIONAL PLAN bag 4.

`results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> Instantiate frozen `a7ng_sparse_dir_axi` with **N_BUCKETS=65536** (parameter, do not patch the `.sv`) + same stream-02 walker (instantiate, do not edit `14f75db7…`) so two facts whose 16-bit keys share bits[11:0] but differ in the high nibble **do not collide**. Query targeting the high-nibble entity must **NOT** emit the 12-bit alias nid. Same queries on a 4096-bucket layout would alias; FULL16 must retrieve the intended nid only. Direct control `{110,144,145}` if those records remain.

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_DIR_FULL16_XSIM_PASS` present.
2. High-nibble query emits intended nid (`FULL16_HIT`) and does **not** emit the 12-bit alias nid (`FULL16_NO_12BIT_COLLISION`); `SEARCH_INCOMPLETE` **ABSENT** on any retrieve class with `gold_n>=1`.
3. CLASS_direct gold hits `{110,144,145}` (records remain).
4. Walker is the frozen STREAM-02 DUT `14f75db7…` instantiated `.N_BUCKETS(65536)` — **not** edited; frozen dir file `09334e42…` **not** patched.
5. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
6. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start page-skip.

PRIMARY HUNT (dispatch; not dropped): bag `qse_role_lexicon.svh` `QSE2_N_LEX=61` boiler=26 header=27 vs C0 59-word `38189974…`. TB include-path **SHADOWS** frozen lexicon. Classify: silent C0 law change vs documented bag-local extension. Check xvlog include_dirs order. If include-path lexicon is a new parser law, required fix = register a new named lexicon law id (do not treat C0 `38189974` as the **runtime** table). Bucket-width unknown may still ACCEPT_PARTIAL if 65536 AR key>=4096 is proven.

This bag **cannot** close C1 800k, cannot promote N=16384, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. Page-skip and context keys remain later bags.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/` (GOLDEN `2a2db8c8…` timestamp **12:10:22**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN `095ca715…` timestamp **10:46:42**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**)
- R1 / R2 / R3 / KEY-RELBIND
- C0 **FILE** hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **instantiate only**)

**Not** this bag: C1 800k close, N=16384 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, threshold drop, `relevant=router_union`, nid-derived keys, context keys, page-skip, loading full posting into BRAM, patching KEEP bags, editing stream RTL, editing `a7ng_sparse_dir_axi.sv`.

Hunt (dispatch, none dropped):

1. C0 lexicon **file** edited (`38189974` drift)
2. Include-path lexicon is a **silent** C0 parser-law change (vs documented bag-local extension)
3. xvlog include_dirs does **not** actually put bag first (C0 59-word compiled; boiler unknown)
4. `N_BUCKETS` still 4096 in elab (banner-only 65536)
5. Alias pair not actually 12-bit collide (`0x1A01` vs `0x0A01` do not share `[11:0]`)
6. High query hits because 12-bit slot was the only plant (no distinct 16-bit bucket write)
7. `DIR16_AR_HIGH_NIBBLE` print tautology (not a live table-0 AR with key>=4096)
8. `ALIAS12_WOULD_COLLIDE` print-only tautology (gold bit, not corpus)
9. Stream DUT edited (hash ≠ `14f75db7…`, or mtime newer than N=256 STREAM-02)
10. Frozen dir `.sv` patched (`09334e42` drift)
11. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
12. Gold hashed after first xvlog / rewritten after FAIL
13. KEEP bags rewritten
14. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
15. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / page-skip started
16. Hash theatre (SHA256.txt vs live Get-FileHash)
17. Independent audit tree written by this implementer
18. Marker-only PASS with incomp / 12-bit collision emit swallowed

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **16-bit exact-bucket** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** `ASTRA-C1-PAGE-SKIP-01` / context keys **or** semantic corpus restart. Do **not** auto-start C1 800k / N=16384 / PAGE-SKIP from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. DIR-FULL16 bag is untracked (`??`). KEEP KEY-INTERSECT / N4096-INTERSECT / STREAM-02 / N4096-STREAM-02 / AXI-BEAT remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…`. KEEP intersect DUT remains untracked with **unchanged** hash `a912786f…`. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1215Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T12:50:00+07:00` `acceptance=PENDING_AUDITOR_C1_DIR_FULL16` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), DIR-FULL16 bag:

```text
12:36:52.304  ACK.json
12:37:35.672  PREREG.md
12:40:58.515  host_astra_c1_dir_full16.py
12:43:26.853  tb_astra_c1_dir_full16.sv
12:44:27.395  run_xsim.ps1
12:44:32.961  qse_role_lexicon.svh          ← bag include-path copy (boiler=26 header=27)
12:44:33.445  corpus.json
12:44:33.447  GOLDEN.json
12:44:33.449  query_gold.svh
12:44:33.450  GOLD_HASH_PRE_XVLOG.txt      ← gold hash BEFORE first xvlog
12:44:46.634  SHA256.txt                   ← freeze immediately before first xvlog
12:44:47.888  xvlog.log
12:44:50.907  xelab.log
12:44:55.087  xsim.log                     PID 59148; session 12:44:51–12:44:55
12:46:27.722  RESULTS.md
12:46:50.888  CLOSEOUT.md
```

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag (GOLDEN 11:43:45 / CLOSEOUT 11:45:37). This bag starts 12:36. DUT was not rewritten for FULL16.

Frozen dir LastWriteTime **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. `role_lexicon.py` **2026-09-05 20:49:59.239** (host mutates in-process `LEX.append` only; did **not** write that file).

Single XSim session. No second xvlog. Gold files were **not** rewritten between 12:44:33 and 12:46:50 (hash MATCH PRE; LastWriteTime still 12:44:33). `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `55b5e527744af5dc0520ea20305bf8ae11b805b1b1cb641eb3cbd4932de9cc17` MATCH RESULTS `XSIM_SHA`.

Page-skip bag path **ABSENT**. N=16384 bag paths **ABSENT**.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / STREAM-02 DUT / bag lexicon

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  rtl/.../qse_role_lexicon.svh        (C0 FILE MATCH; mtime 2026-09-05 20:51:03)
                                                                 **NOT the compiled runtime table**
308cfbdf3a5e0e821115f56792f75df7f5b3ed76c3b8460c202a40a2b1ef9e7a  bag qse_role_lexicon.svh            (runtime include; QSE2_N_LEX=61)
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (mtime 09:43:58)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv
                                                                  (STREAM-02 MATCH; mtime 11:43:39; NOT edited this bag)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
d235d7d324b84db91ca667cb26bf2f67469767c24adf6234223b534354def486  tb_astra_c1_dir_full16.sv
```

STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. N4096-STREAM-02 `SHA256.txt` lists the same blob. Live MATCH.

`GOLD_HASH_PRE_XVLOG.txt` mtime **12:44:33.450** vs live gold (all MATCH):

```text
2f6ab31e41837fd3fd283dab8ef57fea40602bd27719c07e0cd99f619a5eb6f5  GOLDEN.json
89a463150d67d86aae9049adff8ba9900605fede880522f274c448724838e3ba  query_gold.svh
afc0f56c828ff243113410bb98cfb2b25d58c40fd0cbd12a99bc6d0ff6b0ab08  corpus.json
```

`xvlog.log` mtime **12:44:47.888**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 12:44:33). SHA256.txt freeze stamp `2026-09-07T12:44:46.5776979+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **0 mismatches** on C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple, **and** bag lexicon `308cfbdf…`. No invented hash. SHA256.txt also lists C0 lexicon under `TRANSITIVE_INCLUDES` **and** the bag copy under `TB_INCLUDE_PATH_LEXICON_EXTENSION` — both hashes are real; only the bag copy is the compiled table (see §5).

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 12:36+ |
|---|---|---|---|
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |
| R1 | GOLDEN **08:31:44** | CLOSEOUT **08:37:00.181** | **UNMODIFIED** |
| R2 | GOLDEN **08:59:20** | RESULTS **09:01:39.446** | **UNMODIFIED** |
| R3 | GOLDEN **09:24:14** | CLOSEOUT **09:26:23.833** | **UNMODIFIED** |
| KEY-RELBIND | GOLDEN **09:48:35** | CLOSEOUT **09:51:03.157** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** DIR-FULL16 implementer did **not** write that tree. This auditor did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / KEY-INTERSECT not DUT / include_dirs

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_stream_intersect.sv
tb_astra_c1_dir_full16.sv
```

`xelab.log` compiled the same modules. Work `*.sdb`: extract, relbind keys, gate, dir, mem model, **stream_intersect**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_relbind`.

`xelab.log` line is truncated: `a7ng_sparse_dir_axi(N_BUCKETS=32...` and `a7ng_axi_mem_model(DEPTH_WORDS=3...`. That line **alone** cannot distinguish `32'd65536` from `32'd4096`. Independent proof of 65536 is in §7–§8 (live table-0 AR key>=4096 + G_WR_I table stride 65536). Hunt “elab still 4096”: **MISS** as fact; **HIT** as log-truncation caveat.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1` after that). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + relbind `93811ed1…`; throws if leftover / frozen sparse / KEY-INTERSECT / relbind-sparse on xvlog list; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / missing FULL16_HIT / `FAIL ALIAS_12BIT_COLLISION_EMIT` / DISTRACTOR_LEAK / SEARCH_INCOMPLETE / diverge. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` line 166, the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` = `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01` **first**. `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) **second**. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag** copy. Comment in the same file: “Bag include path FIRST so extract sees boiler/header extension; C0 lexicon FILE remains unedited.”

TB instantiates `.N_BUCKETS(G_N_BUCKETS)` with `G_N_BUCKETS = 65536` from `query_gold.svh`. Banner `N_BUCKETS=65536`. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `CAND_CAP = G_CAND_CAP = 16`. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<256). `MEM_DEPTH=272384` TB-only (`G_MEM_DEPTH`). `.MERGE_POST_AR_MAX(256)`.

PASS marker conjunct (TB lines 577–579): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0) && alias_high_hit && alias_no_low && alias_low_ok && alias_no_high && alias_ar_high && (incomp_retrieve == 0)`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `SEARCH_INCOMPLETE` on `gold_n>=1` sets `incomp_retrieve=1` and **blocks the PASS marker**. Collision emit of nid 108 on the high query prints `FAIL ALIAS_12BIT_COLLISION_EMIT` and blocks the marker. Hunt “marker-only PASS with incomp / swallowed collision”: **MISS** this bag (no `SEARCH_INCOMPLETE` line; no `incomp=1`; no `FAIL `; marker present).

### 5) PRIMARY HUNT — include-path lexicon vs C0 FILE `38189974…`

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
boiler/header tokens ABSENT
```

Bag copy `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 61
hash       = 308cfbdf3a5e0e821115f56792f75df7f5b3ed76c3b8460c202a40a2b1ef9e7a
mtime      = 2026-09-07 12:44:32.961
header comment: frozen 59-word table plus boiler id=26 and header id=27
               (12-bit aliases of pump=10 and valve=11). Old ids 1..12 unchanged.
last two QSE2_ID   = 8'd26, 8'd27
last two QSE2_WORD = 96'h...72656c696f62 ("boiler" LSB-first), 96'h...726564616568 ("header")
prefix-59 of CLS/ID/LEN/WORD  == C0 FILE arrays  (independent string compare: MATCH)
```

**Classification: documented bag-local extension, not a silent C0 FILE patch.**

CONFIRMED documentation (before xvlog): PREREG §“TB include-path entity extension”, ACK `write_scope` / `EXTRACT_LAW_FROZEN`, `run_xsim.ps1` include order + SHA256.txt `# TB_INCLUDE_PATH_LEXICON_EXTENSION`, bag file header, host docstring (`LEX.append` in-process; “Does not write role_lexicon.py or C0 qse_role_lexicon.svh”). `role_lexicon.py` mtime **2026-09-05 20:49:59** UNMODIFIED.

**Runtime table is NOT C0 `38189974…`.** Frozen extract IDs 1..12 never set key bits[15:12]. Without the 61-word table, query `"boiler supplies header"` cannot produce `subj=26` / `k0=0x1A01`. Live extract produced `FULL16_HIT id=221 k0=6657 k1=6913` with no `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. Independent `G_BYTES[11]` LSB-first decodes to `"boiler supplies header"` (len=22 MATCH `G_LEN[11]`); `G_SUBJ[11]=26` `G_OBJ[11]=27` `G_K0[11]=16'h1A01` `G_K1[11]=16'h1B01`.

This **is** a new parser table (two extra entity tokens / ids 26 and 27). GOLDEN still labels `extract_law_frozen: qse-v2-role-00`. That label is honest about the **extract RTL file** (`cd7baf49…` unpatched) and **not** honest if read as “the compiled lexicon blob is C0 `38189974…`”. Required fix (P2, not this-unknown FAIL): **register a new named lexicon law id** and hash-gate `308cfbdf…` as that law’s table. Keep citing `38189974…` only as the C0 **FILE** freeze.

Hunt “C0 lexicon file edited”: **MISS.** Hunt “silent C0 law change”: **MISS as file patch; HIT as unnamed runtime table.** Hunt “include_dirs did not shadow”: **MISS** (bag first; boiler parsed).

### 6) Stream RTL freeze / dir geometry (hunts DUT-edit / 4096 elab)

KEEP KEY-INTERSECT DUT `a7ng_query_axi_sparse_intersect.sv` (NOT compiled this bag) still has `buf0`/`buf1` collect-to-cap then AND. Unchanged hash `a912786f…` mtime **10:13:02**.

Live DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**:

- Instantiates frozen extract → relbind keys (not edited) → frozen `a7ng_route_valid_gate`.
- Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle (`q_v=0`, k*_valid=0; hash-gate geometry; **not** the merge walker). Parameter `.N_BUCKETS(N_BUCKETS)` is forwarded.
- Own AXI master: posting AR `arlen=0` (1-beat page, 4 IDs). No `buf0`/`buf1`.
- Directory address (the retrieve path that actually ARs):

```text
B_W = $clog2(N_BUCKETS)     // 16 when N_BUCKETS=65536; 12 when 4096
dir_addr0 = INDEX_BASE + (k0_r[B_W-1:0] * 16)
dir_addr1 = INDEX_BASE + TABLE_BYTES + (k1_r[B_W-1:0] * 16)
TABLE_BYTES = N_BUCKETS * 16
```

Frozen dir file (unpatched) uses the same bucket law: `bucket = k_use[B_W-1:0]`. Default parameter `N_BUCKETS=4096` remains in the `.sv`; TB/DUT **instantiate** 65536. Do not treat the default as the elaborated value.

Hunt “DUT edited this bag”: **MISS.** Hunt “dir file patched”: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 12:44:51 2026**; exit **12:44:55**; PID **59148**; `$finish` at **19325 ns**.

Banner:

```text
C1_DIR_FULL16_N=256 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-stream-intersect-02 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=272384
```

Named lines (verbatim authority):

```text
CLASS_direct gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=8 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
EMIT_direct n=3
  CAND direct i=0 id=110 ev=1
  CAND direct i=1 id=144 ev=1
  CAND direct i=2 id=145 ev=1
CLASS_paraphrase … emit {110,144,145} incomp=0
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 id=146 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=114 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct … keys_match=1 emit_match=1 law=qse-v2-stream-intersect-02 xid_not_directory_key
CLASS_wrong_context gold_n=1 emit_n=3 tp=1 fp_ev1=2 prec_all_x1000=333 rec_x1000=1000 incomp=0
CLASS_distractor gold_n=10 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {110,144,145}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 incomp=0
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=167 ovf=1 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=255 incomp=0
CLASS_late_gold gold_n=1 emit_n=1 tp=1 id=254 incomp=0
FULL16_HIT id=221 k0=6657 k1=6913
FULL16_NO_12BIT_COLLISION low_alias_id=108 excluded_from_high_emit=1
ALIAS12_WOULD_COLLIDE k0_high=6657 k0_low=2561 share12=2561 low_id=108 high_id=221
DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1
CLASS_alias_high gold_n=1 emit_n=1 tp=1 prec_all_x1000=1000 rec_x1000=1000 occ=1 ovf=0 trunc=0 dirB=32 postB=32 discB=0 descB=0 incomp=0
EMIT_alias_high n=1
  CAND alias_high i=0 id=221 ev=1
CLASS_alias_low gold_n=1 emit_n=1 tp=1 prec_all_x1000=1000 rec_x1000=1000 occ=7 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
EMIT_alias_low n=1
  CAND alias_low i=0 id=108 ev=1
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_DIR_FULL16_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384,PAGE_SKIP,CONTEXT_KEYS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `FULL16_HIT=1`; `FULL16_NO_12BIT_COLLISION=1`; `ALIAS12_WOULD_COLLIDE=1`; `DIR16_AR_HIGH_NIBBLE=1`; `ASTRA_C1_DIR_FULL16_XSIM_PASS=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` = **0**; `FIRST_DIVERGENCE` = **0**; `incomp=1` = **0**. `incomp=0` on `CLASS_alias_high`, `CLASS_alias_low`, and `CLASS_direct`.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. WO: presence would be FAIL. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS.**

`DIR16_AR_HIGH_NIBBLE` is **not** a gold-bit print. TB `observe_walk` on the high query:

```text
if (arvalid && arready)
  if (araddr in [DIR_LO, DIR_HI] && araddr < DIR_LO+0x100000)  // table 0 only (1 MiB = 65536*16)
    dir_key0 = (araddr - DIR_LO) >> 4
    if (dir_key0 >= 4096) saw_high_key_ar = 1
```

`DIR_LO = 28'h05000000` = `NG_DDR_INDEX_BASE`. For `k0=0x1A01=6657` and `B_W=16`: `dir_addr0 = 0x05000000 + 6657*16 = 0x0501A010`; `dir_key0 = 6657 >= 4096`. If `N_BUCKETS` were still 4096, `B_W=12`, `dir_addr0` would use `k0[11:0]=2561`, `dir_key0=2561 < 4096`, TB would print `FAIL ALIAS_HIGH_NO_HIGH_NIBBLE_AR` and **block the PASS marker**. Live printed `DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1`. **65536 bucket index used the full 16 bits on the wire.**

`ALIAS12_WOULD_COLLIDE` **is** gated on gold bit `G_ALIAS12_WOULD_COLLIDE[11]=1` (print tautology). Independent corpus in §8 proves the bit is true.

### 8) Independent corpus — k0 `0x1A01` vs `0x0A01` share `[11:0]`; 65536 must not collide

Authority = live `corpus.json` records (hash `afc0f56c…`), **not** the JSON header fields and **not** RESULTS.

Packing: `k0==(subj<<8)|rel`, `k1==(obj<<8)|rel` on all 256 records: **0** failures. `k_eq_nid=0`. Hunt nid-derived keys: **MISS.**

```text
unique entity ids = {1..12, 26, 27} n=14
names             = C0 HVAC 1..12 plus boiler=26 header=27
unique rel ids    = {1,2,3}
unique ctx ids    = {0,1,2}
n records         = 256 (nid 0..255)
kinds             = block_a 144 / fill 53 / late fills 32 / high_occ_synth 15 / alias_high 1 / …
evidence=1        = 205
```

Record 221 (high):

```text
nid=221 text="boiler supplies header" evidence=1 kind=alias_high
subj=26 rel=1 obj=27 ctx=0  k0=6657=0x1A01  k1=6913=0x1B01
```

Record 108 (low alias):

```text
nid=108 text="pump supplies valve" evidence=1 kind=block_a
subj=10 rel=1 obj=11 ctx=0  k0=2561=0x0A01  k1=2817=0x0B01
```

```text
k0 share bits[11:0] = 0x0A01 = 2561   (equal)
k1 share bits[11:0] = 0x0B01 = 2817   (equal)
k0 16-bit differ    YES  delta=4096   high nibble 0x1 vs 0x0
k1 16-bit differ    YES  delta=4096

FULL16 k0=6657 occ=1 ; k1=6913 occ=1 ; AND = {221}     (108 ABSENT)
12-bit  k0&0xFFF=2561 occ=7 ; k1&0xFFF=2817 occ=8 ; AND = {108, 221}
LOW FULL16 k0=2561 occ=6 ; k1=2817 occ=7 ; AND = {108} (221 ABSENT)
direct PSC ev1 k0=2561 k1=257 AND labels {110,144,145}
```

**FACT:** `0x1A01` and `0x0A01` **do** collide on 12 bits. A 4096-bucket index (`key[11:0]`) **would** AND-merge `{108,221}`. A 65536-bucket index (`key[15:0]`) **must not**. Live high emit `{221}` only; live low emit `{108}` only. Hunt “alias pair not actually 12-bit collide”: **MISS.**

Independent `G_BYTES` LSB-first (char0 at bits[7:0]):

```text
q0  "pump supplies chiller"     k0=0x0A01  (control)
q11 "boiler supplies header"    k0=0x1A01  (unknown)
q12 "pump supplies valve"       k0=0x0A01  (low alias)
```

Direct control records 110/144/145 remain PSC (`pump supplies chiller` / water / indirectly). MATCH raw `EMIT_direct`. Distractor excluded set includes nid 108 (polarity meter); `leak_n=0` emit `{110,144,145}` — 108 is **not** a k0∩k1 hit of the direct query (different k1). Polarity intact.

### 9) Independent G_WR_I — both 12-bit and 16-bit slots planted; table stride 65536

`a7ng_axi_mem_model` remaps INDEX region: `word = 6144 + ((araddr - INDEX_BASE) >> 4)`. Host `word_of` matches. So mem index = `6144 + table*N_BUCKETS + bucket`.

Live `G_WR_I` (438 unique writes):

```text
t0 bucket 257  (0x0101 chiller rel1)     word 6401   PRESENT
t0 bucket 2561 (0x0A01 pump rel1)        word 8705   PRESENT
t0 bucket 6657 (0x1A01 boiler rel1)      word 12801  PRESENT
t1 bucket 2817 (0x0B01 valve rel1)       word 74497  PRESENT
t1 bucket 6913 (0x1B01 header rel1)      word 78593  PRESENT
t1 bucket 257                             word 71937  PRESENT
(t1-t0) for bucket 257                    65536
counterfactual t1@N_BUCKETS=4096 b257     word 10497  ABSENT
```

**FACT:** high-nibble buckets **and** their 12-bit aliases are **both** planted as distinct directory words. High retrieve cannot be “the 12-bit slot was the only plant.” Table stride between t0 and t1 is **65536 words**, not 4096. Hunt “N_BUCKETS still 4096 in the index image”: **MISS.**

`G_DIR_HI=28'h053FFFF0` ⇒ directory span `0x400000 = 4*65536*16` bytes. `G_POST_HEAP=28'h05400000`. `G_MEM_DEPTH=272384 = 6144 + 4*65536 + 4096`. MATCH the mem-model remap + 16-bit tables.

CLASS_alias_high `occ=1 dirB=32 postB=32` MATCH singleton FULL16 lists (2 dir AR + 2 one-beat post AR). A 12-bit merge of occ 7+8 would not be `occ=1 postB=32 emit_n=1`.

### 10) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {110,144,145}` tp=3 incomp=0; `FULL16_HIT id=221 k0=6657`; `FULL16_NO_12BIT_COLLISION low_alias 108`; `ALIAS12_WOULD_COLLIDE share12=2561`; `DIR16_AR_HIGH_NIBBLE`; alias_low `{108}`; distractor `leak_n=0 gold_n=10`; unrelated empty-walk; wrong_context `NOT_SELECTIVE`). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, PAGE_SKIP, CONTEXT_KEYS.

CLOSEOUT MATCH raw: marker present, DUT `14f75db7…` mtime 11:43:39 not edited, KEEP intersect `a912786f…` not DUT, leftover not compiled, poke_v=0, C0 lexicon **FILE** `38189974…` unedited, bag include-path copy adds boiler=26 header=27, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`.

Implementer prose that FULL16 retrieves nid 221 for `"boiler supplies header"` and does not emit 12-bit alias 108, while direct still `{110,144,145}`: **HONEST vs raw and vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat).

Caveat on RESULTS/CLOSEOUT/GOLDEN `extract_law_frozen = qse-v2-role-00` plus “C0 hashes MATCH `38189974`”: honest as **FILE** freeze; **do not** read it as “runtime lexicon blob is C0 59-word.” They also wrote the include-path extension in the same documents. Law-id gap, not a hidden 800k claim.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. C0 lexicon FILE edited | **MISS.** Live `38189974…`; mtime 2026-09-05 20:51:03. `role_lexicon.py` 2026-09-05 20:49:59. | FILE freeze holds. |
| 2. Include-path silent C0 law change | **MISS as silent FILE patch. HIT as unnamed runtime table.** Bag `308cfbdf…` `QSE2_N_LEX=61` boiler=26 header=27; prefix-59 MATCH C0; xvlog `-i $bag` first. Documented in PREREG/ACK/SHA256/run_xsim/host. | **P2:** register a new named lexicon law id. Do **not** treat `38189974` as the compiled table. Not a FAIL of the bucket unknown. |
| 3. xvlog did not shadow (C0 59-word compiled) | **MISS.** Live extract emitted k0=6657 for `"boiler supplies header"`; no ROLE_COLLAPSE. | C0 59-word cannot parse `boiler`. |
| 4. N_BUCKETS still 4096 in elab | **MISS as fact.** `DIR16_AR` dir_key0>=4096; G_WR_I t1−t0=65536; counterfactual 10497 ABSENT; TB `.N_BUCKETS(65536)`; MEM_DEPTH=272384; DIR span 4 MiB. **HIT as xelab.log truncation** (`N_BUCKETS=32...`). | Do not treat the truncated elab line as the proof; the AR + WR_I are the proof. |
| 5. Alias pair not 12-bit collide | **MISS.** Independent `0x1A01`/`0x0A01` share `[11:0]=2561`; delta=4096; 12-bit AND=`{108,221}`. | 65536 must use full 16 bits. |
| 6. High hit is 12-bit-slot-only plant | **MISS.** t0 b2561 word 8705 **and** t0 b6657 word 12801 both PRESENT; t1 b2817 and t1 b6913 both PRESENT. | Distinct 16-bit buckets. |
| 7. DIR16_AR print tautology | **MISS.** Computed from live `arvalid&&arready` table-0 address. Would FAIL the bag if dir_key0<4096. | This is the 65536-on-the-wire lock. |
| 8. ALIAS12_WOULD_COLLIDE print tautology | **HIT as print path** (TB prints because `G_ALIAS12_WOULD_COLLIDE[11]=1`). **MISS as fact** (independent 12-bit AND=`{108,221}`). | Corpus postings are the proof, not the `$display`. |
| 9. Stream DUT edited | **MISS.** SHA `14f75db7…` MATCH STREAM-02 / N4096-STREAM-02; mtime 11:43:39 **not newer** than N=256 bag 11:45:37. | Instantiate only. Hash mismatch ⇒ FAIL, do not patch. |
| 10. C0 dir file patched | **MISS.** Live `09334e42…`; mtime 2026-09-05 19:31:03. git `M` vs HEAD is the historical C0 blob (same as 1215Z). | Do not edit `a7ng_sparse_dir_axi.sv`. |
| 11. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 12. Gold after FAIL / after xvlog | **MISS.** PRE 12:44:33; xvlog 12:44:47; gold still 12:44:33; no r0. | Do not regenerate gold. |
| 13. KEEP bags mutated | **MISS.** N4096-STREAM-02 GOLDEN **12:10:22** `2a2db8c8…`; STREAM-02 11:43:45; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 14. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. | Authority = raw FULL16_* + DIR16_AR + independent postings. |
| 15. C1 800k / bounds / ACCEPT_BOARD / page-skip | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. PAGE-SKIP dir **ABSENT**. | Never grant. Never freeze. Never auto-start 800k / PAGE-SKIP. |
| 16. Hash theatre | **MISS** on listed gold/RTL/bag-lexicon paths (live MATCH PRE + SHA256.txt + C0 FILE + STREAM-02 DUT). | SHA256.txt 12:44:46 is the first-xvlog freeze. |
| 17. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 12:36. | Keep that tree read-only. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** Retrieve ARs are the stream DUT’s own master using `B_W=$clog2(N_BUCKETS)`. | Do not call idle dir “the merge”. |
| Direct prec=1000 is 3-id identity | **HIT as quality caveat.** PSC labels = k0∩k1. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=256 XSim with 4 MiB dir image. | Illegal as BOARD_PASS / 800k / DDR freeze. |
| 14-entity clone (12+boiler+header) | **HIT as promotion bound.** N=256; pad/fill majority; ids {1..12,26,27}. | **REJECT C1 800k.** Not a FAIL of the bucket unknown. PLAN bag4 is “16-bit exact bucket”, not 800k-representative. |
| wrong_context still NOT_SELECTIVE | **HIT as law, MISS as overclaim** (labeled). xid still not a key. | Do not fake ctx keys in page-skip/800k. |
| CAND_CAP default 64 vs TB 16 | **MISS as this-bag behavior** (TB override 16; banner 16; 16<256). **HIT as reuse caveat.** | Default 64 is not `CAND_CAP_FINAL`. |
| GOLDEN `extract_law_frozen=qse-v2-role-00` vs runtime 61-word | **HIT as law-id gap.** Extract **RTL** is frozen; compiled **table** is bag `308cfbdf…`. | Required fix = named lexicon law id. Not 800k. |
| Occupancy of alias_high is 1 | **HIT as scale caveat** (singleton lists). The discriminator is collision avoidance, not occupancy. | MERGE_POST_AR_MAX=256 not stressed. |

qstack-validation-adversary one-liner: **DIR-FULL16 XSim is a real 16-bit exact-bucket lock on unpatched C0 FILE hashes: frozen walker `14f75db7…` (mtime 11:43:39, not newer than STREAM-02) instantiated `.N_BUCKETS(65536)` so `B_W=16` and `dir_addr0=INDEX_BASE+k0[15:0]*16`; live table-0 AR produced `DIR16_AR_HIGH_NIBBLE` (dir_key0>=4096) which a 4096-bucket elab cannot print; independent corpus puts nid 221 at k0=`0x1A01` and nid 108 at k0=`0x0A01` sharing `[11:0]=2561` so 12-bit AND=`{108,221}` while FULL16 AND=`{221}`; raw `FULL16_HIT id=221 k0=6657` `FULL16_NO_12BIT_COLLISION low_alias_id=108` `CLASS_direct {110,144,145}` tp=3; G_WR_I plants **both** word 8705 (bucket 2561) and word 12801 (bucket 6657) with table stride 65536; leftover A09 off; poke_v=0; gold PRE 12:44:33 before xvlog 12:44:47; KEEP N4096-STREAM-02 GOLDEN 12:10:22 unedited; runtime lexicon is bag `308cfbdf…` QSE2_N_LEX=61 (documented include-path extension, C0 FILE `38189974…` unedited) — that is not C1 800k, not PAGE-SKIP, not a DDR/CAND freeze, not ACCEPT_BOARD, and still a 14-entity / axi_mem_model clone.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted alias_high `{221}` / alias_low `{108}` / direct `{110,144,145}`). Findings are **law-quality / promotion bounds / parser-law-id**, not “patch frozen QSE RTL” and not “fix TB packing”:

1. **16-bit bucket law is instantiated as claimed, not rewritten.** Frozen extract unpatched. Relbind keys instantiated not edited. Frozen dir **file** unpatched, instantiated AXI-idle at `N_BUCKETS=65536`. Walker uses `k[B_W-1:0]` with `B_W=16`. leftover A09 off. poke_v=0. SHA MATCH STREAM-02.
2. **Alias pair is a real 12-bit discriminator, not a one-sided plant.** Independent postings: share `[11:0]`, delta 4096; 12-bit AND=`{108,221}`; FULL16 AND high=`{221}`; FULL16 AND low=`{108}`; both directory slots planted; live emit matches.
3. **DIR16_AR is a live AXI measurement**, not a gold-bit `$display`. A 4096-bucket walker cannot produce dir_key0>=4096 on table 0. PASS marker requires `alias_ar_high`.
4. **Direct control survived the corpus rebuild.** `{110,144,145}` still PSC and still k0∩k1. Distractor leak_n=0 on a 10-id excluded set (includes 108 as excluded-for-direct, not as a leak). Polarity meter intact.
5. **Include-path lexicon is a documented instrument, not a silent C0 FILE edit.** It **is** a new runtime parser table (ids 26/27) and needs a **named law id**. Without it, bits[15:12] stay 0 and FULL16 is observationally identical to 12-bit — the unknown would be untestable on frozen extract 1..12.
6. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the stream DUT master. Same pattern as STREAM-02 / N4096-STREAM-02.
7. **Index is `axi_mem_model` with INDEX remap base 6144, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
8. **CAND_CAP default 64 in RTL source is a future-bag hazard**, not a this-bag cheat (TB 16). Do not freeze 16 as `CAND_CAP_FINAL`.
9. **Frozen keys still omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`.
10. **14-entity clone + axi_mem_model 4 MiB dir image** is the promotion stop. PLAN bag4 is “16-bit exact bucket” — **closed**. PLAN bags 5–7 (page-skip / context / semantic 16k→800k) are **not** closed and **not** started by this audit.
11. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
12. **xelab.log truncates `N_BUCKETS=32...`.** Do not cite that line as 65536; cite DIR16_AR + WR_I stride.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start page-skip / 800k / context in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 FILE hashes, leftover off, poke_v=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| Stream DUT freeze (`14f75db7…`, mtime 11:43:39 not newer than N=256 stream bag, instantiate `.N_BUCKETS(65536)`) | **PASS_NARROW** | Instantiate only. Not rewritten. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | Parameter instantiate. Default 4096 remains in source. |
| Independent k0 `0x1A01` vs `0x0A01` share `[11:0]`; 12-bit AND=`{108,221}`; FULL16 AND=`{221}` | **PASS_NARROW** | Real 12-bit alias pair. |
| Live `DIR16_AR_HIGH_NIBBLE` (table-0 AR key>=4096) | **PASS_NARROW** | Proves elaborated `B_W=16` / `N_BUCKETS=65536` on the wire. |
| Registered unknown (`FULL16_HIT id=221` **and** nid 108 absent **and** CLASS_direct `{110,144,145}` **and** SEARCH_INCOMPLETE ABSENT) | **PASS_NARROW** | Raw FULL16_* + DIR16_AR + direct tp=3; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_DIR_FULL16_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k. |
| Runtime lexicon = C0 `38189974…` 59-word | **FAIL as runtime-table claim** | Compiled table is bag `308cfbdf…` N_LEX=61. FILE freeze still MATCH. |
| Include-path lexicon as silent C0 patch | **MISS (documented extension)** | PREREG/ACK/SHA256/run_xsim. P2 law-id, not P1 FAIL. |
| Marker-only PASS with incomp / collision swallow | **MISS (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; no FAIL ALIAS_12BIT_COLLISION_EMIT; TB would have blocked. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; hoc prec_all=62; 14-entity clone; context not in keys; reduction not emitted. |
| C1 800k / PAGE-SKIP / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 14-entity / axi_mem_model. This audit does not start next bags. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 12:44:33; xvlog 12:44:47; gold 12:44:33 KEEP `2f6ab31e…`; no r0. |
| KEEP N4096-STREAM-02 + STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1215Z / C0. N4096-STREAM-02 GOLDEN **12:10:22**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N_BUCKETS=65536 instantiate of frozen dir + frozen stream-02 walker: 12-bit-alias pair retrieves intended nid only; `DIR16_AR` key>=4096; CLASS_direct `{110,144,145}` remains; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; C0 **FILE** MATCH; gold-before-xvlog; DUT `14f75db7…` unedited; dir file `09334e42…` unedited; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest; runtime lexicon is a **documented** bag-local 61-word extension, not a silent C0 FILE patch). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, PAGE-SKIP-as-closed, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS. **Not** FAIL_LOOP (hashes real, C0 files unpatched, gold not rewritten, 800k not claimed, walker is not cap-then-AND relabeled, PASS is honest, alias pair is real 12-bit collide, SEARCH_INCOMPLETE absent, DUT not edited, 65536 proven on the wire). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k; lexicon extension is documented). **Not** FAIL of the bucket-width unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** page-skip / context **or** semantic corpus restart. Do **not** auto-start 800k / N=16384 / PAGE-SKIP. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-DIR-FULL16-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or alias_high postB=32.

**P1 — none for this unknown** (independent `0x1A01`/`0x0A01` share `[11:0]`; 12-bit AND=`{108,221}`; FULL16 AND=`{221}`; live `FULL16_HIT id=221 k0=6657` and nid 108 excluded; `DIR16_AR` key>=4096; CLASS_direct `{110,144,145}`; SEARCH_INCOMPLETE ABSENT; DUT SHA MATCH STREAM-02 and mtime not newer than N=256 bag; dir FILE unpatched; C0 lexicon FILE unpatched).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Register a new named lexicon law id** for the bag include-path table (`308cfbdf…`, `QSE2_N_LEX=61`, boiler=26, header=27). Do **not** treat C0 `38189974…` as the runtime table. Keep the C0 FILE hash-gate as the **unedited file** freeze. Next bags that need bits[15:12]≠0 must name this table (or a successor), not silently `-i` shadow C0.
2. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of 16-bit exact-bucket instantiate. Authority = raw `FULL16_HIT` / `FULL16_NO_12BIT_COLLISION` / `DIR16_AR_HIGH_NIBBLE` / `CLASS_direct` + independent postings + G_WR_I stride 65536. Do not silent-patch STREAM-02 / N4096-STREAM-02.
3. **Parent MAY open OPTIONAL next:** `ASTRA-C1-PAGE-SKIP-01` (min/max page skip) **or** `qse-v2-intersect-context-02` **or** a **semantic** corpus restart (not another synthetic 12/14-entity clone). One unknown each. **Not this audit. Do not start PAGE-SKIP from this close.**
4. **Do not auto-start C1 800k / N=16384 / BOARD_PASS.** 14-entity clone + `axi_mem_model` are the stop. Semantic ladder 16k→800k is PLAN bag 7, after a frozen stream law **and** after (optional) dir/page/context — not a clone upsample.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64 is unused this bag; TB 16 is not FINAL. Index is `axi_mem_model`. MERGE_POST_AR_MAX=256 was not stressed (alias_high n_post=2).
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE`; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; KEY-INTERSECT DUT not compiled; frozen sparse not compiled; stream DUT instantiate-only; relbind keys instantiated not edited; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; 12-bit collision emit on the high query FAILs the bag.
7. Next bag should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(65536)` explicitly (do not rely on RTL defaults 64 / 4096). If a future bag compiles extract, decide **named** lexicon: C0 59-word `38189974…` **or** the FULL16 extension `308cfbdf…`, not an accidental include-path order.
8. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
9. KEEP bags including N4096-STREAM-02 GOLDEN 12:10:22 late-gold 4094, STREAM-02 N=256, N4096-INTERSECT GOLDEN 10:46:42 sentinel miss, KEY-INTERSECT gold 10:16:50, AXI-BEAT hoc 256/96/2666 stay on disk as evidence of prior process.
10. Prefer xelab logs that print the **full** `N_BUCKETS=` value (or dump `u_sp.N_BUCKETS` / `B_W`) so the next auditor is not forced to reconstruct 65536 from AR math. Not a this-bag FAIL.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N_BUCKETS=65536 qse-v2-stream-intersect-02
                         16-bit exact bucket;
                         DUT a7ng_query_axi_sparse_stream_intersect 14f75db7…
                           MATCH STREAM-02; mtime 11:43:39 NOT newer than N=256 bag;
                           instantiated .N_BUCKETS(65536); B_W=16;
                           NOT KEY-INTERSECT buf0/buf1 cap-then-AND;
                         frozen dir FILE 09334e42… mtime 2026-09-05 19:31:03 NOT patched;
                           instantiated N_BUCKETS=65536 AXI-idle (geometry, not walker);
                         FULL16 nid 221 k0=0x1A01=6657 k1=0x1B01=6913;
                         12-bit alias nid 108 k0=0x0A01=2561 k1=0x0B01=2817;
                         share [11:0]=2561; 16-bit delta=4096;
                         12-bit AND = {108,221}; FULL16 AND high = {221};
                         raw FULL16_HIT id=221 k0=6657 k1=6913
                           FULL16_NO_12BIT_COLLISION low_alias_id=108
                           ALIAS12_WOULD_COLLIDE share12=2561
                           DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1;
                         CLASS_alias_high emit={221} tp=1 rec=1000 incomp=0;
                         CLASS_alias_low  emit={108} tp=1 incomp=0;
                         CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold 2f6ab31e… 12:44:33 PRE before xvlog 12:44:47;
                         KEEP N4096-STREAM-02 GOLDEN 12:10:22 2a2db8c8…;
                         KEEP STREAM-02 GOLDEN 11:43:45 05c6e087…;
                         KEEP N4096-INTERSECT GOLDEN 10:46:42 095ca715…;
                         KEEP KEY-INTERSECT d3b5b883… 10:16:50;
                         KEEP AXI-BEAT max 11:11:09;
                         independent tree UNMODIFIED (≤10:52:29);
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN;
                         runtime lexicon = bag 308cfbdf… QSE2_N_LEX=61
                           (documented include-path extension; C0 FILE 38189974… unedited))
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not PAGE-SKIP closed,
                            not N=16384, not Master ≥95% recall,
                            not Master ≥90% reduction,
                            not ACCEPT_BOARD, not BOARD_PASS;
                            14-entity clone + axi_mem_model remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   lexicon extension documented, not silent C0 FILE patch)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL page-skip / context
                   OR semantic corpus restart
                   (do NOT auto-start C1 800k / N=16384 / PAGE-SKIP;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
PAGE_SKIP        = NOT_STARTED
N_16384          = NOT_STARTED
DIR_FULL16_XSIM  = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_DIR_FULL16_XSIM_PASS PRESENT
                   PID 59148; 19325 ns; 12:44:51–12:44:55
                   xsim.log SHA256 55b5e527744af5dc0520ea20305bf8ae11b805b1b1cb641eb3cbd4932de9cc17
                   FULL16_HIT id=221 k0=6657 k1=6913 incomp=0
                   FULL16_NO_12BIT_COLLISION low_alias_id=108
                   DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1
                   CLASS_direct {110,144,145} tp=3 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 12:44:33; PRE MATCH live;
                                no r0; PASS session
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_DIR_FILE      = UNEDITED     09334e42… mtime 2026-09-05 19:31:03
C0_LEXICON_FILE  = UNEDITED     38189974… mtime 2026-09-05 20:51:03
RUNTIME_LEXICON  = BAG_COPY     308cfbdf… QSE2_N_LEX=61 boiler=26 header=27
                                prefix-59 MATCH C0; xvlog -i bag FIRST
LEXICON_LAW_ID   = P2_REQUIRED  do not treat 38189974 as runtime table
C0_PATCH         = MISS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 65536 elaborated (B_W=16; DIR16_AR key>=4096; WR_I stride 65536)
N_BUCKETS_DEFAULT_IN_SV = 4096 (source default; not the instantiate)
N4096_STREAM_02_KEEP = UNMODIFIED GOLDEN 12:10:22 2a2db8c8dcb7ac1c9fb322a7d59d407a8892ef087499f96784f71c9f1dd5df06
STREAM02_N256_KEEP   = UNMODIFIED GOLDEN 11:43:45 05c6e087… CLOSEOUT 11:45:37
N4096_INTERSECT_KEEP = UNMODIFIED GOLDEN 10:46:42 095ca715…
KEY_INTERSECT_KEEP   = UNMODIFIED d3b5b883… 10:16:50
AXI_BEAT_KEEP        = UNMODIFIED max 11:11:09
INDEP_TREE           = UNMODIFIED PLAN/EVIDENCE ≤ 10:52:29
LEFTOVER_A09         = not compiled
POKE_V               = 0
K0_HIGH              = 0x1A01 = 6657
K0_LOW               = 0x0A01 = 2561
SHARE12              = 2561
FULL16_AND_HIGH      = {221}
AND12                = {108,221}
BOTH_SLOTS_PLANTED   = YES (t0 8705=b2561 and t0 12801=b6657)
ENTITY_N             = 14 (12+boiler+header clone; REJECT 800k)
N                    = 256
```

Never ACCEPT_BOARD. Never close C1 800k. Never start PAGE-SKIP / context / 800k / N=16384 in this audit.
