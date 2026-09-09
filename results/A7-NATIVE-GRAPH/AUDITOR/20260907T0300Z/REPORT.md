# ASTRA auditor REPORT — 20260907T0300Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R5_FREEZE_BRIEF_INDEPENDENT_AUDIT; astra12_r4=AUDITOR_PASS_NARROW_11_UNIQUE_2_NEW_PLUS_9_POINTERS; astra12_r5=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R5-FREEZE-BRIEF-01 + prior auditor 20260907T0230Z (12-R4 table PASS_NARROW unique 11; ACCEPT_PARTIAL | REJECT_PROMOTION; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T0200Z (A09R7 UART impl-route PASS_NARROW WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD HONEST) + T1500Z (12-R2 four routed tops; wrap-route WNS=+5.733 async_default; 100 MHz sibling WNS=−4.765)
EVIDENCE   = bag ACK.json / BRIEF.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / file_manifest.txt / git_head.txt + RAW cited prior-bag files (wrap-route timing.rpt / io.rpt / util.rpt / clocks.rpt / BITSTREAM.txt / SHA256_BIT.txt, A09R7 timing_route.rpt / io.rpt / util_route.rpt / exceptions_route.rpt / clocks_route.rpt / UART_IOBFF.txt / clk50_uart_impl.xdc / wrap+plant SV, 100 MHz sibling timing.rpt, constraints/arty_a7_100.xdc, wrap-route SoC SV, 12-R4 CANDIDATES.md + SHA256.txt, 12-R2 SHA256.txt, T0230Z REPORT) — NOT RESULTS.md of those bags as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (would wipe routed reports / `xsim.log`). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`. Did not generate a `.bit`.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs BRIEF quotes, (2) overlapping digests vs 12-R2 / 12-R4 / A09R7 PRE+POST / wrap-route SHA256.txt freeze strings + T0230Z / T0200Z / T1500Z, (3) session stamps on raw reports vs those auditors. First-recorded SHA strings in this bag (this-bag markdown, wrap-route `clocks.rpt`, wrap-route `SHA256_BIT.txt`, T0230Z REPORT, this handoff) are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R5-FREEZE-BRIEF-01/`

Pack-only **decision brief**. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `BRIEF.md` two columns from raw routed reports + SHA-256 of cited raw reports/XDC/io/util/bit + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R5-FREEZE-BRIEF-01 only** — one unknown (handoff):

> Decision brief comparing two strongest existing routed UART candidates. `PRODUCTION_TOP` stays UNKNOWN. Parent does **not** pick. PROGRAM=NO.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze. **Not** physical IOB hold MET. **Not** promoting column B WHS=+0.104 as U4 −4.915 MET. **Not** promoting R7 XSim `ans=4` / `w0=−5` as column B’s routed result. **Not** adopting historical UNPROGRAMMED bit `8116fa77…`.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R5-FREEZE-BRIEF-01.md`: ACK first; `BRIEF.md` two columns only, quoting raw reports + hashes:
   - **A:** `arty_a7_astra_rtp_soc_top` wrap-route WNS=+5.733 UART D10/A9 BRAM=2 (historical SoC)
   - **B:** `a7ng_astra_11_a09r7_uart_impl_wrap` WNS=+0.336 WHS=+0.104 UART IOB YES A09-R2 query-learn (XSim ans=4/w0=−5 is a **different** bag)
   - Gaps per column: unique bit, ACCEPT_BOARD, LM06, fixture plant, FALSE_PATH_HOLD, 100 MHz fail sibling
   - `PRODUCTION_TOP=UNKNOWN`. Do not recommend a winner as frozen. Do not close ASTRA-13, BOARD_PASS.
   Preserve: do not edit 12-R2/R3/R4, A09R7 impl-route, wrap-route SoC, R7 XSim. Do not rerun impl. Do not generate a `.bit`. Do not write `PRODUCTION_TOP=` a module name.
2. **Master ASTRA-12** (isolated DAG `ASTRA-12 FINAL-SOURCE-FREEZE` / T1500Z: *preprogram closure, unique bit, current board token/identity/UART plan*). This brief must not steal that close. Historical ASTRA-12 / 12B freeze bags are different objects.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate. `PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260907T0230Z`: 12-R4 table PASS_NARROW; unique **11** = 2 new + 9 pointers; N2 routed WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD HONEST; N1 XSim ans=4 then w0=−5 (no routed WNS); `PRODUCTION_TOP=UNKNOWN`; residual 8: freeze a production top **or keep UNKNOWN**; parent does not pick; BOARD blocked YES.
5. Auditor `20260907T0200Z`: A09R7 bag PASS_NARROW; raw routed WNS=+0.336 WHS=+0.104; UART IOB YES IOB FF packed; FALSE_PATH_HOLD HONEST (UART I/O hold excepted, not physically MET).
6. Auditor `20260906T1500Z`: 12-R2 table PASS_NARROW; four pointer WNS +1.041 / **+5.733** / **−4.765** / +7.179; wrap-route summary WNS=+5.733 is `**async_default**`; intra `clk50u` +7.150; 100 MHz sibling not collapsed with 50 MHz PASS.

Hunt (this dispatch):

1. Two columns only from raw reports? Hashes match live files?
2. Gaps listed: unique bit, ACCEPT_BOARD, LM06, 100 MHz fail sibling, FALSE_PATH_HOLD honest vs physical MET?
3. `PRODUCTION_TOP` still UNKNOWN? No winner freeze / recommendation-as-freeze?
4. R7 XSim not mixed into column B as the routed result?
5. Overclaim BOARD_PASS / ASTRA-13?

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, physical IOB hold MET, UART STA ladder as one envelope, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS, silent freeze of column A or column B, adopting `8116fa77…` as the unique production bit.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` lists it first among this-bag files (`f4d0ca51…e1ebda`). Same digest in `SHA256_POST.txt`. `write_scope` = new bag only: ACK first + BRIEF.md two columns from raw reports (wrap-route SoC vs A09R7 UART impl-route) + SHA256 of cited raw reports/XDC/io/util/bit + RESULTS/CLOSEOUT; no RTL; no bitstream; no freeze of a winner; no `PRODUCTION_TOP=module`; no prior-bag rewrite; no impl/xsim rerun.

`PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`, `winner_frozen: false`, `columns: ["A:arty_a7_astra_rtp_soc_top", "B:a7ng_astra_11_a09r7_uart_impl_wrap"]`.

`does_not_close` includes production_top_identity, Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ASTRA-11_FULLCHIP_COFIT, Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, ACCEPT_BOARD, physical_IOB_hold_MET, UART_STA_ladder_as_one_envelope, ASTRA-SOC-RTP-WRAP-ROUTE, ASTRA-11-A09R7-UART-IMPL-ROUTE-01, ASTRA-09-R7-UART-QUERY-REW-01, winner_as_frozen.

Bag listing: ACK.json, BRIEF.md, RESULTS.md, CLOSEOUT.md, metrics.json, git_head.txt, SHA256.txt, SHA256_POST.txt, file_manifest.txt. **No** `.bit` / `.bin` / `.mcs`. No `ckpt/`. No run scripts. No RTL.

RESULTS.md / CLOSEOUT.md / metrics.json / BRIEF.md header: `PRODUCTION_TOP=UNKNOWN`, `WINNER=NOT_FROZEN`, `COLUMNS=2`, `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `BIT=NOT_BUILT`, `PROGRAM=NO`, `ACCEPT_BOARD=MISSING`.

BRIEF.md: Columns are **not ranked**. Do not treat max WNS, UART present, IOB FF packed, hold-exception WHS≥0, BRAM present, or a historical UNPROGRAMMED `.bit` as a freeze. Parent does **not** pick. This bag does **not** write `PRODUCTION_TOP=<module>`.

Base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH handoff and `git_head.txt` (`HANDOFF_BASE_MATCH=YES`). Branch `grok-orch/astra-native-v1-00` MATCH ACK.

---

### Hunt 1 — two columns only from raw reports; hashes vs live files — MATCH

Authority = each bag’s raw timing report **Design Timing Summary** with `Design State : Routed`. Not RESULTS.md of those bags. Not 12-R2/R3/R4 pack prose.

Exactly **two** brief columns. 100 MHz sibling is quoted as **gap evidence**, labeled **not a third column**.

| Col | Live file | Design / Date / State (opened this audit) | Live Design Timing Summary | Clock (same rpt) | BRIEF quote |
|-----|-----------|-------------------------------------------|----------------------------|------------------|-------------|
| **A** | `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt` | `arty_a7_astra_rtp_soc_top` / Sun Sep 6 **02:11:52** 2026 / **Routed** | WNS=**5.733** TNS=0.000 fail=0/10150 WHS=**0.029** THS=0.000; *All user specified timing constraints are met.* | intra `clk50u` WNS=**7.150** WHS=0.029; path group `**async_default**` clk50u→clk50u WNS=**5.733**; no `uart_io_vclk` | **+5.733 / 0.000 / +0.029** (summary = async_default; intra +7.150) |
| **B** | `ASTRA-11-A09R7-UART-IMPL-ROUTE-01/timing_route.rpt` | `a7ng_astra_11_a09r7_uart_impl_wrap` / Mon Sep 7 **01:52:48** 2026 / **Routed** | WNS=**0.336** TNS=0.000 fail=0/8940 WHS=**0.104** THS=0.000 fail=0/8938; *All user specified timing constraints are met.* | intra `clk50u` WNS=0.336 WHS=0.104; Inter Clock hold columns **blank** (`uart_io_vclk→clk50u` setup 19.270; `clk50u→uart_io_vclk` setup 7.313) | **+0.336 / 0.000 / +0.104** (intra clk50u; UART I/O hold excepted) |

Dates MATCH T1500Z (wrap-route still 02:11:52) and T0200Z / T0230Z (A09R7 still 01:52:48). **Prior bags not rewritten.**

Do **not** cite +5.733 as A09R7, and do **not** cite +0.336 as the SoC wrap. BRIEF states that split. Honest.

#### Column A — supporting raw reports MATCH

Live `clocks.rpt` Date 02:11:54 Design State Routed: `sys_clk_pin` 10.000 P `{CLK100MHZ}`; `clk50u` 20.000 **P,G,A** `{u_mmcm/CLKOUT0}`; `clkfb` 10.000 P,G,A `{u_mmcm/CLKFBOUT}`. **No** `uart_io_vclk`. Pipe clock **real**. MATCH BRIEF A.2.

Live `io.rpt` Date 02:11:54 Total User IO = **15**:

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

Pins **not swapped**. MATCH BRIEF A.3.

Live `util.rpt` Date 02:11:51 Design State Routed: Slice LUTs **4244**, Slice Registers **3810**, Block RAM Tile **2**, RAMB36E1 only **2**, DSPs **0**, Bonded IOB **15**, ILOGIC **0**, OLOGIC **0**. **No** `IOB Flip Flops` row. MATCH BRIEF A.4.

Live `constraints/arty_a7_100.xdc`: D10 / A9 pin loc only. **No** `set_property IOB TRUE` on UART. **No** `set_input_delay` / `set_output_delay` on UART. **No** `set_false_path -hold` on UART. MATCH BRIEF A.5.

Live wrap SV: `// On-chip AXI BRAM with RTP-R2 BASE 17/34 plant. No MIG. freeze unused (no SGD).` plus `a7ng_axi_bram128 #(.PLANT_R2_BASE(1'b1)`. MATCH BRIEF A.6. DSP=0 MATCH util.

Live `SHA256_BIT.txt` / `BITSTREAM.txt`:

```text
8116fa77dfd38253e04a03563f71e22ed628dccb30b77a8f03a315d022b0171b  arty_a7_astra_rtp_soc_top.bit
STATUS=UNPROGRAMMED
PROGRAM=NO
COM12=UNTOUCHED
JTAG=210319BE776EA UNTOUCHED
```

MATCH BRIEF A.7. Wrap-route `run_impl.tcl` historically contains `write_bitstream -force`. **This bag does not call it.** Bit not adopted.

#### Column B — supporting raw reports MATCH

Live `clocks_route.rpt` Date 01:52:52 Design State Routed: `clk50u` 20.000 **P,G,A** `{u_mmcm/CLKOUT0}`; `uart_io_vclk` 20.000 **V** `{}`. Pipe clock **real**. UART I/O clock **virtual**. MATCH BRIEF B.2.

Live `io.rpt` Date 01:52:52 Total User IO = **15**, A9 INPUT / D10 OUTPUT FIXED, pins **not swapped**. MATCH BRIEF B.3.

Live `util_route.rpt`: Slice LUTs **4945**, Slice Registers **3615**, Block RAM Tile **0**, DSPs **2**, Bonded IOB **15**, IOB Flip Flops **2**, ILOGIC **1** (`IFF_Register=1`), OLOGIC **1** (`OUTFF_Register=1`). MATCH BRIEF B.4. Occupancy is **this wrap**, not additive with column A 4244/3810 BRAM=2. Disclosed.

Live `UART_IOBFF.txt`: RX `ILOGICE2.IFF` `ILOGIC_X0Y171` / TX `OLOGICE2.OUTFF` `OLOGIC_X0Y161` / `UART_IOBFF=YES` / `PROGRAM=NO`. MATCH BRIEF B.5.

Live bag-local XDC (PRE=POST SHA `72004235…286c3e57` MATCH A09R7 PRE/POST):

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
```

MATCH BRIEF B.6.

Live `exceptions_route.rpt` Date 01:52:53 Design State Routed:

```text
Position  From                     Through         To                        Setup           Hold
9         [get_ports uart_txd_in]  *               *                         -               false
10        *                        *               [get_ports uart_rxd_out]  -               false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted). BRIEF B.7 quote is **condensed** (Through column dropped) but Setup/Hold MATCH. HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** labeled **HONEST**. DTS WHS=+0.104 is **intra clk50u**, not UART I/O hold vs `uart_io_vclk`. Do **not** promote WHS=+0.104 as physical IOB hold MET. MATCH T0200Z / T0230Z.

Live wrap SV: instantiates `a7ng_astra_09_r2_cand_ovf u_a09r2`; comments `R7 wrap … KEEP, not this top` and `Not PRODUCTION_TOP`. Live plant SV: `// Bag-local behavioral AXI plant. Not silicon BRAM. Not a7ng_axi_bram128 edit.` MATCH BRIEF B.8.

A09R7 `run_impl.tcl` line 1: `PROGRAM=NO. BIT=NO. write_bitstream forbidden.` ACK `"bitstream": "NOT_BUILT"`. Live A09R7 listing: `ckpt/route.dcp` present; **no** `.bit`. MATCH.

Claimed A SHA `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` MATCH 12-R2 `SHA256.txt` and 12-R4 `SHA256.txt` (re-listed, not first-invented). Claimed B SHA `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` MATCH 12-R4 `SHA256.txt` (first-recorded there; content MATCH T0200Z / this opened rpt).

Hunt 1: **MET.**

---

### Hunt 2 — required gaps listed; FALSE_PATH_HOLD honest vs physical MET — MATCH

BRIEF gaps table (both columns) covers every handoff-required gap:

| Gap | A (live + BRIEF) | B (live + BRIEF) |
|-----|------------------|------------------|
| **unique bit** | **MISSING as unique production bit.** Historical UNPROGRAMMED `.bit` `8116fa77…` exists; STATUS=UNPROGRAMMED; sibling bits `c7442d16…` (SOC-WRAP) and `a5c3f2c4…` (TIMING-FIX) MATCH 12-R2 freeze list. This bag does **not** adopt `8116fa77…`. | **MISSING.** BIT=NOT_BUILT. No `.bit` in A09R7 bag. tcl forbids `write_bitstream`. DCP only. |
| **ACCEPT_BOARD** | **MISSING.** T0230Z: ACCEPT_BOARD missing; BOARD blocked YES. No auditor ACCEPT_BOARD of this timed bit. | **MISSING.** T0200Z / T0230Z ACCEPT_PARTIAL on the **wrap bag / table**, not ACCEPT_BOARD. |
| **LM06** | **MISSING.** RTP-R2 pipe; wrap comment `freeze unused (no SGD)`; DSP=0. Not LM06 language. | **MISSING.** A09-R2 query-learn SGD (DSP=2). Not LM06 language. |
| **fixture plant** | **PRESENT (silicon BRAM).** `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)`; util BRAM tile=2 / RAMB36E1=2. No MIG. Plant is RTP-R2 BASE 17/34, **not** A09-R2 query-learn. | **PRESENT (behavioral, not BRAM).** Bag-local plant — “Not silicon BRAM.” Util BRAM tile=0. |
| **FALSE_PATH_HOLD** | **ABSENT on UART.** Pin loc only; no I/O delay envelope; no `set_false_path -hold` on UART; ILOGIC=0. DTS WHS=+0.029 is intra `clk50u` **without** UART I/O STA. Not an honest hold waiver because no UART hold was checked. Honest labeling. | **PRESENT, HONEST.** exceptions Hold=`false` Setup=`-`. WHS=+0.104 is intra `clk50u`, **not** physical IOB hold MET. U4 WHS=**−4.915** still on disk (live `ASTRA-11-A09R3-UART-IOBFF-01/timing_route.rpt` DTS WNS=0.115 WHS=−4.915; *Timing constraints are not met.*). |
| **100 MHz fail sibling** | **EXISTS, distinct bag.** Live `ASTRA-11-SOC-WRAP/timing.rpt` Date Sat Sep 5 **22:59:22** 2026 Design `arty_a7_astra09_soc_top` Design State Routed: WNS=**−4.765** TNS=**−2392.529** fail=**587**/4034 WHS=0.046; *Timing constraints are not met.*; Clock Summary **only** `sys_clk_pin` 10.000 ns (100.000 MHz) — **no `clk50u`**. Same UART D10/A9 family, **different module**, **no 50 MHz MMCM**. Do **not** collapse A +5.733 @ 50 MHz with this −4.765 @ 100 MHz. | **NOT this wrap.** B is 50 MHz `clk50u`. Sibling still `arty_a7_astra09_soc_top` WNS=−4.765. Do **not** collapse B +0.336 with that −4.765. |

100 MHz sibling SHA `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` MATCH 12-R2 / 12-R4 freeze lists. Date still 22:59:22 (T1500Z). Not rewritten. Not a third brief column.

Fixture plants are **not interchangeable**. BRIEF states that. Honest.

Hunt 2: **MET.**

---

### Hunt 3 — PRODUCTION_TOP UNKNOWN; no winner freeze / recommendation-as-freeze — MET

| Artifact | PRODUCTION_TOP | WINNER / ranking |
|----------|----------------|------------------|
| ACK.json | `"UNKNOWN"`, `winner_frozen: false` | not a module name; “without recommending a winner as frozen” |
| BRIEF.md | UNKNOWN / NOT_FROZEN; columns **not ranked** | explicit: do not treat max WNS / UART / IOB FF / hold-exception WHS≥0 / BRAM / historical bit as freeze; “Not claimed: … Ranking A vs B” |
| RESULTS.md | UNKNOWN; “Not frozen. Not silently chosen.” Column A **is not** that top. Column B **is not** that top. Historical bit **is not** that top. | “Two columns. None chosen.” “Winner not recommended as frozen.” |
| CLOSEOUT.md | UNKNOWN / NOT_FROZEN | “This bag is not that freeze.” “Do not recommend column A or column B as frozen.” |
| metrics.json | `"UNKNOWN"`, `winner_frozen: false` | — |
| SHA256.txt / POST / git_head / file_manifest | comments PRODUCTION_TOP=UNKNOWN | — |
| LOOP_STATE.json (read-only) | `"UNKNOWN"` / `NEEDS_OWNER_NOT_SILENT` | — |

No `PRODUCTION_TOP=arty_a7_astra_rtp_soc_top`, no `PRODUCTION_TOP=a7ng_astra_11_a09r7_uart_impl_wrap`, no other module name written as that identity.

Parent handoff phrase “two strongest existing routed UART candidates” is **selection of which two to brief**, not a freeze. BRIEF does not rank A vs B and does not recommend either as frozen.

Bag title `FREEZE-BRIEF` is the work-order name. Content is a brief, **not** a freeze. Not recommendation-as-freeze.

Hunt 3: **MET.**

---

### Hunt 4 — R7 XSim not mixed into column B as the routed result — MET

Column B top = `a7ng_astra_11_a09r7_uart_impl_wrap`. Authority = `timing_route.rpt` Design State Routed 01:52:48 WNS=+0.336 WHS=+0.104. That wrap instantiates frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2`. Wrap comment: R7 wrap `a7ng_astra_09_r7_uart_query_rew_wrap` is **KEEP, not this top**.

BRIEF B.9 / RESULTS / CLOSEOUT / ACK `preserves`: R7 XSim `ans=4` / `w0=−5` is bag `ASTRA-09-R7-UART-QUERY-REW-01` — a **different** bag — and is **not** column B’s routed result. Handoff required that split. Honored.

Column B table cells do **not** list ans=4 / w0=−5 as WNS/WHS. No invented routed WNS for the XSim bag. T0230Z N1 stays XSim-only.

Hunt 4: **MET.**

---

### Hunt 5 — overclaim BOARD_PASS / ASTRA-13 — NOT FOUND

Every this-bag product: `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `ACCEPT_BOARD` missing/false, `BIT=NOT_BUILT`, `PROGRAM=NO`, `write_bitstream=false`, COM12/JTAG UNTOUCHED.

ACK `does_not_close` lists Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ACCEPT_BOARD, physical_IOB_hold_MET.

RESULTS: “Do **not** call this BOARD_PASS or ASTRA-13.” CLOSEOUT: “Do not open ASTRA-13, LM06, BOARD, DDR, or Master F3 from this bag.”

No `.bit` in this bag. Historical `8116fa77…` remains labeled UNPROGRAMMED; not programmed; not unique production bit. Sibling fail/fix bits `c7442d16…` / `a5c3f2c4…` named as siblings, not adopted.

Implementer self-grade `PASS_NARROW` / CLOSEOUT `PASS_THIS_GATE_ONLY` is bounded to the two-column brief unknown. Not a Master-12/13 close.

Hunt 5: **NOT OVERCLAIM.**

---

### Preserve prior bags / pointer hashes

Grep of `ASTRA-12-R2-TOP-CANDIDATES-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, and `ASTRA-12-R4-R7-UART-CANDIDATES-01` for `ASTRA-12-R5` / `FREEZE-BRIEF`: **no matches**. Those bags were **not rewritten**.

12-R4 `CANDIDATES.md` digest claimed `4d694af0be83100a94c682ff678f94487f19691f1cf953e42c51efe54baea84d` MATCH 12-R4 `SHA256.txt` product line **and** 12-R4 `SHA256_POST.txt`. This bag’s hash of 12-R4 `SHA256.txt` `3cf41834…96101c2a` MATCH 12-R4 POST.

12-R2 `SHA256.txt` digest claimed `b1194a9ef378c886ce57465321eca8758bcccf1ee2b71f3a5b29eb3178b549de` MATCH 12-R4 pointer of that file.

Wrap-route `timing.rpt` still 02:11:52 WNS=5.733. A09R7 `timing_route.rpt` still 01:52:48 WNS=0.336 WHS=0.104. SOC-WRAP `timing.rpt` still 22:59:22 WNS=−4.765. U4 IOBFF `timing_route.rpt` still WHS=−4.915.

A09R7 wrap SV `d1f66a54…08644bde` and XDC `72004235…286c3e57` MATCH A09R7 SHA256_POST. Frozen DUT `15a919f1…8b70ee23` MATCH A09R7 PRE. SoC wrap SV `a1f7a063…0853905fa`, pipe `3d27091d…5cd65cbf`, BRAM `6e254828…242cfc`, XDC `1c12e6f8…b6a9c2` MATCH wrap-route PRE SHA256.txt. Wrap-route `SHA256.txt` file digest `20ee4c16…3b0c649b` MATCH 12-R2. A09R7 `SHA256.txt` file digest `db74ba43…eec44a` MATCH 12-R4.

---

### Hash theatre / this-bag product

This-bag product hashes (first-recorded in `SHA256.txt` / `SHA256_POST.txt`; not re-digested here). POST stamped 2026-09-07T02:33:16+07:00. ACK / BRIEF / RESULTS / CLOSEOUT / metrics / git_head digests MATCH between SHA256.txt and SHA256_POST.txt.

| Object | Digest | Overlap / check |
|--------|--------|-----------------|
| ACK.json | `f4d0ca51…e1ebda` | SHA256.txt = POST |
| BRIEF.md | `736500b0…b3315f` | SHA256.txt = POST |
| RESULTS.md | `c210e664…e614aa` | SHA256.txt = POST |
| CLOSEOUT.md | `4d82ade7…a7d781b` | SHA256.txt = POST |
| A `timing.rpt` | `71664fba…0a4a79ac` | 12-R2 + 12-R4 freeze lists; content MATCH live DTS +5.733 |
| A `io.rpt` | `b4cb6178…02f2236` | 12-R2 SHA256.txt; content MATCH A9/D10 |
| A `util.rpt` | `bcf21d25…604ec8` | 12-R2 SHA256.txt; content MATCH 4244/3810/BRAM=2 |
| A `clocks.rpt` | `14e5da83…fb4456f1` | **first-recorded this bag**; content MATCH 02:11:54 no uart_io_vclk |
| A bit | `8116fa77…b0171b` | 12-R2 SHA256.txt + live SHA256_BIT.txt |
| A BITSTREAM.txt | `fb81a51f…6a58a3` | 12-R2 SHA256.txt; content UNPROGRAMMED |
| A SHA256_BIT.txt | `b44ea67c…fb5799cd` | **first-recorded this bag**; content MATCH 8116fa77… UNPROGRAMMED |
| A wrap-route SHA256.txt | `20ee4c16…3b0c649b` | 12-R2 SHA256.txt |
| B `timing_route.rpt` | `0c45687b…378d2b` | 12-R4 SHA256.txt (first-recorded there); content MATCH live DTS +0.336/+0.104 |
| B io/util/exceptions/clocks/XDC/wrap/UART_IOBFF | same strings as 12-R4 SHA256.txt | content MATCH opened files; XDC/wrap also A09R7 POST |
| B SHA256.txt | `db74ba43…eec44a` | 12-R4 SHA256.txt |
| Frozen A09-R2 DUT | `15a919f1…8b70ee23` | A09R7 PRE + 12-R4 |
| 100 MHz sibling `timing.rpt` | `870c0f12…d9dad92c` | 12-R2 + 12-R4; content MATCH −4.765 |
| 12-R4 CANDIDATES.md | `4d694af0…ea84d` | 12-R4 SHA256 + POST |
| 12-R4 SHA256.txt | `3cf41834…101c2a` | 12-R4 POST |
| 12-R2 SHA256.txt | `b1194a9e…8b549de` | 12-R4 pointer |
| T0230Z REPORT | `cfc00174…4f5804` | **first-recorded this bag**; file opened this audit |
| Handoff | `2504ea34f400b7a8d2575d199111a7f5264d54aed7b03a61b9fdfa00b5b0b93e` | **first-recorded this bag**; file opened this audit |

Limitation: this-bag markdown hashes, wrap-route `clocks.rpt` / `SHA256_BIT.txt`, T0230Z REPORT, and handoff cannot be re-digested without a shell. Content of those files MATCHES quotes / prior auditors. Invented overlapping DUT/XDC/12-R2/12-R4/A09R7 pointer digests: **not found**.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md of wrap-route / A09R7 only | **No.** BRIEF cites raw DTS; live MATCH. |
| Invent a third candidate column | **No.** 100 MHz sibling is gap evidence, labeled not a third column. |
| Cite +5.733 as A09R7 / +0.336 as SoC wrap | **No.** Explicit split; dates/designs distinct. |
| Collapse A +5.733 @ 50 MHz with 100 MHz −4.765 | **No.** Distinct module, no clk50u, constraints not met. |
| Mix R7 XSim ans=4/w0=−5 as column B routed WNS | **No.** Different bag; B is named impl-route wrap. |
| Promote B WHS=+0.104 as physical IOB hold MET / erase U4 −4.915 | **No.** Labeled HONEST; U4 still −4.915 live. |
| FALSE_PATH_HOLD unlabeled / hide-WHS cheat | **No.** A: ABSENT (no UART hold checked). B: Hold=false Setup=`-`. |
| Rank / silent-freeze / recommend a winner as frozen | **No.** Not ranked. `PRODUCTION_TOP=UNKNOWN`. CLOSEOUT: do not recommend A or B as frozen. |
| Adopt `8116fa77…` as unique production bit | **No.** UNPROGRAMMED; not adopted. |
| BOARD_PASS / ACCEPT_BOARD / ASTRA-13 | **Not claimed.** BLOCKED / NOT_CLAIMED. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. |
| Add occupancy across columns | **No.** Explicit do-not-add. |
| Hash theatre | **Not found** for overlapping DUT/XDC/wrap/12-R2/12-R4/A09R7 pointer digests. First-recorded clocks.rpt A / SHA256_BIT / T0230Z / this-bag markdown are content-verified only. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps (wrap-route 02:11:52; A09R7 01:52:48; SOC-WRAP 22:59:22; U4 −4.915). |
| Rewrite 12-R2 / 12-R3 / 12-R4 / A09R7 / wrap-route / R7 XSim | **Not found.** |
| TB-load / one-hot transfer | N/A for a brief-only bag. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / recommendation-as-freeze. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the two-column decision-brief unknown.

Evidence class: column A/B WNS/WHS/IOB = **routed STA EVIDENCE** (not board). Historical bit `8116fa77…` = **UNPROGRAMMED file on disk**, not silicon. R7 XSim tokens = **XSim EVIDENCE** of a **different** bag (not mixed into B). `PRODUCTION_TOP=UNKNOWN` = **CONFIRMED** in this bag’s products. Board plugged = **OBSERVED in LOOP_STATE as USER_SAYS_PLUGGED_UNPROGRAMMED**, not authority to program.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written. No RESULTS/raw contradiction on A WNS=+5.733 (async_default) / intra +7.150 / UART D10/A9 / BRAM=2 / IOB FF NO, or B WNS=+0.336 / WHS=+0.104 / UART IOB YES / IOB FF YES / FALSE_PATH_HOLD HONEST, or 100 MHz sibling WNS=−4.765.

Residuals (not this-bag FAIL):

1. BRIEF exceptions quote is condensed (Through column dropped). Live Setup=`-` Hold=`false` MATCH. Same pattern as T0230Z condensed WNS one-liners; this brief’s DTS numeric rows are actually **fuller** than 12-R4 CANDIDATES one-liners.
2. 100 MHz sibling DTS quote truncates THS/WPWS columns; WNS=−4.765 TNS=−2392.529 fail=587 WHS=0.046 MATCH live.
3. First-recorded SHA of wrap-route `clocks.rpt` / `SHA256_BIT.txt` / T0230Z REPORT / handoff / this-bag markdown cannot be re-digested without a shell. Content MATCHES opened files.
4. ACK `observed_session_id=UNKNOWN`. Does not affect the brief unknown.
5. Column A `check_timing` HIGH `no_input_delay` (2) / `no_output_delay` (5) is the unconstrained UART/LED envelope. BRIEF labels FALSE_PATH_HOLD **ABSENT** and “no UART I/O STA”; does not separately restated the HIGH check_timing rows. Not a WNS miss.
6. Column B LED `no_output_delay` HIGH (T0200Z residual) is not closed by this brief. Handoff did not require that gap.
7. Bag title `FREEZE-BRIEF` can be misread as a freeze. Body repeatedly says it is not. Parent named the work order.
8. Column B DSP=2 is frozen SGD, not a7-fpga-gate eam03e DSP=0. Occupancy LUT=4945/FF=3615 is **this wrap**, not additive with wrap-route 4244/3810 BRAM=2. Disclosed.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a two-column decision brief quoting raw Design Timing Summary / IOB / util / XDC / hashes for (A) wrap-route SoC `arty_a7_astra_rtp_soc_top` WNS=+5.733 UART D10/A9 BRAM=2 IOB FF NO and (B) A09R7 UART impl-route `a7ng_astra_11_a09r7_uart_impl_wrap` WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST, with required gaps per column, **without** BOARD_PASS, **without** silently naming a production top, **without** recommending a winner as frozen, **without** mixing R7 XSim into column B, **without** rewriting 12-R2/R3/R4 / A09R7 / wrap-route / R7 XSim.

**Master ASTRA-12** (preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison brief of already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE` are different bags and are **not** this close (ACK `does_not_close`). 12-R2 remains the board-level pointer table; 12-R3/R4 extended the candidate table; this R5 bag **briefs two columns** from that landscape. None of those is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **both briefed columns** (A DTS +5.733; B DTS +0.336); that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen. B DTS WHS≥0 is intra-clk50u with UART I/O hold excepted, not physical IOB hold MET. A DTS WHS≥0 is intra-clk50u with **no** UART I/O STA.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**. Physical IOB hold MET remains **OPEN** (U4 −4.915 still on disk). UART STA ladder remains **separate envelopes**, not one closed ladder.

T0230Z residual 8 (freeze a production top **or keep UNKNOWN**; parent does not pick) is **honored as UNKNOWN**, not closed as a freeze.

T0200Z residual (do not freeze `PRODUCTION_TOP`; do not ASTRA-13; do not promote WNS=+0.336 / WHS=+0.104 as BOARD_PASS or as U4 −4.915 MET) is **honored**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R5-FREEZE-BRIEF-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + BRIEF.md two columns from raw reports; A wrap-route WNS=+5.733 (async_default; intra clk50u +7.150) UART D10/A9 BRAM=2 IOB FF NO; B A09R7 routed WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST; required gaps listed (unique bit MISSING both; ACCEPT_BOARD MISSING; LM06 MISSING; fixture plants not interchangeable; FALSE_PATH_HOLD A ABSENT / B HONEST not physical MET; 100 MHz sibling WNS=−4.765 still distinct); overlapping hashes MATCH prior freeze lists; 12-R2/R3/R4 / A09R7 / wrap-route / R7 XSim **not rewritten**; `PRODUCTION_TOP=UNKNOWN`; winner not frozen / not recommended as frozen; R7 XSim not mixed into B; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze; physical IOB hold MET; UART STA as one envelope).  
Not FAIL (required artifacts present; A/B WNS/WHS/IOB/hold-policy MATCH live routed reports; two columns only; gaps listed; overlapping hashes MATCH prior freeze lists; prior bags not rewritten; no program; no winner; no recommendation-as-freeze).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / R7-XSim-as-B / winner-as-frozen not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared two-column brief-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this brief to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, physical IOB hold MET, or a silent `PRODUCTION_TOP=<module>` (including `arty_a7_astra_rtp_soc_top` or `a7ng_astra_11_a09r7_uart_impl_wrap`). `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**. Do not treat “two strongest” or max WNS as that freeze.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on A or B is **not** that gate. B WHS=+0.104 is **not** U4 −4.915 MET. UNPROGRAMMED historical bit `8116fa77…` is **not** the unique production bit. Do not program it.
3. Keep U4 WHS=−4.915 on disk. Do **not** collapse B FALSE_PATH_HOLD DTS WHS≥0 into physical IOB hold MET. Keep UART STA envelopes **separate**. Column A has **no** UART I/O STA; do not treat A WHS=+0.029 as UART hold MET. Do **not** promote R7 XSim ans=4/w0=−5 as column B.
4. Do **not** rewrite `ASTRA-12-R2-TOP-CANDIDATES-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-12-R4-R7-UART-CANDIDATES-01`, `ASTRA-09-R7-UART-QUERY-REW-01`, `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`, or `ASTRA-SOC-RTP-WRAP-ROUTE`. Do not rerun those impl/xsim scripts. Wrap-route `timing.rpt` must stay 02:11:52 WNS=5.733. A09R7 `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104. SOC-WRAP `timing.rpt` must stay 22:59:22 WNS=−4.765.
5. Do **not** collapse `arty_a7_astra09_soc_top` (100 MHz, WNS=−4.765) with column A (50 MHz, WNS=+5.733) or column B (50 MHz, WNS=+0.336). Do not add B LUT=4945 to wrap-route 4244. Fixture plants (silicon BRAM vs behavioral AXI) are not interchangeable.
6. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout **on that top**, unique bit after WNS≥0 **on that top**, then ASTRA-13 + owner + ACCEPT_BOARD. Not this brief’s job.
7. Optional wording: exceptions Through column; restated column A check_timing HIGH unconstrained I/O. Numbers already MATCH.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **two-column freeze brief**: hashes + raw quotes of (A) wrap-route SoC WNS=+5.733 UART D10/A9 BRAM=2 IOB FF NO and (B) A09R7 UART impl-route WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST, required gaps listed, R7 XSim not mixed into B, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN / not recommended as frozen, 12-R2/R3/R4 / A09R7 / wrap-route / R7 XSim **not rewritten**, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen. Physical IOB hold is **not** MET. Neither column is the production top. Historical UNPROGRAMMED bit is **not** the unique production bit.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
Physical IOB hold MET: **OPEN** (U4 WHS=−4.915 untouched).  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0300Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R5-FREEZE-BRIEF-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
