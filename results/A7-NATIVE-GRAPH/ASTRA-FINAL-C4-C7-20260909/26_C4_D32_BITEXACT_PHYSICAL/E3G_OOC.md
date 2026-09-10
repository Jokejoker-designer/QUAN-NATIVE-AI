# E3g OOC readout — S_LOG-only (Anh 6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. E3e path-cut PASS stands. This is not a mass `c4_rq` refactor.

| Item | E3e | E3g |
|------|-----|-----|
| WNS | −23.439 ns | **-22.718 ns** |
| TNS | −60692.415 ns | -60155.835 ns |
| Failing endpoints | 3734 | 3676 |
| Top-20 family | logits_wdata 20/20 | {'kv_wdata': 20} |
| Worst logic levels | 53 | 48 |
| Worst CARRY4 / DSP48E1 | 35 / 4 | 31 / 4 |

Worst: `di_reg[4]_rep__5/C` → `kv_wdata_reg[0]/D`.

## Case B — `path_cut_new_family`

logits_wdata left top-20; WNS only slight/flat. E3g still PASS as a path cut. Target the new named family. Do not mass-refactor remaining c4_rq sites.

WNS Δ vs E3e: **0.7210000000000001 ns**. Next gate: `E3f_S_K`.

Do not mass-refactor remaining `c4_rq` sites. Next measured gate is **E3f_S_K** (`kv_wdata` 20/20). E3f was reserved for Q/K; this is not E3h.

`timing_n20_e3g.rpt` SHA256 `251d07db9805c08738cea1e5489a0c157fcc2d5f7144d5e0755df7d4b0cfb89f`. Does **not** overwrite E3a/E3d/E3e.

| Resource | E3e | E3g |
|----------|-----|-----|
| Slice LUTs | 31778 | 31138 |
| Slice Registers | 42605 | 42734 |
| DSP | 99 | 88 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |
