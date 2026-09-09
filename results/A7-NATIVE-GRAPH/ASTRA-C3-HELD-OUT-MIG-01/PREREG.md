# PREREG — ASTRA-C3-HELD-OUT-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, F3R4 RTL, SGD KEEP,
official Digilent `mig.prj`, `ddr3_model`, or `mig_native_wrap`.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
Does not relabel A09R8 `w0 0→-5` or compact TB-AXI `ASTRA-C3-HELD-OUT-01` as this bag.

## One unknown

After `init_calib_complete`, does the same 5-seed 4-arm disjoint held-out protocol
as compact C3 still measure `gain(A over B) >= 10 pp` when directory/posting/fact
AXI goes through official Digilent AXI MIG (`mig_7series_0_mig_sim` + `ddr3_model`)
instead of a 96-slot TB slave?

DUT is instantiate of existing `a7ng_astra_c3_held_out` with `TO_CYC=65535`
(16-bit fact-fetch ceiling; default 64 is a compact-slave bound, not KEEP).
KEEP files are not edited.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
seeds = 5
arms A/B/C/D all run
train subjects {10,11,1} ∩ hold subjects {6,9} = empty
gain(A over B) >= 10 pp   (CLASS_gain_A_over_B)
A > shuffled-reward arm
host winner / addr / load_from_tb = 0
ISO SGD KEEP: x=50 rew=3 → dw=+5
```

Planted 2-hop facts remain bag-local (written through MIG AW, not a TB mem array).
800k cartesian corpus is **out of scope**. Silicon microexam is **out of scope** (C7).
This bag must not self-stamp `C3_MASTER=CLOSED` or `BOARD_PASS`.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- official `mig.prj` hash drifts
- C0 `a7ng_query_axi_sparse.sv` compiled as DUT
- STREAM-02 / ctx `8255a798` / leftover A09 / `tiny_gpt803k_core` compiled as DUT
- synth `mig_7series_0_mig.v` compiled instead of `mig_7series_0_mig_sim.v`
- GOLDEN edited after xvlog
- PROGRAM=YES
- A09R8 used as transfer evidence
