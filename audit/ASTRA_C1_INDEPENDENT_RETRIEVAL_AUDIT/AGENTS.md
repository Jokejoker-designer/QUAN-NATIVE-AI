# Independent Astra audit — Antigravity CWD

This directory is an **isolated** investigation and test-gate tree.
It is **not** the Astra implementer CWD.

Owner from 2026-09-08: **Antigravity** (independent auditor + gate builder).
Cursor/Grok must not write here after the bootstrap handoff.

## Never write

- `D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/rtl/`
- `D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-*` (KEEP bags)
- `D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/docs/ASTRA/LOOP_STATE.json`
- `D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/third_party/digilent/`
- `D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00`
- Junction `D:/FPGA/basys3-four-agent-snn-ready`

Read those trees. Write only under `D:/FPGA/ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT/`.

## Start

1. [ANTIGRAVITY_START_HERE.md](ANTIGRAVITY_START_HERE.md)
2. [COORDINATION.md](COORDINATION.md)
3. [GATES/README.md](GATES/README.md)
4. [KEEP_HASHES.json](KEEP_HASHES.json)

## Goal

Second-model hunt of C1/C2 XSim closes. Keep `BOARD_PASS` red. Build fail-closed gates. Dispatch **one-unknown** WORK_ORDERs so Cursor can implement C3→C7 on the live clone without cheat paths. Do not stamp `ASTRA_NATIVE_AI_BOARD_PASS`.

Do not patch C0 hashes. Do not edit KEEP C1/C2 RTL.
