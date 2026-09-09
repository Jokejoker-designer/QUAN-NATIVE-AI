# PREREG — ASTRA-C3-HELD-OUT-MIG-02

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live
`a7ng_astra_c3_held_out.sv`, official Digilent `mig.prj`, `ddr3_model`, or
`mig_native_wrap`. Does not freeze `DDR_QUERY_BOUND_FINAL`.
Does not self-stamp `C3_MASTER` or `BOARD_PASS`.

## One unknown

After `init_calib_complete`, does the same 5-seed 4-arm disjoint held-out
protocol still measure `gain(A over B) >= 10 pp` when directory/posting/fact
AXI goes through official Digilent AXI MIG (`mig_7series_0_mig_sim` +
`ddr3_model`) on **live polarity-CONFLICT C3**, with two positive dests still
ranking and **zero** false `ST_CONFLICT=5` (no planted negative polarity)?

DUT is instantiate of live `a7ng_astra_c3_held_out` with `TO_CYC=65535`.
KEEP files are not edited.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
CLASS_entities_disjoint train={10,11,1} hold={6,9}
CLASS_arm_A/B/C/D
CLASS_gain_A_over_B
CLASS_host_winner_zero
CLASS_no_false_conflict n_conf=0
```

800k cartesian corpus is out of scope. Silicon microexam is out of scope (C7).

## FAIL if

- KEEP C0/C1/C2 hashes drift
- official `mig.prj` hash drifts
- synth `mig_7series_0_mig.v` compiled instead of `mig_sim`
- GOLDEN edited after xvlog
- PROGRAM=YES
- live C3 wrap edited
