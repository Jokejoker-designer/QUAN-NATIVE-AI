# ASTRA auditor REPORT — 20260907T1455Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-SEMANTIC-16K-01
LAW        = qse-v2-intersect-context-02
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           INSTANTIATE DUT  a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             (STREAM-02 two-pointer copy; k2/k3 not probed; NOT edited)
LEXICON    = qse-v2-lex-semantic-16k-01 NEW named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833…
           include-name bag qse_role_lexicon.svh (shim `include of named file)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
KEEP       = ASTRA-C1-CONTEXT-02 (must be unmodified; GOLDEN 14:12:02 verified)
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
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1415Z/REPORT.md
           ACCEPT_PARTIAL (CONTEXT-02 ctx fold; P1 none; parent MAY open OPTIONAL PLAN bag 7)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-16K-01.md
EVIDENCE   = raw xsim.log CLASS_* / EMIT_* / CONTEXT_SELECTIVE / NOT_SELECTIVE /
             LATE_GOLD_HIT / ASTRA_C1_SEMANTIC_16K_XSIM_PASS / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + STREAM-02 / CONTEXT-02 / PAGE-SKIP GOLDEN
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP bags)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (ctx fold into k0/k1; no nid-derived keys; mtime 14:03:07 NOT this bag)
           + INSTANTIATE DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (k0_r <= k0_o folded; STREAM-02 two-pointer; k2/k3 not walked; mtime 14:03:24)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime vs N=256 bag; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate; N_BUCKETS=65536 parameter)
           + TB tb_astra_c1_semantic_16k.sv (poke_v, leftover A09, PASS conjunct, N_DROP, SEMANTIC_MASS)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh / GOLDEN.json / corpus.json records / host_astra_c1_semantic_16k.py
           + independent corpus exact-key postings for plain k0=3332/k1=3588 and packed k0=3380/k1=3636
             and nid 16382 (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SEMANTIC_16K = THIS BAG (N=16384 formulaic HVAC-word grid; not Master close; not 800k)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = FIRST RUNG ONLY (800k / N=65536 NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=16384 semantic-rung** bag `ASTRA-C1-SEMANTIC-16K-01` after auditor `20260907T1415Z` ACCEPT_PARTIAL of CONTEXT-02 (P1 none) allowed parent to open OPTIONAL PLAN bag 7 first rung.

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=16384, law `qse-v2-intersect-context-02` (instantiate ctx keys `124be808…` + STREAM-02 walker via context wrapper `8255a798…`; do not edit `14f75db7…` / `124be808…` / `8255a798…`) on a **semantic** corpus with ≥100 distinct subject ids and ≥8 relation ids (independent gold, **not** cloned “pump supplies chiller” × N): does recall of labeled gold hold on required retrieve classes without `SEARCH_INCOMPLETE` hiding misses?

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_16K_XSIM_PASS` present. N actually 16384 (no silent drop to N=256 clones). If XSim cannot host 16384, FAIL honestly `FIRST_DIVERGENCE MEM`.
2. CLASS_direct labeled gold hits; `SEARCH_INCOMPLETE` **ABSENT** on gold_n≥1 retrieve. Direct is **not** the 12-entity `{110,144,145}` clone.
3. CLASS_wrong_context emit **≠** CLASS_direct; labeled `CONTEXT_SELECTIVE` with `keys_match=0 emit_match=0`. `NOT_SELECTIVE` must not be relabeled PASS.
4. Late-gold nid **16382** in emit (`LATE_GOLD_HIT`); miss is FAIL, not `SEARCH_INCOMPLETE`.
5. Subject mass ≥100 and rel mass ≥8. **Not** a 12-entity HVAC clone. C0 59-word cannot name 100 entities: **NEW named** lexicon law required, SHA recorded, xvlog must bind that table. Do **not** silent-shadow C0 while claiming 59-word runtime. C0 FILE `38189974…` unedited. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` / ctx DUT `8255a798…` **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. C0 extract `cd7baf49…` unedited.
6. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified; independent tree not written.
7. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`. Independent PLAN bag 7 remainder (held-out non-grid / 800k) remains **OPEN** and is **not started** by this audit.

KEEP (must remain unmodified; this audit does not rewrite them):

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

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536.

Hunt (dispatch, none dropped):

1. N not actually 16384 / silent drop to N=256 clone / FIRST_DIVERGENCE MEM hidden
2. 12-entity clone (max_subj=12 / “pump supplies chiller” × N)
3. Formulaic `{ent} {rel} {ent}` grid sold as “semantic mass”
4. Host `subj_id & 0xFF` wrap collapsing distinct subjects
5. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD`
6. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
7. C0 lexicon FILE edited (`38189974` drift)
8. Bag `qse_role_lexicon.svh` silent shadow (DIR-FULL16 61-word pattern) vs named law
9. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys/DUT edited
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. Gold hashed after first xvlog / rewritten after FAIL
12. KEEP bags rewritten
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Independent audit tree written by this implementer
16. Direct emit is still `{110,144,145}` clone / late-gold 16382 miss hidden by incomp

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=16384 first semantic-rung** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** a non-grid held-out rung. Do **not** auto-start C1 800k / N=65536 from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. SEMANTIC-16K bag is untracked (`??`). KEEP CONTEXT-02 / PAGE-SKIP / STREAM-02 / DIR-FULL16 / N4096-STREAM-02 / KEY-INTERSECT remain untracked (`??`). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. KEEP intersect DUT remains untracked with **unchanged** hash `a912786f…`. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1415Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). `M rtl/native_graph/control/a7ng_gate14_crc.svh` vs HEAD is the same historical blob `9a06e6d3…` mtime **2026-09-05 19:57:09**. C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T14:55:00+07:00` `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-CONTEXT-02` `unblocked_item=ASTRA-C1-SEMANTIC-16K-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), SEMANTIC-16K bag:

```text
14:45:36.175  tb_astra_c1_semantic_16k.sv
14:46:58.889  run_xsim.ps1
14:48:07.840  ACK.json PREREG.md
14:48:56.901  host_astra_c1_semantic_16k.py
14:49:07.692  qse_role_lexicon_semantic_16k.svh
14:49:07.692  qse_role_lexicon.svh          ← include-name shim
14:49:09.276  corpus.json
14:49:09.278  GOLDEN.json
14:49:09.296  query_gold.svh
14:49:09.302  GOLD_HASH_PRE_XVLOG.txt      ← gold+named-lex hash BEFORE first xvlog
14:50:34.236  SHA256.txt                   ← freeze immediately before first xvlog
14:50:35.339  xvlog.log
15:16:57.567  xelab.log                    ← ~26 min elaborate (CLOSEOUT said ~18 min)
15:17:20.106  xsim.log                     PID 59468; session 15:17:09–15:17:20
15:18:52.927  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 bag (GOLDEN 14:12:02 / CLOSEOUT 14:13:59). This bag starts 14:45. Ctx keys were not rewritten for SEMANTIC-16K.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer** than CONTEXT-02. Not rewritten.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag. Not rewritten.

Page-skip DUT LastWriteTime **2026-09-07 13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**. `role_lexicon.py` **2026-09-05 20:49:59.239** (host extends LEX **in memory** only).

Single XSim session after one xvlog + one xelab. Gold files were **not** rewritten between 14:49:09 and 15:18:52 (hash MATCH PRE; LastWriteTime still 14:49:09). Named lexicon still 14:49:07. `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `bc03a39b8376b72da3d6ed845999cf83a95e87aa3b6e35f482d43b5b60651d3e` MATCH RESULTS `XSIM_SHA`.

No new C1-800k / N=65536 bag dirs. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` is a prior lane, not this bag.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / KEEP DUT / NEW lexicon

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
                                                                  **this IS the compiled runtime table**
7966f321171cfe97b396ad90bb1ebd156c09a165782df40a3a98109ee59ac263  bag qse_role_lexicon.svh (one-line `include of named file)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv
9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7  a7ng_gate14_crc.svh
42a0c41977732d19f608d11188aa0c9eb8cf875134a9b345f349c90c63b32c24  tb_astra_c1_semantic_16k.sv
```

C0 extract / lexicon FILE MATCH `docs/ASTRA/authority/FINAL_CONTRACT.json` `ROLE_PARSER_LAW`. STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH.

`GOLD_HASH_PRE_XVLOG.txt` mtime **14:49:09.302** vs live gold+named-lex (all MATCH):

```text
0e539d48be5862d006e5785cf3c74355d5540dff09bec5e8c738ac842ea83b99  GOLDEN.json
cfa165c0f9921f0c19802dc5e25a247aa93eb1d19f43155b715f111706336e5b  query_gold.svh
2b5d3028b95205213aa359fdafde86153ae07aae92e4349597a194ff716c81d9  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
```

`xvlog.log` mtime **14:50:35.339**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 14:49:09). SHA256.txt freeze stamp `2026-09-07T14:50:34.1513152+07:00` is immediately before xvlog.

SHA256.txt listed paths vs live: **32 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple). C0 lexicon FILE live MATCH `38189974…` independently (SHA256.txt transitive line carries a trailing comment). No invented hash.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 14:45+ |
|---|---|---|---|
| CONTEXT-02 | `8fc931f5ac07a72f…` **14:12:02.956** | CLOSEOUT **14:13:59.927** | **UNMODIFIED** |
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19.424** | CLOSEOUT **13:39:47.345** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| DIR-FULL16 | `2f6ab31e41837fd3…` **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** SEMANTIC-16K implementer did **not** write that tree. This auditor did **not** write that tree.

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
tb_astra_c1_semantic_16k.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir, TB). Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; requires named lexicon + bag shim present; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / missing CONTEXT_SELECTIVE / NOT_SELECTIVE fail / LATE_GOLD miss / DISTRACTOR_LEAK / SEARCH_INCOMPLETE / diverge. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` line 193, the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (NEW lexicon law). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. This is the DIR-FULL16 include-path geometry, **documented** as NEW law `qse-v2-lex-semantic-16k-01`, **not** a silent C0 59-word claim. Opposite of CONTEXT-02 / PAGE-SKIP (`-i $incq` first, no bag lexicon). Hunt silent C0 runtime: **MISS** (see §5). Hunt undocumented shadow: **MISS** (PREREG / SHA256.txt / RESULTS name the law).

TB instantiates `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `if (G_N_SUBJECTS < 100) diverge SEMANTIC_MASS` not taken. `if (G_N_RELS < 8) diverge SEMANTIC_MASS` not taken. `MEM_DEPTH=286517` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken. RTL source defaults remain `N_BUCKETS=4096` / `CAND_CAP=64`; **TB overrides**. Do not treat 64 as `CAND_CAP_FINAL`. Do not treat 4096 as this-bag directory.

PASS marker conjunct (TB line 538): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_sel && (direct_tp > 0) && direct_ids_ok && late_hit && late_ok && (incomp_retrieve == 0)`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. Wrong-context `emit_match || keys_match` → `NOT_SELECTIVE` **and** `FAIL WRONG_CONTEXT_NOT_SELECTIVE`. Late nid 16382 miss → `FAIL LATE_GOLD_MISS` even if incomp.

Live: `incomp=0` on every CLASS line; `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **0**; `incomp=1` count **0**. Hunt swallowed-incomp: **MISS this bag.**

### 5) PRIMARY HUNT — runtime lexicon is NEW named 187-word, not C0 59-word, not silent shadow

C0 FILE `rtl/native_graph/query/qse_role_lexicon.svh`:

```text
QSE2_N_LEX = 59
hash       = 381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c
mtime      = 2026-09-05 20:51:03.617
words      = chiller…pump…supplies…water…air…indirect… (no boiler, no header, no feeds, no glycol)
```

Named bag file `qse_role_lexicon_semantic_16k.svh`:

```text
QSE2_N_LEX = 187
hash       = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
mtime      = 2026-09-07 14:49:07.692
```

Independent decode (this process, not RESULTS): named table **prefix 59 MATCH C0** (cls/id/word identical). New tail:

```text
boiler cls=1 id=13 … beacon cls=1 id=132     (120 entity words, ids 13..132)
feeds cls=2 id=4 ; feed cls=4 id=4
isolates=5 bypasses=6 modulates=7 discharges=8
glycol cls=3 id=3 ; steam cls=3 id=4
```

Bag `qse_role_lexicon.svh` is **four comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. Not a 61-word DIR-FULL16 table. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler`. Live CLASS_direct query is `"boiler feeds header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13. Hunt “C0 lexicon file edited”: **MISS.** Hunt “silent C0 59-word runtime claim”: **MISS** (PREREG/RESULTS/CLOSEOUT/SHA256.txt say C0 is **not** runtime). Hunt “bag lexicon is undocumented shadow”: **MISS** (named law id `qse-v2-lex-semantic-16k-01`; SHA in PRE). Hunt “C0 extract patched”: **MISS.**

### 6) INSTANTIATE keys / DUT vs nid keys / STREAM-02 clone (hunts 9)

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. No nid port. Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through frozen `{subj,rel}`. Ports are `logic [7:0]` — this **is** the `& 0xFF` width of the frozen extract / ctx-keys law, not a new wrap invented in this bag.

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. At `S_IDLE` with `qse_valid_o && !issued`: **`k0_r <= k0_o`**. `CAND_CAP` at emit. k2/k3 not used to issue AR. Default `N_BUCKETS=4096` / `CAND_CAP=64` in source; **TB overrides 65536 / 16**.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys/DUT edited this bag”: **MISS** (mtime 14:03, this bag 14:45). Hunt “nid-derived keys”: **MISS** (RTL has no nid; packing is `{subj,rel}` / `{subj,ctx[3:0],rel[3:0]}`; one numeric coincidence nid 4356 `k0=4356` on fill row `damper feeds screen` = `pack_plain(17,4)` — not a nid key). Hunt “PAGE-SKIP compiled / mixed”: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 15:17:09 2026**; exit **15:17:20**; PID **59468**; `$finish` at **35035 ns**; run elapsed **8 s**; peak sim memory **229 MB**.

Banner:

```text
C1_SEMANTIC_16K_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286517 N_SUBJECTS=120 N_RELS=8
```

Named lines (verbatim authority):

```text
CLASS_direct gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=121 ovf=1 trunc=0 dirB=32 postB=512 discB=0 descB=0 incomp=0
EMIT_direct n=3
  CAND direct i=0 id=120 ev=1
  CAND direct i=1 id=121 ev=1
  CAND direct i=2 id=122 ev=1
CLASS_paraphrase … emit {120,121,122} incomp=0
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 id=123 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=124 incomp=0
CONTEXT_SELECTIVE class=wrong_context k0=3380 k1=3636 k2=1027 k3=3331 vs_direct k0=3332 k1=3588 k2=1024 k3=3328 keys_match=0 emit_match=0 law=qse-v2-intersect-context-02
CLASS_wrong_context gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=1 ovf=0 trunc=0 dirB=32 postB=32 discB=0 descB=0 incomp=0
EMIT_wrong_context n=1
  CAND wrong_context i=0 id=121 ev=1
CLASS_distractor gold_n=16 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {120,121,122}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 occ=142 incomp=0
EMIT_high_occupancy {125…140}
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=153 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=16383 incomp=0
LATE_GOLD_HIT id=16382
CAP_THEN_AND_WOULD_MISS id=16382 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 id=16382 occ=34 ovf=1 trunc=0 dirB=32 postB=224 incomp=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_SEMANTIC_16K_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_SEMANTIC_16K_XSIM_PASS=1`; `LATE_GOLD_HIT=1`; `CONTEXT_SELECTIVE=1`; `NOT_SELECTIVE=0`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` in `xsim.log` = **0**; `FIRST_DIVERGENCE` = **0**; `ROLE_COLLAPSE` = **0**; `incomp=1` = **0**. `incomp=0` on `CLASS_direct`, `CLASS_wrong_context`, `CLASS_late_gold`, `CLASS_high_id_sentinel`.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_direct emit `{120,121,122}` tp=3 — **not** `{110,144,145}`. CLASS_wrong_context emit `{121}` `keys_match=0 emit_match=0` labeled `CONTEXT_SELECTIVE` not `NOT_SELECTIVE`. Late emit `{16382}` `LATE_GOLD_HIT`. Conjunctive gate holds on raw. N banner = 16384. Hunt “N not actually 16384”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=120` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_LATE_GOLD_ID=16382` `G_LATE_K0_IDX=16` `G_LATE_K1_IDX=33` `G_CTX[4]=3` `G_CTX_VALID[4]=1` `G_K0_PLAIN[4]=16'h0D04` `G_K0[4]=16'h0D34`. Direct bytes LSB-first `"boiler feeds header"` (len 19). Frozen extract keys on the bound query **stay** `0x0D04/0x0E04`; fold produces `0x0D34/0x0E34`. That is the nibble packing `{subj,ctx[3:0],rel[3:0]}` of glycol id=3, not a role swap.

### 8) Independent corpus — N=16384, 120 ev1 subjects, 8 rels, formulaic grid, not 12-clone, not semantic mass

Authority = live `corpus.json` **records** (hash `2b5d3028…`), **not** the JSON header fields and **not** RESULTS.

```text
n records         = 16384 (nid 0..16383 contiguous)
evidence=1        = 16325
evidence=0        = 59 (synth fillers only)
subj_id ev=1      = {13..132} n=120     (no C0 ids 1..12 as ev1 subjects)
rel_id  ev=1      = {1,2,3,4,5,6,7,8} n=8
obj_id  ev=1      = {13..132} n=120
ctx_id  all       = {0:16382, 3:1, 4:1}
N_BUCKETS header  = 65536
kinds             = semantic_core 120 / fill 16196 / high_occ_synth 15 /
                    high_occ_k0_extra 8 / ovf_synth 4 / late_k0_fill 16 /
                    late_k1_fill 16 / + 9 planted specials
```

Packing: `k0_plain==(subj<<8)|rel` on all 16384 records: **0** failures. Packed `k0=={subj,ctx[3:0],rel[3:0]}` when `ctx_valid`: **0** failures. `subj_id != (subj_id & 0xFF)`: **0**. `id>255`: **0**. Host `pack_plain` / `ctx_keys` **do** mask `& 0xFF`; on this corpus every id already fits in 8 bits (13..132). Hunt wrap-collapse of 100+ subjects: **MISS this bag.** Residual: later ids >255 would alias. Hunt nid-derived keys: **MISS** (one numeric coincidence nid 4356 = `pack_plain(17,4)` on `damper feeds screen`).

**12-entity clone hunt: MISS.**

```text
"pump supplies chiller" text count = 0
PSC SRO (subj=10,rel=1,obj=1) ev1  = []
C0 subj 1..12 in ev1               = []
direct text                        = "boiler feeds header"  (NOT pump/chiller)
```

**Formulaic-grid hunt: HIT as quality, not as 12-clone FAIL.**

Every one of 16384 texts MATCH `^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$`. Template entities n=120, template rels n=8, extra words `{glycol,steam}` only. Unique texts = 16327 (= unique SRO+ctx). `semantic_core` is 120 rows `NEW_SUBJ[i]` × `rel=1+(i%8)` × cycling object. `fill` is cartesian `s ∈ {13..132} × r ∈ {1..8} × o ∈ {13..132}, s!=o` until `fill_lim=16350` (16196 rows, all `evidence=1`). Paraphrase is article insertion `"the boiler feeds the header"` (`the` already in C0 function words). Unrelated `"payroll tax form"` is OOV empty-walk. This is **not** held-out natural language, not multi-sentence HVAC prose, not a many-ctx stress (ctx=3 count=1, ctx=4 count=1). It **is** distinct entity/relation **id mass** meeting the WO numeric gate (≥100 subj, ≥8 rel, not cloned PSC × N).

Planted control rows (independent, not RESULTS):

```text
nid 120  text="boiler feeds header"            ctx=0  k0=3332 k1=3588  kind=direct_plain
nid 121  text="boiler feeds header glycol"     ctx=3  k0=3380 k1=3636  kind=direct_glycol
nid 122  text="boiler feeds header steam"      ctx=4  k0=3396          kind=direct_steam
nid 123  text="header feeds boiler"            ctx=0  k0=3588          kind=role_reverse
nid 124  text="boiler isolates header"         ctx=0  k0=3333          kind=wrong_rel
nid 16382 text="cyclone discharges beacon"     ctx=0  k0=33544 k1=33800 kind=late_gold
nid 16383 text="hopper isolates silo"          ctx=0                   kind=high_id_sentinel
```

Host dual-index (always plain k0/k1; **also** packed k0/k1 if record `ctx_valid`):

```text
plain k0=3332 occ=121
plain k1=3588 occ=18
plain AND            = {120,121,122}          ← CLASS_direct

packed k0=3380 occ=1
packed k1=3636 occ=1
packed AND           = {121}                  ← CLASS_wrong_context

121 ∈ plain lists  (so unbound direct still retrieves it)
120 ∉ packed 3380  122 ∉ packed 3380
```

Independent skip of query ctx fold (walk plain 3332/3588 on the bound `"boiler feeds header glycol"`): emit **`{120,121,122}` = direct**. That path would print `NOT_SELECTIVE` and `FAIL WRONG_CONTEXT_NOT_SELECTIVE`. Live did not. **Query ctx fold is necessary** for emit to differ.

Gold predicate (host, before walker, hashed before xvlog): `subj=13 ∧ rel=4 ∧ obj=14 ∧ ctx_id==3` → `{121}`. On this corpus the packed posting coincides because **ctx_id==3 count = 1** (planted `direct_glycol` nid 121 whose text **is** the wrong_context query). Same 1-id plant geometry as CONTEXT-02 nid 144 / water.

Late gold nid 16382 (`cyclone discharges beacon`, k0=33544=`0x8308`, k1=33800=`0x8408`, ctx=0):

```text
k0 occ=17  index of 16382 = 16  (>=16)
k1 occ=34  index of 16382 = 33  (>=16)
full ∩              = {16382}
first16 ∩ first16   = {}          16382 NOT in first16 of either list
complete ∩ then cap = {16382}
stream-then-cap16   = {16382}
```

MATCH raw `LATE_GOLD_HIT id=16382` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0` and GOLDEN `late_gold_k0_index=16` `late_gold_k1_index=33` `occupancies=[17,34]`. `CAP_THEN_AND_WOULD_MISS` **is** gated on gold bit `G_CAP_THEN_AND_MISS` (print tautology). Independent first16∩={} and indices 16/33 prove the bit is true. Hunt late-gold miss hidden: **MISS.** Hunt one-list plant: **MISS.**

Key arithmetic (independent, not RESULTS):

```text
direct k0 = 3332 = 0x0D04 = {subj=13, rel=4}
wc     k0 = 3380 = 0x0D34 = {subj=13, ctx=3, rel=4}
direct k1 = 3588 = 0x0E04 = {obj=14,  rel=4}
wc     k1 = 3636 = 0x0E34 = {obj=14,  ctx=3, rel=4}
wc     k2 = 1027 = {rel=4, ctx=3}
direct k2 = 1024 = {rel=4, ctx=0}
wc     k3 = 3331 = {subj=13, ctx=3}
direct k3 = 3328 = {subj=13, ctx=0}
```

Host comment in `host_astra_c1_semantic_16k.py` (`LATE_S, LATE_O = 131, 132  # centrifuge discharges cyclone`) is **stale vs ENT map** (id 131=cyclone, 132=beacon). Live gold/xsim/corpus text is `"cyclone discharges beacon"`. Doc nit, not an emit FAIL.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {120,121,122}` tp=3 incomp=0; `CONTEXT_SELECTIVE` k0=3380/k1=3636 vs 3332/3588 keys_match=0 emit_match=0; wrong_context emit `{121}`; `LATE_GOLD_HIT id=16382` incomp=0; distractor `leak_n=0 gold_n=16`; unrelated empty-walk). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD. `TWELVE_ENTITY_CLONE=NO` MATCH independent. `N_SUBJECTS=120 N_RELS=8` MATCH independent ev1 sets. `NOT_SELECTIVE` is **ABSENT** this bag (not relabeled).

Implementer prose that dual-index keeps unbound direct on `{120,121,122}` while `"boiler feeds header glycol"` binds NEW CLS_CTX glycol id=3 and walks packed keys: **HONEST vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat). Hunt `NOT_SELECTIVE` relabeled PASS: **MISS.** Hunt “semantic mass” as **Master close**: **MISS as claim** (RESULTS/CLOSEOUT say does not close Master ≥95%). Hunt “semantic mass” as **corpus quality**: **HIT** (formulaic cartesian grid; see §8).

CLOSEOUT MATCH raw: marker present, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` instantiate, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…`, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 14:49:09 PRE before xvlog 14:50:35. CLOSEOUT `xelab ~18 min` is **~26 min** wall (14:50:35→15:16:57). Timing nit, not a law FAIL. Independent tree claim `max mtime 10:52:29` MATCH live.

Host `n_post` vs DUT `postB/16` residual (direct 36 vs 32; hoc 44 vs 42; overflow 36 vs 35; late 14 vs 14 MATCH). This bag did not register AXI-beat identity. P2, not emit FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. N not 16384 / silent N=256 drop / MEM hidden | **MISS.** Banner `N=16384`; `G_N=16384`; corpus n=16384 contiguous nids; TB `N_DROP` not taken; `FIRST_DIVERGENCE` ABSENT; xelab hosted `MEM_DEPTH=286517`; xsim 8 s peak 229 MB. | Drop N ⇒ FAIL. Do not silently shrink. |
| 2. 12-entity clone / PSC × N | **MISS.** ev1 subj `{13..132}` n=120; rel n=8; PSC text count=0; C0 ids 1..12 not ev1 subjects; direct is boiler/feeds/header. | Numeric mass meets WO. Not 800k-representative. |
| 3. Formulaic grid sold as semantic mass | **HIT as quality / promotion bound. MISS as registered-unknown FAIL.** 16384/16384 texts are `{ent} {rel} {ent}` (+ optional glycol/steam). Fill is cartesian S×R×O. Paraphrase = articles. ctx=3 count=1. | WO asked ≥100 subj ≥8 rel not 12-clone — **met**. PLAN bag7 “held-out combinations / real mass” is **not** this corpus. **REJECT 800k.** |
| 4. Host `subj_id & 0xFF` wrap | **MISS as this-bag collapse** (ids 13..132; wrap count=0). **HIT as law residual** (ctx keys / extract ports are 8-bit; packers mask `& 0xFF`). | Ids >255 would alias. New unknown if keys grow. |
| 5. C1 800k / bounds / ACCEPT_BOARD / N=65536 started | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag. | Never grant. Never freeze. Never auto-start 800k. |
| 6. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0 on retrieve classes; conjunct includes `incomp_retrieve==0`. | Keep miss as FAIL on later bags. |
| 7. C0 lexicon FILE edited | **MISS.** Live `38189974…` mtime 2026-09-05 20:51:03; `QSE2_N_LEX=59`. | Do not edit C0 files. |
| 8. Silent bag lexicon shadow | **MISS as silent C0 claim.** Named law documented; PRE hashes named file; xvlog bag-first disclosed; C0 prefix MATCH inside named table; C0 cannot tokenize `boiler` but live did. **HIT as include-path geometry** (same `-i $bag` first as DIR-FULL16, now with a law id). | Keep named-law discipline. Do not later claim C0 59-word runtime. |
| 9. STREAM-02 / ctx keys / ctx DUT edited or STREAM-02 compiled | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` / `8255a798…` mtime 14:03, this bag 14:45. | Hash mismatch ⇒ FAIL, do not patch. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 11. Gold after FAIL / after xvlog | **MISS.** PRE 14:49:09; xvlog 14:50:35; gold still 14:49:09; named lex still 14:49:07; no r0. | Do not regenerate gold. |
| 12. KEEP bags mutated | **MISS.** CONTEXT-02 GOLDEN **14:12:02** `8fc931f5…`; PAGE-SKIP 13:34:19; STREAM-02 11:43:45; DIR-FULL16 12:44:33; N4096-STREAM-02 12:10:22; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 13. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Dual-index prose MATCH independent. | Authority = raw CLASS_* + CONTEXT_SELECTIVE + LATE_GOLD_HIT + independent postings. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 32/32 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…`). | SHA256.txt 14:50:34 is the first-xvlog freeze. |
| 15. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 14:45. | Keep that tree read-only. |
| 16. Direct `{110,144,145}` clone / late 16382 miss | **MISS.** Raw `{120,121,122}` tp=3; independent plain AND `{120,121,122}`; `LATE_GOLD_HIT id=16382` incomp=0; idx 16 and 33. | Identity control, not Master ≥95%. |
| Host dual-index tautology (emit differs **without** query ctx) | **MISS as no-ctx cheat.** Counterfactual: walk plain 3332/3588 on the bound query → `{120,121,122}` = direct (would FAIL). Live keys are the ctx nibble fold. **HIT as construction/quality:** corpus `ctx_id==3` count = **1**. | Dual-index is the index-side of the law. Selectivity is 1-id identity. |
| CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩={} and 16382 at 16 and 33). | Same geometry as STREAM-02 N=256 KEEP, scaled nid. |
| Direct prec=1000 is 3-id identity; wc prec=1000 is 1-id identity | **HIT as quality caveat.** Direct labels = plain k0∩k1; wc gold = the planted glycol row. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| RTL default N_BUCKETS=4096 / CAND_CAP=64 vs TB 65536 / 16 | **MISS as this-bag behavior** (TB override; banner 65536/16; 16<16384). **HIT as reuse caveat.** | Defaults are not FINAL. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** Retrieve ARs are the context DUT’s own master. `N_BUCKETS=65536` is a parameter instantiate of unedited `09334e42…`. | Do not call idle dir “the merge”. Do not call this a new dir unknown. |
| Host n_post vs DUT postB | **HIT as residual.** Direct 36 vs 32 beats; hoc 44 vs 42; overflow 36 vs 35; late 14=14. | Not this-unknown FAIL (emit locked). Do not freeze DDR bytes from either number. |
| CLOSEOUT xelab ~18 min vs live ~26 min | **HIT as timing nit.** xvlog 14:50:35 → xelab.log 15:16:57. xsim 8 s MATCH. | Not a law FAIL. |
| Host LATE comment “centrifuge discharges cyclone” | **HIT as source comment.** Live text is `cyclone discharges beacon` (ids 131/132). | Do not cite the comment. |

qstack-validation-adversary one-liner: **SEMANTIC-16K-01 XSim is a real N=16384 host+instantiate lock on unpatched C0 extract (`cd7baf49…`) with a **documented NEW** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…`, bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime — C0 cannot tokenize `boiler` but live CLASS_direct did): frozen ctx keys `124be808…` and ctx DUT `8255a798…` instantiated not edited; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; independent corpus n=16384 contiguous, ev1 distinct subj=120 (ids 13..132) rel=8, PSC text count=0, every text a `{ent} {rel} {ent}` template, fill=16196 cartesian S×R×O; CLASS_direct emit `{120,121,122}` (`boiler feeds header` ± glycol/steam, **not** `{110,144,145}`); bound `"boiler feeds header glycol"` walks packed k0=3380=`0x0D34` k1=3636=`0x0E34` and emits `{121}` (`CONTEXT_SELECTIVE keys_match=0 emit_match=0`); no-fold counterfactual would still emit `{120,121,122}` (FAIL); late-gold nid 16382 `cyclone discharges beacon` at k0 index 16 **and** k1 index 33 still emits (`LATE_GOLD_HIT`, first16∩={}, `SEARCH_INCOMPLETE` ABSENT); leftover A09 off; poke_v=0; gold PRE 14:49:09 before xvlog 14:50:35; KEEP CONTEXT-02 / PAGE-SKIP / STREAM-02 unmodified; independent tree ≤10:52:29; that is not C1 800k, not held-out semantic mass, not ACCEPT_BOARD, and still an axi_mem_model / 8-bit-id / 1-id ctx plant / 3-id identity rung.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted direct `{120,121,122}` / wrong_context `{121}` / late `{16382}`). Findings are **law-quality / promotion bounds / PLAN-shape residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **N=16384 was actually hosted.** `G_N=16384`; corpus 16384; banner 16384; MEM_DEPTH 286517 TB-only; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 clone.
2. **Numeric semantic-rung mass is real vs 12-entity clone.** 120 ev1 subject ids 13..132, 8 rel ids, 0 PSC clones, direct is boiler/feeds/header. WO ≥100/≥8 **met**.
3. **Corpus is a formulaic HVAC-word cartesian grid, not semantic mass.** 16384 template triples; fill is S×R×O; paraphrase is `the`; ctx tokens total 2 planted rows. Honest vs WO. Illegal as Master ≥95% / 800k-representative / PLAN bag7 “held-out combinations”.
4. **Query ctx fold is a real discriminator vs CLASS_direct.** Independent: same SRO; frozen k0 stays 3332; folded k0=3380 inserts ctx nibble 3; no-fold counterfactual emit equals direct; live emit `{121}` ≠ `{120,121,122}`. Host dual-index is required for the **control** (121 stays in plain lists) and is disclosed. Selectivity is a planted singleton (`ctx=3` count=1).
5. **Late gold 16382 survived instantiate** (unbound, ctx=0, plain keys). Both-list index ≥16; first16∩={}; emit `{16382}` incomp=0. Direct control `{120,121,122}` survived dual-index. Distractor leak_n=0 on a 16-id excluded set. Polarity meter intact.
6. **Runtime lexicon is NEW named 187-word.** C0 FILE unedited 59-word prefix copied into the named table. xvlog bag-first is the DIR-FULL16 include geometry **with a law id**. P2 from 1250Z (named lexicon law id) is **closed as documentation** on this bag, not re-opened as a silent shadow.
7. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the context DUT master. `N_BUCKETS=65536` is a parameter instantiate of unedited `09334e42…`. Same pattern as STREAM-02 / PAGE-SKIP / CONTEXT-02 / DIR-FULL16.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **CAND_CAP default 64 and N_BUCKETS default 4096 in RTL source are future-bag hazards**, not this-bag cheats (TB 16 / 65536). Do not freeze 16 as `CAND_CAP_FINAL`.
10. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
11. **8-bit key packing (`& 0xFF`, 4-bit ctx/rel nibble)** did not collapse this 120-id set. It will alias past 255 / past 16 ctx or rel values. New unknown if keys grow. Not a this-bag emit FAIL.
12. **12-entity clone is gone; formulaic grid + axi_mem_model + 1 planted ctx=3 row + 3-id identity remain the promotion stop.** PLAN bag 7 first rung is “N=16384 numeric mass + gold recall without incomp” — **closed as PASS_NARROW**. 800k / N=65536 / held-out NL are **not** closed and **not** started by this audit.
13. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| INSTANTIATE keys (`124be808…`, `{subj,ctx[3:0],rel[3:0]}` when ctx_valid, else frozen pass-through, no nid, **not edited**) | **PASS_NARROW** | Live 3332→3380 is the nibble insert of named glycol id=3. |
| INSTANTIATE DUT (`8255a798…`, `k0_r <= k0_o`, k2/k3 not probed, not STREAM-02 file, **not edited**) | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02. |
| Independent wc AND: packed k0=3380 ∩ k1=3636 = `{121}`; no-fold counterfactual = `{120,121,122}` | **PASS_NARROW** | Query ctx is necessary. Dual-index is the control, not a no-ctx cheat. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys/DUT freeze (mtime 14:03, this bag 14:45) | **PASS_NARROW** | Instantiated, not edited. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched; N_BUCKETS=65536 parameter) | **PASS_NARROW** | AXI-idle instantiate. |
| NEW lexicon **runtime** = `df0e8833…` 187-word; C0 FILE `38189974…` unedited NOT runtime; xvlog `-i` bag first documented | **PASS_NARROW** | C0 cannot name boiler; live did. Not silent 59-word claim. |
| Registered unknown (N=16384 **and** subj≥100 rel≥8 **and** not 12-clone **and** CLASS_direct `{120,121,122}` **and** CLASS_wrong_context emit `{121}` ≠ direct **and** CONTEXT_SELECTIVE **and** LATE_GOLD 16382 **and** SEARCH_INCOMPLETE ABSENT) | **PASS_NARROW** | Raw CLASS_direct tp=3; CONTEXT_SELECTIVE present; NOT_SELECTIVE absent; `LATE_GOLD_HIT id=16382`; marker present; independent mass 120/8. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_SEMANTIC_16K_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k. |
| Formulaic grid / not semantic mass | **HIT as quality bound, MISS as this-unknown FAIL** | WO numeric mass met. PLAN held-out mass not met. |
| Dual-index no-ctx tautology / nid keys / NOT_SELECTIVE relabel / 12-clone / N-drop | **MISS (not FAIL of this unknown)** | Fold is live; nid unused; NOT_SELECTIVE not printed; N=16384; PSC=0. Construction is a 1-id plant + cartesian fill. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; conjunct includes `incomp_retrieve==0`. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; wc 1000 is 1-id identity; formulaic grid; reduction not emitted. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | Formulaic grid / 8-bit ids / axi_mem_model / ctx=3 count=1. This audit does not start next bags. PLAN bag 7 remainder OPEN. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 14:49:09; xvlog 14:50:35; gold 14:49:09 KEEP `0e539d48…`; named lex `df0e8833…`; no r0. |
| KEEP CONTEXT-02 + PAGE-SKIP + STREAM-02 + DIR-FULL16 + N4096-STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT + stream DUT + page-skip DUT + ctx keys + ctx DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1415Z / C0. CONTEXT-02 GOLDEN **14:12:02**. STREAM-02 GOLDEN **11:43:45**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=16384 `qse-v2-intersect-context-02` instantiate + NEW named lexicon `qse-v2-lex-semantic-16k-01`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word with C0 59-word prefix MATCH; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; CLASS_direct `{120,121,122}` boiler/feeds/header via host dual-index of plain keys; CLASS_wrong_context emit `{121}` ≠ direct with live `CONTEXT_SELECTIVE keys_match=0 emit_match=0`; late-gold 16382 still emits at k0 idx 16 and k1 idx 33; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` / ctx DUT `8255a798…` unedited instantiate; dir file `09334e42…` unedited; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest; N actually 16384; ev1 subj=120 rel=8; **not** 12-entity / PSC clone; fold is **not** nid keys and **not** a no-ctx dual-index cheat). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “semantic mass / held-out NL closed”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, NOT_SELECTIVE not relabeled, PASS is honest, late gold both-list, SEARCH_INCOMPLETE absent, N not dropped, lexicon law named). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k; dual-index disclosed; 12-clone hunt fails; N-drop hunt fails; silent-C0 hunt fails). **Not** FAIL of the N=16384 numeric-mass unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** a non-grid held-out rung of PLAN bag 7. Do **not** auto-start 800k / N=65536. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-16K-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB=512.

**P1 — none for this unknown** (independent N=16384; ev1 subj=120 rel=8; PSC=0; packed AND `{121}` vs plain AND `{120,121,122}`; no-fold counterfactual equals direct; CLASS_direct `{120,121,122}`; CONTEXT_SELECTIVE keys_match=0 emit_match=0; NOT_SELECTIVE absent; LATE_GOLD 16382 at k0 index 16 and k1 index 33; SEARCH_INCOMPLETE ABSENT; ctx keys/DUT not edited; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; named lexicon runtime; gold PRE before xvlog).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=16384 numeric-mass instantiate + named lexicon. Authority = raw `CONTEXT_SELECTIVE` / `CLASS_direct {120,121,122}` / `EMIT_wrong_context {121}` / `LATE_GOLD_HIT id=16382` / `SEARCH_INCOMPLETE` ABSENT + independent postings + named lex `df0e8833…`. Do not silent-patch STREAM-02 / CONTEXT-02 / C0.
2. **Do not sell this as semantic mass, held-out NL, or PLAN bag7 close.** Corpus is a 120-word HVAC cartesian grid; paraphrase is articles; ctx=3 count=1; query text = planted row 121. Next “semantic” bag that claims mass must not be another `triple_text(s,r,o)` fill.
3. **Parent MAY open OPTIONAL next:** a non-grid held-out combination rung (still PLAN bag 7, still not 800k). One unknown. **Not this audit. Do not start 800k / N=65536 from this close.** Independent PLAN bag 7 remainder remains **OPEN**.
4. **Do not auto-start C1 800k / N=65536 / BOARD_PASS.** Formulaic grid + 8-bit ids + `axi_mem_model` + singleton ctx plant are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused this bag; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on several classes.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `CONTEXT_SELECTIVE` vs `NOT_SELECTIVE` (FAIL if emit_match or keys_match); no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; named lexicon law id whenever C0 59-word cannot bind the corpus; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`.
7. Next bag should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02 / CONTEXT-02.
8. If a later law must use subject ids >255, or more than 4 bits of ctx/rel, or walk k_ctx as a third list, that is a **new** named module / new bag. Do not silent-patch `a7ng_query_role_keys_ctx.sv` or C0 extract. Do not grow `& 0xFF` packing past the 8-bit port.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including CONTEXT-02 GOLDEN 14:12:02 (ctx fold `{110,144,145}` / `{144}`), PAGE-SKIP GOLDEN 13:34:19, STREAM-02 N=256 nid 254 at 20/22, DIR-FULL16 GOLDEN 12:44:33 (61-word include-path P2 archive) stay on disk as evidence of prior process.
11. Optional: fix host comment `centrifuge discharges cyclone` to `cyclone discharges beacon`. Optional: print DUT `n_post` vs host `n_post` on CLASS lines so the 36-vs-32 residual is not rediscovered. Neither is a this-bag FAIL.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=16384 qse-v2-intersect-context-02 instantiate
                         + NEW named lexicon qse-v2-lex-semantic-16k-01;
                         N actually 16384 contiguous; G_N=16384; banner N=16384;
                         MEM_DEPTH=286517 TB-only; FIRST_DIVERGENCE MEM ABSENT;
                         INSTANTIATE keys a7ng_query_role_keys_ctx 124be808…
                           mtime 14:03:07 NOT this bag; NOT edited;
                           k0={subj,ctx[3:0],rel[3:0]} when ctx_valid
                           else frozen {subj,rel}; no nid;
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
                           instantiated AXI-idle; N_BUCKETS=65536 parameter;
                         C0 lexicon FILE 38189974… QSE2_N_LEX=59
                           mtime 2026-09-05 20:51:03 UNEDITED; NOT runtime;
                         C0 extract cd7baf49… mtime 2026-09-05 19:48:18 UNEDITED;
                         NEW lexicon RUNTIME df0e8833… QSE2_N_LEX=187
                           prefix 59 MATCH C0; +120 ents ids 13..132
                           + feeds/isolates/bypasses/modulates/discharges
                           + glycol cls=3 id=3 / steam cls=3 id=4;
                           xvlog -i $bag FIRST documented;
                           bag qse_role_lexicon.svh is include-name shim 7966f321…;
                           C0 cannot tokenize boiler; live CLASS_direct did;
                         CLASS_direct emit={120,121,122} tp=3 prec_all=1000 incomp=0
                           text="boiler feeds header" NOT {110,144,145};
                         CONTEXT_SELECTIVE class=wrong_context
                           k0=3380 k1=3636 vs_direct k0=3332 k1=3588
                           keys_match=0 emit_match=0;
                         CLASS_wrong_context emit={121} gold_n=1 tp=1 incomp=0
                           text="boiler feeds header glycol";
                         NOT_SELECTIVE ABSENT (not relabeled);
                         independent:
                           ev1 subj n=120 ids 13..132;
                           ev1 rel n=8 {1..8};
                           PSC text count=0; C0 subj 1..12 in ev1 = [];
                           16384/16384 texts template {ent} {rel} {ent}[+ctx];
                           fill cartesian 16196; pad_synth=0;
                           nid 120 "boiler feeds header" ctx=0 k0=3332;
                           nid 121 "boiler feeds header glycol" ctx=3 k0=3380;
                           nid 122 "boiler feeds header steam" ctx=4 k0=3396;
                         dual-index plain AND={120,121,122};
                         packed AND={121};
                         no-fold counterfactual emit={120,121,122} (would FAIL);
                         LATE_GOLD nid 16382 "cyclone discharges beacon"
                           k0=33544=0x8308 occ=17 idx=16;
                           k1=33800=0x8408 occ=34 idx=33;
                         first16∩first16 = {}; complete∩ then cap = {16382};
                         raw LATE_GOLD_HIT id=16382 CAP_THEN_AND_WOULD_MISS stream_hit=1
                           CLASS_late_gold emit={16382} tp=1 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold 0e539d48… 14:49:09 PRE before xvlog 14:50:35;
                         named lex df0e8833… 14:49:07 PRE;
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
                            not held-out semantic mass;
                            formulaic grid + axi_mem_model + ctx=3 count=1 remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   dual-index disclosed; 12-clone hunt MISS; N-drop hunt MISS;
                   silent-C0 hunt MISS; NOT_SELECTIVE not relabeled;
                   HIT as quality: formulaic grid ≠ semantic mass)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL non-grid held-out rung of PLAN bag 7
                   (do NOT auto-start C1 800k / N=65536;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
PLAN_BAG7_SEMANTIC = FIRST_RUNG_PASS_THIS_GATE_ONLY (remainder OPEN)
N_16384          = THIS_BAG
N_65536          = NOT_STARTED
SEMANTIC_16K_XSIM  = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_SEMANTIC_16K_XSIM_PASS PRESENT
                   PID 59468; 35035 ns; 15:17:09–15:17:20; elapsed 8 s
                   xsim.log SHA256 bc03a39b8376b72da3d6ed845999cf83a95e87aa3b6e35f482d43b5b60651d3e
                   CLASS_direct {120,121,122} tp=3 incomp=0
                   CONTEXT_SELECTIVE k0=3380 k1=3636 keys_match=0 emit_match=0
                   EMIT_wrong_context {121}
                   NOT_SELECTIVE ABSENT
                   LATE_GOLD_HIT id=16382 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 14:49:09; named lex 14:49:07;
                                PRE MATCH live; no r0; PASS session
DUT_CTX_KEYS     = UNEDITED     124be808… mtime 14:03:07 MATCH CONTEXT-02; instantiated
DUT_CTX_WALK     = UNEDITED     8255a798… mtime 14:03:24 MATCH CONTEXT-02; instantiated as DUT
DUT_STREAM       = UNEDITED     14f75db7… mtime 11:43:39 MATCH STREAM-02; NOT compiled
DUT_PAGE_SKIP    = UNEDITED     dab15d76… mtime 13:31:29 MATCH PAGE-SKIP; NOT compiled
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_DIR_FILE      = UNEDITED     09334e42… mtime 2026-09-05 19:31:03
C0_LEXICON_FILE  = UNEDITED     38189974… mtime 2026-09-05 20:51:03; NOT runtime
C0_EXTRACT       = UNEDITED     cd7baf49… mtime 2026-09-05 19:48:18
RUNTIME_LEXICON  = NAMED_187    df0e8833… QSE2_N_LEX=187; xvlog -i bag FIRST
BAG_LEXICON_SHIM = PRESENT      7966f321… include-name only (documented NEW law)
C0_PATCH         = MISS
NID_KEYS         = MISS         (coincidence nid 4356 == pack_plain(17,4) only)
DUAL_INDEX_NO_CTX = MISS as cheat; HIT as 1-id plant / dual-index control
NOT_SELECTIVE_RELABEL = MISS
TWELVE_ENTITY_CLONE = MISS
N_DROP           = MISS
SILENT_C0_RUNTIME = MISS
FORMULAIC_GRID   = HIT as quality (16384 template triples; fill cartesian)
SEMANTIC_MASS    = NOT THIS CORPUS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 65536 this bag (RTL source default 4096 overridden by TB)
CTX3_COUNT       = 1 (nid 121 direct_glycol)
CTX4_COUNT       = 1 (nid 122 direct_steam)
NOFOLD_EMIT      = {120,121,122}   (independent)
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
SHA256_TXT_MISMATCHES = 0 / 32
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=65536 / 800k in this audit. Independent PLAN bag 7 remainder remains OPEN.
