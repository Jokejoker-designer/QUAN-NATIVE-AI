# CLOSEOUT — ASTRA-C4-COND-RNN-H16-01

PROGRAM=NO. Python integer-STE probe of rival-1 family with untied full-H
readout. No XSim DUT (held-out language did not reach the compile bar).
Does **not** stamp C4_MASTER. `LM06_BYTE256` NOT_FROZEN. No WO0550.

## Command

```text
python results\A7-NATIVE-GRAPH\ASTRA-C4-COND-RNN-H16-01\train_h16.py
exit=0
```

## Raw

Same packed 16-byte QUERY/PROOF split as `ASTRA-C4-COND-RNN-LANG-01`
(train pump/valv/tank/pipe, held-out hose/drum/vent/bolt).

| Width | Params | Train grounded | Held grounded |
|---|---|---|---|
| H=16 untied Wo | 5712 | 0.125 peak 0.208 | **0/20** |
| H=32 untied Wo | 10656 | 0.083 peak 0.250 | **0/20** |

Greedy emits `no` / train-entity `pipe`/`pump`, not held-out names.
`evid_has=0` still `n,o,EOS` in the Python replica of the safety gate.

## Corrective

Local CE+int8 STE on compact Elman does not generalize entity-disjoint
copy in this budget. Next letter-aligned options: authorized larger
local train/compute, or a copy-attention readout (that would be a new
architecture, not done here). Do not rewrite §10 into a renderer.

REVIEW_PENDING. self_accept=false.
