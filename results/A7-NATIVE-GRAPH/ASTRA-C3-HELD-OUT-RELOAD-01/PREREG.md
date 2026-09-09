# PREREG — ASTRA-C3-HELD-OUT-RELOAD-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, SGD KEEP,
or `a7ng_astra_c3_held_out.sv`.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
Does not relabel A09R8 `w0 0→-5` as retention.

## One unknown

After arm-A train on the C3 wrap (C1 synonym retrieve + 32-feature SGD KEEP),
does `persist_clr` + C3 `rst_n` flush, then C2 KEEP `reload_i` from the AXI
journal at `AWADDR=0x06000000`, restore held-out accuracy with drop ≤5pp?

## HIT letter this bag may measure (XSim compact TB-AXI)

```text
seeds = 5
train subjects {10,11,1} ∩ hold subjects {6,9} = empty
C2 journal AWADDR = 0x06000000 (not low16 identity)
after clr+rst: C3 w0 = 0 (flush)
after C2 reload: persist_w0 == snapped C3 w0
retention drop = (acc_pre - acc_post) * 100 / 8  per seed, and overall
drop <= 5 percentage points
host winner / addr / load_from_tb = 0
```

Four-arm gain is **out of scope** (closed as XSim on `ASTRA-C3-HELD-OUT-01`).
Silicon microexam is **out of scope** (C7).

## Quality bound (frozen here, not after scores)

C2 KEEP `a7ng_astra_c2_persist_commit` journals **one** 16-bit `w0` in a 128-bit
beat. It cannot store the other 31 SGD weights. This bag:

1. Drives C2 KEEP commits (distinct 20-bit identities, `|rew|<=3`) until
   `live_w0` equals the measured C3 `w[0]`, so the journal payload is produced
   by C2 KEEP AXI write, not a TB-forged beat.
2. Restores `w[0]` from `persist_w0_o` after `persist_clr` + `reload_i`.
3. Restores `w[1:31]` from a TB snapshot taken **before** flush (KEEP limit,
   not a host scorer).

Corpus is TB-planted AXI postings, not production MIG/DDR/800k.
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` compiled as DUT
- C2 KEEP edited
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as retention evidence
