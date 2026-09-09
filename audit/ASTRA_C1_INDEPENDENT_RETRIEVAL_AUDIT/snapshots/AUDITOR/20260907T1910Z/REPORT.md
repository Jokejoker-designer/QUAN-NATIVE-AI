# ASTRA auditor REPORT — 20260907T1910Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only; do not start synonym RTL)
BAG        = ASTRA-C1-SEMANTIC-NL-01
LAW        = qse-v2-intersect-context-02
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           INSTANTIATE DUT  a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             (STREAM-02 two-pointer copy; k2/k3 not probed; NOT edited)
LEXICON    = qse-v2-lex-semantic-16k-01 COPIED named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833… (mtime 14:49:07; NOT rewritten)
           include-name bag qse_role_lexicon.svh (shim `include of named file; same 14:49:07)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
CORPUS     = KEEP UNSEEN-SRO-16K-01 copy SHA 6991adc7… mtime 17:29:38 BYTE-IDENTICAL; NOT rewritten
KEEP       = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 (must be unmodified; GOLDEN 18:19:54 verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 (must be unmodified; GOLDEN 17:29:38 verified)
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
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1835Z/REPORT.md
           ACCEPT_PARTIAL (N=16384 unseen-SRO 8/8 retrieve; P1 none; parent MAY open
             OPTIONAL true NL / non-hard-empty-k1 hold-out; REJECT 800k)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 remainder (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-NL-01.md
EVIDENCE   = raw xsim.log FILL_TEMPLATE_HIT / KEYS_VS_FILL keys_match=0 /
             NL_GOLD_MISS emit={131} / FAIL GOLD_MISS / NOT_SELECTIVE_NL /
             ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER / ASTRA_C1_SEMANTIC_NL_XSIM_PASS ABSENT /
             UNRELATED_EMPTY_WALK / SEARCH_INCOMPLETE
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + KEEP UNSEEN-SRO-16K corpus 6991adc7… byte-identical
             + KEEP R2 / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 GOLDEN
           + file LastWriteTime (gold PRE 19:05:03 vs xvlog 19:05:32 vs xelab 19:18:37
             vs xsim 19:18:38–19:18:47 vs fail_r0 19:18:47 IDENTICAL SHA vs RESULTS 19:20:19)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (mtime 14:03:07 NOT this bag)
           + INSTANTIATE DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (mtime 14:03:24 NOT this bag)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime 11:43:39; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_semantic_nl.sv (poke_v, leftover A09, PASS conjunct keys_match=0 AND nl_hit)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx include order
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh G_RELEVANT vs G_EMIT / GOLDEN.json / corpus.json records
             / host_astra_c1_semantic_nl.py gold_ids(pred_direct)
           + independent twin_role extract of NL probe vs HELDOUT paraphrase vs fill-template
           + independent exact-key postings k0=3332∩k1=3588 and k0=3329∩k1=3585
             and nid 131 "boiler supplies header" (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SEMANTIC_NL  = THIS BAG (N=16384 KEEP-copied cartesian sample; NL probe
               "what does the boiler supply to the header"; keys_match=0 vs fill
               3332/3588; fill-meaning gold MISS; honest NOT_SELECTIVE_NL;
               not synonym law; not Master close; not 800k)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = TRUE_NL_DIFFERENT_KEY_SYNONYM_FAILED_THIS_GATE
                        (800k / N=65536 / synonym RTL NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP UNSEEN-SRO-16K-R2 / UNSEEN-SRO-16K / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, did not start synonym RTL, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **true-NL different-key synonym retrieve** bag `ASTRA-C1-SEMANTIC-NL-01` after auditor `20260907T1835Z` ACCEPT_PARTIAL of N=16384 unseen-SRO **8/8 retrieve** allowed parent to open OPTIONAL PLAN bag 7 remainder **true NL** (not 800k; not hard-empty k1).

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-NL-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> A query whose **bound keys after frozen QSE are NOT identical** to the fill-template control `"boiler feeds header"` (k0=3332 k1=3588), yet still retrieves the labeled gold nids for that meaning `{120,121,122}`. HELDOUT paraphrase `"what does the boiler feed to the header"` maps to the **same** keys 3332/3588 after WH-drop + `feed` RELCTX id=4 — **not** this unknown. WH-word skip alone is not enough. If frozen extract cannot produce a different-key synonym that still HITs fill-meaning gold, RESULT=`FAIL NOT_SELECTIVE_NL`. Do not fake keys. Do not nid-derived keys. Do not edit C0 lexicon/extract. Marker `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` **only** if `keys_match=0` **AND** gold HIT.

NL probe (PREREG, frozen before xvlog):

```text
nl_synonym  "what does the boiler supply to the header"
            supply RELCTX after subject → REL id=1 (not feeds id=4)
```

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` present. N actually 16384. `FILL_TEMPLATE_HIT` with tp=3 emit `{120,121,122}`. `KEYS_VS_FILL keys_match=0`. `NL_GOLD_HIT` (fill-meaning gold retrieved). `SEARCH_INCOMPLETE` **ABSENT**.
2. NL keys after frozen QSE differ from fill 3332/3588 (not HELDOUT same-key paraphrase). Gold for that **meaning** remains `{120,121,122}` (not walker emit, not nid 131).
3. Named lexicon `df0e8833…` **copied not rewritten**. C0 FILE `38189974…` unedited and **not** runtime. C0 extract `cd7baf49…` unedited. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` / ctx DUT `8255a798…` **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. KEEP bags unmodified.
4. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog and **not** regenerated after FAIL / after fail_r0; independent tree not written.
5. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k / synonym RTL. Do **not** silent-patch C0 extract to alias `supply`↔`feeds`.

If frozen extract cannot bind a non-alias synonym to different keys that still retrieve fill-meaning gold: **honest FAIL `NOT_SELECTIVE_NL`**, marker ABSENT. That is a FAIL of the unknown, not a license to relabel gold as walker emit `{131}` or to emit the PASS marker.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`, cannot close N=65536, cannot close a synonym law that was never written.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01/` (GOLDEN `be1eb641…` timestamp **18:19:54**; CLOSEOUT **18:34:48**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01/` (GOLDEN `dfa19dde…` timestamp **17:29:38**; CLOSEOUT **17:52:43**; corpus `6991adc7…`)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-01/` (GOLDEN `9fce7fad…` timestamp **17:01:44**; CLOSEOUT **17:04:05**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-HELDOUT-01/` (GOLDEN `3c1eda7d…` timestamp **15:44:21**; CLOSEOUT **16:06:53**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/` (GOLDEN `0e539d48…` timestamp **14:49:09**; CLOSEOUT **15:18:52**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-CONTEXT-02/` (GOLDEN `8fc931f5…` timestamp **14:12:02**; CLOSEOUT **14:13:59**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/` (GOLDEN `86b536fb…` timestamp **13:34:19**; CLOSEOUT **13:39:47**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/` (GOLDEN `05c6e087…` timestamp **11:43:45**; CLOSEOUT **11:45:37**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/` (GOLDEN timestamp **12:44:33**; CLOSEOUT **12:46:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-STREAM-02/` (GOLDEN timestamp **12:10:22**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN timestamp **10:46:42**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (CLOSEOUT **11:11:09**)
- C0 **FILE** hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Relbind keys `a7ng_query_role_keys_relbind.sv` = `93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d` (KEEP; **not** compiled)
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)
- Stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` = `14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac` (STREAM-02 MATCH; **not** compiled as DUT)
- Page-skip DUT `a7ng_query_axi_sparse_page_skip.sv` = `dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817` (PAGE-SKIP MATCH; **not** compiled as DUT)
- Ctx keys `a7ng_query_role_keys_ctx.sv` = `124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1` (CONTEXT-02 MATCH instantiate; **not** edited)
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` = `8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989` (CONTEXT-02 MATCH instantiate as DUT; **not** edited)

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536, starting synonym RTL, silent-patching C0 extract to alias `supply`↔`feeds`, relabeling gold as `{131}`, emitting PASS on gold miss.

Hunt (dispatch, none dropped):

1. Gold relabeled to walker emit nid 131 / `G_RELEVANT` = `{131}` sold as fill-meaning
2. PASS marker `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` present on gold miss
3. Fake FAIL (marker-or-gold theatre while unknown actually HIT; or FAIL injected without keys_match=0 / without gold miss)
4. C0 extract / C0 lexicon FILE patched (`cd7baf49` / `38189974` drift)
5. Independent audit tree written
6. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=65536 started / synonym RTL started
7. HELDOUT same-key paraphrase sold as this unknown (`keys_match=1`)
8. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
9. Named lex `df0e8833` rewritten / corpus `6991adc7` rewritten / KEEP bags edited
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys/DUT edited
12. Gold hashed after first xvlog / rewritten after fail_r0
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Host `relevant=router_union` / nid-derived keys
16. N drop (silent 256)

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **true-NL different-key synonym** unknown only.

If the measurement is an honest FAIL of that unknown, parent next is **OPTIONAL** a **NEW named synonym law** (do not silent-patch C0 extract). Do **not** auto-start C1 800k / N=65536 / synonym RTL from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. NL bag is untracked (`??`). KEEP UNSEEN-SRO-16K-R2 GOLDEN mtime **18:19:54** / CLOSEOUT **18:34:48** (not this NL window). KEEP UNSEEN-SRO-16K GOLDEN **17:29:38** / CLOSEOUT **17:52:43**. Stream DUT untracked with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same standing finding as 0840Z…1835Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T19:15:00+07:00` (file mtime **19:21:52.127**, parent-owned; auditor did not write it) `acceptance=PENDING_AUDITOR_C1_SEMANTIC_NL` `acceptance_gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` `unblocked_item=ASTRA-C1-SEMANTIC-NL-01` `implementer=DONE_FAIL` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), SEMANTIC-NL bag:

```text
14:49:07.692  qse_role_lexicon_semantic_16k.svh   ← COPIED from KEEP 16K / SEMANTIC-16K; NOT rewritten
14:49:07.692  qse_role_lexicon.svh                ← include-name shim; same stamp as 16k
17:29:38.554  corpus.json                         ← KEEP copy stamp; BYTE-IDENTICAL 6991adc7…
19:00:36.558  host_astra_c1_semantic_nl.py
19:02:38.379  tb_astra_c1_semantic_nl.sv
19:03:29.648  run_xsim.ps1
19:04:52.607  ACK.json PREREG.md
19:05:03.218  GOLDEN.json                         ← NL 3-query gold (NOT KEEP GOLDEN)
19:05:03.232  query_gold.svh
19:05:03.237  GOLD_HASH_PRE_XVLOG.txt             ← gold+named-lex+corpus hash BEFORE xvlog
19:05:31.647  SHA256.txt                          ← freeze immediately before xvlog
19:05:31.651  xsim_work/ CreationTime
19:05:32.666  xvlog.log                           ← first/only xvlog this bag
19:18:37.700  xelab.log                           ← xelab ~13 min (65536-bucket elaborate)
19:18:38      xsim session start PID 62740
19:18:47.801  xsim.log  AND  xsim_fail_r0.log     ← SAME SHA; fail_r0 is copy of this session
19:20:19.201  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO / KEEP 16K / R2. This bag starts 19:00. Ctx keys were not rewritten for NL.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer**. Not rewritten.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087**. Page-skip **13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**. Leftover A09 **2026-09-06 18:51:11.550**.

Named lexicon LastWriteTime **14:49:07.692** — **identical** to KEEP UNSEEN-SRO-16K / SEMANTIC-16K / R2 named file stamp. Hash MATCH `df0e8833…`. Byte-identical (9159 bytes). Copied, not regenerated.

Corpus LastWriteTime **17:29:38.554** — **identical** to KEEP UNSEEN-SRO-16K / R2 corpus stamp. Hash MATCH `6991adc7…`. Byte-identical (3915272 bytes). Host SHA-gates `KEEP_CORPUS_SHA=6991adc7…` and **loads** the copy (`load_copied_corpus`); does **not** call `build_corpus()` to rewrite. Hunt corpus-rewrite this bag: **MISS.**

`xsim_fail_r0.log` **PRESENT**, SHA `1ff11f304e579e954832c06e5fc2c5216f22f7f41df24cfa774151d872165db5` **IDENTICAL** to `xsim.log`. Same session header (PID **62740**, start **19:18:38**, exit **19:18:47**). `run_xsim.ps1` copies `xsim.log` → `xsim_fail_r0.log` on the honest `FAIL_NOT_SELECTIVE_NL` branch and does **not** regenerate gold. Gold files still **19:05:03** after that copy. Named lexicon still 14:49:07. Corpus still 17:29:38.

`xsim.log` SHA256 `1ff11f304e579e954832c06e5fc2c5216f22f7f41df24cfa774151d872165db5` MATCH RESULTS `XSIM_SHA`.

No new C1-800k / N=65536 bag dirs. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane (mtime 2026-09-05), not this bag. No synonym-law RTL file newer than ctx keys 14:03.

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
cce36edf983f60b94d2c3fcb885f4ec971388fae944f010a2de352a2e3c57d20  tb_astra_c1_semantic_nl.sv
aac849c44c3d1dcd795ea70ab26beddb7512121bd0fd82c647b67dd8381f51f8  host_astra_c1_semantic_nl.py
6fa2a93f15a32b2135357c8876700b89c59dcb4972936ef79f130922c593b53b  GOLDEN.json (NL 3-query; NOT KEEP GOLDEN)
b0dce42f501b875a4f21418a90dc5890108eb2ba8addd3c8e910fd11a3dd6a45  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json (KEEP copy)
```

C0 extract / lexicon FILE MATCH prior T1835Z / C0. STREAM-02 N=256 lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH. SEMANTIC-16K / KEEP 16K / R2 named lexicon `df0e8833…`. Live MATCH this bag copy (byte-identical). KEEP 16K / R2 corpus `6991adc7…`. Live MATCH this bag copy (byte-identical).

`GOLD_HASH_PRE_XVLOG.txt` mtime **19:05:03.237** vs live gold+named-lex+corpus (all MATCH):

```text
6fa2a93f15a32b2135357c8876700b89c59dcb4972936ef79f130922c593b53b  GOLDEN.json
b0dce42f501b875a4f21418a90dc5890108eb2ba8addd3c8e910fd11a3dd6a45  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
```

`xvlog.log` mtime **19:05:32.666**. Gold hashed **before** that xvlog. Gold files were **not** rewritten after xsim / after fail_r0 (still 19:05:03). SHA256.txt freeze stamp `2026-09-07T19:05:31.6013310+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **33 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple + corpus). C0 lexicon FILE live MATCH `38189974…` independently. No invented hash.

NL GOLDEN `6fa2a93f…` **differs** from KEEP 16K GOLDEN `dfa19dde…` and R2 GOLDEN `be1eb641…` because NL gold is 3 queries (fill + nl_synonym + unrelated) vs KEEP's 4-query / R2's 11-query. That is a **new-bag gold**, not a KEEP edit. Corpus SHA is the identity that must MATCH KEEP; it does.

Hunt gold-after-fail_r0: **MISS.** fail_r0 is the same bytes as the (only) xsim session. Gold PRE lock still holds.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 19:00+ |
|---|---|---|---|
| UNSEEN-SRO-16K-R2-01 (KEEP) | `be1eb641931e7666…` **18:19:54.023** | CLOSEOUT **18:34:48.146** | **UNMODIFIED** |
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

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: nfiles=6; min **10:50:50** (AGENTS.md); max **10:52:29** (PLAN.md). **files_after_18:00 = 0.** NL implementer did **not** write that tree. This auditor did **not** write that tree.

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
tb_astra_c1_semantic_nl.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir, TB). Truncation `N_BUCKETS=32...` / `DEPTH_WORDS=3...` is Vivado `32'd65536` / `32'd286514` display, **not** a drop to 32768: query_gold `G_N_BUCKETS=65536` `G_MEM_DEPTH=286514`; banner `N_BUCKETS=65536 MEM_DEPTH=286514`; TB diverges `DIR_WIDTH` if `G_N_BUCKETS != 65536` and `MEM` if depth too small; `FIRST_DIVERGENCE` ABSENT.

Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

`work.rlx` include order for extract: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_16k.svh`. TB/DUT include_dirs start with **bag**. Bag first. `work.rlx` unix mtime on named lex `1788767347` = 14:49:07 +07 (KEEP copy, not NL regen). query_gold `1788782703` = 19:05:03 +07 MATCH PRE.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; requires named lexicon + bag shim present; requires corpus SHA `6991adc7…` and named lex `df0e8833…`; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog. Honest FAIL branch copies xsim.log → fail_r0 and prints `FAIL_NOT_SELECTIVE_NL` **without** regenerating gold. PASS marker without `keys_match=0` AND `NL_GOLD_HIT` throws.

xvlog include_dirs (verbatim from `run_xsim.ps1` the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (copied named lexicon law). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. Documented copy of `qse-v2-lex-semantic-16k-01`, **not** a silent C0 59-word claim.

TB instantiates `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `MEM_DEPTH=286514` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken. `G_FILL_GRID != {120,121,122}` / `G_FILL_K0/K1 != 3332/3588` diverges not taken.

PASS marker conjunct (TB line 466): `fail==0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (keys_match == 0) && nl_hit && (incomp_retrieve == 0) && (G_N == 16384)`. `nl_hit = (tp > 0)` against **G_RELEVANT**, not against G_EMIT. Gold miss on nl_synonym increments `fail` (`FAIL GOLD_MISS class=nl_synonym missed=3`) **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. `keys_match==1` (HELDOUT paraphrase) also increments `fail` (`FAIL NL_KEYS_MATCH_FILL`). On this session the else-branch printed `NOT_SELECTIVE_NL` + `ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER` because `keys_match==0 && nl_hit==0 && fill_tp>0`.

Live: `incomp=0` on every CLASS_* retrieve line; `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **1** (`GOLD_MISS class=nl_synonym missed=3`); `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` count **0**; `FIRST_DIVERGENCE` count **0**. Hunt swallowed-incomp: **MISS this bag.** Hunt N_DROP: **MISS this bag.** Hunt PASS-on-miss: **MISS this bag.**

xsim: wall ~7 s elapsed for 3 queries; `$finish` at **9455 ns**. That is a **3-query walk**, not evidence of N drop (banner/gold/corpus all 16384; MEM_DEPTH 286514 hosted). xelab ~13 min is the 65536-bucket elaborate, same shape as KEEP 16K / R2.

### 5) PRIMARY HUNT — runtime lexicon is COPIED named 187-word; C0 extract unedited; supply≠feeds

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
```

Independent decode of C0 96-bit words: **has** `supply` / `supplies`. **Does not have** `feeds` / `feed` / `boiler` / `header`.

Named bag file `qse_role_lexicon_semantic_16k.svh`:

```text
QSE2_N_LEX = 187
hash       = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
mtime      = 2026-09-07 14:49:07.692   (same stamp as KEEP SEMANTIC-16K / UNSEEN-SRO-16K / R2 named file)
```

Independent decode of named 187-word table (LSB-first 96-bit words):

```text
supply     idx=44  CLS=4 RELCTX  id=1
supplies   idx=22  CLS=2 REL     id=1
feed       idx=180 CLS=4 RELCTX  id=4
feeds      idx=179 CLS=2 REL     id=4
boiler     idx=59  CLS=1 ENTITY  id=13
header     idx=60  CLS=1 ENTITY  id=14
what       idx=54  CLS=6 SKIP    id=1
does       idx=53  CLS=6 SKIP    id=1
the        idx=50  CLS=6 SKIP    id=1
```

**FACT:** `supply`/`supplies` are **not** lexicon aliases of `feed`/`feeds`. Different REL ids (1 vs 4). Frozen extract `cd7baf49…` (twin `twin_role.extract`, law `qse-v2-role-00`) binds RELCTX after ST_SUBJ as REL. Host refuses named-lex rewrite: live SHA must MATCH `EXPECTED_LEX_NAMED=df0e8833…` and shim `7966f321…`. Hunt “named lex regenerated this bag”: **MISS.** Hunt “C0 extract patched”: **MISS.** Hunt “C0 lexicon FILE edited”: **MISS.**

Bag `qse_role_lexicon.svh` is **three comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler`. Live CLASS_fill_template query is `"boiler feeds header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13. Hunt “silent C0 59-word runtime claim”: **MISS.**

Corpus `corpus.json` header `gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` (KEEP identity, not rewritten). SHA `6991adc7…` MATCH KEEP. Host `load_copied_corpus()` SHA-gates and does not rebuild. Hunt “corpus rewritten”: **MISS.**

Independent `twin_role.extract` after extending LEX to the named 187-word table (same NEW_ENT + feeds/feed as host; n=187):

```text
"boiler feeds header"                       SRO=(13,4,14) k0=3332 k1=3588
"what does the boiler supply to the header" SRO=(13,1,14) k0=3329 k1=3585   ← this unknown
"what does the boiler feed to the header"   SRO=(13,4,14) k0=3332 k1=3588   ← HELDOUT; NOT this unknown
"payroll tax form"                          SRO=(0,0,0)   k0=0    k1=0
"boiler supplies header"                    SRO=(13,1,14) k0=3329 k1=3585   ← indexed nid 131
```

Key arithmetic MATCH pack_plain `{subj[7:0], rel[7:0]}` / `{obj[7:0], rel[7:0]}`:

```text
3332 = 0x0D04 = {subj=13, rel=4}   boiler feeds
3588 = 0x0E04 = {obj=14,  rel=4}   header  + feeds
3329 = 0x0D01 = {subj=13, rel=1}   boiler supply
3585 = 0x0E01 = {obj=14,  rel=1}   header  + supply
```

query_gold `G_K0 = {16'h0D04, 16'h0D01, 16'h0000}` = `{3332, 3329, 0}`. `G_K1 = {16'h0E04, 16'h0E01, 16'h0000}` = `{3588, 3585, 0}`. `G_REL = {4, 1, 0}`. `G_SUBJ = {13, 13, 0}`. `G_OBJ = {14, 14, 0}`. MATCH independent extract. `G_LEN = {19, 41, 16}` MATCH `len("boiler feeds header")` / `len("what does the boiler supply to the header")` / `len("payroll tax form")`. LSB-first `G_BYTES` char0 decodes to those three strings. `FIRST_DIVERGENCE` ABSENT ⇒ DUT extract matched gold keys. Hunt fake keys / nid-derived keys: **MISS.**

### 6) INSTANTIATE keys / DUT vs nid keys / STREAM-02 not compiled

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. **No nid port.** Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through frozen `{subj,rel}`. Query classes this bag are ctx=0, so k0/k1 = pack_plain(sid,rid)/pack_plain(oid,rid).

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. k2/k3 not used to issue AR.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys/DUT edited this bag”: **MISS** (mtime 14:03, this bag 19:00). Hunt “PAGE-SKIP compiled / mixed”: **MISS.** Hunt “synonym RTL started”: **MISS** (no new keys/extract file; C0 extract still 2026-09-05).

Host gold: `gold_ids(docs, pred_direct)` for **both** fill_template and nl_synonym = nids with `evidence==1` and SRO=`(13,4,14)` **before** the walker twin. `relevant_is_router_union=false` in GOLDEN. nl_synonym `relevant` = `{120,121,122}` = fill-meaning. Walker `emit` predicted `{131}`. Hunt `relevant=router_union`: **MISS.** Hunt gold-relabel-to-131: **MISS** (`G_RELEVANT[nl] = {120,121,122}`; `G_EMIT[nl] = {131}` is host-twin emit lock, not gold).

Independent `k0==(nid<<8)` count = **0**. Coincidental `k0_plain==nid` count = **1** (same KEEP fill row as prior bags; packing arithmetic, not a nid-derived key). Host chk `k0 != (nid<<8)`. RTL has no nid input. Hunt nid-derived keys: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 19:18:38 2026**; exit **19:18:47**; PID **62740**; `$finish` at **9455 ns**.

Banner:

```text
C1_SEMANTIC_NL_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286514 N_SUBJECTS=127 N_RELS=8 FILL_GRID=120,121,122 FILL_K0=3332 FILL_K1=3588 NL_TEXT=what_does_the_boiler_supply_to_the_header
```

Named lines (verbatim authority):

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=121 ovf=1 trunc=0 dirB=32 postB=512 discB=0 descB=0 incomp=0
EMIT_fill_template n=3
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
FAIL GOLD_MISS class=nl_synonym missed=3 trunc=0 ovf=1 incomp=0
KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0 law=qse-v2-intersect-context-02
NL_GOLD_MISS tp=0 emit_n=1 gold_n=3 keys_match=0
CLASS_nl_synonym gold_n=3 emit_n=1 tp=0 fp_ev1=1 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_x1000=0 occ=119 ovf=1 trunc=0 dirB=32 postB=496 discB=0 descB=0 incomp=0
EMIT_nl_synonym n=1
  CAND nl_synonym i=0 id=131 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
EMIT_unrelated n=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
NL_SUMMARY keys_match=0 nl_hit=0 nl_tp=0 fill_tp=3 fail=1
NOT_SELECTIVE_NL keys_match=0 gold_miss=1 frozen_extract_cannot_bind_non_alias_synonym
ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER fail=1 unrelated_empty=1 fill_tp=3 fill_ids_ok=1 keys_match=0 nl_hit=0 incomp_retrieve=0 G_N=16384
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process:

```text
ASTRA_C1_SEMANTIC_NL_XSIM_PASS          = 0   (ABSENT; no exact line)
ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER     = 1
NOT_SELECTIVE_NL                        = 1
FILL_TEMPLATE_HIT                       = 1
NL_GOLD_MISS                            = 1
NL_GOLD_HIT                             = 0
FAIL <space>                            = 1   (GOLD_MISS class=nl_synonym missed=3)
SEARCH_INCOMPLETE                       = 0
FIRST_DIVERGENCE                        = 0
keys_match=0                            = 5
keys_match=1                            = 0
C1_800K=OPEN                            = 1
POKE_V=0                                = 1
```

**FACT:** PASS marker is **ABSENT**. Hunt “PASS marker present”: **MISS.**

**FACT:** `keys_match=0` is real (3329/3585 vs 3332/3588). Hunt “HELDOUT same-key sold as this unknown”: **MISS.** Hunt “fake FAIL without keys_match=0”: **MISS.**

**FACT:** fill-meaning gold missed (tp=0, missed=3, gold_n=3). Emit `{131}` is not `{120,121,122}`. Hunt “fake FAIL without gold miss”: **MISS.** Hunt “unknown actually HIT”: **MISS.**

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1. Gold miss is reported as `FAIL GOLD_MISS` / `NL_GOLD_MISS` / `NOT_SELECTIVE_NL`, not hidden. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_fill_template emit `{120,121,122}` tp=3 occ=121 incomp=0. Fill-template control still hits. N banner = 16384. Hunt “N not actually 16384”: **MISS.** Hunt “silent drop to 256”: **MISS.** Hunt “fill control sacrificed to make NL look better”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=127` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_MEM_DEPTH=286514` `G_N_WR=18561` `G_FILL_GRID={120,121,122}` `G_FILL_K0=16'h0D04` `G_FILL_K1=16'h0E04` `G_NQ=3` `G_FILL_Q=0` `G_NL_Q=1` `G_UNRELATED_Q=2`.

```text
G_NEMIT    = {3,1,0}
G_NREL     = {3,3,0}
G_OCC      = {121,119,0}
G_EMIT     q0={120,121,122}  q1={131}  q2={}
G_RELEVANT q0={120,121,122}  q1={120,121,122}  q2={}
```

**FACT:** `G_RELEVANT[nl] = {120,121,122}` not `{131}`. `G_EMIT[nl] = {131}` is the host-twin walker prediction the TB locks with `CANDIDATE_ID_MISMATCH`. Scoring gold HIT uses `G_RELEVANT`. Relabel hunt looks at `G_RELEVANT` / GOLDEN `relevant`, not at `G_EMIT`. Hunt gold-relabel: **MISS.**

GOLDEN.json (hashed before xvlog): `nl_synonym.relevant = [120,121,122]`; `nl_synonym.emit = [131]`; `nl_keys_match_fill = 0`; `nl_gold_hit_predicted = 0`; `predicted_not_selective_nl = 1`; `relevant_is_router_union = false`; `fill_meaning_gold = [120,121,122]`; `C1_800K = OPEN`; `BOARD_PASS = NOT_CLAIMED`. Host **pre-registered** the FAIL of frozen extract. XSim confirmed it. That is a stated hypothesis + measurement, not gold theatre.

### 8) Independent corpus — nid 131 is cartesian "boiler supplies header", not fill gold; AND 3329∩3585 = {131}; k1 occ=18 not hard-empty

Authority = live `corpus.json` **records** (hash `6991adc7…`, byte-identical KEEP UNSEEN-SRO-16K / R2), **not** RESULTS.

```text
n records         = 16384 (nid 0..16383 contiguous)
evidence=1        = 16384
kinds             = fill 16373 / direct_plain 1 / direct_glycol 1 / direct_steam 1 / unseen_sro 8
header gate       = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01
nid<<8 keys       = 0
```

Records at the fill-grid / plant / NL-emit nids (independent):

```text
nid 120  kind=direct_plain   text="boiler feeds header"         SRO=(13,4,14) k0=3332 k1=3588  ev=1
nid 121  kind=direct_glycol  text="boiler feeds header glycol"  SRO=(13,4,14) ctx=3
nid 122  kind=direct_steam   text="boiler feeds header steam"   SRO=(13,4,14) ctx=4
nid 123..130 kind=unseen_sro (KEEP plants; not queried this bag)
nid 131  kind=fill           text="boiler supplies header"      SRO=(13,1,14) k0=3329 k1=3585  ev=1
nid 132  kind=fill           text="boiler supplies coil"        SRO=(13,1,15)
nid 0    kind=fill           text="boiler supplies preheat"     SRO=(13,1,30) k0=3329
```

**FACT: nid 131 is a KEEP cartesian-sample fill row `"boiler supplies header"` SRO=(13,1,14), not fill-meaning gold.** Independent `SRO==(13,1,14)` nids = `{131}`. Independent `SRO==(13,4,14)` nids = `{120,121,122}`. Relabeling gold as `{131}` would convert the unknown into “retrieve the indexed surface of the same tokens”, which is **not** synonym retrieve of `"boiler feeds header"` meaning.

Independent exact-key postings (plain `{subj,rel}` / `{obj,rel}` — ctx=0 walker keys; indexer writes `k0_plain`/`k1_plain` for every row):

```text
plain k0=3332 occ=121  first16=[120,121,122,487,…]
plain k1=3588 occ=18
plain AND fill 3332∩3588 = {120,121,122}          ← CLASS_fill_template MATCH raw

plain k0=3329 occ=119  first16=[0,131,132,…]       ← 119 = |NEW_SUBJ|−1 boiler-supplies-*
plain k1=3585 occ=18   list=[104,131,2033,2984,…]  ← NOT hard-empty
plain AND nl  3329∩3585 = {131}                   ← CLASS_nl_synonym MATCH raw
fill gold ∩ AND_nl      = {}                      ← gold MISS is real
```

**FACT:** two-pointer AND of the NL keys retrieves **only** nid 131. Fill-meaning gold `{120,121,122}` is **disjoint**. k1 occupancy **18** is **not** a hard-empty k1 (contrast KEEP unbound k1=260 occ=0). The miss is **frozen-QSE synonym selectivity**, not an empty posting.

**FACT:** k0-only of 3329 would emit 16 of 119 `boiler supplies *` rows (CAND_CAP=16), starting nid 0 / 131 / 132 — **not** fill-grid `{120,121,122}`. The NL miss is not the unbound-style k0-share leak. Live AND `{131}` MATCH DUT emit. Hunt k0-only cheat sold as AND: **MISS** (AND singleton MATCH).

Independent gold (evidence=1 ∧ SRO pred, **before** walker):

```text
fill_template  (13,4,14) = {120,121,122}
nl_synonym     (13,4,14) = {120,121,122}   ← same meaning; different query surface
unrelated                  = []
```

MATCH GOLDEN `relevant` and query_gold `G_RELEVANT`. MATCH raw fill emit. MATCH raw NL gold_n=3 tp=0.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (fill `{120,121,122}` tp=3 occ=121 incomp=0; nl emit `{131}` tp=0 gold_n=3 keys_match=0; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE_NL` PRESENT; marker ABSENT). RESULT=`FAIL NOT_SELECTIVE_NL`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, N=65536, Master ≥95%. Banner `NOT_CLAIMED=…ACCEPT_BOARD`. `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `FAIL_R0=PRESENT` MATCH (identical SHA). KEEP “UNMODIFIED” mtimes MATCH live. Independent tree “max 10:52:29” MATCH live. Honesty section states walker emit `{131}` is cartesian `"boiler supplies header"` and that relabeling gold as `{131}` would fake the unknown — **MATCH independent membership**. Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt PASS overclaim: **MISS.** Hunt “true NL closed”: **MISS as claim** (implementer RESULT is FAIL).

CLOSEOUT MATCH raw: marker NOT emitted, `NOT_SELECTIVE_NL` PRESENT, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` instantiate, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…` copied mtime 14:49:07, corpus `6991adc7…` mtime 17:29:38, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 19:05:03 PRE before xvlog 19:05:32, fail_r0 is xsim.log copy, gold NOT regenerated.

Host `n_post` vs DUT `postB/16` residual: fill GOLDEN n_post=36 vs DUT postB=512→32; nl GOLDEN n_post=35 vs DUT postB=496→31. Emit locked. P2, not this-unknown FAIL. Same residual family as KEEP 16K / R2.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Gold relabeled to nid 131 | **MISS.** GOLDEN `relevant=[120,121,122]`; `G_RELEVANT[nl]={120,121,122}`; host `gold_ids(..., pred_direct)` = fill-meaning SRO=(13,4,14). `G_EMIT[nl]={131}` is walker-twin lock, not gold. Implementer Honesty names the relabel trap and did not take it. | Relabel `{131}` ⇒ FAIL as cheat. Not taken. |
| 2. PASS marker present | **MISS.** `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` count=0. `NO_MARKER` present. TB conjunct requires `nl_hit` (tp>0 vs G_RELEVANT) **and** `fail==0`. run_xsim throws if PASS without keys_match=0 AND NL_GOLD_HIT. | Marker on miss ⇒ OVERCLAIM. Absent. |
| 3. Fake FAIL | **MISS.** keys_match=0 is real (3329/3585 vs 3332/3588, MATCH independent extract + packing). Gold miss is real (AND 3329∩3585={131} disjoint from {120,121,122}). Fill control still hits. fail=1 is GOLD_MISS missed=3, not an injected counter. GOLDEN predicted_not_selective_nl=1 is a pre-registered hypothesis that XSim confirmed; gold was not rewritten to force it. | Fake FAIL would be fail=1 with tp>0 or keys_match=1 theatre. Neither. |
| 4. C0 extract / C0 lexicon FILE patched | **MISS.** extract `cd7baf49…` mtime 2026-09-05 19:48:18; C0 FILE `38189974…` mtime 2026-09-05 20:51:03. This bag 19:00. | Hash drift ⇒ FAIL. None. |
| 5. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; files_after_18:00=0; this bag starts 19:00. | Keep that tree read-only. |
| 6. C1 800k / bounds / ACCEPT_BOARD / N=65536 / synonym RTL started | **MISS as claim and as start.** Banner / PASS-else epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag (historical U5 2026-09-05 only). No new extract/keys file. This audit does not start synonym RTL. | Never grant. Never freeze. Never auto-start 800k or synonym RTL. |
| 7. HELDOUT same-key paraphrase sold as this unknown | **MISS.** Probe text is `"what does the boiler supply to the header"` (FILL_RE does **not** match; len=41). Independent extract of HELDOUT `"… feed …"` is 3332/3588 keys_match=1 — **not used**. Live keys_match=0. TB would FAIL `NL_KEYS_MATCH_FILL` if keys matched. | keys_match=1 ⇒ FAIL this unknown. Not taken. |
| 8. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0; conjunct includes `incomp_retrieve==0`; marker ABSENT. | Keep miss as FAIL on later bags. |
| 9. Named lex rewritten / corpus rewritten / KEEP edited | **MISS.** named `df0e8833…` mtime 14:49:07 MATCH KEEP 16K/R2 byte-identical; corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP; host refuses rewrite. KEEP MAX mtimes all < 19:00 (R2 CLOSEOUT 18:34:48). | Do not edit C0. Do not regenerate named lex. Do not rewrite corpus. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…` mtime 2026-09-06 18:51:11. poke_v held 0. | Keep off. |
| 11. STREAM-02 / ctx keys / ctx DUT edited or STREAM-02 compiled | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` / `8255a798…` mtime 14:03, this bag 19:00. | Hash mismatch ⇒ FAIL, do not patch. |
| 12. Gold after FAIL / after xvlog / after fail_r0 | **MISS as gold regen.** PRE 19:05:03; xvlog 19:05:32; gold still 19:05:03; named lex still 14:49:07; corpus still 17:29:38; fail_r0 SHA IDENTICAL to xsim.log (same PID 62740). | Do not regenerate gold. |
| 13. RESULTS vs xsim / 800k claim / PASS claim | **MISS.** Table MATCH raw. RESULT=`FAIL NOT_SELECTIVE_NL`. Banner `C1_800K=OPEN`. Marker ABSENT disclosed. | Authority = raw FILL_TEMPLATE_HIT + KEYS_VS_FILL keys_match=0 + NL_GOLD_MISS emit={131} + NOT_SELECTIVE_NL + PASS ABSENT + independent postings. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 33/33 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…` + corpus `6991adc7…`). | SHA256.txt 19:05:31 is the xvlog freeze. PRE 19:05:03 is the gold lock. |
| 15. `relevant=router_union` / nid keys | **MISS.** `gold_ids` = evidence=1 ∧ SRO=(13,4,14) before walker. RTL no nid port. `nid<<8` keys=0. | Keep independent labels. |
| 16. N drop (silent 256) | **MISS.** Banner/gold/corpus `N=16384`; TB `N_DROP` if `G_N!=16384` not taken; `G_N_BUCKETS=65536` `MEM_DEPTH=286514`; `FIRST_DIVERGENCE` ABSENT. 3-query wall-clock ~7 s is not a drop. | Silent drop ⇒ FAIL. This bag hosted 16384. |
| Frozen extract cannot alias supply↔feeds | **HIT as the registered unknown FAIL.** Not a cheat. keys_match=0 AND gold MISS is exactly `NOT_SELECTIVE_NL`. | Required fix = NEW named synonym law. Do not silent-patch C0 extract. |
| k1 occ=18 is not hard-empty | **HIT as quality / construction honesty.** Unbound-style empty k1 is **not** this miss. | Do not reuse hard-empty k1 as “NL”. This bag did not. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| Host n_post vs DUT postB (fill 36 vs 32; nl 35 vs 31) | **HIT as residual.** Emit locked. | Do not freeze DDR bytes. |
| NL surface is still a WH-wrap of `{ent} {rel} {ent}` with a different REL token | **HIT as quality.** Not a held-out prose paragraph. Unknown is key-selectivity of frozen QSE, which **failed**. | Do not sell as Master ≥95% / closed NL mass. Implementer did not. |

qstack-validation-adversary one-liner: **SEMANTIC-NL-01 XSim is a real N=16384 host+instantiate lock on unpatched C0 extract (`cd7baf49…`) with a **copied** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…` mtime 14:49:07 **not rewritten**) and a **KEEP-copied** corpus (`6991adc7…` mtime 17:29:38 **byte-identical**, not rewritten): bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime; frozen ctx keys `124be808…` and ctx DUT `8255a798…` instantiated not edited; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; leftover A09 off; poke_v=0; gold PRE 19:05:03 before xvlog 19:05:32 and **not** regenerated after fail_r0 (fail_r0 SHA IDENTICAL to xsim.log, same PID 62740); KEEP R2/16K/HELDOUT unmodified; independent tree ≤10:52:29; N actually 16384; fill-template control still emits `{120,121,122}` (`FILL_TEMPLATE_HIT` tp=3 occ=121 incomp=0, independent plain AND `{120,121,122}`); NL probe `"what does the boiler supply to the header"` binds `supply` RELCTX id=1 (not `feeds` id=4) so k0/k1=3329/3585 (`KEYS_VS_FILL keys_match=0`, independent twin extract MATCH; HELDOUT `"… feed …"` is 3332/3588 and was **not** used); fill-meaning gold stayed `{120,121,122}` (`G_RELEVANT` / GOLDEN `relevant`, **not** relabeled to 131); walker AND 3329∩3585 = `{131}` (`"boiler supplies header"` cartesian fill SRO=(13,1,14), k1 occ=18 **not** hard-empty); `NL_GOLD_MISS` tp=0 emit_n=1 gold_n=3; `FAIL GOLD_MISS missed=3`; `NOT_SELECTIVE_NL`; `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` **ABSENT**; `ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER`; that is an **honest FAIL of the true-NL different-key synonym unknown**, **not** OVERCLAIM, **not** gold-relabel cheat, **not** fake FAIL, **not** C0 patch, **not** 800k, **not** ACCEPT_BOARD; required fix is a **NEW named synonym law** — do not silent-patch C0 extract.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / nl `{131}` / unrelated `[]`). The registered unknown **failed**. Findings are **law-quality / required next law**, not “patch frozen QSE in place” and not “fix TB packing”:

1. **N=16384 was actually hosted.** `G_N=16384`; corpus 16384 contiguous; banner 16384; MEM_DEPTH 286514 TB-only; `N_BUCKETS=65536`; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 drop.
2. **Fill-template control still hits.** `"boiler feeds header"` FILL_RE MATCH; emit `{120,121,122}` tp=3 occ=121 incomp=0; independent plain AND `{120,121,122}`. Marker / NO_MARKER path both require this.
3. **NL keys after frozen QSE differ from fill.** Independent twin extract + packing + raw KEYS_VS_FILL: 3329/3585 vs 3332/3588. `supply` RELCTX id=1 vs `feeds` REL id=4. HELDOUT `feed` RELCTX id=4 is the same-key paraphrase and was not used. `keys_match=0` is real. This half of the unknown **held**.
4. **Fill-meaning gold did not HIT under those different keys.** Independent AND 3329∩3585 = `{131}` disjoint from `{120,121,122}`. Raw `NL_GOLD_MISS` tp=0 missed=3. Gold was **not** relabeled. This half of the unknown **failed**. Conjunction FAIL `NOT_SELECTIVE_NL`.
5. **Emit `{131}` is cartesian `"boiler supplies header"`, occupancy-1 AND, k1 occ=18.** Not hard-empty k1. Not fill-grid. Not a nid key. Relabeling gold to `{131}` would fake synonym retrieve.
6. **Frozen extract cannot bind a non-alias synonym.** Named 187-word table has no alias of feeds at a different surface that still hashes to rel id=4 except `feed` (HELDOUT, same keys). C0 59-word also has no feeds. Patching C0 extract/lexicon FILE to alias supply↔feeds would be a **silent C0 patch** and is **forbidden**.
7. **Runtime lexicon is COPIED named 187-word. Corpus is KEEP copy. C0 FILE unedited.** Named file mtime 14:49:07 MATCH 16k/R2 byte-identical; corpus mtime 17:29:38 MATCH KEEP byte-identical; host SHA-gates and does not rewrite. xvlog bag-first documented.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
10. **fail_r0 was written because the session FAILed the unknown.** Gold hashed once before xvlog (19:05:03) and not rewritten. Honest FAIL_LOOP routing for gold; **not** FAIL_LOOP of the bag’s hashes/cheats.
11. **Required next law is a named synonym bind, not a C0 patch and not 800k.** One unknown. Not this audit.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 / synonym RTL in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW of the measurement harness** | Simulation only. Not DDR. Not 800k. |
| INSTANTIATE keys (`124be808…`, not edited) | **PASS_NARROW** | mtime 14:03:07; this bag 19:00. ctx=0 so frozen `{subj,rel}` pass-through. |
| INSTANTIATE DUT (`8255a798…`, not edited, not STREAM-02 file) | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02 / 16k / HELDOUT / UNSEEN-SRO / R2. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121 incomp=0 | **PASS_NARROW** | Cartesian control still hits. Independent plain AND `{120,121,122}`. |
| KEYS_VS_FILL keys_match=0 (3329/3585 vs 3332/3588) | **PASS_NARROW of the key-selectivity half** | Independent twin extract MATCH. Not HELDOUT same-key. |
| NL_GOLD_HIT / fill-meaning gold retrieve under different keys | **FAIL of the registered unknown** | Independent AND `{131}` disjoint from `{120,121,122}`. Raw `NL_GOLD_MISS` tp=0 missed=3. |
| `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` | **ABSENT (correct)** | Conjunct requires keys_match=0 **AND** nl_hit. nl_hit=0. |
| `NOT_SELECTIVE_NL` / `ASTRA_C1_SEMANTIC_NL_XSIM_NO_MARKER` | **PRESENT / HONEST** | keys_match=0 gold_miss=1 fill_tp=3 G_N=16384. |
| Gold stay `{120,121,122}` not relabeled to 131 | **PASS_NARROW of gold discipline** | G_RELEVANT / GOLDEN relevant MATCH fill-meaning. G_EMIT `{131}` is twin lock. |
| Gold-before-xvlog / not regen after fail_r0 | **PASS_NARROW** | PRE 19:05:03; xvlog 19:05:32; gold 19:05:03; fail_r0 SHA IDENTICAL to xsim.log. |
| Independent fill AND: plain k0=3332 ∩ k1=3588 = `{120,121,122}` | **PASS_NARROW** | occ_k0=121. |
| Independent NL AND: plain k0=3329 ∩ k1=3585 = `{131}` | **PASS_NARROW of the measurement** | k1 occ=18 not hard-empty. Occupancy-1 cartesian surface, not synonym. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys/DUT freeze (mtime 14:03, this bag 19:00) | **PASS_NARROW** | Instantiated, not edited. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. Standing `git M` vs HEAD is the C0 blob, not this bag. |
| Copied lexicon **runtime** = `df0e8833…` 187-word mtime 14:49:07; C0 FILE `38189974…` unedited NOT runtime; C0 extract `cd7baf49…` unedited | **PASS_NARROW** | Copied not rewritten. C0 cannot name boiler; live fill did. C0 has supply id=1, not feeds. |
| Copied corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP | **PASS_NARROW** | Not rewritten. Host SHA-gates KEEP copy. |
| KEEP R2 / UNSEEN-SRO-16K / HELDOUT / SEMANTIC-16K unmodified | **PASS_NARROW / UNMODIFIED** | R2 GOLDEN 18:19:54; 16K GOLDEN 17:29:38; HELDOUT GOLDEN 15:44:21; SEMANTIC-16K GOLDEN 14:49:09. |
| Registered unknown (different-key NL **and** fill-meaning gold HIT) | **FAIL NOT_SELECTIVE_NL (honest)** | keys_match=0 held; gold HIT failed. Marker ABSENT. |
| Implementer RESULT=`FAIL NOT_SELECTIVE_NL` | **HONEST vs raw** | Not OVERCLAIM of the unknown. Not PASS. |
| Gold-relabel / PASS-on-miss / fake FAIL / C0 patch / independent tree / 800k claim | **MISS as cheat** | See hunt table. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Unknown failed; cartesian sample; reduction not emitted. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | Honest FAIL of NL synonym. axi_mem_model. This audit does not start next bags. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL of the measurement only** (N=16384 true-NL different-key probe on instantiate `qse-v2-intersect-context-02` + copied named lexicon `qse-v2-lex-semantic-16k-01` + KEEP-copied corpus `6991adc7…`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word **copied not rewritten** mtime 14:49:07; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; CLASS_fill_template `{120,121,122}` `"boiler feeds header"` `FILL_TEMPLATE_HIT` tp=3 occ=121; CLASS_nl_synonym `"what does the boiler supply to the header"` k0=3329 k1=3585 `KEYS_VS_FILL keys_match=0`; fill-meaning gold stayed `{120,121,122}` **not** relabeled to 131; walker emit `{131}` `"boiler supplies header"` SRO=(13,1,14) independent AND 3329∩3585; `NL_GOLD_MISS` tp=0; `NOT_SELECTIVE_NL`; PASS marker **ABSENT**; leftover off; poke_v=0; gold-before-xvlog; fail_r0 = xsim.log copy, gold not regenerated; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` / ctx DUT `8255a798…` unedited instantiate; dir file `09334e42…` unedited; KEEP R2 / UNSEEN-SRO-16K / HELDOUT / SEMANTIC-16K unmodified; independent tree ≤10:52:29; RESULT=`FAIL NOT_SELECTIVE_NL` honest; N actually 16384; gold is **not** router_union and **not** nid keys; k1 occ=18 **not** hard-empty). **FAIL of the registered unknown** (different-key synonym retrieve of fill-meaning gold). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “true NL hold-out closed”, “synonym law closed”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, named lex not rewritten, corpus not rewritten, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, PASS is honestly absent, SEARCH_INCOMPLETE absent, N not dropped, lexicon copied, KEEP unmodified, independent tree not written, FAIL is not fake, gold not relabeled). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer RESULT is FAIL; identity path disclosed; relabel hunt fails; PASS-marker hunt fails; C0-patch hunt fails).

**P1 for this measurement: none** (the FAIL is the unknown). Parent next is **OPTIONAL** a **NEW named synonym law** (do not silent-patch C0 extract). Do **not** auto-start 800k / N=65536 / synonym RTL from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-NL-01` gold/xsim/RESULTS to “improve” this audit into a PASS. **Do not edit** KEEP `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-01` / `ASTRA-C1-SEMANTIC-HELDOUT-01` / `ASTRA-C1-SEMANTIC-16K-01` / `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0 extract or C0 lexicon FILE.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB. **Do not rewrite** named lexicon `df0e8833…`. **Do not rewrite** corpus `6991adc7…`. **Do not relabel gold as `{131}`.** **Do not emit the PASS marker on this bag.** **Do not start synonym RTL or 800k in this audit.**

**P1 — none for this measurement** (independent FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121; KEYS_VS_FILL keys_match=0 k0=3329 k1=3585 vs 3332/3588 MATCH twin extract; NL_GOLD_MISS emit `{131}` gold `{120,121,122}` independent AND 3329∩3585=`{131}` disjoint from fill gold; PASS marker ABSENT; NOT_SELECTIVE_NL PRESENT; SEARCH_INCOMPLETE ABSENT; N=16384 hosted; ctx keys/DUT not edited; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; C0 extract unedited; named lexicon copied not rewritten; corpus KEEP copy not rewritten; gold PRE before xvlog; gold not regen after fail_r0; KEEP unmodified; independent tree not written; gold not relabeled; 800k not claimed).

**Required fix (parent / next law — not this audit, not a silent C0 patch):**

1. **NEW named synonym law.** Frozen `qse-v2-role-00` + named `qse-v2-lex-semantic-16k-01` cannot bind a non-alias synonym (`supply` RELCTX id=1) to the fill-meaning keys of `feeds` (REL id=4) while still retrieving `{120,121,122}`. A later bag that claims this unknown must introduce a **new named law id** (synonym / alias table / dual-rel bind) with its own contract frozen **before** coding, its own gold bag, and hash-gates that **do not** overwrite `cd7baf49…` / `38189974…` in place. Do **not** silent-patch C0 extract. Do **not** alias by rewriting `df0e8833…` in KEEP bags. Do **not** start that RTL in this audit.
2. **Keep this bag as FAIL NOT_SELECTIVE_NL evidence.** Authority = raw `FILL_TEMPLATE_HIT` / `KEYS_VS_FILL keys_match=0` / `NL_GOLD_MISS emit={131}` / `NOT_SELECTIVE_NL` / `ASTRA_C1_SEMANTIC_NL_XSIM_PASS` ABSENT + independent twin extract + exact-key postings + named lex `df0e8833…` + corpus `6991adc7…`. Do not silent-patch STREAM-02 / CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO / R2 / C0 to make this PASS.
3. **Do not relabel gold as `{131}`** in a follow-up of this bag. `{131}` is cartesian `"boiler supplies header"` SRO=(13,1,14). That would convert the unknown into surface-identity retrieve.
4. **Do not sell this as true NL closed, Master ≥95%, or PLAN bag7 close.** keys_match=0 without gold HIT is the FAIL. Next synonym bag must still HIT `{120,121,122}` under different keys.
5. **Do not auto-start C1 800k / N=65536 / BOARD_PASS / synonym RTL from this close.** Honest FAIL + axi_mem_model + cartesian sample are the stop.
6. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused as FINAL; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on fill/nl.
7. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `FILL_TEMPLATE_HIT` required; `KEYS_VS_FILL keys_match=0` required for this unknown; `NL_GOLD_HIT` required for PASS; `NOT_SELECTIVE_NL` + marker ABSENT on keys_match=0 ∧ gold miss; `FAIL NL_KEYS_MATCH_FILL` on HELDOUT same-key; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; named lexicon copied not rewritten; corpus KEEP-copied not rewritten; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`; gold stay fill-meaning not walker emit.
8. Next bag that claims synonym retrieve should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this FAIL bag or of STREAM-02 / CONTEXT-02 / SEMANTIC-16K / KEEP 16K / C0.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board. This audit does not write it.
10. KEEP bags including R2 GOLDEN 18:19:54 (8/8 retrieve), UNSEEN-SRO-16K GOLDEN 17:29:38 (1-of-8 scale-identity), UNSEEN-SRO N=256 GOLDEN 17:01:44, HELDOUT GOLDEN 15:44:21 (same-key paraphrase, **not** this unknown), SEMANTIC-16K GOLDEN 14:49:09 stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL of the MEASUREMENT only
UNKNOWN          = true-NL different-key synonym retrieve
                   (keys after frozen QSE ≠ fill 3332/3588 AND fill-meaning gold {120,121,122} HIT)
VERDICT_FRAME    = FAIL of registered unknown (honest NOT_SELECTIVE_NL)
                   NOT OVERCLAIM of the FAIL
                   NOT cheat (gold not relabeled to 131; PASS marker ABSENT;
                     FAIL not fake; C0 unpatched; independent tree not written;
                     800k not claimed)
PROMOTION        = REJECT
                   REJECT C1 800k
                   REJECT BOARD_PASS
                   REJECT CAND_CAP_FINAL
                   REJECT DDR_QUERY_BOUND_FINAL
                   REJECT Master evidence-recall ≥95%
                   REJECT candidate-reduction ≥90%
                   REJECT N=65536
                   REJECT true NL / synonym-law close
ACCEPT_BOARD     = NO (never)
FAIL_LOOP        = NO
P1               = none for this measurement
REQUIRED_FIX     = NEW named synonym law
                   (do not silent-patch C0 extract cd7baf49 / C0 lexicon FILE 38189974)
C1_800K          = OPEN
PROGRAM          = NO
KEEP_R2          = UNMODIFIED (GOLDEN 18:19:54 CLOSEOUT 18:34:48)
KEEP_16K         = UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43 corpus 6991adc7)
INDEP_TREE       = UNMODIFIED (max 10:52:29; this audit did not write it)
INSTANTIATE      = 124be808 / 8255a798 NOT edited
C0_EXTRACT       = UNEDITED cd7baf49 (mtime 2026-09-05 19:48:18)
C0_LEXICON_FILE  = UNEDITED 38189974 (mtime 2026-09-05 20:51:03; NOT runtime)
POKE_V           = 0
LEFTOVER_A09     = not compiled
SEARCH_INCOMPLETE= ABSENT
PASS_MARKER      = ABSENT
NOT_SELECTIVE_NL = PRESENT keys_match=0 gold_miss=1 emit={131}
GOLD_AFTER_FAIL  = NO (PRE 19:05:03; fail_r0 SHA = xsim.log SHA)
NEXT             = OPTIONAL parent: NEW named synonym law
                   NOT silent C0 patch
                   NOT 800k / NOT N=65536 / NOT synonym RTL this audit
```
