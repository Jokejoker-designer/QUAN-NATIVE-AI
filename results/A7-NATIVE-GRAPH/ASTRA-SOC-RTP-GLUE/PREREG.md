# PREREG — SOC_RTP_GLUE

```text
FIX      = auditor 20260906T0120Z item 7 (SoC exam path)
CWD      = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM  = NO
COM12    = UNTOUCHED
EDIT_09  = NO (a7ng_astra09_pipe / arty_a7_astra09_soc_top frozen)
EDIT_R1  = NO (instantiate only)
```

## Change

New top `arty_a7_astra_rtp_soc_top` maps `a7ng_astra_rtp_pipe_r1` descriptor fetch onto `a7ng_axi_rtp_plant128` (INIT dir+post+rtp-desc-v1 facts). `load_from_tb_o` must stay 0. `fill_i=1` on the wrap. No SGD un-freeze. CLK100MHZ pin E3 10 ns; pipe 50 MHz MMCM.

## Pass

| Case | Stimulus | Expect |
|------|----------|--------|
| BASE | tokens `pump requires indirect`, fill=1 | st=0 ans=4 p0=17 p1=34 nload=2 tbl=0 |
| EMPTY | same tokens, fill=0 | not ans=4 (UNKNOWN/INCOMP); tbl=0 |

Not BOARD_PASS. Not 100 MHz. Not LM06. Not F2.
