# RESULTS — ASTRA-11-A09R8-UART-FREEZE-BIT-01

PROGRAM=NO. COM12/JTAG 210319BE776EA untouched. B bag
`ASTRA-11-A09R7-UART-IMPL-ROUTE-01` KEEP (not overwritten). Frozen A09-R2 / SGD /
uart_rx / uart_tx not patched. This is the **named successor of B** after RCA.

```text
GATE             = ASTRA-11-A09R8-UART-FREEZE-BIT-01
TOP              = a7ng_astra_11_a09r8_uart_freeze_wrap
DUT_MODULE       = a7ng_astra_09_r2_cand_ovf
DUT_INSTANCE     = u_a09r2
UART_RXD_OUT     = D10  FIXED
UART_TXD_IN      = A9   FIXED
UART_IOB         = YES
UART_IOBFF       = NO   (policy FALSE; capture u_rx/rx_sync0_reg SLICE_X18Y163 SLICEL.AFF)
HOLD_POLICY      = RELATED_CHECK_NO_FALSE_PATH_HOLD
UART_IN_HOLD     = +1.150 ns  (uart_io_vclk → clk50u; timed, not excepted)
UART_OUT_HOLD    = +4.064 ns  (clk50u → uart_io_vclk; timed, not excepted)
PIPE_CLK         = clk50u 20.000 ns (50.000 MHz) MMCM+BUFG REAL
PART             = xc7a100tcsg324-1
VIVADO           = 2026.1 Build 6511674
DESIGN_STATE     = Routed  Date Mon Sep 7 05:51:07 2026
WNS              = 0.587 ns
TNS              = 0.000
WHS              = 0.058 ns
THS              = 0.000
CONSTRAINTS      = All user specified timing constraints are met
LUT/FF/BRAM/DSP  = 4946 / 3615 / 0 / 2
ILOGIC/OLOGIC    = 0 / 0
BIT              = UNPROGRAMMED
BIT_FILE         = a7ng_astra_11_a09r8_uart_freeze_wrap.bit
BIT_SHA256       = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
BIT_BYTES        = 3826016
PROGRAM          = NO
PRODUCTION_TOP   = UNKNOWN  (owner freeze still required)
MARKER           = ASTRA_11_A09R8_UART_FREEZE_DONE WNS=0.587 TNS=0.000 WHS=0.058 UART_IN_HOLD=1.150 UART_OUT_HOLD=4.064 BIT=UNPROGRAMMED PROGRAM=NO
RESULT           = PASS_NARROW (this bag: honest UART pad hold MET, DTS WNS>=0 WHS>=0, official .bit written, not programmed)
```

## RCA fix vs B

| | B `a7ng_astra_11_a09r7_uart_impl_wrap` | This successor |
|---|---|---|
| UART IOB FF | YES ILOGIC IFF / OLOGIC OUTFF | **NO** fabric `rx_sync0` / `tx_reg` |
| Hold policy | FALSE_PATH_HOLD (excepted) | **timed** delays 2.000/0.500 |
| Inter-clock hold | blank | **+1.150 / +4.064** |
| DTS WHS | +0.104 intra-clk50u only | +0.058 (includes UART hold MET) |
| Bit | NOT_BUILT (tcl abort) | **UNPROGRAMMED** `e51bdca2…` |

Proven same pad STA class as ASTRA-11-A09R3-UART-IODELAY-01 IN hold +1.151, now on B's R7 query-rew + A09-R2 wrap.

## Not claimed

BOARD_PASS. ASTRA-13. ACCEPT_BOARD. PRODUCTION_TOP identity (owner). LM06.
Master F3. DDR. Programming this bit. Overwriting B's +0.336 bag.
