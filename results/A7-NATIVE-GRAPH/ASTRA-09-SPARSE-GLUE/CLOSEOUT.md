# CLOSEOUT — ASTRA-09-SPARSE-GLUE

```text
GATE                 = ASTRA-09-SPARSE-GLUE
BASE                 = ASTRA-09 PASS_NARROW (sparse AXI walker omitted)
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = rtl/native_graph/integrate/a7ng_query_axi_sparse.sv
                       (additive v2 ports + n_host_* ; LAW_SEL default 0)
                       rtl/native_graph/integrate/a7ng_astra09_pipe.sv
                       (QSE replaced by a7ng_query_axi_sparse LAW_SEL=1;
                        wait q_done before 2-hop; AXI master ports)
                       rtl/native_graph/integrate/a7ng_unified_pipe.sv
                       (comment only: sparse lives on astra09_pipe exam path)
                       results/A7-NATIVE-GRAPH/ASTRA-09-SPARSE-GLUE/*
                       docs/ASTRA/LOOP_STATE.json
RTL_EDIT             = YES (glue only; v1 QSE keys UNCHANGED; walker/2hop/SGD laws UNCHANGED)
PRIMARY_UNKNOWN      = Can one XSim path run raw bytes → qse-v2 LAW_SEL=1 → 4×4096 AXI walk → loaded-edge 2-hop → frozen rank with n_dir≤n_valid, n_host=0, reverse packets distinct, payroll UNKNOWN, A→C not stored?
RESULT               = PASS_NARROW
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
VIOLATED_INVARIANT   = none
FALSIFIED_ALTERNATIVES = synthetic production path / TB poke of q_s q_o winner / poke_v_i;
                         A→C stored as fact (1-hop UNKNOWN);
                         reverse pair same packet (k0 2561 vs 257);
                         payroll ANSWER or n_dir≠0;
                         walker 0..N scan (ndir=4=n_valid; payroll 0);
                         walker plant ID used as 2-hop answer
RESOURCE_DELTA       = n/a (no synth this glue; ASTRA-10 OOC top unchanged)
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
LM06_CLASS           = LANGUAGE_UNPROVEN
SPARSE_AXI           = wired_law_sel_1
V1_QSE_SHA           = ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768
NEXT                 = unblocked_item=NONE (do not skip to board)
```

closed 2026-09-05T21:21:00+07:00
