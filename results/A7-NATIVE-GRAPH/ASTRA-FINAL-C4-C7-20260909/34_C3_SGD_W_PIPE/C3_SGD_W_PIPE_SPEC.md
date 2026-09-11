# C3 SGD `w_reg` pipe (named family `c3_sgd_w`)

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**.  
E3AB=**DO_NOT_START**. Do **not** modify D32 / `a7ng_astra_c4_lm06_d32_fr_v2.sv`.

This is the **new written plan** required after `33_C6_WHOLECHIP_FINAL_V1/C6_ROUTE_TIMING_MISS.md`. It does not authorize programming, freeze, MASTER, or E3ab.

## Trigger (FACT from C6 wholechip_final_v1 route)

```text
WNS              -9.462 ns
TNS              -9703.347 ns
WHS              +0.004 ns   (hold MET)
THS              0
unrouted         0
DRC              0
clock            clk_pll_i / ui_clk period 12.000 ns
top-20 dest      u_c5/u_c3/u_sgd/w_reg  20/20
worst            u_c3/pc1_reg → u_sgd/w_reg
levels           28  (CARRY4=15 DSP48E1=1)
data path        21.318 ns vs 12.000 ns
```

Cone (STA, not a false-path claim): C3 combo `fphi(pc1)` into SGD `x_i`, then `prod_ud = err * x_i[ji]`, then `rsh40` / `sat16` into `w[ji]` in the same `UPD` cycle.

This is **not** D32 `rq_snap` / `smres`. E3aa OOC WNS +1.052 ns does not cover this cone.

## Law (integer KEEP, extra cycles allowed)

Module: `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` only.

```text
IDLE:     load_w KEEP
          go_score|go_upd → snap x_r[k] <= x_i[k]; acc<=0; i<=0;
                   do_upd <= go_upd && !freeze; rew <= reward; ST SNAP
SNAP:     ST SCORE                         // x_r valid; SCORE/UPD never sample x_i
SCORE:    KEEP acc <= acc + sext(w[ji]*x_r[ji]); last i → LATCH else i++
LATCH:    KEEP v_sat <= clamp768(rsh40(acc,7));
               err   <= clamp_err(rew*256 - v);
               i<=0; ST do_upd ? UPD_MUL : DONE
UPD_MUL:  prod_ud_r <= err * x_r[ji];  w_snap <= w[ji];  ST UPD_SHF
UPD_SHF:  dw40_r    <= rsh40(sext(prod_ud_r), 7+SHIFT); ST UPD_WR
UPD_WR:   w[ji]     <= sat16(w_snap + dw40_r[15:0]);     // same truncate as old dw_se
          last i → DONE else i++; ST UPD_MUL
DONE:     KEEP v_q8_o <= v_sat; done_o<=1; ST IDLE
```

Same `rsh40` / `sat16` / `clamp768` / `clamp_err` as the pre-pipe module. Do not change SHIFT, N, freeze, or load. Do not patch `a7ng_shared_rank_sgd_q8.sv`. Do not edit C3 `fphi` / `pendld` in this gate.

C3 already waits on `sgd_done` (`S_SW` / `S_UW`). Extra latency is allowed. Walk `TO_CYC=64` is not the SGD wait.

## GOLDEN (required before another C6 impl)

Host twin + XSim of `a7ng_shared_rank_sgd_q8_sym_f2r2` only:

- zero-weight score v=0
- ASTRA-06-style 16× update x=64 rew=+3, then score (integer match twin)
- mixed `x` / loaded `w` one update: every `w_o[k]` match
- freeze: `go_upd` does not change `w`

Marker: `ASTRA_C3_SGD_W_PIPE_XSIM_PASS`. XSim is **not** C5_MASTER / C6_MASTER / BOARD_PASS.

## After the next C6 post-route

Classify vs this miss (−9.462 / `w_reg` 20/20):

- A/B: `c3_sgd_w` / `w_reg` still top-20 → record the new named family. Do **not** auto-start the next pipe in the same run.
- C: still `pc1`→`w_reg` 20/20 and ΔWNS < ~0.15 → STOP local SGD pipes; new written plan.
- MIXED: read `timing_n20_route.rpt`.

`write_bitstream` only if WO §19 letters hold. Do not program. Do not freeze. OOC/XSim PASS is still **not** WO §19.
