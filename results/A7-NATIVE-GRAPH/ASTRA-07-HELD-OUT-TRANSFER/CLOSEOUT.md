# CLOSEOUT — ASTRA-07-HELD-OUT-TRANSFER

```text
GATE                 = ASTRA-07-HELD-OUT-TRANSFER
BASE                 = ASTRA-06 PASS_NARROW
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = results/A7-NATIVE-GRAPH/ASTRA-07-HELD-OUT-TRANSFER/*
                       docs/ASTRA/LOOP_STATE.json
RTL_EDIT             = NO (reuse a7ng_shared_rank_sgd_q8.sv law native-rank-sgd-q8-v1)
PRIMARY_UNKNOWN      = Do trained shared 32-weights beat frozen and shuffled-reward on held-out worlds?
RESULT               = PASS
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
VIOLATED_INVARIANT   = none
FALSIFIED_ALTERNATIVES = train-x reused as test; ID one-hot in shared w; per-ID transfer;
                         missing-edge hallucinated ANSWER; ASTRA-06 constant-x claimed as transfer
RESOURCE_DELTA       = n/a (no synth)
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
NEXT                 = ASTRA-08 LM06-VOCAB-CHECKPOINT-AUDIT
```

closed 2026-09-05T20:38:47+0700
