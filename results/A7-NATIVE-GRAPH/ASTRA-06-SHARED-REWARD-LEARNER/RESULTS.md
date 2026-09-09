# RESULTS — ASTRA-06 SHARED-REWARD-LEARNER

```text
GATE     = ASTRA-06-SHARED-REWARD-LEARNER
LAW      = native-rank-sgd-q8-v1
XSIM     = ASTRA06_SGD_XSIM_PASS
RESULT   = PASS_NARROW (unit 32-feature SGD, not held-out worlds)
SEED     = x[i]=64, 16 updates, SHIFT=6
BIT      = NO
PROGRAM  = NO
COM12    = UNTOUCHED
```

| Control | v_q8 |
|---------|-----:|
| frozen / zero-weight | 0 |
| enabled reward=+3 | 688 |
| shuffled +3/-3 | 48 |

Enabled beats frozen and shuffled. Not claimed: ASTRA-07 held-out transfer, retrieval hiding, board.
