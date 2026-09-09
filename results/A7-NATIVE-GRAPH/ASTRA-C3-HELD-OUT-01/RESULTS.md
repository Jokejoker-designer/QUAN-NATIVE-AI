# RESULTS — ASTRA-C3-HELD-OUT-01

```text
GATE            = ASTRA-C3-HELD-OUT-01
XSIM            = ASTRA_C3_HELD_OUT_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C3_MASTER       = OPEN
BOARD_PASS      = REJECT
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
DUT             = a7ng_astra_c3_held_out (NEW named wrap)
RETRIEVE        = a7ng_query_axi_sparse_intersect_synonym (C1 KEEP, instantiate)
SGD             = a7ng_shared_rank_sgd_q8_sym_f2r2 (KEEP, instantiate, freeze_i=ctrl)
ISO             = PASS ISO_P3_X50_DW5 (w0=5 viso=0)
```

SHA freeze before xvlog `2026-09-08T01:20:53.1875679+07:00`. KEEP C0/C1 hashes MATCH. C0 `a7ng_query_axi_sparse.sv` hashed, **not** compiled as DUT. GOLDEN hashed before xvlog; not regenerated.

## Raw measured (xsim.log)

```text
C3_SUM A=40/40 B=0 C=0 Dpid=0 gain_pp=100 pair_pos=5/5 host_bad=0
CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}
CLASS_arm_A_learner HIT  8/8 × 5 seeds
CLASS_arm_B_frozen HIT   0/8 × 5 seeds
CLASS_arm_C_shuffled HIT 0/8 × 5 seeds
CLASS_arm_D_perid HIT    pid_pick_gold=0/8 × 5 (host map from train dest)
CLASS_gain_A_over_B HIT  gain_pp=100
CLASS_host_winner_zero HIT
ASTRA_C3_HELD_OUT_XSIM_PASS
```

Five archived seeds, all `A=8 B=0`. Paired direction A>B on every seed.

## Quality bound (do not promote)

Evidence class **XSIM** compact TB-AXI planted postings, not MIG PHY, not 800k corpus, not silicon.
This is **not** Master §9 close. Retention-after-reload is the next named bag.
Arm D `dut_gold=8/8` still ran SGD updates; the per-ID baseline that complements A is `pid_pick_gold=0`.

## KEEP

No C0/C1/C2 KEEP file edited. New wrap only.
