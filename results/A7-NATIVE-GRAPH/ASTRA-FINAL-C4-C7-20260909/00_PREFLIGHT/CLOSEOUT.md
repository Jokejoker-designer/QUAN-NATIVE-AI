# CLOSEOUT — G00 Stage 0 Preflight

```text
GATE                 G00 Stage 0 Preflight
BASE_COMMIT          5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
SOURCE_COMMIT        5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1 (dirty tree preserved, not reset)
TREE_STATUS          DIRTY_PRESERVED
FILES_CHANGED        this bag only; no RTL mutation in G00
PRIMARY_UNKNOWN      which checkpoint is the frozen D32 numerical law after G01 (reverse KEEP vs F-copy candidate)
FIRST_DIVERGENCE     n/a (preflight)
VIOLATED_INVARIANT   none
ACTUAL_COMMANDS      git rev-parse --show-toplevel; git branch --show-current; git rev-parse HEAD; git status --short; git diff --stat; SHA256 inventory python
ACTUAL_EXIT_CODES    0
METRICS              see METRICS.json
RESOURCE_DELTA       n/a
EVIDENCE_CLASS       FACT (git + hashes + file inventory)
RESULT               G00_PREFLIGHT_PASS
LIMITATIONS          MIG user_design noise dominates git status; not cleaned. Confirm v2 240 F/R is not WO 360 and not C4_MASTER. D32 RTL missing. C6 still instantiates old C5 top.
BIT_BUILD            NOT_RUN
PROGRAM              NO
NEXT                 G01 Stage 1 freeze C4 numerical + context contracts
```

`ASTRA_NATIVE_AI_BOARD_PASS` remains OPEN.
