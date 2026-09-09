# CLOSEOUT — ASTRA-C5-FLUSH-RELOAD-MIG-01

PROGRAM=NO. Marker `ASTRA_C5_FLUSH_RELOAD_MIG_XSIM_PASS` on raw `xsim.log`.
`C5_MASTER=OPEN`. `BOARD_PASS=REJECT`. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

This-gate: same C5 production hierarchy through official `mig_sim` + `ddr3_model`.
UART flush (`0x0C`) then C2 reload (`0x12`) of the planted persist row.
GOLDEN hash unchanged `dd16753ee8eb37eeafa5fbea1ea20e73e39c9565110a0348b99371a589d68c1b`.
KEEP C0/C1/C2 unedited (`a7ng_astra_c2_persist_commit.sv` `86a7a069…`). Plant stays in TB.
TB-only `defparam TO_CYC=65535`. UART sim baud 8000/800.

r4 DUT (not KEEP): hold `req[CKPT]` with `reload_pend || p_busy` across UART `0x12`→EOL;
arbiter `pend` keeps `S_OWN` while a read is in flight; `m_wstrb_o = p_wstrb`.
r0–r3 archived FAIL (grant drop; persist R beat drained as orphan). GOLDEN not regenerated.

Measured (not Master close, not silicon):
- `CLASS_mig_calib_complete HIT t=122810625.0 ps`
- `CLASS_two_hop_answer HIT` Q1 `"pump requires indirect"` dest=64 w0=3 pvalid=1
- `CLASS_flush_w0_zero HIT` pvalid=0
- `CLASS_c2_persist_reload HIT` w0=3 saved=3 pvalid=1 guard=0 owner=5 pph=4
- `CLASS_one_ddr_owner HIT` nsw=16 dual=0
- `CLASS_no_qid_map` / `CLASS_no_host_winner` / `CLASS_no_a09_top` / `CLASS_no_plant_in_dut` HIT
- `$finish` 168626625 ps
- Wrapper `ASTRA_C5_FLUSH_RELOAD_MIG_RUN_OK` exit=0 ~560 s wall

Quality bound: planted 2-hop, UART sim baud, KEEP C3 has no CONFLICT opcode, compact LM not 802k.
Does not freeze `DDR_QUERY_BOUND_FINAL` or program silicon.
