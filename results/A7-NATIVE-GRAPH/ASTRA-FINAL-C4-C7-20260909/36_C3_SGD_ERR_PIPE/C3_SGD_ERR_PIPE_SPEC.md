# C3 SGD `err_reg` pipe (named family `c3_sgd_err`)

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**.  
E3AB=**DO_NOT_START**. Do **not** modify D32 / `a7ng_astra_c4_lm06_d32_fr_v2.sv`.  
Do **not** edit `a7ng_astra_c3_held_out_pendld.sv` in this gate. Do not start E3ab.

This is the **new written plan** required after `33_C6_WHOLECHIP_FINAL_V1/C6_NAMED_FAMILY_SGD_ERR.md`.

## Trigger (FACT from C6 wholechip_final_v1 post-route after `c3_pend_phi`)

```text
WNS              -0.525 ns
TNS              -7.554 ns
WHS              +0.031 ns   (hold MET)
THS              0
unrouted         0
DRC              0
clock            clk_pll_i / ui_clk period 12.000 ns
n20              15/20 dest u_c5/u_c3/u_sgd/err_reg[*]/D
                 5/20 dest u_c5/u_c3/pp1_reg[2][*]/R
worst            u_sgd/acc_reg[39] → u_sgd/err_reg[10]
levels           24  (CARRY4=18 LUT1=1 LUT2=2 LUT3=3)
data path        12.447 ns vs 12.000 ns
logic / route    6.454 ns (52%) / 5.993 ns (48%)
n20 SHA256       a8f53e00960386a1c35d179a0d47c223624817b3537d9c711ceacc0fc6309642
```

`pend_phi_reg` is off this top-20. This cone is not D32 `rq_snap`. Prior `c3_sgd_w` (`w_reg`) is off this top-20.

Same-cycle LATCH does `v_sat <= clamp768(rsh40(acc,7))` and `err <= clamp_err(rew*256 - v_comb)`. STA dest is `err_reg` from `acc_reg`. Splitting `err` onto a later cycle that reads registered `v_sat` breaks that concat.

## Law (integer KEEP, extra cycles allowed)

Module: `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` only.

```text
IDLE / SNAP / SCORE / UPD_MUL / UPD_SHF / UPD_WR / DONE   KEEP
LATCH:      v_sat <= clamp768(rsh40(acc,7));   ST LATCH_ERR
LATCH_ERR:  err   <= clamp_err(rew*256 - sext(v_sat));
            i<=0; ST do_upd ? UPD_MUL : DONE
```

Same `rsh40` / `sat16` / `clamp768` / `clamp_err` / SHIFT / N. Do not patch `a7ng_shared_rank_sgd_q8.sv`. Do not edit C3 `fphi` / `pendld` / D32.

C3 already waits on `sgd_done` (`S_SW` / `S_UW`). Extra `LATCH_ERR` cycle is allowed. Walk `TO_CYC` is not this wait.

## GOLDEN (required before another C6 impl)

Same host twin as `c3_sgd_w` (integer must not change) + XSim of this DUT:

- zero-weight score v=0
- 16× update x=64 rew=+3, then score
- mixed `x` / loaded `w` one update: every `w_o[k]` match
- freeze: `go_upd` does not change `w`

Marker: `ASTRA_C3_SGD_ERR_PIPE_XSIM_PASS`. XSim is **not** MASTER / BOARD_PASS.

## After the next C6 post-route

Classify vs this miss (−0.525 / `err_reg` 15/20). Do **not** auto-start the next pipe in that classify run. E3ab remains DO_NOT_START. `write_bitstream` only if WO §19 letters hold. Do not program.
