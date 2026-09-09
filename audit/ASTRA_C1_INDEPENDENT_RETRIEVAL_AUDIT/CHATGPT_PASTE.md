# PASTE THIS INTO CHATGPT — Astra independent audit handoff

You are ChatGPT helping Anh (software engineer) on Astra Native AI (Arty A7-100T).
Date of handoff: 2026-09-08 00:07 +07.

You are NOT the live implementer. You do not stamp BOARD_PASS.
If you are used as a second-model auditor: read files, hunt overclaim, propose WORK_ORDERs.
If Anh also uses Antigravity: Antigravity’s CWD is the independent audit tree below.

## Role split

| Agent | May write | Must not |
|---|---|---|
| Cursor | live clone named bags + new named RTL | independent audit tree (after bootstrap); KEEP hashes; mig.prj |
| Antigravity | `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` only | live `rtl/`, KEEP bags, LOOP_STATE, V3.1 tree, new bit program |
| Grok parent | dispatch `unblocked_item` | independent tree; DUT implement |
| ChatGPT | advice + hunt text Anh pastes; optional drafts Anh saves into the audit tree | invent hashes; claim BOARD_PASS; silent-patch C0 |

## Open these first (in order)

1. `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\ANTIGRAVITY_START_HERE.md`
2. `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\COORDINATION.md`
3. `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\AGENTS.md`
4. `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\KEEP_HASHES.json`
5. `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\GATES\README.md`
6. `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\LOOP_STATE.json`
7. `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\OPEN_GATES.md`
8. `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md`  (§8 C2 done XSim; §9 C3 is NEXT)

Authority for PASS of the whole product is Master V1.1 C0–C7, not historical V3.1.

## Trees (absolute)

```
WRITE (Antigravity / independent)  D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
READ  (live isolate clone)         D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
                                   branch grok-orch/astra-native-v1-00
HIST  Codex/Grok handoff           D:\FPGA\ASTRA_HANDOFF
NEVER write V3.1 / Basys           D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00
NEVER write junction               D:\FPGA\basys3-four-agent-snn-ready
```

Live clone pointer (read-only reminder):
`D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\.agents\handoff\ANTIGRAVITY_START_HERE.md`

## Live LOOP (FACT)

```
acceptance             = ACCEPT_C1_C2_XSIM
c1_800k                = CLOSED_XSIM_CARTESIAN_PROCEDURAL
c2_persist             = CLOSED_XSIM_AXI_JOURNAL_PLUS_MIG_RELOAD
unblocked_item         = ASTRA-C3-HELD-OUT-01
c_gate                 = C3_HELD_OUT
CAND_CAP_FINAL         = 16
DDR_QUERY_BOUND_FINAL  = NOT_FROZEN
PERSIST_SCHEMA_VERSION = NOT_FROZEN
final_promotion        = REJECT
board_pass             = false
program_scope          = PINNED_SHA_e51bdca2_ONLY
```

C1/C2 Cursor auditor reports were same-session as implementer (disclosed). ChatGPT/Antigravity = second-model hunt.

## What is NOT done (do not skip)

C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip WNS>=0, C7 blind board exam.
Only C7 letter may stamp ASTRA_NATIVE_AI_BOARD_PASS.
A09R8 silicon `w0 0→-5` is NOT C3.

## Commands already green/red (independent tree)

```bat
cd /d D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT
python scripts\c1_800k_close_gate.py
python scripts\c2_persist_close_gate.py
python scripts\c3_heldout_prereg_gate.py
```

Verified 2026-09-08: C2_CLOSE=YES_XSIM BOARD=REJECT. C3_CLOSE=NO (bag not started).

## File list to attach or @ in ChatGPT

Independent tree:

```
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\ANTIGRAVITY_START_HERE.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\COORDINATION.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\AGENTS.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\README.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\KEEP_HASHES.json
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\GATES\README.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\WORK_ORDER\README.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\WORK_ORDER\20260907T1700Z_C3_HELD_OUT_DRAFT.md
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c1_800k_close_gate.py
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c2_persist_close_gate.py
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\scripts\c3_heldout_prereg_gate.py
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\results\c2_persist_close_gate.json
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\results\c3_heldout_prereg_gate.json
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\results\adversarial_review_c1_xsim_close.json
D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT\results\RCA_C1_XSIM_CLOSE.md
```

Live authority / close reports:

```
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\LOOP_STATE.json
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\WORK_QUEUE.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\GSTACK_LOOP.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\AUDITOR_BOOT.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\OPEN_GATES.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\CURRENT_EVIDENCE_LEDGER.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\FINAL_CONTRACT.json
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T2148Z\REPORT.md
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T1652Z\REPORT.md
```

C1 close bags (raw log > RESULTS):

```
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-N800000-SCALE-01\xsim.log
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-CAND-CAP-SWEEP-01\xsim.log
```

C2 close bags:

```
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C2-PERSIST-COMMIT-01\
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C2-PERSIST-MULTI-SLOT-01\
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C2-PERSIST-DDR-STALL-01\
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C2-PERSIST-MIG-01\
```

## Hard stops

Do not edit C0 prefixes: extract `cd7baf49`, lexicon FILE `38189974`, dir `09334e42`, sparse FILE `5a4ad04d`, gate `49a66da2`.
Do not edit C1 KEEP retrieve RTL / C2 KEEP persist RTL / official Digilent `mig.prj`.
Do not freeze DDR_QUERY_BOUND_FINAL or PERSIST_SCHEMA_VERSION from these bags.
Do not program any bit except pinned SHA `e51bdca2…` (test vehicle) without WNS>=0 + auditor ACCEPT + Anh.
xelab MIG must use `-mt off -O0`. Do not compile synth `mig_7series_0_mig.v` as DUT.

## First job for ChatGPT / Antigravity

1. Second-model hunt of C1 cartesian close and C2 persist close (F_BAD_TXN dead after DUP; MIG posted write; stall is modeled AXI not MIG PHY).
2. Tighten `WORK_ORDER\20260907T1700Z_C3_HELD_OUT_DRAFT.md` until leakage-proof; mark READY; then Cursor implements. Do not start C3 RTL yourself in the live clone.
3. Implement remaining G-* gates listed in GATES\README.md as fail-closed scripts in the independent tree.

Evidence law: raw xsim.log / UART / live Get-FileHash > gate JSON > prose.
Classify FACT / INFERENCE / HYPOTHESIS / UNKNOWN / CONTRADICTED.
Never promote XSim to BOARD.
