# E3n OOC readout — shared acc keep (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. No last-di SNAP in this gate.

| Item | E3m | E3n |
|------|-----|-----|
| WNS | −5.998 ns | **−5.840 ns** |
| TNS | −2234.909 ns | -2060.058 ns |
| Failing endpoints | 647 | 647 |
| Top-20 family | rq_snap 19, acc 1 | {'acc': 10, 'rq_snap': 10} |
| Worst logic levels | 21 | 27 |
| Worst CARRY4 / DSP48E1 | 9 / 1 | 17 / 1 |

Worst: `di_reg[4]_rep__14/C` → `acc_reg[63]/D`.

## Case MIXED — `read_topn`

Neither clean A/B/C. Read timing_n20_e3n.rpt before RTL.

WNS Δ vs E3m: **+0.158 ns**. Synth wall **4h42m** (CPU ~20 min) — previously misread as hung; that inference is **CONTRADICTED**.

Cone (FACT): keep on shared `acc` survived (`acc_reg` is a dest). Top-20 split **10 acc / 10 rq_snap**. Worst is last-`di` MAC into `acc_reg[63]` (27 levels, CARRY4 17). A leftover path `di_reg[4]_rep` → `rq_val_r_reg[63]` is still in top-20 (20 levels). Keep did not cut the last-`di` `acc + product` flatten. Next measured gate: **one** last-`di` SNAP (`E3o`), same law as `S_H_SNAP`. Do not retry keep. Do not SNAP all remaining sites in one gate.

`timing_n20_e3n.rpt` SHA256 `55870abf8047e039bd0310966fa5484719c98296675412fc18b5130d05bb382b`. Does **not** overwrite prior n20 (E3m still `e733fb4f…`).

| Resource | E3m | E3n |
|----------|-----|-----|
| Slice LUTs | 27895 | 28023 |
| Slice Registers | 42960 | 42901 |
| DSP | 25 | 25 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
