# PREREG — ASTRA-11-A09R8-UART-FREEZE-BIT-01

Frozen before impl. PROGRAM=NO (never xsdb/fpga/COM12/JTAG 210319BE776EA).
Bitstream **may** be written if routed DTS WNS≥0 and WHS≥0 **and** UART pad hold
is a numeric slack (not FALSE_PATH excepted). Board is **not** programmed.

Does not edit B bag ASTRA-11-A09R7-UART-IMPL-ROUTE-01 (KEEP). Does not patch
frozen A09-R2 / leftover A09 / SGD / uart_rx / uart_tx. Does not overwrite
IOBFF WHS=−4.915, HOLD WHS=+0.131, IODELAY WNS=+0.681, B WNS=+0.336.

## Root cause of B (frozen here, not guessed after WNS)

1. **Physical hold fail:** wrap IOB FF `uart_rx_iob` packed ILOGICE2.IFF with
   0.000 ns pad-to-IFF route, timed vs virtual `uart_io_vclk` (SCD=0) while
   capture clock `clk50u` has MMCM+BUFG insertion (~5 ns). Proven
   ASTRA-11-A09R3-UART-IOBFF-01 routed **WHS=−4.915**. IDELAYE2 TAP31 max
   ~2.5 ns cannot cover 4.915 ns.
2. **Tautological WHS:** B copied FALSE_PATH_HOLD_ASYNC_UART so DTS WHS=+0.104
   is intra-clk50u, Inter-clock hold columns blank. Not pad hold MET.
3. **No official bit:** B `run_impl.tcl` renamed `write_bitstream` to abort.
   BIT=NOT_BUILT by construction.

## Frozen STA envelope (BEFORE impl)

```text
STA_ENVELOPE     = UART_IO_DELAY_2P000_0P500  (copy IODELAY bag, not invented)
HOLD_POLICY      = RELATED_CHECK_NO_FALSE_PATH_HOLD
IOB_FF_POLICY    = FALSE  (no wrap pad FFs; IOB FALSE on UART ports)
UART_RX_CAPTURE  = frozen uart_rx rx_sync0/rx_sync1 (has SR → will not pack IOB)
UART_TX_DRIVE    = frozen uart_tx.tx
PIPE_CLK         = MMCM 100→50 clk50u + BUFG
UART_IO_VCLK     = virtual 20.000 ns (I/O reference only)
UART_IN_MAX_NS   = 2.000
UART_IN_MIN_NS   = 0.500
UART_OUT_MAX_NS  = 2.000
UART_OUT_MIN_NS  = 0.500
write_bitstream  = ALLOWED_IFF WNS>=0 AND WHS>=0 AND UART_HOLD_NUMERIC>=0
PROGRAM          = NO
```

Proven same envelope without IOB FF: ASTRA-11-A09R3-UART-IODELAY-01 routed
WNS=+0.681 WHS=+0.100, UART IN hold **+1.151** (A9 → u_rx/rx_sync0_reg),
OUT hold **+4.517**. That bag is A09R3 (no R7 FSM). This bag is B's R7
query-rew FSM + frozen A09-R2 + same pad STA.

## One unknown

After implement+route of `a7ng_astra_11_a09r8_uart_freeze_wrap` instantiating
frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2` on `xc7a100tcsg324-1` at
declared 50 MHz with D10/A9, delays 2.000/0.500, **no UART IOB FF**, **no
FALSE_PATH_HOLD**: is Design Timing Summary **WNS ≥ 0 and WHS ≥ 0** with UART
pad hold slacks **numeric and ≥ 0**? If yes, write the official `.bit`
(UNPROGRAMMED). If no, FAIL, preserve reports, **do not** write a failing bit.

## Not claimed until evidence

PRODUCTION_TOP freeze (owner). BOARD_PASS. ASTRA-13. ACCEPT_BOARD. LM06.
Master F3. DDR. Programming COM12. Physical IOB hold MET of bag B.
