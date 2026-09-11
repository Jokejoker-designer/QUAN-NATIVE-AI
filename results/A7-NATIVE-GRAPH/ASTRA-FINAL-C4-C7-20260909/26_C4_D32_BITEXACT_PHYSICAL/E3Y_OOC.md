# E3y OOC readout — S_DOT operand snap into prod_r (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. Last extra E3 gate → E3_REVIEW.

| Item | E3x | E3y |
|------|-----|-----|
| WNS | −1.532 ns | **-1.332 ns** |
| TNS | −101.238 ns | -88.438 ns |
| Failing endpoints | 88 | 88 |
| Top-20 family | prod_r 20 (kv) | {'prod_r': 20} |
| Worst logic levels | 10 | 8 |
| Worst CARRY4 / DSP48E1 | 0 / 1 | 1 / 1 |
| LUT / FF / DSP / BRAM | 26915 / 43308 / 12 / 0 | 26799 / 43326 / 12 / 0 |

Worst: `fi_reg[5]/C` → `prod_r_reg[31]/D`.

## Case MIXED — cone read: S_DOT `kv` left; S_F2 `fi` now 20/20

WNS Δ vs E3x **+0.200 ns**. Failing still 88. `prod_r` dest pin unchanged, **source cone changed** `kv`→`fi`. All 20 top paths: `fi_reg[5]` → `prod_r_reg[31:50]` (CARRY4=1 DSP=1, 8 levels). RTL match: `S_F2` still `prod_r <= wgt8(W2)*tv[fi]` same cycle. Plan §3: **no E3z**. `stop_local_e3` (same `kv` cone) = false; **stop further local E3 by plan** = true.

WNS Δ vs E3x: **+0.200 ns**. Next: `E3_REVIEW`.

`timing_n20_e3y.rpt` SHA256 `7c59f524db4c3f4ccf905433e6b35597620008b35a55728924a4615361f075da`. Does **not** overwrite prior n20.
