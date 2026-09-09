# RESULTS — ASTRA-12-R5-FREEZE-BRIEF-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name. Winner not recommended as frozen.

```text
GATE             = ASTRA-12-R5-FREEZE-BRIEF-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
COLUMNS          = 2
AUDITOR_PRIOR    = 20260907T0230Z ACCEPT_PARTIAL | REJECT_PROMOTION
TABLE_PRIOR      = ASTRA-12-R4-R7-UART-CANDIDATES-01 PASS_NARROW unique 11
COLUMN_A         = arty_a7_astra_rtp_soc_top  WNS=+5.733 WHS=+0.029 UART D10/A9 BRAM=2 IOB FF NO
COLUMN_B         = a7ng_astra_11_a09r7_uart_impl_wrap  WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST
RESULT           = PASS_NARROW (this bag only: two-column brief from raw reports; no freeze)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
BOARD            = BLOCKED
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
write_bitstream  = not called
ACCEPT_BOARD     = MISSING
```

## One unknown (answered)

Decision brief comparing two strongest existing routed UART candidates, quoting
WNS/WHS/IOB/util/XDC from **raw reports** with hashes, plus gaps per column
(unique bit, ACCEPT_BOARD, LM06, fixture plant, FALSE_PATH_HOLD, 100 MHz fail
sibling), while PRODUCTION_TOP remains UNKNOWN.

**Two columns. None chosen.** See `BRIEF.md`.

| Col | Top | Bag | Raw WNS | Raw WHS | UART D10/A9 | IOB FF | BRAM |
|-----|-----|-----|---------|---------|-------------|--------|------|
| A | `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | **+5.733** `timing.rpt` Routed (async_default; intra clk50u +7.150) | **+0.029** (no UART I/O envelope) | YES A9 INPUT / D10 OUTPUT FIXED | NO (ILOGIC=0 OLOGIC=0) | **2** |
| B | `a7ng_astra_11_a09r7_uart_impl_wrap` | ASTRA-11-A09R7-UART-IMPL-ROUTE-01 | **+0.336** `timing_route.rpt` Routed | **+0.104** (intra clk50u; UART I/O hold excepted) | YES A9 INPUT / D10 OUTPUT FIXED | YES (2 packed) | **0** |

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.
R7 XSim ans=4/w0=-5 is a **different** bag and is **not** column B.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. Column A is **not** that top.
Column B is **not** that top. Historical UNPROGRAMMED bit `8116fa77…` is **not**
that top. Parent does not pick. This bag does not pick.

## Gaps (both columns; not closed)

Unique production bit. Auditor ACCEPT_BOARD. LM06. Physical IOB hold MET.
100 MHz fail sibling `arty_a7_astra09_soc_top` WNS=−4.765 still on disk — do not
collapse with A or B. Column A FALSE_PATH_HOLD on UART is **absent**. Column B
FALSE_PATH_HOLD is **honest** (excepted, not MET). Fixture plants differ
(silicon BRAM vs behavioral AXI) and are **not** interchangeable.

## Hashes

Cited-file SHA256 in `SHA256.txt`. Prior-bag files hashed in place, not rewritten.
ACK.json written first.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-12 unique-bit /
UART plan. Master ASTRA-06 DDR/NVM. Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Production-top identity. Auditor ACCEPT_BOARD. Physical IOB hold MET.
Do **not** call this BOARD_PASS or ASTRA-13. Manager independently accepts.
Do not autonomously open the next gate.
