# ASTRA auditor REPORT — 20260907T1145Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-STREAM-INTERSECT-02
LAW        = qse-v2-stream-intersect-02  (NEW named RTL; N=256 only)
KEEP       = ASTRA-C1-KEY-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-N4096-INTERSECT-01 (must be unmodified; verified)
           + ASTRA-C1-AXI-BEAT-ACCOUNTING-01 (must be unmodified; verified)
           + R1 / R2 / R3 / KEY-RELBIND (verified)
           + C0 RTL hashes (extract/lexicon/sparse/dir/gate; verified MATCH)
           + intersect DUT a7ng_query_axi_sparse_intersect.sv a912786f… (KEEP; not compiled as DUT)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T1115Z/REPORT.md
           ACCEPT_PARTIAL (P0-2 AXI-BEAT); STREAM_INTERSECT_02 not started by that audit
           Independent P0-1 (RO): D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
             PLAN.md §P0-1 + EVIDENCE.md P0-1 (this audit did not write that tree)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256 / FINAL_CONTRACT
           WO .agents/handoff/ASTRA-C1-STREAM-INTERSECT-02.md
EVIDENCE   = raw xsim.log CLASS_* / LATE_GOLD_HIT / CAP_THEN_AND_WOULD_MISS /
             ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS / NOT_SELECTIVE / UNRELATED_EMPTY_WALK
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold PRE vs first xvlog/xsim; KEEP KEY-INTERSECT / N4096 / AXI-BEAT)
           + NEW RTL rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv
           + TB tb_astra_c1_stream_intersect.sv (poke_v, leftover A09, CAND_CAP override, LATE_GOLD gate)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_stream_intersect.py
           + independent corpus exact-key postings for nid 254 (not RESULTS)
           + KEEP intersect DUT a912786f… (buf0/buf1 cap-then-AND) NOT compiled
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = KEEP unedited (not this bag; not promoted; this audit does not start N=4096 stream)
CAND_CAP_FINAL        = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP KEY-INTERSECT / N4096 / AXI-BEAT / R1 / R2 / R3 / KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`, did not start an N=4096 stream bag, and did not spawn agents. Only this file is written.

Active characters (TrustLayer x16): cartographer + code-reader + inspector (recon, `READ_ONLY_AUDIT`); red-team-source-auditor (red, `READ_ONLY_AUDIT`); purple-team-release-gate + devil-advocate (`VERIFY_ONLY`); risk-officer (`REPORT_ONLY`). No blue patch.

---

## Scope

Read-only except this file.

Primary object: C1 **P0-1 stream-intersect** bag `ASTRA-C1-STREAM-INTERSECT-02` after independent PLAN §P0-1 and auditor `20260907T1115Z` (P1 none on AXI-BEAT) allowed parent to open N=256 `qse-v2-stream-intersect-02`.

`results/A7-NATIVE-GRAPH/ASTRA-C1-STREAM-INTERSECT-02/`

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=256, new law `qse-v2-stream-intersect-02` (postings sorted by nid; two-pointer merge; 1-beat page buffer; rare-list-first; CAND_CAP after emit), does LATE gold (posting index ≥16 on both k0 and k1, so cap-then-AND would miss) HIT while CLASS_direct still retrieves `{110,144,145}` if those records remain?

PASS this bag only if:

1. XSim `FAIL=0` and marker `ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS` present.
2. LATE gold nid in emit (`LATE_GOLD_HIT`); `SEARCH_INCOMPLETE` does **not** convert a gold miss into PASS.
3. CLASS_direct gold hits `{110,144,145}` (records remain).
4. Walker is sorted-nid two-pointer AND, 1-beat page, rare-first, CAND_CAP **after emit** — **not** KEY-INTERSECT `buf0`/`buf1` cap-then-AND.
5. Frozen C0 dir instantiated not patched; leftover A09 off; `poke_v=0`; gold hashed before first xvlog; KEEP bags unmodified.
6. Do **not** freeze `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / C1 800k.

This bag **cannot** close C1 800k, cannot promote N=4096, cannot freeze a DDR byte bound, cannot close Master evidence-recall ≥95% or candidate-reduction ≥90%, cannot `ACCEPT_BOARD`.

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/` (GOLDEN `d3b5b883…` timestamp **10:16:50**)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/` (GOLDEN timestamp **10:46:42**; sentinel miss remains in that bag)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/` (GOLDEN **10:16:50**; bag max **11:11:09**)
- R1 / R2 / R3 / KEY-RELBIND
- C0 hashes of extract / lexicon / `a7ng_sparse_dir_axi` / `a7ng_query_axi_sparse` / `a7ng_route_valid_gate`
- Intersect DUT `a7ng_query_axi_sparse_intersect.sv` = `a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c` (KEEP; **not** compiled as DUT)

**Not** this bag: C1 800k close, N>256 generation, C2 DDR persist, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys, context keys, 65k directory, page-skip, loading full posting into BRAM, patching KEY-INTERSECT / N4096 / AXI-BEAT.

Hunt (dispatch, none dropped):

1. Late gold planted on only one posting list (stream would still “hit” via M_K0/M_K1, or first16∩first16 would also hit)
2. Merge still caps each list first (`buf0`/`buf1` / `n0<CAND_CAP` then AND) — KEY-INTERSECT clone under a new filename
3. `SEARCH_INCOMPLETE` used to PASS a retrieve class with `gold_n>=1` miss
4. C0 dir patched (`09334e42` drift)
5. Independent audit tree written by this implementer
6. C1 800k claimed / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` frozen / `ACCEPT_BOARD`
7. RTL `CAND_CAP` default **64** vs TB **16** (override missing / theatre)
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. Gold hashed after first xvlog / rewritten after FAIL
10. KEEP KEY-INTERSECT / N4096 / AXI-BEAT timestamps rewritten
11. RESULTS.md / CLOSEOUT.md vs raw `xsim.log`
12. Frozen / KEY-INTERSECT sparse compiled as DUT
13. Hash theatre (SHA256.txt vs live Get-FileHash)
14. `reduction_x1000` as `1-CAND_CAP/N`
15. CAP_THEN_AND_WOULD_MISS print-only tautology (gold bit, not corpus)

Master §7 line this bag is **not** graded as closing: evidence-recall ≥95% / candidate-reduction ≥90% / 800k. This is the **N=256 stream law** unknown only.

If P1 is none for this unknown, parent **may** open N=4096 LATE-GOLD stress **SAME stream law** (sentinel/late nid must **FAIL** the bag if `SEARCH_INCOMPLETE` on `gold_n>=1`). This audit does **not** start that bag. Never `ACCEPT_BOARD`. Never C1 800k.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. STREAM bag is untracked (`??`). KEY-INTERSECT / N4096 / AXI-BEAT remain untracked (`??`). NEW RTL `a7ng_query_axi_sparse_stream_intersect.sv` is untracked (`??`). KEEP intersect DUT remains untracked at HEAD with **unchanged** hash `a912786f…`. Frozen extract / lexicon / `query_axi_sparse` remain untracked at HEAD. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD; working-tree hash is still the C0 blob `09334e42…` (same finding as 0840Z/0915Z/0940Z/0955Z/1020Z/1115Z — **not** a silent patch in this bag; mtime still **2026-09-05 19:31:03**). `PROGRAM=NO` this process and this bag (no `.bit` in bag, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T11:50:00+07:00` `acceptance=PENDING_AUDITOR_C1_STREAM_INTERSECT_02` `implementer=DONE` `auditor=IN_PROGRESS` `c1_800k=OPEN` `n4096_bag=KEEP_UNEDITED` `final_promotion=REJECT` `independent_audit_write=false`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), STREAM bag:

```text
11:39:14.908  host_astra_c1_stream_intersect.py
11:41:26.129  tb_astra_c1_stream_intersect.sv
11:43:12.987  PREREG.md ACK.json run_xsim.ps1
11:43:39.087  rtl/.../a7ng_query_axi_sparse_stream_intersect.sv   (NEW)
11:43:45.702  corpus.json
11:43:45.704  GOLDEN.json
11:43:45.705  query_gold.svh
11:43:45.706  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xvlog
11:43:58.405  SHA256.txt                 ← freeze immediately before first xvlog
11:43:59.610  xvlog.log
11:44:02.567  xelab.log
11:44:06.268  xsim.log                   PID 56180; session 11:44:03–11:44:06
11:45:37.318  RESULTS.md CLOSEOUT.md
```

Single XSim session. No second xvlog. Gold files were **not** rewritten between 11:43:45 and 11:45:37 (hash MATCH PRE; LastWriteTime still 11:43:45). `xsim_fail_r0.log` **ABSENT** (PASS session). Hunt gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `9091c5a78d1e67ffb1683bfee8fe029b17fc1b6e6b965a20d7d328a400084c14` MATCH RESULTS `XSIM_SHA`.

NEW stream RTL LastWriteTime **11:43:39** — before gold hash 11:43:45 and xvlog 11:43:59. KEEP intersect DUT LastWriteTime still **10:13:02.641**.

### 2) Live hashes vs C0 / SHA256.txt / PRE

Live `Get-FileHash SHA256` (this process):

```text
cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27  a7ng_query_role_extract.sv          (C0 MATCH; mtime 2026-09-05 19:48:18)
381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c  qse_role_lexicon.svh                (C0 MATCH; mtime 2026-09-05 20:51:03)
09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24  a7ng_sparse_dir_axi.sv              (C0 MATCH; mtime 2026-09-05 19:31:03)
5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa  a7ng_query_axi_sparse.sv            (C0 MATCH; mtime 2026-09-05 21:14:18)
49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385  a7ng_route_valid_gate.sv            (C0 MATCH; mtime 2026-09-05 18:58:22)
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  a7ng_query_role_keys_relbind.sv     (0955Z/1020Z MATCH; mtime 09:43:58)
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  a7ng_query_axi_sparse_intersect.sv  (KEY-INTERSECT MATCH; mtime 10:13:02; NOT DUT)
14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac  a7ng_query_axi_sparse_stream_intersect.sv  (NEW; MATCH SHA256.txt)
9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c  a7ng_astra_09_integ_path.sv         (C0 leftover prefix MATCH; NOT compiled)
```

`GOLD_HASH_PRE_XVLOG.txt` mtime **11:43:45.706** vs live gold (all MATCH):

```text
05c6e087e567146fc3f8da058370d8bfc5f7a9acfdebc1efaf6659b594f4b86b  GOLDEN.json
e6c88efe25ce55ae1c37683920cbb3d0f5a180cf0456d62dd8f1dc1aea812dd1  query_gold.svh
fe7a3d5a1bf650a50db321e2de08daf63d624c6c82ce3c25ee9227fdb0bf46ee  corpus.json
```

`xvlog.log` mtime **11:43:59.610**. Gold hashed **before** first xvlog. Gold files were **not** rewritten after xsim (still 11:43:45). SHA256.txt freeze stamp `2026-09-07T11:43:58.3500130+07:00` is immediately before xvlog.

SHA256.txt listed NEW RTL / compiled / bag gold / BAG lines vs live: MATCH on every path re-hashed this process (C0 five, relbind keys, KEEP intersect, stream DUT `14f75db7…`, pkg, mem model, TB, host, ACK, PREREG, run_xsim, gold triple). No invented hash.

### 3) KEEP bags unmodified

| Bag | GOLDEN hash / mtime | bag MAX mtime | vs STREAM window 11:39+ |
|---|---|---|---|
| KEY-INTERSECT | `d3b5b883…` **10:16:50.145** | CLOSEOUT **10:18:37.973** | **UNMODIFIED** |
| N4096 | `095ca715…` **10:46:42.851** | CLOSEOUT **10:49:24.999** | **UNMODIFIED** |
| AXI-BEAT | `d3b5b883…` **10:16:50.145** (copy) | CLOSEOUT **11:11:09.523** | **UNMODIFIED** (before STREAM) |
| R1 | GOLDEN **08:31:44** | CLOSEOUT **08:37:00** | **UNMODIFIED** |
| R2 | GOLDEN **08:59:20** | RESULTS **09:01:39** | **UNMODIFIED** |
| R3 | GOLDEN **09:24:14** | CLOSEOUT **09:26:23** | **UNMODIFIED** |
| KEY-RELBIND | GOLDEN **09:48:35** | CLOSEOUT **09:51:03** | **UNMODIFIED** |

Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`: all files **10:50:50–10:52:29** (PLAN/EVIDENCE/recompute). **No file after 10:52:29.** STREAM implementer did **not** write that tree.

### 4) Compile list / leftover A09 / poke_v / KEY-INTERSECT not DUT

`xvlog.log` analyzed units, in order:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_stream_intersect.sv
tb_astra_c1_stream_intersect.sv
```

`xelab.log` compiled the same modules (frozen dir `a7ng_sparse_dir_axi(CAND_CAP=32'…` instantiated AXI-idle; stream DUT is the walker). Work `*.sdb`: extract, relbind keys, gate, dir, mem model, **stream_intersect**, TB. **ABSENT:** `a7ng_astra_09_integ_path`, `a7ng_query_axi_sparse.sv` as DUT, `a7ng_query_axi_sparse_intersect.sv` as DUT, `a7ng_query_axi_sparse_relbind`.

TB holds `poke_v=0` (assigned 0; never `<= 1`). Diverge `HOST_SEMANTIC_LEAK` if `poke_v!=0`. Raw banner `POKE_V=0`. No `FIRST_DIVERGENCE`. leftover A09 **off**.

`run_xsim.ps1` hash-gates C0 + KEEP intersect `a912786f…` + relbind `93811ed1…`; throws if leftover / frozen sparse / KEY-INTERSECT / relbind-sparse on xvlog list; requires `GOLD_HASH_PRE_XVLOG` MATCH live before xvlog; copies `xsim_fail_r0.log` on missing PASS / LATE_GOLD_MISS / DISTRACTOR_LEAK / diverge / numeric `reduction_x1000`. PASS session ⇒ r0 ABSENT.

### 5) Stream RTL vs KEY-INTERSECT cap-then-AND (hunts 2, 7)

KEEP KEY-INTERSECT DUT `a7ng_query_axi_sparse_intersect.sv` (NOT compiled this bag) still has:

```text
parameter CAND_CAP = 64;
logic [ID_W-1:0] buf0 [0:CAND_CAP-1];
logic [ID_W-1:0] buf1 [0:CAND_CAP-1];
if (w_cand_v && … && (n0 < CAND_CAP)) buf0[n0] <= w_cand_id;   // collect k0 to cap
if (w_cand_v && … && (n1 < CAND_CAP)) buf1[n1] <= w_cand_id;   // collect k1 to cap
// then S_SCAN membership AND of buffers
```

That is `first_CAND_CAP(k0) ∩ first_CAND_CAP(k1)`. Independent EVIDENCE P0-1 already confirmed this operator on the KEEP bags.

NEW DUT `a7ng_query_axi_sparse_stream_intersect.sv` SHA `14f75db7…`:

- Instantiates frozen extract → relbind keys (not edited) → frozen `a7ng_route_valid_gate`.
- Instantiates frozen `a7ng_sparse_dir_axi` with `q_v=0`, k-valids=0, `arready=0` (AXI **idle**; hash-gate geometry; **not** the merge walker). Compliant with WO “instantiate frozen dir, do not patch C0”.
- Own AXI master: directory AR `arlen=0`; posting AR `arlen=0` (1-beat page, 4 IDs). TB diverges `AXI_PROTOCOL_ERROR` if any accepted AR has `arlen!=0`. Raw: no such diverge.
- Two 128-bit beat registers `beat0`/`beat1` + lane pointers. **No** `buf0`/`buf1` of `CAND_CAP`. **No** `n0 < CAND_CAP` collect-then-AND.
- Two-pointer in `S_NEXT`: `id0==id1` → emit (if `nemit < CAND_CAP`); `id0 < id1` → `adv0`; else `adv1`. After emit, advance **both**.
- `CAND_CAP` checked **at emit** (`nemit >= CAND_CAP` before raising `cand_v`), not per-list collect.
- Rare-first: when both pages empty, `fetch_sel <= (occ0 <= occ1) ? 0 : 1`.
- `MERGE_POST_AR_MAX=256` exhaust → `acc_incomp` / `q_incomplete_o`. Never empty-as-UNKNOWN.
- `w_v2`/`w_v3` never probed (`acc_pmask` only bits 0/1). `M_AND` when both keys valid; `M_K0`/`M_K1` fallback if only one valid (not this unknown: late_gold and direct both-valid).
- Parameter default `CAND_CAP = 64` in the RTL source. **TB overrides** `.CAND_CAP(CAND_CAP)` with `localparam CAND_CAP = G_CAND_CAP` and `G_CAND_CAP = 16`. Banner `CAND_CAP=16`. `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` not taken (16<256).

Hunt “new filename, old cap-then-AND”: **MISS.** Hunt “CAND_CAP default 64 used this bag”: **MISS as behavior** (TB override 16; banner 16). **HIT as reuse caveat:** a future bag that instantiates the module without override gets emit budget 64. Do not treat 64 as `CAND_CAP_FINAL`.

FSM names (`S_IDLE/S_DISPATCH/S_ARDIR0/S_RDIR0/S_ARDIR1/S_RDIR1/S_NEXT/S_ARPOST/S_RPOST/S_OUT/S_DONE`) differ from the WO prose (`FETCH_DIR_K0` / `MERGE_CMP`). Behavior is two-pointer 1-beat merge. Not a FAIL.

### 6) Raw xsim.log (authority)

Session: Vivado xsim v2026.1; start **Mon Sep 7 11:44:03 2026**; exit **11:44:06**; PID **56180**; `$finish` at **16765 ns**.

Banner:

```text
C1_STREAM_INTERSECT_02_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-stream-intersect-02 POKE_V=0 PAGE_BUFFER_BEATS=1 RARE_LIST_FIRST=1 CAND_CAP_AFTER_EMIT=1 REDUCTION_X1000=NOT_EMITTED CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN
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
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 id=114 occ=22 postB=32 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct … keys_match=1 emit_match=1 law=qse-v2-stream-intersect-02 xid_not_directory_key
CLASS_wrong_context gold_n=1 emit_n=3 tp=1 fp_ev1=2 prec_all_x1000=333 rec_x1000=1000 incomp=0
CLASS_distractor gold_n=10 emit_n=3 leak_n=0 tp=0 fp_ev1=3 rec_undef=1 incomp=0 gold_polarity=excluded
EMIT_distractor {110,144,145}
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_fill0=15 prec_all_x1000=62 rec_x1000=1000 occ=22 postB=160 trunc=0 incomp=0
EMIT_high_occupancy {147…162}
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 id=167 (emit 163–167) ovf=1 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 id=255 incomp=0
LATE_GOLD_HIT id=254
CAP_THEN_AND_WOULD_MISS id=254 stream_hit=1
CLASS_late_gold gold_n=1 emit_n=1 tp=1 prec_all_x1000=1000 rec_x1000=1000 occ=23 ovf=1 trunc=0 dirB=32 postB=192 incomp=0
EMIT_late_gold n=1
  CAND late_gold i=0 id=254 ev=1
HEADLINE precision_all=TP/emit_n prec_ev1=diagnostic
ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

Counts this process: `LATE_GOLD_HIT=1`; `CAP_THEN_AND_WOULD_MISS=1`; `ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS=1`; `XSIM_NO_MARKER=0`; `FAIL ` lines = **0**; `SEARCH_INCOMPLETE` = **0**; `FIRST_DIVERGENCE` = **0**; `incomp=[1-9]` = **0**. `incomp=0` on `CLASS_late_gold` and `CLASS_direct`.

TB PASS conjunct (lines 508–509): `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0) && late_hit && late_ok`. Gold miss on a retrieve class increments `fail` **even if** `q_incomp` (`FAIL GOLD_MISS` + `SEARCH_INCOMPLETE … incomp does not hide gold miss`). Hunt “incomp used to PASS”: **MISS** this bag (no incomp line; no gold miss).

`PAGE_BUFFER_BEATS=1` / `RARE_LIST_FIRST=1` on the banner are TB `$display` constants. Independent confirmation of 1-beat: no `arlen!=0` diverge. Independent confirmation of merge-not-full-drain: see §8 `wrong_relation` live `n_post=2` vs host full-drain 7.

### 7) Independent corpus — nid 254 on **both** lists at index ≥16 (hunts 1, 15)

Authority = live `corpus.json` records (hash `fe7a3d5a…`), **not** the JSON header fields and **not** RESULTS.

Packing: `k0==(subj<<8)|rel`, `k1==(obj<<8)|rel` on all 256 records: **0** failures. `k0/k1/k2/k3 == nid`: **0**. Hunt nid-derived keys: **MISS.**

Record 254:

```text
nid=254 text="compressor requires tower" evidence=1 kind=late_gold
subj=4 rel=2 obj=9 ctx=0  k0=1026 k1=2306
```

Exact-key postings (sorted by nid):

```text
k0=1026 occ=21
  p0 = [40, 41, 42, 43, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 254]
  index of 254 = 20  (>=16)

k1=2306 occ=23
  p1 = [55, 66, 77, 88, 177, 218, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254]
  index of 254 = 22  (>=16)
```

```text
full(k0) ∩ full(k1)              = {254}
first_16(k0) ∩ first_16(k1)      = {}          254 NOT in first16 of either list
complete ∩ then cap16            = {254}       HIT
254 in only one list?            NO
late_k0_fill (222–237)           = "compressor requires valve"  evidence=0  k0-only
late_k1_fill (238–253)           = "condenser requires tower"   evidence=0  k1-only
```

**FACT:** nid 254 sits at posting index **20** on k0 **and** **22** on k1. Cap-then-AND (`first16 ∩ first16`) **misses**. AND-then-cap / two-pointer **hits**. Planted on **both** lists; the 16+16 fillers are one-list-only (so they occupy prefix slots without creating extra AND hits).

1-beat occupancy model for late_gold: `ceil(21/4)+ceil(23/4)=6+6=12` posting beats; `postB=192`; `dirB=32`. Live CLASS `dirB=32 postB=192`. **MATCH.** Cap-then-AND that fetched only 16 ids/list would be 4+4=8 posting beats = 128 B. Live 192 B is full walk of both lists to the late nid — consistent with stream merge, not prefix-cap.

`G_BYTES[10]` LSB-first decodes to `"compressor requires tower"`. `G_K0[10]=16'h0402=1026`, `G_K1[10]=16'h0902=2306`, `G_LATE_GOLD_ID=254`, `G_CAP_THEN_AND_MISS[10]=1`. TB print `CAP_THEN_AND_WOULD_MISS` is gated on that gold bit (print tautology). **The corpus posting math independently confirms the bit is true.**

Direct control (k0=2561, k1=257):

```text
k0 occ=6  {108,109,110,111,144,145}
k1 occ=8  {99,110,121,132,144,145,188,208}
k0 ∩ k1   {110,144,145}
```

MATCH raw `EMIT_direct` and KEY-INTERSECT control (records remain). `occ=8` on CLASS is max occupancy (k1); KEY-INTERSECT had k1 occ=9 — this corpus rebuilt fill to reserve late_n slots; **not** a KEEP-bag edit.

Distractor excluded (two-role overlap, evidence=1): `{99,108,109,111,114,118,121,132,188,208}` n=10. `excluded ∩ emit = {}`. MATCH raw `leak_n=0 gold_n=10`. KEY-INTERSECT had gold_n=11 (nids 193/214/235 dropped by fill reservation; 188/208 present). Polarity meter intact.

high_occupancy (k0=1538, k1=258): full ∩ n=**16** `{147…162}`; cap-then-AND n=**12** `{147…158}`; stream n=**16**. Live emit_n=16 MATCH ∩-then-cap, **not** KEY-INTERSECT’s cap-then emit_n=12. Gold 147 is **early** (not the late-gold unknown). Extra discriminator that this walker is not cap-then-AND.

### 8) Independent n_post vs live (rare-first / AND early-exit)

Host `route()` counts `nbeats(len(k0))+nbeats(len(k1))` (full occupancy). RTL two-pointer stops when a list is exhausted or emit-cap hits. Live `postB/16` vs that model:

| class | occ | host full beats | two-pointer visited beats | live n_post | G_NPOST |
|---|---:|---:|---:|---:|---:|
| direct | 6,8 | 4 | 4 | **4** | 4 |
| wrong_relation | 4,22 | **7** | **2** | **2** | 7 |
| high_occupancy | 20,22 | 11 | 10 | **10** | 11 |
| late_gold | 21,23 | 12 | 12 | **12** | 12 |
| overflow_page | 10,11 | 6 | 6 | 6 | 6 |
| high_id_sentinel | 10,7 | 5 | 5 | 5 | 5 |

**FACT:** live n_post equals two-pointer **visited** beats, not host full-drain, on every class. `wrong_relation` is the rare-first smoking gun: k0 occ=4, ∩={114} at k1 index 1; RTL fetched **2** posting beats and stopped; cap-then-AND / full-drain host wanted 7. TB does **not** bit-exact `n_post` vs `G_NPOST` (only emit IDs). Not a FAIL of the registered unknown. **Do not freeze `DDR_QUERY_BOUND_FINAL` from host `n_post` or from this XSim.**

late_gold must walk **both** lists to the end (254 last on both) ⇒ host=visited=live=12. That is the unknown.

### 9) RESULTS.md / CLOSEOUT.md vs raw (honesty hunt)

RESULTS CLASS table **MATCH** raw (`direct {110,144,145} tp=3 incomp=0`; `late_gold {254} LATE_GOLD_HIT CAP_THEN_AND_WOULD_MISS incomp=0`; distractor `leak_n=0 gold_n=10`; hoc emit_n=16 prec_all=62; unrelated empty-walk; wrong_context `NOT_SELECTIVE`). RESULT=`PASS_THIS_GATE_ONLY`. Explicitly **not** claimed: C1 800k, N4096 promotion, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`, BOARD_PASS, ACCEPT_BOARD.

CLOSEOUT MATCH raw: marker present, NEW RTL `14f75db7…`, KEEP intersect `a912786f…` not DUT, leftover not compiled, poke_v=0, KEY-INTERSECT GOLDEN 10:16:50 KEEP, N4096 KEEP, AXI-BEAT KEEP, `CAND_CAP_FINAL=NOT_FROZEN`, `C1_800K=OPEN`. LATE_GOLD indices 20/22 MATCH independent corpus.

Implementer prose that stream retrieves nid 254 that first16∩first16 misses, while direct still `{110,144,145}`: **HONEST vs raw and vs independent postings.** Hunt RESULTS-vs-xsim: **MISS.** Hunt 800k overclaim: **MISS as claim.**

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. Late gold on only one list | **MISS.** 254 ∈ p0 and p1; full ∩ = {254}; 16 k0-fillers k0-only; 16 k1-fillers k1-only. | Keep both-list index ≥16 as the scale stress. |
| 2. Merge still caps each list first | **MISS.** No buf0/buf1; CAND_CAP at emit; hoc emit 16 vs cap-then 12; WR live n_post=2 not 7; late postB=192 not 128. KEY-INTERSECT DUT not compiled. | Do not silent-patch KEEP intersect. |
| 3. SEARCH_INCOMPLETE used to PASS | **MISS.** Zero `SEARCH_INCOMPLETE` lines; `incomp=0` on late_gold and direct; TB FAILs gold miss even if incomp; marker gated on `late_hit`. | N=4096 same law **must** FAIL the bag if incomp on `gold_n>=1`. |
| 4. C0 dir patched | **MISS.** Live `09334e42…`; mtime 2026-09-05 19:31:03. git `M` vs HEAD is the historical C0 blob (same as 1115Z). | Do not edit `a7ng_sparse_dir_axi.sv`. |
| 5. Independent tree written | **MISS.** PLAN/EVIDENCE/recompute all ≤10:52:29; STREAM bag starts 11:39. | Keep that tree read-only. |
| 6. C1 800k / bounds / ACCEPT_BOARD | **MISS as claim.** Banner / PASS epilogue / RESULTS / CLOSEOUT / ACK / LOOP_STATE `c1_800k=OPEN`, bounds `NOT_FROZEN`, `BOARD_PASS=NOT_CLAIMED`. | Never grant. Never freeze from this bag. |
| 7. CAND_CAP default 64 vs TB 16 | **MISS as this-bag behavior** (TB override 16; banner 16; 16<256). **HIT as reuse caveat:** RTL source default remains 64. | Next bag must keep `.CAND_CAP(16)` until a named freeze. Default 64 is not `CAND_CAP_FINAL`. |
| 8. leftover A09 / poke_v=1 | **MISS.** leftover off xvlog/xelab/sdb; leftover file hash still `9fdbe0d6…`. poke_v held 0; no HOST_SEMANTIC_LEAK. | Keep off. |
| 9. Gold after FAIL / after xvlog | **MISS.** PRE 11:43:45; xvlog 11:43:59; gold still 11:43:45; no r0. | Do not regenerate gold. |
| 10. KEEP bags mutated | **MISS.** KEY-INTERSECT gold 10:16:50 `d3b5b883…`; N4096 all files ≤10:49:24 GOLDEN 10:46:42; AXI-BEAT max 11:11:09. | Leave all KEEP bags on disk (N4096 sentinel miss remains). |
| 11. RESULTS vs xsim / 800k | **MISS.** Table MATCH raw. RESULT=`PASS_THIS_GATE_ONLY`. | Authority = raw CLASS_* + LATE_GOLD_HIT + independent postings. |
| 12. Frozen / KEY-INTERSECT as DUT | **MISS.** sdb list is extract + relbind keys + gate + dir + mem + **stream** + TB. | Keep KEY-INTERSECT off xvlog. |
| 13. Hash theatre | **MISS** on listed gold/RTL paths (live MATCH PRE + SHA256.txt + C0 + KEEP DUT). | SHA256.txt 11:43:58 is the first-xvlog freeze. |
| 14. `reduction_x1000` as cap/N | **MISS.** `REDUCTION_X1000=NOT_EMITTED`. hoc prec_all=62 is TP/emit_n=1/16. | Do not carry 16/256 as Master ≥90%. |
| 15. CAP_THEN_AND_WOULD_MISS print tautology | **HIT as print path** (TB prints because `G_CAP_THEN_AND_MISS[10]=1`). **MISS as fact** (independent first16∩first16 = {} and 254 at 20 and 22). | Corpus postings are the proof, not the `$display`. |
| Host n_post not bit-exact to RTL | **HIT as measurement caveat, not law FAIL.** WR 7 vs live 2; hoc 11 vs live 10. Emit IDs bit-exact. | Do not freeze DDR bounds from host `n_post`. |
| Banner RARE_LIST_FIRST=1 is a constant | **HIT as print, not as a probe.** Independent WR n_post=2 MATCH visited-beats. | Keep rare-first as scheduler, not a second unknown. |
| Frozen dir AXI-idle instantiate | **HIT as hash-gate geometry, not as walker.** WO required instantiate; walker is the new AXI master. | Do not call idle dir “the merge”. |
| Direct prec=1000 is 3-id identity | **HIT as quality caveat.** Same as KEY-INTERSECT: PSC labels = k0∩k1. | Not Master ≥95%. |
| Index is `axi_mem_model`, not MIG | **HIT as bound.** Honest N=256 XSim. | Illegal as BOARD_PASS / 800k / DDR freeze. |
| RTL sets `acc_incomp` when emit-cap hits | **HIT as residual.** Mixes emit budget with SEARCH_INCOMPLETE. Not fired this bag (`incomp=0`). | At scale: gold miss must still FAIL; do not PASS on incomp. |
| wrong_context still NOT_SELECTIVE | **HIT as law, MISS as overclaim** (labeled). xid still not a key. | Do not fake ctx keys in the N=4096 stream bag. |

qstack-validation-adversary one-liner: **STREAM-INTERSECT XSim is a real N=256 named-law twin lock on unpatched C0 hashes: NEW walker `14f75db7…` is nid-sorted two-pointer AND with 1-beat pages and CAND_CAP-after-emit (not KEY-INTERSECT buf0/buf1 cap-then-AND); independent corpus puts nid 254 at k0 index 20 and k1 index 22 so first16∩first16 is empty while complete∩ then cap hits {254}; raw `LATE_GOLD_HIT id=254` `CAP_THEN_AND_WOULD_MISS stream_hit=1` `CLASS_late_gold incomp=0` and CLASS_direct `{110,144,145}` tp=3; leftover A09 off; poke_v=0; gold PRE 11:43:45 before xvlog 11:43:59; KEEP KEY-INTERSECT/N4096/AXI-BEAT unmodified; marker `ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS` present; that is not C1 800k, not N=4096, not a DDR/CAND freeze, and not ACCEPT_BOARD.**

---

## Logic bugs

No DUT vs host-twin **emit** mismatch (CAND lists match `G_EMIT`; CLASS lines match GOLDEN predicted late_gold tp=1 / direct {110,144,145}). Findings are **law-quality / promotion bounds**, not “patch frozen QSE” and not “fix TB packing”:

1. **Stream law is implemented as claimed on the both-valid path.** New named walker only. Frozen extract unpatched. Relbind keys instantiated not edited. Frozen dir instantiated AXI-idle. Two-pointer compare-and-advance; 1-beat `arlen=0`; rare-first fetch; CAND_CAP at emit. k2/k3 not probed. leftover A09 off. poke_v=0.
2. **Late gold is a real discriminator, not a one-list plant.** Independent postings: 254 at 20 and 22; first16∩first16={}; complete∩={254}; live emit={254} incomp=0. Fillers occupy prefixes without being AND hits.
3. **Direct control survived the corpus rebuild.** `{110,144,145}` still PSC and still k0∩k1. Distractor leak_n=0 on a 10-id excluded set (not the KEEP KEY-INTERSECT 11-id set; fill reservation). Polarity meter intact.
4. **hoc emit_n=16 vs KEY-INTERSECT emit_n=12** is the same operator split independent EVIDENCE already measured (∩-then-cap 16 vs cap-then-AND 12). Gold 147 is early — hoc is supporting evidence, not the registered unknown.
5. **Host AR-count twin is not bit-exact.** Full-occupancy `nbeats` overcounts when AND finishes early (WR 7→2; hoc 11→10). Emit IDs are the twin lock. Bytes are not this bag’s freeze.
6. **CAND_CAP default 64 in RTL source is a future-bag hazard**, not a this-bag cheat (TB 16). Do not freeze 16 as `CAND_CAP_FINAL`.
7. **Emit-cap sets `q_incomplete_o`.** Harmless here (`incomp=0`). At N=4096, if merge budget or emit cap dies before a declared gold, TB must FAIL — N4096 KEY-INTERSECT’s hole was PASS despite sentinel `SEARCH_INCOMPLETE`. Same hole is **forbidden** on the stream scale bag.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for N=256 XSim; illegal as C2 / production retrieval / 800k close.
9. **Frozen keys still omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`. Do not invent a context key inside N=4096 stream stress.
10. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.
11. **N=4096 KEEP still exhibits sentinel miss on `qse-v2-intersect-01`.** This bag does not repair that. Restart 256→4096 only from **this** stream law after ACCEPT_PARTIAL of this unknown.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0. Do not freeze DDR/CAND bounds. Do not start N=4096 stream in this audit.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 hashes, leftover off, poke_v=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Simulation only. Not DDR. Not 800k. |
| Stream law as claimed (two-pointer AND; 1-beat; rare-first; CAND_CAP after emit; not buf0/buf1 cap-then-AND) | **PASS_NARROW** | RTL S_NEXT + independent postings + WR n_post=2 + hoc emit 16 vs cap-then 12 + late postB=192. |
| Independent nid 254 at k0 index ≥16 **and** k1 index ≥16; first16∩first16 miss; complete∩ then cap hit | **PASS_NARROW** | idx 20 and 22; first16∩={}; stream={254}. |
| Registered unknown (`LATE_GOLD_HIT` **and** CLASS_direct `{110,144,145}` **and** incomp not hiding a miss) | **PASS_NARROW** | Raw `LATE_GOLD_HIT id=254` `incomp=0`; direct tp=3 `{110,144,145}`; marker present. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT honest vs raw. Do not promote as C1 800k or N=4096. |
| Master §7 retrieval quality / ≥95% / ≥90% reduction | **FAIL as Master close** | Direct 1000 is 3-id identity; hoc prec_all=62; context not in keys; reduction not emitted. |
| C1 800k / N=4096 promotion / `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED** | N4096 KEEP unedited (sentinel miss remains on the old law). This audit does not start N=4096 stream. |
| Gold-after-FAIL process | **PASS_NARROW** | PRE 11:43:45; xvlog 11:43:59; gold 11:43:45 KEEP `05c6e087…`; no r0. |
| KEEP KEY-INTERSECT + N4096 + AXI-BEAT + C0 hashes + intersect DUT | **UNMODIFIED** | Hashes + timestamps MATCH 1020Z/1115Z / C0. |
| Independent audit tree | **UNMODIFIED** | mtimes ≤10:52:29. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown only** (N=256 `qse-v2-stream-intersect-02`: late gold 254 at both-list index ≥16 hits; cap-then-AND would miss; direct `{110,144,145}` remains; leftover off; poke_v=0; C0 MATCH; gold-before-xvlog; KEEP unmodified; RESULT=`PASS_THIS_GATE_ONLY` honest). **REJECT** promotion of C1 800k, `DDR_QUERY_BOUND_FINAL`, `CAND_CAP_FINAL`, N=4096 scale, Master ≥95% recall, candidate-reduction ≥90%, BOARD_PASS. **Not** FAIL_LOOP (hashes real, C0 unpatched, gold not rewritten, 800k not claimed, walker is not cap-then-AND relabeled, PASS is honest, late gold is both-list). **Not** `ACCEPT_BOARD`.

**P1 for this unknown: none.** Parent **may** open N=4096 LATE-GOLD stress **SAME stream law** `qse-v2-stream-intersect-02` (one unknown: scale of merge, not prefix luck). Sentinel / late nid in gold **must FAIL the bag** if `SEARCH_INCOMPLETE` on a retrieve class with `gold_n>=1`. Not context keys. Not 65k dir. Not N=800k. This audit does **not** start that bag.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-STREAM-INTERSECT-02` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-KEY-INTERSECT-01` / `ASTRA-C1-N4096-INTERSECT-01` / `ASTRA-C1-AXI-BEAT-ACCOUNTING-01`. **Do not patch C0.** **Do not edit** `a7ng_query_axi_sparse_intersect.sv`. **Do not freeze** `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL` from CAND_CAP=16 or late_gold postB=192.

**P1 — none for this unknown** (late gold independently at k0 index 20 and k1 index 22; first16∩first16 miss; stream hit; direct `{110,144,145}`; incomp=0; walker is two-pointer not cap-then-AND).

**P2 — parent / next law / quality (do not treat as a license to freeze a DDR bound or silent-patch C0):**

1. **Keep this bag as PASS_THIS_GATE_ONLY evidence** of N=256 stream law. Authority = raw `LATE_GOLD_HIT` / `CLASS_direct` / `CLASS_late_gold incomp=0` + independent postings. Archive `qse-v2-intersect-01` at N=256; do not silent-patch it.
2. **If parent opens N=4096, SAME LAW `qse-v2-stream-intersect-02`.** One unknown: scale. Late / sentinel gold **must hit**. `SEARCH_INCOMPLETE` on `gold_n>=1` **FAILS the bag** (do not repeat N4096 KEY-INTERSECT’s marker-only PASS). Hash gold before xvlog. leftover A09 off. poke_v=0. PROGRAM=NO. C1 800k stays OPEN. This audit does **not** write that bag.
3. **Do not freeze `CAND_CAP_FINAL` or `DDR_QUERY_BOUND_FINAL`.** RTL default 64 is unused this bag; TB 16 is not FINAL. Host `n_post` overcounts AND early-exit. Index is `axi_mem_model`.
4. **Keep** the reporting machinery: `precision_all=TP/emit_n`; `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE`; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; KEY-INTERSECT DUT not compiled; frozen sparse not compiled; relbind keys instantiated not edited.
5. Next scale bag should instantiate `.CAND_CAP(16)` explicitly (do not rely on RTL default 64). If emit-cap must not set `SEARCH_INCOMPLETE`, that is a **named** contract tweak in the scale bag, not a silent patch of this PASS bag.
6. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `n4096_bag` stays KEEP_UNEDITED until parent opens a **new** stream-law N=4096 folder (do not edit the KEY-INTERSECT N4096 bag).
7. KEEP bags including KEY-INTERSECT gold 10:16:50, N4096 sentinel `SEARCH_INCOMPLETE` / emit_n=0, AXI-BEAT hoc 256/96/2666, R3 `leak_n=10`, and relbind `leak_n=9` stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown only: N=256 qse-v2-stream-intersect-02;
                         NEW RTL a7ng_query_axi_sparse_stream_intersect 14f75db7…;
                         two-pointer AND, 1-beat page, rare-first, CAND_CAP after emit;
                         NOT KEY-INTERSECT buf0/buf1 cap-then-AND;
                         LATE_GOLD nid 254 at k0 index 20 AND k1 index 22;
                         first16∩first16 = {}; complete∩ then cap = {254};
                         raw LATE_GOLD_HIT id=254 CAP_THEN_AND_WOULD_MISS stream_hit=1;
                         CLASS_late_gold emit={254} tp=1 rec=1000 incomp=0;
                         CLASS_direct emit={110,144,145} tp=3 prec_all=1000 incomp=0;
                         SEARCH_INCOMPLETE ABSENT (not used to PASS);
                         leftover A09 off; poke_v=0; C0 hashes MATCH;
                         gold 05c6e087… 11:43:45 PRE before xvlog 11:43:59;
                         KEEP KEY-INTERSECT d3b5b883… 10:16:50;
                         KEEP N4096 GOLDEN 10:46:42; KEEP AXI-BEAT max 11:11:09;
                         independent tree UNMODIFIED (≤10:52:29);
                         RESULT=PASS_THIS_GATE_ONLY honest;
                         CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL NOT_FROZEN)
PROMOTION        = REJECT  (not C1 800k, not DDR_QUERY_BOUND_FINAL,
                            not CAND_CAP_FINAL, not N=4096 closed,
                            not Master ≥95% recall, not Master ≥90% reduction,
                            not ACCEPT_BOARD)
FAIL_LOOP        = NO
P1_THIS_UNKNOWN  = NONE
PARENT_MAY_OPEN  = N=4096 LATE-GOLD stress SAME stream law
                   qse-v2-stream-intersect-02
                   (sentinel/late nid MUST FAIL bag if SEARCH_INCOMPLETE
                    on gold_n>=1; this audit did NOT start it)
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_800K          = OPEN
N_4096           = KEEP_UNEDITED (old law sentinel miss remains; not promoted)
STREAM_02_XSIM   = PASS_THIS_GATE_ONLY
                   marker ASTRA_C1_STREAM_INTERSECT_02_XSIM_PASS PRESENT
                   PID 56180; 16765 ns; 11:44:03–11:44:06
                   xsim.log SHA256 9091c5a78d1e67ffb1683bfee8fe029b17fc1b6e6b965a20d7d328a400084c14
                   LATE_GOLD_HIT id=254 incomp=0
                   CLASS_direct {110,144,145} tp=3 incomp=0
                   fail_r0 ABSENT; FIRST_DIVERGENCE ABSENT; SEARCH_INCOMPLETE ABSENT
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 11:43:45; PRE MATCH live;
                                no r0; PASS session
DUT_STREAM       = NEW          14f75db7… mtime 11:43:39; two-pointer; arlen=0
DUT_INTERSECT    = UNEDITED     a912786f… mtime 10:13:02; NOT compiled as DUT
C0_PATCH         = MISS
CAND_CAP         = 16 this bag (RTL source default 64 overridden by TB; NOT FINAL)
KEY_INTERSECT_KEEP = UNMODIFIED d3b5b883… / f1611917… / e8b4f8ea…  10:16:50
N4096_KEEP       = UNMODIFIED   GOLDEN 10:46:42; bag files ≤ 10:49:24
AXI_BEAT_KEEP    = UNMODIFIED   GOLDEN 10:16:50; bag max 11:11:09
INDEP_TREE       = UNMODIFIED   PLAN/EVIDENCE ≤ 10:52:29
LEFTOVER_A09     = not compiled
POKE_V           = 0
NID_254_K0_IDX   = 20  (>=16)   EVIDENCE from corpus.json records
NID_254_K1_IDX   = 22  (>=16)
FIRST16_AND      = {}           would miss
STREAM_AND_CAP   = {254}        hits
BOTH_LISTS       = YES
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 stream in this audit.
