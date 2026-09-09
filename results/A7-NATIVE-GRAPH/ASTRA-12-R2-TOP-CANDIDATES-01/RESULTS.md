# RESULTS — ASTRA-12-R2-TOP-CANDIDATES-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name.

```text
GATE             = ASTRA-12-R2-TOP-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
CANDIDATE_COUNT  = 4
UNIQUE_MODULES   = 3
AUDITOR_PRIOR    = 20260906T1430Z ACCEPT_PARTIAL | REJECT_PROMOTION
RESULT           = PASS_NARROW (this bag only: candidate table from raw routed reports)
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

What are the existing **routed** tops already in this clone (name, bag, WNS from
raw timing, UART pins present?, IOB count, bit built?) — with hashes — while
PRODUCTION_TOP remains UNKNOWN?

**Four** ASTRA board-level routed candidates (three unique module names). None
chosen. See `CANDIDATES.md`.

| Top | Bag | Raw WNS | UART | IOB | Bit |
|-----|-----|---------|------|----:|-----|
| `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | **+1.041** `timing_route.rpt` Design State=Routed | **NO** | 13 | NOT_BUILT |
| `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | **+5.733** `timing.rpt` Design State=Routed | YES D10/A9 | 15 | UNPROGRAMMED `8116fa77…` |
| `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | **−4.765** `timing.rpt` Design State=Routed | YES D10/A9 | 15 | UNPROGRAMMED `c7442d16…` |
| `arty_a7_astra09_soc_top` | ASTRA-11-TIMING-FIX | **+7.179** `timing.rpt` Design State=Routed | YES D10/A9 | 15 | UNPROGRAMMED `a5c3f2c4…` |

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.

UART from XDC:

- A09 wrap `clk50_impl.xdc`: no `uart_*`; comment “No UART”.
- SoC bags: `constraints/arty_a7_100.xdc` `uart_rxd_out` **D10**, `uart_txd_in` **A9**.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. A09 wrap WNS=+1.041 is not that
top. Wrap-route WNS=+5.733 is a different DUT (`pipe_r2`). TIMING-FIX WNS=+7.179
is a different compile of `arty_a7_astra09_soc_top` than SOC-WRAP WNS=−4.765.
Parent does not pick. This bag does not pick.

## Hashes

Cited-file SHA256 in `SHA256.txt`. Prior-bag files hashed in place, not rewritten.
ACK.json written first.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-12 unique-bit /
UART plan. Master ASTRA-06 DDR/NVM. Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Production-top identity. Auditor ACCEPT_BOARD.
Do **not** call this BOARD_PASS or ASTRA-13. Manager independently accepts.
Do not autonomously open the next gate.
