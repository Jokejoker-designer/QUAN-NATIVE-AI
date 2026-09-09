# PREREG — ASTRA-10-RESOURCE-BOUND-01

Frozen before synth. PROGRAM=NO. No board. No JTAG/xsdb/COM12/bitstream/write_bitstream.
Does not edit F2R-* / F3-* / ASTRA-06-* / ASTRA-09-INTEGRATED-PATH-01 bags or frozen RTL.
Does not rerun those bags' run scripts. Does not overwrite ASTRA-11 wrap-route timing bag.
Does not open LM06 / BOARD / DDR / Master F3. Does not close Master ASTRA-09.

## Claim this revision may close

One unknown, this bag only: post-synth LUT/FF/BRAM/DSP and a WNS at a **declared
50 MHz** clock for a **new named synth wrapper** that **instantiates**
`a7ng_astra_09_integ_path` (does **not** copy-paste the graph) on
`xc7a100tcsg324-1`, without a bitstream.

## Frozen build identity

```text
GATE           = ASTRA-10-RESOURCE-BOUND-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_10_resource_wrap
DUT_MODULE     = a7ng_astra_09_integ_path
DUT_INSTANCE   = u_a09
CLOCK          = clk  period 20.000 ns  (50.000 MHz)
CLOCK_JUSTIFY  = handoff default 50 MHz; same pipe rate as prior Arty MMCM 100→50
MODE           = synth_design -mode out_of_context
OPT_PLACE      = optional; no route required; write_bitstream forbidden
BIT            = NOT_BUILT
PROGRAM        = NO
COM12          = UNTOUCHED
JTAG           = 210319BE776EA UNTOUCHED
```

## One unknown

For `a7ng_astra_09_integ_path` (via named wrapper `a7ng_astra_10_resource_wrap`
instance `u_a09`, not a copy-paste) on xc7a100tcsg324-1, what are post-synth
LUT/FF/BRAM/DSP and a WNS at 50 MHz — without a bitstream?

## Wrapper law

- New named wrapper only. Instantiates frozen A09 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- AXI master ports remain at wrap top (no `a7ng_axi_bram128` in this instance).
- Unpacked DUT arrays `w_o[0:31]` / `pend_phi_o[0:31]` stay internal to the wrap.
- `load_from_tb_o` is an observed output; DUT drives 0.

## Comparison (not identity)

- DESIGN_CANDIDATE preferred envelope (not this close): LUT≤40k, FF≤50k,
  DSP≤32, BRAM≤115. Hard device fit / BOARD WNS is V3.1, not this bag.
- Prior wrap-route `ASTRA-SOC-RTP-WRAP-ROUTE` post-route **BRAM_TILE=2** is
  `arty_a7_astra_rtp_soc_top` + `a7ng_axi_bram128` 256×128. **Not this wrapper.**
  Do not claim that bag's WNS (clk50u 7.150 / summary 5.733) or BOARD_PASS.
- Prior OOC `ASTRA-10-OOC-RESOURCE` / `ASTRA-10B-OOC-ASTRA09-PIPE` are
  `a7ng_unified_pipe` / `a7ng_astra09_pipe`, not `a7ng_astra_09_integ_path`.

## Hash

SHA256 of every file Vivado compiles (RTL + XDC + tcl) **before** synth, plus
transitive `.svh` and this PREREG/ACK.

## Out of scope

Master ASTRA-09 production path (LM06 generation, UART, PHYS4 array).
Master F3 10pp/CI. LM06. BOARD. DDR/MIG persist. ASTRA-13. ASTRA-11 SoC UART wrap.
write_bitstream. JTAG/xsdb/COM12/hw_server.
