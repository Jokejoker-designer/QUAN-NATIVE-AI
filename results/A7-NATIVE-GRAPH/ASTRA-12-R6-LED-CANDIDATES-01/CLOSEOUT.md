# CLOSEOUT — ASTRA-12-R6-LED-CANDIDATES-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-12-R6-LED-CANDIDATES-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
PRODUCTION_TOP       = UNKNOWN
WINNER               = NOT_FROZEN
LED_NEW_ROWS         = 1
R4_POINTER_ROWS      = 11 unique
R5_POINTER           = BRIEF (not extra unique tops)
CANDIDATE_COUNT      = 12
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
BOARD                = BLOCKED
BOARD_PASS           = NOT_CLAIMED
ASTRA-13             = BLOCKED
LM06                 = OPEN
ACCEPT_BOARD         = MISSING
Master_ASTRA-09 / Master_ASTRA-11 / Master_ASTRA-12_unique_bit / Master_F3_10pp / Master_ASTRA-06 / LM06 = OPEN
```

## Evidence

- LED candidate table + raw WNS/WHS + LED H5/J5/T9/T10 + UART D10/A9 + IOB/hold-policy: `CANDIDATES.md`
- Cited hashes: `SHA256.txt`
- ACK first: `ACK.json`
- Authority: prior-bag `timing_route.rpt` / `timing_led_out.rpt` / XDC / `io.rpt` / `util_route.rpt` / `exceptions_route.rpt` / `clocks_route.rpt` (not rewritten)
- Auditor prior: `AUDITOR/20260907T0400Z/REPORT.md` ACCEPT_PARTIAL | REJECT_PROMOTION; A09R7 LED bag PASS_NARROW CLOSED_NARROW; DTS WHS intra-clk50u; LED hold MET +2.927; UART false-path-hold HONEST; PRODUCTION_TOP stays UNKNOWN; ASTRA-13 BLOCKED

## Next dependency

Independent auditor of this table. Do not open ASTRA-13, LM06, BOARD, DDR, or
Master F3 from this bag. PROGRAM=NO. Production-top identity remains UNKNOWN
until a **named freeze** in a later dispatched gate. This bag is not that freeze.
Do not promote L1 WHS=+0.027 as LED pad hold or as physical UART IOB hold MET.
Keep U4 WHS=−4.915 on disk. Keep N2 WNS=+0.336 WHS=+0.104 on disk.
Do not freeze `PRODUCTION_TOP=a7ng_astra_11_a09r7_led_io_wrap`.
