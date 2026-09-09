# PREREG — ASTRA-C3-HELD-OUT-800K-RELOAD-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, SGD KEEP,
official Digilent `mig.prj`, compact C3, or KEEP `a7ng_astra_c3_held_out.sv`.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
Does not relabel A09R8 `w0 0→-5` as retention.

## One unknown

After arm-A train on the 800k cartesian 2-hop ctx-k0 overlay image (same DUT
and facts as `ASTRA-C3-HELD-OUT-800K-2HOP-01`), does `persist_clr` + C3 `rst_n`
flush, then C2 KEEP `reload_i` from the AXI journal at `AWADDR=0x06000000`,
restore held-out gold-hit accuracy with drop ≤5pp?

## HIT letter this bag may measure (XSim TB-AXI 800k 2-hop + C2 w0)

```text
seeds = 5
train subjects {13,15,16} ∩ hold subjects {19,20} = empty
queries = "<entity> feeds indirect" (ctx=2)
C2 journal AWADDR = 0x06000000
after clr+rst: C3 w0 = 0 (flush)
after C2 reload: persist_w0 == snapped C3 w0
retention drop = (acc_pre - acc_post) * 100 / 8  per seed, and overall
drop <= 5 percentage points
host winner / addr / load_from_tb = 0
```

Four-arm gain is **out of scope** (closed as XSim on `ASTRA-C3-HELD-OUT-800K-2HOP-01`).
MIG PHY and silicon microexam are **out of scope**.

## Quality bound (frozen here, not after scores)

C2 KEEP `a7ng_astra_c2_persist_commit` journals **one** 16-bit `w0` in a 128-bit
beat. It cannot store the other 31 SGD weights. This bag:

1. Drives C2 KEEP commits (distinct 20-bit identities, `|rew|<=3`) until
   `live_w0` equals the measured C3 `w[0]`, so the journal payload is produced
   by C2 KEEP AXI write, not a TB-forged beat.
2. Restores `w[0]` from `persist_w0_o` after `persist_clr` + `reload_i`.
3. Restores `w[1:31]` from a TB snapshot taken **before** flush (KEEP limit,
   not a host scorer).

Corpus is 800k cartesian `fact_pack` + ctx-folded k0 overlay through bag-local
`a7ng_axi_mem_c3_800k_2hop`, not production MIG/DDR.
DUT is bag-local `a7ng_astra_c3_held_out_nb64k` (`N_BUCKETS=65536`).
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` compiled as DUT
- KEEP `a7ng_astra_c3_held_out.sv` edited
- C2 KEEP edited
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as retention evidence
