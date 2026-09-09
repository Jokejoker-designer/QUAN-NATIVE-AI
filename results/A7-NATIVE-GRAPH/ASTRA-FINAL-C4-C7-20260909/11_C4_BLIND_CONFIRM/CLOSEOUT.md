# CLOSEOUT — G02 Stage 2 WO360 Confirm v3

```text
GATE                 G02 new blind C4 confirmation
BASE_COMMIT          5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TREE_STATUS          DIRTY_PRESERVED
CONFIRM_SHA          f876633e6daf4ca79317bec55ef9888e12ff726e26d316ad87193eaba74b3e6a
CHECKPOINT           a462dd69d80ea5a2bf07d8d01359d0c01219919643e50204425ca4032320c4ed
OPENED_ONCE          true
USED_FOR_SELECTION   false
CONFIRM_V1_FOR_PASS  false
CONFIRM_V2_FOR_PASS  false
LEARNED_F            120/120
LEARNED_R            120/120
LEARNED_OVERALL      240/240 = 1.0
FLOAT_INT_SEQ        360/360
TERMINATION          1.0
LEARNED_U_HALL_PROXY 1.0  (ungated LM copies facts on unsupported; NOT a refusal claim)
SYSTEM_SAFE          120/120 by contracted S_SAFE n→o→EOS (not silicon, not learned)
RESULT               G02_LEARNED_FR_PASS; C4_MASTER still OPEN (no RTL/ablation/materializer/OOC)
PROGRAM              NO
BOARD_PASS           OPEN
NEXT                 G03 causal ablations; G04 D32 RTL bit-exact
```

FACT: learned unsupported hallucination proxy is 1.0. That is why C3 non-ANSWER must be hardware S_SAFE. Do not claim the LM learned refusal.
