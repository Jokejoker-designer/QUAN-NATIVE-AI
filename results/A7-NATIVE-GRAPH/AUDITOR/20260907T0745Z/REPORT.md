# ASTRA auditor REPORT — 20260907T0745Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAG        = ASTRA-C0-LAW-FREEZE-01
PLUS       = docs/ASTRA/authority/{FINAL_CONTRACT.json,CURRENT_EVIDENCE_LEDGER.md,OPEN_GATES.md}
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON §6 C0 + C1–C7 unknowns
           prior silicon auditor 20260907T0735Z (ladder; not this bag)
EVIDENCE   = live Get-FileHash SHA256 of every path in bag SHA256.txt
           + expected prefixes SGD/A09-R2/leftover/bit
           + wrap.sv u_a09r2 (no param overrides) + plant.sv
           + a7ng_astra_09_r2_cand_ovf.sv/.svh (CAND_CAP, LAW_SEL=1, u_sgd)
           + qse_role_lexicon.svh QSE2_N_LEX
           + raw LADDER.txt + xsim.log R7 frames + timing_route.rpt DTS
           RESULTS.md / CLOSEOUT.md / ACK.json / PREREG.md / LEDGER prose are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1–C7        = OPEN (not closed by this audit; do not start C1 here)
```

This auditor did not program the board, did not edit `rtl/`, did not edit implementer bags, did not write a V3.1 tree, and did not spawn agents.

---

## Scope

Read-only except this file.

Primary object: C0 law/authority freeze bag

`results/A7-NATIVE-GRAPH/ASTRA-C0-LAW-FREEZE-01/`

plus the three Master §6 deliverables

`docs/ASTRA/authority/FINAL_CONTRACT.json`  
`docs/ASTRA/authority/CURRENT_EVIDENCE_LEDGER.md`  
`docs/ASTRA/authority/OPEN_GATES.md`

Master §6 primary unknown: can remaining work use one stable representation and one final acceptance contract?

Master §6 PASS: versions/hashes recorded **before** C1 confirmation data is inspected.

**Not** this bag: C1 800k role-aware retrieval, C2 DDR persist, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, programming, new bitstream, V3.1 writes.

Hunt (dispatch + GSTACK_LOOP, none dropped):

1. C1 closed by historical 800k (`ASTRA-02-U5`)
2. Silicon `w0 0→-5` called C3
3. A09R8 wrap called C5 / `BOARD_PASS` / `ACCEPT_BOARD`
4. Hash invented / prefix mismatch / hash theatre
5. Instantiated `CAND_CAP` not 16
6. Leftover A09 `integ_path` treated as live DUT
7. Plant LUT called production DDR
8. LM06 composer called language
9. C0 freeze after looking at C1 scores

---

## Evidence re-derived

### 1) Git / bag identity

Live:

```text
HEAD    = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
BRANCH  = grok-orch/astra-native-v1-00
```

MATCH `ACK.json` `base` and `RESULTS.md` `HEAD`. C0 bag on disk is five files only: `ACK.json`, `PREREG.md`, `RESULTS.md`, `CLOSEOUT.md`, `SHA256.txt`. No Vivado/XSim/program logs in this bag. `PROGRAM=NO` this process and this bag.

`LOOP_STATE.json` still has `unblocked_item=ASTRA-11-A09R8-SILICON-UART-01`, `auditor=IN_PROGRESS`, `updated=2026-09-07T07:35:00+07:00`. That file is **stale vs this C0 bag**. Auditor does not edit it.

### 2) Live SHA256 vs bag `SHA256.txt` vs expected prefixes

Tool: PowerShell `Get-FileHash -Algorithm SHA256` at audit time on every 64-hex line in

`results/A7-NATIVE-GRAPH/ASTRA-C0-LAW-FREEZE-01/SHA256.txt`

**All 33 listed paths exist. All 33 live hashes MATCH the listed digest.** No invented hash. No missing file.

Mandatory prefixes (dispatch):

| Object | Expected | Live SHA256 | Match |
|---|---|---|---|
| SGD `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` | YES |
| A09-R2 `a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…` | `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` | YES |
| leftover A09 `a7ng_astra_09_integ_path.sv` | `9fdbe0d6…` | `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` | YES |
| checkpoint bit | `e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb` | same; bytes=3826016 | YES |

Also MATCH listed (no dispatch prefix required):

```text
cd7baf49…  rtl/native_graph/query/a7ng_query_role_extract.sv
38189974…  rtl/native_graph/query/qse_role_lexicon.svh
420c04b9…  rtl/native_graph/query/qse_lexicon.svh
ede064f0…  rtl/native_graph/query/a7ng_query_struct_extract.sv
feaed571…  rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.svh
ad2d66d4…  rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh
8e802d0b…  rtl/board/uart_rx.sv
b4b7d097…  rtl/board/uart_tx.sv
5a4ad04d…  rtl/native_graph/integrate/a7ng_query_axi_sparse.sv
49a66da2…  rtl/native_graph/query/a7ng_route_valid_gate.sv
09334e42…  rtl/native_graph/memory/a7ng_sparse_dir_axi.sv
7cf98852…  rtl/native_graph/pkg/a7ng_pkg.sv
9a06e6d3…  rtl/native_graph/control/a7ng_gate14_crc.svh
f4ff4d76…  .../a7ng_astra_11_a09r8_uart_freeze_wrap.sv
d7951ce8…  .../a7ng_astra_11_a09r8_uart_freeze_plant.sv
170199ba…  .../a7ng_astra_11_a09r8_uart_freeze.svh
60b72ea2…  .../ASTRA-11-A09R8-SILICON-UART-01/LADDER.txt
85f72418…  docs/ASTRA/authority/ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md
ac32bebd…  docs/ASTRA/authority/FINAL_CONTRACT.json
2be3eb6c…  docs/ASTRA/authority/CURRENT_EVIDENCE_LEDGER.md
f2fe2041…  docs/ASTRA/authority/OPEN_GATES.md
322d217a…  ASTRA-C0-LAW-FREEZE-01/ACK.json
e3c30ed5…  ASTRA-C0-LAW-FREEZE-01/PREREG.md
03722033…  ASTRA-C0-LAW-FREEZE-01/RESULTS.md
2a696510…  ASTRA-C0-LAW-FREEZE-01/CLOSEOUT.md
```

Silicon bag `LADDER.txt` and freeze wrap/plant/bit hashes MATCH C0 `SHA256.txt` → C0 did **not** overwrite those silicon/freeze files after hashing.

Hygiene (not a hash fail): `RESULTS.md` / `FINAL_CONTRACT.json` `recorded_at_utc=2026-09-07T01:02:20Z`; `SHA256.txt` header `UTC 2026-09-07T01:07:31Z` / local `08:07:31+07:00`. Contract first, then bag-file hashes. `SHA256.txt` does not hash itself.

### 3) Instantiated bounds — wrap + DUT, not RESULTS prose

Wrap `a7ng_astra_11_a09r8_uart_freeze_wrap.sv` line 133:

```text
a7ng_astra_09_r2_cand_ovf u_a09r2 (
```

**No** `#(...)` parameter override. Comment line 5: leftover `a7ng_astra_09_integ_path` not instantiated. Grep of wrap source: leftover module name only in that comment. Instance is `u_a09r2` + bag-local plant.

DUT defaults (`a7ng_astra_09_r2_cand_ovf.sv` + `.svh`):

```text
A7NG_A09R2_CAND_CAP = 16
A7NG_A09R2_MAX_PATH = 4
parameter CAND_CAP = A7NG_A09R2_CAND_CAP
parameter MAX_PATH = A7NG_A09R2_MAX_PATH
```

`u_sp` gets `.CAND_CAP(CAND_CAP)` and `.LAW_SEL(1)`. Hunt **CAND_CAP not 16**: **MISS**. Instantiated checkpoint cap is 16.

`CAND_CAP_SWEEP` / `CAND_CAP_FINAL` remain `NOT_FROZEN` in `FINAL_CONTRACT.json` / `OPEN_GATES.md`. That is the Master §7 rule (`CAND_CAP_FINAL` only after the cap sweep). Instantiated 16 is a checkpoint default, not C1 acceptance.

`MAX_HOPS=2` is **not** a Verilog parameter. A09-R2 `S_EJ` composes two typed edges (`fs[ej]==fo[ei]`, same rel). Silicon `LADDER.txt` `npath=2`. Contract discloses this. Honest.

Leftover `a7ng_astra_09_integ_path.sv` also defaults `CAND_CAP=16` / `MAX_PATH=4`, but it is **not** the wrap DUT. A09-R2 `` `include "a7ng_astra_09_integ_path.svh" `` is shared constants (`TO_CYC`, `TXN_MAX`, …), not an instance of leftover.

### 4) Parser / learner identity (raw RTL)

`a7ng_query_role_extract.sv` header: law `qse-v2-role-00`; includes `qse_role_lexicon.svh`.

`qse_role_lexicon.svh`: `QSE2_N_LEX = 59`. MATCH `FINAL_CONTRACT.json` `lexicon_n=59`.

`a7ng_query_axi_sparse.sv`: `LAW_SEL==0` instantiates `a7ng_query_struct_extract`; `else` instantiates `a7ng_query_role_extract` with `subj_id_o→entity_id_o`, `obj_id_o→intent_id_o`. Checkpoint `LAW_SEL(1)` is the role parser. QSE-v1 is hashed as control-only. MATCH contract.

`a7ng_shared_rank_sgd_q8_sym_f2r2.sv`: `N=32`, `SHIFT=6`. Instantiated `u_sgd` inside A09-R2. `freeze_i` tied 0 in the DUT instance (not a freeze-i=1 cheat on this checkpoint).

No `ROLE_W` / `N_ROLE` parameters exist on the frozen QSE files. `a7ng_pkg.sv` has `NG_LANES=16` (scorer/wave lanes), not a parser `ROLE_W=3`. C0 froze the **actual** qse-v2-role-00 files, not a nonexistent `a7ng_lexicon_role_bank.svh`.

UART hashes MATCH freeze compiled set (same as 0735Z). Framing claims in contract (`115200 8N1 MAGIC=A2 …`) are copied from prior bags; this C0 bag did not recapture UART.

### 5) BOARD / XSIM / ROUTE cited by the ledger — raw, not LEDGER prose

`LADDER.txt` live SHA MATCH C0 list. Raw frames:

```text
FRAME_SMOKE a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
FRAME_REW   a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
FRAME_UNREL a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
DECODE_SMOKE st=0 acc=1 ans=4 p0=17 p1=34 npath=2
DECODE_REW   w0=-5 phi0=50 nupd=1 nbad=0 tag=0x57 txn=1 gen=1
BOARD_PASS=NOT_CLAIMED ASTRA-13=NOT_CLOSED DDR=NOT_OPENED
OVF_SW1=NOT_RUN
```

XSim R7 `xsim.log` (reference, not silicon):

```text
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
FRAME REW_OBS    a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
FRAME UNREL_UART a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
```

Byte-identical to LADDER. LEDGER copy of those hex strings MATCH raw.

`timing_route.rpt` Design Timing Summary (Routed; not RESULTS):

```text
WNS=0.587  TNS=0.000  TNS fail=0 / 8940
WHS=0.058  THS=0.000  THS fail=0 / 8940
All user specified timing constraints are met.
```

Intra `clk50u` setup slack MET 0.587 ns; hold MET 0.058 ns. UART inter-clock hold MET 1.150 ns / 4.064 ns. LEDGER ROUTE numbers MATCH DTS + `TIMING_EXTRACT.txt`. This is **not** C6 (Master §12: A09R8 bit is not final co-fit; no production DDR+LM path).

0735Z already graded silicon ladder **PASS_NARROW** and RESULTS `SMOKE_SW0_OFF` **OVERCLAIM**. LEDGER at C0 freeze labeled `AUDITOR_SILICON=PENDING` (no REPORT at `AUDITOR/20260907T0735Z` then). That report exists now. C0 did not rewrite LADDER. C0 did not claim `BOARD_PASS`.

### 6) C0 deliverables vs Master §6

Written:

```text
FINAL_CONTRACT.json
CURRENT_EVIDENCE_LEDGER.md
OPEN_GATES.md
```

Contract records checkpoint hashes, `PROGRAM=NO`, `PRODUCTION_TOP=UNKNOWN`, `BOARD_PASS=NOT_CLAIMED`, `LM06_BYTE256=NOT_FROZEN`, `DDR_INDEX=NOT_FROZEN`, `c1_800k_inspected=false`, `c1_800k_generated=false`.

Master §6 version table rows that are **recorded as NOT_FROZEN** (still a recording): `CORPUS_SCHEMA_VERSION`, `INDEX_SCHEMA_VERSION`, `CAND_CAP_SWEEP`, `RULE_TABLE_VERSION`, `PERSIST_SCHEMA_VERSION`, `LM_CONTEXT_SERIALIZATION_VERSION`, plus `CAND_CAP_FINAL` / `DDR_QUERY_BOUND_FINAL`. C0 did not invent fake version IDs for those.

`OPEN_GATES.md` one-line C1–C7 unknowns MATCH Master:

| Gate | OPEN_GATES / Master primary unknown |
|---|---|
| C1 | role-aware query law retrieve selectively through real index law to 800,000 records |
| C2 | successful reward update ⇒ intended state committed/recoverable on production persist path |
| C3 | learning on real parser→retrieval→reasoning→ranking path improves unseen cases, not merely one weight |
| C4 | LM06 consumes materialized evidence and generates grounded tokens, not arithmetic/class ID |
| C5 | all accepted blocks in one production hierarchy with no synthetic shortcuts |
| C6 | exact production top fits and closes timing on Arty A7-100T |
| C7 | board validates the complete final artifact, not the narrow A09R8 checkpoint (§13 rule) |

All seven labeled **OPEN**. Historical U5 cannot close C1. `w0 0→-5` cannot close C3. A09R8 wrap is not C5. A09R8 bit is not C6/C7.

No C1 score table, recall/precision numbers, or 800k confirmation metrics appear in the C0 bag or the three authority files.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|---|---|---|
| C1 closed by historical 800k | **MISS as claim.** ACK `does_not_close` includes `C1_…` and `historical_ASTRA-02-U5_as_C1`. OPEN_GATES C1 OPEN. LEDGER XSIM row: U5 is historical pre-role-law and **does not close C1**. No 800k scores in C0 files. | **HIT as bound:** U5 remains XSIM/host historical only. Next gate C1 must not cite U5 as close. |
| Silicon w0 0→-5 called C3 | **MISS as C3 label.** ACK / RESULTS / OPEN_GATES / Master §9: reachability, not transfer. | **HIT as bound:** LADDER REW_M3 is still the plant first-POR vector (`rew=-3`, epoch=7 = wrap `live_epoch_i`). Not 5-seed held-out. |
| A09R8 as C5 / BOARD_PASS / ACCEPT_BOARD | **MISS as claim.** `BOARD_PASS=NOT_CLAIMED`, `PRODUCTION_TOP=UNKNOWN`, C5 OPEN, ACK excludes `ACCEPT_BOARD`. | **HIT as bound:** wrap is UART+AXI plant checkpoint. C5 forbids synthetic plant as corpus authority. Never ACCEPT_BOARD for this fixture. |
| Hash invented / prefix mismatch | **MISS.** Live re-hash MATCH all 33 listed; four expected prefixes MATCH. | None. |
| CAND_CAP not 16 | **MISS.** `A7NG_A09R2_CAND_CAP=16`; wrap no override; `u_sp` `.CAND_CAP(CAND_CAP)`. | Instantiated 16 ≠ `CAND_CAP_FINAL`. Sweep still OPEN. |
| Leftover A09 as live DUT | **MISS.** Wrap instantiates `u_a09r2` only. Leftover hashed as `FROZEN_NOT_INSTANTIATED_IN_CHECKPOINT`. | A09-R2 includes leftover **svh** constants. Do not promote leftover `.sv` onto xvlog/impl DUT list. |
| Plant LUT called production DDR | **MISS as claim** (`DDR_INDEX=NOT_FROZEN`, LEDGER OPEN). | **HIT as bound:** plant `mem_rd` + BRAM=0 from 0735Z. Not C1/C2 evidence. |
| LM06 language | **MISS.** `LM06_BYTE256=NOT_FROZEN`; C4 OPEN. | None this bag. |
| Hash freeze after looking at C1 scores | **MISS in artifacts.** `C1_800K_INSPECT=NO`; no confirmation metrics copied. | Cannot prove a human did not open U5 RESULTS; can prove C0 did not ingest those numbers. |
| Timing-fail bit called BOARD_PASS | **MISS.** DTS WNS=+0.587 WHS=+0.058 MET; BOARD_PASS not claimed. | Not C6. |
| RESULTS vs raw on this C0 bag | **MISS on hashes/frames/STA numbers cited.** | LEDGER BOARD class `PROVEN NARROW` is Master §4.1 language + LADDER, labeled pending auditor at freeze. 0735Z later ACCEPT_PARTIAL of the ladder. Does **not** close C1–C7. 0735Z `SMOKE_SW0_OFF` OVERCLAIM remains non-evidence (not re-asserted as a C0 measurement). |

qstack-validation-adversary one-liner: **C0 recorded live hashes of the checkpoint laws and left C1–C7 OPEN; it did not invent prefixes, did not set CAND_CAP≠16, and did not close C1/C3/C5 from U5 / w0 / A09R8.**

---

## Logic bugs

No DUT RTL bug is in scope for C0 (no new RTL). Findings that are **not** “fix frozen RTL”:

1. **`LOOP_STATE.json` is stale** relative to C0 (still silicon-UART unblocked / auditor IN_PROGRESS). Parent file; auditor does not patch it.
2. **C0 freeze vs silicon-auditor sequencing.** LEDGER says 0735Z was missing at freeze. PARENT_BOOT wanted ACCEPT_PARTIAL of silicon **then** C0. 0735Z now exists with ACCEPT_PARTIAL and no P1, so the C0 *content* is still the right next overlay. Process hygiene, not a hash FAIL.
3. **Many Master §6 version rows are `NOT_FROZEN`.** Allowed as recording; they are not a completed production representation. C1 must not treat `CAND_CAP=16` as `CAND_CAP_FINAL`.
4. **`MAX_HOPS` is a Master freeze + two-edge compose, not a parameter.** Do not grep-fail C0 for a missing `MAX_HOPS` localparam.
5. **0735Z `SMOKE_SW0_OFF` hex is still not a raw SW0-OFF capture.** C0 LEDGER does not repeat that false label; it copies UNREL from LADDER. Keep that discipline.

No auditor patch.

---

## Verdict per bag

| Object | Verdict | Why |
|---|---|---|
| `ASTRA-C0-LAW-FREEZE-01` | **PASS_NARROW** | Live hashes MATCH SHA256.txt; SGD/A09-R2/leftover/bit prefixes MATCH; CAND_CAP instantiated 16; leftover not instantiated; C1–C7 OPEN; PROGRAM=NO; BOARD_PASS not claimed; no invented hash; no C1 scores ingested into the freeze files. Narrow because many versions remain NOT_FROZEN and C0 is recording, not product-complete. |
| `FINAL_CONTRACT.json` / `CURRENT_EVIDENCE_LEDGER.md` / `OPEN_GATES.md` | **PASS_NARROW** | Master §6 deliverables present; evidence classes split BOARD/XSIM/ROUTE/OPEN; OPEN_GATES unknowns MATCH Master C1–C7. LEDGER BOARD “PROVEN NARROW” is Master §4.1 + raw LADDER, not C7. |
| Historical `ASTRA-02-U5` as C1 | **NOT CLOSED** | Explicitly forbidden by Master §6 and by this bag. |
| Silicon w0 as C3 | **NOT CLOSED** | Master §9. |
| A09R8 as C5 / BOARD_PASS / ACCEPT_BOARD | **NOT CLOSED** | Never ACCEPT_BOARD for this plant fixture. |
| Master C1–C7 | **OPEN** | Do not start C1 in this audit. |

Promotion scale: **ACCEPT_PARTIAL** of the C0 law/hash freeze. **REJECT_PROMOTION** to C1 close, production-top freeze, or board-pass.

---

## Required fixes

Auditor does not implement. Parent maps.

**P1 (new RTL / new named bag required): none.** Expected prefixes MATCH live files. C0 PASS criterion (hashes recorded before C1 inspect) holds on the artifacts.

**P2 (parent / next-gate discipline; not a C0 rework):**

1. Next Master gate is **C1** (role-aware sparse retrieval ladder). **Do not start C1 in this audit.** Do not spawn a C1 implementer from this report’s existence alone until parent updates `LOOP_STATE`.
2. Do **not** close or shortcut C1 with `ASTRA-02-U5` 800k.
3. Do **not** treat instantiated `CAND_CAP=16` as `CAND_CAP_FINAL`. Sweep still OPEN.
4. Do **not** call LADDER `w0=-5` C3; do not call AXI plant DDR; do not write `PRODUCTION_TOP=a7ng_astra_11_a09r8_uart_freeze_wrap`.
5. Do **not** re-run A09R8 smoke/ladder to farm PASS (Master §5 / GSTACK_LOOP).
6. Treat 0735Z `SMOKE_SW0_OFF` as non-evidence. Authority for silicon frames remains `LADDER.txt`.
7. `LOOP_STATE.json` is stale; parent may retarget `unblocked_item` to C1 **after** this ACCEPT_PARTIAL. Auditor does not write it.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
PROMOTION        = REJECT_PROMOTION
FAIL_LOOP        = NO
ACCEPT_BOARD     = MISSING (never granted)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C0               = PASS_NARROW  hashes/versions recorded; C1–C7 remain OPEN
C1–C7            = OPEN (do not start C1 here; do not close any from this checkpoint)
HASH_CHECK       = PASS  SGD b66ef328 MATCH; A09-R2 15a919f1 MATCH; leftover 9fdbe0d6 MATCH; bit e51bdca2 MATCH
CAND_CAP         = 16 instantiated default; CAND_CAP_FINAL NOT_FROZEN
LEFTOVER_A09     = hashed, not instantiated
U5_AS_C1         = REJECTED
W0_AS_C3         = REJECTED
A09R8_AS_C5      = REJECTED
NEXT_GATE        = C1  (parent; not this auditor)
```

Never ACCEPT_BOARD. Never close C1–C7 from this report.
