# ASTRA auditor REPORT — 20260907T0230Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R4_R7_UART_CANDIDATES_INDEPENDENT_AUDIT; astra12_r4=IMPLEMENTER_CLAIM_11_ROWS_PENDING_AUDITOR; astra11_a09r7=AUDITOR_PASS_NARROW_WNS_P0336_WHS_P0104_UART_IOB; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R4-R7-UART-CANDIDATES-01 + prior auditor 20260907T0200Z (A09R7 UART impl-route ACCEPT_PARTIAL | REJECT_PROMOTION; PASS_NARROW; raw routed WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD HONEST; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T0130Z (R7 UART query-rew XSim PASS_NARROW ans=4 then w0=−5) + T1930Z (12-R3 table PASS_NARROW 9 rows ACCEPT_PARTIAL) + T1500Z (12-R2 table PASS_NARROW 4 pointers)
EVIDENCE   = bag ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt + RAW cited prior-bag files (R7 xsim.log / xelab.log, A09R7 timing_route.rpt / io.rpt / util_route.rpt / exceptions_route.rpt / clocks_route.rpt / UART_IOBFF.txt / clk50_uart_impl.xdc, 12-R2/12-R3 CANDIDATES.md + SHA256.txt + SHA256_POST.txt, pointer timing_route.rpt / timing.rpt) — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (would wipe `xsim.log` / routed reports). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs CANDIDATES quotes, (2) overlapping digests vs 12-R2 / 12-R3 `SHA256.txt` + `SHA256_POST.txt` / R7 PRE+POST / A09R7 PRE+POST / T0130Z / T0200Z / T1930Z / T1500Z freeze strings, (3) session stamps on raw reports vs T0200Z / T0130Z / T1930Z. Timing-report SHA strings first-recorded in this bag are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R4-R7-UART-CANDIDATES-01/`

Table-only. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `CANDIDATES.md` from raw reports (R7 XSim + A09R7 impl-route) + SHA-256 of cited raw reports/XDC/io + pointers to 12-R2 and 12-R3 tables + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R4-R7-UART-CANDIDATES-01 only** — one unknown (handoff):

> Extend the candidate table with R7 XSim + A09R7 impl-route. Parent does **not** freeze `PRODUCTION_TOP`. PROGRAM=NO.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze. **Not** physical IOB hold MET. **Not** promoting N2 WHS=+0.104 as U4 −4.915 MET. **Not** promoting N1 XSim ans=4/w0=−5 as the routed result.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R4-R7-UART-CANDIDATES-01.md`: ACK first; `CANDIDATES.md` rows quoting raw reports:
   - ASTRA-09-R7-UART-QUERY-REW-01 (XSim, ans=4 then w0=−5, no routed WNS)
   - ASTRA-11-A09R7-UART-IMPL-ROUTE-01 WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD
   - Pointers to 12-R2 and 12-R3 tables, do **not** rewrite those files
   - `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD_PASS, LM06, Master F3; PROGRAM=NO.
   Preserve: do not edit ASTRA-12-R2, ASTRA-12-R3, ASTRA-09-R7, ASTRA-11-A09R7-UART-IMPL-ROUTE-01. Do not rerun impl/xsim. Do not generate a `.bit`. Do not write `PRODUCTION_TOP=` a module name.
2. **Master ASTRA-12** (isolated DAG `ASTRA-12 FINAL-SOURCE-FREEZE` / T1500Z: *preprogram closure, unique bit, current board token/identity/UART plan*). This table must not steal that close. Historical ASTRA-12 / 12B freeze bags are different objects.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/LOOP_STATE.json`: *astra13=BLOCKED; program=false; production_top=UNKNOWN.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260907T0200Z`: A09R7 bag PASS_NARROW; raw routed WNS=+0.336 WHS=+0.104; UART IOB YES IOB FF packed; FALSE_PATH_HOLD HONEST (UART I/O hold excepted, not physically MET); `PRODUCTION_TOP=UNKNOWN`; BOARD blocked YES.
5. Auditor `20260907T0130Z`: R7 UART query-rew XSim PASS_NARROW; marker `ASTRA_09_R7_UART_QUERY_REW_PASS`; ans=4 then w0=−5; claimed `xsim.log` SHA `7cdffce1…` content-verified; no routed WNS.
6. Auditor `20260906T1930Z`: 12-R3 table PASS_NARROW; 5 UART + 4 12-R2 pointers = 9; 12-R2 files not rewritten; U4 WHS=−4.915 kept separate from U5 FALSE_PATH_HOLD.
7. Auditor `20260906T1500Z`: 12-R2 table PASS_NARROW; four pointer WNS +1.041 / +5.733 / −4.765 / +7.179.

Hunt (this dispatch):

1. Rows include R7 XSim (ans=4/w0=−5) and A09R7 impl WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD?
2. Pointers to 12-R2/R3 without rewriting those bags?
3. `PRODUCTION_TOP` UNKNOWN? No winner freeze?
4. Overclaim BOARD_PASS / ASTRA-13?
5. Candidate count honest (11 vs 2 new + pointers)?

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, physical IOB hold MET, UART STA ladder as one envelope, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS, silent freeze of `a7ng_astra_11_a09r7_uart_impl_wrap`.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` lists it first among this-bag files (`2c7544c2…285288a1`). `write_scope` = new bag only: ACK first + CANDIDATES.md from raw reports (R7 XSim + A09R7 impl-route) + SHA256 of cited raw reports/XDC/io + pointers to 12-R2 and 12-R3 tables + RESULTS/CLOSEOUT; no RTL; no bitstream; no freeze of a winner; no prior-bag rewrite; no impl/xsim rerun.

`PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`, `winner_frozen: false`.

`does_not_close` includes production_top_identity, Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ASTRA-11_FULLCHIP_COFIT, Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, ACCEPT_BOARD, physical_IOB_hold_MET, UART_STA_ladder_as_one_envelope, ASTRA-09-R7-UART-QUERY-REW-01, ASTRA-11-A09R7-UART-IMPL-ROUTE-01.

Bag listing: ACK.json, CANDIDATES.md, RESULTS.md, CLOSEOUT.md, metrics.json, SHA256.txt, SHA256_POST.txt. **No** `.bit` / `.bin` / `.mcs`. No `ckpt/`. No run scripts. No RTL. Same 7-file candidate-bag pattern as 12-R2 and 12-R3.

RESULTS.md / CLOSEOUT.md / metrics.json: `PRODUCTION_TOP=UNKNOWN`, `WINNER=NOT_FROZEN`, `R7_NEW_ROWS=2`, `R3_POINTER_ROWS=9`, `R2_POINTER_ROWS=4`, `CANDIDATE_COUNT=11`, `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

CANDIDATES.md: **Rows are not ranked.** Do not treat max WNS, IOB FF packed, or hold-exception WHS≥0 as a freeze. Parent does **not** pick a top. This bag does **not** write `PRODUCTION_TOP=<module>`.

Base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH handoff.

---

### Hunt 1 — R7 XSim ans=4/w0=−5 + A09R7 WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD — MATCH

#### N1 — ASTRA-09-R7-UART-QUERY-REW-01 (XSim only; no routed WNS)

Live `xsim.log` session **Mon Sep 7 01:24:47–01:26:05 2026**, PID **46472**, snapshot `a09r7qr`:

```text
TB ASTRA-09-R7-UART-QUERY-REW DUT=a7ng_astra_09_r7_uart_query_rew_wrap INNER=a7ng_astra_09_r2_cand_ovf.u_sgd PROGRAM=NO
UART 115200 8N1 CPB_PIN100=868 BIT_NS=8680 PRODUCTION_TOP=UNKNOWN
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE SMOKE_UART magic=a2 tbl=0 st=0 ans=4 p0=17 p1=34 npath=2 ntrunc=0 rov=0 wov=0 acc=1 eol=0a hier_tbl=0 w0=0 phi0=50 txn=1
INNER_UPD rew=-3 phi0=50 t=3994945000
FRAME REW_OBS a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
DECODE REW_OBS magic=a2 w0=-5 phi0=50 nupd=1 nbad=0 nstale=0 ndup=0 txn=1 gen=1 tag=57 hier_w0=-5 sgd_w0=-5 pub_w0=-5 tbl=0 cmt=1
ASTRA_09_R7_UART_QUERY_REW_PASS
$finish called at time : 11975335 ns
```

CANDIDATES.md N1 quote MATCHES this live log (same TB line, SMOKE ans=4, REW_OBS w0=−5 / `fb ff`, marker, finish time). No `timing_route.rpt` in that bag. WNS/WHS **N/A**. UART ports YES; PACKAGE_PIN **NO**. MMCM = UNISIM: live `xelab.log` `unisims_ver.MMCME2_BASE` / `BUFG` (not silicon). Claimed `xsim.log` SHA `7cdffce10f07ff20cf2e1866f6275f6c5f4738f01aee0741bf4895d989b256d5` MATCHES T0130Z content-verified string and R7 RESULTS.md / metrics.json. Wrap SV digest `aeb7e194…fc2c608c` MATCH R7 PRE/POST SHA256. Frozen DUT `15a919f1…8b70ee23` MATCH R7 / A09R7 / 12-R3 / this bag.

N1 is **not** the A09R7 routed result. Bag discloses that.

#### N2 — ASTRA-11-A09R7-UART-IMPL-ROUTE-01 (Routed)

Live `timing_route.rpt` header:

```text
Date         : Mon Sep  7 01:52:48 2026
Design       : a7ng_astra_11_a09r7_uart_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Design Timing Summary numeric row (authority):

```text
    WNS(ns)      TNS(ns)  ...      WHS(ns)      THS(ns)
      0.336        0.000  ...        0.104        0.000
All user specified timing constraints are met.
```

Intra-clock `clk50u`: WNS=0.336 WHS=0.104. Inter-clock hold columns **blank**:

```text
uart_io_vclk  clk50u             19.270
clk50u        uart_io_vclk        7.313
```

CANDIDATES.md N2 **+0.336 / +0.104** MATCH live DTS and T0200Z. Clock period `clk50u` 20.000 ns (50.000 MHz). Pipe clock **real**: live `clocks_route.rpt` Design State Routed 01:52:52 `clk50u 20.000 P,G,A {u_mmcm/CLKOUT0}`; `uart_io_vclk 20.000 V {}`. MATCH CANDIDATES quote.

UART IOB YES — live `io.rpt` Total User IO = **15**, Date 01:52:52:

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    | ... | FIXED
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    | ... | FIXED
```

Pins **not swapped**. Bag-local XDC (PRE=POST SHA `72004235…286c3e57` MATCH A09R7 PRE/POST):

```text
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]
set_property IOB TRUE [get_ports uart_txd_in]
set_property IOB TRUE [get_ports uart_rxd_out]
set_input_delay  -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_txd_in]
set_input_delay  -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_txd_in]
set_output_delay -clock [get_clocks uart_io_vclk] -max 2.000 [get_ports uart_rxd_out]
set_output_delay -clock [get_clocks uart_io_vclk] -min 0.500 [get_ports uart_rxd_out]
set_false_path -hold -from [get_ports uart_txd_in]
set_false_path -hold -to   [get_ports uart_rxd_out]
```

IOB FF YES — live `util_route.rpt`: Slice LUTs **4945**, Slice Registers **3615**, Block RAM Tile **0**, DSPs **2**, Bonded IOB **15**, IOB Flip Flops **2**, ILOGIC **1** (`IFF_Register=1`), OLOGIC **1** (`OUTFF_Register=1`). Live `UART_IOBFF.txt`: `RX BEL=ILOGICE2.IFF LOC=ILOGIC_X0Y171` / `TX BEL=OLOGICE2.OUTFF LOC=OLOGIC_X0Y161` / `UART_IOBFF=YES`. MATCH CANDIDATES occupancy row N2 and T0200Z.

FALSE_PATH_HOLD — live `exceptions_route.rpt` Design State Routed 01:52:53:

```text
Position  From                     To                   Setup  Hold
9         [get_ports uart_txd_in]  *                    -      false
10        *                        [get_ports uart_rxd_out]  -      false
```

Hold column **`false`**. Setup column **`-`** (setup **not** excepted). DTS WHS=+0.104 is **intra clk50u**, not UART I/O hold vs `uart_io_vclk`. Bag labels HOLD_POLICY **FALSE_PATH_HOLD_ASYNC_UART** and **HONEST** (not physically MET). MATCH T0200Z.

Claimed N2 `timing_route.rpt` SHA `0c45687b6f79e0fa6ade58d0754a76c160b718b100cc6c014fc0374048378d2b` is **first-recorded in this bag** (A09R7 PRE/POST hash sources, not the rpt). Content of the opened rpt MATCHES T0200Z numeric quotes. Wrap SV `d1f66a54…08644bde` MATCH A09R7 PRE/POST.

Hunt 1: **MET.**

---

### Hunt 2 — pointers to 12-R2/R3 without rewriting those bags — MET

Live 12-R3 `CANDIDATES.md` still:

```text
GATE             = ASTRA-12-R3-UART-WRAP-CANDIDATES-01
CANDIDATE_COUNT  = 9
UART_WRAP_ROWS   = 5
R2_POINTER_ROWS  = 4
```

No R7 / A09R7 / `WNS=+0.336` strings in that directory (grep). Table A still U1–U5; Table B still P1–P4. Pointer SHA claimed `713ecb714bd482f02aff1e491fcdef2d13844acea8446ad79487291b5fbecf87` MATCH 12-R3 `SHA256.txt` product line **and** 12-R3 `SHA256_POST.txt` (tabled 2026-09-06T23:53:38+07:00). This bag’s hash of 12-R3 `SHA256.txt` `68b3f8fd…9614da32` MATCH 12-R3 POST. This bag’s hash of 12-R3 `SHA256_POST.txt` `969be83f…0c7e9e22` is listed; POST file still contains `713ecb71…` for CANDIDATES.md.

Live 12-R2 `CANDIDATES.md` still:

```text
GATE             = ASTRA-12-R2-TOP-CANDIDATES-01
CANDIDATE_COUNT  = 4
```

No R7 / A09R7 / `WNS=+0.336` strings in that directory (grep). Pointer SHA claimed `ccfe51e2c6be0ee1cf312f9ea3f9f431c3b6896cfce608ed5b64fedd46619178` MATCH 12-R2 `SHA256.txt` product line **and** 12-R2 `SHA256_POST.txt` (tabled 2026-09-06T20:25:48+07:00) **and** 12-R3 pointer of the same file. This bag’s hash of 12-R2 `SHA256.txt` `b1194a9e…8b549de` MATCH 12-R2 POST.

Pointer timing SHA strings in this bag MATCH 12-R3 `SHA256.txt` (which MATCH 12-R2 for P1–P4):

| # | Report SHA in this bag | Also in 12-R3 SHA256.txt | Live DTS this audit |
|---|------------------------|--------------------------|---------------------|
| U1 xsim.log `e9b7f433…f0110040` | YES | T1930Z / T1700Z content-verified; MAGIC A2 PASS; no routed WNS |
| U2 `c3225d49…e54b6165` | YES | WNS=0.305 WHS=0.024 Routed |
| U3 `2fea8558…b82eb6` | YES | WNS=0.681 WHS=0.100 Routed |
| U4 `95a71677…e6172c` | YES | WNS=0.115 WHS=−4.915 Routed; constraints **not** met |
| U5 `a7501ce4…8edf5f6b` | YES | WNS=0.115 WHS=0.131 Routed |
| P1 `2a72f98a…ed48f72` | YES (also 12-R2) | WNS=1.041 WHS=0.160 Routed |
| P2 `71664fba…0a4a79ac` | YES (also 12-R2) | T1500Z / T1930Z +5.733 (not re-opened as FAIL) |
| P3 `870c0f12…d9dad92c` | YES (also 12-R2) | T1500Z / T1930Z −4.765 |
| P4 `32232b9c…ee275c5` | YES (also 12-R2) | T1500Z / T1930Z +7.179 |

This bag **copies quotes** into its own `CANDIDATES.md` Table B/C. That is the required pointer. It does **not** add N1/N2 into the 12-R2 or 12-R3 files.

R7 / A09R7 bags also not rewritten at content level: `xsim.log` still 01:24:47 PID 46472; `timing_route.rpt` still 01:52:48 Design `a7ng_astra_11_a09r7_uart_impl_wrap`; wrap SV digests MATCH those bags’ PRE/POST.

Hunt 2: **MET.**

---

### Hunt 3 — PRODUCTION_TOP UNKNOWN; no winner freeze — MET

| Artifact | PRODUCTION_TOP | WINNER |
|----------|----------------|--------|
| ACK.json | `"UNKNOWN"`, `winner_frozen: false` | not a module name |
| CANDIDATES.md | UNKNOWN / NOT_FROZEN; rows **not ranked** | explicit: do not treat max WNS / IOB FF / hold-exception WHS≥0 as freeze |
| RESULTS.md | UNKNOWN; “Not frozen. Not silently chosen.” | N2 +0.336 **is not** that top; N1 XSim **is not** that top |
| CLOSEOUT.md | UNKNOWN / NOT_FROZEN | “This bag is not that freeze.” |
| metrics.json | `"UNKNOWN"`, `winner_frozen: false` | — |
| SHA256.txt / POST | comments PRODUCTION_TOP=UNKNOWN | — |
| LOOP_STATE.json (read-only) | `"UNKNOWN"` / `NEEDS_OWNER_NOT_SILENT` | — |

No `PRODUCTION_TOP=a7ng_astra_11_a09r7_uart_impl_wrap` (or any other module) written. Hunt 3: **MET.**

---

### Hunt 4 — overclaim BOARD_PASS / ASTRA-13 — NOT FOUND

Every this-bag product: `BOARD_PASS=NOT_CLAIMED`, `ASTRA-13=BLOCKED`, `ACCEPT_BOARD` missing/false, `BIT=NOT_BUILT`, `PROGRAM=NO`, `write_bitstream=false`, COM12/JTAG UNTOUCHED.

ACK `does_not_close` lists Master_ASTRA-12_unique_bit_UART_plan, Master_ASTRA-13, BOARD_PASS, write_bitstream, ACCEPT_BOARD, physical_IOB_hold_MET.

RESULTS: “Do **not** call this BOARD_PASS or ASTRA-13.”

CANDIDATES Not claimed: PRODUCTION_TOP, Winner, write_bitstream, BOARD_PASS, ASTRA-13, ACCEPT_BOARD, physical IOB hold MET, UART STA ladder as one envelope, Master ASTRA-12 unique-bit, mixing N2 +0.336 with U2 +0.305 / U3 +0.681 / U4/U5 +0.115 / P2 +5.733, promoting N2 WHS=+0.104 to erase U4 −4.915, promoting N1 XSim as the routed result.

No `.bit` in this bag. Historical P2–P4 bits remain labeled UNPROGRAMMED prefixes (`8116fa77…` / `c7442d16…` / `a5c3f2c4…`) in the pointer table — same as 12-R3, not adopted.

Implementer self-grade `PASS_NARROW` / CLOSEOUT `PASS_THIS_GATE_ONLY` is bounded to the table unknown. Not a Master-12/13 close.

Hunt 4: **NOT OVERCLAIM.**

---

### Hunt 5 — candidate count honest (11 vs 2 new + pointers) — HONEST

Header arithmetic (ACK / CANDIDATES / RESULTS / CLOSEOUT / metrics):

```text
R7_NEW_ROWS          = 2
R3_POINTER_ROWS      = 9
R2_POINTER_ROWS      = 4
CANDIDATE_COUNT      = 11
```

CANDIDATES.md states explicitly:

> `CANDIDATE_COUNT=11` = **2 new** (this bag) + **5** 12-R3 UART wraps + **4** 12-R2 routed tops. 12-R3’s 9-row table already includes those 4 R2 tops; they are **pointed**, not double-counted as extra unique candidates.

Table C: “These are the **same** P1–P4 as Table B. Cited for handoff completeness; **not** extra unique candidates.”

Unique set = N1, N2, U1, U2, U3, U4, U5, P1, P2, P3, P4 = **11**.  
Not 15 (would be 2+9+4 double-count).  
Not 11 **new** rows generated here (only N1+N2 are new).  
Not 2-only (handoff asked to keep 12-R2/R3 as pointers).

LOOP_STATE `astra12_r4=IMPLEMENTER_CLAIM_11_ROWS_PENDING_AUDITOR` is this unique-11 claim, not eleven new routed wraps.

Table B pointer WNS MATCH live files and 12-R3 table: U1 N/A; U2 +0.305/+0.024; U3 +0.681/+0.100; U4 +0.115/−4.915; U5 +0.115/+0.131; P1 +1.041 UART NO; P2 +5.733 UART YES; P3 −4.765 UART YES; P4 +7.179 UART YES.

Hunt 5: **HONEST.**

---

### Hash theatre / this-bag product

This-bag product hashes (first-recorded in `SHA256.txt` / `SHA256_POST.txt`; not re-digested here): ACK `2c7544c2…`, CANDIDATES `4d694af0…`, RESULTS `cd909c89…`, CLOSEOUT `fa37d5bc…`, metrics `fd3d6b1d…`, SHA256.txt itself `3cf41834…` (POST only). ACK.json digest is the same in SHA256.txt and SHA256_POST.txt. POST stamped 2026-09-07T02:13:05+07:00.

Overlap (strings compared, not re-hashed):

| Object | Digest | Overlap |
|--------|--------|---------|
| 12-R3 CANDIDATES.md | `713ecb71…5fbecf87` | 12-R3 SHA256 + POST |
| 12-R3 SHA256.txt | `68b3f8fd…9614da32` | 12-R3 POST |
| 12-R2 CANDIDATES.md | `ccfe51e2…46619178` | 12-R2 SHA256 + POST + 12-R3 pointer |
| 12-R2 SHA256.txt | `b1194a9e…8b549de` | 12-R2 POST + 12-R3 pointer |
| N1 wrap SV | `aeb7e194…fc2c608c` | R7 PRE/POST |
| Frozen A09-R2 DUT | `15a919f1…8b70ee23` | R7 / A09R7 / 12-R3 |
| N2 wrap SV | `d1f66a54…08644bde` | A09R7 PRE/POST |
| N2 XDC | `72004235…286c3e57` | A09R7 PRE/POST |
| N1 xsim.log | `7cdffce1…89b256d5` | T0130Z content-verified + R7 RESULTS/metrics |
| Pointer U1–U5 / P1–P4 timing | see Hunt 2 | 12-R3 / 12-R2 freeze lists |

Limitation: this-bag markdown hashes, N2 `timing_route.rpt` SHA `0c45687b…` (first-recorded here), and T0200Z REPORT SHA `7c0afb48…` cannot be re-digested without a shell. Content of those reports MATCHES quotes / T0200Z / T0130Z. Invented overlapping DUT/XDC/12-R2/12-R3 pointer digests: **not found**.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md only | **No.** CANDIDATES cites raw DTS / xsim.log; live MATCH. |
| Invent routed WNS for R7 XSim row | **No.** N1 N/A; no `timing_route.rpt` in R7 bag. |
| Recycle wrap-route +5.733 / HOLD +0.115/+0.131 / UART wrap +0.305 as N2 +0.336 | **No.** Explicit split; N2 date 01:52:48 Design `a7ng_astra_11_a09r7_uart_impl_wrap`. |
| Promote N1 ans=4/w0=−5 as routed | **Not claimed.** |
| Collapse N2 WHS=+0.104 into U4 −4.915 / claim physical IOB hold MET | **No.** U4 still −4.915 23:06:09 live; N2 hold excepted; labeled HONEST. |
| FALSE_PATH_HOLD unlabeled / hide-WHS cheat | **No.** Labeled. exceptions Hold=false Setup=`-`. T0200Z already graded HONEST. |
| Rank / silent-freeze a winner | **No.** Not ranked. `PRODUCTION_TOP=UNKNOWN`. |
| BOARD_PASS / ACCEPT_BOARD / ASTRA-13 | **Not claimed.** BLOCKED / NOT_CLAIMED. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. P2–P4 bits UNPROGRAMMED historical. |
| CANDIDATE_COUNT=11 as 11 new / or 2+9+4=15 | **No.** Header splits 2 new + 9 pointer; Table C not extra unique. |
| Mix UART STA ladder as one envelope | **Not claimed.** `does_not_close` includes that. |
| Hash theatre | **Not found** for overlapping DUT/XDC/wrap/12-R2/12-R3 pointer digests. First-recorded N2 timing SHA is content-verified only. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps (R7 01:24:47 PID 46472; A09R7 01:52:48; U4 23:06:09 −4.915). |
| Rewrite 12-R2 / 12-R3 | **Not found.** GATE names, counts, hashes MATCH POST lists; no R7 rows inserted. |
| TB-load / one-hot transfer | N/A for a table-only bag. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the R7-extension candidate-table unknown.

Evidence class: N1 functional tokens = **XSim EVIDENCE** (not silicon). N2 WNS/WHS/IOB = **routed STA EVIDENCE** (not board). Pointer WNS = **prior-bag routed EVIDENCE** (not re-impl). `PRODUCTION_TOP=UNKNOWN` = **CONFIRMED** in this bag’s products. Board plugged = **OBSERVED in LOOP_STATE as USER_SAYS_PLUGGED_UNPROGRAMMED**, not authority to program.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written. No RESULTS/raw contradiction on N1 marker/ans/w0, N2 WNS/WHS/IOB/hold-policy, or the nine pointer WNS/WHS (or XSim N/A).

Residuals (not this-bag FAIL):

1. CANDIDATES.md WNS “quotes” are condensed one-liners (`WNS(ns)=0.336 TNS=0.000 WHS=0.104`), not the verbatim Design Timing Summary numeric row. Live numbers MATCH. Same pattern as T1930Z.
2. Table B P3 omits WHS=+0.046 (12-R2 table had it; 12-R3 pointer table also omitted it). This bag copies 12-R3 compression. TNS=−2392.529 still quoted. Not a WNS miss; not a collapse with P4.
3. First-recorded SHA of N2 `timing_route.rpt` / this-bag markdown / T0200Z REPORT cannot be re-digested without a shell. Content MATCHES T0200Z / opened files.
4. ACK `observed_session_id=UNKNOWN`. Does not affect the table unknown.
5. N2 DSP=2 is frozen SGD, not a7-fpga-gate eam03e DSP=0. Occupancy LUT=4945/FF=3615 is **this R7 UART wrap**, not additive with HOLD 4802/3500 or wrap-route 4244/3810 BRAM=2. Disclosed.
6. Table C re-lists P1–P4 for handoff completeness. Count remains 11 unique because they are the same four as Table B. Honest, but a reader who only sums header integers 2+9+4 without the prose could misread 15. Prose and `CANDIDATE_COUNT=11` correct that.
7. N2 UART I/O hold remains excepted (T0200Z residual). This table correctly does not promote WHS=+0.104 as physical IOB hold MET. U4 −4.915 remains on disk.
8. LED `no_output_delay` HIGH on N2 (T0200Z residual) is not closed by this table.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a candidate table now includes **two new R7 rows** (XSim ans=4 then w0=−5, no routed WNS; routed WNS=+0.336 WHS=+0.104 UART IOB YES FALSE_PATH_HOLD) plus **pointers** to the intact 12-R3 nine-row table (which already includes the four 12-R2 tops), unique count **11**, with hashes and raw quotes, **without** BOARD_PASS, **without** silently naming a production top, **without** freezing a winner, **without** rewriting 12-R2 / 12-R3 / R7 XSim / A09R7 routed bags.

**Master ASTRA-12** (preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison table of already-simmed / already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` / `ASTRA-12B-POST-GLUE-FREEZE` are different bags and are **not** this close (ACK `does_not_close`). 12-R2 remains the board-level pointer table; 12-R3 extended it with R3 UART wraps; this R4 bag **extends** it with R7 XSim + A09R7 impl-route. None of those three is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **some** rows (N2 / U2 / U3 / U5 DTS; U4 WNS≥0 but WHS<0; P3 WNS<0); that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen. N2 DTS WHS≥0 is intra-clk50u with UART I/O hold excepted, not physical IOB hold MET.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**. Physical IOB hold MET remains **OPEN** (U4 −4.915 still on disk). UART STA ladder remains **separate envelopes**, not one closed ladder.

T0200Z residual (do not freeze `PRODUCTION_TOP`; do not ASTRA-13; do not promote WNS=+0.336 / WHS=+0.104 as BOARD_PASS or as U4 −4.915 MET) is **honored**, not closed as Master 12/13.

T0130Z residual (R7 XSim is not a silent production UART freeze) is **honored**: N1 stays XSim-only in this table; N2 is a **named wrap candidate**, not a freeze.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R4-R7-UART-CANDIDATES-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + CANDIDATES.md table from raw reports; **2 new** R7 rows (N1 XSim ans=4 then w0=−5 MAGIC A2 PASS, no routed WNS; N2 routed WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST) + **9** 12-R3 pointer rows (already including **4** 12-R2 tops) = unique **11**; pointer WNS/WHS MATCH live Design State=Routed files and 12-R3 table; 12-R2 and 12-R3 files **not rewritten**; R7 XSim log and A09R7 routed rpt **not overwritten**; `PRODUCTION_TOP=UNKNOWN`; winner not frozen; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze; physical IOB hold MET; UART STA as one envelope).  
Not FAIL (required artifacts present; N1 marker/ans/w0 MATCH live xsim.log; N2 WNS/WHS/IOB/hold-policy MATCH live routed reports; unique count 11 honest as 2 new + pointers; overlapping hashes MATCH prior freeze lists; prior bags including 12-R2, 12-R3, U4 −4.915, R7 XSim, A09R7 route not rewritten; no program; no winner).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / physical IOB hold MET / 11-new-rows not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared table-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this table to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, physical IOB hold MET, or a silent `PRODUCTION_TOP=<module>` (including `a7ng_astra_11_a09r7_uart_impl_wrap`). `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on N2 / U2 / U3 / U5 / P1 / P2 / P4 is **not** that gate. N2 WHS=+0.104 is **not** U4 −4.915 MET. UNPROGRAMMED historical bits are **not** the unique production bit.
3. Keep U4 WHS=−4.915 on disk. Do **not** collapse N2 FALSE_PATH_HOLD DTS WHS≥0 into physical IOB hold MET. Keep UART STA envelopes **separate**. Do **not** promote N1 XSim ans=4/w0=−5 as the N2 routed result.
4. Do **not** rewrite `ASTRA-12-R2-TOP-CANDIDATES-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-09-R7-UART-QUERY-REW-01`, or `ASTRA-11-A09R7-UART-IMPL-ROUTE-01`. Do not rerun those impl/xsim scripts. R7 `xsim.log` must stay 01:24:47 PID 46472. A09R7 `timing_route.rpt` must stay 01:52:48 WNS=0.336 WHS=0.104.
5. Do **not** collapse `arty_a7_astra09_soc_top` P3 (100 MHz, WNS=−4.765) with P4 (50 MHz, WNS=+7.179). Do not treat max WNS, UART present, IOB FF packed, or hold-exception WHS≥0 as a freeze. Do not add N2 LUT=4945 to HOLD 4802 or wrap-route 4244.
6. Count: unique **11** = 2 new + 9 pointers. Do not brief this as “11 new UART wraps” or as “15 rows.”
7. Optional wording: CANDIDATES.md condensed WNS one-liners → verbatim Design Timing Summary numeric rows; Table B P3 could quote live WHS=+0.046 from 12-R2. Numbers already MATCH.
8. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout **on that top**, unique bit after WNS≥0 **on that top**, then ASTRA-13 + owner + ACCEPT_BOARD. Not this table’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **R7 UART candidate-table extension**: hashes + raw quotes of two new rows (R7 XSim ans=4 then w0=−5, no routed WNS; A09R7 routed WNS=+0.336 WHS=+0.104 UART IOB YES IOB FF YES FALSE_PATH_HOLD HONEST) plus pointers to intact 12-R3 (9) / 12-R2 (4, already inside the 9) tables, unique count **11**, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN, 12-R2/12-R3/R7 XSim/A09R7 route **not rewritten**, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen. Physical IOB hold is **not** MET. N2 wrap is **not** the production top.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
Physical IOB hold MET: **OPEN** (U4 WHS=−4.915 untouched).  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0230Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R4-R7-UART-CANDIDATES-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
