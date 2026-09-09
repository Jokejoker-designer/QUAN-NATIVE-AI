# PREREG — ASTRA-SOC-RTP-WRAP-ROUTE

```text
FIX        = auditor 20260906T0152Z item 2 (Item 7 remainder)
BAG        = results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-ROUTE/
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
EDIT_09    = NO (a7ng_astra09_pipe / arty_a7_astra09_soc_top frozen, not this DUT)
EDIT_R2    = NO (instantiate only)
GLUE_BAG   = ASTRA-SOC-RTP-GLUE stays stripped r1+plant128
XSIM_BAG   = ASTRA-SOC-RTP-WRAP-XSIM left as wrap-equivalent XSim + synth-only BRAM=2
```

## DUT (this bag)

`synth_design` / impl / route top = **`arty_a7_astra_rtp_soc_top`**.

Instances:

- `u_pipe` = `a7ng_astra_rtp_pipe_r2`
- `u_sram` = `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)` `.DEPTH_WORDS(256)` (RTP-R2 BASE 17/34 plant)
- UART `uart_rx` / `uart_tx`
- MMCM 100→50 MHz (pipe/UART domain). Pin `CLK100MHZ` E3 stays 10 ns.

**Not the exam DUT:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`. Those files are not `read_verilog`'d.

TCL copied from `ASTRA-11-TIMING-FIX/run_impl.tcl`; top and file list changed as above. SGD / evidence_compose dropped (r2 has no SGD).

SHA256 of every file Vivado compiles, **before** synth.

## PASS_NARROW

All of:

1. route complete
2. WNS ≥ 0 at **50 MHz pipe clk** (`clk50u`, period 20 ns)
3. WHS ≥ 0
4. post-route **Block RAM Tile > 0** (routed util, not WRAP-XSIM synth-only 2, not 09 timing-fix 0)
5. bit **UNPROGRAMMED** if written
6. PROGRAM=NO, COM12/JTAG untouched

## Not claimed

BOARD_PASS. ASTRA-13. COM12 program. UART MAGIC `A2` capture. Wrap EMPTY (no `fill_i`). 100 MHz close. 09-wrap fetch. LM06 language. F2. XSim of this top (that was WRAP-XSIM wrap-equivalent only).
