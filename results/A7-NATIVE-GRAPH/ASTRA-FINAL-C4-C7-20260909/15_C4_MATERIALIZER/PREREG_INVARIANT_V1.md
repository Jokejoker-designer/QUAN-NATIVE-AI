# G06 PREREG — invariant SRC/DST materializer (before C4 decode)

**PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.**
**Written before IntegerModel/RTL decode of these contexts.**

## Law under test

Materializer serializes FPGA-owned proof endpoints. It must **not** permute slots as a function of F/R.

```text
byte 0        opcode 'F'=70 or 'R'=82
byte 1        space
bytes 2..5    SRC (4 ASCII)   proof source endpoint
byte 6        space
bytes 7..10   DST (4 ASCII)   proof dest endpoint
byte 11       '>'
bytes 12..15  DST (repeat of dest; identical for F and R)
```

Text form: `F drum hose>hose` / `R drum hose>hose`.

**Forbidden:** direction-dependent rewrite such as
`F hose drum>hose` vs `R drum drum>hose`.

## Falsifier (layout)

After materializing `ctx_F` and `ctx_R` from the same SRC/DST:

```text
for i in 1..15:  ctx_F[i] == ctx_R[i]
ctx_F[0] == 'F'
ctx_R[0] == 'R'
```

Any other differing byte = materializer answer-selection. FAIL.

## C4 expected (preregistered; not tuned after viewing)

Copy law on this layout:

```text
opcode F → emit DST then EOS
opcode R → emit SRC then EOS
```

| id | SRC | DST | op | context | expected C4 tokens |
|---|---|---|---|---|---|
| C1 | drum | hose | F | `F drum hose>hose` | `hose` + EOS |
| C2 | drum | hose | R | `R drum hose>hose` | `drum` + EOS |
| C3a | bolt | hose | R | `R bolt hose>hose` | `bolt` + EOS |
| C3b | vent | hose | R | `R vent hose>hose` | `vent` + EOS |
| C4F | drum | hose | F | same as C1 | `hose` + EOS |
| C4R | drum | hose | R | same as C2 | `drum` + EOS |

C1 vs C2 / C4: same proof bytes, only opcode flips. If C4 strings are equal, F/R path is not causal. FAIL.

C3a vs C3b: same DST and opcode R, SRC replaced. Output must follow SRC. FAIL if both emit `hose` or both emit the old SRC.

## Anti-shortcuts (must FAIL these oracles)

On C1/C2 pair:

- always copy slot A (SRC) → would emit `drum` for F (wrong)
- always copy slot B/C (DST) → would emit `hose` for R (wrong)

## What this does **not** claim

- Not `C4_MASTER_PASS`
- Not `ASTRA_NATIVE_AI_BOARD_PASS`
- Frozen WO360 differential remains evidence for the **previous** permuting layout only
