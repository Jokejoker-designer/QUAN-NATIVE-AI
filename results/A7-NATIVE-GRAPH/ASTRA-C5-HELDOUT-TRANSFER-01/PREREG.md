# PREREG — ASTRA-C5-HELDOUT-TRANSFER-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, KEEP C3,
C4 adapters, C5 DDR arbiter, `a7ng_lm_graph_arb.sv`, leftover A09,
frozen LM-06 `tiny_gpt803k_core`, or official `mig.prj`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. Does not self-stamp `C5_MASTER`.

Plant stays in this TB. Observe ports `c3_ans_o`/`c3_p0_o`/`c3_p1_o` reused.

## One unknown

On the same C5 production hierarchy, does a frozen held-out query return
the low-conf 2-hop distractor, and after one learn-mode train query with
auto +3 reward, does the same held-out query return the high-conf dest?

## HIT letter this bag may measure (XSim modeled AXI)

```text
CLASS_entities_disjoint train={10} hold={6}
CLASS_heldout_pre  freeze "ahu connects indirect" ans=144 p0=256
CLASS_reward_update persist w0 changes after "pump requires indirect"
CLASS_heldout_post learn "ahu connects indirect" ans=112 p0=258
CLASS_heldout_changed pre != post
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
```

## Out of scope

CONFLICT opcode, MIG PHY, silicon, 90% TinyGPT, 800k.

## FAIL if

KEEP hashes drift, GOLDEN edited after xvlog, PROGRAM=YES, C5_MASTER claimed.
