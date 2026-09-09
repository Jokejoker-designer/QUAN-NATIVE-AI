# ASTRA-08 — LM06 vocab/checkpoint audit (read-only)

```text
CLASS        = LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN
BIT          = NO
PROGRAM      = NO
COM12        = UNTOUCHED
REDESIGN     = NO
```

## Confirmed (this clone)

- LM-06 working-set XSim bit-exact vs frozen CONTROL: `results/A7-NATIVE-GRAPH/STATUS/CLOSEOUT_lm06_wm_00.md` (PASS_NARROW, not silicon of the restructure).
- BRAM 132 tiles are working machinery (`u_a` 66 / `u_w` 64 / `u_snap` 2), not a 784 KiB persistent model store: `results/A7-NATIVE-GRAPH/MEM-00/LM06_BRAM_OWNERSHIP_SOURCE.md`.
- Historical board chain (C9/OUT 653/689/237/60) is regression-only, not NLU.

## Not evidenced here

- Versioned tokenizer bound to the weight image with independent lexical decode.
- Autoregressive generation that is not host-templated class-ID → sentence.
- Input8-bit vs output10-bit contract closure (DESIGN_CANDIDATE §7).
- Teacher-off language exam on current HEAD.

## Classification

**LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN** — datapath/working-set exists; language usefulness is not proven. Do not retrain in this gate. Do not claim Gate14 language.

HANDOFF: LM activity ≠ language understanding.
