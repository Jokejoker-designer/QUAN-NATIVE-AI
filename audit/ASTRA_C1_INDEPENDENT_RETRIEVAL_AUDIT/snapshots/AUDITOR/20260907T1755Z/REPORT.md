# ASTRA auditor REPORT — 20260907T1755Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01
LAW        = qse-v2-intersect-context-02
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           INSTANTIATE DUT  a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             (STREAM-02 two-pointer copy; k2/k3 not probed; NOT edited)
LEXICON    = qse-v2-lex-semantic-16k-01 COPIED named
           runtime = bag qse_role_lexicon_semantic_16k.svh df0e8833… (mtime 14:49:07; NOT rewritten)
           include-name bag qse_role_lexicon.svh (shim `include of named file; same 14:49:07)
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
KEEP       = ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 (must be unmodified; GOLDEN 17:01:44 verified)
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
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1705Z/REPORT.md
           ACCEPT_PARTIAL (N=256 unseen-SRO IDENTITY; P1 none; parent MAY open OPTIONAL
             scale of the same contract at N=16384)
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md bag7 remainder (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01.md
EVIDENCE   = raw xsim.log FILL_TEMPLATE_HIT / UNSEEN_SRO_HIT / UNBOUND_EMPTY_WALK /
             UNRELATED_EMPTY_WALK / CLASS_* / EMIT_* /
             ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS / SEARCH_INCOMPLETE
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon df0e8833… + KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K /
             CONTEXT-02 / PAGE-SKIP / STREAM-02 GOLDEN
           + file LastWriteTime (gold PRE 17:29:38 vs surviving xvlog 17:37:44 vs xelab 17:50:57
             vs xsim 17:50:58; claimed abort 17:30 leftover ABSENT; KEEP bags)
           + INSTANTIATE keys rtl/native_graph/query/a7ng_query_role_keys_ctx.sv
             (mtime 14:03:07 NOT this bag)
           + INSTANTIATE DUT rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv
             (mtime 14:03:24 NOT this bag)
           + STREAM-02 DUT a7ng_query_axi_sparse_stream_intersect.sv (mtime 11:43:39; NOT compiled)
           + PAGE-SKIP DUT a7ng_query_axi_sparse_page_skip.sv (mtime 13:31:29; NOT compiled)
           + frozen dir rtl/native_graph/memory/a7ng_sparse_dir_axi.sv (file hash; AXI-idle instantiate)
           + TB tb_astra_c1_semantic_unseen_sro_16k.sv (poke_v, leftover A09, PASS conjunct, N_DROP, leak)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx include order
           + xvlog include_dirs order in run_xsim.ps1 (`-i $bag -i $incq -i $incc`)
           + bag qse_role_lexicon.svh (shim) vs named qse_role_lexicon_semantic_16k.svh vs C0 59-word
           + query_gold.svh / GOLDEN.json / corpus.json records / host_astra_c1_semantic_unseen_sro_16k.py
           + independent cartesian-fill membership of nids 123–130 and unbound SRO=(13,4,1)
             and exact-key postings for k0=3332/k1=3588 and k0=257/k1=513 and k0=3332/k1=260
             (not RESULTS)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
SEMANTIC_UNSEEN_SRO_16K = THIS BAG (N=16384 cartesian-generator SAMPLE + 8 off-grid C0 HVAC
                          plants; retrieve 1 of 8 as identity; not semantic mass; not Master
                          close; not 800k; not N=65536)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
PLAN_BAG7_SEMANTIC    = UNSEEN_SRO_16K_SCALE_IDENTITY_THIS_GATE_ONLY
                        (800k / N=65536 / NL mass NOT started)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 N=256 / DIR-FULL16 / N4096-STREAM-02 / N4096-INTERSECT / KEY-INTERSECT / AXI-BEAT, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C1 800k / N=65536, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=16384 unseen / non-grid SRO scale** bag `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` after auditor `20260907T1705Z` ACCEPT_PARTIAL of N=256 unseen-SRO **identity** (1-id plant; not mass) allowed parent to open OPTIONAL PLAN bag 7 remainder **scale** slice.

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=16384, cartesian fill over the SEMANTIC-16K generator `NEW_SUBJ_IDS={13..132}` **plus** ≥8 off-grid planted `(s,r,o)` facts **not** in that fill generator. Retrieve one planted nid (`gold_n>=1`) under instantiate ctx keys `124be808…` + DUT `8255a798…` (not edited). A query bound to an (s,r,o) that is **not** indexed must `UNBOUND_EMPTY_WALK` and must **not** emit fill-grid neighbors `{120,121,122}`. `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL. If XSim cannot host 16384, FAIL honestly `FIRST_DIVERGENCE MEM` — do **not** silently drop to N=256.

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS` present. N actually 16384 (not a silent drop of the registered scale). `PLANTED_N=8`. `FILL_TEMPLATE_HIT` with tp=3 emit `{120,121,122}`. `UNSEEN_SRO_HIT` nid=123. `UNBOUND_EMPTY_WALK` emit_n=0. `SEARCH_INCOMPLETE` **ABSENT**.
2. All 8 planted SROs at nids 123–130 are **not** in the cartesian fill generator over `{13..132}`. Unbound SRO=(13,4,1) is **not** indexed. Unbound must not emit `{120,121,122}` (`UNBOUND_FILL_GRID_LEAK` = FAIL). k0-only of shared fill k0 **would** leak `{120,121,122}`.
3. Named lexicon `df0e8833…` **copied not rewritten**. C0 FILE `38189974…` unedited and **not** runtime. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` / ctx DUT `8255a798…` **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Frozen dir file `09334e42…` **not** patched. C0 extract `cd7baf49…` unedited. KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified.
4. Leftover A09 off; `poke_v=0`; gold hashed before first **surviving** xvlog and **not** regenerated after the claimed 17:30 abort / after FAIL; KEEP bags unmodified; independent tree not written.
5. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k / BOARD_PASS. Do **not** start N=65536 / 800k. Do **not** sell 1-of-8 retrieve or cartesian-generator **sample** as semantic mass / Master ≥95% / C1 800k.

This bag **cannot** close C1 800k, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`, cannot close N=65536, cannot close true NL synonym hold-out. Remaining planted nids 124–130 were **indexed but not queried**.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-UNSEEN-SRO-01/` (GOLDEN `9fce7fad…` timestamp **17:01:44**; CLOSEOUT **17:04:05**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-HELDOUT-01/` (GOLDEN `3c1eda7d…` timestamp **15:44:21**; CLOSEOUT **16:06:53**)
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

**Not** this bag: C1 800k close, N=65536 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL **file** patch, silent C0 59-word runtime claim, threshold drop, `relevant=router_union`, nid-derived keys, loading full posting into BRAM, patching KEEP bags including UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K, editing stream RTL `14f75db7…`, editing ctx keys `124be808…` / ctx DUT `8255a798…`, editing page-skip `dab15d76…`, editing `a7ng_sparse_dir_axi.sv`, mixing page-skip scheduler, starting 800k / N=65536, selling 1-of-8 retrieve or a 16373-SRO **sample** of a 114239 generator as semantic mass / Master close.

Hunt (dispatch, none dropped):

1. N drop (silent 256 / HELDOUT 4096-bucket geometry sold as 65536 / MEM FAIL hidden)
2. Only 1 retrieve of 8 plants as tautology sold as mass / Master ≥95%
3. Planted nids 123–130 SRO actually in cartesian fill over `{13..132}`
4. Unbound SRO=(13,4,1) is indexed / unbound emits `{120,121,122}` / k0-only leak sold as AND
5. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD` / N=65536 started
6. `SEARCH_INCOMPLETE` hidden on gold_n≥1 / marker-only PASS
7. C0 lexicon FILE edited (`38189974` drift) / named lex `df0e8833` rewritten
8. Bag `qse_role_lexicon.svh` silent shadow vs copied named law
9. STREAM-02 `14f75db7…` compiled as DUT or edited; ctx keys/DUT edited
10. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
11. Gold hashed after first xvlog / rewritten after FAIL / after claimed 17:30 abort
12. KEEP bags rewritten (UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K first)
13. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash)
15. Independent audit tree written by this implementer
16. Host `relevant=router_union` / nid-derived keys / k0-only walker leak sold as AND

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=16384 unseen-SRO scale-identity** unknown only.

If P1 is none for this unknown, parent next is **OPTIONAL** further PLAN bag 7 remainder (real NL / remaining planted retrieve classes). Do **not** auto-start C1 800k / N=65536 from this audit. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. UNSEEN-SRO-16K bag is untracked (`??`). KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K / CONTEXT-02 remain prior bags (GOLDEN mtimes **not** this window). Stream DUT is untracked (`??`) with **unchanged** hash `14f75db7…` mtime **11:43:39**. Page-skip DUT untracked with **unchanged** hash `dab15d76…` mtime **13:31:29**. Ctx keys untracked with **unchanged** hash `124be808…` mtime **14:03:07**. Ctx DUT untracked with **unchanged** hash `8255a798…` mtime **14:03:24**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z…1705Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). C0 lexicon FILE is `??` on this branch with live hash **MATCH** `38189974…` and mtime **2026-09-05 20:51:03** (not rewritten this bag). Extract is `??` with live hash **MATCH** `cd7baf49…` mtime **2026-09-05 19:48:18**. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T17:55:00+07:00` (file mtime **17:54:05.126**, parent-owned; auditor did not write it) `acceptance=ACCEPT_PARTIAL` `acceptance_gate=ASTRA-C1-SEMANTIC-UNSEEN-SRO-01` `unblocked_item=ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), UNSEEN-SRO-16K bag:

```text
14:49:07.692  qse_role_lexicon_semantic_16k.svh   ← COPIED from SEMANTIC-16K; NOT rewritten
14:49:07.692  qse_role_lexicon.svh                ← include-name shim; same stamp as 16k
17:22:52.658  ACK.json PREREG.md
17:26:18.870  host_astra_c1_semantic_unseen_sro_16k.py
17:29:21.996  tb_astra_c1_semantic_unseen_sro_16k.sv
17:29:21.996  run_xsim.ps1
17:29:38.554  corpus.json
17:29:38.555  GOLDEN.json
17:29:38.570  query_gold.svh
17:29:38.575  GOLD_HASH_PRE_XVLOG.txt             ← gold+named-lex hash BEFORE surviving xvlog
17:37:43.838  SHA256.txt                          ← PASS-attempt freeze immediately before xvlog
17:37:43.846  xsim_work/ CreationTime             ← PASS workspace (no 17:30 leftover)
17:37:44.779  xvlog.log                           ← surviving / PASS xvlog
17:50:57.062  xelab.log                           ← xelab ~13 min (65536-bucket elaborate)
17:50:58      xsim session start PID 24652
17:51:08.354  xsim.log                            session 17:50:58–17:51:08
17:52:43.608  RESULTS.md CLOSEOUT.md
```

Ctx keys LastWriteTime **2026-09-07 14:03:07.410** — **not newer** than CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO N=256. This bag starts 17:22. Ctx keys were not rewritten for UNSEEN-SRO-16K.

Ctx DUT LastWriteTime **2026-09-07 14:03:24.544** — **not newer**. Not rewritten.

Stream DUT LastWriteTime **2026-09-07 11:43:39.087** — **not newer** than N=256 STREAM-02 bag. Not rewritten.

Page-skip DUT LastWriteTime **2026-09-07 13:31:29.466**. Frozen dir **2026-09-05 19:31:03.634**. C0 lexicon FILE **2026-09-05 20:51:03.617**. Extract **2026-09-05 19:48:18.679**.

Named lexicon LastWriteTime **14:49:07.692** — **identical** to KEEP SEMANTIC-16K named file stamp. Hash MATCH `df0e8833…`. Byte-identical to KEEP 16k named file (9159 bytes). Copied, not regenerated. Host SHA-gates `EXPECTED_LEX_NAMED=df0e8833…` / shim `7966f321…`.

**Claimed abort 17:30 vs disk:** RESULTS/CLOSEOUT claim first xvlog **17:30:01** (aborted xelab) then PASS xvlog **17:37:44**. Independent disk: **no** `xvlog.log` / `xelab.log` / `xsim_fail_r0.log` / `xsim_work` artifact with mtime in `17:30:xx`. `xsim_work` CreationTime **17:37:43.846** (recreated for the PASS attempt). Empty `xsimcrash.log` mtime **17:50:59.252** is the PASS xsim start file (0 bytes; session `$finish`ed; not the 17:30 abort). TB / host / gold / PRE / `run_xsim.ps1` were **not** rewritten after 17:29:38. SHA256.txt restamp 17:37:43 is `run_xsim.ps1` designed behavior (live gold MATCH PRE). Hunt gold-regen-after-FAIL: **MISS**. Abort session is **implementer-claimed and not independently replayable from leftover logs**; it does not disturb gold-before-surviving-xvlog.

Gold files were **not** rewritten between 17:29:38 and 17:52:43 (hash MATCH PRE; LastWriteTime still 17:29:38). Named lexicon still 14:49:07. `xsim_fail_r0.log` **ABSENT**.

`xsim.log` SHA256 `cee6e63d48b79cb15c8de492517f84d58fa239cbe34ffb6fc5391db218a50f28` MATCH RESULTS `XSIM_SHA`.

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
c1b04ff86ede6f4f3bfd3d0f08861848404a4850df383429d7a65356b0a8856a  tb_astra_c1_semantic_unseen_sro_16k.sv
e8db0c60e0cf41a8e34a6f1c96a88382448d6c6eb6837003314e452f1f9395fb  host_astra_c1_semantic_unseen_sro_16k.py
```

C0 extract / lexicon FILE MATCH `docs/ASTRA/authority/FINAL_CONTRACT.json` `ROLE_PARSER_LAW`. STREAM-02 N=256 `SHA256.txt` lists the same stream DUT blob `14f75db7…`. Live MATCH. CONTEXT-02 SHA256.txt lists ctx keys `124be808…` and ctx DUT `8255a798…`. Live MATCH. SEMANTIC-16K named lexicon `df0e8833…`. Live MATCH this bag copy (byte-identical).

`GOLD_HASH_PRE_XVLOG.txt` mtime **17:29:38.575** vs live gold+named-lex (all MATCH):

```text
dfa19dde41e2566dc2a0d277c0ad30dc1394a6ebb90872f548de557d7a7b20a2  GOLDEN.json
429c9f8881a659ee5e17e115899ca17a7cdf9065e3e1966550b840f30a5ee15d  query_gold.svh
6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597  corpus.json
df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4  qse_role_lexicon_semantic_16k.svh
```

Surviving `xvlog.log` mtime **17:37:44.779**. Gold hashed **before** that xvlog (and before the claimed 17:30 attempt). Gold files were **not** rewritten after xsim (still 17:29:38). SHA256.txt freeze stamp `2026-09-07T17:37:43.7918900+07:00` is immediately before PASS xvlog.

SHA256.txt listed paths vs live: **33 checked, 0 mismatches** (C0 five FILE hashes, relbind keys, KEEP intersect, stream DUT `14f75db7…`, page-skip DUT `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lexicon `df0e8833…`, bag shim, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple). C0 lexicon FILE live MATCH `38189974…` independently. No invented hash.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 17:22+ |
|---|---|---|---|
| UNSEEN-SRO N=256 | `9fce7fad371afbc3…` **17:01:44.789** | CLOSEOUT **17:04:05.364** | **UNMODIFIED** |
| HELDOUT | `3c1eda7d1639ef1d…` **15:44:21.671** | CLOSEOUT **16:06:53.125** | **UNMODIFIED** |
| SEMANTIC-16K | `0e539d48be5862d0…` **14:49:09.278** | CLOSEOUT **15:18:52.927** | **UNMODIFIED** |
| CONTEXT-02 | `8fc931f5ac07a72f…` **14:12:02.956** | CLOSEOUT **14:13:59.927** | **UNMODIFIED** |
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19.424** | CLOSEOUT **13:39:47.345** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45.704** | CLOSEOUT **11:45:37.318** | **UNMODIFIED** |
| DIR-FULL16 | `2f6ab31e41837fd3…` **12:44:33.447** | CLOSEOUT **12:46:50.888** | **UNMODIFIED** |
| N4096-STREAM-02 | `2a2db8c8dcb7ac1c…` **12:10:22.762** | CLOSEOUT **12:12:27.498** | **UNMODIFIED** |
| N4096-INTERSECT | `095ca7156c1f8efe…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| KEY-INTERSECT | `d3b5b88356bd2fc6…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| AXI-BEAT | GOLDEN copy **10:16:50** | CLOSEOUT **11:11:09.523** | **UNMODIFIED** |

KEEP SEMANTIC-16K named lexicon file hash `df0e8833…` mtime **14:49:07.692** — **identical** to this bag copy. KEEP file itself was not rewritten.

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** UNSEEN-SRO-16K implementer did **not** write that tree. This auditor did **not** write that tree.

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
tb_astra_c1_semantic_unseen_sro_16k.sv
```

`xelab.log` compiled the same modules (`a7ng_query_role_keys_ctx`, `a7ng_query_axi_sparse_intersect_context`, frozen dir, TB). Truncation `N_BUCKETS=32...` / `DEPTH_WORDS=3...` is Vivado `32'd65536` / `32'd286514` display, **not** a drop to 32768: query_gold `G_N_BUCKETS=65536` `G_MEM_DEPTH=286514`; banner `N_BUCKETS=65536 MEM_DEPTH=286514`; TB diverges `DIR_WIDTH` if `G_N_BUCKETS != 65536` and `MEM` if depth too small; `FIRST_DIVERGENCE` ABSENT.

Work `*.sdb`: extract, **keys_ctx**, gate, dir, mem model, **intersect_context**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_stream_intersect.sv` as DUT, `a7ng_query_axi_sparse_page_skip.sv` as DUT, `a7ng_query_role_keys_relbind`, `a7ng_query_axi_sparse_relbind`.

`work.rlx` include order for extract: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_16k.svh`. TB/DUT include_dirs start with **bag**. Bag first.

TB holds `poke_v=0` (blocking assign in initial; never `poke_v <= 1`; never `poke_v = 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0` at start **and** each query. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 FILE hashes + KEEP intersect `a912786f…` + stream DUT `14f75db7…` + page-skip `dab15d76…` + relbind `93811ed1…` + ctx keys `124be808…` + ctx DUT `8255a798…`; throws if leftover / frozen sparse / KEY-INTERSECT / STREAM-02 / PAGE-SKIP / relbind keys on xvlog list; requires named lexicon + bag shim present; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog. PASS session ⇒ r0 ABSENT.

xvlog include_dirs (verbatim from `run_xsim.ps1` the command that produced this `xvlog.log`):

```text
xvlog.bat --sv -i $bag -i $incq -i $incc $files
```

`$bag` **FIRST** (copied named lexicon law). `$incq` = `rtl/native_graph/query` (C0 lexicon FILE) second. `$incc` = `rtl/native_graph/control`. Extract `` `include "qse_role_lexicon.svh" `` therefore binds the **bag shim** → named `qse_role_lexicon_semantic_16k.svh`. Documented copy of `qse-v2-lex-semantic-16k-01`, **not** a silent C0 59-word claim.

TB instantiates `.N_TABLES(4), .N_BUCKETS(G_N_BUCKETS), .CAND_CAP(CAND_CAP)` with `G_N_BUCKETS = 65536`, `G_CAND_CAP = 16`. Banner `N_BUCKETS=65536 CAND_CAP=16`. `if (G_N != 16384) diverge N_DROP` not taken. `if (G_N_BUCKETS != 65536) diverge DIR_WIDTH` not taken. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<16384). `MEM_DEPTH=286514` TB-only; `if (MEM_DEPTH < (6144 + 4 * G_N_BUCKETS)) diverge MEM` not taken. `G_UNSEEN_NID != 123` / `G_FILL_GRID != {120,121,122}` / `G_PLANTED_N < 8` diverges not taken.

PASS marker conjunct (TB line 486): `fail==0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (unseen_tp > 0) && unbound_empty && unbound_no_leak && (incomp_retrieve == 0) && (G_N == 16384) && (G_PLANTED_N >= 8)`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**. Unbound leak of `{120,121,122}` → `FAIL UNBOUND_FILL_GRID_LEAK`. Fill tp=0 → `FAIL FILL_TEMPLATE_GOLD_MISS`. Unseen miss → `FAIL UNSEEN_SRO_GOLD_MISS`. Unseen keys identical to fill-grid → `KEY_MISMATCH` diverge. Unbound k0 must share fill-grid k0; unbound k1 must differ.

Live: `incomp=0` on CLASS_fill_template / CLASS_unseen_sro / CLASS_unbound_sro (`incomp=0` count **3**); `SEARCH_INCOMPLETE` line count **0** in `xsim.log`; `FAIL ` line count **0**; `incomp=1` count **0**; `UNBOUND_FILL_GRID_LEAK` count **0**. Hunt swallowed-incomp: **MISS this bag.** Hunt N_DROP: **MISS this bag.**

xsimkernel: design load 17380 KB; sim peak 32744 KB; CPU 7264 ms; wall ~8 s for 4 queries. That is a **4-query walk**, not a 24 h HELDOUT-style session, and **not** evidence of N drop (banner/gold/corpus all 16384; MEM_DEPTH 286514 hosted).

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

Named prefix 59 **MATCH C0** (array identity). Host refuses rewrite: live SHA must MATCH `EXPECTED_LEX_NAMED=df0e8833…` and shim `7966f321…`. Hunt “named lex regenerated this bag”: **MISS.**

Bag `qse_role_lexicon.svh` is **three comment lines +** `` `include "qse_role_lexicon_semantic_16k.svh" ``. Hash `7966f321…`. xvlog `-i $bag` FIRST.

**Discriminator that runtime is not C0:** C0 59-word has **no** `boiler`. Live CLASS_fill_template query is `"boiler feeds header"` with `G_SUBJ=13 G_OBJ=14 G_REL=4` and **no** `ROLE_COLLAPSE` / `KEY_MISMATCH` / `FIRST_DIVERGENCE`. If C0 were the runtime table, extract could not bind boiler→13. Hunt “C0 lexicon file edited”: **MISS.** Hunt “silent C0 59-word runtime claim”: **MISS.** Hunt “named lex rewritten”: **MISS.**

### 6) INSTANTIATE keys / DUT vs nid keys / STREAM-02 clone (hunts 9, 16)

KEEP STREAM-02 DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…` mtime **11:43:39**. **Not compiled** this bag (xvlog/xelab/sdb ABSENT).

KEEP PAGE-SKIP DUT `a7ng_query_axi_sparse_page_skip.sv` SHA `dab15d76…` mtime **13:31:29**. **Not compiled.**

KEEP ctx keys `a7ng_query_role_keys_ctx.sv` SHA `124be808…` mtime **14:03:07**. Combinational rebind of frozen extract outputs. No nid port. Packing `{subj[7:0], ctx[3:0], rel[3:0]}` when `ctx_id!=0`, else pass-through frozen `{subj,rel}`.

KEEP ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` SHA `8255a798…` mtime **14:03:24**. Instantiates frozen extract → **keys_ctx** (not relbind) → frozen `a7ng_route_valid_gate`. Instantiates frozen `a7ng_sparse_dir_axi` AXI-idle. Own AXI master: `arlen=0`. At `S_IDLE` with `qse_valid_o && !issued`: **`k0_r <= k0_o`**. `CAND_CAP` at emit. k2/k3 not used to issue AR.

Hunt “STREAM-02 clone as DUT / 14f75db7 compiled”: **MISS.** Hunt “STREAM-02 edited”: **MISS** (hash + mtime). Hunt “ctx keys/DUT edited this bag”: **MISS** (mtime 14:03, this bag 17:22). Hunt “nid-derived keys”: **MISS** (RTL has no nid; independent `k_eq_nid=0` on all 16384 records). Hunt “PAGE-SKIP compiled / mixed”: **MISS.**

Host gold: `gold_ids(docs, pred)` = nids with `evidence==1` matching an SRO **predicate**, computed **before** the walker twin. `relevant_is_router_union=false` in GOLDEN. Hunt `relevant=router_union`: **MISS.**

### 7) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 17:50:58 2026**; exit **17:51:08**; PID **24652**; `$finish` at **7265 ns**.

Banner:

```text
C1_SEMANTIC_UNSEEN_SRO_16K_N=16384 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MEM_DEPTH=286514 N_SUBJECTS=127 N_RELS=8 PLANTED_N=8 UNSEEN_SRO=1 FILL_GRID=120,121,122 UNSEEN_NID=123
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
CLASS_unseen_sro gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=2 ovf=0 trunc=0 dirB=32 postB=32 discB=0 descB=0 incomp=0
EMIT_unseen_sro n=1
  CAND unseen_sro i=0 id=123 ev=1
UNBOUND_EMPTY_WALK gold_n=0 emit_n=0
CLASS_unbound_sro gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0 prec_ev1_undef=1 prec_all_x1000=-1 rec_x1000=-1 occ=121 ovf=1 trunc=0 dirB=32 postB=0 discB=0 descB=0 incomp=0
EMIT_unbound_sro n=0
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
EMIT_unrelated n=0
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS=1`; `FILL_TEMPLATE_HIT=1`; `UNSEEN_SRO_HIT=1`; `UNBOUND_EMPTY_WALK=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` in `xsim.log` = **0**; `FIRST_DIVERGENCE` = **0**; `UNBOUND_FILL_GRID_LEAK` = **0**; `incomp=1` = **0**.

**FACT:** `SEARCH_INCOMPLETE` is **ABSENT** on gold_n>=1 retrieve classes. Hunt swallowed-incomp / marker-only-PASS-with-incomp: **MISS this bag.**

**FACT:** CLASS_fill_template emit `{120,121,122}` tp=3 occ=121. CLASS_unseen_sro emit `{123}` tp=1 occ=2. CLASS_unbound_sro emit_n=0 (not `{120,121,122}`) occ=121. Conjunctive gate holds on raw. N banner = 16384. `PLANTED_N=8`. Hunt “N not actually 16384”: **MISS.** Hunt “silent drop to 256”: **MISS.**

query_gold (hashed before xvlog): `G_N=16384` `G_N_SUBJECTS=127` `G_N_RELS=8` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_MEM_DEPTH=286514` `G_N_WR=18561` `G_UNSEEN_NID=123` `G_FILL_GRID={120,121,122}` `G_PLANTED_N=8` `G_PLANTED_NIDS={123..130}` `G_UNSEEN_Q=1` `G_UNBOUND_Q=2`. `G_LEN = {19,26,20,16}` MATCH independent `len(query text)`. `G_SUBJ/G_REL/G_OBJ` = `{13,4,14}` / `{1,1,2}` / `{13,4,1}` / `{0,0,0}`. `G_K0 = {16'h0D04, 16'h0101, 16'h0D04, 16'h0000}` = `{3332, 257, 3332, 0}`. `G_K1 = {16'h0E04, 16'h0201, 16'h0104, 16'h0000}` = `{3588, 513, 260, 0}`. `G_OCC = {121,2,121,0}`. `G_NEMIT = {3,1,0,0}`. Unbound k0 **shares** fill-grid k0=3332; unbound k1=260 **differs**. Independent LSB-first decode of `G_BYTES`:

```text
q0 "boiler feeds header"           FILL_RE MATCH  (control)
q1 "chiller supplies condenser"    FILL_RE MATCH  (unseen SRO; not fill-ent)
q2 "boiler feeds chiller"          FILL_RE MATCH  (unbound combination)
q3 "payroll tax form"              FILL_RE MATCH  (3-token OOV empty-walk)
```

### 8) Independent corpus — nids 123–130 are OFF cartesian fill over {13..132}; unbound (13,4,1) is NOT indexed; k0-only would leak {120,121,122}

Authority = live `corpus.json` **records** (hash `6991adc7…`), **not** RESULTS.

```text
n records         = 16384 (nid 0..16383 contiguous)
evidence=1        = 16384
evidence=0        = 0
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
k_eq_nid          = 0
wrap 8-bit        = 0
clone_pump_supplies_chiller header = 0
ctx_id            = {0:16382, 3:1, 4:1}
```

Independent cartesian generator: `s,o ∈ {13..132}`, `r ∈ {1..8}`, skip `s==o`, skip reserved `(13,4,14)` → **114239** SROs. MATCH header.

**FACT: the index is a SAMPLE of that generator, not the full 114239 unique SRO.** Host fills nids 0–119 with one cartesian SRO per NEW entity, reserves 120–122, plants 123–130, then takes unused generator SROs until N. Independent: `fill` kind SRO-in-cart = **16373**. CLOSEOUT’s “114239 unique SRO generator” is the **generator size**, not corpus unique SRO. Honest if read as generator; illegal as “full cartesian mass indexed”.

Records whose SRO is **OUT** of that generator (independent):

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

**FACT: unbound SRO=(13,4,1) is not indexed.** Record count with `(subj,rel,obj)==(13,4,1)` = **0**. `(13,4,1) ∈ cart` = **False** (obj=1 is not in `{13..132}`). Independent gold_ids `evidence==1 ∧ SRO=(13,4,1)` = `[]`.

Fill-grid `(13,4,14)` is **reserved out of cartesian fill** and planted at nids 120/121/122 (same plants as SEMANTIC-16K / HELDOUT / UNSEEN-SRO N=256). That is the **control**, not the unseen fact.

Independent gold (evidence=1 ∧ SRO pred, **before** walker):

```text
fill_template  (13,4,14) = {120,121,122}
unseen_sro     (1,1,2)   = {123}
unbound_sro    (13,4,1)  = []
```

MATCH GOLDEN `relevant` and raw emit. Plants 124–130 are indexed evidence=1 but are **not** a query class this bag.

Independent exact-key postings (plain `{subj,rel}` / `{obj,rel}`):

```text
plain k0=3332 occ=121  first16=[120,121,122,487,488,489,490,491,492,493,494,495,496,497,498,499]
plain k1=3588 occ=18
plain AND fill 3332∩3588 = {120,121,122}          ← CLASS_fill_template

plain k0=257  occ=1  list=[123]
plain k1=513  occ=2  list=[123,125]               ← nid 125 shares obj/rel condenser/supplies
plain AND unseen 257∩513 = {123}                  ← CLASS_unseen_sro

plain k1=260  occ=0  list=[]
plain AND unbound 3332∩260 = {}                   ← CLASS_unbound_sro

k0-only 3332 would emit the 121 boiler-feeds-* nids
  FIRST THREE in nid order = {120,121,122}        ← WOULD LEAK fill-grid
```

**FACT:** two-pointer AND is **necessary** for the unbound empty walk. A k0-only walker on shared k0=3332 **would leak** fill-grid neighbors as the first three posting hits (CAND_CAP=16 would emit them). Live emit_n=0. Hunt k0-only cheat sold as AND: **MISS** (empty k1 posting; AND empty; leak FAIL path present and not taken).

Key arithmetic (independent):

```text
fill    k0 = 3332 = 0x0D04 = {subj=13, rel=4}   boiler feeds
fill    k1 = 3588 = 0x0E04 = {obj=14,  rel=4}   header
unseen  k0 =  257 = 0x0101 = {subj=1,  rel=1}   chiller supplies
unseen  k1 =  513 = 0x0201 = {obj=2,   rel=1}   condenser
unbound k0 = 3332 = 0x0D04 = {subj=13, rel=4}   SHARES fill k0  occ=121
unbound k1 =  260 = 0x0104 = {obj=1,   rel=4}   chiller + feeds  (empty posting)
```

k0 occ=121 = 3 fill-grid nids (plain-indexed even when ctx≠0) + 118 cartesian `boiler feeds *` with `* ∈ {13..132}\{13,14}`. MATCH `3+118=121`.

TB requires unseen keys **≠** fill keys (live: 257/513 vs 3332/3588) and unbound k0 **==** fill k0 with unbound k1 **≠** fill k1. FIRST_DIVERGENCE ABSENT.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`fill_template {120,121,122}` tp=3 occ=121 incomp=0; `UNSEEN_SRO_HIT` nid=123 emit `{123}` tp=1 occ=2 incomp=0; `UNBOUND_EMPTY_WALK` emit_n=0; unrelated empty-walk). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD, N=65536, Master ≥95%. Banner `NOT_CLAIMED=…N_65536,MASTER_95,ACCEPT_BOARD`. `TWELVE_ENTITY_CLONE=NO` MATCH independent (PSC=0). `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `UNBOUND_FILL_GRID_LEAK` ABSENT. `N_DROP=ABSENT` MATCH.

Implementer prose that bulk fill is cartesian `{13..132}` × 8 rels (114239 unique SRO **generator**), planted nids 123–130 use C0 HVAC ids outside NEW_SUBJ, unbound (13,4,1) is not indexed and shares fill-grid k0 occ=121: **HONEST vs independent membership + postings**, with the construction caveat that corpus unique cartesian SRO is **16373** (sample), not 114239 indexed. Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim as **claim**: **MISS.** Hunt 800k as **promotion**: **REJECT** (auditor, not implementer cheat). Hunt “N=16384 claimed as semantic mass / Master close”: **MISS as claim** (RESULTS Honesty + CLOSEOUT QUALITY_NOTE). Hunt “true NL closed”: **MISS as claim**.

CLOSEOUT MATCH raw: marker present, ctx keys `124be808…` instantiate, ctx DUT `8255a798…` instantiate, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `df0e8833…` copied mtime 14:49:07, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`, `SEARCH_INCOMPLETE=ABSENT`, gold 17:29:38 PRE before PASS xvlog 17:37:44. Independent tree claim `max mtime 10:52:29` MATCH live. KEEP UNSEEN-SRO N=256 CLOSEOUT 17:04:05 / HELDOUT 16:06:53 / SEMANTIC-16K 15:18:52 MATCH live.

Host `n_post` vs DUT `postB/16` residual: fill GOLDEN n_post=36 vs DUT postB=512→32; unbound GOLDEN n_post=31 vs DUT postB=0 (empty k1 ⇒ no post beats). Emit locked. P2, not emit FAIL. Unseen 2 vs postB=32→2 MATCH.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. N drop (silent 256 / wrong geometry) | **MISS.** Banner/gold/corpus `N=16384`; TB `N_DROP` if `G_N!=16384` not taken; `G_N_BUCKETS=65536` `MEM_DEPTH=286514`; xelab `32'd` truncation not 32768; `FIRST_DIVERGENCE` ABSENT. 4-query wall-clock ~8 s is not a drop. | Silent drop ⇒ FAIL. This bag hosted 16384. |
| 2. Only 1 retrieve of 8 as tautology | **HIT as quality / promotion bound. MISS as registered-unknown FAIL.** WO asked retrieve **one** planted nid — **met** (`UNSEEN_SRO_HIT` nid=123). Plants 124–130 are indexed evidence=1 and **never queried**. Unseen AND is occupancy-1 (`257∩513={123}`); prec=1000 is 1-id identity. k1 occ=2 is plant 125 sharing condenser/supplies, not a second retrieve class. | Illegal as Master ≥95% / “8-plant semantic mass”. Honest as scale-identity unknown. |
| 3. nids 123–130 SRO in cartesian fill over {13..132} | **MISS.** Independent: all 8 `sro ∉ cart`; subj and obj outside NEW_SUBJ. | Plant in fill generator ⇒ FAIL. |
| 4. Unbound (13,4,1) indexed / leak `{120,121,122}` | **MISS.** Indexed count=0; gold=[]; plain AND 3332∩260={}; raw emit_n=0; `UNBOUND_FILL_GRID_LEAK` ABSENT. **HIT as construction:** k1 occ=0 is a hard empty. k0-only **would** leak `{120,121,122}` as first three of 121. | Empty AND on shared k0 is the negative. Keep leak as FAIL. |
| 5. C1 800k / bounds / ACCEPT_BOARD / N=65536 started | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. No new 800k / N=65536 bag (historical U5 2026-09-05 only). | Never grant. Never freeze. Never auto-start 800k. |
| 6. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** `xsim.log` SEARCH_INCOMPLETE count=0; incomp=0 on retrieve classes; conjunct includes `incomp_retrieve==0` and `G_N==16384` and `G_PLANTED_N>=8`. | Keep miss as FAIL on later bags. |
| 7. C0 lexicon FILE edited / named lex rewritten | **MISS.** Live `38189974…` mtime 2026-09-05 20:51:03; named `df0e8833…` mtime 14:49:07 MATCH 16k copy byte-identical; host refuses rewrite. | Do not edit C0. Do not regenerate named lex. |
| 8. Silent bag lexicon shadow | **MISS as silent C0 claim.** Copied named law; PRE hashes named file; xvlog bag-first disclosed; C0 cannot tokenize `boiler` but live fill did. | Keep named-law discipline. |
| 9. STREAM-02 / ctx keys / ctx DUT edited or STREAM-02 compiled | **MISS.** `14f75db7…` mtime 11:43:39 sdb ABSENT; `124be808…` / `8255a798…` mtime 14:03, this bag 17:22. | Hash mismatch ⇒ FAIL, do not patch. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0. | Keep off. |
| 11. Gold after FAIL / after xvlog / after claimed 17:30 abort | **MISS as gold regen.** PRE 17:29:38; surviving xvlog 17:37:44; gold still 17:29:38; named lex still 14:49:07; TB/host/run_xsim still 17:29:21; no r0. 17:30 abort **not independently on disk** (work dir created 17:37:43). SHA256.txt restamp 17:37:43 MATCH live PRE. | Do not regenerate gold. |
| 12. KEEP bags mutated | **MISS.** UNSEEN-SRO N=256 GOLDEN **17:01:44** `9fce7fad…` CLOSEOUT **17:04:05**; HELDOUT GOLDEN **15:44:21** `3c1eda7d…` CLOSEOUT **16:06:53**; SEMANTIC-16K GOLDEN **14:49:09** `0e539d48…` CLOSEOUT **15:18:52**; CONTEXT-02 GOLDEN **14:12:02**; PAGE-SKIP 13:34:19; STREAM-02 11:43:45; DIR-FULL16 12:44:33; N4096-STREAM-02 12:10:22; N4096-INTERSECT 10:46:42; KEY-INTERSECT 10:16:50; AXI-BEAT max 11:11:09. | Leave KEEP on disk. |
| 13. RESULTS vs xsim / 800k claim | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. Banner `C1_800K=OPEN`. Identity-path prose MATCH independent membership. | Authority = raw FILL_TEMPLATE_HIT + UNSEEN_SRO_HIT + UNBOUND_EMPTY_WALK + independent postings. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt 33/33 + C0 FILE + STREAM-02 DUT + PAGE-SKIP DUT + ctx keys/DUT + named lex `df0e8833…`). | SHA256.txt 17:37:43 is the PASS-xvlog freeze. PRE 17:29:38 is the gold lock. |
| 15. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; this bag starts 17:22. | Keep that tree read-only. |
| 16. `relevant=router_union` / nid keys / k0-only leak | **MISS.** `gold_ids` = evidence=1 ∧ SRO pred before walker. GOLDEN `relevant_is_router_union=false`. `k_eq_nid=0`. k0-only counterfactual would leak; live AND empty. | Keep independent labels. |
| Unseen query is still `{ent}{rel}{ent}` FILL_RE | **HIT as quality.** All four queries MATCH FILL_RE. Unknown is **SRO identity vs fill generator at N=16384**, not held-out NL. Unseen facts are C0 HVAC triples, not novel prose. | Do not sell as NL synonym hold-out. |
| Cartesian “mass” is a 16373-SRO sample of a 114239 generator | **HIT as construction/quality, MISS as cheat.** Generator size disclosed; corpus unique SRO=16382. N=16384 hosted. | Not full-generator mass. Not 800k. |
| Fill-template control is reserved (13,4,14) not cartesian bulk | **HIT as construction, MISS as cheat.** Host skips reserved SRO from bulk fill then plants it at 120–122. Control still hits with occ=121. | Identity control, not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=16384 XSim (MEM_DEPTH TB-only). | Illegal as BOARD_PASS / 800k / DDR freeze. |
| Unbound k1 occ=0 is a hard empty | **HIT as construction/quality.** Negative is “not indexed”, which this is. Not a held-out combination that exists in a large index and must be missed. Same construction as N=256. | Next NL bag must not reuse hard-empty k1 as “unknown”. |
| Host n_post vs DUT postB (fill 36 vs 32; unbound 31 vs 0) | **HIT as residual.** DUT issues no post beats on empty k1. Emit empty MATCH. | Do not freeze DDR bytes. |

qstack-validation-adversary one-liner: **SEMANTIC-UNSEEN-SRO-16K-01 XSim is a real N=16384 host+instantiate lock on unpatched C0 extract (`cd7baf49…`) with a **copied** 187-word lexicon (`qse-v2-lex-semantic-16k-01`, named file `df0e8833…` mtime 14:49:07 **not rewritten**, bag-first xvlog, C0 FILE `38189974…` unedited and **not** runtime — C0 cannot tokenize `boiler` but live CLASS_fill_template did): frozen ctx keys `124be808…` and ctx DUT `8255a798…` instantiated not edited; STREAM-02 `14f75db7…` unedited and **not** compiled as DUT; independent corpus n=16384 contiguous, cartesian **generator** over FILL_ENT `{13..132}` × rel `{1..8}` skip s==o and reserved `(13,4,14)` = 114239 SRO of which **16373** are indexed as `fill`; 8 off-grid C0 HVAC plants at nids 123–130 are **OUT** of that generator (subj and obj ∉ NEW_SUBJ) and nid 123 retrieves (`UNSEEN_SRO_HIT` emit `{123}` k0 occ=1 k1 occ=2 incomp=0) while nids 124–130 are indexed **unqueried**; unbound `"boiler feeds chiller"` SRO=(13,4,1) is **not indexed** (0 records) and shares fill-grid k0=3332 (occ=121, k0-only first16 starts `{120,121,122,…}` so **would leak**) while k1=260 occ=0 so AND is empty (`UNBOUND_EMPTY_WALK` emit_n=0, `UNBOUND_FILL_GRID_LEAK` ABSENT); fill-template control still emits `{120,121,122}` (`FILL_TEMPLATE_HIT` tp=3 occ=121 incomp=0); leftover A09 off; poke_v=0; gold PRE 17:29:38 before surviving xvlog 17:37:44 (claimed 17:30 abort leftover ABSENT; gold not regenerated); KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified; independent tree ≤10:52:29; N actually 16384 (`N_BUCKETS=65536` `MEM_DEPTH=286514`); that is **1-of-8 SRO identity at N=16384 scale** on a cartesian-generator **sample**, **not** semantic mass, not Master ≥95%, not C1 800k, not ACCEPT_BOARD, and still an axi_mem_model / hard-empty k1 / C0-HVAC plant / FILL_RE rung.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / unseen `{123}` / unbound `[]`). Findings are **law-quality / promotion bounds / PLAN-shape residual**, not “patch frozen QSE” and not “fix TB packing”:

1. **N=16384 was actually hosted and was the registered scale.** `G_N=16384`; corpus 16384 contiguous; banner 16384; MEM_DEPTH 286514 TB-only; `N_BUCKETS=65536`; no `N_DROP`; no `FIRST_DIVERGENCE MEM`. Not a silent 256 drop. xelab ~13 min is the 65536-bucket elaborate, not a fail-hidden MEM.
2. **Fill-template control still hits at scale.** `"boiler feeds header"` FILL_RE MATCH; emit `{120,121,122}` tp=3 occ=121 incomp=0; independent plain AND `{120,121,122}`. Marker requires `fill_tp>0` and bit-identical fill emit. occ=121 is real boiler-feeds occupancy on the 120-entity generator sample, not the N=256 3-entity pad (occ=9).
3. **Eight planted nids 123–130 are off the cartesian fill generator; one retrieves.** Independent: all 8 SRO not in `{13..132}×{1..8}`; retrieve `{123}` k0 occ=1 incomp=0. Marker requires `unseen_tp>0` and nid 123 in emit and `G_PLANTED_N>=8`. Unseen keys 257/513 ≠ fill 3332/3588.
4. **Unbound SRO=(13,4,1) is not indexed and does not emit fill-grid.** Independent 0 records; gold=[]; AND 3332∩260={}; raw emit_n=0. k0-only counterfactual would leak `{120,121,122}` as first three of 121. Two-pointer AND is necessary. `UNBOUND_FILL_GRID_LEAK` path exists and was not taken.
5. **That is 1-of-8 identity at N=16384, not semantic mass.** N_SUBJECTS=127; unique corpus SRO=16382 of 114239 generator; unseen occupancy-1 AND; unbound k1 occupancy=0; remaining 7 plants unqueried. WO scale-identity unknown **met**. Mass / NL / 800k **not this bag**.
6. **Runtime lexicon is COPIED named 187-word.** C0 FILE unedited. Named file mtime 14:49:07 MATCH 16k byte-identical; host SHA-gates and does not rewrite. xvlog bag-first documented.
7. **Frozen dir AXI-idle is hash-gate geometry.** Retrieve ARs are the context DUT master. `N_BUCKETS=65536` is a parameter instantiate of unedited `09334e42…` (16-bit exact; ids used ≤132; no 12-bit alias this bag).
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for this XSim; illegal as C2 / production retrieval / 800k close.
9. **Emit-cap can set `q_incomplete_o`.** Harmless here (`incomp=0`). This TB’s PASS conjunct **does** include `incomp_retrieve==0`. Later bags must still FAIL gold_n>=1 + incomp.
10. **Unseen facts use C0 HVAC ids (chiller/condenser/supplies/…), not a novel entity set.** Honest vs “not in FILL_ENT generator”. Not a 12-entity × N clone (PSC=0; `pump supplies valve` not `pump supplies chiller`). Not NL.
11. **fail_r0 was not written** because the surviving session PASSed the gate. Gold hashed once before xvlog (17:29:38) and not rewritten after the claimed abort. Not FAIL_LOOP.
12. **PLAN bag 7 scale slice is “N=16384 non-grid SRO retrieves and unbound does not leak fill-grid” — closed as PASS_NARROW.** 800k / N=65536 / semantic mass / true NL / remaining 7 planted retrieve classes are **not** closed and **not** started by this audit.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start 800k / N=65536 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=16384 hosted, leftover off, poke_v=0, CAND_CAP=16<16384, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| INSTANTIATE keys (`124be808…`, not edited) | **PASS_NARROW** | mtime 14:03:07; this bag 17:22. Unbound/fill ctx=0 so frozen `{subj,rel}` pass-through. |
| INSTANTIATE DUT (`8255a798…`, not edited, not STREAM-02 file) | **PASS_NARROW** | STREAM-02 FSM copy already accepted on CONTEXT-02 / 16k / HELDOUT / UNSEEN-SRO N=256. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121 incomp=0 | **PASS_NARROW** | Cartesian control still hits at scale. Independent plain AND `{120,121,122}`. |
| UNSEEN_SRO_HIT tp=1 emit `{123}` incomp=0; SRO=(1,1,2) ∉ cart; 8 plants off-grid | **PASS_NARROW of scale-identity unknown** | Independent: nids 123–130 OUT of FILL_ENT fill. 1-of-8 retrieve. |
| UNBOUND_EMPTY_WALK emit_n=0; SRO=(13,4,1) not indexed; no `{120,121,122}` | **PASS_NARROW** | Independent 0 records; AND 3332∩260={}; k0-only would leak first. |
| Independent fill AND: plain k0=3332 ∩ k1=3588 = `{120,121,122}` | **PASS_NARROW** | Dual-index not required on ctx=0 fill (plain keys). occ_k0=121. |
| Independent unseen AND: plain k0=257 ∩ k1=513 = `{123}` | **PASS_NARROW** | Occupancy-1 plant; k1 occ=2 via nid 125 share. |
| STREAM-02 DUT freeze (`14f75db7…`, mtime 11:43:39, **not compiled**) | **PASS_NARROW** | KEEP. Not rewritten. Not DUT. |
| PAGE-SKIP DUT freeze (`dab15d76…`, mtime 13:31:29, **not compiled**) | **PASS_NARROW** | KEEP. Scheduler not mixed. |
| Ctx keys/DUT freeze (mtime 14:03, this bag 17:22) | **PASS_NARROW** | Instantiated, not edited. |
| Frozen dir FILE freeze (`09334e42…`, mtime 2026-09-05 19:31:03, not patched) | **PASS_NARROW** | AXI-idle instantiate. N_BUCKETS=65536 parameter. |
| Copied lexicon **runtime** = `df0e8833…` 187-word mtime 14:49:07; C0 FILE `38189974…` unedited NOT runtime | **PASS_NARROW** | Copied not rewritten. C0 cannot name boiler; live fill did. |
| KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified | **PASS_NARROW / UNMODIFIED** | N=256 GOLDEN 17:01:44; HELDOUT GOLDEN 15:44:21; 16k GOLDEN 14:49:09; named lex byte-identical. |
| Registered unknown (8 plants off fill **and** nid 123 retrieves **and** unbound not indexed **and** no fill-grid leak **and** fill control hits **and** N=16384 hosted **and** SEARCH_INCOMPLETE ABSENT) | **PASS_NARROW** | Raw FILL_TEMPLATE_HIT tp=3; UNSEEN_SRO_HIT nid=123; UNBOUND_EMPTY_WALK emit_n=0; PLANTED_N=8; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or mass. |
| 1-of-8 tautology / cartesian sample as mass / true NL | **HIT as quality bound, MISS as this-unknown FAIL** | WO scale-identity met. PLAN mass / NL not met. |
| nid keys / router_union / NOT_SELECTIVE relabel / 12-clone × N / N-drop / gold-after-FAIL | **MISS (not FAIL of this unknown)** | nid unused; gold is evidence∧SRO pred; N=16384 registered; PSC=0; gold before xvlog. |
| Marker-only PASS with incomp | **MISS this bag (not OVERCLAIM of the marker)** | incomp=0; SEARCH_INCOMPLETE ABSENT; conjunct includes `incomp_retrieve==0`. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Unseen 1000 is 1-id identity; fill 1000 is 3-id identity; cartesian sample; reduction not emitted; 7 plants unqueried. |
| C1 800k / N=65536 / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED / REJECT_PROMOTION** | 1-of-8 plant / hard-empty k1 / axi_mem_model / FILL_RE. This audit does not start next bags. PLAN bag 7 remainder OPEN. |
| Gold-after-FAIL / after claimed 17:30 abort | **PASS_NARROW** | PRE 17:29:38; surviving xvlog 17:37:44; gold 17:29:38 KEEP `dfa19dde…`; named lex `df0e8833…`; no r0; 17:30 leftover ABSENT. |
| KEEP UNSEEN-SRO N=256 + HELDOUT + SEMANTIC-16K + CONTEXT-02 + PAGE-SKIP + STREAM-02 + DIR-FULL16 + N4096-STREAM-02 + N4096-INTERSECT + KEY-INTERSECT + AXI-BEAT + C0 FILE hashes + intersect DUT + stream DUT + page-skip DUT + ctx keys + ctx DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1705Z / C0. UNSEEN-SRO N=256 GOLDEN **17:01:44**. HELDOUT GOLDEN **15:44:21**. SEMANTIC-16K GOLDEN **14:49:09**. STREAM-02 GOLDEN **11:43:45**. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=16384 unseen-SRO **scale-identity** on instantiate `qse-v2-intersect-context-02` + copied named lexicon `qse-v2-lex-semantic-16k-01`: C0 extract unpatched; runtime table is bag `qse_role_lexicon_semantic_16k.svh` `df0e8833…` 187-word **copied not rewritten** mtime 14:49:07; C0 FILE `38189974…` unedited and not runtime; xvlog `-i $bag` FIRST documented; CLASS_fill_template `{120,121,122}` `"boiler feeds header"` `FILL_TEMPLATE_HIT` tp=3 occ=121; CLASS_unseen_sro `{123}` `"chiller supplies condenser"` SRO=(1,1,2) **not** in cartesian fill over `{13..132}` `UNSEEN_SRO_HIT` tp=1; 8 plants nids 123–130 all off-grid; CLASS_unbound_sro emit_n=0 `"boiler feeds chiller"` SRO=(13,4,1) **not indexed**, shares k0=3332 occ=121, k1=260 empty, `UNBOUND_EMPTY_WALK`, no `{120,121,122}` leak; k0-only would leak; `SEARCH_INCOMPLETE` ABSENT; leftover off; poke_v=0; gold-before-xvlog; STREAM-02 `14f75db7…` unedited and not DUT; PAGE-SKIP `dab15d76…` unedited and not DUT; ctx keys `124be808…` / ctx DUT `8255a798…` unedited instantiate; dir file `09334e42…` unedited; KEEP UNSEEN-SRO N=256 / HELDOUT / SEMANTIC-16K unmodified; independent tree ≤10:52:29; RESULT=`PASS_THIS_GATE_ONLY` honest; N actually 16384; **not** 12-entity × N clone; gold is **not** router_union and **not** nid keys). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=65536, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS, “semantic mass / true NL hold-out closed”. **Not** FAIL_LOOP (hashes real, C0 files unpatched, named lex not rewritten, gold not rewritten, 800k not claimed, keys are not nid, STREAM-02 not compiled, PASS is honest, SEARCH_INCOMPLETE absent, N not dropped, lexicon copied, planted SROs off fill, unbound not indexed). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer did not claim 800k or mass; identity path disclosed; nid-123-in-fill hunt fails; 8-plant-in-fill hunt fails; unbound-leak hunt fails; N-drop hunt fails; KEEP unmodified). **Not** FAIL of the unseen-SRO scale-identity unknown.

**P1 for this unknown: none.** Parent next is **OPTIONAL** further PLAN bag 7 remainder (real NL / remaining planted retrieve classes). Do **not** auto-start 800k / N=65536. This audit does **not** start those bags. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-SEMANTIC-UNSEEN-SRO-01` / `ASTRA-C1-SEMANTIC-HELDOUT-01` / `ASTRA-C1-SEMANTIC-16K-01` / `ASTRA-C1-CONTEXT-02` / `ASTRA-C1-PAGE-SKIP-01` / `ASTRA-C1-STREAM-INTERSECT-02` / `ASTRA-C1-DIR-FULL16-01` / `ASTRA-C1-N4096-STREAM-02` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or postB. **Do not rewrite** named lexicon `df0e8833…`.

**P1 — none for this unknown** (independent FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=121; UNSEEN_SRO_HIT nid=123 SRO=(1,1,2) ∉ cartesian fill over `{13..132}`; 8 plants nids 123–130 all off-grid; UNBOUND_EMPTY_WALK emit_n=0 SRO=(13,4,1) not indexed; k0-only 3332 would leak fill-grid as first three of 121; SEARCH_INCOMPLETE ABSENT; N=16384 hosted; ctx keys/DUT not edited; STREAM-02 SHA MATCH and not compiled; C0 FILE unedited; named lexicon copied not rewritten; gold PRE before xvlog; KEEP UNSEEN-SRO N=256 / HELDOUT / 16k unmodified).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound, silent-patch C0, or auto-start 800k):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=16384 unseen-SRO **scale-identity** (eight planted non-grid triples exist; one retrieves; unbound combination does not leak fill-grid) on instantiate ctx keys/DUT. Authority = raw `FILL_TEMPLATE_HIT` / `UNSEEN_SRO_HIT nid=123` / `UNBOUND_EMPTY_WALK emit_n=0` / `CLASS_fill_template {120,121,122}` / `EMIT_unseen_sro {123}` / `SEARCH_INCOMPLETE` ABSENT + independent cartesian membership + exact-key postings + named lex `df0e8833…`. Do not silent-patch STREAM-02 / CONTEXT-02 / SEMANTIC-16K / HELDOUT / UNSEEN-SRO N=256 / C0.
2. **Do not sell this as semantic mass, true NL hold-out, Master ≥95%, or PLAN bag7 close.** N_SUBJECTS=127 is a 120-entity cartesian **sample** (16373 unique fill SRO of 114239 generator) plus 8 C0 HVAC plants; unseen is 1-id retrieve; unbound k1 occupancy=0; 7 plants unqueried. Next “semantic” bag that claims mass / NL must not be another FILL_RE pad with one queried triple.
3. **Parent MAY open OPTIONAL next:** further PLAN bag 7 remainder (real NL / held-out combinations that are not hard-empty k1 / retrieve classes for the remaining 7 plants). One unknown. **Not this audit. Do not start 800k / N=65536 from this close.** Independent PLAN bag 7 remainder remains **OPEN**.
4. **Do not auto-start C1 800k / N=65536 / BOARD_PASS.** 1-of-8 plant + axi_mem_model + hard-empty k1 + FILL_RE sample are the stop.
5. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64/4096 unused as FINAL; TB 16/65536 is not FINAL. Host n_post ≠ DUT postB on fill/unbound.
6. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `UNBOUND_EMPTY_WALK` / `UNBOUND_FILL_GRID_LEAK` FAIL; `FILL_TEMPLATE_HIT` / `UNSEEN_SRO_HIT` required; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; STREAM-02 / PAGE-SKIP / KEY-INTERSECT **not** compiled as DUT; frozen sparse not compiled; named lexicon copied not rewritten; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILs the bag; `incomp_retrieve==0` in the PASS conjunct; `G_N!=16384` FAILs as `N_DROP`; planted SRO in cartesian fill generator FAILs the bag.
7. Next bag should instantiate `.CAND_CAP(16)` and `.N_BUCKETS(...)` explicitly (do not rely on RTL defaults 64/4096). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak, not a silent patch of this PASS bag or of STREAM-02 / CONTEXT-02 / SEMANTIC-16K.
8. If a later law must bind synonyms that are not lexicon aliases, or walk combinations that exist in a large index without leaking fill-grid, that is a **new** named bag. Do not silent-patch `a7ng_query_role_keys_ctx.sv` or C0 extract. Do not rewrite `df0e8833…` in place.
9. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `final_promotion` stays REJECT until a human board.
10. KEEP bags including UNSEEN-SRO N=256 GOLDEN 17:01:44 (1-id identity), HELDOUT GOLDEN 15:44:21 (N=16384 query-surface wrap), SEMANTIC-16K GOLDEN 14:49:09 (formulaic grid `{120,121,122}`), CONTEXT-02 GOLDEN 14:12:02, PAGE-SKIP GOLDEN 13:34:19, STREAM-02 N=256 nid 254 at 20/22 stay on disk as evidence of prior process.
11. Optional: print DUT `n_post` vs host `n_post` on CLASS lines so the fill 36-vs-32 and unbound 31-vs-0 residuals are not rediscovered. Neither is a this-bag FAIL. Optional: keep leftover abort xvlog/xelab as `xsim_fail_r0.log` / `xelab_abort.log` so a 17:30-style claim is independently replayable.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=16384 unseen-SRO SCALE-IDENTITY
                         on qse-v2-intersect-context-02 instantiate
                         + copied named lexicon qse-v2-lex-semantic-16k-01;
                         N actually 16384 contiguous; G_N=16384; banner N=16384;
                         N_BUCKETS=65536; MEM_DEPTH=286514 TB-only;
                         FIRST_DIVERGENCE MEM ABSENT; N_DROP ABSENT;
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
                           mtime 14:49:07 MATCH SEMANTIC-16K copy BYTE-IDENTICAL; NOT rewritten;
                           xvlog -i $bag FIRST documented;
                           bag qse_role_lexicon.svh is include-name shim 7966f321…;
                           C0 cannot tokenize boiler; live CLASS_fill_template did;
                         FILL_TEMPLATE_HIT tp=3 emit={120,121,122} occ=121 incomp=0
                           text="boiler feeds header" FILL_RE MATCH
                           independent plain AND 3332∩3588={120,121,122};
                         UNSEEN_SRO_HIT tp=1 emit={123} incomp=0
                           text="chiller supplies condenser" SRO=(1,1,2)
                           NOT in cartesian fill over FILL_ENT={13..132};
                           independent plain AND 257∩513={123} k0 occ=1 k1 occ=2;
                         PLANTED_N=8 nids 123..130 all SRO ∉ cart; subj/obj ∉ NEW_SUBJ;
                           only nid 123 is a retrieve class;
                         UNBOUND_EMPTY_WALK gold_n=0 emit_n=0
                           text="boiler feeds chiller" SRO=(13,4,1) NOT indexed
                           (0 records); shares k0=3332 with fill-grid occ=121;
                           k1=260 occ=0; AND={};
                           k0-only 3332 first16 starts {120,121,122,…};
                           UNBOUND_FILL_GRID_LEAK ABSENT;
                         UNRELATED_EMPTY_WALK emit_n=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS; not swallowed);
                         leftover A09 off; poke_v=0; C0 FILE hashes MATCH;
                         gold dfa19dde… 17:29:38 PRE before surviving xvlog 17:37:44;
                           claimed abort 17:30 leftover ABSENT; gold not regenerated;
                         named lex df0e8833… 14:49:07 PRE (copied);
                         KEEP UNSEEN-SRO N=256 GOLDEN 17:01:44 9fce7fad… CLOSEOUT 17:04:05;
                         KEEP HELDOUT GOLDEN 15:44:21 3c1eda7d… CLOSEOUT 16:06:53;
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
                            not semantic mass / true NL hold-out;
                            cartesian-generator SAMPLE + 1-of-8 plant
                            + hard-empty k1 + axi_mem_model remain)
FAIL_LOOP        = NO
OVERCLAIM        = NO as this-unknown claim (implementer PASS_THIS_GATE_ONLY;
                   identity path disclosed; nid-123-in-fill hunt MISS;
                   8-plant-in-fill hunt MISS; unbound-leak hunt MISS;
                   N-drop hunt MISS; KEEP unmodified;
                   12-clone×N hunt MISS;
                   silent-C0 hunt MISS; named-lex rewrite hunt MISS;
                   gold≠router_union; 800k not claimed;
                   HIT as quality: 1-of-8 identity; cartesian sample
                   16373/114239; not semantic mass)
FAIL             = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = OPTIONAL further PLAN bag 7 remainder
                   (real NL / remaining 7 planted retrieve classes)
                   (do NOT auto-start C1 800k / N=65536;
                    this audit did NOT start them)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
PLAN_BAG7_SEMANTIC = UNSEEN_SRO_16K_SCALE_IDENTITY_PASS_THIS_GATE_ONLY
                     (remainder OPEN)
N_256            = KEEP UNSEEN-SRO-01 (1-id identity; not this bag)
N_16384          = THIS_BAG (scale-identity; cartesian sample; not mass)
N_65536          = NOT_STARTED
SEMANTIC_UNSEEN_SRO_16K_XSIM = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS PRESENT
                   PID 24652; 7265 ns; 17:50:58–17:51:08
                   xsim.log SHA256 cee6e63d48b79cb15c8de492517f84d58fa239cbe34ffb6fc5391db218a50f28
                   FILL_TEMPLATE_HIT tp=3 emit {120,121,122} occ=121 incomp=0
                   UNSEEN_SRO_HIT tp=1 emit {123} nid=123 occ=2 incomp=0
                   UNBOUND_EMPTY_WALK emit_n=0 occ=121
                   UNBOUND_FILL_GRID_LEAK ABSENT
                   PLANTED_N=8
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 17:29:38; named lex 14:49:07;
                                PRE MATCH live; no r0; PASS session;
                                claimed 17:30 abort leftover ABSENT;
                                xsim_work CreationTime 17:37:43
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
NID_KEYS         = MISS         (k_eq_nid=0)
ROUTER_UNION     = MISS         gold_ids = evidence=1 ∧ SRO pred before walker
K0_ONLY_LEAK     = MISS as cheat (AND empty); HIT as counterfactual
                   (k0=3332 first16 starts {120,121,122})
UNBOUND_INDEXED  = MISS         SRO=(13,4,1) record count=0
NID123_IN_CART   = MISS         SRO=(1,1,2) ∉ FILL_ENT cartesian
PLANTS_123_130_IN_CART = MISS   all 8 ∉ cart; subj/obj ∉ NEW_SUBJ
ONE_OF_EIGHT_TAUTOLOGY = HIT as quality (only nid 123 queried; prec=1000 is 1-id identity)
N16384_AS_MASS   = MISS as claim; HIT as quality (sample 16373/114239; FILL_RE 16384/16384)
NOT_SELECTIVE_RELABEL = N/A this bag (no wrong_context class)
TWELVE_ENTITY_CLONE = MISS as ×N clone (PSC=0); HIT as C0-HVAC plant ids 1..12
N_DROP           = MISS
SILENT_C0_RUNTIME = MISS
NAMED_LEX_REWRITE = MISS
FORMULAIC_GRID   = HIT as quality (16373 cartesian fill SRO of 114239 generator)
SEMANTIC_MASS    = NOT THIS CORPUS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
N_BUCKETS        = 65536 this bag
CTX3_COUNT       = 1 (nid 121 direct_glycol)
CTX4_COUNT       = 1 (nid 122 direct_steam)
FILL_RE_ALL_Q    = YES (identity unknown is SRO vs generator, not WH-wrap)
PARA_KEYS_EQ_FILL = N/A (no paraphrase class this bag)
UNSEEN_KEYS      = k0=257 k1=513  ≠ fill 3332/3588
UNBOUND_K0_SHARE = YES (3332 occ=121)
UNBOUND_K1       = 260 occ=0
K0_ONLY_3332_FIRST16 = {120,121,122,487,488,489,490,491,492,493,494,495,496,497,498,499}
PLAIN_AND_FILL   = {120,121,122}
PLAIN_AND_UNSEEN = {123}
PLAIN_AND_UNBOUND = {}
CARTESIAN_SRO_GENERATOR = 114239
CARTESIAN_SRO_INDEXED   = 16373
UNIQUE_SRO       = 16382
ENTITY_N_UNIQUE  = 127 subj (REJECT 800k as sample not mass)
N                = 16384
WRAP_8BIT        = 0 this bag
HOST_AND_FF      = YES (pack_plain / ctx_keys mask; law width, not this-bag cheat)
UNSEEN256_KEEP   = UNMODIFIED GOLDEN 17:01:44 9fce7fad371afbc3a0fe3173d3b7c3c154ce338f05e2374255ac51aa38f8bff2 CLOSEOUT 17:04:05
HELDOUT_KEEP     = UNMODIFIED GOLDEN 15:44:21 3c1eda7d1639ef1d90e06d8eb799cd7f2a382cd42de1a4dd4319d131d3bcfcb4 CLOSEOUT 16:06:53
SEM16K_KEEP      = UNMODIFIED GOLDEN 14:49:09 0e539d48be5862d006e5785cf3c74355d5540dff09bec5e8c738ac842ea83b99 CLOSEOUT 15:18:52
                   named lex df0e8833… 14:49:07 BYTE-IDENTICAL this bag copy
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
ABORT_1730_ON_DISK   = ABSENT (implementer-claimed; work dir created 17:37:43)
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=65536 / 800k in this audit. Independent PLAN bag 7 remainder (real NL / remaining planted retrieve classes) remains OPEN.
