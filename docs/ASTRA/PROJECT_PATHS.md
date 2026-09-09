# ASTRA Native AI — path catalog (isolate clone)

Updated: 2026-09-05. PROGRAM=NO. COM12 untouched.

## 1. Clone / git

| Item | Path |
|------|------|
| Isolate root | `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH` |
| Branch | `grok-orch/astra-native-v1-00` |
| HEAD | `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` |
| Do **not** write | `D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00` |

## 2. Master blueprint (Codex audit + SHA-matched copies)

| File | Original | Isolate copy |
|------|----------|----------------|
| DESIGN_CANDIDATE | `C:\Users\phant\.codex\.chatgpt-projects\g-p-68c95e6ae97c8191978788a39b2b2d1c\audits\NATIVE_AI_ASTRA_20260905\DESIGN_CANDIDATE.md` | `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\DESIGN_CANDIDATE.md` |
| HANDOFF_GROK | `...\NATIVE_AI_ASTRA_20260905\HANDOFF_GROK.md` | `...\docs\ASTRA\authority\HANDOFF_GROK.md` |
| AUDIT | `...\NATIVE_AI_ASTRA_20260905\AUDIT.md` | `...\docs\ASTRA\authority\AUDIT.md` |
| Manifest | | `...\docs\ASTRA\authority\AUTHORITY_COPY_MANIFEST.json` |
| Isolated master prompt | | `...\docs\ASTRA\authority\GROK_ASTRA_NEW_SESSION_MASTER_PROMPT_ISOLATED_V1.md` |
| Blueprint V3.1 (historical) | | `...\docs\ASTRA\authority\UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md` |

SHA match: DESIGN `ABAE77D6…` HANDOFF `BDDA0F35…` AUDIT `A1752410…`

## 3. Parent / loop / tick

| File | Path |
|------|------|
| Orchestrator | `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\PARENT_ORCHESTRATOR.md` |
| Boot | `...\docs\ASTRA\PARENT_BOOT.md` |
| Loop state | `...\docs\ASTRA\LOOP_STATE.json` |
| Pause/resume | `...\docs\ASTRA\PAUSE_RESUME.md` |
| Launch bat | `...\docs\ASTRA\launch_parent.bat` |
| This catalog | `...\docs\ASTRA\PROJECT_PATHS.md` |
| Tick | scheduler id `01a0723a2dd4` (20 min) |

## 4. Evidence bags (`results\A7-NATIVE-GRAPH\`)

Base: `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\`

| Bag | Result |
|-----|--------|
| `ASTRA-00-BASELINE-AUTHORITY-FREEZE` | PASS |
| `ASTRA-01-U4-REAL-AXI-SPARSE-00` | unit |
| `ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION` | PASS |
| `ASTRA-02-SCALE-SELECTIVITY-00` | host ladder |
| `ASTRA-02-U5-SCALE-SELECTIVITY-800K` | PASS_NARROW |
| `ASTRA-03-ROLE-AWARE-QUERY` | PASS |
| `ASTRA-04-RELATION-ENGINE-2HOP` | PASS_NARROW |
| `ASTRA-05-CAUSAL-PROOF-PERTURBATION` | PASS_NARROW |
| `ASTRA-06-SHARED-REWARD-LEARNER` | PASS_NARROW |
| `ASTRA-07-HELD-OUT-TRANSFER` | PASS |
| `ASTRA-08-LM06-VOCAB-CHECKPOINT-AUDIT` | LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN |
| `ASTRA-09-UNIFIED-PIPELINE` | PASS_NARROW |
| `ASTRA-09-SPARSE-GLUE` | PASS_NARROW |
| `ASTRA-10-OOC-RESOURCE` | PASS_NARROW LUT 2966 |
| `ASTRA-10B-OOC-ASTRA09-PIPE` | PASS_NARROW LUT 3707 |
| `ASTRA-11-FULLCHIP-COFIT` | PINMAP_AUDIT DONE |
| `ASTRA-11-SOC-WRAP` | PASS_NARROW WNS=-4.765 ns; bit UNPROGRAMMED |
| `ASTRA-11-TIMING-FIX` | NOT IN QUEUE (do not start; 11 accepts WNS<0) |
| `ASTRA-12-FINAL-SOURCE-FREEZE` | PASS_NARROW (pre-glue) + `DRIFT.md` |
| `ASTRA-12B-POST-GLUE-FREEZE` | PASS_NARROW hash bag; **live DRIFT** on SGD (see bag `DRIFT.md`) |
| `ASTRA-RTP-RETRIEVAL-TO-PROOF` | PASS_NARROW (F1 XSim causality; TB_LOAD=0) |
| `ASTRA-RTP-R1-TRANSPORT-IDENTITY` | PASS_NARROW (RESULTS.md recorded; original rtp pipe unchanged) |
| `ASTRA-RTP-F2-COMPETE-RANK-REWARD` | RESULTS.md RECORDED PARTIAL; `ASTRA_RTP_F2_XSIM_FAIL` (reward-switch); not F2 PASS |
| `ASTRA-RTP-R2-HIGHID-ARTO` | PASS_NARROW (20-bit ID / AR stall / LATE_R; original rtp pipe unchanged) |
| `ASTRA-RTP-F2T-SHARED-TRANSFER` | PASS_NARROW (class-transfer; v1 SGD; not timing-fix) |
| `ASTRA-RTP-HOP3` | PASS_NARROW (`ASTRA_RTP_HOP3_XSIM_PASS`; posting intervention; TB_LOAD=0) |
| `ASTRA-SGD-PERSIST` | PASS_NARROW (`ASTRA_SGD_PERSIST_XSIM_PASS`; v1 weight snapshot; not schemaV2 store) |
| `ASTRA-SOC-RTP-GLUE` | PASS_NARROW XSim (`ASTRA_SOC_RTP_GLUE_XSIM_PASS`); R1 fetch + planted AXI; not board |

## 5. ASTRA RTL (this clone)

| Role | Path |
|------|------|
| Role parser v2 | `rtl\native_graph\query\a7ng_query_role_extract.sv` |
| Role lexicon | `rtl\native_graph\query\qse_role_lexicon.svh` `role_lexicon.py` `twin_role.py` |
| QSE v1 (unchanged SHA ede064f0) | `rtl\native_graph\query\a7ng_query_struct_extract.sv` |
| Valid gate | `rtl\native_graph\query\a7ng_route_valid_gate.sv` |
| Sparse AXI dir | `rtl\native_graph\memory\a7ng_sparse_dir_axi.sv` |
| Sparse integrate | `rtl\native_graph\integrate\a7ng_query_axi_sparse.sv` |
| 2-hop engine | `rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv` |
| Unified pipe (pre-glue) | `rtl\native_graph\integrate\a7ng_unified_pipe.sv` |
| Exam pipe + sparse | `rtl\native_graph\integrate\a7ng_astra09_pipe.sv` |
| Shared SGD | `rtl\native_graph\learn\a7ng_shared_rank_sgd_q8.sv` |
| Proof bytes | `rtl\native_graph\lm\a7ng_evidence_compose.sv` |
| UART (reuse) | `rtl\board\uart_rx.sv` `uart_tx.sv` `a7ng_uart_rx100.sv` |
| Pin XDC | `constraints\arty_a7_100.xdc` |

SoC wrap: `rtl\board\arty_a7_astra09_soc_top.sv`  
AXI BRAM: `rtl\native_graph\memory\a7ng_axi_bram128.sv`  
Unprogrammed bit: `results\A7-NATIVE-GRAPH\ASTRA-11-SOC-WRAP\arty_a7_astra09_soc_top.bit`

## 6. Toolchain

| Item | Path |
|------|------|
| Vivado 2026.1 | `C:\2026.1\Vivado\bin\vivado.bat` |
| License | `D:\Xilinx\licenses\vivado_basic.lic` |
| Grok CLI | `C:\Users\phant\.grok\bin\grok.exe` |
| Part | `xc7a100tcsg324-1` |
| Board UART/JTAG (do not program) | COM12 / `210319BE776EA` |

## 7. Open gate

ASTRA-13 BLOCKED. PROGRAM=NO. Do not start ASTRA-13, timing-fix, or board promote of ASTRA-11 wrap.
HOP3 RESULTS.md PASS_NARROW. SGD persist RESULTS.md PASS_NARROW. RTP/R1/R2/F2T RESULTS.md PASS_NARROW. F2 RESULTS.md recorded PARTIAL (`ASTRA_RTP_F2_XSIM_FAIL` reward-switch; two proofs + rank-before-select closed; weight update not closed).
`unblocked_item=AUDITOR_NEEDED` after SOC_RTP_GLUE XSim. Next would be ASTRA-13 — not started. Stop for auditor.
12B still **DRIFT** on `a7ng_shared_rank_sgd_q8.sv`; do not retarget ASTRA-06 SGD; no second F2 writer.
ASTRA-11 wrap remains PASS_NARROW_SCAFFOLD, WNS=-4.765, bit UNPROGRAMMED.
LM06 NOT_INTEGRATED. Do not claim language.
