# E3l OOC readout — S_Y-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. S_F1 was not retouched.

| Item | E3k | E3l |
|------|-----|-----|
| WNS | −15.041 ns | **-6.543 ns** |
| TNS | −9485.734 ns | -1971.193 ns |
| Failing endpoints | 1125 | 583 |
| Top-20 family | rq_snap 20 (yv cone) | {'other': 15, 'rq_snap': 5} |
| Worst logic levels | 38 | 26 |
| Worst CARRY4 / DSP48E1 | 23 / 5 | 12 / 2 |

Worst: `vv_reg[23][24][15]/C` → `acc_reg[63]/D`.

## Case MIXED — `read_topn`

Neither clean A/B/C. Read timing_n20_e3l.rpt before RTL.

WNS Δ vs E3k: **8.498000000000001 ns**. Next gate: `E3m_S_H_acc`.

Cone (FACT): 15/20 dest `acc_reg[*]`, 5/20 dest `rq_val_r_reg[*]`, all source `vv_reg[23][24][15]`. Cells `acc2_i_*`. That is the S_H MAC recurrence flattened into combo. S_Y cone is no longer worst. Cut **S_H acc only** (keep the per-`ti` register; do not retouch S_Y).

`timing_n20_e3l.rpt` SHA256 `cedec6de74b031ed7904b5e17785ecaa1a8f948a99c38fb6e9143eb89c06f050`. Does **not** overwrite prior n20.

| Resource | E3k | E3l |
|----------|-----|-----|
| Slice LUTs | 28501 | 28475 |
| Slice Registers | 42831 | 42880 |
| DSP | 29 | 25 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
