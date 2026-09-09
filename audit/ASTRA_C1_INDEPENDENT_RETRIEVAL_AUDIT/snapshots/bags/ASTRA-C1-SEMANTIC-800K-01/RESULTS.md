# RESULTS — ASTRA-C1-SEMANTIC-800K-01

Authority = raw `xsim.log` (SHA `7d0a52ac3a4c19ef8f3990b16294b52cc8d518a20f177058bd80954d6bc394d5`)
+ `GOLD_HASH_PRE_XVLOG.txt` + live Get-FileHash. PROGRAM=NO.

```text
RESULT               = PASS_THIS_GATE_ONLY
MARKER               = ASTRA_C1_SEMANTIC_800K_XSIM_PASS PRESENT
FAIL                 = 0
N                    = 800000
N_ADDRESSABLE        = 800000
N_BUCKETS            = 65536
CAND_CAP             = 16
PROC_MEM             = 1 (bag a7ng_axi_mem_proc_800k; C0 dense mem NOT compiled)
LAW                  = qse-v2-relctx-synonym-01
CTX_LAW              = qse-v2-intersect-context-02 (keys 124be808 instantiate, not edited)
LEX                  = qse-v2-lex-semantic-800k-01 (NEW named 023a6f81…)
EXTRACT              = qse-v2-role-00 frozen cd7baf49 unedited
POKE_V               = 0
LEFTOVER_A09         = not compiled
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT on PASS session
FAIL_R0              = PRESENT (xsim_fail_r0.log; dir-pack width in procedural mem;
                       gold NOT regenerated; TB-only fix then PASS)
HISTORICAL_U5        = cannot close this bag
```

## CLASS table (raw xsim.log)

| class | gold | emit | tp | fp_ev1 | rec_x1000 | notes |
|---|---|---|---|---|---|---|
| fill_template | {120,121,122} | {120,121,122} | 3 | 0 | 1000 | FILL_TEMPLATE_HIT occ=202 incomp=0 |
| nl_synonym | {120,121,122} | {120,121,122} | 3 | 0 | 1000 | NL_GOLD_HIT; frozen keys_match=0; syn keys_match=1; not nid 131 |
| high_id_sentinel | {799999} | {799999} | 1 | 0 | 1000 | HIGH_ID_HIT nid=799999; proves N=800000 addressable |
| unrelated | {} | {} | 0 | 0 | n/a | UNRELATED_EMPTY_WALK |

Raw named lines:

```text
C1_SEMANTIC_800K_N=800000 N_BUCKETS=65536 CAND_CAP=16 ... PROC_MEM=1 N_ADDRESSABLE=800000 N_SUBJECTS=201 N_RELS=20
FILL_TEMPLATE_HIT tp=3 emit_n=3
FROZEN_KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0 law=qse-v2-role-00
SYN_KEYS_VS_FILL class=nl_synonym k0=3332 k1=3588 vs_fill_template k0=3332 k1=3588 keys_match=1 law=qse-v2-relctx-synonym-01 syn_hit=1
NL_GOLD_HIT tp=3 emit_n=3 gold_n=3 keys_match_frozen=0 keys_match_syn=1
HIGH_ID_HIT nid=799999 emit_n=1 tp=1
CLASS_unrelated UNRELATED_EMPTY_WALK
N800K_SUMMARY fill_tp=3 nl_hit=1 high_hit=1 emit_has_131=0 incomp_retrieve=0 fail=0 G_N=800000
ASTRA_C1_SEMANTIC_800K_XSIM_PASS
NOT_CLAIMED=BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,MASTER_95,ACCEPT_BOARD
BOARD_PASS=NOT_CLAIMED PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN
```

## Unknown

N=800000 under `qse-v2-relctx-synonym-01` + ctx keys `124be808` + synonym DUT wrap.
Fill-template `"boiler feeds header"` HIT gold `{120,121,122}`. High-id sentinel
nid `799999` (`hatchway splits boiler`) HIT. `SEARCH_INCOMPLETE` absent on
retrieve classes. Not a 16k clone labeled 800k (201 subjects × 20 rels
procedural cartesian; sentinel only exists at N=800000).

## Gold-before-xvlog

```text
GOLD_HASH_PRE_XVLOG  20:42:01.101
SHA256.txt           20:44:42.818  (PASS session freeze)
xvlog.log            20:44:43.914
xelab.log            20:44:55.785
xsim.log             20:44:58.703
GOLDEN.json          20:41:44.347 SHA acdbc379… MATCH PRE
query_gold.svh       20:41:44.346 SHA c7fe9acd… MATCH PRE
corpus.json          20:41:44.347 SHA 33d9c387… MATCH PRE
named lex 800k       20:41:44.342 SHA 023a6f81… MATCH PRE
synonym table        19:42:02.355 SHA 551655a1… MATCH PRE / rtl
```

Gold files were **not** rewritten after fail_r0 (still 20:41:44). fail_r0 was
procedural dir-pack width (124-bit concat vs 128-bit walker fields). Fix was
TB `gen_800k.svh` only.

## KEEP / C0 freeze (live MATCH)

```text
extract cd7baf49… UNEDITED
C0 lexicon FILE 38189974… UNEDITED NOT runtime
ctx keys 124be808… instantiate NOT edited (mtime 14:03:07)
ctx DUT 8255a798… KEEP NOT compiled as DUT NOT edited
STREAM-02 14f75db7… KEEP NOT compiled as DUT NOT edited
synonym overlay e862208c… instantiate NOT edited (mtime 19:42:02)
synonym DUT a84bbf7e… instantiate NOT edited (mtime 19:42:02)
SYNONYM-LAW-01 GOLDEN 19:49:47 UNMODIFIED
SEMANTIC-NL-01 GOLDEN 19:05:03 UNMODIFIED
UNSEEN-SRO-16K-R2 GOLDEN 18:19:54 UNMODIFIED
SEMANTIC-16K GOLDEN 14:49:09 UNMODIFIED
```

This bag did not write `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`.

## Honesty

- Historical `ASTRA-02-U5-SCALE-SELECTIVITY-800K` (`qse-v1`) cannot close C1.
- Not BOARD_PASS. Not ACCEPT_BOARD. Not Master ≥95%. `CAND_CAP_FINAL` NOT_FROZEN.
- Index is bag procedural AXI slave, not MIG. Illegal as silicon close.
- DUT `n_post` on fill is 52 beats (rare-first AND stops when one list ends);
  host twin counted full both-list beats (102) as an upper bound. Emit locked
  to gold. `SEARCH_INCOMPLETE` absent.
- CAND display `ev=0` on nids 120–122 is a 20-bit signed compare artifact in
  `ev_of` vs `G_N=800000`; retrieve scoring used `G_RELEVANT` (tp=3).
- Synonym law is the named overlay already frozen; this bag instantiates it
  at N=800000 and does not grow `QSE_SYN_N`.

XSIM_SHA = `7d0a52ac3a4c19ef8f3990b16294b52cc8d518a20f177058bd80954d6bc394d5`
PID session start Mon Sep 7 20:44:56 2026; exit 20:44:58; `$finish` 18825 ns.
