# RESULTS — ASTRA-C3-HELD-OUT-MIG-01

```text
GATE            = ASTRA-C3-HELD-OUT-MIG-01
XSIM            = ASTRA_C3_HELD_OUT_MIG_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C3_MASTER       = OPEN
BOARD_PASS      = REJECT
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
DUT             = a7ng_astra_c3_held_out (existing wrap, TO_CYC=65535, not edited)
MIG             = XSIM official AXI mig_7series_0_mig_sim + ddr3_model
CALIB           = HIT t=122810625.0 ps
SIM_PS          = 2442962625
WALL            = elapsed 03:29:06
ISO             = PASS ISO_P3_X50_DW5 (w0=5 viso=0)
```

GOLDEN hashed before xvlog. KEEP C0/C1/C2 + SGD KEEP + official `mig.prj` MATCHED. C0 sparse hashed, not compiled as DUT. Synth `mig.v` not compiled. `tiny_gpt803k_core` not compiled.

## Raw measured (xsim.log)

```text
CLASS_mig_calib_complete HIT t=122810625.0 ps
CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}
C3_SUM A=40/40 B=0 C=0 Dpid=0 gain_pp=100 pair_pos=5/5 host_bad=0
CLASS_arm_A_learner HIT  8/8 × 5 seeds
CLASS_arm_B_frozen HIT   0/8 × 5 seeds
CLASS_arm_C_shuffled HIT 0/8 × 5 seeds
CLASS_arm_D_perid HIT    pid_pick_gold=0/8 × 5
CLASS_gain_A_over_B HIT  gain_pp=100
CLASS_host_winner_zero HIT
ASTRA_C3_HELD_OUT_MIG_XSIM_PASS
C3_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO quality=MIG_PHY_PLANTED_2HOP_5SEED
```

Five archived seeds, all `A=8 B=0`. Paired direction A>B on every seed. Directory/posting/fact AXI after calib went through official MIG PHY sim.

## Quality bound (do not promote)

Evidence class **XSIM MIG PHY**. Planted 2-hop facts written through MIG AW, not 800k cartesian corpus, not silicon microexam.
This is **not** Master §9 close. `C3_MASTER=OPEN`.

## KEEP

No C0/C1/C2 KEEP file edited. Existing C3 wrap instantiated only. Official `mig.prj` / `ddr3_model` / `mig_native_wrap` not edited.
