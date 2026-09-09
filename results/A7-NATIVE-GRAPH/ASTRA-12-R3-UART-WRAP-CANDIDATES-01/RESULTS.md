# RESULTS — ASTRA-12-R3-UART-WRAP-CANDIDATES-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name.

```text
GATE             = ASTRA-12-R3-UART-WRAP-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
UART_WRAP_ROWS   = 5
R2_POINTER_ROWS  = 4
CANDIDATE_COUNT  = 9
AUDITOR_PRIOR    = 20260906T1900Z ACCEPT_PARTIAL | REJECT_PROMOTION
HOLD_BAG         = PASS_NARROW; false-path-hold HONEST
RESULT           = PASS_NARROW (this bag only: UART-wrap candidate table from raw reports)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
BOARD            = BLOCKED
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
write_bitstream  = not called
```

## One unknown (answered)

Extend the candidate table with UART wraps (XSim + routed), quoting WNS/WHS from
**raw reports**, hashes, IOB, hold-policy, UART D10/A9 yes/no per row, while
PRODUCTION_TOP remains UNKNOWN.

**Five** UART-wrap rows + **four** 12-R2 pointer rows. None chosen. See `CANDIDATES.md`.

| # | Top | Bag | Raw WNS | Raw WHS | UART D10/A9 | IOB FF |
|---|-----|-----|---------|---------|-------------|--------|
| U1 | `a7ng_astra_09_r3_uart_wrap` | ASTRA-09-R3-UART-XSIM-01 | N/A (XSim; MAGIC A2 PASS) | N/A | ports YES; PACKAGE_PIN NO | N/A |
| U2 | `a7ng_astra_11_a09r3_uart_impl_wrap` | ASTRA-11-A09R3-UART-IMPL-ROUTE-01 | **+0.305** `timing_route.rpt` Routed | **+0.024** | YES A9 INPUT / D10 OUTPUT FIXED | NO |
| U3 | `a7ng_astra_11_a09r3_uart_iodelay_wrap` | ASTRA-11-A09R3-UART-IODELAY-01 | **+0.681** Routed | **+0.100** | YES | NO |
| U4 | `a7ng_astra_11_a09r3_uart_iobff_wrap` | ASTRA-11-A09R3-UART-IOBFF-01 | **+0.115** Routed | **−4.915** (constraints not met) | YES | YES |
| U5 | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` | ASTRA-11-A09R3-UART-IOBFF-HOLD-01 | **+0.115** Routed | **+0.131** (intra clk50u; UART I/O hold excepted) | YES | YES |

U3 delays from raw XDC: **max 2.000 / min 0.500**.
U5 HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** (honest; min NOT_APPLIED).
U4 WHS=−4.915 bag **not overwritten**.

Pointer (12-R2 files not rewritten; timing SHA MATCH): P1 +1.041 UART NO; P2 +5.733 UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES.

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. U5 WNS=+0.115 WHS=+0.131 IOB FF YES is
**not** that top. U4 −4.915 remains the physical hold evidence under min 0.500.
Parent does not pick. This bag does not pick.

## Hashes

Cited-file SHA256 in `SHA256.txt`. Prior-bag files hashed in place, not rewritten.
ACK.json written first.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-12 unique-bit /
UART plan. Master ASTRA-06 DDR/NVM. Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Production-top identity. Auditor ACCEPT_BOARD. Physical IOB hold MET.
Do **not** call this BOARD_PASS or ASTRA-13. Manager independently accepts.
Do not autonomously open the next gate.
