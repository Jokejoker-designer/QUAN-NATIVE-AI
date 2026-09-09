# ASTRA auditor REPORT — 20260907T1020Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-KEY-INTERSECT-01
LAW        = qse-v2-intersect-01
KEEP       = ASTRA-C1-N256-ROLE-RETRIEVAL-01 (must be unmodified; verified)
           + ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01 (must be unmodified; verified)
           + ASTRA-C1-N256-R3-DISTRACTOR-01 (must be unmodified; verified)
           + ASTRA-C1-KEY-RELBIND-01 (must be unmodified; verified)
           + C0 RTL hashes (extract/lexicon/sparse/dir/gate; verified MATCH)
PRIOR      = results/A7-NATIVE-GRAPH/AUDITOR/20260907T0955Z/REPORT.md
           ACCEPT_PARTIAL (relbind measured); exclusion FAIL leak_n=9 remaining k0∪k1
           Required fix = NEW named key/index law id (intersect / both subject+object)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + docs/ASTRA/LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + FAIL routing + C0 SHA256.txt
           WO .agents/handoff/ASTRA-C1-KEY-INTERSECT-01.md
EVIDENCE   = raw xsim.log CLASS_* / ASTRA_C1_KEY_INTERSECT_XSIM_PASS / NOT_SELECTIVE /
             UNRELATED_EMPTY_WALK / FAIL DISTRACTOR_LEAK ABSENT
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 hashes
           + file LastWriteTime (gold vs first xvlog/xsim; KEEP bags vs 0840Z/0915Z/0940Z/0955Z)
           + tb_astra_c1_key_intersect.sv (poke_v, leftover A09, G_GOLD_EXCLUDED, leak scoring)
           + xvlog.log / xelab.log compiled units + xsim_work/xsim.dir/work/*.sdb
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1_key_intersect.py
           + run_xsim.ps1 (PASS-marker gate; leftover gate; SHA freeze; fail_r0 copy-on-FAIL)
           + NEW RTL a7ng_query_axi_sparse_intersect.sv
           + instantiated (not edited) a7ng_query_role_keys_relbind.sv
           + frozen a7ng_query_role_extract.sv / sparse / dir / gate (not patched)
           + independent corpus k0 posting ∩ k1 posting vs emit vs R3/relbind labels
RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = NOT STARTED (this audit does not start it; P1 none on this unknown
               so parent MAY open N=4096 SAME LAW as the next scale unknown, not C2)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not edit KEEP bags R1/R2/R3/KEY-RELBIND, did not write a V3.1 tree, did not patch C0 hashes, and did not spawn agents. Only this file is written.

---

## Scope

Read-only except this file.

Primary object: C1 N=256 **named key law** `qse-v2-intersect-01` after auditor `20260907T0955Z` required a NEW named law that emits **k0 ∩ k1** (subject-rel ∩ object-rel). Remaining relbind leak was k0∪k1 (WO∪WE). Another k2/k3-only rebind was forbidden.

`results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/`

Master §7 primary unknown (full C1): can the frozen role-aware query law retrieve relevant evidence selectively and with bounded traffic through the real index law up to 800,000 records?

This bag is the **N=256 intersect key-law rung only**. It cannot close C1 800k. It cannot itself start N=4096. It cannot close Master evidence-recall ≥95% or candidate-reduction ≥90% (those apply at N≥4096 / 800k).

KEEP (must remain unmodified; this audit does not rewrite them):

- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/` including `fail_r0` and the post-fail gold rewrite
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01/` (reporting bag; distractor gold was retrieve-subset `{72…75}`)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R3-DISTRACTOR-01/` (polarity meter; `leak_n=10` four-table cue-union)
- `results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-RELBIND-01/` (relbind measured; `leak_n=9` remaining k0∪k1)
- C0 hashes of `a7ng_query_role_extract.sv` / `qse_role_lexicon.svh` / `a7ng_sparse_dir_axi.sv` / `a7ng_query_axi_sparse.sv` / `a7ng_route_valid_gate.sv`

**Not** this bag: C1 800k close, N>256 generation, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, historical `ASTRA-02-U5` as C1, silent C0 RTL patch, threshold drop, `relevant=router_union`, nid-derived keys, k2/k3-only rebind as exclusion, patch of `a7ng_sparse_dir_axi`.

Registered unknown (WO / PREREG, frozen before xvlog):

> At N=256, new law `qse-v2-intersect-01` (emit ids in k0∩k1 when both keys valid; relbind keys reused; k2/k3 not unioned), does CLASS_distractor `leak_n=0` on R3 excluded gold while CLASS_direct still retrieves its gold ids (expect `{110,144,145}` for `"pump supplies chiller"`)?

PASS this bag only if `DISTRACTOR leak_n=0` **and** direct gold hits >0.

Hunt (dispatch, none dropped):

1. `reduction_x1000` appearing as cap/N (`1-CAND_CAP/N`)
2. occupancy fillers treated as the precision story (vs `fp_ev1` / `fp_fill0` split)
3. distractor polarity: excluded set vs retrieved subset; leak scored as `FAIL DISTRACTOR_LEAK` not `tp`/`rec=1000`; PSC retrieve scored as `fp_ev1` not leak
4. unrelated 0/0 scored 1000/1000 vs `UNRELATED_EMPTY_WALK`
5. wrong_context k0–k3 / emit vs direct labeled as recall win vs `NOT_SELECTIVE`
6. gold regenerated after FAIL; gold LastWriteTime after first xvlog
7. frozen RTL patched vs C0 hashes
8. leftover `a7ng_astra_09_integ_path` compiled; `poke_v=1`
9. KEEP prior bags SHA/timestamps changed (R1, R2, R3, **and KEY-RELBIND**)
10. RESULTS.md / CLOSEOUT.md vs raw `xsim.log` (PASS claimed vs honest numbers)
11. C1 800k closed / N=4096 started / `ACCEPT_BOARD`
12. gold chosen as k0∩k1 after seeing FAIL (tautology); `leak_n` manufactured
13. query reused `"supply duct"` + gold `{72,73,74,75}`
14. `ASTRA_C1_KEY_INTERSECT_XSIM_PASS` emitted despite `leak_n>0`
15. FAIL is TB packing (`ROLE_COLLAPSE` / `KEY_MISMATCH`) vs remaining union
16. walker unions k0 with k1, or probes k2/k3 as the exclusion mechanism
17. nid-derived keys in intersect or host
18. threshold drop
19. `relevant=router_union`
20. silent C0 patch (edit extract / sparse / dir / gate / lexicon)
21. relbind keys unit edited (must be instantiated, hash `93811ed1…`)
22. leak 9→0 is scoring theatre, not k0∩k1
23. frozen `a7ng_query_axi_sparse.sv` or `a7ng_query_axi_sparse_relbind.sv` compiled as DUT

Master §7 line that this bag is graded against:

> Report precision per class; do not substitute recall alone for retrieval quality.

Required class name (Master §7, distinct from “direct relevant”):

> entity-context distractor

0940Z + WO: gold = entity-context records that **must be excluded**; presence in emit = `FAIL DISTRACTOR_LEAK` (fp, never tp). PASS distractor only if `leak_n=0` and `gold_n>=1` **and** CLASS_direct gold hits >0. Do not reuse `"supply duct"` + `{72…75}`. Target: `"pump supplies chiller"`.

Master §7 FAIL routing (if this bag FAILed):

```text
do not lower threshold
do not relabel relevant=set(router_union)
do not use nid-derived keys
return to index/key architecture only
do not silently patch C0
```

This bag **may** `ACCEPT_PARTIAL` of **this unknown** (`leak_n=0` **and** direct hits at N=256 intersect) without closing Master ≥95% recall, candidate-reduction ≥90%, C1 800k, or N=4096. If P1 is none for this unknown, parent **may** open N=4096 **SAME LAW** (one unknown: scale), not C2. This audit does not start N=4096. Never `ACCEPT_BOARD`.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. Intersect bag is untracked (`??`). KEEP R1 / R2 / R3 / KEY-RELBIND are untracked (`??`). New RTL `a7ng_query_axi_sparse_intersect.sv` is untracked (`??`). Relbind keys / relbind sparse remain untracked at HEAD with **unchanged** hashes vs 0955Z. Frozen extract / lexicon / `query_axi_sparse` remain untracked at HEAD. `git status` still shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD (working tree is the C0-hashed `09334e42…` blob, same finding as 0840Z/0915Z/0940Z/0955Z). `PROGRAM=NO` this process and this bag (no bit, no JTAG, no COM12).

`docs/ASTRA/LOOP_STATE.json` `updated=2026-09-07T10:20:00+07:00` `acceptance=PENDING_AUDITOR_C1_KEY_INTERSECT` `implementer=DONE` `c1_800k=OPEN` `n4096=NOT_STARTED` `auditor=IN_PROGRESS` `final_promotion=REJECT`. Auditor does not edit it. Parent `program=true` is the pinned-SHA silicon pin (`e51bdca2`); it is **not** a license for this audit to program.

File LastWriteTime (local +07), intersect bag:

```text
10:13:02.641  rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect.sv
10:14:24.410  host_astra_c1_key_intersect.py
10:14:24.416  tb_astra_c1_key_intersect.sv
10:15:09.778  run_xsim.ps1
10:16:05.140  PREREG.md ACK.json
10:16:50.144  corpus.json
10:16:50.145  GOLDEN.json
10:16:50.146  query_gold.svh
10:16:50.147  GOLD_HASH_PRE_XVLOG.txt     ← gold hash BEFORE first xvlog
10:17:22.474  SHA256.txt                  ← freeze immediately before first xvlog
10:17:23.379  xvlog.log
10:17:25.661  xelab.log
10:17:28.322  xsim.log                    PID 51140  PASS marker; no fail_r0
10:18:37.973  RESULTS.md CLOSEOUT.md
```

Single XSim session. No second xvlog. Gold files were **not** rewritten between 10:16:50 and 10:18:37 (hash MATCH PRE; LastWriteTime still 10:16:50). `xsim_fail_r0.log` **ABSENT** (PASS session; `run_xsim.ps1` copies r0 only on missing PASS / `FAIL DISTRACTOR_LEAK` / diverge / numeric `reduction_x1000`). Hunt 6 as gold-after-FAIL: **MISS** (no FAIL; gold before xvlog).

`xsim.log` SHA256 `4b17320d3692777f22393d936bab2e5db1513ec296d020a5c5d7c1cb27747b4b` MATCH RESULTS claim. Length 5340 bytes.

Relbind keys unit LastWriteTime **09:43:58** (relbind bag era), SHA `93811ed1…` MATCH 0955Z. Not edited this bag. Relbind sparse SHA `37b7858c…` MATCH 0955Z, not compiled as DUT.

### 2) Live SHA256 vs bag lists vs C0

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time.

**GOLD_HASH_PRE_XVLOG.txt vs live (all MATCH):**

```text
d3b5b88356bd2fc691398a794b2e8b6470d7b3eef2fd56a5d7aeddab8ccb5625  GOLDEN.json
f16119179191036ba1eb2bd8e451e8fd6691095a08d0ec5f9ff81533a9000f55  query_gold.svh
e8b4f8ea3a66bee35c0f10c8f23b91bba851933d3764696a7cd573116e300825  corpus.json
```

**SHA256.txt frozen-RTL / NEW_NAMED_RTL / compiled / bag gold / BAG lines vs live: 26/26 MATCH.** No invented hash. Independent re-hash of every listed path: 0 mismatches.

C0 `SHA256.txt` vs live (this bag must not patch these):

| Object | C0 | Live | Match |
|---|---|---|---|
| `a7ng_query_role_extract.sv` | `cd7baf49…` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` | YES |
| `qse_role_lexicon.svh` | `38189974…` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` | YES |
| `a7ng_sparse_dir_axi.sv` | `09334e42…` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` | YES |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d…` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` | YES |
| `a7ng_route_valid_gate.sv` | `49a66da2…` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` | YES |
| leftover `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES (not compiled) |

C0 files LastWriteTime remain 2026-09-05 (extract/lexicon/sparse/dir/gate). Not touched this bag.

**NEW named RTL (not in C0; listed in this bag’s SHA256.txt `# NEW_NAMED_RTL`):**

```text
93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d  rtl/native_graph/query/a7ng_query_role_keys_relbind.sv
a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c  rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect.sv
```

Relbind keys hash **equals** 0955Z (instantiated, not edited). Hunt **frozen RTL patched**: **MISS vs C0 hashes.** Frozen `a7ng_query_axi_sparse.sv` is hash-gated MATCH C0 and is **not** the DUT. Hunt **silent C0 patch**: **MISS.** Hunt **relbind keys edited**: **MISS.**

TB / host / PREREG / ACK / `run_xsim.ps1` hashes MATCH the `SHA256.txt` `# BAG` / `# COMPILED` lines.

### 3) KEEP prior bags unmodified

0955Z / 0940Z / 0915Z / 0840Z recorded gold hashes and timestamps. Live KEEP:

**R1 `ASTRA-C1-N256-ROLE-RETRIEVAL-01`:**

```text
414f9952583084e3e7c25b1c1e70a6bc1c3dca28e235291f6476f968a66b95b7  GOLDEN.json     MATCH 0840Z/0915Z/0940Z/0955Z
4b61d88f56ccfd9186ed104602d3b914741190ce3b58cb8da5da7d74779c3dfd  query_gold.svh  MATCH
8c342aa23afdbfc8da7f253ee235ccde3a0d0beec40a3cbcdb4e3a487bd22f34  corpus.json     MATCH
```

LastWriteTime KEEP R1 (still): gold 08:31:44; `xsim_fail_r0.log` 08:30:38; `xsim.log` 08:32:01; RESULTS/CLOSEOUT 08:37:00.

**R2 `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01`:**

```text
e2091bac49f95c85d49032ca01ba76d350ec0e4e15cb0b88708e11ebfbb84fa1  GOLDEN.json     MATCH 0915Z/0940Z/0955Z
181958becf400bf6242304831dc66b649ff84a7358476dd2b325703d78f45d70  query_gold.svh  MATCH
a089afda975efd1717c7458b3d02ca701514b03726e31919e1ecbd140d172198  corpus.json     MATCH
```

LastWriteTime KEEP R2 (still): gold 08:59:20; SHA256.txt 09:00:24; `xsim.log` 09:00:29; RESULTS/CLOSEOUT 09:01:39.

**R3 `ASTRA-C1-N256-R3-DISTRACTOR-01`:**

```text
96f445a9dbff7759a63cbc00032c8ca359a78f1a15649254129f9cffdcc5ea9a  GOLDEN.json     MATCH 0940Z/0955Z
a0d993117e538b4847cd9a4bfa520824e9d8cc0ba1f432556b44a18cfdd7de47  query_gold.svh  MATCH
0ce3bfffafa319891fd628c65070f00aff3c05bf954cfcb854f3a6b75f1428cf  corpus.json     MATCH
```

LastWriteTime KEEP R3 (still): gold 09:24:14; SHA256.txt 09:24:36; `xsim.log` / `xsim_fail_r0.log` 09:24:43 SHA `f953c420…`; RESULTS/CLOSEOUT 09:26:23. Raw R3 still prints `FAIL DISTRACTOR_LEAK leak_n=10` and `ASTRA_C1_N256_R3_XSIM_PASS` ABSENT.

**KEY-RELBIND `ASTRA-C1-KEY-RELBIND-01`:**

```text
0f1ba57ac183404a80c35e8d9543f897029e8c9716d14fae6c77ca158e862d4e  GOLDEN.json     MATCH 0955Z
f8835b2e6b552228431a2d0875d60666e33e0e37329aa326415b96e7d26bd2de  query_gold.svh  MATCH
4f981fd93940b258109d1bc21bd96d90db4dd3920ca6c039ef99c1bc9954605e  corpus.json     MATCH
```

LastWriteTime KEEP RELBIND (still): gold 09:48:35; SHA256.txt 09:49:05; `xsim.log` / `xsim_fail_r0.log` 09:49:11 SHA `48cb3b7f…`; RESULTS/CLOSEOUT 09:51:03. Raw relbind still prints `FAIL DISTRACTOR_LEAK leak_n=9` and `ASTRA_C1_KEY_RELBIND_XSIM_PASS` ABSENT.

Hunt 9: **MISS** (neither KEEP bag edited; R3 polarity bag and relbind FAIL evidence left intact).

### 4) Raw xsim (PID 51140)

`xsim.log` PID 51140, session Mon Sep 7 10:17:26–10:17:28, `$finish` 18105 ns. Banner:

```text
C1_KEY_INTERSECT_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW=qse-v2-intersect-01 POKE_V=0 REDUCTION_X1000=NOT_EMITTED
```

Named lines (authority = this log, not RESULTS):

```text
CLASS_direct gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
EMIT_direct n=3
  CAND direct i=0 id=110 ev=1
  CAND direct i=1 id=144 ev=1
  CAND direct i=2 id=145 ev=1
CLASS_paraphrase gold_n=3 emit_n=3 tp=3 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=11 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=28 ovf=1 trunc=12 dirB=32 postB=48 discB=0 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct k0=2561 k1=257 k2=510 k3=312 keys_match=1 emit_match=1 law=qse-v2-intersect-01 xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=3 tp=1 fp_ev1=2 fp_fill0=0 prec_ev1_x1000=333 prec_all_x1000=333 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
CLASS_distractor gold_n=11 emit_n=3 leak_n=0 tp=0 fp_ev1=3 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_undef=1 occ=9 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0 gold_polarity=excluded
EMIT_distractor n=3
  CAND distractor i=0 id=110 ev=1
  CAND distractor i=1 id=144 ev=1
  CAND distractor i=2 id=145 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=12 tp=1 fp_ev1=0 fp_fill0=11 prec_ev1_x1000=1000 prec_all_x1000=83 rec_x1000=1000 occ=28 ovf=1 trunc=21 dirB=32 postB=64 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=5 tp=1 fp_ev1=0 fp_fill0=4 prec_ev1_x1000=1000 prec_all_x1000=200 rec_x1000=1000 occ=12 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=1 tp=1 fp_ev1=0 fp_fill0=0 prec_ev1_x1000=1000 prec_all_x1000=1000 rec_x1000=1000 occ=10 ovf=1 trunc=0 dirB=32 postB=64 discB=0 descB=0 incomp=0
ASTRA_C1_KEY_INTERSECT_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
REDUCTION_X1000=NOT_EMITTED
```

`ASTRA_C1_KEY_INTERSECT_XSIM_PASS` count = **1**. `ASTRA_C1_KEY_INTERSECT_XSIM_NO_MARKER` count = **0**. `FAIL DISTRACTOR_LEAK` count = **0**. Hunt 14: **MISS** (marker present with `leak_n=0` and `direct_tp=3`).

No `FIRST_DIVERGENCE`. No `ROLE_COLLAPSE`. No `KEY_MISMATCH`. No `SEARCH_INCOMPLETE`. No `HOST_SEMANTIC_LEAK`. No `reduction_x1000=<digit>`. Ten named `CLASS_*` markers present. `UNRELATED_EMPTY_WALK` present. `NOT_SELECTIVE` present with `keys_match=1 emit_match=1` and relbind k2/k3 `510/312`. Distractor `rec_undef=1` (not `rec_x1000=1000`). Distractor `tp=0`. Distractor `leak_n=0`. Direct emit ids `{110,144,145}`. Distractor emit ids `{110,144,145}` (PSC retrieve as `fp_ev1=3`, **not** leak). `direct_tp=3`.

TB emits `ASTRA_C1_KEY_INTERSECT_XSIM_PASS` only if `fail==0 && dist_gold_ok && dist_excl_ok && dist_no_leak && unrelated_empty && wc_not_sel && (direct_tp > 0)` (`tb` lines 464–465). `dist_no_leak` is set only when `leak_n==0`. Raw matches.

### 5) TB: poke_v, leftover A09, load_from_tb, scoring polarity, key checks

`tb_astra_c1_key_intersect.sv`:

- Instantiates frozen `a7ng_query_role_extract` (standalone, for KEY_MISMATCH vs gold) **and** DUT `a7ng_query_axi_sparse_intersect` with `.poke_v_i(poke_v)` and `pk*`/`pv*` tied to 0. `CAND_CAP = G_CAND_CAP = 16`.
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
- **Distractor scoring inverted (R3 polarity reused):** `G_GOLD_EXCLUDED[5]=1`; `G_RELEVANT[5]` is the excluded set. Hits increment `leak_n`, never `tp`. `rec_x1000 = -1` (`rec_undef=1`). If `leak_n>0`: print `FAIL DISTRACTOR_LEAK`, `fail = fail + 1`. CLASS line prints `tp=0` `gold_polarity=excluded`. PSC ids in emit increment `fp_ev1`, not `leak_n`.

`xvlog.log` analyzed **only**:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_query_role_keys_relbind.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse_intersect.sv
tb_astra_c1_key_intersect.sv
```

`xelab.log` compiled the same modules. `xsim_work/xsim.dir/work/*.sdb` has those six RTL + TB. **No** `a7ng_astra_09_integ_path`. **No** `a7ng_query_axi_sparse.sdb` (frozen sparse wrapper is not the DUT). **No** `a7ng_query_axi_sparse_relbind.sdb`. Hunt leftover A09 compiled: **MISS.** Hunt frozen `a7ng_query_axi_sparse.sv` compiled as DUT: **MISS.** Hunt relbind sparse compiled as DUT: **MISS.**

`run_xsim.ps1` DUT list matches xvlog; leftover filename on the list throws; xvlog text matching leftover throws; frozen `a7ng_query_axi_sparse.sv` on the list throws; relbind sparse on the list throws; `reduction_x1000=[0-9]` throws; missing PASS marker or `FAIL DISTRACTOR_LEAK` copies r0 and throws `C1INTERSECT_XSIM_FAIL_OR_MARKER_MISSING`. Hash-gate vs C0 expected map; mismatch throws `C1INTERSECT_HASH_GATE_FAIL do_not_invent`. Gold PRE must exist and MATCH live before xvlog.

### 6) Intersect RTL law vs claim vs host twin (hunts 16, 17, 21)

Frozen extract (C0 hash `cd7baf49…`, **not edited**):

```text
k0_o = {subj_id_o, rel_id_o}
k1_o = {obj_id_o,  rel_id_o}
k2_o = subj_cue_o[15:0]          // cue-only; no relation
k3_o = obj_cue_o[15:0]           // cue-only; no relation
```

Named wrapper `a7ng_query_role_keys_relbind.sv` (live SHA `93811ed1…`, **not edited** this bag):

```text
k0_o = k0_i                     // pass-through
k1_o = k1_i                     // pass-through
k2_o = {rel_id_i, subj_cue_i[7:0]}
k3_o = {rel_id_i, obj_cue_i[7:0]}
valids pass through frozen bind-state
```

No `nid` port. No nid in the key equations. Valids are not `key!=0`.

DUT `a7ng_query_axi_sparse_intersect.sv` (live SHA `a912786f…`): instantiates frozen extract → named relbind → frozen `a7ng_route_valid_gate` → frozen `a7ng_sparse_dir_axi`. Walker:

- Latches relbind k0–k3. Frozen gate `probe0_o = k0_valid_i`, `probe1_o = k1_valid_i` (bind-state, not `key!=0`).
- `w_v2 = 0`, `w_v3 = 0` always. k2/k3 **never probed**.
- If `p0 && p1`: `mode = M_AND`; walk k0-only into `buf0`, walk k1-only into `buf1`, `S_SCAN` emits `buf0[i]` only if `in_b` (membership in `buf1`). That is **intersect**, not union.
- Else if only `p0`: `M_K0` (emit k0 posting). Else if only `p1`: `M_K1` (emit k1 posting). Else empty. Fallback is **not** k0∪k1. Registered unknown (`"pump supplies chiller"`) has both keys valid (`G_V0[0]=1 G_V1[0]=1`) so `M_AND`.
- Frozen `a7ng_query_axi_sparse.sv` is not instantiated. Relbind sparse wrapper is not instantiated.

Host `route()`: if both valid, `walk_one_table(k0)` then `walk_one_table(k1)`, emit ids in both; never union k2/k3. Same function.

Independent check on all 256 corpus records: `k0 == (subj<<8)|rel`, `k1 == (obj<<8)|rel`, `k2 == (rel<<8)|(k2_frozen&0xFF)`: **0** failures. `k2==nid` or `k3==nid` or `k0==nid` or `k1==nid`: **0**. Hunt **nid-derived keys**: **MISS.** Hunt **relbind keys edited**: **MISS.** Hunt **walker unions k0 with k1 / probes k2/k3 as exclusion**: **MISS** (for both-valid, which is this unknown).

Direct query keys:

```text
frozen extract k2/k3 = 766 / 4408
relbind     k2/k3 = 510 /  312 = 16'h01FE / 16'h0138
G_K2/G_K3[0]      = 16'h01FE / 16'h0138
xsim NOT_SELECTIVE k2=510 k3=312
k0/k1             = 2561 / 257 = 16'h0A01 / 16'h0101
```

`510 = {rel=1, cue[7:0]=0xFE}`; `312 = {rel=1, cue[7:0]=0x38}`. Pump nid=10 and chiller obj_id=1 are **not** those low bytes.

### 7) Distractor polarity + independent k0 ∩ k1 vs emit

Host `queries_spec` class `distractor`:

```text
text = "pump supplies chiller"     # same tokens as CLASS_direct; NOT "supply duct"
pred = pred_excl                   # two-role overlap; PSC excluded from gold
```

`pred_excl`: evidence=1 records that share two of `{subj=pump=10, rel=supplies=1, obj=chiller=1}` and mismatch the third. `pred_psc` (all three) is the retrieve set, **not** in excluded gold. Computed **before** `route()`. GOLDEN.json `"relevant_is_router_union": false`. `"distractor_gold_polarity": "excluded"`. `"distractor_not_supply_duct": true`.

Independent LSB-first decode of `G_BYTES`:

```text
direct / distractor = "pump supplies chiller"
paraphrase          = "pump supply chiller"
role_reversal       = "chiller supplies pump"
wrong_relation      = "pump requires chiller"
wrong_context       = "pump supplies chiller water"
unrelated           = "payroll tax form"
high_occupancy      = "ahu requires chiller"
overflow_page       = "sensor connects vav"
high_id_sentinel    = "sensor connects tower"
```

`query_gold.svh`:

```text
G_LEN[5]            = 21
G_BYTES[5]          = same 384-bit pack as G_BYTES[0]
G_SUBJ/REL/OBJ[5]   = 10 / 1 / 1
G_K0..K3[5]         = 2561, 257, 510, 312
G_GOLD_EXCLUDED     = '{0,0,0,0,0,1,0,0,0,0}
G_NREL[5]           = 11
G_RELEVANT[5]       = {99,108,109,111,114,118,121,132,193,214,235}
                      NOT {72,73,74,75}; EQUAL to R3 / relbind excluded gold
G_EMIT[5]           = {110,144,145}
                      identical to G_EMIT[0] (same query tokens; intersect)
G_RELEVANT[0]       = {110,144,145}   # pred_psc, same as R3/relbind direct gold
```

Independent re-derive from live `corpus.json` (256 records). **Labels** `(nid,text,evidence,subj,rel,obj,ctx)` vs R3 corpus: **0 mismatches.** vs RELBIND corpus: **0 mismatches.** Keys k2/k3 vs R3 differ on 254/256 (expected: R3 cue-only). Keys k0/k1/k2/k3 vs RELBIND: **0 mismatches** (same relbind function; index rebuilt). Excluded gold nids **equal** R3 and relbind.

Independent posting for query keys k0=2561 k1=257 (exact key match, not bucket):

```text
k0=2561 {subj,rel}  occ=6  → {108,109,110,111,144,145}     pump supplies *
k1=257  {obj,rel}   occ=9  → {99,110,121,132,144,145,193,214,235}  * supplies chiller
k0 ∩ k1             occ=3  → {110,144,145}
k0 ∪ k1 (relbind)          → 12 ids; WO+WE leak
```

| nid | s,r,o | text | two-role tag | in k0 | in k1 | in k0∩k1 |
|---:|---|---|---|---|---|---|
| 110 | 10,1,1 | pump supplies chiller | PSC | Y | Y | Y |
| 144 | 10,1,1 | pump supplies chiller water | PSC | Y | Y | Y |
| 145 | 10,1,1 | pump supplies chiller indirectly | PSC | Y | Y | Y |
| 108 | 10,1,11 | pump supplies valve | WO | Y | N | N |
| 109 | 10,1,12 | pump supplies sensor | WO | Y | N | N |
| 111 | 10,1,2 | pump supplies condenser | WO | Y | N | N |
| 114 | 10,2,1 | pump requires chiller | WR | N | N | N |
| 118 | 10,3,1 | pump connects chiller | WR | N | N | N |
| 99 | 9,1,1 | tower supplies chiller | WE | N | Y | N |
| 121 | 11,1,1 | valve supplies chiller | WE | N | Y | N |
| 132 | 12,1,1 | sensor supplies chiller | WE | N | Y | N |
| 193 | 2,1,1 | condenser supplies chiller | WE | N | Y | N |
| 214 | 3,1,1 | evaporator supplies chiller | WE | N | Y | N |
| 235 | 4,1,1 | compressor supplies chiller | WE | N | Y | N |

Live `xsim.log` `EMIT_direct` / `EMIT_distractor` CAND ids = `{110,144,145}` (all `ev=1`).

Independent leak:

```text
k0 posting ∩ k1 posting == emit == {110,144,145}
excluded ∩ emit = {}                                  leak_n=0
excluded \ emit = all 11 excluded nids
emit \ excluded = {110,144,145}                       PSC retrieve (direct gold)
```

MATCH raw `CLASS_distractor leak_n=0 gold_n=11 tp=0 rec_undef gold_polarity=excluded emit_n=3 fp_ev1=3`. PSC retrieve counted as fp under excluded polarity, **never** as leak and **never** as tp. `rec_x1000=1000` was **not** printed on this class.

Query is **not** `"supply duct"`. Gold is **not** `{72,73,74,75}`. Hunt 13: **MISS.**

`dirB=32 postB=64` = `n_dir=2 * 16` + `n_post=4 * 16`. Two sequential one-table walks (k0 then k1), not four-table union. Relbind had `dirB=64 postB=128` (`n_dir=4`). Traffic shrink is the two-table conjunctive probe, not a numeric `reduction_x1000`.

### 8) Intersect vs relbind — measured effect (not scoring theatre)

Relbind raw (KEEP unmodified, SHA `48cb3b7f…`):

```text
CLASS_direct   emit_n=12 tp=3 fp_ev1=9  prec_ev1=250 trunc=0 dirB=64
FAIL DISTRACTOR_LEAK leak_n=9  emit_n=12 gold_n=11
EMIT = k0∪k1 unique set {108,109,110,111,144,145,99,121,132,193,214,235}
```

This bag:

```text
CLASS_direct   emit_n=3  tp=3 fp_ev1=0  prec_ev1=1000 trunc=0 dirB=32
CLASS_distractor leak_n=0 emit_n=3 gold_n=11 tp=0 rec_undef
EMIT = k0∩k1 {110,144,145}
WO/WE/WR absent from emit
```

Hunt 22 (leak 9→0 is scoring theatre): **MISS.** Delta is the walker no longer emitting WO via k0-only or WE via k1-only. Gold definition unchanged (R3 excluded nids; PSC still retrieve gold). Direct still tp=3 of `{110,144,145}`.

### 9) Tautology / manufactured-leak / gold-as-intersect-after-FAIL (dispatch 12)

**Scoring tautology (R2 shape):** gold = posting prefix scored `tp`/`rec=1000`. This bag does **not** do this for distractor. Distractor gold is a label predicate (`pred_excl`) computed before `route()`. Host checks `set(relevant) != set(emit)` on distractor. Direct gold is `pred_psc`, also before `route()`.

**Gold chosen as k0∩k1 after seeing FAIL:** **MISS as process cheat.**

- No FAIL session (`xsim_fail_r0` ABSENT; gold LastWriteTime 10:16:50; xvlog 10:17:22).
- Direct gold `{110,144,145}` is **identical** to R3 and relbind `pred_psc` (0955Z already stated k0∩k1 = `{110,144,145}` = gold direct **before this bag existed**).
- Distractor gold is the R3 excluded set, **not** the intersection. `G_RELEVANT[5] ≠ G_EMIT[5]`.
- Host comment: “relevant is the label predicate, not set(emit). Intersect may equal gold.” Direct `relevant == emit` is allowed as law success, not as a post-fail rewrite.
- GOLDEN.json already contains `leak_n=0` / `DISTRACTOR_LEAK=false` at 10:16:50, **before** first xvlog. That is the host walker twin predicting the new-law intersect, then hashing gold, then simulating. Host `main()` returns 3 (`GOLD_IMMUTABLE`) if `xsim.log` / `xvlog.log` / `xsim_fail_r0.log` exist.

**Law identity (not a cheat):** on this corpus, PSC triples **are** exactly the records with both `{subj,rel}=k0` and `{obj,rel}=k1` for `"pump supplies chiller"`. So `pred_psc == k0∩k1 == emit`. That is the registered law working at N=256. It is **not** Master ranking quality and **not** a license to close ≥95% at 800k.

Hunt 12 as “excluded set is the posting itself”: **MISS.** Excluded set is two-role overlap; posting (emit) is PSC. `excluded ∩ emit = ∅`.

Hunt **manufactured leak_n=0**: **MISS.** Independent exact-key posting intersection equals emit; excluded ids are not in that set.

### 10) Precision split, reduction, wrong_context, unrelated, threshold

**fp_ev1 vs fp_fill0:** present on every CLASS line except unrelated (named empty-walk). Direct: `fp_ev1=0 fp_fill0=0 prec_ev1=1000=prec_all`. Direct/distractor emit ids are all `ev=1`. Direct precision 1000 is conjunctive identity (emit = PSC gold), not occupancy fillers. Distractor `fp_ev1=3` is the PSC retrieve set under excluded polarity — correct for this class.

high_occupancy: `prec_ev1=1000 prec_all=83` with `fp_fill0=11`. Independent: k0=1538 occ=25, k1=258 occ=28, full intersect n=21; CAND_CAP-truncated walks emit `{147…158}` (gold 147 + 11 synth fillers that share both keys). Split is real. trunc=21 = (25-16)+(28-16).

wrong_relation: k0 occ=4, k1 occ=28, intersect `{114}` only; trunc=12 is k1 cap. Gold 114 in emit.

**reduction_x1000 as cap/N:** **MISS as emitted metric.** Banner and close print `REDUCTION_X1000=NOT_EMITTED`. No `reduction_x1000=<integer>`. GOLDEN per-query field is the string `"NOT_EMITTED"`. Do not read 16/256 or 3/256 as Master ≥90% (that bound is N≥4096).

**unrelated:** `UNRELATED_EMPTY_WALK gold_n=0 emit_n=0`. Host `prec_all is None and recall is None`. Not 1000/1000. **PASS** as named check.

**wrong_context:** `NOT_SELECTIVE` with k0–k3 identical to direct (`2561,257,510,312`) and `emit_match=1`. Intersect still has no context key (xid is not a directory key). CLASS still prints `rec_x1000=1000` `prec=333`; RESULTS does **not** call that a context-selectivity win. Labeling requirement: **PASS**. Selectivity of the new law: still **NOT_SELECTIVE** (expected; WO: do not fake ctx keys).

**threshold drop:** CAND_CAP remains 16 (same as R1/R2/R3/relbind); INDEX_HEAD remains 4; no score/min-hit threshold in TB, host, or intersect RTL. Hunt 18: **MISS.**

**`relevant=router_union`:** GOLDEN `"relevant_is_router_union": false`. `G_RELEVANT[5]` is the excluded two-role set, not `G_EMIT[5]`. Hunt 19: **MISS.**

### 11) RESULTS.md / CLOSEOUT.md vs raw xsim.log (honesty hunt)

RESULTS CLASS table numbers **MATCH** `xsim.log` exactly (gold_n / emit_n / tp / leak_n / fp_ev1 / fp_fill0 / prec_ev1 / prec_all / rec / notes). No invented P/R. Discloses `C1_800K=OPEN`, `BOARD_PASS=NOT_CLAIMED`, `REDUCTION_X1000=NOT_EMITTED`, KEEP bags not edited, gold not regenerated, PASS marker emitted, C0 hashes MATCH.

Implementer `RESULT = PASS_THIS_GATE_ONLY` / CLOSEOUT `RESULT = PASS_THIS_GATE_ONLY` / `ASTRA_C1_KEY_INTERSECT_XSIM_PASS emitted` / `LEAK_N = 0` / `DISTRACTOR_TP = 0` / `DISTRACTOR_REC = undef` / `DIRECT_TP = 3`: **HONEST vs raw.** `LOOP_STATE.json` `implementer=DONE` is consistent. This is not a C1-800k overclaim.

Split in RESULTS “Unknown”:

- Direct retrieve: **yes** (`tp=3` of `{110,144,145}`) — MATCH raw and independent posting.
- Entity-context exclusion (`leak_n=0`): **yes** (`leak_n=0/11`; `tp=0`; `rec_undef`) — MATCH raw and independent `excluded ∩ emit = ∅`.
- Gate requires `leak_n=0` **and** direct gold hits >0 for `PASS_THIS_GATE_ONLY`. Therefore PASS this gate only.

Do not read RESULTS “Direct `prec_ev1=1000`” as Master retrieval quality. It is k0∩k1 identity on a 3-id gold set inside cap.

Hunt **overclaim of C1 800k / N=4096 / BOARD_PASS / Master ≥95%**: **MISS as claim** (listed under Not claimed). Hunt **PASS marker despite leak**: **MISS.**

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. `reduction_x1000` as cap/N | **MISS.** Not emitted as a number. | Do not carry 16/256 or 3/256 into N=4096 as candidate-reduction. |
| 2. occupancy fillers as the precision story | **MISS as RESULTS prose** (direct fp_fill0=0; hoc fp_fill0=11 split stated). **HIT as quality caveat:** rec=1000 on 3 retrieve-class gold ids inside cap is still not Master retrieval quality. Direct 1000 is conjunctive identity, not ranking. | Precision 333 on wrong_context; hoc prec_all=83; distractor prec_ev1=0 under excluded polarity. |
| 3. distractor polarity | **MISS as OVERCLAIM.** Gold is excluded set gold_n=11; tp=0; rec_undef; leak_n=0; PSC `{110,144,145}` scored fp_ev1=3 not leak. | Scoring polarity **PASS_NARROW** (R3 meter reused). Law exclusion **PASS_NARROW** at N=256. |
| 4. unrelated 0/0 = 1000/1000 | **MISS.** `UNRELATED_EMPTY_WALK`. | Keep named; do not reintroduce 1000/1000. |
| 5. wrong_context rec=1000 as selectivity | **MISS as claim** (`NOT_SELECTIVE` + RESULTS). **HIT as law:** keys_match=1 emit_match=1 (xid still not a key). | Do not fake context keys. Do not patch C0 to chase context. |
| 6. gold after FAIL / after first xvlog | **MISS** on GOLDEN / svh / corpus (10:16:50; PRE hashes MATCH live). No fail_r0. Host refuses regen. | Do not regenerate gold. New labels ⇒ new named bag. |
| 7. frozen RTL patched | **MISS vs C0 live hashes.** Frozen sparse not compiled as DUT. C0 files still 2026-09-05. | Do not silently patch QSE/dir/sparse/gate/lexicon. |
| 8. leftover A09 compiled / poke_v=1 | **MISS.** poke_v held 0; leftover off xvlog/xelab/sdb. | Keep off. |
| 9. KEEP bags mutated | **MISS.** R1 414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps. R2 e2091bac / 181958be / a089afda + 0915Z timestamps. R3 96f445a9 / a0d99311 / 0ce3bfff + 0940Z timestamps / xsim SHA f953c420. RELBIND 0f1ba57a / f8835b2e / 4f981fd9 + 0955Z timestamps / xsim SHA 48cb3b7f. | Leave all four KEEP bags including R1 fail_r0, R3 leak_n=10, relbind leak_n=9. |
| 10. RESULTS vs xsim numbers / FAIL honesty | **MISS** (table MATCH; RESULT=PASS_THIS_GATE_ONLY honest vs raw). **MISS** as 800k overclaim. | Authority = raw CLASS_* + polarity/exclusion/intersect-delta split above. |
| 11. C1 800k / N=4096 / BOARD_PASS | **MISS as claim.** | Never grant. This audit does not start N=4096. |
| 12. gold = k0∩k1 after FAIL; leak_n manufactured | **MISS as scoring cheat** (no FAIL; pred_psc/pred_excl before route; distractor gold ≠ emit; gold = R3 labels; PRE before xvlog). **HIT as law identity** (PSC labels equal k0∩k1 by construction of `{subj,rel}∩{obj,rel}`). | Do not treat leak_n=0 as a TB bug. Do not treat prec=1000 as Master ≥95%. |
| 13. reuse `"supply duct"` + `{72…75}` | **MISS.** Query `"pump supplies chiller"`; gold 11 two-role nids, equal R3. | Do not revert to R2 retrieve-subset. |
| 14. PASS marker despite leak | **MISS.** Marker present with leak_n=0 and direct_tp=3. | Keep marker gated on leak_n=0 **and** direct_tp>0. |
| 15. FAIL is TB packing vs remaining union | **N/A as FAIL.** No packing diverge. Remaining union **closed** at N=256 by M_AND. | Walker bit-exact to G_EMIT; no ROLE_COLLAPSE; no KEY_MISMATCH. |
| 16. walker unions k0 with k1 / k2/k3-only exclusion | **MISS** on both-valid path (this unknown). w_v2=w_v3=0. M_AND emits buf0 ∩ buf1. | M_K0/M_K1 fallback exists when only one key valid — residual, not this unknown. |
| 17. nid-derived keys | **MISS.** Intersect has no nid port; k0/k1/k2/k3 ≠ nid on this corpus; packing is `{subj,rel}`/`{obj,rel}`/`{rel,cue[7:0]}`. | Do not introduce nid keys. |
| 18. threshold drop | **MISS.** CAND_CAP=16; INDEX_HEAD=4; no score threshold. Same cap as R1/R2/R3/relbind. | Do not lower cap. |
| 19. `relevant=router_union` | **MISS** on `G_RELEVANT` / GOLDEN relevant. | `G_EMIT` is walker twin oracle (bit-exact), not the label set. |
| 20. silent C0 patch | **MISS.** Five frozen SHAs MATCH C0. | Do not edit extract/lexicon/dir/sparse/gate. |
| 21. relbind keys edited | **MISS.** SHA 93811ed1… MATCH 0955Z; LastWriteTime 09:43:58. | Instantiate only. |
| 22. leak 9→0 scoring theatre | **MISS.** Independent k0∩k1 = emit; WO/WE left because they are not in both postings. | Measured intersect effect. |
| 23. frozen/relbind sparse compiled as DUT | **MISS.** sdb list is extract + relbind keys + gate + dir + mem + intersect + TB. | Keep frozen sparse and relbind sparse off xvlog. |
| Hash theatre | **MISS** on listed gold/RTL paths (live MATCH, 26/26 SHA256.txt lines). PRE attests gold-before-first-xvlog. | SHA256.txt 10:17:22 is the first-xvlog freeze. |
| cap≥N selectivity | **MISS.** CAND_CAP=16 < 256. | Instantiated 16 ≠ `CAND_CAP_FINAL`. |

qstack-validation-adversary one-liner: **Intersect XSim is a real named-law twin lock at N=256 on unpatched C0 hashes that PASSes this gate only: CLASS_distractor leak_n=0 tp=0 rec_undef gold_polarity=excluded while CLASS_direct retrieves {110,144,145} tp=3 prec_ev1=1000; independent k0 posting ∩ k1 posting equals emit; relbind keys instantiated not edited; k2/k3 not probed; remaining relbind leak k0∪k1 is closed at this corpus/cap; that is not Master ≥95%, not C1 800k, not N=4096, not nid keys, not a C0 patch, and not ACCEPT_BOARD.**

---

## Logic bugs

No DUT vs host-twin mismatch (emit lists match `G_EMIT`; CLASS lines match GOLDEN predicted leak_n=0; intersect is buf0∩buf1). Findings are **index-law quality / promotion bounds**, not “patch frozen QSE in this bag” and not “fix TB packing”:

1. **Intersect law is implemented as claimed on the both-valid path.** Named walker only. Frozen extract unpatched. Relbind keys instantiated not edited. DUT walks k0 then k1 and emits membership AND. k2/k3 valids forced 0. C0 hashes MATCH. leftover A09 off. poke_v=0.
2. **Intersect has a measured effect.** Relbind leak_n=9 (WO∪WE via k0∪k1) → this bag leak_n=0. Direct still tp=3 of `{110,144,145}`. Independent posting composition confirms. That is ACCEPT_PARTIAL of **this unknown**, not C1 800k.
3. **Direct prec=1000 is law identity, not ranking.** PSC gold is exactly k0∩k1 on this corpus because gold is `(s,r,o)` and keys are `{s,r}`/`{o,r}`. Recall 1.0 on a 3-id set inside cap is not Master ≥95% evidence recall.
4. **Scoring polarity remains correct.** Excluded gold, leak=FAIL if present, tp=0, rec_undef, query `"pump supplies chiller"`, gold_n=11≥1, gold nids equal R3, PASS marker present only with leak_n=0 and direct_tp>0, PSC retrieve as fp_ev1 on distractor.
5. **Frozen keys still omit context.** wrong_context ≡ direct walk under intersect. Correctly labeled `NOT_SELECTIVE`. Do not invent a context key inside a promotion to N=4096.
6. **Single-key fallback `M_K0`/`M_K1` is not conjunctive.** Not exercised on the registered query (both valid). Residual for other queries; not P1 for this unknown.
7. **CAND_CAP truncates each table before AND.** At N=256 PSC occupancies 6 and 9 fit. high_occupancy full intersect n=21, emit 12 after 16-cap walks. At N=4096 this **is** the scale unknown (prefix-intersect may drop gold or keep fillers).
8. **Index is `axi_mem_model`, not MIG/DDR.** Honest for N=256 XSim; illegal as C2 / production retrieval / 800k close.
9. **k2/k3 still indexed** (host builds four tables with relbind keys) **but not probed.** Exclusion is k0∩k1, not another cue rebind. Compliant with WO.
10. **fail_r0 was not written** because the session PASSed the gate. Gold hashed once before that session. Not FAIL_LOOP.

No auditor patch. Do not edit this bag’s gold or RTL. Do not edit KEEP bags. Do not patch C0.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| XSim twin-lock (C0 hashes, leftover off, poke_v=0, n_host=0, CAND_CAP=16<256, gold PRE MATCH live, KEEP unmodified, no packing diverge, host=RTL intersect) | **PASS_NARROW** | Bit-exact to host walker on frozen C0 files + named intersect. Simulation only. Not DDR. Not 800k. |
| Intersect law as claimed (emit k0∩k1 when both valid; k2/k3 not probed; no k0∪k1; relbind instantiated not edited; no nid) | **PASS_NARROW** | RTL M_AND + host route() + independent posting ∩ + G_EMIT `{110,144,145}`. Frozen extract unpatched. |
| Registered unknown (`leak_n=0` **and** CLASS_direct gold hits `{110,144,145}`) | **PASS_NARROW** | Raw leak_n=0 gold_n=11 tp=0 rec_undef; direct tp=3 emit `{110,144,145}`. PASS marker present. |
| Scoring polarity (excluded gold, leak=FAIL not tp, rec_undef, gold_n=11, query `"pump supplies chiller"`, not `{72…75}`, PSC as fp_ev1) | **PASS_NARROW** | R3 meter reused correctly. |
| Entity-context **exclusion** (`leak_n=0`) | **PASS_NARROW** at N=256 | Independent `excluded ∩ emit = ∅`. WO/WE/WR not in k0∩k1. Not a TB bug. |
| `PASS_THIS_GATE_ONLY` / `ASTRA_C1_KEY_INTERSECT_XSIM_PASS` | **PASS_NARROW / PRESENT** | Implementer RESULT=PASS_THIS_GATE_ONLY MATCH raw. Do not promote as C1 800k. |
| Master §7 retrieval quality at N=256 (precision per class; ≥95% evidence recall; ≥90% reduction) | **FAIL as Master close** | Direct prec=1000 is 3-id identity; wrong_context 333; hoc prec_all=83; rec substituted if used as quality; context not in keys; reduction not emitted. |
| C1 800k / N=4096 / `CAND_CAP_FINAL` / BOARD_PASS / ACCEPT_BOARD / U5 | **NOT CLOSED** | This audit does not start N=4096. |
| Gold-after-FAIL process | **PASS_NARROW** | Gold 10:16:50; PRE MATCH; no r0; host refuses regen. |
| KEEP R1 + KEEP R2 + KEEP R3 + KEEP RELBIND + C0 hashes | **UNMODIFIED** | Hashes + timestamps MATCH 0840Z/0915Z/0940Z/0955Z / C0. |

Promotion scale: **ACCEPT_PARTIAL** of **this unknown** (named law `qse-v2-intersect-01` implemented as claimed on unpatched C0; emit k0∩k1; `leak_n=0` on R3 excluded gold; CLASS_direct still retrieves `{110,144,145}` tp=3 prec_ev1=1000; polarity meter intact; PASS marker present; gold-before-xvlog; RESULT=PASS_THIS_GATE_ONLY honest; KEEP R1+R2+R3+RELBIND unmodified). **REJECT** promotion of C1 800k, Master ≥95% recall, candidate-reduction ≥90%, `CAND_CAP_FINAL`, BOARD_PASS, and any claim that N=4096 is already done. **Not** FAIL_LOOP (hashes are real, RTL unpatched vs C0, gold not rewritten, 800k not claimed, PASS is honest, intersect delta is real). **Not** `ACCEPT_BOARD`.

**P1 for this unknown: none.** Parent **may** open N=4096 **SAME LAW** (one unknown: scale — does conjunctive k0∩k1 still retrieve gold and hold `leak_n=0` when postings exceed CAND_CAP / INDEX_HEAD on a larger corpus?). Not C2. Not a new key law unless scale reveals a new root cause. This audit does not generate N=4096.

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-KEY-INTERSECT-01` gold/xsim/RESULTS to “improve” this audit. **Do not edit** KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` or `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` or `ASTRA-C1-N256-R3-DISTRACTOR-01` or `ASTRA-C1-KEY-RELBIND-01`. **Do not patch C0.**

**P1 — none for this unknown** (`leak_n=0` and direct hits at N=256 intersect, independently confirmed).

**P2 — parent / scale / quality (do not treat as a license to silently patch C0 or drop threshold):**

1. **Keep the polarity meter and this bag as PASS_THIS_GATE_ONLY evidence.** Do not revert gold to a retrieved subset. Do not score excluded ids as `tp`/`rec=1000`. Do not reuse `"supply duct"` + `{72…75}`. `gold_n>=1` excluded and `leak_n=0` **and** direct gold hits >0 remain the distractor PASS condition at the next rung.
2. **If parent opens N=4096, SAME LAW `qse-v2-intersect-01`.** One unknown: scale. Rebuild directory/postings with the **same** host+RTL function. Hash gold BEFORE xvlog. Do **not** silently patch C0 hashes `cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`. Do not drop CAND_CAP. Do not set `relevant=router_union`. Do not use nid-derived keys. Do not fake context keys in the same bag. Do not compile leftover A09. poke_v=0. PROGRAM=NO. C1 800k stays OPEN until 800k is actually measured.
3. **Scale risks already visible at N=256:** each table is capped at CAND_CAP **before** AND (hoc full intersect 21, emit 12); INDEX_HEAD=4 sets `ovf=1` even on PSC; `axi_mem_model` is not MIG/DDR; M_K0/M_K1 fallback is not conjunctive; xid still not a key.
4. **Do not read direct prec=1000 as Master ≥95%.** It is `{subj,rel}∩{obj,rel}` identity on three PSC nids. Master evidence-recall ≥95% and candidate-reduction ≥90% apply at N≥4096 / 800k and are **not** closed.
5. **Keep** the reporting machinery: `fp_ev1` vs `fp_fill0`; `UNRELATED_EMPTY_WALK`; `NOT_SELECTIVE` + k0–k3 vs direct; no numeric `reduction_x1000`; leftover A09 off xvlog; `poke_v=0`; gold hashed before first xvlog; never regen gold after FAIL; PROGRAM=NO; C1 800k OPEN; PASS marker gated on `leak_n=0` and `direct_tp>0`; frozen `a7ng_query_axi_sparse.sv` not compiled as DUT; relbind sparse not compiled as DUT; relbind keys instantiated not edited.
6. leftover `a7ng_astra_09_integ_path` stays off xvlog. Token query authority. No U5 citation. No `CAND_CAP_FINAL`. No V3.1. This audit does not start N=4096.
7. `docs/ASTRA/LOOP_STATE.json` remains parent-owned. `c1_800k` stays OPEN until a 800k measurement exists. `n4096` may move from NOT_STARTED to an opened SAME-LAW bag **by parent**, not by this report writing N=4096 files.
8. KEEP bags including R1 `fail_r0`, R2 retrieve-subset gold, R3 `leak_n=10`, and relbind `leak_n=9` stay on disk as evidence of prior process.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
ACCEPT_PARTIAL   = YES  (this unknown: leak_n=0 + direct hits at N=256 intersect;
                         named law qse-v2-intersect-01 emit k0∩k1 when both valid;
                         C0 hashes MATCH; relbind keys instantiated not edited;
                         k2/k3 not probed; leftover off; poke_v=0; host=RTL;
                         CLASS_direct tp=3 emit {110,144,145} prec_ev1=1000 rec=1000;
                         CLASS_distractor leak_n=0 gold_n=11 tp=0 rec_undef
                         gold_polarity=excluded emit_n=3 fp_ev1=3 (PSC not leak);
                         independent k0 posting ∩ k1 posting == emit;
                         polarity meter intact; PASS marker PRESENT;
                         gold-before-xvlog; RESULT=PASS_THIS_GATE_ONLY honest;
                         KEEP R1+R2+R3+RELBIND unmodified)
PROMOTION        = REJECT  (not C1 800k, not N=4096 closed, not Master ≥95% recall,
                            not Master ≥90% reduction, not ACCEPT_BOARD,
                            not CAND_CAP_FINAL; direct prec=1000 is 3-id identity)
FAIL_LOOP        = NO
P1_THIS_UNKNOWN  = NONE
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_KEY_INTERSECT_XSIM = PASS_THIS_GATE_ONLY
                             leak_n=0 gold_n=11 tp=0 rec_undef
                             direct_tp=3 ids {110,144,145} prec_ev1=1000 rec=1000
                             PID 51140; 18105 ns; PASS marker PRESENT
                             FAIL DISTRACTOR_LEAK ABSENT; fail_r0 ABSENT
                             xsim.log SHA256 4b17320d…
                             LAW=qse-v2-intersect-01 k0=2561 k1=257 k2=510 k3=312
C1_INTERSECT_LAW = PASS_NARROW  M_AND buf0∩buf1; w_v2=w_v3=0; no nid; C0 unpatched
C1_INTERSECT_DELTA = PASS_NARROW  leak 9→0 vs relbind; WO/WE gone; direct still tp=3
C1_N256_POLARITY = PASS_NARROW  excluded-set scoring (0915Z P1-3 / 0940Z meter)
C1_N256_EXCLUSION= PASS_NARROW  leak_n=0/11 at N=256; independent posting ∩
C1_N256_QUALITY  = FAIL as Master close  (3-id identity / wrong_context 333 /
                                          hoc fillers / recall substitution)
PASS_THIS_GATE   = CLAIMED and MATCH raw
GOLD_AFTER_FAIL  = MISS         GOLDEN/svh/corpus 10:16:50; PRE MATCH live;
                                no r0; PASS session
HASH_CHECK       = PASS vs C0   cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2 MATCH
NEW_RTL          = a912786f… axi_sparse_intersect
RELBIND_KEYS     = 93811ed1… instantiated not edited (MATCH 0955Z)
LEFTOVER_A09     = not compiled
FROZEN_AXI_SPARSE= not compiled as DUT (hash MATCH C0)
RELBIND_SPARSE   = not compiled as DUT (hash MATCH 0955Z)
POKE_V           = 0
LOAD_FROM_TB     = not present
KEEP_R1          = UNMODIFIED   414f9952 / 4b61d88f / 8c342aa2 + 0840Z timestamps
KEEP_R2          = UNMODIFIED   e2091bac / 181958be / a089afda + 0915Z timestamps
KEEP_R3          = UNMODIFIED   96f445a9 / a0d99311 / 0ce3bfff + 0940Z timestamps
                                 xsim SHA f953c420 leak_n=10 preserved
KEEP_RELBIND     = UNMODIFIED   0f1ba57a / f8835b2e / 4f981fd9 + 0955Z timestamps
                                 xsim SHA 48cb3b7f leak_n=9 preserved
REDUCTION_X1000  = NOT_EMITTED  (not 1-CAND_CAP/N)
UNRELATED        = UNRELATED_EMPTY_WALK
WRONG_CONTEXT    = NOT_SELECTIVE keys_match=1 emit_match=1 k2=510 k3=312
DISTRACTOR_QUERY = "pump supplies chiller"  (NOT "supply duct")
DISTRACTOR_GOLD  = EXCLUDED {99,108,109,111,114,118,121,132,193,214,235}
                                 EQUAL to R3 and relbind; labels unchanged
LEAK_IDS         = {}
EMIT_DIRECT      = {110,144,145}  == k0∩k1 == pred_psc
K0_POSTING       = {108,109,110,111,144,145}
K1_POSTING       = {99,110,121,132,144,145,193,214,235}
HOST_EQ_RTL      = YES          intersect both-valid; 256/256 packing; no KEY_MISMATCH
NID_KEYS         = NO
THRESHOLD_DROP   = NO
RELEVANT_UNION   = NO
UNION_WALK       = NO           (both-valid path)
K2K3_PROBED      = NO
LAW_FAIL_ROUTING = N/A this unknown (PASS); still: no threshold drop;
                   no relevant=router_union; no nid-derived keys;
                   no silent C0 patch if scale FAILs
C1_800K          = OPEN
N_4096           = NOT STARTED  (parent MAY open SAME LAW; this audit does not)
U5_AS_C1         = REJECTED
NEXT             = parent may open N=4096 SAME LAW qse-v2-intersect-01
                   (one unknown: scale), not C2, not a new key law,
                   not gold rewrite of this PASS bag, not a silent C0 patch,
                   not k2/k3-only rebind, not threshold drop
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 in this audit.
