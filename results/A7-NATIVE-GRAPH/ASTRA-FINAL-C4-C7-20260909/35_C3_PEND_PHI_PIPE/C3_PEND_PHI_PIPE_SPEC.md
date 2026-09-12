# C3 `pend_phi` pick-commit pipe (named family `c3_pend_phi`)

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**.  
E3AB=**DO_NOT_START**. Do **not** modify D32 / `a7ng_astra_c4_lm06_d32_fr_v2.sv`.  
Do **not** edit `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` in this gate.

This is the **new written plan** required after `33_C6_WHOLECHIP_FINAL_V1/C6_NAMED_FAMILY_PEND_PHI.md`. Overlay SHA `6531040732cceb4a71f89174a5d5660967f1f88f`.

## Trigger (FACT from C6 wholechip_final_v1 post-route)

```text
WNS              -5.654 ns
TNS              -1946.522 ns
WHS              +0.028 ns   (hold MET)
THS              0
unrouted         0
DRC              0
clock            clk_pll_i / ui_clk period 12.000 ns
top-20 dest      u_c5/u_c3/pend_phi_reg  20/20
worst            u_c3/pp1_reg[0][8] → pend_phi_reg[5][6]
levels           23  (CARRY4=7)
data path        17.615 ns vs 12.000 ns
logic / route    4.798 ns (27%) / 12.817 ns (73%)
```

Cone: 4-way `c_best_*` (pv / pp0 / pp1) into mux `phis[c_best_idx]` → `pend_phi`. Not D32 `rq_snap`. `c3_sgd_w` left top-20.

Path nets (same report): `best_a*` / `sel_idx*` / `c_best_v32_in` arrive ~16.5 ns **before** `pend_phi[*]_i_*` mux. Mux-only `S_COMMIT` would leave the compare over 12 ns. This revision deletes the 4-way combo and serializes one slot per cycle.

## Law (integer KEEP, extra cycles allowed)

Module: `rtl/native_graph/integrate/a7ng_astra_c3_held_out_pendld.sv` only.

Do not change `fphi`, path build, SGD, `bank_r`, alias boot.

Add `S_COMMIT` then `S_CMP` at the **end** of the enum (do not renumber `S_PICK` / `S_HOLD` / `S_UW`).

```text
S_SW last path → S_PICK

S_PICK:  incumbent = slot 0 (or NEG if np==0)
         k_r <= 1
         if np<=1 ST S_COMMIT else ST S_CMP

S_CMP:   better = pv[k_r] > v_best
                || (eq pv && pp0[k_r] < best_p0)
                || (eq pv && eq pp0 && pp1[k_r] < best_p1)
         if better: incumbent <= slot k_r; v_second <= old v_best
         else if pv[k_r] >= v_second: v_second <= pv[k_r]
         if k_r+1 >= np ST S_COMMIT else k_r++

S_COMMIT: sel_idx   <= idx_r
          best_src  <= psrc[idx_r]
          best_dst  <= pdst[idx_r]
          pend_phi[k] <= phis[idx_r][k]
          r_st / proof_ok / pend_id / txn / gen / pend_acc / pend_cmt  KEEP
          ST S_HOLD
```

`result_v_o` stays `(st==S_HOLD)`. C5 `ST_WAITQ` waits `c3_res` (that signal), not a 1-cycle assumption. Extra `S_CMP`/`S_COMMIT` cycles are allowed. `TO_CYC` is AXI fetch, not this wait.

## GOLDEN (required before another C6 impl)

Host twin of the same better() law + XSim of the real C3 DUT (hierarchical **deposit** into `S_PICK`, wait `S_HOLD`). Do **not** `force st`: force suppresses NBA.

- np=1
- higher `pv` wins
- `pv` tie → smaller `pp0`
- `pv`+`pp0` tie → smaller `pp1`
- np=4 mixed
- `pend_phi` equals `phis[winner]` (distinct per-slot vectors)

Marker: `ASTRA_C3_PEND_PHI_PIPE_XSIM_PASS`. XSim is **not** MASTER / BOARD_PASS.

## After the next C6 post-route

Classify vs this miss (−5.654 / `pend_phi` 20/20). Do **not** auto-start the next pipe in that classify run. E3ab remains DO_NOT_START. `write_bitstream` only if WO §19 letters hold. Do not program.
