# E3u OOC readout — di-indexed wgt8 operand pipe into prod_r (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3t | E3u |
|------|-----|-----|
| WNS | −2.766 ns | **-2.753 ns** |
| TNS | −369.748 ns | -307.046 ns |
| Failing endpoints | 351 | 183 |
| Top-20 family | prod_r 20 | {'rq_q': 15, 'smres_div': 5} |
| Worst logic levels | 11 | 38 |
| Worst CARRY4 / DSP48E1 | 1 / 1 | 33 / 0 |

Worst: `u_rq/shr_r_reg[4]/C` → `u_rq/q_r_reg[63]/D`.

## Case B — `path_cut_new_family`

prod_r left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3t: **0.0129999999999999 ns**. Next gate: `E3v_rq_q`.

`timing_n20_e3u.rpt` SHA256 `f32603c64771b5a372ff4c75fc12766926a23203209efd92aa86c9af71bfc90b`. Does **not** overwrite prior n20.
