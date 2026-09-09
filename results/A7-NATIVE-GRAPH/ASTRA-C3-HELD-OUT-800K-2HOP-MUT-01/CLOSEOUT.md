# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-2HOP-MUT-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_2HOP_MUT_XSIM_PASS` on raw `xsim.log`.
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: after +rew train on 800k cartesian 2-hop ctx overlay, mutate the
overlay. GOLDEN hash unchanged
`17ab52466f7be85acd59f9f6cc22fe592c8fe9ab576ab7b1750c92ed7d5a1c2a`.
KEEP C3 wrap was not edited.

Measured (not Master close, not MIG, not silicon):
- `CLASS_entities_disjoint HIT train={13,15,16} hold={19}`
- `CLASS_base_two_hop HIT` ans=28 p0=24617 p1=64617 ctx=2 npath=2
- `CLASS_edge_delete HIT` st=UNKNOWN npath=0 ans=0
- `CLASS_edge_replace HIT` ans=45 p1=64633
- `CLASS_edge_reverse HIT` "header feeds indirect" subj=14 UNKNOWN
- `CLASS_host_winner_zero HIT`
- `$finish` 52435 ns

Quality bound: same ctx-k0 overlay as `ASTRA-C3-HELD-OUT-800K-2HOP-01`;
delete removes hop2 nids; replace swaps gold hop2 nid 64617→64633 (dest 45);
reverse is empty ctx-key for header=14, not a stored reverse chain.
This bag does not freeze `DDR_QUERY_BOUND_FINAL` or program silicon.
