# RESULTS — ASTRA-C2-PERSIST-DDR-STALL-01

ONE UNKNOWN: persist + dirty write-back complete under AW/W/B backpressure
(reload under AR/R stall). PERSISTED only after B OKAY. Not MIG. Not low16.

```text
MARKER               = ASTRA_C2_PERSIST_DDR_STALL_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = NO
STALL                = AW=8 W=5 B=6 AR=4 R=3
SIM_NS               = 1405
```

| Class | Result |
|---|---|
| reset_before_update | HIT |
| schema_mismatch | HIT fail_code=1 |
| aw_stall | HIT n_aw_stall=8 on first persist (run total 28) |
| w_stall | HIT n_w_stall=5 on first persist (run total 15) |
| b_stall | HIT n_b_stall=6 on first persist (run total 18) |
| wdata_stable | HIT |
| not_persisted_before_b | HIT |
| in_place_dirty | HIT live=2 AXI0=1 p_w0=1 |
| writeback_after_stall | HIT AXI0 A w0=2, AXI1 B w0=2, n_wb=1 |
| high_id_identity | HIT B 0xC34FF / 799998 / 0xABCDE |
| alias_attempt | HIT low16 0x034FF miss |
| journal_addr_not_low16 | HIT last_aw=0x06000010 |
| reset_during_stall | HIT journal kept B, live_w0=0 |
| reload_after_stall | HIT B identity+w0=2 after persist_clr + AR/R stall |
| false_success_zero | HIT n_false=0 |

HEADLINE `n_upd=4 n_hit=1 n_wb=1 n_aw_stall=28 n_w_stall=15 n_b_stall=18 n_schema=1 n_false=0`

Does **not** close Master §8 (no MIG). Cache/journal updates only on AXI B OKAY.
Does not compile persist-commit / multi-slot KEEP / ASTRA-06 / prior_store / C0 as DUT.
Gold hashed before first xvlog. First XSim PASS (no xsim_fail_r0).
