# CLOSEOUT — ASTRA-C4-LM06-RED-BPTT-01

PROGRAM=NO. Full attention BPTT / STE / slot-copy aux on the declared
rival-2 family. Does **not** overwrite rtl `a7ng_astra_c4_lm06_red.sv`
`b45773d309200675e375decc2570c4a55cbc6e90569632420a232c08686bee4b`
or LCG hex `74b5f885da98382db924c0b2a7e002b126d6517330c23ce164e62695ccdade1d`.
Does **not** stamp C4_MASTER. `LM06_BYTE256` NOT_FROZEN. No TinyGPT. No WO0550.
No XSim DUT for these 0% held probes.

## Commands

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BPTT-01\train_bptt.py
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BPTT-01\train_ste.py
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BPTT-01\train_copy.py
```

All exit 0. Python-only. No xvlog.

## Raw

Packed 16-byte QUERY/PROOF law unchanged: train pump/valv/tank/pipe,
held-out hose/drum/vent/bolt, evid_has=0 hardware `n,o,EOS`.

| Mode | Config | n_w | TF train | Greedy train | Held 90 | Hall |
|---|---|---|---|---|---|---|
| float BPTT | d4_nope (DUT law) | 1392 | n/a | **0/20** | **0/20** | 1.0 |
| float BPTT | d4_pe | 1488 | n/a | 0 | **0/20** | 1.0 |
| float BPTT | d16_pe (same-family scale) | 6528 | n/a | 0 | **0/20** | 1.0 |
| STE/QAT | d4_nope | 1392 | 0.03–0.19 | **0** | **0/20** | 1.0 |
| STE/QAT | d16_pe | 6528 | **0.83** | 0.21–0.33 | **0/20** | 1.0 |
| STE + attn copy aux | d4_nope | 1392 | 0.09 | **0** | **0/20** | 1.0 |
| STE + attn copy aux | d16_pe | 6528 | 0.76 | 0.17 | **0/20** | 1.0 |

Float BPTT loss dropped (d16 ~1.1) but integer greedy collapsed (`eppppp` /
`nnniRR` / `ppeeee`) because small-float embeddings round to near-zero int8.
STE used int8-scale init. evid_has=0 safe remains hardware `n,o,EOS`.

d16 greedy train samples emit **train-set names** (`pipe` for a `pump` query),
not held-out slot copy (`hose`→`dddddd`/`tav`).

## Classes

MISS: lang_90, lang_hall5, lang_safe95 (unrelated hall=1.0; evid_has=0 gate
alone is not the 95% unrelated-safe letter).
HIT: rtl_hex_unedited, cloud=false, tinygpt=false.

## Corrective hypothesis (one)

Exact D=4 F=8 1-layer rival-2 cannot memorize this split under full BPTT.
Same-family D=16+PE teacher-forces train names and does not copy held-out
QUERY/PROOF slots. Do not add a third architecture. Do not execute WO0550.
Do not rewrite §10 into a renderer. C4_MASTER stays OPEN.

REVIEW_PENDING. self_accept=false.
