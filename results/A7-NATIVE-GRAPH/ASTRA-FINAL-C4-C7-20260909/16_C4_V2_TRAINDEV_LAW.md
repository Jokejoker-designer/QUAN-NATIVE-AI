# V2 TRAIN/DEV generation law

**PROGRAM=NO. C4_MASTER=OPEN.**  
**No Confirm V2 rows are instantiated in this file.**

Checkpoint selection uses TRAIN/DEV only. Blind Confirm V2 is hashed after the selected checkpoint is frozen.

## Architecture (fixed)

- D=32, F=64
- F and R attention banks, shared We/Pe/FFN/by
- Vocab 256 byte tokens
- W8/A12 integer family after float train
- No U bank, no extra hidden layer, no larger D, no target_slot, no pointer oracle

The only intended change vs F-copy V1 is the **context serialization / training distribution**.

## Context

`C4_CONTEXT_CONTRACT_V2` G06 minimal:

```text
{F|R} {src} {dst}>----
```

`src` and `dst` are disjoint 4-letter `[a-z]` names. PAD is always `----`.

## Labels (decoder law)

```text
group F → ans = dst
group R → ans = src
```

Materializer never sees `ans`.

## Sampling

- Character/position-balanced F+R batches, even batch size, half F half R.
- Exclude reserved names: historic V1 entities, confirm v1, reverse train/dev, F-copy train/dev, G06 probe names `drum,hose,vent,bolt,pump,tank,pipe,coil,gear,axle,vane,plug`.
- Do not train on Confirm V2 (it must not exist yet).
- Select `best_dev.npz` by min(F_dev, R_dev) on the V2 DEV split only.

## Confirm V2 (later)

Specification only until checkpoint freeze: 120 F + 120 R + 120 unsupported, V2 layout, hashed before the single open. Generator may exist as code with a guard that refuses to emit rows until `CHECKPOINT_FROZEN.json` is present.
