# CLOSEOUT — ASTRA-C4-LM06-RED-BYTE256-01

PROGRAM=NO. Named `a7ng_astra_c4_lm06_red` SHA
`b45773d309200675e375decc2570c4a55cbc6e90569632420a232c08686bee4b`.
grounded_gen KEEP still `1fbdc00a…`. TinyGPT-802k **not** compiled.
Hex `74b5f885…` (synthetic LCG seed=18, N_W=1392 int8, no cloud train).
Does **not** stamp C4_MASTER. Language 90/95/5 **MISS**.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-BYTE256-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN SHA256 `2997cfd154df53f18b41bb0399edf0dde1c9c433fe25e082a36ca5eaa4109afe` hashed before xvlog
- Marker `ASTRA_C4_LM06_RED_BYTE256_XSIM_PASS`
- `$finish` **434865 ns**
- Prefix seed 0 vs `0x79`: tok0 53 vs 206
- Context `valve requires pump` vs `pump requires valve`: tok1 53 vs 125
- Safe `n,o,EOS`. Zero weights tok0=0 n=1. First-query n_mac=10836. head10[9:8]=00

## Classes HIT

prefix_changes, evidence_changes, safe_no, seq_ge3, zero_changes, host_tok0, ref_match.

## Classes MISS (letter)

lang_90, lang_safe95, lang_hall5 — synthetic decoder, not QUERY/PROOF held-out corpus.

## Resource formula (not synth)

1392 int8 params (tied We 1024 + Wqkv 48 + FFN 64 + by 256). Sequential MAC, **0 BRAM / 0 DSP** assumed distributed. First-query 10836 MAC.

## Feasibility close of two rivals

| Rival | Causality | 90/95/5 | Params | First-query MAC |
|---|---|---|---|---|
| Elman BYTE256 | PASS | MISS | 1384 | 8256 |
| Reduced LM06-compatible | PASS | MISS | 1392 | 10836 |

Neither rival is a C4 letter winner. Do not rewrite Master §10 into a renderer. Do not execute WO0550.

REVIEW_PENDING. self_accept=false.
