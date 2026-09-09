# RESULTS — ASTRA-C3-HELD-OUT-RELOAD-01

```text
GATE            = ASTRA-C3-HELD-OUT-RELOAD-01
XSIM            = ASTRA_C3_HELD_OUT_RELOAD_XSIM_PASS
RESULT          = PASS_THIS_GATE_ONLY
C3_MASTER       = OPEN
BOARD_PASS      = REJECT
PROGRAM         = NO
BIT             = NOT_BUILT
COM12 / JTAG    = UNTOUCHED
C3 DUT          = a7ng_astra_c3_held_out (instantiate, not edited)
C2 KEEP         = a7ng_astra_c2_persist_commit (instantiate, hash 86a7a069 MATCH)
ISO             = PASS ISO_P3_X50_DW5 (w0=5 viso=0)
```

SHA freeze before xvlog. KEEP C0/C1/C2 hashes MATCH. C0 `a7ng_query_axi_sparse.sv` hashed, **not** compiled as DUT. GOLDEN hashed before xvlog (`d641360cc51015008257dce797108be0bd10375984a6d1e5e22a694f9310efd6`); not regenerated.

## Raw measured (xsim.log)

```text
C3_RELOAD_SUM pre=40/40 post=40 drop_pp=0 max_seed_drop=0 host_bad=0 saw_base=1 n_false=0
CLASS_entities_disjoint HIT train={10,11,1} hold={6,9}
CLASS_flush_w0_zero HIT  (w0=0 after persist_clr + rst, 5/5 seeds)
CLASS_c2_persist_reload HIT  persist_w0=live_w0=35 after reload, 5/5 seeds
CLASS_c2_w0_match HIT
CLASS_awaddr_06000000 HIT awaddr=6000000
CLASS_host_winner_zero HIT
CLASS_retention_le5pp HIT drop_pp=0 max_seed_drop=0
ASTRA_C3_HELD_OUT_RELOAD_XSIM_PASS
C3_MASTER_CLAIM=NO BOARD_PASS=REJECT
```

C2 KEEP reached w0=35 with 12 AXI commits (`|rew|<=3`, distinct 20-bit identities), then `persist_clr`, C3 `rst_n` (flush w0=0), `reload_i` restored journaled w0=35.

## Quality bound (do not promote)

Evidence class **XSIM** compact TB-AXI. Not MIG PHY, not 800k, not silicon.
C2 KEEP journals **w0 only**. `w[1:31]` were TB-restored from the pre-flush snapshot. That is a KEEP-limit bound, not a host scorer.
This is **not** Master §9 close (no board microexam, no auditor hunt).

## KEEP

No C0/C1/C2 KEEP file edited. C3 wrap not edited.
