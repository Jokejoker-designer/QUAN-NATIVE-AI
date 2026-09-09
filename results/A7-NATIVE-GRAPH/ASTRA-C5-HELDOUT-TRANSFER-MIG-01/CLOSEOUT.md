# CLOSEOUT — ASTRA-C5-HELDOUT-TRANSFER-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_HELDOUT_TRANSFER_MIG_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: same C5 production hierarchy through official `mig_sim` + `ddr3_model`.
GOLDEN hash unchanged `dabdaecc87e1ce6b05e41875165b7172154741cdbb7cd6a3465cae803d7247ba`.
KEEP C0/C1/C2/C3 unedited. Plant stays in TB (MIG AW mux while DUT in reset).
TB-only `defparam TO_CYC=65535`.

Measured (not Master close, not silicon):
- `CLASS_mig_calib_complete HIT t=122810625.0 ps`
- `CLASS_entities_disjoint HIT train={10} hold={6}`
- `CLASS_heldout_pre HIT` freeze `"ahu connects indirect"` ans=144 p0=256
- `CLASS_reward_update HIT` after `"pump requires indirect"` persist w0=3
- `CLASS_heldout_post HIT` ans=112 p0=258
- `CLASS_heldout_changed HIT` pre=144 post=112
- `CLASS_one_ddr_owner HIT` nsw=23 dual=0
- `CLASS_no_qid_map` / `CLASS_no_host_winner` / `CLASS_no_a09_top` / `CLASS_no_plant_in_dut` HIT
- `$finish` 229910625 ps

Quality bound: planted 2-hop, UART sim baud 8000/800, persist PRE w0=`x` vs TRAIN w0=3,
no CONFLICT opcode, compact LM not 802k. First xsim attempt stalled after PRE when
the log file was read while xsim still held it; r0 archived; GOLDEN not regenerated.
Independent auditor must hunt plant tautology. Does not freeze `DDR_QUERY_BOUND_FINAL`
or program silicon.
