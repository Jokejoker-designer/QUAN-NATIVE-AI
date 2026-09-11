# E3p OOC readout — di-indexed acc product pipeline (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. S_F2 was not pipelined.

Parser note: `hacc_reg` must be matched **before** `acc_reg` (`hacc_reg` contains the substring `acc_reg`). Correct family is **hacc 20**.

| Item | E3o | E3p |
|------|-----|-----|
| WNS | −5.957 ns | **−5.220 ns** |
| TNS | −1884.503 ns | −1900.469 ns |
| Failing endpoints | 620 | 1024 |
| Top-20 family | acc 20 | **hacc 20** (acc 0) |
| Worst logic levels | 27 | 23 |
| Worst CARRY4 / DSP48E1 | 17 / 1 | 12 / 2 |

Worst: `vv_reg[23][30][15]/C` → `hacc_reg[63]/D`.

## Case B — `path_cut_new_family`

`di`→`acc` left top-20. WNS Δ vs E3o: **+0.737 ns** (slight; TNS/failing worse — not a cut fail). Path-cut PASS. Next: **`E3q_hacc` only**.

`timing_n20_e3p.rpt` SHA256 `21c39d9e2079a1860db1c42194613b86a8caf93fc932ea42377bb0cdff32201b`. E3o n20 SHA `5d0ae12db047…` intact.

| Resource | E3o | E3p |
|----------|-----|-----|
| Slice LUTs | 28453 | 27706 |
| Slice Registers | 42940 | 42989 |
| DSP | 19 | 19 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 200 | 200 |
