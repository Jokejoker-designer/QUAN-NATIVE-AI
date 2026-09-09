# RESULTS — ASTRA-11-A09R8-SILICON-UART-01

Owner-approved program of SHA-pinned A09R8 bit. Not DDR. Not LM. Not ASTRA-13.
Not BOARD_PASS.

```text
JTAG_TARGET      = localhost:3121/xilinx_tcf/Digilent/210319BE776EA
DEVICE           = xc7a100t_0
STARTUP          = HIGH
BIT_SHA256       = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
PROGRAM          = PASS  (ASTRA_11_A09R8_SILICON_PROGRAM_PASS)
COM12            = YES 115200 8N1
UART_LINK        = PASS  (16-byte MAGIC A2 … EOL 0A)
SMOKE_SW0_OFF    = UNKNOWN  a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
SMOKE_SW0_ON     = PASS     a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE           = st=0 ANSWER acc=1 ans=4 p0=17 p1=34 npath=2 ntrunc=0
MATCHES_XSIM     = ASTRA-09-R7 SMOKE_UART exact (same 16 bytes)
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = NOT_CLOSED
DDR / LM         = NOT_OPENED
```

## What this proves

1. Correct Arty (serial `210319BE776EA`), not PYNQ.
2. Official bit programmed; FPGA DONE/startup HIGH.
3. COM12 talks to this bitstream: MAGIC A2 framing is silicon-real.
4. After owner SW0=ON and `A7 0A` retire of the prior HOLD: query
   `"pump requires indirect\n"` returned the **exact** XSim smoke frame
   `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` (ans=4 p0=17 p1=34 npath=2).

## What this does not prove

Reward w0=-5 on silicon (txn/gen/epoch not in the answer frame). DDR. LM06.
BOARD_PASS. ASTRA-13.
