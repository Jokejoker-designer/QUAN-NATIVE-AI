# RESULTS — ASTRA-09-SPARSE-GLUE

```text
GATE            = ASTRA-09-SPARSE-GLUE
HOST            = GOLDEN.json ASTRA09_SPARSE_HOST_COMPARE_PASS
XSIM            = ASTRA09_SPARSE_XSIM_PASS
RESULT          = PASS_NARROW (XSim glue, not board; language OPEN)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
EXAM_PAIR_STORED= false
N_HOST          = 0
LM06_CLASS      = LANGUAGE_UNPROVEN
SPARSE_AXI      = wired (LAW_SEL=1 qse-v2-role-00)
V1_QSE_SHA      = ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768 UNCHANGED
```

Path: UART-like bytes → `a7ng_query_axi_sparse` (`LAW_SEL=1` = `a7ng_query_role_extract`) → `a7ng_route_valid_gate` → `a7ng_sparse_dir_axi` 4×4096 on `a7ng_axi_mem_model` → `a7ng_rel_engine_2hop` (loaded edges) → `a7ng_shared_rank_sgd_q8` (`freeze_i=1`) → `a7ng_evidence_compose`.

TB does not drive engine `q_s`/`q_o`/`q_r` or `poke_v_i`. Walker plant IDs ≥ 201 are retrieval-only; 2-hop answers still come from loaded facts. A→C is not a stored fact.

| Case | Query | n_dir | n_emit | Expected | XSim |
|------|-------|------:|-------:|----------|------|
| C1_FWD | pump supplies chiller | 4 | 6 | packet k0=2561; 1-hop ANSWER | st=0 ans=1 p0=3 ndar=4 |
| C1_REV | chiller supplies pump | 4 | 3 | swapped k0=257; WRONGDIR | st=2 ans=0 ndar=4 |
| C1_NTRANS | pump supplies indirect condenser | 4 | 6 | two_hop=1 NTRANS | st=3 |
| C2_1HOP | pump requires chiller | 4 | 6 | ANSWER + proof | st=0 ans=1 p0=1 |
| C3_2HOP | pump requires indirect compressor | 4 | 6 | ANSWER C + two edge IDs | st=0 ans=4 p0=1 p1=2 |
| C3_NO_AC | pump requires compressor | 4 | 6 | UNKNOWN (A→C not stored) | st=1 |
| C4_UNREL | payroll tax form | 0 | 0 | UNKNOWN skip, no dir AR | st=1 skip=1 ndar=0 |
| C5_MISS | same 2-hop after DELETE B→C | 4 | 6 | UNKNOWN, not keep C | st=1 ans=0 |
| C6_REV1 | chiller requires pump | 4 | 3 | WRONGDIR, not keep chiller | st=2 ans=0 |
| C6_REV2 | compressor requires indirect pump | 4 | 3 | UNKNOWN, not keep pump | st=1 ans=0 |

v_q8=0 on all cases (zero weights, freeze). n_host_*=0. ntok=14 compact proof bytes (not language). Directory AR = n_valid ≤ 4; payroll 0 AR (no 0..N scan). Observed AXI dir addresses matched host-golden buckets only.

## Narrow claim

One connected XSim path now includes the sparse AXI walker: role packets still reverse-distinct, payroll emits 0/UNKNOWN, 2-hop still needs loaded edges (A→C not stored), n_host_*=0, walker directory AR ≤ valid tables.

## Not claimed

Gate14, board, NLU, fullchip, 800k DDR graph, LM language generation, bitstream, COM12.
