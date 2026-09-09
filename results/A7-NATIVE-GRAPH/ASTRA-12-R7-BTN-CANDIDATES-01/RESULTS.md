# RESULTS — ASTRA-12-R7-BTN-CANDIDATES-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.
PRODUCTION_TOP not written as a module name.

```text
GATE             = ASTRA-12-R7-BTN-CANDIDATES-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
BTN_NEW_ROWS     = 2
R6_POINTER_ROWS  = 12 unique
CANDIDATE_COUNT  = 14
AUDITOR_PRIOR    = 20260907T0530Z ACCEPT_PARTIAL | REJECT_PROMOTION
BTN_IO_BAG       = FAIL_WHS; WNS=+0.452 WHS=−2.068 (stays on disk; fail_r0 intact)
BTN_IDELAY_BAG   = PASS_NARROW; TAP=31 WNS=+0.574 WHS=+0.131 BTN hold MET +0.638 false-path-btn NO
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

Extend the candidate table with two BTN rows, quoting WNS/WHS from **raw**
`timing_route.rpt` Design State=Routed: FAIL bag BTN-IO WNS=+0.452 WHS=−2.068;
IDELAY bag TAP=31 WNS=+0.574 WHS=+0.131, BTN pad hold MET +0.638 vs related
clk50u, false-path-btn NO; hashes, IOB, hold-policy; plus pointer to 12-R6
table without rewriting those files, while PRODUCTION_TOP remains UNKNOWN.

**Two** new BTN rows + **twelve** 12-R6 unique pointer rows. Unique count **14**.
None chosen. See `CANDIDATES.md`.

| # | Top | Bag | Raw WNS | Raw WHS | BTN D9/C9/B9/B8 | IDELAY TAP | false-path-btn |
|---|-----|-----|---------|---------|-----------------|------------|----------------|
| F1 | `a7ng_astra_11_a09r7_btn_io_wrap` | ASTRA-11-A09R7-BTN-IO-01 | **+0.452** `timing_route.rpt` Routed | **−2.068** (BTN pad hold `btn[0]`→`btn_q_reg[0]/D`; THS=−8.128, 4 endpoints) | YES INPUT FIXED BTN0–BTN3 | **NO** IDELAYE2=0 | **NO** |
| I1 | `a7ng_astra_11_a09r7_btn_idelay_wrap` | ASTRA-11-A09R7-BTN-IDELAY-01 | **+0.574** `timing_route.rpt` Routed | **+0.131** (intra clk50u `idelay_rdy_sync`; BTN pad hold MET **+0.638** vs clk50u; UART I/O hold excepted) | YES INPUT FIXED BTN0–BTN3 | **YES TAP=31** IDELAYE2=4 + IDELAYCTRL=1 | **NO** |

F1/I1 BTN delays from raw XDC: **max 2.000 / min 0.500** vs related `clk50u`.
F1/I1 BTN HOLD_POLICY **RELATED_CLK50U_NO_FALSE_PATH_HOLD** (no `btn[*]` exception).
F1/I1 UART HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** (honest; UART I/O hold excepted, not physically MET).
F1 WHS=−2.068 bag **not overwritten** (`fail_r0/timing_route.rpt` same SHA as live).
L1 LED wrap WNS=+0.411 WHS=+0.027 bag **not overwritten**.
N2 UART wrap WNS=+0.336 WHS=+0.104 bag **not overwritten**.
U4 WHS=−4.915 bag **not overwritten**.
U5 WHS=+0.131 bag **not overwritten** (HOLD wrap coincidence, not I1).

Pointer (12-R6 files not rewritten; SHA MATCH):
L1 +0.411/+0.027; N1 XSim N/A; N2 +0.336/+0.104; U1 XSim N/A; U2 +0.305;
U3 +0.681; U4 +0.115/−4.915; U5 +0.115/+0.131; P1 +1.041 UART NO; P2 +5.733
UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES.

WNS quoted from raw Design Timing Summary, not RESULTS.md of those bags.

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. I1 WNS=+0.574 WHS=+0.131 TAP=31
BTN IOB YES is **not** that top. F1 WNS=+0.452 WHS=−2.068 is **not** that top.
L1 WNS=+0.411 is **not** that top. N2 WNS=+0.336 is **not** that top.
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
