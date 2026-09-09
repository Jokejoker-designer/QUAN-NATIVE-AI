# RESULTS — ASTRA-C2-PERSIST-MULTI-SLOT-01

ONE UNKNOWN: CAP_N=2 miss-allocate / cache-hit / full capacity / dirty eviction
with AXI write-back of the oldest committed victim. Not MIG. Not low16 address.

```text
MARKER               = ASTRA_C2_PERSIST_MULTI_SLOT_XSIM_PASS PRESENT
RESULT               = PASS_THIS_GATE_ONLY
PROGRAM              = NO
BOARD_PASS           = NOT_CLAIMED
MIG                  = NO
CAP_N                = 2
N_AXI                = 4
SIM_NS               = 895
```

| Class | Result |
|---|---|
| reset_before_update | HIT (after rst + persist_clr; sim power-on slots were X) |
| schema_mismatch | HIT fail_code=1 |
| miss_allocate | HIT A {13,4,14,0} w0=1 occ=1 awaddr=0x06000000 |
| cache_hit | HIT lk A occ=1 |
| wrong_generation | HIT n_stale=1 w0 unchanged |
| in_place_dirty | HIT cache w0=2 dirty=1; AXI0 still w0=1 |
| multi_slot | HIT A slot0 + B 0xC34FF slot1 occ=2 |
| full_capacity | HIT cap_full=1 |
| high_id_identity | HIT B subj=0xC34FF obj=799998 ctx=0xABCDE w0=2 |
| dirty_eviction | HIT victim A out, C in slot0, B stays; n_evict=1 n_wb=1 |
| writeback_completion | HIT AXI0 A w0=2; AXI2 C w0=1 |
| identity_not_mixed | HIT |
| alias_attempt | HIT low16 0x034FF miss; full-20 B hit |
| journal_addr_not_low16 | HIT last_aw=0x06000020 |
| reload_after_clr | HIT AXI0+AXI1 restore A w0=2 and B w0=2; C cache miss (AXI2 only) |
| false_success_zero | HIT n_false=0 |

HEADLINE `n_upd=4 n_hit=1 n_miss=3 n_evict=1 n_wb=1 n_stale=1 n_schema=1 n_false=0`

Does **not** close Master §8 (no DDR stall, MIG, duplicate-reward on this law — DUP remains KEEP identity bag).
Does not compile persist-commit / ASTRA-06 / prior_store / C0 / STREAM-02 as DUT.
C0 + persist-commit KEEP hash-gate MATCH. Gold hashed before first xvlog.
