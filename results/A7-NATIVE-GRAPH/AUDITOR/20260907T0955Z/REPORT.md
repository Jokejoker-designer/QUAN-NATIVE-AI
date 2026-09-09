# ASTRA auditor REPORT — 20260907T0955Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-KEY-RELBIND-01
LAW        = qse-v2-relbind-01
KEEP       = ASTRA-C1-N256-ROLE-RETRIEVAL-01 (must be unmodified; verified)
           + ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01 (must be unmodified; verified)
           + ASTRA-C1-N256-R3-DISTRACTOR-01 (must be unmodified; verified)
           + C0 RTL hashes (extract/lexicon/sparse/dir/gate; verified MATCH)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T0940Z/REPORT.md
           ACCEPT_PARTIAL (scoring polarity only); exclusion FAIL leak_n=10/11
           Required fix = NEW named key/index law id; do not silently patch C0
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256.txt
           WO .agents/handoff/ASTRA-C1-KEY-RELBIND-01.md
EVIDENCE   = raw xsim.log CLASS_* / FAIL DISTRACTOR_LEAK / NOT_SELECTIVE /
             UNRELATED_EMPTY_WALK / ASTRA_C1_KEY_RELBIND_XSIM_NO_MARKER
           + xsim_fail_r0.log (byte-identical copy of this xsim.log)
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold vs first xvlog/xsim; KEEP bags vs 0840Z/0915Z/0940Z)
           + tb_astra_c1_key_relbind.sv (poke_v, leftover A09, G_GOLD_EXCLUDED, leak scoring)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_key_relbind.py
           + run_xsim.ps1 (PASS-marker gate; leftover gate; SHA freeze; fail_r0 copy)
           + NEW RTL a7ng_query_role_keys_relbind.sv + a7ng_query_axi_sparse_relbind.sv
           + frozen a7ng_query_role_extract.sv k2/k3 (cue, not patched)
           + independent corpus two-role labels vs R3 labels and vs emit
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = NOT STARTED (this audit does not start it)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP bags R1/R2/R3, did not write a V3.1 tree, did not patch C0 hashes, and did not spawn agents. Only this file is written.

---

## Scope

Read-only except this file.

Primary object: C1 N=256 **named key law** `qse-v2-relbind-01` after auditor `20260907T0940Z` required a NEW key/index law (frozen four-table union, k2/k3 no relation, `leak_n=10/11`).

`results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-RELBIND-01/`

Master §7 primary unknown (full C1): can the frozen role-aware query law retrieve relevant evidence selectively and with bounded traffic through the real index law up to 800,000 records?

This bag is the **N=256 relbind key-law rung only**. It cannot close C1 800k. It cannot start N=4096. It cannot close Master evidence-recall ≥95% or candidate-reduction ≥90% (those apply at N≥4096 / 800k).

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/` including `fail_r0` and the post-fail gold rewrite
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01/` (reporting bag; distractor gold was retrieve-subset `{72…75}`)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R3-DISTRACTOR-01/` (polarity meter; `leak_n=10` four-table cue-union)
- C0 hashes of `a7ng_query_role_extract.sv` / `qse_role_lexicon.svh` / `a7ng_sparse_dir_axi.sv` / `a7ng_query_axi_sparse.sv` / `a7ng_route_valid_gate.sv`

**Not** this bag: C1 800k, N>256, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, historical `ASTRA-02-U5` as C1, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys.

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=256, new law `qse-v2-relbind-01` with `k2={rel_id,subj_cue[7:0]}` `k3={rel_id,obj_cue[7:0]}` (`k0,k1` unchanged from frozen extract), does CLASS_distractor `leak_n=0` on R3 excluded gold while CLASS_direct still retrieves its gold ids?

PASS this bag only if `DISTRACTOR leak_n=0` **and** direct still retrieves its gold (rec of those gold ids >0).

Hunt (dispatch, none dropped):

1. `reduction_x1000` appearing as cap/N (`1-CAND_CAP/N`)
2. occupancy fillers treated as the precision story (vs `fp_ev1` / `fp_fill0` split)
3. distractor polarity: excluded set vs retrieved subset; leak scored as `FAIL DISTRACTOR_LEAK` not `tp`/`rec=1000`
4. unrelated 0/0 scored 1000/1000 vs `UNRELATED_EMPTY_WALK`
5. wrong_context k0–k3 / emit vs direct labeled as recall win vs `NOT_SELECTIVE`
6. gold regenerated after FAIL; gold LastWriteTime after first xvlog
7. frozen RTL patched vs C0 hashes
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. KEEP prior bags SHA/timestamps changed (R1, R2, **and R3**)
10. RESULTS.md / CLOSEOUT.md vs raw `xsim.log` (PASS claimed vs honest FAIL)
11. C1 800k closed / N=4096 started / `ACCEPT_BOARD`
12. excluded set still a tautology of the same posting; `leak_n` manufactured
13. query reused `"supply duct"` + gold `{72,73,74,75}`
14. `ASTRA_C1_KEY_RELBIND_XSIM_PASS` emitted despite `leak_n>0`
15. FAIL is TB packing (`ROLE_COLLAPSE` / `KEY_MISMATCH`) vs remaining k0∪k1 union
16. host index keys ≠ RTL rebind (`k2={rel,cue[7:0]}` claimed, not built)
17. nid-derived keys in relbind or host
18. threshold drop
19. `relevant=router_union`
20. silent C0 patch (edit extract / sparse / dir / gate / lexicon)
21. relbind not actually applied (k2 still frozen cue `766`)
22. leak 10→9 is scoring theatre, not WR exclusion via relation-bound k2/k3

Master §7 line that this bag is graded against:

> Report precision per class; do not substitute recall alone for retrieval quality.

Required class name (Master §7, distinct from “direct relevant”):

> entity-context distractor

0940Z + WO: gold = entity-context records that **must be excluded**; presence in emit = `FAIL DISTRACTOR_LEAK` (fp, never tp). PASS distractor only if `leak_n=0` and `gold_n>=1` **and** CLASS_direct gold hits >0. Do not reuse `"supply duct"` + `{72…75}`. Target: `"pump supplies chiller"`.

Master §7 FAIL routing (this bag’s remaining law-exclusion FAIL):

```text
do not lower threshold
do not relabel relevant=set(router_union)
do not use nid-derived keys
return to index/key architecture only
```

If remaining leak is k0∪k1 union (k0 no object, k1 no subject): **Required fix = NEW named key/index law id** (e.g. require both subject+object / intersect tables). Do not silently patch C0. Do not drop threshold. Do not treat another k2/k3 rebind as sufficient while k0 and k1 are still unioned.

This bag **may** `ACCEPT_PARTIAL` of **relbind measured** (WR exclusion via relation-bound k2/k3; leak 10→9; C0 unpatched; honest FAIL) without closing Master exclusion, ≥95% recall, C1 800k, or N=4096. Never `ACCEPT_BOARD`.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. Relbind bag is untracked (`??`). KEEP R1 / R2 / R3 are untracked (`??`). New RTL `a7ng_query_role_keys_relbind.sv` and `a7ng_query_axi_sparse_relbind.sv` are untracked (`??`). Frozen extract / lexicon / `query_axi_sparse` remain untracked at HEAD. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD (working tree is the C0-hashed `09334e42…` blob, same finding as 0840Z/0915Z/0940Z). `PROGRAM=NO` this process and this bag (no bit, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T09:55:00+07:00` `acceptance=PENDING_AUDITOR_C1_KEY_RELBIND` `implementer=DONE_FAIL` `relbind_result=FAIL DISTRACTOR_LEAK leak_n=9 direct_tp=3` `c1_800k=OPEN` `n4096=NOT_STARTED` `auditor=IN_PROGRESS` `final_promotion=REJECT`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), relbind bag:

```text
09:46:14.167  tb_astra_c1_key_relbind.sv
09:47:59.022  run_xsim.ps1
09:47:59.023  PREREG.md ACK.json
09:48:30.677  host_astra_c1_key_relbind.py
09:48:35.331  GOLDEN.json query_gold.svh corpus.json
09:48:35.332  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xvlog
09:49:05.651  SHA256.txt                  ← freeze immediately before first xvlog
09:49:06.603  xvlog.log
09:49:08.841  xelab.log
09:49:11.468  xsim.log                    PID 24464  NO_MARKER / DISTRACTOR_LEAK
09:49:11.468  xsim_fail_r0.log            byte-identical copy of this xsim.log
09:51:03.156  RESULTS.md
09:51:03.157  CLOSEOUT.md
```

Single XSim session. No second xvlog. Gold files were **not** rewritten between 09:48:35 and 09:51:03. Hunt 6 as gold-after-FAIL: **MISS**.

`xsim.log` SHA256 `48cb3b7feb7822d7f7d54d78044869d84d5890471a92bb553f63a287d0203cd5` **equals** `xsim_fail_r0.log` SHA256 (same length 9000 bytes, same LastWriteTime). `run_xsim.ps1` copies `xsim.log` → `xsim_fail_r0.log` when PASS marker is missing or `FAIL DISTRACTOR_LEAK` is present. This r0 is **DISTRACTOR_LEAK on the first (only) session**, not a packing `ROLE_COLLAPSE` / `KEY_MISMATCH` followed by a gold rewrite.

### 2) Live SHA256 vs bag lists vs C0

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time.

**GOLD_HASH_PRE_XVLOG.txt vs live (all MATCH):**

```text
0f1ba57ac183404a80c35e8d9543f897029e8c9716d14fae6c77ca158e862d4e  GOLDEN.json
f8835b2e6b552228431a2d0875d60666e33e0e37329aa326415b96e7d26bd2de  query_gold.svh
4f981fd93940b258109d1bc21bd96d90db4dd3920ca6c039ef99c1bc9954605e  corpus.json
```

**SHA256.txt frozen-RTL / NEW_NAMED_RTL / compiled / bag gold / BAG lines vs live: all MATCH.** No invented hash.

C0 `SHA256.txt` vs live (this bag must not patch these):

| Object | C0 | Live | Match |
|---|---|---|---|
| `a7ng_query_role_extract.sv` | `cd7baf49…` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` | YES |
| `qse_role_lexicon.svh` | `38189974…` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` | YES |
| `a7ng_sparse_dir_axi.sv` | `09334e42…` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` | YES |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d…` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` | YES |
| `a7ng_route_valid_gate.sv` | `49a66da2…` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` | YES |
| leftover `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES (not compiled) |

**NEW named RTL (not in C0; listed in this bag’s SHA256.txt `# NEW_NAMED_RTL`):**

```text
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  rtl/native_graph/query/a7ng_query_role_keys_relbind.sv
37b7858cafae9154828a48969cece1a862748a86f9f19fc26026e8cbbfc4dfd6  rtl/native_graph/integrate/a7ng_query_axi_sparse_relbind.sv
```

Hunt **frozen RTL patched**: **MISS vs C0 hashes.** Frozen `a7ng_query_axi_sparse.sv` is hash-gated MATCH C0 and is **not** the DUT. Hunt **silent C0 patch**: **MISS.**

TB / host / PREREG / ACK / `run_xsim.ps1` hashes MATCH the `SHA256.txt` `# BAG` / `# COMPILED` lines.

### 3) KEEP prior bags unmodified

0940Z / 0915Z / 0840Z recorded gold hashes and timestamps. Live KEEP:

**R1 `ASTRA-C1-N256-ROLE-RETRIEVAL-01`:**

```text
414f9952583084e3e7c25b1c1e70a6bc1c3dca28e235291f6476f968a66b95b7  GOLDEN.json     MATCH 0840Z/0915Z/0940Z
4b61d88f56ccfd9186ed104602d3b914741190ce3b58cb8da5da7d74779c3dfd  query_gold.svh  MATCH 0840Z/0915Z/0940Z
8c342aa23afdbfc8da7f253ee235ccde3a0d0beec40a3cbcdb4e3a487bd22f34  corpus.json     MATCH 0840Z/0915Z/0940Z
```

LastWriteTime KEEP R1 (still): gold 08:31:44; `xsim_fail_r0.log` 08:30:38; `xsim.log` 08:32:01; RESULTS/CLOSEOUT 08:37:00. Identical to the 0840Z/0915Z/0940Z timestamp table.

**R2 `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01`:**

```text
e2091bac49f95c85d49032ca01ba76d350ec0e4e15cb0b88708e11ebfbb84fa1  GOLDEN.json     MATCH 0915Z/0940Z
181958becf400bf6242304831dc66b649ff84a7358476dd2b325703d78f45d70  query_gold.svh  MATCH 0915Z/0940Z
a089afda975efd1717c7458b3d02ca701514b03726e31919e1ecbd140d172198  corpus.json     MATCH 0915Z/0940Z
```

LastWriteTime KEEP R2 (still): gold 08:59:20; `run_xsim.ps1` 09:00:11; SHA256.txt 09:00:24; `xsim.log` 09:00:29; RESULTS/CLOSEOUT 09:01:39. Identical to the 0915Z/0940Z timestamp table.

**R3 `ASTRA-C1-N256-R3-DISTRACTOR-01`:**

```text
96f445a9dbff7759a63cbc00032c8ca359a78f1a15649254129f9cffdcc5ea9a  GOLDEN.json     MATCH 0940Z
a0d993117e538b4847cd9a4bfa520824e9d8cc0ba1f432556b44a18cfdd7de47  query_gold.svh  MATCH 0940Z
0ce3bfffafa319891fd628c65070f00aff3c05bf954cfcb854f3a6b75f1428cf  corpus.json     MATCH 0940Z
```

LastWriteTime KEEP R3 (still): gold 09:24:14; SHA256.txt 09:24:36; `xsim.log` / `xsim_fail_r0.log` 09:24:43 SHA `f953c420…`; RESULTS/CLOSEOUT 09:26:23. Identical to the 0940Z timestamp table. Raw R3 still prints `FAIL DISTRACTOR_LEAK leak_n=10` and `ASTRA_C1_N256_R3_XSIM_PASS` ABSENT.

Hunt 9: **MISS** (neither KEEP bag edited; R3 polarity bag left as FAIL evidence).

### 4) Raw xsim (PID 24464) and fail_r0

`xsim.log` PID 24464, session Mon Sep 7 09:49:09–09:49:11, `$finish` 17335 ns. Banner:

```text
C1_KEY_RELBIND_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-relbind-01 POKE_V=0 REDUCTION_X1000=NOT_EMITTED
```

Named lines (authority = this log, not RESULTS):

```text
CLASS_direct gold_n=3 emit_n=12 tp=3 fp_ev1=9 fp_fill0=0 prec_ev1_x1000=250 prec_all_x1000=250 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=12 tp=3 fp_ev1=9 fp_fill0=0 prec_ev1_x1000=250 prec_all_x1000=250 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct k0=2561 k1=257 k2=510 k3=312 keys_match=1 emit_match=1 law=qse-v2-relbind-01 xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=12 tp=1 fp_ev1=11 fp_fill0=0 prec_ev1_x1000=83 prec_all_x1000=83 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
FAIL DISTRACTOR_LEAK leak_n=9 emit_n=12 fp_ev1=12 fp_fill0=0 gold_n=11
CLASS_distractor gold_n=11 emit_n=12 leak_n=9 tp=0 fp_ev1=12 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_undef=1 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0 gold_polarity=excluded
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
ASTRA_C1_KEY_RELBIND_XSIM_NO_MARKER fail=1 dist_gold_ok=1 dist_excl_ok=1 dist_no_leak=0 unrelated_empty=1 wc_not_sel=1 direct_tp=3
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

`ASTRA_C1_KEY_RELBIND_XSIM_PASS` count = **0** in `xsim.log` and in `xsim_fail_r0.log`. Hunt 14: **MISS** (marker correctly ABSENT).

No `FIRST_DIVERGENCE`. No `ROLE_COLLAPSE`. No `KEY_MISMATCH`. No `SEARCH_INCOMPLETE`. No `HOST_SEMANTIC_LEAK`. No `reduction_x1000=<digit>`. Ten named `CLASS_*` markers present. `UNRELATED_EMPTY_WALK` present. `NOT_SELECTIVE` present with `keys_match=1 emit_match=1` and **new** k2/k3 `510/312` (not frozen cue `766/4408`). `FAIL DISTRACTOR_LEAK` present. `rec_undef=1` on distractor (not `rec_x1000=1000`). `tp=0` on distractor. `direct_tp=3`.

`xsim_fail_r0.log` is the same bytes. This r0 is **law-exclusion FAIL with walker twin locked**, not a TB packing fail.

TB emits `ASTRA_C1_KEY_RELBIND_XSIM_PASS` only if `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0)` (`tb` lines 464–465). `dist_no_leak` is set only when `leak_n==0`. Raw `dist_no_leak=0` + `fail=1` + `direct_tp=3` matches `leak_n=9` with direct still retrieving.

### 5) TB: poke_v, leftover A09, load_from_tb, scoring polarity, key checks

`tb_astra_c1_key_relbind.sv`:

- Instantiates frozen `a7ng_query_role_extract` (standalone, for KEY_MISMATCH vs gold) **and** DUT `a7ng_query_axi_sparse_relbind` with `.poke_v_i(poke_v)` and `pk*`/`pv*` tied to 0.
- Instantiates named `a7ng_query_role_keys_relbind` on the standalone extract (`u_rb_qse`) to check frozen-extract → rebind against `G_K*`.
- `poke_v = 0` at reset; **never assigned 1** (no `poke_v <= 1` / `poke_v = 1` in the file). Diverge `HOST_SEMANTIC_LEAK` if `poke_v !== 0`.
- No `load_from_tb` net. Index image is TB write of `u_mem.mem[G_WR_I[i]] = G_WR_D[i]` (AXI mem model). Queries are token bytes (`G_BYTES` LSB-first `bytes[8*bi +: 8]`).
- `` `include "query_gold.svh" `` only. No `` `include "tb_ng03_a09_score_task.svh" ``.
- `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` — 16 < 256, not taken.
- Startup: `G_NREL[5] < 1` → `DISTRACTOR_EMPTY_GOLD`; `G_GOLD_EXCLUDED[5] !== 1` → `DISTRACTOR_POLARITY`. Both passed (`dist_gold_ok=1 dist_excl_ok=1`).
- Direct: `if (direct_tp < 1) FAIL DIRECT_GOLD_MISS`. Raw `direct_tp=3`.
- Relbind applied: `if (qi == 0 && k2_rb === k2) diverge KEY_MISMATCH "relbind k2 identical to frozen cue k2"`. Not taken (k2_rb=510, frozen extract k2=766).
- Unrelated (`qi==6`): diverge if `n_got != 0`; print `UNRELATED_EMPTY_WALK`; **do not** score 0/0 as 1000/1000.
- wrong_context (`qi==4`): print `NOT_SELECTIVE` + k0–k3 vs direct + `keys_match` + `emit_match`.
- Precision split is live on retrieve classes: `fp_fill0` if `G_EVIDENCE[id]==0` else `fp_ev1`.
- Bit-exact `got[i] === G_EMIT[qi][i]` (host walker twin) **and** independent `G_RELEVANT` for P/R.
- **Distractor scoring inverted (R3 polarity reused):** `G_GOLD_EXCLUDED[5]=1`; `G_RELEVANT[5]` is the excluded set. Hits increment `leak_n`, never `tp`. `rec_x1000 = -1` (`rec_undef=1`). If `leak_n>0`: print `FAIL DISTRACTOR_LEAK`, `fail = fail + 1`. CLASS line prints `tp=0` `gold_polarity=excluded`.

`xvlog.log` analyzed **only**:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_relbind.sv
tb_astra_c1_key_relbind.sv
```

`xelab.log` compiled the same modules. `xsim_work/xsim.dir/work/*.sdb` has those six RTL + TB. **No** `a7ng_astra_09_integ_path`. **No** `a7ng_query_axi_sparse.sdb` (frozen sparse wrapper is not the DUT). Hunt leftover A09 compiled: **MISS.** Hunt frozen `a7ng_query_axi_sparse.sv` compiled as DUT: **MISS.**

`run_xsim.ps1` DUT list matches xvlog; leftover filename on the list throws; xvlog text matching leftover throws; frozen `a7ng_query_axi_sparse.sv` on the list throws; `reduction_x1000=[0-9]` throws; missing PASS marker or `FAIL DISTRACTOR_LEAK` copies r0 and throws `C1RELBIND_XSIM_FAIL_OR_MARKER_MISSING`. Hash-gate vs C0 expected map; mismatch throws `C1RELBIND_HASH_GATE_FAIL do_not_invent`. Gold PRE must exist and MATCH live before xvlog.

### 6) Relbind RTL law vs claim vs host twin (hunts 16, 17, 21)

Frozen extract (C0 hash `cd7baf49…`, **not edited**):

```text
k0_o = {subj_id_o, rel_id_o}
k1_o = {obj_id_o,  rel_id_o}
k2_o = subj_cue_o[15:0]          // cue-only; no relation
k3_o = obj_cue_o[15:0]           // cue-only; no relation
```

Named wrapper `a7ng_query_role_keys_relbind.sv` (live SHA `93811ed1…`):

```text
k0_o = k0_i                     // pass-through
k1_o = k1_i                     // pass-through
k2_o = {rel_id_i, subj_cue_i[7:0]}
k3_o = {rel_id_i, obj_cue_i[7:0]}
valids pass through frozen bind-state
```

No `nid` port. No nid in the key equations. Valids are not `key!=0`.

DUT `a7ng_query_axi_sparse_relbind.sv` (live SHA `37b7858c…`): instantiates frozen extract → named relbind → frozen `a7ng_route_valid_gate` → frozen `a7ng_sparse_dir_axi`. Walker keys are `k0_o..k3_o` from relbind, not from extract. Frozen `a7ng_query_axi_sparse.sv` is not instantiated.

Host `relbind_keys()`:

```text
k2 = ((rid << 8) | (subj_cue & 0xFF)) & 0xFFFF
k3 = ((rid << 8) | (obj_cue  & 0xFF)) & 0xFFFF
```

Independent check on all 256 corpus records: `k2 == (rel_id<<8)|(k2_frozen&0xFF)` and `k3 == (rel_id<<8)|(k3_frozen&0xFF)` for **0** failures. Direct query:

```text
frozen extract k2/k3 = 766 / 4408 = 16'h02FE / 16'h1138
relbind     k2/k3 = 510 /  312 = 16'h01FE / 16'h0138
G_K2/G_K3[0]      = 16'h01FE / 16'h0138
xsim NOT_SELECTIVE k2=510 k3=312
```

`510 = {rel=1, cue[7:0]=0xFE}`; `312 = {rel=1, cue[7:0]=0x38}`. Pump nid=10 and chiller obj_id=1 are **not** those low bytes. Corpus-wide `k2==nid` or `k3==nid`: **0**. Hunt **nid-derived keys**: **MISS.** Hunt **relbind not applied**: **MISS.** Hunt **host index keys ≠ RTL rebind**: **MISS** (packing identity + TB `KEY_MISMATCH` not fired + walker bit-exact to `G_EMIT`).

Coincidence, not a cheat: nid 114 (`pump requires chiller`, rel=2) has `k2_frozen=766` and relbind `k2=766` because `{rel=2, cue[7:0]=0xFE}=0x02FE=766`. Query k2 is `0x01FE=510`, so 114 is **not** in the k2 posting of `"pump supplies chiller"`. That coincidence is why WR exclusion is the measured relbind effect, not a packing bug.

### 7) Distractor polarity + independent leak vs R3

Host `queries_spec` class `distractor`:

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
G_K0..K3[5]         = 2561, 257, 510, 312   (all valid; k2/k3 rebound)
G_GOLD_EXCLUDED     = '{0,0,0,0,0,1,0,0,0,0}
G_NREL[5]           = 11
G_RELEVANT[5]       = {99,108,109,111,114,118,121,132,193,214,235}
                      NOT {72,73,74,75}; EQUAL to R3 excluded gold
G_EMIT[5]           = {108,109,110,111,144,145,99,121,132,193,214,235}
                      identical to G_EMIT[0] (same query tokens)
```

Independent re-derive from live `corpus.json` (256 records, law `qse-v2-relbind-01`). **Labels** `(nid,text,evidence,subj,rel,obj)` vs R3 corpus: **0 mismatches.** Keys k2/k3 differ on 254/256 records (expected: index rebuilt). Excluded gold nids **equal** R3. WO reuse of R3 excluded nids is valid.

| nid | s,r,o | text | two-role tag | query-key hit |
|---:|---|---|---|---|
| 108 | 10,1,11 | pump supplies valve | WO | k0=2561 and k2=510 |
| 109 | 10,1,12 | pump supplies sensor | WO | k0=2561 and k2=510 |
| 111 | 10,1,2 | pump supplies condenser | WO | k0=2561 and k2=510 |
| 114 | 10,2,1 | pump requires chiller | WR | **none** of query k0/k1/k2/k3 |
| 118 | 10,3,1 | pump connects chiller | WR | **none** of query k0/k1/k2/k3 |
| 99 | 9,1,1 | tower supplies chiller | WE | k1=257 and k3=312 |
| 121 | 11,1,1 | valve supplies chiller | WE | k1=257 and k3=312 |
| 132 | 12,1,1 | sensor supplies chiller | WE | k1=257 and k3=312 |
| 193 | 2,1,1 | condenser supplies chiller | WE | k1=257 and k3=312 |
| 214 | 3,1,1 | evaporator supplies chiller | WE | k1=257 and k3=312 |
| 235 | 4,1,1 | compressor supplies chiller | WE | k1=257 and k3=312 |

PSC retrieve (NOT in excluded gold): `{110,144,145}` = `pump supplies chiller` / `… water` / `… indirectly`. Direct `tp=3` of that set. Gate “direct still retrieves”: **yes.**

Live `xsim.log` `EMIT_distractor` CAND ids = `{108,109,110,111,144,145,99,121,132,193,214,235}` (all `ev=1`).

Independent leak:

```text
excluded ∩ emit = {108,109,111,99,121,132,193,214,235}     leak_n=9
excluded \ emit = {114,118}                                 WR not in k0/k1/k2/k3
emit \ excluded = {110,144,145}                             PSC retrieve (direct gold)
```

MATCH raw `FAIL DISTRACTOR_LEAK leak_n=9 gold_n=11` and GOLDEN `leak_ids`. Leaks counted as fp, **never tp**. `rec_x1000=1000` was **not** printed on this class.

Query is **not** `"supply duct"`. Gold is **not** `{72,73,74,75}`. Hunt 13: **MISS.**

### 8) Relbind vs R3 — measured effect (not scoring theatre)

R3 raw (`xsim.log` PID 45168, SHA `f953c420…`, KEEP unmodified):

```text
CLASS_direct   emit_n=16 tp=3 fp_ev1=13 prec_ev1=187 trunc=4 dirB=48
FAIL DISTRACTOR_LEAK leak_n=10 emit_n=16 gold_n=11
EMIT_distractor includes WR 114 and cue-only one-role {112,113,115}; 118 truncated
k2=766 k3=4408 (cue-only)
```

This bag:

```text
CLASS_direct   emit_n=12 tp=3 fp_ev1=9  prec_ev1=250 trunc=0 dirB=64
FAIL DISTRACTOR_LEAK leak_n=9  emit_n=12 gold_n=11
EMIT_distractor = k0∪k1 unique set; 114 and 118 absent; {112,113,115} absent
k2=510 k3=312 (relation-bound)
```

Query-key posting occupancy on this corpus (independent):

```text
k0=2561 {subj,rel}           occ=6  → 108,109,110,111,144,145     pump supplies *
k1=257  {obj,rel}            occ=9  → 99,110,121,132,144,145,193,214,235  * supplies chiller
k2=510  {rel,subj_cue[7:0]}  occ=6  → SAME SET as k0
k3=312  {rel,obj_cue[7:0]}   occ=9  → SAME SET as k1
```

`set(k2 posting)==set(k0 posting)` and `set(k3 posting)==set(k1 posting)` for this query. Relbind bound `rel_id` into the former cue-only tables, which on this lexicon **duplicates** k0/k1 for matching `(subj,rel)` / `(obj,rel)` pairs. That is why:

- WR `{114,118}` left the walk (their k2/k3 now carry `rel≠supplies`; R3 cue-only k2=766 hit both).
- WO/WE still leak (k0 has no object; k1 has no subject; k2/k3 do not add a new conjunctive constraint).
- `dirB` 48→64: all four tables probed (`n_dir=4`) because unique emit 12 < CAND_CAP 16 (R3 filled cap from cue-only WR/one-role and truncated).
- Direct `prec_ev1` 187→250 is **emit shrink** (16→12, fp_ev1 13→9) with `tp` still 3, not ranking quality and not Master retrieval quality.

Hunt 22 (leak 10→9 is scoring theatre): **MISS.** Delta is the WR pair `{114,118}` leaving the four-table union. 114 was a raw R3 leak; 118 was R3-truncated and is now not walked. Gold definition unchanged.

### 9) Tautology / manufactured-leak hunt (dispatch 12)

**Scoring tautology (R2 shape):** gold = posting prefix scored `tp`/`rec=1000`. This bag does **not** do this. Gold is a label predicate (`pred_excl`) computed before `route()`. Host checks `set(relevant) != set(emit)` and `direct ∩ distractor gold = ∅`. WR `{114,118}` are in gold and **not** in emit — gold is not “whatever leaked.” PSC `{110,144,145}` are in emit and **not** in gold. Hunt **manufactured leak_n**: **MISS.**

GOLDEN.json already contains `leak_n=9` / `DISTRACTOR_LEAK=true` at 09:48:35, **before** first xvlog. That is the host walker twin predicting the new-law union, then hashing gold, then simulating. It is not a post-fail gold edit. Host `main()` returns 3 (`GOLD_IMMUTABLE`) if `xsim.log` / `xvlog.log` / `xsim_fail_r0.log` exist.

**Same-posting identity (law, not scoring):** distractor query tokens ≡ direct query tokens, so `G_EMIT[5] ≡ G_EMIT[0]`. Occupancies `[6,9,6,9]`, `n_dir=4`, `n_post=8`, `trunc=0` are the four-table walk of `"pump supplies chiller"` with k2/k3 duplicating k0/k1. Two-role-overlap nids that sit in k0 or k1 **must** leak under this registered law. CONFIRMED_ROOT_CAUSE for remaining `leak_n=9` = **k0∪k1 union**, not a TB packing bug (walker bit-exact; no `ROLE_COLLAPSE`; no `KEY_MISMATCH`; gold not rewritten).

Hunt 12 as “excluded set is the posting itself”: **MISS as gold definition.** **HIT as law identity:** the distractor class re-scores the **same** four-table union as CLASS_direct. Intended P1 shape (same target query, inverted gold). Relbind changed the union’s WR component; it did not change k0/k1.

### 10) Precision split, reduction, wrong_context, unrelated, threshold

**fp_ev1 vs fp_fill0:** present on every CLASS line except unrelated (named empty-walk). Direct: `fp_ev1=9 fp_fill0=0 prec_ev1=250=prec_all`. Direct/distractor emit ids are all `ev=1`. Low direct precision is k0∪k1 (WO+WE), not occupancy fillers. RESULTS states that. Distractor `fp_ev1=12` is **all** emit ids (tp forced 0 under excluded polarity), including PSC `{110,144,145}` — correct for this class.

wrong_relation / high_occupancy / overflow / high_id: `prec_ev1 != prec_all` where fillers exist. Split is real.

**reduction_x1000 as cap/N:** **MISS as emitted metric.** Banner and close print `REDUCTION_X1000=NOT_EMITTED`. No `reduction_x1000=<integer>`. GOLDEN per-query field is the string `"NOT_EMITTED"`. Do not read 16/256 or 12/256 as Master ≥90% (that bound is N≥4096).

**unrelated:** `UNRELATED_EMPTY_WALK gold_n=0 emit_n=0`. Host `prec_all is None and recall is None`. Not 1000/1000. **PASS** as named check.

**wrong_context:** `NOT_SELECTIVE` with k0–k3 identical to direct (`2561,257,510,312`) and `emit_match=1`. Relbind still has no context key (xid is not a directory key). CLASS still prints `rec_x1000=1000`; RESULTS does **not** call that a context-selectivity win. Labeling requirement: **PASS**. Selectivity of the new law: still **NOT_SELECTIVE** (expected; WO: do not fake ctx keys).

**threshold drop:** CAND_CAP remains 16; INDEX_HEAD remains 4; no score/min-hit threshold in TB, host, or relbind RTL. Hunt 18: **MISS.**

**`relevant=router_union`:** GOLDEN `"relevant_is_router_union": false`. `G_RELEVANT[5]` is the excluded two-role set, not `G_EMIT[5]`. Hunt 19: **MISS.**

### 11) RESULTS.md / CLOSEOUT.md vs raw xsim.log (honesty hunt)

RESULTS CLASS table numbers **MATCH** `xsim.log` exactly (gold_n / emit_n / tp / leak_n / fp_ev1 / fp_fill0 / prec_ev1 / prec_all / rec / notes). No invented P/R. Discloses `C1_800K=OPEN`, `BOARD_PASS=NOT_CLAIMED`, `REDUCTION_X1000=NOT_EMITTED`, KEEP bags not edited, gold not regenerated, PASS marker NOT emitted, C0 hashes MATCH.

Implementer `RESULT = FAIL` / CLOSEOUT `RESULT = FAIL` / `ASTRA_C1_KEY_RELBIND_XSIM_PASS NOT emitted` / `LEAK_N = 9` / `DISTRACTOR_TP = 0` / `DISTRACTOR_REC = undef` / `DIRECT_TP = 3`: **HONEST vs raw.** `LOOP_STATE.json` `implementer=DONE_FAIL` is consistent. This is not a PASS_THIS_GATE_ONLY overclaim.

Split in RESULTS “Unknown”:

- Direct retrieve: **yes** (`tp=3` of `{110,144,145}`) — MATCH raw.
- WR exclusion via k2/k3: **partial** (`{114,118}` not in emit) — MATCH independent corpus.
- Entity-context exclusion (`leak_n=0`): **no** (`leak_n=9/11`) — MATCH raw. Gate requires `leak_n=0` for `PASS_THIS_GATE_ONLY`. Therefore FAIL.

“Leak is the four-table union of the new relbind keys still probing k0 (no object) and k1 (no subject)”: **CONFIRMED** (twin-lock; r0 ≡ xsim; no `ROLE_COLLAPSE`; posting composition above). Measurement at this corpus/cap/law, not a theorem that no future named law can exclude.

Hunt **overclaim of PASS / of “law cannot exclude” as a close / as an excuse to skip a new law**: **MISS.** Implementer did not claim `PASS_THIS_GATE_ONLY`, did not emit the PASS marker, did not drop threshold, did not set `relevant=router_union`, did not patch C0, did not use nid-derived keys, and did not start N=4096. RESULTS explicitly lists `PASS_THIS_GATE_ONLY` and `ASTRA_C1_KEY_RELBIND_XSIM_PASS` under **Not claimed**.

Do not read RESULTS “Wrong-relation exclusion via k2/k3: partial” as gate close. Relbind effect is the ACCEPT_PARTIAL slice. Exclusion remains FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. `reduction_x1000` as cap/N | **MISS.** Not emitted as a number. | Do not carry 16/256 or 12/256 into N=4096 as candidate-reduction. |
| 2. occupancy fillers as the precision story | **MISS as RESULTS prose** (direct fp_fill0=0 fp_ev1=9 stated). **HIT as quality:** rec=1000 on 3 retrieve-class gold ids inside cap is still not Master retrieval quality. | Precision 62–250/1000 on gold>0 retrieve classes; distractor prec_ev1=0 under excluded polarity. Direct 250 is emit-shrink vs R3 187, not ranking. |
| 3. distractor polarity | **MISS as OVERCLAIM.** Gold is excluded set gold_n=11; tp=0; rec_undef; FAIL DISTRACTOR_LEAK leak_n=9; not rec=1000 on excluded ids. | Scoring polarity **PASS_NARROW** (R3 meter reused). Law exclusion **FAIL**. |
| 4. unrelated 0/0 = 1000/1000 | **MISS.** `UNRELATED_EMPTY_WALK`. | Keep named; do not reintroduce 1000/1000. |
| 5. wrong_context rec=1000 as selectivity | **MISS as claim** (`NOT_SELECTIVE` + RESULTS). **HIT as law:** keys_match=1 emit_match=1 (xid still not a key). | Do not fake context keys. Do not patch C0 to chase context. |
| 6. gold after FAIL / after first xvlog | **MISS** on GOLDEN / svh / corpus (09:48:35; PRE hashes MATCH live). r0 is copy of the same FAIL session. Host refuses regen. | Do not regenerate gold. New labels ⇒ new named bag. |
| 7. frozen RTL patched | **MISS vs C0 live hashes.** Frozen sparse not compiled as DUT. | Do not silently patch QSE/dir/sparse/gate/lexicon. |
| 8. leftover A09 compiled / poke_v=1 | **MISS.** poke_v held 0; leftover off xvlog/xelab/sdb. | Keep off. |
| 9. KEEP bags mutated | **MISS.** R1 414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps. R2 e2091bac / 181958be / a089afda + 0915Z timestamps. R3 96f445a9 / a0d99311 / 0ce3bfff + 0940Z timestamps / xsim SHA f953c420. | Leave all three KEEP bags including R1 fail_r0 and R3 leak_n=10. |
| 10. RESULTS vs xsim numbers / FAIL honesty | **MISS** (table MATCH; RESULT=FAIL honest). **MISS** as PASS overclaim. | Authority = raw CLASS_* + polarity/exclusion/relbind-delta split above. |
| 11. C1 800k / N=4096 / BOARD_PASS | **MISS as claim.** | Never grant. Never start N=4096 from this audit. |
| 12. excluded = posting tautology; leak_n manufactured | **MISS as scoring cheat** (independent two-role labels; 114/118 not in emit; PSC in emit not gold; GOLDEN leak predicted before xvlog). **HIT as law identity** (same union as direct). | Do not treat leak_n=9 as a TB bug. |
| 13. reuse `"supply duct"` + `{72…75}` | **MISS.** Query `"pump supplies chiller"`; gold 11 two-role nids, equal R3. | Do not revert to R2 retrieve-subset. |
| 14. PASS marker despite leak | **MISS.** `ASTRA_C1_KEY_RELBIND_XSIM_PASS` ABSENT; `NO_MARKER fail=1 dist_no_leak=0 direct_tp=3`. | Keep marker gated on leak_n=0 **and** direct_tp>0. |
| 15. FAIL is TB packing vs remaining union | **FAIL = remaining k0∪k1 union**, not TB-bug. r0 ≡ xsim; no ROLE_COLLAPSE; no KEY_MISMATCH; walker bit-exact. | Required fix = NEW named key/index law id (conjunct / intersect). Not a pack fix. Not a C0 silent patch. Not another k2/k3-only rebind. |
| 16. host index keys ≠ RTL rebind | **MISS.** Host packing = RTL `{rel,cue[7:0]}`; 256/256 corpus records; TB KEY_MISMATCH not fired; DUT `sp_k*` match `G_K*`. | Keep host+RTL the same function. |
| 17. nid-derived keys | **MISS.** Relbind has no nid port; k2/k3 ≠ nid on this corpus; k0/k1 are `{subj,rel}`/`{obj,rel}`. | Do not introduce nid keys to paper over leak_n. |
| 18. threshold drop | **MISS.** CAND_CAP=16; INDEX_HEAD=4; no score threshold. | Do not lower cap or add a score gate to hide WO/WE. |
| 19. `relevant=router_union` | **MISS** on `G_RELEVANT` / GOLDEN relevant. | `G_EMIT` is walker twin oracle (bit-exact), not the label set. |
| 20. silent C0 patch | **MISS.** Five frozen SHAs MATCH C0. | Do not edit extract/lexicon/dir/sparse/gate. |
| 21. relbind not applied (k2 still 766) | **MISS.** Live k2=510 k3=312; TB diverges if k2_rb===frozen k2 on qi=0. | Relbind is real. |
| 22. leak 10→9 scoring theatre | **MISS.** WR `{114,118}` left the walk because relation-bound k2/k3 no longer match cue-only 766. | Measured WR exclusion. Remaining leak is WO+WE via k0∪k1. |
| Hash theatre | **MISS** on listed gold/RTL paths (live MATCH). PRE attests gold-before-first-xvlog. | SHA256.txt 09:49:05 is the first-xvlog freeze. |
| cap≥N selectivity | **MISS.** CAND_CAP=16 < 256. | Instantiated 16 ≠ `CAND_CAP_FINAL`. |

qstack-validation-adversary one-liner: **Relbind XSim is a real named-law twin lock at N=256 on unpatched C0 hashes that honestly FAILs DISTRACTOR_LEAK leak_n=9 tp=0 rec_undef while CLASS_direct still retrieves tp=3; k2/k3 are `{rel,cue[7:0]}` as claimed and WR `{114,118}` left the walk (leak 10→9); remaining leak is k0∪k1 (no object / no subject), not a TB packing bug, not nid keys, not a license to silently patch C0 or drop threshold, and not Master entity-context exclusion.**

---

## Logic bugs

No DUT vs host-twin mismatch (emit lists match `G_EMIT`; CLASS lines match GOLDEN predicted leak; relbind keys match `{rel,cue[7:0]}`). Findings are **index-law quality / FAIL routing**, not “patch frozen QSE in this bag” and not “fix TB packing”:

1. **Relbind law is implemented as claimed.** Named wrappers only. Frozen extract still emits cue-only k2/k3; wrapper rebinds; DUT walker uses rebound keys; host index rebuilt with the same function. C0 hashes MATCH. leftover A09 off. poke_v=0.
2. **Relbind has a measured effect.** R3 cue-only k2=766 leaked WR 114 (118 truncated). Relation-bound k2=510 / k3=312 do not hit `{114,118}`. leak 10→9. Direct still tp=3. That is ACCEPT_PARTIAL of **relbind measured**, not gate PASS.
3. **Remaining FAIL is k0∪k1 union.** k0 has no object (WO leaks). k1 has no subject (WE leaks). On this corpus, relbind k2/k3 **duplicate** k0/k1 postings for this query, so they cannot exclude WO/WE. Another k2/k3-only rebind cannot close `leak_n=0` while k0 and k1 remain unioned.
4. **Scoring polarity remains correct.** Excluded gold, leak=FAIL, tp=0, rec_undef, query `"pump supplies chiller"`, gold_n=11≥1, gold nids equal R3, PASS marker ABSENT, direct_tp=3.
5. **Master §7 FAIL routing applies to the remaining FAIL.** Do not lower threshold. Do not relabel `relevant=router_union`. Do not use nid-derived keys. Return to **index/key architecture only** via a **NEW named law id** that requires both subject and object (intersect tables / conjunctive probe), not a silent C0 patch and not a threshold drop.
6. **Frozen keys still omit context.** wrong_context ≡ direct walk under relbind. Correctly labeled `NOT_SELECTIVE`. Do not invent a context key inside this FAIL bag.
7. **Recall 1.0 on retrieve classes is posting-order of a 1–3 id gold set inside cap.** Direct prec 250/1000 is still WO+WE union. Not ranking quality. Not Master ≥95%.
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for N=256 XSim; illegal as C2 / production retrieval.
9. **fail_r0 is the exclusion FAIL itself**, not a packing theatre. Gold hashed once before that session. Not FAIL_LOOP.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 hashes, leftover off, poke_v=0, n_host=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge, host=RTL rebind) | **PASS_NARROW** | Bit-exact to host walker on frozen C0 files + named relbind. Simulation only. Not DDR. Not 800k. FAIL is `DISTRACTOR_LEAK`, not `ROLE_COLLAPSE`. |
| Relbind law as claimed (`k2={rel,cue[7:0]}`, k0/k1 pass-through, no nid, wrappers only) | **PASS_NARROW** | RTL + host + G_K* + xsim k2=510 k3=312. Frozen extract unpatched. |
| Relbind **measured effect** (WR `{114,118}` gone; leak 10→9; direct still tp=3) | **PASS_NARROW** | Independent corpus posting composition. Not scoring theatre. |
| Scoring polarity (excluded gold, leak=FAIL not tp, rec_undef, gold_n=11, query `"pump supplies chiller"`, not `{72…75}`, PASS marker ABSENT, direct_tp=3) | **PASS_NARROW** | R3 meter reused correctly. |
| Entity-context **exclusion** (`leak_n=0`) | **FAIL** | `leak_n=9/11`. Remaining k0∪k1 union (WO+WE). **Not a TB bug.** |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_KEY_RELBIND_XSIM_PASS` | **NOT CLAIMED / ABSENT** | Implementer RESULT=FAIL is honest. Do not promote relbind-partial as gate PASS. |
| Master §7 retrieval quality at N=256 (precision per class; distractor exclusion; ≥95% evidence recall) | **FAIL** | prec 62–250/1000 on retrieve classes; leak_n=9; recall substituted if used as quality; context not in keys. |
| C1 800k / N=4096 / `CAND_CAP_FINAL` / BOARD_PASS / ACCEPT_BOARD / U5 | **NOT CLOSED** | Do not start N=4096 from this audit. |
| Gold-after-FAIL process | **PASS_NARROW** | Gold 09:48:35; PRE MATCH; r0 is copy of first FAIL; host refuses regen. |
| KEEP R1 + KEEP R2 + KEEP R3 + C0 hashes | **UNMODIFIED** | Hashes + timestamps MATCH 0840Z/0915Z/0940Z / C0. |

Promotion scale: **ACCEPT_PARTIAL** of **relbind measured** (named law `qse-v2-relbind-01` implemented as claimed on unpatched C0; WR exclusion via relation-bound k2/k3; leak 10→9; direct still retrieves; honest FAIL; polarity meter intact). **REJECT** promotion of C1 rung-close, Master distractor *exclusion*, Master ≥95% recall, candidate-reduction ≥90%, C1 800k, and any step to N=4096. **Not** FAIL_LOOP (hashes are real, RTL unpatched vs C0, gold not rewritten after FAIL, 800k not claimed, FAIL is honest, relbind delta is real). **Not** `ACCEPT_BOARD`.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-KEY-RELBIND-01` gold/xsim/RESULTS to “clean” this audit. **Do not edit** KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` or `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` or `ASTRA-C1-N256-R3-DISTRACTOR-01`. **Do not patch C0.**

**P1 — remaining law-exclusion FAIL is k0∪k1 union (no object / no subject). Required fix = NEW named key/index law id. Do not silently patch C0. Do not start N=4096. Do not drop threshold.**

1. **Keep the polarity meter and the relbind bag as FAIL evidence.** Do not revert gold to a retrieved subset. Do not score excluded ids as `tp`/`rec=1000`. Do not reuse `"supply duct"` + `{72…75}`. `gold_n>=1` excluded and `leak_n=0` **and** direct gold hits >0 remain the distractor PASS condition.
2. **Do not treat this bag’s FAIL as a TB packing bug.** r0 ≡ xsim; walker locked; gold not rewritten; KEY_MISMATCH not fired.
3. **Do not treat another k2/k3-only rebind as the next unknown.** On this corpus, relbind k2/k3 already duplicate k0/k1 for `"pump supplies chiller"`. Remaining leaks are WO via k0 and WE via k1. A follow-up that only retouches cue tables cannot exclude those nids while the walker still **unions** k0 and k1.
4. **Required next named law (parent maps; freeze contract before coding):** require **both** subject and object (conjunctive probe / intersect tables), so `pump supplies *` and `* supplies chiller` are not independently sufficient. New law id. New named RTL wrappers. Rebuild N=256 directory/postings with the **same** function (host+RTL). Reuse R3/relbind excluded gold nids **if labels unchanged**. Hash gold BEFORE xvlog. Do **not** silently patch C0 hashes `cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
5. **Master FAIL routing (mandatory):** no threshold drop; no `relevant=router_union`; no nid-derived keys; do not rewrite this oracle; do not combine multiple root causes in one patch; do not fake context keys in the same bag.
6. **Keep** the reporting machinery: `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE` + k0–k3 vs direct; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; PASS marker gated on `leak_n=0` and `direct_tp>0`; frozen `a7ng_query_axi_sparse.sv` not compiled as DUT.
7. leftover `a7ng_astra_09_integ_path` stays off xvlog. Token query authority. No U5 citation. No `CAND_CAP_FINAL`. No V3.1. No N=4096 generation.

**P2 — parent / docs:**

1. Map `ACCEPT_PARTIAL` to **relbind measured only**. Next unblocked_item is a **new named key/index law** for k0∪k1 conjunction/intersect if exclusion is still the unknown; **not** N=4096, not C2, not 800k, not A09R8 smoke, not a silent C0 edit, not a gold rewrite of this FAIL bag, not a second relbind of cue tables.
2. Do **not** spawn N=4096 from this report.
3. Do **not** re-run this bag’s xsim to farm a PASS (gold is frozen; leak is the remaining union).
4. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN. `n4096` stays NOT_STARTED.
5. KEEP bags including R1 `fail_r0`, R2 retrieve-subset gold, and R3 `leak_n=10` stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (relbind measured: named law qse-v2-relbind-01
                         k2={rel,cue[7:0]} k3={rel,cue[7:0]} as claimed;
                         C0 hashes MATCH; wrappers only; leftover off;
                         poke_v=0; host=RTL keys; WR {114,118} gone;
                         leak 10→9; CLASS_direct tp=3 prec_ev1=250;
                         polarity meter intact; PASS marker ABSENT;
                         gold-before-xvlog; RESULT=FAIL honest;
                         KEEP R1+R2+R3 unmodified)
PROMOTION        = REJECT  (not C1 800k, not N=4096, not Master ≥95% recall,
                            not Master ≥90% reduction, not entity-context
                            *exclusion* closed, not PASS_THIS_GATE_ONLY;
                            remaining leak is k0∪k1 union)
FAIL_LOOP        = NO
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_KEY_RELBIND_XSIM = FAIL   DISTRACTOR_LEAK leak_n=9 gold_n=11 tp=0 rec_undef
                             PID 24464; 17335 ns; PASS marker ABSENT
                             xsim.log SHA256 48cb3b7f… == xsim_fail_r0.log
                             LAW=qse-v2-relbind-01 k2=510 k3=312
C1_RELBIND_LAW   = PASS_NARROW  k2/k3 rebound as claimed; no nid; C0 unpatched
C1_RELBIND_DELTA = PASS_NARROW  leak 10→9; WR 114/118 gone; direct still tp=3
C1_N256_POLARITY = PASS_NARROW  excluded-set scoring (0915Z P1-3 / 0940Z meter)
C1_N256_EXCLUSION= FAIL         remaining k0∪k1 union (WO+WE);
                                k2/k3 duplicate k0/k1 on this query;
                                NOT a TB packing bug
C1_N256_QUALITY  = FAIL         precision / leak_n=9 / recall substitution
PASS_THIS_GATE   = NOT_CLAIMED  implementer RESULT=FAIL MATCH raw
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 09:48:35; PRE MATCH live;
                                r0 is copy of first FAIL session
HASH_CHECK       = PASS vs C0   cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2 MATCH
NEW_RTL          = 93811ed1… keys_relbind / 37b7858c… axi_sparse_relbind
LEFTOVER_A09     = not compiled
FROZEN_AXI_SPARSE= not compiled as DUT (hash MATCH C0)
POKE_V           = 0
LOAD_FROM_TB     = not present
KEEP_R1          = UNMODIFIED   414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps
KEEP_R2          = UNMODIFIED   e2091bac / 181958be / a089afda + 0915Z timestamps
KEEP_R3          = UNMODIFIED   96f445a9 / a0d99311 / 0ce3bfff + 0940Z timestamps
                                 xsim SHA f953c420 leak_n=10 preserved
REDUCTION_X1000  = NOT_EMITTED  (not 1-CAND_CAP/N)
UNRELATED        = UNRELATED_EMPTY_WALK
WRONG_CONTEXT    = NOT_SELECTIVE keys_match=1 emit_match=1 k2=510 k3=312
DISTRACTOR_QUERY = "pump supplies chiller"  (NOT "supply duct")
DISTRACTOR_GOLD  = EXCLUDED {99,108,109,111,114,118,121,132,193,214,235}
                                 EQUAL to R3; labels unchanged
LEAK_IDS         = {108,109,111,99,121,132,193,214,235}  (114,118 held out)
R3_LEAK_IDS      = {108,109,111,99,121,132,193,214,235,114}  (118 truncated)
HOST_EQ_RTL      = YES          k2=(rel<<8)|(cue[7:0]); 256/256; no KEY_MISMATCH
NID_KEYS         = NO
THRESHOLD_DROP   = NO
RELEVANT_UNION   = NO
LAW_FAIL_ROUTING = no threshold drop; no relevant=router_union; no nid-derived keys;
                   NEW named key/index law id (require both subject+object /
                   intersect tables); do not silently patch C0;
                   do not another k2/k3-only rebind
C1_800K          = OPEN
N_4096           = NOT STARTED
U5_AS_C1         = REJECTED
NEXT             = new named key/index law for k0∪k1 conjunction/intersect
                   (parent) if exclusion still unknown;
                   not N=4096; not C2; not gold rewrite of this FAIL bag;
                   not a silent C0 patch; not a second cue-table rebind
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 in this audit.
