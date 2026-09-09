# PREREG — ASTRA-06 SHARED-REWARD-LEARNER

```text
GATE        = ASTRA-06-SHARED-REWARD-LEARNER
LAW         = native-rank-sgd-q8-v1
FEATURES    = 32 shared (not per-ID prior as the only path)
BIT         = NO
PROGRAM     = NO
COM12       = UNTOUCHED
```

Required controls (DESIGN_CANDIDATE §5): enabled vs frozen vs shuffled-reward vs per-ID prior.
Do not let learning hide retrieval/reasoning defects. Seeds archived.
Held-out transfer is ASTRA-07.
