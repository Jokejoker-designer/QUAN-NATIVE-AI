# CLOSEOUT — ASTRA-C3-HELD-OUT-MIG-02

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_MIG_02_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.
`PERSIST_SCHEMA_VERSION=NOT_FROZEN`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS). Official Digilent AXI MIG PHY XSim.

## One unknown

After `init_calib_complete`, does the same 5-seed 4-arm disjoint held-out
protocol still measure `gain(A over B) >= 10 pp` through official Digilent AXI
MIG (`mig_7series_0_mig_sim` + `ddr3_model`) on **live polarity-CONFLICT C3**,
with two positive dests still ranking and **zero** false `ST_CONFLICT=5`?

## Measured (XSim MIG PHY)

```text
CLASS_mig_calib_complete HIT t=122810625.0 ps
CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}
CLASS_arm_A_learner HIT seed=0..4 acc=8/8 nupd=8
CLASS_arm_B_frozen HIT seed=0..4 acc=0/8
CLASS_arm_C_shuffled HIT seed=0..4 acc=0/8
CLASS_arm_D_perid HIT seed=0..4 dut_gold=8/8 pid_pick_gold=0/8
CLASS_gain_A_over_B HIT gain_pp=100
CLASS_host_winner_zero HIT
CLASS_no_false_conflict HIT n_conf=0
C3_SUM A=40/40 B=0 C=0 Dpid=0 pair_pos=5/5 n_conf=0
PAIRED_CI n=5 mean_gain_pp=100 sd=0 CI95_lower=100 gt0=YES
ISO SGD KEEP: x=50 rew=3 → dw=+5 (ISO_P3 w0=5 viso=0)
```

`$finish` at 2442962625 ps. GOLDEN hash frozen before xvlog:
`3442a5969e981ebf2f223e4705b4938221f3395171ed3d8f510a5c02a1612dae  GOLDEN.json`

KEEP C0/C1/C2 MATCH vs independent `KEEP_HASHES.json` (mismatches=0) including
SGD `b66ef328…`, C2 `86a7a069…`, `mig.prj` `914a9e4b…`.
Live C3 wrap `cfb89632…` unedited. DUT is live wrap (`TO_CYC=65535`), not nb64k.
xvlog analyzed `mig_7series_0_mig_sim.v`, not synth `mig_7series_0_mig.v`.
Bit not programmed.

## Quality bound

Compact planted 2-hop through MIG PHY, not 800k cartesian, not silicon (C7).
`CLASS_arm_D_perid` `pid_pick_gold=0/8` (`Dpid=0`); pass law is A/B/C + gain +
`n_conf=0`, not per-id pick. Two positive dests ranked (`npath=4`, `st=0`).
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.
