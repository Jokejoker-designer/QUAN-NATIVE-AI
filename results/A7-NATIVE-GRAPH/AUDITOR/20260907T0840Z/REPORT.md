# ASTRA auditor REPORT — 20260907T0840Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C1-N256-ROLE-RETRIEVAL-01
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §7 C1 + C0 FINAL_CONTRACT.json
           C0 auditor 20260907T0745Z (ACCEPT_PARTIAL of law freeze; C1–C7 remained OPEN)
EVIDENCE   = raw xsim.log CLASS_* + ASTRA_C1_N256_XSIM_PASS
           + xsim_fail_r0.log ROLE_COLLAPSE
           + live Get-FileHash vs GOLD_HASH_PRE_XVLOG.txt + SHA256.txt + C0 FINAL_CONTRACT
           + tb_astra_c1_n256.sv (poke_v, leftover A09, load_from_tb)
           + xvlog.log / xelab.log compiled units
           + query_gold.svh / GOLDEN.json / corpus.json / host_astra_c1.py
           + file LastWriteTime vs fail_r0
           RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1_800K      = OPEN
N_4096       = NOT STARTED (this audit does not start it)
```

This auditor did not program the board, did not edit `rtl/`, did not edit the implementer bag, did not write a V3.1 tree, and did not spawn agents.

---

## Scope

Read-only except this file.

Primary object: C1 first rung N=256 role-law sparse retrieval

`results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/`

Master §7 primary unknown (full C1): can the frozen role-aware query law retrieve relevant evidence selectively and with bounded traffic through the real index law up to 800,000 records?

This bag is the **N=256 first rung only**. It cannot close C1 800k. It cannot start N=4096.

**Not** this bag: C1 800k, N>256, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes, leftover A09 as DUT, historical `ASTRA-02-U5` as C1.

Hunt (dispatch, none dropped):

1. `reduction_x1000=938` used as Master candidate-reduction ≥90% (it is 16/256 cap/N)
2. occupancy fillers treated as retrieval quality
3. distractor gold=0 / unrelated 0/0 tautology
4. C1 800k closed
5. cap≥N as selectivity
6. `relevant=router_union`
7. gold edited after fail_r0
8. frozen RTL patched vs C0 FINAL_CONTRACT
9. historical ASTRA-02-U5 used as this close

Plus boot hunts: poke_v / load_from_tb as query authority, leftover A09 compiled, RESULTS vs raw xsim.log (parent wrote RESULTS after implementer XSim).

Master §7 line that this bag is graded against:

> Report precision per class; do not substitute recall alone for retrieval quality.

---

## Evidence re-derived

### 1) Git / bag identity / timestamps

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base`. Bag is untracked (`??`). `PROGRAM=NO` this process and this bag (no bit, no JTAG, no COM12).

File LastWriteTime (local +07), authority for hunt 7:

```text
08:25:33  PREREG.md ACK.json
08:29:18  tb_astra_c1_n256.sv
08:30:07  run_xsim.ps1
08:30:36  xsim_fail_r0.log session start  PID 47632
08:30:38  xsim_fail_r0.log / xsim_47632.backup.log  ROLE_COLLAPSE
08:31:37  host_astra_c1.py          ← AFTER fail_r0
08:31:44  GOLDEN.json query_gold.svh corpus.json GOLD_HASH_PRE_XVLOG.txt  ← AFTER fail_r0
08:31:56  SHA256.txt  header 2026-09-07T08:31:56.0070125+07:00
08:31:57  xvlog.log
08:31:59  xsim.log session start  PID 4532
08:32:01  xsim.log exit + ASTRA_C1_N256_XSIM_PASS
08:37:00  RESULTS.md CLOSEOUT.md    ← ~5 min after XSim (parent; implementer session ended)
```

`LOOP_STATE.json` `updated=2026-09-07T08:40:00+07:00` `acceptance=PENDING_AUDITOR_C1_N256` `c1_800k=OPEN` `auditor=IN_PROGRESS`. Auditor does not edit it.

### 2) Live SHA256 vs bag lists vs C0 FINAL_CONTRACT

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time.

**GOLD_HASH_PRE_XVLOG.txt vs live (all MATCH):**

```text
414f9952583084e3e7c25b1c1e70a6bc1c3dca28e235291f6476f968a66b95b7  GOLDEN.json
4b61d88f56ccfd9186ed104602d3b914741190ce3b58cb8da5da7d74779c3dfd  query_gold.svh
8c342aa23afdbfc8da7f253ee235ccde3a0d0beec40a3cbcdb4e3a487bd22f34  corpus.json
```

These three files were **rewritten at 08:31:44**, after fail_r0 08:30:38. The PRE file therefore attests gold-before-the-**PASS** xvlog, not gold-before-the-**first** xvlog. Pre-fail gold is not on disk (overwritten). `xsim_work` is the second run only (`xsim.jou` session 08:31:59 PID 4532).

**SHA256.txt frozen-RTL / compiled / bag lines vs live: all MATCH.** No invented hash.

C0 `FINAL_CONTRACT.json` prefixes vs live (C1 must not patch these):

| Object | C0 / expected | Live | Match |
|---|---|---|---|
| `a7ng_query_role_extract.sv` | `cd7baf49…` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` | YES |
| `qse_role_lexicon.svh` | `38189974…` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` | YES |
| `a7ng_sparse_dir_axi.sv` | `09334e42…` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` | YES |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d…` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` | YES |
| `a7ng_route_valid_gate.sv` | `49a66da2…` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` | YES |
| leftover `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES (not compiled) |
| SGD (not this DUT) | `b66ef328…` | MATCH | YES |
| A09-R2 (not this DUT) | `15a919f1…` | MATCH | YES |

Hunt **frozen RTL patched**: **MISS vs C0 hashes.** `git status` shows `M rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` vs HEAD blob `39c03370…` (working tree `54ffc3cc…`, +39/−19). That dirty tree is **exactly** the C0-hashed `09334e42…` file. C1 did not retouch it after C0. Role-extract / lexicon / `query_axi_sparse` are untracked at HEAD and MATCH C0.

### 3) fail_r0 (raw), then PASS xsim (raw)

`xsim_fail_r0.log` PID 47632, session Mon Sep 7 08:30:36–08:30:38:

```text
C1_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW_SEL=1
FIRST_DIVERGENCE ROLE_COLLAPSE q=0 direct subj/obj/rel/ctx 0 0 0 0
$finish ... tb_astra_c1_n256.sv Line 144
```

No CLASS_* lines. QSE returned unbound 0/0/0/0 on query 0. Consistent with TB `bytes[8*bi +: 8]` reading the **LSB** of `G_BYTES` while an earlier pack put ASCII at the MSB (leading zeros → empty tokens). Current `query_gold.svh` LSB decode of query 0 is `pump supplies chiller` (21 bytes). `host_astra_c1.py` + gold files were rewritten after this fail.

`xsim.log` PID 4532, session 08:31:59–08:32:01, `$finish` 15755 ns:

```text
C1_N=256 CAND_CAP=16 INDEX_HEAD=4 LAW_SEL=1
CLASS_direct          P=3/16 R=3/3   prec_x1000=187 rec_x1000=1000 emit=16 gold=3 occ=14 ovf=1 trunc=4 incomp=0 reduction_x1000=938
CLASS_paraphrase      P=3/16 R=3/3   prec_x1000=187 rec_x1000=1000 emit=16 gold=3 occ=14 ovf=1 trunc=4 incomp=0 reduction_x1000=938
CLASS_role_reversal   P=1/16 R=1/1   prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=11 ovf=1 trunc=2 incomp=0 reduction_x1000=938
CLASS_wrong_relation  P=1/16 R=1/1   prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=28 ovf=1 trunc=15 incomp=0 reduction_x1000=938
CLASS_wrong_context   P=1/16 R=1/1   prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=14 ovf=1 trunc=4 incomp=0 reduction_x1000=938
CLASS_distractor      P=0/12 R=0/0   prec_x1000=0   rec_x1000=0    emit=12 gold=0 occ=12 ovf=1 trunc=0 incomp=0 reduction_x1000=954
CLASS_unrelated       P=0/0  R=0/0   prec_x1000=1000 rec_x1000=1000 emit=0 gold=0 occ=0 ovf=0 trunc=0 incomp=0 reduction_x1000=1000
CLASS_high_occupancy  P=1/16 R=1/1   prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=25 ovf=1 trunc=9 incomp=0 reduction_x1000=938
CLASS_overflow_page   P=1/16 R=1/1   prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=12 ovf=1 trunc=1 incomp=0 reduction_x1000=938
CLASS_high_id_sentinel P=1/16 R=1/1  prec_x1000=62  rec_x1000=1000 emit=16 gold=1 occ=10 ovf=1 trunc=2 incomp=0 reduction_x1000=938
ASTRA_C1_N256_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,N_gt_256
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

No `FIRST_DIVERGENCE` in the PASS log. No `SEARCH_INCOMPLETE`. No `HOST_SEMANTIC_LEAK`. Ten named `CLASS_*` markers present.

TB reduction formula (raw, not RESULTS):

```text
reduction_x1000 = 1000 - ((n_got * 1000) / G_N)
```

For emit=16, N=256: `1000 - 62 = 938` = **1 − cap/N**, integer. Independent of posting occupancy. Unrelated emit=0 → 1000. Distractor emit=12 → 954.

### 4) TB: poke_v, load_from_tb, leftover A09, query authority

`tb_astra_c1_n256.sv`:

- Instantiates `a7ng_query_role_extract` (token stream) and `a7ng_query_axi_sparse #(.LAW_SEL(1), .CAND_CAP(G_CAND_CAP=16))`.
- `poke_v = 0` at reset; never assigned 1. `pk*`/`pv*` stay 0.
- No `load_from_tb` net. Index image is TB write of `u_mem.mem[G_WR_I[i]] = G_WR_D[i]` (AXI mem model), then queries are **tokens**.
- `if (CAND_CAP >= G_N) diverge SELECTIVITY_TAUTOLOGY` — 16 < 256, not taken.
- `n_host` OR of QSE host counters; diverge `HOST_SEMANTIC_LEAK` if nonzero. PASS log has no such line.
- Bit-exact check `got[i] === G_EMIT[qi][i]` (host walker twin baked into svh) **and** independent `G_RELEVANT` for P/R display.

`xvlog.log` analyzed **only**:

```text
a7ng_pkg.sv
a7ng_query_role_extract.sv
a7ng_route_valid_gate.sv
a7ng_sparse_dir_axi.sv
a7ng_axi_mem_model.sv
a7ng_query_axi_sparse.sv
tb_astra_c1_n256.sv
```

`xelab.log` compiled the same modules. `xsim_work/xsim.dir/work/*.sdb` has those six + TB. **No** `a7ng_astra_09_integ_path`. Hunt leftover A09 compiled: **MISS.**

`a7ng_query_axi_sparse.sv` `LAW_SEL==1` instantiates `a7ng_query_role_extract` (subj→entity_id_o, obj→intent_id_o). `poke_v_i` can bypass QSE; TB keeps it 0, so walk keys come from QSE valid. `a7ng_route_valid_gate.sv`: `probe*_o = k*_valid_i` (explicitly **not** `key != 0`). Master `key==0 as implicit invalid = 0`: MISS as cheat on this path.

Sparse-dir default parameter `CAND_CAP=64`; instance from `u_sp` is **16**. Instantiated cap is 16, not `CAND_CAP_FINAL`.

### 5) Independent gold vs router union vs frozen key law

`host_astra_c1.py` computes `gold_ids` (evidence==1 ∧ class predicate) **before** `route()` walker. `GOLDEN.json` `"relevant_is_router_union": false`. Direct relevant `{110,144,145}` ≠ emit 16 ids. Hunt 6 as `relevant=set(router_union)`: **MISS** on the label set.

`G_EMIT` **is** the host walker union and is the TB bit-exact oracle. That is a twin lock, not a gold-label cheat. CLASS precision is therefore the **index law’s** precision, confirmed DUT-identical to the twin.

Frozen `twin_role.py` / QSE key law (C0, not patched):

```text
k0 = (sid << 8) | rid
k1 = (oid << 8) | rid
k2 = scue[15:0]
k3 = ocue[15:0]
```

**Context id / ctx cue is not a directory key.** Direct and wrong_context share `k0=2561 k1=257 k2=766 k3=4408`. xsim EMIT lists are **byte-identical** (same 16 ids). wrong_context cannot fail recall if the ctx-specific record sits in the same posting (nid 144 does). That class is not context-selective under the frozen law.

Distractor spec in host: `lambda d: False` → `relevant=[]`. Query `"supply duct"` binds duct as subject, walks k2 (subj cue), emits nids 72–83.

Unrelated `"payroll tax form"`: all valids 0, emit 0. TB forces `qi==6 && n_got != 0` fail. Metric `n_got==0 && nrel==0 → prec=1000 rec=1000` is 0/0 arithmetic, not retrieval quality.

### 6) Emit ids vs corpus.json (occupancy-filler claim)

corpus N=256, evidence=0 n=24 (20 `high_occ_synth` + 4 `ovf_synth`), evidence=1 n=232.

CLASS_direct EMIT vs corpus (raw ids from xsim.log):

| id | evidence | kind | text |
|---:|---:|---|---|
| 108 | 1 | block_a | pump supplies valve |
| 109 | 1 | block_a | pump supplies sensor |
| 110 | 1 | block_a | pump supplies chiller **GOLD** |
| 111 | 1 | block_a | pump supplies condenser |
| 144 | 1 | psc_water | pump supplies chiller water **GOLD** |
| 145 | 1 | psc_indirect | pump supplies chiller indirectly **GOLD** |
| 99 | 1 | block_a | tower supplies chiller |
| 121 | 1 | block_a | valve supplies chiller |
| 132 | 1 | block_a | sensor supplies chiller |
| 193 | 1 | fill | condenser supplies chiller |
| 214 | 1 | fill | evaporator supplies chiller |
| 235 | 1 | fill | compressor supplies chiller |
| 112 | 1 | block_a | pump **requires** valve |
| 113 | 1 | block_a | pump **requires** sensor |
| 114 | 1 | block_a | pump **requires** chiller |
| 115 | 1 | block_a | pump **requires** condenser |

**direct non-gold: evidence=0 count = 0; evidence=1 other facts = 13.** Includes four **wrong-relation** records (112–115). Low precision is 4-table cue-union (k2/k3 have no relation), not occupancy fillers.

role_reversal: 0 fillers; 15 other evidence=1 facts (chiller supplies * / * supplies pump).

distractor: gold=0; 12 evidence=1 duct facts (supplies/requires/connects). Not empty-index; not a labeled entity-context distractor.

high_occupancy: 11 evidence=0 synth + 4 other evidence=1 `ahu requires {duct,vav,tower,pump}` + gold 147. Mix, not “fillers only”.

overflow_page: gold 172 present; also 255 (high-id) and 4 ovf_synth + 11 other evidence=1. incomp=0 because gold was inside cap.

### 7) RESULTS.md vs raw (parent wrote after implementer died)

RESULTS 08:37:00 quotes CLASS_* numbers **MATCH** xsim.log. No invented P/R. Discloses `C1_800K=OPEN`, `BOARD_PASS=NOT_CLAIMED`, U5 not this close, `reduction_x1000=938` is `1-16/256` and **must not** be Master ≥90% for N≥4096.

Overclaim vs raw (not the table numbers):

1. `RESULT_PROPOSED = PASS_THIS_GATE_ONLY` / CLOSEOUT `RESULT = PASS_THIS_GATE_ONLY` vs PREREG: PASS requires **no tautological gold** and **gold not edited after FAIL**. Both fail (unrelated 0/0 scored 1000/1000; distractor gold=0; gold files rewritten after fail_r0).
2. “Precision is low because occupancy fillers occupy CAND_CAP.” **False for direct/paraphrase/role_reversal** (zero evidence=0 in emit). Recall 1.0 on gold>0 classes is then used as the positive quality sentence — Master forbids substituting recall for retrieval quality.
3. “CORRECTIVE = 1 (TB/gold packing)”: TB LastWriteTime **08:29:18 < fail_r0**. Post-fail corrective is `host_astra_c1.py` + gold regen, not TB.

CLOSEOUT `DISTRACTOR_GOLD = 0` is honest. CLOSEOUT still writes `PASS_THIS_GATE_ONLY`.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| 1. reduction_x1000=938 as Master ≥90% | **MISS as claim** (RESULTS/CLOSEOUT say cap/N, not N≥4096 gate). **HIT as metric:** TB `1000-(n_got*1000)/256`; for cap-full classes this is 16/256, not posting selectivity. | Do not carry 938 into N=4096 as candidate-reduction. |
| 2. occupancy fillers as retrieval quality | **HIT.** Direct emit has **0** evidence=0 ids; 13/16 are other evidence=1 facts including wrong-relation 112–115. RESULTS attributes low precision to fillers. Recall 1.0 is gold-in-first-16, not ranking quality. | Occupancy synth exists only in high_occ / ovf classes. |
| 3. distractor gold=0 / unrelated 0/0 | **HIT.** Distractor `relevant=[]` by construction; emits 12 real duct facts; P=0/12 R=0/0. Unrelated 0/0 scored prec=1000 rec=1000. PREREG forbade tautological gold. | Empty-walk for unrelated is a real n_emit=0 check; the 1000/1000 score is not quality. |
| 4. C1 800k closed | **MISS.** xsim `C1_800K=OPEN`; ACK `does_not_close` includes 800k; OPEN_GATES C1 OPEN. | Still OPEN. |
| 5. cap≥N selectivity | **MISS.** CAND_CAP=16, N=256; TB would diverge. | Instantiated 16 ≠ `CAND_CAP_FINAL`. |
| 6. relevant=router_union | **MISS** on `G_RELEVANT` (direct 3 ≠ emit 16; host gold_ids before route). | `G_EMIT` **is** walker union used as bit-exact twin oracle. |
| 7. gold edited after fail_r0 | **HIT.** fail_r0 08:30:38; host py 08:31:37; GOLDEN/svh/corpus/GOLD_HASH_PRE 08:31:44. Pre-fail gold not preserved. PREREG FAIL clause. | No DUT emit existed at fail (ROLE_COLLAPSE at QSE). Likely tok_pack endian, not relevant-relabel. Still a gold rewrite after FAIL. |
| 8. frozen RTL patched | **MISS vs C0 live hashes.** | `sparse_dir_axi.sv` dirty vs git HEAD is the C0-frozen blob, not a C1 patch. Do not patch it to chase precision. |
| 9. historical U5 as this close | **MISS.** ACK/PREREG/RESULTS exclude U5. | U5 remains pre-role-law historical. |
| poke_v / load_from_tb query authority | **MISS.** poke_v held 0; no load_from_tb; queries are tokens. | Index is TB-preloaded axi_mem_model, **not** DDR. Not C2. |
| leftover A09 compiled | **MISS.** | Keep off xvlog. |
| Hash theatre | **MISS** on listed paths (live MATCH). | GOLD_HASH_PRE does not cover the first xvlog. |
| BOARD_PASS / ACCEPT_BOARD / C1 800k | **MISS as claim.** | Never grant. |

qstack-validation-adversary one-liner: **second-run XSim is a real token-stream + sparse-dir twin lock at N=256 on C0 hashes; it is not selective retrieval, not Master candidate-reduction, not a distractor test, and PASS_THIS_GATE_ONLY is overclaim vs precision / empty-gold / gold-after-fail_r0.**

---

## Logic bugs

No DUT vs host-twin mismatch on the PASS run (emit lists match `G_EMIT`). Findings are **law/index quality and bag process**, not “patch frozen QSE in this bag”:

1. **Four-table union until CAND_CAP pulls wrong-relation and wrong-object evidence=1 facts** via k2/k3 cue keys. Direct precision 187/1000 with 0 fillers is the frozen key law at this corpus, not a TB scoring bug.
2. **Frozen keys omit context.** wrong_context ≡ direct walk. Do not report rec_x1000=1000 as context selectivity.
3. **Distractor class has no independent relevant set.** Host `lambda d: False`. TB cannot fail a false-positive except emit≥N.
4. **Unrelated 0/0 → 1000/1000** in TB `metrics` / CLASS line. Empty walk is useful; the score is tautological.
5. **Gold regenerated after ROLE_COLLAPSE.** PREREG FAIL. Packing belongs in TB byte extract or a versioned tok_pack, with GOLDEN labels frozen across the fail.
6. **RESULTS filler sentence is false for direct.** Parent RESULTS after 08:32 is numerically faithful to CLASS_* and interpretively overclaim on why precision is low.
7. **Recall 1.0 is posting-order of a 1–3 id gold set inside cap**, with trunc dropping other ids. Not evidence ranking. `SEARCH_INCOMPLETE` never fires because gold was not among the truncated ids.
8. **Index is axi_mem_model**, not MIG/DDR. Honest for N=256 XSim; illegal as C2 / production retrieval.

No auditor patch. Do not edit this bag’s gold or RTL.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| Second-run `xsim.log` twin-lock (marker, FAIL=0, hashes, leftover off, poke_v=0, n_host=0, CAND_CAP=16<256) | **PASS_NARROW** | Bit-exact to post-fail host walker on frozen C0 files. Simulation only. Not DDR. Not 800k. |
| `PASS_THIS_GATE_ONLY` / CLOSEOUT `RESULT` / RESULTS filler explanation | **OVERCLAIM** | PREREG tautology + gold-after-FAIL violated; filler story false for direct; recall substituted for quality. CLASS numbers themselves MATCH xsim. |
| Master §7 retrieval quality at N=256 (precision per class; distractor; unrelated; wrong_context; reduction) | **FAIL** | prec 62–187/1000 on gold>0 classes; distractor gold=0; unrelated 0/0=1000; reduction is cap/N; context not in keys. |
| C1 800k / N=4096 / `CAND_CAP_FINAL` / BOARD_PASS / ACCEPT_BOARD / U5 | **NOT CLOSED** | Do not start N=4096 from this audit. |
| Gold-after-fail_r0 process | **FAIL** vs this bag’s PREREG | Files rewritten 08:31:44. |

Promotion scale: **REJECT_PROMOTION** of C1 rung-close and of any step to N=4096. **Not** ACCEPT_PARTIAL of `PASS_THIS_GATE_ONLY`. **Not** FAIL_LOOP (hashes are real, RTL unpatched vs C0, 800k not claimed; parent can dispatch a **new named bag**).

---

## Required fixes

Auditor does not implement. Parent maps. **Do not edit** `ASTRA-C1-N256-ROLE-RETRIEVAL-01` gold/xsim/RESULTS to “clean” this audit.

**P1 — new named bag required (quality + gold discipline). Do not patch frozen C0 RTL in that bag. Do not start N=4096.**

1. **Gold immutability:** hash independent labels **once** before the first xvlog. On FAIL, copy `xsim.log` to `xsim_fail_r0.log` and **do not regenerate** `GOLDEN.json` / `query_gold.svh` / `corpus.json` / `GOLD_HASH_PRE_XVLOG.txt`. Token packing bugs are TB extract/`G_BYTES` layout only, with labels unchanged. If labels must change, that is a new bag, not a post-fail rewrite.
2. **Report precision per class as the quality number.** Do not treat rec_x1000=1000 on 1–3 gold ids as retrieval quality. Occupancy fillers (evidence=0) must be counted separately from **other evidence=1 false positives** (direct today: 0 fillers, 13 EV1 FPs including wrong-relation).
3. **Distractor:** non-empty independent gold (entity-context records that must be excluded or that define the true distractor set). `lambda d: False` is not Master “entity-context distractor”.
4. **Unrelated:** keep n_emit=0 as a named check; **do not** score 0/0 as prec=1000 rec=1000. Report empty-walk / all-invalid-keys separately.
5. **wrong_context:** under frozen qse-v2-role-00, xid/xcue are not directory keys. Either report the class **NOT_SELECTIVE** (same k0–k3 and same emit as direct) or change **index/key architecture in a new law id after parent triage** — Master FAIL routing: do not relabel `relevant=router_union`, do not lower threshold, do not silently patch C0 hashes.
6. **reduction:** stop emitting cap/N as `reduction_x1000` if that string will be read as Master candidate-reduction. Master ≥90% applies at **N≥4096** and is posting-selectivity, not `1-CAND_CAP/N`.
7. Leftover `a7ng_astra_09_integ_path` stays off xvlog. poke_v=0. Token query authority. PROGRAM=NO. C1 800k stays OPEN. No U5 citation. No `CAND_CAP_FINAL`.

**P2 — parent / docs:**

1. Treat this bag’s `PASS_THIS_GATE_ONLY` as **non-close**. Authority = raw CLASS_* + corpus emit classification above.
2. Do **not** spawn N=4096 from this report.
3. Do **not** re-run this bag’s xsim to farm a second PASS.
4. `LOOP_STATE.json` remains parent-owned. Next unblocked_item = new named C1-N256 quality bag if parent follows P1; not C2, not 800k, not A09R8 smoke.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = REJECT_PROMOTION
FAIL_LOOP        = NO
ACCEPT_PARTIAL   = NO
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C1_N256_XSIM     = PASS_NARROW  twin-lock only (second run, PID 4532, 15755 ns)
C1_N256_QUALITY  = FAIL         precision / empty-gold / tautology / recall substitution
PASS_THIS_GATE   = OVERCLAIM
GOLD_AFTER_FAIL  = HIT          GOLDEN/svh/corpus rewritten 08:31:44 after ROLE_COLLAPSE 08:30:38
HASH_CHECK       = PASS vs C0   cd7baf49 / 38189974 / 09334e42 / 5a4ad04d / 49a66da2 MATCH
LEFTOVER_A09     = not compiled
POKE_V           = 0
LOAD_FROM_TB     = not present
C1_800K          = OPEN
N_4096           = NOT STARTED
U5_AS_C1         = REJECTED
REDUCTION_938    = cap/N, not Master ≥90%
NEXT             = new named C1-N256 bag (parent); not N=4096; not C2
```

Never ACCEPT_BOARD. Never close C1 800k. Never start N=4096 in this audit.
