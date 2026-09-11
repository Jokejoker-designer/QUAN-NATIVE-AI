# E3w OOC readout — SMRES num/abs pipe (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3v | E3w |
|------|-----|-----|
| WNS | −2.598 ns | **-2.457 ns** |
| TNS | −192.428 ns | -147.021 ns |
| Failing endpoints | 96 | 88 |
| Top-20 family | smres_div 3, prod_r 17 | {'prod_r': 20} |
| Worst logic levels | 21 | 10 |
| Worst CARRY4 / DSP48E1 | 10 / 0 | 0 / 2 |

Worst: `vv_reg[23][30][15]/C` → `prod_r_reg[32]/D`.

## Case B — `path_cut_new_family`

smres_div left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3v: **0.14100000000000001 ns**. Next gate: `E3x_prod_r`.

`timing_n20_e3w.rpt` SHA256 `7160ef64b8a46aedea8a042b4718017c6055fc49345c407a5ea6c2687e35bd83`. Does **not** overwrite prior n20.
