# ASTRA auditor REPORT — 20260906T1500Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_R2_TOP_CANDIDATES_INDEPENDENT_AUDIT; astra12=AUDITOR_PASS_NARROW_PACK_ONLY; astra12_r2=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram closure / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-R2-TOP-CANDIDATES-01 + prior auditor 20260906T1430Z (PREPROGRAM-PACK PASS_NARROW; ACCEPT_PARTIAL | REJECT_PROMOTION; PRODUCTION_TOP=UNKNOWN; A09 wrap WNS=+1.041 Design State=Routed; BOARD blocked YES)
EVIDENCE   = bag ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt + RAW cited prior-bag files (timing_route.rpt, timing.rpt, io.rpt, util*.rpt, clk50_impl.xdc, constraints/arty_a7_100.xdc, BITSTREAM.txt, wrap SV, freeze lists) — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs CANDIDATES quotes, (2) overlapping digests vs prior-bag freeze lists / PREPROGRAM-PACK `SHA256.txt` / auditor `20260906T1430Z`, (3) copied DUT/bit digests vs those bags' `SHA256.txt` / `SHA256_BIT.txt`. First-recorded digests (this bag is the first hasher of TIMING-FIX `timing.rpt` / some freeze-list file hashes / T1430Z REPORT) are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-R2-TOP-CANDIDATES-01/`

Table-only. **No RTL. No bitstream. No impl/xsim rerun. No winner freeze.** ACK first, then `CANDIDATES.md` + SHA-256 of cited raw reports/XDC/io/bits + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-R2-TOP-CANDIDATES-01 only** — one unknown: what are the existing **routed** tops already in this clone (name, bag, WNS from raw timing, UART pins present?, IOB count, bit built?) — with hashes — while `PRODUCTION_TOP` remains **UNKNOWN**? Parent does **not** pick a top. This bag must not write `PRODUCTION_TOP=<module>`.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS. **Not** a named production-top freeze.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-R2-TOP-CANDIDATES-01.md`: ACK first; `CANDIDATES.md` table at least A09 wrap (`a7ng_astra_11_a09_impl_wrap` / `timing_route.rpt`) and wrap-route SoC UART top (`arty_a7_astra_rtp_soc_top` or actual module / that bag’s routed report); quote UART pin names from each XDC (D10/A9 or absent); `PRODUCTION_TOP=UNKNOWN` in ACK/RESULTS/CLOSEOUT; no `write_bitstream`; no freeze of a winner; do not close ASTRA-13, BOARD_PASS, LM06, Master F3. Preserve prior bags; do not rerun impl; do not generate a `.bit`.
2. **Master ASTRA-12** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“Preprogram closure, unique bit, current board token/identity/UART plan.”* Isolated DAG label `ASTRA-12 FINAL-SOURCE-FREEZE` is a **different historical bag**. This table must not steal either close.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate. LOOP_STATE `program_gate` = `ASTRA-13_AND_OWNER_AND_WNS_GE_0_ON_FROZEN_PRODUCTION_TOP_AND_AUDITOR_ACCEPT_BOARD`.
4. Auditor `20260906T1430Z`: PREPROGRAM-PACK **PASS_NARROW**; Final `ACCEPT_PARTIAL | REJECT_PROMOTION`; `PRODUCTION_TOP=UNKNOWN`; raw A09 wrap WNS=+1.041 Design State=Routed; residual: do not silent-freeze a top; do not ASTRA-13. Remaining = freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout on that top, unique bit after WNS≥0 on that top, then ASTRA-13 + owner + ACCEPT_BOARD.

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART I/O on a frozen production top, auditor ACCEPT_BOARD, JTAG/COM12 program, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS.

Hunt (parent / this dispatch):

1. Four rows from raw reports? WNS +1.041 / +5.733 / −4.765 / +7.179 match live files?
2. UART D10/A9 present only on SoC XDC, absent on A09 `clk50_impl.xdc`?
3. Same module `arty_a7_astra09_soc_top` at 100 MHz FAIL vs 50 MHz PASS — not collapsed as one candidate?
4. `PRODUCTION_TOP` still UNKNOWN? No winner freeze?
5. Overclaim BOARD_PASS / ASTRA-13 / programmable bit?

---

## Evidence re-derived

### 1. Four rows from raw reports; WNS match live files (hunt 1) — MATCH

Authority = each bag’s raw timing report **Design Timing Summary** with `Design State : Routed`. Not RESULTS.md.

Grep of `results/A7-NATIVE-GRAPH/**/ASTRA*/**/timing*.rpt` for `Design State : Routed` returns **exactly four** files — the four rows this bag tables. No silent extra ASTRA routed timing summary; no missing ASTRA routed timing summary.

| # | Live file | Design / Date / State (opened this audit) | Live Design Timing Summary | Clock (same rpt) | Bag quote |
|---|-----------|-------------------------------------------|----------------------------|------------------|-----------|
| 1 | `ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt` | `a7ng_astra_11_a09_impl_wrap` / Sun Sep 6 **19:48:09** 2026 / **Routed** | WNS=**1.041** TNS=0.000 fail=0/3004 WHS=0.160 THS=0.000; *All user specified timing constraints are met.* | `sys_clk_pin` 10.000 ns (100 MHz); `clk50u` 20.000 ns (50 MHz); intra `clk50u` WNS=1.041 WHS=0.160 | **+1.041** TNS=0 WHS=+0.160 `clk50u` |
| 2 | `ASTRA-SOC-RTP-WRAP-ROUTE/timing.rpt` | `arty_a7_astra_rtp_soc_top` / Sun Sep 6 **02:11:52** 2026 / **Routed** | WNS=**5.733** TNS=0.000 fail=0/10150 WHS=0.029 THS=0.000; *All user specified timing constraints are met.* | intra `clk50u` WNS=**7.150** WHS=0.029; path group `**async_default**` clk50u→clk50u WNS=**5.733** | **+5.733** (summary = async_default); intra +7.150 |
| 3 | `ASTRA-11-SOC-WRAP/timing.rpt` | `arty_a7_astra09_soc_top` / Sat Sep 5 **22:59:22** 2026 / **Routed** | WNS=**−4.765** TNS=−2392.529 fail=**587**/4034 WHS=0.046; *Timing constraints are not met.* | Clock Summary: **only** `sys_clk_pin` 10.000 ns (100 MHz) — **no `clk50u`**; intra WNS=−4.765 | **−4.765** TNS=−2392.529 (587 fail) @ 100 MHz |
| 4 | `ASTRA-11-TIMING-FIX/timing.rpt` | `arty_a7_astra09_soc_top` / Sun Sep 6 **01:09:37** 2026 / **Routed** | WNS=**7.179** TNS=0.000 fail=0/4162 WHS=0.083 THS=0.000; *All user specified timing constraints are met.* | `clk50u` 20.000 ns (50 MHz); intra `clk50u` WNS=7.179 WHS=0.083 | **+7.179** TNS=0 WHS=+0.083 `clk50u` |

Dates match auditor `20260906T1430Z` / T1400Z comparison (wrap-route still 02:11:52; SOC-WRAP still 22:59:22; A09 wrap still 19:48:09). **Prior bags not rewritten.**

Wrap-route summary WNS=+5.733 is the **async_default** group, **not** intra-clock `clk50u` (+7.150). CANDIDATES.md states that split. Do not cite +5.733 as A09 wrap, and do not cite A09 +1.041 as the RTP SoC top. Honest.

CANDIDATES “raw WNS quotes” are **condensed** one-liners (`WNS(ns)=1.041 TNS=0.000 …`), not the verbatim multi-column numeric row. **Numbers match** the live Design Timing Summary. Not RESULTS.md as authority. P2 wording, not a WNS miss.

Occupancy (raw util, not identity) also MATCH live:

| # | LUT | FF | BRAM tile | DSP | Bonded IOB | util rpt |
|---|----:|---:|----------:|----:|-----------:|----------|
| 1 | 1305 | 1075 | 0 | 2 | 13 | `util_route.rpt` |
| 2 | 4244 | 3810 | 2 | 0 | 15 | `util.rpt` |
| 3 | 2956 | 1550 | 0 | 2 | 15 | `util.rpt` |
| 4 | 3102 | 1577 | 0 | 2 | 15 | `util.rpt` |

DUT under top (live SV, not RESULTS):

- Row 1 wrap: `a7ng_astra_09_integ_path u_a09` — ports `CLK100MHZ`, `sw[3:0]`, `btn[3:0]`, `led[3:0]` only.
- Row 2: `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128` `PLANT_R2_BASE=1'b1` + UART.
- Rows 3/4: `a7ng_astra09_pipe` under `arty_a7_astra09_soc_top`.

`ASTRA-11-RTP-SOC/util_synth.rpt` Design State = **Synthesized**; no `timing.rpt`; correctly **out of table**.

### 2. UART D10/A9 on SoC XDC only; absent on A09 `clk50_impl.xdc` (hunt 2) — MATCH

**Row 1 — `ASTRA-11-A09-IMPL-ROUTE-01/clk50_impl.xdc`** (opened this audit):

```text
# Do not edit that file. No UART. No DDR. Not BOARD_PASS.
```

Ports constrained: `CLK100MHZ` E3, `sw[3:0]` A8/C11/C10/A10, `led[3:0]` H5/J5/T9/T10, `btn[3:0]` D9/C9/B9/B8. **No `uart_*`. No `PACKAGE_PIN D10`. No `PACKAGE_PIN A9` as UART.** `run_impl.tcl` aborts if `uart_rx.sv` / `uart_tx.sv` / SoC tops are compiled.

Raw `io.rpt` Design `a7ng_astra_11_a09_impl_wrap`, Total User IO = **13**; Bonded IOB = **13**:

```text
| A9         |             | ... | User IO     |             |
| D10        |             | ... | User IO     |             |
```

A9 and D10 are **unbonded** on this wrap.

**Rows 2–4 — `constraints/arty_a7_100.xdc`** (live):

```text
## USB-UART Interface (Digilent names: uart_rxd_out = FPGA TX)
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];
```

No `IOB=TRUE` / `IOB=YES` attribute in that XDC. Bag reports **Bonded IOB count**, not an IOB=YES packing claim. Honest.

Raw `io.rpt` on rows 2, 3, and 4: Total User IO = **15**; Bonded IOB = **15**:

```text
| A9         | uart_txd_in  | ... | INPUT       | LVCMOS33    |
| D10        | uart_rxd_out | ... | OUTPUT      | LVCMOS33    |
```

Live SoC tops expose `uart_txd_in` / `uart_rxd_out`. Shared crystal/LED/SW/BTN sites are **not** identity of tops. UART present on a SoC wrap is **not** UART on a frozen production top (identity UNKNOWN).

### 3. Same module 100 MHz FAIL vs 50 MHz PASS — not collapsed (hunt 3) — MATCH

Rows 3 and 4 share module name `arty_a7_astra09_soc_top` and are **two compiles**:

| | ASTRA-11-SOC-WRAP (row 3) | ASTRA-11-TIMING-FIX (row 4) |
|--|---------------------------|-----------------------------|
| Design in timing.rpt | `arty_a7_astra09_soc_top` | `arty_a7_astra09_soc_top` |
| Clock Summary | **only** `sys_clk_pin` 10.000 ns (100 MHz) | `clk50u` 20.000 ns (50 MHz) |
| WNS | **−4.765** constraints **not met** | **+7.179** constraints **met** |
| Freeze-before-impl top SHA (from that bag `SHA256.txt`, files not rewritten) | `f8cef9a011a2cbdcaa11c283d5b87a2a06754b344d5bc05f514d22e79f13e0de` | `71f4ebe08e846bccda61d182351c8503cceb8ec3d5c24cf7fdd46b38cf014554` |
| Bit (UNPROGRAMMED) | `c7442d16…` | `a5c3f2c4…` |

Live `rtl/board/arty_a7_astra09_soc_top.sv` contains `MMCME2_BASE` 100→50 (`CLKIN1_PERIOD=10.0`, `CLKOUT0_DIVIDE_F=20.0`) and `localparam CLK_HZ = 50_000_000`. That matches the TIMING-FIX compile (clk50u present), **not** the SOC-WRAP compile (no clk50u in Clock Summary). Bag states live top SHA `71f4ebe0…` matches row 4 freeze, **not** row 3. CANDIDATE_COUNT=4, UNIQUE_MODULES=3. Rows **not ranked**. Do not treat max WNS as a freeze.

Prior PREPROGRAM-PACK table had **three** candidates and left TIMING-FIX as a comparison bit in MISSING.md only. This bag adding row 4 **without collapsing it into row 3** is the required split, not a silent extra winner.

### 4. PRODUCTION_TOP still UNKNOWN; no winner freeze (hunt 4) — MATCH

ACK.json / CANDIDATES.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt all write **`PRODUCTION_TOP = UNKNOWN`** and **`WINNER = NOT_FROZEN`** / `winner_frozen: false`.

No file in this bag writes `PRODUCTION_TOP=<module>`. Rows are explicitly **not ranked**. A09 wrap WNS=+1.041 is not that top. Wrap-route WNS=+5.733 is a different DUT (`pipe_r2`). TIMING-FIX WNS=+7.179 is a different compile of `arty_a7_astra09_soc_top` than SOC-WRAP WNS=−4.765.

LOOP_STATE.json (read-only this audit): `production_top=UNKNOWN`, `astra13=BLOCKED`, `program=false`, `board_pass=false`, `program_gate=ASTRA-13_AND_OWNER_AND_WNS_GE_0_ON_FROZEN_PRODUCTION_TOP_AND_AUDITOR_ACCEPT_BOARD`.

**No silent production-top freeze.**

### 5. BOARD_PASS / ASTRA-13 / programmable bit overclaim (hunt 5) — NO / NO / NO

This bag listing: ACK, CANDIDATES, RESULTS, CLOSEOUT, metrics, SHA256, SHA256_POST. **No `.bit`. No `vivado.log`. No tcl. No DCP.** Grep of this bag for `*.bit`: **zero**.

ACK/RESULTS/CLOSEOUT: `BIT=NOT_BUILT`, `write_bitstream=false`, `BOARD_PASS=NOT_CLAIMED`, `PROGRAM=NO`, `COM12=UNTOUCHED`, `ASTRA-13=BLOCKED`, `BOARD=BLOCKED`, `ACCEPT_BOARD=MISSING`.

Historical bits in **other** bags remain **UNPROGRAMMED**:

| Bag | BITSTREAM.txt | Bit digest (overlap) |
|-----|---------------|----------------------|
| wrap-route | `STATUS=UNPROGRAMMED` `PROGRAM=NO` | `8116fa77…` MATCH `SHA256_BIT.txt` and PREPROGRAM-PACK |
| SOC-WRAP | `STATUS=UNPROGRAMMED` `PROGRAM=NO` | `c7442d16…` MATCH that bag `SHA256.txt` (hex case only) |
| TIMING-FIX | `STATUS=UNPROGRAMMED` `PROGRAM=NO` | `a5c3f2c4…` MATCH that bag `SHA256.txt` |

A09 wrap bag still DCP-only (`ckpt/synth.dcp`, `ckpt/route.dcp`). No `.bit` there.

No `ASTRA-13-*` bag under `results/A7-NATIVE-GRAPH/`. Auditor reports still have **no** `ACCEPT_BOARD` verdict (phrase appears only as **missing** / program-gate condition). T1430Z Final remains `ACCEPT_PARTIAL | REJECT_PROMOTION`.

This bag does **not** call historical UNPROGRAMMED bits “programmable,” “READY_TO_PROGRAM,” or the unique production bit. UNIFIED blueprint §24 unique-bit / `READY_TO_PROGRAM=YES` is **not** claimed.

**No BOARD_PASS claim. No ASTRA-13 start. No programmable-bit overclaim. No bitstream generated by this table.**

### Cited SHA256 vs live files

**No independent `Get-FileHash` this process.** Cross-check:

| Cited object | This-bag digest | Live content / overlapping digest |
|--------------|-----------------|-----------------------------------|
| A09 wrap `timing_route.rpt` | `2a72f98a…ed48f72` | MATCH PREPROGRAM-PACK `SHA256.txt`. Live WNS/header **MATCH** CANDIDATES and T1430Z/T1400Z. |
| wrap-route `timing.rpt` | `71664fba…4a79ac` | MATCH PREPROGRAM-PACK. Live Date 02:11:52 WNS=5.733 **MATCH**. |
| SOC-WRAP `timing.rpt` | `870c0f12…dad92c` | MATCH PREPROGRAM-PACK. Live Date 22:59:22 WNS=−4.765 **MATCH**. |
| TIMING-FIX `timing.rpt` | `32232b9c…e275c5` | **First recording** (not in PREPROGRAM-PACK `SHA256.txt`). Live Date 01:09:37 WNS=7.179 **MATCH** CANDIDATES and that bag `TIMING_EXTRACT.txt` / RESULTS. |
| A09 `io.rpt` | `af08de5f…f2f1e2` | MATCH PREPROGRAM-PACK. Live Total User IO **13**; A9/D10 unbonded. |
| wrap-route `io.rpt` | `b4cb6178…f2236` | MATCH PREPROGRAM-PACK. Live Total User IO **15**; A9=`uart_txd_in` D10=`uart_rxd_out`. |
| SOC-WRAP `io.rpt` | `18505a0e…8fd395` | MATCH PREPROGRAM-PACK. Live Total User IO **15**; same UART sites. |
| TIMING-FIX `io.rpt` | `1f4c7a22…be0c2` | **First recording.** Live Total User IO **15**; UART bonded. Content MATCH quote. |
| `clk50_impl.xdc` | `9daf143e…b195f8` | MATCH A09 freeze `SHA256.txt` / `SHA256_POST.txt` and PREPROGRAM-PACK. Live “No UART.” |
| `constraints/arty_a7_100.xdc` | `1c12e6f8…b6a9c2` | MATCH wrap-route freeze and TIMING-FIX freeze. Live D10/A9 UART. |
| wrap-route bit | `8116fa77…b0171b` | MATCH `SHA256_BIT.txt` and PREPROGRAM-PACK. STATUS=UNPROGRAMMED. |
| SOC-WRAP bit | `c7442d16…5d1d99` | MATCH SOC-WRAP `SHA256.txt` `C7442D16…`. STATUS=UNPROGRAMMED. |
| TIMING-FIX bit | `a5c3f2c4…30e84a` | MATCH TIMING-FIX `SHA256.txt`. STATUS=UNPROGRAMMED. |
| A09 wrap SV | `399aa22a…b2a5f42` | MATCH A09 freeze / `SHA256_POST.txt`. Live module ports = CLK/sw/btn/led only. |
| DUT A09 `9fdbe0d6…` / pipe `48c9e480…` / rtp pipe `3d27091d…` / rtp top `a1f7a063…` | copied | MATCH those bags’ freeze lists (files not rewritten). |
| Live `arty_a7_astra09_soc_top.sv` `71f4ebe0…` | listed as live Get-FileHash | MATCH TIMING-FIX freeze **and** wrap-route KEEP_NOT_COMPILED. **Not** SOC-WRAP freeze `f8cef9a0…`. |
| A09 freeze-list file `SHA256.txt` | `2d36af9c…4bf827` | MATCH PREPROGRAM-PACK hash of that same freeze-list file. **Not rewritten.** |
| Auditor `20260906T1430Z/REPORT.md` | `a72b6542…0658ca` | **First recording.** Live file still Final `ACCEPT_PARTIAL \| REJECT_PROMOTION`; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES. |
| PREPROGRAM-PACK `PACK.md` | `e3e2a712…21f419` | **First recording.** Live PACK still PRODUCTION_TOP=UNKNOWN; three candidates not chosen; A09 WNS=+1.041. |

ACK.json digest in `SHA256.txt` and `SHA256_POST.txt` is the same `35054d03…`. This-bag product list is ACK + CANDIDATES + RESULTS + CLOSEOUT + metrics + SHA256. **No `.bit` in this bag.**

Hash theatre of **invented** overlapping digests: **not found**. Limitation: first-recorded report hashes not re-digested here.

### ACK first / preserve

ACK.json present; `SHA256.txt` lists it first among this-bag files. `write_scope` = new bag only. `preserves` names PREPROGRAM-PACK, ASTRA-11-A09, SOC-WRAP*, TIMING-FIX, wrap-route, RTP-SOC, A09, A10, ASTRA-06-*, F2R-*, F3-*, ASTRA-12-FINAL-SOURCE-FREEZE, ASTRA-12B (not edited; run scripts not rerun). Comparison timing.rpt dates still original. No evidence of prior-bag wipe.

`does_not_close` includes production_top_identity / Master ASTRA-12 unique-bit UART plan / Master ASTRA-13 / BOARD_PASS / write_bitstream / ASTRA-11 FULLCHIP / Master ASTRA-09 / F3 10pp/CI / ASTRA-06 / LM06 / ACCEPT_BOARD.

A09 wrap `check_timing` live: `no_output_delay` **4 HIGH** (LED ports). This table does not manufacture that as closed board I/O timing. Residual vs pinout, not this-bag FAIL.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md only | **No.** CANDIDATES cites raw Design Timing Summary; live MATCH four files. |
| Four WNS numbers invented / swapped | **No.** +1.041 / +5.733 / −4.765 / +7.179 MATCH live routed summaries. Wrap-route +5.733 correctly labeled async_default, not intra +7.150. |
| Wrap-route WNS=+5.733 recycled as A09 wrap | **No.** Different Design names, dates, IOB, UART. |
| OOC / synth-only as routed | **No.** RTP-SOC and ASTRA-10\* called out of table (Synthesized). |
| UART D10/A9 on A09 wrap | **No.** XDC comment “No UART”; io.rpt A9/D10 unbonded. |
| Collapse `arty_a7_astra09_soc_top` 100 MHz FAIL with 50 MHz PASS | **No.** Two rows; two freeze SHAs; Clock Summary 100 MHz-only vs clk50u 20 ns. |
| A09 wrap / max-WNS row silently frozen as production top | **No.** UNKNOWN + not ranked + “do not treat max WNS as freeze.” |
| BOARD_PASS / ACCEPT_BOARD | **Not claimed.** Zero ACCEPT_BOARD verdict in AUDITOR reports. |
| ASTRA-13 started | **No.** No ASTRA-13 bag. LOOP_STATE `astra13=BLOCKED`. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. Historical bits labeled UNPROGRAMMED, not adopted, not READY_TO_PROGRAM. |
| Programmable-bit overclaim | **No.** UNPROGRAMMED + PROGRAM=NO + not production bitstream. |
| LM06 language | **No.** Listed OPEN. |
| Master F3 10pp closed | **No.** Listed OPEN. |
| Hash theatre | **Not found** for overlapping timing/io/bit/DUT/freeze-list digests. First-recorded TIMING-FIX `timing.rpt` hash is content-verified only. |
| TB-load / one-hot transfer / tautology | N/A for a table-only bag. A09 wrap still ties `load_v_i=1'b0` (prior T1400Z). This bag did not reopen that DUT. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited rpts keep original session stamps. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top / unique bit. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the candidate-table unknown.

---

## Logic bugs

None in this bag’s product (markdown + hash list + metrics). No DUT compiled. No bitstream. No new RTL. No winner written.

Residuals (not this-bag FAIL):

1. CANDIDATES.md WNS “quotes” are condensed one-liners, not the verbatim Design Timing Summary numeric row. Live numbers MATCH. Prior PACK.md of PREPROGRAM-PACK was more verbatim for A09 wrap.
2. First-recorded SHA of TIMING-FIX `timing.rpt` / TIMING-FIX `io.rpt` / several freeze-list files / T1430Z REPORT / PACK.md cannot be re-digested without a shell. Content of those files MATCHES quotes / prior overlapping lists.
3. ACK `observed_session_id=UNKNOWN`. Does not affect the table unknown.
4. `docs/ASTRA/PROJECT_PATHS.md` still says `ASTRA-11-TIMING-FIX | NOT IN QUEUE`. Stale vs the existing routed bag. This table did not rewrite that doc and did not promote TIMING-FIX to production top.
5. A09 wrap `no_output_delay` 4 HIGH remains a pinout residual, not closed by this table.
6. Other-lane routed reports in this clone (NG-01/02/03, E2\*, BRAM-WM, etc.) are scoped out of the ASTRA production-top table. Handoff required **at least** A09 wrap + wrap-route SoC UART top; bag delivered those plus SOC-WRAP and TIMING-FIX. Honest exclusion, not a hidden extra freeze.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a candidate table exists, with hashes and raw quotes of four routed ASTRA board-level tops (three unique module names), UART pin names from each XDC, IOB counts, and bit-built status, **without** BOARD_PASS, **without** silently naming a production top, **without** freezing a winner.

**Master ASTRA-12** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7: preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This bag is a comparison table of already-routed wrappers. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` is a different bag and is also **not** this close (ACK `does_not_close`). PREPROGRAM-PACK remains the pack-only evidence classification; this R2 bag is the missing candidate split (especially 100 MHz vs 50 MHz same module name). Neither is Master ASTRA-12 unique-bit close.

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD. WNS≥0 exists on **some** candidates (A09 wrap, wrap-route, TIMING-FIX) and **fails** on SOC-WRAP; that is **not** WNS≥0 on **the frozen production top**, because no production top is frozen.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**.

T1430Z residual (do not silent-freeze a top; do not ASTRA-13) is **honored**, not closed.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-R2-TOP-CANDIDATES-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + CANDIDATES.md four-row table from raw routed reports; UART D10/A9 quoted from SoC XDC and absent on A09 `clk50_impl.xdc`; same module `arty_a7_astra09_soc_top` kept as two compiles (100 MHz FAIL vs 50 MHz PASS); `PRODUCTION_TOP=UNKNOWN`; winner not frozen; PROGRAM=NO; no `.bit`; no BOARD_PASS; no ASTRA-13.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS; named production-top freeze).  
Not FAIL (required artifacts present; four raw WNS MATCH live Design State=Routed files; UART/IOB MATCH XDC/io.rpt; overlapping hashes MATCH prior pack/freeze lists; prior bags not rewritten; no program; no collapse; no winner).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit / programmable bit not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared table-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this table to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, JTAG/COM12, or a silent `PRODUCTION_TOP=<module>`. `PRODUCTION_TOP` stays **UNKNOWN** until a later **named freeze**.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority. WNS≥0 on A09 wrap / wrap-route / TIMING-FIX is **not** that gate. UNPROGRAMMED historical bits are **not** the unique production bit.
3. Do **not** collapse `arty_a7_astra09_soc_top` row 3 (100 MHz, WNS=−4.765, freeze `f8cef9a0…`) with row 4 (50 MHz MMCM, WNS=+7.179, freeze `71f4ebe0…`). Do not treat max WNS, UART present, or bit-exists as a freeze.
4. Optional wording: CANDIDATES.md condensed WNS one-liners → verbatim Design Timing Summary numeric rows (as PREPROGRAM-PACK did for A09 wrap). Numbers already MATCH.
5. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout on **that** top, unique bit after WNS≥0 on **that** top, then ASTRA-13 + owner + ACCEPT_BOARD. Not this table’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **routed-candidate table**: hashes + raw quotes of four ASTRA board-level routed tops (WNS +1.041 / +5.733 / −4.765 / +7.179), UART D10/A9 vs absent, IOB 13 vs 15, bits UNPROGRAMMED or NOT_BUILT, `PRODUCTION_TOP=UNKNOWN`, winner NOT_FROZEN, BIT=NOT_BUILT, PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. No production top is frozen.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1500Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-R2-TOP-CANDIDATES-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; BOARD blocked YES.
