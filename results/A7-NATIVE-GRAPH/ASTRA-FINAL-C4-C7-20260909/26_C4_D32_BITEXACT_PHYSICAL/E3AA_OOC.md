# E3aa OOC readout — S_SMLUT_LUT index snap then Lut apply (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. New written plan after E3z Case B.

| Item | E3z | E3aa |
|------|-----|------|
| WNS | −0.349 ns | **1.052 ns** |
| TNS | −24.793 ns | 0.0 ns |
| Failing endpoints | 192 | 0 |
| Top-20 family | smres 20 (delta_r) | {'rq_snap': 20} |
| Worst logic levels | 18 | 11 |
| Worst CARRY4 / DSP48E1 | 8 / 0 | 1 / 0 |
| LUT / FF / DSP / BRAM | 27111 / 43285 / 11 / 0 | 26762 / 43365 / 11 / 0 |

Worst: `toks_reg[23][0]/C` → `rq_val_r_reg[10]/D`.

## Case B — `path_cut_new_family`

smres/elut left top-20; WNS slight/flat. Path-cut PASS. Do not auto-start the next pipe. PROGRAM=NO. Not WO §19 post-route C6.

WNS Δ vs E3z: **1.401 ns**. Next: `E3ab_rq_snap`.

`timing_n20_e3aa.rpt` SHA256 `c0f4ca866e871b40aeaef097b2239916e3540e27ecdaab091580825233bb8417`. Does **not** overwrite prior n20.
