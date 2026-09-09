# QUAN NATIVE AI

Public research tree for **Astra Native AI** on Digilent **Arty A7-100T** (`xc7a100tcsg324-1`).

The FPGA owns retrieve → 2-hop proof → grounded generation → pending reward → on-chip SGD. The host is a UART teacher/auditor, not the learning engine.

This snapshot is built so **any AI or engineer can follow the design, replay XSim bags, and hunt remaining C3–C6 gaps** without downloading Vivado run dumps, compiled simulators, or bitstream binaries.

**Honest status (2026-09-09):** named C1–C6 *this-gate* bags exist. Master letters `C3_MASTER` / `C4_MASTER` / `C5_MASTER` / `C6_MASTER` remain **OPEN**. This repo does **not** stamp `BOARD_PASS` or `ASTRA_NATIVE_AI_BOARD_PASS`.

---

## Tiếng Việt (ngắn)

Đây là bản public của mô hình Astra Native AI: RTL, hợp đồng, testbench, closeout, kế hoạch đóng C1–C6, và báo cáo audit độc lập.

**Không** đẩy bitstream, checkpoint Vivado, thư mục `xsim.dir`, file JSON train nặng, hay RTL MIG do Vivado generate (EULA Xilinx). SHA của bit và marker PASS/FAIL nằm trong `CLOSEOUT.md`.

Đọc bắt đầu: [`AI_FOLLOW.md`](AI_FOLLOW.md) → [`results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md`](results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md) → [`handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/MASTER_CLOSURE_PLAN.md`](handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/MASTER_CLOSURE_PLAN.md).

---

## Start here (for humans and other AIs)

| Order | Path | Why |
|---|---|---|
| 1 | [`AI_FOLLOW.md`](AI_FOLLOW.md) | How to audit this tree without overclaiming |
| 2 | [`AGENTS.md`](AGENTS.md) | Agent lock, frozen lanes, Native Graph rules |
| 3 | [`docs/NATIVE_AI_ARTY_A7_BLUEPRINT/00_CURRENT_AUTHORITY.md`](docs/NATIVE_AI_ARTY_A7_BLUEPRINT/00_CURRENT_AUTHORITY.md) | Authority order: evidence > LOOP_STATE > blueprint |
| 4 | [`docs/NATIVE_AI_ARTY_A7_BLUEPRINT/04_HARDSTOPS.md`](docs/NATIVE_AI_ARTY_A7_BLUEPRINT/04_HARDSTOPS.md) | HS-01…HS-25 |
| 5 | [`docs/authority-root/ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md`](docs/authority-root/ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md) | Master V1.1 post-silicon letter |
| 6 | [`results/A7-NATIVE-GRAPH/STATUS/LOOP_STATE.json`](results/A7-NATIVE-GRAPH/STATUS/LOOP_STATE.json) | Live execution pointer |
| 7 | [`results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md`](results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md) | Why C3–C6 are not final PASS |
| 8 | [`handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/`](handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/) | Independent close plan + Cursor work orders |

Chat memory is **not** project authority.

---

## What is in this repo

```text
rtl/native_graph/          Native Graph + Astra C1–C6 RTL
rtl/board/                 Board wrappers / SoC tops
docs/NATIVE_AI_ARTY_A7_BLUEPRINT/   Architecture package
docs/native_graph/         Operating plan, budget, freeze, test matrix
docs/ASTRA/                Astra session authority and parent boot
docs/authority-root/       Isolated Grok master prompt + Master V1.1
constraints/               Arty A7 XDC
vivado/tcl/                Program / report Tcl (no .runs trees)
vivado/ip/mig_7series_0/   MIG .xci + mig.prj only — regenerate RTL in Vivado
tests/                     Shared XSim / hex (no compiled sim)
results/A7-NATIVE-GRAPH/   Bag closeouts, TBs, run_xsim.ps1, STATUS
handoff/ASTRA_HANDOFF/     Manager handoff + C1–C6 close plan
audit/                     Independent retrieval / C3–C6 auditor work orders
.agents/  .cursor/         Crew, pipeline, Cursor rules (no live mcp.json)
```

Production-looking tops to read first:

- `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv`
- `rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv`
- `rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv`
- `rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv`
- `rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv`
- `rtl/native_graph/integrate/a7ng_astra_c6_wholechip.sv`

Canonical C4 DUT is **LM06 grounded gen** (0 BRAM). TinyGPT-802k is **retired** (`TINYGPT_802K=RETIRED_PER_GROK_550`). Do not revive it to “make it look like AI”.

---

## What was deliberately left out

Local research tree was ~2 GB, almost all `results/A7-NATIVE-GRAPH` machine output. This public export is ~38 MiB.

| Left out | Reason |
|---|---|
| `xsim.dir/`, `*.exe`, `*.sdb`, `*.rtd` | Compiled XSim; rebuild with `run_xsim.ps1` |
| `*.bit`, `*.dcp` | Large binaries; SHA is in CLOSEOUT / freeze manifests |
| Vivado `.runs/.cache/.hw` | Regenerable; not needed to find RTL bugs |
| Generated MIG `user_design/rtl` | Xilinx IP; keep `.xci` + `mig.prj` |
| `TRAIN_METRICS*.json` and other bulky JSON | User request + GitHub size; scripts remain |
| Independent-audit `drafts/` tick spam | Noise; keep `WORK_ORDER/` and `AUDITOR/` |

See [`EXPORT_MANIFEST.json`](EXPORT_MANIFEST.json) for file counts and the largest included objects.

---

## Reproduce a bag (XSim)

Requires Vivado 2026.1 (or the version recorded in the bag CLOSEOUT) on Windows.

```powershell
cd results/A7-NATIVE-GRAPH/ASTRA-C5-PROD-TOP-MIG-01
.\run_xsim.ps1
```

A bag is not closed by a script existing. A bag is closed when `CLOSEOUT.md` records the command, the marker (`ASTRA_*_XSIM_PASS` or FAIL), and the DUT SHA.

Do not promote XSim PASS to BOARD_PASS.

---

## Open master gaps (do not paper over)

Tracked in `HARD_BLOCK_MASTER_C3_C6.md` and the 2026-09-09 close plan:

1. **C3** — held-out / reload this-gates exist; silicon held-out episode (C7) is still required for the master letter.
2. **C4** — grounded class-ID path and 20-question ablations exist; QUERY/PROOF *language* generation is still MISS. Bias-load dead (`V[5:0]=0`) is a recorded falsifier.
3. **C5** — live prod_top still has auto-reward / grant-hold / UART baud / last-token issues vs named patched tops. Flush-reload MIG grant-drop is documented.
4. **C6** — POST_ROUTE WNS PASS and bit SHA `edda8575…` exist; freeze artifacts and board program are not a clean final promotion.

Work orders: [`handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/CURSOR_WORK_ORDERS.md`](handoff/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/CURSOR_WORK_ORDERS.md).

---

## Lineage

| Item | Value |
|---|---|
| Display name | QUAN NATIVE AI |
| Research clone | `D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH` |
| Branch | `grok-orch/astra-native-v1-00` |
| Historical GitHub | [Jokejoker-designer/FPGG_ART_Y](https://github.com/Jokejoker-designer/FPGG_ART_Y) |
| Related | [Jokejoker-designer/arty-a7-online-lm](https://github.com/Jokejoker-designer/arty-a7-online-lm) |

This public tree is a **lean evidence export**, not a git-filter of the 2 GB working clone.

---

## License / IP

See [`NOTICE.md`](NOTICE.md). Project RTL and docs are published for research and independent audit. Xilinx MIG / Vivado IP must be regenerated by the user under their own Vivado license. Do not treat this repository as a redistributable Xilinx IP core.
