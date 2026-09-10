# E3f OOC readout — S_K-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_Q` was not touched.

| Item | E3g | E3f |
|------|-----|-----|
| WNS | −22.718 ns | **-22.55 ns** |
| TNS | −60155.835 ns | -63996.18 ns |
| Failing endpoints | 3676 | 4406 |
| Top-20 family | kv_wdata 20/20 | {'hv': 20} |
| Worst logic levels | 48 | 46 |
| Worst CARRY4 / DSP48E1 | 31 / 4 | 28 / 3 |

Worst: `vv_reg[23][27][15]/C` → `hv_reg[0][0]/D`.

## Case B — `path_cut_new_family`

kv_wdata left top-20; WNS only slight/flat. E3f still PASS as a path cut. Target the new named family. Do not mass-refactor remaining c4_rq sites.

WNS Δ vs E3g: **0.16799999999999926 ns**. Next gate: `E3h_hv`.

`timing_n20_e3f.rpt` SHA256 `33fd344924687038640fd496efcb02b62c36b5f1478f661ed91c298756435ab0`. Does **not** overwrite E3a/E3d/E3e/E3g.

| Resource | E3g | E3f |
|----------|-----|-----|
| Slice LUTs | 31138 | 30815 |
| Slice Registers | 42734 | 42817 |
| DSP | 88 | 74 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
