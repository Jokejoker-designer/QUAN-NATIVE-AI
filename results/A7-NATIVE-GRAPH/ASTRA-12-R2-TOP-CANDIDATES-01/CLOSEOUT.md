# CLOSEOUT — ASTRA-12-R2-TOP-CANDIDATES-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-12-R2-TOP-CANDIDATES-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
PRODUCTION_TOP       = UNKNOWN
WINNER               = NOT_FROZEN
CANDIDATE_COUNT      = 4
UNIQUE_MODULES       = 3
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

- Candidate table + raw WNS + UART XDC quotes: `CANDIDATES.md`
- Cited hashes: `SHA256.txt`
- ACK first: `ACK.json`
- Authority: prior-bag `timing_route.rpt` / `timing.rpt` Design State=Routed (not rewritten)
- Auditor prior: `AUDITOR/20260906T1430Z/REPORT.md` ACCEPT_PARTIAL | REJECT_PROMOTION; PRODUCTION_TOP stays UNKNOWN

## Next dependency

Independent auditor of this table. Do not open ASTRA-13, LM06, BOARD, DDR, or
Master F3 from this bag. PROGRAM=NO. Production-top identity remains UNKNOWN
until a **named freeze** in a later dispatched gate. This bag is not that freeze.
