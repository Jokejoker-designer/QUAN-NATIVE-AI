# RESULTS — ASTRA-C1-SYNONYM-LAW-01

Authority = raw `xsim.log` (SHA `fe4b0ac4690868abed79a1a108d2bc566e75b5150fed2637088b24b24844068b`)
+ `GOLD_HASH_PRE_XVLOG.txt` + live Get-FileHash. PROGRAM=NO.

```text
RESULT               = PASS_THIS_GATE_ONLY
MARKER               = ASTRA_C1_SYNONYM_LAW_XSIM_PASS PRESENT
FAIL                 = 0
N                    = 16384
N_BUCKETS            = 65536
CAND_CAP             = 16
MEM_DEPTH            = 286514
LAW                  = qse-v2-relctx-synonym-01
CTX_LAW              = qse-v2-intersect-context-02 (keys 124be808 instantiate, not edited)
LEX                  = qse-v2-lex-semantic-16k-01 (copied df0e8833, not rewritten)
EXTRACT              = qse-v2-role-00 frozen cd7baf49 unedited
POKE_V               = 0
LEFTOVER_A09         = not compiled
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL= NOT_FROZEN
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
FAIL_R0              = ABSENT (session PASSed; gold not regenerated)
```

## CLASS table (raw xsim.log)

| class | gold | emit | tp | fp_ev1 | rec_x1000 | notes |
|---|---|---|---|---|---|---|
| fill_template | {120,121,122} | {120,121,122} | 3 | 0 | 1000 | FILL_TEMPLATE_HIT occ=121 incomp=0 |
| nl_synonym | {120,121,122} | {120,121,122} | 3 | 0 | 1000 | NL_GOLD_HIT; not nid 131 |
| unrelated | {} | {} | 0 | 0 | n/a | UNRELATED_EMPTY_WALK |

Raw named lines:

```text
FILL_TEMPLATE_HIT tp=3 emit_n=3
FROZEN_KEYS_VS_FILL class=nl_synonym k0=3329 k1=3585 vs_fill_template k0=3332 k1=3588 keys_match=0 law=qse-v2-role-00
SYN_KEYS_VS_FILL class=nl_synonym k0=3332 k1=3588 vs_fill_template k0=3332 k1=3588 keys_match=1 law=qse-v2-relctx-synonym-01 syn_hit=1
NL_GOLD_HIT tp=3 emit_n=3 gold_n=3 keys_match_frozen=0 keys_match_syn=1
EMIT_nl_synonym n=3
  CAND nl_synonym i=0 id=120 ev=1
  CAND nl_synonym i=1 id=121 ev=1
  CAND nl_synonym i=2 id=122 ev=1
CLASS_unrelated UNRELATED_EMPTY_WALK
NL_SUMMARY keys_match_frozen=0 keys_match_syn=1 nl_hit=1 nl_tp=3 fill_tp=3 emit_has_131=0 fail=0
ASTRA_C1_SYNONYM_LAW_XSIM_PASS
NOT_CLAIMED=C1_800k,BOARD_PASS,ASTRA-13,CAND_CAP_FINAL,DDR_QUERY_BOUND_FINAL,PAGE_SKIP_MIX,N_65536,MASTER_95,ACCEPT_BOARD
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

## Unknown

Probe `"what does the boiler supply to the header"` retrieves fill-meaning gold
`{120,121,122}` (feeds), **not** cartesian nid 131 (`"boiler supplies header"`).

Frozen extract still binds `supply` RELCTX id=1 → keys 3329/3585 (`FROZEN_KEYS_VS_FILL keys_match=0`).
Named overlay `qse-v2-relctx-synonym-01` remaps rel 1→4 → DUT keys 3332/3588
(`SYN_KEYS_VS_FILL keys_match=1 syn_hit=1`). Walker AND of fill keys emits `{120,121,122}`.

Gold `G_RELEVANT[nl]={120,121,122}` was **not** relabeled to `{131}`.

## Gold-before-xvlog

```text
GOLD_HASH_PRE_XVLOG  19:49:47.982
SHA256.txt           19:50:25.642
xvlog.log            19:50:26.616
xelab.log            20:03:33.379
xsim.log             20:03:44.413
GOLDEN.json live     587e6ac3841105f1a570b28094784dfdad3eff168549d9d8112280af02022936 MATCH PRE
query_gold.svh live  d61a444805ebe9d1673c333496cdfcaf996b66d01afa8fb5d886ffcffb854608 MATCH PRE
corpus.json          6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597 MATCH KEEP / PRE
named lex            df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4 MATCH KEEP / PRE mtime 14:49:07
synonym table        551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd MATCH PRE
```

Gold files were **not** rewritten after xsim (still 19:49:47).

## KEEP / C0 freeze (live MATCH)

```text
extract cd7baf49… UNEDITED
C0 lexicon FILE 38189974… UNEDITED NOT runtime
ctx keys 124be808… instantiate NOT edited
ctx DUT 8255a798… KEEP NOT compiled as DUT NOT edited
STREAM-02 14f75db7… KEEP NOT compiled as DUT NOT edited
SEMANTIC-NL-01 GOLDEN 6fa2a93f… mtime 19:05:03 UNMODIFIED (honest FAIL evidence)
independent tree max 10:52:29 UNMODIFIED (this bag did not write it)
```

## Honesty

- Not C1 800k. Not BOARD_PASS. Not ACCEPT_BOARD. Not Master ≥95%.
- Index is `axi_mem_model`, not MIG. Illegal as silicon close.
- Host n_post vs DUT postB residual (36 vs 32) same family as KEEP 16K; emit locked.
- Synonym law is a **named overlay**, not a silent C0 extract patch.
- Frozen keys_match=0 proves C0 extract still distinguishes supply≠feeds.

XSIM_SHA = `fe4b0ac4690868abed79a1a108d2bc566e75b5150fed2637088b24b24844068b`
PID session start Mon Sep 7 20:03:34 2026; exit 20:03:44; `$finish` 9535 ns.
