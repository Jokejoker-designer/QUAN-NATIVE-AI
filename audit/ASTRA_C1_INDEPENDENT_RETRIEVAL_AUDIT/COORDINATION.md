# Coordination — Antigravity × Cursor × Grok parent

Owner: Anh. Date: 2026-09-08 (+07).

## Roles (one writer per file)

| Agent | CWD | May write | Must not |
|---|---|---|---|
| **Antigravity** | `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` | This tree only: hunts, close-gates, WORK_ORDER, snapshots, adversarial JSON | Live clone `rtl/`, KEEP bags, `LOOP_STATE.json`, V3.1 tree, JTAG program of a new bit |
| **DeepSeek** | `drafts/` via `scripts/deepseek_consult.py` | Draft markdown/RTL under `drafts/` only | live `rtl/`, KEEP bags, secrets in git, BOARD_PASS |
| **Cursor** | live clone after 验收 | Named bags + unblock when DeepSeek is stuck (`DEEPSEEK_PROTOCOL.md`) | KEEP hashes; official `mig.prj`; secrets |
| **Grok parent** | live clone docs/ASTRA | Dispatch `unblocked_item` only | Independent audit tree; implement DUT; stamp `BOARD_PASS` |

Antigravity is the **independent auditor + adversarial test-gate builder**.
DeepSeek drafts complex RTL/reasoning into `drafts/` only.
Cursor is the **independent 验收** and the unblocker when DeepSeek is stuck.
Nobody self-stamps `ASTRA_NATIVE_AI_BOARD_PASS`.

See `DEEPSEEK_PROTOCOL.md`.

## Protocol

```text
1. Antigravity runs close-gates / hunts in THIS tree (raw xsim.log > RESULTS.md).
2. If FAIL/OVERCLAIM/P1: write WORK_ORDER/<UTC>.md  (one unknown, one bag name).
3. Anh or Grok parent copies the bag name into live LOOP_STATE.unblocked_item.
4. Cursor implements that ONE bag in the live clone. PROGRAM=NO unless the WO names pinned SHA e51bdca2.
5. Cursor writes RESULTS.md / CLOSEOUT.md. Does not self-grade Master close.
6. Antigravity re-runs gates on raw logs, writes REPORT under this tree
   AUDITOR/<UTC>/REPORT.md  (and optionally a copy request for live AUDITOR/).
7. Repeat. Never two implementers on the same bag. Auditor never patches DUT.
```

## Evidence law

```text
RAW xsim.log / UART / JTAG / live Get-FileHash
  > accepted gate JSON
  > audit interpretation
  > design prose
```

Never promote a weaker evidence class into a stronger one:

```text
BOARD > POST_ROUTE > MIG_XSIM > XSIM > OOC > RTL_FACT > HOST_MODEL > ENGINEERING > HYPOTHESIS
```

## What “dứt điểm PASS theo blueprint” actually means

Blueprint authority is Master V1.1 §5 DAG, **not** historical V3.1 / ASTRA-13 smoke:

```text
C0 freeze → C1 retrieval 800k → C2 persist → C3 held-out transfer
→ C4 LM06 language → C5 one production top → C6 whole-chip WNS>=0
→ C7 blind board exam → ASTRA_NATIVE_AI_BOARD_PASS
```

Live (2026-09-07 23:52 +07):

```text
C0 recorded          YES
C1 CLOSED_XSIM       YES (cartesian/AXI quality bound; not BOARD)
C2 CLOSED_XSIM       YES (modeled AXI capacity/stall; MIG reload single-slot; not BOARD)
C3–C7                OPEN
BOARD_PASS           NOT_CLAIMED
final_promotion      REJECT
```

Closing C3–C7 without the Master letter (5-seed transfer, LM06 tokens, one top, timing, blind silicon) is OVERCLAIM. Do not skip gates to “finish the project”.
