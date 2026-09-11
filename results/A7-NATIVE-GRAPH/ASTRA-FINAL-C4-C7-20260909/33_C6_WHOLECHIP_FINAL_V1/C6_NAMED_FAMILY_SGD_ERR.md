# C6 post-route after `c3_pend_phi` — named family (do not auto-start)

```text
NO BOARD PASS
NO C6 FREEZE
PROGRAM=NO
C4_MASTER=OPEN
C5_MASTER=OPEN
C6_MASTER=OPEN
ASTRA_NATIVE_AI_BOARD_PASS=NOT_EVIDENCED
E3AB=DO_NOT_START
auto_start_next_pipe=false
```

DUT SHA256 `1330A66B235194E8027535531E23E45C423B90DD9BD3BB85EA5151142C735D09` (`a7ng_astra_c3_held_out_pendld.sv`). Overlay SHA `60d04e254b582b6e7d12f0e2247b953e615d3e57` ([PR #6](https://github.com/Jokejoker-designer/QUAN-NATIVE-AI/pull/6)).

## This run

```text
C6_SYNTH     = PASS          (elapsed 00:45:22, 0 errors, checksum 6b50e3a6)
C6_PLACE     = PASS          (elapsed 00:06:58, 0 errors)
C6_ROUTE     = COMPLETED     (route_design completed successfully, elapsed 00:11:00)
C6_POSTROUTE = SETUP_MISS
C6_POST_ROUTE_PHYSICAL = NOT_PASS
write_bitstream = skipped
bit = none
```

Letters (`ROUTE_LETTERS.txt`, Design State Routed, `clk_pll_i` 12.000 ns):

```text
WNS=-0.525
TNS=-7.554
WHS=0.031
THS=0.000
UNROUTED=0
FAILED_ROUTE=0
DRC_ERROR_FATAL=0
CRITICAL_UNCONSTRAINED=0
FIT_OK=0
```

Hold MET. Setup FAIL. `TNS` failing endpoints = 33 (intra `clk_pll_i`). No `.bit`.

Prior completed post-route (after `c3_sgd_w`, before this `c3_pend_phi` synth): WNS −5.654 / TNS −1946.522, n20 dest **20/20** `pend_phi_reg`. That family is **off this top-20**.

## n20 (SHA256 `a8f53e00960386a1c35d179a0d47c223624817b3537d9c711ceacc0fc6309642`)

- **15/20** dest `u_c5/u_c3/u_sgd/err_reg[*]/D`. Source `u_sgd/acc_reg[39]/C`. 24 levels (CARRY4=18). Datapath 12.447 ns vs 12.000 ns. Logic 6.454 ns (52%) / route 5.993 ns (48%). Family **`c3_sgd_err`**. RTL: `err <= clamp_err(rew_se * 256 - v_se)` from 40-bit `acc` in `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`.
- **5/20** dest `u_c5/u_c3/pp1_reg[2][*]/R` (sync reset, not D). Source `ej_reg[1]_rep__0`. Slack −0.198 … −0.186 ns. Family **`c3_pp1`**. Not the closed `pend_phi_reg` D-pin family.

Top family **`c3_sgd_err`**. Not D32 `rq_snap`. Not `c3_sgd_w` (`w_reg`). `auto_start_next_pipe=false`. E3ab DO_NOT_START.

Next gate requires a **new written plan**. This file records the family only. Do not start `c3_sgd_err` pipe in the same classify run. Do not start E3ab.
