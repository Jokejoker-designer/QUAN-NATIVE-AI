# CLOSEOUT — ASTRA-03-ROLE-AWARE-QUERY

```text
GATE                 = ASTRA-03-ROLE-AWARE-QUERY
BASE                 = ASTRA-02 PASS_NARROW
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = rtl/native_graph/query/a7ng_query_role_extract.sv
                       rtl/native_graph/query/qse_role_lexicon.svh
                       rtl/native_graph/query/role_lexicon.py
                       rtl/native_graph/query/twin_role.py
                       rtl/native_graph/query/gen_role_lexicon.py
                       rtl/native_graph/integrate/a7ng_query_axi_sparse.sv (LAW_SEL default 0)
                       rtl/native_graph/control/a7ng_gate14_crc.svh (include guard only)
                       results/A7-NATIVE-GRAPH/ASTRA-03-ROLE-AWARE-QUERY/*
RTL_EDIT             = YES (new v2 module + LAW_SEL; v1 extractor/lexicon UNCHANGED)
PRIMARY_UNKNOWN      = Can the parser preserve ordered semantic roles?
RESULT               = PASS
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
VIOLATED_INVARIANT   = none
FALSIFIED_ALTERNATIVES = bag-of-lexicon min-ID (v1 control still collapses);
                         exam-sentence ROM (words are separate lexicon entries);
                         silent retarget of qse-v1 keys (v1 smoke PASS)
RESOURCE_DELTA       = not measured this gate (ASTRA-10)
QUERY_LAW            = qse-v2-role-00
QUERY_LAW_CONTROL    = qse-v1-lexicon-hdc-00 UNCHANGED
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
NEXT                 = ASTRA-04 RELATION-ENGINE-2HOP
```

v1 SHA a7ng_query_struct_extract.sv = EDE064F0C2A5C956EEBA5269F539690DBD63C0773B9DED11128BD9BE05496768
v1 SHA qse_lexicon.svh = 420C04B9DFB649A0569AF25024A08C44F59D7598F2F2A3F1AE13C68B349C5CF7
closed 2026-09-05T19:57:46.156281+07:00
