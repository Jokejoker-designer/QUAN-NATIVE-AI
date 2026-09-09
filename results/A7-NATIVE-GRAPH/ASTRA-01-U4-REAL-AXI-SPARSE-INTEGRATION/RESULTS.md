# RESULTS — ASTRA-01 U4-REAL-AXI-SPARSE-INTEGRATION

```text
GATE            = ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION
PASS            = YES
XSIM            = ASTRA01_AXI_SPARSE_PASS
HOST            = GOLDEN.json RESULT PASS (freeze vs U4A-R6 candidate_ids)
EXTRACTOR_WIRE  = YES (RTL a7ng_query_axi_sparse)
WALKER_SHA      = ab9a2a2582f316b3e610072165a80dc183e3a7b1a71a857b5c7acdd611e6a2c7
EXTRACTOR_SHA   = ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768
                 (unchanged vs U4-MEM02 / U4-PRE0)
FIRST_DIVERGENCE= none
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
V31_WRITES      = 0
```

## Path proven (XSim + independent host gold)

```text
raw query bytes
→ a7ng_query_struct_extract
→ packet {eid,iid,rid,xid,k0..k3,k*_valid}
→ a7ng_route_valid_gate (probe=valid, never key!=0)
→ a7ng_sparse_dir_axi 4×4096
→ AXI dir AR → posting AR → predup IDs → dedup emit ≤64
```

TB does **not** copy keys into the walker. Wrapper captures QSE outputs in RTL.

## Cuts A–F (13/13)

| Q | Stimulus | dir | post | predup | emit | dup | trunc | beats | bytes |
|---|----------|-----|------|--------|------|-----|-------|-------|-------|
| 0 | QSE chiller | 2 | 2 | 8 | 4 | 4 | 0 | 4 | 64 |
| 1 | QSE water chiller | 3 | 3 | 27 | 22 | 5 | 0 | 10 | 160 |
| 2 | QSE leak chiller | 3 | 1 | 4 | 4 | 0 | 0 | 4 | 64 |
| 3 | QSE payroll tax form | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 4 | QSE soccer match score | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 5 | QSE adversarial | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 6 | poke one table | 1 | 1 | 4 | 4 | 0 | 0 | 2 | 32 |
| 7 | poke valid=1,key=0 | 1 | 1 | 1 | 1 | 0 | 0 | 2 | 32 |
| 8 | poke empty posting | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 16 |
| 9 | poke CAND_CAP 80 | 1 | 1 | 80 | 64 | 0 | 16 | 21 | 336 |
| 10 | poke all valid=0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 11 | poke valid=0,key!=0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 12 | QSE chiller + backpressure | 2 | 2 | 8 | 4 | 4 | 0 | 4 | 64 |

Directory AR ≤ valid tables ≤ 4. No 0..N scan. Unknown → 0 candidates, 0 dir AR.
Q7: valid=1,key=0 still probes. Q9: emit=64 trunc=16, AXI drained. Q12: stall held presented beat.
n_host_any=0 on every query.

## Not claimed

800k semantic selectivity, P4 quality, role-aware parse, 2-hop, board, Gate14.
`water chiller` 22 candidates is identity-correct vs R6, not a precision PASS.
