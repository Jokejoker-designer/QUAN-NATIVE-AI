# ASTRA auditor REPORT — 20260907T1415Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-CONTEXT-02
LAW        = qse-v2-intersect-context-02
           NEW named keys a7ng_query_role_keys_ctx.sv
           NEW named DUT  a7ng_query_axi_sparse_intersect_context.sv
           (frozen extract → ctx fold → STREAM-02 two-pointer copy; k2/k3 not probed)
KEEP       = ASTRA-C1-PAGE-SKIP-01 (must be unmodified; GOLDEN 13:34:19 verified)
           + ASTRA-C1-STREAM-INTERSECT-02 N=256 (must be unmodified; GOLDEN 11:43:45 verified)
           + ASTRA-C1-DIR-FULL16-01 (must be unmodified; GOLDEN 12:44:33 verified)
           + ASTRA-C1-N4096-STREAM-02 (must be unmodified; GOLDEN 12:10:22 verified)
           + ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; GOLDEN 10:46:42 verified)
           + ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; GOLDEN 10:16:50 verified)
           + ASTRA-C1-AXI-BEAT-ACCOUNTING-01 (must be unmodified; CLOSEOUT 11:11:09 verified)
           + C0 RTL FILE hashes (extract/lexicon FILE/sparse/dir/gate; verified MATCH)
           + relbind keys a7ng_query_role_keys_relbind.sv 93811ed1… (KEEP; NOT compiled)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (KEEP; not compiled as DUT)
           + stream DUT a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (KEEP; NOT compiled as DUT)
           + page-skip DUT a7ng_query_axi_sparse_page_skip.sv dab15d76… (KEEP; NOT compiled as DUT)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1340Z/REPORT.md
           ACCEPT_PARTIAL (PAGE-SKIP min/max skip; P1 none; parent MAY open OPTIONAL context)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag6 (this audit did not write that tree)
             PLAN.md bag7 semantic 16k→800k remains OPEN (this audit does not start it)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-CONTEXT-02.md
EVIDENCE   = raw xsim.log CLASS_* / EMIT_* / CONTEXT_SELECTIVE / NOT_SELECTIVE /
             LATE_GOLD_HIT / ASTRA_C1_CONTEXT_02_XSIM_PASS / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + STREAM-02 SHA256.txt / PAGE-SKIP GOLDEN
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP bags)
           + NEW keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (ctx fold into k0/k1; no nid-derived keys)
           + NEW DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (k0_r <= k0_o folded; dir_addr from k0_r/k1_r; k2/k3 not walked)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime vs N=256 bag; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_context_02.sv (poke_v, leftover A09, PASS conjunct, CONTEXT_SELECTIVE)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + xvlog include_dirs order in run_xsim.ps1 (`-i $incq -i $incc -i $bag`)
           + C0 qse_role_lexicon.svh QSE2_N_LEX=59 (no bag qse_role_lexicon.svh)
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_context_02.py
           + independent corpus exact-key postings for plain k0=2561/k1=257 and packed k0=2577/k1=273
             and nid 254 (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
CONTEXT_KEYS = THIS BAG (N=256 fold-into-k0/k1 only; not Master close)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = OPEN (not started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start semantic 16k / C1 800k / N=16384, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=256 context-key** bag `ASTRA-C1-CONTEXT-02` after auditor `20260907T1340Z` ACCEPT_PARTIAL of PAGE-SKIP (P1 none) allowed parent to open OPTIONAL PLAN bag 6.

`results/A7-NATIVE-GRAPH/ASTRA-C1-CONTEXT-02/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=256, **new named key law** `qse-v2-intersect-context-02` (C0 extract instantiated not patched; NEW `a7ng_query_role_keys_ctx.sv` folds C0 ctx token into k0/k1 when `ctx_valid`; STREAM-02 two-pointer walker in a new named wrapper, not an edit of `14f75db7…`) — does CLASS_wrong_context emit differ from CLASS_direct `{110,144,145}` **and** does CLASS_direct still retrieve those gold ids **and** if STREAM-02 late-gold nid **254** remains in this corpus, is it still in emit (`SEARCH_INCOMPLETE` must not hide a miss)?

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_CONTEXT_02_XSIM_PASS` present.
2. CLASS_direct emit bit-identical `{110,144,145}`; `SEARCH_INCOMPLETE` **ABSENT** on gold retrieve.
3. CLASS_wrong_context emit **≠** CLASS_direct; labeled `CONTEXT_SELECTIVE` with `keys_match=0 emit_match=0`; live emit `{144}`. `NOT_SELECTIVE` must not be relabeled PASS.
4. STREAM-02 late-gold nid **254** in emit (`LATE_GOLD_HIT`); miss is FAIL, not `SEARCH_INCOMPLETE`.
5. NEW keys actually fold ctx into k0/k1 from query extract — **not** nid-derived keys, **not** `relevant=router_union`, **not** a host dual-index tautology that makes emit differ **without** query ctx. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. PAGE-SKIP `dab15d76…` **not** compiled; **not** edited. Frozen dir file `09334e42…` **not** patched. C0 59-word lexicon `38189974…` is the **runtime** table (xvlog `-i` C0 query **first**; **no** bag `qse_role_lexicon.svh` shadow). C0 extract `cd7baf49…` unedited.
6. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
7. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start semantic 16k / 800k.

If wrong_context emit equals direct, or C0 cannot bind a distinguishing ctx token, this bag is **FAIL** honestly (`NOT_SELECTIVE` remains) — do not fake ctx from nid. If emit differs only because the host chose gold as a ctx-packed posting **without** the query DUT folding ctx, verdict is **FAIL or OVERCLAIM**, not PASS_NARROW.

This bag **cannot** close C1 800k, cannot promote N=16384, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. Independent PLAN bag 7 (semantic corpus ladder 16k→800k) remains **OPEN** and is **not started** by this audit.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/` (GOLDEN `86b536fb…` timestamp **13:34:19**; CLOSEOUT **13:39:47**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/` (GOLDEN `2f6ab31e…` timestamp **12:44:33**; CLOSEOUT **12:46:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/` (GOLDEN `2a2db8c8…` timestamp **12:10:22**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN `095ca715…` timestamp **10:46:42**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**)
- C0 **FILE** hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Relbind keys `a7ng_query_role_keys_relbind.sv` = `93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d` (KEEP; **not** compiled)
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **not** compiled as DUT)
- Page-skip DUT `a7ng_query_axi_sparse_page_skip.sv` = `dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817` (PAGE-SKIP MATCH; **not** compiled as DUT)

**Not** this bag: C1 800k close, N=16384 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, bag lexicon shadow, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags, editing stream RTL `14f75db7…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting PLAN bag 7.

Hunt (dispatch, none dropped):

1. Host dual-index tautology (wrong_context gold chosen as ctx-packed posting so emit differs by construction **without query ctx**)
2. nid-derived keys
3. C0 extract / lexicon / dir / sparse / gate patched
4. Bag `qse_role_lexicon.svh` shadow / xvlog `-i` not C0 query first
5. STREAM-02 `14f75db7…` compiled as DUT or edited
6. PAGE-SKIP `dab15d76…` compiled or edited / page-skip scheduler mixed in
7. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
8. Gold hashed after first xvlog / rewritten after FAIL
9. KEEP bags rewritten
10. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
11. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / semantic 16k started
12. `NOT_SELECTIVE` relabeled PASS
13. Hash theatre (SHA256.txt vs live Get-FileHash)
14. Independent audit tree written by this implementer
15. Direct emit drift from `{110,144,145}`
16. Late-gold nid 254 miss hidden by `SEARCH_INCOMPLETE` / marker-only PASS

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=256 context-key fold** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** semantic corpus restart (PLAN bag 7). Do **not** auto-start C1 800k / N=16384 / semantic 16k from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. CONTEXT-02 bag is untracked (`??`). NEW keys `a7ng_query_role_keys_ctx.sv` and NEW DUT `a7ng_query_axi_sparse_intersect_context.sv` are untracked (`??`). KEEP PAGE-SKIP / STREAM-02 / DIR-FULL16 / N4096-STREAM-02 / KEY-INTERSECT remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…`. Page-skip DUT untracked with **unchanged** hash `dab15d76…`. KEEP intersect DUT remains untracked with **unchanged** hash `a912786f…`. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1340Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T14:20:00+07:00` `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-PAGE-SKIP-01` `unblocked_item=ASTRA-C1-CONTEXT-02` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), CONTEXT-02 bag:

```text
14:03:07.410  rtl/native_graph/query/a7ng_query_role_keys_ctx.sv          ← NEW keys
14:03:24.544  rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
14:07:07.743  host_astra_c1_context_02.py
14:08:48.160  tb_astra_c1_context_02.sv
14:10:21.732  ACK.json PREREG.md
14:11:28.653  run_xsim.ps1
14:12:02.955  corpus.json
14:12:02.956  GOLDEN.json
14:12:02.957  query_gold.svh
14:12:02.958  GOLD_HASH_PRE_XVLOG.txt      ← gold hash BEFORE first xvlog
14:12:22.680  SHA256.txt                   ← freeze immediately before first xvlog
14:12:24.210  xvlog.log
14:12:27.095  xelab.log
14:12:31.121  xsim.log                     PID 25508; session 14:12:28–14:12:31
14:13:59.927  RESULTS.md CLOSEOUT.md
```

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag (GOLDEN 11:43:45 / CLOSEOUT 11:45:37). This bag starts 14:03. STREAM-02 was not rewritten for CONTEXT-02.

Page-skip DUT LastWriteTime **2026-09-07 13:31:29.466** — **not newer** than PAGE-SKIP bag (GOLDEN 13:34:19 / CLOSEOUT 13:39:47). PAGE-SKIP was not rewritten for CONTEXT-02.

Frozen dir LastWriteTime **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**.

Single XSim session. No second xvlog. Gold files were **not** rewritten between 14:12:02 and 14:13:59 (hash MATCH PRE; LastWriteTime still 14:12:02). `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `e749c9b0314c69f4b706655348b07505adf13c1ae8d7faaeeff00e76cd010f66` MATCH RESULTS `XSIM_SHA`.

Bag `qse_role_lexicon.svh` **ABSENT**. N=16384 bag path **ABSENT**. New C1-800k / CONTEXT-03 / semantic-ladder dirs **ABSENT** (historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane, not this bag).

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / STREAM-02 DUT / NEW RTL

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  rtl/.../qse_role_lexicon.svh        (C0 FILE MATCH; mtime 2026-09-05 20:51:03)
                                                                 **this IS the compiled runtime table**
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (mtime 09:43:58; NOT compiled)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv
                                                                  (STREAM-02 MATCH; mtime 11:43:39; NOT compiled this bag)
dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817  a7ng_query_axi_sparse_page_skip.sv
                                                                  (PAGE-SKIP MATCH; mtime 13:31:29; NOT compiled this bag)
124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1  a7ng_query_role_keys_ctx.sv
                                                                  (NEW named keys; mtime 14:03:07)
8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989  a7ng_query_axi_sparse_intersect_context.sv
                                                                  (NEW named DUT; mtime 14:03:24)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7  a7ng_gate14_crc.svh
5561949d37894595404b6140799079b6f655e42ea1cccf6d6d277032d0abeeb1  tb_astra_c1_context_02.sv
```

C0 extract / lexicon MATCH `docs/ASTRA/authority/FINAL_CONTRACT.json` `ROLE_PARSER_LAW`. STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH.

`GOLD_HASH_PRE_XVLOG.txt` mtime **14:12:02.958** vs live gold (all MATCH):

```text
8fc931f5ac07a72fd146a8e429ab38aed7ce0952464514883b887049ce0c3165  GOLDEN.json
1dbd096a16d29578fa83ddcab67c161a68b2a51f6b3a9e8afc47e2b1ce68325f  query_gold.svh
eee202e0ded1a2fa45c92b1671dd371e34cfccf8f5a8b0e722416de8d1418ebd  corpus.json
```

`xvlog.log` mtime **14:12:24.210**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 14:12:02). SHA256.txt freeze stamp `2026-09-07T14:12:22.5644121+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **30 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, NEW keys `124be808…`, NEW DUT `8255a798…`, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple, gate14 crc). No invented hash. SHA256.txt `# FORBIDDEN bag qse_role_lexicon.svh shadow` — bag copy **ABSENT** on disk.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 14:03+ |
|---|---|---|---|
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19.424** | CLOSEOUT **13:39:47.345** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| DIR-FULL16 | `2f6ab31e41837fd3…` **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** CONTEXT-02 implementer did **not** write that tree. This auditor did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / STREAM-02 not DUT / include_dirs

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_ctx.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_intersect_context.sv
tb_astra_c1_context_02.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir AXI-idle, TB). Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; throws if bag `qse_role_lexicon.svh` exists; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / missing CONTEXT_SELECTIVE / NOT_SELECTIVE fail / LATE_GOLD miss / DISTRACTOR_LEAK / diverge. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` line 181, the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $incq -i $incc -i $bag $files
```

`$incq` = `rtl/native_graph/query` (C0 lexicon FILE) **first**. `$incc` = `rtl/native_graph/control`. `$bag` **third** (gold svh only). Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **C0** 59-word table. Opposite of DIR-FULL16 (`-i $bag` first). Hunt bag lexicon shadow: **MISS.**

TB instantiates `.N_BUCKETS(G_N_BUCKETS_TB)` with `G_N_BUCKETS_TB = 4096`, `.CAND_CAP(CAND_CAP)` with `G_CAND_CAP = 16`. Banner `N_BUCKETS=4096 CAND_CAP=16`. `if (G_N_BUCKETS != 4096) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<256). `MEM_DEPTH=32768` TB-only.

PASS marker conjunct (TB line 535): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_sel && (direct_tp > 0) && direct_ids_ok && late_hit && late_ok && (incomp_retrieve == 0)`. Direct IDs must be exactly `{110,144,145}` or `FAIL DIRECT_EMIT_NOT_BIT_IDENTICAL`. Wrong-context `emit_match || keys_match` → `NOT_SELECTIVE` **and** `FAIL WRONG_CONTEXT_NOT_SELECTIVE` (cannot relabel). Late nid 254 miss → `FAIL LATE_GOLD_MISS` even if incomp. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `incomp_retrieve==0` is in the conjunct (copied from DIR-FULL16; stronger than PAGE-SKIP TB).

Live: `incomp=0` on every CLASS line; `SEARCH_INCOMPLETE` line count **0**; `incomp=1` count **0**. Hunt swallowed-incomp: **MISS this bag.**

### 5) PRIMARY HUNT — C0 59-word runtime (no bag shadow)

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
```

Independent decode of C0 table (this process, not RESULTS):

```text
word pump        cls=1 id=10
word chiller     cls=1 id=1
word supplies    cls=2 id=1
word water       cls=3 id=1     ← CLS_CTX
word air         cls=3 id=1
word indirect    cls=3 id=2
word indirectly  cls=3 id=2
```

Bag `results/A7-NATIVE-GRAPH/ASTRA-C1-CONTEXT-02/qse_role_lexicon.svh`: **ABSENT**. `run_xsim.ps1` throws `C1CTX02_BAG_LEXICON_SHADOW_FORBIDDEN` if present. xvlog `-i` C0 query **first**.

Live extract on `"pump supplies chiller"` / `"pump supplies chiller water"` produced CLASS lines with no `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. Direct k0=2561=`0x0A01` (pump=10, rel=1) MATCH C0 HVAC ids. Wrong-context k0=2577=`0x0A11` is the same subj/rel with ctx nibble 1 packed in — not a different entity. **Runtime table is C0 `38189974…` 59-word.** DIR-FULL16 61-word boiler/header shadow was **not** reused. Hunt “C0 lexicon file edited”: **MISS.** Hunt “bag lexicon shadow”: **MISS.** Hunt “xvlog did not put C0 first”: **MISS.** Hunt “C0 extract patched”: **MISS.**

### 6) NEW keys / NEW DUT vs nid keys / STREAM-02 clone (hunts 2, 5, 6)

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**: 611 lines; instantiates `a7ng_query_role_keys_relbind`; **no** `S_ARHDR`. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**: **Not compiled** (xvlog/xelab/sdb ABSENT). NEW DUT has **no** `S_ARHDR` / `can_skip`. Hunt page-skip scheduler mixed in: **MISS.**

NEW keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. No nid port. Packing:

```text
ctx_valid_o = (ctx_id_i != 0)
k0_ctx = {subj[7:0], ctx[3:0], rel[3:0]}
k1_ctx = {obj[7:0],  ctx[3:0], rel[3:0]}
k0_o   = ctx_valid_o ? k0_ctx : k0_i     // else pass through frozen {subj,rel}
k1_o   = ctx_valid_o ? k1_ctx : k1_i
k2_o   = {rel, ctx}                      // indexed, not probed
k3_o   = {subj, ctx}
valids pass through frozen bind-state
```

NEW DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**: 613 lines. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle (`q_v=0`, k*_valid=0, `arready=0` — **not** the merge walker). Own AXI master: `arlen=0` (1-beat). States `S_IDLE / S_DISPATCH / S_ARDIR0 / S_RDIR0 / S_ARDIR1 / S_RDIR1 / S_NEXT / S_ARPOST / S_RPOST / S_OUT / S_DONE` — STREAM-02 two-pointer copy, not page-skip. At `S_IDLE` with `qse_valid_o && !issued`: **`k0_r <= k0_o`** (folded keys, not `k0_ex`). `dir_addr0/1` from `k0_r[B_W-1:0]` / `k1_r`. `p2`/`p3` are wired from the gate and **never used** to issue AR (acc_pmask only bits 0 and 1). `CAND_CAP` checked **at emit**. Rare-list-first when both need a beat (`occ0 <= occ1`). No union. No nid in the key path.

TB also instantiates a **shadow** `a7ng_query_role_keys_ctx u_cx_qse` on a separate extract, then feeds the DUT a second time. `CONTEXT_SELECTIVE` prints `k0_cx` (shadow). DUT keys are separately gated: `sp_k0 !== G_K0[qi]` → `KEY_MISMATCH` / `FIRST_DIVERGENCE`. Live FIRST_DIVERGENCE **ABSENT**, so DUT `sp_k0/sp_k1` matched folded gold. Emit lists are live DUT `got[]`.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “nid-derived keys”: **MISS** (RTL has no nid; independent `k_eq_nid=0` on all 256 records). Hunt “PAGE-SKIP compiled / mixed”: **MISS.**

Parameter default `CAND_CAP = 64` remains in the NEW DUT `.sv`. **TB overrides 16.** Do not treat 64 as `CAND_CAP_FINAL`.

`ctx_valid := (ctx_id != 0)` is **not** PLAN’s “independent of ctx_id==0” as a separate extract `xh` pin (C0 extract does not export `xh`). PREREG discloses that C0 CLS_CTX ids are `{1,2}` never 0, so the bind flag ≡ `xh` on this freeze. Quality residual vs PLAN wording, not a this-bag emit FAIL. If a later named extract exports `xh`, that is a new wire — do not silent-patch C0.

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 14:12:28 2026**; exit **14:12:31**; PID **25508**; `$finish` at **16565 ns**.

Banner:

```text
C1_CONTEXT_02_N=256 N_BUCKETS=4096 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN
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
CONTEXT_SELECTIVE class=wrong_context k0=2577 k1=273 k2=257 k3=2561 vs_direct k0=2561 k1=257 k2=256 k3=2560 keys_match=0 emit_match=0 law=qse-v2-intersect-context-02
CLASS_wrong_context gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=1 ovf=0 trunc=0 dirB=32 postB=32 discB=0 descB=0 incomp=0
EMIT_wrong_context n=1
  CAND wrong_context i=0 id=144 ev=1
CLASS_distractor gold_n=10 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {110,144,145}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 occ=22 incomp=0
EMIT_high_occupancy {147…162}
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=167 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=255 incomp=0
LATE_GOLD_HIT id=254
CAP_THEN_AND_WOULD_MISS id=254 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 id=254 occ=23 ovf=1 trunc=0 dirB=32 postB=192 incomp=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_CONTEXT_02_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_16384,PAGE_SKIP_MIX
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_CONTEXT_02_XSIM_PASS=1`; `LATE_GOLD_HIT=1`; `CONTEXT_SELECTIVE=1`; `NOT_SELECTIVE=0`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` = **0**; `FIRST_DIVERGENCE` = **0**; `ROLE_COLLAPSE` = **0**; `incomp=1` = **0**. `incomp=0` on `CLASS_direct`, `CLASS_wrong_context`, `CLASS_late_gold`, `CLASS_high_id_sentinel`.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_direct emit `{110,144,145}` tp=3. CLASS_wrong_context emit `{144}` `keys_match=0 emit_match=0` labeled `CONTEXT_SELECTIVE` not `NOT_SELECTIVE`. Late emit `{254}` `LATE_GOLD_HIT`. Conjunctive gate holds on raw.

query_gold (hashed before xvlog): `G_CTX[4]=1` `G_CTX_VALID[4]=1` `G_K0_PLAIN[4]=16'h0A01` `G_K0[4]=16'h0A11` `G_SUBJ/OBJ/REL[4]` identical to direct. `G_BYTES[4]` LSB-first `pump supplies chiller water` (len 27). Frozen extract keys on the bound query **stay** `0x0A01/0x0101`; fold produces `0x0A11/0x0111`. That is the nibble packing `{subj,ctx[3:0],rel[3:0]}`, not a role swap.

### 8) Independent corpus — ctx fold is real; dual-index is the index-side, not a no-ctx cheat

Authority = live `corpus.json` records (hash `eee202e0…`), **not** the JSON header fields and **not** RESULTS.

Packing: `k0_plain==(subj<<8)|rel` on all 256 records: **0** failures. Packed `k0=={subj,ctx[3:0],rel[3:0]}` when `ctx_valid`: **0** failures. `k_eq_nid=0`. Hunt nid-derived keys: **MISS.** Packed key vs some other record’s plain key: **0** collisions this corpus.

```text
unique entity ids = {1..12} n=12
names             = C0 HVAC 1..12 (no boiler/header)
unique rel ids    = {1,2,3}
unique ctx ids    = {0,1,2}   counts 254 / 1 / 1
n records         = 256 (nid 0..255)
kinds             = block_a 144 / fill 54 / late_k0_fill 16 / late_k1_fill 16 /
                    high_occ_synth 15 / ovf_synth 4 / psc_water 1 / psc_indirect 1 / …
N_BUCKETS         = 4096
```

PSC control records (subj=10, rel=1, obj=1, evidence=1):

```text
nid 110  text="pump supplies chiller"            ctx=0  k0=2561 k1=257   kind=block_a
nid 144  text="pump supplies chiller water"      ctx=1  k0=2577 k1=273   kind=psc_water
nid 145  text="pump supplies chiller indirectly" ctx=2  k0=2593 k1=289   kind=psc_indirect
```

Host dual-index (always plain k0/k1; **also** packed k0/k1 if record `ctx_valid`):

```text
plain k0=2561 list = [108,109,110,111,144,145]
plain k1=257  list = [99,110,121,132,144,145,188,208]
plain AND            = {110,144,145}          ← CLASS_direct

packed k0=2577 list = [144]
packed k1=273  list = [144]
packed AND           = {144}                  ← CLASS_wrong_context

144 ∈ plain lists  (so unbound direct still retrieves it)
110 ∉ packed 2577  145 ∉ packed 2577
```

Independent skip of query ctx fold (walk plain keys on the bound query string): emit **`{110,144,145}` = direct**. That path would print `NOT_SELECTIVE` and `FAIL WRONG_CONTEXT_NOT_SELECTIVE`. Live did not. **Query ctx fold is necessary** for emit to differ.

Gold predicate (host, before walker, hashed before xvlog): `pred_psc AND ctx_id==1` → `{144}`. Not defined as “the packed posting list”. On this corpus the two sets coincide because **ctx_id==1 count = 1** (the planted `psc_water` row whose text **is** the wrong_context query).

Late gold nid 254 (`compressor requires tower`, k0=1026, k1=2306, ctx=0):

```text
k0 occ=21  index of 254 = 20  (>=16)
k1 occ=23  index of 254 = 22  (>=16)
full ∩              = {254}
first16 ∩ first16   = {}          254 NOT in first16 of either list
complete ∩ then cap = {254}
```

MATCH raw `LATE_GOLD_HIT id=254` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0`. `CAP_THEN_AND_WOULD_MISS` **is** gated on gold bit `G_CAP_THEN_AND_MISS` (print tautology). Independent first16∩={} and indices 20/22 prove the bit is true. Same STREAM-02 N=256 late-gold plant (KEEP 11:43:45). Hunt late-gold miss hidden: **MISS.** Hunt one-list plant: **MISS.**

Key arithmetic (independent, not RESULTS):

```text
direct k0 = 2561 = 0x0A01 = {subj=10, rel=1}
wc     k0 = 2577 = 0x0A11 = {subj=10, ctx=1, rel=1}
direct k1 =  257 = 0x0101 = {obj=1,  rel=1}
wc     k1 =  273 = 0x0111 = {obj=1,  ctx=1, rel=1}
wc     k2 =  257 = {rel=1, ctx=1}
direct k2 =  256 = {rel=1, ctx=0}
wc     k3 = 2561 = {subj=10, ctx=1}
direct k3 = 2560 = {subj=10, ctx=0}
```

If `"water"` had been extracted as a new **object**, k1 high byte would change (not `0x01→0x0111` nibble insert). If it had been a new **relation**, frozen `k0_plain` would leave `0x0A01`. Live TB requires `k0 === G_K0_PLAIN` (still `0x0A01` on qi=4) **and** `k0_cx !== G_K0_PLAIN` (`wrong_context k0 not folded` diverge). FIRST_DIVERGENCE ABSENT. SRO of the bound query MATCH direct (subj=10, obj=1, rel=1). **Only ctx differs.**

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {110,144,145}` tp=3 incomp=0; `CONTEXT_SELECTIVE` k0=2577/k1=273 vs 2561/257 keys_match=0 emit_match=0; wrong_context emit `{144}`; `LATE_GOLD_HIT id=254` incomp=0; distractor `leak_n=0 gold_n=10`; unrelated empty-walk). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD. `NOT_SELECTIVE` is **ABSENT** this bag (not relabeled).

Implementer prose that dual-index keeps unbound direct on `{110,144,145}` while `"pump supplies chiller water"` binds C0 ctx id=1 and walks packed keys: **HONEST vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat). Hunt `NOT_SELECTIVE` relabeled PASS: **MISS.**

CLOSEOUT MATCH raw: marker present, NEW keys `124be808…`, NEW DUT `8255a798…`, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` runtime / no bag shadow, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 14:12:02 PRE before xvlog 14:12:24.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Host dual-index tautology (emit differs **without** query ctx) | **MISS as no-ctx cheat.** Counterfactual: walk plain 2561/257 on the bound query → `{110,144,145}` = direct (would FAIL). Live keys are the ctx nibble fold; frozen extract k0 stays 2561; DUT `k0_r <= k0_o`; SRO unchanged. **HIT as construction/quality:** corpus `ctx_id==1` count = **1** (planted `psc_water` nid 144 whose text **is** the query); packed posting `{144}` coincides with label gold `PSC ∧ ctx==1` by that plant; dual-index is what keeps 144 in the **plain** lists so CLASS_direct still hits. | Dual-index is the index-side of the law, not a substitute for query ctx. Selectivity is 1-id identity, not a many-ctx stress. |
| 2. nid-derived keys | **MISS.** RTL has no nid. Independent `k_eq_nid=0`. Keys are `{subj,rel}` / `{subj,ctx[3:0],rel[3:0]}`. | Fake nid keys ⇒ FAIL, do not patch. |
| 3. C0 extract / lexicon / dir / sparse / gate patched | **MISS.** Live MATCH FINAL_CONTRACT / C0 FILE hashes; mtimes 2026-09-05. git `M` dir vs HEAD is the historical C0 blob `09334e42…`. | Do not edit C0 files. |
| 4. Bag lexicon shadow / xvlog `-i` order | **MISS.** Live `38189974…` `QSE2_N_LEX=59`; bag copy ABSENT; xvlog `-i` C0 query first. | DIR-FULL16 61-word shadow was **not** reused. Runtime **is** C0 59-word. |
| 5. STREAM-02 DUT edited / compiled | **MISS.** SHA `14f75db7…` MATCH STREAM-02; mtime 11:43:39 **not newer** than N=256 bag; sdb ABSENT. | Hash mismatch ⇒ FAIL, do not patch. |
| 6. PAGE-SKIP compiled / scheduler mixed | **MISS.** SHA `dab15d76…` mtime 13:31:29; sdb ABSENT; NEW DUT has no `S_ARHDR`. | Do not mix skip into the context unknown. |
| 7. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 8. Gold after FAIL / after xvlog | **MISS.** PRE 14:12:02; xvlog 14:12:24; gold still 14:12:02; no r0. | Do not regenerate gold. |
| 9. KEEP bags mutated | **MISS.** PAGE-SKIP GOLDEN **13:34:19** `86b536fb…`; STREAM-02 11:43:45; DIR-FULL16 12:44:33; N4096-STREAM-02 12:10:22; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 10. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Dual-index prose MATCH independent. | Authority = raw CLASS_* + CONTEXT_SELECTIVE + LATE_GOLD_HIT + independent postings. |
| 11. C1 800k / bounds / ACCEPT_BOARD / semantic 16k | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. Semantic / 800k / N=16384 new dirs ABSENT. | Never grant. Never freeze. Never auto-start 800k. PLAN bag 7 remains OPEN. |
| 12. `NOT_SELECTIVE` relabeled PASS | **MISS.** Raw `CONTEXT_SELECTIVE` count=1; `NOT_SELECTIVE` count=0; `FAIL WRONG_CONTEXT_NOT_SELECTIVE` ABSENT. TB FAIL path still prints `NOT_SELECTIVE` if emit_match or keys_match. | Keep that FAIL path on later bags. |
| 13. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 30/30 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + NEW keys/DUT). | SHA256.txt 14:12:22 is the first-xvlog freeze. |
| 14. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 14:03. | Keep that tree read-only. |
| 15. Direct emit drift | **MISS.** Raw `{110,144,145}` tp=3; independent plain AND `{110,144,145}`. | Identity control, not Master ≥95%. |
| 16. Late-gold 254 miss hidden by incomp | **MISS.** Raw `LATE_GOLD_HIT id=254` emit `{254}` `incomp=0`; `SEARCH_INCOMPLETE` ABSENT; independent idx 20 and 22; first16∩={}. | Keep miss as FAIL on later bags. |
| CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩={} and 254 at 20 and 22). | Same as STREAM-02 N=256 KEEP. |
| PLAN third-list `k0 ∩ k1 ∩ k_ctx` vs fold-into-k0/k1 | **HIT as law-shape residual.** Implementer folded ctx into k0/k1 and dual-indexed instead of walking a third posting. Equivalent on this corpus (0 packed/plain collisions; only one ctx=1 record). | 4-bit ctx/rel packing can alias at scale. Not a this-bag emit FAIL. |
| `ctx_valid := (ctx_id != 0)` vs PLAN `xh` | **HIT as residual vs PLAN wording.** C0 extract does not export `xh`; CLS_CTX ids never 0 so equivalent **this freeze**. | Do not silent-patch extract. New `xh` wire = new named extract law. |
| k2/k3 alias plain k1/k0 | **HIT as residual.** wc k2=257 equals direct **plain k1**; wc k3=2561 equals direct **plain k0**. Not probed this bag (`p2`/`p3` unused). | Do not later “probe k3” without a named law. |
| CAND_CAP default 64 vs TB 16 | **MISS as this-bag behavior** (TB override 16; banner 16; 16<256). **HIT as reuse caveat.** | Default 64 is not `CAND_CAP_FINAL`. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** Retrieve ARs are the context DUT’s own master. | Do not call idle dir “the merge”. |
| Direct prec=1000 is 3-id identity; wc prec=1000 is 1-id identity | **HIT as quality caveat.** PSC labels = plain k0∩k1; wc gold = the planted water row. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=256 XSim. | Illegal as BOARD_PASS / 800k / DDR freeze. |
| 12-entity clone | **HIT as promotion bound.** Entity ids {1..12}; `N_BUCKETS=4096`; ctx tokens `{water,air,…}=1` and `{indirect,indirectly}=2` already in C0. | **REJECT C1 800k.** PLAN bag6 is “wrong_context emit ≠ direct”, not 800k-representative. PLAN bag 7 remains OPEN. |
| CONTEXT_SELECTIVE key print is TB shadow `k0_cx` vs gold direct keys | **HIT as print path.** DUT keys separately gated (`sp_k0 === G_K0`); emit_match is live `got[]` vs live `direct_got[]`. FIRST_DIVERGENCE ABSENT. | Corpus AND is the proof, not the `$display`. |
| NEW DUT is a STREAM-02 FSM copy (611 vs 613 lines) not an instantiate | **MISS as forbidden edit** (14f75db7 unedited, not compiled). **HIT as naming.** WO allowed “else new thin wrapper”. | Keep STREAM-02 file frozen. |

qstack-validation-adversary one-liner: **CONTEXT-02 XSim is a real host+new-keys ctx-fold lock on unpatched C0 59-word runtime (`38189974…`, no bag lexicon shadow, xvlog `-i` C0 query first): NEW `a7ng_query_role_keys_ctx` `124be808…` packs `{subj,ctx[3:0],rel[3:0]}` into k0/k1 when `ctx_id!=0` and passes frozen `{subj,rel}` otherwise; NEW DUT `8255a798…` walks those folded keys with a STREAM-02 two-pointer copy (`k0_r <= k0_o`; k2/k3 not probed); independent PSC records 110=`pump supplies chiller` ctx=0 / 144=`… water` ctx=1 / 145=`… indirectly` ctx=2 dual-indexed so unbound CLASS_direct still emits `{110,144,145}` while bound `"pump supplies chiller water"` (same SRO, C0 CLS_CTX water id=1) walks packed k0=2577=`0x0A11` k1=273=`0x0111` and emits `{144}` (`CONTEXT_SELECTIVE keys_match=0 emit_match=0`); counterfactual without the fold would still emit `{110,144,145}` (FAIL); late-gold nid 254 at k0 index 20 **and** k1 index 22 still emits (`LATE_GOLD_HIT`, first16∩={}, `SEARCH_INCOMPLETE` ABSENT); STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; PAGE-SKIP `dab15d76…` not compiled; leftover A09 off; poke_v=0; gold PRE 14:12:02 before xvlog 14:12:24; KEEP PAGE-SKIP / STREAM-02 unmodified; that is not C1 800k, not a third-list `k0∩k1∩k_ctx`, not a many-ctx stress (corpus ctx=1 count=1, query text = planted row 144), not ACCEPT_BOARD, and still a 12-entity / axi_mem_model clone.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted direct `{110,144,145}` / wrong_context `{144}` / late `{254}`). Findings are **law-quality / promotion bounds / PLAN-shape residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **Context law is a new named key bind as claimed, not a STREAM-02 re-label and not nid keys.** Frozen extract unpatched. Relbind keys **not compiled**. Frozen dir instantiated AXI-idle. Two-pointer compare-and-advance; 1-beat `arlen=0`; CAND_CAP at emit. k2/k3 not probed. leftover A09 off. poke_v=0. STREAM-02 SHA MATCH and not compiled. PAGE-SKIP SHA MATCH and not compiled.
2. **Query ctx fold is a real discriminator vs CLASS_direct.** Independent: same SRO; frozen k0 stays 2561; folded k0=2577 inserts ctx nibble 1; no-fold counterfactual emit equals direct; live emit `{144}` ≠ `{110,144,145}`. Host dual-index is required for the **control** (144 stays in plain lists) and is disclosed.
3. **Selectivity this bag is a planted singleton.** Corpus `ctx_id==1` count=1; query text equals record 144 text; packed occupancy=1. Honest vs the registered unknown (`emit ≠ direct` **and** direct still hits). Not a held-out many-context exam.
4. **PLAN bag6 preferred `emit = k0 ∩ k1 ∩ k_ctx` with `k_ctx={subj,rel,ctx}`.** Implementer folded ctx into k0/k1 (4-bit ctx and rel) plus dual-index. Equivalent here (0 collisions). 4-bit packing can alias a later 8-bit rel/ctx space. New unknown if keys grow.
5. **Late gold 254 survived the new keys** (unbound, ctx=0, plain keys). Both-list index ≥16; first16∩={}; emit `{254}` incomp=0. Direct control `{110,144,145}` survived dual-index. Distractor leak_n=0 on a 10-id excluded set. Polarity meter intact.
6. **Runtime lexicon is C0 59-word.** Opposite of DIR-FULL16 bag-first 61-word extension. CLS_CTX `water`/`air`/… already in the freeze — no new lexicon field was required. P2 from 1250Z (named lexicon law id) is **not** re-opened by this bag.
7. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the context DUT master. Same pattern as STREAM-02 / PAGE-SKIP / DIR-FULL16.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **CAND_CAP default 64 in RTL source is a future-bag hazard**, not a this-bag cheat (TB 16). Do not freeze 16 as `CAND_CAP_FINAL`.
10. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0` (unlike PAGE-SKIP). Later bags must still FAIL gold_n>=1 + incomp.
11. **12-entity clone + 12-bit `N_BUCKETS=4096` + axi_mem_model + 1 planted ctx=1 row** is the promotion stop. PLAN bag6 is “wrong_context emit ≠ direct” — **closed as PASS_NARROW**. PLAN bag 7 (semantic 16k→800k) is **not** closed and **not** started by this audit.
12. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
13. **k2/k3 numeric alias with plain k1/k0** is unused this bag. Do not probe them later without a named law.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start semantic 16k / 800k / N=16384 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 59-word runtime, leftover off, poke_v=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| NEW keys fold (`124be808…`, `{subj,ctx[3:0],rel[3:0]}` when ctx_valid, else frozen pass-through, no nid) | **PASS_NARROW** | Live 2561→2577 is the nibble insert of C0 water id=1. |
| NEW DUT walk (`8255a798…`, `k0_r <= k0_o`, k2/k3 not probed, not STREAM-02 file, not page-skip) | **PASS_NARROW** | STREAM-02 FSM copy in a new named wrapper. |
| Independent wc AND: packed k0=2577 ∩ k1=273 = `{144}`; no-fold counterfactual = `{110,144,145}` | **PASS_NARROW** | Query ctx is necessary. Dual-index is the control, not a no-ctx cheat. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. |
| C0 lexicon **runtime** = `38189974…` 59-word; no bag shadow; xvlog `-i` C0 first | **PASS_NARROW** | Opposite of DIR-FULL16 include-path extension. CLS_CTX already in freeze. |
| Registered unknown (CLASS_direct `{110,144,145}` **and** CLASS_wrong_context emit `{144}` ≠ direct **and** CONTEXT_SELECTIVE keys_match=0 emit_match=0 **and** LATE_GOLD 254 **and** SEARCH_INCOMPLETE ABSENT) | **PASS_NARROW** | Raw CLASS_direct tp=3; CONTEXT_SELECTIVE present; NOT_SELECTIVE absent; `LATE_GOLD_HIT id=254`; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_CONTEXT_02_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k. |
| Dual-index no-ctx tautology / nid keys / NOT_SELECTIVE relabel | **MISS (not FAIL of this unknown)** | Fold is live; nid unused; NOT_SELECTIVE not printed. Construction is a 1-id plant. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; conjunct includes `incomp_retrieve==0`. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; wc 1000 is 1-id identity; 12-entity clone; reduction not emitted. |
| C1 800k / semantic 16k / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 12-entity / 12-bit dir / axi_mem_model / ctx=1 count=1. This audit does not start next bags. PLAN bag 7 OPEN. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 14:12:02; xvlog 14:12:24; gold 14:12:02 KEEP `8fc931f5…`; no r0. |
| KEEP PAGE-SKIP + STREAM-02 + DIR-FULL16 + N4096-STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT + stream DUT + page-skip DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1340Z / C0. PAGE-SKIP GOLDEN **13:34:19**. STREAM-02 GOLDEN **11:43:45**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=256 `qse-v2-intersect-context-02`: C0 ctx token folded into k0/k1 on a new named key module; CLASS_direct `{110,144,145}` remains via host dual-index of plain keys; CLASS_wrong_context emit `{144}` ≠ direct with live `CONTEXT_SELECTIVE keys_match=0 emit_match=0`; late-gold 254 still emits; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; C0 **runtime** 59-word MATCH; no bag lexicon shadow; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; dir file `09334e42…` unedited; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest; fold is **not** nid keys and **not** a no-ctx dual-index cheat). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, PLAN bag 7, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “third-list k_ctx closed”, “many-context selectivity”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, NOT_SELECTIVE not relabeled, PASS is honest, late gold both-list, SEARCH_INCOMPLETE absent). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k; dual-index disclosed; no-ctx hunt fails). **Not** FAIL of the context-key unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** PLAN bag 7 semantic corpus restart. Do **not** auto-start 800k / N=16384 / semantic 16k. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-CONTEXT-02` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16.

**P1 — none for this unknown** (independent packed AND `{144}` vs plain AND `{110,144,145}`; no-fold counterfactual equals direct; CLASS_direct `{110,144,145}`; CONTEXT_SELECTIVE keys_match=0 emit_match=0; NOT_SELECTIVE absent; LATE_GOLD 254 at k0 index 20 and k1 index 22; SEARCH_INCOMPLETE ABSENT; NEW keys not nid; STREAM-02 SHA MATCH and not compiled; PAGE-SKIP not compiled; C0 59-word runtime; no bag lexicon; gold PRE before xvlog).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=256 ctx fold into k0/k1. Authority = raw `CONTEXT_SELECTIVE` / `CLASS_direct {110,144,145}` / `EMIT_wrong_context {144}` / `LATE_GOLD_HIT id=254` / `SEARCH_INCOMPLETE` ABSENT + independent postings. Do not silent-patch STREAM-02 / PAGE-SKIP / C0.
2. **Do not sell this as many-context selectivity or as PLAN’s third-list `k0 ∩ k1 ∩ k_ctx`.** Corpus ctx=1 count=1; query text = planted row 144; packing is 4-bit ctx/rel fold plus dual-index. Next context bag that claims k_ctx as a third walk must actually probe a third posting, not relabel this fold.
3. **Parent MAY open OPTIONAL next:** PLAN bag 7 **semantic** corpus restart (not another synthetic 12-entity clone). One unknown. **Not this audit. Do not start semantic 16k / 800k from this close.** Independent PLAN bag 7 remains **OPEN**.
4. **Do not auto-start C1 800k / N=16384 / BOARD_PASS.** 12-entity clone + 12-bit dir + `axi_mem_model` + singleton ctx plant are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64 is unused this bag; TB 16 is not FINAL.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `CONTEXT_SELECTIVE` vs `NOT_SELECTIVE` (FAIL if emit_match or keys_match); no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; C0 query `-i` first unless a **named** lexicon law is registered; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct.
7. Next bag should instantiate `.CAND_CAP(16)` explicitly (do not rely on RTL default 64). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02.
8. If a later law must export extract `xh` independent of `ctx_id==0`, or must walk k_ctx as a third list, or must use more than 4 bits of ctx/rel in the packed key, that is a **new** named module / new bag. Do not silent-patch `a7ng_query_role_keys_ctx.sv` or C0 extract.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including PAGE-SKIP GOLDEN 13:34:19 (real min/max skip vs AXI-BEAT 14), STREAM-02 N=256 nid 254 at 20/22, DIR-FULL16 GOLDEN 12:44:33 (61-word include-path P2 archive) stay on disk as evidence of prior process.
11. Optional: do not probe k2/k3 later without noticing wc k2 aliases direct plain k1 and wc k3 aliases direct plain k0. Optional: print DUT `sp_k0` on the CONTEXT_SELECTIVE line (not only TB shadow `k0_cx`).

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=256 qse-v2-intersect-context-02 ctx fold;
                         NEW keys a7ng_query_role_keys_ctx 124be808…
                           k0={subj,ctx[3:0],rel[3:0]} when ctx_valid
                           else frozen {subj,rel}; no nid;
                         NEW DUT a7ng_query_axi_sparse_intersect_context 8255a798…
                           k0_r <= k0_o; STREAM-02 two-pointer copy;
                           k2/k3 not probed; NOT page-skip; NOT 14f75db7 file;
                         STREAM-02 a7ng_query_axi_sparse_stream_intersect 14f75db7…
                           MATCH STREAM-02; mtime 11:43:39 NOT newer than N=256 bag;
                           NOT compiled as DUT;
                         PAGE-SKIP a7ng_query_axi_sparse_page_skip dab15d76…
                           MATCH PAGE-SKIP; mtime 13:31:29; NOT compiled as DUT;
                         frozen dir FILE 09334e42… mtime 2026-09-05 19:31:03 NOT patched;
                           instantiated AXI-idle (geometry, not walker);
                         C0 lexicon RUNTIME 38189974… QSE2_N_LEX=59
                           xvlog -i C0 query FIRST; bag qse_role_lexicon.svh ABSENT;
                           water CLS_CTX id=1 already in freeze;
                         C0 extract cd7baf49… mtime 2026-09-05 19:48:18 UNEDITED;
                         CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0;
                         CONTEXT_SELECTIVE class=wrong_context
                           k0=2577 k1=273 vs_direct k0=2561 k1=257
                           keys_match=0 emit_match=0;
                         CLASS_wrong_context emit={144} gold_n=1 tp=1 incomp=0;
                         NOT_SELECTIVE ABSENT (not relabeled);
                         independent PSC:
                           110 "pump supplies chiller" ctx=0 k0=2561;
                           144 "pump supplies chiller water" ctx=1 k0=2577;
                           145 "pump supplies chiller indirectly" ctx=2 k0=2593;
                         dual-index plain AND={110,144,145};
                         packed AND={144};
                         no-fold counterfactual emit={110,144,145} (would FAIL);
                         LATE_GOLD nid 254 at k0 index 20 AND k1 index 22;
                         first16∩first16 = {}; complete∩ then cap = {254};
                         raw LATE_GOLD_HIT id=254 CAP_THEN_AND_WOULD_MISS stream_hit=1
                           CLASS_late_gold emit={254} tp=1 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold 8fc931f5… 14:12:02 PRE before xvlog 14:12:24;
                         KEEP PAGE-SKIP GOLDEN 13:34:19 86b536fb…;
                         KEEP STREAM-02 GOLDEN 11:43:45 05c6e087…;
                         KEEP DIR-FULL16 GOLDEN 12:44:33 2f6ab31e…;
                         KEEP N4096-STREAM-02 GOLDEN 12:10:22 2a2db8c8…;
                         KEEP N4096-INTERSECT GOLDEN 10:46:42 095ca715…;
                         KEEP KEY-INTERSECT d3b5b883… 10:16:50;
                         KEEP AXI-BEAT max 11:11:09;
                         independent tree UNMODIFIED (≤10:52:29);
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN)
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not PLAN bag 7,
                            not N=16384, not Master ≥95% recall,
                            not Master ≥90% reduction,
                            not ACCEPT_BOARD, not BOARD_PASS,
                            not third-list k_ctx, not many-ctx stress;
                            12-entity clone + axi_mem_model + ctx=1 count=1 remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   dual-index disclosed; no-ctx hunt MISS;
                   NOT_SELECTIVE not relabeled)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL PLAN bag 7 semantic corpus restart
                   (do NOT auto-start C1 800k / N=16384 / semantic 16k;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
PLAN_BAG6_CTX    = PASS_THIS_GATE_ONLY (this unknown)
PLAN_BAG7_SEMANTIC = OPEN / NOT_STARTED
N_16384          = NOT_STARTED
CONTEXT_02_XSIM  = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_CONTEXT_02_XSIM_PASS PRESENT
                   PID 25508; 16565 ns; 14:12:28–14:12:31
                   xsim.log SHA256 e749c9b0314c69f4b706655348b07505adf13c1ae8d7faaeeff00e76cd010f66
                   CLASS_direct {110,144,145} tp=3 incomp=0
                   CONTEXT_SELECTIVE k0=2577 k1=273 keys_match=0 emit_match=0
                   EMIT_wrong_context {144}
                   NOT_SELECTIVE ABSENT
                   LATE_GOLD_HIT id=254 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 14:12:02; PRE MATCH live;
                                no r0; PASS session
DUT_CTX_KEYS     = NEW          124be808… mtime 14:03:07; ctx fold; no nid
DUT_CTX_WALK     = NEW          8255a798… mtime 14:03:24; STREAM-02 copy + ctx keys
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02; NOT compiled
DUT_PAGE_SKIP    = UNEDITED     dab15d76… mtime 13:31:29 MATCH PAGE-SKIP; NOT compiled
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_DIR_FILE      = UNEDITED     09334e42… mtime 2026-09-05 19:31:03
C0_LEXICON_FILE  = UNEDITED     38189974… mtime 2026-09-05 20:51:03
C0_EXTRACT       = UNEDITED     cd7baf49… mtime 2026-09-05 19:48:18
RUNTIME_LEXICON  = C0_59_WORD   38189974… QSE2_N_LEX=59; xvlog -i C0 FIRST
BAG_LEXICON      = ABSENT
C0_PATCH         = MISS
NID_KEYS         = MISS
DUAL_INDEX_NO_CTX = MISS as cheat; HIT as 1-id plant / dual-index control
NOT_SELECTIVE_RELABEL = MISS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 4096
CTX1_COUNT       = 1 (nid 144 psc_water)
CTX2_COUNT       = 1 (nid 145 psc_indirect)
NOFOLD_EMIT      = {110,144,145}   (independent)
PACKED_AND       = {144}
NID_254_K0_IDX   = 20 (>=16)  EVIDENCE from corpus.json records
NID_254_K1_IDX   = 22 (>=16)
FIRST16_AND_LATE = {}          would miss
STREAM_AND_CAP   = {254}       hits
BOTH_LISTS       = YES
ENTITY_N         = 12 (clone; REJECT 800k)
N                = 256
PAGE_SKIP_KEEP   = UNMODIFIED GOLDEN 13:34:19 86b536fb6ce46d7ba6ffb59947822bf245d3253647be17664d22565dd31a566e CLOSEOUT 13:39:47
STREAM02_N256_KEEP   = UNMODIFIED GOLDEN 11:43:45 05c6e087e567146fc3f8da058370d8bfc5f7a9acfdebc1efaf6659b594f4b86b CLOSEOUT 11:45:37
DIR_FULL16_KEEP      = UNMODIFIED GOLDEN 12:44:33 2f6ab31e41837fd3fd283dab8ef57fea40602bd27719c07e0cd99f619a5eb6f5
N4096_STREAM_02_KEEP = UNMODIFIED GOLDEN 12:10:22 2a2db8c8dcb7ac1c9fb322a7d59d407a8892ef087499f96784f71c9f1dd5df06
N4096_INTERSECT_KEEP = UNMODIFIED GOLDEN 10:46:42 095ca7156c1f8efe60d1a2d689f93192271eb79bfb2747f3f12d2b90ea0f9dd3
KEY_INTERSECT_KEEP   = UNMODIFIED d3b5b883… 10:16:50
AXI_BEAT_KEEP        = UNMODIFIED max 11:11:09
INDEP_TREE           = UNMODIFIED PLAN/EVIDENCE ≤ 10:52:29
LEFTOVER_A09         = not compiled
POKE_V               = 0
SHA256_TXT_MISMATCHES = 0 / 30
```

Never ACCEPT_BOARD. Never close C1 800k. Never start semantic 16k / 800k / N=16384 in this audit. Independent PLAN bag 7 remains OPEN.
