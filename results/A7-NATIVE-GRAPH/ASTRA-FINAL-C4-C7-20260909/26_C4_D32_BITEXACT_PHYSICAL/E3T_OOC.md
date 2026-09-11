# E3t OOC readout — S_SMLUT delta_r then Lut (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3s | E3t |
|------|-----|-----|
| WNS | −3.755 ns | **-2.766 ns** |
| TNS | −1501.355 ns | -369.748 ns |
| Failing endpoints | 519 | 351 |
| Top-20 family | smres 20 | {'prod_r': 20} |
| Worst logic levels | 23 | 11 |
| Worst CARRY4 / DSP48E1 | 9 / 0 | 1 / 1 |

Worst: `di_reg[4]/C` → `prod_r_reg[23]/D`.

## Case B — `path_cut_new_family`

smres/elut left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only.

WNS Δ vs E3s: **0.9889999999999999 ns**. Next gate: `E3u_prod_r`.

`timing_n20_e3t.rpt` SHA256 `c31c8453d6ded7ce6b90519c2f604add45d7b3af3806a1c74cdea152d968e31e`. Does **not** overwrite prior n20.
