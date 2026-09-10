# E3m OOC readout — S_H acc-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. S_Y was not retouched.

| Item | E3l | E3m |
|------|-----|-----|
| WNS | −6.543 ns | **-5.998 ns** |
| TNS | −1971.193 ns | -2234.909 ns |
| Failing endpoints | 583 | 647 |
| Top-20 family | acc 15, rq_snap 5 | {'rq_snap': 19, 'acc': 1} |
| Worst logic levels | 26 | 21 |
| Worst CARRY4 / DSP48E1 | 12 / 2 | 9 / 1 |

Worst: `di_reg[4]/C` → `rq_val_r_reg[63]/D`.

## Case MIXED — `read_topn`

Neither clean A/B/C. Read timing_n20_e3m.rpt before RTL.

WNS Δ vs E3l: **0.5449999999999999 ns**. Next gate: `E3n_acc_keep`.

Cone (FACT): acc 15→1 in top-20 (path-cut). New worst 19/20 `di_reg[4]` → `rq_val_r_reg[*]` through `acc1__3_*` + DSP `rq_val_r1__2`. Last-`di` `acc + product` snapshot flattened. Cut **keep on shared `acc` only**. Do not SNAP every remaining site in this gate.

`timing_n20_e3m.rpt` SHA256 `e733fb4f123eca67d8c81b6ca151f6ba110ee4a296e94ffd6e548ead296304ce`. Does **not** overwrite prior n20.

| Resource | E3l | E3m |
|----------|-----|-----|
| Slice LUTs | 28475 | 27895 |
| Slice Registers | 42880 | 42960 |
| DSP | 25 | 25 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
