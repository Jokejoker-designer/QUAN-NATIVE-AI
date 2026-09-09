# CLOSEOUT — ASTRA-01-U4-REAL-AXI-SPARSE-00

```text
GATE                 = ASTRA-01-U4-REAL-AXI-SPARSE-00
HEAD                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
RTL_EDIT             = NO
FILES_CHANGED        = results/A7-NATIVE-GRAPH/ASTRA-01-U4-REAL-AXI-SPARSE-00/*
                       docs/ASTRA/LOOP_STATE.json
QUERY_LAW            = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW         = U4A-R6 bind-state; NOT (key != 0)
N_TABLES             = 4
N_BUCKETS            = 4096
CAND_CAP             = 64
BIT_BUILD            = NO
PROGRAM              = NO
GATE14_PASS          = NO
COM12                = UNTOUCHED
V31_FOLDER           = UNTOUCHED
RESULT               = PASS (HOST+XSIM)
EVIDENCE_CLASS       = HOST_MODEL + XSIM (behavioral AXI mem, not MIG, not board)
FIRST_DIVERGENCE     = none
```

Claim only:

> Raw FPGA query-extractor packets drive the exact 4×4096 AXI sparse
> directory/posting path and reproduce independent host-golden candidate IDs.

Not claimed: 800k quality, P4 freeze, silicon, GATE14, BOARD_PASS.
