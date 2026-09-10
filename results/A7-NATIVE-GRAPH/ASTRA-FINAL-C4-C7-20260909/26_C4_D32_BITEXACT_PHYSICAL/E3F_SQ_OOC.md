# E3f_S_Q OOC readout — S_Q-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Remaining combo `c4_rq` sites were not touched.

| Item | E3h | E3f_S_Q |
|------|-----|---------|
| WNS | −23.364 ns | **-20.614 ns** |
| TNS | −45067.714 ns | -51896.881 ns |
| Failing endpoints | 3050 | 3531 |
| Top-20 family | qv_wdata 20/20 | {'f1_rq': 20} |
| Worst logic levels | 48 | 45 |
| Worst CARRY4 / DSP48E1 | 31 / 4 | 30 / 7 |

Worst: `fi_reg[4]/C` → `val0/A[0]`.

## Case B — `path_cut_new_family`

qv_wdata left top-20; WNS only slight/flat. E3f_S_Q still PASS as a path cut. Target the new named family. Do not mass-refactor remaining c4_rq sites.

WNS Δ vs E3h: **2.75 ns**. Next gate: `E3i_F1`.

`timing_n20_e3f_sq.rpt` SHA256 `625ea9427a3145315a3d1f50f6599fe8d0cbddc9199c819e15333b3bfb5a01fc`. Does **not** overwrite E3a/E3d/E3e/E3g/E3f/E3h.

| Resource | E3h | E3f_S_Q |
|----------|-----|---------|
| Slice LUTs | 30352 | 29908 |
| Slice Registers | 42723 | 42798 |
| DSP | 70 | 56 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
