# PREREG — ASTRA-01 U4-REAL-AXI-SPARSE-INTEGRATION

```text
GATE            = ASTRA-01-U4-REAL-AXI-SPARSE-INTEGRATION
PARENT          = ASTRA_GROK_PARENT
CWD             = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
BRANCH          = grok-orch/astra-native-v1-00
HEAD            = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
LAST_PASS       = ASTRA-00
QUERY_LAW       = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW    = U4A-R6 bind-state via a7ng_route_valid_gate; NOT (key != 0)
N_TABLES        = 4
N_BUCKETS       = 4096
BUCKET_W        = 12
CAND_CAP        = 64
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
U4A-R4/R5/R6    = DO NOT REDO
SCHEMA_V2       = DO NOT REDO
U5 / ASTRA-02   = CLOSED this gate
GATE14_PASS     = NO
```

## Primary unknown

Can **raw FPGA query processing** (token stream → QSE packet) drive the exact
4×4096 AXI directory/posting walker **inside RTL** and reproduce independent
host-golden candidate IDs?

U4-PRE0 proved geometry. U4-MEM02 proved walker vs golden with
`EXTRACTOR_WIRE=NO` (TB copied keys). This gate closes the extractor wire.

## Required path (FPGA-owned)

```text
raw query bytes
→ a7ng_query_struct_extract
→ query packet {eid,iid,rid,xid,k0..k3,k*_valid}
→ a7ng_route_valid_gate (probe = valid, never key!=0)
→ a7ng_sparse_dir_axi 4×4096
→ AXI directory lookup
→ posting fetch
→ union/dedup
→ CAND_CAP bounded stream
```

Host may: tokenize bytes, load DDR image, log, compare gold.
Host must not: subject/object/relation/intent/cue/bucket/candidates/winner/address.

## Cuts (stop at first divergence)

| Cut | Compare |
|-----|---------|
| A | query packet IDs + keys + valid bits vs host twin |
| B | directory AR addresses vs host golden |
| C | posting AR addresses vs host golden |
| D | pre-dedup IDs from posting beats vs host golden |
| E | post-dedup emit IDs vs host golden |
| F | bounded stream: emit ≤ 64, trunc, overflow drain, backpressure hold |

Also: invalid table not probed; valid=1,key=0 still probes; unknown → 0 dir AR
and 0 candidates; no hidden full scan; n_host_* = 0.

## Not this gate

800k semantic quality, role-aware parse, 2-hop, board program, Gate14 PASS.
Do not change qse keys. Do not reopen U4A law.
