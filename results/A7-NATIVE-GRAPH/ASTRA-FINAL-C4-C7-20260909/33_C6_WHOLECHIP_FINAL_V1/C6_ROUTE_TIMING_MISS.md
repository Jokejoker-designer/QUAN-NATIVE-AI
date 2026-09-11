# C6 post-route TIMING_OR_FIT miss (not a freeze)

**PROGRAM=NO.** No bitstream. E3AB=DO_NOT_START. Do not modify D32 for this miss.

## Letters (routed `a7ng_astra_c6_wholechip_final_v1`)

```text
WNS = -9.462 ns
TNS = -9703.347 ns
WHS = +0.004 ns
THS = 0
unrouted = 0
DRC errors = 0
critical unconstrained = 0
clock = clk_pll_i / ui_clk period 12.000 ns
```

Hold MET. Device routed. Setup FAIL. `write_bitstream` correctly skipped.

Synth DCP exists: `c6_synth.dcp`. Place PASS. Route completed with timing miss.

## Top-20 dest (20/20)

`u_c5/u_c3/u_sgd/w_reg[*][*]/D`

Source example: `u_c5/u_c3/pc1_reg` → C3 SGD `w_reg`. Logic levels 28 (CARRY4=15, DSP=1). Data path ~21.3 ns vs 12 ns.

This is **not** D32 `rq_snap`. E3aa OOC WNS +1.052 ns does not cover this cone. Do not start E3ab.

Named family for the next written plan: **`c3_sgd_w`**. Started: `34_C3_SGD_W_PIPE/C3_SGD_W_PIPE_SPEC.md`. E3AB still DO_NOT_START. Do not modify D32.
