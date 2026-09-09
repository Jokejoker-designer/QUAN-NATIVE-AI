# PREREG — ASTRA-C3-HELD-OUT-800K-2HOP-MUT-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP or KEEP C3 wrap.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C3_MASTER`.

## One unknown

After positive-reward train on the 800k cartesian 2-hop ctx overlay, does
mutating the overlay (delete hop2 / replace gold dest / query reverse
subject with empty ctx-key) change C3 status/destination the way Master
causal-mutation requires?

## HIT letter this bag may measure (XSim TB-AXI)

```text
CLASS_entities_disjoint train={13,15,16} hold={19}
CLASS_base_two_hop ans=28 p1=64617
CLASS_edge_delete → UNKNOWN (not dest 28)
CLASS_edge_replace → ANSWER dest=45 p1=64633
CLASS_edge_reverse "header feeds indirect" → UNKNOWN
CLASS_host_winner_zero
```

MIG PHY and silicon are out of scope. Quality bound: same ctx-k0 overlay
as `ASTRA-C3-HELD-OUT-800K-2HOP-01`; reverse is empty k0 for header=14,
not a stored reverse chain.

## FAIL if

- KEEP hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- bag claims C3_MASTER closed
