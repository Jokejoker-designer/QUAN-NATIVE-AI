# DECISIONS — ASTRA-C4-CONDITIONAL-GEN-FEASIBILITY-01

PROGRAM=NO. Proposal + measured falsifiers. **Not** C4_MASTER. Playbook A is a
candidate engineering plan, not RTL that already PASSed.

## Ownership

This bag writes only `results/A7-NATIVE-GRAPH/ASTRA-C4-CONDITIONAL-GEN-FEASIBILITY-01/`.
Does not touch C5 rew/ckpt files.

## Already measured (do not re-close C4)

FACT. `ASTRA-C4-BIAS-LOAD-DEAD-01`: `A7NG_C4G_V[5:0]=0`, bias idx 1 and 63
rejected, tok0=0. Unedited `grounded_gen` hash `1fbdc00a…`.

FACT. `score_at` ignores prefix/`last_tok` for ranking (`cand_sc` constant 100).
`x_rel` latched unused. Output is object class ID, not BYTE256 language.

## Two rivals (rival 1 measured, not C4 winner)

1. Compact conditional recurrent decoder: **measured** in
   `ASTRA-C4-COND-RNN-BYTE256-01` (integer Elman BYTE256, prefix and evidence
   both change the sequence; language 90/95/5 MISS).
2. Reduced LM06-compatible core: **measured** in
   `ASTRA-C4-LM06-RED-BYTE256-01` (tied-embed decoder-only BYTE256, not
   TinyGPT-802k; prefix and evidence both change the sequence; language
   90/95/5 MISS).

Neither rival hits letter 90/95/5. Gap is dataset/compute/checkpoint, not a
missing third architecture search. Do not rewrite Master §10 into a renderer.

1. Compact conditional recurrent decoder: byte256 embed, small H, sequential MAC,
   context state consumed in every token score (Playbook A2).
2. Reduced LM06-compatible core with measured BRAM/DSP, not TinyGPT-802k.

Do not train until dataset/compute/checkpoint hashes exist. No cloud download.

## Token law (not frozen)

BYTE256 **or** bounded vocab + exact dictionary. V=64 class-ID is not BYTE256.

## If none reach 90/95/5 on held-out language

Report claim/resource/quality gap. Do not rewrite Master §10 into a renderer.
Do not execute WO0550.
