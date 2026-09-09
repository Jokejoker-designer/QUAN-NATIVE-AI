# CLOSEOUT — ASTRA-11-A09R7-BTN-IO-01

```text
RESULT               = FAIL_WHS
TASK                 = ASTRA-11-A09R7-BTN-IO-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
TOP                  = a7ng_astra_11_a09r7_btn_io_wrap
DUT                  = a7ng_astra_09_r2_cand_ovf
INSTANCE             = u_a09r2
BTN_CITE             = constraints/arty_a7_100.xdc
BTN[0]               = D9   BTN0
BTN[1]               = C9   BTN1
BTN[2]               = B9   BTN2
BTN[3]               = B8   BTN3
BTN_IOB              = YES  (io.rpt FIXED)
BTN_IOBFF            = YES  (btn_q_reg[0:3] ILOGICE2.IFF)
BTN_IN_MAX_NS        = 2.000
BTN_IN_MIN_NS        = 0.500
BTN_IN_SETUP_SLACK   = 18.616 ns  (btn[0] → btn_q_reg[0]; Input Delay=2.000)
BTN_IN_HOLD_SLACK    = -2.068 ns  (btn[0] → btn_q_reg[0]; Input Delay=0.500; VIOLATED)
BTN_HOLD_POLICY      = RELATED_CLK50U_NO_FALSE_PATH_HOLD
LED[0]               = H5   LD4
LED[1]               = J5   LD5
LED[2]               = T9   LD6
LED[3]               = T10  LD7
LED_IOB              = YES  (io.rpt FIXED)
LED_IOBFF            = YES
LED_OUT_MAX_NS       = 2.000
LED_OUT_MIN_NS       = 0.500
LED_OUT_SETUP_SLACK  = 10.321 ns
LED_OUT_HOLD_SLACK   = 2.927 ns
LED_HOLD_POLICY      = RELATED_CLK50U_NO_FALSE_PATH_HOLD
UART_IOB             = YES  (A9 uart_txd_in INPUT; D10 uart_rxd_out OUTPUT; io.rpt FIXED)
UART_IOBFF           = YES
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
WNS                  = 0.452 ns  (timing_route.rpt Design Timing Summary; Design State=Routed; clk50u)
TNS                  = 0.000 ns
WHS                  = -2.068 ns (Design Timing Summary; BTN pad hold VIOLATED; 4 endpoints)
THS                  = -8.128 ns
ROUTE_LUT            = 4944   (util_route.rpt Slice LUTs; Design State=Routed)
ROUTE_FF             = 3614
BRAM_TILE            = 0
DSP                  = 2
IOB_FLIP_FLOPS       = 10
ILOGIC               = 5
OLOGIC               = 5
SYNTH_LUT            = 5792   (util_synth.rpt; not the WNS quote)
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
WNS_WHS_LT_0_EXPERIMENT = RUN (post-route phys_opt; netlist unmodified because WNS>=0; WHS still -2.068; fail_r0 preserved)
PRODUCTION_TOP       = UNKNOWN
Master_ASTRA-09 / Master_F3 / Master_ASTRA-06 / Master_ASTRA-10 / LM06 / BOARD_PASS / ASTRA-13 = OPEN
```

## Evidence

- Raw routed timing: `timing_route.rpt` (authority for WNS / WHS)
- fail_r0: `fail_r0/timing_route.rpt` (preserved before bounded experiment)
- Bounded experiment: `timing_route_exp.rpt` / `TIMING_EXTRACT_EXP.txt` / `BTN_IODELAY_EXP.txt`
- BTN I/O paths: `timing_btn_in.rpt` / `BTN_IODELAY.txt` / `BTN_IOB.txt` / `BTN_IOBFF.txt`
- LED I/O paths: `timing_led_out.rpt` / `LED_IODELAY.txt` / `LED_IOB.txt` / `LED_IOBFF.txt`
- UART I/O paths: `timing_uart_in.rpt` / `timing_uart_out.rpt` / `UART_IODELAY.txt`
- IOB FF pack: `BTN_IOBFF.txt` / `LED_IOBFF.txt` / `UART_IOBFF.txt` / `util_route.rpt` IOB Flip Flops=10 ILOGIC=5 OLOGIC=5
- check_timing: `check_timing.rpt` (`btn[*]` constrained; remaining `no_input_delay`=sw[*])
- Raw routed util: `util_route.rpt` / `util_hier_route.rpt`
- BTN/LED/UART IOB: `io.rpt`
- Clocks / clock network: `clocks_route.rpt` / `clock_util_route.rpt`
- Route status: `route_status.rpt`
- Synth (not the WNS quote): `util_synth.rpt` / `timing_synth.rpt`
- Extracts: `TIMING_EXTRACT.txt` / `UTIL_EXTRACT.txt`
- SHA freeze before impl: `SHA256.txt` / `SOURCE_HASHES.txt`
- Post-run compiled match: `SHA256_POST.txt`
- Vivado log: `vivado.log`
- Contract: `PREREG.md` / `ACK.json`
- First divergence: `FIRST_DIVERGENCE.txt` (`WHS_NEG`)

## Next dependency

Independent auditor of this impl/route bag. Do not open LM06, BOARD, DDR,
ASTRA-13, or Master F3 from this bag. Do not freeze PRODUCTION_TOP. PROGRAM=NO.
Do not retune frozen BTN 2.000/0.500. Bag-local AXI plant remains a fixture.
WNS≥0 / WHS<0 is this bag's routed STA (BTN delays 2.000/0.500 vs clk50u frozen
before impl; pins D9/C9/B9/B8 cited from `constraints/arty_a7_100.xdc`), not a
silent freeze of this wrap as PRODUCTION_TOP, and not silicon buttons.
