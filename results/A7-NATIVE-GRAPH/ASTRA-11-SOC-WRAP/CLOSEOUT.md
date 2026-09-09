# CLOSEOUT — ASTRA-11 SOC_WRAP + IMPL_ROUTE

```text
GATE       = ASTRA-11-SOC-WRAP
RESULT     = PASS_NARROW
TOP        = arty_a7_astra09_soc_top
SYNTH      = DONE
IMPL       = DONE
ROUTE      = DONE
WNS        = -4.765 ns
TNS        = -2392.529 ns
WHS        = 0.046 ns
LUT        = 2956
FF         = 1550
DSP        = 2
BRAM       = 0 (empty index const-prop; AXI FSM present)
IOB        = 15 (cited XDC only)
MIG        = NO
BIT        = UNPROGRAMMED
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
QSE_V1     = UNCHANGED ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768
NEXT       = NONE (ASTRA-13 remains BLOCKED; PROGRAM=NO)
```

PASS_NARROW = synth+impl+route complete, WNS/TNS reported, util reported, PROGRAM=NO.

Not claimed: Gate14, NLU, LM06 language, MIG co-fit, BOARD_PASS, 100 MHz timing closed.
