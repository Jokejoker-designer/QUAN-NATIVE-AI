# CLOSEOUT — ASTRA-C4-SLOT-COPY-CAPACITY-01

PROGRAM=NO. Python capacity/split falsifier. No xvlog. No third architecture.
Does not stamp C4_MASTER. Does not edit rival DUT hashes.

## Command

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-SLOT-COPY-CAPACITY-01\capacity.py
exit=0
SHA256 222747d7ced89cdc658355d45c6c3071f9b9fa038d77417cd1ced1ff64e3ce04
```

## Raw

- Held-out names hose/drum/vent/bolt: first letters **h,d,v,b unique**
- Held F/R prefix-collision pairs: **0**
- Train names pump/valv/tank/pipe: **pump vs pipe** share `p` (18 collision pairs)
- Held names ∩ train names: **[]**
- Prior trained probes (Elman, H16/H32, LM06-red STE, full BPTT, copy-aux): held **0/20**

## Classes

MISS: lang_90.
FACT: held 0/20 on this split is **closed-set name emission**, not F/R first-letter collision.
INFERENCE: D=16 STE emitting `pipe` on a `pump`/`hose` query is lookup of train names, not QUERY/PROOF slot copy.
FACT: rival-1 hidden has no ReLU; decode does not reread ctx; rival-2 q is from `xs[last]` only.

REVIEW_PENDING. self_accept=false.
