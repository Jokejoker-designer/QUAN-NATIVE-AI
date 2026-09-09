# PREREG — ASTRA-11-A09-IMPL-ROUTE-01

Frozen before impl. PROGRAM=NO. No board program. No JTAG/xsdb/COM12/bitstream/write_bitstream/hw_server.
Does not edit ASTRA-10 / ASTRA-09 / ASTRA-11-SOC-WRAP* / F2R-* / F3-* / ASTRA-06-* bags or frozen RTL.
Does not overwrite wrap-route WNS=+5.733 evidence. Does not open LM06 / BOARD / DDR / Master F3.
Does not close ASTRA-13, BOARD_PASS, SoC UART wrap, LM06, Master F3.

## Claim this revision may close

One unknown, this bag only: after **implement+route** of a **new named wrapper** that
**instantiates** `a7ng_astra_09_integ_path` (does **not** copy-paste the graph) on
`xc7a100tcsg324-1` at a **declared 50 MHz** constraint with **clock-network delay
included**, is routed WNS ≥ 0 — **without a bitstream**.

OOC synth WNS=+2.283 (ASTRA-10-RESOURCE-BOUND-01, Design State Synthesized) is
**not** this result.

## Frozen build identity

```text
GATE           = ASTRA-11-A09-IMPL-ROUTE-01
PART           = xc7a100tcsg324-1
VIVADO         = 2026.1
LICENSE        = D:\Xilinx\licenses\vivado_basic.lic
TOP            = a7ng_astra_11_a09_impl_wrap
DUT_MODULE     = a7ng_astra_09_integ_path
DUT_INSTANCE   = u_a09
PIN_CLK        = CLK100MHZ E3  period 10.000 ns  (board oscillator site; not 50 MHz identity)
PIPE_CLK       = MMCME2_BASE 100→50 + BUFG  (declared 50.000 MHz / 20.000 ns)
CLOCK_JUSTIFY  = handoff default 50 MHz; MMCM+BUFG so routed WNS includes clock-network delay
MODE           = synth_design (in-context, not OOC) ; opt_design ; place_design ; route_design
BIT            = NOT_BUILT
write_bitstream= FORBIDDEN
PROGRAM        = NO
COM12          = UNTOUCHED
JTAG           = 210319BE776EA UNTOUCHED
```

## One unknown

After implement+route of that instantiated A09 path on xc7a100tcsg324-1 at a
declared 50 MHz constraint (clock-network delay included), is WNS ≥ 0 — without
a bitstream?

## Wrapper law

- New named wrapper only. Instantiates frozen A09 DUT. Does not duplicate QSE /
  sparse / 2-hop / SGD RTL.
- I/O folded to official Arty CLK100MHZ / sw / btn / led so the design is
  placeable (A09 AXI master is **not** exported; hanging AXI, no `a7ng_axi_bram128`).
- No UART. No SoC UART wrap. No `a7ng_astra09_pipe`.
- Unpacked DUT arrays `w_o[0:31]` / `pend_phi_o[0:31]` stay internal.
- `load_from_tb` path unused (`load_v_i` tied 0). DUT `load_from_tb_o` observed only.

## Comparison (not identity)

- Do **not** quote ASTRA-10 OOC WNS=+2.283 as this result.
- Do **not** overwrite or claim wrap-route `ASTRA-SOC-RTP-WRAP-ROUTE` WNS=+5.733
  (different top `arty_a7_astra_rtp_soc_top` + UART + `a7ng_axi_bram128`).
- DESIGN_CANDIDATE preferred envelope is not this close.

## Hash

SHA256 of every file Vivado compiles (RTL + XDC + tcl) **before** impl, plus
transitive `.svh` and this PREREG/ACK.

## If WNS < 0

FAIL this bag, keep the routed report, one bounded clock/constraint experiment
in this bag. Still no bitstream. Do not program a failing bit.

## Out of scope

Master ASTRA-09 production path. Master F3. LM06. BOARD_PASS. ASTRA-13.
ASTRA-11 SoC UART wrap. write_bitstream. JTAG/xsdb/COM12/hw_server.
