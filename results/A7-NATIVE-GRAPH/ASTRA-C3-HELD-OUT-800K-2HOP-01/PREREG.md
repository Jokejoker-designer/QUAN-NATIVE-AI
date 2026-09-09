# PREREG — ASTRA-C3-HELD-OUT-800K-2HOP-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, SGD KEEP,
official Digilent `mig.prj`, or compact/MIG/800k-1hop C3 bags.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.

## One unknown

Does the same 5-seed 4-arm disjoint held-out protocol still measure
`gain(A over B) >= 10 pp` when C3 walks **2-hop** (`r_two=1`) on the N=800000
cartesian `fact_pack` image, using ctx-folded directory keys
`k0={subj, ctx=2, rel_nibble=4}` that cartesian occupancy leaves empty?

DUT is bag-local `a7ng_astra_c3_held_out_nb64k` (`N_BUCKETS=65536`,
`MAX_PATH=16`, `TO_CYC=65535`, `FACT_BASE=0x0E000000`). KEEP C3 wrap is
not edited. Queries are `"<entity> feeds indirect"`.

## HIT letter this bag may measure (XSim TB-AXI 800k 2-hop)

```text
CLASS_entities_disjoint train={13,15,16} hold={19,20}
CLASS_two_hop_indirect  ctx=2 and proof1!=0 on frozen hold
seeds = 5
arms A/B/C/D all run
gain(A over B) >= 10 pp
A > shuffled-reward arm
host winner / addr / load_from_tb = 0
ISO SGD KEEP: x=50 rew=3 → dw=+5
```

MIG PHY and silicon microexam are **out of scope**. Quality bound: ctx-key
overlay (cartesian 1-hop keys unused); hops are cartesian SRO nids; gold dest
28 also exists as a 1-hop triple in the full image but is not in the ctx
posting; C3 uses `S_EJ` because the query contains `indirect`.
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as transfer evidence
