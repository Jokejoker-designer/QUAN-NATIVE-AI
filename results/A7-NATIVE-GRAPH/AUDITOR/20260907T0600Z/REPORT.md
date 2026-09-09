# ASTRA auditor REPORT — 20260907T0600Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R7_BTN_CANDIDATES_INDEPENDENT_AUDIT; astra12_r7=IMPLEMENTER_CLAIM_14_ROWS_PENDING_AUDITOR; astra11_btn=AUDITOR_FAIL_WHS_M2068_BTN_PAD_HOLD; astra11_btn_idelay=AUDITOR_PASS_NARROW_TAP31_WNS_P0574_WHS_P0131; astra12_r6=AUDITOR_PASS_NARROW_12_UNIQUE_1_NEW_PLUS_11_POINTERS; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R7-BTN-CANDIDATES-01 + prior auditor 20260907T0530Z (A09R7 BTN-IDELAY PASS_NARROW TAP=31 WNS=+0.574 WHS=+0.131 BTN pad hold MET +0.638 false-path-btn NO; FAIL bag still WHS=−2.068; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T0500Z (BTN-IO FAIL_LOOP WHS=−2.068) + T0430Z (12-R6 LED table PASS_NARROW unique 12 ACCEPT_PARTIAL)
EVIDENCE   = bag ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / file_manifest.txt / git_head.txt + RAW cited prior-bag files (FAIL timing_route.rpt live + fail_r0/timing_route.rpt / timing_btn_in.rpt / exceptions_route.rpt / io.rpt / util_route.rpt / clocks_route.rpt / btn_iodelay.xdc / wrap SV / BTN_IOB.txt, IDELAY timing_route.rpt / timing_btn_in.rpt / exceptions_route.rpt / io.rpt / util_route.rpt / clocks_route.rpt / btn_iodelay.xdc / wrap SV / BTN_IDELAYE2.txt / PREREG, 12-R6 CANDIDATES.md + SHA256.txt + SHA256_POST.txt + ACK.json + RESULTS.md + git_head.txt, L1 LED timing_route.rpt, N2 UART timing_route.rpt, U4 IOBFF timing_route.rpt, U5 HOLD timing_route.rpt, 12-R4/R5/R2/R3 CANDIDATES/BRIEF headers, T0530Z / T0430Z REPORT) — NOT RESULTS.md of those bags as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (would wipe routed reports). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`. Did not retune FAIL bag `ASTRA-11-A09R7-BTN-IO-01`. Did not rewrite `ASTRA-12-R6-LED-CANDIDATES-01`.

This process has **no independent `Get-FileHash`**. Hash check = (1) live file **content** vs CANDIDATES quotes, (2) overlapping digests vs 12-R6 SHA256.txt / SHA256_POST.txt / T0430Z / T0530Z freeze strings / FAIL and IDELAY PRE+POST wrap hashes, (3) session stamps on raw reports vs T0530Z / T0430Z / T0500Z. Timing-report SHA strings first-recorded in this bag are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R7-BTN-CANDIDATES-01/`

Table-only. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `CANDIDATES.md` two new BTN rows from raw `ASTRA-11-A09R7-BTN-IO-01` and `ASTRA-11-A09R7-BTN-IDELAY-01` reports + SHA-256 of cited raw reports/XDC/io/util + pointers to 12-R6 **without rewriting those files** + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R7-BTN-CANDIDATES-01 only** — one unknown (handoff):

> Two new rows quoting raw reports: FAIL bag BTN-IO WNS=+0.452 WHS=−2.068; IDELAY bag TAP=31 WNS=+0.574 WHS=+0.131 BTN hold MET +0.638 false-path-btn NO. Pointers to 12-R6, do not rewrite those files. `PRODUCTION_TOP=UNKNOWN`. Do not close ASTRA-13, BOARD_PASS, LM06. PROGRAM=NO.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze. **Not** mixing FAIL WHS=−2.068 as PASS. **Not** promoting I1 DTS WHS=+0.131 as BTN pad hold. **Not** `set_false_path` on `btn[*]`. **Not** rewriting 12-R6.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R7-BTN-CANDIDATES-01.md`: ACK first; `CANDIDATES.md` two rows quoting raw reports (FAIL WNS=+0.452 WHS=−2.068; IDELAY TAP=31 WNS=+0.574 WHS=+0.131 BTN hold MET +0.638 false-path-btn NO); pointers to 12-R6, do **not** rewrite those files; `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD_PASS, LM06; PROGRAM=NO. Preserve: do not edit ASTRA-12-R6, ASTRA-11-A09R7-BTN-IO-01, ASTRA-11-A09R7-BTN-IDELAY-01. Do not rerun impl. Do not generate a `.bit`. Do not write `PRODUCTION_TOP=` a module name.
2. **Master ASTRA-12** (isolated DAG `ASTRA-12 FINAL-SOURCE-FREEZE` / T1500Z: *preprogram closure, unique bit, current board token/identity/UART plan*). This table must not steal that close. Historical ASTRA-12 / 12B freeze bags are different objects.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0530Z`: IDELAY bag PASS_NARROW; TAP=31 frozen before impl; raw routed WNS=+0.574 WHS=+0.131; BTN pad hold MET +0.638 vs related clk50u; false-path-btn NO; delays 2.000/0.500 kept; FAIL bag still WHS=−2.068; `PRODUCTION_TOP=UNKNOWN`; BOARD blocked YES.
5. Auditor `20260907T0430Z`: 12-R6 table PASS_NARROW; unique **12** = 1 new + 11 pointer; L1 raw WNS=+0.411 WHS=+0.027; 12-R4/R5 not overwritten; `PRODUCTION_TOP=UNKNOWN`.

Hunt (this dispatch):

1. Two new rows quote raw reports? FAIL and IDELAY not collapsed? false-path-btn NO on I1?
2. Unique 14 = 2 new + 12 pointer honest?
3. `PRODUCTION_TOP` UNKNOWN? No winner freeze?
4. Overclaim BOARD_PASS / ASTRA-13 / mixing FAIL as PASS?
5. Prior bags not rewritten (confirm 12-R6)?

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART/LED/BTN I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, physical IOB hold MET, DTS WHS as BTN pad hold, UART STA ladder as one envelope, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS, silent freeze of `a7ng_astra_11_a09r7_btn_idelay_wrap`, mixing I1 +0.574 with L1 +0.411 / N2 +0.336 / F1 +0.452, collapsing F1 WHS=−2.068 into I1 PASS.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` lists it first among this-bag files (`89e8e4546d91bf1236736b0f07d861a0a9fdea83b0a80a8dc5cf0f19cd7c7274`). Same digest in `SHA256_POST.txt`. `write_scope` = new bag only: ACK first + CANDIDATES.md two new BTN rows from raw ASTRA-11-A09R7-BTN-IO-01 and ASTRA-11-A09R7-BTN-IDELAY-01 reports + SHA256 of cited raw reports/XDC/io/util + pointers to 12-R6 without rewriting those files + RESULTS/CLOSEOUT; no RTL; no bitstream; no freeze of a winner; no `PRODUCTION_TOP=module`; no prior-bag rewrite; no impl/xsim rerun.

`PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`, `winner_frozen: false`, `new_rows: F1:a7ng_astra_11_a09r7_btn_io_wrap`, `I1:a7ng_astra_11_a09r7_btn_idelay_wrap`.

`does_not_close` includes production_top_identity, Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ASTRA-11_FULLCHIP_COFIT, Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, ACCEPT_BOARD, physical_IOB_hold_MET, physical_BTN_hold_as_DTS_WHS, UART_STA_ladder_as_one_envelope, ASTRA-11-A09R7-BTN-IO-01, ASTRA-11-A09R7-BTN-IDELAY-01, ASTRA-11-A09R7-LED-IO-01, ASTRA-11-A09R7-UART-IMPL-ROUTE-01, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-12-R6-LED-CANDIDATES-01, winner_as_frozen.

Bag listing: ACK.json, CANDIDATES.md, RESULTS.md, CLOSEOUT.md, metrics.json, git_head.txt, SHA256.txt, SHA256_POST.txt, file_manifest.txt. **No** `.bit` / `.bin` / `.mcs`. No `ckpt/`. No run scripts. No RTL. Same pack-only 9-file pattern as 12-R6.

RESULTS.md / CLOSEOUT.md / metrics.json / CANDIDATES.md header: `PRODUCTION_TOP=UNKNOWN`, `WINNER=NOT_FROZEN`, `BTN_NEW_ROWS=2`, `R6_POINTER_ROWS=12 unique`, `CANDIDATE_COUNT=14`, `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `BIT=NOT_BUILT`, `PROGRAM=NO`, `BTN_IO_BAG=FAIL_WHS`, `BTN_IDELAY_BAG=PASS_NARROW`.

CANDIDATES.md: **Rows are not ranked.** Do not treat max WNS, TAP=31, BTN IOB packed, or WHS≥0 as a freeze. Parent does **not** pick a top. This bag does **not** write `PRODUCTION_TOP=<module>`. F1 stays **FAIL_WHS**. I1 WHS=+0.131 does **not** erase F1 WHS=−2.068.

Base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH handoff and `git_head.txt` (`HANDOFF_BASE_MATCH=YES`). Branch `grok-orch/astra-native-v1-00` MATCH ACK. `git_head.txt` is **byte-identical** to 12-R6 `git_head.txt` (HEAD unchanged); claimed digest `2b39981c7ae125f2a8316072fcac20331eafc21a457b69d8b484804467058d8b` MATCH 12-R6 POST of the same six lines — not hash theatre.

---

### Hunt 1 — two new rows quote raw reports; FAIL and IDELAY not collapsed; false-path-btn NO on I1 — MATCH

Authority = live `timing_route.rpt` Design Timing Summary, Design State=Routed, **not** those bags’ RESULTS.md.

#### F1 FAIL bag — live `ASTRA-11-A09R7-BTN-IO-01/timing_route.rpt`

```text
Date         : Mon Sep  7 04:24:50 2026
Design       : a7ng_astra_11_a09r7_btn_io_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row (authority):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      0.452        0.000                      0                 8953       -2.068       -8.128                      4                 8951
Timing constraints are not met.
```

CANDIDATES.md F1 **+0.452 / −2.068** MATCH this live DTS and T0500Z / T0530Z. Intra-clock `clk50u`: WNS=0.452 WHS=−2.068 (TNS endpoints 7258; THS failing=4). Clock period `clk50u` 20.000 ns (50.000 MHz). Inter-clock hold columns **blank**.

`fail_r0/timing_route.rpt`: same Date **04:24:50**, same Design, same DTS **WNS=0.452 WHS=−2.068 THS=−8.128**, same “Timing constraints are not met.” FAIL bag **not retuned**.

Worst **setup** path (clk50u intra, Slack MET 0.452 ns):

```text
Source  u_a09r2/pv_reg[0][3]/C
Dest    u_a09r2/best_a_reg[15]/D
Requirement = 20.000 ns
Data Path Delay = 19.388 ns  (logic 5.609 / route 13.779)
```

MATCH CANDIDATES raw-quote block.

Worst **hold** path (clk50u intra, Slack VIOLATED −2.068 ns) — **is** BTN pad hold:

```text
Source  btn[0]  (D9, input port clocked by clk50u)
Dest    btn_q_reg[0]/D  (ILOGIC_X0Y187)
Path Type Hold (Min at Slow Process Corner)
Data Path Delay = 1.417 ns  (IBUF=1; route 0.000)
Input Delay = 0.500 ns
Clock Path Skew = 3.712 ns (DCD=6.515 SCD=2.656 CPR=0.147)
Clock Uncertainty = 0.082 ns
Device hold = 0.191 ns
Check : 1.417 + 0.500 − 3.712 − 0.082 − 0.191 = −2.068
```

MATCH CANDIDATES and live `timing_btn_in.rpt` Date 04:24:55 Slack (VIOLATED) −2.068 ns `btn[0]` → `btn_q_reg[0]/D`. F1 Kind = **Routed FAIL_WHS**. Not relabeled PASS.

F1 `util_route.rpt` Design State Routed: Slice LUTs **4944**, Slice Registers **3614**, BRAM **0**, DSP **2**, Bonded IOB **15**, IOB FF **10**, ILOGIC **5**, OLOGIC **5**, IDELAYCTRL **0**, IDELAYE2 **0**. MATCH CANDIDATES occupancy. FAIL wrap SV has **no** `IDELAYE2` / `IDELAYCTRL` string.

#### I1 IDELAY bag — live `ASTRA-11-A09R7-BTN-IDELAY-01/timing_route.rpt`

```text
Date         : Mon Sep  7 04:52:55 2026
Design       : a7ng_astra_11_a09r7_btn_idelay_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row (authority):

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)
      0.574        0.000                      0                 8954        0.131        0.000                      0                 8952        0.264
All user specified timing constraints are met.
```

CANDIDATES.md I1 **+0.574 / +0.131 TAP=31** MATCH this live DTS and T0530Z. Intra-clock `clk50u`: WNS=0.574 WHS=0.131 (TNS endpoints 7259). Clock Summary includes **clk200u 5.000 ns / 200.000 MHz** (absent on F1). Inter-clock hold columns **blank**.

Worst **setup** path (clk50u intra, Slack MET 0.574 ns) — **intra-DUT**, not a recycled UART/LED/FAIL number:

```text
Source  u_a09r2/pc2_reg[2][7]/C
Dest    u_a09r2/u_sgd/w_reg[19][1]/D
Requirement = 20.000 ns
Data Path Delay = 19.254 ns  (logic 10.243 / route 9.011)
```

Worst **hold** path (clk50u intra, Slack MET 0.131 ns) — **not BTN pad hold**:

```text
Source  idelay_rdy_sync_reg[0]/C   (SLICE_X0Y187)
Dest    idelay_rdy_sync_reg[1]/D   (SLICE_X0Y187)
Path Type Hold (Min at Fast Process Corner)
Data Path Delay = 0.206 ns (logic 0.141 / route 0.065)
```

MATCH CANDIDATES. DTS WHS=+0.131 is intra-clk50u `idelay_rdy_sync`. Implementer **discloses** this. BTN pad hold is separately MET **+0.638** ns.

Live `timing_btn_in.rpt` Date 04:53:00 Design `a7ng_astra_11_a09r7_btn_idelay_wrap`, command `report_timing -from [get_ports {btn[*]}] -delay_type min_max`:

```text
btn[0] D9 → btn_q_reg[0]  Min/hold Slack (MET)  0.638 ns  Input Delay=0.500  IDELAY_X0Y187
btn[2] B9 → btn_q_reg[2]  Min/hold Slack (MET)  0.679 ns
btn[1] C9 → btn_q_reg[1]  Min/hold Slack (MET)  0.681 ns
btn[3] B8 → btn_q_reg[3]  Min/hold Slack (MET)  0.699 ns
```

Hold path `btn[0]`: Data Path Delay = 4.123 ns (IBUF=1.417 + IDELAYE2=2.707). Check 4.123 + 0.500 − 3.712 − 0.082 − 0.191 = **+0.638**. F1 same skew family with data=1.417 IBUF-only → WHS=−2.068. −2.068 + 2.707 = +0.639 ≈ +0.638 (1 ps). MATCH CANDIDATES.

TAP=31: live wrap `localparam int unsigned BTN_IDELAY_VALUE = 31;` plus `BTN_IDELAYE2.txt` `BTN_IDELAY_VALUE_PREREG=31` `IDELAYE2_CELLS=4` `IDELAYE2_TAP31_CELLS=4` `IDELAYCTRL_CELLS=1`. I1 `util_route.rpt`: LUT **4947**, FF **3616**, BRAM **0**, DSP **2**, Bonded IOB **15**, IOB FF **10**, ILOGIC **5**, OLOGIC **5**, IDELAYCTRL **1**, IDELAYE2 **4**. MATCH CANDIDATES.

Delays still **max 2.000 / min 0.500** vs clk50u on both `btn_iodelay.xdc` files (not retuned).

#### false-path-btn NO on I1 (and F1)

Live I1 `exceptions_route.rpt` Design State Routed 04:53:00, Design `a7ng_astra_11_a09r7_btn_idelay_wrap`. Entire exception table:

```text
Position  From                     To                   Setup  Hold
2         [get_ports {sw[*]}]      *                    false  false
8         [get_ports uart_txd_in]  *                    -      false
9         *                        [get_ports uart_rxd_out]  -      false
```

**No row on `btn[*]`.** Live F1 `exceptions_route.rpt` Date 04:24:55: **same three rows**. UART Hold column **`false`**. UART Setup column **`-`**. **false-path-btn = NO** on F1 and I1. MATCH CANDIDATES `BTN_HOLD_POLICY=RELATED_CLK50U_NO_FALSE_PATH_HOLD`.

#### Pins / IOB (supporting)

Live F1 `io.rpt` Date 04:24:54 and I1 `io.rpt` Date 04:52:58: Total User IO = **15**. D9/C9/B9/B8 `btn[0..3]` INPUT LVCMOS33 FIXED; H5/J5/T9/T10 `led[0..3]` OUTPUT FIXED; A9 `uart_txd_in` INPUT FIXED; D10 `uart_rxd_out` OUTPUT FIXED. MATCH CANDIDATES Table A and `BTN_IOB.txt` (D9/C9/B9/B8 YES).

I1 clocks: live `clocks_route.rpt` Date 04:52:58 `clk50u 20.000 P,G,A {u_mmcm/CLKOUT0}`; `clk200u 5.000 P,G,A {u_mmcm/CLKOUT1}`; `uart_io_vclk 20.000 V {}`. F1 clocks Date 04:24:54: `clk50u` P,G,A; `uart_io_vclk` V; **no** `clk200u`. MATCH CANDIDATES.

#### Not collapsed

| Row | Design | Date | WNS | WHS | IDELAYE2 | Kind in table |
|-----|--------|------|-----|-----|----------|---------------|
| F1 | `a7ng_astra_11_a09r7_btn_io_wrap` | 04:24:50 | +0.452 | **−2.068** | 0 | **FAIL_WHS** |
| I1 | `a7ng_astra_11_a09r7_btn_idelay_wrap` | 04:52:55 | +0.574 | +0.131 (BTN pad +0.638) | 4 TAP=31 | **PASS_NARROW** |

Two rows. Two bags. Two Design names. Two dates. FAIL stays FAIL. I1 does not overwrite F1. Hunt 1: **MET.**

---

### Hunt 2 — unique count 14 honest (2 new + 12 pointer) — HONEST

Header arithmetic (ACK / CANDIDATES / RESULTS / CLOSEOUT / metrics):

```text
BTN_NEW_ROWS         = 2
R6_POINTER_ROWS      = 12 unique
CANDIDATE_COUNT      = 14
```

CANDIDATES.md states explicitly:

> `CANDIDATE_COUNT=14` = **2 new** (this bag) + **12** unique from ASTRA-12-R6-LED-CANDIDATES-01. 12-R6 is **pointed**, not rewritten, not double-counted.

Unique set = F1, I1, L1, N1, N2, U1, U2, U3, U4, U5, P1, P2, P3, P4 = **14**.

Not 16 (would be 2+12+2-column 12-R5 brief double-count).  
Not 15 (would add 12-R5 as extra unique).  
Not 13 (would miss a new row, or collapse P3/P4 in the unique-identity count).  
Not 12 (would omit F1/I1).  
Not 2-only (handoff asked to keep 12-R6 as pointers).  
Not 14 **new** routed wraps generated here (only F1 and I1 are new to this table).

LOOP_STATE `astra12_r7=IMPLEMENTER_CLAIM_14_ROWS_PENDING_AUDITOR` is this unique-14 claim, not fourteen new routed wraps.

Table B pointer identities MATCH T0430Z unique-12 list (L1 + N1, N2, U1–U5, P1–P4). RESULTS condensed pointer WNS MATCH T0430Z: L1 +0.411/+0.027; N1 XSim N/A; N2 +0.336/+0.104; U1 XSim N/A; U2 +0.305; U3 +0.681; U4 +0.115/−4.915; U5 +0.115/+0.131; P1 +1.041 UART NO; P2 +5.733 UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES.

F1 and I1 are **new named wraps**, not L1 (`a7ng_astra_11_a09r7_led_io_wrap`) and not N2 (`a7ng_astra_11_a09r7_uart_impl_wrap`). Different Design names, dates, WNS, WHS, endpoint counts, IDELAYE2 occupancy.

Distinct **module names** in the 14-row set are **13** because P3 and P4 share `arty_a7_astra09_soc_top` (two bags). T0230Z unique-11 and T0430Z unique-12 already counted those as two identities. This bag’s unique-14 continues that convention (2 new + 12 R6 identities), not “13 distinct SV modules.”

Hunt 2: **HONEST.**

---

### Hunt 3 — PRODUCTION_TOP UNKNOWN; no winner freeze — MET

| Artifact | PRODUCTION_TOP | WINNER |
|----------|----------------|--------|
| ACK.json | `"UNKNOWN"`, `winner_frozen: false` | not a module name |
| CANDIDATES.md | UNKNOWN / NOT_FROZEN; rows **not ranked** | explicit: I1 is **not** a freeze of `PRODUCTION_TOP`; F1 stays FAIL_WHS |
| RESULTS.md | UNKNOWN; “Not frozen. Not silently chosen.” | I1 +0.574 **is not** that top; F1 −2.068 **is not** that top; L1 +0.411 **is not** that top; N2 +0.336 **is not** that top |
| CLOSEOUT.md | UNKNOWN / NOT_FROZEN | “This bag is not that freeze.” Do not freeze `PRODUCTION_TOP=a7ng_astra_11_a09r7_btn_idelay_wrap` |
| metrics.json | `"UNKNOWN"`, `winner_frozen: false` | — |
| SHA256.txt / POST | comments PRODUCTION_TOP=UNKNOWN | — |
| git_head.txt / file_manifest.txt | UNKNOWN | — |
| LOOP_STATE.json (read-only) | `"UNKNOWN"` / `NEEDS_OWNER_NOT_SILENT` | — |

No `PRODUCTION_TOP=a7ng_astra_11_a09r7_btn_idelay_wrap` (or any other module) written as a freeze. TAP=31 / WNS=+0.574 is **not** treated as a production freeze. 12-R6 residual (freeze a top **or keep UNKNOWN**) is **kept UNKNOWN**. Hunt 3: **MET.**

---

### Hunt 4 — overclaim BOARD_PASS / ASTRA-13 / mixing FAIL as PASS — NOT FOUND

Every this-bag product: `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `ACCEPT_BOARD` missing/false, `BIT=NOT_BUILT`, `PROGRAM=NO`, `write_bitstream=false`, COM12/JTAG UNTOUCHED.

ACK `does_not_close` lists Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ACCEPT_BOARD, physical_IOB_hold_MET, **physical_BTN_hold_as_DTS_WHS**.

RESULTS: “Do **not** call this BOARD_PASS or ASTRA-13.” F1 labeled **FAIL_WHS**. I1 labeled **PASS_NARROW**. F1 WHS=−2.068 bag **not overwritten**.

CANDIDATES Not claimed: PRODUCTION_TOP, Winner, write_bitstream, BOARD_PASS, ASTRA-13, ACCEPT_BOARD, LM06, Physical IOB hold MET (UART I/O hold excepted; U4 −4.915 remains), **DTS WHS=+0.131 as BTN pad hold (BTN hold is +0.638)**, F1 WHS=−2.068 as closed, mixing I1 +0.574 with L1 +0.411 / N2 +0.336 / F1 +0.452, promoting I1 WHS=+0.131 to erase F1 −2.068 / U4 −4.915 / U5 +0.131, silent freeze of `a7ng_astra_11_a09r7_btn_idelay_wrap`, `set_false_path` on `btn[*]`.

No `.bit` in this bag. No `BOARD_PASS=YES`. No `ASTRA-13=PASS`. No `WINNER=` a module.

Implementer self-grade `PASS_NARROW` / CLOSEOUT `PASS_THIS_GATE_ONLY` is bounded to the table unknown. Not a Master-12/13 close. Not a FAIL-as-PASS collapse.

HOLD-wrap DTS WHS=+0.131 coincidence is **disclosed** (Date Sun Sep 6 23:33:11 2026, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, WNS=+0.115, TNS endpoints=8601). Live HOLD rpt still that Date / Design / DTS. I1 Date 04:52:55 Design `…btn_idelay_wrap` WNS=0.574 endpoints=8954 worst hold = `idelay_rdy_sync`. **Not stolen.**

Hunt 4: **NOT OVERCLAIM.** FAIL not mixed as PASS.

---

### Hunt 5 — prior bags not rewritten (12-R6 and FAIL / IDELAY / LED / UART) — MET

Live 12-R6 `CANDIDATES.md` still:

```text
GATE             = ASTRA-12-R6-LED-CANDIDATES-01
CANDIDATE_COUNT  = 12
LED_NEW_ROWS     = 1
R4_POINTER_ROWS  = 11 unique
PRODUCTION_TOP   = UNKNOWN
WINNER           = NOT_FROZEN
```

No `btn_io_wrap` / `btn_idelay` / `F1` / `I1` / `TAP=31` / `WHS=-2.068` strings in that directory (grep). Pointer SHA claimed `917537363da034cc4192e42731a5a78a8b70136e3648dbc1ae2b328d50b07212` MATCH 12-R6 `SHA256.txt` product line **and** 12-R6 `SHA256_POST.txt` (tabled 2026-09-07T03:32:14 / POST 03:32:59) **and** T0430Z. This bag’s hash of 12-R6 `SHA256.txt` `6aeff64838408ac1f4b93db68721d28eb8c415456efe317af50bc09af1a54bfa` MATCH 12-R6 POST. 12-R6 listing still ACK / CANDIDATES / RESULTS / CLOSEOUT / metrics / git_head / SHA256 / SHA256_POST / file_manifest. No F1/I1 row inserted. RESULTS still `CANDIDATE_COUNT=12`. SHA256.txt still *Tabled 2026-09-07T03:32:14+07:00*.

Live 12-R4 `CANDIDATES.md` still `GATE=ASTRA-12-R4-R7-UART-CANDIDATES-01` `CANDIDATE_COUNT=11`. No F1/I1 strings.  
Live 12-R5 `BRIEF.md` still `GATE=ASTRA-12-R5-FREEZE-BRIEF-01` `COLUMNS=2` `WINNER=NOT_FROZEN`. No F1/I1 strings.  
Live 12-R2 `CANDIDATES.md` still `GATE=ASTRA-12-R2-TOP-CANDIDATES-01` `CANDIDATE_COUNT=4`. No F1/I1 strings.  
Live 12-R3 `CANDIDATES.md` still `GATE=ASTRA-12-R3-UART-WRAP-CANDIDATES-01` `CANDIDATE_COUNT=9`. No F1/I1 strings.

FAIL bag **not overwritten** (raw): live `timing_route.rpt` still Date **Mon Sep 7 04:24:50 2026**, Design `a7ng_astra_11_a09r7_btn_io_wrap`, WNS=0.452 WHS=−2.068. `fail_r0/` still present, same DTS. FAIL SHA freeze still `2026-09-07T04:20:01.2603642+07:00`. FAIL POST still `2026-09-07T04:25:01.1754930+07:00`. Wrap SHA `52e1b4f2…3eec6132` MATCH FAIL PRE **and** FAIL POST **and** this bag’s KEEP. `btn_iodelay.xdc` still 2.000/0.500.

IDELAY bag **not overwritten** (raw): live `timing_route.rpt` still Date **Mon Sep 7 04:52:55 2026**, Design `a7ng_astra_11_a09r7_btn_idelay_wrap`, WNS=0.574 WHS=0.131. IDELAY SHA freeze still `2026-09-07T04:48:09.8689055+07:00`. POST still `2026-09-07T04:53:01.5024181+07:00`. Wrap SHA `5fa1c354…e99b48ee` MATCH IDELAY PRE **and** POST **and** this bag. TAP=31 still in wrap localparam.

LED-IO bag **not overwritten** (raw): `timing_route.rpt` still Date **Mon Sep 7 03:11:15 2026**, Design `a7ng_astra_11_a09r7_led_io_wrap`, WNS=0.411 WHS=0.027, TNS endpoints=8949. Claimed SHA `4fbd3e42e633dcf59e96276227314982398a81d59802b0341676bb83b0d52585` MATCH 12-R6 SHA256.txt. F1/I1 do **not** steal L1.

N2 UART wrap **not overwritten** (raw): `timing_route.rpt` still Date **Mon Sep 7 01:52:48 2026**, Design `a7ng_astra_11_a09r7_uart_impl_wrap`, DTS WNS=0.336 WHS=0.104, TNS endpoints=8940. Claimed SHA `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` MATCH 12-R6 SHA256.txt.

U4 IOBFF bag **not overwritten** (raw): live DTS WNS=0.115 WHS=**−4.915**. I1 WHS=+0.131 does **not** erase U4.

U5 HOLD bag **not overwritten** (raw): Date **Sun Sep 6 23:33:11 2026**, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`, WNS=0.115 WHS=0.131, TNS endpoints=8601. I1 does **not** steal U5.

This bag **copies quotes / pointer identities** into its own `CANDIDATES.md` Table B. That is the required pointer. It does **not** add F1/I1 into the 12-R6 files.

Hunt 5: **MET.** 12-R6 **not rewritten.**

---

### Hash theatre / this-bag product

This-bag product hashes (first-recorded in `SHA256.txt` / `SHA256_POST.txt`; not re-digested here): ACK `89e8e454…`, CANDIDATES `6be8a48d…`, RESULTS `d015feeb…`, CLOSEOUT `5eb8d542…`, metrics `61f5020f…`, git_head `2b39981c…` (also 12-R6 POST of identical content), SHA256.txt itself `74280754…` (POST only), file_manifest `a1eaac43…` (POST; not in SHA256.txt product list — same R5/R6 pattern). ACK.json digest is the same in SHA256.txt and SHA256_POST.txt. SHA256.txt stamped 2026-09-07T05:10:44+07:00; POST stamped 2026-09-07T05:11:45+07:00.

Overlap (strings compared, not re-hashed):

| Object | Digest | Overlap |
|--------|--------|---------|
| 12-R6 CANDIDATES.md | `91753736…b07212` | 12-R6 SHA256 + POST + T0430Z |
| 12-R6 SHA256.txt | `6aeff648…a54bfa` | 12-R6 POST + T0430Z |
| 12-R6 ACK.json | `c1187d8a…e28c4cfb` | 12-R6 SHA256 + POST + T0430Z |
| L1 `timing_route.rpt` | `4fbd3e42…d52585` | 12-R6 SHA256.txt; content MATCH live DTS +0.411/+0.027 Date 03:11:15 |
| N2 `timing_route.rpt` | `0c45687b…378d2b` | 12-R6 SHA256.txt; content MATCH live DTS +0.336/+0.104 Date 01:52:48 |
| F1 wrap SV | `52e1b4f2…ec6132` | FAIL PRE + FAIL POST + IDELAY KEEP + T0530Z |
| I1 wrap SV | `5fa1c354…9b48ee` | IDELAY PRE + IDELAY POST + T0530Z |
| Frozen A09-R2 DUT | `15a919f1…ee23` | FAIL / IDELAY / 12-R6 / T0530Z / T0430Z |
| Cite `constraints/arty_a7_100.xdc` | `1c12e6f8…a9c2` | T0530Z / 12-R6 freeze of the same file |
| git_head.txt | `2b39981c…058d8b` | 12-R6 POST (identical six lines) |

Limitation: this-bag markdown hashes, F1 `timing_route.rpt` SHA `8749d728…` and I1 `timing_route.rpt` SHA `19696683…` (first-recorded here; FAIL/IDELAY PRE/POST hash compiled sources, not the rpt), F1/I1 io/util/exceptions/clocks/`timing_btn_in`/XDC extracts, 12-R6 `SHA256_POST.txt` as an object (`4b6bd041…`, first-recorded here), T0530Z REPORT `6fa7b0f0…`, and this handoff `08eb102b…` cannot be re-digested without a shell. Content of those reports MATCHES quotes / T0530Z / T0430Z / opened files. Invented overlapping DUT/XDC/wrap/12-R6 pointer digests: **not found.** F1 live vs `fail_r0` DTS/header **byte-class identical** on the quoted fields (same Date, Design, WNS=0.452, WHS=−2.068, THS=−8.128).

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS/WHS from RESULTS.md only | **No.** CANDIDATES cites raw DTS; live MATCH. |
| Collapse FAIL WHS=−2.068 into I1 PASS | **No.** Two rows; F1 Kind=FAIL_WHS; fail_r0 intact 04:24:50. |
| Recycle L1 LED wrap WNS=+0.411 as I1 +0.574 | **No.** Different top, date, WNS, WHS, endpoint count, IDELAYE2. LED raw rpt intact 03:11:15. |
| Recycle N2 UART wrap WNS=+0.336 as I1/F1 | **No.** UART raw rpt intact 01:52:48. |
| Recycle HOLD wrap WHS=+0.131 as I1 DTS WHS | **No.** HOLD rpt Date 23:33:11 Design `…iobff_hold_wrap` WNS=0.115 endpoints=8601. This worst hold is `idelay_rdy_sync` on I1. Disclosed coincidence. |
| Recycle wrap-route +5.733 / IOBFF −4.915 / IOdelay +0.681 / UART wrap +0.305 as F1/I1 | **No.** Explicit split. |
| Promote DTS WHS=+0.131 as BTN pad hold | **Not claimed.** Disclosed intra-clk50u vs BTN hold MET +0.638. |
| `set_false_path` on `btn[*]` to make WHS tautological | **No.** `exceptions_route.rpt` has no btn row on F1 or I1. |
| Retune 2.000/0.500 | **No.** Both `btn_iodelay.xdc` still 2.000/0.500. FAIL DTS still WHS=−2.068. |
| Rank / silent-freeze a winner / TAP=31 as PRODUCTION_TOP | **No.** Not ranked. `PRODUCTION_TOP=UNKNOWN`. CLOSEOUT forbids freeze of I1 wrap. |
| BOARD_PASS / ACCEPT_BOARD / ASTRA-13 | **Not claimed.** BLOCKED / NOT_CLAIMED. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. |
| CANDIDATE_COUNT=14 as 14 new / or 2+12+2=16 | **No.** Header splits 2 new + 12 pointer; 12-R5 not extra unique. |
| Mix UART STA ladder as one envelope | **Not claimed.** `does_not_close` includes that. |
| Add F1/I1 into 12-R6 files | **No.** 12-R6 GATE/count/hash MATCH POST; no F1/I1 rows inserted. |
| Hash theatre | **Not found** for overlapping DUT/XDC/wrap/12-R6 pointer digests. First-recorded F1/I1 timing SHA is content-verified only. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps (FAIL 04:24:50; IDELAY 04:52:55; LED 03:11:15; N2 01:52:48; HOLD 23:33:11; U4 −4.915). |
| Rewrite 12-R6 / 12-R5 / 12-R4 / 12-R2 / 12-R3 / FAIL / IDELAY | **Not found.** GATE names, counts, SHA freeze stamps MATCH prior auditors. |
| TB-load / one-hot transfer | N/A for a table-only bag. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / DTS WHS as BTN pad hold / FAIL-as-PASS. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the BTN-extension candidate-table unknown.

Evidence class: F1/I1 WNS/WHS/IOB = **routed DTS EVIDENCE** (Design Timing Summary, Design State=Routed — not relabeled STA). I1 BTN pad hold +0.638 = **path STA EVIDENCE** from `timing_btn_in.rpt` (separate from DTS WHS). Pointer WNS = **prior-bag routed EVIDENCE** (not re-impl). `PRODUCTION_TOP=UNKNOWN` = **CONFIRMED** in this bag’s products. Board plugged = **OBSERVED in LOOP_STATE as USER_SAYS_PLUGGED_UNPROGRAMMED**, not authority to program.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written. No RESULTS/raw contradiction on F1 WNS/WHS/IOB/hold-policy, I1 WNS/WHS/TAP/BTN-pad/+0.638/false-path-btn NO, L1/N2 pointer identity, or the twelve 12-R6 pointer identities.

Residuals (not this-bag FAIL):

1. CANDIDATES.md WNS “quotes” for F1/I1 include the verbatim Design Timing Summary numeric row (same strength as 12-R6 L1). Pointer Table B lists module+bag only; RESULTS condensed pointer WNS omit some WHS (U2 +0.024, U3 +0.100, P3 +0.046) the way 12-R6/R4 compressed them. Numbers that are quoted MATCH. Not a WNS miss.
2. First-recorded SHA of F1/I1 `timing_route.rpt` / this-bag markdown / T0530Z REPORT / 12-R6 POST file cannot be re-digested without a shell. Content MATCHES T0530Z / T0430Z / opened files.
3. ACK `observed_session_id=UNKNOWN`. Does not affect the table unknown.
4. F1 DSP=2 / I1 DSP=2 is frozen SGD, not a7-fpga-gate eam03e DSP=0. Occupancy LUT 4944/4947 vs LED wrap 4945 / UART wrap 4945 is expected (BTN IDELAY cells on I1). Disclosed: do not add F1/I1 LUT/FF to L1/N2 as a whole-chip sum.
5. Distinct **module names** in the 14-row set are **13** because P3 and P4 share `arty_a7_astra09_soc_top`. T0230Z/T0430Z already counted those as two identities. This bag’s unique-14 continues that convention, not “13 distinct SV modules.” Prose and `CANDIDATE_COUNT=14` correct a reader who only sums 2+12+2 or who collapses P3/P4 then under-counts.
6. `file_manifest.txt` is hashed in POST only, not in `SHA256.txt` product list (same as 12-R5/R6). Not a missing required artifact.
7. I1 UART I/O hold remains excepted (T0530Z residual). This table correctly does not promote DTS WHS=+0.131 as physical IOB hold MET or as BTN pad hold. U4 −4.915 remains on disk. F1 WHS=−2.068 remains on disk.
8. 12-R6 residual (freeze a top **or keep UNKNOWN**) is honored: this bag **keeps UNKNOWN**. TAP=31 is `PASS_NARROW` evidence class, not a production freeze.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a candidate table now includes **two new BTN rows** (F1 routed FAIL_WHS WNS=+0.452 WHS=−2.068 BTN pad hold VIOLATED, IDELAYE2=0, false-path-btn NO; I1 routed PASS_NARROW TAP=31 WNS=+0.574 WHS=+0.131 DTS intra-clk50u, BTN pad hold MET +0.638, IDELAYE2=4 + IDELAYCTRL=1, false-path-btn NO; both BTN D9/C9/B9/B8 + LED H5/J5/T9/T10 + UART A9/D10 kept; delays 2.000/0.500 kept) plus **pointers** to the intact 12-R6 twelve-identity table, unique count **14**, with hashes and raw quotes, **without** BOARD_PASS, **without** silently naming a production top, **without** freezing a winner, **without** mixing FAIL as PASS, **without** rewriting 12-R6 / FAIL route / IDELAY route / LED-IO route / A09R7 UART route.

**Master ASTRA-12** (preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison table of already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE` are different bags and are **not** this close (ACK `does_not_close`). 12-R2 remains the board-level pointer table; 12-R3 extended it with R3 UART wraps; 12-R4 extended it with R7 XSim + A09R7 UART impl-route; 12-R5 is a two-column brief of two of those; 12-R6 extended the table with the LED wrap; this R7 bag **extends** the table with FAIL BTN-IO + IDELAY TAP=31. None of those is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **some** rows (I1 / L1 / N2 / U2 / U3 / U5 DTS; F1 WNS≥0 but WHS<0; U4 WNS≥0 but WHS<0; P3 WNS<0); that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen. I1 DTS WHS≥0 is intra-clk50u; BTN pad hold MET +0.638 is path STA on this named wrap, not silicon buttons; UART I/O hold remains excepted, not physically MET. Routed IDELAYE2 tap **≠** silicon button delay.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**. Physical IOB hold MET remains **OPEN** (U4 −4.915 still on disk). UART STA ladder remains **separate envelopes**, not one closed ladder.

T0530Z residual (do not freeze `PRODUCTION_TOP`; do not ASTRA-13; do not promote WNS=+0.574 / WHS=+0.131 / TAP=31 as BOARD_PASS or as BTN pad DTS WHS or as FAIL −2.068 closed) is **honored**, not closed as Master 12/13.

T0430Z residual (freeze a production top **or keep UNKNOWN**; parent does not pick; do not rewrite 12-R6) is **honored**: this bag **keeps UNKNOWN** and **does not rewrite 12-R6**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R7-BTN-CANDIDATES-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + CANDIDATES.md table from raw reports; **2 new** BTN rows (F1 routed FAIL_WHS WNS=+0.452 WHS=−2.068 BTN pad hold VIOLATED IDELAYE2=0 false-path-btn NO; I1 routed PASS_NARROW TAP=31 WNS=+0.574 WHS=+0.131 DTS intra-clk50u, BTN pad hold MET +0.638, IDELAYE2=4 + IDELAYCTRL=1, false-path-btn NO; both BTN D9/C9/B9/B8 LED H5/J5/T9/T10 UART A9/D10 kept IOB FF YES RELATED_CLK50U_NO_FALSE_PATH_HOLD on BTN / FALSE_PATH_HOLD HONEST on UART) + **12** 12-R6 unique pointer identities = unique **14**; F1/I1 WNS/WHS/TAP/IOB/hold-policy MATCH live Design State=Routed files and T0530Z / T0500Z; FAIL and IDELAY **not collapsed**; 12-R6 files **not rewritten**; FAIL route / IDELAY route / LED-IO route / A09R7 UART route **not overwritten**; `PRODUCTION_TOP=UNKNOWN`; winner not frozen; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13; DTS WHS not claimed as BTN pad hold; FAIL not mixed as PASS.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze; physical IOB hold MET; DTS WHS as BTN pad hold; UART STA as one envelope; FAIL closed).  
Not FAIL (required artifacts present; F1/I1 WNS/WHS/TAP/IOB/false-path-btn MATCH live routed reports; unique count 14 honest as 2 new + 12 pointer; overlapping hashes MATCH prior freeze lists; prior bags including 12-R6, 12-R5, 12-R4, 12-R2, 12-R3, FAIL −2.068, IDELAY TAP=31, U4 −4.915, LED-IO route, A09R7 UART route not rewritten; no program; no winner).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / DTS WHS as BTN pad hold / FAIL-as-PASS / 14-new-rows not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared table-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this table to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, physical IOB hold MET, DTS WHS as BTN pad hold, FAIL WHS=−2.068 as closed, or a silent `PRODUCTION_TOP=<module>` (including `a7ng_astra_11_a09r7_btn_idelay_wrap`). `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**. TAP=31 is `PASS_NARROW`, not a freeze.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on I1 / L1 / N2 / U2 / U3 / U5 / P1 / P2 / P4 is **not** that gate. I1 WHS=+0.131 is **not** BTN pad hold and **not** U4 −4.915 MET. BTN hold MET +0.638 on this named wrap is **not** silicon buttons. Routed IDELAYE2 tap **≠** silicon button delay.
3. Keep F1 WHS=−2.068 on disk (`fail_r0/` intact). Keep U4 WHS=−4.915 on disk. Do **not** collapse I1 FALSE_PATH_HOLD DTS WHS≥0 into physical IOB hold MET. Keep UART STA envelopes **separate**. Do **not** mix I1 +0.574 with L1 +0.411 / N2 +0.336 / F1 +0.452 / U2 +0.305 / U3 +0.681 / U4/U5 +0.115 / P2 +5.733. Do **not** steal HOLD wrap WHS=+0.131 as I1 DTS WHS.
4. Do **not** rewrite `ASTRA-12-R6-LED-CANDIDATES-01`, `ASTRA-12-R5-FREEZE-BRIEF-01`, `ASTRA-12-R4-R7-UART-CANDIDATES-01`, `ASTRA-12-R2-TOP-CANDIDATES-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-11-A09R7-BTN-IO-01`, `ASTRA-11-A09R7-BTN-IDELAY-01`, `ASTRA-11-A09R7-LED-IO-01`, or `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`. Do not rerun those impl/xsim scripts. FAIL `timing_route.rpt` must stay 04:24:50 WNS=0.452 WHS=−2.068 Design `a7ng_astra_11_a09r7_btn_io_wrap`. IDELAY `timing_route.rpt` must stay 04:52:55 WNS=0.574 WHS=0.131 Design `a7ng_astra_11_a09r7_btn_idelay_wrap`. 12-R6 `CANDIDATES.md` must stay hash `91753736…` / `CANDIDATE_COUNT=12`. LED `timing_route.rpt` must stay 03:11:15 WNS=0.411 WHS=0.027. A09R7 UART `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104.
5. Do **not** add I1 LUT=4947 to L1 4945 / N2 4945 / F1 4944 as a whole-chip sum. Do not treat max WNS, TAP=31, BTN IOB packed, or hold-exception WHS≥0 as a freeze. Do not add F1/I1 as extra 12-R5 brief columns. Do **not** `set_false_path` on `btn[*]`. Do **not** retune frozen 2.000/0.500.
6. Count: unique **14** = 2 new + 12 pointer. Do not brief this as “14 new BTN wraps” or as “16 rows.” Distinct module names are 13 only if P3/P4 are collapsed; that is **not** this bag’s unique-14 convention (inherited from T0230Z unique-11 / T0430Z unique-12 identities).
7. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/LED/BTN pinout **on that top**, unique bit after WNS≥0 **on that top**, then ASTRA-13 + owner + ACCEPT_BOARD. Not this table’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **BTN candidate-table extension**: hashes + raw quotes of two new rows (F1 FAIL-bag BTN-IO wrap routed WNS=+0.452 WHS=−2.068 FAIL_WHS kept on disk; I1 IDELAY TAP=31 wrap routed WNS=+0.574 WHS=+0.131 PASS_NARROW, BTN pad hold MET +0.638, false-path-btn NO, delays 2.000/0.500 kept) plus pointers to intact 12-R6 (12 unique), unique count **14**, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN, 12-R6/12-R5/12-R4/12-R2/12-R3/FAIL route/IDELAY route/LED-IO route/A09R7 UART route **not rewritten**, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen. Physical IOB hold is **not** MET. DTS WHS=+0.131 is **not** BTN pad hold. F1 WHS=−2.068 is **not** PASS. I1 wrap is **not** the production top.

Not `FAIL_LOOP`: the declared table unknown is met on raw routed reports and honest unique-14 arithmetic.  
Not `ACCEPT_BOARD`: no bitstream, no silicon, `PRODUCTION_TOP=UNKNOWN`, ASTRA-13 BLOCKED.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
Physical IOB hold MET: **OPEN** (U4 WHS=−4.915 untouched).  
ASTRA-12-R6-LED-CANDIDATES-01: **untouched, still PASS_NARROW unique 12, not this table**.  
ASTRA-11-A09R7-BTN-IO-01 routed WNS=+0.452 WHS=−2.068: **untouched, still FAIL_WHS evidence**.  
ASTRA-11-A09R7-BTN-IDELAY-01 routed TAP=31 WNS=+0.574 WHS=+0.131: **untouched, still PASS_NARROW evidence, not a freeze**.  
ASTRA-11-A09R7-LED-IO-01 routed WNS=+0.411 WHS=+0.027: **untouched**.  
ASTRA-11-A09R7-UART-IMPL-ROUTE-01 routed WNS=+0.336 WHS=+0.104: **untouched**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. BTN IOB: **YES** (tabled). BTN IDELAYE2: **YES TAP=31** (I1 only). false-path-btn: **NO**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0600Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R7-BTN-CANDIDATES-01; unique 14 = 2 new + 12 pointer; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
