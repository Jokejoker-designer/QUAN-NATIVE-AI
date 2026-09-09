# PREREG — SGD v1 weight persist (DESIGN product 6)

```text
PROGRAM=NO
```

Instance A: x[0]=64, go_upd reward=+3, snapshot w_o.
Instance B: reset, load snapshot, go_score same x. v_B must equal v_A after load (not equal to fresh-zero score).
