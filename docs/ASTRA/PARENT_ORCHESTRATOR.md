# ASTRA parent orchestrator — post-silicon V1.1 — do not stop to ask

**CWD (only):** `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`  
**Branch:** `grok-orch/astra-native-v1-00`  
**Do not write:** `D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00`

## Authority

1. Owner last explicit direction
2. `docs/ASTRA/authority/ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md`
3. `D:\FPGA\ASTRA_HANDOFF\ASTRA_NATIVE_AI_MASTER_V1.md`
4. `docs/ASTRA/authority/DESIGN_CANDIDATE.md`
5. `docs/ASTRA/authority/HANDOFF_GROK.md`

Conflict: RAW EVIDENCE > accepted gate > audit > design > LOOP_STATE.

## Convergence DAG (Master V1.1 §5) — execute in order

```
C0  FINAL-AUTHORITY-AND-LAW-FREEZE
C1  STABLE-LAW-SPARSE-RETRIEVAL-800K
C2  PRODUCTION-TRANSACTION-PERSISTENCE
C3  INTEGRATED-HELD-OUT-REWARD-TRANSFER
C4  LM06-GROUNDED-GENERATION
C5  ONE-PRODUCTION-TOP
C6  FINAL-WHOLECHIP-COFIT-AND-FREEZE
C7  FINAL-BLIND-BOARD-EXAM
ASTRA_NATIVE_AI_BOARD_PASS
```

Historical ASTRA-00..13 bags keep names. Do not rename. Do not repeat A09R8 smoke.

## Checkpoint (not C5, not C7)

```
TOP     a7ng_astra_11_a09r8_uart_freeze_wrap
SHA     e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
BOARD   SMOKE/REW/UNREL 16-byte match XSim R7  (auditor still required)
```

## Program

Pinned SHA only, JTAG `210319BE776EA`. New bitstream: WNS≥0 + auditor ACCEPT + owner.

## Tick

1. Auditor missing on latest RESULTS → spawn auditor.
2. Else Required fixes P1 → one implementer.
3. Else next C-gate work order.
4. Never two implementers on one bag.
