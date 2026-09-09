# PREREG — ASTRA-11-A09R8-SILICON-UART-01

Owner 2026-09-07: board plugged; approval to **test** the official A09R8 bit.
This bag is **one unknown**: silicon UART smoke of that bit. Not DDR. Not LM.
Not Master ASTRA-13 close. Not BOARD_PASS.

## Frozen before program

```text
BIT_FILE     = results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-UART-FREEZE-BIT-01/a7ng_astra_11_a09r8_uart_freeze_wrap.bit
BIT_SHA256   = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
TOP          = a7ng_astra_11_a09r8_uart_freeze_wrap
JTAG_WANT    = 210319BE776EA
REFUSE       = xc7z020 / 1234-TUL / PYNQ / any other serial / any other .bit
UART         = COM12 115200 8N1
QUERY        = ASCII "pump requires indirect\n"
PLANT        = SW0=ON (sw[1:0]=01 = PLANT_SMOKE). SW0 is a physical Arty switch (pin A8).
EXPECT_SMOKE = MAGIC A2, status ANSWER, ans=4, p0=17, p1=34, EOL 0A
  (XSim ASTRA-09-R7 frame a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a)
WNS_SRC      = A09R8 routed +0.587 / WHS +0.058 / UART hold +1.150 (not this bag's STA)
```

## One unknown

After `program_hw_devices` of the SHA-pinned bit onto JTAG `210319BE776EA` only:
does COM12 return a 16-byte MAGIC-A2 smoke frame with ans=4 p0=17?

If SW0 is physically OFF, plant_sel=0 and mem_rd is zeros — that is a
**setup miss**, not a bit FAIL. Record NEED_SW0. Do not retune RTL.

## Explicitly not this bag

DDR / MIG / index image / LM06 / 800k / Master F3 / BOARD_PASS / ASTRA-13.
Reward-learn on silicon (needs txn/gen/epoch; answer frame does not carry them)
is a **later** unknown. Do not mix.
