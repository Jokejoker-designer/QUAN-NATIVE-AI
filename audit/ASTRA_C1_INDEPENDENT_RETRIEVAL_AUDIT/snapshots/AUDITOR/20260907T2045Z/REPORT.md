# ASTRA auditor REPORT — 20260907T2045Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only; do not start C2 / do not write V3.1 / do not edit KEEP bags)
BAG        = ASTRA-C1-SEMANTIC-800K-01
LAW        = qse-v2-relctx-synonym-01  INSTANTIATE (QSE_SYN_N=1; rtl not edited this bag)
           INSTANTIATE keys a7ng_query_role_keys_ctx.sv 124be808… (NOT edited)
           DUT INSTANTIATE wrap a7ng_query_axi_sparse_intersect_synonym.sv a84bbf7e…
             (frozen extract cd7baf49 + overlay e862208c + keys_ctx 124be808
              + STREAM-02 two-pointer copy inside wrap; STREAM-02 file not DUT)
           CTX DUT a7ng_query_axi_sparse_intersect_context.sv 8255a798…
             KEEP; NOT compiled as DUT; NOT edited
           PROC MEM bag a7ng_axi_mem_proc_800k.sv + gen_800k.svh
             C0 a7ng_axi_mem_model.sv NOT compiled (dense array forbidden)
LEXICON    = qse-v2-lex-semantic-800k-01 NEW named
           runtime = bag qse_role_lexicon_semantic_800k.svh 023a6f81… (mtime 20:41:44)
           include-name bag qse_role_lexicon.svh shim `include of named file
           C0 FILE rtl/.../qse_role_lexicon.svh 38189974… UNEDITED, NOT runtime
CORPUS     = procedural generator metadata SHA 33d9c387… (602 bytes; records_materialized=false)
           NOT a 16k record dump; NOT KEEP corpus 6991adc7
KEEP       = ASTRA-C1-SYNONYM-LAW-01 (must be unmodified; GOLDEN 19:49:47 SHA 587e6ac3…)
           + ASTRA-C1-SEMANTIC-NL-01 (must be unmodified; honest FAIL NOT_SELECTIVE_NL;
             GOLDEN 19:05:03 SHA 6fa2a93f… verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01 (must be unmodified; GOLDEN 18:19:54 verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 (must be unmodified; GOLDEN 17:29:38 verified)
           + ASTRA-C1-SEMANTIC-UNSEEN-SRO-01 (must be unmodified; GOLDEN 17:01:44 verified)
           + ASTRA-C1-SEMANTIC-HELDOUT-01 (must be unmodified; GOLDEN 15:44:21 verified)
           + ASTRA-C1-SEMANTIC-16K-01 (must be unmodified; GOLDEN 14:49:09 verified)
           + ASTRA-C1-CONTEXT-02 (must be unmodified; GOLDEN 14:12:02 verified)
           + ASTRA-C1-PAGE-SKIP-01 (must be unmodified; GOLDEN 13:34:19 verified)
           + ASTRA-C1-STREAM-INTERSECT-02 N=256 (must be unmodified; GOLDEN 11:43:45 verified)
           + ASTRA-02-U5-SCALE-SELECTIVITY-800K (historical qse-v1; cannot close C1;
             GOLDEN 2026-09-05 19:31:15; NOT compiled)
           + C0 RTL FILE hashes (extract/lexicon FILE/sparse/dir/gate; verified MATCH)
           + stream DUT a7ng_query_axi_sparse_stream_intersect.sv 14f75db7… (KEEP; NOT compiled as DUT)
           + page-skip DUT a7ng_query_axi_sparse_page_skip.sv dab15d76… (KEEP; NOT compiled as DUT)
           + ctx keys a7ng_query_role_keys_ctx.sv 124be808… (KEEP instantiate; NOT edited)
           + ctx DUT a7ng_query_axi_sparse_intersect_context.sv 8255a798… (KEEP; NOT compiled as DUT; NOT edited)
           + synonym overlay/table/wrap mtime 19:42:02 (SYNONYM-LAW; NOT edited this bag)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1955Z/REPORT.md
           ACCEPT_PARTIAL of 1-alias synonym law at N=16384; C1 800k was OPEN
           Independent tree D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-SEMANTIC-800K-01.md
EVIDENCE   = raw xsim.log C1_SEMANTIC_800K_N=800000 / FILL_TEMPLATE_HIT tp=3 /
             HIGH_ID_HIT nid=799999 / FROZEN_KEYS_VS_FILL keys_match=0 /
             SYN_KEYS_VS_FILL keys_match=1 / NL_GOLD_HIT tp=3 emit={120,121,122} /
             emit_has_131=0 / ASTRA_C1_SEMANTIC_800K_XSIM_PASS / UNRELATED_EMPTY_WALK /
             SEARCH_INCOMPLETE ABSENT / FIRST_DIVERGENCE ABSENT on PASS session
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FILE hashes
             + named lexicon 023a6f81… + synonym table 551655a1… bag==rtl
             + overlay e862208c… + wrap DUT a84bbf7e… + proc mem b2b06471… + gen 7f23cc43…
           + file LastWriteTime (gold PRE 20:41:44 vs SHA256 20:44:42 vs xvlog 20:44:43
             vs xelab 20:44:55 vs xsim 20:44:56–20:44:58 vs RESULTS 20:47:13;
             gold still 20:41:44 after fail_r0 20:43:43 and after PASS;
             gen_800k.svh 20:44:30 TB-pack only)
           + independent closed-form census of gen_800k.svh / host nids_of_sro:
             unique nids = 800000 contiguous 0..799999; nid 799999 only SRO (213,20,13);
             fill AND 3332∩3588 = {120,121,122}; sentinel AND = {799999} k0_occ=1 k1_occ=200
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb + work.rlx
           + leftover A09 off; poke_v=0; C0 dense mem not compiled; STREAM-02 not DUT
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = THIS BAG (XSim retrieve gate only; Master C1 NOT CLOSED)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
C2_PERSIST            = NOT STARTED (this audit does not start C2)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP SYNONYM-LAW / SEMANTIC-NL / UNSEEN-SRO / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 / U5, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start C2, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **N=800000 semantic retrieve** bag `ASTRA-C1-SEMANTIC-800K-01` after auditor `20260907T1955Z` ACCEPT_PARTIAL of the 1-alias synonym law at N=16384. Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` (`qse-v1`) **cannot** close this bag.

`results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-800K-01/`

Registered unknown (WO / PREREG, frozen before xvlog):

> N=**800000** records under current law stack (`qse-v2-relctx-synonym-01` overlay + ctx keys `124be808` + synonym DUT wrap). Fill-template control HIT `{120,121,122}`. High-id sentinel nid `799999` HIT. `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve = FAIL. A 16k clone with `N` printed 800000 is OVERCLAIM / FAIL. Sparse/on-demand procedural AXI mem is allowed only if 800k nids are addressable.

Query classes (PREREG, frozen before xvlog):

```text
fill_template     "boiler feeds header"                       k0=3332 k1=3588  gold={120,121,122}
nl_synonym        "what does the boiler supply to the header"  frozen keys_match=0; syn keys_match=1
high_id_sentinel  "hatchway splits boiler"                     gold={799999}
unrelated         "payroll tax form"                           empty walk
```

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` present. **N actually 800000** (not a 16k clone labeled 800k). `FILL_TEMPLATE_HIT` with tp=3 emit `{120,121,122}`. `HIGH_ID_HIT nid=799999`. `FROZEN_KEYS_VS_FILL keys_match=0`. `SYN_KEYS_VS_FILL keys_match=1`. `NL_GOLD_HIT` tp=3 on fill-meaning gold `{120,121,122}`. `emit_has_131=0`. `SEARCH_INCOMPLETE` **ABSENT** on retrieve classes.
2. Procedural generator hosts 800000 **distinct** nids `0..799999` including sentinel 799999. Independent sample of nid 799999 in the generator. Not U5. Not dense 800k array.
3. Named lexicon `023a6f81…` is the runtime table. C0 FILE `38189974…` unedited and **not** runtime. C0 extract `cd7baf49…` unedited. Frozen STREAM-02 `14f75db7…` **not** compiled as DUT; **not** edited. Ctx keys `124be808…` **not** edited. Ctx DUT `8255a798…` **not** compiled as DUT; **not** edited. PAGE-SKIP `dab15d76…` **not** compiled. Synonym overlay/wrap instantiated, not edited this bag. KEEP bags unmodified.
4. Leftover A09 off; `poke_v=0`; gold hashed before first xvlog and **not** regenerated after fail_r0. fail_r0 TB packing only. Independent tree not written by this audit.
5. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS. Do **not** start C2. Do **not** silent-patch C0. Do **not** sell cartesian formulaic + MIG-less AXI plant as Master C1 CLOSED.

This bag **cannot** freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`, cannot close general NL, cannot start C2.

Hunt (dispatch, none dropped):

1. N drop / 16k clone labeled 800k
2. U5 bag used as this close
3. C1 800k claimed CLOSED / BOARD_PASS / CAND_CAP_FINAL
4. C0 extract / C0 lexicon FILE patched
5. Independent audit tree written by this Grok process / Grok implementer
6. Gold relabeled `{131}`
7. Dense 800k array hidden / C0 `axi_mem_model` compiled
8. High-id retrieve is prefix luck / 12-bit rel alias / N_BUCKETS collision theatre
9. Gold regenerated after fail_r0 (not TB pack)
10. leftover A09 compiled; `poke_v=1`
11. STREAM-02 `14f75db7…` compiled as DUT; ctx DUT `8255a798…` compiled as DUT
12. SEARCH_INCOMPLETE hidden on gold_n≥1 / marker-only PASS
13. RESULTS.md vs raw `xsim.log`
14. Hash theatre (SHA256.txt vs live Get-FileHash vs PRE)
15. `relevant=router_union` / nid-derived keys
16. Cartesian formulaic / MIG-less AXI plant sold as Master close

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / BOARD_PASS / C2 persist. This is the **800k addressable XSim retrieve** unknown only.

If the measurement is an honest HIT of that unknown **and N is real**: **PASS_NARROW** + **ACCEPT_PARTIAL this 800k XSim retrieve only**. **REJECT_PROMOTION** of BOARD_PASS / `CAND_CAP_FINAL` / Master C1 CLOSED if still cartesian formulaic / 12-bit alias / MIG-less AXI plant. Never `ACCEPT_BOARD`. Do **not** start C2 from this audit.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. 800k bag is untracked (`??`). Synonym overlay/wrap/table remain untracked with **unchanged** hashes from SYNONYM-LAW-01 (mtime still **19:42:02**). Ctx keys untracked hash `124be808…` mtime **14:03:07**. Ctx DUT untracked hash `8255a798…` mtime **14:03:24**. STREAM-02 untracked hash `14f75db7…` mtime **11:43:39**. Extract `??` hash MATCH `cd7baf49…` mtime **2026-09-05 19:48:18**. C0 lexicon FILE `??` hash MATCH `38189974…` mtime **2026-09-05 20:51:03**. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` mtime **2026-09-05 19:31:03** — **not** a silent patch in this bag. `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T20:50:00+07:00` (parent-owned; auditor did not write it) `acceptance=PENDING_AUDITOR_C1_SEMANTIC_800K` `unblocked_item=ASTRA-C1-SEMANTIC-800K-01` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=RESULTS_READY_PENDING_AUDITOR` `c2_persist=BLOCKED_UNTIL_C1_800K_AUDITOR` `final_promotion=REJECT` `independent_audit_write=false` `board_pass=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), SEMANTIC-800K bag:

```text
19:42:02.355  qse_relctx_synonym_01.svh          ← COPIED from SYNONYM-LAW; NOT rewritten
20:33:00.240  ACK.json
20:33:53.095  PREREG.md
20:36:29.252  host_astra_c1_semantic_800k.py
20:37:33.687  a7ng_axi_mem_proc_800k.sv
20:39:45.306  tb_astra_c1_semantic_800k.sv
20:41:39.023  run_xsim.ps1
20:41:44.342  qse_role_lexicon_semantic_800k.svh ← NEW named 280-word lex; PRE-locked
20:41:44.342  qse_role_lexicon.svh               ← include-name shim
20:41:44.346  query_gold.svh                     ← gold lock
20:41:44.347  corpus.json GOLDEN.json            ← gold lock
20:42:01.101  GOLD_HASH_PRE_XVLOG.txt            ← BEFORE first xvlog
20:43:43.545  xsim_fail_r0.log / xsim_58088.backup.log
              FIRST_DIVERGENCE CANDIDATE_ID_MISMATCH q=0 emit 0 exp 3
20:44:30.076  gen_800k.svh                       ← TB pack-width fix AFTER fail_r0; gold NOT touched
20:44:42.818  SHA256.txt                         ← PASS-session freeze immediately before xvlog
20:44:43.914  xvlog.log
20:44:55.785  xelab.log
20:44:58.703  xsim.log                           ← PASS session PID 60708
20:47:13.341  RESULTS.md CLOSEOUT.md
```

Synonym overlay/table/wrap LastWriteTime **19:42:02** — **not newer** than SYNONYM-LAW. This bag starts 20:33. Overlay/DUT were **not** rewritten for 800k.

Ctx keys **14:03:07** / ctx DUT **14:03:24** / STREAM-02 **11:43:39** / PAGE-SKIP **13:31:29** / frozen dir **2026-09-05 19:31:03** / C0 lexicon FILE **2026-09-05 20:51:03** / extract **2026-09-05 19:48:18** / leftover A09 **2026-09-06 18:51:11** / C0 mem model **2026-09-05 18:58:22** / `role_lexicon.py` **2026-09-05 20:49:59**. None rewritten this bag.

Gold files still **20:41:44** after fail_r0 **20:43:43** and after PASS xsim **20:44:58**. Named lex still 20:41:44. PRE 20:42:01 is **before** first xvlog (fail_r0 session ~20:43) and before PASS xvlog 20:44:43.

`xsim.log` SHA256 `7d0a52ac3a4c19ef8f3990b16294b52cc8d518a20f177058bd80954d6bc394d5` MATCH RESULTS `XSIM_SHA`.

No new C2 bag. No `ASTRA-C1-N65536-SCALE-01` / `ASTRA-C1-N262144-SCALE-01` dirs. Historical U5 mtime **2026-09-05**, not this bag.

### 2) Live hashes vs C0 FILE / SHA256.txt / PRE / KEEP DUT / named lex / proc mem

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  rtl/.../qse_role_lexicon.svh        (C0 FILE MATCH; mtime 2026-09-05 20:51:03)
                                                                 **NOT the compiled runtime table this bag**
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; NOT compiled as DUT)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (KEEP; NOT compiled)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEEP; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv
                                                                  (STREAM-02 MATCH; mtime 11:43:39; NOT compiled)
dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817  a7ng_query_axi_sparse_page_skip.sv
                                                                  (PAGE-SKIP MATCH; mtime 13:31:29; NOT compiled)
124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1  a7ng_query_role_keys_ctx.sv
                                                                  (CONTEXT-02 MATCH instantiate; mtime 14:03:07; NOT edited)
8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989  a7ng_query_axi_sparse_intersect_context.sv
                                                                  (CONTEXT-02 MATCH; mtime 14:03:24; NOT compiled as DUT)
551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd  rtl qse_relctx_synonym_01.svh
                                                                  (QSE_SYN_N=1; mtime 19:42:02; bag copy IDENTICAL)
e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922  a7ng_query_role_relctx_synonym.sv
                                                                  (mtime 19:42:02; NOT edited this bag)
a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8  a7ng_query_axi_sparse_intersect_synonym.sv
                                                                  (mtime 19:42:02; instantiate as DUT; NOT edited)
023a6f810b7d2dbb01adf66398cf5afc791ce0e054fd76d463c95400ce4c2448  qse_role_lexicon_semantic_800k.svh
                                                                  **this IS the compiled runtime table; NEW 280-word; mtime 20:41:44**
a49164247d5e546d350fa7f54ee3eef09865a6216746f33620d842a07847dfd7  bag qse_role_lexicon.svh (shim)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (NOT compiled)
7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6  a7ng_pkg.sv
40df08bb58e7eb6e1cc0f0a87b4d67564e8ea602cace166c67eed7d088d8007c  a7ng_axi_mem_model.sv              (NOT compiled)
b2b06471626f155aea1d880a27b54821f75126d2603bebb11c16f4b9822a6084  a7ng_axi_mem_proc_800k.sv
7f23cc435ad5cd47337253c297e0705b3300657e71ec0f39c0d8a63130b08670  gen_800k.svh                      (POST fail_r0 pack fix)
aea0b387a244eeed61f1b55779d5001c5524fd51c53df074b6407b64653b974d  tb_astra_c1_semantic_800k.sv
acdbc3797ac7746c8a98cf5357750d0875dd48c74d747b7788b4b82f4b28209a  GOLDEN.json
c7fe9acd73af8d5affd47c5c7e18b32d448b0449c8ed3186d4294124e505fcd1  query_gold.svh
33d9c387825f6cca332fe75b1dbd43313092810beb136c039b4d7b4cdf38aa3f  corpus.json
7d0a52ac3a4c19ef8f3990b16294b52cc8d518a20f177058bd80954d6bc394d5  xsim.log (PASS)
d93396c4ecc55c82d6300951daab3239776a50e5a5abf7e9017b7132e88e5832  xsim_fail_r0.log
```

C0 extract / lexicon FILE MATCH prior T1955Z / C0. STREAM-02 MATCH `14f75db7…`. Ctx keys MATCH `124be808…`. Ctx DUT MATCH `8255a798…`. Synonym table bag == rtl `551655a1…`. Wrap DUT MATCH `a84bbf7e…` mtime 19:42 (not this bag).

`GOLD_HASH_PRE_XVLOG.txt` mtime **20:42:01.101** vs live gold+named-lex+corpus+syn-table (all MATCH):

```text
acdbc3797ac7746c8a98cf5357750d0875dd48c74d747b7788b4b82f4b28209a  GOLDEN.json
c7fe9acd73af8d5affd47c5c7e18b32d448b0449c8ed3186d4294124e505fcd1  query_gold.svh
33d9c387825f6cca332fe75b1dbd43313092810beb136c039b4d7b4cdf38aa3f  corpus.json
023a6f810b7d2dbb01adf66398cf5afc791ce0e054fd76d463c95400ce4c2448  qse_role_lexicon_semantic_800k.svh
551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd  qse_relctx_synonym_01.svh
```

Gold hashed **before** first xvlog. Gold files were **not** rewritten after fail_r0 or after PASS (still 20:41:44). SHA256.txt freeze stamp `2026-09-07T20:44:42.7533261+07:00` is immediately before PASS xvlog. `gen_800k.svh` is **not** in PRE (allowed: TB pack after fail_r0). Live gen hash MATCH SHA256.txt `7f23cc43…`.

SHA256.txt listed paths vs live: C0 five FILE hashes, relbind, KEEP intersect, STREAM-02 `14f75db7…`, PAGE-SKIP `dab15d76…`, ctx keys `124be808…`, ctx DUT `8255a798…`, named lex `023a6f81…`, bag shim, synonym table/overlay/wrap, proc mem, gen, pkg, TB, gold triple + corpus + syn-table: **MATCH**. No invented hash.

Hunt gold-after-fail: **MISS as gold regen.** fail_r0 is dir-pack (see §4). Gold PRE lock still holds.

### 3) KEEP bags unmodified / U5 not this close

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs this bag window 20:33+ |
|---|---|---|---|
| SYNONYM-LAW-01 (KEEP) | `587e6ac3841105f1…` **19:49:47** | CLOSEOUT **20:05:22** | **UNMODIFIED** |
| SEMANTIC-NL-01 (KEEP FAIL) | `6fa2a93f15a32b21…` **19:05:03** | CLOSEOUT **19:20:19** | **UNMODIFIED** |
| UNSEEN-SRO-16K-R2-01 | `be1eb641931e7666…` **18:19:54** | CLOSEOUT **18:34:48** | **UNMODIFIED** |
| UNSEEN-SRO-16K-01 | `dfa19dde41e2566d…` **17:29:38** | CLOSEOUT **17:52:43** | **UNMODIFIED** |
| UNSEEN-SRO N=256 | `9fce7fad371afbc3…` **17:01:44** | CLOSEOUT **17:04:05** | **UNMODIFIED** |
| HELDOUT | `3c1eda7d1639ef1d…` **15:44:21** | CLOSEOUT **16:06:53** | **UNMODIFIED** |
| SEMANTIC-16K | `0e539d48be5862d0…` **14:49:09** | CLOSEOUT **15:18:52** | **UNMODIFIED** |
| CONTEXT-02 | `8fc931f5ac07a72f…` **14:12:02** | CLOSEOUT **14:13:59** | **UNMODIFIED** |
| PAGE-SKIP | `86b536fb6ce46d7b…` **13:34:19** | CLOSEOUT **13:39:47** | **UNMODIFIED** |
| STREAM-02 N=256 | `05c6e087e567146f…` **11:43:45** | CLOSEOUT **11:45:37** | **UNMODIFIED** |
| U5 SCALE-SELECTIVITY-800K | `02c880547c81393f…` **2026-09-05 19:31:15** | MANIFEST **19:33:04** | **UNMODIFIED; not compiled; cannot close C1** |

Hunt “U5 used as this close”: **MISS.** U5 is `qse-v1`, not on xvlog list, mtime 2026-09-05. This bag’s DUT is synonym wrap `a84bbf7e…` + proc mem.

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: nfiles=138. Cursor-owned tree **was updated this window** (snapshots of this bag GOLDEN/PRE/SHA256/xsim/RESULTS 20:41–20:47; `c1_800k_close_gate.json` 20:51; `EVIDENCE_C1_800K.md` 20:53; scripts `snapshot_evidence.py` / `assert_scale_bag.py` / `c1_800k_close_gate.py`). Close-gate JSON `c1_close=NO` `c2_may_start=NO` blocking=`LADDER_65536_BAG`, `LADDER_262144_BAG`, `REDUCTION_METRIC_EMITTED`. This **Grok auditor did not write that tree**. Grok implementer ACK/CLOSEOUT claim they did not write it; snapshots have identical timestamps to bag files (copy). Hunt “Grok implementer wrote independent tree as a silent C1 CLOSED”: **MISS as CLOSED claim** (`C1_CLOSE=NO`). Hunt “tree unmodified since 10:52:29”: **HIT as Cursor update** — process note, not this-unknown FAIL. Keep that tree read-only from Grok.

### 4) Compile list / leftover A09 / poke_v / STREAM-02 not DUT / ctx DUT not DUT / fail_r0 pack

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_relctx_synonym.sv
a7ng_query_role_keys_ctx.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_proc_800k.sv          ← bag procedural slave; NOT C0 mem model
a7ng_query_axi_sparse_intersect_synonym.sv
tb_astra_c1_semantic_800k.sv
```

`xelab.log` compiled the same modules. Truncation `N_BUCKETS=32...` is Vivado `32'd65536` display, **not** a drop to 32768: `G_N_BUCKETS=65536`; banner `N_BUCKETS=65536`; TB diverges `DIR_WIDTH` if `G_N_BUCKETS != 65536`; `FIRST_DIVERGENCE` ABSENT on PASS.

Work `*.sdb`: extract, **relctx_synonym**, **keys_ctx**, gate, dir, **axi_mem_proc_800k**, **intersect_synonym**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_axi_mem_model`, `a7ng_query_axi_sparse_stream_intersect`, `a7ng_query_axi_sparse_page_skip`, `a7ng_query_axi_sparse_intersect_context` (8255a798 NOT compiled as DUT), `a7ng_query_axi_sparse.sv` as DUT.

`work.rlx` include_dirs start with **bag** then control then C0 query. Extract include: bag `qse_role_lexicon.svh` → named `qse_role_lexicon_semantic_800k.svh`. Overlay include: bag `qse_relctx_synonym_01.svh`. Proc mem include: bag `query_gold.svh` + `gen_800k.svh`. `work.rlx` unix mtime on gold `1788788504` = 20:41:44 +07 MATCH PRE. gen_800k `1788788670` = 20:44:30 +07 MATCH pack-fix stamp. extract `1788612498` = 2026-09-05 19:48:18. keys_ctx `1788764587` = 14:03:07. synonym rtl `1788784922` = 19:42:02.

TB holds `poke_v=0` (initial assign; never `poke_v <= 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0`. Raw banner `POKE_V=0`. leftover A09 **off**. `G_PROC_MEM != 1` diverges `MEM` “dense_800k_array_forbidden”. `G_N != 800000` diverges `N_DROP`. `CAND_CAP >= G_N` diverges `SELECTIVITY_TAUTOLOGY` (16<800000).

PASS marker conjunct (TB line 536): `fail==0 && unrelated_empty && (fill_tp > 0) && fill_ids_ok && (keys_match == 0) && keys_match_syn && nl_hit && (nl_tp >= 3) && (emit_has_131 == 0) && high_hit && (incomp_retrieve == 0) && (G_N == 800000)`. Gold miss increments `fail` even if `q_incomp`. `incomp && nrel>=1` sets `incomp_retrieve=1` which **blocks the marker**.

fail_r0 (PID 58088, 20:43:41–20:43:43, `$finish` 1115 ns):

```text
C1_SEMANTIC_800K_N=800000 ... SEN_NID=799999
FIRST_DIVERGENCE CANDIDATE_ID_MISMATCH q=0 fill_template emit 0 exp 3
```

Walker saw occupancy 0 because directory pack was not 128-bit (DUT unpacks `hbase[27:0]`, `hcnt[47:32]`, `ovf[48]`, `obase[107:80]`, `ocnt[123:108]`, epoch `[79:64]`). Fix was **TB `gen_800k.svh` only** (mtime 20:44:30). Gold files still 20:41:44 MATCH PRE. Hunt “gold regen after FAIL”: **MISS.** Hunt “fail_r0 hidden”: **MISS** (file preserved; RESULTS discloses FAIL_R0 PRESENT).

`xsim.mem` length **24312** bytes — not a dense 800k×16B array (~12.8 MiB). Proc mem module has **no** `mem[]` array; `g_rdata_of(addr)` is closed-form. Hunt dense array hidden: **MISS.**

xvlog `-i $bag -i $incq -i $incc`. Bag **FIRST**. Documented named 800k lexicon, **not** a silent C0 59-word claim.

### 5) PRIMARY HUNT — is N actually 800000, or a 16k clone labeled 800k?

query_gold (hashed before xvlog): `G_N=800000` `G_N_SUBJECTS=201` `G_N_RELS=20` `G_N_STREAM=799996` `G_FILL_CIDX=600` `G_SENT_CIDX=803800` `G_SEN_S=213` `G_SEN_R=20` `G_SEN_O=13` `G_SEN_NID=20'd799999` `G_N_BUCKETS=65536` `G_CAND_CAP=16` `G_PROC_MEM=1` `G_N_WR=0` (no write array). `ID_W=20` in TB; DUT default `ID_W=20` (799999 fits; 16-bit would wrap).

Independent closed-form port of `gen_800k.svh` / host `nids_of_sro` (this process; not RESULTS):

```text
cartesian slots          = 201 * 20 * 200 = 804000
unique nids              = 800000
min/max                  = 0 / 799999
missing in 0..799999     = 0
nids >= 16384            = 783616     ← NOT a 16k wrap
dropped SROs             = 4002       ← N_STREAM cap (truncated cube)
multi SRO (fill plant)   = 1          ← (13,4,14) → {120,121,122}
nid 799999 SRO           = ONLY (213, 20, 13)   "hatchway splits boiler"
nid 0 SRO                = (13, 1, 14)          "boiler supplies header"  (was 16k nid 131)
nid 131 SRO              = (13, 1, 142)         NOT fill-meaning
nid 799998 SRO           = (212, 20, 209)       in-stream high cartesian
fill AND 3332∩3588       = {120,121,122}        k0_occ=202 k1_occ=201
frozen AND 3329∩3585     = {0}                  k0_occ=200 k1_occ=199
sentinel AND 54548∩3348  = {799999}             k0_occ=1   k1_occ=200
pack_plain               MATCH 3332/3588/3329/3585/54548/3348
12-bit ctx-fold alias    pack_ctx(213,20,0) = 54532 ≠ 54548
```

**FACT: N=800000 unique nids 0..799999 are generated. Not a 16k clone labeled 800k.** Hunt N_DROP / 16k clone: **MISS.**

**FACT: the cube is truncated.** 804000 cartesian SROs minus fill/sent specials minus `N_STREAM=799996` leaves **4002 SROs unindexed** (mostly subject 213 / high cidx). Sentinel `(213,20,13)` is **special-cased** to nid 799999; other hatchway objects on rel 20 are dropped, so **k0 occupancy of the sentinel key is 1**. GOLDEN occupancies `[1, 200]` MATCH independent. xsim `CLASS_high_id_sentinel occ=200` is `G_OCC = max(occupancies) = 200` (k1), not k0.

**FACT: HIGH_ID_HIT is a planted last-nid with k0 occ=1, not a random probe of a complete 804k cube and not CAND_CAP prefix luck among a 200∩200 AND.** Two-pointer AND of `{799999}` ∩ 200-list = `{799999}` deterministically. DUT `postB=816` = 51 beats = `nbeats(1)+nbeats(200)` MATCH GOLDEN `n_post=51`. That **does** prove 20-bit nid 799999 is returned from the procedural index. It does **not** prove every dropped hatchway SRO is retrievable. Quality / promotion bound, not this-unknown FAIL: the registered unknown **named** sentinel 799999.

Fill-template AND `{120,121,122}` MATCH raw emit. Fill k1 occ=201 because `(213,4,14)` is in the truncated tail. GOLDEN `[202, 201]` MATCH. xsim `occ=202` = max.

### 6) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 20:44:56 2026**; exit **20:44:58**; PID **60708**; `$finish` at **18825 ns**. Wall ~2 s is consistent with procedural on-demand mem (no 800k array fill) + 4 short AND walks, **not** evidence of N drop.

Banner:

```text
C1_SEMANTIC_800K_N=800000 N_BUCKETS=65536 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-relctx-synonym-01 CTX=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN PROC_MEM=1 N_ADDRESSABLE=800000 N_SUBJECTS=201 N_RELS=20 FILL_GRID=120,121,122 FILL_K0=3332 FILL_K1=3588 SEN_NID=799999
```

Named lines (verbatim authority):

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=202 ovf=1 trunc=0 dirB=32 postB=832 discB=0 descB=0 incomp=0
EMIT_fill_template n=3
  CAND fill_template i=0 id=120 ev=0
  CAND fill_template i=1 id=121 ev=0
  CAND fill_template i=2 id=122 ev=0
FROZEN_KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0 law=qse-v2-role-00
SYN_KEYS_VS_FILL class=nl_synonym k0=3332 k1=3588 vs_fill_template k0=3332 k1=3588 keys_match=1 law=qse-v2-relctx-synonym-01 syn_hit=1
NL_GOLD_HIT tp=3 emit_n=3 gold_n=3 keys_match_frozen=0 keys_match_syn=1
CLASS_nl_synonym gold_n=3 emit_n=3 tp=3 ... occ=202 ... incomp=0
EMIT_nl_synonym n=3
  CAND nl_synonym i=0 id=120 ev=0
  CAND nl_synonym i=1 id=121 ev=0
  CAND nl_synonym i=2 id=122 ev=0
HIGH_ID_HIT nid=799999 emit_n=1 tp=1
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 ... occ=200 ... postB=816 incomp=0
EMIT_high_id_sentinel n=1
  CAND high_id_sentinel i=0 id=799999 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
N800K_SUMMARY fill_tp=3 nl_hit=1 high_hit=1 emit_has_131=0 incomp_retrieve=0 fail=0 G_N=800000
ASTRA_C1_SEMANTIC_800K_XSIM_PASS
NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD
BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN
REDUCTION_X1000=NOT_EMITTED
```

Counts this process:

```text
ASTRA_C1_SEMANTIC_800K_XSIM_PASS     = 1
ASTRA_C1_SEMANTIC_800K_XSIM_NO_MARKER= 0
FILL_TEMPLATE_HIT                    = 1
HIGH_ID_HIT                          = 1
NL_GOLD_HIT                          = 1
FAIL <space>                         = 0
SEARCH_INCOMPLETE                    = 0
FIRST_DIVERGENCE                     = 0   (PASS session; fail_r0 had 1)
C1_SEMANTIC_800K_N=800000            = 1
POKE_V=0                             = 1
emit_has_131=0                       = 1
BOARD_PASS=NOT_CLAIMED               = 1
```

Independent LSB-first `G_BYTES` decode MATCH PREREG / GOLDEN / banner:

```text
q0 "boiler feeds header"                       nz=19
q1 "what does the boiler supply to the header" nz=41
q2 "hatchway splits boiler"                    nz=22
q3 "payroll tax form"                          nz=16
```

`FIRST_DIVERGENCE` ABSENT on PASS ⇒ TB-shadow extract matched frozen gold keys **and** DUT wrap matched synonym/high-id gold keys (`G_K0[high]=16'hD514=54548`). Hunt 12-bit alias this bag: **MISS** (ctx=0 pass-through; 12-bit fold of rel=20 would be 54532; DUT would KEY_MISMATCH). Standing bound: `keys_ctx` still folds `{subj[7:0], ctx[3:0], rel[3:0]}` when ctx≠0, so rel 20 aliases to rel 4 under ctx fold. Not exercised here.

**FACT:** scoring uses `G_RELEVANT` id match, not `ev_of`. `ev=0` on nids 120–122 vs `ev=1` on 799999 is a **20-bit signed compare artifact**: `ev_of` is `if (nid < G_N)` with `nid` `logic [19:0]` and `G_N=800000` (bit19 set ⇒ signed 20-bit negative). Fill nids < 2^19 compare false against truncated signed `G_N`; 799999 (also bit19) compares true. tp is still 3/1 from `G_RELEVANT`. Quality display bug, not retrieve FAIL.

**FACT:** `emit_has_131=0` is **stale vs 16k**. Independent census: cartesian `"boiler supplies header"` is now **nid 0**, not 131. nid 131 is `(13,1,142)`. Overlay failure would emit `{0}` and still fail `SYN_KEYS_NOT_FILL` / `GOLD_MISS` / `nl_tp>=3`. Real guards held. Hunt gold={131}: **MISS** (`G_RELEVANT` fill/nl = `{120,121,122}`; high = `{799999}`).

N_BUCKETS=65536 vs 800k facts: directory is **16-bit exact key** (`key = pack_plain = {id[7:0], rel[7:0]}`), 4 tables × 65536 slots. Not a hash of nid. Occupied keys ≈ 201×20 with list length ~200 (fill 202/201; sentinel k0=1). **No inter-key collision.** Occupancy 202 < `MERGE_POST_AR_MAX=256` and < collect buffer `[0:255]`. Hunt bucket-collision theatre: **MISS.** Hunt occupancy blow-up SEARCH_INCOMPLETE: **MISS this bag** (widened 201-entity namespace kept occ~200). Independent close-gate projection occ≈6933 assumed **same 120 entities**; that projection does not apply to this generator.

DUT fill `postB=832` (52 beats) vs GOLDEN `n_post=102`: DUT rare-first AND stops when one list ends; host counted both lists. Emit locked to gold. Same residual family as 16k. Do not freeze DDR bytes.

### 7) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (fill `{120,121,122}` tp=3 occ=202 incomp=0; nl emit `{120,121,122}` tp=3 keys_match_frozen=0 keys_match_syn=1 emit_has_131=0; HIGH_ID_HIT nid=799999; `UNRELATED_EMPTY_WALK`; marker PRESENT). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: BOARD_PASS, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, ACCEPT_BOARD, Master ≥95%. Banner `NOT_CLAIMED=…ACCEPT_BOARD`. `SEARCH_INCOMPLETE=ABSENT` MATCH raw. `FAIL_R0=PRESENT` MATCH. KEEP “UNMODIFIED” mtimes MATCH live. Honesty discloses procedural AXI (not MIG), host n_post vs DUT postB, ev=0 signed-20-bit artifact, historical U5 cannot close. Hunt RESULTS-vs-xsim: **MISS.** Hunt “C1 CLOSED” as **claim in this bag**: **MISS.** Hunt “Master ≥95% / BOARD_PASS”: **MISS as claim.**

CLOSEOUT MATCH raw: marker emitted, `FAIL_COUNT_FINAL=0`, N=800000, HIGH_ID_HIT, STREAM-02 `14f75db7…` not compiled, PAGE-SKIP not compiled, leftover not compiled, poke_v=0, C0 lexicon FILE `38189974…` unedited / **not** runtime, named lexicon `023a6f81…`, xvlog `-i $bag` FIRST, `CAND_CAP_FINAL=NOT_FROZEN`, gold 20:41:44 PRE, gold NOT regenerated after fail_r0 (TB `gen_800k.svh` only), PROGRAM=NO. QUALITY_NOTE does **not** close BOARD_PASS / Master ≥95% / CAND_CAP_FINAL / DDR.

Promotion language in RESULTS “proves N=800000 addressable” is **narrowly true** of the 800k nid space + sentinel emit, **over-strong** if read as “complete 804k cartesian cube / every high-id SRO”. Independent census: 4002 SROs dropped; sentinel k0 occ=1. Implementer RESULT remains `PASS_THIS_GATE_ONLY`. Bound as REJECT_PROMOTION, not bag OVERCLAIM of the registered unknown.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. N drop / 16k clone labeled 800k | **MISS.** Independent unique nids=800000 contiguous 0..799999; 783616 nids ≥16384; corpus 602 B metadata not KEEP 6991adc7 dump; banner/gold/TB `G_N=800000`; `N_DROP` not taken; `xsim.mem` 24 KB. | Silent drop / 16k clone ⇒ FAIL. Not taken. |
| 2. U5 used as this close | **MISS.** U5 GOLDEN 2026-09-05; not compiled; `qse-v1`. This DUT is synonym wrap `a84bbf7e…`. | U5 cannot close C1. Not used. |
| 3. C1 800k claimed CLOSED / BOARD_PASS / CAND_CAP_FINAL | **MISS as claim.** RESULT=`PASS_THIS_GATE_ONLY`. LOOP `c1_800k=RESULTS_READY_PENDING_AUDITOR` `final_promotion=REJECT`. Cursor close-gate `c1_close=NO`. Banner `BOARD_PASS=NOT_CLAIMED` `CAND_CAP_FINAL=NOT_FROZEN`. | Never grant. Never freeze. Never start C2. |
| 4. C0 extract / C0 lexicon FILE patched | **MISS.** extract `cd7baf49…` mtime 2026-09-05 19:48:18; C0 FILE `38189974…` mtime 2026-09-05 20:51:03. Frozen keys still 3329/3585 (`keys_match=0`). | Hash drift / frozen keys_match=1 ⇒ FAIL. Neither. |
| 5. Independent tree written | **HIT as Cursor-owned tree update this window** (snapshots + close_gate; `C1_CLOSE=NO`). **MISS as Grok implementer CLOSED write / this audit write.** | Keep that tree read-only from Grok. This audit did not write it. |
| 6. Gold relabeled `{131}` | **MISS.** `G_RELEVANT` fill/nl=`{120,121,122}`; high=`{799999}`. Independent nid 131 is `(13,1,142)`, not fill-meaning. Cartesian supplies is nid **0**. | Relabel `{131}` ⇒ FAIL as cheat. Not taken. |
| 7. Dense 800k array hidden | **MISS.** Proc mem has no `mem[]`; C0 `axi_mem_model` not compiled; `xsim.mem` 24312 B; `G_N_WR=0`. | Dense clone ⇒ FAIL. Not taken. |
| 8. High-id prefix luck / 12-bit alias / bucket collision | **MISS as cheat.** Sentinel AND is occ 1∩200 unique nid 799999 (planted, not luck). ctx=0 16-bit keys `16'hD514`. N_BUCKETS=65536 is 16-bit exact key, not a nid hash. **HIT as quality:** k0 occ=1 because cube truncated; 12-bit rel fold still exists in `keys_ctx` for ctx≠0. | Do not sell as general high-id mass / ctx-folded 5-bit rel. |
| 9. Gold after fail_r0 | **MISS as gold regen.** PRE 20:41:44; fail_r0 20:43:43 pack; gen_800k 20:44:30; gold still 20:41:44 MATCH PRE. | TB pack allowed. Gold rewrite ⇒ FAIL. Not taken. |
| 10. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; poke_v held 0. | Keep off. |
| 11. STREAM-02 compiled / ctx DUT compiled as DUT / overlay edited | **MISS.** `14f75db7…` mtime 11:43 sdb ABSENT; `8255a798…` mtime 14:03 sdb ABSENT; overlay/wrap mtime 19:42. | Hash mismatch / ctx DUT as DUT ⇒ FAIL. |
| 12. SEARCH_INCOMPLETE hidden / marker-only PASS | **MISS.** count=0; conjunct includes `incomp_retrieve==0`; fail=0. | Keep miss as FAIL on later bags. |
| 13. RESULTS vs xsim / Master-close claim | **MISS as RESULTS-vs-raw and as CLOSED claim.** Table MATCH. RESULT=`PASS_THIS_GATE_ONLY`. | Authority = raw marker + HIGH_ID_HIT + independent census. |
| 14. Hash theatre | **MISS** on listed gold/RTL/bag paths (live MATCH PRE + SHA256.txt + C0 FILE + STREAM-02 + ctx keys/DUT + syn table bag==rtl). | SHA256 20:44:42 is PASS xvlog freeze. PRE 20:42:01 is gold lock. |
| 15. `relevant=router_union` / nid keys | **MISS.** Gold = fill-meaning SRO / sentinel SRO before walker. RTL no nid port. | Keep independent labels. |
| 16. Cartesian formulaic / MIG-less AXI / truncated cube | **HIT as quality / promotion bound.** Entire corpus is `{ent} {rel} {ent}` closed-form. Index is bag procedural AXI slave, not MIG. 4002 SROs dropped. Sentinel planted. Reduction `NOT_EMITTED`. No 65k/262k ladder bags. | ACCEPT_PARTIAL this 800k XSim retrieve only. REJECT BOARD_PASS / CAND_CAP_FINAL / Master C1 CLOSED / C2 start. Implementer did not claim those. |

qstack-validation-adversary one-liner: **SEMANTIC-800K-01 XSim is a real N=800000 nid-space host+wrap lock on unpatched C0 extract (`cd7baf49…`) with a NEW named 280-word lexicon (`qse-v2-lex-semantic-800k-01`, `023a6f81…`) and a procedural cartesian generator (not a 16k clone, not U5, not dense array) plus INSTANTIATED synonym overlay (`QSE_SYN_N=1` `551655a1…` / `e862208c…` / wrap `a84bbf7e…` mtime 19:42 not edited): bag-first xvlog, C0 FILE `38189974…` unedited and not runtime; frozen ctx keys `124be808…` instantiated not edited; ctx DUT `8255a798…` unedited and not compiled as DUT; STREAM-02 `14f75db7…` unedited and not compiled as DUT; leftover A09 off; poke_v=0; gold PRE 20:41:44 before xvlog and not regenerated after fail_r0 (TB `gen_800k.svh` 128-bit pack only); KEEP SYNONYM-LAW / NL FAIL / 16k unmodified; independent census unique nids=800000 contiguous 0..799999; fill-template emit `{120,121,122}` independent AND MATCH; NL frozen keys_match=0 syn keys_match=1 fill-meaning HIT; HIGH_ID_HIT nid=799999 is the planted SRO (213,20,13) with k0 occ=1 because 4002 cube cells were dropped by `N_STREAM`; `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` PRESENT; that is an **honest PASS_NARROW of the 800k addressable XSim retrieve unknown**, **not** OVERCLAIM of that unknown, **not** a 16k clone, **not** gold={131}, **not** C0 patch, **not** ACCEPT_BOARD, **not** Master C1 CLOSED; ACCEPT_PARTIAL this unknown only; REJECT_PROMOTION BOARD_PASS / CAND_CAP_FINAL / Master C1 CLOSED / C2 because the index is still cartesian formulaic + truncated + MIG-less AXI plant + reduction not emitted + 65k/262k ladder absent.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted fill `{120,121,122}` / nl `{120,121,122}` / high `{799999}` / unrelated `[]`). The registered 800k-retrieve unknown **HIT**. Findings are **law-quality / promotion bounds**, not “patch frozen QSE” and not “regen gold”:

1. **N=800000 unique nids were actually hosted.** Independent census 800000 contiguous; banner/gold/TB 800000; procedural mem; `N_DROP` not taken; not a silent 16k/256 drop; not U5.
2. **Fill-template control still hits.** `"boiler feeds header"` emit `{120,121,122}` tp=3 occ=202 incomp=0; independent AND `{120,121,122}`.
3. **Frozen extract still distinguishes supply≠feeds.** Independent packing + raw `FROZEN_KEYS_VS_FILL` 3329/3585 vs 3332/3588. C0 unpatched half **held**. Overlay remapped DUT keys; `NL_GOLD_HIT` tp=3; `emit_has_131=0`.
4. **Sentinel 799999 HIT is real and is a plant.** Independent `nids_of_sro(213,20,13)=[799999]` only. k0 occ=1 because hatchway’s other objects were truncated. Not prefix luck. Not 12-bit alias this bag.
5. **The cube is formulaic and truncated.** 201×20×200=804000 slots; 4002 dropped; texts are `{ent} {rel} {ent}`. Illegal as Master ≥95% / complete semantic mass.
6. **Index is bag procedural AXI, not MIG/DDR.** Honest for this XSim; illegal as BOARD_PASS / C2 persist / `DDR_QUERY_BOUND_FINAL`.
7. **`ev_of` 20-bit signed display artifact.** Scoring used `G_RELEVANT`. Do not read CAND `ev=0` as evidence=0.
8. **`emit_has_131` is a stale 16k check.** Cartesian supplies is nid 0 here. Overlay guards are keys_match_syn + G_RELEVANT HIT.
9. **Host n_post vs DUT postB (102 vs 52) on fill.** Emit locked. Do not freeze DDR bytes.
10. **Collect buffer `[0:255]` / MERGE_POST_AR_MAX=256.** Occupancy 202 fits. A same-entity 800k projection would overflow; this bag widened entities instead. Do not silent-bump KEEP STREAM-02.
11. **fail_r0 was TB pack, gold not rewritten.** Correct fail routing.
12. **Master C1 ladder 65k / 262k bags do not exist.** Owner may have jumped 16k→800k. This XSim does not close Master §7. Cursor close-gate `C1_CLOSE=NO`.
13. **Required next is not C2 and not BOARD_PASS.** One unknown (800k XSim retrieve) HIT. Promotion stays REJECT.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start C2 in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (N=800000 unique nids hosted, leftover off, poke_v=0, CAND_CAP=16<800000, gold PRE MATCH live, KEEP unmodified, pack fail_r0 then PASS) | **PASS_NARROW of the measurement harness** | Simulation only. Not DDR. Not BOARD. |
| Procedural mem `a7ng_axi_mem_proc_800k` + `gen_800k.svh` | **PASS_NARROW of 800k addressability** | Closed-form; 800000 distinct nids; not dense array; not 16k clone. |
| Independent nid 799999 sample SRO=(213,20,13) | **PASS_NARROW** | Only that SRO maps to 799999. Raw HIGH_ID_HIT MATCH. |
| FILL_TEMPLATE_HIT tp=3 emit `{120,121,122}` occ=202 incomp=0 | **PASS_NARROW** | Independent AND `{120,121,122}`. |
| FROZEN_KEYS_VS_FILL keys_match=0 / SYN_KEYS_VS_FILL keys_match=1 / NL_GOLD_HIT | **PASS_NARROW of overlay still live at 800k** | C0 unpatched; 1-pair remap; gold not `{131}`. |
| `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` | **PRESENT (correct)** | Conjunct requires fill HIT AND high HIT AND frozen0 AND syn1 AND nl_tp≥3 AND emit_has_131==0 AND G_N==800000. All held. |
| Gold-before-xvlog / not regen after fail_r0 | **PASS_NARROW** | PRE 20:41:44; gen pack 20:44:30; gold 20:41:44. |
| STREAM-02 `14f75db7…` / PAGE-SKIP `dab15d76…` / ctx DUT `8255a798…` not compiled | **PASS_NARROW** | KEEP. Wrap is the DUT. |
| Ctx keys `124be808…` instantiate not edited | **PASS_NARROW** | mtime 14:03; ctx=0 pass-through 16-bit. |
| C0 extract `cd7baf49…` / C0 FILE `38189974…` unedited | **PASS_NARROW** | Named 280-word is runtime. |
| KEEP SYNONYM-LAW / NL FAIL / 16k unmodified | **PASS_NARROW / UNMODIFIED** | MAX mtimes < 20:33 (SYNONYM CLOSEOUT 20:05:22). |
| U5 historical 800k | **NOT THIS CLOSE** | qse-v1; 2026-09-05. |
| Truncated cube / sentinel k0 occ=1 / cartesian formulaic | **HIT as quality bound** | 4002 SROs dropped. Not Master mass. |
| MIG-less AXI plant | **HIT as bound** | Illegal as BOARD_PASS / C2 / DDR freeze. |
| 12-bit ctx-fold rel alias | **MISS this bag (ctx=0); HIT as standing bound** | `keys_ctx` still 4-bit rel when ctx≠0. |
| N_BUCKETS=65536 vs 800k facts | **PASS_NARROW as 16-bit exact keys** | Not nid-hash collision. occ~200 < MERGE 256. |
| Reduction / 65k / 262k ladder / Master ≥95% / ≥90% | **FAIL as Master close / REJECT_PROMOTION** | `REDUCTION_X1000=NOT_EMITTED`. Ladder bags absent. 4 query classes only. |
| Implementer RESULT=`PASS_THIS_GATE_ONLY` | **HONEST vs raw for this gate** | Not OVERCLAIM of the registered unknown. Not C1 CLOSED. |
| C1 800k Master / BOARD_PASS / CAND_CAP_FINAL / ACCEPT_BOARD / C2 | **NOT CLOSED / REJECT_PROMOTION** | Honest 800k XSim retrieve. axi proc mem. This audit does not start C2. |

Promotion scale: **ACCEPT_PARTIAL of this 800k addressable XSim retrieve unknown only** (N=800000 unique nids under instantiate `qse-v2-relctx-synonym-01` + ctx keys `124be808` + synonym DUT wrap `a84bbf7e…` + NEW named lexicon `qse-v2-lex-semantic-800k-01` `023a6f81…`; C0 extract unpatched; C0 FILE `38189974…` unedited not runtime; xvlog `-i $bag` FIRST; CLASS_fill_template `{120,121,122}` `FILL_TEMPLATE_HIT` tp=3 occ=202; CLASS_nl_synonym frozen keys_match=0 syn keys_match=1 `NL_GOLD_HIT` tp=3; CLASS_high_id_sentinel `HIGH_ID_HIT nid=799999` independent SRO (213,20,13) k0_occ=1 k1_occ=200; PASS marker PRESENT; leftover off; poke_v=0; gold-before-xvlog; gold not regen after fail_r0 TB pack; STREAM-02 not DUT; ctx DUT not DUT; KEEP unmodified; not 16k clone; not U5; not dense array; not gold={131}; RESULT=`PASS_THIS_GATE_ONLY` honest vs raw). **REJECT** promotion of BOARD_PASS, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, Master C1 CLOSED, evidence-recall ≥95%, candidate-reduction ≥90%, general NL, C2 persist. **Not** FAIL_LOOP (hashes real, C0 unpatched, gold not rewritten, N not dropped, 800k not claimed CLOSED, keys are not nid, STREAM-02 not compiled, SEARCH_INCOMPLETE absent, lexicon named, KEEP unmodified). **Not** `ACCEPT_BOARD`. **Not** OVERCLAIM of the registered unknown (implementer RESULT is `PASS_THIS_GATE_ONLY`; 16k-clone hunt fails; U5 hunt fails; C0-patch hunt fails; sentinel plant is named).

**P1 for this measurement: none.** Parent next is **not C2** and **not BOARD_PASS**. Optional later: 65k/262k ladder on the same law stack, reduction print, MIG persist — each a **new bag**. Never `ACCEPT_BOARD`. Never start C2 from this audit.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-SEMANTIC-800K-01` gold/xsim/RESULTS to inflate this audit into Master C1 CLOSED / BOARD_PASS / CAND_CAP_FINAL. **Do not edit** KEEP SYNONYM-LAW / SEMANTIC-NL-01 / UNSEEN-SRO / HELDOUT / SEMANTIC-16K / CONTEXT-02 / PAGE-SKIP / STREAM-02 / U5. **Do not patch C0 extract or C0 lexicon FILE.** **Do not edit** `a7ng_query_axi_sparse_stream_intersect.sv` / `a7ng_query_axi_sparse_page_skip.sv` / `a7ng_query_role_keys_ctx.sv` / `a7ng_query_axi_sparse_intersect_context.sv` / `a7ng_sparse_dir_axi.sv` / synonym overlay/wrap. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. **Do not start C2 in this audit.** **Do not write** `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` from Grok.

**P1 — none for this measurement** (independent unique nids=800000; FILL_TEMPLATE_HIT `{120,121,122}`; HIGH_ID_HIT 799999 MATCH generator SRO (213,20,13); frozen keys_match=0; syn keys_match=1; NL_GOLD_HIT; SEARCH_INCOMPLETE ABSENT; N not dropped; not 16k clone; not U5; gold PRE; gold not regen; C0 unpatched; STREAM-02 not DUT; leftover off; poke_v=0).

**Required fix (parent / promotion — not this audit, not a silent C0 patch, not C2):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence of 800k nid-space XSim retrieve.** Authority = raw `C1_SEMANTIC_800K_N=800000` / `FILL_TEMPLATE_HIT` / `HIGH_ID_HIT nid=799999` / `FROZEN_KEYS_VS_FILL keys_match=0` / `SYN_KEYS_VS_FILL keys_match=1` / `NL_GOLD_HIT` / `ASTRA_C1_SEMANTIC_800K_XSIM_PASS` + independent census unique=800000 + sentinel SRO (213,20,13). Do not silent-patch KEEP / C0 to inflate this.
2. **Do not sell this as Master C1 CLOSED, BOARD_PASS, ≥95% recall, ≥90% reduction, or complete 804k cube.** Cartesian `{ent}{rel}{ent}`; 4002 SROs dropped; sentinel k0 occ=1; reduction not emitted; 65k/262k bags absent; index is procedural AXI not MIG.
3. **Do not start C2 / persist / MIG from this close.** Honest 800k XSim + axi proc mem are the stop.
4. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** Host n_post ≠ DUT postB on fill.
5. **Keep** reporting machinery: `precision_all=TP/emit_n`; `FILL_TEMPLATE_HIT` required; `HIGH_ID_HIT nid=799999` required; `FROZEN_KEYS_VS_FILL keys_match=0` required; `SYN_KEYS_VS_FILL keys_match=1` required; `SEARCH_INCOMPLETE` on `gold_n>=1` FAILS the bag; `G_N!=800000` FAILS as `N_DROP`; leftover A09 off; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL (TB pack only); PROGRAM=NO; STREAM-02 / PAGE-SKIP / ctx DUT **not** compiled as DUT.
6. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `final_promotion` stays REJECT until a human board. `c2_persist` stays blocked. This audit does not write it.
7. If parent later opens 65k/262k, those are **new bags** on the frozen law stack. Occupancy fork already taken here (widen entities, not silent MERGE bump). Do not silent-grow `QSE_SYN_N`. Do not silent-patch C0.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL of this 800k ADDRESSABLE XSIM RETRIEVE unknown only
UNKNOWN          = N=800000 unique nids under qse-v2-relctx-synonym-01
                   + ctx keys 124be808 + synonym DUT wrap
                   Fill-template HIT {120,121,122}
                   High-id sentinel nid 799999 HIT
                   SEARCH_INCOMPLETE absent on gold_n>=1
VERDICT_FRAME    = PASS_NARROW of registered unknown
                   NOT OVERCLAIM of that unknown
                   NOT FAIL of that unknown
                   NOT cheat (N is real 800000 nids, not 16k clone;
                     not U5; gold not {131}; C0 unpatched;
                     gold not regen after fail_r0 TB pack;
                     dense array not hidden)
PROMOTION        = REJECT
                   REJECT BOARD_PASS
                   REJECT CAND_CAP_FINAL
                   REJECT DDR_QUERY_BOUND_FINAL
                   REJECT Master C1 CLOSED
                   REJECT Master evidence-recall ≥95%
                   REJECT candidate-reduction ≥90%
                   REJECT general NL
                   REJECT C2 persist start
                   REASON still cartesian formulaic
                          + truncated cube (4002 SROs dropped;
                            sentinel k0 occ=1 plant)
                          + MIG-less AXI plant
                          + 12-bit ctx-fold standing (not active ctx=0)
                          + reduction NOT_EMITTED
                          + 65k/262k ladder bags absent
ACCEPT_BOARD     = NO (never)
FAIL_LOOP        = NO
P1               = none for this measurement
REQUIRED_FIX     = do not promote; do not start C2
C1_800K          = THIS_GATE_ONLY (Master C1 NOT CLOSED)
C2               = NOT STARTED (this audit does not start it)
PROGRAM          = NO
KEEP_SYNLAW      = UNMODIFIED (GOLDEN 19:49:47 CLOSEOUT 20:05:22)
KEEP_NL_FAIL     = UNMODIFIED (GOLDEN 19:05:03 CLOSEOUT 19:20:19)
KEEP_16K         = UNMODIFIED
U5               = NOT THIS CLOSE (2026-09-05 qse-v1)
INDEP_TREE       = Cursor-updated this window; C1_CLOSE=NO;
                   this audit did not write it
INSTANTIATE      = 124be808 NOT edited; 8255a798 NOT compiled as DUT
                   a84bbf7e / e862208c / 551655a1 instantiate NOT edited
                   (mtime 19:42:02)
C0_EXTRACT       = UNEDITED cd7baf49 (mtime 2026-09-05 19:48:18)
C0_LEXICON_FILE  = UNEDITED 38189974 (mtime 2026-09-05 20:51:03; NOT runtime)
NEW_LEXICON      = qse-v2-lex-semantic-800k-01 023a6f81 QSE2_N_LEX=280
PROC_MEM         = bag a7ng_axi_mem_proc_800k; C0 dense mem NOT compiled
N_REAL           = 800000 unique nids 0..799999 (independent census)
NID_799999       = ONLY SRO (213,20,13) "hatchway splits boiler"
POKE_V           = 0
LEFTOVER_A09     = not compiled
SEARCH_INCOMPLETE= ABSENT
PASS_MARKER      = PRESENT fill HIT AND high HIT AND frozen0 AND syn1
                   AND NL_GOLD_HIT tp=3 AND emit_has_131=0 AND G_N=800000
GOLD_AFTER_FAIL  = NO (PRE 20:41:44; gold still 20:41:44 after fail_r0
                   20:43:43 and PASS 20:44:58; gen_800k pack 20:44:30 only)
NEXT             = NOT C2 / NOT BOARD_PASS / NOT CAND_CAP_FINAL this audit
                   OPTIONAL parent: 65k/262k ladder as NEW bags
                   NOT silent C0 patch
                   NOT silent MERGE bump of STREAM-02
```
