# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RTL-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_2HOP_CONFLICT_RTL_XSIM_PASS` on raw `xsim.log` (start-of-line).
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.
A09 is not DUT. GOLDEN not regenerated (r0 PASS). Modeled AXI, not MIG PHY.

## One unknown

Do the same 5-seed 4-arm 800k cartesian 2-hop letters still HIT on a bag-local
copy of live polarity-CONFLICT C3 (`N_BUCKETS=65536`, `MAX_PATH=16`), with two
positive destinations still ranking and zero false `ST_CONFLICT=5` (no planted
negative polarity on this overlay)?

## Measured (XSim modeled AXI)

```text
CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}
CLASS_two_hop_indirect HIT n=40 (ctx=2, npath=2)
CLASS_arm_A_learner     A=40/40
CLASS_arm_B_frozen      B=0/40
CLASS_arm_C_shuffled    C=0/40
CLASS_arm_D_perid       D=40/40
CLASS_gain_A_over_B HIT gain_pp=100 pair_pos=5/5
CLASS_host_winner_zero HIT
CLASS_no_false_conflict HIT n_conf=0
ISO SGD KEEP: x=50 rew=3 → dw=+5 (ISO_P3 w0=5 viso=0)
```

Hold A/D answers dest=28 with p1=64617 (two positive dests rank). Frozen B
tie-breaks to min p0 (ans=14). No query reported `st=5`.

`$finish` at 1008635 ns. GOLDEN hash frozen before xvlog:
`a82368c9bab69537b7da9717fcb75e3d945f09b81603cb32014531871e1b1ecc  GOLDEN.json`

KEEP C0/C1/C2 MATCH. Live C3 wrap `cfb89632…` unedited. DUT is bag-local
`a7ng_astra_c3_held_out_nb64k.sv` `6dde677a…`. Bit not programmed.

First `run_xsim.ps1` launch failed on a PowerShell array parse before xvlog
(LAW comment). Script comment quoting was fixed; GOLDEN was not regenerated.
Successful r0 wall ~12.8 s; sim time matches prior 800k-2hop `$finish`.

## Quality bound

Cartesian 2-hop ctx-k0 overlay on modeled AXI, not MIG, not silicon.
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.
