# E3x OOC readout — S_H operand snap into prod_r (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3w | E3x |
|------|-----|-----|
| WNS | −2.457 ns | **-1.532 ns** |
| TNS | −147.021 ns | -101.238 ns |
| Failing endpoints | 88 | 88 |
| Top-20 family | prod_r 20 | {'prod_r': 20} |
| Worst logic levels | 10 | 10 |
| Worst CARRY4 / DSP48E1 | 0 / 2 | 0 / 1 |
| LUT / FF / DSP / BRAM | 27217 / 43255 / 12 / 0 | 26915 / 43308 / 12 / 0 |

Worst: `kv_reg[23][30][15]/C` → `prod_r_reg[31]/D`.

## Case MIXED — cone read: S_H `vv` left; S_DOT `kv` now 20/20

WNS Δ vs E3w **+0.925 ns**. Failing still 88. `prod_r` dest pin unchanged, **source cone changed** `vv`→`kv`. Rule 7: one extra structural cut **E3y S_DOT**. No E3z. stop_local_e3=false.

WNS Δ vs E3w: **0.925 ns**. Next gate: `E3y_S_DOT`.

`timing_n20_e3x.rpt` SHA256 `778e6a55838d379afcdf63d394fe621b499e391d7d06def8ed80d986285519b0`. Does **not** overwrite prior n20.
