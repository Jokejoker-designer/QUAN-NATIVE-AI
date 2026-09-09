# CLOSEOUT — ASTRA-11-A09R7-LED-IO-01

```text
RESULT               = PASS_NARROW
TASK                 = ASTRA-11-A09R7-LED-IO-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TOP                  = a7ng_astra_11_a09r7_led_io_wrap
DUT                  = a7ng_astra_09_r2_cand_ovf
INSTANCE             = u_a09r2
LED_CITE             = constraints/arty_a7_100.xdc
LED[0]               = H5   LD4
LED[1]               = J5   LD5
LED[2]               = T9   LD6
LED[3]               = T10  LD7
LED_IOB              = YES  (io.rpt FIXED)
LED_IOBFF            = YES  (led_q_reg[0:3] OLOGICE2.OUTFF)
LED_OUT_MAX_NS       = 2.000
LED_OUT_MIN_NS       = 0.500
LED_OUT_SETUP_SLACK  = 10.321 ns  (led_q_reg[3] → led[3]; Output Delay=2.000)
LED_OUT_HOLD_SLACK   = 2.927 ns   (led_q_reg[1] → led[1]; Output Delay=0.500)
LED_HOLD_POLICY      = RELATED_CLK50U_NO_FALSE_PATH_HOLD
UART_IOB             = YES  (A9 uart_txd_in INPUT; D10 uart_rxd_out OUTPUT; io.rpt FIXED)
UART_IOBFF           = YES  (uart_rx_iob_reg ILOGICE2.IFF ILOGIC_X0Y171; uart_tx_iob_reg OLOGICE2.OUTFF OLOGIC_X0Y161)
UART_IN_MAX_NS       = 2.000
UART_IN_MIN_NS       = 0.500
UART_OUT_MAX_NS      = 2.000
UART_OUT_MIN_NS      = 0.500
HOLD_POLICY          = FALSE_PATH_HOLD_ASYNC_UART
PART                 = xc7a100tcsg324-1
PIN_CLK              = CLK100MHZ E3 10.000 ns
PIPE_CLK             = clk50u 20.000 ns (50.000 MHz) MMCM+BUFG REAL
IO_CLK_REF           = uart_io_vclk 20.000 ns VIRTUAL (UART I/O setup reference only)
SYNTH                = PASS (0 errors / 0 critical warnings)
ROUTE                = COMPLETE (failed nets = 0)
WNS                  = 0.411 ns  (timing_route.rpt Design Timing Summary; Design State=Routed; clk50u)
TNS                  = 0.000 ns
WHS                  = 0.027 ns  (Design Timing Summary; intra clk50u hold MET)
THS                  = 0.000 ns
ROUTE_LUT            = 4945   (util_route.rpt Slice LUTs; Design State=Routed)
ROUTE_FF             = 3615
BRAM_TILE            = 0
DSP                  = 2
IOB_FLIP_FLOPS       = 6
ILOGIC               = 1
OLOGIC               = 5
SYNTH_LUT            = 5792   (util_synth.rpt; not the WNS quote)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
WNS_WHS_LT_0_EXPERIMENT = not run (routed WNS >= 0 and WHS >= 0)
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / Master_ASTRA-06 / Master_ASTRA-10 / LM06 / BOARD_PASS / ASTRA-13 = OPEN
```

## Evidence

- Raw routed timing: `timing_route.rpt` (authority for WNS / WHS)
- LED I/O paths: `timing_led_out.rpt` / `LED_IODELAY.txt` / `LED_IOB.txt` / `LED_IOBFF.txt`
- UART I/O paths: `timing_uart_in.rpt` / `timing_uart_out.rpt` / `UART_IODELAY.txt`
- IOB FF pack: `LED_IOBFF.txt` / `UART_IOBFF.txt` / `util_route.rpt` IOB Flip Flops=6 ILOGIC=1 OLOGIC=5
- check_timing: `check_timing.rpt` (`no_output_delay`=0; LED constrained)
- Raw routed util: `util_route.rpt` / `util_hier_route.rpt`
- LED/UART IOB: `io.rpt`
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
WNS≥0 / WHS≥0 is this bag's routed STA (LED delays 2.000/0.500 vs clk50u frozen
before impl; pins H5/J5/T9/T10 cited from `constraints/arty_a7_100.xdc`), not a
silent freeze of this wrap as PRODUCTION_TOP, and not silicon LEDs.
