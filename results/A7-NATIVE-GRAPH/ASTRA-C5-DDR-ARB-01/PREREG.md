# PREREG — ASTRA-C5-DDR-ARB-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, `a7ng_lm_graph_arb.sv`,
official `mig.prj`, leftover A09, or frozen LM-06.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not C5.

## One unknown

Do six Master DDR client classes share **one** exclusive owner/arbiter such that
an in-flight transaction cannot change owner, dual-owner is 0, and ungranted
clients cannot drive the shared AXI AR channel?

## HIT letter this bag may measure (XSim modeled AXI)

```text
clients = idx_load, query_dir, desc_fetch, learn_rw, lm_dma, ckpt
one-hot grant / dual_err = 0
owner stable while req[owner] stays high (mid-flight other req blocked)
ungranted s_arvalid does not appear as m_araddr of that client
ckpt client uses AW/AR base 0x06000000
```

Production top unification is **out of scope** (`ASTRA-C5-PROD-TOP-01`).
MIG PHY is **out of scope**. This bag must not self-stamp `C5_MASTER=CLOSED`.

## Quality bound

Modeled 1-beat AXI AR slave, not Digilent MIG. Not whole-chip. Not BOARD.

## FAIL if

- KEEP hashes drift
- `a7ng_lm_graph_arb` edited
- synth `mig_7series_0_mig.v` compiled
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09 used as production top
