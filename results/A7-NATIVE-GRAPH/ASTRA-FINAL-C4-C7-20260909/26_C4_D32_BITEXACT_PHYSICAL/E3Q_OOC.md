# E3q OOC readout — S_H hacc product pipeline (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3p | E3q |
|------|-----|-----|
| WNS | −5.220 ns | **−4.089 ns** |
| TNS | −1900.469 ns | −1556.346 ns |
| Failing endpoints | 1024 | 627 |
| Top-20 family | hacc 20 | acc 13, smres/elut 7 |
| Worst logic levels | 23 | 24 |
| Worst CARRY4 / DSP48E1 | 12 / 2 | 17 / 1 |

Worst: `fi_reg[5]/C` → `acc_reg[63]/D` (S_F2 last-`fi` MAC, previously deferred).

## Case B — `path_cut_new_family`

`hacc` left top-20 (0/20). WNS Δ vs E3p: **+1.131 ns** (slight; TNS/failing improved). Path-cut PASS. Next: **`E3r` S_F2 `fi`→`acc` only**. Do not re-touch Q/K/V/DOT `di` MAC.

`timing_n20_e3q.rpt` SHA256 `413baf840789e9898e7615bcac0a19a4532a6942329351b6c4886a07e4bc52ac`. E3p n20 SHA `21c39d9e2079a186…` intact.

| Resource | E3p | E3q |
|----------|-----|-----|
| Slice LUTs | 27706 | 27573 |
| Slice Registers | 42989 | 42979 |
| DSP | 19 | 17 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 200 | 200 |
