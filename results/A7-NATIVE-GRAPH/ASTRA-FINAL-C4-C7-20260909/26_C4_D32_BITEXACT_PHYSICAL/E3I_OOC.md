# E3i OOC readout — S_F1-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_Y`/`S_F2`/`S_EMB`/`S_DOT` were not touched.

| Item | E3f_S_Q | E3i |
|------|---------|-----|
| WNS | −20.614 ns | **-19.828 ns** |
| TNS | −51896.881 ns | -24375.93 ns |
| Failing endpoints | 3531 | 1965 |
| Top-20 family | f1_rq/val0 20/20 | {'zv_wdata': 16, 'dots': 4} |
| Worst logic levels | 45 | 49 |
| Worst CARRY4 / DSP48E1 | 30 / 7 | 35 / 4 |

Worst: `dj_reg[4]/C` → `zv_wdata_reg[0]/D`.

## Case B — `path_cut_new_family`

f1_rq/val0 left top-20; WNS only slight/flat. E3i still PASS as a path cut. Target the new named family. Do not mass-refactor remaining c4_rq sites.

WNS Δ vs E3f_S_Q: **0.7860000000000014 ns**. Next gate: `E3i_F2`.

`timing_n20_e3i.rpt` SHA256 `9ad79a877b896ac071c696272d257a4cbd37391952ff0fec600668989b63cc57`. Does **not** overwrite E3a/E3d/E3e/E3g/E3f/E3h/E3f_sq.

| Resource | E3f_S_Q | E3i |
|----------|---------|-----|
| Slice LUTs | 29908 | 29535 |
| Slice Registers | 42798 | 42771 |
| DSP | 56 | 49 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
