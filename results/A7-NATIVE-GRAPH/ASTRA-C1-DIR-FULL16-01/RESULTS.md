# RESULTS — ASTRA-C1-DIR-FULL16-01

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK /
`FULL16_HIT` / `FULL16_NO_12BIT_COLLISION` / `ALIAS12_WOULD_COLLIDE` /
`DIR16_AR_HIGH_NIBBLE` / `ASTRA_C1_DIR_FULL16_XSIM_PASS`. This file does not
promote C1 800k, N=16384, `CAND_CAP_FINAL`, `DDR_QUERY_BOUND_FINAL`,
page-skip, context keys, or BOARD_PASS.

```text
GATE             = ASTRA-C1-DIR-FULL16-01
N                = 256
N_BUCKETS        = 65536  (16-bit exact; bucket = key[15:0])
CAND_CAP         = 16   (< 256; emit budget after AND; not CAND_CAP_FINAL)
LAW              = qse-v2-stream-intersect-02
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
RELBIND_KEYS     = instantiated not edited (93811ed1…); k2={rel,cue[7:0]} k3={rel,cue[7:0]}
WALKER           = STREAM-02 DUT 14f75db7… instantiated .N_BUCKETS(65536); not edited
                   sorted-nid two-pointer AND; 1-beat page (arlen=0); rare-list-first;
                   CAND_CAP after emit; SEARCH_INCOMPLETE on budget exhaust
DIR              = frozen a7ng_sparse_dir_axi 09334e42… instantiated N_BUCKETS=65536;
                   C0 file unedited (mtime 2026-09-05 19:31:03)
k0,k1            = {subj,rel}/{obj,rel}
k2,k3            = relbind (indexed, not unioned)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_stream_intersect, tb_astra_c1_dir_full16)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
                   a7ng_query_axi_sparse_intersect.sv NOT compiled as DUT (KEEP)
                   a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (12:44:33, before first xvlog 12:44:47)
GOLD_LIVE        = MATCH 2f6ab31e… / 89a46315… / afc0f56c…  (not rewritten after xsim)
FAIL_R0          = not written (PASS session; no ALIAS_12BIT_COLLISION_EMIT;
                   no DISTRACTOR_LEAK; no SEARCH_INCOMPLETE)
XSIM_MARKER      = ASTRA_C1_DIR_FULL16_XSIM_PASS emitted
SIM_TIME         = 19325 ns
PID              = 59148
SESSION          = Mon Sep 7 12:44:51–12:44:55 2026
XSIM_SHA         = 55b5e527744af5dc0520ea20305bf8ae11b805b1b1cb641eb3cbd4932de9cc17
MEM_DEPTH        = 272384 (TB-only; 4*65536*16 directory + postings)
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_16384          = NOT this bag
CAND_CAP_FINAL   = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
BOARD_PASS       = NOT_CLAIMED
RESULT           = PASS_THIS_GATE_ONLY
```

Prior bags were not edited:
- KEEP `ASTRA-C1-KEY-INTERSECT-01` GOLDEN 10:16:50 hash d3b5b883…
- KEEP `ASTRA-C1-N4096-INTERSECT-01` GOLDEN 10:46:42 hash 095ca715…
- KEEP `ASTRA-C1-STREAM-INTERSECT-02` GOLDEN 11:43:45 hash 05c6e087…
- KEEP `ASTRA-C1-N4096-STREAM-02` GOLDEN 12:10:22 hash 2a2db8c8…
- KEEP `ASTRA-C1-AXI-BEAT-ACCOUNTING-01` CLOSEOUT 11:11:09
- KEEP intersect DUT `a7ng_query_axi_sparse_intersect.sv` 10:13:02 hash a912786f…
- KEEP stream DUT `a7ng_query_axi_sparse_stream_intersect.sv` 11:43:39 hash 14f75db7…

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH /
FAIL ALIAS_12BIT_COLLISION_EMIT / FAIL DISTRACTOR_LEAK). Gold was **not**
regenerated after xsim.

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.
Relbind keys `93811ed1…`. KEEP intersect `a912786f…` not compiled as DUT.
STREAM-02 DUT `14f75db7…` instantiated, not edited.

Independent audit tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` was
not written (max mtime 10:52:29).

## Unknown (this bag)

`N_BUCKETS=65536` instantiate of frozen `a7ng_sparse_dir_axi` (do not patch
the `.sv`) + instantiate stream-02 walker SHA `14f75db7…` (do not edit) —
do 12-bit-alias entity pairs retrieve the intended nid only?

Alias pair (independent corpus, not RESULTS):

```text
low  nid=108  subj=10 pump   rel=1 obj=11 valve   k0=0x0A01=2561 k1=0x0B01=2817
high nid=221  subj=26 boiler rel=1 obj=27 header  k0=0x1A01=6657 k1=0x1B01=6913
k0 share bits[11:0]=2561; differ by 4096 (high nibble 0 vs 1)
k1 share bits[11:0]=2817; differ by 4096
12-bit AND would emit {108,221}
FULL16 AND of high query emits {221} only
```

Raw:

```text
FULL16_HIT id=221 k0=6657 k1=6913
FULL16_NO_12BIT_COLLISION low_alias_id=108 excluded_from_high_emit=1
ALIAS12_WOULD_COLLIDE k0_high=6657 k0_low=2561 share12=2561 low_id=108 high_id=221
DIR16_AR_HIGH_NIBBLE table0_key_ge_4096=1
CLASS_alias_high gold_n=1 emit_n=1 tp=1 id=221 incomp=0
CLASS_alias_low  gold_n=1 emit_n=1 tp=1 id=108 incomp=0
CLASS_direct     gold_n=3 emit_n=3 tp=3 {110,144,145} incomp=0
```

High-nibble query retrieve: **yes** (`FULL16_HIT id=221`; DUT issued a
table-0 directory AR with key ≥4096). 12-bit alias nid 108 is **absent**
from that emit. Low query still retrieves 108 and does not emit 221.
Direct control `{110,144,145}` remains.

SEARCH_INCOMPLETE was **not** used to hide a gold miss (`FAIL ` lines = 0;
`incomp=0` on alias_high, alias_low, and direct).

Gate requires FAIL=0 **and** alias-pair correct **and** no 12-bit collision
emit for `PASS_THIS_GATE_ONLY`. Therefore **RESULT=PASS_THIS_GATE_ONLY**.

This does **not** close C1 800k, N=16384, Master evidence-recall ≥95%,
candidate-reduction ≥90%, page-skip, context keys, `CAND_CAP_FINAL`, or
`DDR_QUERY_BOUND_FINAL`. TB include-path lexicon extension adds entity ids
26/27 so extract can emit keys with bits[15:12]≠0; C0 lexicon **file**
hash MATCH `38189974…` (mtime 2026-09-05 20:51:03). Frozen 12-entity HVAC
namespace is otherwise unchanged. Index is `axi_mem_model`, not MIG.

## CLASS table (raw xsim.log)

| class | gold_n | emit_n | tp | prec_all_x1000 | incomp | notes |
|---|---:|---:|---:|---:|---:|---|
| direct | 3 | 3 | 3 | 1000 | 0 | `{110,144,145}` |
| paraphrase | 3 | 3 | 3 | 1000 | 0 | |
| role_reversal | 1 | 1 | 1 | 1000 | 0 | 146 |
| wrong_relation | 1 | 1 | 1 | 1000 | 0 | 114 |
| wrong_context | 1 | 3 | 1 | 333 | 0 | NOT_SELECTIVE |
| distractor | 10 | 3 | 0 | 0 | 0 | leak_n=0 excluded |
| unrelated | 0 | 0 | 0 | — | 0 | UNRELATED_EMPTY_WALK |
| high_occupancy | 1 | 16 | 1 | 62 | 0 | |
| overflow_page | 1 | 5 | 1 | 200 | 0 | ovf=1 |
| high_id_sentinel | 1 | 1 | 1 | 1000 | 0 | 255 |
| late_gold | 1 | 1 | 1 | 1000 | 0 | 254 (supporting) |
| alias_high | 1 | 1 | 1 | 1000 | 0 | 221; no nid 108 |
| alias_low | 1 | 1 | 1 | 1000 | 0 | 108; no nid 221 |
