# RESULTS — ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01

Authority = raw `xsim.log` CLASS_* / NOT_SELECTIVE / UNRELATED_EMPTY_WALK.
This file does not promote C1 800k, N=4096, or BOARD_PASS.

```text
GATE             = ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW_SEL          = 1
QUERY_LAW        = qse-v2-role-00 (hash cd7baf49… MATCH C0)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog.log units: pkg, role_extract, route_valid_gate,
                   sparse_dir_axi, axi_mem_model, query_axi_sparse, tb_astra_c1_n256_r2)
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (08:59:20, before first xvlog 08:59:39)
GOLD_LIVE        = MATCH e2091bac… / 181958be… / a089afda…  (not rewritten)
FAIL_R0          = none (XSim never FIRST_DIVERGENCE / ROLE_COLLAPSE)
XSIM_MARKER      = ASTRA_C1_N256_R2_XSIM_PASS
SIM_TIME         = 15755 ns
PID              = 37544
SESSION          = Mon Sep 7 09:00:27–09:00:29 2026
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
BOARD_PASS       = NOT_CLAIMED
RESULT_PROPOSED  = PASS_THIS_GATE_ONLY
```

Prior bag `ASTRA-C1-N256-ROLE-RETRIEVAL-01` was not edited (RESULTS.md still 08:37:00).

Wrapper note (not an XSim FAIL): first xvlog/xsim at 08:59:42 already printed
`ASTRA_C1_N256_R2_XSIM_PASS`. `run_xsim.ps1` then tripped on case-insensitive
`reduction_x1000=` matching the honest line `REDUCTION_X1000=NOT_EMITTED`.
Gold files were not regenerated. Pattern tightened to `reduction_x1000=[0-9]`;
archived log is the second session (PID 37544). No `xsim_fail_r0.log`.

## Per-class (authority = xsim.log)

Quality number is **precision** (`prec_ev1` excludes evidence=0 fillers from the
denominator; `prec_all` uses emit_n). Recall on 1–4 gold ids inside CAND_CAP is
not the quality headline.

| class | gold_n | emit_n | tp | fp_ev1 | fp_fill0 | prec_ev1 | prec_all | rec | notes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 16 | 3 | 13 | 0 | 187 | 187 | 1000 | 0 fillers; EV1 FPs include wrong-relation 112–115 |
| paraphrase | 3 | 16 | 3 | 13 | 0 | 187 | 187 | 1000 | same walk as direct |
| role_reversal | 1 | 16 | 1 | 15 | 0 | 62 | 62 | 1000 | 0 fillers |
| wrong_relation | 1 | 16 | 1 | 7 | 8 | 125 | 62 | 1000 | fillers present; prec_ev1 ≠ prec_all |
| wrong_context | 1 | 16 | 1 | 15 | 0 | 62 | 62 | 1000 | **NOT_SELECTIVE** (see below) |
| distractor | 4 | 12 | 4 | 8 | 0 | 333 | 333 | 1000 | gold_n=4 (duct supplies *); not lambda False |
| unrelated | 0 | 0 | 0 | 0 | 0 | — | — | — | **UNRELATED_EMPTY_WALK** (not 1000/1000) |
| high_occupancy | 1 | 16 | 1 | 4 | 11 | 200 | 62 | 1000 | fillers counted separately |
| overflow_page | 1 | 16 | 1 | 11 | 4 | 83 | 62 | 1000 | gold 172 in emit; ovf=1 |
| high_id_sentinel | 1 | 16 | 1 | 11 | 4 | 83 | 62 | 1000 | id 255 present |

Raw CLASS / named lines:

```text
CLASS_direct gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=16 tp=3 fp_ev1=13 fp_fill0=0 prec_ev1_x1000=187 prec_all_x1000=187 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=766 k3=4408 vs_direct k0=2561 k1=257 k2=766 k3=4408 keys_match=1 emit_match=1 frozen_law=xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=14 ovf=1 trunc=4 dirB=48 postB=96 discB=36 descB=0 incomp=0
CLASS_distractor gold_n=4 emit_n=12 tp=4 fp_ev1=8 fp_fill0=0 prec_ev1_x1000=333 prec_all_x1000=333 rec_x1000=1000 occ=12 ovf=1 trunc=0 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
```

wrong_context emit list is byte-identical to direct (frozen qse-v2: xid is not a
directory key). That is the expected NOT_SELECTIVE outcome, not a context-selectivity
win, even though rec_x1000=1000.

Low direct precision is **13 evidence=1 false positives** via four-table cue union
(k2/k3 have no relation), not occupancy fillers (`fp_fill0=0` on direct).

`reduction_x1000` was not emitted. Do not read 16/256 as Master candidate-reduction
≥90% (that bound is N≥4096).

## Not claimed

C1 800k. N>256. CAND_CAP_FINAL. BOARD_PASS. ASTRA-13. DDR. Historical U5 close.
Master evidence-recall ≥95%. Master candidate-reduction ≥90%. Context selectivity
under frozen qse-v2-role-00.
