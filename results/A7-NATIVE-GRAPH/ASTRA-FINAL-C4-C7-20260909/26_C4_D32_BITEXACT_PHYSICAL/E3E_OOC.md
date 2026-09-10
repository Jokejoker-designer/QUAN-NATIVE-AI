# E3e OOC — S_V-only rq_mcycle D32

**PROGRAM=NO.** `C4_MASTER` remains **OPEN**. This is not `BOARD_PASS`.

| Item | Value |
|------|--------|
| Marker | `E3E_OOC_DONE PROGRAM=NO C4_MASTER=OPEN` |
| Tool | Vivado 2026.1 OOC synth `a7ng_astra_c4_lm06_d32_fr_v2` + divider + `a7ng_astra_c4_rq_mcycle` |
| Device | `xc7a100tcsg324-1` / 100 MHz constraint |
| Scope | **S_V only** (`S_Q`/`S_K` still combo `c4_rq`) |
| D32 SHA256 | `f3e84760009e15596afa2dd53d582fc7ac2129506c6e4b76a3b47101ebe40fd1` |
| RQ SHA256 | `cc287b5b438de4a46b881a0368f2cdfc121fc319d7f9e6998862506e19eb7bbc` |

## Timing vs E3d

| | E3d | E3e |
|--|-----|-----|
| WNS | **−24.357 ns** | **-23.439 ns** |
| TNS / failing endpoints | −66304.710 ns / 3927 | -60692.415 ns / 3734 |
| Worst dest family | vv_wdata | **logits_wdata** |
| WNS improved vs E3d | — | True |
| Next gate | — | `E3g_logits_wdata` |

Worst: `vi_reg[0]_rep__0/C` → `logits_wdata_reg[11]/S`.

New named site logits_wdata. New measured cut after this top-N. Do not silently expand E3e/E3f.

`timing_n20_e3e.rpt` SHA256 `40297181d5cc55a4168fcee02aa16caa034479a1221645b5bfcffdbb8c33046a`.  
Parser output: `E3E_N20.json`. Does **not** overwrite `timing_n20.rpt` / `timing_n20_e3d.rpt`.

## Util / RAM (OOC)

| Resource | E3d | E3e |
|----------|-----|-----|
| Slice LUTs | 31781 | 31778 |
| Slice Registers | 42364 | 42605 |
| DSP | 106 | 99 |
| Block RAM Tile | 0 | 0 |
| LUT as Memory | 224 | 224 |

OOC WNS≥0 is **not** `C4_MASTER`. Do not program.

`.dcp` is gitignored. Re-run `run_e3e_ooc.ps1` to regenerate.
