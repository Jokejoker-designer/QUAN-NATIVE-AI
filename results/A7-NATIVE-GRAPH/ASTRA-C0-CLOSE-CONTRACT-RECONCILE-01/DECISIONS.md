# DECISIONS — C1–C6 close contract reconcile

PROGRAM=NO. Proposed contract only. Does **not** freeze
`LM06_BYTE256`, `DDR_QUERY_BOUND_FINAL`, `PERSIST_SCHEMA_VERSION`.
Does **not** stamp `C3_MASTER` / `C4_MASTER` / `C5_MASTER` / `C6_MASTER` /
`BOARD_PASS`.

Live KEEP hashes MATCH the handoff `KEEP_VERIFICATION.json` (18/18).
Live DUT hashes MATCH `SOURCE_SNAPSHOT.json` except `docs/ASTRA/LOOP_STATE.json`
(this session added TinyGPT-retired / held-out notes; not a KEEP file).

## Product target (current, not amended)

Master V1.1 §9–13 remains the letter. Compact learned **sequence** generation
is a **candidate** for C4, not a closed letter. Owner has not approved a
Master amendment that drops BYTE256 language.

## §550 vs WO0550

**FACT.** Grok isolated prompt line 550 is under `ASTRA LEARNING TARGET`:
do not add a large NN merely to use the word "AI"; preferred learner is the
32-feature linear reward predictor.

**FACT.** That line does **not** retire LM06, does **not** close Master §10,
and does **not** authorize `C4_MASTER=CLOSED` from a 20-sample class-ID bag.

**INFERENCE.** TinyGPT-802k acc=0/2 and additive BRAM 260>135 falsify **that**
candidate, not every compact conditional generator.

WO0550 (expand old grounded_gen bag to 20 then freeze C4) is a **proposal**,
not executable close. Do not rewrite frozen GOLDEN of
`ASTRA-C4-LM06-GROUNDED-GEN-01`.

## C3 labels (break the C7 circle)

| Label | Meaning | Board program required? |
|---|---|---|
| `C3_PREBOARD_VERIFIED` | XSim/MIG statistical protocol + full-vector reload on canonical path | NO |
| `C3_BOARD_CONFIRMED` | Silicon held-out of that same path | YES (C7) |

C6 preboard ready does **not** require C7 program. C7 is confirmation, not a
gate that blocks C1–C6 **readiness**.

## C1 / C2 scope

Do not rerun closed C1/C2 unit bags only to add markers.
`C1_C2_XSIM_ACCEPTED` stays that scope. Production C1 image + DDR bound freeze
and C2 **full SGD32** persist are **new** named bags (WO-03 / WO-01B).

## Architecture still open (does not block P1)

C4 rival set (max 2), undeclared until WO-02 feasibility:

1. Compact conditional recurrent/sequence decoder, BYTE256 or bounded vocab
   + dictionary (not V=64 class-ID as BYTE256).
2. LM06-compatible reduced core with measured footprint.

Not decided: which rival, vocab law, checkpoint. P1 reward/persist proceeds
with the existing C3 SGD bank + new C5 I/O.

## Canonical hierarchy (proposed)

```text
UART framed cmd
→ role parser / full-ID map
→ C1 KEEP index/descriptor
→ legal proof frontier
→ shared rank / pending txn
→ explicit host reward packet
→ committed C3 SGD32
→ versioned DDR checkpoint (new backend; C2 KEEP = control)
Answer: status/proof gate → FPGA dict/text materializer
→ compact learned generator → token FIFO → UART
```

Invalid/unsupported proof must not become ANSWER through the generator.

## Ownership / write map

| Package | Writer files | Must not touch |
|---|---|---|
| WO-00 | this bag only | KEEP, live tops, LOOP_STATE Master flags |
| WO-01A | new `a7ng_astra_c5_prod_top_rew*` | live `prod_top.sv`, C3 wrap, C2 KEEP |
| WO-01B | new persist backend | C2 KEEP, live prod_top |
| WO-02 | new C4 gen/hex/TB | live `grounded_gen.sv`, TinyGPT hex, C5 rew files |

## First measured falsifiers (this session)

See bags `ASTRA-C4-BIAS-LOAD-DEAD-01` and `ASTRA-C5-AUTO-REWARD-REGRESS-01`.
Those prove F01/F04 on **unedited** live DUT. They do not close letters.
