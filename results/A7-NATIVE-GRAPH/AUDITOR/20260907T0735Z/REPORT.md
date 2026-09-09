# ASTRA auditor REPORT — 20260907T0735Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO (this process: no JTAG / xsdb / COM12 / write_bitstream / hw_server)
RTL_EDIT   = NO
FIX        = NO (report only)
BAGS       = ASTRA-11-A09R8-SILICON-UART-01 + ASTRA-11-A09R8-UART-FREEZE-BIT-01 (STA/SHA spot-check)
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY
           AUDITOR_BOOT.md + GSTACK_LOOP.md + LOOP_STATE.json (read, not written)
           Master V1.1 POST_SILICON C0–C7
           prior freeze auditor 20260907T0551Z (STA/bit only; no silicon UART then)
EVIDENCE   = RAW LADDER.txt / UART_SMOKE*.txt / vivado_program*.log / PROGRAM.txt
           + timing_route.rpt Design Timing Summary + timing_uart_in.rpt + timing_uart_out.rpt
           + exceptions_route.rpt + util_route.rpt + UART_IOBFF.txt
           + SHA256_BIT.txt vs live Get-FileHash
           + wrap.sv / plant.sv / a7ng_astra_09_r2_cand_ovf.sv (load_from_tb_o)
           + XSim R7 xsim.log frames as REFERENCE ONLY
           RESULTS.md / CLOSEOUT.md / LADDER_CLOSEOUT.md are HUNTED, not authority
ACCEPT_BOARD = MISSING
BOARD_PASS   = NOT_CLAIMED (and not granted)
ASTRA-13     = BLOCKED
PRODUCTION_TOP = UNKNOWN
C1–C7        = NOT CLOSED
```

This auditor did not program the board, did not edit `rtl/`, did not edit implementer bags, did not write a V3.1 tree, and did not spawn agents. Implementer program of the pinned checkpoint is in `vivado_program_ladder.log`; it is re-derived below, not repeated.

---

## Scope

Read-only except this file.

Primary object: silicon program + UART ladder bag

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-SILICON-UART-01/`

with mandatory re-spot-check of the SHA-pinned freeze bit and wrap/plant

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-UART-FREEZE-BIT-01/`

Owner ACK (`ACK.json` 2026-09-07 07:21:24) authorized **test** of the official A09R8 bit on plugged Arty A7. GSTACK_LOOP allows checkpoint SHA `e51bdca2…` as a **test vehicle only**, not as `write_bitstream` of a new top and not as ASTRA-13.

One unknown (silicon PREREG): after `program_hw_devices` of SHA-pinned bit onto JTAG `210319BE776EA` only, does COM12 return MAGIC-A2 smoke `ans=4 p0=17`?

Ladder expansion (LADDER_PREREG 07:28:21, after first smoke): same SHA, reprogram for clean POR, then SMOKE / REW_M3 / RETIRE / UNREL. OVF_SW1 explicitly NOT_RUN.

**Not** this checkpoint: C0 law freeze close, C1 800k role-aware retrieval, C2 DDR/MIG persistence, C3 held-out transfer, C4 LM06 language, C5 one production top, C6 whole-chip co-fit, C7 blind exam, `ASTRA_NATIVE_AI_BOARD_PASS`, `ACCEPT_BOARD`, owner `PRODUCTION_TOP=<module>`.

Hunt (boot + GSTACK_LOOP, none dropped):

1. Plant LUT called production DDR / 800k retrieval
2. w0 0→-5 called C3 held-out transfer
3. A09R8 wrap called C5 production top or ASTRA-13 / BOARD_PASS
4. RESULTS overclaim vs LADDER.txt
5. Bit SHA mismatch
6. Wrong JTAG serial / PYNQ
7. `load_from_tb` as query authority
8. Tautology: oracle is the same plant that defines the answer
9. Hash theatre / log-RESULTS mismatch / TB-loaded facts as retrieval

---

## Evidence re-derived

### 1) Freeze bit identity and live SHA

Live `Get-FileHash SHA256` of

`results/A7-NATIVE-GRAPH/ASTRA-11-A09R8-UART-FREEZE-BIT-01/a7ng_astra_11_a09r8_uart_freeze_wrap.bit`

```text
e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
bytes = 3826016
```

MATCH `SHA256_BIT.txt` line 1, MATCH `SHA256_POST.txt` bit line, MATCH silicon `PROGRAM.txt` / `ACK.json` / `program.tcl` `want_sha`, MATCH expected live SHA in the dispatch.

`SHA256_BIT.txt` still records bag-local `STATUS=UNPROGRAMMED PROGRAM=NO` from impl time. That is **not** current board state. Board program is the silicon bag’s `PROGRAM.txt` / Vivado logs.

Live source hashes MATCH freeze `SHA256.txt` / `SHA256_POST.txt` compiled set (not theatre):

```text
f4ff4d769d4f1acb1e718b283562ee47a03bf69f99bccb6554b754a86610d443  a7ng_astra_11_a09r8_uart_freeze_wrap.sv
d7951ce830f19ed2e3f0dd0a5729582da52f0aedd8e361acff1534c899a3a1d0  a7ng_astra_11_a09r8_uart_freeze_plant.sv
c9dc8de7c516e7a11a99d18c76a4e3dec354f26429540e260429efcd9f3a6e43  clk50_uart_freeze.xdc
15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23  rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv
8e802d0b4f7466d7683c9b0109d6666ba5b5d77cf67e45f5ab7c0564bcd5369a  rtl/board/uart_rx.sv
b4b7d09758cc95bb52a382bf5c11b5861ddcf0f74055d478824386531b36367b  rtl/board/uart_tx.sv
```

Frozen A09-R2 / uart_rx / uart_tx hashes unchanged vs T0551Z.

### 2) Routed STA (freeze bag) — `timing_route.rpt` is authority

Header:

```text
Tool Version : Vivado v.2026.1 Build 6511674
Date         : Mon Sep  7 05:51:07 2026
Design       : a7ng_astra_11_a09r8_uart_freeze_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row:

```text
WNS=0.587  TNS=0.000  TNS failing=0 / 8940
WHS=0.058  THS=0.000  THS failing=0 / 8940
WPWS=3.000 TPWS=0.000
All user specified timing constraints are met.
```

Clock Summary: `clk50u` period **20.000 ns / 50.000 MHz** (MMCM 100→50). `sys_clk_pin` 10.000 ns is the pin, not the pipe.

Intra-clock `clk50u`: WNS=0.587 WHS=0.058 (TNS endpoints 7245).

Inter-clock table **not blank** (this is the B-bag RCA: UART hold was previously excepted):

```text
uart_io_vclk → clk50u   WNS=15.108  WHS=1.150
clk50u → uart_io_vclk   WNS=5.432   WHS=4.064
```

`timing_uart_in.rpt` Date 05:51:12, Design State Routed, hold Slack **MET 1.150 ns**: `uart_txd_in` (A9) → `u_rx/rx_sync0_reg/D` (FDSE, clk50u). Input Delay 0.500 ns. Not ILOGIC IFF.

`timing_uart_out.rpt` hold Slack **MET 4.064 ns**: `u_tx/tx_reg/C` → `uart_rxd_out` (D10 OBUF). Output Delay 0.500 ns.

`exceptions_route.rpt` Date 05:51:12 Routed: false-path **only** `sw[*]` and `btn[*]`. **No** UART `set_false_path -hold`. MATCH XDC.

`UART_IOBFF.txt`: RX capture `u_rx/rx_sync0_reg` `SLICE_X18Y163` `SLICEL.AFF` IOB_PACKED=**NO**; TX `u_tx/tx_reg` `SLICE_X3Y151` IOB_PACKED=**NO**.

`util_route.rpt` Routed occupancy (not RESULTS prose):

```text
Slice LUTs=4946  Slice Registers=3615  BRAM Tile=0  DSP=2
Bonded IOB=15  ILOGIC=0  OLOGIC=0
```

BRAM=0 is physical confirmation the AXI “memory” is **not** a BRAM store. DSP=2 is occupancy of this graph DUT, **not** the eam03e DSP=0 gate and **not** a C-gate close.

TIMING_EXTRACT.txt WNS/WHS MATCH DTS. Freeze RESULTS.md WNS/WHS MATCH DTS. No STA number invention found on the freeze bag.

### 3) Program path — raw Vivado, not RESULTS

Two program sessions, **same** bit SHA, **same** JTAG, **same** device. Not PYNQ.

| Log | Session start | Marker |
|-----|---------------|--------|
| `vivado_program.log` | Mon Sep 7 07:21:41 2026 | first program + later UART_SMOKE timeout |
| `vivado_program_ladder.log` | Mon Sep 7 07:28:31 2026 | reprogram then LADDER.txt |

`vivado_program_ladder.log` raw:

```text
BIT_SHA_OK e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
HW_TARGETS=localhost:3121/xilinx_tcf/Digilent/210319BE776EA
HW_DEVICES=xc7a100t_0
PROGRAM_BEGIN file=.../a7ng_astra_11_a09r8_uart_freeze_wrap.bit
  target=localhost:3121/xilinx_tcf/Digilent/210319BE776EA device=xc7a100t_0
End of startup status: HIGH
ASTRA_11_A09R8_SILICON_PROGRAM_PASS ... sha=e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
Exiting Vivado at Mon Sep  7 07:28:51 2026
```

`PROGRAM.txt` (written by `program.tcl` after `program_hw_devices`):

```text
STATUS=PROGRAMMED
SHA256=e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb
TARGET=localhost:3121/xilinx_tcf/Digilent/210319BE776EA
DEVICE=xc7a100t_0
JTAG=210319BE776EA
COM12=NOT_IN_THIS_TCL
```

`program.tcl` refuses `1234-TUL` / `xc7z020` / forbidden bit name fragments; hashes the file before program. HW_TARGETS string contains **only** `210319BE776EA`. No Zynq device listed.

Hunt **wrong JTAG / PYNQ**: MISS (correct Arty A7-100T serial).

Hunt **bit SHA mismatch**: MISS (live = file = log = want).

LADDER_PREREG states reprogram is for **clean POR** so first txn matches XSim first-smoke (`live_epoch_i=16'd7`, txn/gen=1). That is disclosed setup, not a silent second bit. GSTACK “do not repeat A09R8 smoke to farm PASS” still applies going forward: this ladder is the silicon record; do not re-run it to accumulate markers.

### 4) UART raw captures vs XSim R7 reference

XSim reference (NOT silicon) `ASTRA-09-R7-UART-QUERY-REW-01/xsim.log`:

```text
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
FRAME REW_OBS    a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
FRAME UNREL_UART a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
```

#### First smoke (pre-ladder) — FAIL/timeout, still on disk

`UART_SMOKE.txt` 07:24:19:

```text
FRAME_TIMEOUT bytes=0 dump=EMPTY
NEED_SW0_OR_NO_TX
```

`FIRST_DIVERGENCE.txt` **still** (not cleared after later PASS):

```text
FIRST_DIVERGENCE UART_TIMEOUT dump=EMPTY
```

This is **zero bytes**. It is not an UNKNOWN frame.

#### Smoke2 (SW0 presumed ON, retire then query) — PASS

`UART_SMOKE2.txt` 07:25:21 PORTS include COM12. After `A7 0A` retire, query `"pump requires indirect\n"`:

```text
RX_N=16 dump=a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE magic=0xa2 st=0 acc=1 rov=0 wov=0 ans=4 p0=17 p1=34 npath=2 ntrunc=0 eol=0x0a
SMOKE=PASS
```

Byte `[1]=0x10` = `{tbl,r_ovf,w_ovf,pend_acc,status}` → **tbl=0**, pend_acc=1, status=0. MATCH XSim SMOKE_UART_TBL0.

#### Ladder (post-reprogram, header `PROGRAM=YES SW0=ON`) — PASS three frames

`LADDER.txt` 2026-09-07T07:28:52.6358140+07:00, PORTS include COM12, PRE_JUNK=EMPTY.

| Step | TX | RX 16-byte frame | Decode from **this** file |
|------|----|------------------|---------------------------|
| SMOKE | ASCII `pump requires indirect\n` (`70 75 6d 70 … 0a`) | `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` | st=0 acc=1 ans=4 p0=17 p1=34 npath=2 |
| REW_M3 | `a6 fd 01 01 07 00 0a` | `a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a` | w0=-5 (`fb ff`) phi0=50 (`32`) nupd=1 nbad=0 tag=0x57 txn=1 gen=1 |
| RETIRE | `a7 0a` | EMPTY | script always logs PASS RETIRE_SENT |
| UNREL | ASCII `payroll tax form\n` | `a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a` | st=1 ans=0 p0=0 npath=0 |

All three 16-byte frames are **byte-identical** to XSim R7. Marker `ASTRA_11_A09R8_SILICON_LADDER_PASS`. `OVF_SW1=NOT_RUN`. `BOARD_PASS=NOT_CLAIMED ASTRA-13=NOT_CLOSED DDR=NOT_OPENED`.

REW byte `[1]=0x60` on wrap OBS packing `{tbl,pend_cmt,pend_acc,1'b0,status}` → tbl=0, pend_cmt=1, pend_acc=1. That is an on-chip commit observation, **not** a 5-seed held-out protocol.

UNREL with **SW0 still ON** (LADDER header and LADDER_PREREG) returning UNKNOWN is query-selectivity vs a two-key plant, not a SW0-off test.

### 5) Wrap / plant — plant_sel, mem_rd, load_from_tb

Wrap instantiates frozen `a7ng_astra_09_r2_cand_ovf u_a09r2` and bag-local `a7ng_astra_11_a09r8_uart_freeze_plant`.

```text
.load_v_i(1'b0) ... .load_from_tb_o(tbl)
.live_epoch_i(16'd7) .sess_id_i(16'd7)
.plant_sel(sw[1:0])
```

DUT `a7ng_astra_09_r2_cand_ovf.sv` line 148:

```text
assign load_from_tb_o = 1'b0;
```

Silicon smoke/rew frames have tbl=0. Hunt **load_from_tb as query authority**: MISS on the DUT pin. Query authority is the **AXI plant**, not a TB `load_w` preload (`load_v_i` tied 0).

Plant `mem_rd` (hardcoded facts; `plant_sel==PLANT_SMOKE (2'd1)` or `PLANT_OVF (2'd2)` only; else zeros):

```text
INDEX_BASE=28'h0500_0000  POST_HEAP=28'h0504_0000  FACT_BASE=28'h0580_0000
dir keys 2562 / 766 → count 4 (smoke) or 20 (ovf)
POST_HEAP beats: 17,34,18,35
fact 17: s=10 o=1 r=2 e=17 conf=200
fact 34: s=1  o=4 r=2 e=34 conf=200
```

`ans=4 p0=17 p1=34` is **exactly** those packed facts. `uart_ladder.ps1` oracle is `ans==4 && p0==17 && st==0 && acc==1`. The test checks the plant’s own constants.

Reward path: host sends `rew8=0xFD` → wrap `rew_i <= rx_data[3:0]` = 4'sd-3; txn=1 gen=1 epoch=7 **equal to wrap-tied `live_epoch_i=16'd7`**. XSim R7 already published w0 0→-5 / phi0=50 / nupd=1 on that first-POR vector. Silicon matching it is **reachability of the same fixture**, not C3.

### 6) RESULTS.md / CLOSEOUT.md vs raw (timestamp order)

```text
07:22:04  vivado_program.log PROGRAM_PASS (first)
07:24:19  UART_SMOKE.txt TIMEOUT EMPTY + FIRST_DIVERGENCE.txt
07:25:21  UART_SMOKE2.txt SMOKE PASS
07:25:43  RESULTS.md          ← BEFORE ladder
07:28:51  vivado_program_ladder.log PROGRAM_PASS (reprogram)
07:29:19  LADDER.txt SMOKE/REW/UNREL PASS
07:29:31  CLOSEOUT.md + LADDER_CLOSEOUT.md
```

`RESULTS.md` (07:25:43) therefore **cannot** be a ladder closeout. It records smoke2 and then:

```text
SMOKE_SW0_OFF = UNKNOWN  a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
```

**No file in this bag captures that 16-byte frame under a SW0-OFF test.** Raw SW0-related first attempt is EMPTY timeout. The same 16 bytes appear later as `FRAME_UNREL` with SW0 **ON**, and in XSim UNREL. Writing them as `SMOKE_SW0_OFF` is not re-derived from UART_SMOKE.txt.

`RESULTS.md` §What this does not prove still says “Reward w0=-5 on silicon (txn/gen/epoch not in the answer frame)”. After 07:29:19 that sentence is **stale vs LADDER.txt**: the OBS frame **does** carry w0/phi0/nupd/txn/gen/epoch. LADDER_CLOSEOUT (07:29:31) correctly lists REW_M3 PASS. RESULTS.md was not rewritten.

`CLOSEOUT.md` (07:29:31) copies ladder PASS **and** keeps `FRAME_SW0_OFF = a2 01 …` — that label is still false relative to raw files.

`FIRST_DIVERGENCE.txt` remains the 07:24:19 timeout next to a PASS ladder. Hygiene miss, not a hidden FAIL of the ladder (LADDER.txt has no FAIL lines).

Implementer **did** write `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=NOT_CLOSED`, `DDR=NOT_OPENED` on LADDER.txt / ACK `not_this_bag`. Those negatives MATCH the hunt targets they avoided in prose. The SW0_OFF hex line is the RESULTS/raw mismatch.

---

## Overclaim / cheat / tautology

| Hunt | Result | Bound |
|------|--------|--------|
| Plant LUT called production DDR / 800k | **MISS in implementer claims** (`DDR=NOT_OPENED`, ACK `not_this_bag` includes DDR/800k). **HIT as capability bound**: `mem_rd` is a combinational LUT at DDR-like addresses `0x0500_0000` / `0x0580_0000`; BRAM=0; not MIG; not 800k records. Must not be reused as C1/C2 evidence. |
| w0 0→-5 called C3 held-out transfer | **MISS as C3 label** (no “C3” / “held-out” / “transfer” in silicon RESULTS/LADDER). **HIT as bound**: Master V1.1 §9 says `w0 0→-5` proves causal on-chip update reachability and **does not** prove transferable learning. No 5-seed arms, no disjoint entities, no PRE/POST held-out, no reload retention. LADDER REW_M3 is XSim-first-POR tautology (`rew=-3`, epoch=7 = wrap `live_epoch_i`). |
| A09R8 wrap called C5 / ASTRA-13 / BOARD_PASS | **MISS** in bag claims (`BOARD_PASS=NOT_CLAIMED`, `PRODUCTION_TOP` not written as a module in silicon bag; freeze RESULTS `PRODUCTION_TOP=UNKNOWN`). **HIT as bound**: C5 requires real sparse DDR/MIG index, LM06, persistence, and **forbids** “synthetic plant used as corpus authority”. This top is a UART+plant checkpoint, not C5. |
| RESULTS overclaim vs LADDER.txt | **HIT**: `SMOKE_SW0_OFF` / CLOSEOUT `FRAME_SW0_OFF` 16-byte UNKNOWN frame is **not** in raw UART_SMOKE.txt (EMPTY) and is the UNREL/XSim-UNREL byte string. RESULTS.md also stale vs LADDER on w0 (underclaim after 07:25:43). LADDER.txt itself is internally consistent. |
| Bit SHA mismatch | **MISS** live = `e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb` |
| Wrong JTAG / PYNQ | **MISS** `210319BE776EA` / `xc7a100t_0` only; tcl refuse path present |
| load_from_tb as query authority | **MISS** on pin (`load_from_tb_o=0`, tbl bit 0 in silicon frames, `load_v_i=0`). Corpus authority is still the plant. |
| Tautology: oracle is the plant that defines the answer | **HIT (expected fixture, not a hidden cheat if labeled)**. Plant packs fact 17/34 → ans=4 p0=17; ladder checks ans=4 p0=17. Unrelated ASCII misses the two planted dir keys → UNKNOWN. That is empty-index UNKNOWN, not held-out corpus miss. |
| Hash theatre | **MISS** on freeze compiled set + bit (live re-hash). Silicon bag has no SHA256.txt of scripts (not claimed). |
| Timing-fail 100 MHz SoC bit called BOARD_PASS | **MISS** (50 MHz clk50u, WNS≥0, BOARD_PASS not claimed) |
| LM06 composer called language | **MISS** (not in this top) |
| Repeating smoke to farm PASS | **WATCH**: two programs + smoke2 then ladder. Ladder_PREREG discloses POR reason. **Do not run a third smoke.** |

qstack-validation-adversary one-liner: **silicon UART MAGIC-A2 + XSim-identical 16-byte frames on the pinned bit are real; they are not retrieval, not transfer, not a production top, and RESULTS.md’s SW0_OFF hex is not a raw capture.**

---

## Logic bugs

No DUT RTL bug is proven by the ladder mismatching XSim — the three frames match.

Findings that are **not** “fix the DUT in this bag”:

1. **RESULTS/CLOSEOUT SW0_OFF frame is not evidenced.** First smoke produced **no TX**. Empty plant (`plant_sel=0`) should still be able to emit UNKNOWN after `result_v`; EMPTY timeout is setup/UART/C_HOLD/read-path, not a decoded UNKNOWN. Do not treat CLOSEOUT `FRAME_SW0_OFF` as a silicon measurement.
2. **`uart_ladder.ps1` RETIRE is tautological PASS** (`Pass "RETIRE_SENT"` with no RX check). Prereg allows no required TX; do not cite RETIRE as a checked gate.
3. **Stale `FIRST_DIVERGENCE.txt`** (UART_TIMEOUT) left beside `ASTRA_11_A09R8_SILICON_LADDER_PASS`. Readers of FIRST_DIVERGENCE only would invert the bag. Auditor uses LADDER.txt as the ladder record and UART_SMOKE.txt as the earlier timeout record — both kept.
4. **Stale freeze `SHA256_BIT.txt` / `BITSTREAM.txt` `UNPROGRAMMED`** vs silicon `PROGRAMMED`. Bag-local historical vs later test-vehicle program. Do not mix.
5. **Wrap `live_epoch_i` hard-tied to 7** plus test sending epoch 7. A different first txn/epoch would be STALE per LADDER_PREREG — that is fixture coupling, not a general reward API proof.
6. **OVF_SW1 not run.** Cannot claim candidate-overflow silicon.
7. **Plant `mem_rd` ignores `arsize`/`arburst` and answers a handful of addresses.** Fine for a named fixture; illegal as C5 corpus.

No auditor patch. Parent may dispatch a **new named bag** only if they want a real SW0-OFF capture or OVF_SW1; do not edit this bag’s LADDER.txt.

---

## Verdict per bag

| Bag | Verdict | Why |
|-----|---------|-----|
| `ASTRA-11-A09R8-UART-FREEZE-BIT-01` | **PASS_NARROW** | Routed DTS WNS=+0.587 WHS=+0.058 MET; UART pad hold numeric +1.150 / +4.064; no UART hold exception; IOB FF unpacked; official bit SHA live-match; `PRODUCTION_TOP=UNKNOWN`; PROGRAM was NO at freeze-bag close (T0551Z). Not C5. Not unique production bit in the Master C6 sense. |
| `ASTRA-11-A09R8-SILICON-UART-01` **raw program + LADDER.txt** | **PASS_NARROW** | Correct serial, correct SHA, startup HIGH, COM12 16-byte MAGIC-A2; SMOKE/REW/UNREL frames byte-match XSim R7; tbl=0; BOARD_PASS not claimed. Proves checkpoint UART+query-rew FSM+plant fixture on silicon. |
| `ASTRA-11-A09R8-SILICON-UART-01` **RESULTS.md / CLOSEOUT `FRAME_SW0_OFF`** | **OVERCLAIM** (prose only) | UNKNOWN 16-byte frame attributed to SW0_OFF without a raw SW0-OFF capture; bytes are UNREL/XSim-UNREL. Does **not** void LADDER.txt. |
| Master C0–C7 / ASTRA-13 / BOARD_PASS / `ACCEPT_BOARD` | **NOT CLOSED** | Out of scope. Never ACCEPT_BOARD for A09R8 plant fixture. |

Promotion scale for this checkpoint: **ACCEPT_PARTIAL** of the silicon UART ladder on the pinned 50 MHz plant wrap. **REJECT_PROMOTION** to any C-gate close, production-top freeze, or board-pass.

---

## Required fixes

Auditor does not implement. Parent maps:

**P1 (new RTL / new silicon bag required): none.** Raw LADDER three frames MATCH the preregistered XSim vectors on the pinned SHA. Do not retune wrap/plant/A09-R2 to chase SW0_OFF prose.

**P2 (parent / docs / next bag discipline):**

1. Treat `RESULTS.md` `SMOKE_SW0_OFF` and `CLOSEOUT.md` `FRAME_SW0_OFF` as **non-evidence**. Authority = `UART_SMOKE.txt` (EMPTY timeout) + `UART_SMOKE2.txt` + `LADDER.txt`. Do not edit those implementer files to “fix” the label (one writer; new note bag if a correction file is required).
2. Do **not** re-run A09R8 smoke/ladder to farm additional PASS markers (GSTACK_LOOP + Master V1.1 §5).
3. Do **not** write `PRODUCTION_TOP=a7ng_astra_11_a09r8_uart_freeze_wrap`. Owner freeze still required; C5 forbids this plant as corpus authority.
4. Do **not** open C1 on this plant LUT / historical 800k. Hashes for C0 law freeze must be recorded **before** any C1 800k inspect.
5. Do **not** call LADDER REW_M3 `w0=-5` C3. Optional later bag: disjoint held-out PRE/POST, 5 seeds, four arms — not this wrap’s first-POR vector.
6. Do **not** call AXI plant addresses `0x0500_0000` DDR. C2 = real MIG/persistence image, new named bag.
7. Ignore stale `FIRST_DIVERGENCE.txt` as the ladder outcome; it is the 07:24:19 timeout only.
8. Freeze-bag `UNPROGRAMMED` flags are historical; silicon `PROGRAM.txt` is the program record for SHA `e51bdca2…` on `210319BE776EA`.
9. OVF_SW1 remains NOT_RUN; do not imply candidate-overflow silicon.
10. Checkpoint bit may be re-programmed only as a test vehicle. **New** bits still need WNS≥0 + auditor ACCEPT + owner. This report is **not** ACCEPT_BOARD.

If parent follows PARENT_BOOT “ACCEPT_PARTIAL + no P1 → C0”: C0 is **law/authority freeze**, not a claim that A09R8 is the product. C0 must not smuggle C1–C7 closed.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

```text
FINAL            = ACCEPT_PARTIAL
PROMOTION        = REJECT_PROMOTION
FAIL_LOOP        = NO
ACCEPT_BOARD     = MISSING (never granted for this plant fixture)
BOARD_PASS       = NOT_CLAIMED / NOT_GRANTED
ASTRA-13         = BLOCKED
PRODUCTION_TOP   = UNKNOWN
C0–C7            = OPEN (do not close any from this checkpoint)
SILICON_UART     = PASS_NARROW  SMOKE+REW+UNREL frames match XSim R7 on SHA e51bdca2… / JTAG 210319BE776EA
PLANT            = fixture LUT, not DDR, not 800k
W0_-5            = on-chip OBS reachability, not C3
A09R8_WRAP       = checkpoint UART top, not C5
RESULTS_SW0_OFF  = OVERCLAIM vs raw
```

Never ACCEPT_BOARD. Never close C1–C7 from this report.
