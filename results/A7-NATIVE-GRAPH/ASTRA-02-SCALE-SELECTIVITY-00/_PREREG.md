# ASTRA-02 prereg — 800k scale / selectivity with independent gold

Written **before** host execution. Thresholds are not retargeted after seeing numbers.

```text
GATE            = ASTRA-02-SCALE-SELECTIVITY-00
PARENT          = ASTRA_GROK_PARENT
BASE            = ASTRA-01 HOST_XSIM_PASS (HEAD 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1)
QUERY_LAW       = qse-v1-lexicon-hdc-00  KEY VALUES UNCHANGED
VALIDITY_LAW    = U4A-R6 bind-state bits; NOT (key != 0)
GEOMETRY        = U4-PRE0 P4_4k_h64
N_TABLES        = 4
N_BUCKETS       = 4096
BUCKET_W        = 12
HEAD_CAP        = 64
PAGE_CAP        = 64
CAND_CAP_SWEEP  = 64,128,256,512,1024
ENTRY_BYTES     = 16
TABLE_BYTES     = 65536
INDEX_BASE      = 0x05000000
POST_HEAP       = 0x05040000
BYTE_BUDGET     = 32768
ID_W            = 20
SENTINEL_ID     = 799999
RTL_WALKER      = rtl/native_graph/memory/a7ng_sparse_dir_axi.sv  (UNCHANGED this gate)
RTL_QSE         = rtl/native_graph/query/a7ng_query_struct_extract.sv  (UNCHANGED)
EVIDENCE_CLASS  = HOST_MODEL (independent gold). XSim 800k = NOT_RUN
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
JTAG            = 210319BE776EA UNTOUCHED
U4A_R4_R5_R6    = DO_NOT_REDO
SCHEMA_V2_LOW16 = DO_NOT_REDO
U4_SEMANTIC     = NO
OCCUPANCY_AS_SEMANTIC = FORBIDDEN
K2K3_FROM_NID   = FORBIDDEN
CAP_GE_N_SELECTIVITY  = FORBIDDEN
GATE14_PASS     = NO
```

## Primary unknown

On actual QSE keys + U4A-R6 valid masks, with an index that stores **every
valid record** (overflow pages included), what are recall, precision,
candidate reduction, bytes/query (including fetch-then-drop/dedup), overflow,
bucket skew, posting lengths, dedup, and latency at

```text
N = 256, 4096, 16384, 65536, 262144, 800000
```

Does any **selected** profile (not only a reference row) meet all prereg
thresholds at N≥4096 with `CAND_CAP < N`? If 800k does not fit this turn,
report honest max N. Do not fabricate 800k.

## Independent gold (authority for quality)

Gold relevant IDs are assigned by the **generator labels**, before hashing:

| Query class | Gold relevant set |
|-------------|-------------------|
| known_domain | `label.entity == q.entity` |
| paraphrase / entity_context | `entity == q.entity AND context == q.context` |
| same_entity_diff_intent | `entity == q.entity AND intent == q.intent` |
| role_fwd / role_rev | `subject, relation, object` exact triple |
| unrelated | empty |

Keys used for indexing/routing come only from `twin.extract` (QSE law).
Never `k2 = nid & 0xffff`, never `k3 = (nid >> 4) & 0xffff`.
Occupancy/coverage is archived and labeled **NOT_SEMANTIC**.

R6 freeze (42-title HVAC corpus, not the scale mix): `water chiller` emit
count remains 22/42 under P4_4k_h64 CAND_CAP=64. Divergence is
FIRST_DIVERGENCE; do not retune.

## Index law this gate (`astra02-ovf-page-v1`, HOST)

Every record with at least one valid bit is stored in every valid table's
posting chain. Head page holds ≤64 IDs. Further IDs go to linked overflow
pages (PAGE_CAP=64). Coverage of valid records in the FULL index must be
1.00 or the index is FAIL.

Current RTL walker (`a7ng_sparse_dir_axi`) reads the directory, fetches the
**head** posting, sets `q_overflow_o` from bit 48, and does **not** follow
overflow pages. Two walk modes are therefore measured:

| Mode | Walk | Key check | Byte model |
|------|------|-----------|------------|
| `rtl_head_union` | head only | bucket 12-bit (RTL) | AXI dir 16B + ceil(n_head/4)*16 including dropped/dedup |
| `full_ovf_union` | overflow chain | bucket 12-bit | + 16B page header per overflow page |
| `full_ovf_union_keychk` | overflow chain | full 16-bit key after fetch | collisions = fetch-then-drop, still in bytes |
| `full_ovf_intersect_keychk` | rarest list, host set ∩ | full 16-bit key | AXI bytes for rarest+dirs only; ∩ is HOST_SET, not AXI-claimed |

If budget or cap cuts a posting: **SEARCH_INCOMPLETE**, never fake
**NO_EVIDENCE**. NO_EVIDENCE is only for: no table probed (all valid=0) or
all probed postings empty with no unread overflow.

## Thresholds (proposed; freeze only if ALL hold)

From DESIGN_CANDIDATE §9. Applied to the **selected** profile, N≥4096,
`CAND_CAP < N`. Not applied to N=256 with cap≥256.

| Metric | Pass if |
|--------|---------|
| evidence recall@cap (known_domain + intent + role, COMPLETE queries) | ≥ 0.95 |
| candidate reduction `1 - n_emit/N` | ≥ 0.90 |
| unrelated rejection (`n_emit==0`) | ≥ 0.95 of unrelated queries |
| FULL index coverage of valid records | = 1.00 |
| ID 799999 stored untruncated when N=800000 | yes |
| nid and nid+65536 distinct in postings when N>65536 | yes |
| SEARCH_INCOMPLETE ≠ NO_EVIDENCE | telemetry distinct |
| role_fwd emit set ≠ role_rev emit set | required for role-aware claim; **current QSE law is expected to FAIL this** — report as class, do not retune keys |

P4 production freeze this gate only if every row above passes for the
selected (mode, cap). Otherwise **NO_PROFILE_FREEZE**.

## Query set (frozen)

```text
known_domain              chiller
known_domain              pump
paraphrase                water chiller
entity_context_distractor water chiller   gold = chiller AND context=water
same_entity_diff_intent   leak chiller
same_entity_diff_intent   install chiller
role_fwd                  chiller pipe pump
role_rev                  pump pipe chiller
role_audit_fwd            chiller supplies pump
role_audit_rev            pump supplies chiller
unrelated                 payroll tax form
unrelated                 soccer match score
unrelated                 <ADV_SEED lexicon adversarial>
```

Include per-class precision/reduction. Entity-context distractors exist in
the corpus (`air`/`dx`/`chilled` + same entity).

## Bytes / candidates archive

Bytes/query = directory beats + overflow headers + posting beats actually
read, **including** IDs later dropped as duplicate, truncated, or failed
full-key check. Forbidden substitute: `16 * n_emit`.

Latency: host wall-ms (not FPGA) plus estimated AXI beats at 10 ns
(not a silicon claim).

## Not claimed even if HOST numbers look strong

Board, MIG, BIT, PROGRAM, GATE14, U4 semantic PASS, P4 production freeze
without all-criteria pass, occupancy semantic recall, 800k XSim, role-aware
parse (ASTRA-03), 2-hop (ASTRA-04).

## Forbidden this gate

- Write `D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00`
- git worktree add
- program COM12 / JTAG 210319BE776EA
- redo U4A-R4/R5/R6 or schemaV2 low-16 patches
- rebuild k2/k3 from nid
- call occupancy semantic recall
- use cap ≥ dataset size as sparse-selectivity proof
- change qse keys / validity law
- fake 800k if it does not run
