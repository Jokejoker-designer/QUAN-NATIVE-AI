# CLOSEOUT — ASTRA-11-A09R3-UART-IOBFF-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-11-A09R3-UART-IOBFF-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TOP                  = a7ng_astra_11_a09r3_uart_iobff_wrap
DUT                  = a7ng_astra_09_r2_cand_ovf
INSTANCE             = u_a09r2
UART_IOB             = YES  (A9 uart_txd_in INPUT; D10 uart_rxd_out OUTPUT; io.rpt FIXED)
UART_IOBFF           = YES  (uart_rx_iob_reg ILOGICE2.IFF ILOGIC_X0Y171; uart_tx_iob_reg OLOGICE2.OUTFF OLOGIC_X0Y161)
UART_IN_MAX_NS       = 2.000
UART_IN_MIN_NS       = 0.500
UART_OUT_MAX_NS      = 2.000
UART_OUT_MIN_NS      = 0.500
UART_IN_SETUP_SLACK  = 19.270 ns  (uart_txd_in → uart_rx_iob_reg)
UART_IN_HOLD_SLACK   = -4.915 ns  (HOLD_FINDING; 1 endpoint)
UART_OUT_SETUP_SLACK = 7.313 ns   (uart_tx_iob_reg → uart_rxd_out)
UART_OUT_HOLD_SLACK  = 3.662 ns
PART                 = xc7a100tcsg324-1
PIN_CLK              = CLK100MHZ E3 10.000 ns
PIPE_CLK             = clk50u 20.000 ns (50.000 MHz) MMCM+BUFG REAL
IO_CLK_REF           = uart_io_vclk 20.000 ns VIRTUAL (I/O reference only)
SYNTH                = PASS (0 errors / 0 critical warnings)
ROUTE                = COMPLETE (failed nets = 0)
WNS                  = 0.115 ns  (timing_route.rpt Design Timing Summary; Design State=Routed; clk50u)
TNS                  = 0.000 ns
WHS                  = -4.915 ns (UART IOB input hold vs uart_io_vclk; intra clk50u WHS=+0.131 MET)
THS                  = -4.915 ns
ROUTE_LUT            = 4802   (util_route.rpt Slice LUTs; Design State=Routed)
ROUTE_FF             = 3500
BRAM_TILE            = 0
DSP                  = 2
IOB_FLIP_FLOPS       = 2
ILOGIC               = 1
OLOGIC               = 1
SYNTH_LUT            = 5682   (util_synth.rpt; not the WNS quote)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
WNS_LT_0_EXPERIMENT  = not run (routed WNS >= 0)
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / Master_ASTRA-06 / Master_ASTRA-10 / LM06 / BOARD_PASS / ASTRA-13 = OPEN
```

## Evidence

- Raw routed timing: `timing_route.rpt` (authority for WNS / WHS)
- UART I/O paths: `timing_uart_in.rpt` / `timing_uart_out.rpt` / `UART_IODELAY.txt`
- IOB FF pack: `UART_IOBFF.txt` / `util_route.rpt` IOB Flip Flops=2 ILOGIC=1 OLOGIC=1
- check_timing: `check_timing.rpt` (UART ports still constrained; LED residual)
- Raw routed util: `util_route.rpt` / `util_hier_route.rpt`
- UART IOB: `io.rpt` / `UART_IOB.txt`
- Clocks / clock network: `clocks_route.rpt` / `clock_util_route.rpt`
- Route status: `route_status.rpt`
- Synth (not the WNS quote): `util_synth.rpt` / `timing_synth.rpt`
- Extracts: `TIMING_EXTRACT.txt` / `UTIL_EXTRACT.txt`
- SHA freeze before impl: `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Vivado log: `vivado.log`
- Contract: `PREREG.md` / `ACK.json`

## Next dependency

Independent auditor of this impl/route bag. Do not open LM06, BOARD, DDR,
ASTRA-13, or Master F3 from this bag. Do not freeze PRODUCTION_TOP. PROGRAM=NO.
Bag-local AXI plant remains a fixture; this is not a production SoC top.
LED I/O delay remains a residual. UART IOB input hold vs virtual `uart_io_vclk`
is a finding of this bag, not a retune of frozen 2.000/0.500.
