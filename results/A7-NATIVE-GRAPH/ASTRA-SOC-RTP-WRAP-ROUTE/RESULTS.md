# RESULTS — ASTRA-SOC-RTP-WRAP-ROUTE

```text
FIX          = auditor 20260906T0152Z item 2 (Item 7 remainder)
DUT_IMPL     = arty_a7_astra_rtp_soc_top
PIPE         = a7ng_astra_rtp_pipe_r2 SHA 3d27091d KEEP
MEM          = a7ng_axi_bram128 SHA 6e254828 PLANT_R2_BASE=1
WRAP         = arty_a7_astra_rtp_soc_top SHA a1f7a063 KEEP
NOT_DUT      = a7ng_astra09_pipe / arty_a7_astra09_soc_top / r1 / plant128
ROUTE        = COMPLETE (0 nets with routing errors; 5864/5864 fully routed)
DESIGN_STATE = Routed
WNS          = 5.733 ns (timing.rpt Design Timing Summary; path group **async_default**)
WHS          = 0.029 ns
WNS_CLK50U   = 7.150 ns (Intra Clock Table; period 20.000 ns = 50.000 MHz)
WHS_CLK50U   = 0.029 ns
CONSTRAINTS  = All user specified timing constraints are met
BRAM_TILE    = 2 (post-route util.rpt; 2× RAMB36E1 u_sram/mem_reg 256×128)
LUT/FF/DSP   = 4244 / 3810 / 0 (Routed)
BIT          = UNPROGRAMMED SHA 8116fa77
PROGRAM      = NO
COM12        = UNTOUCHED
JTAG         = 210319BE776EA UNTOUCHED
BOARD_PASS   = NO
```

SHA256.txt written **before** synth (stamp 2026-09-06T02:09:06+07). Vivado session 02:09:07–02:12:14. Marker: `ASTRA_SOC_RTP_WRAP_ROUTE_DONE WNS=5.733 WHS=0.029 WNS50=5.733 BRAM=2 BIT=UNPROGRAMMED PROGRAM=NO`.

## DUT identity (raw `vivado.log`, not RESULTS)

`synth_design -top arty_a7_astra_rtp_soc_top -part xc7a100tcsg324-1`.

Synthesized: wrap, MMCME2_BASE (CLKIN1_PERIOD=10, CLKFBOUT_MULT_F=10, CLKOUT0_DIVIDE_F=20 → 50 MHz), uart_rx, uart_tx, **`a7ng_astra_rtp_pipe_r2`**, **`a7ng_axi_bram128` `PLANT_R2_BASE=1'b1`**.

**Not synthesized:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`. File list forbids `*astra09*` / `*pipe_r1*` / `*plant128*`.

## Timing (`timing.rpt`, Design State = Routed)

| Clock | Period | Freq | Intra WNS | Intra WHS |
|-------|-------:|-----:|----------:|----------:|
| `sys_clk_pin` (E3) | 10.000 ns | 100 MHz | — (pin → MMCM) | — |
| **`clk50u`** (u_mmcm/CLKOUT0) | **20.000 ns** | **50.000 MHz** | **7.150** | **0.029** |
| `clkfb` | 10.000 ns | 100 MHz | — | — |

Worst slack in the summary is **async_default** clk50u→clk50u **WNS=5.733** (still ≥ 0). Do not cite 09 timing-fix WNS=7.179 (that is `arty_a7_astra09_soc_top`, BRAM Tile=0, DSP=2).

Pin `CLK100MHZ` E3 10 ns **unchanged**.

## Post-route BRAM (`util.rpt`)

Design State = Routed. Block RAM Tile = **2**, RAMB36E1 only = **2**, DSPs = **0**. Synth mapping: `u_sram mem_reg` 256×128 → 2 RAMB36. Survived route (not WRAP-XSIM synth-only 2; not 09 timing-fix 0).

DRC `REQP-1839` (RAMB36 async control on `u_sram` addr regs): warning, not a timing fail. Not fixed in this bag.

## Bit

`arty_a7_astra_rtp_soc_top.bit` written. `BITSTREAM.txt` STATUS=**UNPROGRAMMED**. SHA256_BIT.txt `8116fa77…`. No xsdb, no `fpga` program, COM12 / JTAG `210319BE776EA` untouched.

## KEEP (hashed, not compiled)

| File | SHA256 | Note |
|------|--------|------|
| `a7ng_astra09_pipe.sv` | `48c9e480…` | MATCH WRAP-XSIM / 12B; not edited; not this DUT |
| `arty_a7_astra09_soc_top.sv` | `71f4ebe0…` | MATCH TIMING-FIX; empty default BRAM; not this close |

Compiled RTL hashes MATCH WRAP-XSIM `SHA256_SYNTH.txt` (r2 `3d27091d`, bram128 `6e254828`, wrap `a1f7a063`, xdc `1c12e6f8`).

## Not claimed

BOARD_PASS. ASTRA-13. COM12 program. UART MAGIC `A2` capture. Wrap EMPTY. 100 MHz close. 09-wrap fetch. LM06 language. F2. XSim of this top (WRAP-XSIM remains wrap-equivalent r2+bram128 XSim).
