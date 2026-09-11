# E3r OOC readout — S_F2 fi-indexed acc product pipeline (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3q | E3r |
|------|-----|-----|
| WNS | −4.089 ns | **−3.669 ns** |
| TNS | −1556.346 ns | −1427.389 ns |
| Failing endpoints | 627 | 879 |
| Top-20 family | acc 13, smres 7 | **smres/elut 20** (acc 0) |
| Worst logic levels | 24 | 22 |
| Worst CARRY4 / DSP48E1 | 17 / 1 | 9 / 0 |

Worst: `dots_reg[23][1]/C` → `elut_reg[0][0]/D` (S_SMLUT; `dmax` mux flattened into `elut`).

## Case B — `path_cut_new_family`

`fi`→`acc` left top-20. WNS Δ vs E3q: **+0.420 ns** (slight; TNS improved, failing worse — not a cut fail). Path-cut PASS. Next: **`E3s_smres`** — keep/pipeline `dmax` so S_SMLUT does not flatten `dots`→`elut`.

`timing_n20_e3r.rpt` SHA256 `4af487cb462bcfb1e5af89d6d2cb61ae8cd78ae177b832614423659e3e09d912`. E3q n20 SHA `413baf840789e989…` intact.

| Resource | E3q | E3r |
|----------|-----|-----|
| Slice LUTs | 27573 | 27071 |
| Slice Registers | 42979 | 42921 |
| DSP | 17 | 16 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 200 | 200 |
