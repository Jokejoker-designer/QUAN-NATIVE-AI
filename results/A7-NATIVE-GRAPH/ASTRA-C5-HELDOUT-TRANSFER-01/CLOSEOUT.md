# CLOSEOUT — ASTRA-C5-HELDOUT-TRANSFER-01

PROGRAM=NO. Marker `ASTRA_C5_HELDOUT_TRANSFER_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: same C5 production hierarchy, modeled AXI. GOLDEN hash unchanged
`37334758a555d70304d9b360299caea74433b3601f4514e1dff6407c9ea0308d`.
KEEP C0/C1/C2/C3 unedited. Plant stays in TB.

Measured (not Master close, not MIG, not silicon):
- `CLASS_entities_disjoint HIT train={10} hold={6}`
- `CLASS_heldout_pre HIT` freeze `"ahu connects indirect"` ans=144 p0=256
- `CLASS_reward_update HIT` after `"pump requires indirect"` persist w0=3
- `CLASS_heldout_post HIT` ans=112 p0=258
- `CLASS_heldout_changed HIT` pre=144 post=112
- `CLASS_one_ddr_owner HIT` nsw=23 dual=0
- `CLASS_no_qid_map` / `CLASS_no_host_winner` / `CLASS_no_a09_top` / `CLASS_no_plant_in_dut` HIT
- `$finish` 84185 ns

Quality bound: compact planted 2-hop, UART sim baud 8000/800, no CONFLICT
opcode, compact LM not 802k. Persist PRE w0 sampled as `x` (uninitialized
journal) vs TRAIN w0=3. Independent auditor must hunt plant tautology.
This bag does not freeze `DDR_QUERY_BOUND_FINAL` or program silicon.
