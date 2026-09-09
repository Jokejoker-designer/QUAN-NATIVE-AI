# ASTRA auditor REPORT — 20260907T0915Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01
KEEP       = ASTRA-C1-N256-ROLE-RETRIEVAL-01 (must be unmodified; verified)
PRIOR_P1   = results/A7-NATIVE-GRAPH/AUDITOR/20260907T0840Z/REPORT.md  REJECT_PROMOTION
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + C0 FINAL_CONTRACT.json / C0 SHA256.txt
           WO .agents/handoff/ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01.md
EVIDENCE   = raw xsim.log CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK / ASTRA_C1_N256_R2_XSIM_PASS
           + xsim_4456.backup.log (first session; no xsim_fail_r0.log)
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold vs first xvlog/xsim; KEEP bag vs 0840Z)
           + tb_astra_c1_n256_r2.sv (poke_v, leftover A09, load_from_tb, scoring polarity)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_r2.py
           + run_xsim.ps1 (reduction pattern; SHA freeze; leftover gate)
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = NOT STARTED (this audit does not start it)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit the KEEP bag, did not write a V3.1 tree, and did not spawn agents. Only this file is written.

---

## Scope

Read-only except this file.

Primary object: C1 N=256 **R2** quality-reporting bag after auditor `20260907T0840Z` P1.

`results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01/`

Master §7 primary unknown (full C1): can the frozen role-aware query law retrieve relevant evidence selectively and with bounded traffic through the real index law up to 800,000 records?

This bag is the **N=256 quality-reporting rung only**. It cannot close C1 800k. It cannot start N=4096. It cannot close Master evidence-recall ≥95% or candidate-reduction ≥90% (those apply at N≥4096 / 800k).

KEEP (must remain unmodified; this audit does not rewrite it):

`results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/` including `fail_r0` and the post-fail gold rewrite.

**Not** this bag: C1 800k, N>256, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, historical `ASTRA-02-U5` as C1, frozen-RTL patch to paper over `wrong_context`.

Hunt (dispatch, none dropped):

1. `reduction_x1000` appearing as cap/N (`1-CAND_CAP/N`)
2. occupancy fillers treated as the precision story (vs `fp_ev1` / `fp_fill0` split)
3. distractor polarity: `gold_n=4 tp=4 rec=1000` — retrieved set vs excluded set (Master entity-context distractor / P1 item 3)
4. unrelated 0/0 scored 1000/1000 vs `UNRELATED_EMPTY_WALK`
5. wrong_context k0–k3 / emit vs direct labeled as recall win vs `NOT_SELECTIVE`
6. gold regenerated after FAIL; gold LastWriteTime after first xvlog
7. frozen RTL patched vs C0 hashes
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. KEEP prior bag SHA/timestamps changed
10. RESULTS.md vs raw `xsim.log`
11. C1 800k closed / N=4096 started / `ACCEPT_BOARD`

Master §7 line that this bag is graded against:

> Report precision per class; do not substitute recall alone for retrieval quality.

Required class name (Master §7, distinct from “direct relevant”):

> entity-context distractor

P1 item 3 (0840Z + WO): non-empty independent gold; entity-context records that **must be excluded** or that define the true distractor set; `lambda d: False` is not that class.

User/parent bound for this audit: if distractor gold is the **retrieved** set rather than the **excluded** set, that is **OVERCLAIM of P1 item 3**.

This bag **may** `ACCEPT_PARTIAL` as quality-reporting discipline without closing Master ≥95% recall / C1 800k / N=4096. Never `ACCEPT_BOARD`.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. R2 bag is untracked (`??`). KEEP bag is untracked (`??`). `PROGRAM=NO` this process and this bag (no bit, no JTAG, no COM12).

`LOOP_STATE.json` `updated=2026-09-07T09:15:00+07:00` `acceptance=PENDING_AUDITOR_C1_N256_R2` `c1_800k=OPEN` `n4096=NOT_STARTED` `auditor=IN_PROGRESS` `final_promotion=REJECT`. Auditor does not edit it.

File LastWriteTime (local +07), R2 bag:

```text
08:54:46  PREREG.md ACK.json
08:56:53  host_astra_c1_r2.py
08:59:20.701  tb_astra_c1_n256_r2.sv
08:59:20.906  corpus.json
08:59:20.907  query_gold.svh GOLDEN.json
08:59:20.908  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xsim
08:59:42–08:59:43  xsim_4456.backup.log   PID 4456  ASTRA_C1_N256_R2_XSIM_PASS (first session)
09:00:11  run_xsim.ps1                    ← wrapper pattern tightened AFTER first PASS
09:00:24.336  SHA256.txt                  ← second freeze, immediately before second xvlog
09:00:25.230  xvlog.log                   (work dir wiped/recreated; this is the second xvlog)
09:00:27.206  xelab.log
09:00:27–09:00:29  xsim.log               PID 37544  ASTRA_C1_N256_R2_XSIM_PASS
09:01:39  RESULTS.md CLOSEOUT.md
```

No `xsim_fail_r0.log` in the R2 bag. First XSim (PID 4456) already printed `ASTRA_C1_N256_R2_XSIM_PASS` at 15755 ns and `REDUCTION_X1000=NOT_EMITTED`. RESULTS’s wrapper note (case-insensitive `reduction_x1000=` matching that honest line; pattern then tightened to `reduction_x1000=[0-9]`) is consistent with `run_xsim.ps1` LastWriteTime 09:00:11 and the live pattern at line 161. Gold files were **not** rewritten between 08:59:20 and 09:00:29.

Independent bound on “gold before first xvlog”: first xvlog of session 4456 is not on disk (`xsim_work` deleted by the second `run_xsim.ps1`). Bound that **is** on disk: gold + `GOLD_HASH_PRE_XVLOG.txt` at 08:59:20 **before** first xsim 08:59:42. Hunt 6 as gold-after-FAIL / gold-after-first-sim: **MISS** on the three gold files.

`SHA256.txt` header `SHA freeze BEFORE xvlog 2026-09-07T09:00:24` is true of the **second** xvlog only. It includes the edited wrapper hash `89a8a6d8…` (`run_xsim.ps1` 09:00:11). That is a freeze-after-first-PASS of the wrapper, not a gold regen.

### 2) Live SHA256 vs bag lists vs C0

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time.

**GOLD_HASH_PRE_XVLOG.txt vs live (all MATCH):**

```text
e2091bac49f95c85d49032ca01ba76d350ec0e4e15cb0b88708e11ebfbb84fa1  GOLDEN.json
181958becf400bf6242304831dc66b649ff84a7358476dd2b325703d78f45d70  query_gold.svh
a089afda975efd1717c7458b3d02ca701514b03726e31919e1ecbd140d172198  corpus.json
```

**SHA256.txt frozen-RTL / compiled / bag gold lines vs live: all MATCH.** No invented hash.

C0 `FINAL_CONTRACT.json` / C0 `SHA256.txt` vs live (C1 R2 must not patch these):

| Object | C0 | Live | Match |
|---|---|---|---|
| `a7ng_query_role_extract.sv` | `cd7baf49…` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` | YES |
| `qse_role_lexicon.svh` | `38189974…` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` | YES |
| `a7ng_sparse_dir_axi.sv` | `09334e42…` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` | YES |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d…` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` | YES |
| `a7ng_route_valid_gate.sv` | `49a66da2…` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` | YES |
| leftover `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES (not compiled) |

Hunt **frozen RTL patched**: **MISS vs C0 hashes.** `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD (working tree is the C0-hashed `09334e42…` blob, same finding as 0840Z). Role-extract / lexicon / `query_axi_sparse` remain untracked at HEAD and MATCH C0. R2 did not retouch them.

TB / host / PREREG / ACK / `run_xsim.ps1` hashes MATCH the `SHA256.txt` `# BAG` / `# COMPILED` lines.

### 3) KEEP prior bag unmodified

0840Z recorded gold hashes and timestamps. Live KEEP bag:

```text
414f9952583084e3e7c25b1c1e70a6bc1c3dca28e235291f6476f968a66b95b7  GOLDEN.json     MATCH 0840Z
4b61d88f56ccfd9186ed104602d3b914741190ce3b58cb8da5da7d74779c3dfd  query_gold.svh  MATCH 0840Z
8c342aa23afdbfc8da7f253ee235ccde3a0d0beec40a3cbcdb4e3a487bd22f34  corpus.json     MATCH 0840Z
```

LastWriteTime KEEP (still):

```text
08:25:33  PREREG.md ACK.json
08:29:18  tb_astra_c1_n256.sv
08:30:38  xsim_fail_r0.log
08:31:44  GOLDEN.json query_gold.svh corpus.json GOLD_HASH_PRE_XVLOG.txt
08:31:56  SHA256.txt
08:32:01  xsim.log
08:37:00  RESULTS.md CLOSEOUT.md
```

Identical to the 0840Z timestamp table. Hunt 9: **MISS** (KEEP not edited).

KEEP distractor (for polarity contrast, not rewritten): query `"supply duct"`, `relevant=[]`, emit `{72…83}`, `lambda d: False`.

### 4) Raw xsim (archived PID 37544) and first-session backup (PID 4456)

`xsim.log` PID 37544, session Mon Sep 7 09:00:27–09:00:29, `$finish` 15755 ns. Banner:

```text
C1_R2_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW_SEL=1 POKE_V=0 REDUCTION_X1000=NOT_EMITTED
```

Named lines (authority = this log, not RESULTS):

```text
CLASS_direct gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=766 k3=4408 vs_direct k0=2561 k1=257 k2=766 k3=4408 keys_match=1 emit_match=1 frozen_law=xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_distractor gold_n=4 emit_n=12 tp=4 fp_ev1=8 fp_fill0=0 prec_ev1_x1000=333 prec_all_x1000=333 rec_x1000=1000 occ=12 ovf=1 trunc=0 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
ASTRA_C1_N256_R2_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

No `FIRST_DIVERGENCE`. No `SEARCH_INCOMPLETE`. No `HOST_SEMANTIC_LEAK`. No `reduction_x1000=<digit>` (wrapper gate `reduction_x1000=[0-9]` would have thrown). Ten named `CLASS_*` markers present. `UNRELATED_EMPTY_WALK` present. `NOT_SELECTIVE` present with `keys_match=1 emit_match=1`.

`xsim_4456.backup.log` PID 4456, 08:59:42–08:59:43, same 15755 ns, **same CLASS_*/NOT_SELECTIVE/UNRELATED/PASS/REDUCTION lines** as the archived log. Second run is a wrapper re-exec after a false-positive pattern match, not a gold/RTL change.

Marker `ASTRA_C1_N256_R2_XSIM_PASS` is emitted only if `fail==0 && dist_gold_ok && unrelated_empty && wc_not_sel` (`tb` lines 394–398). `dist_gold_ok` is `G_NREL[5] >= 1` (gold_n≥1), **not** “excluded-set polarity”.

### 5) TB: poke_v, leftover A09, load_from_tb, scoring

`tb_astra_c1_n256_r2.sv`:

- Instantiates frozen QSE + `a7ng_query_axi_sparse` with `.poke_v_i(poke_v)` and `pk*`/`pv*` tied to 0.
- `poke_v = 0` at reset; **never assigned 1**. Diverge `HOST_SEMANTIC_LEAK` if `poke_v !== 0`.
- No `load_from_tb` net. Index image is TB write of `u_mem.mem[G_WR_I[i]] = G_WR_D[i]` (AXI mem model). Queries are token bytes (`G_BYTES` LSB-first).
- `` `include "query_gold.svh" `` only. No `` `include "tb_ng03_a09_score_task.svh" ``.
- `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` — 16 < 256, not taken.
- Unrelated (`qi==6`): diverge if `n_got != 0`; print `UNRELATED_EMPTY_WALK`; **do not** score 0/0 as 1000/1000 (`rec_x1000 = -1` when `nrel==0`, and this class takes the empty-walk branch).
- wrong_context (`qi==4`): print `NOT_SELECTIVE` + k0–k3 vs direct + `keys_match` + `emit_match`. CLASS line still prints `rec_x1000=1000` **after** that named line.
- Precision split is live: `fp_fill0` if `G_EVIDENCE[id]==0` else `fp_ev1`; `prec_ev1 = tp/(tp+fp_ev1)`; `prec_all = tp/n_got`.
- Bit-exact `got[i] === G_EMIT[qi][i]` (host walker twin) **and** independent `G_RELEVANT` for P/R.
- **Distractor scoring uses the same TP/recall path as direct:** `G_RELEVANT[5] = {72,73,74,75}`, `G_NREL[5]=4`. An emitted gold id increments `tp` and `rec`. There is no “excluded-set / DISTRACTOR_LEAK if present” path.

`xvlog.log` analyzed **only**:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse.sv
tb_astra_c1_n256_r2.sv
```

`xelab.log` compiled the same modules. `xsim_work/xsim.dir/work/*.sdb` has those six + TB. **No** `a7ng_astra_09_integ_path`. Hunt leftover A09 compiled: **MISS.**

`run_xsim.ps1` DUT list matches xvlog; leftover filename on the list throws; xvlog text matching leftover throws.

### 6) Distractor polarity (P1 item 3) — RAW gold vs Master class

Host (`host_astra_c1_r2.py`):

```text
# distractor: entity-context gold = duct-as-subject AND supplies (rel=1).
# Query "supply duct" binds duct as subject + supply as ctx (no relation).
# Independent gold is the duct-supplies facts, not lambda False, not router_union.
("distractor", "supply duct", lambda d: d["subj_id"] == 7 and d["rel_id"] == 1)
```

`gold_ids` = `evidence==1 AND pred`, computed **before** `route()`. `GOLDEN.json` `"relevant_is_router_union": false`. Direct relevant `{110,144,145}` ≠ emit 16 ids. Hunt `relevant=router_union` on the **label** set: **MISS**.

GOLDEN / `query_gold.svh` / xsim agree:

```text
query text     = "supply duct"
parse          = subj_id=7 obj_id=0 rel_id=0 ctx_id=1
k0=1792 k1=0 k2=582 k3=0
k0_valid=0 k1_valid=0 k2_valid=1 k3_valid=0   ← only cue key k2 is walked
relevant/gold  = {72,73,74,75}                 ← RETRIEVE these
emit           = {72,73,74,75,76,77,78,79,80,81,82,83}
gold_n=4 emit_n=12 tp=4 fp_ev1=8 rec_x1000=1000
```

corpus.json records (live):

| id | ev | rel | text |
|---:|---:|---:|---|
| 72 | 1 | 1 | duct supplies vav **GOLD (retrieve)** |
| 73 | 1 | 1 | duct supplies tower **GOLD** |
| 74 | 1 | 1 | duct supplies pump **GOLD** |
| 75 | 1 | 1 | duct supplies valve **GOLD** |
| 76 | 1 | 2 | duct requires vav |
| 77 | 1 | 2 | duct requires tower |
| 78 | 1 | 2 | duct requires pump |
| 79 | 1 | 2 | duct requires valve |
| 80 | 1 | 3 | duct connects vav |
| 81 | 1 | 3 | duct connects tower |
| 82 | 1 | 3 | duct connects pump |
| 83 | 1 | 3 | duct connects valve |

Host checks `relevant != emit` (subset, not identity) and `psc_nids.isdisjoint(distractor emit)` (does not pull pump-supplies-chiller). Those checks do **not** test exclusion of entity-context distractors from a target query.

Polarity:

- Master class is **entity-context distractor**, listed separately from **direct relevant**.
- 0840Z P1-3: gold = records that **must be excluded** (or the true distractor set as a negative control). KEEP had `lambda False` / `gold_n=0` on the **same** query and the **same** emit `{72…83}`.
- R2 filled gold with the **head of that same k2 posting** (rel=1 slice `{72…75}`), then scored `tp`/`rec` as if those ids were the retrieval target.
- Query `rel_id=0` (unbound). Frozen k2 is a **cue** key with **no relation**. The DUT cannot implement `pred rel_id==1`. `rec=1000` is posting-order: the four supplies facts occupy nids 72–75, the first four of a 12-id cue list that fits under CAND_CAP=16.
- If gold were the **excluded** set, `tp=4 rec=1000` would be a **FAIL** (retrieved the distractors). The TB treats them as TP.

This is **not** Master entity-context distractor. It is a renamed positive retrieval of the duct cue-walk, with host-side rel=1 labels the frozen law cannot use. **OVERCLAIM of P1 item 3.**

Letter of this bag’s PREREG (`distractor gold_n>=1`, not `lambda False`) is met. Spirit of P1-3 / Master class name is not.

### 7) Precision split, reduction, wrong_context, unrelated

**fp_ev1 vs fp_fill0 (P1-2):** present on every CLASS line except unrelated (named empty-walk). Direct: `fp_ev1=13 fp_fill0=0 prec_ev1=187=prec_all`. Direct emit ids `{108,109,110,111,144,145,99,121,132,193,214,235,112,113,114,115}` — all `ev=1`. Includes wrong-relation 112–115 (`pump requires *`). Low direct precision is four-table cue-union (k2/k3 have no relation), not occupancy fillers. RESULTS states that; 0840Z hunt “filler sentence” is **fixed in prose**.

wrong_relation / high_occupancy / overflow / high_id: `prec_ev1 != prec_all` where fillers exist. Split is real.

**reduction_x1000 as cap/N (P1-6):** **MISS as emitted metric.** Banner and close print `REDUCTION_X1000=NOT_EMITTED`. No `reduction_x1000=<integer>`. GOLDEN per-query field is the string `"NOT_EMITTED"`. Do not read 16/256 as Master ≥90% (that bound is N≥4096).

**unrelated (P1-4):** `UNRELATED_EMPTY_WALK gold_n=0 emit_n=0`. Host `prec_all is None and recall is None`. Not 1000/1000. **PASS** as named check.

**wrong_context (P1-5):** `NOT_SELECTIVE` with k0–k3 identical to direct (`2561,257,766,4408`) and `emit_match=1`. Frozen qse-v2: xid is not a directory key (parent triage; do not invent a new key law). CLASS still prints `rec_x1000=1000`; RESULTS does **not** call that a context-selectivity win. Labeling requirement: **PASS**. Selectivity of the frozen law: still **NOT_SELECTIVE** (expected).

### 8) RESULTS.md vs raw xsim.log

RESULTS CLASS table numbers **MATCH** `xsim.log` exactly (gold_n / emit_n / tp / fp_ev1 / fp_fill0 / prec_ev1 / prec_all / rec / notes). No invented P/R. Discloses `C1_800K=OPEN`, `BOARD_PASS=NOT_CLAIMED`, `REDUCTION_X1000=NOT_EMITTED`, KEEP not edited, first-session wrapper trip, gold not regenerated.

Overclaim vs raw (not the table numbers):

1. `RESULT_PROPOSED = PASS_THIS_GATE_ONLY` / CLOSEOUT `RESULT = PASS_THIS_GATE_ONLY` / CLOSEOUT `DISTRACTOR_GOLD_N = 4` presented as the P1 distractor close. gold_n≥1 is true; **exclusion polarity is false**. That is OVERCLAIM of P1-3.
2. RESULTS “gold_n=4 (duct supplies *); not lambda False” is letter-true and polarity-silent. Hunt: tautology of scoring a cue-posting subset as recall 1000.

CLOSEOUT quality note “precision is the quality number; direct fp_fill0=0 fp_ev1=13” **MATCH** xsim and is the correct quality headline.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. `reduction_x1000` as cap/N | **MISS.** Not emitted as a number. Wrapper false-tripped on `REDUCTION_X1000=NOT_EMITTED` then tightened. | Do not carry 16/256 into N=4096 as candidate-reduction. |
| 2. occupancy fillers as the precision story | **MISS as RESULTS prose** (direct fp_fill0=0 fp_ev1=13 stated). **HIT as quality:** rec=1000 on 1–3 gold ids inside cap is still not Master retrieval quality. | Precision 62–187/1000 on gold>0 non-distractor classes. |
| 3. distractor polarity (P1-3) | **HIT OVERCLAIM.** gold `{72…75}` is the **retrieved** rel=1 slice of the k2 duct posting, scored tp/rec. Master entity-context distractor is the **excluded** set. Same query+emit as KEEP `gold_n=0`; labels inverted from empty to retrieve-subset. Query `rel_id=0`; DUT cannot filter rel=1 on k2. rec=1000 is posting layout. | Required fix for parent. Do not treat `gold_n=4 tp=4 rec=1000` as P1-3 closed. |
| 4. unrelated 0/0 = 1000/1000 | **MISS.** `UNRELATED_EMPTY_WALK`. | Keep named; do not reintroduce 1000/1000. |
| 5. wrong_context rec=1000 as selectivity | **MISS as claim** (`NOT_SELECTIVE` + RESULTS). **HIT as law:** keys_match=1 emit_match=1. | Do not patch C0 to chase context keys. |
| 6. gold after FAIL / after first xvlog | **MISS** on GOLDEN / svh / corpus (08:59:20; PRE hashes MATCH live; no `xsim_fail_r0.log`). SHA256.txt rewritten 09:00:24 after first PASS (wrapper), before second xvlog. | Do not call SHA256.txt rewrite a gold regen. |
| 7. frozen RTL patched | **MISS vs C0 live hashes.** | Do not patch QSE/dir to paper over distractor or wrong_context. |
| 8. leftover A09 compiled / poke_v=1 | **MISS.** poke_v held 0; leftover off xvlog/xelab/sdb. | Keep off. |
| 9. KEEP bag mutated | **MISS.** Gold hashes + timestamps MATCH 0840Z. | Leave KEEP including fail_r0. |
| 10. RESULTS vs xsim numbers | **MISS** (table MATCH). **HIT** CLOSEOUT `PASS_THIS_GATE_ONLY` as P1-3 complete. | Authority = raw CLASS_* + polarity above. |
| 11. C1 800k / N=4096 / BOARD_PASS | **MISS as claim.** | Never grant. Never start N=4096 from this audit. |
| Hash theatre | **MISS** on listed gold/RTL paths (live MATCH). PRE attests gold-before-first-xsim. | Second SHA256.txt is wrapper+second-xvlog freeze. |
| `relevant=router_union` | **MISS** on `G_RELEVANT` / GOLDEN relevant. | `G_EMIT` is walker twin oracle (bit-exact), not the label set. |
| cap≥N selectivity | **MISS.** CAND_CAP=16 < 256. | Instantiated 16 ≠ `CAND_CAP_FINAL`. |

qstack-validation-adversary one-liner: **R2 XSim is a real token-stream + sparse-dir twin lock at N=256 on C0 hashes, with honest precision split, named empty-walk, named NOT_SELECTIVE, and no cap/N reduction metric; it is not Master entity-context distractor (gold polarity is retrieve-not-exclude), not selective retrieval, and CLOSEOUT `PASS_THIS_GATE_ONLY` overclaims P1-3.**

---

## Logic bugs

No DUT vs host-twin mismatch on either xsim session (emit lists match `G_EMIT`; PID 4456 CLASS lines byte-match PID 37544). Findings are **label polarity / index-law quality / bag process**, not “patch frozen QSE in this bag”:

1. **Distractor gold polarity inverted.** TB/host score `{72…75}` as relevant TP. Master/P1-3 require those (or the true overlapping entity-context records on a **target** query) to be the **excluded** set. `gold_n>=1` alone is a metric-shape check, not the class.
2. **Host `rel_id==1` gold on an unbound-relation query.** Frozen k2 cannot honor that predicate. rec=1000 is guaranteed if the labeled nids sit inside the cue posting under cap.
3. **Four-table union until CAND_CAP** still pulls wrong-relation / wrong-object evidence=1 facts via k2/k3. Direct `prec_ev1=187/1000` with 0 fillers is the frozen key law at this corpus, now **honestly reported**.
4. **Frozen keys omit context.** wrong_context ≡ direct walk. Correctly labeled `NOT_SELECTIVE`; still not context-selective.
5. **Recall 1.0 is posting-order of a 1–4 id gold set inside cap**, with trunc dropping other ids. Not ranking quality. `SEARCH_INCOMPLETE` never fires because gold was not among the truncated ids.
6. **Index is `axi_mem_model`**, not MIG/DDR. Honest for N=256 XSim; illegal as C2 / production retrieval.
7. **Second xvlog after wrapper edit** is disclosed. Gold not regenerated. Not FAIL_LOOP; not a second-gold theatre.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (marker, FAIL=0, C0 hashes, leftover off, poke_v=0, n_host=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified) | **PASS_NARROW** | Bit-exact to host walker on frozen C0 files. Simulation only. Not DDR. Not 800k. First and second sessions agree. |
| Quality-reporting discipline (fp_ev1 vs fp_fill0, UNRELATED_EMPTY_WALK, NOT_SELECTIVE + keys/emit vs direct, no numeric `reduction_x1000`, gold hashed before first xsim and not rewritten) | **PASS_NARROW** | This is what R2 was opened to do. RESULTS numbers MATCH xsim. Direct filler story from 0840Z is corrected. |
| `PASS_THIS_GATE_ONLY` as **P1-3 closed** / Master entity-context distractor | **OVERCLAIM** | gold_n=4 tp=4 rec=1000 is retrieve-subset tautology, not exclusion. Required fix. |
| Master §7 retrieval quality at N=256 (precision per class; distractor exclusion; ≥95% evidence recall) | **FAIL** | prec 62–187/1000 on gold>0 law-using classes; distractor polarity wrong; recall substituted if used as quality; context not in keys. |
| C1 800k / N=4096 / `CAND_CAP_FINAL` / BOARD_PASS / ACCEPT_BOARD / U5 | **NOT CLOSED** | Do not start N=4096 from this audit. |
| Gold-after-FAIL process (R2) | **PASS_NARROW** | No FAIL; gold 08:59:20; PRE MATCH. SHA256.txt after first PASS is wrapper freeze only. |
| KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` | **UNMODIFIED** | Hashes + timestamps MATCH 0840Z. |

Promotion scale: **ACCEPT_PARTIAL** of **quality-reporting discipline only**. **REJECT** promotion of C1 rung-close, Master distractor class, Master ≥95% recall, candidate-reduction ≥90%, C1 800k, and any step to N=4096. **Not** FAIL_LOOP (hashes are real, RTL unpatched vs C0, 800k not claimed, reporting machinery is real). **Not** `ACCEPT_BOARD`.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` gold/xsim/RESULTS to “clean” this audit. **Do not edit** KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01`.

**P1 — new named bag required for distractor polarity. Do not patch frozen C0 RTL. Do not start N=4096.**

1. **Distractor = excluded set, not retrieved set (OVERCLAIM of 0840Z P1 item 3).** Do not treat `CLASS_distractor gold_n=4 tp=4 rec=1000` as Master entity-context distractor. In the new bag:
   - Gold for this class is the **entity-context records that must not appear** (or a target-query relevant set plus a named leak check that overlapping distractor nids are absent).
   - Scoring: presence of a gold-excluded id is **FAIL / DISTRACTOR_LEAK / fp**, not `tp`/`rec=1000`.
   - Do not reuse query `"supply duct"` + gold = k2 posting prefix `{72…75}`.
   - Suggested shape (parent chooses one, then freezes gold **once** before xvlog): keep target query `"pump supplies chiller"`; excluded set = overlapping wrong-entity / wrong-relation / wrong-object evidence=1 records that share tokens; **or** a dedicated class whose gold_n≥1 is that excluded set and TB diverges if any excluded id is emitted.
   - `gold_n>=1` remains required so the class cannot collapse to KEEP `lambda False`.
2. **Do not call R2 `PASS_THIS_GATE_ONLY` a P1-complete close.** Letter of R2 PREREG (shape checks) is met; Master distractor class is not.
3. **Keep** the reporting machinery that R2 got right: `fp_ev1` vs `fp_fill0` + `prec_ev1`/`prec_all`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE` + k0–k3 vs direct; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN.
4. **Precision remains the quality number.** Direct 187/1000 with 13 EV1 FPs is frozen-law four-table union, not a TB bug. Do not patch C0 hashes to chase it in the distractor bag. Do not substitute rec=1000.
5. leftover `a7ng_astra_09_integ_path` stays off xvlog. Token query authority. No U5 citation. No `CAND_CAP_FINAL`. No V3.1. No N=4096 generation.

**P2 — parent / docs:**

1. Map `ACCEPT_PARTIAL` to **reporting discipline only**. Next unblocked_item is a **new named C1-N256 distractor-polarity bag** if parent follows P1; **not** N=4096, not C2, not 800k, not A09R8 smoke.
2. Do **not** spawn N=4096 from this report.
3. Do **not** re-run this bag’s xsim to farm another PASS.
4. `LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `n4096` stays NOT_STARTED.
5. KEEP bag including `fail_r0` stays on disk as evidence of the first-rung gold-after-FAIL process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (quality-reporting discipline only: gold-before-xvlog,
                         fp_ev1/fp_fill0, UNRELATED_EMPTY_WALK, NOT_SELECTIVE,
                         reduction not cap/N, leftover off, poke_v=0, KEEP unmodified,
                         C0 hashes MATCH)
PROMOTION        = REJECT  (not C1 800k, not N=4096, not Master ≥95% recall,
                            not Master ≥90% reduction, not entity-context distractor closed)
FAIL_LOOP        = NO
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_N256_R2_XSIM  = PASS_NARROW  twin-lock (PID 37544 archived; PID 4456 backup agrees; 15755 ns)
C1_N256_REPORTING= PASS_NARROW  P1 items 1,2,4,5,6,7 (shape) vs 0840Z
C1_N256_QUALITY  = FAIL         precision / distractor polarity / recall substitution
P1_ITEM_3        = OVERCLAIM    distractor gold is retrieved set {72,73,74,75}, not excluded set
PASS_THIS_GATE   = OVERCLAIM    if read as P1-3 / Master distractor closed
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 08:59:20; PRE MATCH live; no r0 FAIL
HASH_CHECK       = PASS vs C0   cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2 MATCH
LEFTOVER_A09     = not compiled
POKE_V           = 0
LOAD_FROM_TB     = not present
KEEP_PRIOR_BAG   = UNMODIFIED   414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps
REDUCTION_X1000  = NOT_EMITTED  (not 1-CAND_CAP/N)
UNRELATED        = UNRELATED_EMPTY_WALK
WRONG_CONTEXT    = NOT_SELECTIVE keys_match=1 emit_match=1
C1_800K          = OPEN
N_4096           = NOT STARTED
U5_AS_C1         = REJECTED
NEXT             = new named C1-N256 distractor-polarity bag (parent); not N=4096; not C2
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 in this audit.
