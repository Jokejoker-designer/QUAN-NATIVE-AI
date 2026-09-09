# RESULTS — ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01

```text
RESULT               = PASS_THIS_GATE_ONLY
LAW                  = qse-v2-intersect-context-02
LEXICON_LAW          = qse-v2-lex-semantic-16k-01 (copied named df0e8833; not C0 59-word runtime)
N                    = 16384
N_BUCKETS            = 65536
N_SUBJECTS           = 127
N_RELS               = 8
PLANTED_N            = 8
CAND_CAP             = 16 (after emit; NOT FINAL)
MEM_DEPTH            = 286514 (TB-only; 4*65536 directory + postings)
POKE_V               = 0
PROGRAM              = NO
C1_800K              = OPEN
BOARD_PASS           = NOT_CLAIMED
CAND_CAP_FINAL       = NOT_FROZEN
DDR_QUERY_BOUND_FINAL = NOT_FROZEN
MARKER               = ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS
PID                  = 24652
SIM_TIME             = 7265 ns
XSIM                 = 17:50:58–17:51:08 local+07; Vivado 2026.1
XSIM_SHA             = cee6e63d48b79cb15c8de492517f84d58fa239cbe34ffb6fc5391db218a50f28
GOLD_PRE             = 17:29:38 (GOLDEN/svh/corpus) BEFORE first xvlog 17:30:01
                       and BEFORE PASS xvlog 17:37:44
                       named lex mtime 14:49:07 (copied; not rewritten)
GOLDEN               = dfa19dde41e2566dc2a0d277c0ad30dc1394a6ebb90872f548de557d7a7b20a2
SVH                  = 429c9f8881a659ee5e17e115899ca17a7cdf9065e3e1966550b840f30a5ee15d
CORPUS               = 6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597
LEX_NAMED            = df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4
FAIL_R0              = ABSENT (PASS session)
FAIL_COUNT           = 0
SEARCH_INCOMPLETE    = ABSENT
FIRST_DIVERGENCE     = ABSENT
UNBOUND_FILL_GRID_LEAK = ABSENT
N_DROP               = ABSENT (N actually 16384; not silent 256)
TWELVE_ENTITY_CLONE  = NO
```

Authority = raw `xsim.log` CLASS_* / EMIT_* / FILL_TEMPLATE_HIT /
UNSEEN_SRO_HIT / UNBOUND_EMPTY_WALK / UNRELATED_EMPTY_WALK /
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS. This file is hunted, not
authority.

## Registered unknown (closed this bag only)

N=16384 cartesian fill (SEMANTIC-16K generator over NEW_SUBJ_IDS
`{13..132}`) **plus** ≥8 off-grid planted (s,r,o) facts not in that
fill; retrieve one planted nid (`gold_n>=1`); query bound to an
unindexed SRO must `UNBOUND_EMPTY_WALK` and must **not** emit fill-grid
neighbors `{120,121,122}`. Instantiate ctx keys `124be808…` + DUT
`8255a798…` (not edited). `SEARCH_INCOMPLETE` on `gold_n>=1` retrieve =
FAIL. If XSim cannot host 16384, FAIL honestly MEM — do not drop N.
C1 800k stays OPEN.

Raw:

```text
C1_SEMANTIC_UNSEEN_SRO_16K_N=16384 N_BUCKETS=65536 … MEM_DEPTH=286514
  N_SUBJECTS=127 N_RELS=8 PLANTED_N=8 UNSEEN_SRO=1 FILL_GRID=120,121,122 UNSEEN_NID=123
FILL_TEMPLATE_HIT tp=3 emit_n=3
CLASS_fill_template gold_n=3 emit_n=3 tp=3 occ=121 ovf=1 trunc=0 incomp=0
  CAND fill_template i=0 id=120 ev=1
  CAND fill_template i=1 id=121 ev=1
  CAND fill_template i=2 id=122 ev=1
UNSEEN_SRO_HIT tp=1 emit_n=1 nid=123
CLASS_unseen_sro gold_n=1 emit_n=1 tp=1 occ=2 ovf=0 trunc=0 incomp=0
  CAND unseen_sro i=0 id=123 ev=1
UNBOUND_EMPTY_WALK gold_n=0 emit_n=0
CLASS_unbound_sro gold_n=0 emit_n=0 occ=121 ovf=1 trunc=0 incomp=0
UNRELATED_EMPTY_WALK
ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_XSIM_PASS
C1_800K=OPEN BOARD_PASS=NOT_CLAIMED PROGRAM=NO
```

Fill-template control `"boiler feeds header"` still emits `{120,121,122}`
with k0 occupancy **121** (not a 3-entity pad). Unseen SRO `"chiller
supplies condenser"` SRO=(1,1,2) is **not** in cartesian fill over
NEW_SUBJ_IDS `{13..132}` and retrieves planted nid 123. Unbound
`"boiler feeds chiller"` SRO=(13,4,1) is **not indexed**, shares
fill-grid k0=3332 (occ=121; k0-only would leak `{120,121,122}` plus
cartesian boiler-feeds-* nids), k1=260 occ=0, AND empty. Eight off-grid
plants at nids 123–130 use C0 HVAC ids outside NEW_SUBJ_IDS. N actually
16384. Not nid-derived. Not `relevant=router_union`. Not a 12-entity
HVAC clone (`pump supplies chiller` count=0).

## Honesty / not claimed

N=16384 **was hosted** (banner, `G_N=16384`, MEM_DEPTH=286514 TB-only,
`N_DROP` ABSENT). That is this bag's scale unknown. It does **not**
close C1 800k, Master evidence-recall ≥95%, candidate-reduction ≥90%,
BOARD_PASS, ACCEPT_BOARD, N=65536, or true NL hold-out.

Unseen retrieve remains occupancy-small (AND `{123}`; k1 occ=2 because
a second plant shares obj/rel `condenser/supplies`). Fill-template gold
is still the 3-id reserved plant `{120,121,122}`. Unbound negative is a
hard-empty k1 (not a held-out combination that exists in the index).
Index is `axi_mem_model`, not MIG/DDR. `CAND_CAP_FINAL` /
`DDR_QUERY_BOUND_FINAL` stay NOT_FROZEN. Host n_post vs DUT postB
residual on fill (host 31+5 beats vs DUT postB=512→32) and unbound
(host nbeats(121) vs DUT postB=0) — emit locked; do not freeze DDR
bytes.

## CLASS table (raw)

| class | gold | emit | tp | incomp | notes |
|---|---|---|---|---|---|
| fill_template | {120,121,122} | {120,121,122} | 3 | 0 | cartesian control; occ=121 |
| unseen_sro | {123} | {123} | 1 | 0 | SRO=(1,1,2) ∉ NEW_SUBJ cartesian |
| unbound_sro | [] | [] | 0 | 0 | SRO=(13,4,1) not indexed; no {120,121,122} |
| unrelated | [] | [] | 0 | 0 | UNRELATED_EMPTY_WALK |

## Instantiation / KEEP

- Ctx keys `a7ng_query_role_keys_ctx.sv` `124be808…` instantiate, mtime 14:03:07, **not edited**.
- Ctx DUT `a7ng_query_axi_sparse_intersect_context.sv` `8255a798…` instantiate as DUT, mtime 14:03:24, **not edited**.
- STREAM-02 `14f75db7…` mtime 11:43:39 **not compiled as DUT**.
- PAGE-SKIP `dab15d76…` **not compiled**.
- leftover A09 **not compiled**. `poke_v=0`.
- Named lexicon `df0e8833…` copied mtime 14:49:07, **not rewritten**. xvlog `-i $bag` FIRST.
- C0 lexicon FILE `38189974…` mtime 2026-09-05 20:51:03 unedited, **not runtime**.
- C0 extract `cd7baf49…` unedited.
- KEEP UNSEEN-SRO N=256 CLOSEOUT 17:04:05 **unmodified**.
- KEEP HELDOUT CLOSEOUT 16:06:53 **unmodified**.
- KEEP SEMANTIC-16K CLOSEOUT 15:18:52 **unmodified**.
- Independent tree `D:\FPGA\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT` max mtime 10:52:29 **not written**.

Gold hashed 17:29:38 **before** first xvlog 17:30:01 (aborted xelab) and
before PASS xvlog 17:37:44. Gold files still 17:29:38 after xsim.
`xsim_fail_r0.log` ABSENT.
