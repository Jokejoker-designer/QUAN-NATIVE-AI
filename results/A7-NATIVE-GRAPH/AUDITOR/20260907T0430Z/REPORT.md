# ASTRA auditor REPORT — 20260907T0430Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R6_LED_CANDIDATES_INDEPENDENT_AUDIT; astra12_r6=IMPLEMENTER_CLAIM_12_ROWS_PENDING_AUDITOR; astra11_led=AUDITOR_PASS_NARROW_WNS_P0411_WHS_P0027_LED_IOB; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R6-LED-CANDIDATES-01 + prior auditor 20260907T0400Z (A09R7 LED-IO impl-route PASS_NARROW WNS=+0.411 WHS=+0.027 LED IOB YES UART D10/A9 kept FALSE_PATH_HOLD HONEST; DTS WHS intra-clk50u not LED pad hold; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T0300Z (12-R5 two-column brief PASS_NARROW ACCEPT_PARTIAL; WINNER NOT_FROZEN) + T0230Z (12-R4 table PASS_NARROW unique 11 = 2 new + 9 pointers)
EVIDENCE   = bag ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / file_manifest.txt / git_head.txt + RAW cited prior-bag files (LED timing_route.rpt / io.rpt / util_route.rpt / exceptions_route.rpt / clocks_route.rpt / timing_led_out.rpt / check_timing.rpt / clk50_led_io.xdc / led_iodelay.xdc / LED_IOB.txt / LED_IOBFF.txt / UART_IOB.txt / UART_IOBFF.txt / wrap+plant SV, N2 UART timing_route.rpt, 12-R4 CANDIDATES.md + SHA256.txt + SHA256_POST.txt, 12-R5 BRIEF.md + SHA256.txt + SHA256_POST.txt, 12-R2/R3 CANDIDATES.md headers, U4 IOBFF timing_route.rpt, T0400Z REPORT) — NOT RESULTS.md of those bags as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (would wipe routed reports). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs CANDIDATES quotes, (2) overlapping digests vs 12-R4 / 12-R5 / LED-IO PRE+POST / T0400Z / T0300Z / T0230Z freeze strings, (3) session stamps on raw reports vs those auditors. Timing-report SHA strings first-recorded in this bag are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R6-LED-CANDIDATES-01/`

Table-only. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `CANDIDATES.md` one new LED-wrap row from raw `ASTRA-11-A09R7-LED-IO-01` reports + SHA-256 of cited raw reports/XDC/io/util + pointers to 12-R4 and 12-R5 tables **without rewriting those files** + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R6-LED-CANDIDATES-01 only** — one unknown (handoff):

> Extend the candidate table with the LED wrap. Quote raw `timing_route.rpt` WNS=+0.411 WHS=+0.027 LED H5/J5/T9/T10 UART A9/D10 kept. Pointers to 12-R4/R5, do not rewrite those files. Parent does **not** freeze `PRODUCTION_TOP`. PROGRAM=NO.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze. **Not** physical IOB hold MET. **Not** promoting DTS WHS=+0.027 as LED pad hold. **Not** promoting L1 WNS=+0.411 as N2 UART wrap WNS=+0.336. **Not** closing 12-R5 residual (freeze a top **or keep UNKNOWN**) — this bag **keeps UNKNOWN**.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R6-LED-CANDIDATES-01.md`: ACK first; `CANDIDATES.md` one new row quoting raw `timing_route.rpt` WNS=+0.411 WHS=+0.027 LED H5/J5/T9/T10 UART A9/D10 kept; pointers to 12-R4/R5, do **not** rewrite those files; `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD_PASS, LM06; PROGRAM=NO. Preserve: do not edit ASTRA-12-R2/R3/R4/R5, ASTRA-11-A09R7-LED-IO-01, A09R7 UART impl. Do not rerun impl. Do not generate a `.bit`. Do not write `PRODUCTION_TOP=` a module name.
2. **Master ASTRA-12** (isolated DAG `ASTRA-12 FINAL-SOURCE-FREEZE` / T1500Z: *preprogram closure, unique bit, current board token/identity/UART plan*). This table must not steal that close. Historical ASTRA-12 / 12B freeze bags are different objects.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0400Z`: LED-IO bag PASS_NARROW; raw routed WNS=+0.411 WHS=+0.027; LED IOB H5/J5/T9/T10 FIXED LD4–LD7; LED IOB FFs packed; LED delays 2.000/0.500 vs related clk50u RELATED_CLK50U_NO_FALSE_PATH_HOLD; UART D10/A9 kept; UART I/O hold excepted (FALSE_PATH_HOLD HONEST); DTS WHS=+0.027 is **intra-clk50u**, LED hold MET +2.927; `PRODUCTION_TOP=UNKNOWN`; BOARD blocked YES.
5. Auditor `20260907T0300Z`: 12-R5 brief PASS_NARROW; two columns only (A wrap-route WNS=+5.733 / B N2 WNS=+0.336 WHS=+0.104); WINNER NOT_FROZEN; 12-R4 unique 11 pointed, not extra; `PRODUCTION_TOP=UNKNOWN`.
6. Auditor `20260907T0230Z`: 12-R4 table PASS_NARROW; unique **11** = 2 new + 9 pointers; N2 routed WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD HONEST; 12-R2/R3 not rewritten.

Hunt (this dispatch):

1. New row quotes raw WNS=+0.411 WHS=+0.027 LED H5/J5/T9/T10 UART A9/D10 kept?
2. Unique count 12 honest (1 new + pointers)?
3. `PRODUCTION_TOP` UNKNOWN? No winner freeze?
4. Overclaim BOARD_PASS / ASTRA-13 / DTS WHS as LED pad hold?
5. Prior bags not rewritten (confirm 12-R4/R5)?

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART/LED I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, physical IOB hold MET, DTS WHS as LED pad hold, UART STA ladder as one envelope, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS, silent freeze of `a7ng_astra_11_a09r7_led_io_wrap`, mixing L1 +0.411 with N2 +0.336.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` lists it first among this-bag files (`c1187d8a…e28c4cfb`). Same digest in `SHA256_POST.txt`. `write_scope` = new bag only: ACK first + CANDIDATES.md one new LED-wrap row from raw ASTRA-11-A09R7-LED-IO-01 reports + SHA256 of cited raw reports/XDC/io/util + pointers to 12-R4 and 12-R5 without rewriting those files + RESULTS/CLOSEOUT; no RTL; no bitstream; no freeze of a winner; no `PRODUCTION_TOP=module`; no prior-bag rewrite; no impl/xsim rerun.

`PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`, `winner_frozen: false`, `new_row: L1:a7ng_astra_11_a09r7_led_io_wrap`.

`does_not_close` includes production_top_identity, Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ASTRA-11_FULLCHIP_COFIT, Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, ACCEPT_BOARD, physical_IOB_hold_MET, physical_LED_hold_as_DTS_WHS, UART_STA_ladder_as_one_envelope, ASTRA-11-A09R7-LED-IO-01, ASTRA-11-A09R7-UART-IMPL-ROUTE-01, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-12-R4-R7-UART-CANDIDATES-01, ASTRA-12-R5-FREEZE-BRIEF-01, winner_as_frozen.

Bag listing: ACK.json, CANDIDATES.md, RESULTS.md, CLOSEOUT.md, metrics.json, git_head.txt, SHA256.txt, SHA256_POST.txt, file_manifest.txt. **No** `.bit` / `.bin` / `.mcs`. No `ckpt/`. No run scripts. No RTL. Same pack-only pattern as 12-R5 (R4 was 7-file; R5/R6 add `git_head.txt` + `file_manifest.txt`).

RESULTS.md / CLOSEOUT.md / metrics.json / CANDIDATES.md header: `PRODUCTION_TOP=UNKNOWN`, `WINNER=NOT_FROZEN`, `LED_NEW_ROWS=1`, `R4_POINTER_ROWS=11 unique`, `R5_POINTER=BRIEF two-column (not extra unique tops)`, `CANDIDATE_COUNT=12`, `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

CANDIDATES.md: **Rows are not ranked.** Do not treat max WNS, LED IOB packed, UART IOB packed, or hold-exception WHS≥0 as a freeze. Parent does **not** pick a top. This bag does **not** write `PRODUCTION_TOP=<module>`.

Base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH handoff and `git_head.txt` (`HANDOFF_BASE_MATCH=YES`). Branch `grok-orch/astra-native-v1-00` MATCH ACK. `git_head.txt` is **byte-identical** to 12-R5 `git_head.txt` (HEAD unchanged); digest `2b39981c…67058d8b` MATCH 12-R5 POST of the same six lines — not hash theatre.

---

### Hunt 1 — new row quotes raw WNS=+0.411 WHS=+0.027 LED H5/J5/T9/T10 UART A9/D10 kept — MATCH

Authority = live `ASTRA-11-A09R7-LED-IO-01/timing_route.rpt` Design Timing Summary, Design State=Routed, **not** that bag’s RESULTS.md.

Live header:

```text
Date         : Mon Sep  7 03:11:15 2026
Design       : a7ng_astra_11_a09r7_led_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row (authority):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints
      0.411        0.000                      0                 8949        0.027        0.000                      0                 8947        3.000        0.000                       0                  3626
All user specified timing constraints are met.
```

CANDIDATES.md L1 **+0.411 / +0.027** MATCH this live DTS and T0400Z. Intra-clock `clk50u`: WNS=0.411 WHS=0.027 (TNS endpoints 7254). Clock period `clk50u` 20.000 ns (50.000 MHz). Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

Pipe clock **real**: live `clocks_route.rpt` Design State Routed 03:11:19 `clk50u 20.000 P,G,A {u_mmcm/CLKOUT0}`; `uart_io_vclk 20.000 V {}`. MATCH CANDIDATES quote.

Worst **setup** path (clk50u intra, Slack MET 0.411 ns):

```text
Source  u_a09r2/FSM_sequential_st_reg[3]/C
Dest    u_a09r2/u_sgd/w_reg[24][2]/D
Requirement = 20.000 ns
Data Path Delay = 19.402 ns  (logic 10.274 / route 9.128)
```

Worst **hold** path (clk50u intra, Slack MET 0.027 ns):

```text
Source  u_a09r2/u_sp/u_walk/ntrunc_reg[2]/C
Dest    u_a09r2/u_sp/u_walk/n_trunc_o_reg[2]/D
Data Path Delay = 0.358 ns
```

MATCH CANDIDATES raw-quote block and T0400Z. DTS WHS=+0.027 is **intra clk50u DUT hold**, not LED pad hold, not UART I/O hold.

LED IOB H5/J5/T9/T10 YES — live `io.rpt` Total User IO = **15**, Date 03:11:19, Design `a7ng_astra_11_a09r7_led_io_wrap`:

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| H5         | led[0]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| J5         | led[1]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T9         | led[2]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
| T10        | led[3]       | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

UART A9/D10 **kept** (not dropped). Pins **not swapped**. MATCH CANDIDATES Table A and `LED_IOB.txt` / `UART_IOB.txt`.

Bag-local XDC (hashed LED PRE `48558c4a…32f8b78b` MATCH 12-R6 SHA256.txt and LED-bag COMPILED list):

```text
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports {led[*]}]
```

LED delays live `led_iodelay.xdc` (PRE `9d25526c…49c8707` MATCH):

```text
set_output_delay -clock [get_clocks clk50u] -max 2.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks clk50u] -min 0.500 [get_ports {led[*]}]
```

LED hold policy RELATED_CLK50U_NO_FALSE_PATH_HOLD — live `exceptions_route.rpt` Design State Routed 03:11:20: false-path-hold exists for `uart_txd_in` / `uart_rxd_out` (Hold=`false`, Setup=`-`); false-path (setup+hold) for `sw[*]` / `btn[*]`. **No** `led[*]` exception. MATCH CANDIDATES.

IOB FF YES — live `util_route.rpt` Design State Routed: Slice LUTs **4945**, Slice Registers **3615**, Block RAM Tile **0**, DSPs **2**, Bonded IOB **15**, IOB Flip Flops **6**, ILOGIC **1**, OLOGIC **5**. Live `LED_IOBFF.txt`: `led_q_reg[0..3]` BEL=OLOGICE2.OUTFF PACKED=YES LOC=OLOGIC_X1Y101 / X1Y100 / X0Y52 / X0Y51. Live `UART_IOBFF.txt`: RX BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y171 PACKED=YES / TX BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161 PACKED=YES. MATCH CANDIDATES occupancy row L1.

LED pad STA (not DTS WHS) — live `timing_led_out.rpt` Design State Routed 03:11:21:

```text
led_q_reg[3] → led[3]  Max/setup Slack (MET) 10.321 ns  Output Delay=2.000  dest T10
led_q_reg[1] → led[1]  Min/hold  Slack (MET)  2.927 ns  Output Delay=0.500  dest J5
```

MATCH CANDIDATES. `check_timing.rpt`: `no_output_delay (0)`, `partial_output_delay (0)`, `no_input_delay (8)` = `sw[*]`/`btn[*]`. LED ports are **not** in `no_output_delay`.

Claimed L1 `timing_route.rpt` SHA `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585` is **first-recorded in this bag** (LED PRE/POST hash compiled sources + `.svh`, not the rpt). Content of the opened rpt MATCHES T0400Z numeric quotes (WNS=0.411 WHS=0.027, Date 03:11:15, Design `a7ng_astra_11_a09r7_led_io_wrap`, TNS endpoints 8949). Wrap SV `7bb960c0…a77d6e7c` MATCH LED PRE/POST. Frozen DUT `15a919f1…8b70ee23` MATCH LED / UART-impl / T0400Z.

Hunt 1: **MET.**

---

### Hunt 2 — unique count 12 honest (1 new + pointers) — HONEST

Header arithmetic (ACK / CANDIDATES / RESULTS / CLOSEOUT / metrics):

```text
LED_NEW_ROWS         = 1
R4_POINTER_ROWS      = 11 unique
R5_POINTER           = BRIEF two-column (not extra unique tops)
CANDIDATE_COUNT      = 12
```

CANDIDATES.md states explicitly:

> `CANDIDATE_COUNT=12` = **1 new** (this bag) + **11** unique from ASTRA-12-R4-R7-UART-CANDIDATES-01. 12-R5 is a two-column brief of two of those already-counted tops; it is **pointed**, not double-counted.

Table C: columns A/B are **already** P2 and N2 in the unique-11 set. They are **not** extra unique candidates. This bag does not add L1 as a third brief column.

Unique set = L1, N1, N2, U1, U2, U3, U4, U5, P1, P2, P3, P4 = **12**.  
Not 13 (would be 1+11+2-column brief double-count).  
Not 14 (would be 1+11+2 extra).  
Not 12 **new** rows generated here (only L1 is new).  
Not 1-only (handoff asked to keep 12-R4/R5 as pointers).

LOOP_STATE `astra12_r6=IMPLEMENTER_CLAIM_12_ROWS_PENDING_AUDITOR` is this unique-12 claim, not twelve new routed wraps.

Table B pointer identities MATCH T0230Z unique-11 list (N1, N2, U1–U5, P1–P4). RESULTS condensed pointer WNS MATCH T0230Z / 12-R4 table: N1 XSim N/A; N2 +0.336/+0.104; U1 XSim N/A; U2 +0.305; U3 +0.681; U4 +0.115/−4.915; U5 +0.115/+0.131; P1 +1.041 UART NO; P2 +5.733 UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES. 12-R5 columns A/B = P2/N2, not extra.

L1 is a **new named wrap** (`a7ng_astra_11_a09r7_led_io_wrap`), not N2 (`a7ng_astra_11_a09r7_uart_impl_wrap`). Different Design name, date, PID, WNS, WHS, endpoint count, IOB FF 2→6.

Hunt 2: **HONEST.**

---

### Hunt 3 — PRODUCTION_TOP UNKNOWN; no winner freeze — MET

| Artifact | PRODUCTION_TOP | WINNER |
|----------|----------------|--------|
| ACK.json | `"UNKNOWN"`, `winner_frozen: false` | not a module name |
| CANDIDATES.md | UNKNOWN / NOT_FROZEN; rows **not ranked** | explicit: do not treat max WNS / LED IOB / UART IOB / hold-exception WHS≥0 as freeze |
| RESULTS.md | UNKNOWN; “Not frozen. Not silently chosen.” | L1 +0.411 **is not** that top; N2 +0.336 **is not** that top; 12-R5 columns **are not** that top |
| CLOSEOUT.md | UNKNOWN / NOT_FROZEN | “This bag is not that freeze.” Do not freeze `PRODUCTION_TOP=a7ng_astra_11_a09r7_led_io_wrap` |
| metrics.json | `"UNKNOWN"`, `winner_frozen: false` | — |
| SHA256.txt / POST | comments PRODUCTION_TOP=UNKNOWN | — |
| git_head.txt / file_manifest.txt | UNKNOWN | — |
| LOOP_STATE.json (read-only) | `"UNKNOWN"` / `NEEDS_OWNER_NOT_SILENT` | — |

No `PRODUCTION_TOP=a7ng_astra_11_a09r7_led_io_wrap` (or any other module) written. 12-R5 residual (freeze a top **or keep UNKNOWN**) is **kept UNKNOWN**. Hunt 3: **MET.**

---

### Hunt 4 — overclaim BOARD_PASS / ASTRA-13 / DTS WHS as LED pad hold — NOT FOUND

Every this-bag product: `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `ACCEPT_BOARD` missing/false, `BIT=NOT_BUILT`, `PROGRAM=NO`, `write_bitstream=false`, COM12/JTAG UNTOUCHED.

ACK `does_not_close` lists Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ACCEPT_BOARD, physical_IOB_hold_MET, **physical_LED_hold_as_DTS_WHS**.

RESULTS: “Do **not** call this BOARD_PASS or ASTRA-13.”

CANDIDATES Not claimed: PRODUCTION_TOP, Winner, write_bitstream, BOARD_PASS, ASTRA-13, ACCEPT_BOARD, LM06, Physical IOB hold MET, **DTS WHS=+0.027 as LED pad hold (LED hold is +2.927)**, UART STA ladder as one envelope, Master ASTRA-12 unique-bit, mixing L1 +0.411 with N2 +0.336 / U2 +0.305 / U3 +0.681 / U4/U5 +0.115 / P2 +5.733, promoting L1 WHS=+0.027 to erase U4 −4.915 or N2 +0.104, silent freeze of `a7ng_astra_11_a09r7_led_io_wrap`.

No `.bit` in this bag.

Implementer self-grade `PASS_NARROW` / CLOSEOUT `PASS_THIS_GATE_ONLY` is bounded to the table unknown. Not a Master-12/13 close.

DTS vs LED-pad split is **disclosed** in CANDIDATES / RESULTS / metrics (`whs_note`: intra clk50u `ntrunc_reg[2]->n_trunc_o_reg[2]`; `led_hold_ns: 2.927`). **Not** an overclaim of DTS WHS as LED pad hold.

Hunt 4: **NOT OVERCLAIM.**

---

### Hunt 5 — prior bags not rewritten (12-R4 / 12-R5 and LED/UART route) — MET

Live 12-R4 `CANDIDATES.md` still:

```text
GATE             = ASTRA-12-R4-R7-UART-CANDIDATES-01
CANDIDATE_COUNT  = 11
R7_NEW_ROWS      = 2
R3_POINTER_ROWS  = 9
```

No `led_io_wrap` / `WNS=+0.411` / `H5` strings in that directory (grep). Pointer SHA claimed `4d694af0be83100a94c682ff678f94487f19691f1cf953e42c51efe54baea84d` MATCH 12-R4 `SHA256.txt` product line **and** 12-R4 `SHA256_POST.txt` (tabled 2026-09-07T02:13:05+07:00) **and** 12-R5 freeze of the same `CANDIDATES.md`. This bag’s hash of 12-R4 `SHA256.txt` `3cf41834…96101c2a` MATCH 12-R4 POST **and** 12-R5 SHA256.txt pointer. 12-R4 listing still the original 7 files (ACK / CANDIDATES / RESULTS / CLOSEOUT / metrics / SHA256 / SHA256_POST). No L1 row inserted.

Live 12-R5 `BRIEF.md` still:

```text
GATE             = ASTRA-12-R5-FREEZE-BRIEF-01
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
COLUMNS          = 2
COLUMN_A         = arty_a7_astra_rtp_soc_top
COLUMN_B         = a7ng_astra_11_a09r7_uart_impl_wrap
```

No `led_io_wrap` / `WNS=+0.411` / `H5` strings in that directory (grep). Pointer SHA claimed `736500b0da266fd1e4542ad2e707ffe99286e510c47015ad657c50ca24b3315f` MATCH 12-R5 `SHA256.txt` product line **and** 12-R5 `SHA256_POST.txt` (tabled 2026-09-07T02:33:16+07:00) **and** T0300Z. This bag’s hash of 12-R5 `SHA256.txt` `1ae466a5…ef83c1d2` MATCH 12-R5 POST. 12-R5 listing still ACK / BRIEF / RESULTS / CLOSEOUT / metrics / git_head / SHA256 / SHA256_POST / file_manifest. No L1 column added.

Live 12-R2 `CANDIDATES.md` still `GATE=ASTRA-12-R2-TOP-CANDIDATES-01` `CANDIDATE_COUNT=4`. No L1 strings.  
Live 12-R3 `CANDIDATES.md` still `GATE=ASTRA-12-R3-UART-WRAP-CANDIDATES-01` `CANDIDATE_COUNT=9`. No L1 strings.

LED-IO bag **not overwritten** (raw): `timing_route.rpt` still Date **Mon Sep 7 03:11:15 2026**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027. LED PRE stamp still `2026-09-07T03:06:25.2550197+07:00`. LED POST stamp still `2026-09-07T03:11:22.0254046+07:00`. MATCH T0400Z.

N2 UART wrap **not overwritten** (raw): `timing_route.rpt` still Date **Mon Sep 7 01:52:48 2026**, Design `a7ng_astra_11_a09r7_uart_impl_wrap`, DTS WNS=0.336 WHS=0.104, TNS endpoints=8940. Claimed SHA `0c45687b…378d2b` MATCH 12-R4 SHA256.txt **and** 12-R5 SHA256.txt. L1 does **not** steal N2 +0.336/+0.104.

U4 IOBFF bag **not overwritten** (raw): live DTS WNS=0.115 WHS=**−4.915**. L1 WHS=+0.027 does **not** erase U4.

This bag **copies quotes / pointer identities** into its own `CANDIDATES.md` Table B/C. That is the required pointer. It does **not** add L1 into the 12-R4 or 12-R5 files.

Hunt 5: **MET.**

---

### Hash theatre / this-bag product

This-bag product hashes (first-recorded in `SHA256.txt` / `SHA256_POST.txt`; not re-digested here): ACK `c1187d8a…`, CANDIDATES `91753736…`, RESULTS `423c7e91…`, CLOSEOUT `bb65965c…`, metrics `1d41a1f3…`, git_head `2b39981c…` (also 12-R5 POST of identical content), SHA256.txt itself `6aeff648…` (POST only), file_manifest `f93b3097…` (POST; not in SHA256.txt product list — same R5 pattern). ACK.json digest is the same in SHA256.txt and SHA256_POST.txt. SHA256.txt stamped 2026-09-07T03:32:14+07:00; POST stamped 2026-09-07T03:32:59+07:00.

Overlap (strings compared, not re-hashed):

| Object | Digest | Overlap |
|--------|--------|---------|
| 12-R4 CANDIDATES.md | `4d694af0…ea84d` | 12-R4 SHA256 + POST + 12-R5 pointer + T0230Z / T0300Z |
| 12-R4 SHA256.txt | `3cf41834…101c2a` | 12-R4 POST + 12-R5 pointer + T0300Z |
| 12-R5 BRIEF.md | `736500b0…b3315f` | 12-R5 SHA256 + POST + T0300Z |
| 12-R5 SHA256.txt | `1ae466a5…c1d2` | 12-R5 POST |
| N2 `timing_route.rpt` | `0c45687b…8d2b` | 12-R4 SHA256.txt + 12-R5 SHA256.txt; content MATCH live DTS +0.336/+0.104 |
| L1 wrap SV | `7bb960c0…d6e7c` | LED PRE/POST |
| L1 plant SV | `42e99ee8…c6bfb3` | LED PRE/POST |
| L1 `clk50_led_io.xdc` | `48558c4a…b78b` | LED PRE/POST |
| L1 `led_iodelay.xdc` | `9d25526c…c8707` | LED PRE/POST |
| Frozen A09-R2 DUT | `15a919f1…ee23` | LED / UART-impl / T0400Z |
| Cite `constraints/arty_a7_100.xdc` | `1c12e6f8…a9c2` | T0400Z / 12-R5 freeze of the same file |
| git_head.txt | `2b39981c…058d8b` | 12-R5 POST (identical six lines) |

Limitation: this-bag markdown hashes, L1 `timing_route.rpt` SHA `4fbd3e42…` (first-recorded here; LED PRE/POST do not hash the rpt), L1 io/util/exceptions/clocks/`timing_led_out`/IOB extracts, LED `SHA256.txt`/`SHA256_POST.txt` as objects, 12-R4 `SHA256_POST.txt` `3ff5d1e3…`, 12-R5 `SHA256_POST.txt` `259d9ba8…`, T0400Z REPORT `0d15df73…`, and this handoff `e7647b23…` cannot be re-digested without a shell. Content of those reports MATCHES quotes / T0400Z / T0300Z / T0230Z. Invented overlapping DUT/XDC/12-R4/12-R5 pointer digests: **not found**.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md only | **No.** CANDIDATES cites raw DTS; live MATCH. |
| Recycle N2 UART wrap WNS=+0.336 as L1 +0.411 | **No.** Different top, date, PID, WNS, WHS, endpoint count, wrap hash. UART raw rpt intact 01:52:48. |
| Recycle wrap-route +5.733 / HOLD +0.115/+0.131 / UART wrap +0.305 / IOdelay +0.681 / IOBFF −4.915 as L1 | **No.** Explicit split. |
| Promote DTS WHS=+0.027 as LED pad hold | **Not claimed.** Disclosed intra-clk50u vs LED hold MET +2.927. |
| Collapse L1 WHS=+0.027 into U4 −4.915 / claim physical IOB hold MET | **No.** U4 still −4.915 live; UART hold excepted; labeled HONEST. |
| FALSE_PATH_HOLD unlabeled / hide-WHS cheat | **No.** UART Hold=false Setup=`-`; no `led[*]` exception. |
| Rank / silent-freeze a winner | **No.** Not ranked. `PRODUCTION_TOP=UNKNOWN`. |
| BOARD_PASS / ACCEPT_BOARD / ASTRA-13 | **Not claimed.** BLOCKED / NOT_CLAIMED. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. |
| CANDIDATE_COUNT=12 as 12 new / or 1+11+2=14 | **No.** Header splits 1 new + 11 pointer; Table C not extra unique. |
| Mix UART STA ladder as one envelope | **Not claimed.** `does_not_close` includes that. |
| Add L1 as third 12-R5 brief column | **No.** Explicitly refused. |
| Hash theatre | **Not found** for overlapping DUT/XDC/wrap/12-R4/12-R5 pointer digests. First-recorded L1 timing SHA is content-verified only. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps (LED 03:11:15; N2 01:52:48; U4 −4.915). |
| Rewrite 12-R4 / 12-R5 / 12-R2 / 12-R3 | **Not found.** GATE names, counts, hashes MATCH POST lists; no L1 rows inserted. |
| TB-load / one-hot transfer | N/A for a table-only bag. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / DTS WHS as LED pad hold. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the LED-extension candidate-table unknown.

Evidence class: L1 WNS/WHS/IOB = **routed DTS EVIDENCE** (Design Timing Summary, Design State=Routed — not relabeled STA). LED pad hold +2.927 = **path STA EVIDENCE** from `timing_led_out.rpt` (separate). Pointer WNS = **prior-bag routed EVIDENCE** (not re-impl). `PRODUCTION_TOP=UNKNOWN` = **CONFIRMED** in this bag’s products. Board plugged = **OBSERVED in LOOP_STATE as USER_SAYS_PLUGGED_UNPROGRAMMED**, not authority to program.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written. No RESULTS/raw contradiction on L1 WNS/WHS/IOB/hold-policy, N2 pointer identity, or the eleven 12-R4 pointer identities.

Residuals (not this-bag FAIL):

1. CANDIDATES.md WNS “quotes” for L1 include the verbatim Design Timing Summary numeric row (stronger than T0230Z condensed one-liners). Pointer Table B lists module+bag only; RESULTS condensed pointer WNS omit some WHS (U2 +0.024, U3 +0.100, P3 +0.046) the way 12-R4/R3 compressed them. Numbers that are quoted MATCH. Not a WNS miss.
2. First-recorded SHA of L1 `timing_route.rpt` / this-bag markdown / T0400Z REPORT / 12-R4 POST file / 12-R5 POST file cannot be re-digested without a shell. Content MATCHES T0400Z / T0300Z / opened files.
3. ACK `observed_session_id=UNKNOWN`. Does not affect the table unknown.
4. L1 DSP=2 is frozen SGD, not a7-fpga-gate eam03e DSP=0. Occupancy LUT=4945/FF=3615 matching N2 is expected (LED FFs in IOB). Disclosed: do not add L1 LUT/FF to N2 as a whole-chip sum.
5. Distinct **module names** in the 12-row set are **11** because P3 and P4 share `arty_a7_astra09_soc_top` (two bags). T0230Z already counted those as two of unique-11. This bag’s unique-12 continues that identity convention (1 new + 11 R4 identities), not “11 distinct SV modules.” Prose and `CANDIDATE_COUNT=12` correct a reader who only sums 1+11+2 or who collapses P3/P4 then under-counts.
6. `file_manifest.txt` is hashed in POST only, not in `SHA256.txt` product list (same as 12-R5). Not a missing required artifact.
7. L1 UART I/O hold remains excepted (T0400Z residual). This table correctly does not promote WHS=+0.027 as physical IOB hold MET or as LED pad hold. U4 −4.915 remains on disk.
8. 12-R5 residual (freeze a top **or keep UNKNOWN**) is honored: this bag **keeps UNKNOWN**.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a candidate table now includes **one new LED row** (routed WNS=+0.411 WHS=+0.027 LED IOB H5/J5/T9/T10 YES UART A9/D10 kept IOB FF YES RELATED_CLK50U_NO_FALSE_PATH_HOLD on LEDs / FALSE_PATH_HOLD HONEST on UART) plus **pointers** to the intact 12-R4 eleven-identity table and the intact 12-R5 two-column brief (A=P2 / B=N2, not extra unique), unique count **12**, with hashes and raw quotes, **without** BOARD_PASS, **without** silently naming a production top, **without** freezing a winner, **without** rewriting 12-R4 / 12-R5 / 12-R2 / 12-R3 / LED-IO route / A09R7 UART route.

**Master ASTRA-12** (preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison table of already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE` are different bags and are **not** this close (ACK `does_not_close`). 12-R2 remains the board-level pointer table; 12-R3 extended it with R3 UART wraps; 12-R4 extended it with R7 XSim + A09R7 UART impl-route; 12-R5 is a two-column brief of two of those; this R6 bag **extends** the table with the LED wrap. None of those is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **some** rows (L1 / N2 / U2 / U3 / U5 DTS; U4 WNS≥0 but WHS<0; P3 WNS<0); that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen. L1 DTS WHS≥0 is intra-clk50u; LED pad hold MET +2.927 is path STA on this named wrap, not silicon LEDs; UART I/O hold remains excepted, not physically MET.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**. Physical IOB hold MET remains **OPEN** (U4 −4.915 still on disk). UART STA ladder remains **separate envelopes**, not one closed ladder.

T0400Z residual (do not freeze `PRODUCTION_TOP`; do not ASTRA-13; do not promote WNS=+0.411 / WHS=+0.027 as BOARD_PASS or as LED pad hold or as U4 −4.915 MET) is **honored**, not closed as Master 12/13.

T0300Z residual (freeze a production top **or keep UNKNOWN**; parent does not pick) is **honored**: this bag **keeps UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R6-LED-CANDIDATES-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + CANDIDATES.md table from raw reports; **1 new** LED row (L1 routed WNS=+0.411 WHS=+0.027 LED IOB YES H5/J5/T9/T10 LD4–LD7 UART A9/D10 kept IOB FF YES RELATED_CLK50U_NO_FALSE_PATH_HOLD on LEDs / FALSE_PATH_HOLD HONEST on UART; DTS WHS intra-clk50u, LED hold MET +2.927 disclosed) + **11** 12-R4 unique pointer identities + 12-R5 two-column brief pointed not extra = unique **12**; L1 WNS/WHS/IOB/hold-policy MATCH live Design State=Routed files and T0400Z; 12-R4 and 12-R5 files **not rewritten**; LED-IO route and A09R7 UART route **not overwritten**; `PRODUCTION_TOP=UNKNOWN`; winner not frozen; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13; DTS WHS not claimed as LED pad hold.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze; physical IOB hold MET; DTS WHS as LED pad hold; UART STA as one envelope).  
Not FAIL (required artifacts present; L1 WNS/WHS/IOB/hold-policy MATCH live routed reports; unique count 12 honest as 1 new + pointers; overlapping hashes MATCH prior freeze lists; prior bags including 12-R4, 12-R5, 12-R2, 12-R3, U4 −4.915, LED-IO route, A09R7 UART route not rewritten; no program; no winner).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / DTS WHS as LED pad hold / 12-new-rows not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared table-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this table to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, physical IOB hold MET, DTS WHS as LED pad hold, or a silent `PRODUCTION_TOP=<module>` (including `a7ng_astra_11_a09r7_led_io_wrap`). `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on L1 / N2 / U2 / U3 / U5 / P1 / P2 / P4 is **not** that gate. L1 WHS=+0.027 is **not** LED pad hold and **not** U4 −4.915 MET. LED hold MET +2.927 on this named wrap is **not** silicon LEDs.
3. Keep U4 WHS=−4.915 on disk. Do **not** collapse L1 FALSE_PATH_HOLD DTS WHS≥0 into physical IOB hold MET. Keep UART STA envelopes **separate**. Do **not** mix L1 +0.411 with N2 +0.336 / U2 +0.305 / U3 +0.681 / U4/U5 +0.115 / P2 +5.733.
4. Do **not** rewrite `ASTRA-12-R2-TOP-CANDIDATES-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-12-R4-R7-UART-CANDIDATES-01`, `ASTRA-12-R5-FREEZE-BRIEF-01`, `ASTRA-11-A09R7-LED-IO-01`, or `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`. Do not rerun those impl/xsim scripts. LED `timing_route.rpt` must stay 03:11:15 WNS=0.411 WHS=0.027 Design `a7ng_astra_11_a09r7_led_io_wrap`. A09R7 UART `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104.
5. Do **not** add L1 LUT=4945 to N2 4945 as a whole-chip sum. Do not treat max WNS, LED IOB packed, UART IOB packed, or hold-exception WHS≥0 as a freeze. Do not add L1 as a third 12-R5 brief column.
6. Count: unique **12** = 1 new + 11 pointers. Do not brief this as “12 new LED wraps” or as “14 rows.” Distinct module names are 11 only if P3/P4 are collapsed; that is **not** this bag’s unique-12 convention (inherited from T0230Z unique-11 identities).
7. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/LED pinout **on that top**, unique bit after WNS≥0 **on that top**, then ASTRA-13 + owner + ACCEPT_BOARD. Not this table’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **LED candidate-table extension**: hashes + raw quotes of one new row (A09R7 LED-IO wrap routed WNS=+0.411 WHS=+0.027 LED IOB YES H5/J5/T9/T10 UART A9/D10 kept IOB FF YES RELATED_CLK50U_NO_FALSE_PATH_HOLD / FALSE_PATH_HOLD HONEST; DTS WHS intra-clk50u, LED hold MET +2.927 disclosed) plus pointers to intact 12-R4 (11 unique) / 12-R5 (two-column brief, not extra unique) tables, unique count **12**, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN, 12-R4/12-R5/12-R2/12-R3/LED-IO route/A09R7 UART route **not rewritten**, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen. Physical IOB hold is **not** MET. DTS WHS=+0.027 is **not** LED pad hold. L1 wrap is **not** the production top.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
Physical IOB hold MET: **OPEN** (U4 WHS=−4.915 untouched).  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. LED IOB: **YES**. UART IOB: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0430Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R6-LED-CANDIDATES-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
