# RESULTS — ASTRA-C2-PERSIST-COMMIT-01

ONE UNKNOWN: 20-bit persist identity + five phases + false success=0 on modeled AXI journal.

```text
MARKER               = ASTRA_C2_PERSIST_COMMIT_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = NO
```

| Class | Result |
|---|---|
| reset_before_update | HIT |
| schema_mismatch | HIT fail_code=1 |
| happy_commit | HIT {13,4,14,0,gen=1} w0=1 awaddr=0x06000000 |
| duplicate_reward | HIT w0 unchanged |
| wrong_generation | HIT |
| high_id_identity | HIT subj=0xC34FF obj=799998 ctx=0xABCDE w0=3 |
| alias_attempt | HIT low16 0x034FF miss; full-20 hit |
| reset_during_update | HIT journal kept high-id; live_w0=0 |
| reset_after_commit_reload | HIT identity+w0 exact after persist_clr + AXI reload |
| journal_addr_not_low16 | HIT |
| false_success_zero | HIT n_false=0 |

Does **not** close Master §8 (no multi-slot, dirty eviction, DDR stall, MIG, held-out).
Historical ASTRA-06 is on-chip regs / 8-bit obj. prior_store low16 is not this DUT.
