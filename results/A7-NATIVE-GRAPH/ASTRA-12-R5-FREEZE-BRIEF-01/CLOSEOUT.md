# CLOSEOUT — ASTRA-12-R5-FREEZE-BRIEF-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-12-R5-FREEZE-BRIEF-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
PRODUCTION_TOP       = UNKNOWN
WINNER               = NOT_FROZEN
COLUMNS              = 2
BIT                  = NOT_BUILT
PROGRAM              = NO
COM12 / JTAG         = UNTOUCHED
write_bitstream      = not called
BOARD                = BLOCKED
BOARD_PASS           = NOT_CLAIMED
ASTRA-13             = BLOCKED
ACCEPT_BOARD         = MISSING
Master_ASTRA-09 / Master_ASTRA-11 / Master_ASTRA-12_unique_bit / Master_F3_10pp / Master_ASTRA-06 / LM06 = OPEN
```

## Evidence

- Two-column brief + raw WNS/WHS + UART D10/A9 + IOB/hold-policy + required gaps: `BRIEF.md`
- Cited hashes: `SHA256.txt`
- ACK first: `ACK.json`
- Authority: prior-bag `timing.rpt` / `timing_route.rpt` / XDC / `io.rpt` / `util*.rpt` / `exceptions_route.rpt` (not rewritten)
- Auditor prior: `AUDITOR/20260907T0230Z/REPORT.md` ACCEPT_PARTIAL | REJECT_PROMOTION; 12-R4 table PASS_NARROW unique 11; PRODUCTION_TOP stays UNKNOWN; ASTRA-13 BLOCKED; residual 8: freeze a production top **or keep UNKNOWN**

## Next dependency

Independent auditor of this brief. Do not open ASTRA-13, LM06, BOARD, DDR, or
Master F3 from this bag. PROGRAM=NO. Production-top identity remains UNKNOWN
until a **named freeze** in a later dispatched gate. This bag is not that freeze.
Do not recommend column A or column B as frozen. Do not promote B WHS=+0.104 as
physical IOB hold MET. Do not adopt historical UNPROGRAMMED bit `8116fa77…`.
Do not collapse either column with 100 MHz WNS=−4.765. Keep U4 WHS=−4.915 on disk.
Do not promote R7 XSim ans=4/w0=-5 as column B.
