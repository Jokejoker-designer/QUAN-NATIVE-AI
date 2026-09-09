# PREREG — ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RTL-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live
`a7ng_astra_c3_held_out.sv`, official `mig.prj`, or TinyGPT.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C3_MASTER` or `BOARD_PASS`.

## One unknown

Do the same 5-seed 4-arm 800k cartesian 2-hop letters still HIT on a bag-local
copy of **live polarity-CONFLICT C3** (`N_BUCKETS=65536`, `MAX_PATH=16`), with
two positive destinations still ranking and **zero** false `ST_CONFLICT=5` on
this overlay (no planted negative polarity)?

## HIT letter this bag may measure (XSim TB-AXI 800k 2-hop)

```text
CLASS_entities_disjoint train={13,15,16} hold={19,20}
CLASS_two_hop_indirect
CLASS_arm_A/B/C/D
CLASS_gain_A_over_B
CLASS_host_winner_zero
CLASS_no_false_conflict n_conf=0
```

## Out of scope

- Silicon held-out (C7)
- MIG PHY
- Planted polarity CONFLICT (that is C5)

## FAIL if

- KEEP C0/C1/C2 hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- live C3 wrap edited as KEEP
