# E3h OOC readout — S_H-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_Q` was not touched.

| Item | E3f | E3h |
|------|-----|-----|
| WNS | −22.550 ns | **-23.364 ns** |
| TNS | −63996.180 ns | -45067.714 ns |
| Failing endpoints | 4406 | 3050 |
| Top-20 family | hv 20/20 | {'qv_wdata': 20} |
| Worst logic levels | 46 | 48 |
| Worst CARRY4 / DSP48E1 | 28 / 3 | 31 / 4 |

Worst: `di_reg[4]/C` → `qv_wdata_reg[10]/S`.

## Case B — `path_cut_new_family`

hv left top-20; WNS only slight/flat. E3h still PASS as a path cut. Target the new named family. Do not mass-refactor remaining c4_rq sites.

WNS Δ vs E3f: **-0.8140000000000001 ns**. Next gate: `E3f_S_Q`.

`timing_n20_e3h.rpt` SHA256 `1674be5d538b6d3d10826bb1b3a2ea7307e11cdcd0e808fd3b96d23bdb95d907`. Does **not** overwrite E3a/E3d/E3e/E3g/E3f.

| Resource | E3f | E3h |
|----------|-----|-----|
| Slice LUTs | 30815 | 30352 |
| Slice Registers | 42817 | 42723 |
| DSP | 74 | 70 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
