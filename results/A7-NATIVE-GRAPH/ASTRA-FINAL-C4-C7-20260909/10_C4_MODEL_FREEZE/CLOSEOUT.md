# CLOSEOUT — G01 Stage 1 C4 numerical freeze

```text
GATE                 G01 Stage 1 freeze C4 numerical + context law
BASE_COMMIT          5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
SOURCE_COMMIT        dirty tree preserved
TREE_STATUS          DIRTY_PRESERVED
FILES_CHANGED        10_C4_MODEL_FREEZE/* + generated svh path
PRIMARY_UNKNOWN      RTL/XSim token parity (G04/G13)
FIRST_DIVERGENCE     n/a
VIOLATED_INVARIANT   none
ACTUAL_COMMANDS      quantize_c4_parity.py F-copy ckpt; gen_numerical_contract.py
ACTUAL_EXIT_CODES    0
METRICS              historic PTQ FLOAT=20/20 INTEGER=20/20 PARITY=20/20; D=32 F=64
RESOURCE_DELTA       n/a
EVIDENCE_CLASS       FACT (generated from files)
RESULT               G01_CONTRACT_FROZEN
LIMITATIONS          Reverse 8ae46886 KEEP as development. Frozen product candidate is F-copy a462dd69 + this PTQ. Historic 20 is not blind. No RTL yet.
BIT_BUILD            NOT_RUN
PROGRAM              NO
NEXT                 G02 WO360 already locked; eval recorded in 11_C4_BLIND_CONFIRM
```

WO §6.1 named reverse as default authority. Confirm v1 failed after viewing; bounded F-copy repair is the frozen law per master goal. Reverse hex is not loaded into D32 RTL.
