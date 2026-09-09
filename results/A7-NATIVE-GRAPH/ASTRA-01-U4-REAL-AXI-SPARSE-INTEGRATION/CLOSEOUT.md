# CLOSEOUT — ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION

```text
GATE                 = ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION
HEAD                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
LAST_PASS            = ASTRA-00
RTL_EDIT             = YES (new wrapper only)
FILES_CHANGED        = rtl/native_graph/integrate/a7ng_query_axi_sparse.sv
                       results/.../ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION/*
QUERY_LAW            = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW         = U4A-R6 bind-state; NOT (key != 0)
N_TABLES             = 4
N_BUCKETS            = 4096
CAND_CAP             = 64
EXTRACTOR_WIRE       = YES
BIT_BUILD            = NO
PROGRAM              = NO
GATE14_PASS          = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
U4A-R4/R5/R6         = NOT REDONE
SCHEMA_V2            = NOT REDONE
RESULT               = PASS
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
```

Claim only:

> Raw FPGA query processing (token stream → QSE packet → valid-gate)
> drives the exact 4×4096 AXI sparse directory/posting path in RTL and
> reproduces independent host-golden candidate identities.

Not claimed: 800k semantic retrieval, role parse, board PASS.
