# RESULTS — ASTRA-04 RELATION-ENGINE-2HOP

```text
GATE     = ASTRA-04-RELATION-ENGINE-2HOP
XSIM     = ASTRA04_2HOP_XSIM_PASS
RESULT   = PASS_NARROW (unit BRAM-edge table, not DDR corpus, no LM)
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
```

| Test | Result |
|------|--------|
| stored fact pump requires chiller | PASS |
| 1-hop | PASS |
| 2-hop pump→chiller→condenser proof (4,2) | PASS |
| missing edge | UNKNOWN |
| wrong direction | WRONGDIR |
| supplies non-transitive compose | NTRANS |
| cycle | CYCLE |
| duplicate edge | last-wins still ANSWER |

Not claimed: DDR-backed 800k graph, LM, open NLU, ASTRA-05 perturbation suite.
