# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-2HOP-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_2HOP_XSIM_PASS` on raw `xsim.log`.
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: 5-seed 4-arm disjoint held-out on N=800000 cartesian `fact_pack`
at `FACT_BASE=0x0E000000` with ctx-folded k0 overlay
(`k0={subj, ctx=2, rel_nibble=4}`). GOLDEN hash unchanged
`0eabc808b098fc1a2c2617435227394e63312ee7c33aed778d62f1cfe3c50fd3`.
KEEP `a7ng_astra_c3_held_out.sv` was not edited. DUT is bag-local
`a7ng_astra_c3_held_out_nb64k.sv`. Queries are `"<entity> feeds indirect"`.

Measured (not Master close, not MIG, not silicon):
- `CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}`
- `CLASS_two_hop_indirect HIT n=40` (ctx=2, proof1!=0 on frozen hold)
- `CLASS_arm_A_learner` A=40/40; `CLASS_arm_B_frozen` B=0/40
- `CLASS_arm_C_shuffled` C=0/40; `CLASS_arm_D_perid` D=40/40
- `CLASS_gain_A_over_B HIT gain_pp=100 pair_pos=5/5`
- `CLASS_host_winner_zero HIT`
- ISO SGD KEEP: x=50 rew=3 → dw=+5
- `$finish` 1008635 ns

Quality bound: cartesian 1-hop directory keys unused; ctx-key overlay posts
four cartesian nids (low-conf distractor 1-hop+2-hop vs high-conf gold
S→29→28, dest=28, p1=64617). Dest 28 also exists as a 1-hop triple in the
full image but is not in the ctx posting; C3 uses `S_EJ` because the query
contains `indirect`. Frozen B tie-breaks to min p0 (ans=14). Positive train
reward then ranks max-conf on hold; negative reward does not. Independent
auditor must hunt ctx-overlay tautology. This bag does not freeze
`DDR_QUERY_BOUND_FINAL` or program silicon.
