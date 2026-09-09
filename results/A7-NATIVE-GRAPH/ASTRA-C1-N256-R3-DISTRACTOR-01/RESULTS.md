# RESULTS — ASTRA-C1-N256-R3-DISTRACTOR-01

Authority = raw `xsim.log` CLASS_* / FAIL DISTRACTOR_LEAK / NOT_SELECTIVE /
UNRELATED_EMPTY_WALK. This file does not promote C1 800k, N=4096, or BOARD_PASS.

```text
GATE             = ASTRA-C1-N256-R3-DISTRACTOR-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW_SEL          = 1
QUERY_LAW        = qse-v2-role-00 (hash cd7baf49… MATCH C0)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog.log units: pkg, role_extract, route_valid_gate,
                   sparse_dir_axi, axi_mem_model, query_axi_sparse, tb_astra_c1_n256_r3)
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (09:24:14, before first xvlog 09:24:37)
GOLD_LIVE        = MATCH 96f445a9… / a0d99311… / 0ce3bfff…  (not rewritten after FAIL)
FAIL_R0          = xsim_fail_r0.log (copy of this xsim.log; DISTRACTOR_LEAK, not packing)
XSIM_MARKER      = ASTRA_C1_N256_R3_XSIM_PASS NOT emitted
                   ASTRA_C1_N256_R3_XSIM_NO_MARKER fail=1 dist_no_leak=0
SIM_TIME         = 16695 ns
PID              = 45168
SESSION          = Mon Sep 7 09:24:40–09:24:43 2026
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_4096           = NOT STARTED
BOARD_PASS       = NOT_CLAIMED
RESULT           = FAIL
```

Prior bags were not edited:
- KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` gold 08:31:44 hashes 414f9952 / 4b61d88f / 8c342aa2
- KEEP `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` gold 08:59:20 hashes e2091bac / 181958be / a089afda

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH).
Gold was **not** regenerated after FAIL. Leak is the frozen four-table union
emitting excluded overlapping evidence=1 nids, not a TB packing bug.

## Unknown (this bag)

At N=256 frozen qse-v2 + sparse dir, does the entity-context distractor class
treat gold as the **EXCLUDED** set (`leak = FAIL`) rather than a retrieved subset?

Scoring polarity: **yes** (gold_n=11 excluded; tp=0; rec_undef; FAIL DISTRACTOR_LEAK;
not rec=1000 on excluded ids; not query `"supply duct"` / gold `{72,73,74,75}`).

Frozen-law exclusion: **no** (`leak_n=10`). Gate requires leak_n=0 for
`PASS_THIS_GATE_ONLY`. Therefore **RESULT=FAIL**.

## Per-class (authority = xsim.log)

Quality number is **precision** (`prec_ev1` excludes evidence=0 fillers).
Recall on 1–3 retrieve-class gold ids inside CAND_CAP is not the quality headline.
Direct `prec_ev1=187` is frozen four-table union, not a TB bug and not patched.

| class | gold_n | emit_n | tp | leak_n | fp_ev1 | fp_fill0 | prec_ev1 | prec_all | rec | notes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 16 | 3 | — | 13 | 0 | 187 | 187 | 1000 | 0 fillers; EV1 FPs include wrong-relation 112–115 |
| paraphrase | 3 | 16 | 3 | — | 13 | 0 | 187 | 187 | 1000 | same walk as direct |
| role_reversal | 1 | 16 | 1 | — | 15 | 0 | 62 | 62 | 1000 | 0 fillers |
| wrong_relation | 1 | 16 | 1 | — | 7 | 8 | 125 | 62 | 1000 | fillers present; prec_ev1 ≠ prec_all |
| wrong_context | 1 | 16 | 1 | — | 15 | 0 | 62 | 62 | 1000 | **NOT_SELECTIVE** |
| distractor | 11 | 16 | 0 | 10 | 16 | 0 | 0 | 0 | undef | **EXCLUDED**; **FAIL DISTRACTOR_LEAK** |
| unrelated | 0 | 0 | 0 | — | 0 | 0 | — | — | — | **UNRELATED_EMPTY_WALK** |
| high_occupancy | 1 | 16 | 1 | — | 4 | 11 | 200 | 62 | 1000 | fillers counted separately |
| overflow_page | 1 | 16 | 1 | — | 11 | 4 | 83 | 62 | 1000 | gold 172 in emit; ovf=1 |
| high_id_sentinel | 1 | 16 | 1 | — | 11 | 4 | 83 | 62 | 1000 | id 255 present |

Raw CLASS / named lines:

```text
CLASS_direct gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=766 k3=4408 vs_direct k0=2561 k1=257 k2=766 k3=4408 keys_match=1 emit_match=1 frozen_law=xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
FAIL DISTRACTOR_LEAK leak_n=10 emit_n=16 fp_ev1=16 fp_fill0=0 gold_n=11
CLASS_distractor gold_n=11 emit_n=16 leak_n=10 tp=0 fp_ev1=16 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_undef=1 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0 gold_polarity=excluded
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
ASTRA_C1_N256_R3_XSIM_NO_MARKER fail=1 dist_gold_ok=1 dist_excl_ok=1 dist_no_leak=0 unrelated_empty=1 wc_not_sel=1
REDUCTION_X1000=NOT_EMITTED
```

## Distractor polarity (P1)

Query = `"pump supplies chiller"` (same tokens as CLASS_direct; **not** `"supply duct"`).

Independent excluded gold (evidence=1 two-role overlap, computed before walker):

```text
wrong-object  pump supplies !chiller     {108,109,111}
wrong-relation pump !supplies chiller    {114,118}
wrong-entity  !pump supplies chiller     {99,121,132,193,214,235}
gold_n        = 11
not in gold   = PSC retrieve {110,144,145}
```

Emit (walker twin, bit-exact to G_EMIT): `{108,109,110,111,144,145,99,121,132,193,214,235,112,113,114,115}`.

`leak_n=10` = excluded ∩ emit = `{99,108,109,111,114,121,132,193,214,235}`.
Excluded nid 118 (`pump connects chiller`) was not in emit (trunc=4).
Leaks counted as fp_ev1, **never tp**. `rec_x1000=1000` was **not** printed
on this class.

`reduction_x1000` was not emitted as a number. Do not read 16/256 as Master
candidate-reduction ≥90% (that bound is N≥4096). Do not patch C0 RTL to chase
leak_n or direct prec=187.

## Not claimed

C1 800k. N>256. CAND_CAP_FINAL. BOARD_PASS. ASTRA-13. DDR. Historical U5 close.
Master evidence-recall ≥95%. Master candidate-reduction ≥90%. Context selectivity
under frozen qse-v2-role-00. `PASS_THIS_GATE_ONLY`. `ASTRA_C1_N256_R3_XSIM_PASS`.
