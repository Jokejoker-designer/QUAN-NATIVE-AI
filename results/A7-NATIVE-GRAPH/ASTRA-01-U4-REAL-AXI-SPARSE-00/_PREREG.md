# ASTRA-01 prereg — U4 real AXI sparse (QSE → 4×4096 directory)

```text
GATE            = ASTRA-01-U4-REAL-AXI-SPARSE-00
PARENT          = ASTRA_GROK_PARENT
BASE            = ASTRA-00 PASS (HEAD 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1)
QUERY_LAW       = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW    = U4A-R6 bind-state bits; NOT (key != 0)
GEOMETRY        = U4-PRE0 P4_4k_h64
N_TABLES        = 4
N_BUCKETS       = 4096
BUCKET_W        = 12
HEAD_CAP        = 64
CAND_CAP        = 64
ENTRY_BYTES     = 16
TABLE_BYTES     = 65536
INDEX_BASE      = 0x05000000
POST_HEAP       = 0x05040000
RTL_WALKER      = rtl/native_graph/memory/a7ng_sparse_dir_axi.sv  (UNCHANGED)
RTL_QSE         = rtl/native_graph/query/a7ng_query_struct_extract.sv  (UNCHANGED)
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
JTAG            = 210319BE776EA UNTOUCHED
U4A_R4_R5_R6    = DO_NOT_REDO
SCHEMA_V2_LOW16 = DO_NOT_REDO
U4_SEMANTIC     = NO
U5_800K         = NO (ASTRA-02)
GATE14_PASS     = NO
```

## Primary unknown

Can raw FPGA query processing (U3Q extractor) drive the exact 4×4096 AXI
directory and reproduce independent host-golden candidate IDs?

No host semantic help: host does not compute bucket, candidate, winner,
address, or next-token for the DUT. Host golden is an independent twin of
the published law, generated before XSim, then frozen into `query_gold.svh`.

## Required path

```text
raw UART-style bytes
 → a7ng_query_struct_extract  (packet + k0..k3 + k*_valid)
 → live wire into a7ng_sparse_dir_axi  (no TB-computed keys on QSE queries)
 → valid-table AXI directory lookup  (dir_addr = BASE + t*65536 + k[11:0]*16)
 → posting fetch
 → pre-dedup ID stream
 → exact dedup + CAND_CAP bound
 → candidate stream
```

QSE `k*_o` / `k*_valid_o` combinationally drive walker `k*_i` / `k*_valid_i`
for every QSE-mode query. Protocol poke vectors are labeled POKE and are not
claimed as query-processing.

## Independent host golden (before XSim)

Reuse law from U3Q twin + U4A-R6 validity + U4-PRE0 address formula.
Cross-check corpus keys/valid/candidate IDs against frozen
`U4A-R6-ROUTE-VALIDITY-00/METRICS.json`. Divergence vs R6 is FIRST_DIVERGENCE
on the host side (do not silently retune).

Do not treat U4-MEM02 `GOLDEN.json` as this gate's authority; regenerate here.

## Cuts (stop at first divergence)

| Cut | Compare |
|-----|---------|
| A | query packet (entity/intent/relation/context IDs) |
| B | valid bits k0..k3_valid |
| C | keys k0..k3 |
| D | directory AXI AR addresses |
| E | posting AXI AR addresses |
| F | pre-dedup posting IDs (RDATA lanes) |
| G | post-dedup candidate IDs + n_dup |
| H | bounded stream: emit ≤ 64, n_trunc, no full scan |

Also: n_host_* = 0; unknown query dir_ar=0 emit=0; valid=1 key=0 probes bucket 0;
valid=0 key≠0 does not probe; CAND_CAP 80→64+16 trunc.

## Not claimed

800k semantic quality, P4 production freeze, role-aware parse, 2-hop,
reward learning, LM language, board, BIT, PROGRAM, GATE14.

## Forbidden this gate

- Write `D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00`
- git worktree add
- program COM12 / JTAG 210319BE776EA
- redo U4A-R4/R5/R6 or schemaV2 low-16 patches
- change qse keys / validity law / synthetic XOR table keys
- call this U4 semantic PASS or ASTRA-02
