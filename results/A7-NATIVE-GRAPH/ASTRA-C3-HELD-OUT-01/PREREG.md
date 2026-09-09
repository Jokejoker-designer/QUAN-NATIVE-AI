# PREREG — ASTRA-C3-HELD-OUT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, or SGD KEEP.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
Does not relabel A09R8 `w0 0→-5` or ASTRA-07 / F3R4 as this bag.

## One unknown

Does the shared 32-feature KEEP learner (`a7ng_shared_rank_sgd_q8_sym_f2r2`), on the
C1 synonym retrieve path (`a7ng_query_axi_sparse_intersect_synonym`), improve held-out
queries whose entities are disjoint from training, versus frozen / shuffled / per-ID?

## HIT letter this bag may measure (XSim compact TB-AXI)

```text
seeds = 5
arms A/B/C/D all run
train subjects {10,11,1} ∩ hold subjects {6,9} = empty
gain(A over B) >= 10 pp   (CLASS_gain_A_over_B)
A > shuffled-reward arm
host winner / addr / load_from_tb = 0
ISO SGD KEEP: x=50 rew=3 → dw=+5
```

Retention after persist reload is **out of scope** (`ASTRA-C3-HELD-OUT-RELOAD-01`).
Silicon microexam is **out of scope** (C7).

## Quality bound (frozen here, not after scores)

Corpus is TB-planted AXI postings, not production MIG/DDR/800k.
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.
Independent auditor reads raw `xsim.log`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as transfer evidence
