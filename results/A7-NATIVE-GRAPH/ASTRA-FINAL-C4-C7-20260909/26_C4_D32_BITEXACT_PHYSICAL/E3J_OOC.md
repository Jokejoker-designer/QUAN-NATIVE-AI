# E3j OOC readout — S_DOT-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_EMB` and `S_Y` were not touched.

| Item | E3i_F2 | E3j |
|------|--------|-----|
| WNS | −17.556 ns | **-16.734 ns** |
| TNS | −23918.976 ns | -19812.107 ns |
| Failing endpoints | 1949 | 1735 |
| Top-20 family | dots 20 | {'x_wdata': 20} |
| Worst logic levels | 39 | 41 |
| Worst CARRY4 / DSP48E1 | 25 / 4 | 24 / 2 |

Worst: `toks_reg[23][0]/C` → `x_wdata_reg[11]/D`.

## Case B — `path_cut_new_family`

dots left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3i_F2: **0.8219999999999992 ns**. Next gate: `E3k_S_EMB`.

`timing_n20_e3j.rpt` SHA256 `3e541a0dd26fcb57e0af2ba9b928613f38cfa193540985bde470901cdb711c16`. Does **not** overwrite prior n20.

| Resource | E3i_F2 | E3j |
|----------|--------|-----|
| Slice LUTs | 29528 | 29528 |
| Slice Registers | 42747 | 42869 |
| DSP | 40 | 33 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
