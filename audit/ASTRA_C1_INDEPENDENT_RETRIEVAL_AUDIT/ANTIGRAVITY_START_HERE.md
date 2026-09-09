# ANTIGRAVITY — START HERE

Đọc file này trước. CWD của Antigravity **bắt buộc** là cây này, không phải clone live.

```text
CWD (write)   = D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
LIVE (read)   = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
V3.1 (never)  = D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00
```

Tiếp theo đọc ngay: [COORDINATION.md](COORDINATION.md) → [AGENTS.md](AGENTS.md) → [GATES/README.md](GATES/README.md) → [KEEP_HASHES.json](KEEP_HASHES.json).

Bạn là **auditor độc lập + người dựng cổng bắt lỗi**. Cursor triển khai bag trên clone live. **Không** tự stamp `BOARD_PASS` / `ASTRA_NATIVE_AI_BOARD_PASS`.

---

## 0. First 15 minutes

```bat
cd /d D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
python scripts\c1_800k_close_gate.py
python scripts\c2_persist_close_gate.py
python scripts\c3_heldout_prereg_gate.py
```

Rồi mở raw (không tin RESULTS.md):

```text
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\LOOP_STATE.json
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\OPEN_GATES.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T2148Z\REPORT.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T1652Z\REPORT.md
```

Hunt đầu tiên (bắt buộc, vì Cursor vừa tự-audit C1/C2):

1. C1 cartesian / cap không bind / `DDR_QUERY_BOUND_FINAL` không được freeze từ AXI 1632.
2. C2 `F_BAD_TXN` dead after DUP; MIG posted-write; multi-slot/stall không phải MIG PHY.
3. C3 **chưa** được đóng bởi `w0 0→-5`.

Ghi findings vào `results/adversarial_review_c2_xsim_close.json` (cùng schema `results/adversarial_review_c1_xsim_close.json`).

---

## 1. Path catalog (absolute)

### 1.1 Trees

| Role | Path |
|---|---|
| Antigravity write root | `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` |
| Live isolate clone | `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH` |
| Git branch (live) | `grok-orch/astra-native-v1-00` |
| Historical Codex handoff | `D:\FPGA\ASTRA_HANDOFF` |
| Architecture Master V1 (not V1.1 overlay) | `D:\FPGA\ASTRA_HANDOFF\ASTRA_NATIVE_AI_MASTER_V1.md` |
| V3.1 / Basys — **never write** | `D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00` |
| Junction forbidden | `D:\FPGA\basys3-four-agent-snn-ready` |

### 1.2 Blueprint / authority (live clone) — read, never invent

| What | Path |
|---|---|
| **Execution Master V1.1 (C0–C7)** | `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md` |
| C0 freeze contract | `...\docs\ASTRA\authority\FINAL_CONTRACT.json` |
| Open gates | `...\docs\ASTRA\authority\OPEN_GATES.md` |
| Evidence ledger | `...\docs\ASTRA\authority\CURRENT_EVIDENCE_LEDGER.md` |
| Design candidate (not execution authority) | `...\docs\ASTRA\authority\DESIGN_CANDIDATE.md` |
| Historical V3.1 blueprint copy | `...\docs\ASTRA\authority\UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md` |
| HANDOFF_GROK (historical) | `...\docs\ASTRA\authority\HANDOFF_GROK.md` |
| Loop | `...\docs\ASTRA\LOOP_STATE.json` |
| Parent boot | `...\docs\ASTRA\PARENT_BOOT.md` |
| Auditor boot (stale “never promote C1–C7 from A09R8”; still useful hunt list) | `...\docs\ASTRA\AUDITOR_BOOT.md` |
| gstack loop | `...\docs\ASTRA\GSTACK_LOOP.md` |
| Work queue | `...\docs\ASTRA\WORK_QUEUE.md` |
| Stale path catalog (2026-09-05; do not trust as live) | `...\docs\ASTRA\PROJECT_PATHS.md` |

Native-graph blueprint package (resource/hardstops; **does not replace** Master V1.1 C-gates):

```text
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\NATIVE_AI_ARTY_A7_BLUEPRINT\
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\native_graph\
```

### 1.3 Toolchain

| Item | Path / value |
|---|---|
| Vivado 2026.1 | `C:\2026.1\Vivado\bin` (`vivado.bat`, `xvlog.bat`, `xelab.bat`, `xsim.bat`) |
| License | `D:\Xilinx\licenses\vivado_basic.lic` |
| Part | `xc7a100tcsg324-1` |
| UART | COM12 115200 8N1 |
| JTAG | `210319BE776EA` |
| xelab MIG | **must** `-mt off -O0` (Vivado 2026.1 ACCESS_VIOLATION otherwise) |
| xelab.bat | splits on `=`; do **not** pass `-generic_top FOO=1` |
| PowerShell | never `Select-String -Pattern [regex]::Escape($p)` inline; bind pattern to a variable. Do not name a function `H` (aliases `Get-History`) |

### 1.4 Live clone RTL / bags you will hunt (read-only)

Base RTL: `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\rtl\native_graph\`  
Base bags: `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\`

C1 close bags:

```text
...\ASTRA-C1-N65536-SCALE-01\
...\ASTRA-C1-N262144-SCALE-01\
...\ASTRA-C1-N800000-SCALE-01\
...\ASTRA-C1-CAND-CAP-SWEEP-01\
...\AUDITOR\20260907T2148Z\REPORT.md
```

C2 close bags:

```text
...\ASTRA-C2-PERSIST-COMMIT-01\
...\ASTRA-C2-PERSIST-MULTI-SLOT-01\
...\ASTRA-C2-PERSIST-DDR-STALL-01\
...\ASTRA-C2-PERSIST-MIG-01\
...\AUDITOR\20260907T1652Z\REPORT.md
```

C2 DUT:

```text
...\rtl\native_graph\integrate\a7ng_astra_c2_persist_commit.sv
...\rtl\native_graph\integrate\a7ng_astra_c2_persist_multi_slot.sv
...\rtl\native_graph\integrate\a7ng_astra_c2_persist_ddr_stall.sv
...\rtl\native_graph\integrate\a7ng_astra_c2_persist_mig.sv
...\rtl\ddr\mig_native_wrap.sv
...\third_party\digilent\arty-a7-100\E.0\1.0\mig.prj
```

Official Digilent `mig.prj` hash `914a9e4b…`. IP copy under `vivado/ip/.../mig.prj` is a **different** hash — do not confuse. Compile **`mig_7series_0_mig_sim.v`**, not synth `mig_7series_0_mig.v`.

Checkpoint bit (test vehicle only):

```text
...\results\A7-NATIVE-GRAPH\ASTRA-11-A09R8-UART-FREEZE-BIT-01\a7ng_astra_11_a09r8_uart_freeze_wrap.bit
SHA256 = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
```

KEEP hashes: [KEEP_HASHES.json](KEEP_HASHES.json).

### 1.5 This tree (write)

| File | Use |
|---|---|
| `ANTIGRAVITY_START_HERE.md` | this file |
| `COORDINATION.md` | who writes what |
| `AGENTS.md` | isolation law |
| `KEEP_HASHES.json` | hash gate |
| `GATES/README.md` | bug-catching gates |
| `scripts/c1_800k_close_gate.py` | C1 XSim close gate |
| `scripts/c2_persist_close_gate.py` | C2 XSim close gate |
| `scripts/c3_heldout_prereg_gate.py` | C3 must stay red |
| `scripts/assert_scale_bag.py` | scale bag tautology hunt |
| `scripts/snapshot_evidence.py` | copy evidence into `snapshots/` (extend bag list for C2) |
| `results/` | gate JSON + adversarial reviews |
| `AUDITOR/<UTC>/REPORT.md` | your reports (do not write live clone) |
| `WORK_ORDER/<UTC>.md` | one-unknown dispatch for Cursor |

---

## 2. Live LOOP (FACT at handoff)

From `LOOP_STATE.json` written 2026-09-07T23:52:52+07:00:

```text
acceptance              = ACCEPT_C1_C2_XSIM
c1_800k                 = CLOSED_XSIM_CARTESIAN_PROCEDURAL
c2_persist              = CLOSED_XSIM_AXI_JOURNAL_PLUS_MIG_RELOAD
c2_persist_closed       = true
unblocked_item          = ASTRA-C3-HELD-OUT-01
c_gate                  = C3_HELD_OUT
CAND_CAP_FINAL          = 16
DDR_QUERY_BOUND_FINAL   = NOT_FROZEN
PERSIST_SCHEMA_VERSION  = NOT_FROZEN
final_promotion         = REJECT
board_pass              = false
program                 = true
program_scope           = PINNED_SHA_e51bdca2_ONLY
```

Cursor C1/C2 auditor reports were **same-session as implementer** (disclosed). Your job is the missing **second-model** hunt.

---

## 3. Master remaining letter (what PASS the whole project requires)

Authority: Master V1.1 §§9–13. Do not substitute DESIGN_CANDIDATE or V3.1.

### C3 — held-out transfer (NEXT)

Unknown: learning on the real parser→retrieval→reason→rank path improves **unseen** cases, not one weight.

```text
>= 5 seeds
arms A learner / B frozen / C shuffled reward / D per-ID prior
train entities ∩ held-out entities = empty (when claim requires disjoint)
gain(A over B) >= 10 pp; paired CI lower > 0
A > shuffled; A complements per-ID
retention drop after reload <= 5 pp
host winner/address/weight update = 0
Always-UNKNOWN cannot PASS
A09R8 w0 0→-5 is NOT C3
Silicon microexam = C7 phase 6 (at least one episode on final bit)
```

### C4 — LM06 grounded generation

```text
LM06_BYTE256 preferred (8-bit tokens 0..255); new versioned law
materialized <QUERY>+<PROOF> evidence, not class-ID→host sentence
ablations: zero weights, evidence removed, evidence replaced
held-out grounded accuracy >= 90%; hallucination <= 5%
host next-token = 0
```

### C5 — one production top

Must instantiate UART, role parser, **real sparse DDR/MIG index**, descriptors, ranker, proof, pending reward, **production persist**, evidence materializer, LM06, UART out.

Must be absent: qid→answer map, plant-as-corpus, host winner, class-ID sentence, shadow path driving result.

One DDR owner/arbiter. Unified regression list in Master §11.

### C6 — whole-chip co-fit

A09R8 bit is **not** C6 (no full DDR+LM). Need WNS>=0 TNS=0 WHS>=0 UNROUTED=0 unique bit + freeze manifest.

### C7 — blind board exam

One unique final bit, one JTAG, teacher=0, host route/winner/next-token=0. Phases 0–10 in Master §13 (boot/MIG/UART, role, retrieval 800k image, novel proof, causal intervention, SEARCH_INCOMPLETE, held-out PRE/train/POST, persist reload, LM06 teacher-off, unrelated/conflict, claim reconciliation).

**Only after C7 letter** may anyone stamp `ASTRA_NATIVE_AI_BOARD_PASS`.

---

## 4. Hard stops (cheat hunts)

Copy from gstack; you expand them into gates:

- Plant LUT called production DDR retrieval
- `w0 0→-5` called held-out transfer / C3
- Timing-fail SoC bit called BOARD_PASS
- LM06 composer called language
- `1-CAND_CAP/N` called reduction
- Historical U5 800k called C1
- Hash freeze after looking at scores
- Editing GOLDEN after fail
- Identical-φ plants called independent seeds
- A09R8 wrap called one production top / C6 / C7
- low16 / low8 as canonical persist identity
- Compiling leftover A09 / STREAM-02 / ctx DUT `8255a798` / prior_store / synth `mig_7series_0_mig.v` as DUT
- Freezing `DDR_QUERY_BOUND_FINAL` from persist AWADDR or AXI query 1632
- Silent C0 / KEEP patch
- Two implementers on one bag
- Programming any bit except pinned `e51bdca2…` without WNS>=0 + ACCEPT + Anh

Do not edit KEEP C1 bags: SYNONYM-LAW, SEMANTIC-NL-01, UNSEEN-SRO*, HELDOUT, SEMANTIC-16K, CONTEXT-02, PAGE-SKIP, STREAM-02, N4096-*, KEY-INTERSECT, AXI-BEAT, SEMANTIC-800K-01 (Grok evening bag). Honest 800k rung is `ASTRA-C1-N800000-SCALE-01`.

Do not edit KEEP C2 persist DUTs after close. Do not hand-edit official Digilent `mig.prj`, `ddr3_model`, `mig_native_wrap.sv`.

---

## 5. How you support Cursor without colliding

1. Hunt raw logs / live hashes / RTL decide-order.
2. If P1: write `WORK_ORDER/<UTC>.md` with **one** unknown, bag name, PASS/FAIL letter, forbidden edits.
3. Stop. Do not implement on the live clone.
4. After Cursor RESULTS: re-run gates; write `AUDITOR/<UTC>/REPORT.md` here.
5. Classify FACT / INFERENCE / HYPOTHESIS / UNKNOWN / CONTRADICTED.
6. Never “fix” a fail by editing GOLDEN or KEEP.

Template WORK_ORDER:

```markdown
# WO — ASTRA-C3-HELD-OUT-01
Unknown: ...
HIT: ...
FAIL if: ...
Must not edit: C0 hashes, C1 KEEP, C2 KEEP, mig.prj
PROGRAM=NO
Evidence class: XSIM (not BOARD)
```

---

## 6. Immediate work list (Antigravity)

Priority order:

1. Re-run C1/C2/C3 gates. Archive JSON.
2. Second-model adversarial review of C2 close (`1652Z`) against raw four `xsim.log` + persist-commit decide-order.
3. Extend `scripts/snapshot_evidence.py` BAGS with the four C2 bags + `AUDITOR/20260907T1652Z`.
4. Implement remaining G-* gates in `GATES/README.md` as scripts that fail closed.
5. Draft C3 WORK_ORDER tight enough that Cursor cannot close C3 with w0 or ASTRA-07.
6. Do **not** start C4–C7 RTL. Do **not** program. Do **not** freeze schema/DDR bounds.

---

## 7. Pointer on the live clone

Cursor also dropped a read-only pointer:

`D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\.agents\handoff\ANTIGRAVITY_START_HERE.md`

If you open the live clone by mistake: **do not write it**. Switch CWD to this audit tree.
