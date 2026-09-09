# POLICY — ASTRA-12-PREPROGRAM-PACK-01

## Program gate (absolute)

```text
PROGRAM = NO
until ALL of:
  1. ASTRA-13 is the dispatched gate (not this pack)
  2. owner program gate (explicit; board plugged is not it)
  3. WNS >= 0 on THE FROZEN PRODUCTION TOP
  4. auditor ACCEPT_BOARD of that timed bitstream
```

LOOP_STATE `program_gate` string (read-only citation, not edited here):

`ASTRA-13_AND_OWNER_AND_WNS_GE_0_ON_FROZEN_PRODUCTION_TOP_AND_AUDITOR_ACCEPT_BOARD`

This pack does **not** satisfy (1)(2)(3)(4).

## What WNS=+1.041 is not

A09 wrap `a7ng_astra_11_a09_impl_wrap` routed WNS=+1.041 ns @ clk50u 20.000 ns
(Design State=Routed, auditor 20260906T1400Z PASS_NARROW) is:

- **not** WNS on the frozen production top
- **not** SoC UART wrap timing
- **not** permission to `write_bitstream`
- **not** BOARD_PASS
- **not** ASTRA-13

SoC UART wrap remains a **different bag**:

- `arty_a7_astra09_soc_top` in ASTRA-11-SOC-WRAP: UART pins D10/A9, routed
  WNS=**−4.765** (timing not met at 100 MHz), bit UNPROGRAMMED `c7442d16…`
- `arty_a7_astra_rtp_soc_top` in ASTRA-SOC-RTP-WRAP-ROUTE: UART + RTP `pipe_r2`
  + BRAM=2, routed WNS=+5.733, bit UNPROGRAMMED `8116fa77…`

Neither is frozen here as production top. **PRODUCTION_TOP = UNKNOWN.**
Do not pick a top silently.

## Forbidden in this bag and until the gate above

- `write_bitstream`
- JTAG / `xsdb` / `hw_server` / `fpga` / `program_hw*`
- COM12 (owner says plugged; still UNTOUCHED)
- generating a `.bit` for A09 wrap or any other top
- editing prior bags or rerunning their impl/xsim scripts
- claiming BOARD_PASS, ACCEPT_BOARD, or Master ASTRA-11/13 close
- programming Gate14 / LM06 / 01R / 02M frozen bits from this tree

DCP (`write_checkpoint`) in prior bags is not a bitstream and is not authority
to program.

## Owner / board

Owner: Arty A7-100T is plugged. Policy: **PROGRAM=NO**. Plugged ≠ programmed
≠ ACCEPT_BOARD. JTAG serial `210319BE776EA` UNTOUCHED.

## This pack’s allowed product

ACK + PACK.md + MISSING.md + POLICY.md + SHA256 of cited evidence +
RESULTS/CLOSEOUT. Evidence classification only. Manager/auditor independently
accept. Do not autonomously open ASTRA-13.
