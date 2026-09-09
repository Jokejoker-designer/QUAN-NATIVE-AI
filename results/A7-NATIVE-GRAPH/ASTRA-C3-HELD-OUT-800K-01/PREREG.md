# PREREG — ASTRA-C3-HELD-OUT-800K-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, SGD KEEP,
official Digilent `mig.prj`, or compact/MIG C3 bags.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.

## One unknown

Does the same 5-seed 4-arm disjoint held-out protocol still measure
`gain(A over B) >= 10 pp` when directory/postings come from the N=800000
cartesian procedural image and C3 fact fetches use closed-form `fact_pack`
at `FACT_BASE=0x0E000000` (outside gen_800k post-heap), not a 96-slot planted
TB memory?

DUT is instantiate of existing `a7ng_astra_c3_held_out` with `TO_CYC=65535`
and `FACT_BASE=0x0E000000`. KEEP files are not edited.

## HIT letter this bag may measure (XSim TB-AXI 800k)

```text
CLASS_entities_disjoint train={13,15,16} hold={19,20}
seeds = 5
arms A/B/C/D all run
gain(A over B) >= 10 pp
A > shuffled-reward arm
host winner / addr / load_from_tb = 0
ISO SGD KEEP: x=50 rew=3 → dw=+5
```

MIG PHY and silicon microexam are **out of scope**. Quality bound: 1-hop
`"<entity> feeds"` queries (no `indirect`), cartesian occupancy truncated by
CAND_CAP=16, gold nid = first of 16 with `nid%16==9` (conf 200 vs 40).
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as transfer evidence
