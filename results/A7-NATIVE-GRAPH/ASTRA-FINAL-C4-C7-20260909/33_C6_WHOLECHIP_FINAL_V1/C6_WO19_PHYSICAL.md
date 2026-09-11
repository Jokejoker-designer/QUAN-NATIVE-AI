# C6 wholechip_final_v1 — WO §19 letters HOLD (not freeze, not MASTER)

```text
NO BOARD PASS
NO C6 FREEZE
PROGRAM=NO
C4_MASTER=OPEN
C5_MASTER=OPEN
C6_MASTER=OPEN
ASTRA_NATIVE_AI_BOARD_PASS=NOT_EVIDENCED
freeze_allowed=false
E3AB=DO_NOT_START
```

Marker `ASTRA_C6_WHOLECHIP_FINAL_V1_ROUTE_PASS`. `write_bitstream` completed. DRC 0 on bitstream. `open_hw` / `program_hw*` did not run.

## Letters (Design State Routed, `clk_pll_i` 12.000 ns)

```text
WNS=+0.273
TNS=0.000
WHS=+0.026
THS=0.000
UNROUTED=0
FAILED_ROUTE=0
DRC_ERROR_FATAL=0
CRITICAL_UNCONSTRAINED=0
FIT_OK=1
```

Intra-clock `clk_pll_i` in `timing_route.rpt`: WNS 0.273, TNS 0.000, WHS 0.026, THS 0.000, failing endpoints 0 / 119709. n20: **0** `Slack (VIOLATED)`. Worst MET: `u_sgd/i_reg[2]` → `acc_reg[38]`, +0.273 ns.

This is WO §19 **physical letters**. It is **not** §18 freeze, not `C6_MASTER`, not `ASTRA_NATIVE_AI_BOARD_PASS`.

## Same-run freeze SHA (before vivado)

```text
0a4e0e05…  a7ng_astra_c4_lm06_d32_fr_v2.sv
8c9aa81a…  a7ng_astra_c5_prod_top_final_v1.sv
7c7bf78e…  a7ng_astra_c6_wholechip_final_v1.sv
1330a66b…  a7ng_astra_c3_held_out_pendld.sv
9123c107…  a7ng_shared_rank_sgd_q8_sym_f2r2.sv
```

## Bit (do not program)

```text
file     a7ng_astra_c6_wholechip_final_v1.bit
size     3826012
SHA256   536ACBECB41F7A7E53D8160FDCF718856CC724AE21B3FFFF6B6D751E147E7935
```

`finish_c6_impl.py`: `freeze_allowed=false` (manifest dirty 497). C4/C5 remain OPEN. C7 queries NOT_FILLED. Do not invent a live set. Do not program this bit until §18 freeze + explicit `PROGRAM=YES` on this same SHA.

G14 remains **BLOCKED_PRE_BOARD**.
