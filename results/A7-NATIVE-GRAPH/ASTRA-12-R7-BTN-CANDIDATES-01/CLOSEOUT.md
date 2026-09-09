# CLOSEOUT — ASTRA-12-R7-BTN-CANDIDATES-01

```text
RESULT               = PASS_THIS_GATE_ONLY
TASK                 = ASTRA-12-R7-BTN-CANDIDATES-01
SESSION              = UNKNOWN
BASE                 = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
PRODUCTION_TOP       = UNKNOWN
WINNER               = NOT_FROZEN
BTN_NEW_ROWS         = 2
R6_POINTER_ROWS      = 12 unique
CANDIDATE_COUNT      = 14
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

- BTN candidate table + raw WNS/WHS + TAP=31 + BTN D9/C9/B9/B8 + false-path-btn NO + UART D10/A9 + LED H5/J5/T9/T10 + IOB/hold-policy: `CANDIDATES.md`
- Cited hashes: `SHA256.txt`
- ACK first: `ACK.json`
- Authority: prior-bag `timing_route.rpt` / `timing_btn_in.rpt` / XDC / `io.rpt` / `util_route.rpt` / `exceptions_route.rpt` / `clocks_route.rpt` / `BTN_IDELAYE2.txt` (not rewritten)
- Auditor prior: `AUDITOR/20260907T0530Z/REPORT.md` ACCEPT_PARTIAL | REJECT_PROMOTION; A09R7 BTN-IDELAY bag PASS_NARROW CLOSED_NARROW TAP=31 WNS=+0.574 WHS=+0.131; DTS WHS intra-clk50u; BTN pad hold MET +0.638; false-path-btn NO; FAIL bag still WHS=−2.068; PRODUCTION_TOP stays UNKNOWN; ASTRA-13 BLOCKED

## Next dependency

Independent auditor of this table. Do not open ASTRA-13, LM06, BOARD, DDR, or
Master F3 from this bag. PROGRAM=NO. Production-top identity remains UNKNOWN
until a **named freeze** in a later dispatched gate. This bag is not that freeze.
Do not promote I1 WHS=+0.131 as BTN pad hold or as physical UART IOB hold MET.
Keep F1 WHS=−2.068 on disk (`fail_r0/` intact). Keep L1 WNS=+0.411 WHS=+0.027
on disk. Keep N2 WNS=+0.336 WHS=+0.104 on disk. Keep U4 WHS=−4.915 on disk.
Do not freeze `PRODUCTION_TOP=a7ng_astra_11_a09r7_btn_idelay_wrap`.
Do not `set_false_path` on `btn[*]`. Do not retune 2.000/0.500.
Do not edit ASTRA-11-A09R7-BTN-IO-01 or ASTRA-11-A09R7-BTN-IDELAY-01.
