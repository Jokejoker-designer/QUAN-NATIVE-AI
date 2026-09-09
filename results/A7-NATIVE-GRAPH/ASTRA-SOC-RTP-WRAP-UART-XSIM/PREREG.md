# PREREG — ASTRA-SOC-RTP-WRAP-UART-XSIM

```text
FIX        = auditor 20260906T0215Z item 3 / 0152Z item 3 (wrap-top UART/MMCM un-XSim'd)
BAG        = results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-UART-XSIM/
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
EDIT_09    = NO (a7ng_astra09_pipe / arty_a7_astra09_soc_top frozen)
EDIT_R2    = NO (instantiate only)
EDIT_WRAP  = NO (instantiate only)
GLUE_BAG   = ASTRA-SOC-RTP-GLUE stays stripped r1+plant128
XSIM_BAG   = ASTRA-SOC-RTP-WRAP-XSIM left as wrap-equivalent r2+bram128 (NOT this UART exam)
ROUTE_BAG  = ASTRA-SOC-RTP-WRAP-ROUTE left as impl+route UNPROGRAMMED
```

## DUT

XSim instantiates **`arty_a7_astra_rtp_soc_top`** (real wrap ports: `CLK100MHZ` 10 ns, `uart_txd_in` / `uart_rxd_out`).

Inside wrap (not TB-rewired):

- `u_pipe` = `a7ng_astra_rtp_pipe_r2`
- `u_sram` = `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)` (RTP-R2 BASE 17/34)
- `uart_rx` / `uart_tx` `#(.CLK_HZ(50_000_000), .BAUD(115200))`
- MMCM 100→50 (`MMCME2_BASE` + `BUFG`). If unisim missing in xelab, bag-local **MMCM_STUB** (RESULTS must say `MMCM_STUB`, not silicon MMCM).

**Not compiled:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`.

EMPTY not in this bag (wrap has no `fill_i`).

SHA256 of every file xvlog compiles, **before** xvlog.

## Stimulus

Drive `uart_txd_in` 115200 8N1. Bit period from **100 MHz pin** (`CPB = (100e6+115200/2)/115200 = 868` × 10 ns = 8680 ns), matching DUT UART at **50 MHz pipe** (434 × 20 ns).

Query bytes: `pump requires indirect\n` (EOL `0x0A` fires wrap FIFO).

## Pass

| Case | Stimulus | Expect |
|------|----------|--------|
| BASE UART | wrap UART query, planted BRAM | MAGIC `A2` frame; ans=4 p0=17 p1=34; tbl=0 (byte[1][7] and `load_from_tb_o`) |

Not BOARD_PASS. Not 100 MHz close. Not LM06. Not F2. Not 09-wrap fetch. Not ASTRA-13. Not COM12 program. Not EMPTY.
