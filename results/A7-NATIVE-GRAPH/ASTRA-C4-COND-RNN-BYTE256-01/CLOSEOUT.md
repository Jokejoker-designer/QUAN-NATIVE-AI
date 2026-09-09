# CLOSEOUT — ASTRA-C4-COND-RNN-BYTE256-01

PROGRAM=NO. Named `a7ng_astra_c4_cond_rnn` SHA
`467b0a4b55c913e335eb3718d2ddcb83501faa800245b5d31fa1d1ccf4f78f8b`.
grounded_gen KEEP still `1fbdc00a…`. live prod_top still `c4fcca30…`.
Hex `46b81cd7…` (synthetic LCG seed=7, N_W=1384 int8, no cloud train).
Does **not** stamp C4_MASTER. Language 90/95/5 **MISS**.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C4-COND-RNN-BYTE256-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `023f8b3db59cf8ca3aa111d94c1533945b4208b5a3e2bb01fd52b5233b116fca` (hashed before first xvlog, not regenerated)
- First xvlog/xelab/xsim PASS. RTL matched integer reference (`CLASS_ref_match`).
- `$finish` 340945 ns
- Marker `ASTRA_C4_COND_RNN_BYTE256_XSIM_PASS`
- Prefix seed 0 vs `0x79`: tok2 84 vs 109. Context `valve requires pump` vs `pump requires valve`: tok0 201 vs 247. Safe `n,o,EOS`. Zero weights tok0=0 n=1. evid n_out=6 host=0. First-query n_mac=8256.

## Classes HIT

prefix_changes, evidence_changes, safe_no, seq_ge3, zero_changes, host_tok0, ref_match.

## Classes MISS (letter)

lang_90, lang_safe95, lang_hall5 — synthetic Elman, not a held-out QUERY/PROOF corpus.

Resource formula (not synth): 1384 int8 params; ~1124 MAC/token plus context encode. 0 BRAM assumed distributed.

Rival 2 (`reduced_lm06_compatible`) remains unmeasured. C4_MASTER=OPEN.

REVIEW_PENDING. self_accept=false.
