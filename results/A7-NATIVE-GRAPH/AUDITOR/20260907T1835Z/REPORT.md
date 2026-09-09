# ASTRA auditor REPORT — 20260907T1835Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01
LAW        = qse-v2-intersect-context-02
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           INSTANTIATE DUT  a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             (STREAM-02 two-pointer copy; k2/k3 not probed; NOT edited)
LEXICON    = qse-v2-lex-semantic-16k-01 COPIED named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833… (mtime 14:49:07; NOT rewritten)
           include-name bag qse_role_lexicon.svh (shim `include of named file; same 14:49:07)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
CORPUS     = KEEP UNSEEN-SRO-16K-01 copy SHA 6991adc7… mtime 17:29:38 BYTE-IDENTICAL; NOT rewritten
KEEP       = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 (must be unmodified; GOLDEN 17:29:38 verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 (must be unmodified; GOLDEN 17:01:44 verified)
           + ASTRA-C1-SEMANTIC-HELDOUT-01 (must be unmodified; GOLDEN 15:44:21 verified)
           + ASTRA-C1-SEMANTIC-16K-01 (must be unmodified; GOLDEN 14:49:09 verified)
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
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1755Z/REPORT.md
           ACCEPT_PARTIAL (N=16384 unseen-SRO SCALE-IDENTITY; 1-of-8 retrieve nid=123;
             plants 124–130 indexed unqueried; P1 none; parent MAY open OPTIONAL remaining
             planted retrieve classes)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 remainder (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01.md
EVIDENCE   = raw xsim.log FILL_TEMPLATE_HIT / UNSEEN_SRO_HIT (8 lines nids 123..130) /
             UNSEEN_SRO_8_OF_8_HIT / UNBOUND_EMPTY_WALK / UNRELATED_EMPTY_WALK / CLASS_* /
             EMIT_* / ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS / SEARCH_INCOMPLETE
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + KEEP UNSEEN-SRO-16K corpus 6991adc7… byte-identical
             + KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP /
             STREAM-02 GOLDEN
           + file LastWriteTime (gold PRE 18:19:54 vs xvlog 18:20:11 vs xelab 18:33:11
             vs xsim 18:33:12–18:33:22 vs RESULTS 18:34:48; KEEP 16K GOLDEN 17:29:38)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (mtime 14:03:07 NOT this bag)
           + INSTANTIATE DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (mtime 14:03:24 NOT this bag)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime 11:43:39; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_semantic_unseen_sro_16k_r2.sv (poke_v, leftover A09, PASS conjunct,
             N_DROP, 8/8 HIT, leak)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx include order
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh / GOLDEN.json / corpus.json records / host_astra_c1_semantic_unseen_sro_16k_r2.py
           + independent cartesian-fill membership of nids 123–130 and unbound SRO=(13,4,1)
             and exact-key postings for each of 8 planted (s,r,o) plus fill 3332∩3588 and unbound 3332∩260
             (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SEMANTIC_UNSEEN_SRO_16K_R2 = THIS BAG (N=16384 cartesian-generator SAMPLE + 8 off-grid C0 HVAC
                            plants; query ALL 8; each HIT its nid; not semantic mass; not Master
                            close; not 800k; not N=65536)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = UNSEEN_SRO_16K_R2_8_OF_8_RETRIEVE_THIS_GATE_ONLY
                        (800k / N=65536 / NL mass NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP UNSEEN-SRO-16K-01 / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=16384 unseen / non-grid SRO 8-of-8 retrieve** bag `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` after auditor `20260907T1755Z` ACCEPT_PARTIAL of KEEP 16K as **1-of-8** retrieve (nid 123 only; plants 124–130 indexed unqueried) allowed parent to open OPTIONAL remaining planted retrieve classes.

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> N=16384 same KEEP plants 123–130 — query **each** of 8 off-grid SROs; each HIT its nid; unbound SRO still `UNBOUND_EMPTY_WALK` and must **not** emit fill-grid `{120,121,122}`. `SEARCH_INCOMPLETE` on any of 8 retrieve = FAIL. Instantiate ctx keys `124be808…` + DUT `8255a798…` (not edited). Corpus/lexicon copied hashed from KEEP UNSEEN-SRO-16K-01 (KEEP not edited). If XSim cannot host 16384, FAIL honestly `FIRST_DIVERGENCE MEM` — do **not** silently drop to N=256.

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS` present. `UNSEEN_SRO_8_OF_8_HIT` present. N actually 16384. `PLANTED_N=8`. `FILL_TEMPLATE_HIT` with tp=3 emit `{120,121,122}`. All 8 `UNSEEN_SRO_HIT` nids 123..130. `UNBOUND_EMPTY_WALK` emit_n=0. `SEARCH_INCOMPLETE` **ABSENT**.
2. Each query SRO matches the planted corpus record at that nid. All 8 planted SROs at nids 123–130 are **not** in the cartesian fill generator over `{13..132}`. Unbound SRO=(13,4,1) is **not** indexed. Unbound must not emit `{120,121,122}` (`UNBOUND_FILL_GRID_LEAK` = FAIL). k0-only of shared fill k0 **would** leak `{120,121,122}`. Keys are SRO-packed, **not** nid-derived.
3. Named lexicon `df0e8833…` **copied not rewritten**. Corpus `6991adc7…` **KEEP copy, not rewritten**. C0 FILE `38189974…` unedited and **not** runtime. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` / ctx DUT `8255a798…` **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. C0 extract `cd7baf49…` unedited. KEEP UNSEEN-SRO-16K-01 unmodified.
4. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog and **not** regenerated after FAIL; KEEP bags unmodified; independent tree not written.
5. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k. Do **not** sell 8/8 occupancy-1 retrieve or cartesian-generator **sample** as semantic mass / Master ≥95% / C1 800k.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`, cannot close N=65536, cannot close true NL synonym hold-out.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01/` (GOLDEN `dfa19dde…` timestamp **17:29:38**; CLOSEOUT **17:52:43**; corpus `6991adc7…`)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-01/` (GOLDEN `9fce7fad…` timestamp **17:01:44**; CLOSEOUT **17:04:05**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-HELDOUT-01/` (GOLDEN `3c1eda7d…` timestamp **15:44:21**; CLOSEOUT **16:06:53**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/` (GOLDEN `0e539d48…` timestamp **14:49:09**; CLOSEOUT **15:18:52**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-CONTEXT-02/` (GOLDEN `8fc931f5…` timestamp **14:12:02**; CLOSEOUT **14:13:59**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/` (GOLDEN `86b536fb…` timestamp **13:34:19**; CLOSEOUT **13:39:47**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/` (GOLDEN **12:44:33**; CLOSEOUT **12:46:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/` (GOLDEN **12:10:22**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN **10:46:42**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**)
- C0 **FILE** hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Relbind keys `a7ng_query_role_keys_relbind.sv` = `93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d` (KEEP; **not** compiled)
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **not** compiled as DUT)
- Page-skip DUT `a7ng_query_axi_sparse_page_skip.sv` = `dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817` (PAGE-SKIP MATCH; **not** compiled as DUT)
- Ctx keys `a7ng_query_role_keys_ctx.sv` = `124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1` (CONTEXT-02 MATCH instantiate; **not** edited)
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` = `8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989` (CONTEXT-02 MATCH instantiate as DUT; **not** edited)

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags including UNSEEN-SRO-16K-01 / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536, selling 8/8 occupancy-1 retrieve or a 16373-SRO **sample** of a 114239 generator as semantic mass / Master close.

Hunt (dispatch, none dropped):

1. Missed nid among 123–130 / `UNSEEN_SRO_8_OF_8_HIT` without 8 HIT lines
2. Unbound leak `{120,121,122}` / unbound indexed
3. Query SRO ≠ planted corpus record / nid-derived keys
4. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=65536 started
5. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
6. C0 lexicon FILE edited (`38189974` drift) / named lex `df0e8833` rewritten / corpus `6991adc7` rewritten
7. KEEP UNSEEN-SRO-16K-01 edited
8. Independent audit tree written
9. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
10. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys/DUT edited
11. Gold hashed after first xvlog / rewritten after FAIL
12. N drop (silent 256) / MEM FAIL hidden
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Host `relevant=router_union` / k0-only walker leak sold as AND
16. 8/8 occupancy-1 retrieve sold as semantic mass / Master ≥95% / C1 800k

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=16384 unseen-SRO 8-of-8 retrieve** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** further PLAN bag 7 remainder (real NL / held-out combinations that are not hard-empty k1). Do **not** auto-start C1 800k / N=65536 from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. R2 bag is untracked (`??`). KEEP UNSEEN-SRO-16K-01 is untracked (`??`) with **unchanged** GOLDEN mtime **17:29:38** / CLOSEOUT **17:52:43** (not this R2 window). Stream DUT untracked with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same standing finding as 0840Z…1755Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T18:40:00+07:00` (file mtime **18:36:14.951**, parent-owned; auditor did not write it) `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` `unblocked_item=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), UNSEEN-SRO-16K-R2 bag:

```text
14:49:07.692  qse_role_lexicon_semantic_16k.svh   ← COPIED from KEEP 16K / SEMANTIC-16K; NOT rewritten
14:49:07.692  qse_role_lexicon.svh                ← include-name shim; same stamp as 16k
17:29:38.554  corpus.json                         ← KEEP copy stamp; BYTE-IDENTICAL 6991adc7…
18:15:31.375  host_astra_c1_semantic_unseen_sro_16k_r2.py
18:16:56.104  tb_astra_c1_semantic_unseen_sro_16k_r2.sv
18:18:09.434  run_xsim.ps1
18:19:37.038  ACK.json PREREG.md
18:19:54.023  GOLDEN.json                         ← R2 11-query gold (NOT KEEP GOLDEN)
18:19:54.039  query_gold.svh
18:19:54.044  GOLD_HASH_PRE_XVLOG.txt             ← gold+named-lex+corpus hash BEFORE xvlog
18:20:10.551  SHA256.txt                          ← PASS freeze immediately before xvlog
18:20:10.555  xsim_work/ CreationTime             ← PASS workspace
18:20:11.535  xvlog.log                           ← first/only xvlog this bag
18:33:11.879  xelab.log                           ← xelab ~13 min (65536-bucket elaborate)
18:33:12      xsim session start PID 22308
18:33:22.935  xsim.log                            session 18:33:12–18:33:22
18:34:48.146  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO / KEEP 16K. This bag starts 18:15. Ctx keys were not rewritten for R2.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer**. Not rewritten.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag. Not rewritten.

Page-skip DUT LastWriteTime **2026-09-07 13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**. Leftover A09 **2026-09-06 18:51:11.550**.

Named lexicon LastWriteTime **14:49:07.692** — **identical** to KEEP UNSEEN-SRO-16K / SEMANTIC-16K named file stamp. Hash MATCH `df0e8833…`. Byte-identical to KEEP 16K named file (9159 bytes). Copied, not regenerated.

Corpus LastWriteTime **17:29:38.554** — **identical** to KEEP UNSEEN-SRO-16K corpus stamp. Hash MATCH `6991adc7…`. Byte-identical (3915272 bytes). Host SHA-gates `KEEP_CORPUS_SHA=6991adc7…` and **loads** the copy (`load_copied_corpus`); does **not** call `build_corpus()` to rewrite. Hunt corpus-rewrite this bag: **MISS.**

`xsim_fail_r0.log` **ABSENT**. Gold files were **not** rewritten between 18:19:54 and 18:34:48 (hash MATCH PRE; LastWriteTime still 18:19:54). Named lexicon still 14:49:07. Corpus still 17:29:38.

`xsim.log` SHA256 `ea8581ee5bc7b28891b6643cd0f9ff148917a1e0cc3c5e23f79446294e921627` MATCH RESULTS `XSIM_SHA`.

No new C1-800k / N=65536 bag dirs. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane (mtime 2026-09-05), not this bag.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / KEEP DUT / copied lexicon / copied corpus

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
f32467f9732c34988f96fc43f312c70a0edcc8108bf99006f1d630489650861c  tb_astra_c1_semantic_unseen_sro_16k_r2.sv
c683cfa681df03b2913362c31c58e3ec3adf69ba62e4f23c5d8f0d4c10452deb  host_astra_c1_semantic_unseen_sro_16k_r2.py
be1eb641931e7666b4751b71dfaa309030aa3ac3ba454f92ac7768e5a9bcd8bc  GOLDEN.json (R2 11-query; NOT KEEP GOLDEN)
d24a983bfc5d704bb35c1223729c90a2b728ccae5b62c5bb884a4d05553b6251  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json (KEEP copy)
```

C0 extract / lexicon FILE MATCH prior T1755Z / C0. STREAM-02 N=256 lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH. SEMANTIC-16K / KEEP 16K named lexicon `df0e8833…`. Live MATCH this bag copy (byte-identical). KEEP 16K corpus `6991adc7…`. Live MATCH this bag copy (byte-identical).

`GOLD_HASH_PRE_XVLOG.txt` mtime **18:19:54.044** vs live gold+named-lex+corpus (all MATCH):

```text
be1eb641931e7666b4751b71dfaa309030aa3ac3ba454f92ac7768e5a9bcd8bc  GOLDEN.json
d24a983bfc5d704bb35c1223729c90a2b728ccae5b62c5bb884a4d05553b6251  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
```

`xvlog.log` mtime **18:20:11.535**. Gold hashed **before** that xvlog. Gold files were **not** rewritten after xsim (still 18:19:54). SHA256.txt freeze stamp `2026-09-07T18:20:10.5016774+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **33 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple + corpus). C0 lexicon FILE live MATCH `38189974…` independently. No invented hash.

R2 GOLDEN `be1eb641…` **differs** from KEEP 16K GOLDEN `dfa19dde…` because R2 gold is 11 queries (fill + 8 plants + unbound + unrelated) vs KEEP's 4-query (fill + 1 plant + unbound + unrelated). That is a **new-bag gold**, not a KEEP edit. Corpus SHA is the identity that must MATCH KEEP; it does.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 18:15+ |
|---|---|---|---|
| UNSEEN-SRO-16K-01 (KEEP) | `dfa19dde41e2566d…` **17:29:38.555** | CLOSEOUT **17:52:43.608** | **UNMODIFIED** |
| UNSEEN-SRO N=256 | `9fce7fad371afbc3…` **17:01:44.789** | CLOSEOUT **17:04:05.364** | **UNMODIFIED** |
| HELDOUT | `3c1eda7d1639ef1d…` **15:44:21.671** | CLOSEOUT **16:06:53.125** | **UNMODIFIED** |
| SEMANTIC-16K | `0e539d48be5862d0…` **14:49:09.278** | CLOSEOUT **15:18:52.927** | **UNMODIFIED** |
| CONTEXT-02 | `8fc931f5ac07a72f…` **14:12:02.956** | CLOSEOUT **14:13:59.927** | **UNMODIFIED** |
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19.424** | CLOSEOUT **13:39:47.345** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| DIR-FULL16 | GOLDEN **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| N4096-STREAM-02 | GOLDEN **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | GOLDEN **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | GOLDEN **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

KEEP UNSEEN-SRO-16K named lexicon file hash `df0e8833…` mtime **14:49:07.692** — **identical** to this bag copy. KEEP corpus hash `6991adc7…` mtime **17:29:38.554** — **identical**. KEEP files themselves were not rewritten.

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** R2 implementer did **not** write that tree. This auditor did **not** write that tree.

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
tb_astra_c1_semantic_unseen_sro_16k_r2.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir, TB). Truncation `N_BUCKETS=32...` / `DEPTH_WORDS=3...` is Vivado `32'd65536` / `32'd286514` display, **not** a drop to 32768: query_gold `G_N_BUCKETS=65536` `G_MEM_DEPTH=286514`; banner `N_BUCKETS=65536 MEM_DEPTH=286514`; TB diverges `DIR_WIDTH` if `G_N_BUCKETS != 65536` and `MEM` if depth too small; `FIRST_DIVERGENCE` ABSENT.

Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

`work.rlx` include order for extract: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_16k.svh`. TB/DUT include_dirs start with **bag**. Bag first. `work.rlx` unix mtime on named lex `1788767347` = 14:49:07 +07 (KEEP copy, not R2 regen). query_gold `1788779994` = 18:19:54 +07 MATCH PRE.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; requires named lexicon + bag shim present; requires corpus SHA `6991adc7…` and named lex `df0e8833…`; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (copied named lexicon law). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. Documented copy of `qse-v2-lex-semantic-16k-01`, **not** a silent C0 59-word claim.

TB instantiates `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `MEM_DEPTH=286514` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken. `G_PLANTED_N != 8` / `G_NQ != 11` / `G_UNBOUND_Q != 9` / `G_PLANTED_NIDS[i] != 123+i` / `G_FILL_GRID != {120,121,122}` diverges not taken.

PASS marker conjunct (TB line 499): `fail==0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (unseen_hit_n == G_PLANTED_N) && unbound_empty && unbound_no_leak && (incomp_retrieve == 0) && (G_N == 16384) && (G_PLANTED_N == 8)`. Stronger than KEEP 16K (`unseen_tp > 0` for one nid): R2 requires **`unseen_hit_n == 8`**. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. Unbound leak of `{120,121,122}` → `FAIL UNBOUND_FILL_GRID_LEAK`. Fill tp=0 → `FAIL FILL_TEMPLATE_GOLD_MISS`. Any planted miss → `FAIL UNSEEN_SRO_GOLD_MISS`. Unseen keys identical to fill-grid → `KEY_MISMATCH` diverge. Unbound k0 must share fill-grid k0; unbound k1 must differ.

Live: `incomp=0` on every CLASS_* retrieve line; `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **0**; `incomp=1` count **0**; `UNBOUND_FILL_GRID_LEAK` count **0**. Hunt swallowed-incomp: **MISS this bag.** Hunt N_DROP: **MISS this bag.**

xsim: wall ~7 s elapsed for 11 queries; `$finish` at **16545 ns**. That is an **11-query walk**, not a 24 h HELDOUT-style session, and **not** evidence of N drop (banner/gold/corpus all 16384; MEM_DEPTH 286514 hosted). xelab ~13 min is the 65536-bucket elaborate, same shape as KEEP 16K.

### 5) PRIMARY HUNT — runtime lexicon is COPIED named 187-word, corpus KEEP copy, not rewritten, not C0 59-word

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
mtime      = 2026-09-07 14:49:07.692   (same stamp as KEEP SEMANTIC-16K / UNSEEN-SRO-16K named file)
```

Host refuses rewrite: live SHA must MATCH `EXPECTED_LEX_NAMED=df0e8833…` and shim `7966f321…`. Hunt “named lex regenerated this bag”: **MISS.**

Bag `qse_role_lexicon.svh` is **three comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler`. Live CLASS_fill_template query is `"boiler feeds header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13. Hunt “C0 lexicon file edited”: **MISS.** Hunt “silent C0 59-word runtime claim”: **MISS.** Hunt “named lex rewritten”: **MISS.**

Corpus `corpus.json` header `gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` (KEEP identity, not rewritten). SHA `6991adc7…` MATCH KEEP. Host `load_copied_corpus()` SHA-gates and does not rebuild. Hunt “corpus rewritten”: **MISS.**

### 6) INSTANTIATE keys / DUT vs nid keys / STREAM-02 clone

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. **No nid port.** Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through frozen `{subj,rel}`. Query classes this bag are ctx=0, so k0/k1 = pack_plain(sid,rid)/pack_plain(oid,rid).

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. k2/k3 not used to issue AR.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys/DUT edited this bag”: **MISS** (mtime 14:03, this bag 18:15). Hunt “PAGE-SKIP compiled / mixed”: **MISS.**

Host gold: `gold_ids(docs, pred)` = nids with `evidence==1` matching an SRO **predicate**, computed **before** the walker twin. `relevant_is_router_union=false` in GOLDEN. Hunt `relevant=router_union`: **MISS.**

Index writes `k0_plain`/`k1_plain` for every evidence row, plus ctx-folded k0/k1 only when `ctx_valid`. Queries this bag are ctx=0, so they walk **plain** keys. Independent `k0==(nid<<8)` count = **0**. Coincidental `k0_plain==nid` count = **1** (nid 4356 `"damper feeds wing"` SRO=(17,4,79); `pack_plain(17,4)=(17<<8)|4=4356`). That is packing arithmetic on a fill row, **not** a nid-derived key. Host chk `k0 != (nid<<8)`. RTL has no nid input. Hunt nid-derived keys: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 18:33:12 2026**; exit **18:33:22**; PID **22308**; `$finish` at **16545 ns**.

Banner:

```text
C1_SEMANTIC_UNSEEN_SRO_16K_R2_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286514 N_SUBJECTS=127 N_RELS=8 PLANTED_N=8 UNSEEN_SRO=8 FILL_GRID=120,121,122 PLANTED_NIDS=123,124,125,126,127,128,129,130
```

Named lines (verbatim authority):

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=121 ovf=1 trunc=0 dirB=32 postB=512 discB=0 descB=0 incomp=0
EMIT_fill_template n=3
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=123
CLASS_unseen_sro_123 gold_n=1 emit_n=1 tp=1 … occ=2 ovf=0 trunc=0 dirB=32 postB=32 … incomp=0
  CAND unseen_sro_123 i=0 id=123 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=124
CLASS_unseen_sro_124 … occ=1 … incomp=0
  CAND unseen_sro_124 i=0 id=124 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=125
CLASS_unseen_sro_125 … occ=2 … incomp=0
  CAND unseen_sro_125 i=0 id=125 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=126
CLASS_unseen_sro_126 … occ=1 … incomp=0
  CAND unseen_sro_126 i=0 id=126 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=127
CLASS_unseen_sro_127 … occ=1 … incomp=0
  CAND unseen_sro_127 i=0 id=127 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=128
CLASS_unseen_sro_128 … occ=1 … incomp=0
  CAND unseen_sro_128 i=0 id=128 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=129
CLASS_unseen_sro_129 … occ=1 … incomp=0
  CAND unseen_sro_129 i=0 id=129 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=130
CLASS_unseen_sro_130 … occ=1 … incomp=0
  CAND unseen_sro_130 i=0 id=130 ev=1
UNBOUND_EMPTY_WALK gold_n=0 emit_n=0
CLASS_unbound_sro gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0 prec_ev1_undef=1 prec_all_x1000=-1 rec_x1000=-1 occ=121 ovf=1 trunc=0 dirB=32 postB=0 discB=0 descB=0 incomp=0
EMIT_unbound_sro n=0
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
EMIT_unrelated n=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
UNSEEN_SRO_HIT_N=8 OF 8
UNSEEN_SRO_8_OF_8_HIT
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS=1`; `UNSEEN_SRO_8_OF_8_HIT=1`; `UNSEEN_SRO_HIT=8` (nids 123,124,125,126,127,128,129,130 — **one each**); `FILL_TEMPLATE_HIT=1`; `UNBOUND_EMPTY_WALK=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` in `xsim.log` = **0**; `FIRST_DIVERGENCE` = **0**; `UNBOUND_FILL_GRID_LEAK` = **0**; `incomp=1` = **0**. CAND `id=120/121/122` appear **only** on `fill_template`, **not** on unbound (emit_n=0, no CAND lines).

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_fill_template emit `{120,121,122}` tp=3 occ=121. All 8 CLASS_unseen_sro_* emit exactly `{nid}` tp=1 incomp=0. CLASS_unbound_sro emit_n=0 (not `{120,121,122}`) occ=121. Conjunctive gate holds on raw. N banner = 16384. `PLANTED_N=8`. `UNSEEN_SRO=8`. Hunt “N not actually 16384”: **MISS.** Hunt “silent drop to 256”: **MISS.** Hunt “missed nid”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=127` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_MEM_DEPTH=286514` `G_N_WR=18561` `G_UNSEEN_NID=123` `G_FILL_GRID={120,121,122}` `G_PLANTED_N=8` `G_PLANTED_NIDS={123..130}` `G_NQ=11` `G_UNSEEN_Q=1` `G_PLANTED_Q0=1` `G_UNBOUND_Q=9` `G_UNRELATED_Q=10`. `G_LEN = {19,26,27,29,17,19,26,19,30,20,16}` MATCH independent `len(query text)`.

```text
G_SUBJ = {13, 1, 1, 4, 6,10, 9,12, 3,13, 0}
G_REL  = { 4, 1, 2, 1, 3, 1, 8, 5, 6, 4, 0}
G_OBJ  = {14, 2, 3, 2, 7,11, 2, 6, 4, 1, 0}
G_K0   = {16'h0D04, 16'h0101, 16'h0102, 16'h0401, 16'h0603, 16'h0A01, 16'h0908, 16'h0C05, 16'h0306, 16'h0D04, 16'h0000}
       = {3332, 257, 258, 1025, 1539, 2561, 2312, 3077, 774, 3332, 0}
G_K1   = {16'h0E04, 16'h0201, 16'h0302, 16'h0201, 16'h0703, 16'h0B01, 16'h0208, 16'h0605, 16'h0406, 16'h0104, 16'h0000}
       = {3588, 513, 770,  513, 1795, 2817,  520, 1541,1030,  260, 0}
G_K0_PLAIN == G_K0  (ctx=0 pass-through)
G_NEMIT = {3,1,1,1,1,1,1,1,1,0,0}
G_OCC   = {121,2,1,2,1,1,1,1,1,121,0}
G_EMIT  q0={120,121,122} q1..q8={123}..{130} q9={} q10={}
```

Unbound k0 **shares** fill-grid k0=3332; unbound k1=260 **differs**. Each planted query SRO MATCH corpus record at that nid (next section). Independent LSB-first `G_LEN` vs GOLDEN text:

```text
q0  "boiler feeds header"            len=19  FILL_RE MATCH  (control)
q1  "chiller supplies condenser"     len=26  FILL_RE MATCH  SRO=(1,1,2)   nid 123
q2  "chiller requires evaporator"    len=27  FILL_RE MATCH  SRO=(1,2,3)   nid 124
q3  "compressor supplies condenser"  len=29  FILL_RE MATCH  SRO=(4,1,2)   nid 125
q4  "ahu connects duct"              len=17  FILL_RE MATCH  SRO=(6,3,7)   nid 126
q5  "pump supplies valve"            len=19  FILL_RE MATCH  SRO=(10,1,11) nid 127
q6  "tower discharges condenser"     len=26  FILL_RE MATCH  SRO=(9,8,2)   nid 128
q7  "sensor isolates ahu"            len=19  FILL_RE MATCH  SRO=(12,5,6)  nid 129
q8  "evaporator bypasses compressor" len=30  FILL_RE MATCH  SRO=(3,6,4)   nid 130
q9  "boiler feeds chiller"           len=20  FILL_RE MATCH  SRO=(13,4,1)  unbound
q10 "payroll tax form"               len=16  FILL_RE MATCH  (OOV empty-walk)
```

Key arithmetic MATCH pack_plain `{subj[7:0], rel[7:0]}` / `{obj[7:0], rel[7:0]}` (ctx=0). **No nid in the packer.**

### 8) Independent corpus — each query SRO MATCH planted record; nids 123–130 OFF cartesian fill; unbound (13,4,1) NOT indexed; k0-only would leak {120,121,122}

Authority = live `corpus.json` **records** (hash `6991adc7…`, byte-identical KEEP), **not** RESULTS.

```text
n records         = 16384 (nid 0..16383 contiguous)
evidence=1        = 16384
evidence=0        = 0
n_host            = 0 all rows
subj unique       = 127  (NEW_SUBJ {13..132} n=120 plus plant subj {1,3,4,6,9,10,12})
rel unique        = {1..8} n=8
obj unique        = 126
kinds             = fill 16373 / direct_plain 1 / direct_glycol 1 / direct_steam 1 / unseen_sro 8
cartesian_fill_sro_n header = 114239
indep generator   = 120×8×119 − 1 reserved (13,4,14) = 114239  MATCH
unique SRO in corpus = 16382   (= 16373 cartesian SAMPLE + reserved (13,4,14) + 8 plants)
FILL_RE match     = 16384/16384
unique texts      = 16384
PSC text count    = 0
nid<<8 keys       = 0
wrap 8-bit        = 0
ctx_id            = {0:16382, 3:1, 4:1}
unbound indexed   = 0
```

Independent cartesian generator: `s,o ∈ {13..132}`, `r ∈ {1..8}`, skip `s==o`, skip reserved `(13,4,14)` → **114239** SROs. MATCH header.

**FACT: the index is a SAMPLE of that generator, not the full 114239 unique SRO.** Independent: `fill` kind SRO-in-cart = **16373**. Honest if read as generator size; illegal as “full cartesian mass indexed”.

Records whose SRO is **OUT** of that generator (independent, n=11):

```text
nid 120  kind=direct_plain   text="boiler feeds header"                 SRO=(13,4,14) ctx=0  k0=3332 k1=3588  ev=1
nid 121  kind=direct_glycol  text="boiler feeds header glycol"          SRO=(13,4,14) ctx=3
nid 122  kind=direct_steam   text="boiler feeds header steam"           SRO=(13,4,14) ctx=4
nid 123  kind=unseen_sro     text="chiller supplies condenser"          SRO=(1,1,2)   k0=257  k1=513   ev=1
nid 124  kind=unseen_sro     text="chiller requires evaporator"         SRO=(1,2,3)   k0=258  k1=770   ev=1
nid 125  kind=unseen_sro     text="compressor supplies condenser"       SRO=(4,1,2)   k0=1025 k1=513   ev=1
nid 126  kind=unseen_sro     text="ahu connects duct"                   SRO=(6,3,7)   k0=1539 k1=1795  ev=1
nid 127  kind=unseen_sro     text="pump supplies valve"                 SRO=(10,1,11) k0=2561 k1=2817  ev=1
nid 128  kind=unseen_sro     text="tower discharges condenser"          SRO=(9,8,2)   k0=2312 k1=520   ev=1
nid 129  kind=unseen_sro     text="sensor isolates ahu"                 SRO=(12,5,6)  k0=3077 k1=1541  ev=1
nid 130  kind=unseen_sro     text="evaporator bypasses compressor"      SRO=(3,6,4)   k0=774  k1=1030  ev=1
```

**FACT: all 8 planted SROs are truly off cartesian fill over {13..132}.** Independent `sro ∈ cart` = **False** for nids 123–130. Plant subj **and** obj are all outside `NEW_SUBJ_IDS` (C0 HVAC ids 1–12).

**FACT: each query SRO MATCHES the planted corpus record** (text, (s,r,o), k0, k1, nid). query_gold `G_SUBJ/G_REL/G_OBJ` for q1..q8 = corpus records 123..130. GOLDEN `relevant`/`emit` = `{nid}` each. Raw CAND = `{nid}` each. Hunt “query SRO ≠ planted record”: **MISS.**

**FACT: unbound SRO=(13,4,1) is not indexed.** Record count with `(subj,rel,obj)==(13,4,1)` = **0**. `(13,4,1) ∈ cart` = **False** (obj=1 is not in `{13..132}`). Independent gold_ids `evidence==1 ∧ SRO=(13,4,1)` = `[]`.

Fill-grid `(13,4,14)` is **reserved out of cartesian fill** and planted at nids 120/121/122. That is the **control**, not the unseen fact.

Independent gold (evidence=1 ∧ SRO pred, **before** walker):

```text
fill_template  (13,4,14) = {120,121,122}
unseen_sro_123 (1,1,2)   = {123}
unseen_sro_124 (1,2,3)   = {124}
unseen_sro_125 (4,1,2)   = {125}
unseen_sro_126 (6,3,7)   = {126}
unseen_sro_127 (10,1,11) = {127}
unseen_sro_128 (9,8,2)   = {128}
unseen_sro_129 (12,5,6)  = {129}
unseen_sro_130 (3,6,4)   = {130}
unbound_sro    (13,4,1)  = []
```

MATCH GOLDEN `relevant` and raw emit.

Independent exact-key postings (plain `{subj,rel}` / `{obj,rel}` — the keys the ctx=0 walker actually uses; indexer writes `k0_plain`/`k1_plain` for every row):

```text
plain k0=3332 occ=121  first16=[120,121,122,487,488,489,490,491,492,493,494,495,496,497,498,499]
plain k1=3588 occ=18
plain AND fill 3332∩3588 = {120,121,122}          ← CLASS_fill_template MATCH raw

plain k0=257  occ=1  list=[123]
plain k1=513  occ=2  list=[123,125]               ← nid 125 shares obj/rel condenser/supplies
plain AND 123  257∩513  = {123}                   ← CLASS_unseen_sro_123 MATCH raw

plain k0=258  occ=1  AND 258∩770   = {124}
plain k0=1025 occ=1  AND 1025∩513  = {125}        ← k1 occ=2 via nid 123 share
plain k0=1539 occ=1  AND 1539∩1795 = {126}
plain k0=2561 occ=1  AND 2561∩2817 = {127}
plain k0=2312 occ=1  AND 2312∩520  = {128}
plain k0=3077 occ=1  AND 3077∩1541 = {129}
plain k0=774  occ=1  AND 774∩1030  = {130}

plain k1=260  occ=0  list=[]
plain AND unbound 3332∩260 = {}                   ← CLASS_unbound_sro MATCH raw

k0-only 3332 would emit the 121 boiler-feeds-* nids
  FIRST THREE in nid order = {120,121,122}        ← WOULD LEAK fill-grid
```

**FACT:** two-pointer AND is **necessary** for the unbound empty walk. A k0-only walker on shared k0=3332 **would leak** fill-grid neighbors as the first three posting hits (CAND_CAP=16 would emit them). Live emit_n=0. Hunt k0-only cheat sold as AND: **MISS** (empty k1 posting; AND empty; leak FAIL path present and not taken).

**FACT:** each of the 8 retrieve ANDs is occupancy-1 on k0 (123/125 share k1 occ=2 but AND still singleton). prec=1000 is **1-id identity** eight times, not semantic mass.

Key arithmetic (independent, ctx=0 pass-through):

```text
fill     k0=3332=0x0D04 = {subj=13, rel=4}   boiler feeds
fill     k1=3588=0x0E04 = {obj=14,  rel=4}   header
123      k0= 257=0x0101 = {subj=1,  rel=1}   chiller supplies
123      k1= 513=0x0201 = {obj=2,   rel=1}   condenser
124      k0= 258=0x0102 / k1=770=0x0302
125      k0=1025=0x0401 / k1=513=0x0201      (shares 123 k1)
126      k0=1539=0x0603 / k1=1795=0x0703
127      k0=2561=0x0A01 / k1=2817=0x0B01
128      k0=2312=0x0908 / k1=520=0x0208
129      k0=3077=0x0C05 / k1=1541=0x0605
130      k0= 774=0x0306 / k1=1030=0x0406
unbound  k0=3332=0x0D04 SHARES fill k0  occ=121
unbound  k1= 260=0x0104 = {obj=1,   rel=4}   chiller + feeds  (empty posting)
```

k0 occ=121 = 3 fill-grid nids (plain-indexed even when ctx≠0) + 118 cartesian `boiler feeds *` with `* ∈ {13..132}\{13,14}`. MATCH `3+118=121`.

TB requires each unseen key pair **≠** fill keys (live: none of 257/513, 258/770, … equal 3332/3588) and unbound k0 **==** fill k0 with unbound k1 **≠** fill k1. FIRST_DIVERGENCE ABSENT. No `ROLE_COLLAPSE` / `KEY_MISMATCH`.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (fill `{120,121,122}` tp=3 occ=121 incomp=0; eight `UNSEEN_SRO_HIT` nids 123–130 emit `{nid}` tp=1; `UNBOUND_EMPTY_WALK` emit_n=0; unrelated empty-walk; `UNSEEN_SRO_8_OF_8_HIT` PRESENT). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, N=65536, Master ≥95%. Banner `NOT_CLAIMED=…N_65536,MASTER_95,ACCEPT_BOARD`. `TWELVE_ENTITY_CLONE=NO` MATCH independent (PSC=0). `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `UNBOUND_FILL_GRID_LEAK` ABSENT. `N_DROP=ABSENT` MATCH. KEEP 16K “UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43)” MATCH live. Independent tree “max 10:52:29” MATCH live.

Implementer prose that bulk fill is cartesian `{13..132}` × 8 rels (114239 unique SRO **generator**), planted nids 123–130 use C0 HVAC ids outside NEW_SUBJ, unbound (13,4,1) is not indexed and shares fill-grid k0 occ=121: **HONEST vs independent membership + postings**, with the construction caveat that corpus unique cartesian SRO is **16373** (sample), not 114239 indexed. Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat). Hunt “8/8 claimed as semantic mass / Master close”: **MISS as claim** (RESULTS Honesty + CLOSEOUT QUALITY_NOTE). Hunt “true NL closed”: **MISS as claim**.

CLOSEOUT MATCH raw: marker present, `UNSEEN_SRO_8_OF_8_HIT`, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` instantiate, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…` copied mtime 14:49:07, corpus `6991adc7…` mtime 17:29:38, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 18:19:54 PRE before xvlog 18:20:11.

Host `n_post` vs DUT `postB/16` residual: fill GOLDEN n_post=36 vs DUT postB=512→32; unbound GOLDEN n_post=31 vs DUT postB=0 (empty k1 ⇒ no post beats). Unseen 123 GOLDEN n_post=2 vs postB=32→2 MATCH. Emit locked. P2, not emit FAIL. Same residual family as KEEP 16K.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Missed nid 123–130 / fake 8-of-8 | **MISS.** Raw 8 `UNSEEN_SRO_HIT` lines, one per nid 123..130, each emit `{nid}` tp=1. `UNSEEN_SRO_HIT_N=8 OF 8`. `UNSEEN_SRO_8_OF_8_HIT`. Marker conjunct requires `unseen_hit_n == G_PLANTED_N == 8`. Independent plain AND each singleton MATCH. | Any miss ⇒ FAIL. None missed. |
| 2. Unbound leak `{120,121,122}` / unbound indexed | **MISS.** Indexed count=0; gold=[]; plain AND 3332∩260={}; raw emit_n=0; no CAND 120/121/122 on unbound; `UNBOUND_FILL_GRID_LEAK` ABSENT. **HIT as construction:** k1 occ=0 is a hard empty. k0-only **would** leak `{120,121,122}` as first three of 121. | Empty AND on shared k0 is the negative. Keep leak as FAIL. |
| 3. Query SRO ≠ planted record / nid-derived keys | **MISS.** Each q1..q8 (s,r,o,k0,k1,text) MATCH corpus nid 123..130. RTL no nid port. `nid<<8` keys=0. Coincidental `k0_plain==nid` is fill row 4356 pack_plain(17,4), not a cheat. GOLDEN `relevant_is_router_union=false`. | SRO mismatch ⇒ FAIL. nid keys ⇒ FAIL. |
| 4. C1 800k / bounds / ACCEPT_BOARD / N=65536 started | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag (historical U5 2026-09-05 only). | Never grant. Never freeze. Never auto-start 800k. |
| 5. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0 on all retrieve classes; conjunct includes `incomp_retrieve==0` and `unseen_hit_n==8` and `G_N==16384`. | Keep miss as FAIL on later bags. |
| 6. C0 lexicon FILE edited / named lex rewritten / corpus rewritten | **MISS.** Live `38189974…` mtime 2026-09-05 20:51:03; named `df0e8833…` mtime 14:49:07 MATCH KEEP 16K copy byte-identical; corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP; host refuses rewrite. | Do not edit C0. Do not regenerate named lex. Do not rewrite corpus. |
| 7. KEEP UNSEEN-SRO-16K-01 edited | **MISS.** GOLDEN `dfa19dde…` **17:29:38**; CLOSEOUT **17:52:43**; xsim.log **17:51:08**; corpus/lex stamps unchanged. R2 window starts 18:15. | Leave KEEP on disk. |
| 8. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 18:15. | Keep that tree read-only. |
| 9. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…` mtime 2026-09-06 18:51:11. poke_v held 0. | Keep off. |
| 10. STREAM-02 / ctx keys / ctx DUT edited or STREAM-02 compiled | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` / `8255a798…` mtime 14:03, this bag 18:15. | Hash mismatch ⇒ FAIL, do not patch. |
| 11. Gold after FAIL / after xvlog | **MISS as gold regen.** PRE 18:19:54; xvlog 18:20:11; gold still 18:19:54; named lex still 14:49:07; corpus still 17:29:38; no r0. SHA256.txt restamp 18:20:10 MATCH live PRE. | Do not regenerate gold. |
| 12. N drop (silent 256 / wrong geometry) | **MISS.** Banner/gold/corpus `N=16384`; TB `N_DROP` if `G_N!=16384` not taken; `G_N_BUCKETS=65536` `MEM_DEPTH=286514`; xelab `32'd` truncation not 32768; `FIRST_DIVERGENCE` ABSENT. 11-query wall-clock ~7 s is not a drop. | Silent drop ⇒ FAIL. This bag hosted 16384. |
| 13. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Identity-path prose MATCH independent membership. | Authority = raw 8 HIT lines + UNSEEN_SRO_8_OF_8_HIT + UNBOUND_EMPTY_WALK + independent postings. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 33/33 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…` + corpus `6991adc7…`). | SHA256.txt 18:20:10 is the xvlog freeze. PRE 18:19:54 is the gold lock. |
| 15. `relevant=router_union` / k0-only leak sold as AND | **MISS.** `gold_ids` = evidence=1 ∧ SRO pred before walker. k0-only counterfactual would leak; live AND empty. | Keep independent labels. |
| 16. 8/8 occupancy-1 retrieve sold as mass / Master ≥95% / C1 800k | **HIT as quality / promotion bound. MISS as registered-unknown FAIL and MISS as implementer claim.** WO asked query **each** of 8 — **met**. Each AND is occupancy-1 (123/125 k1 share occ=2, AND still singleton). prec=1000 is 1-id identity ×8. Implementer RESULT=`PASS_THIS_GATE_ONLY`; Honesty section does **not** claim mass/800k/Master. | Illegal as Master ≥95% / “semantic mass closed” / C1 800k. Honest as 8/8 off-grid retrieve unknown. |
| Unseen queries are still `{ent}{rel}{ent}` FILL_RE | **HIT as quality.** All 11 queries MATCH FILL_RE. Unknown is **SRO identity vs fill generator at N=16384**, not held-out NL. Unseen facts are C0 HVAC triples, not novel prose. Corpus FILL_RE 16384/16384. | Do not sell as NL synonym hold-out. |
| Cartesian “mass” is a 16373-SRO sample of a 114239 generator | **HIT as construction/quality, MISS as cheat.** Generator size disclosed; corpus unique SRO=16382. N=16384 hosted. | Not full-generator mass. Not 800k. |
| Fill-template control is reserved (13,4,14) not cartesian bulk | **HIT as construction, MISS as cheat.** Control still hits with occ=121. | Identity control, not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| Unbound k1 occ=0 is a hard empty | **HIT as construction/quality.** Negative is “not indexed”, which this is. Not a held-out combination that exists in a large index and must be missed. Same construction as N=256 / KEEP 16K. | Next NL bag must not reuse hard-empty k1 as “unknown”. |
| Host n_post vs DUT postB (fill 36 vs 32; unbound 31 vs 0) | **HIT as residual.** DUT issues no post beats on empty k1. Emit empty MATCH. | Do not freeze DDR bytes. |

qstack-validation-adversary one-liner: **SEMANTIC-UNSEEN-SRO-16K-R2-01 XSim is a real N=16384 host+instantiate lock on unpatched C0 extract (`cd7baf49…`) with a **copied** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…` mtime 14:49:07 **not rewritten**) and a **KEEP-copied** corpus (`6991adc7…` mtime 17:29:38 **byte-identical**, not rewritten; KEEP 16K GOLDEN/CLOSEOUT still 17:29:38/17:52:43): bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime — C0 cannot tokenize `boiler` but live CLASS_fill_template did; frozen ctx keys `124be808…` and ctx DUT `8255a798…` instantiated not edited; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; independent corpus n=16384 contiguous, cartesian **generator** over FILL_ENT `{13..132}` × rel `{1..8}` skip s==o and reserved `(13,4,14)` = 114239 SRO of which **16373** are indexed as `fill`; 8 off-grid C0 HVAC plants at nids 123–130 are **OUT** of that generator (subj and obj ∉ NEW_SUBJ); **each** planted SRO was queried and each retrieves its nid (`UNSEEN_SRO_HIT` ×8, `UNSEEN_SRO_8_OF_8_HIT`, independent plain AND each `{nid}` incomp=0); unbound `"boiler feeds chiller"` SRO=(13,4,1) is **not indexed** (0 records) and shares fill-grid k0=3332 (occ=121, k0-only first16 starts `{120,121,122,…}` so **would leak**) while k1=260 occ=0 so AND is empty (`UNBOUND_EMPTY_WALK` emit_n=0, `UNBOUND_FILL_GRID_LEAK` ABSENT); fill-template control still emits `{120,121,122}` (`FILL_TEMPLATE_HIT` tp=3 occ=121 incomp=0); leftover A09 off; poke_v=0; gold PRE 18:19:54 before xvlog 18:20:11 (gold not regenerated); KEEP UNSEEN-SRO-16K unmodified; independent tree ≤10:52:29; N actually 16384 (`N_BUCKETS=65536` `MEM_DEPTH=286514`); that is **8/8 SRO identity at N=16384 scale** on a cartesian-generator **sample**, **not** semantic mass, not Master ≥95%, not C1 800k, not ACCEPT_BOARD, and still an axi_mem_model / hard-empty k1 / C0-HVAC plant / FILL_RE rung.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / each plant `{nid}` / unbound `[]`). Findings are **law-quality / promotion bounds / PLAN-shape residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **N=16384 was actually hosted and was the registered scale.** `G_N=16384`; corpus 16384 contiguous; banner 16384; MEM_DEPTH 286514 TB-only; `N_BUCKETS=65536`; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 drop. xelab ~13 min is the 65536-bucket elaborate, not a fail-hidden MEM.
2. **Fill-template control still hits at scale.** `"boiler feeds header"` FILL_RE MATCH; emit `{120,121,122}` tp=3 occ=121 incomp=0; independent plain AND `{120,121,122}`. Marker requires `fill_tp>0` and bit-identical fill emit.
3. **Eight planted nids 123–130 are off the cartesian fill generator; all eight retrieve.** Independent: all 8 SRO not in `{13..132}×{1..8}`; each query SRO MATCH corpus record; each emit `{nid}` k0 occ=1 incomp=0. Marker requires `unseen_hit_n==8`. Unseen keys ≠ fill 3332/3588.
4. **Unbound SRO=(13,4,1) is not indexed and does not emit fill-grid.** Independent 0 records; gold=[]; AND 3332∩260={}; raw emit_n=0. k0-only counterfactual would leak `{120,121,122}` as first three of 121. Two-pointer AND is necessary. `UNBOUND_FILL_GRID_LEAK` path exists and was not taken.
5. **That is 8/8 identity at N=16384, not semantic mass.** N_SUBJECTS=127; unique corpus SRO=16382 of 114239 generator; each unseen occupancy-1 AND; unbound k1 occupancy=0. WO 8/8 retrieve unknown **met**. Mass / NL / 800k **not this bag**.
6. **Runtime lexicon is COPIED named 187-word. Corpus is KEEP copy.** C0 FILE unedited. Named file mtime 14:49:07 MATCH 16k byte-identical; corpus mtime 17:29:38 MATCH KEEP byte-identical; host SHA-gates and does not rewrite. xvlog bag-first documented.
7. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the context DUT master. `N_BUCKETS=65536` is a parameter instantiate of unedited `09334e42…`.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
10. **Unseen facts use C0 HVAC ids (chiller/condenser/supplies/…), not a novel entity set.** Honest vs “not in FILL_ENT generator”. Not a 12-entity × N clone (PSC=0; `pump supplies valve` not `pump supplies chiller`). Not NL. All 11 queries FILL_RE.
11. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before xvlog (18:19:54) and not rewritten. Not FAIL_LOOP.
12. **PLAN bag 7 remaining-planted-retrieve slice is “query each of 8 and unbound does not leak fill-grid” — closed as PASS_NARROW.** 800k / N=65536 / semantic mass / true NL are **not** closed and **not** started by this audit.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| INSTANTIATE keys (`124be808…`, not edited) | **PASS_NARROW** | mtime 14:03:07; this bag 18:15. Unbound/fill/plants ctx=0 so frozen `{subj,rel}` pass-through. |
| INSTANTIATE DUT (`8255a798…`, not edited, not STREAM-02 file) | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02 / 16k / HELDOUT / UNSEEN-SRO N=256 / KEEP 16K. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121 incomp=0 | **PASS_NARROW** | Cartesian control still hits at scale. Independent plain AND `{120,121,122}`. |
| UNSEEN_SRO_HIT ×8 nids 123–130; UNSEEN_SRO_8_OF_8_HIT; each SRO ∉ cart; each query MATCH planted record | **PASS_NARROW of 8/8 retrieve unknown** | Independent: nids 123–130 OUT of FILL_ENT fill. 8/8 retrieve. |
| UNBOUND_EMPTY_WALK emit_n=0; SRO=(13,4,1) not indexed; no `{120,121,122}` | **PASS_NARROW** | Independent 0 records; AND 3332∩260={}; k0-only would leak first. |
| Independent fill AND: plain k0=3332 ∩ k1=3588 = `{120,121,122}` | **PASS_NARROW** | Dual-index not required on ctx=0 fill (plain keys). occ_k0=121. |
| Independent plant AND: each pack_plain pair ∩ = `{nid}` | **PASS_NARROW** | Occupancy-1 plant; 123/125 k1 share occ=2. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys/DUT freeze (mtime 14:03, this bag 18:15) | **PASS_NARROW** | Instantiated, not edited. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. N_BUCKETS=65536 parameter. Standing `git M` vs HEAD is the C0 blob, not this bag. |
| Copied lexicon **runtime** = `df0e8833…` 187-word mtime 14:49:07; C0 FILE `38189974…` unedited NOT runtime | **PASS_NARROW** | Copied not rewritten. C0 cannot name boiler; live fill did. |
| Copied corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP | **PASS_NARROW** | Not rewritten. Host SHA-gates KEEP copy. |
| KEEP UNSEEN-SRO-16K-01 unmodified | **PASS_NARROW / UNMODIFIED** | GOLDEN 17:29:38 `dfa19dde…`; CLOSEOUT 17:52:43; corpus/lex stamps unchanged. |
| KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified | **PASS_NARROW / UNMODIFIED** | N=256 GOLDEN 17:01:44; HELDOUT GOLDEN 15:44:21; 16k GOLDEN 14:49:09; named lex byte-identical. |
| Registered unknown (8 plants off fill **and** each queried nid HITs **and** unbound not indexed **and** no fill-grid leak **and** fill control hits **and** N=16384 hosted **and** SEARCH_INCOMPLETE ABSENT **and** query SRO MATCH planted record **and** not nid keys) | **PASS_NARROW** | Raw FILL_TEMPLATE_HIT tp=3; UNSEEN_SRO_HIT ×8; UNSEEN_SRO_8_OF_8_HIT; UNBOUND_EMPTY_WALK emit_n=0; PLANTED_N=8; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_R2_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or mass. |
| 8/8 tautology / cartesian sample as mass / true NL | **HIT as quality bound, MISS as this-unknown FAIL** | WO 8/8 retrieve met. PLAN mass / NL not met. |
| nid keys / router_union / NOT_SELECTIVE relabel / 12-clone × N / N-drop / gold-after-FAIL / missed nid / unbound leak / KEEP 16K edit / independent tree write / C0 patch | **MISS (not FAIL of this unknown)** | nid unused; gold is evidence∧SRO pred; N=16384 registered; PSC=0; gold before xvlog; 8/8 HIT; leak ABSENT; KEEP mtimes pre-R2; tree ≤10:52:29; C0 FILE 2026-09-05. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; conjunct includes `incomp_retrieve==0` and `unseen_hit_n==8`. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Each unseen 1000 is 1-id identity; fill 1000 is 3-id identity; cartesian sample; reduction not emitted. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 8/8 plant / hard-empty k1 / axi_mem_model / FILL_RE. This audit does not start next bags. PLAN bag 7 remainder (true NL) OPEN. |
| Gold-before-xvlog | **PASS_NARROW** | PRE 18:19:54; xvlog 18:20:11; gold 18:19:54 KEEP-lock `be1eb641…`; named lex `df0e8833…`; corpus `6991adc7…`; no r0. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=16384 unseen-SRO **8/8 retrieve** on instantiate `qse-v2-intersect-context-02` + copied named lexicon `qse-v2-lex-semantic-16k-01` + KEEP-copied corpus `6991adc7…`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word **copied not rewritten** mtime 14:49:07; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; CLASS_fill_template `{120,121,122}` `"boiler feeds header"` `FILL_TEMPLATE_HIT` tp=3 occ=121; eight CLASS_unseen_sro_* `{123}…{130}` matching planted SROs **not** in cartesian fill over `{13..132}` `UNSEEN_SRO_HIT` ×8 `UNSEEN_SRO_8_OF_8_HIT`; CLASS_unbound_sro emit_n=0 `"boiler feeds chiller"` SRO=(13,4,1) **not indexed**, shares k0=3332 occ=121, k1=260 empty, `UNBOUND_EMPTY_WALK`, no `{120,121,122}` leak; k0-only would leak; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` / ctx DUT `8255a798…` unedited instantiate; dir file `09334e42…` unedited; KEEP UNSEEN-SRO-16K / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified; independent tree ≤10:52:29; RESULT=`PASS_THIS_GATE_ONLY` honest; N actually 16384; **not** 12-entity × N clone; gold is **not** router_union and **not** nid keys). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “semantic mass / true NL hold-out closed”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, named lex not rewritten, corpus not rewritten, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, PASS is honest, SEARCH_INCOMPLETE absent, N not dropped, lexicon copied, planted SROs off fill, each query MATCH planted record, unbound not indexed, KEEP 16K unmodified, independent tree not written). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k or mass; identity path disclosed; 8-plant-in-fill hunt fails; unbound-leak hunt fails; missed-nid hunt fails; N-drop hunt fails; KEEP unmodified). **Not** FAIL of the unseen-SRO 8/8 retrieve unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** further PLAN bag 7 remainder (real NL / held-out combinations that are not hard-empty k1). Do **not** auto-start 800k / N=65536. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-01` / `ASTRA-C1-SEMANTIC-HELDOUT-01` / `ASTRA-C1-SEMANTIC-16K-01` / `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB. **Do not rewrite** named lexicon `df0e8833…`. **Do not rewrite** corpus `6991adc7…`.

**P1 — none for this unknown** (independent FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121; UNSEEN_SRO_HIT ×8 nids 123–130 each SRO ∉ cartesian fill over `{13..132}` and each query MATCH planted record; UNSEEN_SRO_8_OF_8_HIT; UNBOUND_EMPTY_WALK emit_n=0 SRO=(13,4,1) not indexed; k0-only 3332 would leak fill-grid as first three of 121; SEARCH_INCOMPLETE ABSENT; N=16384 hosted; ctx keys/DUT not edited; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; named lexicon copied not rewritten; corpus KEEP copy not rewritten; gold PRE before xvlog; KEEP UNSEEN-SRO-16K unmodified).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=16384 unseen-SRO **8/8 retrieve** (eight planted non-grid triples exist; all eight retrieve their nid; unbound combination does not leak fill-grid) on instantiate ctx keys/DUT. Authority = raw `FILL_TEMPLATE_HIT` / eight `UNSEEN_SRO_HIT nid=123..130` / `UNSEEN_SRO_8_OF_8_HIT` / `UNBOUND_EMPTY_WALK emit_n=0` / `SEARCH_INCOMPLETE` ABSENT + independent cartesian membership + exact-key postings + named lex `df0e8833…` + corpus `6991adc7…`. Do not silent-patch STREAM-02 / CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO N=256 / KEEP 16K / C0.
2. **Do not sell this as semantic mass, true NL hold-out, Master ≥95%, or PLAN bag7 close.** N_SUBJECTS=127 is a 120-entity cartesian **sample** (16373 unique fill SRO of 114239 generator) plus 8 C0 HVAC plants; each unseen is 1-id retrieve; unbound k1 occupancy=0; all 11 queries FILL_RE. Next “semantic” bag that claims mass / NL must not be another FILL_RE pad.
3. **Parent MAY open OPTIONAL next:** further PLAN bag 7 remainder (real NL / held-out combinations that are not hard-empty k1). One unknown. **Not this audit. Do not start 800k / N=65536 from this close.** Independent PLAN bag 7 remainder remains **OPEN**.
4. **Do not auto-start C1 800k / N=65536 / BOARD_PASS.** 8/8 occupancy-1 plant + axi_mem_model + hard-empty k1 + FILL_RE sample are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused as FINAL; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on fill/unbound.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `UNBOUND_EMPTY_WALK` / `UNBOUND_FILL_GRID_LEAK` FAIL; `FILL_TEMPLATE_HIT` / `UNSEEN_SRO_HIT` required; `UNSEEN_SRO_8_OF_8_HIT` required when the unknown is 8/8; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; named lexicon copied not rewritten; corpus KEEP-copied not rewritten; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`; planted SRO in cartesian fill generator FAILs the bag; miss of any planted nid FAILs the bag.
7. Next bag should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02 / CONTEXT-02 / SEMANTIC-16K / KEEP 16K.
8. If a later law must bind synonyms that are not lexicon aliases, or walk combinations that exist in a large index without leaking fill-grid, that is a **new** named bag. Do not silent-patch `a7ng_query_role_keys_ctx.sv` or C0 extract. Do not rewrite `df0e8833…` or `6991adc7…` in place.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including UNSEEN-SRO-16K GOLDEN 17:29:38 (1-of-8 scale-identity), UNSEEN-SRO N=256 GOLDEN 17:01:44 (1-id identity), HELDOUT GOLDEN 15:44:21, SEMANTIC-16K GOLDEN 14:49:09 stay on disk as evidence of prior process.
11. Optional: print DUT `n_post` vs host `n_post` on CLASS lines so the fill 36-vs-32 and unbound 31-vs-0 residuals are not rediscovered. Neither is a this-bag FAIL.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
UNKNOWN          = N=16384 unseen-SRO 8/8 retrieve
                   (query each planted nid 123–130; each HIT; unbound empty, not {120,121,122})
VERDICT_FRAME    = PASS_NARROW of registered unknown
                   NOT OVERCLAIM of registered unknown
                   NOT FAIL of registered unknown
PROMOTION        = REJECT
                   REJECT C1 800k
                   REJECT BOARD_PASS
                   REJECT CAND_CAP_FINAL
                   REJECT DDR_QUERY_BOUND_FINAL
                   REJECT Master evidence-recall ≥95%
                   REJECT candidate-reduction ≥90%
                   REJECT N=65536
                   REJECT true NL / semantic mass close
ACCEPT_BOARD     = NO (never)
FAIL_LOOP        = NO
P1               = none
C1_800K          = OPEN
PROGRAM          = NO
KEEP_16K         = UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43 corpus 6991adc7)
INDEP_TREE       = UNMODIFIED (max 10:52:29; this audit did not write it)
INSTANTIATE      = 124be808 / 8255a798 NOT edited
POKE_V           = 0
LEFTOVER_A09     = not compiled
SEARCH_INCOMPLETE= ABSENT
NEXT             = OPTIONAL parent: true NL / non-hard-empty-k1 hold-out
                   NOT 800k / NOT N=65536 / NOT this audit
```
