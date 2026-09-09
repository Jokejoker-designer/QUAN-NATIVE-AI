# ASTRA auditor REPORT — 20260907T1550Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-SEMANTIC-HELDOUT-01
LAW        = qse-v2-intersect-context-02
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           INSTANTIATE DUT  a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             (STREAM-02 two-pointer copy; k2/k3 not probed; NOT edited)
LEXICON    = qse-v2-lex-semantic-16k-01 COPIED named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833… (mtime 14:49:07; NOT rewritten)
           include-name bag qse_role_lexicon.svh (shim `include of named file; same 14:49:07)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
KEEP       = ASTRA-C1-SEMANTIC-16K-01 (must be unmodified; GOLDEN 14:49:09 verified)
           + ASTRA-C1-CONTEXT-02 (must be unmodified; GOLDEN 14:12:02 verified)
           + ASTRA-C1-PAGE-SKIP-01 (must be unmodified; GOLDEN 13:34:19 verified)
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
           + ctx keys a7ng_query_role_keys_ctx.sv 124be808… (KEEP instantiate; NOT edited)
           + ctx DUT a7ng_query_axi_sparse_intersect_context.sv 8255a798… (KEEP instantiate as DUT; NOT edited)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1455Z/REPORT.md
           ACCEPT_PARTIAL (SEMANTIC-16K N=16384 formulaic grid; P1 none;
             parent MAY open OPTIONAL non-grid held-out rung)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-HELDOUT-01.md
EVIDENCE   = raw xsim.log FILL_TEMPLATE_HIT / PARAPHRASE_HIT / CLASS_* / EMIT_* /
             CONTEXT_SELECTIVE / NOT_SELECTIVE / LATE_GOLD_HIT /
             ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + STREAM-02 / CONTEXT-02 / PAGE-SKIP / SEMANTIC-16K GOLDEN
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP bags)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (mtime 14:03:07 NOT this bag)
           + INSTANTIATE DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (mtime 14:03:24 NOT this bag)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime 11:43:39; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_semantic_heldout.sv (poke_v, leftover A09, PASS conjunct)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx include order
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh / GOLDEN.json / corpus.json records / host_astra_c1_semantic_heldout.py
           + independent corpus exact-key postings for plain k0=3332/k1=3588 and packed k0=3380/k1=3636
             and nid 16382 (not RESULTS)
           + independent FILL_RE vs query texts + twin_role extract after skip-class (not RESULTS)
           + independent record-identity vs KEEP SEMANTIC-16K corpus.json (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SEMANTIC_HELDOUT = THIS BAG (N=16384 query-surface wrap of the 16k cartesian grid;
                   not true semantic hold-out; not Master close; not 800k)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = SURFACE_RUNG_THIS_GATE_ONLY (unseen-combination / 800k / N=65536 NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=16384 held-out query-surface** bag `ASTRA-C1-SEMANTIC-HELDOUT-01` after auditor `20260907T1455Z` ACCEPT_PARTIAL of SEMANTIC-16K (formulaic grid; P1 none) allowed parent to open OPTIONAL PLAN bag 7 remainder first slice.

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-HELDOUT-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=16384, gold **queries** whose *surface form is not* the cartesian `{ent} {rel} {ent}` fill used to build the 16k index, yet labeled nids still retrieve under instantiate ctx keys `124be808…` + DUT `8255a798…` (not edited); plus a fill-template control still hits. If `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve → FAIL.

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS` present. N actually 16384. `FILL_TEMPLATE_HIT` with tp>0. `PARAPHRASE_HIT` with tp>0.
2. Held-out retrieve-class query **texts** do **not** match `^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$`. Fill-template control **does** match that regex and still hits labeled gold. `SEARCH_INCOMPLETE` **ABSENT** on gold_n≥1 retrieve.
3. CLASS_wrong_context emit **≠** fill_template; labeled `CONTEXT_SELECTIVE` with `keys_match=0 emit_match=0`. `NOT_SELECTIVE` must not be relabeled PASS.
4. Late-gold nid **16382** in emit (`LATE_GOLD_HIT`); miss is FAIL, not `SEARCH_INCOMPLETE`.
5. Named lexicon `df0e8833…` **copied not rewritten**. C0 FILE `38189974…` unedited and **not** runtime. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` / ctx DUT `8255a798…` **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. C0 extract `cd7baf49…` unedited. KEEP SEMANTIC-16K corpus **unmodified**.
6. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
7. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. True semantic hold-out (unseen SRO combinations / synonyms / NL that binds different keys) remains **OPEN** and is **not started** by this audit.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/` (GOLDEN `0e539d48…` timestamp **14:49:09**; CLOSEOUT **15:18:52**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-CONTEXT-02/` (GOLDEN `8fc931f5…` timestamp **14:12:02**; CLOSEOUT **14:13:59**)
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
- Ctx keys `a7ng_query_role_keys_ctx.sv` = `124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1` (CONTEXT-02 MATCH instantiate; **not** edited)
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` = `8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989` (CONTEXT-02 MATCH instantiate as DUT; **not** edited)

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags including SEMANTIC-16K, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536, selling QSE skip-class WH-wrap as true semantic hold-out.

Hunt (dispatch, none dropped):

1. Gold queries still cartesian `{ent} {rel} {ent}` fill generator sold as held-out
2. Held-out is surface-only (QSE CLS_SKIP drops WH/function words; RELCTX `feed` aliases `feeds`) vs true semantic hold-out
3. Index not the 16k cartesian / KEEP SEMANTIC-16K corpus rewritten
4. Host `relevant=router_union` / nid-derived keys
5. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=65536 started
6. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
7. C0 lexicon FILE edited (`38189974` drift) / named lex `df0e8833` rewritten
8. Bag `qse_role_lexicon.svh` silent shadow vs copied named law
9. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys/DUT edited
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. Gold hashed after first xvlog / rewritten after FAIL
12. KEEP bags rewritten (SEMANTIC-16K first)
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Independent audit tree written by this implementer
16. Direct/fill emit is still `{110,144,145}` clone / late 16382 miss hidden by incomp

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=16384 held-out query-surface** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** an unseen-combination / non-grid SRO rung. Do **not** auto-start C1 800k / N=65536 from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. HELDOUT bag is untracked (`??`). KEEP SEMANTIC-16K / CONTEXT-02 remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1455Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T15:50:00+07:00` (file mtime **16:08:14**, parent-owned; auditor did not write it) `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-SEMANTIC-16K-01` `unblocked_item=ASTRA-C1-SEMANTIC-HELDOUT-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), HELDOUT bag:

```text
14:49:07.692  qse_role_lexicon_semantic_16k.svh   ← COPIED from SEMANTIC-16K; NOT rewritten
14:49:07.692  qse_role_lexicon.svh                ← include-name shim; same stamp as 16k
15:41:02.412  host_astra_c1_semantic_heldout.py
15:41:40.224  tb_astra_c1_semantic_heldout.sv
15:42:38.445  run_xsim.ps1
15:44:00.211  ACK.json
15:44:09.692  PREREG.md
15:44:21.669  corpus.json
15:44:21.671  GOLDEN.json
15:44:21.694  query_gold.svh
15:44:21.702  GOLD_HASH_PRE_XVLOG.txt             ← gold+named-lex hash BEFORE first xvlog
15:45:14.630  SHA256.txt                          ← freeze immediately before first xvlog
15:45:15.804  xvlog.log
16:05:08.432  xelab.log                           ← ~20 min elaborate
16:05:21.382  xsim.log                            PID 61968; session 16:05:09–16:05:21
16:06:53.125  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 / SEMANTIC-16K. This bag starts 15:41. Ctx keys were not rewritten for HELDOUT.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer**. Not rewritten.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag. Not rewritten.

Page-skip DUT LastWriteTime **2026-09-07 13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**. `role_lexicon.py` **2026-09-05 20:49:59.239** (host extends LEX **in memory** only).

Named lexicon LastWriteTime **14:49:07.692** — **identical** to KEEP SEMANTIC-16K named file stamp. Hash MATCH `df0e8833…`. Copied, not regenerated.

Single XSim session after one xvlog + one xelab. Gold files were **not** rewritten between 15:44:21 and 16:06:53 (hash MATCH PRE; LastWriteTime still 15:44:21). Named lexicon still 14:49:07. `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `38ed2631d50c650791d87334141465f39d3b19b2497b18f3967b8ce0d425b446` MATCH RESULTS `XSIM_SHA`.

No new C1-800k / N=65536 bag dirs. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane (mtime 2026-09-05), not this bag.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / KEEP DUT / copied lexicon

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  rtl/.../qse_role_lexicon.svh        (C0 FILE MATCH; mtime 2026-09-05 20:51:03)
                                                                 **NOT the compiled runtime table this bag**
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
                                                                  (CONTEXT-02 MATCH instantiate; mtime 14:03:07; NOT edited)
8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989  a7ng_query_axi_sparse_intersect_context.sv
                                                                  (CONTEXT-02 MATCH instantiate as DUT; mtime 14:03:24; NOT edited)
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
                                                                  **this IS the compiled runtime table; COPIED; mtime 14:49:07**
7966f321171cfe97b396ad90bb1ebd156c09a165782df40a3a98109ee59ac263  bag qse_role_lexicon.svh (one-line `include of named file)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7  a7ng_gate14_crc.svh
77598b15a5ab56cd455143af40afd855bfeae66f3b14cd92cb183e7b07f1ca70  tb_astra_c1_semantic_heldout.sv
502e88b7929f897de01032ecaf2c922b638334c11d0152ef8d3953e516ba6ea3  host_astra_c1_semantic_heldout.py
```

C0 extract / lexicon FILE MATCH `docs/ASTRA/authority/FINAL_CONTRACT.json` `ROLE_PARSER_LAW`. STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH. SEMANTIC-16K named lexicon `df0e8833…`. Live MATCH this bag copy.

`GOLD_HASH_PRE_XVLOG.txt` mtime **15:44:21.702** vs live gold+named-lex (all MATCH):

```text
3c1eda7d1639ef1d90e06d8eb799cd7f2a382cd42de1a4dd4319d131d3bcfcb4  GOLDEN.json
95be8b1b172096c16e4fe8b668e4f50b8bcaad0b116669edd513d9848800988a  query_gold.svh
45d239c792b616fb355b8d7c661e733879b8deb3776870aa800eedb8eccb5ed8  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
```

`xvlog.log` mtime **15:45:15.804**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 15:44:21). SHA256.txt freeze stamp `2026-09-07T15:45:14.5704253+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **33 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple). C0 lexicon FILE live MATCH `38189974…` independently. No invented hash.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 15:41+ |
|---|---|---|---|
| SEMANTIC-16K | `0e539d48be5862d0…` **14:49:09.278** | CLOSEOUT **15:18:52.927** | **UNMODIFIED** |
| CONTEXT-02 | `8fc931f5ac07a72f…` **14:12:02.956** | CLOSEOUT **14:13:59.927** | **UNMODIFIED** |
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19.424** | CLOSEOUT **13:39:47.345** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| DIR-FULL16 | `2f6ab31e41837fd3…` **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

KEEP SEMANTIC-16K `corpus.json` hash `2b5d3028…` mtime **14:49:09.276** — **not** this bag's `45d239c7…`. See §8: the **records** are bit-identical; only the JSON header `gate` field differs. KEEP file itself was not rewritten.

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** HELDOUT implementer did **not** write that tree. This auditor did **not** write that tree.

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
tb_astra_c1_semantic_heldout.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir, TB). Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

`work.rlx` include order for extract: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_16k.svh`. TB/DUT include_dirs: **bag ; control ; query**. Bag first.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; requires named lexicon + bag shim present; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (copied named lexicon law). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. Documented copy of `qse-v2-lex-semantic-16k-01`, **not** a silent C0 59-word claim.

TB instantiates `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `if (G_N_SUBJECTS < 100) diverge SEMANTIC_MASS` not taken. `if (G_N_RELS < 8) diverge SEMANTIC_MASS` not taken. `MEM_DEPTH=286517` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken.

PASS marker conjunct (TB line 551): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_sel && (fill_tp > 0) && fill_ids_ok && (para_tp > 0) && late_hit && late_ok && (incomp_retrieve == 0)`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. Wrong-context `emit_match || keys_match` → `NOT_SELECTIVE` **and** `FAIL WRONG_CONTEXT_NOT_SELECTIVE`. Late nid 16382 miss → `FAIL LATE_GOLD_MISS` even if incomp. Fill tp=0 → `FAIL FILL_TEMPLATE_GOLD_MISS`. Para tp=0 → `FAIL PARAPHRASE_GOLD_MISS`.

Live: `incomp=0` on every CLASS line that reports it (`incomp=0` count **10**); `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **0**; `incomp=1` count **0**. Hunt swallowed-incomp: **MISS this bag.**

### 5) PRIMARY HUNT — runtime lexicon is COPIED named 187-word, not rewritten, not C0 59-word

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
```

Named bag file `qse_role_lexicon_semantic_16k.svh`:

```text
QSE2_N_LEX = 187
hash       = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
mtime      = 2026-09-07 14:49:07.692   (same stamp as KEEP SEMANTIC-16K named file)
```

Host `write_named_lexicon()` **refuses to rewrite**: live SHA must MATCH `EXPECTED_LEX_NAMED=df0e8833…` and shim `7966f321…`. Hunt “named lex regenerated this bag”: **MISS.**

Bag `qse_role_lexicon.svh` is **three comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler` and **no** `feed`. Live CLASS_paraphrase query is `"what does the boiler feed to the header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13 or RELCTX feed→4. Hunt “C0 lexicon file edited”: **MISS.** Hunt “silent C0 59-word runtime claim”: **MISS.** Hunt “named lex rewritten”: **MISS.**

### 6) INSTANTIATE keys / DUT vs nid keys / STREAM-02 clone (hunts 9)

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. No nid port. Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through frozen `{subj,rel}`.

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. At `S_IDLE` with `qse_valid_o && !issued`: **`k0_r <= k0_o`**. `CAND_CAP` at emit. k2/k3 not used to issue AR.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys/DUT edited this bag”: **MISS** (mtime 14:03, this bag 15:41). Hunt “nid-derived keys”: **MISS** (RTL has no nid; one numeric coincidence nid 4356 `k0=4356` on fill row `damper feeds screen` = `pack_plain(17,4)` — not a nid key). Hunt “PAGE-SKIP compiled / mixed”: **MISS.**

Host gold: `gold_ids(docs, pred)` = nids with `evidence==1` matching an SRO/ctx **predicate**, computed **before** `route()` / walker twin. `relevant_is_router_union=false` in GOLDEN. Distractor polarity is **excluded** (`pred_excl`; leak=FAIL). Hunt `relevant=router_union`: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 16:05:09 2026**; exit **16:05:21**; PID **61968**; `$finish` at **39395 ns**; run elapsed **9 s**; peak sim memory **229 MB**.

Banner:

```text
C1_SEMANTIC_HELDOUT_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286517 N_SUBJECTS=120 N_RELS=8 HELDOUT=1 FILL_TEMPLATE_CONTROL=1
```

Named lines (verbatim authority):

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 … incomp=0
EMIT_fill_template n=3
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
PARAPHRASE_HIT tp=3 emit_n=3
CLASS_paraphrase gold_n=3 emit_n=3 tp=3 … incomp=0
EMIT_paraphrase n=3
  CAND paraphrase i=0 id=120 ev=1
  CAND paraphrase i=1 id=121 ev=1
  CAND paraphrase i=2 id=122 ev=1
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 id=123 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=124 incomp=0
CONTEXT_SELECTIVE class=wrong_context k0=3380 k1=3636 k2=1027 k3=3331 vs_fill_template k0=3332 k1=3588 k2=1024 k3=3328 keys_match=0 emit_match=0 law=qse-v2-intersect-context-02
CLASS_wrong_context gold_n=1 emit_n=1 tp=1 … incomp=0
EMIT_wrong_context n=1
  CAND wrong_context i=0 id=121 ev=1
CLASS_distractor gold_n=16 emit_n=3 leak_n=0 tp=0 … incomp=0 gold_polarity=excluded
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 … incomp=0
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=153 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=16383 incomp=0
LATE_GOLD_HIT id=16382
CAP_THEN_AND_WOULD_MISS id=16382 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 id=16382 occ=34 … incomp=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS=1`; `FILL_TEMPLATE_HIT=1`; `PARAPHRASE_HIT=1`; `LATE_GOLD_HIT=1`; `CONTEXT_SELECTIVE=1`; `NOT_SELECTIVE=0`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` in `xsim.log` = **0**; `FIRST_DIVERGENCE` = **0**; `incomp=1` = **0**.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_fill_template emit `{120,121,122}` tp=3 — **not** `{110,144,145}`. CLASS_paraphrase emit `{120,121,122}` tp=3 (same labels). CLASS_wrong_context emit `{121}` `keys_match=0 emit_match=0` labeled `CONTEXT_SELECTIVE` not `NOT_SELECTIVE`. Late emit `{16382}` `LATE_GOLD_HIT`. Conjunctive gate holds on raw. N banner = 16384. Hunt “N not actually 16384”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=120` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_LATE_GOLD_ID=16382` `G_LATE_K0_IDX=16` `G_LATE_K1_IDX=33` `G_CTX[4]=3` `G_CTX_VALID[4]=1`. `G_LEN = {19,39,39,35,38,19,16,36,36,33,38}` MATCH independent `len(query text)`. `G_SUBJ/G_REL/G_OBJ` for q0 and q1 both `{13,4,14}`. `G_K0[0]=G_K0[1]=16'h0D04` `G_K1[0]=G_K1[1]=16'h0E04`. `G_K0[4]=16'h0D34` (ctx nibble 3). Fill bytes LSB-first `"boiler feeds header"` (len 19, char0=`b`=0x62). Paraphrase bytes LSB-first `"what does the boiler feed to the header"` (len 39, char0=`w`=0x77).

### 8) Independent corpus — index IS the SEMANTIC-16K cartesian grid; KEEP unmodified; queries are surface wraps

Authority = live `corpus.json` **records** (hash `45d239c7…`) vs KEEP SEMANTIC-16K records (hash `2b5d3028…`), **not** RESULTS.

```text
n records HELDOUT     = 16384 (nid 0..16383 contiguous)
n records SEMANTIC-16K = 16384
record_key mismatches  = 0 of 16384
field diffs            = {}          (every record field identical)
header DIFF            = gate only
                         H=ASTRA-C1-SEMANTIC-HELDOUT-01
                         S=ASTRA-C1-SEMANTIC-16K-01
                         all other header fields SAME (n, n_subjects=120, n_rels=8,
                         late_gold_nid=16382, k0_idx=16, k1_idx=33, law, lexicon_law)
```

**FACT:** HELDOUT index is the same cartesian 16k generator **records** as SEMANTIC-16K. Corpus.json hash differs **only** because the header `gate` string changed. KEEP SEMANTIC-16K `corpus.json` file itself is **unmodified** (`2b5d3028…` / 14:49:09).

Index fill regex: **16384/16384** texts MATCH `^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$`. Unique texts = 16327. kinds: semantic_core 120 / fill 16196 / + planted specials. ev1 subj `{13..132}` n=120; rel `{1..8}` n=8. PSC text count = 0. ctx_id `{0:16382, 3:1, 4:1}`. Packing `k0_plain==(subj<<8)|rel` on all 16384: **0** failures. Wrap `subj_id != (subj_id & 0xFF)`: **0**. nid-eq-key coincidences: **1** (nid 4356 `damper feeds screen`).

Planted control rows (independent, MATCH 16k):

```text
nid 120  text="boiler feeds header"            ctx=0  k0=3332 k1=3588  kind=direct_plain
nid 121  text="boiler feeds header glycol"     ctx=3  k0=3380 k1=3636  kind=direct_glycol
nid 122  text="boiler feeds header steam"      ctx=4  k0=3396          kind=direct_steam
nid 123  text="header feeds boiler"            ctx=0  k0=3588          kind=role_reverse
nid 124  text="boiler isolates header"         ctx=0  k0=3333          kind=wrong_rel
nid 16382 text="cyclone discharges beacon"     ctx=0  k0=33544 k1=33800 kind=late_gold
nid 16383 text="hopper isolates silo"          ctx=0                   kind=high_id_sentinel
```

Independent gold (evidence=1 ∧ SRO/ctx pred, **before** walker):

```text
fill/paraphrase labels = {120,121,122}
role_reversal          = {123}
wrong_relation         = {124}
wrong_context          = {121}
late                   = {16382}
```

MATCH GOLDEN `relevant` and raw emit for retrieve classes.

Host dual-index (always plain k0/k1; **also** packed k0/k1 if record `ctx_valid`):

```text
plain k0=3332 occ=121
plain k1=3588 occ=18
plain AND            = {120,121,122}          ← CLASS_fill_template / CLASS_paraphrase

packed k0=3380 occ=1
packed k1=3636 occ=1
packed AND           = {121}                  ← CLASS_wrong_context
```

Late gold nid 16382 (`cyclone discharges beacon`, k0=33544=`0x8308`, k1=33800=`0x8408`, ctx=0):

```text
k0 occ=17  index of 16382 = 16  (>=16)
k1 occ=34  index of 16382 = 33  (>=16)
full ∩              = {16382}
first16 ∩ first16   = {}          16382 NOT in first16 of either list
```

MATCH raw `LATE_GOLD_HIT id=16382` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0`. Hunt late-gold miss hidden: **MISS.**

### 9) Query texts vs fill regex — surface-only (QSE drops WH) vs true semantic hold-out

FILL_RE = `^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$` (WO / host). Independent on GOLDEN query texts:

| class | text | FILL_RE | ntok | extract SRO |
|---|---|---|---|---|
| fill_template | `boiler feeds header` | **MATCH** (control) | 3 | 13/4/14 |
| paraphrase | `what does the boiler feed to the header` | **NO** | 8 | 13/4/14 **same keys 3332/3588** |
| role_reversal | `what does the header feed to the boiler` | **NO** | 8 | 14/4/13 |
| wrong_relation | `does the boiler isolates the header` | **NO** | 6 | 13/5/14 |
| wrong_context | `does the boiler feed the header glycol` | **NO** | 7 | 13/4/14 ctx=3 keys 3380/3636 |
| distractor | `boiler feeds header` | MATCH (excluded polarity; not claimed held-out) | 3 | 13/4/14 |
| unrelated | `payroll tax form` | MATCH (3-token OOV; empty walk; not a retrieve class) | 3 | 0/0/0 |
| high_occupancy | `does the damper modulates the grille` | **NO** | 6 | 17/7/18 |
| overflow_page | `does the strainer bypasses the riser` | **NO** | 6 | 21/6/20 |
| high_id_sentinel | `does the hopper isolates the silo` | **NO** | 6 | 93/5/94 |
| late_gold | `does the cyclone discharges the beacon` | **NO** | 6 | 131/8/132 |

WO required held-out retrieve classes **not** match FILL_RE, fill-template control **does**. **MET** on paraphrase / role_reversal / wrong_relation / wrong_context / high_occupancy / overflow / sentinel / late_gold. Distractor is the excluded-polarity control using the fill surface (disclosed). Unrelated is OOV empty-walk; coincidentally 3 lowercase tokens so FILL_RE matches — **not** a retrieve-class FAIL.

Independent twin_role extract (named 187-word table in memory, C0 skip-class intact) on paraphrase:

```text
tokens = what/SKIP, does/SKIP, the/SKIP, boiler/ENT:13, feed/RELCTX:4, to/SKIP, the/SKIP, header/ENT:14
kept   = boiler, feed, header
extract s=13 r=4 o=14 ctx=0 n_host=0
keys   = k0=3332 k1=3588   IDENTICAL to fill_template "boiler feeds header"
```

C0 skip words (FILE, unedited): `a an the to of does what is do for and`. Named table adds RELCTX `feed` id=4 (after subject → CLS_REL). Frozen extract **drops WH/function words** and aliases `feed`/`feeds` to the same rel id. Remaining **content tokens are the cartesian SRO**.

SEMANTIC-16K paraphrase was `"the boiler feeds the header"` (article insertion only). This bag's paraphrase adds WH-words + morphological `feed`. Both bind the **same** keys as the fill row. Index rows remain `{ent} {rel} {ent}`. No unseen SRO, no synonym that is not a lexicon alias, no NL that would retrieve a different nid set than the fill control.

**FACT:** this is **held-out query surface** (WO text). It is **not** true semantic hold-out.

WO itself discloses the intended path: “Frozen extract still binds the held-out strings to the same SRO as the fill rows (skip-class function words + RELCTX `feed` after subject).” Implementer RESULTS/CLOSEOUT name the unknown as query **surface**. Hunt “sold as true semantic / Master mass”: **MISS as claim** (RESULTS §Honesty: “Index is still a cartesian HVAC-word grid”; “unknown closed here is only: held-out query surface”). Hunt “gold queries still cartesian fill”: **MISS on retrieve-class texts** (FILL_RE NO); **HIT on index** (16384/16384 still the template; records identical to 16k).

### 10) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`fill_template {120,121,122}` tp=3 incomp=0; `PARAPHRASE_HIT` tp=3 emit `{120,121,122}`; `CONTEXT_SELECTIVE` k0=3380/k1=3636 vs 3332/3588 keys_match=0 emit_match=0; wrong_context emit `{121}`; `LATE_GOLD_HIT id=16382` incomp=0; distractor `leak_n=0 gold_n=16`; unrelated empty-walk). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD. `TWELVE_ENTITY_CLONE=NO` MATCH independent. `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `NOT_SELECTIVE` is **ABSENT** this bag (not relabeled).

Implementer prose that skip-class + RELCTX `feed` still binds subj=13 rel=4 obj=14, and that the index remains the cartesian generator: **HONEST vs independent extract + record identity.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat). Hunt `NOT_SELECTIVE` relabeled PASS: **MISS.** Hunt “true semantic hold-out closed”: **MISS as claim**; **HIT as quality bound** (surface-only; see §9).

CLOSEOUT MATCH raw: marker present, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` instantiate, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…` copied mtime 14:49:07, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 15:44:21 PRE before xvlog 15:45:15. Independent tree claim `max mtime 10:52:29` MATCH live. KEEP SEMANTIC-16K GOLDEN 14:49:09 / CLOSEOUT 15:18:52 MATCH live.

Host `n_post` vs DUT `postB/16` residual (fill GOLDEN n_post=36 vs DUT postB=512→32 beats). Same residual as SEMANTIC-16K. This bag did not register AXI-beat identity. P2, not emit FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Gold queries still cartesian fill sold as held-out | **MISS on retrieve-class query texts.** Paraphrase/role/wrong_rel/wrong_ctx/hoc/ovf/sentinel/late FILL_RE=NO. Fill-template control FILL_RE=YES and hits. **HIT on index:** 16384/16384 still `{ent} {rel} {ent}`; records identical to 16k. | WO asked query surface ≠ fill regex — **met**. Unseen SRO combinations **not** this bag. |
| 2. Surface-only (QSE drops WH) vs true semantic hold-out | **HIT as quality / promotion bound. MISS as registered-unknown FAIL.** Independent: paraphrase kept tokens = `{boiler, feed, header}`; keys **identical** to fill `3332/3588`; emit `{120,121,122}` = fill. Skip words `what/does/the/to`. RELCTX `feed` aliases `feeds`. Other held-out classes are `"does the {ent} {rel} the {ent}"` wraps of the planted fill rows. | WO is surface form. Illegal as Master ≥95% / “semantic generalization” / unseen-combination close. |
| 3. Index not 16k cartesian / KEEP 16k corpus rewritten | **MISS.** Record identity 0 mismatches / 0 field diffs vs KEEP 16k records. KEEP corpus file hash `2b5d3028…` mtime 14:49:09 **UNMODIFIED**. HELDOUT corpus hash differs only by header `gate`. | Do not edit KEEP 16k. Next bag that needs a new index is a new bag. |
| 4. `relevant=router_union` / nid keys | **MISS.** `gold_ids` = evidence=1 ∧ SRO/ctx pred before `route()`. GOLDEN `relevant_is_router_union=false`. nid-eq-key coincidences=1 (4356). | Keep independent labels. |
| 5. C1 800k / bounds / ACCEPT_BOARD / N=65536 started | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag. | Never grant. Never freeze. Never auto-start 800k. |
| 6. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0 on retrieve classes; conjunct includes `incomp_retrieve==0` and `para_tp>0` and `fill_tp>0`. | Keep miss as FAIL on later bags. |
| 7. C0 lexicon FILE edited / named lex rewritten | **MISS.** Live `38189974…` mtime 2026-09-05 20:51:03; named `df0e8833…` mtime 14:49:07 MATCH 16k copy; host refuses rewrite. | Do not edit C0. Do not regenerate named lex. |
| 8. Silent bag lexicon shadow | **MISS as silent C0 claim.** Copied named law; PRE hashes named file; xvlog bag-first disclosed; C0 cannot tokenize `boiler`/`feed` but live did. | Keep named-law discipline. |
| 9. STREAM-02 / ctx keys / ctx DUT edited or STREAM-02 compiled | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` / `8255a798…` mtime 14:03, this bag 15:41. | Hash mismatch ⇒ FAIL, do not patch. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 11. Gold after FAIL / after xvlog | **MISS.** PRE 15:44:21; xvlog 15:45:15; gold still 15:44:21; named lex still 14:49:07; no r0. | Do not regenerate gold. |
| 12. KEEP bags mutated | **MISS.** SEMANTIC-16K GOLDEN **14:49:09** `0e539d48…` CLOSEOUT **15:18:52**; CONTEXT-02 GOLDEN **14:12:02**; PAGE-SKIP 13:34:19; STREAM-02 11:43:45; DIR-FULL16 12:44:33; N4096-STREAM-02 12:10:22; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 13. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Surface-path prose MATCH independent extract. | Authority = raw CLASS_* + FILL_TEMPLATE_HIT + PARAPHRASE_HIT + CONTEXT_SELECTIVE + LATE_GOLD_HIT + independent postings + FILL_RE. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 33/33 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…`). | SHA256.txt 15:45:14 is the first-xvlog freeze. |
| 15. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 15:41. | Keep that tree read-only. |
| 16. Fill `{110,144,145}` clone / late 16382 miss | **MISS.** Raw fill `{120,121,122}` tp=3; paraphrase `{120,121,122}` tp=3; independent plain AND `{120,121,122}`; `LATE_GOLD_HIT id=16382` incomp=0; idx 16 and 33. | Identity control, not Master ≥95%. |
| Host dual-index tautology (emit differs **without** query ctx) | **MISS as no-ctx cheat** (same geometry as 16k: packed AND `{121}` vs plain `{120,121,122}`). **HIT as construction/quality:** corpus `ctx_id==3` count = **1**. | Dual-index is the index-side of the law. Selectivity is 1-id identity. |
| CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩={} and 16382 at 16 and 33). | Same geometry as SEMANTIC-16K / STREAM-02. |
| Direct/fill prec=1000 is 3-id identity; wc prec=1000 is 1-id identity | **HIT as quality caveat.** Fill labels = plain k0∩k1; paraphrase labels **copied** from fill (`gold_map paraphrase == fill_template`). | Not Master ≥95%. Paraphrase hit is a skip-class identity, not a new gold set. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| Unrelated FILL_RE match (`payroll tax form`) | **HIT as regex nit.** 3 lowercase OOV tokens match the cartesian regex. Not a retrieve class; empty-walk holds. | Do not cite unrelated as a held-out retrieve. |
| 16k paraphrase was already article-insertion | **HIT as incremental-surface.** This bag adds WH + `feed` RELCTX. Still same keys. | PLAN bag7 “held-out combinations / real mass” remains OPEN. |

qstack-validation-adversary one-liner: **SEMANTIC-HELDOUT-01 XSim is a real N=16384 host+instantiate lock on unpatched C0 extract (`cd7baf49…`) with a **copied** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…` mtime 14:49:07 **not rewritten**, bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime): frozen ctx keys `124be808…` and ctx DUT `8255a798…` instantiated not edited; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; independent corpus records **bit-identical** to KEEP SEMANTIC-16K (header `gate` only differs; KEEP corpus file `2b5d3028…` 14:49:09 unmodified); CLASS_fill_template emit `{120,121,122}` (`boiler feeds header`, FILL_RE MATCH, `FILL_TEMPLATE_HIT` tp=3 incomp=0); CLASS_paraphrase emit `{120,121,122}` (`what does the boiler feed to the header`, FILL_RE NO, `PARAPHRASE_HIT` tp=3 incomp=0) with independent skip-class remaining tokens `{boiler, feed, header}` and **identical keys 3332/3588**; bound `"does the boiler feed the header glycol"` walks packed k0=3380=`0x0D34` k1=3636=`0x0E34` and emits `{121}` (`CONTEXT_SELECTIVE keys_match=0 emit_match=0`); late-gold nid 16382 `does the cyclone discharges the beacon` at k0 index 16 **and** k1 index 33 still emits (`LATE_GOLD_HIT`, first16∩={}, `SEARCH_INCOMPLETE` ABSENT); leftover A09 off; poke_v=0; gold PRE 15:44:21 before xvlog 15:45:15; KEEP SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 unmodified; independent tree ≤10:52:29; that is **held-out query surface** (QSE drops WH), **not** true semantic hold-out, not C1 800k, not ACCEPT_BOARD, and still an axi_mem_model / 8-bit-id / 1-id ctx plant / 3-id identity / cartesian-grid rung.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / paraphrase `{120,121,122}` / wrong_context `{121}` / late `{16382}`). Findings are **law-quality / promotion bounds / PLAN-shape residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **N=16384 was actually hosted.** `G_N=16384`; corpus 16384; banner 16384; MEM_DEPTH 286517 TB-only; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 clone.
2. **Fill-template control still hits.** `"boiler feeds header"` FILL_RE MATCH; emit `{120,121,122}` tp=3 incomp=0; independent plain AND `{120,121,122}`. Marker requires `fill_tp>0` and bit-identical fill emit.
3. **Paraphrase surface is not the fill regex and still retrieves the same labels.** `"what does the boiler feed to the header"` FILL_RE NO; emit `{120,121,122}` tp=3; keys identical to fill. Marker requires `para_tp>0`.
4. **That paraphrase path is QSE skip-class + RELCTX alias, not semantic generalization.** Independent tokens: WH/function words SKIP; kept `{boiler, feed, header}`; `feed` CLS_RELCTX id=4 after subject = same rel as `feeds`. Other held-out classes are `"does the … the …"` wraps of planted fill triples. WO surface unknown **met**. True semantic / unseen-combination unknown **not this bag**.
5. **Index is the SEMANTIC-16K cartesian grid, not a new corpus.** 0 record mismatches vs KEEP 16k; KEEP file unmodified. 16384/16384 texts still `{ent} {rel} {ent}`.
6. **Query ctx fold is a real discriminator vs fill_template.** Independent packed AND `{121}` vs plain `{120,121,122}`; live `CONTEXT_SELECTIVE keys_match=0 emit_match=0`; NOT_SELECTIVE absent. Selectivity is still a planted singleton (`ctx=3` count=1).
7. **Late gold 16382 survived instantiate** (unbound, ctx=0, plain keys) under the held-out surface `"does the cyclone discharges the beacon"`. Both-list index ≥16; first16∩={}; emit `{16382}` incomp=0.
8. **Runtime lexicon is COPIED named 187-word.** C0 FILE unedited. Named file mtime 14:49:07 MATCH 16k; host SHA-gates and does not rewrite. xvlog bag-first documented.
9. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the context DUT master. `N_BUCKETS=65536` is a parameter instantiate of unedited `09334e42…`.
10. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
11. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
12. **8-bit key packing (`& 0xFF`, 4-bit ctx/rel nibble)** did not collapse this 120-id set. Residual if ids >255.
13. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
14. **12-entity clone is gone; formulaic grid + axi_mem_model + 1 planted ctx=3 row + 3-id identity + skip-class surface wrap remain the promotion stop.** PLAN bag 7 surface slice is “query text ≠ fill regex, still retrieve, fill control hits, no incomp” — **closed as PASS_NARROW**. 800k / N=65536 / unseen-combination NL are **not** closed and **not** started by this audit.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| INSTANTIATE keys (`124be808…`, not edited) | **PASS_NARROW** | mtime 14:03:07; this bag 15:41. Live 3332→3380 is the nibble insert of named glycol id=3. |
| INSTANTIATE DUT (`8255a798…`, not edited, not STREAM-02 file) | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02 / 16k. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` incomp=0 | **PASS_NARROW** | Cartesian control still hits. Independent plain AND `{120,121,122}`. |
| PARAPHRASE_HIT tp=3 emit `{120,121,122}` incomp=0; FILL_RE NO | **PASS_NARROW of surface unknown** | Same labels/keys as fill. QSE skip WH + RELCTX `feed`. |
| Independent wc AND: packed k0=3380 ∩ k1=3636 = `{121}` | **PASS_NARROW** | Query ctx is necessary. Dual-index is the control, not a no-ctx cheat. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys/DUT freeze (mtime 14:03, this bag 15:41) | **PASS_NARROW** | Instantiated, not edited. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. |
| Copied lexicon **runtime** = `df0e8833…` 187-word mtime 14:49:07; C0 FILE `38189974…` unedited NOT runtime | **PASS_NARROW** | Copied not rewritten. C0 cannot name boiler/feed; live did. |
| KEEP SEMANTIC-16K corpus unmodified; HELDOUT records bit-identical | **PASS_NARROW / UNMODIFIED** | Hash differs by header `gate` only. KEEP file 14:49:09 `2b5d3028…`. |
| Registered unknown (query surface ≠ fill regex **and** paraphrase hits **and** fill-template hits **and** SEARCH_INCOMPLETE ABSENT **and** LATE_GOLD 16382) | **PASS_NARROW** | Raw FILL_TEMPLATE_HIT tp=3; PARAPHRASE_HIT tp=3; CONTEXT_SELECTIVE present; NOT_SELECTIVE absent; `LATE_GOLD_HIT id=16382`; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or true semantic. |
| True semantic hold-out / unseen SRO / NL that binds different keys | **HIT as quality bound, MISS as this-unknown FAIL** | WO surface met. PLAN held-out combinations not met. |
| Dual-index no-ctx tautology / nid keys / NOT_SELECTIVE relabel / 12-clone / N-drop / gold=router_union | **MISS (not FAIL of this unknown)** | Fold is live; nid unused; NOT_SELECTIVE not printed; N=16384; PSC=0; gold is evidence∧SRO pred. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; conjunct includes `incomp_retrieve==0`. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Fill/para 1000 is 3-id identity; wc 1000 is 1-id identity; formulaic grid; reduction not emitted; skip-class identity. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | Surface wrap of cartesian grid / 8-bit ids / axi_mem_model / ctx=3 count=1. This audit does not start next bags. PLAN bag 7 remainder OPEN. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 15:44:21; xvlog 15:45:15; gold 15:44:21 KEEP `3c1eda7d…`; named lex `df0e8833…`; no r0. |
| KEEP SEMANTIC-16K + CONTEXT-02 + PAGE-SKIP + STREAM-02 + DIR-FULL16 + N4096-STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT + stream DUT + page-skip DUT + ctx keys + ctx DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1455Z / C0. SEMANTIC-16K GOLDEN **14:49:09**. STREAM-02 GOLDEN **11:43:45**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=16384 held-out **query surface** on instantiate `qse-v2-intersect-context-02` + copied named lexicon `qse-v2-lex-semantic-16k-01`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word **copied not rewritten** mtime 14:49:07; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; CLASS_fill_template `{120,121,122}` `"boiler feeds header"` FILL_RE MATCH `FILL_TEMPLATE_HIT` tp=3; CLASS_paraphrase `{120,121,122}` `"what does the boiler feed to the header"` FILL_RE NO `PARAPHRASE_HIT` tp=3 with skip-class remaining tokens `{boiler, feed, header}` and **same keys as fill**; CLASS_wrong_context emit `{121}` ≠ fill with live `CONTEXT_SELECTIVE keys_match=0 emit_match=0`; late-gold 16382 still emits at k0 idx 16 and k1 idx 33 under held-out surface `"does the cyclone discharges the beacon"`; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` / ctx DUT `8255a798…` unedited instantiate; dir file `09334e42…` unedited; KEEP SEMANTIC-16K unmodified including corpus records identity; independent tree ≤10:52:29; RESULT=`PASS_THIS_GATE_ONLY` honest; N actually 16384; **not** 12-entity / PSC clone; gold is **not** router_union and **not** nid keys). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “true semantic hold-out / unseen-combination NL closed”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, named lex not rewritten, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, NOT_SELECTIVE not relabeled, PASS is honest, late gold both-list, SEARCH_INCOMPLETE absent, N not dropped, lexicon copied). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k; surface path disclosed; FILL_RE hunt fails on retrieve-class texts; KEEP 16k unmodified). **Not** FAIL of the query-surface unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** an unseen-combination / non-grid SRO rung of PLAN bag 7. Do **not** auto-start 800k / N=65536. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-HELDOUT-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-SEMANTIC-16K-01` / `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB=512. **Do not rewrite** named lexicon `df0e8833…`.

**P1 — none for this unknown** (independent FILL_TEMPLATE_HIT tp=3; PARAPHRASE_HIT tp=3; retrieve-class FILL_RE=NO; fill control FILL_RE=YES; packed AND `{121}` vs plain AND `{120,121,122}`; CLASS_fill `{120,121,122}`; CONTEXT_SELECTIVE keys_match=0 emit_match=0; NOT_SELECTIVE absent; LATE_GOLD 16382 at k0 index 16 and k1 index 33; SEARCH_INCOMPLETE ABSENT; ctx keys/DUT not edited; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; named lexicon copied not rewritten; gold PRE before xvlog; KEEP 16k records unmodified).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=16384 held-out **query surface** (skip-class WH-wrap + RELCTX `feed`) on the frozen 16k cartesian index. Authority = raw `FILL_TEMPLATE_HIT` / `PARAPHRASE_HIT` / `CONTEXT_SELECTIVE` / `CLASS_fill_template {120,121,122}` / `EMIT_paraphrase {120,121,122}` / `EMIT_wrong_context {121}` / `LATE_GOLD_HIT id=16382` / `SEARCH_INCOMPLETE` ABSENT + independent FILL_RE + twin_role skip-class remaining tokens + KEEP 16k record identity + named lex `df0e8833…`. Do not silent-patch STREAM-02 / CONTEXT-02 / SEMANTIC-16K / C0.
2. **Do not sell this as true semantic hold-out, unseen-combination mass, or PLAN bag7 close.** Index is the same 120-word HVAC cartesian grid; paraphrase remaining tokens = fill SRO; ctx=3 count=1. Next “semantic” bag that claims hold-out **combinations** must use gold queries whose **bound keys / labeled nids are not** the fill-template control’s SRO (not another `"does the {ent} {rel} the {ent}"` wrap).
3. **Parent MAY open OPTIONAL next:** an unseen-combination / non-grid SRO rung (still PLAN bag 7, still not 800k). One unknown. **Not this audit. Do not start 800k / N=65536 from this close.** Independent PLAN bag 7 remainder remains **OPEN**.
4. **Do not auto-start C1 800k / N=65536 / BOARD_PASS.** Formulaic grid + skip-class surface + 8-bit ids + `axi_mem_model` + singleton ctx plant are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused this bag; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on several classes.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `CONTEXT_SELECTIVE` vs `NOT_SELECTIVE` (FAIL if emit_match or keys_match); `FILL_TEMPLATE_HIT` / `PARAPHRASE_HIT` required; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; named lexicon copied not rewritten; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`; retrieve-class query FILL_RE MATCH FAILs as not-held-out.
7. Next bag should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02 / CONTEXT-02 / SEMANTIC-16K.
8. If a later law must use subject ids >255, or more than 4 bits of ctx/rel, or walk k_ctx as a third list, or bind synonyms that are not lexicon aliases, that is a **new** named module / new bag. Do not silent-patch `a7ng_query_role_keys_ctx.sv` or C0 extract. Do not grow `& 0xFF` packing past the 8-bit port. Do not rewrite `df0e8833…` in place.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including SEMANTIC-16K GOLDEN 14:49:09 (formulaic grid `{120,121,122}` / `{121}` / 16382), CONTEXT-02 GOLDEN 14:12:02, PAGE-SKIP GOLDEN 13:34:19, STREAM-02 N=256 nid 254 at 20/22, DIR-FULL16 GOLDEN 12:44:33 stay on disk as evidence of prior process.
11. Optional: print DUT `n_post` vs host `n_post` on CLASS lines so the 36-vs-32 residual is not rediscovered. Optional: exclude 3-token OOV unrelated from FILL_RE “held-out surface” rhetoric. Neither is a this-bag FAIL.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=16384 held-out QUERY SURFACE
                         on qse-v2-intersect-context-02 instantiate
                         + copied named lexicon qse-v2-lex-semantic-16k-01;
                         N actually 16384 contiguous; G_N=16384; banner N=16384;
                         MEM_DEPTH=286517 TB-only; FIRST_DIVERGENCE MEM ABSENT;
                         INSTANTIATE keys a7ng_query_role_keys_ctx 124be808…
                           mtime 14:03:07 NOT this bag; NOT edited;
                         INSTANTIATE DUT a7ng_query_axi_sparse_intersect_context 8255a798…
                           mtime 14:03:24 NOT this bag; NOT edited;
                           k0_r <= k0_o; STREAM-02 two-pointer copy;
                           k2/k3 not probed; NOT page-skip; NOT 14f75db7 file;
                         STREAM-02 a7ng_query_axi_sparse_stream_intersect 14f75db7…
                           MATCH STREAM-02; mtime 11:43:39 NOT newer than N=256 bag;
                           NOT compiled as DUT;
                         PAGE-SKIP a7ng_query_axi_sparse_page_skip dab15d76…
                           MATCH PAGE-SKIP; mtime 13:31:29; NOT compiled as DUT;
                         frozen dir FILE 09334e42… mtime 2026-09-05 19:31:03 NOT patched;
                         C0 lexicon FILE 38189974… QSE2_N_LEX=59
                           mtime 2026-09-05 20:51:03 UNEDITED; NOT runtime;
                         C0 extract cd7baf49… mtime 2026-09-05 19:48:18 UNEDITED;
                         COPIED lexicon RUNTIME df0e8833… QSE2_N_LEX=187
                           mtime 14:49:07 MATCH SEMANTIC-16K copy; NOT rewritten;
                           xvlog -i $bag FIRST documented;
                           bag qse_role_lexicon.svh is include-name shim 7966f321…;
                           C0 cannot tokenize boiler/feed; live CLASS_paraphrase did;
                         FILL_TEMPLATE_HIT tp=3 emit={120,121,122} incomp=0
                           text="boiler feeds header" FILL_RE MATCH
                           NOT {110,144,145};
                         PARAPHRASE_HIT tp=3 emit={120,121,122} incomp=0
                           text="what does the boiler feed to the header" FILL_RE NO
                           keys k0=3332 k1=3588 IDENTICAL to fill;
                           independent skip-class remaining tokens
                             {boiler ENT:13, feed RELCTX:4, header ENT:14};
                         CONTEXT_SELECTIVE class=wrong_context
                           k0=3380 k1=3636 vs_fill_template k0=3332 k1=3588
                           keys_match=0 emit_match=0;
                         CLASS_wrong_context emit={121} gold_n=1 tp=1 incomp=0
                           text="does the boiler feed the header glycol";
                         NOT_SELECTIVE ABSENT (not relabeled);
                         independent:
                           HELDOUT records bit-identical to KEEP SEMANTIC-16K
                             (0 mismatches / 0 field diffs; header gate only);
                           KEEP 16k corpus file 2b5d3028… 14:49:09 UNMODIFIED;
                           16384/16384 index texts template {ent} {rel} {ent};
                           fill cartesian 16196; pad_synth=0;
                           ev1 subj n=120 ids 13..132; rel n=8;
                           PSC text count=0;
                         dual-index plain AND={120,121,122};
                         packed AND={121};
                         gold_ids = evidence=1 ∧ SRO/ctx pred BEFORE walker;
                         relevant_is_router_union=false;
                         LATE_GOLD nid 16382 "does the cyclone discharges the beacon"
                           k0=33544=0x8308 occ=17 idx=16;
                           k1=33800=0x8408 occ=34 idx=33;
                         first16∩first16 = {}; complete∩ = {16382};
                         raw LATE_GOLD_HIT id=16382 CAP_THEN_AND_WOULD_MISS stream_hit=1
                           CLASS_late_gold emit={16382} tp=1 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold 3c1eda7d… 15:44:21 PRE before xvlog 15:45:15;
                         named lex df0e8833… 14:49:07 PRE (copied);
                         KEEP SEMANTIC-16K GOLDEN 14:49:09 0e539d48… CLOSEOUT 15:18:52;
                         KEEP CONTEXT-02 GOLDEN 14:12:02 8fc931f5…;
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
                            not CAND_CAP_FINAL, not N=65536,
                            not Master ≥95% recall,
                            not Master ≥90% reduction,
                            not ACCEPT_BOARD, not BOARD_PASS,
                            not true semantic hold-out / unseen-combination NL;
                            skip-class surface wrap of cartesian grid
                            + axi_mem_model + ctx=3 count=1 remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   surface path disclosed; FILL_RE hunt MISS on retrieve texts;
                   KEEP 16k unmodified; 12-clone hunt MISS; N-drop hunt MISS;
                   silent-C0 hunt MISS; named-lex rewrite hunt MISS;
                   NOT_SELECTIVE not relabeled; gold≠router_union;
                   HIT as quality: QSE drops WH; remaining tokens = fill SRO;
                   not true semantic hold-out)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL unseen-combination / non-grid SRO rung of PLAN bag 7
                   (do NOT auto-start C1 800k / N=65536;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
PLAN_BAG7_SEMANTIC = SURFACE_RUNG_PASS_THIS_GATE_ONLY (remainder OPEN)
N_16384          = THIS_BAG (index = KEEP 16k cartesian records)
N_65536          = NOT_STARTED
SEMANTIC_HELDOUT_XSIM = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_SEMANTIC_HELDOUT_XSIM_PASS PRESENT
                   PID 61968; 39395 ns; 16:05:09–16:05:21; elapsed 9 s
                   xsim.log SHA256 38ed2631d50c650791d87334141465f39d3b19b2497b18f3967b8ce0d425b446
                   FILL_TEMPLATE_HIT tp=3 emit {120,121,122} incomp=0
                   PARAPHRASE_HIT tp=3 emit {120,121,122} incomp=0
                   CONTEXT_SELECTIVE k0=3380 k1=3636 keys_match=0 emit_match=0
                   EMIT_wrong_context {121}
                   NOT_SELECTIVE ABSENT
                   LATE_GOLD_HIT id=16382 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 15:44:21; named lex 14:49:07;
                                PRE MATCH live; no r0; PASS session
DUT_CTX_KEYS     = UNEDITED     124be808… mtime 14:03:07 MATCH CONTEXT-02; instantiated
DUT_CTX_WALK     = UNEDITED     8255a798… mtime 14:03:24 MATCH CONTEXT-02; instantiated as DUT
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02; NOT compiled
DUT_PAGE_SKIP    = UNEDITED     dab15d76… mtime 13:31:29 MATCH PAGE-SKIP; NOT compiled
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_DIR_FILE      = UNEDITED     09334e42… mtime 2026-09-05 19:31:03
C0_LEXICON_FILE  = UNEDITED     38189974… mtime 2026-09-05 20:51:03; NOT runtime
C0_EXTRACT       = UNEDITED     cd7baf49… mtime 2026-09-05 19:48:18
RUNTIME_LEXICON  = COPIED_187   df0e8833… QSE2_N_LEX=187; mtime 14:49:07 NOT rewritten
BAG_LEXICON_SHIM = PRESENT      7966f321… include-name only (copied named law)
C0_PATCH         = MISS
NID_KEYS         = MISS         (coincidence nid 4356 == pack_plain(17,4) only)
ROUTER_UNION     = MISS         gold_ids = evidence=1 ∧ SRO/ctx pred before walker
DUAL_INDEX_NO_CTX = MISS as cheat; HIT as 1-id plant / dual-index control
NOT_SELECTIVE_RELABEL = MISS
TWELVE_ENTITY_CLONE = MISS
N_DROP           = MISS
SILENT_C0_RUNTIME = MISS
NAMED_LEX_REWRITE = MISS
FORMULAIC_GRID   = HIT as quality (index still 16384 template triples; records = 16k)
SURFACE_ONLY     = HIT as quality (QSE CLS_SKIP drops what/does/the/to;
                                  RELCTX feed aliases feeds; keys identical to fill)
TRUE_SEMANTIC_HELDOUT = NOT THIS BAG
SEMANTIC_MASS    = NOT THIS CORPUS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 65536 this bag (RTL source default 4096 overridden by TB)
CTX3_COUNT       = 1 (nid 121 direct_glycol)
CTX4_COUNT       = 1 (nid 122 direct_steam)
FILL_RE_PARA     = NO
FILL_RE_FILL     = YES
PARA_KEYS_EQ_FILL = YES (3332/3588)
PARA_KEPT_TOKENS = boiler, feed, header
NOFOLD_EMIT      = {120,121,122}   (independent plain)
PACKED_AND       = {121}
NID_16382_K0_IDX = 16 (>=16)  EVIDENCE from corpus.json records
NID_16382_K1_IDX = 33 (>=16)
FIRST16_AND_LATE = {}          would miss
STREAM_AND_CAP   = {16382}     hits
BOTH_LISTS       = YES
ENTITY_N_EV1     = 120 (ids 13..132; REJECT 800k as grid not mass)
N                = 16384
WRAP_8BIT        = 0 this bag (ids 13..132); residual if ids>255
HOST_AND_FF      = YES (pack_plain / ctx_keys mask; law width, not this-bag cheat)
SEM16K_KEEP      = UNMODIFIED GOLDEN 14:49:09 0e539d48be5862d006e5785cf3c74355d5540dff09bec5e8c738ac842ea83b99 CLOSEOUT 15:18:52
                   corpus 2b5d3028… 14:49:09 records == HELDOUT records
CONTEXT02_KEEP   = UNMODIFIED GOLDEN 14:12:02 8fc931f5ac07a72fd146a8e429ab38aed7ce0952464514883b887049ce0c3165 CLOSEOUT 14:13:59
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
SHA256_TXT_MISMATCHES = 0 / 33
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=65536 / 800k in this audit. Independent PLAN bag 7 remainder (unseen-combination / real NL) remains OPEN.
