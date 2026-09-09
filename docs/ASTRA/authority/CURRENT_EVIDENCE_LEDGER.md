# CURRENT EVIDENCE LEDGER — post C0 freeze

Authority: Master V1.1 `ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md`.
Truth law: RAW EVIDENCE > accepted gate result > audit interpretation > design
document > status file.

C0 recorded live SHA256 in `FINAL_CONTRACT.json` **before** any C1 800k
inspect. This ledger separates BOARD / XSIM / ROUTE / OPEN. Classes are not
merged.

```text
PROGRAM            = NO  (this C0 bag)
PRODUCTION_TOP     = UNKNOWN
BOARD_PASS         = NOT_CLAIMED
ASTRA-13           = NOT_CLOSED
LM06_BYTE256       = NOT_FROZEN
DDR_INDEX          = NOT_FROZEN
AUDITOR_SILICON    = PENDING  (no REPORT at AUDITOR/20260907T0735Z at freeze time)
```

---

## BOARD

Checkpoint bit (live Get-FileHash MATCH expected):

```text
TOP        = a7ng_astra_11_a09r8_uart_freeze_wrap
BIT_SHA    = e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
FILE       = results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-UART-FREEZE-BIT-01/a7ng_astra_11_a09r8_uart_freeze_wrap.bit
JTAG       = 210319BE776EA
DEVICE     = xc7a100t_0
UART       = COM12 115200 8N1
DUT        = a7ng_astra_09_r2_cand_ovf as u_a09r2
LEFTOVER   = a7ng_astra_09_integ_path NOT instantiated
PLANT      = labeled AXI plant, not DDR/MIG
```

Raw `ASTRA-11-A09R8-SILICON-UART-01/LADDER.txt` (PROGRAM=YES SW0=ON):

```text
TX SMOKE_QUERY 70 75 6d 70 20 72 65 71 75 69 72 65 73 20 69 6e 64 69 72 65 63 74 0a
FRAME_SMOKE    a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE_SMOKE   st=0 acc=1 ans=4 p0=17 p1=34 npath=2
TX REW_M3      a6 fd 01 01 07 00 0a
FRAME_REW      a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
DECODE_REW     w0=-5 phi0=50 nupd=1 nbad=0 tag=0x57 txn=1 gen=1
TX UNREL_QUERY 70 61 79 72 6f 6c 6c 20 74 61 78 20 66 6f 72 6d 0a
FRAME_UNREL    a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
DECODE_UNREL   st=1 ans=0 p0=0 npath=0
OVF_SW1        NOT_RUN
```

Registered XSim R7 frames (`ASTRA-09-R7-UART-QUERY-REW-01` RESULTS, same 16 bytes):

```text
SMOKE_UART  a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
REW_M3_W0   a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
UNREL_UART  a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
```

**Match:** LADDER.txt raw SMOKE / REW / UNREL frames are byte-identical to the
registered XSim R7 frames.

**BOARD checkpoint (narrow, pending independent auditor):** parser → current
plant/evidence path → 2-hop proof → structured answer/status → FPGA-owned
pending reward → shared fixed-point SGD reachability on this bit. Master §4.1
class: `PARSER/REASONER/SGD SILICON REACHABILITY = PROVEN NARROW`.
`FINAL NATIVE AI = NOT PROVEN`.

**Not BOARD_PASS. Not ASTRA-13. Not ACCEPT_BOARD.** Auditor report for the
silicon ladder was not present at C0 freeze (`AUDITOR/20260907T0735Z` missing).

---

## XSIM

Reusable capabilities **within the exact tested laws**. They do not promote
the final integrated path, DDR, or C1–C7.

| Capability | Bag | Class |
|---|---|---|
| Role reversal packets differ (`qse-v2-role-00`) | `ASTRA-03-ROLE-AWARE-QUERY` | XSIM unit |
| Typed 2-hop on loaded edges | `ASTRA-04-RELATION-ENGINE-2HOP` | XSIM unit, not DDR |
| Causal delete/replace/reverse/CONFLICT/INCOMP | `ASTRA-05-CAUSAL-PROOF-PERTURBATION` | XSIM unit, not DDR |
| Shared 32-feature Q8 SGD symmetric RSH | `ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW` + ISO in later bags | XSIM unit |
| A09-R2 ntrunc→INCOMP; smoke ans=4 p0=17 npath=2 | `ASTRA-09-R2-CAND-OVF-01` | XSIM integrator |
| UART query+rew 16-byte frames (R7) | `ASTRA-09-R7-UART-QUERY-REW-01` | XSIM wrap; UNISIM MMCM |
| On-chip warm persist (registers, not DDR) | `ASTRA-06-WARM-PERSIST-01` | XSIM; not C2 |
| C2 persist identity (20-bit tuple, AXI journal, not MIG) | `ASTRA-C2-PERSIST-COMMIT-01` | XSIM PASS_THIS_GATE_ONLY; not Master C2 |
| C2 persist multi-slot CAP_N=2 dirty eviction AXI WB | `ASTRA-C2-PERSIST-MULTI-SLOT-01` | XSIM PASS_THIS_GATE_ONLY; not Master C2; not MIG |
| C2 persist DDR stall AW/W/B + dirty WB | `ASTRA-C2-PERSIST-DDR-STALL-01` | XSIM PASS_THIS_GATE_ONLY; modeled stall not MIG |
| C2 persist through Digilent AXI MIG+ddr3_model | `ASTRA-C2-PERSIST-MIG-01` | XSIM PASS_THIS_GATE_ONLY; feeds C2 CLOSED_XSIM 1652Z |
| C2 XSim law close (warm persist) | `AUDITOR/20260907T1652Z` | CLOSED_XSIM; not BOARD; schema NOT_FROZEN |
| Held-out transfer on frozen two-world generator | `ASTRA-07-HELD-OUT-TRANSFER` / `ASTRA-F3-SHARED-TRANSFER-01` | XSIM; not C3 |
| Historical 800k selectivity **pre-role-law** | `ASTRA-02-U5-SCALE-SELECTIVITY-800K` | XSIM/host historical; **does not close C1** |

R7 XSim also recorded OVF frame
`a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a` (st=6 ans=0). Silicon OVF
(SW1) was **not** run.

---

## ROUTE

Checkpoint wrap route (`ASTRA-11-A09R8-UART-FREEZE-BIT-01`, Design State
Routed 2026-09-07 05:51:07, Vivado 2026.1):

```text
WNS            = 0.587 ns
TNS            = 0.000
WHS            = 0.058 ns
THS            = 0.000
UART_IN_HOLD   = +1.150 ns  (timed; not FALSE_PATH_HOLD)
UART_OUT_HOLD  = +4.064 ns
LUT/FF/BRAM/DSP= 4946 / 3615 / 0 / 2
PIPE_CLK       = clk50u 50.000 MHz
PART           = xc7a100tcsg324-1
```

This is **not** C6 whole-chip co-fit. Master §12: the existing A09R8 bit is
not the final co-fit authority because it does not include the full production
DDR+LM path.

Other route bags (IOBFF hold FAIL, BTN pad hold FAIL, IODELAY UART, etc.)
remain their own objects. Do not collapse FAIL WHS into this checkpoint.

---

## OPEN

Explicitly **not proven** by the checkpoint bit or by C0:

```text
DDR / MIG production index path
stable-law 800k role-aware retrieval          (C1 CLOSED_XSIM 20260907T2148Z; not BOARD; historical U5 cannot close)
production DDR learned-state persistence      (C2 CLOSED_XSIM 20260907T1652Z; AXI journal + MIG_XSIM reload; not BOARD; schema NOT_FROZEN; ASTRA-06 is on-chip registers)
integrated held-out transfer                  (C3 OPEN; w0 0→-5 is reachability, not transfer)
LM06 meaningful grounded generation           (C4 OPEN; class LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN)
LM06_BYTE256                                  NOT_FROZEN
one complete production top                   (C5 OPEN; A09R8 wrap is checkpoint)
final whole-chip co-fit                       (C6 OPEN)
ASTRA-13 blind final exam                     (C7 OPEN)
ASTRA_NATIVE_AI_BOARD_PASS
PRODUCTION_TOP identity
```

C1–C7 one-line unknowns: `OPEN_GATES.md`.
