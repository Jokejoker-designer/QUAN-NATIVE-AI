# E3k OOC readout — S_EMB-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_Y` was not touched.

| Item | E3j | E3k |
|------|-----|-----|
| WNS | −16.734 ns | **-15.041 ns** |
| TNS | −19812.107 ns | -9485.734 ns |
| Failing endpoints | 1735 | 1125 |
| Top-20 family | x_wdata 20 | {'rq_snap': 20} |
| Worst logic levels | 41 | 38 |
| Worst CARRY4 / DSP48E1 | 24 / 2 | 23 / 5 |

Worst: `x_reg[6][18][15]/C` → `rq_val_r1__1/A[0]`.

## Case B — `path_cut_new_family`

x_wdata left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3j: **1.6930000000000014 ns**. Next gate: `E3l_S_Y`.

Cone (FACT, not dest-pin family): all 20 paths are `x_reg[*]` → `yv_reg[31][*]_i_*` CARRY4 → `rq_val_r1__1/A[*]`. That is the remaining combo `S_Y` `c4_rq` pulled into the S_F1 snapshot. Cut **S_Y only**. Do not pipeline `rq_val_r` as a separate site.

`timing_n20_e3k.rpt` SHA256 `cfff4e86c95752cca8ec50fc0c4ab9a13e328ce9f2143487d899d2739ab8f4f2`. Does **not** overwrite prior n20.

| Resource | E3j | E3k |
|----------|-----|-----|
| Slice LUTs | 29528 | 28501 |
| Slice Registers | 42869 | 42831 |
| DSP | 33 | 29 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
