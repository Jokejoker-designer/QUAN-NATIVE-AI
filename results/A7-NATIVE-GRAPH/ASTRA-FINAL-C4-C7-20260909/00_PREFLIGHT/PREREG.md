# PREREG — G00 Stage 0 Preflight

**WO:** `WO_FINAL_ASTRA_C4_C7_CONVERGENCE_20260909.md` §5  
**Goal:** G00  
**PROGRAM:** NO  
**self_accept:** false

## Unit of analysis

One local repository snapshot + SHA256 of declared rescue/candidate artifacts. Not a capability PASS.

## PASS

- git toplevel/branch/HEAD/status recorded
- no `reset --hard` / discard of today's dirty tree
- rescue artifact SHA256 recorded
- C3–C6 candidate inventory recorded
- `ASTRA_NATIVE_AI_BOARD_PASS` remains OPEN

## FAIL

Missing hashes, destructive git, or claiming C4/C5/C6/C7 PASS from this bag.
