# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RELOAD-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_2HOP_CONFLICT_RELOAD_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.
`PERSIST_SCHEMA_VERSION=NOT_FROZEN`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS). Modeled AXI, not MIG PHY.

## One unknown

After arm-A train on the 800k cartesian 2-hop overlay, on a bag-local copy of
live polarity-CONFLICT C3, does C2 KEEP reload from `AWADDR=0x06000000` restore
held-out gold-hit accuracy with drop ≤5pp, with zero false `ST_CONFLICT=5`?

## Measured (XSim modeled AXI)

```text
CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}
CLASS_flush_w0_zero HIT seed=0..4
CLASS_c2_persist_reload HIT / CLASS_c2_w0_match HIT w0=30
CLASS_awaddr_06000000 HIT
CLASS_host_winner_zero HIT
CLASS_retention_le5pp HIT drop_pp=0 max_seed_drop=0 pre=40/40 post=40/40
CLASS_no_false_conflict HIT n_conf=0
ISO SGD KEEP: x=50 rew=3 → dw=+5
```

`$finish` at 395635 ns. GOLDEN hash frozen before xvlog:
`a5428b0b10ad46fec4a8adfc6b1a5a562ac19f3374562ad0773e62f4058bd0f1  GOLDEN.json`

KEEP C0/C1/C2 MATCH including SGD `b66ef328…` and C2 `86a7a069…`.
Live C3 wrap `cfb89632…` unedited. DUT bag-local nb64k `6dde677a…`.
Bit not programmed.

## Quality bound

C2 journals w0 only; w[1:31] TB-restored. Cartesian overlay, not MIG, not silicon.
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.
