# RESULTS — ASTRA-12-R4-R7-UART-CANDIDATES-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name.

```text
GATE             = ASTRA-12-R4-R7-UART-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
R7_NEW_ROWS      = 2
R3_POINTER_ROWS  = 9
R2_POINTER_ROWS  = 4
CANDIDATE_COUNT  = 11
AUDITOR_PRIOR    = 20260907T0200Z ACCEPT_PARTIAL | REJECT_PROMOTION
A09R7_ROUTE_BAG  = PASS_NARROW; false-path-hold HONEST; WNS=+0.336 WHS=+0.104 UART IOB YES
R7_XSIM_BAG      = PASS_NARROW; ans=4 then w0=-5; no routed WNS
RESULT           = PASS_NARROW (this bag only: candidate table from raw reports)
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

Extend the candidate table with R7 UART query-rew XSim and A09R7 UART impl-route,
quoting WNS/WHS from **raw reports**, hashes, IOB, hold-policy, UART D10/A9 yes/no
per row, plus pointers to 12-R2 and 12-R3 tables without rewriting those files,
while PRODUCTION_TOP remains UNKNOWN.

**Two** new R7 rows + **nine** 12-R3 pointer rows (which already include the four
12-R2 tops). Unique count **11**. None chosen. See `CANDIDATES.md`.

| # | Top | Bag | Raw WNS | Raw WHS | UART D10/A9 | IOB FF |
|---|-----|-----|---------|---------|-------------|--------|
| N1 | `a7ng_astra_09_r7_uart_query_rew_wrap` | ASTRA-09-R7-UART-QUERY-REW-01 | N/A (XSim; ans=4 then w0=-5; MAGIC A2 PASS) | N/A | ports YES; PACKAGE_PIN NO | N/A |
| N2 | `a7ng_astra_11_a09r7_uart_impl_wrap` | ASTRA-11-A09R7-UART-IMPL-ROUTE-01 | **+0.336** `timing_route.rpt` Routed | **+0.104** (intra clk50u; UART I/O hold excepted) | YES A9 INPUT / D10 OUTPUT FIXED | YES |

N2 delays from raw XDC: **max 2.000 / min 0.500**.
N2 HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** (honest; UART I/O hold excepted, not physically MET).
U4 WHS=−4.915 bag **not overwritten**.

Pointer (12-R3 / 12-R2 files not rewritten; timing SHA MATCH):
U1 XSim N/A; U2 +0.305; U3 +0.681; U4 +0.115/−4.915; U5 +0.115/+0.131;
P1 +1.041 UART NO; P2 +5.733 UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES.

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. N2 WNS=+0.336 WHS=+0.104 IOB FF YES
is **not** that top. N1 XSim ans=4/w0=-5 is **not** that top. U4 −4.915 remains
the physical hold evidence under min 0.500 with no hold exception.
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
