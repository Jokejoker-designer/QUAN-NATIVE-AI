# PREREG — ASTRA-SOC-RTP-WRAP-XSIM

```text
FIX        = auditor 20260906T0138Z wrap-vs-DUT (item 2)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
EDIT_09    = NO (a7ng_astra09_pipe / arty_a7_astra09_soc_top frozen)
EDIT_R2    = NO (instantiate only)
GLUE_BAG   = ASTRA-SOC-RTP-GLUE stays r1+plant128 XSim; wrap NOT restored as that DUT
```

## DUT

XSim instantiates **wrap-equivalent** `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)` (same instances/params as `arty_a7_astra_rtp_soc_top` `u_pipe`/`u_sram`). Writes tied off. `load_from_tb_o` must stay 0.

EMPTY: wrap has no `fill_i`. TB muxes a second `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b0)` (all-zero INIT). Not combo-ROM `plant128`. Not r1.

UART/MMCM of the wrap are **not** in this TB.

SHA256 of the files xvlog compiles, **before** xvlog.

Optional cheap synth of `arty_a7_astra_rtp_soc_top` in this bag for Block RAM Tile count. Impl optional. No bitstream program.

## Pass

| Case | Stimulus | Expect |
|------|----------|--------|
| BASE | tokens `pump requires indirect`, planted BRAM | st=0 ans=4 p0=17 p1=34 nload=2 tbl=0 |
| EMPTY | same tokens, empty BRAM | not (ans=4 && st=0); tbl=0 |

Not BOARD_PASS. Not 100 MHz. Not LM06. Not F2. Not 09-wrap fetch. Not ASTRA-13.
