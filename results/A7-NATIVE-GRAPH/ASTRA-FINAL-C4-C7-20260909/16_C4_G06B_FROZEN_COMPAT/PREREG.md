# G06-B PREREG — frozen V1-trained D32 on V2 contexts

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**
**EXPECTED_OUTCOME = UNKNOWN**

This file is written before decode. It does not claim PASS or FAIL.

## Checkpoint under test

Frozen F-copy D32 (V1-trained serialization). IntegerModel + the same D32 RTL weights. Materializer V2 is not modified after seeing outputs.

## Semantic expected outputs (copy law)

| id | proof | op | V2 context | expected tokens |
|---|---|---|---|---|
| C1 | SRC=drum DST=hose | F | `F drum hose>----` | `hose` + EOS |
| C2 | SRC=drum DST=hose | R | `R drum hose>----` | `drum` + EOS |
| C3a | SRC=bolt DST=hose | R | `R bolt hose>----` | `bolt` + EOS |
| C3b | SRC=vent DST=hose | R | `R vent hose>----` | `vent` + EOS |

## Falsifiers (also scored, not used to retune)

Opcode intervention: keep bytes 1..15 of C1, set byte 0 from F to R. Expected endpoint flips `hose` → `drum`.

Endpoint intervention: R with DST=hose, SRC ∈ {drum, bolt, vent} must emit that SRC.

## How to read the result

- If all rows match: `OLD_C4_CONTEXT_COMPATIBILITY = PASS` (V1-trained decoder already follows V2).
- If F and R emit the same endpoint, or opcode flip does not change the endpoint: `OLD_C4_CONTEXT_COMPATIBILITY = FAIL` and `FIRST_DIVERGENCE = V1-trained decoder depends on answer-aligned serialization`.
- Do not change the materializer either way.
