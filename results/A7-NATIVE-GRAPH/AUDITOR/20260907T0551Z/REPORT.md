# AUDITOR — 20260907T0551Z — ASTRA-11-A09R8-UART-FREEZE-BIT-01

Independent of implementer RESULTS prose. Authority = raw reports + live bit hash.

## Verdict

```text
ACCEPT_PARTIAL
REJECT_PROMOTION
ACCEPT_BOARD     = MISSING
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN  (owner still required)
PROGRAM          = NO  (confirmed: vivado.log has no open_hw / program_hw / xsdb / COM12)
```

## Checked

1. DTS `timing_route.rpt` Design `a7ng_astra_11_a09r8_uart_freeze_wrap` State **Routed**
   Date **Mon Sep 7 05:51:07 2026**: WNS=**0.587** TNS=0.000 WHS=**0.058** THS=0.000.
   “All user specified timing constraints are met.”
2. Inter-clock hold **not blank**: uart_io_vclk→clk50u WHS=**1.150**; clk50u→uart_io_vclk WHS=**4.064**.
3. `exceptions_route.rpt`: false-path only `sw[*]` and `btn[*]`. **No** UART hold exception.
4. Capture `u_rx/rx_sync0_reg` LOC=`SLICE_X18Y163` BEL=`SLICEL.AFF` IOB_PACKED=**NO**.
   ILOGIC=0 OLOGIC=0. B's IOB-IFF defect is absent.
5. Live SHA256 of `a7ng_astra_11_a09r8_uart_freeze_wrap.bit` =
   `E51BDCA253A7179AA1037695918D0069C43770581A3152665FB8A2739ED461BB` MATCH
   `SHA256_BIT.txt`. STATUS=UNPROGRAMMED. Size 3826016 bytes.
6. Frozen A09-R2 hash still `15a919f1…` (ps1 gate). uart_rx/uart_tx not patched.

## Reject promotion because

- Owner has not written `PRODUCTION_TOP=<module>`.
- No ACCEPT_BOARD. No silicon UART transcript.
- AXI plant is still behavioral (BRAM=0). DDR OPEN.
- LM06 / Master F3 / ASTRA-13 remain OPEN.

Do not program this bit unless the owner says **nạp** after ACCEPT_BOARD.
