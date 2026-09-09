# CLOSEOUT — ASTRA-C4-LM06-RED-FLOATTFM-01

PROGRAM=NO. Same-family scale: D=32 F=64 PE softmax (float), not TinyGPT,
not a third architecture. Does not overwrite D=4 DUT hex `74b5f885…`.
Frozen held-out hose/drum/vent/bolt. Not C4_MASTER. No XSim (letter MISS).

## Commands

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-FLOATTFM-01\train_float.py
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-FLOATTFM-01\train_float_best.py
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-FLOATTFM-01\train_float_rup.py
```

All exit 0.

## Raw

| Run | Peak held float | Int8 greedy | Notes |
|---|---|---|---|
| train_float 40×96 | 3/20 (ep 30) | 0/20 | first nonzero held |
| train_float_best 60×128 | **9/20 (0.45)** | 0/20 | restored best snapshot |
| train_float_rup R-upsample | 0/20 | 0/20 | F-copy signal lost |

Best snapshot F-queries: hose/drum/vent exact; bolt→`bllt`. R-queries `ccc*`.
Unrelated hall_float=1.0. evid_has=0 still `n,o,EOS`.

Replay `train_finetune.py` phase A reproduced **9/20** at ep 16; `snap_best.npz` saved.
Copy-safe restore kept that snapshot. Balanced F/R hill-climb and R-only fine-tune:
R stayed **0/8**, F stayed 9. Opcode-in-Q (`train_q0.py`) held **0/20**.

Slot-aux from scratch: peak 6/20 (F/R oscillate, never both). D=64 balanced: **R=8/8 F=0** at ep 13. D=32 R-only: **R=8/8** TF=1.0 by ep 2 (`snap_r32.npz`). D=32 F-snap remains 9/12. One checkpoint does not hold both modes. Complementary specialists exist; letter still needs **one** 18/20 generator.

PCGrad from F-snap with F-protect: **F=12/12** including bolt (`snap_pcg_fprotect.npz`), held 12/20, R still 0 (`ccce`). Tiny R add-on did not introduce Reverse copies. From-scratch PCGrad collapsed to R=8 F=0. One checkpoint still cannot serve both slots.

## Classes

MISS: lang_90 (need 18/20), lang_hall5, lang_90_int.
FACT: first held-out **name copy** on this split (float only, F-slot).

REVIEW_PENDING. self_accept=false.
