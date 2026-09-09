# CLOSEOUT — ASTRA-11-A09R8-UART-FREEZE-BIT-01

```text
TOP                  = a7ng_astra_11_a09r8_uart_freeze_wrap
DUT                  = a7ng_astra_09_r2_cand_ovf as u_a09r2
WNS                  = 0.587 ns   (timing_route.rpt Design Timing Summary; Routed 05:51:07)
TNS                  = 0.000
WHS                  = 0.058 ns
THS                  = 0.000
UART_IN_HOLD         = 1.150 ns   (uart_io_vclk → clk50u)
UART_OUT_HOLD        = 4.064 ns   (clk50u → uart_io_vclk)
HOLD_EXCEPTIONS_UART = NONE       (exceptions_route.rpt only sw[*] / btn[*])
UART_RX_CAPTURE      = u_rx/rx_sync0_reg  SLICE_X18Y163  IOB_PACKED=NO
UART_TX_DRIVE        = u_tx/tx_reg        SLICE_X3Y151   IOB_PACKED=NO
BIT                  = UNPROGRAMMED
BIT_SHA256           = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
PROGRAM              = NO
COM12                = UNTOUCHED
JTAG                 = 210319BE776EA UNTOUCHED
PRODUCTION_TOP       = UNKNOWN
```

Authority: `timing_route.rpt`, `UART_IODELAY.txt`, `exceptions_route.rpt`,
`BITSTREAM.txt`, `SHA256_BIT.txt`, live Get-FileHash of the `.bit`.
