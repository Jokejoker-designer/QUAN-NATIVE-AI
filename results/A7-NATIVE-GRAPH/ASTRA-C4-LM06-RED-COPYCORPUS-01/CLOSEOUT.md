# CLOSEOUT — ASTRA-C4-LM06-RED-COPYCORPUS-01

PROGRAM=NO. Diverse / online local QUERY/PROOF training on rival-2 family.
Does **not** overwrite rtl hex `74b5f885…`. Frozen held-out remains
hose/drum/vent/bolt. Not C4_MASTER. No TinyGPT. No XSim (held 0/20).

## Commands

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-COPYCORPUS-01\train_corpus.py
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-COPYCORPUS-01\train_online.py
```

Both exit 0.

## Raw

12-name cartesian (4 original + 8 random): n_train=396.

| Config | TF train | Greedy train | Frozen held |
|---|---|---|---|
| d4_nope DUT law | 0.17 | 0 | **0/20** (empty emit) |
| d16_pe | 0.72 | 0.13 | **0/20** (`etty`/`qeeg` train names) |

Online fresh random 4-grams each row (no name inventory), d16_pe 30×192:

- train TF 0.30
- frozen held **0/20** (`no` / `phq` / `uuuit`)
- tf_held 0.17
- hall_rate 0.33

## Classes

MISS: lang_90, lang_hall5, lang_safe95.
HIT: rtl_hex_unedited, frozen_held eval, cloud=false.

REVIEW_PENDING. self_accept=false.
