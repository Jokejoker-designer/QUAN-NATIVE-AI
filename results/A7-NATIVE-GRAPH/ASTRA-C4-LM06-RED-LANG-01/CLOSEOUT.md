# CLOSEOUT — ASTRA-C4-LM06-RED-LANG-01

PROGRAM=NO. Local integer STE on unedited rival-2 law (`D=4 F=8 N_W=1392`).
Does not overwrite `rtl/native_graph/integrate/a7ng_astra_c4_lm06_red.hex`
(`74b5f885…`). No TinyGPT. No cloud. Does **not** stamp C4_MASTER.

## Command

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-RED-LANG-01\train_red.py
exit=0
```

## Raw

Same packed 16-byte QUERY/PROOF split as LANG-01 / H16 probe.
Train grounded **0**. Held-out grounded **0/20**. Greedy is EOS-only.
`evid_has=0` replica still `n,o,EOS`.

Bag-local hex SHA `6d79a111405fd6ab629b1fc69b35d35b792f1b749bd3041d584fffb6aae8a5c5`
is not a letter checkpoint. No XSim DUT (did not meet the compile bar).

## Both rivals, trained

| Candidate | Train grounded | Held 90/95/5 |
|---|---|---|
| Elman BYTE256 (causal + LANG + H16/H32 STE) | ≤0.25 | **MISS 0/20** |
| Reduced LM06-compatible STE | 0 | **MISS 0/20** |

C4_MASTER stays OPEN. No third architecture. No WO0550.

REVIEW_PENDING. self_accept=false.
