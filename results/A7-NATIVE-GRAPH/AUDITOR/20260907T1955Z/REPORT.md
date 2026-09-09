# ASTRA auditor REPORT — 20260907T1955Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only; do not start 800k / do not grow synonym table)
BAG        = ASTRA-C1-SYNONYM-LAW-01
LAW        = qse-v2-relctx-synonym-01  NEW named overlay (1-pair: REL id 1→4)
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           DUT NEW wrap a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e…
             (frozen extract cd7baf49 + overlay e862208c + keys_ctx 124be808
              + STREAM-02 two-pointer copy; k2/k3 not probed)
           CTX DUT a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             KEEP; NOT compiled as DUT; NOT edited
LEXICON    = qse-v2-lex-semantic-16k-01 COPIED named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833… (mtime 14:49:07; NOT rewritten)
           include-name bag qse_role_lexicon.svh (shim `include of named file; same 14:49:07)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
CORPUS     = KEEP UNSEEN-SRO-16K-01 copy SHA 6991adc7… mtime 17:29:38 BYTE-IDENTICAL; NOT rewritten
KEEP       = ASTRA-C1-SEMANTIC-NL-01 (must be unmodified; honest FAIL NOT_SELECTIVE_NL;
             GOLDEN 19:05:03 SHA 6fa2a93f… verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 (must be unmodified; GOLDEN 18:19:54 verified)
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
           + ctx DUT a7ng_query_axi_sparse_intersect_context.sv 8255a798… (KEEP; NOT compiled as DUT; NOT edited)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1910Z/REPORT.md
           ACCEPT_PARTIAL of SEMANTIC-NL measurement; honest FAIL NOT_SELECTIVE_NL;
           REQUIRED_FIX NEW named synonym law (not silent C0 patch); REJECT 800k
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 remainder (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SYNONYM-LAW-01.md
EVIDENCE   = raw xsim.log FILL_TEMPLATE_HIT / FROZEN_KEYS_VS_FILL keys_match=0 /
             SYN_KEYS_VS_FILL keys_match=1 / NL_GOLD_HIT tp=3 emit={120,121,122} /
             emit_has_131=0 / ASTRA_C1_SYNONYM_LAW_XSIM_PASS / UNRELATED_EMPTY_WALK /
             SEARCH_INCOMPLETE ABSENT / FIRST_DIVERGENCE ABSENT
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + KEEP UNSEEN-SRO-16K corpus 6991adc7… byte-identical
             + NEW synonym table 551655a1… + overlay e862208c… + wrap DUT a84bbf7e…
             + KEEP SEMANTIC-NL GOLDEN 6fa2a93f… / R2 / UNSEEN-SRO N=256 / HELDOUT /
             SEMANTIC-16K / CONTEXT-02 GOLDEN
           + file LastWriteTime (gold PRE 19:49:47 vs SHA256 19:50:25 vs xvlog 19:50:26
             vs xelab 20:03:33 vs xsim 20:03:34–20:03:44 vs RESULTS 20:05:22;
             gold still 19:49:47 after PASS)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (mtime 14:03:07 NOT this bag)
           + KEEP ctx DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (mtime 14:03:24 NOT this bag; NOT compiled as DUT)
           + NEW overlay rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv (mtime 19:42:02)
           + NEW table rtl/native_graph/query/qse_relctx_synonym_01.svh (mtime 19:42:02; QSE_SYN_N=1)
           + NEW wrap DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv
             (mtime 19:42:02)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime 11:43:39; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_synonym_law.sv (shadow frozen extract + overlay + DUT wrap;
             poke_v; leftover A09; PASS conjunct frozen0 AND syn1 AND nl_tp>=3 AND emit_has_131==0)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx include order
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh G_RELEVANT vs G_EMIT / G_REL vs G_REL_SYN / G_K0_FROZEN vs G_K0
             / GOLDEN.json / corpus.json records / host_astra_c1_synonym_law.py gold_ids(pred_direct)
           + independent twin packing of NL probe vs fill-template vs cartesian nid 131
           + independent exact-key postings k0=3332∩k1=3588 and k0=3329∩k1=3585
             and nid 131 "boiler supplies header" (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SYNONYM_LAW  = THIS BAG (N=16384 KEEP-copied cartesian sample; 1-alias overlay
               REL id 1 supply → REL id 4 feeds; probe
               "what does the boiler supply to the header"; frozen keys_match=0
               vs fill 3332/3588; synonym keys_match=1; fill-meaning gold HIT
               {120,121,122}; emit_has_131=0; not general NL; not Master close; not 800k)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = 1_ALIAS_SUPPLY_TO_FEEDS_THIS_GATE_ONLY
                        (800k / N=65536 / general NL / extra alias pairs NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP SEMANTIC-NL-01 (honest FAIL) / UNSEEN-SRO-16K-R2 / UNSEEN-SRO-16K / UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, did not grow the 1-pair synonym table, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **named synonym-law 1-alias retrieve** bag `ASTRA-C1-SYNONYM-LAW-01` after auditor `20260907T1910Z` ACCEPT_PARTIAL of SEMANTIC-NL measurement and honest FAIL `NOT_SELECTIVE_NL` required parent to open a **NEW named synonym law** (not a silent C0 extract patch; not 800k).

`results/A7-NATIVE-GRAPH/ASTRA-C1-SYNONYM-LAW-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> Named overlay so `"what does the boiler supply to the header"` retrieves fill-meaning gold `{120,121,122}` (feeds), **not** cartesian `"boiler supplies header"` nid 131. Frozen extract still binds `supply` RELCTX → REL id=1 (keys 3329/3585). That frozen keys_match vs fill **must stay 0** (proves C0 unpatched). Synonym overlay remaps rel 1→4 so DUT keys become fill 3332/3588 and the walker HITs `{120,121,122}`. Do **not** relabel gold as `{131}`. Do **not** silent-patch C0 extract.

NL probe (PREREG, frozen before xvlog):

```text
fill_template  "boiler feeds header"                       k0=3332 k1=3588  SRO=(13,4,14)
nl_synonym     "what does the boiler supply to the header"  frozen supply RELCTX→REL id=1
                                                            frozen k0=3329 k1=3585
                                                            synonym rel=4 keys 3332/3588
unrelated      "payroll tax form"                           empty walk
```

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` present. N actually 16384. `FILL_TEMPLATE_HIT` with tp=3 emit `{120,121,122}`. `FROZEN_KEYS_VS_FILL keys_match=0`. `SYN_KEYS_VS_FILL keys_match=1`. `NL_GOLD_HIT` tp=3 on fill-meaning gold `{120,121,122}`. `emit_has_131=0`. `SEARCH_INCOMPLETE` **ABSENT**.
2. Frozen extract keys after unpatched QSE differ from fill 3332/3588 (not HELDOUT same-key paraphrase; not a C0 alias). Synonym DUT keys remap to fill. Gold for that **meaning** remains `{120,121,122}` (not walker emit of nid 131).
3. Named lexicon `df0e8833…` **copied not rewritten**. C0 FILE `38189974…` unedited and **not** runtime. C0 extract `cd7baf49…` unedited. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` **not** edited. Ctx DUT `8255a798…` **not** compiled as DUT; **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. KEEP bags unmodified including SEMANTIC-NL-01 FAIL evidence. New files only: `qse_relctx_synonym_01.svh` / `a7ng_query_role_relctx_synonym.sv` / `a7ng_query_axi_sparse_intersect_synonym.sv`.
4. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog and **not** regenerated after xsim; independent tree not written.
5. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k. Do **not** silent-patch C0 extract to alias `supply`↔`feeds`. Do **not** sell a 1-pair table as general NL.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`, cannot close N=65536, cannot close general NL / multi-alias synonym mass.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-NL-01/` (GOLDEN `6fa2a93f…` timestamp **19:05:03**; CLOSEOUT **19:20:19**; honest FAIL `NOT_SELECTIVE_NL`)
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
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` = `8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989` (CONTEXT-02 MATCH; **not** compiled as DUT; **not** edited)

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags including SEMANTIC-NL-01, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536, silent-patching C0 extract to alias `supply`↔`feeds`, relabeling gold as `{131}`, selling 1-pair as general NL.

Hunt (dispatch, none dropped):

1. C0 extract / C0 lexicon FILE patched (`cd7baf49` / `38189974` drift) so frozen keys_match=1
2. Gold relabeled to walker emit nid 131 / `G_RELEVANT` = `{131}` sold as fill-meaning
3. 1-pair table (`QSE_SYN_N=1`, id 1→4) overclaimed as general NL / Master synonym mass
4. Independent audit tree written
5. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=65536 started
6. SEMANTIC-NL FAIL bag edited (gold/xsim/RESULTS rewritten to un-FAIL)
7. PASS marker without frozen keys_match=0 AND syn keys_match=1 AND NL_GOLD_HIT tp=3 AND emit_has_131=0
8. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
9. Named lex `df0e8833` rewritten / corpus `6991adc7` rewritten / KEEP bags edited
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys edited; ctx DUT `8255a798…` compiled as DUT
12. Gold hashed after first xvlog / rewritten after xsim
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Host `relevant=router_union` / nid-derived keys
16. N drop (silent 256)

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k / general NL. This is the **1-alias supply→feeds retrieve** unknown only.

If the measurement is an honest HIT of that 1-alias unknown: **PASS_NARROW** + **ACCEPT_PARTIAL this 1-alias only**. **REJECT_PROMOTION** of C1 800k / BOARD_PASS / general NL / `CAND_CAP_FINAL`. Never `ACCEPT_BOARD`. Do **not** auto-start C1 800k / N=65536 from this audit.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. Synonym bag is untracked (`??`). New RTL files untracked:

```text
?? rtl/native_graph/query/qse_relctx_synonym_01.svh
?? rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv
?? rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv
?? results/A7-NATIVE-GRAPH/ASTRA-C1-SYNONYM-LAW-01/
```

KEEP SEMANTIC-NL GOLDEN mtime **19:05:03** / CLOSEOUT **19:20:19** (not this synonym window). KEEP UNSEEN-SRO-16K-R2 GOLDEN **18:19:54** / CLOSEOUT **18:34:48**. Stream DUT untracked with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same standing finding as 0840Z…1910Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T19:55:00+07:00` (file mtime **20:06:41.094**, parent-owned; auditor did not write it) `acceptance=PENDING_AUDITOR_C1_SYNONYM_LAW` `acceptance_gate=ASTRA-C1-SEMANTIC-NL-01` `unblocked_item=ASTRA-C1-SYNONYM-LAW-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false` `nl=AUDITOR_HONEST_FAIL_NOT_SELECTIVE_NL`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), SYNONYM-LAW bag:

```text
14:49:07.692  qse_role_lexicon_semantic_16k.svh   ← COPIED from KEEP 16K / SEMANTIC-16K; NOT rewritten
14:49:07.692  qse_role_lexicon.svh                ← include-name shim; same stamp as 16k
17:29:38.554  corpus.json                         ← KEEP copy stamp; BYTE-IDENTICAL 6991adc7…
19:42:02.355  qse_relctx_synonym_01.svh           ← NEW 1-pair table (rtl + bag identical)
19:42:02.355  rtl a7ng_query_role_relctx_synonym.sv
19:42:02.364  rtl a7ng_query_axi_sparse_intersect_synonym.sv
19:44:03.582  host_astra_c1_synonym_law.py
19:45:45.288  tb_astra_c1_synonym_law.sv
19:48:02.403  run_xsim.ps1
19:49:33.518  ACK.json PREREG.md
19:49:47.963  GOLDEN.json                         ← synonym 3-query gold (NOT KEEP GOLDEN; NOT NL FAIL gold)
19:49:47.977  query_gold.svh
19:49:47.982  GOLD_HASH_PRE_XVLOG.txt             ← gold+named-lex+corpus+syn-table hash BEFORE xvlog
19:50:25.642  SHA256.txt                          ← freeze immediately before xvlog
19:50:26.616  xvlog.log                           ← first/only xvlog this bag
20:03:33.379  xelab.log                           ← xelab ~13 min (65536-bucket elaborate)
20:03:34      xsim session start PID 64248
20:03:44.413  xsim.log
20:05:22.946  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO / KEEP 16K / R2 / SEMANTIC-NL. This bag starts 19:42. Ctx keys were not rewritten for synonym.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer**. Not rewritten. Not compiled as DUT.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087**. Page-skip **13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**. Leftover A09 **2026-09-06 18:51:11.550**.

Named lexicon LastWriteTime **14:49:07.692** — **identical** to KEEP UNSEEN-SRO-16K / SEMANTIC-16K / R2 / SEMANTIC-NL named file stamp. Hash MATCH `df0e8833…`. Byte-identical (9159 bytes). Copied, not regenerated.

Corpus LastWriteTime **17:29:38.554** — **identical** to KEEP UNSEEN-SRO-16K / R2 / SEMANTIC-NL corpus stamp. Hash MATCH `6991adc7…`. Byte-identical (3915272 bytes). Host SHA-gates `KEEP_CORPUS_SHA=6991adc7…` and **loads** the copy (`load_copied_corpus`); does **not** call `build_corpus()` on the live path. Hunt corpus-rewrite this bag: **MISS.**

`xsim_fail_r0.log` **ABSENT** (session PASSed; `run_xsim.ps1` copies fail_r0 only on FAIL / PASS-without-conjunct). Gold files still **19:49:47** after xsim **20:03:44**. Named lexicon still 14:49:07. Corpus still 17:29:38.

`xsim.log` SHA256 `fe4b0ac4690868abed79a1a108d2bc566e75b5150fed2637088b24b24844068b` MATCH RESULTS `XSIM_SHA`.

No new C1-800k / N=65536 bag dirs. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane (mtime 2026-09-05), not this bag.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / KEEP DUT / copied lexicon / copied corpus / NEW overlay

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
                                                                  (CONTEXT-02 MATCH; mtime 14:03:24; NOT compiled as DUT; NOT edited)
551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd  rtl qse_relctx_synonym_01.svh
                                                                  **NEW 1-pair table; mtime 19:42:02; bag copy IDENTICAL**
e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922  a7ng_query_role_relctx_synonym.sv
                                                                  **NEW overlay; mtime 19:42:02**
a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8  a7ng_query_axi_sparse_intersect_synonym.sv
                                                                  **NEW wrap DUT; mtime 19:42:02**
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
                                                                  **this IS the compiled runtime table; COPIED; mtime 14:49:07**
7966f321171cfe97b396ad90bb1ebd156c09a165782df40a3a98109ee59ac263  bag qse_role_lexicon.svh (one-line `include of named file)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7  a7ng_gate14_crc.svh
732193bffcf155d6582e23c832f417edc4d35e134812479c94f857ca87bc00af  tb_astra_c1_synonym_law.sv
fbf7143e73f5b55b7ea6c37e343c060d2b1ff28cb9404f8226f8c29f127c0923  host_astra_c1_synonym_law.py
587e6ac3841105f1a570b28094784dfdad3eff168549d9d8112280af02022936  GOLDEN.json (synonym 3-query; NOT KEEP; NOT NL FAIL gold)
d61a444805ebe9d1673c333496cdfcaf996b66d01afa8fb5d886ffcffb854608  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json (KEEP copy)
```

C0 extract / lexicon FILE MATCH prior T1910Z / C0. STREAM-02 N=256 lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH. SEMANTIC-16K / KEEP 16K / R2 / SEMANTIC-NL named lexicon `df0e8833…`. Live MATCH this bag copy (byte-identical). KEEP 16K / R2 / SEMANTIC-NL corpus `6991adc7…`. Live MATCH this bag copy (byte-identical).

`GOLD_HASH_PRE_XVLOG.txt` mtime **19:49:47.982** vs live gold+named-lex+corpus+syn-table (all MATCH):

```text
587e6ac3841105f1a570b28094784dfdad3eff168549d9d8112280af02022936  GOLDEN.json
d61a444805ebe9d1673c333496cdfcaf996b66d01afa8fb5d886ffcffb854608  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd  qse_relctx_synonym_01.svh
```

`xvlog.log` mtime **19:50:26.616**. Gold hashed **before** that xvlog. Gold files were **not** rewritten after xsim (still 19:49:47). SHA256.txt freeze stamp `2026-09-07T19:50:25.5896068+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **39 checked, 0 mismatches, 0 missing** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, NEW synonym table/overlay/wrap DUT, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple + corpus + syn-table). C0 lexicon FILE live MATCH `38189974…` independently. No invented hash.

Synonym GOLDEN `587e6ac3…` **differs** from SEMANTIC-NL GOLDEN `6fa2a93f…` and KEEP 16K GOLDEN `dfa19dde…` because synonym gold is a new 3-query bag (fill + nl_synonym after overlay + unrelated) vs NL FAIL gold (same three queries, predicted miss). That is a **new-bag gold**, not a KEEP / NL-FAIL edit. Corpus SHA is the identity that must MATCH KEEP; it does.

Hunt gold-after-xsim: **MISS.** Gold PRE lock still holds. fail_r0 ABSENT because the session PASSed.

### 3) KEEP bags unmodified (including SEMANTIC-NL FAIL evidence)

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 19:42+ |
|---|---|---|---|
| SEMANTIC-NL-01 (KEEP FAIL) | `6fa2a93f15a32b21…` **19:05:03.218** | CLOSEOUT **19:20:19.201** | **UNMODIFIED** |
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

SEMANTIC-NL FAIL bag GOLDEN still `6fa2a93f…` mtime **19:05:03**; xsim.log still SHA `1ff11f30…` mtime **19:18:47**; RESULTS/CLOSEOUT still **19:20:19**. This synonym bag starts **19:42**. Hunt “SEMANTIC-NL FAIL bag edited”: **MISS.**

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: nfiles=6; min **10:50:50** (AGENTS.md); max **10:52:29** (PLAN.md). **files_after_19:20 = 0.** Synonym implementer did **not** write that tree. This auditor did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / STREAM-02 not DUT / ctx DUT not DUT / include_dirs

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_relctx_synonym.sv
a7ng_query_role_keys_ctx.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_intersect_synonym.sv
tb_astra_c1_synonym_law.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_extract`, `a7ng_query_role_relctx_synonym`, `a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_synonym`, frozen dir, TB). Truncation `N_BUCKETS=32...` / `DEPTH_WORDS=3...` is Vivado `32'd65536` / `32'd286514` display, **not** a drop to 32768: query_gold `G_N_BUCKETS=65536` `G_MEM_DEPTH=286514`; banner `N_BUCKETS=65536 MEM_DEPTH=286514`; TB diverges `DIR_WIDTH` if `G_N_BUCKETS != 65536` and `MEM` if depth too small; `FIRST_DIVERGENCE` ABSENT.

Work `*.sdb`: extract, **relctx_synonym**, **keys_ctx**, gate, dir, mem model, **intersect_synonym**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`, **`a7ng_query_axi_sparse_intersect_context` (8255a798 NOT compiled as DUT)**.

`work.rlx` include order for extract: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_16k.svh`. Overlay include: bag `qse_relctx_synonym_01.svh`. TB/DUT include_dirs start with **bag**. Bag first. `work.rlx` unix mtime on named lex `1788767347` = 14:49:07 +07 (KEEP copy, not synonym regen). query_gold `1788785387` = 19:49:47 +07 MATCH PRE. synonym table `1788784922` = 19:42:02 +07. extract `1788612498` = 2026-09-05 19:48:18 +07. keys_ctx `1788764587` = 14:03:07 +07.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys / **ctx DUT** on xvlog list; requires named lexicon + bag shim present; requires corpus SHA `6991adc7…` and named lex `df0e8833…`; requires bag synonym table SHA == rtl synonym table SHA; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog. PASS marker without `FROZEN_KEYS_VS_FILL keys_match=0` AND `SYN_KEYS_VS_FILL keys_match=1` AND `NL_GOLD_HIT tp=3` OR with `FAIL EMIT_NID_131` / `^FAIL ` throws.

xvlog include_dirs (verbatim from `run_xsim.ps1` the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (copied named lexicon law + bag synonym table). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. Overlay `` `include "qse_relctx_synonym_01.svh" `` binds the **bag copy** of the 1-pair table (byte-identical to rtl). Documented copy of `qse-v2-lex-semantic-16k-01` + new `qse-v2-relctx-synonym-01`, **not** a silent C0 59-word claim and **not** a C0 extract patch.

TB instantiates DUT `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `MEM_DEPTH=286514` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken. `G_FILL_GRID != {120,121,122}` / `G_FILL_K0/K1 != 3332/3588` diverges not taken.

PASS marker conjunct (TB line 525): `fail==0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (keys_match == 0) && keys_match_syn && nl_hit && (nl_tp >= 3) && (emit_has_131 == 0) && (incomp_retrieve == 0) && (G_N == 16384)`. `nl_hit = (tp >= 3)` against **G_RELEVANT**, not against G_EMIT. Gold miss on nl_synonym increments `fail` (`FAIL GOLD_MISS`) **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. Frozen `keys_match==1` (C0 alias / HELDOUT) increments `fail` (`FAIL FROZEN_NL_KEYS_MATCH_FILL`). Synonym `keys_match_syn==0` increments `fail` (`FAIL SYN_KEYS_NOT_FILL`). Emit containing nid 131 increments `fail` (`FAIL EMIT_NID_131`).

Live: `incomp=0` on every CLASS_* retrieve line; `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **0**; `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` count **1**; `FIRST_DIVERGENCE` count **0**. Hunt swallowed-incomp: **MISS this bag.** Hunt N_DROP: **MISS this bag.** Hunt PASS-without-conjunct: **MISS this bag.**

xsim: wall ~10 s elapsed for 3 queries; `$finish` at **9535 ns**. That is a **3-query walk**, not evidence of N drop (banner/gold/corpus all 16384; MEM_DEPTH 286514 hosted). xelab ~13 min is the 65536-bucket elaborate, same shape as KEEP 16K / R2 / SEMANTIC-NL.

### 5) PRIMARY HUNT — runtime lexicon is COPIED named 187-word; C0 extract unedited; overlay is NEW 1-pair wrap

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
mtime      = 2026-09-07 14:49:07.692   (same stamp as KEEP SEMANTIC-16K / UNSEEN-SRO-16K / R2 / SEMANTIC-NL named file)
```

**FACT:** `supply`/`supplies` remain **not** lexicon aliases of `feed`/`feeds` in the named 187-word table. Different REL ids (1 vs 4). Frozen extract `cd7baf49…` (TB shadow `u_qse`, law `qse-v2-role-00`) still binds RELCTX after ST_SUBJ as REL id=1 for `supply`. Live `FROZEN_KEYS_VS_FILL keys_match=0` k0=3329 k1=3585. TB would `FAIL FROZEN_NL_KEYS_MATCH_FILL` and `diverge ROLE_COLLAPSE` if frozen `rel !== G_REL[nl]=1`. `FIRST_DIVERGENCE` ABSENT. Hunt “C0 extract patched to alias supply↔feeds”: **MISS.** Hunt “C0 lexicon FILE edited”: **MISS.** Hunt “named lex regenerated this bag”: **MISS.**

NEW synonym table `qse_relctx_synonym_01.svh` (rtl == bag, SHA `551655a1…`):

```text
QSE_SYN_N           = 1
QSE_SYN_FROM[0]     = 8'd1    // supply / supplies REL id
QSE_SYN_TO[0]       = 8'd4    // feeds / feed REL id
QSE_SYN_CANON_FEEDS = 8'd4
QSE_SYN_ALIAS_SUPPLY= 8'd1
```

**FACT:** the named law is a **1-pair combinational remap**, not a general NL synonym table. Overlay module `a7ng_query_role_relctx_synonym` walks `QSE_SYN_N` and rebuilds pack_plain `{subj,rid}/{obj,rid}`. Unused ports: `k0_i`, `k1_i`, `k0_valid_i`, `k1_valid_i`, `ctx_id_i` (ctx folding left to frozen `keys_ctx`). This bag's queries are ctx=0, so DUT k0/k1 = overlay pack_plain of remapped rel.

Bag `qse_role_lexicon.svh` is **three comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler`. Live CLASS_fill_template query is `"boiler feeds header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13. Hunt “silent C0 59-word runtime claim”: **MISS.**

Corpus `corpus.json` header `gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` (KEEP identity, not rewritten). SHA `6991adc7…` MATCH KEEP. Host `load_copied_corpus()` SHA-gates and does not rebuild. Hunt “corpus rewritten”: **MISS.**

Independent packing arithmetic MATCH pack_plain `{subj[7:0], rel[7:0]}` / `{obj[7:0], rel[7:0]}`:

```text
3332 = 0x0D04 = {subj=13, rel=4}   boiler feeds
3588 = 0x0E04 = {obj=14,  rel=4}   header  + feeds
3329 = 0x0D01 = {subj=13, rel=1}   boiler supply
3585 = 0x0E01 = {obj=14,  rel=1}   header  + supply
```

query_gold:

```text
G_REL        = {4, 1, 0}          frozen extract rel (NL still 1)
G_REL_SYN    = {4, 4, 0}          overlay remapped
G_SYN_HIT    = {0, 1, 0}
G_K0_FROZEN  = {16'h0D04, 16'h0D01, 16'h0000} = {3332, 3329, 0}
G_K1_FROZEN  = {16'h0E04, 16'h0E01, 16'h0000} = {3588, 3585, 0}
G_K0_PLAIN   = same as G_K0_FROZEN
G_K0         = {16'h0D04, 16'h0D04, 16'h0000} = {3332, 3332, 0}  DUT after overlay
G_K1         = {16'h0E04, 16'h0E04, 16'h0000} = {3588, 3588, 0}
G_LEN        = {19, 41, 16}
```

Independent LSB-first decode of `G_BYTES` (char0 at bits[7:0]):

```text
q0 "boiler feeds header"                       nz=19
q1 "what does the boiler supply to the header" nz=41
q2 "payroll tax form"                          nz=16
```

MATCH PREREG / GOLDEN / banner `NL_TEXT`. `FIRST_DIVERGENCE` ABSENT ⇒ TB-shadow extract matched frozen gold keys **and** DUT wrap matched synonym gold keys. Hunt fake keys / nid-derived keys: **MISS.**

### 6) INSTANTIATE keys / NEW wrap DUT vs nid keys / STREAM-02 not compiled / ctx DUT not DUT

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of incoming k0/k1. **No nid port.** Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through incoming `{subj,rel}` keys. Query classes this bag are ctx=0, so k0/k1 = overlay pack_plain(sid, rid_syn)/pack_plain(oid, rid_syn). Instantiated in the NEW wrap **and** as TB shadow (`u_cx_qse` on frozen rel; `u_cx_syn` on remapped rel).

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. **Not compiled as DUT** (xvlog/xelab/sdb ABSENT; `run_xsim.ps1` throws if it is).

NEW wrap DUT `a7ng_query_axi_sparse_intersect_synonym.sv` SHA `a84bbf7e…` mtime **19:42:02**. Instantiates frozen extract → **NEW overlay** → frozen `keys_ctx` (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. k2/k3 not used to issue AR. Walker is a STREAM-02 two-pointer copy **inside the new file** (same pattern as CONTEXT-02); STREAM-02 file itself unedited and not compiled.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys edited this bag”: **MISS** (mtime 14:03, this bag 19:42). Hunt “ctx DUT 8255a798 compiled as DUT”: **MISS.** Hunt “PAGE-SKIP compiled / mixed”: **MISS.** Hunt “silent C0 extract patch instead of named overlay”: **MISS** (new files present; C0 extract mtime 2026-09-05; frozen keys_match=0).

Host gold: `gold_ids(docs, pred_direct)` for **both** fill_template and nl_synonym = nids with `evidence==1` and SRO=`(13,4,14)` **before** the walker twin. `relevant_is_router_union=false` in GOLDEN. nl_synonym `relevant` = `{120,121,122}` = fill-meaning. Host predicted emit `{120,121,122}` after synonym remap (not `{131}`). Hunt `relevant=router_union`: **MISS.** Hunt gold-relabel-to-131: **MISS** (`G_RELEVANT[nl] = {120,121,122}`; `G_EMIT[nl] = {120,121,122}` is host-twin emit lock **after overlay**, not a relabel of gold to cartesian 131).

Independent `k0==(nid<<8)` count = **0**. Host chk `k0 != (nid<<8)`. RTL has no nid input. Hunt nid-derived keys: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 20:03:34 2026**; exit **20:03:44**; PID **64248**; `$finish` at **9535 ns**.

Banner:

```text
C1_SYNONYM_LAW_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286514 N_SUBJECTS=127 N_RELS=8 FILL_GRID=120,121,122 FILL_K0=3332 FILL_K1=3588 NL_TEXT=what_does_the_boiler_supply_to_the_header
```

Named lines (verbatim authority):

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=121 ovf=1 trunc=0 dirB=32 postB=512 discB=0 descB=0 incomp=0
EMIT_fill_template n=3
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
FROZEN_KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0 law=qse-v2-role-00
SYN_KEYS_VS_FILL class=nl_synonym k0=3332 k1=3588 vs_fill_template k0=3332 k1=3588 keys_match=1 law=qse-v2-relctx-synonym-01 syn_hit=1
KEYS_VS_FILL class=nl_synonym k0=3332 k1=3588 vs_fill_template k0=3332 k1=3588 keys_match=1 law=qse-v2-relctx-synonym-01
NL_GOLD_HIT tp=3 emit_n=3 gold_n=3 keys_match_frozen=0 keys_match_syn=1
CLASS_nl_synonym gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=121 ovf=1 trunc=0 dirB=32 postB=512 discB=0 descB=0 incomp=0
EMIT_nl_synonym n=3
  CAND nl_synonym i=0 id=120 ev=1
  CAND nl_synonym i=1 id=121 ev=1
  CAND nl_synonym i=2 id=122 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
EMIT_unrelated n=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
NL_SUMMARY keys_match_frozen=0 keys_match_syn=1 nl_hit=1 nl_tp=3 fill_tp=3 emit_has_131=0 fail=0
ASTRA_C1_SYNONYM_LAW_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process:

```text
ASTRA_C1_SYNONYM_LAW_XSIM_PASS          = 1
ASTRA_C1_SYNONYM_LAW_XSIM_NO_MARKER     = 0
FILL_TEMPLATE_HIT                       = 1
NL_GOLD_HIT                             = 1
NL_GOLD_MISS                            = 0
FAIL <space>                            = 0
SEARCH_INCOMPLETE                       = 0
FIRST_DIVERGENCE                        = 0
FROZEN_KEYS_VS_FILL keys_match=0        = 1
SYN_KEYS_VS_FILL keys_match=1           = 1
emit_has_131=0                          = 1
C1_800K=OPEN                            = 1
POKE_V=0                                = 1
```

**FACT:** PASS marker is **PRESENT** with the required conjunct. Hunt “PASS without frozen keys_match=0”: **MISS.** Hunt “PASS without syn keys_match=1”: **MISS.** Hunt “PASS without NL_GOLD_HIT tp=3”: **MISS.** Hunt “PASS with emit 131”: **MISS.**

**FACT:** `keys_match_frozen=0` is real (3329/3585 vs 3332/3588, MATCH independent packing + TB-shadow extract). Hunt “C0 extract aliased so frozen keys match fill”: **MISS.** Hunt “HELDOUT same-key sold as this unknown”: **MISS** (probe text is `supply`, not `feed`; frozen keys differ).

**FACT:** fill-meaning gold HIT (tp=3, gold_n=3, emit `{120,121,122}`). Emit does **not** contain nid 131. Hunt “gold miss hidden”: **MISS.** Hunt “unknown actually still MISS”: **MISS.**

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_fill_template emit `{120,121,122}` tp=3 occ=121 incomp=0. Fill-template control still hits. N banner = 16384. Hunt “N not actually 16384”: **MISS.** Hunt “silent drop to 256”: **MISS.** Hunt “fill control sacrificed to make NL look better”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=127` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_MEM_DEPTH=286514` `G_N_WR=18561` `G_FILL_GRID={120,121,122}` `G_FILL_K0=16'h0D04` `G_FILL_K1=16'h0E04` `G_NQ=3` `G_FILL_Q=0` `G_NL_Q=1` `G_UNRELATED_Q=2`.

```text
G_NEMIT    = {3,3,0}
G_NREL     = {3,3,0}
G_OCC      = {121,121,0}
G_EMIT     q0={120,121,122}  q1={120,121,122}  q2={}
G_RELEVANT q0={120,121,122}  q1={120,121,122}  q2={}
```

**FACT:** `G_RELEVANT[nl] = {120,121,122}` not `{131}`. `G_EMIT[nl] = {120,121,122}` is the host-twin walker prediction **after synonym remap** (SEMANTIC-NL FAIL had `G_EMIT[nl]={131}` under frozen keys). Scoring gold HIT uses `G_RELEVANT`. Relabel hunt looks at `G_RELEVANT` / GOLDEN `relevant`, not at matching emit after a real remap. Hunt gold-relabel: **MISS.**

GOLDEN.json (hashed before xvlog): `nl_synonym.relevant = [120,121,122]`; `nl_synonym.emit = [120,121,122]`; `nl_keys_match_fill_frozen = 0`; `nl_keys_match_fill_syn = 1`; `nl_gold_hit_predicted = 1`; `predicted_not_selective_nl = 0`; `gold_not_relabeled_131 = true`; `relevant_is_router_union = false`; `fill_meaning_gold = [120,121,122]`; `not_nid_131 = true`; `C1_800K = OPEN`; `BOARD_PASS = NOT_CLAIMED`. Host **pre-registered** the HIT of the named overlay. XSim confirmed it. That is a stated hypothesis + measurement, not gold theatre.

### 8) Independent corpus — nid 131 is still cartesian "boiler supplies header"; AND 3332∩3588 = {120,121,122}; frozen AND 3329∩3585 = {131}

Authority = live `corpus.json` **records** (hash `6991adc7…`, byte-identical KEEP UNSEEN-SRO-16K / R2 / SEMANTIC-NL), **not** RESULTS.

```text
n records         = 16384 (nid 0..16383 contiguous)
evidence=1        = 16384
kinds             = fill 16373 / direct_plain 1 / direct_glycol 1 / direct_steam 1 / unseen_sro 8
header gate       = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01
nid<<8 keys       = 0
```

Records at the fill-grid / plant / NL-cartesian nids (independent):

```text
nid 120  kind=direct_plain   text="boiler feeds header"         SRO=(13,4,14) k0=3332 k1=3588  ev=1
nid 121  kind=direct_glycol  text="boiler feeds header glycol"  SRO=(13,4,14) ctx=3
nid 122  kind=direct_steam   text="boiler feeds header steam"   SRO=(13,4,14) ctx=4
nid 123..130 kind=unseen_sro (KEEP plants; not queried this bag)
nid 131  kind=fill           text="boiler supplies header"      SRO=(13,1,14) k0=3329 k1=3585  ev=1
nid 132  kind=fill           text="boiler supplies coil"        SRO=(13,1,15)
nid 0    kind=fill           text="boiler supplies preheat"     SRO=(13,1,30) k0=3329
```

**FACT: nid 131 is still a KEEP cartesian-sample fill row `"boiler supplies header"` SRO=(13,1,14), not fill-meaning gold.** Independent `SRO==(13,1,14)` nids = `{131}`. Independent `SRO==(13,4,14)` nids = `{120,121,122}`. Relabeling gold as `{131}` would convert the unknown into “retrieve the indexed surface of the same tokens”, which is **not** synonym retrieve of `"boiler feeds header"` meaning. This bag did **not** take that cheat.

Independent exact-key postings (plain `{subj,rel}` / `{obj,rel}` — ctx=0 walker keys; indexer writes `k0_plain`/`k1_plain` for every row):

```text
plain k0=3332 occ=121  first16=[120,121,122,487,…]
plain k1=3588 occ=18
plain AND fill 3332∩3588 = {120,121,122}          ← CLASS_fill_template AND CLASS_nl_synonym MATCH raw

plain k0=3329 occ=119  first16=[0,131,132,…]       ← 119 = |NEW_SUBJ|−1 boiler-supplies-*
plain k1=3585 occ=18   list=[104,131,2033,2984,…]  ← NOT hard-empty
plain AND frozen-nl 3329∩3585 = {131}             ← what SEMANTIC-NL emitted; this bag did NOT
fill gold ∩ AND_frozen_nl      = {}               ← frozen extract still misses fill-meaning
```

**FACT:** two-pointer AND of the **frozen** NL keys still retrieves **only** nid 131. Fill-meaning gold `{120,121,122}` is **disjoint** from that AND. The named overlay remaps the query onto fill keys 3332/3588 whose AND **is** `{120,121,122}`. Live DUT emit `{120,121,122}` MATCH independent fill AND. Hunt “emit is still cartesian 131 sold as HIT”: **MISS** (raw CAND ids 120,121,122; `emit_has_131=0`).

**FACT:** k1 occupancy **18** is **not** a hard-empty k1. The SEMANTIC-NL miss was frozen-QSE synonym selectivity. This bag's HIT is overlay remap onto the fill posting, not an empty-posting theatre.

Independent gold (evidence=1 ∧ SRO pred, **before** walker):

```text
fill_template  (13,4,14) = {120,121,122}
nl_synonym     (13,4,14) = {120,121,122}   ← same meaning; different query surface
unrelated                  = []
```

MATCH GOLDEN `relevant` and query_gold `G_RELEVANT`. MATCH raw fill emit. MATCH raw NL emit. MATCH host `pred_direct` (DIR_S,DIR_R,DIR_O)=(13,4,14).

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (fill `{120,121,122}` tp=3 occ=121 incomp=0; nl emit `{120,121,122}` tp=3 gold_n=3 keys_match_frozen=0 keys_match_syn=1 emit_has_131=0; `UNRELATED_EMPTY_WALK`; marker PRESENT). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, N=65536, Master ≥95%. Banner `NOT_CLAIMED=…ACCEPT_BOARD`. `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `FAIL_R0=ABSENT` MATCH. KEEP “UNMODIFIED” mtimes MATCH live. Independent tree “max 10:52:29” MATCH live. Honesty section states synonym law is a **named overlay**, frozen keys_match=0 proves C0 unpatched, index is `axi_mem_model`. Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt PASS-without-HIT: **MISS.** Hunt “general NL closed” as **claim**: **MISS** (RESULT is `PASS_THIS_GATE_ONLY`; Honesty “Not Master ≥95%”; they do not claim multi-alias / prose NL). Quality bound remains: 1-pair is not general NL — **REJECT_PROMOTION** of that scale even though the claim was not made.

CLOSEOUT MATCH raw: marker emitted, `FAIL_COUNT_FINAL=0`, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` **not** compiled as DUT, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…` copied mtime 14:49:07, corpus `6991adc7…` mtime 17:29:38, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 19:49:47 PRE before xvlog 19:50:26, gold NOT regenerated, SEMANTIC-NL GOLDEN 19:05:03 UNMODIFIED, independent tree max 10:52:29 UNMODIFIED. QUALITY_NOTE names the 1-alias remap and does **not** close 800k / Master ≥95% / N=65536 / BOARD_PASS.

Host `n_post` vs DUT `postB/16` residual: fill GOLDEN n_post=36 vs DUT postB=512→32; nl GOLDEN n_post=36 vs DUT postB=512→32. Emit locked. P2, not this-unknown FAIL. Same residual family as KEEP 16K / R2 / SEMANTIC-NL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. C0 extract / C0 lexicon FILE patched | **MISS.** extract `cd7baf49…` mtime 2026-09-05 19:48:18; C0 FILE `38189974…` mtime 2026-09-05 20:51:03. This bag 19:42. Frozen keys still 3329/3585 (`FROZEN_KEYS_VS_FILL keys_match=0`). TB would FAIL `FROZEN_NL_KEYS_MATCH_FILL` if frozen matched fill. | Hash drift / frozen keys_match=1 ⇒ FAIL. Neither. |
| 2. Gold relabeled to nid 131 | **MISS.** GOLDEN `relevant=[120,121,122]`; `G_RELEVANT[nl]={120,121,122}`; host `gold_ids(..., pred_direct)` = fill-meaning SRO=(13,4,14). `G_EMIT[nl]={120,121,122}` is walker-twin lock **after overlay**, not gold={131}. Raw emit `{120,121,122}`; `emit_has_131=0`. SEMANTIC-NL FAIL gold stayed `{120,121,122}` with emit `{131}`. | Relabel `{131}` ⇒ FAIL as cheat. Not taken. |
| 3. 1-pair table overclaim as general NL | **MISS as claim.** RESULT=`PASS_THIS_GATE_ONLY`. ACK/PREREG/CLOSEOUT name `qse-v2-relctx-synonym-01` as REL id 1→4. Honesty: not Master ≥95%, not 800k, not BOARD_PASS. **HIT as quality bound:** `QSE_SYN_N=1`; one hardcoded alias; WH-wrap of `{ent} {rel} {ent}`; not a held-out prose paragraph; not multi-pair; not learned. | REJECT_PROMOTION of general NL / Master synonym mass even though implementer did not claim it. 1-pair HIT ≠ general NL. |
| 4. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; files_after_19:20=0; this bag starts 19:42. This audit did not write it. | Keep that tree read-only. |
| 5. C1 800k / bounds / ACCEPT_BOARD / N=65536 claimed or started | **MISS as claim and as start.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag (historical U5 2026-09-05 only). This audit does not start 800k. | Never grant. Never freeze. Never auto-start 800k. |
| 6. SEMANTIC-NL FAIL bag edited | **MISS.** GOLDEN `6fa2a93f…` mtime 19:05:03; xsim.log SHA `1ff11f30…` mtime 19:18:47; CLOSEOUT 19:20:19. This bag 19:42+. | Editing FAIL evidence ⇒ FAIL_LOOP. Not taken. |
| 7. PASS marker without conjunct | **MISS.** Marker PRESENT; frozen keys_match=0 AND syn keys_match=1 AND NL_GOLD_HIT tp=3 AND emit_has_131=0 AND fail=0 AND G_N=16384. `run_xsim.ps1` throws if PASS without that set. | Marker without HIT / with frozen match / with 131 ⇒ OVERCLAIM. Not taken. |
| 8. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0; conjunct includes `incomp_retrieve==0`; fail=0. | Keep miss as FAIL on later bags. |
| 9. Named lex rewritten / corpus rewritten / KEEP edited | **MISS.** named `df0e8833…` mtime 14:49:07 MATCH KEEP 16K/R2/NL byte-identical; corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP; host refuses rewrite. KEEP MAX mtimes all < 19:42 (NL CLOSEOUT 19:20:19). | Do not edit C0. Do not regenerate named lex. Do not rewrite corpus. Do not un-FAIL SEMANTIC-NL. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…` mtime 2026-09-06 18:51:11. poke_v held 0. | Keep off. |
| 11. STREAM-02 compiled / ctx keys edited / ctx DUT compiled as DUT | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` mtime 14:03; `8255a798…` mtime 14:03 sdb ABSENT. NEW wrap `a84bbf7e…` is the DUT. | Hash mismatch / ctx DUT as DUT ⇒ FAIL, do not patch. |
| 12. Gold after xvlog / after xsim | **MISS as gold regen.** PRE 19:49:47; xvlog 19:50:26; gold still 19:49:47; named lex still 14:49:07; corpus still 17:29:38; fail_r0 ABSENT (PASS). | Do not regenerate gold. |
| 13. RESULTS vs xsim / 800k claim / general-NL claim | **MISS as RESULTS-vs-raw and as 800k/Master claim.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Marker PRESENT disclosed with conjunct. | Authority = raw FILL_TEMPLATE_HIT + FROZEN_KEYS_VS_FILL keys_match=0 + SYN_KEYS_VS_FILL keys_match=1 + NL_GOLD_HIT emit={120,121,122} + emit_has_131=0 + PASS PRESENT + independent postings. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 39/39 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…` + corpus `6991adc7…` + syn table 551655a1 bag==rtl). | SHA256.txt 19:50:25 is the xvlog freeze. PRE 19:49:47 is the gold lock. |
| 15. `relevant=router_union` / nid keys | **MISS.** `gold_ids` = evidence=1 ∧ SRO=(13,4,14) before walker. RTL no nid port. `nid<<8` keys=0. | Keep independent labels. |
| 16. N drop (silent 256) | **MISS.** Banner/gold/corpus `N=16384`; TB `N_DROP` if `G_N!=16384` not taken; `G_N_BUCKETS=65536` `MEM_DEPTH=286514`; `FIRST_DIVERGENCE` ABSENT. 3-query wall-clock ~10 s is not a drop. | Silent drop ⇒ FAIL. This bag hosted 16384. |
| 1-pair table is not general NL | **HIT as quality / promotion bound.** `QSE_SYN_N=1`. Overlay remaps **all** rel_id==1, not a token-conditioned lexicon. Probe is still a WH-wrap of `{ent} {rel} {ent}`. | ACCEPT_PARTIAL this 1-alias unknown only. REJECT general NL / Master ≥95% / extra pairs without a new named law id. Implementer did not claim those. |
| Overlay rebuilds pack_plain; ignores k0_i/k1_i/ctx_id_i | **HIT as quality.** Harmless this bag (ctx=0; packing MATCH extract). | Do not treat as general ctx-aware synonym. Later ctx≠0 queries need a named contract if overlay must preserve ctx-folded incoming keys. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| Host n_post vs DUT postB (36 vs 32) | **HIT as residual.** Emit locked. | Do not freeze DDR bytes. |
| Walker is STREAM-02 copy inside NEW wrap | **HIT as construction honesty.** STREAM-02 **file** `14f75db7…` unedited and not compiled. Same wrap pattern as CONTEXT-02. | Do not claim STREAM-02 file was the DUT. Implementer did not. |

qstack-validation-adversary one-liner: **SYNONYM-LAW-01 XSim is a real N=16384 host+wrap lock on unpatched C0 extract (`cd7baf49…`) with a **copied** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…` mtime 14:49:07 **not rewritten**) and a **KEEP-copied** corpus (`6991adc7…` mtime 17:29:38 **byte-identical**, not rewritten) plus a **NEW named 1-pair overlay** (`qse-v2-relctx-synonym-01`, table `551655a1…` `QSE_SYN_N=1` id 1→4, module `e862208c…`, wrap DUT `a84bbf7e…`): bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime; frozen ctx keys `124be808…` instantiated not edited; ctx DUT `8255a798…` unedited and **not** compiled as DUT; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; leftover A09 off; poke_v=0; gold PRE 19:49:47 before xvlog 19:50:26 and **not** regenerated after PASS; KEEP SEMANTIC-NL FAIL GOLDEN 19:05:03 unmodified; independent tree ≤10:52:29; N actually 16384; fill-template control still emits `{120,121,122}` (`FILL_TEMPLATE_HIT` tp=3 occ=121 incomp=0, independent plain AND `{120,121,122}`); NL probe `"what does the boiler supply to the header"` still binds frozen `supply` RELCTX id=1 so frozen k0/k1=3329/3585 (`FROZEN_KEYS_VS_FILL keys_match=0`, independent packing MATCH; C0 unpatched); overlay remaps rel 1→4 so DUT keys 3332/3588 (`SYN_KEYS_VS_FILL keys_match=1 syn_hit=1`); fill-meaning gold stayed `{120,121,122}` (`G_RELEVANT` / GOLDEN `relevant`, **not** relabeled to 131); walker AND of remapped keys = `{120,121,122}` (independent fill AND MATCH; frozen AND `{131}` **not** emitted; `emit_has_131=0`); `NL_GOLD_HIT` tp=3 emit_n=3 gold_n=3; `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` **PRESENT**; that is an **honest PASS_NARROW of the 1-alias unknown**, **not** OVERCLAIM of that unknown, **not** gold-relabel cheat, **not** C0 patch, **not** SEMANTIC-NL FAIL-bag edit, **not** 800k, **not** ACCEPT_BOARD, **not** general NL; ACCEPT_PARTIAL this 1-alias only; REJECT_PROMOTION C1 800k / BOARD_PASS / general NL / CAND_CAP_FINAL.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / nl `{120,121,122}` / unrelated `[]`). The registered 1-alias unknown **HIT**. Findings are **law-quality / promotion bounds**, not “patch frozen QSE in place” and not “fix TB packing”:

1. **N=16384 was actually hosted.** `G_N=16384`; corpus 16384 contiguous; banner 16384; MEM_DEPTH 286514 TB-only; `N_BUCKETS=65536`; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 drop.
2. **Fill-template control still hits.** `"boiler feeds header"` emit `{120,121,122}` tp=3 occ=121 incomp=0; independent plain AND `{120,121,122}`. Marker requires this.
3. **Frozen extract still distinguishes supply≠feeds.** Independent packing + TB-shadow extract + raw `FROZEN_KEYS_VS_FILL`: 3329/3585 vs 3332/3588. `supply` RELCTX id=1 vs `feeds` REL id=4. HELDOUT `feed` RELCTX id=4 is the same-key paraphrase and was not used. `keys_match_frozen=0` is real. C0 unpatched half **held**.
4. **Named overlay remapped DUT keys to fill and fill-meaning gold HIT.** Independent AND 3332∩3588 = `{120,121,122}`. Raw `NL_GOLD_HIT` tp=3 emit `{120,121,122}`. Gold was **not** relabeled. `emit_has_131=0`. Conjunction PASS of the 1-alias unknown.
5. **Nid 131 remains cartesian `"boiler supplies header"`.** Frozen AND 3329∩3585 = `{131}` still holds on the unpatched index. Overlay did not delete that row; it stopped the NL probe from walking those keys. Relabeling gold to `{131}` would still fake synonym retrieve; not taken.
6. **The law is 1-pair, not general NL.** `QSE_SYN_N=1`. No other alias. Probe is still a WH-wrap. Do not promote to Master ≥95% / NL mass / extra pairs without a new named law id and a new gold bag.
7. **Runtime lexicon is COPIED named 187-word. Corpus is KEEP copy. C0 FILE unedited. Overlay is NEW files.** Named file mtime 14:49:07 MATCH 16k/R2/NL byte-identical; corpus mtime 17:29:38 MATCH KEEP byte-identical; host SHA-gates and does not rewrite. xvlog bag-first documented. C0 extract mtime 2026-09-05.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
10. **fail_r0 was not written because the session PASSed.** Gold hashed once before xvlog (19:49:47) and not rewritten.
11. **SEMANTIC-NL-01 remains honest FAIL evidence.** Do not edit it. The synonym HIT does not un-FAIL frozen extract.
12. **Required next is not 800k.** One unknown (1-alias) HIT. Promotion of C1 800k / BOARD_PASS / general NL / `CAND_CAP_FINAL` stays REJECT. Not this audit.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 in this audit. Do not silently grow `QSE_SYN_N` in place.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW of the measurement harness** | Simulation only. Not DDR. Not 800k. |
| NEW overlay (`qse-v2-relctx-synonym-01`, `QSE_SYN_N=1`, id 1→4) | **PASS_NARROW of the 1-alias unknown** | New files; C0 extract unpatched; frozen keys_match=0 AND syn keys_match=1 AND gold HIT. |
| INSTANTIATE keys (`124be808…`, not edited) | **PASS_NARROW** | mtime 14:03:07; this bag 19:42. ctx=0 so incoming overlay pack_plain pass-through. |
| NEW wrap DUT (`a84bbf7e…`); ctx DUT `8255a798…` NOT compiled as DUT | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02 / 16k / HELDOUT / UNSEEN-SRO / R2 / NL. STREAM-02 **file** not compiled. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121 incomp=0 | **PASS_NARROW** | Cartesian control still hits. Independent plain AND `{120,121,122}`. |
| FROZEN_KEYS_VS_FILL keys_match=0 (3329/3585 vs 3332/3588) | **PASS_NARROW of the C0-unpatched half** | Independent packing MATCH. Not HELDOUT same-key. Not C0 alias. |
| SYN_KEYS_VS_FILL keys_match=1 (3332/3588) | **PASS_NARROW of the overlay half** | syn_hit=1. DUT keys MATCH fill. |
| NL_GOLD_HIT tp=3 emit `{120,121,122}` emit_has_131=0 | **PASS_NARROW of the registered unknown** | Independent AND `{120,121,122}`. Raw `NL_GOLD_HIT`. Not nid 131. |
| `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` | **PRESENT (correct)** | Conjunct requires frozen0 AND syn1 AND nl_tp>=3 AND emit_has_131==0 AND fail==0. All held. |
| Gold stay `{120,121,122}` not relabeled to 131 | **PASS_NARROW of gold discipline** | G_RELEVANT / GOLDEN relevant MATCH fill-meaning. |
| Gold-before-xvlog / not regen after xsim | **PASS_NARROW** | PRE 19:49:47; xvlog 19:50:26; gold 19:49:47. |
| Independent fill AND: plain k0=3332 ∩ k1=3588 = `{120,121,122}` | **PASS_NARROW** | occ_k0=121. MATCH both fill and NL emit. |
| Independent frozen-NL AND: plain k0=3329 ∩ k1=3585 = `{131}` | **PASS_NARROW of the C0-unpatched measurement** | k1 occ=18 not hard-empty. Occupancy-1 cartesian surface still exists; overlay did not walk it. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys freeze (mtime 14:03, this bag 19:42) | **PASS_NARROW** | Instantiated, not edited. |
| Ctx DUT freeze (mtime 14:03, **not compiled as DUT**) | **PASS_NARROW** | KEEP 8255a798. Wrap is the DUT. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. Standing `git M` vs HEAD is the C0 blob, not this bag. |
| Copied lexicon **runtime** = `df0e8833…` 187-word mtime 14:49:07; C0 FILE `38189974…` unedited NOT runtime; C0 extract `cd7baf49…` unedited | **PASS_NARROW** | Copied not rewritten. C0 cannot name boiler; live fill did. C0 has supply id=1, not feeds. Frozen extract still binds id=1. |
| Copied corpus `6991adc7…` mtime 17:29:38 BYTE-IDENTICAL KEEP | **PASS_NARROW** | Not rewritten. Host SHA-gates KEEP copy. |
| KEEP SEMANTIC-NL FAIL / R2 / UNSEEN-SRO-16K / HELDOUT / SEMANTIC-16K unmodified | **PASS_NARROW / UNMODIFIED** | NL GOLDEN 19:05:03; R2 GOLDEN 18:19:54; 16K GOLDEN 17:29:38; HELDOUT GOLDEN 15:44:21; SEMANTIC-16K GOLDEN 14:49:09. |
| Registered unknown (1-alias overlay **and** fill-meaning gold HIT **and** frozen keys_match=0) | **PASS_NARROW (HIT)** | Marker PRESENT. Not general NL. |
| Implementer RESULT=`PASS_THIS_GATE_ONLY` | **HONEST vs raw for this gate** | Not OVERCLAIM of the 1-alias unknown. Not 800k. Not general NL as a claim. |
| C0 patch / gold-relabel / independent tree / 800k claim / SEMANTIC-NL FAIL-bag edit | **MISS as cheat** | See hunt table. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction / general NL | **FAIL as Master close / REJECT_PROMOTION** | 1-pair WH-wrap; cartesian sample; reduction not emitted. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD / general NL | **NOT CLOSED / REJECT_PROMOTION** | Honest 1-alias XSim. axi_mem_model. This audit does not start next bags. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL of this 1-alias unknown only** (N=16384 named overlay `qse-v2-relctx-synonym-01` on instantiate `qse-v2-intersect-context-02` + copied named lexicon `qse-v2-lex-semantic-16k-01` + KEEP-copied corpus `6991adc7…`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word **copied not rewritten** mtime 14:49:07; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; NEW files only table `551655a1…` `QSE_SYN_N=1` id 1→4 + overlay `e862208c…` + wrap DUT `a84bbf7e…`; CLASS_fill_template `{120,121,122}` `"boiler feeds header"` `FILL_TEMPLATE_HIT` tp=3 occ=121; CLASS_nl_synonym `"what does the boiler supply to the header"` frozen k0=3329 k1=3585 `FROZEN_KEYS_VS_FILL keys_match=0`; synonym k0=3332 k1=3588 `SYN_KEYS_VS_FILL keys_match=1 syn_hit=1`; fill-meaning gold stayed `{120,121,122}` **not** relabeled to 131; walker emit `{120,121,122}` independent AND 3332∩3588; frozen AND 3329∩3585 still `{131}` **not** emitted; `NL_GOLD_HIT` tp=3; `emit_has_131=0`; PASS marker **PRESENT**; leftover off; poke_v=0; gold-before-xvlog; gold not regenerated; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` unedited instantiate; ctx DUT `8255a798…` unedited and not DUT; dir file `09334e42…` unedited; KEEP SEMANTIC-NL FAIL / R2 / UNSEEN-SRO-16K / HELDOUT / SEMANTIC-16K unmodified; independent tree ≤10:52:29; RESULT=`PASS_THIS_GATE_ONLY` honest vs raw; N actually 16384; gold is **not** router_union and **not** nid keys; k1 occ=18 **not** hard-empty). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “true NL hold-out closed”, “general synonym law closed”, extra alias pairs. **Not** FAIL_LOOP (hashes real, C0 files unpatched, named lex not rewritten, corpus not rewritten, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, ctx DUT not compiled as DUT, PASS conjunct held, SEARCH_INCOMPLETE absent, N not dropped, lexicon copied, KEEP unmodified including SEMANTIC-NL FAIL, independent tree not written, gold not relabeled). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered 1-alias unknown (implementer RESULT is `PASS_THIS_GATE_ONLY`; identity path disclosed; relabel hunt fails; C0-patch hunt fails; 1-pair is named).

**P1 for this measurement: none.** Parent next is **not** 800k. Optional later: additional named alias pairs as a **new law id** (do not silent-grow `QSE_SYN_N` in this bag; do not silent-patch C0 extract). Do **not** auto-start 800k / N=65536 from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SYNONYM-LAW-01` gold/xsim/RESULTS to inflate this audit into general NL / 800k / BOARD_PASS. **Do not edit** KEEP `ASTRA-C1-SEMANTIC-NL-01` (honest FAIL evidence) / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01` / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` / `ASTRA-C1-SEMANTIC-UNSEEN-SRO-01` / `ASTRA-C1-SEMANTIC-HELDOUT-01` / `ASTRA-C1-SEMANTIC-16K-01` / `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0 extract or C0 lexicon FILE.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB. **Do not rewrite** named lexicon `df0e8833…`. **Do not rewrite** corpus `6991adc7…`. **Do not relabel gold as `{131}`.** **Do not start 800k in this audit.** **Do not silent-grow `QSE_SYN_N` in place.**

**P1 — none for this measurement** (independent FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121; FROZEN_KEYS_VS_FILL keys_match=0 k0=3329 k1=3585 vs 3332/3588 MATCH packing; SYN_KEYS_VS_FILL keys_match=1; NL_GOLD_HIT emit `{120,121,122}` gold `{120,121,122}` independent AND 3332∩3588; emit_has_131=0; PASS marker PRESENT with conjunct; SEARCH_INCOMPLETE ABSENT; N=16384 hosted; ctx keys not edited; ctx DUT not compiled as DUT; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; C0 extract unedited; named lexicon copied not rewritten; corpus KEEP copy not rewritten; gold PRE before xvlog; gold not regen after xsim; KEEP unmodified including SEMANTIC-NL FAIL; independent tree not written; gold not relabeled; 800k not claimed).

**Required fix (parent / promotion — not this audit, not a silent C0 patch, not 800k):**

1. **Keep this bag as 1-alias PASS_THIS_GATE_ONLY evidence.** Authority = raw `FILL_TEMPLATE_HIT` / `FROZEN_KEYS_VS_FILL keys_match=0` / `SYN_KEYS_VS_FILL keys_match=1` / `NL_GOLD_HIT tp=3 emit={120,121,122}` / `emit_has_131=0` / `ASTRA_C1_SYNONYM_LAW_XSIM_PASS` PRESENT + independent packing + exact-key postings + named lex `df0e8833…` + corpus `6991adc7…` + new table `551655a1…`. Do not silent-patch STREAM-02 / CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO / R2 / SEMANTIC-NL / C0 to inflate this.
2. **Do not sell this as general NL, true NL closed, Master ≥95%, or PLAN bag7 close.** `QSE_SYN_N=1`. WH-wrap of one alias. Next alias pair needs a **new named law id** and its own gold bag, not a silent append to this table.
3. **Do not relabel gold as `{131}`** in any follow-up. `{131}` is cartesian `"boiler supplies header"` SRO=(13,1,14). Frozen AND still retrieves only that nid.
4. **Do not auto-start C1 800k / N=65536 / BOARD_PASS from this close.** Honest 1-alias + axi_mem_model + cartesian sample are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused as FINAL; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on fill/nl.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `FILL_TEMPLATE_HIT` required; `FROZEN_KEYS_VS_FILL keys_match=0` required (C0 unpatched); `SYN_KEYS_VS_FILL keys_match=1` required (overlay applied); `NL_GOLD_HIT` tp=3 required for PASS; `emit_has_131==0` required; `FAIL FROZEN_NL_KEYS_MATCH_FILL` on C0 alias / HELDOUT same-key; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT / ctx DUT **not** compiled as DUT; frozen sparse not compiled; named lexicon copied not rewritten; corpus KEEP-copied not rewritten; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`; gold stay fill-meaning not cartesian 131.
7. Next bag that claims more synonym retrieve should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). Additional pairs = **new named law id**, not a silent patch of this bag or of C0.
8. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board. This audit does not write it.
9. KEEP bags including SEMANTIC-NL GOLDEN 19:05:03 (honest FAIL `NOT_SELECTIVE_NL`), R2 GOLDEN 18:19:54 (8/8 retrieve), UNSEEN-SRO-16K GOLDEN 17:29:38, UNSEEN-SRO N=256 GOLDEN 17:01:44, HELDOUT GOLDEN 15:44:21 (same-key paraphrase, **not** this unknown), SEMANTIC-16K GOLDEN 14:49:09 stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL of this 1-ALIAS UNKNOWN only
UNKNOWN          = named synonym overlay so NL "what does the boiler supply
                   to the header" HIT fill-meaning gold {120,121,122}
                   AND frozen extract keys_match vs fill stay 0
                   AND emit is not nid 131
VERDICT_FRAME    = PASS_NARROW of registered 1-alias unknown
                   NOT OVERCLAIM of that unknown
                   NOT FAIL of that unknown
                   NOT cheat (C0 unpatched; gold not relabeled to 131;
                     independent tree not written; 800k not claimed;
                     SEMANTIC-NL FAIL bag not edited;
                     1-pair not sold as general NL)
PROMOTION        = REJECT
                   REJECT C1 800k
                   REJECT BOARD_PASS
                   REJECT CAND_CAP_FINAL
                   REJECT DDR_QUERY_BOUND_FINAL
                   REJECT Master evidence-recall ≥95%
                   REJECT candidate-reduction ≥90%
                   REJECT N=65536
                   REJECT general NL / multi-alias synonym close
ACCEPT_BOARD     = NO (never)
FAIL_LOOP        = NO
P1               = none for this measurement
REQUIRED_FIX     = do not promote; extra pairs = NEW named law id
                   (do not silent-patch C0 extract cd7baf49 /
                    C0 lexicon FILE 38189974;
                    do not silent-grow QSE_SYN_N in this bag)
C1_800K          = OPEN
PROGRAM          = NO
KEEP_NL_FAIL     = UNMODIFIED (GOLDEN 19:05:03 CLOSEOUT 19:20:19 SHA 6fa2a93f)
KEEP_R2          = UNMODIFIED (GOLDEN 18:19:54 CLOSEOUT 18:34:48)
KEEP_16K         = UNMODIFIED (GOLDEN 17:29:38 CLOSEOUT 17:52:43 corpus 6991adc7)
INDEP_TREE       = UNMODIFIED (max 10:52:29; this audit did not write it)
INSTANTIATE      = 124be808 NOT edited; 8255a798 NOT compiled as DUT NOT edited
NEW_FILES        = qse_relctx_synonym_01.svh 551655a1 QSE_SYN_N=1
                   a7ng_query_role_relctx_synonym.sv e862208c
                   a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e
C0_EXTRACT       = UNEDITED cd7baf49 (mtime 2026-09-05 19:48:18)
C0_LEXICON_FILE  = UNEDITED 38189974 (mtime 2026-09-05 20:51:03; NOT runtime)
POKE_V           = 0
LEFTOVER_A09     = not compiled
SEARCH_INCOMPLETE= ABSENT
PASS_MARKER      = PRESENT frozen0 AND syn1 AND NL_GOLD_HIT tp=3 AND emit_has_131=0
GOLD_AFTER_XSIM  = NO (PRE 19:49:47; gold still 19:49:47 after xsim 20:03:44)
NEXT             = NOT 800k / NOT N=65536 / NOT BOARD_PASS this audit
                   OPTIONAL parent: new named alias-pair law
                   NOT silent C0 patch
                   NOT silent QSE_SYN_N growth in this bag
```
