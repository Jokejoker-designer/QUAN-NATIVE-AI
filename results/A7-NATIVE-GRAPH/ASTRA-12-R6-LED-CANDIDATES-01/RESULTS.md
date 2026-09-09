# RESULTS — ASTRA-12-R6-LED-CANDIDATES-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name.

```text
GATE             = ASTRA-12-R6-LED-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
LED_NEW_ROWS     = 1
R4_POINTER_ROWS  = 11 unique
R5_POINTER       = BRIEF two-column (not extra unique tops)
CANDIDATE_COUNT  = 12
AUDITOR_PRIOR    = 20260907T0400Z ACCEPT_PARTIAL | REJECT_PROMOTION
LED_ROUTE_BAG    = PASS_NARROW; WNS=+0.411 WHS=+0.027 LED IOB YES UART D10/A9 kept
RESULT           = PASS_NARROW (this bag only: candidate table from raw reports)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
BOARD            = BLOCKED
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
LM06             = OPEN
write_bitstream  = not called
```

## One unknown (answered)

Extend the candidate table with the LED wrap, quoting WNS/WHS from **raw**
`timing_route.rpt` Design State=Routed, LED H5/J5/T9/T10, UART A9/D10 kept,
hashes, IOB, hold-policy, plus pointers to 12-R4 and 12-R5 tables without
rewriting those files, while PRODUCTION_TOP remains UNKNOWN.

**One** new LED row + **eleven** 12-R4 unique pointer rows. 12-R5 brief is
pointed, not an extra unique top. Unique count **12**. None chosen.
See `CANDIDATES.md`.

| # | Top | Bag | Raw WNS | Raw WHS | LED H5/J5/T9/T10 | UART D10/A9 | IOB FF |
|---|-----|-----|---------|---------|------------------|-------------|--------|
| L1 | `a7ng_astra_11_a09r7_led_io_wrap` | ASTRA-11-A09R7-LED-IO-01 | **+0.411** `timing_route.rpt` Routed | **+0.027** (intra clk50u; LED hold MET +2.927 vs clk50u; UART I/O hold excepted) | YES OUTPUT FIXED LD4–LD7 | YES A9 INPUT / D10 OUTPUT FIXED | YES (6 packed) |

L1 LED delays from raw XDC: **max 2.000 / min 0.500** vs related `clk50u`.
L1 LED HOLD_POLICY **RELATED_CLK50U_NO_FALSE_PATH_HOLD** (no `led[*]` exception).
L1 UART HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** (honest; UART I/O hold excepted, not physically MET).
U4 WHS=−4.915 bag **not overwritten**.
N2 UART wrap WNS=+0.336 WHS=+0.104 bag **not overwritten**.

Pointer (12-R4 / 12-R5 files not rewritten; SHA MATCH):
N1 XSim N/A; N2 +0.336/+0.104; U1 XSim N/A; U2 +0.305; U3 +0.681;
U4 +0.115/−4.915; U5 +0.115/+0.131; P1 +1.041 UART NO; P2 +5.733 UART YES;
P3 −4.765 UART YES; P4 +7.179 UART YES. 12-R5 columns A/B = P2/N2, not extra.

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. L1 WNS=+0.411 WHS=+0.027 LED IOB
YES is **not** that top. N2 WNS=+0.336 is **not** that top. 12-R5 columns are
**not** that top. Parent does not pick. This bag does not pick.

## Hashes

Cited-file SHA256 in `SHA256.txt`. Prior-bag files hashed in place, not rewritten.
ACK.json written first.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-12 unique-bit /
UART plan. Master ASTRA-06 DDR/NVM. Master F3 10pp/CI. LM06. BOARD_PASS.
ASTRA-13. Production-top identity. Auditor ACCEPT_BOARD. Physical IOB hold MET.
Do **not** call this BOARD_PASS or ASTRA-13. Manager independently accepts.
Do not autonomously open the next gate.
