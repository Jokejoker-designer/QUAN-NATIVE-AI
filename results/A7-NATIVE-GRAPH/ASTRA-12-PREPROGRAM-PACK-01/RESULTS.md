# RESULTS — ASTRA-12-PREPROGRAM-PACK-01

PROGRAM=NO. No JTAG/COM12/bit/write_bitstream/hw_server. Prior bags not edited.
Those bags' run scripts not rerun. Frozen RTL not patched. No `.bit` generated.
LM06 / BOARD / DDR / Master F3 / ASTRA-13 not opened. BOARD_PASS not claimed.

```text
GATE             = ASTRA-12-PREPROGRAM-PACK-01
PRODUCTION_TOP   = UNKNOWN
AUDITOR_PRIOR    = 20260906T1400Z ACCEPT_PARTIAL | REJECT_PROMOTION
A09_WRAP_WNS     = +1.041 ns  (raw timing_route.rpt Design State=Routed; clk50u)
A09_XSIM_MARKER  = ASTRA_09_INTEGRATED_PATH_XSIM_PASS
A10_UTIL_SYNTH   = LUT 5178 FF 4155 BRAM 0 DSP 2  (Design State=Synthesized)
R4_XSIM_MARKER   = ASTRA_06_R4_SESS_REUSE_XSIM_PASS
RESULT           = PASS_NARROW (this bag only: frozen evidence pack + explicit missing)
BIT              = NOT_BUILT
PROGRAM          = NO
COM12            = UNTOUCHED
JTAG             = 210319BE776EA UNTOUCHED
BOARD            = BLOCKED
BOARD_PASS       = NOT_CLAIMED
ASTRA-13         = BLOCKED
```

## One unknown (answered)

Can a frozen evidence pack list, with hashes, the routed A09 wrap WNS, the A09
XSim marker, persist/handshake bags, and **explicit missing items** (UART/LED
I/O, SoC top identity, bitstream SHA, auditor ACCEPT_BOARD) — without claiming
BOARD_PASS?

**Yes.** See `PACK.md` + `MISSING.md` + `POLICY.md` + `SHA256.txt`.

Quoted WNS from raw `ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt`
SHA256 `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72`:

```text
Design State : Routed
WNS(ns)=1.041  TNS=0.000  WHS=0.160  THS=0.000
All user specified timing constraints are met.
```

A09 XSim marker from raw `ASTRA-09-INTEGRATED-PATH-01/xsim.log`
SHA256 `445199d247c3f8e47ad2ea5204d46127f9c5eda9207239d7f4a800664b15caa7`:

```text
ASTRA_09_INTEGRATED_PATH_XSIM_PASS
```

ASTRA-10 `util_synth.rpt` SHA256
`3933db007c1a1011a3e32fd0a10996d6b7e70cd9de708dfaf43548f3217217ac`:
LUT=5178 FF=4155 BRAM=0 DSP=2 Design State=Synthesized.

R4 marker from raw `ASTRA-06-R4-SESS-REUSE-01/xsim.log`
SHA256 `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f`:

```text
ASTRA_06_R4_SESS_REUSE_XSIM_PASS
```

## Production-top identity

**UNKNOWN.** Not frozen. Not silently chosen. A09 wrap WNS=+1.041 is **not**
that top (`POLICY.md`). SoC UART wrap remains a different bag.

## Missing (explicit; not closed)

UART on frozen production top. Pinout identity vs wrap-route SoC (13 vs 15 IOB;
UART D10/A9 absent on A09 wrap). Bitstream SHA of frozen production top.
ASTRA-13. LM06 language. Master F3 10pp/CI. Auditor ACCEPT_BOARD (zero hits in
AUDITOR reports). LED `no_output_delay` close.

## Hashes

Cited-file SHA256 in `SHA256.txt`. Prior-bag files hashed in place, not rewritten.
ACK.json written first.

## Open (unchanged)

Master ASTRA-09. Master ASTRA-11 FULLCHIP-COFIT. Master ASTRA-06 DDR/NVM.
Master F3 10pp/CI. LM06. BOARD_PASS. ASTRA-13. Production-top identity.
Do **not** call this BOARD_PASS or ASTRA-13. Manager independently accepts.
Do not autonomously open the next gate.
