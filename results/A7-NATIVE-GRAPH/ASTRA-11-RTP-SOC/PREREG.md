# PREREG — ASTRA-11 RTP SOC (auditor 20260906T0120Z fix #7)

```text
GATE       = ASTRA-11-RTP-SOC
TOP        = arty_a7_astra_rtp_soc_top
PIPE       = a7ng_astra_rtp_pipe_r2 (NOT a7ng_astra09_pipe)
PART       = xc7a100tcsg324-1
XDC        = constraints/arty_a7_100.xdc (cite only)
CLK_PIN    = CLK100MHZ E3 10 ns (unchanged)
PIPE_CLK   = MMCM 100→50 MHz (pipe/UART domain only)
UART_TX    = uart_rxd_out D10
UART_RX    = uart_txd_in A9
MIG        = NO
DDR_PINS   = NOT INVENTED
FROZEN_SOC = NOT EDITED (lm06 / gate14 tops)
ASTRA09    = NOT EDITED (a7ng_astra09_pipe.sv)
FREEZE_I   = unused (r2 has no SGD)
LOAD_FROM_TB = 0 (output tied in pipe)
MEM        = a7ng_axi_bram128 DEPTH=256 PLANT_R2_BASE=1
PLANT      = RTP-R2 BASE 17/34 (same as tb_astra_rtp_r2)
INDEX_BASE = 0x05000000
FACT_BASE  = 0x05800000
EPOCH      = 7
BIT        = UNPROGRAMMED if written
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
```

## Unknown this gate

Can RTP-R2 fetch (dir + posting + rtp-desc-v1 facts) sit in the SoC wrap with a **non-empty** on-chip plant such that:

1. synth+impl+route complete
2. WNS≥0 **at 50 MHz pipe clk** (pin still 10 ns)
3. Block RAM Tile > 0 (facts not const-prop away)
4. PROGRAM=NO

Empty BRAM was co-fit only (ASTRA-11 wrap/timing-fix = 0 tiles). This bag plants the R2 BASE world.

## Plant (RTP-R2 BASE 17/34)

Same packing as `tb_astra_rtp_r2.sv`:

| Addr | Word | Contents |
|------|------|----------|
| 0x0500A020 | dir t0 k=2562 | epoch=7, count=2, post=0x05040000 |
| 0x05022FE0 | dir t2 k=766 | same |
| 0x05040000 | POST_HEAP | ids 17, 34 (32-bit lanes) |
| 0x05800110 | fact 17 | s=10 o=1 r=2 e=17 ver=1 valid/trans/pol |
| 0x05800220 | fact 34 | s=1 o=4 r=2 e=34 |

UART fire: bytes of `pump requires indirect` then `0x0A`/`0x00`. TX = compact proof (MAGIC 0xA2), not NLU. Expect on a later board exam (not this bag): ans=4 p0=17 p1=34. **This bag does not program or UART-capture.**

## Flow

1. NEW `rtl/board/arty_a7_astra_rtp_soc_top.sv`.
2. `a7ng_axi_bram128` gains `PLANT_R2_BASE` (default 0; wrap empty-init unchanged).
3. SHA256 freeze **before** synth.
4. synth then opt/place/route. If impl too heavy, synth+util with BRAM>0 still recorded.
5. Bit UNPROGRAMMED. Never program COM12.

## PASS_NARROW

WNS≥0 at 50 MHz pipe clk **AND** Block RAM Tile > 0 **AND** PROGRAM=NO.

## Not claimed

100 MHz close, BOARD_PASS, LM06 language, NLU, ASTRA-13, COM12, HIGH_ID silicon, SGD learn, freeze_i policy.
