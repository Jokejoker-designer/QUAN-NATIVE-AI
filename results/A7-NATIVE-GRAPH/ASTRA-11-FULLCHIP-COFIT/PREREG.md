# PREREG — ASTRA-11 FULLCHIP-COFIT

```text
GATE     = ASTRA-11-FULLCHIP-COFIT
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
```

Fullchip impl of ASTRA pipe + existing SoC/LM06 is a separate long job.
Do not overwrite frozen bits. Do not program COM12. If blocked on missing
top-level pin map for the new pipe, write BLOCKED.md and do not invent I/O.
