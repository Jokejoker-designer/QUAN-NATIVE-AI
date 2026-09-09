# E3d OOC — post-divider + E3c D32

**PROGRAM=NO.** `C4_MASTER` remains **OPEN**. This is not `BOARD_PASS`.

| Item | Value |
|------|--------|
| Marker | `E3D_OOC_DONE PROGRAM=NO C4_MASTER=OPEN` |
| Wall clock | 2026-09-09 19:24:53 → 20:09:31 +07 (~44.7 min) |
| Tool | Vivado 2026.1 OOC synth `a7ng_astra_c4_lm06_d32_fr_v2` + `a7ng_astra_c4_smres_div_mcycle` |
| Device | `xc7a100tcsg324-1` / 100 MHz constraint |
| D32 SHA256 | `7a2f0b3b4a67b1bea49c70f23bead0a7897dfc035fdd5b66dcccd8acc4d00b78` |
| Divider SHA256 | `8f3eaf1e2594d5352e3a222d0bb3125abfc235daf9f306676ae7a544f94ab30e` |

## Timing vs E3a (pre-divider)

| | E3a | E3d |
|--|-----|-----|
| WNS | **−83.427 ns** | **−24.357 ns** |
| TNS | (fail recorded 62840) | **−66304.711 ns**, 3927 failing endpoints |
| Worst path | `elut_reg[11][5]` → attn CARRY4 → `acc1` DSP, 319 levels, 92.893 ns | `di_reg[4]` → `vv_wdata_reg[*]`, 48 levels, 33.716 ns |
| Top-20 name family | 20/20 SMRES | **0/20 SMRES**, 0/20 weight |

E3d `timing_n20_e3d.rpt` SHA256 `3f122daa5a0d9ef7c8091556b47989065464fa1a7fc77ae6743a7d8e0a9d3cb6`.  
Parser output: `E3D_N20.json`. Does **not** overwrite `timing_n20.rpt` / `E3A_N20.json`.

## Util / RAM (OOC)

| Resource | E3a | E3d |
|----------|-----|-----|
| Slice LUTs | 38171 | **31781** (50.13%) |
| Slice Registers | 50872 | **42364** (33.41%) |
| DSP | 106 | **106** |
| Block RAM Tile | 0 | **0** |
| LUTM distributed RAM | (not the E3a claim) | **224** (100% inferred as LUTRAM) |

`util_e3d.rpt` SHA256 `69d0d107ec5985fa9c78e9015c6bafa55fb2536eabb1bdbd0fe2e42a15b932e4`  
`ram_e3d.rpt` SHA256 `a9b660f866629ff31b09ad02bc92ea57bd6d60c599f61efb717f7975941ebf16`

**FACT:** E3c async-reset split did **not** infer Block RAM on this OOC. Arrays sit in distributed LUTRAM / registers. Timing improved because the 32-bit combo `/` left the top-N, not because BRAM appeared.

`.dcp` is gitignored. Re-run `run_e3d_ooc.ps1` to regenerate.
