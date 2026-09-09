# ASTRA auditor REPORT — 20260906T1430Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA12_PREPROGRAM_PACK_INDEPENDENT_AUDIT; astra12=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra11_a09=AUDITOR_PASS_NARROW_ROUTED_WNS_P1041; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-12 (preprogram closure / unique bit / UART plan) + MASTER ASTRA-13 (FINAL-BOARD-ACCEPTANCE) + work order ASTRA-12-PREPROGRAM-PACK-01 + prior auditor 20260906T1400Z (A09 wrap PASS_NARROW WNS=+1.041; ACCEPT_PARTIAL | REJECT_PROMOTION; BOARD blocked)
EVIDENCE   = pack bag PACK.md / MISSING.md / POLICY.md / SHA256.txt / ACK.json / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256_POST.txt + RAW cited prior-bag files (timing_route.rpt, xsim.log, util_synth.rpt, io.rpt, timing.rpt, freeze lists) — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not rerun impl/xsim scripts.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) live file **content** vs PACK quotes, (2) overlapping digests vs prior-bag RESULTS/metrics and prior auditor reports, (3) copied DUT/bit digests vs those bags' `SHA256.txt` / `SHA256_BIT.txt`. First-recorded digests (this pack is the first hasher of `timing_route.rpt` / `util_synth.rpt`) are **content-verified**, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-12-PREPROGRAM-PACK-01/`

Pack-only. **No RTL. No bitstream. No impl/xsim rerun.** ACK first, then PACK.md + MISSING.md + POLICY.md + SHA-256 of cited evidence + RESULTS/CLOSEOUT.

Gate under review is **work-order ASTRA-12-PREPROGRAM-PACK-01 only** — one unknown: can a frozen evidence pack list, with hashes, the routed A09 wrap WNS, the A09 XSim marker, persist/handshake bags, and **explicit missing items** (UART/LED I/O, SoC top identity, bitstream SHA, auditor ACCEPT_BOARD) — **without claiming BOARD_PASS**? If production-top identity cannot be frozen, say so; do not pick a top silently.

**Not** Master ASTRA-12 unique-bit close. **Not** historical `ASTRA-12-FINAL-SOURCE-FREEZE`. **Not** ASTRA-13. **Not** BOARD_PASS.

Judged against:

1. Work order `.agents/handoff/ASTRA-12-PREPROGRAM-PACK-01.md`: ACK first; PACK + SHA256 of ASTRA-11-A09 `timing_route.rpt` (quote WNS), ASTRA-09 `xsim.log` marker, ASTRA-10 `util_synth`, ASTRA-06-R4 sess-reuse marker; copy hashes, do not rewrite those files; MISSING.md UART / pinout vs wrap-route SoC / bitstream SHA / ASTRA-13 / LM06 / Master F3 10pp; POLICY.md PROGRAM=NO until ASTRA-13 + owner + WNS≥0 on **the frozen production top** + auditor ACCEPT_BOARD; A09 wrap WNS=+1.041 is **not** that top; no `write_bitstream`; no JTAG.
2. **Master ASTRA-12** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“Preprogram closure, unique bit, current board token/identity/UART plan.”* Isolated DAG label `ASTRA-12 FINAL-SOURCE-FREEZE` is a **different historical bag**. This pack must not steal either close.
3. **Master ASTRA-13** (DAG: FINAL-BOARD-ACCEPTANCE): silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md` §7: *ASTRA-13 BLOCKED. PROGRAM=NO.* GSTACK_LOOP: ASTRA-13 + owner + WNS≥0 + auditor ACCEPT is the only program gate.
4. Auditor `20260906T1400Z`: ASTRA-11-A09-IMPL-ROUTE-01 **PASS_NARROW** routed WNS=+1.041; Master ASTRA-11/13 OPEN; BOARD still blocked YES; residual: do not silent-close ASTRA-11/13; remaining is production top / bitstream policy / board.

Out of this bag’s close: unique production bitstream, frozen production-top identity, UART I/O on that top, auditor ACCEPT_BOARD, JTAG/COM12 program, Master ASTRA-09 production path, Master ASTRA-11 FULLCHIP-COFIT, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06 language, ASTRA-13 BOARD_PASS.

Hunt (parent / this dispatch):

1. PACK quotes WNS=+1.041 from **raw** `timing_route.rpt`, not RESULTS.md only?
2. Cited SHA256 match live files?
3. `PRODUCTION_TOP=UNKNOWN` explicit? A09 wrap not silently named production top?
4. MISSING.md lists UART / bitstream / ASTRA-13 / LM06 / F3 10pp?
5. POLICY.md PROGRAM=NO until frozen production top + ACCEPT_BOARD?
6. Overclaim BOARD_PASS? Any `.bit` generated in this bag?

---

## Evidence re-derived

### 1. PACK quotes WNS=+1.041 from raw `timing_route.rpt` (hunt 1) — MATCH

Authority file: `results/A7-NATIVE-GRAPH/ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt`

Live header (opened this audit):

```text
Tool Version : Vivado v.2026.1 (win64) Build 6511674
Date         : Sun Sep  6 19:48:09 2026
Command      : report_timing_summary -file .../ASTRA-11-A09-IMPL-ROUTE-01/timing_route.rpt
Design       : a7ng_astra_11_a09_impl_wrap
Device       : 7a100t-csg324
Design State : Routed
```

Live Design Timing Summary numeric line:

```text
    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints
      1.041        0.000                      0                 3004        0.160        0.000                      0                 3004
All user specified timing constraints are met.
```

Clock Summary (same rpt): `sys_clk_pin` period 10.000 (100.000 MHz); `clk50u` period 20.000 (50.000 MHz). Intra-clock `clk50u` WNS=1.041 WHS=0.160.

PACK.md quotes that same header, that same WNS/TNS/WHS line, Design State=Routed, and clk50u 20.000 ns. RESULTS.md repeats it but is **not** the authority PACK used. Auditor `20260906T1400Z` quoted the **same** raw numbers.

This number is **not** ASTRA-10 OOC WNS=+2.283, **not** wrap-route WNS=+5.733 (`arty_a7_astra_rtp_soc_top`, timing.rpt still Date Sun Sep 6 02:11:52), **not** ASTRA-11-SOC-WRAP WNS=−4.765 (`arty_a7_astra09_soc_top`, timing.rpt still Date Sat Sep 5 22:59:22). Prior comparison reports **not overwritten** (dates match T1400Z).

`check_timing` live: `no_output_delay` 4 HIGH (LED ports). PACK/MISSING record this as a residual vs board I/O timing, not as manufacture of internal clk50u WNS. Honest.

### 2. Cited SHA256 vs live files (hunt 2)

**No independent `Get-FileHash` this process.** Cross-check:

| Cited object | Pack digest | Live content / overlapping digest |
|--------------|-------------|-----------------------------------|
| A09 wrap `timing_route.rpt` | `2a72f98a…ed48f72` | **First recording** of this digest (A11 bag freeze is pre-impl; `SHA256_POST.txt` is RTL-only). Live WNS/header **MATCH** PACK quote and T1400Z. |
| ASTRA-09 `xsim.log` | `445199d247c3f8e47ad2ea5204d46127f9c5eda9207239d7f4a800664b15caa7` | MATCH A09 RESULTS.md / metrics.json **and** auditor `20260906T1300Z`. Live marker `ASTRA_09_INTEGRATED_PATH_XSIM_PASS`, `$finish` 12705 ns, session 18:53:05–18:53:07 PID 40928 — MATCH PACK. |
| ASTRA-10 `util_synth.rpt` | `3933db00…217ac` | **First recording.** Live header Design `a7ng_astra_10_resource_wrap`, Date Sun Sep 6 19:18:49, Design State **Synthesized**; LUT 5178 / FF 4155 / BRAM 0 / DSP 2 / Bonded IOB 0 — MATCH PACK and T1330Z. |
| ASTRA-06-R4 `xsim.log` | `cf7db5260f4f410d0c8e41fd5560b2fd5056e8ffd2555060df5697826670d64f` | MATCH R4 RESULTS.md / metrics.json **and** auditor `20260906T1235Z`. Live marker `ASTRA_06_R4_SESS_REUSE_XSIM_PASS`, `$finish` 13555 ns, session 18:35:14–18:35:16 — MATCH PACK. |
| Persist/handshake xsim.log | pack table | MATCH those bags' RESULTS/metrics: warm `5f739df0…`, R2 `ff0770d3…`, R3 `d6deb5ba…`, F2R2 `337ca164…`, F2R3 `806026f2…`, F2R4 `98297afc…`, F2R5 `a93aaedc…`. Raw markers present for warm/R2/R3/F2R2/F2R5. F2R3/F2R4 also have PASS markers in raw logs; PACK table says “(bag exists; not this close)” — **underclaim**, not overclaim. |
| DUT A09 `9fdbe0d6…` / SGD `b66ef328…` / persist/R2/R3/R4 / F2R3–F2R5 / `clk50_impl.xdc` `9daf143e…` | copied | MATCH ASTRA-11-A09 `SHA256.txt` freeze-before-impl (that file not rewritten; content opened this audit). |
| F2R2 law DUT `5e2f23c3…` | listed as copied from A11 freeze | **Not in** A11 `SHA256.txt`. **Is in** ASTRA-09 and ASTRA-06-R4 freeze lists. Digest is real; **provenance footnote is wrong.** P2, not fake hash. |
| SOC-WRAP bit `c7442d16…` | pack SHA256.txt | MATCH SOC-WRAP `SHA256.txt` `C7442D16…` (hex case only). `BITSTREAM.txt` STATUS=UNPROGRAMMED. |
| wrap-route bit `8116fa77…` | pack SHA256.txt | MATCH `ASTRA-SOC-RTP-WRAP-ROUTE/SHA256_BIT.txt`. STATUS=UNPROGRAMMED. |
| TIMING-FIX bit `a5c3f2c4…` | MISSING.md only (not SHA256.txt) | MATCH `ASTRA-11-TIMING-FIX/SHA256.txt`. Comparison-only. |
| A09 wrap `io.rpt` Total User IO | pack `af08de5f…` | Live **13**. UART sites A9/D10 **unbonded** on this wrap. |
| SOC-WRAP / wrap-route `io.rpt` | pack `18505a0e…` / `b4cb6178…` | Live Total User IO **15**. wrap-route: `A9 uart_txd_in`, `D10 uart_rxd_out`. |
| Auditor `20260906T1400Z/REPORT.md` | `f5b83053…9d3597b` | **First recording.** Live file still Final `ACCEPT_PARTIAL \| REJECT_PROMOTION`; WNS=+1.041; BOARD blocked YES. |

ACK.json digest in `SHA256.txt` and `SHA256_POST.txt` is the same `3c4b4754…`. Pack product list is ACK + PACK + MISSING + POLICY + SHA256 + RESULTS + CLOSEOUT + metrics. **No `.bit` in this bag** (9 files: 5 md, 2 json, 2 txt).

Hash theatre of **invented** digests: **not found**. Limitation: first-recorded report hashes not re-digested here.

### 3. PRODUCTION_TOP=UNKNOWN; A09 wrap not silently named production top (hunt 3) — MATCH

PACK.md / POLICY.md / RESULTS.md / CLOSEOUT.md / metrics.json / ACK.json all write **`PRODUCTION_TOP = UNKNOWN`**.

PACK names three **candidates not chosen**:

| Candidate | Bag | Routed WNS | UART | IOB | Bit |
|-----------|-----|------------|------|-----|-----|
| `a7ng_astra_11_a09_impl_wrap` | ASTRA-11-A09-IMPL-ROUTE-01 | **+1.041** clk50u | **NO** | 13 | NOT_BUILT |
| `arty_a7_astra09_soc_top` | ASTRA-11-SOC-WRAP | **−4.765** @ 100 MHz | YES D10/A9 | 15 | UNPROGRAMMED `c7442d16…` |
| `arty_a7_astra_rtp_soc_top` | ASTRA-SOC-RTP-WRAP-ROUTE | **+5.733** (RTP `pipe_r2`) | YES D10/A9 | 15 | UNPROGRAMMED `8116fa77…` |

Live wrap SV ports = `CLK100MHZ`, `sw[3:0]`, `btn[3:0]`, `led[3:0]` only. `clk50_impl.xdc` comment “No UART”; pins E3 / A8 C11 C10 A10 / H5 J5 T9 T10 / D9 C9 B9 B8 — MATCH PACK. `run_impl.tcl` forbids compiling `uart_rx.sv` / `uart_tx.sv`. Bonded IOB=13 in `util_route.rpt` and `io.rpt`.

POLICY: A09 wrap WNS=+1.041 is **not** WNS on the frozen production top, **not** SoC UART wrap timing, **not** permission to `write_bitstream`. SoC UART wrap remains a **different bag**. Do not pick a top silently.

**No silent production-top freeze.**

### 4. MISSING.md required list (hunt 4) — MATCH, one terminology residual

| Required | Present? | Live check |
|----------|----------|------------|
| UART | YES §1 | A09 wrap no UART; SoC wraps have D10/A9; MAGIC/COM12 capture not present; `rtl/board/uart_rx.sv` / `uart_tx.sv` exist in tree, **not** compiled into A09 wrap |
| Pinout vs wrap-route SoC | YES §2 | 13 vs 15 IOB; UART A9/D10 absent on A09 wrap; LED `no_output_delay` 4 HIGH |
| Bitstream SHA of frozen production top | YES §3 | This bag BIT=NOT_BUILT; A09 wrap DCP only, no `.bit` (grep of A11-A09 bag: zero `.bit`); historical bits UNPROGRAMMED, **not adopted** |
| ASTRA-13 | YES §4 | No `ASTRA-13-*` bag under `results/A7-NATIVE-GRAPH/`. LOOP_STATE `astra13=BLOCKED`. This pack does not start ASTRA-13 |
| LM06 | YES §5 | ASTRA-08 RESULTS live: `CLASS = LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN`. A09 path is retrieve→proof→rank→pending→reward, not LM06 token out |
| Master F3 10pp | YES §6, heading misnamed | Live F3-R4 RESULTS: `MASTER_F3 = OPEN (10pp/CI/retention not claimed; n=8 compact TB-AXI, not ASTRA-07 24×8)`. Master §8 Transfer is **≥10 percentage points** over no-update, paired CI>0, retention ≤5pp drop — **not** “10 packed pages.” MISSING heading says “10 packed pages”; RESULTS.md of **this** pack correctly says `Master F3 10pp/CI`. Gap is still listed OPEN. Terminology P2, not a close |
| ACCEPT_BOARD | YES §7 | Grep `AUDITOR/**/REPORT.md` for `ACCEPT_BOARD`: **zero**. T1400Z Final is ACCEPT_PARTIAL \| REJECT_PROMOTION |

### 5. POLICY.md PROGRAM=NO until frozen production top + ACCEPT_BOARD (hunt 5) — MATCH

POLICY program gate (absolute):

```text
PROGRAM = NO
until ALL of:
  1. ASTRA-13 is the dispatched gate (not this pack)
  2. owner program gate (explicit; board plugged is not it)
  3. WNS >= 0 on THE FROZEN PRODUCTION TOP
  4. auditor ACCEPT_BOARD of that timed bitstream
```

Cites LOOP_STATE `program_gate` string `ASTRA-13_AND_OWNER_AND_WNS_GE_0_ON_FROZEN_PRODUCTION_TOP_AND_AUDITOR_ACCEPT_BOARD`. States this pack does **not** satisfy (1)(2)(3)(4).

Forbidden: `write_bitstream`, JTAG/`xsdb`/`hw_server`/`fpga`/`program_hw*`, COM12, generating a `.bit` for A09 wrap or any other top, editing prior bags, claiming BOARD_PASS / ACCEPT_BOARD / Master ASTRA-11/13 close, programming Gate14/LM06/01R/02M frozen bits.

Owner plugged ≠ authority. JTAG `210319BE776EA` UNTOUCHED. Matches GSTACK_LOOP and T1400Z residual.

### 6. BOARD_PASS overclaim? `.bit` generated this bag? (hunt 6) — NO / NO

This bag listing: ACK, PACK, MISSING, POLICY, SHA256, SHA256_POST, RESULTS, CLOSEOUT, metrics. **No `.bit`. No `vivado.log`. No tcl. No DCP.**

ACK/RESULTS/CLOSEOUT: `BIT=NOT_BUILT`, `write_bitstream=false`, `BOARD_PASS=NOT_CLAIMED`, `PROGRAM=NO`, `COM12=UNTOUCHED`, `ASTRA-13=BLOCKED`, `BOARD=BLOCKED`.

Historical bits in **other** bags remain UNPROGRAMMED (SOC-WRAP `BITSTREAM.txt`; wrap-route `SHA256_BIT.txt`). Pack lists them as comparison, not production, not ACCEPT_BOARD.

A09 wrap bag still DCP-only (`ckpt/synth.dcp`, `ckpt/route.dcp`). No `.bit` there either.

**No BOARD_PASS claim. No bitstream generated by this pack.**

### Persist / handshake (listed, not re-run)

Raw xsim.log markers confirmed for required R4 plus warm/R2/R3/F2R2/F2R5. F2R3 `ASTRA_F2R3_SEM_GUARD_XSIM_PASS` and F2R4 `ASTRA_F2R4_AXI_DRAIN_XSIM_PASS` exist in those logs; PACK did not promote them as this close. XSim / on-chip only. Not DDR. Not NVM. Not BOARD. Master ASTRA-06 remains OPEN (schemaV2 DDR / NVM / QSPI). Honest.

### ACK first / preserve

ACK.json present; `SHA256.txt` lists it first among this-bag files. `write_scope` = new bag only. `preserves` names ASTRA-11-A09, SOC-WRAP*, wrap-route, A09, A10, ASTRA-06-*, F2R-*, F3-*, ASTRA-12-FINAL-SOURCE-FREEZE, ASTRA-12B (not edited; run scripts not rerun). Comparison timing.rpt dates still 02:11:52 and 22:59:22 — **not rewritten**. A09/R4 xsim session times still original. No evidence of prior-bag wipe.

`does_not_close` includes Master ASTRA-09 / ASTRA-11 FULLCHIP / `Master_ASTRA-12_FINAL_SOURCE_FREEZE_as_this_bag` / F3 10pp/CI / ASTRA-06 / LM06 / BOARD_PASS / ASTRA-13 / SoC UART wrap / production_top_identity / write_bitstream.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| WNS from RESULTS.md only | **No.** PACK quotes raw `timing_route.rpt` Design State=Routed. Live MATCH. |
| Wrap-route WNS=+5.733 as this bag | **No.** PACK/POLICY name it a different DUT. Live wrap-route rpt still 02:11:52 WNS=5.733. |
| OOC WNS=+2.283 as implemented | **No.** A10 util_synth Design State=Synthesized, Bonded IOB=0. |
| A09 wrap silently frozen as production top | **No.** UNKNOWN + candidate table + POLICY “not that top.” |
| BOARD_PASS / ACCEPT_BOARD | **Not claimed.** Zero ACCEPT_BOARD in AUDITOR reports. |
| ASTRA-13 started | **No.** No ASTRA-13 bag. POLICY forbids autonomous open. |
| Unique bit / write_bitstream this bag | **No.** BIT=NOT_BUILT. Historical bits labeled UNPROGRAMMED, not adopted. |
| LM06 language | **No.** Listed missing; A08 CLASS unchanged. |
| Master F3 10pp closed | **No.** Listed OPEN. Heading “10 packed pages” is a **misparse** of Master §8 10 **percentage points**, not a close. |
| Hash theatre | **Not found** for overlapping xsim/DUT/bit digests. F2R2 DUT digest real, **wrong freeze-list citation** (A11 freeze omits F2R2; A09/R4 have it). |
| TB-load / one-hot transfer / tautology | N/A for a pack-only bag. A09 wrap still ties `load_v_i=1'b0` (prior T1400Z). This pack did not reopen that DUT. |
| Cheat: edit golden / rerun wipe logs | **Not found.** Cited logs/rpts keep original session stamps. |

**Not OVERCLAIM** of BOARD_PASS / ASTRA-13 / production top. Narrow PASS language (`PASS_NARROW` / `PASS_THIS_GATE_ONLY`) is bounded to the pack unknown.

---

## Logic bugs

None in this pack’s product (markdown + hash list). No DUT compiled. No bitstream. No new RTL.

Residuals (not this-bag FAIL):

1. MISSING.md §6 title “10 packed pages” ≠ Master §8 “10 percentage points.” Body still lists F3 OPEN with CI/retention. RESULTS.md of this pack uses `10pp/CI` correctly.
2. PACK claims F2R2 law DUT hash was copied from ASTRA-11-A09 `SHA256.txt`; that freeze list does not contain `a7ng_astra_f2r2_hs_law.sv`. Hash `5e2f23c3…` matches ASTRA-09 / ASTRA-06-R4 freeze. Provenance footnote only.
3. ACK `does_not_close` names Master ASTRA-12 as `FINAL_SOURCE_FREEZE_as_this_bag` and does not spell Master V1 “unique bit / UART plan.” MISSING/POLICY still leave unique bit, UART, and production-top **explicitly missing**. Not a silent Master ASTRA-12 close.
4. First-recorded SHA of `timing_route.rpt` / `util_synth.rpt` / comparison `io.rpt`/`timing.rpt` / T1400Z REPORT / freeze-list files cannot be re-digested without a shell. Content of those files MATCHES quotes.

---

## This bag vs Master ASTRA-12 / ASTRA-13

Work-order unknown **answered**: a frozen evidence pack exists, with hashes and raw quotes of routed A09 wrap WNS=+1.041, A09 XSim marker, A10 util_synth, R4 sess-reuse marker, persist/handshake logs, and an explicit MISSING list, **without** BOARD_PASS, **without** silently naming a production top.

**Master ASTRA-12** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7: preprogram closure, **unique bit**, current board token/identity/**UART plan**) remains **OPEN**. This pack is evidence classification + gap list. It does **not** produce a unique bit, does **not** freeze board token/UART plan, does **not** freeze production-top identity. Historical `ASTRA-12-FINAL-SOURCE-FREEZE` is a different bag and is also **not** this close (ACK `does_not_close`).

**Master ASTRA-13** FINAL-BOARD-ACCEPTANCE remains **BLOCKED**. PROGRAM=NO. No bitstream from this bag. Board plugged ≠ authority. No ACCEPT_BOARD.

Master ASTRA-09 / ASTRA-11 FULLCHIP-COFIT / ASTRA-06 DDR-NVM / F3 10pp/CI / LM06 / BOARD_PASS remain **OPEN**.

T1400Z residual (do not silent-close ASTRA-11/13; remaining = production top / bitstream policy / board) is **recorded as missing**, not closed.

---

## Verdict per bag: PASS_NARROW

`ASTRA-12-PREPROGRAM-PACK-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: ACK + PACK + MISSING + POLICY + SHA256 of cited evidence; WNS quoted from raw routed `timing_route.rpt`; PRODUCTION_TOP=UNKNOWN explicit; PROGRAM=NO; no `.bit`; no BOARD_PASS; A09 wrap not named production top; UART / bitstream / ASTRA-13 / LM06 / F3 10pp / ACCEPT_BOARD listed missing.

Not PASS (Master ASTRA-12 unique bit + UART plan + board identity; Master ASTRA-13; BOARD_PASS).  
Not FAIL (required artifacts present; raw WNS/markers MATCH live files; overlapping hashes MATCH prior bags; prior bags not rewritten; no program).  
Not OVERCLAIM (BOARD_PASS / ASTRA-13 / production top / unique bit not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared pack-only unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this pack to Master ASTRA-12 unique-bit close, ASTRA-13, BOARD_PASS, `write_bitstream`, or JTAG/COM12. `PRODUCTION_TOP` stays **UNKNOWN** until a later named freeze.
2. Keep PROGRAM=NO until **all** of: ASTRA-13 dispatched, owner program gate, WNS≥0 on **the frozen production top**, auditor ACCEPT_BOARD of that timed bit. Board plugged ≠ authority.
3. Optional wording: MISSING.md “10 packed pages” → Master §8 **10 percentage points** (paired CI>0, retention ≤5pp, ≥5 seeds, shuffled-reward and per-ID controls). Do not treat F3 as closed.
4. Optional provenance: F2R2 law DUT `5e2f23c3…` lives in ASTRA-09 / ASTRA-06-R4 freeze lists, not ASTRA-11-A09 `SHA256.txt`.
5. Parent next residual is **not** silent ASTRA-13. Remaining: freeze a production top (or keep UNKNOWN and stay blocked), UART/pinout on that top, unique bit after WNS≥0 on that top, then ASTRA-13 + owner + ACCEPT_BOARD. Not this pack’s job.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated pre-program **evidence pack**: hashes + raw quotes of A09 wrap routed WNS=+1.041, A09/R4 XSim markers, A10 util_synth, persist/handshake logs, explicit MISSING, POLICY PROGRAM=NO, PRODUCTION_TOP=UNKNOWN, BIT=NOT_BUILT.

`REJECT_PROMOTION` — Master **ASTRA-12** (unique bit / UART plan / board identity), Master **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1430Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-12-PREPROGRAM-PACK-01; Master ASTRA-12 unique-bit / ASTRA-13 OPEN; PRODUCTION_TOP=UNKNOWN; raw A09 wrap WNS=+1.041 from timing_route.rpt Design State=Routed; PROGRAM=NO; BOARD still blocked YES.
