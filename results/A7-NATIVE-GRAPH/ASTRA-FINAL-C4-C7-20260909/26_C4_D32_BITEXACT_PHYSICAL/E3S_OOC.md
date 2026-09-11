# E3s OOC readout — dmax keep (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3r | E3s |
|------|-----|-----|
| WNS | −3.669 ns | **-3.755 ns** |
| TNS | −1427.389 ns | -1501.355 ns |
| Failing endpoints | 879 | 519 |
| Top-20 family | smres 20 | {'smres': 20} |
| Worst logic levels | 22 | 23 |
| Worst CARRY4 / DSP48E1 | 9 / 0 | 9 / 0 |

Worst: `dots_reg[23][1]/C` → `elut_reg[0][0]/D`.

## Case C — `register_boundary_may_not_have_survived`

elut still 20/20 from dots. dmax keep may not have cut S_SMLUT flatten.

WNS Δ vs E3r: **-0.08599999999999985 ns**. Next gate: `E3T_SMLUT_PIPE`.

`timing_n20_e3s.rpt` SHA256 `fc146755028fd27da602776689b7b60728cb9b16aae24a80011b57ae24963aba`. Does **not** overwrite prior n20.
