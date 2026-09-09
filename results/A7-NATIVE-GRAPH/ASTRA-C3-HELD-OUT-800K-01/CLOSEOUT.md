# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_XSIM_PASS` on raw `xsim.log`.
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: 5-seed 4-arm disjoint held-out on N=800000 cartesian dir/postings
plus C3 `fact_pack` at `FACT_BASE=0x0E000000`. GOLDEN hash unchanged
`2ce1a9c1d571645a8bb1b6f8f2f8d99f5968006ff917f0bd6e932ee68a278b5a`.
KEEP `a7ng_astra_c3_held_out.sv` was not edited. DUT is bag-local
`a7ng_astra_c3_held_out_nb64k.sv` (N_BUCKETS=65536, MAX_PATH=16; dir[48]
overflow-list present is not treated as SEARCH fail).

Measured (not Master close, not MIG, not silicon):
- `CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}`
- `CLASS_arm_A_learner` A=40/40; `CLASS_arm_B_frozen` B=0/40
- `CLASS_arm_C_shuffled` C=0/40; `CLASS_arm_D_perid` D=40/40
- `CLASS_gain_A_over_B HIT gain_pp=100 pair_pos=5/5`
- `CLASS_host_winner_zero HIT`
- ISO SGD KEEP: x=50 rew=3 → dw=+5

Quality bound: 1-hop `"<entity> feeds"` (no `indirect`), CAND_CAP=16, gold =
first of 16 sorted k0 nids with `nid%16==9` (conf 200 vs 40). Frozen B
tie-breaks to min nid (p0=24602 vs gold=24617). Positive train reward then
ranks max-conf on hold; negative reward does not. Independent auditor must
hunt reward-sign→conf-rank tautology. This bag does not freeze
`DDR_QUERY_BOUND_FINAL` or program silicon.
