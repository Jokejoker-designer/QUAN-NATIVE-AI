# CLOSEOUT — ASTRA-C4-COND-RNN-LANG-01

PROGRAM=NO. Unedited rival-1 DUT `a7ng_astra_c4_cond_rnn` SHA
`467b0a4b55c913e335eb3718d2ddcb83501faa800245b5d31fa1d1ccf4f78f8b`.
Bag-local trained hex SHA
`e3a1bfb48b8e7eec8701021648e6bc5bd834f9ab81fc9da465ed5c61f6d99c4c`.
Rival-1 causality hex `46b81cd7…` unedited. grounded_gen KEEP `1fbdc00a…`.
Does **not** stamp C4_MASTER. `LM06_BYTE256` NOT_FROZEN.

## Command

```text
powershell -NoProfile -ExecutionPolicy Bypass -File results\A7-NATIVE-GRAPH\ASTRA-C4-COND-RNN-LANG-01\run_xsim.ps1
exit=0
```

## Raw

- GOLDEN.json SHA256 `985d4d4630edb7a39ae0a0d268e00318580a30ca420978602e23fda99a92fdea` (hashed before first xvlog)
- `$finish` 3287035 ns
- Marker `ASTRA_C4_COND_RNN_LANG_XSIM_PASS` (measurement complete, not letter HIT)
- Held-out entities hose/drum/vent/bolt disjoint from train pump/valv/tank/pipe
- Grounded **0/20** (outputs `aaaaaa` / `oooooo`, not entity names)
- evid_has=0 safe **20/20** (`n,o,EOS` hardware gate)
- Unrelated evid_has=1 hall **12/12**
- Host next-token **0**

## Classes

HIT: safe_no, host_tok0, lang_safe95 (evid_has=0 gate).
MISS: lang_90, lang_hall5.

## Corrective hypothesis (one)

Tied BYTE256 Elman E=4 H=8 (and a float H=32 probe) did not learn
slot-copy of 4-char proof entities under local CE+int8 in this budget.
Do not add a third architecture. Do not execute WO0550. Do not rewrite
§10 into a renderer. C4_MASTER stays OPEN until a checkpoint reaches
90/95/5 on this frozen split or a later registered corpus.

REVIEW_PENDING. self_accept=false.
