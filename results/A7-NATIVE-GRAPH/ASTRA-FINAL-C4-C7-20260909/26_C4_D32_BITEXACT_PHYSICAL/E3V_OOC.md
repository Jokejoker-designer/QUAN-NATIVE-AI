# E3v OOC readout — RQ ST_RND serial shift (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3u | E3v |
|------|-----|-----|
| WNS | −2.753 ns | **-2.598 ns** |
| TNS | −307.046 ns | -192.428 ns |
| Failing endpoints | 183 | 96 |
| Top-20 family | rq_q 15, smres_div 5 | {'smres_div': 3, 'prod_r': 17} |
| Worst logic levels | 38 | 21 |
| Worst CARRY4 / DSP48E1 | 33 / 0 | 10 / 0 |

Worst: `elut_reg[23][0]/C` → `u_smres_div/un_reg[31]/D`.

## Case B — `path_cut_new_family`

rq_q left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3u: **0.15500000000000025 ns**. Next gate: `E3w_smres_div`.

`timing_n20_e3v.rpt` SHA256 `c5b826332b0ce7ad6f6b0fdcc01d1ed6cd1c86c9b6e8dbb0188fa7fd88e6e382`. Does **not** overwrite prior n20.
