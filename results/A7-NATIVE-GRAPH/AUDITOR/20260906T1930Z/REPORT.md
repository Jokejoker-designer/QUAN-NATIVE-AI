# ASTRA auditor REPORT — 20260906T1930Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R3_UART_CANDIDATES_INDEPENDENT_AUDIT; astra11_iobff_hold=AUDITOR_PASS_NARROW_FALSE_PATH_HOLD_HONEST_WHS_P0131; astra12_r3=IMPLEMENTER_CLAIM_PASS_NARROW_9_ROWS_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R3-UART-WRAP-CANDIDATES-01 + prior auditor 20260906T1900Z (HOLD bag ACCEPT_PARTIAL | REJECT_PROMOTION; PASS_NARROW; false-path-hold HONEST; WNS=+0.115 WHS=+0.131 IOB FF YES; UART I/O hold excepted not physically MET; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T1500Z (12-R2 table PASS_NARROW ACCEPT_PARTIAL) + T1830 / T1800 / T1730 / T1700
EVIDENCE   = bag ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt + RAW cited prior-bag files (timing_route.rpt, timing.rpt, xsim.log, io.rpt, util_route.rpt, exceptions_route.rpt, bag-local XDC, wrap SV) — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (would wipe `xsim.log` / routed reports). Did not program the plugged board.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs CANDIDATES quotes, (2) overlapping digests vs prior-bag freeze lists / 12-R2 `SHA256.txt` + `SHA256_POST.txt` / UART-bag PRE SHA256.txt / auditor T1700 / T1500 / T1900, (3) session stamps on raw reports vs T1900Z / T1500Z. Timing-report SHA strings in this bag’s `SHA256.txt` are **first-recorded here** and **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R3-UART-WRAP-CANDIDATES-01/`

Table-only. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `CANDIDATES.md` + SHA-256 of cited raw reports/XDC/io + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R3-UART-WRAP-CANDIDATES-01 only** — one unknown: extend the candidate table with the UART wraps (XSim + routed), quoting WNS/WHS from **raw** reports, hashes, IOB, hold-policy, UART D10/A9 yes/no per row, while `PRODUCTION_TOP` remains **UNKNOWN**. Parent does **not** pick a top. This bag must not write `PRODUCTION_TOP=<module>`. Do not edit `ASTRA-12-R2-TOP-CANDIDATES-01` or any ASTRA-11 UART bags. Do not rerun impl. Do not generate a `.bit`.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze. **Not** physical IOB hold MET. **Not** collapsing HOLD into IOBFF.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R3-UART-WRAP-CANDIDATES-01.md`: ACK first; `CANDIDATES.md` rows quoting WNS/WHS from raw reports, do not mix bags:
   - ASTRA-09-R3-UART-XSIM-01 (XSim only, no routed WNS)
   - ASTRA-11-A09R3-UART-IMPL-ROUTE-01 WNS=+0.305
   - ASTRA-11-A09R3-UART-IODELAY-01 WNS=+0.681 delays 2.000/0.500
   - ASTRA-11-A09R3-UART-IOBFF-01 WNS=+0.115 WHS=−4.915 IOB FF YES
   - ASTRA-11-A09R3-UART-IOBFF-HOLD-01 WNS=+0.115 WHS=+0.131 FALSE_PATH_HOLD
   - Keep the four 12-R2 routed tops as a pointer, do not rewrite those files
   - `PRODUCTION_TOP=UNKNOWN` in ACK/RESULTS/CLOSEOUT; UART D10/A9 present yes/no per row; PROGRAM=NO; do not close ASTRA-13, BOARD_PASS, LM06, Master F3.
2. **Master ASTRA-12** (isolated DAG `ASTRA-12 FINAL-SOURCE-FREEZE` / T1500Z: *preprogram closure, unique bit, current board token/identity/UART plan*). This table must not steal that close.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260906T1900Z`: HOLD bag PASS_NARROW; false-path-hold HONEST; DTS WHS=+0.131 envelope-tautological (UART I/O hold excepted, not physically MET); prior IOBFF WHS=−4.915 must remain on disk; `PRODUCTION_TOP=UNKNOWN`; BOARD blocked YES.
5. Auditor `20260906T1500Z`: 12-R2 table PASS_NARROW; four pointer WNS +1.041 / +5.733 / −4.765 / +7.179 MATCH live; `PRODUCTION_TOP=UNKNOWN`; 12-R2 files must stay unrewritten.

Hunt (this dispatch):

1. Five UART rows + four 12-R2 pointers = 9? WNS/WHS match live files (+0.305 / +0.681 / +0.115 WHS−4.915 / +0.115 WHS+0.131 / XSim no WNS)?
2. HOLD vs IOBFF not collapsed? FALSE_PATH_HOLD labeled?
3. `PRODUCTION_TOP` UNKNOWN? No winner freeze?
4. Overclaim BOARD_PASS / ASTRA-13?
5. 12-R2 files not rewritten?

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, physical IOB hold MET, UART STA ladder as one envelope, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` lists it first among this-bag files (`d5c05f47…65d334c0`). `write_scope` = new bag only: ACK + CANDIDATES.md + SHA256 of cited raw reports/XDC/io + RESULTS/CLOSEOUT; no RTL; no bitstream; no freeze of a winner; no prior-bag rewrite; no impl rerun.

`PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`, `winner_frozen: false`.

`does_not_close` includes production_top_identity, Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ASTRA-11_FULLCHIP_COFIT, Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, ACCEPT_BOARD, physical_IOB_hold_MET, UART_STA_ladder_as_one_envelope.

Bag listing: ACK.json, CANDIDATES.md, RESULTS.md, CLOSEOUT.md, metrics.json, SHA256.txt, SHA256_POST.txt. **No** `.bit` / `.bin` / `.mcs`. No `ckpt/`. No run scripts. No RTL.

RESULTS.md / CLOSEOUT.md / metrics.json: `PRODUCTION_TOP=UNKNOWN`, `WINNER=NOT_FROZEN`, `UART_WRAP_ROWS=5`, `R2_POINTER_ROWS=4`, `CANDIDATE_COUNT=9`, `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

CANDIDATES.md: **Rows are not ranked.** Do not treat max WNS, IOB FF packed, or hold-exception WHS≥0 as a freeze.

---

### Hunt 1 — nine rows; WNS/WHS match live files — MATCH

Authority = each bag’s raw `timing_route.rpt` / `timing.rpt` **Design Timing Summary** with `Design State : Routed`, or `xsim.log` for the XSim-only row. Not RESULTS.md.

| # | Live file | Design / Date / State (opened this audit) | Live Design Timing Summary / XSim | Bag quote | Match |
|---|-----------|-------------------------------------------|-----------------------------------|-----------|-------|
| U1 | `ASTRA-09-R3-UART-XSIM-01/xsim.log` | session Sun Sep 6 **21:45:37–** (PID **19596**); **no** `timing_route.rpt` in that bag | `FRAME OVF_UART a2 …`; `FRAME SMOKE_UART a2 …`; `ASTRA_09_R3_UART_XSIM_PASS`; `$finish` **9631755 ns**; TB line `PRODUCTION_TOP=UNKNOWN` | **N/A** (XSim only; MAGIC A2 PASS) | **YES** |
| U2 | `ASTRA-11-A09R3-UART-IMPL-ROUTE-01/timing_route.rpt` | `a7ng_astra_11_a09r3_uart_impl_wrap` / Sun Sep 6 **22:12:21** 2026 / **Routed** | WNS=**0.305** TNS=0.000 fail=0/8599 WHS=**0.024** THS=0.000; *All user specified timing constraints are met.* Intra `clk50u` WNS=0.305 WHS=0.024. Inter Clock Table **empty**. | **+0.305** TNS=0 WHS=**+0.024** | **YES** |
| U3 | `ASTRA-11-A09R3-UART-IODELAY-01/timing_route.rpt` | `a7ng_astra_11_a09r3_uart_iodelay_wrap` / Sun Sep 6 **22:39:44** 2026 / **Routed** | WNS=**0.681** TNS=0.000 fail=0/8601 WHS=**0.100** THS=0.000; constraints met. Intra `clk50u` 0.681/0.100. Inter `uart_io_vclk`→`clk50u` WNS=15.179 WHS=1.151; `clk50u`→`uart_io_vclk` WNS=4.423 WHS=4.517. | **+0.681** TNS=0 WHS=**+0.100**; delays **max 2.000 / min 0.500** | **YES** |
| U4 | `ASTRA-11-A09R3-UART-IOBFF-01/timing_route.rpt` | `a7ng_astra_11_a09r3_uart_iobff_wrap` / Sun Sep 6 **23:06:09** 2026 / **Routed** | WNS=**0.115** TNS=0.000 fail=0/8601 WHS=**−4.915** THS=−4.915 THS failing=**1**; *Timing constraints are not met.* Intra `clk50u` WNS=0.115 WHS=**0.131** (intra hold MET). Inter `uart_io_vclk`→`clk50u` WNS=19.270 WHS=**−4.915**. | **+0.115** WHS=**−4.915** (constraints not met); IOB FF YES | **YES** |
| U5 | `ASTRA-11-A09R3-UART-IOBFF-HOLD-01/timing_route.rpt` | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` / Sun Sep 6 **23:33:11** 2026 / **Routed** | WNS=**0.115** TNS=0.000 fail=0/8601 WHS=**0.131** THS=0.000; *All user specified timing constraints are met.* Intra `clk50u` 0.115/0.131. Inter `uart_io_vclk`→`clk50u` WNS=19.270 **hold BLANK**; `clk50u`→`uart_io_vclk` WNS=7.313 **hold BLANK**. | **+0.115** WHS=**+0.131** (intra clk50u; UART I/O hold excepted) | **YES** |
| P1 | `ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt` | `a7ng_astra_11_a09_impl_wrap` / Sun Sep 6 **19:48:09** 2026 / **Routed** | WNS=**1.041** TNS=0.000 WHS=**0.160**; constraints met. Intra `clk50u` 1.041/0.160. | **+1.041** TNS=0 WHS=+0.160 | **YES** |
| P2 | `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt` | `arty_a7_astra_rtp_soc_top` / Sun Sep 6 **02:11:52** 2026 / **Routed** | WNS=**5.733** TNS=0.000 WHS=**0.029**; constraints met. Intra `clk50u` WNS=**7.150** WHS=0.029 (summary WNS is async_default, as T1500Z). | **+5.733** TNS=0 WHS=+0.029 | **YES** |
| P3 | `ASTRA-11-SOC-WRAP/timing.rpt` | `arty_a7_astra09_soc_top` / Sat Sep 5 **22:59:22** 2026 / **Routed** | WNS=**−4.765** TNS=**−2392.529** fail=**587**/4034 WHS=0.046; *Timing constraints are not met.* Clock Summary **only** `sys_clk_pin` 10.000 ns — **no `clk50u`**. | **−4.765** TNS=−2392.529 | **YES** |
| P4 | `ASTRA-11-TIMING-FIX/timing.rpt` | `arty_a7_astra09_soc_top` / Sun Sep 6 **01:09:37** 2026 / **Routed** | WNS=**7.179** TNS=0.000 WHS=**0.083**; constraints met. Intra `clk50u` 7.179/0.083. | **+7.179** TNS=0 WHS=+0.083 | **YES** |

**Five UART-wrap rows + four 12-R2 pointer rows = 9.** Count MATCH. Do not mix bags: +0.305 is IMPL-ROUTE; +0.681 is IODELAY; +0.115/−4.915 is IOBFF; +0.115/+0.131 is IOBFF-HOLD; leftover A09 +1.041, wrap-route +5.733, SOC-WRAP −4.765, TIMING-FIX +7.179 stay on their own reports. CANDIDATES.md states that split. Honest.

XSim row has **no** routed WNS. Bag listing of `ASTRA-09-R3-UART-XSIM-01/` has `xsim.log` / wrap SV / TB / SHA lists — **no** `timing_route.rpt`. Do not invent a WNS. MATCH.

Dates match T1900Z / T1500Z / T1700Z (XSim still 21:45:37 PID 19596; UART impl still 22:12:21; IODELAY still 22:39:44; IOBFF still 23:06:09 WHS=−4.915; HOLD still 23:33:11 WHS=+0.131; A09 wrap still 19:48:09; wrap-route still 02:11:52; SOC-WRAP still 22:59:22; TIMING-FIX still 01:09:37). **Prior bags not rewritten.**

U2 `check_timing` live: `There is 1 input port with no input delay specified. (HIGH)` and `There are 5 ports with no output delay specified. (HIGH)` — MATCH CANDIDATES condensed line. UART I/O delay **not applied** on U2. WNS=+0.305 is **not** I/O-constrained UART STA. Disclosed.

U5 `check_timing` live: `partial_input_delay` HIGH (1); `partial_output_delay` HIGH (1) — MATCH (min NOT_APPLIED). `no_output_delay` still 4 HIGH (LEDs) — residual, not this-table FAIL.

Occupancy (raw `util_route.rpt`, **not** identity) MATCH:

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | IOB FF | ILOGIC | OLOGIC |
|---|----:|---:|----------:|----:|-----------:|-------:|-------:|-------:|
| U1 | N/A | N/A | N/A | N/A | N/A | N/A | N/A | N/A |
| U2 | 4804 | 3500 | 0 | 2 | 15 | (no IOB-FF line) | 0 | 0 |
| U3 | 4803 | 3500 | 0 | 2 | 15 | (no IOB-FF line) | 0 | 0 |
| U4 | 4802 | 3500 | 0 | 2 | 15 | **2** | **1** | **1** |
| U5 | 4802 | 3500 | 0 | 2 | 15 | **2** | **1** | **1** |

Do not add LUT/FF across rows. DSP=2 is the frozen F2R2 SGD, disclosed. Not a7-fpga-gate eam03e DSP=0.

UART D10/A9 (raw `io.rpt` Total User IO = **15** on U2–U5):

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

Bag-local XDC on U2–U5 (opened): `PACKAGE_PIN D10` / `PACKAGE_PIN A9`. U1 wrap SV ports `uart_txd_in` / `uart_rxd_out`; **no XDC** / **no PACKAGE_PIN**. P1 `io.rpt` A9/D10 **unbonded** (UART NO). P2–P4 A9/D10 bonded UART YES. MATCH CANDIDATES yes/no column.

Every UART wrap SV instantiates `a7ng_astra_09_r2_cand_ovf u_a09r2` (opened U1/U2/U3/U4/U5). Leftover `a7ng_astra_09_integ_path` is **not** this DUT (that is P1).

---

### Hunt 2 — HOLD vs IOBFF not collapsed; FALSE_PATH_HOLD labeled — MET

U4 and U5 are **separate rows**, **separate named wraps**, **separate routed reports**, **separate dates**:

| | U4 IOBFF | U5 IOBFF-HOLD |
|--|----------|----------------|
| Design | `a7ng_astra_11_a09r3_uart_iobff_wrap` | `a7ng_astra_11_a09r3_uart_iobff_hold_wrap` |
| Date | 23:06:09 | 23:33:11 |
| DTS WHS | **−4.915** (1 fail) | **+0.131** |
| Intra clk50u WHS | +0.131 MET | +0.131 MET |
| Inter hold `uart_io_vclk`→`clk50u` | **−4.915** | **BLANK** |
| XDC min | **−min 0.500** still present (`clk50_uart_iobff.xdc`) | **no −min** (`clk50_uart_iobff_hold.xdc`) |
| Hold policy | none (physical min-delay check) | **`FALSE_PATH_HOLD_ASYNC_UART`** labeled |
| IOB FF | YES (2) | YES (2) |
| Bag on disk | **not overwritten** | additive STA envelope |

U5 XDC (opened):

```tcl
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

Raw `exceptions_route.rpt` Design State=Routed **23:33:16**, Design `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`:

```text
Position  From                     To                   Setup  Hold
7         [get_ports uart_txd_in]  *                    -      false
8         *                        [get_ports uart_rxd_out]  -      false
9–14      uart_io_vclk ↔ clk50u                         -      false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted). MATCH CANDIDATES. T1900Z already classified this as **HONEST** async UART exception, DTS WHS envelope-tautological. This table **labels** it `FALSE_PATH_HOLD` / `FALSE_PATH_HOLD_ASYNC_UART` and **does not** sell U5 WHS=+0.131 as U4 −4.915 now MET.

CANDIDATES “Not claimed”: *Physical IOB hold MET (U5 excepts the U4 −4.915 path). … Promoting U5 WHS=+0.131 to erase U4 WHS=−4.915.* RESULTS.md: *U4 −4.915 remains the physical hold evidence under min 0.500.* CLOSEOUT: *Do not promote U5 WHS=+0.131 as physical IOB hold MET. Keep U4 WHS=−4.915 on disk.*

Hunt 2: **MET. Not collapsed. FALSE_PATH_HOLD labeled.**

---

### Hunt 3 — PRODUCTION_TOP UNKNOWN; no winner freeze — MET

| File | PRODUCTION_TOP | WINNER |
|------|----------------|--------|
| ACK.json | `"PRODUCTION_TOP": "UNKNOWN"`, `"winner_frozen": false` | — |
| CANDIDATES.md | `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN` / *Rows are **not ranked*** | not frozen |
| RESULTS.md | `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN` | *U5 WNS=+0.115 WHS=+0.131 IOB FF YES is **not** that top. Parent does not pick. This bag does not pick.* |
| CLOSEOUT.md | `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN` | *This bag is not that freeze.* |
| metrics.json | `"production_top": "UNKNOWN"`, `"winner_frozen": false` | — |

No `PRODUCTION_TOP=<module>` anywhere in this bag. Hunt 3: **MET.**

---

### Hunt 4 — BOARD_PASS / ASTRA-13 overclaim — NOT FOUND

ACK/CANDIDATES/RESULTS/CLOSEOUT/metrics: `BOARD_PASS=NOT_CLAIMED` / `ASTRA-13=BLOCKED` / `write_bitstream=not called` / `BIT=NOT_BUILT` / `PROGRAM=NO` / `ACCEPT_BOARD` missing or false. LM06 listed OPEN. No ASTRA-13 bag opened. LOOP_STATE `astra13=BLOCKED`, `program=false`, `board_pass=false`.

Board plugged ≠ authority. Hunt 4: **NOT FOUND.**

---

### Hunt 5 — 12-R2 files not rewritten — MET

`ASTRA-12-R2-TOP-CANDIDATES-01/` listing unchanged (ACK.json, CANDIDATES.md, CLOSEOUT.md, metrics.json, RESULTS.md, SHA256.txt, SHA256_POST.txt). No extra files. No missing files.

Live `CANDIDATES.md` still `PRODUCTION_TOP=UNKNOWN`, four-row table WNS **+1.041 / +5.733 / −4.765 / +7.179**, UART absent on P1 / D10/A9 on P2–P4, P3 vs P4 same module name not collapsed. Content MATCH T1500Z quotes.

Digest overlap (strings compared, not re-hashed this process):

| Object | Digest in 12-R2 `SHA256.txt` / `SHA256_POST.txt` (tabled 2026-09-06T20:25:48+07:00) | Same digest in 12-R3 `SHA256.txt` |
|--------|-------------------------------------------------------------------------------------|-----------------------------------|
| 12-R2 `CANDIDATES.md` | `ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178` | **YES** |
| 12-R2 `SHA256.txt` | `b1194a9ef378c886ce57465321eca8758bcccf1ee2b71f3a5b29eb3178b549de` (POST) | **YES** |
| P1 `timing_route.rpt` | `2a72f98a149a953f1ef0d386d679fbc68d60b92861a66a1ece1b01941ed48f72` | **YES** |
| P2 `timing.rpt` | `71664fba4f5ec2d22d2d2a5d1223ac072b714330317bd8e2fb6c8a2e0a4a79ac` | **YES** |
| P3 `timing.rpt` | `870c0f1237944841ba98ce96e76b9c55d2ded4ecef786b66242cfc92d9dad92c` | **YES** |
| P4 `timing.rpt` | `32232b9c41c548b5e476eeb1987f442c026998527b34095a0b4152553ee275c5` | **YES** |

Pointer bit prefixes MATCH 12-R2 freeze list: P2 `8116fa77…`, P3 `c7442d16…`, P4 `a5c3f2c4…` (UNPROGRAMMED historical bits in **other** bags; not this bag; not ACCEPT_BOARD).

UART-bag freeze-list overlap (PRE SHA256.txt, files not rewritten): DUT `a7ng_astra_09_r2_cand_ovf.sv` `15a919f1…8b70ee23` MATCH U1–U5 PRE lists and 12-R3. Wrap SV / XDC digests in 12-R3 MATCH those bags’ PRE SHA256.txt (`20cdeb8e…` U1 wrap, `1c3a95f4…`/`506a3e12…` U2, `34353bb7…`/`7023fd8a…` U3, `4f97db83…`/`dad1dbf2…` U4, `76c4cf1d…`/`046a3cb2…`/`f17d1004…` U5 wrap/XDC/PREREG). T1700Z content-verified `xsim.log` SHA `e9b7f433…f0110040` MATCH 12-R3.

If 12-R2 `SHA256.txt` had been rewritten, POST digest `b1194a9e…` would not still be the string this bag copies. Hunt 5: **MET.**

---

### Hash theatre / this-bag product

This-bag product hashes (first-recorded in `SHA256.txt` / `SHA256_POST.txt`; not re-digested here): ACK `d5c05f47…`, CANDIDATES `713ecb71…`, RESULTS `98969b5b…`, CLOSEOUT `b75908f1…`, metrics `1771f820…`, SHA256.txt itself `68b3f8fd…` (POST only). ACK.json digest is the same in SHA256.txt and SHA256_POST.txt.

Limitation: this-bag markdown hashes and UART `timing_route.rpt` SHA strings are **content-verified** against opened files / prior auditor quotes, not independently re-hashed. Invented overlapping DUT/XDC/12-R2-pointer digests: **not found**.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md only | **No.** CANDIDATES cites raw Design Timing Summary / xsim.log; live MATCH nine files. |
| Five UART + four pointer ≠ 9 / invented WNS | **No.** 5+4=9. +0.305 / +0.681 / +0.115/−4.915 / +0.115/+0.131 / XSim N/A / +1.041 / +5.733 / −4.765 / +7.179 MATCH live. |
| Mix bags (recycle wrap-route +5.733 as UART wrap, etc.) | **No.** Explicit split; dates/design names differ. |
| Invent routed WNS for XSim row | **No.** N/A; no `timing_route.rpt` in that bag. |
| Collapse HOLD into IOBFF / erase −4.915 | **No.** Two rows; U4 still −4.915 23:06:09; U5 labeled FALSE_PATH_HOLD; Inter hold blank vs −4.915. |
| U5 WHS=+0.131 sold as physical IOB hold MET | **Not claimed.** Envelope-tautology **disclosed** (echoes T1900Z HONEST / tautological). |
| FALSE_PATH_HOLD unlabeled / hide-WHS cheat of min 0.500 | **No.** Labeled. U5 XDC has no `-min`. U4 still has `-min 0.500`. |
| Rank / silent-freeze a winner (max WNS, IOB FF, hold-exception WHS≥0) | **No.** Not ranked. `PRODUCTION_TOP=UNKNOWN`. |
| BOARD_PASS / ACCEPT_BOARD / ASTRA-13 | **Not claimed.** BLOCKED / NOT_CLAIMED. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. Historical P2–P4 bits labeled UNPROGRAMMED, not adopted. |
| LM06 language | **No.** Listed OPEN. |
| Master F3 10pp closed | **No.** Listed OPEN. |
| UART STA ladder as one envelope | **Not claimed.** `does_not_close` includes `UART_STA_ladder_as_one_envelope`. |
| Hash theatre | **Not found** for overlapping DUT/XDC/wrap/12-R2-pointer digests. First-recorded timing-report SHA strings are content-verified only. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps. |
| TB-load / one-hot transfer | N/A for a table-only bag. This bag did not reopen those DUTs. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the UART-wrap candidate-table unknown.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written. No RESULTS/raw contradiction on the nine quoted WNS/WHS (or XSim N/A).

Residuals (not this-bag FAIL):

1. CANDIDATES.md WNS “quotes” are condensed one-liners (`WNS(ns)=0.305 TNS=0.000 …`), not the verbatim Design Timing Summary numeric row. Live numbers MATCH. Same P2 as T1500Z.
2. Table B P3 omits WHS=+0.046 (12-R2 table had it). Live WHS=0.046. TNS=−2392.529 still quoted. Not a WNS miss; not a collapse with P4.
3. First-recorded SHA of UART `timing_route.rpt` / `io.rpt` / `util_route.rpt` / this-bag markdown / T1900Z REPORT cannot be re-digested without a shell. Content of those reports MATCHES quotes / T1900Z / T1500Z / T1700Z.
4. ACK `observed_session_id=UNKNOWN`. Does not affect the table unknown.
5. U2 `no_output_delay` 5 HIGH and U5 LED `no_output_delay` 4 HIGH remain pinout residuals, not closed by this table.
6. DSP=2 on UART wraps is frozen SGD, not a7-fpga-gate eam03e DSP=0. Disclosed. Not summed across rows.
7. 12-R3 Table B does not repeat 12-R2 occupancy LUT/FF. Pointer is WNS + UART yes/no + bit status, as the handoff asked. Occupancy remains in 12-R2 `CANDIDATES.md` (not rewritten).

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a nine-row candidate table exists (five UART wraps + four 12-R2 pointers), with hashes and raw quotes of WNS/WHS / XSim N/A, UART D10/A9 yes/no, IOB FF, hold-policy, **without** BOARD_PASS, **without** silently naming a production top, **without** freezing a winner, **without** rewriting 12-R2 or UART STA bags, **without** collapsing HOLD into IOBFF.

**Master ASTRA-12** (preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison table of already-simmed / already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` is a different bag and is also **not** this close (ACK `does_not_close`). 12-R2 remains the board-level pointer table; this R3 bag **extends** it with UART wraps. Neither is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **some** UART wraps (U2/U3/U5 DTS; U4 WNS≥0 but WHS<0) and **fails** on P3; that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen. U5 DTS WHS≥0 is hold-excepted, not physical IOB hold MET.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**. Physical IOB hold MET remains **OPEN** (U4 −4.915 still on disk). UART STA ladder remains **separate envelopes**, not one closed ladder.

T1900Z residual (do not freeze `PRODUCTION_TOP`; do not ASTRA-13; UART STA ladder CLOSED_NARROW as **separate** envelopes) is **honored**, not closed as Master 12/13.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R3-UART-WRAP-CANDIDATES-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + CANDIDATES.md nine-row table (5 UART + 4 12-R2 pointers) from raw reports; XSim row has no WNS; routed WNS/WHS MATCH live Design State=Routed files (+0.305 / +0.681 / +0.115 WHS−4.915 / +0.115 WHS+0.131 / pointers +1.041 / +5.733 / −4.765 / +7.179); UART D10/A9 yes/no MATCH XDC/io.rpt; HOLD vs IOBFF **not collapsed**; `FALSE_PATH_HOLD` **labeled**; `PRODUCTION_TOP=UNKNOWN`; winner not frozen; 12-R2 files **not rewritten**; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze; physical IOB hold MET; UART STA as one envelope).  
Not FAIL (required artifacts present; nine raw WNS/WHS or XSim N/A MATCH live files; UART/IOB/hold-policy MATCH XDC/io/exceptions; overlapping hashes MATCH prior freeze lists; prior bags including 12-R2 and U4 −4.915 not rewritten; no program; no collapse; no winner).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared table-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this table to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, physical IOB hold MET, or a silent `PRODUCTION_TOP=<module>` (including `a7ng_astra_11_a09r3_uart_iobff_hold_wrap`). `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on U2/U3/U5 / P1/P2/P4 is **not** that gate. U5 WHS=+0.131 is **not** U4 −4.915 MET. UNPROGRAMMED historical bits are **not** the unique production bit.
3. Keep U4 WHS=−4.915 on disk. Do **not** collapse HOLD into IOBFF. Do **not** treat `FALSE_PATH_HOLD` DTS WHS≥0 as physical IOB hold MET. Keep UART STA envelopes **separate**.
4. Do **not** rewrite `ASTRA-12-R2-TOP-CANDIDATES-01` or any ASTRA-11 UART bags. Do not rerun those impl/xsim scripts.
5. Do **not** collapse `arty_a7_astra09_soc_top` P3 (100 MHz, WNS=−4.765) with P4 (50 MHz, WNS=+7.179). Do not treat max WNS, UART present, IOB FF packed, or hold-exception WHS≥0 as a freeze.
6. Optional wording: CANDIDATES.md condensed WNS one-liners → verbatim Design Timing Summary numeric rows; Table B P3 could quote live WHS=+0.046. Numbers already MATCH.
7. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout **on that top**, unique bit after WNS≥0 **on that top**, then ASTRA-13 + owner + ACCEPT_BOARD. Not this table’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **UART-wrap candidate table**: hashes + raw quotes of five UART wraps (XSim MAGIC A2 no WNS; routed +0.305 / +0.681 / +0.115 WHS−4.915 IOB FF YES / +0.115 WHS+0.131 FALSE_PATH_HOLD) plus four 12-R2 pointers (+1.041 / +5.733 / −4.765 / +7.179), UART D10/A9 yes/no, IOB/hold-policy, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN, 12-R2 not rewritten, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen. Physical IOB hold is **not** MET.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
Physical IOB hold MET: **OPEN** (U4 WHS=−4.915 untouched).  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1930Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R3-UART-WRAP-CANDIDATES-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
