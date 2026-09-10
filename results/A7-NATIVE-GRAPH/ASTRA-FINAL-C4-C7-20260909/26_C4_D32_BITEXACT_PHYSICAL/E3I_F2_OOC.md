# E3i_F2 OOC readout — S_F2-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_DOT` was not touched.

| Item | E3i | E3i_F2 |
|------|-----|--------|
| WNS | −19.828 ns | **-17.556 ns** |
| TNS | −24375.930 ns | -23918.976 ns |
| Failing endpoints | 1965 | 1949 |
| Top-20 family | zv_wdata 16, dots 4 | {'dots': 20} |
| Worst logic levels | 49 | 39 |
| Worst CARRY4 / DSP48E1 | 35 / 4 | 25 / 4 |

Worst: `kv_reg[23][31][15]/C` → `dots_reg[0][27]/D`.

## Case B — `path_cut_new_family`

zv_wdata left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3i: **2.2719999999999985 ns**. Next gate: `E3j_dots`.

`timing_n20_e3i_f2.rpt` SHA256 `7f695acde2875ace0608482aa215c9eebe0d0b5021de67d27af9089dd0180bb3`. Does **not** overwrite prior n20.

| Resource | E3i | E3i_F2 |
|----------|-----|--------|
| Slice LUTs | 29535 | 29528 |
| Slice Registers | 42771 | 42747 |
| DSP | 49 | 40 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
