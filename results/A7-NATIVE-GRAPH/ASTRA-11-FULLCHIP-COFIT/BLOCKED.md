# BLOCKED — ASTRA-11 FULLCHIP-COFIT

```text
BLOCKER   = no ASTRA-pipe pin/clock map into frozen Gate14/LM06 SoC top
BIT       = NO (do not overwrite frozen bits)
PROGRAM   = NO
COM12     = UNTOUCHED
```

Cannot invent I/O, MIG, or UART mux into `a7ng_g1g5_cofit` / Gate14 without a
reviewed address map. Historical U2R 313 free slices is a **candidate**, not
current HEAD. Next unblocked in this gate: record OOC vs U2R headroom only.
