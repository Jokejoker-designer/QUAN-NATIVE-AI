# CLOSEOUT — ASTRA-C3-HELD-OUT-800K-RELOAD-01

PROGRAM=NO. Marker `ASTRA_C3_HELD_OUT_800K_RELOAD_XSIM_PASS` on raw `xsim.log`.
`C3_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.
`PERSIST_SCHEMA_VERSION=NOT_FROZEN`.

r0: xelab dual-drive on `jmem`/`jvalid`/`last_aw` (initial + always_ff). GOLDEN not regenerated.
r1: TB-only; GOLDEN frozen MATCH `2bac646d3e30ef15950385e0f1c4b78a81f70db85f4ae3c21464f21dae746b26`.

This-gate: after arm-A train on 800k cartesian 2-hop ctx overlay, C2 KEEP
journals w0 at `AWADDR=0x06000000`, `persist_clr`+`rst_n` flush, C2 `reload_i`
restores w0, TB restores w[1:31]. KEEP C3 wrap was not edited.

Measured (not Master close, not MIG, not silicon):
- `CLASS_entities_disjoint HIT train={13,15,16} hold={19,20}`
- `CLASS_flush_w0_zero HIT` seeds 0–4
- `CLASS_c2_persist_reload HIT` / `CLASS_c2_w0_match HIT` w0=30
- `CLASS_awaddr_06000000 HIT`
- `CLASS_host_winner_zero HIT`
- `CLASS_retention_le5pp HIT drop_pp=0 max_seed_drop=0` pre=40/40 post=40/40
- `$finish` 395635 ns

Quality bound: C2 journals w0 only; w[1:31] TB-restored; cartesian overlay not MIG.
Does not close C3 silicon microexam. Independent auditor must hunt TB w[1:31] restore.
