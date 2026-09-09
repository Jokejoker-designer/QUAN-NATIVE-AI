# G06-B result (not a prereg)

Prereg `EXPECTED_OUTCOME = UNKNOWN` in `PREREG.md`.

Observed IntegerModel of frozen V1 F-copy checkpoint on V2 contexts:

| id | got | expected | match |
|---|---|---|---|
| C1 F drum hose | hdse | hose | no |
| C2 R drum hose | oooo | drum | no |
| C3a R bolt hose | tnnn | bolt | no |
| C3b R vent hose | tnnn | vent | no |

Opcode F→R on C1 also emitted `oooo`, not `drum`.

```text
OLD_C4_CONTEXT_COMPATIBILITY = FAIL
FIRST_DIVERGENCE = V1-trained decoder depends on answer-aligned serialization
```

Materializer V2 was not changed. Confirm V2 was not instantiated.
