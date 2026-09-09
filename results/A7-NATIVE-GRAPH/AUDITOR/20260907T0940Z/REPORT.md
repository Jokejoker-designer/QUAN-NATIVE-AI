# ASTRA auditor REPORT — 20260907T0940Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-N256-R3-DISTRACTOR-01
KEEP       = ASTRA-C1-N256-ROLE-RETRIEVAL-01 (must be unmodified; verified)
           + ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01 (must be unmodified; verified)
PRIOR_P1   = results/A7-NATIVE-GRAPH/AUDITOR/20260907T0915Z/REPORT.md
           ACCEPT_PARTIAL (reporting only); P1 distractor = EXCLUDED set
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256.txt
           WO .agents/handoff/ASTRA-C1-N256-R3-DISTRACTOR-01.md
EVIDENCE   = raw xsim.log CLASS_* / FAIL DISTRACTOR_LEAK / NOT_SELECTIVE /
             UNRELATED_EMPTY_WALK / ASTRA_C1_N256_R3_XSIM_NO_MARKER
           + xsim_fail_r0.log (byte-identical copy of this xsim.log)
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold vs first xvlog/xsim; KEEP bags vs 0840Z/0915Z)
           + tb_astra_c1_n256_r3.sv (poke_v, leftover A09, G_GOLD_EXCLUDED, leak scoring)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_r3.py
           + run_xsim.ps1 (PASS-marker gate; leftover gate; SHA freeze; fail_r0 copy)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = NOT STARTED (this audit does not start it)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit either KEEP bag, did not write a V3.1 tree, did not patch C0 hashes, and did not spawn agents. Only this file is written.

---

## Scope

Read-only except this file.

Primary object: C1 N=256 **R3** entity-context distractor **excluded-set polarity** bag after auditor `20260907T0915Z` P1.

`results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R3-DISTRACTOR-01/`

Master §7 primary unknown (full C1): can the frozen role-aware query law retrieve relevant evidence selectively and with bounded traffic through the real index law up to 800,000 records?

This bag is the **N=256 distractor-polarity rung only**. It cannot close C1 800k. It cannot start N=4096. It cannot close Master evidence-recall ≥95% or candidate-reduction ≥90% (those apply at N≥4096 / 800k).

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/` including `fail_r0` and the post-fail gold rewrite
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01/` (reporting bag; distractor gold was retrieve-subset `{72…75}`)

**Not** this bag: C1 800k, N>256, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, historical `ASTRA-02-U5` as C1, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys.

Hunt (dispatch, none dropped):

1. `reduction_x1000` appearing as cap/N (`1-CAND_CAP/N`)
2. occupancy fillers treated as the precision story (vs `fp_ev1` / `fp_fill0` split)
3. distractor polarity: excluded set vs retrieved subset; leak scored as `FAIL DISTRACTOR_LEAK` not `tp`/`rec=1000`
4. unrelated 0/0 scored 1000/1000 vs `UNRELATED_EMPTY_WALK`
5. wrong_context k0–k3 / emit vs direct labeled as recall win vs `NOT_SELECTIVE`
6. gold regenerated after FAIL; gold LastWriteTime after first xvlog
7. frozen RTL patched vs C0 hashes
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. KEEP prior bags SHA/timestamps changed (R1 and R2)
10. RESULTS.md / CLOSEOUT.md vs raw `xsim.log` (implementer claimed FAIL — honesty vs overclaim of “law cannot exclude”)
11. C1 800k closed / N=4096 started / `ACCEPT_BOARD`
12. excluded set still a tautology of the same posting; `leak_n` manufactured
13. query reused `"supply duct"` + gold `{72,73,74,75}`
14. `ASTRA_C1_N256_R3_XSIM_PASS` emitted despite `leak_n>0`
15. FAIL is TB packing (`ROLE_COLLAPSE`) vs frozen four-table union (k2/k3 no relation)

Master §7 line that this bag is graded against:

> Report precision per class; do not substitute recall alone for retrieval quality.

Required class name (Master §7, distinct from “direct relevant”):

> entity-context distractor

0915Z P1 item 3 + WO: gold = entity-context records that **must be excluded**; presence in emit = `FAIL DISTRACTOR_LEAK` (fp, never tp). PASS distractor only if `leak_n=0` and `gold_n>=1`. Do not reuse `"supply duct"` + `{72…75}`. Suggested target: `"pump supplies chiller"`.

Master §7 FAIL routing (this bag’s law-exclusion FAIL):

```text
do not lower threshold
do not relabel relevant=set(router_union)
do not use nid-derived keys
return to index/key architecture only
```

If leak is frozen four-table union (k2/k3 no relation): **Required fix = NEW named key/index law id**. Do not silently patch C0.

This bag **may** `ACCEPT_PARTIAL` of **scoring polarity only** without closing Master exclusion, ≥95% recall, C1 800k, or N=4096. Never `ACCEPT_BOARD`.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. R3 bag is untracked (`??`). KEEP R1 and KEEP R2 are untracked (`??`). `PROGRAM=NO` this process and this bag (no bit, no JTAG, no COM12).

`LOOP_STATE.json` `updated=2026-09-07T09:40:00+07:00` `acceptance=PENDING_AUDITOR_C1_N256_R3` `implementer=DONE_FAIL` `c1_800k=OPEN` `n4096=NOT_STARTED` `auditor=IN_PROGRESS` `final_promotion=REJECT`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), R3 bag:

```text
09:19:21.999  PREREG.md ACK.json
09:21:38.223  host_astra_c1_r3.py
09:23:59.945  tb_astra_c1_n256_r3.sv
09:23:59.946  run_xsim.ps1
09:24:14.175  corpus.json
09:24:14.176  GOLDEN.json
09:24:14.177  query_gold.svh
09:24:14.178  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xvlog
09:24:36.099  SHA256.txt                  ← freeze immediately before first xvlog
09:24:37.224  xvlog.log
09:24:39.658  xelab.log
09:24:43.190  xsim.log                    PID 45168  NO_MARKER / DISTRACTOR_LEAK
09:24:43.190  xsim_fail_r0.log            byte-identical copy of xsim.log
09:26:23.833  RESULTS.md CLOSEOUT.md
```

Single XSim session. No second xvlog. Gold files were **not** rewritten between 09:24:14 and 09:26:23. Hunt 6 as gold-after-FAIL: **MISS**.

`xsim.log` SHA256 `f953c42001632d12c52e362ad77cf929361940dd9e38e731bb6d55119705513a` **equals** `xsim_fail_r0.log` SHA256 (same length 9533 bytes, same LastWriteTime). `run_xsim.ps1` copies `xsim.log` → `xsim_fail_r0.log` when PASS marker is missing or `FAIL DISTRACTOR_LEAK` is present. This r0 is **DISTRACTOR_LEAK on the first (only) session**, not a packing `ROLE_COLLAPSE` followed by a gold rewrite (contrast KEEP R1 `fail_r0` 08:30:38 then gold 08:31:44).

### 2) Live SHA256 vs bag lists vs C0

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time.

**GOLD_HASH_PRE_XVLOG.txt vs live (all MATCH):**

```text
96f445a9dbff7759a63cbc00032c8ca359a78f1a15649254129f9cffdcc5ea9a  GOLDEN.json
a0d993117e538b4847cd9a4bfa520824e9d8cc0ba1f432556b44a18cfdd7de47  query_gold.svh
0ce3bfffafa319891fd628c65070f00aff3c05bf954cfcb854f3a6b75f1428cf  corpus.json
```

**SHA256.txt frozen-RTL / compiled / bag gold / BAG lines vs live: all MATCH.** No invented hash.

C0 `SHA256.txt` vs live (C1 R3 must not patch these):

| Object | C0 | Live | Match |
|---|---|---|---|
| `a7ng_query_role_extract.sv` | `cd7baf49…` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` | YES |
| `qse_role_lexicon.svh` | `38189974…` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` | YES |
| `a7ng_sparse_dir_axi.sv` | `09334e42…` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` | YES |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d…` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` | YES |
| `a7ng_route_valid_gate.sv` | `49a66da2…` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` | YES |
| leftover `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES (not compiled) |

Hunt **frozen RTL patched**: **MISS vs C0 hashes.** `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD (working tree is the C0-hashed `09334e42…` blob, same finding as 0840Z/0915Z). Role-extract / lexicon / `query_axi_sparse` remain untracked at HEAD and MATCH C0. R3 did not retouch them.

TB / host / PREREG / ACK / `run_xsim.ps1` hashes MATCH the `SHA256.txt` `# BAG` / `# COMPILED` lines.

### 3) KEEP prior bags unmodified

0915Z / 0840Z recorded gold hashes and timestamps. Live KEEP:

**R1 `ASTRA-C1-N256-ROLE-RETRIEVAL-01`:**

```text
414f9952583084e3e7c25b1c1e70a6bc1c3dca28e235291f6476f968a66b95b7  GOLDEN.json     MATCH 0840Z/0915Z
4b61d88f56ccfd9186ed104602d3b914741190ce3b58cb8da5da7d74779c3dfd  query_gold.svh  MATCH 0840Z/0915Z
8c342aa23afdbfc8da7f253ee235ccde3a0d0beec40a3cbcdb4e3a487bd22f34  corpus.json     MATCH 0840Z/0915Z
```

LastWriteTime KEEP R1 (still): gold 08:31:44; `xsim_fail_r0.log` 08:30:38; `xsim.log` 08:32:01; RESULTS/CLOSEOUT 08:37:00. Identical to the 0840Z/0915Z timestamp table.

**R2 `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01`:**

```text
e2091bac49f95c85d49032ca01ba76d350ec0e4e15cb0b88708e11ebfbb84fa1  GOLDEN.json     MATCH 0915Z
181958becf400bf6242304831dc66b649ff84a7358476dd2b325703d78f45d70  query_gold.svh  MATCH 0915Z
a089afda975efd1717c7458b3d02ca701514b03726e31919e1ecbd140d172198  corpus.json     MATCH 0915Z
```

LastWriteTime KEEP R2 (still): gold 08:59:20; `run_xsim.ps1` 09:00:11; SHA256.txt 09:00:24; `xsim.log` 09:00:29; RESULTS/CLOSEOUT 09:01:39. Identical to the 0915Z timestamp table.

Hunt 9: **MISS** (neither KEEP bag edited).

### 4) Raw xsim (PID 45168) and fail_r0

`xsim.log` PID 45168, session Mon Sep 7 09:24:40–09:24:43, `$finish` 16695 ns. Banner:

```text
C1_R3_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW_SEL=1 POKE_V=0 REDUCTION_X1000=NOT_EMITTED
```

Named lines (authority = this log, not RESULTS):

```text
CLASS_direct gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=766 k3=4408 vs_direct k0=2561 k1=257 k2=766 k3=4408 keys_match=1 emit_match=1 frozen_law=xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
FAIL DISTRACTOR_LEAK leak_n=10 emit_n=16 fp_ev1=16 fp_fill0=0 gold_n=11
CLASS_distractor gold_n=11 emit_n=16 leak_n=10 tp=0 fp_ev1=16 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_undef=1 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0 gold_polarity=excluded
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
ASTRA_C1_N256_R3_XSIM_NO_MARKER fail=1 dist_gold_ok=1 dist_excl_ok=1 dist_no_leak=0 unrelated_empty=1 wc_not_sel=1
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

`ASTRA_C1_N256_R3_XSIM_PASS` count = **0** in `xsim.log` and in `xsim_fail_r0.log`. Hunt 14: **MISS** (marker correctly ABSENT).

No `FIRST_DIVERGENCE`. No `ROLE_COLLAPSE`. No `SEARCH_INCOMPLETE`. No `HOST_SEMANTIC_LEAK`. No `reduction_x1000=<digit>`. Ten named `CLASS_*` markers present. `UNRELATED_EMPTY_WALK` present. `NOT_SELECTIVE` present with `keys_match=1 emit_match=1`. `FAIL DISTRACTOR_LEAK` present. `rec_undef=1` on distractor (not `rec_x1000=1000`). `tp=0` on distractor.

`xsim_fail_r0.log` is the same bytes. Contrast KEEP R1 r0 (`ROLE_COLLAPSE` at QSE, no CLASS lines). R3 r0 is **law-exclusion FAIL with walker twin locked**, not a TB packing fail.

TB emits `ASTRA_C1_N256_R3_XSIM_PASS` only if `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel` (`tb` lines 438–445). `dist_no_leak` is set only when `leak_n==0`. Raw `dist_no_leak=0` + `fail=1` matches `leak_n=10`.

### 5) TB: poke_v, leftover A09, load_from_tb, scoring polarity

`tb_astra_c1_n256_r3.sv`:

- Instantiates frozen QSE + `a7ng_query_axi_sparse` with `.poke_v_i(poke_v)` and `pk*`/`pv*` tied to 0.
- `poke_v = 0` at reset; **never assigned 1** (no `poke_v <= 1` / `poke_v = 1` in the file). Diverge `HOST_SEMANTIC_LEAK` if `poke_v !== 0`.
- No `load_from_tb` net. Index image is TB write of `u_mem.mem[G_WR_I[i]] = G_WR_D[i]` (AXI mem model). Queries are token bytes (`G_BYTES` LSB-first `bytes[8*bi +: 8]`).
- `` `include "query_gold.svh" `` only. No `` `include "tb_ng03_a09_score_task.svh" ``.
- `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` — 16 < 256, not taken.
- Startup: `G_NREL[5] < 1` → `DISTRACTOR_EMPTY_GOLD`; `G_GOLD_EXCLUDED[5] !== 1` → `DISTRACTOR_POLARITY`. Both passed (`dist_gold_ok=1 dist_excl_ok=1`).
- Unrelated (`qi==6`): diverge if `n_got != 0`; print `UNRELATED_EMPTY_WALK`; **do not** score 0/0 as 1000/1000.
- wrong_context (`qi==4`): print `NOT_SELECTIVE` + k0–k3 vs direct + `keys_match` + `emit_match`.
- Precision split is live on retrieve classes: `fp_fill0` if `G_EVIDENCE[id]==0` else `fp_ev1`.
- Bit-exact `got[i] === G_EMIT[qi][i]` (host walker twin) **and** independent `G_RELEVANT` for P/R.
- **Distractor scoring is inverted vs R2:** `G_GOLD_EXCLUDED[5]=1`; `G_RELEVANT[5]` is the excluded set. Hits increment `leak_n`, never `tp`. `rec_x1000 = -1` (`rec_undef=1`). If `leak_n>0`: print `FAIL DISTRACTOR_LEAK`, `fail = fail + 1`. CLASS line prints `tp=0` `gold_polarity=excluded`.

`xvlog.log` analyzed **only**:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse.sv
tb_astra_c1_n256_r3.sv
```

`xelab.log` compiled the same modules. `xsim_work/xsim.dir/work/*.sdb` has those six + TB. **No** `a7ng_astra_09_integ_path`. Hunt leftover A09 compiled: **MISS.**

`run_xsim.ps1` DUT list matches xvlog; leftover filename on the list throws; xvlog text matching leftover throws; `reduction_x1000=[0-9]` throws; missing PASS marker or `FAIL DISTRACTOR_LEAK` copies r0 and throws `C1R3_XSIM_FAIL_OR_MARKER_MISSING`.

### 6) Distractor polarity (P1 item 3) — RAW gold vs Master class

Host (`host_astra_c1_r3.py`) `queries_spec` class `distractor`:

```text
text = "pump supplies chiller"     # same tokens as CLASS_direct; NOT "supply duct"
pred = pred_excl                   # two-role overlap; PSC excluded from gold
```

`pred_excl`: evidence=1 records that share two of `{subj=pump=10, rel=supplies=1, obj=chiller=1}` and mismatch the third. `pred_psc` (all three) is the retrieve set, **not** in excluded gold. Computed **before** `route()`. `GOLDEN.json` `"relevant_is_router_union": false`. `"distractor_gold_polarity": "excluded"`. `"distractor_not_supply_duct": true`.

`query_gold.svh`:

```text
G_LEN[5]            = 21
G_BYTES[5]          = same 384-bit pack as G_BYTES[0]
                      LSB-first decode = "pump supplies chiller"  (char0='p')
G_SUBJ/REL/OBJ[5]   = 10 / 1 / 1
G_K0..K3[5]         = 2561, 257, 766, 4408   (all valid; same as direct)
G_GOLD_EXCLUDED     = '{0,0,0,0,0,1,0,0,0,0}
G_NREL[5]           = 11
G_RELEVANT[5]       = {99,108,109,111,114,118,121,132,193,214,235}
                      NOT {72,73,74,75}
G_EMIT[5]           = {108,109,110,111,144,145,99,121,132,193,214,235,112,113,114,115}
                      identical to G_EMIT[0] (same query tokens)
```

Independent re-derive from live `corpus.json` (256 records, law `qse-v2-role-00`):

| nid | s,r,o | text | two-role tag |
|---:|---|---|---|
| 108 | 10,1,11 | pump supplies valve | WO |
| 109 | 10,1,12 | pump supplies sensor | WO |
| 111 | 10,1,2 | pump supplies condenser | WO |
| 114 | 10,2,1 | pump requires chiller | WR |
| 118 | 10,3,1 | pump connects chiller | WR |
| 99 | 9,1,1 | tower supplies chiller | WE |
| 121 | 11,1,1 | valve supplies chiller | WE |
| 132 | 12,1,1 | sensor supplies chiller | WE |
| 193 | 2,1,1 | condenser supplies chiller | WE |
| 214 | 3,1,1 | evaporator supplies chiller | WE |
| 235 | 4,1,1 | compressor supplies chiller | WE |

PSC retrieve (NOT in excluded gold): `{110,144,145}` = `pump supplies chiller` / `… water` / `… indirectly`.

Live `xsim.log` `EMIT_distractor` CAND ids = `{108,109,110,111,144,145,99,121,132,193,214,235,112,113,114,115}` (all `ev=1`).

Independent leak:

```text
excluded ∩ emit = {108,109,111,99,121,132,193,214,235,114}     leak_n=10
excluded \ emit = {118}                                        trunc=4 (pump connects chiller)
emit \ excluded = {110,144,145,112,113,115}                    PSC retrieve + one-role pump-requires-*
```

MATCH raw `FAIL DISTRACTOR_LEAK leak_n=10 gold_n=11` and GOLDEN `leak_ids`. Leaks counted as fp, **never tp**. `rec_x1000=1000` was **not** printed on this class.

Query is **not** `"supply duct"`. Gold is **not** `{72,73,74,75}` (those nids still exist in corpus as duct facts; they are not this class’s gold). Hunt 13: **MISS**.

Polarity vs 0915Z OVERCLAIM: **inverted correctly.** Letter of WO (`gold_n>=1` excluded; leak=FAIL; not supply-duct retrieve-subset) is met. Spirit of Master class name (entity-context distractor as a **negative** set) is met **as scoring**. Exclusion by the frozen law is **not** met (`leak_n=10`).

### 7) Tautology / manufactured-leak hunt (dispatch 12)

**Scoring tautology (R2 shape):** gold = posting prefix scored `tp`/`rec=1000`. R3 does **not** do this. Gold is a label predicate (`pred_excl`) computed before `route()`. Host checks `set(relevant) != set(emit)` and `direct ∩ distractor gold = ∅`. One-role emit ids `{112,113,115}` (`pump requires valve/sensor/condenser`) are in the walk and **not** in gold — gold is not `emit \ {PSC}`. Excluded nid 118 is in gold and **not** in emit — gold is not “whatever leaked.” Hunt **manufactured leak_n**: **MISS.**

GOLDEN.json already contains `leak_n=10` / `DISTRACTOR_LEAK=true` at 09:24:14, **before** first xvlog. That is the host walker twin predicting the frozen-law intersection, then hashing gold, then simulating. It is not a post-fail gold edit. Host `main()` refuses to regenerate if `xsim.log` / `xvlog.log` / `xsim_fail_r0.log` exist.

**Same-posting identity (law, not scoring):** distractor query tokens ≡ direct query tokens, so `G_EMIT[5] ≡ G_EMIT[0]`. Occupancies `[6,9,14]`, `n_dir=3`, `n_post=6`, `trunc=4` are the four-table walk of `"pump supplies chiller"` stopping at `CAND_CAP=16` after k0/k1/k2 (k3 not probed). Composition:

```text
k0=2561 (subj+rel, no object) occ=6  → 108,109,110,111,144,145     pump supplies *
k1=257  (obj+rel,  no subject) occ=9  → 99,121,132,193,214,235      * supplies chiller
k2=766  (subj cue, no relation) occ=14 → 112,113,114,115 (+trunc)   pump * *
k3=4408 (obj cue,  no relation)         not walked (cap already full)
```

Two-role-overlap nids that sit in those posting heads **must** leak under this frozen key law. That is CONFIRMED_ROOT_CAUSE for `leak_n=10`, not a TB packing bug (walker bit-exact; no `ROLE_COLLAPSE`; gold not rewritten). It is also **not** a reason to score those leaks as TP.

Hunt 12 as “excluded set is the posting itself”: **MISS as gold definition** (independent two-role labels; 118 held out of emit; 112/113/115 in emit but not gold). **HIT as law identity:** the distractor class re-scores the **same** four-table union as CLASS_direct. That is the intended P1 shape (same target query, inverted gold), not a new retrieval.

### 8) Precision split, reduction, wrong_context, unrelated

**fp_ev1 vs fp_fill0:** present on every CLASS line except unrelated (named empty-walk). Direct: `fp_ev1=13 fp_fill0=0 prec_ev1=187=prec_all`. Direct/distractor emit ids are all `ev=1`. Low direct precision is four-table cue-union (k0 no object, k1 no subject, k2/k3 no relation), not occupancy fillers. RESULTS states that. Distractor `fp_ev1=16` is **all** emit ids (tp forced 0 under excluded polarity), including PSC `{110,144,145}` — correct for this class, not a retrieve-class precision number.

wrong_relation / high_occupancy / overflow / high_id: `prec_ev1 != prec_all` where fillers exist. Split is real.

**reduction_x1000 as cap/N:** **MISS as emitted metric.** Banner and close print `REDUCTION_X1000=NOT_EMITTED`. No `reduction_x1000=<integer>`. GOLDEN per-query field is the string `"NOT_EMITTED"`. Do not read 16/256 as Master ≥90% (that bound is N≥4096).

**unrelated:** `UNRELATED_EMPTY_WALK gold_n=0 emit_n=0`. Host `prec_all is None and recall is None`. Not 1000/1000. **PASS** as named check.

**wrong_context:** `NOT_SELECTIVE` with k0–k3 identical to direct (`2561,257,766,4408`) and `emit_match=1`. Frozen qse-v2: xid is not a directory key (parent triage; do not invent a new key law **for context** in this bag). CLASS still prints `rec_x1000=1000`; RESULTS does **not** call that a context-selectivity win. Labeling requirement: **PASS**. Selectivity of the frozen law: still **NOT_SELECTIVE** (expected).

### 9) RESULTS.md / CLOSEOUT.md vs raw xsim.log (honesty hunt)

RESULTS CLASS table numbers **MATCH** `xsim.log` exactly (gold_n / emit_n / tp / leak_n / fp_ev1 / fp_fill0 / prec_ev1 / prec_all / rec / notes). No invented P/R. Discloses `C1_800K=OPEN`, `BOARD_PASS=NOT_CLAIMED`, `REDUCTION_X1000=NOT_EMITTED`, KEEP bags not edited, gold not regenerated, PASS marker NOT emitted.

Implementer `RESULT = FAIL` / CLOSEOUT `RESULT = FAIL` / `ASTRA_C1_N256_R3_XSIM_PASS NOT emitted` / `LEAK_N = 10` / `DISTRACTOR_TP = 0` / `DISTRACTOR_REC = undef`: **HONEST vs raw.** `LOOP_STATE.json` `implementer=DONE_FAIL` is consistent. This is not a PASS_THIS_GATE_ONLY overclaim.

Split in RESULTS “Unknown”:

- Scoring polarity: **yes** — MATCH raw (`gold_polarity=excluded`, `tp=0`, `rec_undef=1`, `FAIL DISTRACTOR_LEAK`, query `"pump supplies chiller"`, gold ≠ `{72…75}`).
- Frozen-law exclusion: **no** (`leak_n=10`) — MATCH raw. Gate requires `leak_n=0` for `PASS_THIS_GATE_ONLY`. Therefore FAIL.

“Leak is the frozen four-table union emitting excluded overlapping evidence=1 nids, not a TB packing bug”: **CONFIRMED** (twin-lock; r0 ≡ xsim; no `ROLE_COLLAPSE`; k0/k1/k2 composition above). This is a **measurement at this corpus/cap/law**, not a theorem that no future named law can exclude.

Hunt **overclaim of “law cannot exclude” as a close / as an excuse to skip a new law / as PASS**: **MISS.** Implementer did not claim `PASS_THIS_GATE_ONLY`, did not emit the PASS marker, did not drop threshold, did not set `relevant=router_union`, did not patch C0, and did not start N=4096. RESULTS explicitly lists `PASS_THIS_GATE_ONLY` and `ASTRA_C1_N256_R3_XSIM_PASS` under **Not claimed**.

Do not read RESULTS “Scoring polarity: yes” as P1-complete gate close. Polarity is the ACCEPT_PARTIAL slice. Exclusion remains FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. `reduction_x1000` as cap/N | **MISS.** Not emitted as a number. | Do not carry 16/256 into N=4096 as candidate-reduction. |
| 2. occupancy fillers as the precision story | **MISS as RESULTS prose** (direct fp_fill0=0 fp_ev1=13 stated). **HIT as quality:** rec=1000 on 1–3 retrieve-class gold ids inside cap is still not Master retrieval quality. | Precision 62–187/1000 on gold>0 retrieve classes; distractor prec_ev1=0 under excluded polarity. |
| 3. distractor polarity (P1-3) | **MISS as OVERCLAIM.** Gold is excluded set gold_n=11; tp=0; rec_undef; FAIL DISTRACTOR_LEAK leak_n=10; not rec=1000 on excluded ids. | Scoring polarity **PASS_NARROW**. Law exclusion **FAIL**. |
| 4. unrelated 0/0 = 1000/1000 | **MISS.** `UNRELATED_EMPTY_WALK`. | Keep named; do not reintroduce 1000/1000. |
| 5. wrong_context rec=1000 as selectivity | **MISS as claim** (`NOT_SELECTIVE` + RESULTS). **HIT as law:** keys_match=1 emit_match=1. | Do not patch C0 to chase context keys. |
| 6. gold after FAIL / after first xvlog | **MISS** on GOLDEN / svh / corpus (09:24:14; PRE hashes MATCH live). r0 is copy of the same FAIL session, not a packing-then-rewrite. | Do not regenerate gold. New labels ⇒ new named bag. |
| 7. frozen RTL patched | **MISS vs C0 live hashes.** | Do not silently patch QSE/dir to paper over leak_n. |
| 8. leftover A09 compiled / poke_v=1 | **MISS.** poke_v held 0; leftover off xvlog/xelab/sdb. | Keep off. |
| 9. KEEP bags mutated | **MISS.** R1 gold 414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps. R2 gold e2091bac / 181958be / a089afda + 0915Z timestamps. | Leave both KEEP bags including R1 fail_r0. |
| 10. RESULTS vs xsim numbers / FAIL honesty | **MISS** (table MATCH; RESULT=FAIL honest). **MISS** as “law cannot exclude” overclaim used to skip FAIL or skip a new law id. | Authority = raw CLASS_* + polarity/exclusion split above. |
| 11. C1 800k / N=4096 / BOARD_PASS | **MISS as claim.** | Never grant. Never start N=4096 from this audit. |
| 12. excluded = posting tautology; leak_n manufactured | **MISS as scoring cheat** (independent two-role labels; 118 not in emit; 112/113/115 in emit not gold; GOLDEN leak predicted before xvlog). **HIT as law identity** (same four-table union as direct). | Do not treat leak_n=10 as a TB bug. |
| 13. reuse `"supply duct"` + `{72…75}` | **MISS.** Query `"pump supplies chiller"`; gold 11 two-role nids. | Do not revert to R2 retrieve-subset. |
| 14. PASS marker despite leak | **MISS.** `ASTRA_C1_N256_R3_XSIM_PASS` ABSENT; `NO_MARKER fail=1 dist_no_leak=0`. | Keep marker gated on leak_n=0. |
| 15. FAIL is TB packing vs four-table union | **FAIL = frozen four-table union**, not TB-bug. r0 ≡ xsim; no ROLE_COLLAPSE; walker bit-exact. | Required fix = NEW named key/index law id. Not a pack fix. Not a C0 silent patch. |
| Hash theatre | **MISS** on listed gold/RTL paths (live MATCH). PRE attests gold-before-first-xvlog. | SHA256.txt 09:24:36 is the first-xvlog freeze. |
| `relevant=router_union` | **MISS** on `G_RELEVANT` / GOLDEN relevant. | `G_EMIT` is walker twin oracle (bit-exact), not the label set. |
| cap≥N selectivity | **MISS.** CAND_CAP=16 < 256. | Instantiated 16 ≠ `CAND_CAP_FINAL`. |

qstack-validation-adversary one-liner: **R3 XSim is a real token-stream + sparse-dir twin lock at N=256 on C0 hashes that honestly inverts distractor gold to the excluded set and FAILs DISTRACTOR_LEAK leak_n=10 tp=0 rec_undef; it is not Master entity-context *exclusion*, not selective retrieval, not a TB packing bug, and not a license to silently patch C0 or drop threshold.**

---

## Logic bugs

No DUT vs host-twin mismatch (emit lists match `G_EMIT`; CLASS lines match GOLDEN predicted leak). Findings are **index-law quality / FAIL routing**, not “patch frozen QSE in this bag” and not “fix TB packing”:

1. **Scoring polarity is correct.** Excluded gold, leak=FAIL, tp=0, rec_undef, query `"pump supplies chiller"`, gold_n=11≥1. This is the 0915Z P1 item 3 fix as a **meter**.
2. **Frozen four-table union cannot honor two-role exclusion.** k0 has no object (wrong-object WO leaks). k1 has no subject (wrong-entity WE leaks). k2 has no relation (wrong-relation WR 114 leaks; 118 truncated). Direct `prec_ev1=187/1000` with 13 EV1 FPs is the same law, now also visible as `leak_n=10/11`. CONFIRMED_ROOT_CAUSE = frozen key/index law, not TB.
3. **Master §7 FAIL routing applies.** Do not lower threshold. Do not relabel `relevant=router_union`. Do not use nid-derived keys. Return to **index/key architecture only** via a **NEW named law id**. Do not silently patch C0 hashes `cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
4. **Frozen keys omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`; still not context-selective. Do not invent a context key inside this FAIL bag.
5. **Recall 1.0 on retrieve classes is posting-order of a 1–4 id gold set inside cap**, with trunc dropping other ids. Not ranking quality. Not this bag’s unknown; still not Master ≥95%.
6. **Index is `axi_mem_model`**, not MIG/DDR. Honest for N=256 XSim; illegal as C2 / production retrieval.
7. **fail_r0 is the polarity FAIL itself**, not a packing theatre. Gold hashed once before that session. Not FAIL_LOOP.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 hashes, leftover off, poke_v=0, n_host=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge) | **PASS_NARROW** | Bit-exact to host walker on frozen C0 files. Simulation only. Not DDR. Not 800k. FAIL is `DISTRACTOR_LEAK`, not `ROLE_COLLAPSE`. |
| Scoring polarity (excluded gold, leak=FAIL not tp, rec_undef, gold_n=11, query `"pump supplies chiller"`, not `{72…75}`, PASS marker ABSENT) | **PASS_NARROW** | This is what R3 was opened to invert vs 0915Z P1-3 OVERCLAIM. |
| Frozen-law entity-context **exclusion** (`leak_n=0`) | **FAIL** | `leak_n=10/11`. Four-table union (k2/k3 no relation). **Not a TB bug.** |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_N256_R3_XSIM_PASS` | **NOT CLAIMED / ABSENT** | Implementer RESULT=FAIL is honest. Do not promote polarity-only as gate PASS. |
| Master §7 retrieval quality at N=256 (precision per class; distractor exclusion; ≥95% evidence recall) | **FAIL** | prec 62–187/1000 on retrieve classes; leak_n=10; recall substituted if used as quality; context not in keys. |
| C1 800k / N=4096 / `CAND_CAP_FINAL` / BOARD_PASS / ACCEPT_BOARD / U5 | **NOT CLOSED** | Do not start N=4096 from this audit. |
| Gold-after-FAIL process (R3) | **PASS_NARROW** | Gold 09:24:14; PRE MATCH; r0 is copy of first FAIL; host refuses regen. |
| KEEP R1 + KEEP R2 | **UNMODIFIED** | Hashes + timestamps MATCH 0840Z/0915Z. |

Promotion scale: **ACCEPT_PARTIAL** of **scoring polarity only**. **REJECT** promotion of C1 rung-close, Master distractor *exclusion*, Master ≥95% recall, candidate-reduction ≥90%, C1 800k, and any step to N=4096. **Not** FAIL_LOOP (hashes are real, RTL unpatched vs C0, gold not rewritten after FAIL, 800k not claimed, FAIL is honest, polarity meter is real). **Not** `ACCEPT_BOARD`.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-N256-R3-DISTRACTOR-01` gold/xsim/RESULTS to “clean” this audit. **Do not edit** KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` or `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01`.

**P1 — law-exclusion FAIL is frozen four-table union. Required fix = NEW named key/index law id. Do not silently patch C0. Do not start N=4096.**

1. **Keep the polarity meter.** Do not revert gold to a retrieved subset. Do not score excluded ids as `tp`/`rec=1000`. Do not reuse `"supply duct"` + `{72…75}`. `gold_n>=1` excluded and `leak_n=0` remain the distractor PASS condition.
2. **Do not treat this bag’s FAIL as a TB packing bug.** r0 ≡ xsim; walker locked; gold not rewritten. A pack-only “fix” is the wrong lane.
3. **Do not silently patch C0** (`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`). Direct `prec_ev1=187/1000` and `leak_n=10` are the same four-table union (k0 no object, k1 no subject, k2/k3 no relation). A change that would exclude two-role overlap is a **new named law**, frozen in a new contract **before** coding, with its own gold bag hashed before xvlog.
4. **Master FAIL routing (mandatory):** no threshold drop; no `relevant=router_union`; no nid-derived keys; do not rewrite this oracle; do not combine multiple root causes in one patch.
5. **Keep** the reporting machinery: `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE` + k0–k3 vs direct; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; PASS marker gated on `leak_n=0`.
6. leftover `a7ng_astra_09_integ_path` stays off xvlog. Token query authority. No U5 citation. No `CAND_CAP_FINAL`. No V3.1. No N=4096 generation.

**P2 — parent / docs:**

1. Map `ACCEPT_PARTIAL` to **scoring polarity only**. Next unblocked_item is a **new named key/index law** (parent) if exclusion is still the unknown; **not** N=4096, not C2, not 800k, not A09R8 smoke, not a silent C0 edit, not a gold rewrite of this FAIL bag.
2. Do **not** spawn N=4096 from this report.
3. Do **not** re-run this bag’s xsim to farm a PASS (gold is frozen; leak is the law).
4. `LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `n4096` stays NOT_STARTED.
5. KEEP bags including R1 `fail_r0` and R2 retrieve-subset gold stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (scoring polarity only: excluded gold, leak=FAIL not tp,
                         rec_undef, query "pump supplies chiller", gold_n=11,
                         not {72…75}, PASS marker ABSENT, gold-before-xvlog,
                         fp_ev1/fp_fill0, UNRELATED_EMPTY_WALK, NOT_SELECTIVE,
                         reduction not cap/N, leftover off, poke_v=0,
                         KEEP R1+R2 unmodified, C0 hashes MATCH, RESULT=FAIL honest)
PROMOTION        = REJECT  (not C1 800k, not N=4096, not Master ≥95% recall,
                            not Master ≥90% reduction, not entity-context
                            *exclusion* closed, not PASS_THIS_GATE_ONLY)
FAIL_LOOP        = NO
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_N256_R3_XSIM  = FAIL          DISTRACTOR_LEAK leak_n=10 gold_n=11 tp=0 rec_undef
                                 PID 45168; 16695 ns; PASS marker ABSENT
                                 xsim.log SHA256 f953c420… == xsim_fail_r0.log
C1_N256_POLARITY = PASS_NARROW   excluded-set scoring (0915Z P1-3 inverted)
C1_N256_EXCLUSION= FAIL          frozen four-table union (k2/k3 no relation);
                                 NOT a TB packing bug
C1_N256_QUALITY  = FAIL          precision / leak_n=10 / recall substitution
PASS_THIS_GATE   = NOT_CLAIMED   implementer RESULT=FAIL MATCH raw
GOLD_AFTER_FAIL  = MISS          GOLDEN/svh/corpus 09:24:14; PRE MATCH live;
                                 r0 is copy of first FAIL session
HASH_CHECK       = PASS vs C0    cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2 MATCH
LEFTOVER_A09     = not compiled
POKE_V           = 0
LOAD_FROM_TB     = not present
KEEP_R1          = UNMODIFIED    414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps
KEEP_R2          = UNMODIFIED    e2091bac / 181958be / a089afda + 0915Z timestamps
REDUCTION_X1000  = NOT_EMITTED  (not 1-CAND_CAP/N)
UNRELATED        = UNRELATED_EMPTY_WALK
WRONG_CONTEXT    = NOT_SELECTIVE keys_match=1 emit_match=1
DISTRACTOR_QUERY = "pump supplies chiller"  (NOT "supply duct")
DISTRACTOR_GOLD  = EXCLUDED {99,108,109,111,114,118,121,132,193,214,235}
LEAK_IDS         = {108,109,111,99,121,132,193,214,235,114}  (118 truncated)
LAW_FAIL_ROUTING = no threshold drop; no relevant=router_union; no nid-derived keys;
                   NEW named key/index law id; do not silently patch C0
C1_800K          = OPEN
N_4096           = NOT STARTED
U5_AS_C1         = REJECTED
NEXT             = new named key/index law (parent) if exclusion still unknown;
                   not N=4096; not C2; not gold rewrite of this FAIL bag
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 in this audit.
