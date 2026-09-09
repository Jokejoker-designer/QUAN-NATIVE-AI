# CLOSEOUT — ASTRA-05-CAUSAL-PROOF-PERTURBATION

```text
GATE                 = ASTRA-05-CAUSAL-PROOF-PERTURBATION
BASE                 = ASTRA-04 PASS_NARROW
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = rtl/native_graph/integrate/a7ng_rel_engine_2hop.sv
                       results/A7-NATIVE-GRAPH/ASTRA-04-RELATION-ENGINE-2HOP/tb_astra04_2hop.sv
                       results/A7-NATIVE-GRAPH/ASTRA-05-CAUSAL-PROOF-PERTURBATION/*
RTL_EDIT             = YES (sequential 2-hop + polarity + q_budget + q_max_hop + CONFLICT/INCOMPLETE)
PRIMARY_UNKNOWN      = Does corpus mutation change the derived answer?
RESULT               = PASS
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
VIOLATED_INVARIANT   = none
FALSIFIED_ALTERNATIVES = answer ROM / stored READ_A→CALIB_C (1-hop UNKNOWN);
                         delete keeps C;
                         replace leaves C;
                         contradiction mushed into ANSWER;
                         capped search reported as UNKNOWN
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
NEXT                 = ASTRA-06 SHARED-REWARD-LEARNER
```

closed 2026-09-05T20:18:41+07:00
