# PREREG — ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RELOAD-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, live
`a7ng_astra_c3_held_out.sv`, official `mig.prj`, or TinyGPT.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
Does not self-stamp `C3_MASTER` or `BOARD_PASS`.

## One unknown

After arm-A train on the 800k cartesian 2-hop ctx-k0 overlay, on a bag-local
copy of **live polarity-CONFLICT C3**, does `persist_clr` + C3 `rst_n` flush,
then C2 KEEP `reload_i` from the AXI journal at `AWADDR=0x06000000`, restore
held-out gold-hit accuracy with drop ≤5pp, with **zero** false `ST_CONFLICT=5`
on this overlay (no planted negative polarity)?

## HIT letter this bag may measure (XSim TB-AXI 800k 2-hop + C2 w0)

```text
CLASS_entities_disjoint train={13,15,16} hold={19,20}
CLASS_flush_w0_zero
CLASS_c2_persist_reload / CLASS_c2_w0_match
CLASS_awaddr_06000000
CLASS_host_winner_zero
CLASS_retention_le5pp drop<=5
CLASS_no_false_conflict n_conf=0
```

Four-arm gain is out of scope (closed on CONFLICT-RTL-01). MIG PHY and silicon
microexam are out of scope.

## Quality bound (frozen here, not after scores)

C2 KEEP journals one 16-bit `w0`. `w[1:31]` TB-restored after C2 reload of w0.
DUT is bag-local `a7ng_astra_c3_held_out_nb64k` copied from live CONFLICT C3
(`N_BUCKETS=65536`, `MAX_PATH=16`). Modeled AXI, not MIG.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- GOLDEN edited after xvlog
- PROGRAM=YES
- live C3 wrap edited as KEEP
