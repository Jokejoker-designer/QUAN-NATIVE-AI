# ASTRA auditor REPORT — 20260906T0215Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
SCOPE      = results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-ROUTE/
LOOP_STATE = auditor=IN_PROGRESS, soc_rtp_wrap_route=PENDING_AUDITOR, astra13=BLOCKED, program=false
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA wrap **impl+route** (auditor 20260906T0152Z item 2 / 1841Z remainder). Next encoder work stays ungated DIFF twin (not S2, not glue).

---

## Scope

Read-only. Wrote only this `REPORT.md`. Did not edit `rtl/`. Did not program. Did not touch COM12 / JTAG `210319BE776EA`. Did not run `xsdb` / `program_hw_*` / Vivado hardware.

| Object | Path |
|--------|------|
| Bag | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-ROUTE/` |
| Raw timing | `timing.rpt` + `TIMING_EXTRACT.txt` (not RESULTS.md) |
| Raw util (routed) | `util.rpt` Design State = Routed + `UTIL_EXTRACT.txt` |
| Raw log | `vivado.log` (session Sun Sep 6 02:09:07–02:12:14 2026) |
| Bit status | `BITSTREAM.txt` `STATUS=UNPROGRAMMED` |
| Freeze | `SHA256.txt` (before synth, stamp 2026-09-06T02:09:06+07) |
| Wrap | `rtl/board/arty_a7_astra_rtp_soc_top.sv` |
| Pipe | `rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r2.sv` |
| Mem | `rtl/native_graph/memory/a7ng_axi_bram128.sv` `.PLANT_R2_BASE(1)` |
| Authority | `docs/ASTRA/AUDITOR_BOOT.md`, `GSTACK_LOOP.md`, `LOOP_STATE.json` |
| Prior | `AUDITOR/20260906T0152Z`, `20260906T0138Z`, `20260906T0120Z`, `20260905T1841Z` |

Hunt: overclaim, cheat, tautology, RESULTS vs raw, hash theatre, TB-load as retrieval, empty BRAM, **09 wrap vs RTP wrap**, WNS/WHS, PROGRAM=NO, BOARD_PASS without WNS≥0 **and** JTAG program log.

Out of bag (identity/residual only): WRAP-XSIM (r2+bram128 XSim + synth BRAM=2), glue (stripped r1+plant128), ASTRA-11-TIMING-FIX (`arty_a7_astra09_soc_top`, WNS=7.179, BRAM Tile=0, DSP=2).

---

## Evidence re-derived

### DUT identity (raw `vivado.log` / `run_impl.tcl`, not RESULTS)

`run_impl.tcl` `set top arty_a7_astra_rtp_soc_top`. File list: pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_bram128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r2`**, uart_rx, uart_tx, **`arty_a7_astra_rtp_soc_top`**, `constraints/arty_a7_100.xdc`.

Forbidden-name abort in tcl: `*astra09*` / `*pipe_r1*` / `*plant128*` → `ASTRA_SOC_RTP_WRAP_ROUTE_ABORTED`. Did not fire. No `FIRST_DIVERGENCE.txt`.

Raw log prints:

```text
DUT_TOP=arty_a7_astra_rtp_soc_top
DUT_PIPE=a7ng_astra_rtp_pipe_r2
DUT_MEM=a7ng_axi_bram128
NOT_DUT=a7ng_astra09_pipe arty_a7_astra09_soc_top a7ng_astra_rtp_pipe_r1 a7ng_axi_rtp_plant128
Command: synth_design -top arty_a7_astra_rtp_soc_top -part xc7a100tcsg324-1
```

Synthesized modules (in order): wrap, MMCME2_BASE, BUFG, uart_rx, uart_tx, **`a7ng_astra_rtp_pipe_r2`**, query/role/gate/sparse/engine, **`a7ng_axi_bram128`**. Then `done synthesizing module 'arty_a7_astra_rtp_soc_top'`.

**Not synthesized:** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`. Those strings appear only in tcl comments / `NOT_DUT` print / forbidden-name check. Post-synth `get_cells *astra09*` guard did not abort.

`timing.rpt` / `util.rpt` / `clocks.rpt` / `drc.rpt` / `io.rpt` Design = **`arty_a7_astra_rtp_soc_top`**, device `xc7a100tcsg324-1` / `7a100t-csg324`.

Live wrap RTL: `module arty_a7_astra_rtp_soc_top`; `u_pipe = a7ng_astra_rtp_pipe_r2`; `u_sram = a7ng_axi_bram128 #(.PLANT_R2_BASE(1'b1), .DEPTH_WORDS(256))`. No `freeze_i` (r2 has no SGD). `load_from_tb_o` wired as `tbl`.

**Not the 09 wrap.** Live `arty_a7_astra09_soc_top.sv` still instantiates `a7ng_astra09_pipe` with **`freeze_i(1'b1)`**, `load_v(1'b0)`, and `a7ng_axi_bram128` **without** `PLANT_R2_BASE` (default `1'b0` = empty INIT). That top was not `read_verilog`'d.

### Route complete

`route_status.rpt`: 5864/5864 fully routed, **0** nets with routing errors. `util.rpt` / `timing.rpt` Design State = **Routed**. `drc.rpt` Design State = Fully Routed. Marker in raw log:

```text
ASTRA_SOC_RTP_WRAP_ROUTE_DONE WNS=5.733 WHS=0.029 WNS50=5.733 BRAM=2 BIT=UNPROGRAMMED PROGRAM=NO
```

Matches `TIMING_EXTRACT.txt` (WNS/WHS/WNS_CLK50U/BRAM/TOP/PIPE/MEM/PROGRAM). No `ASTRA_SOC_RTP_WRAP_ROUTE_*_FAIL`.

### WNS / WHS (raw `timing.rpt`, then extract)

`timing.rpt` 2026-09-06 02:11:52, Design State = Routed:

| Source | WNS (ns) | WHS (ns) | Notes |
|--------|---------:|---------:|-------|
| Design Timing Summary | **5.733** | **0.029** | TNS=0, THS=0, 0 failing endpoints; WPWS=3.000 |
| Intra Clock `clk50u` (20.000 ns = **50.000 MHz**) | **7.150** | **0.029** | 7558 endpoints; TNS=0 |
| Other path group `**async_default**` clk50u→clk50u | **5.733** | 0.705 | recovery/removal, 2592 endpoints |
| Inter Clock Table | empty | empty | no timed 100↔50 datapath group |

Line 144: **`All user specified timing constraints are met.`**

Clock summary: `sys_clk_pin` 10.000 ns / 100 MHz (pin E3); generated `clk50u` 20.000 ns / 50 MHz from `u_mmcm/CLKOUT0`; `clkfb` 10.000 ns. `clocks.rpt` attributes `clk50u` = P,G,A (propagated, generated, auto-derived). `io.rpt`: `CLK100MHZ` site **E3**. `CLOCK_EXTRACT.txt`: `PIN_PERIOD_NS=10.000`, `CLOCK clk50u PERIOD_NS=20.000`.

`TIMING_EXTRACT.txt` (tcl `get_timing_paths` worst, including recovery):

```text
WNS=5.733
WHS=0.029
WNS_CLK50U=5.733
WHS_CLK50U=0.029
ROUTE=COMPLETE
PIPE_CLK=50MHz
PIN_CLK=100MHz_E3_10ns
BRAM_TILE=2
TOP=arty_a7_astra_rtp_soc_top
PIPE=a7ng_astra_rtp_pipe_r2
MEM=a7ng_axi_bram128
PROGRAM=NO
```

TCL `-to clk50u` captured the **async_default recovery** slack (5.733), not the intra-clock datapath WNS (7.150). Both are ≥ 0. Honest worst for the design is **summary WNS=5.733 / WHS=0.029**. Pipe domain is 50 MHz MMCM, not a 100 MHz close.

Worst recovery path (MET): `por_cnt_reg[0]` → `u_pipe/u_eng/er_reg[2][0]/CLR` (async reset recovery, 20 ns req, slack 5.733). Intra hold MET 0.029 on `clk50u`.

**Do not cite ASTRA-11-TIMING-FIX WNS=7.179 / WHS=0.083.** That extract is `arty_a7_astra09_soc_top`, BRAM Tile=0, DSP=2.

Route intermediates in `vivado.log` had WHS=−0.161 then recovered; **final** routed summary is WHS=+0.029. Authority is the routed `timing.rpt`, not intermediate.

`check_timing`: no_clock=0, unconstrained_internal=0, loops=0. `no_input_delay=2` / `no_output_delay=5` (HIGH) on unconstrained board IO — same class as other Arty wraps; not a WNS fail.

### Post-route BRAM tiles > 0 (raw `util.rpt`)

`util.rpt` 2026-09-06 02:11:51, Design = `arty_a7_astra_rtp_soc_top`, **Design State = Routed**:

| Site | Used |
|------|-----:|
| Slice LUTs | **4244** |
| Slice Registers | **3810** |
| **Block RAM Tile** | **2** |
| RAMB36E1 only | **2** |
| RAMB18 | 0 |
| DSPs | **0** |
| MMCME2_ADV | 1 |
| BUFGCTRL | 1 |

`UTIL_EXTRACT.txt` matches: `LUT=4244 FF=3810 BRAM_TILE=2 DSP=0 DESIGN_STATE=Routed PROGRAM=NO`.

Synth mapping in `vivado.log` (preliminary **and** final):

```text
|u_sram      | mem_reg    | 256 x 128(READ_FIRST)  | ... | 0 RAMB18 | 2 RAMB36 |
```

Synth 8-7052 names instances **`u_sram/mem_reg_0`** and **`u_sram/mem_reg_1`**. `drc.rpt` RBOR-1 names the same two RAMB cells. Power opt: `WRITE_MODE attribute of 0 BRAM(s) out of a total of 2 has been updated`. Tiles **survived route** (not WRAP-XSIM synth-only 2; not 09 timing-fix 0).

Synth util this bag: LUT=4352 FF=3867 BRAM=2 DSP=0 Design State=Synthesized — matches WRAP-XSIM `UTIL_EXTRACT_SYNTH.txt` (same wrap, pre-route). Routed counts dropped LUT/FF as expected; BRAM stayed 2.

**Empty BRAM?** No at the tile-existence gate. Wrap instantiates `.PLANT_R2_BASE(1'b1)`. `a7ng_axi_bram128` INIT writes dir/post/fact words 0–6 (17/34 plant) when that param is 1. Default param is 0; 09 wrap leaves it default. Post-route util cannot dump INIT bits; combined evidence is wrap param + INIT code + 2 RAMB36 named `u_sram/mem_reg_*` + WRAP-XSIM AXI beats on the same SHA. Not a proof of UART fetch on silicon.

### Bitstream UNPROGRAMMED (raw)

```text
Command: write_bitstream -force .../ASTRA-SOC-RTP-WRAP-ROUTE/arty_a7_astra_rtp_soc_top.bit
Writing bitstream .../arty_a7_astra_rtp_soc_top.bit...
write_bitstream completed successfully
BITSTREAM_UNPROGRAMMED .../arty_a7_astra_rtp_soc_top.bit
```

`BITSTREAM.txt`:

```text
STATUS=UNPROGRAMMED
FILE=.../arty_a7_astra_rtp_soc_top.bit
PROGRAM=NO
COM12=UNTOUCHED
JTAG=210319BE776EA UNTOUCHED
```

`vivado.log` / `vivado.jou`: **no** `open_hw_manager`, `program_hw_devices`, `xsdb`, COM12, or JTAG `210319BE776EA`. Batch source was only `run_impl.tcl`. File `arty_a7_astra_rtp_soc_top.bit` exists in the bag. `SHA256_BIT.txt` claims `8116fa77…` + `STATUS=UNPROGRAMMED`. That hash file is **not** emitted by `run_impl.tcl` / `run_impl.ps1` (ps1 hashes RTL before synth only). This sandbox has no `Get-FileHash`; live re-hash of the `.bit` is **UNVERIFIED**. Unprogrammed status is taken from `BITSTREAM.txt` + log `BITSTREAM_UNPROGRAMMED` + absence of program commands, not from the extra hash string.

**BOARD_PASS = NO.** Gate is WNS≥0 **and** JTAG program log. This bag has WNS≥0 and **no** program log. RESULTS already writes `BOARD_PASS = NO`; that line is true.

### load_from_tb / freeze_i / plant

- `a7ng_astra_rtp_pipe_r2.sv`: `assign load_from_tb_o = 1'b0`. No `freeze_i`. `poke_v_i` tied 0 on the walker.
- Wrap connects `load_from_tb_o(tbl)` into MAGIC `A2` TX byte[1]. No TB in this bag (impl-only).
- AXI writes on wrap `u_sram` tied off (`awvalid=0`, `wvalid=0`). Read path is pipe AR → BRAM R.
- This bag does **not** re-run XSim. WRAP-XSIM (0152Z PASS_NARROW) remains the fetch proof for r2+bram128, not wrap-top UART.

### SHA256 freeze vs live

`SHA256.txt` stamp **2026-09-06T02:09:06.1578158+07** (ps1, before Vivado). Vivado session **02:09:07–02:12:14**. Not hash-after-scores.

This auditor sandbox cannot execute `Get-FileHash`. Live identity is **cross-manifest** of every freeze line against WRAP-XSIM `SHA256_SYNTH.txt` (audited 20260906T0152Z, freeze 01:50:40) and ASTRA-11-RTP-SOC / TIMING-FIX / 12B KEEP lists.

| File | This bag SHA256.txt | Cross-check |
|------|---------------------|-------------|
| `a7ng_astra_rtp_pipe_r2.sv` | `3d27091d64ff7782…` | identical WRAP-XSIM SYNTH + ASTRA-11-RTP-SOC + R2 bag — **KEEP** |
| `a7ng_axi_bram128.sv` | `6e25482890d69df9…` | identical WRAP-XSIM SYNTH + ASTRA-11-RTP-SOC — **KEEP** (planted param is wrap instance, not file drift) |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239…` | identical WRAP-XSIM SYNTH + ASTRA-11-RTP-SOC + glue wrap freeze — **KEEP** |
| `a7ng_pkg.sv` | `7cf9885217562c8e…` | identical WRAP-XSIM SYNTH |
| QSE / role / gate / sparse_dir / query_axi / rel_engine | same as WRAP-XSIM SYNTH | **KEEP** |
| `uart_rx.sv` / `uart_tx.sv` | `8e802d0b…` / `b4b7d097…` | identical WRAP-XSIM SYNTH (0152Z had no second-bag witness; now this bag matches) |
| `constraints/arty_a7_100.xdc` | `1c12e6f8943261c7…` | identical WRAP-XSIM SYNTH + TIMING-FIX + ASTRA-11-RTP-SOC — **KEEP** |
| `run_impl.tcl` | `d26c7d7ebede546d…` | this bag only (retargeted TIMING-FIX template) |
| `a7ng_astra09_pipe.sv` KEEP_NOT_COMPILED | `48c9e480cbf2f682…` | identical 12B / WRAP-XSIM cite / TIMING-FIX / RTP-SOC — **KEEP, not DUT** |
| `arty_a7_astra09_soc_top.sv` KEEP_NOT_COMPILED | `71f4ebe08e846bcc…` | identical TIMING-FIX / RTP-SOC — **KEEP, not DUT** |

No compiled-DUT drift vs the WRAP-XSIM synth freeze. 09 files hashed as KEEP, not compiled. Not wrap-hash-theatre of a 09 top.

### DRC (not a timing FAIL)

`drc.rpt`: 23 checks. RBOR-1 ×2 (RAMB output regs on `u_sram/mem_reg_0/1`). REQP-1839 ×20 **and** CHECK-3 “rule limit reached” — **at least** 20 RAMB36 async-control warnings (`u_sram/r_addr_reg[*]` async set/reset into ADDRARDADDR). Warning, not WNS fail. Residual for silicon robustness (INIT/read during POR). Not closed in this bag.

---

## Overclaim / cheat / tautology

1. **Not OVERCLAIM of wrap-top identity.** Raw log top is `arty_a7_astra_rtp_soc_top` + r2 + `a7ng_axi_bram128`. Not 09 wrap. RESULTS `NOT_DUT` matches xvlog-equivalent file list.

2. **Not BOARD_PASS.** RESULTS `BOARD_PASS = NO` matches evidence. **Forbidden:** promoting this bag to BOARD_PASS / ASTRA-13 / COM12 program because WNS≥0. JTAG program log is missing.

3. **Not UART MAGIC `A2` capture.** Wrap RTL packs `A2` + ans/p0/p1 on `result_v`. This bag has no UART capture, no wrap-top XSim, no board. RESULTS “Not claimed” is honest.

4. **RESULTS vs TIMING_EXTRACT field mismatch (hygiene, not inflated summary).** RESULTS table `WNS_CLK50U = 7.150` (Intra Clock Table — real in `timing.rpt`). `TIMING_EXTRACT.txt` `WNS_CLK50U=5.733` and RESULTS marker `WNS50=5.733` (tcl worst-to-clk50u = async_default recovery). Design Timing Summary WNS=5.733 is stated correctly in RESULTS. Do not advertise 7.150 as “the” WNS. Not a cheat of MET/FAIL.

5. **Not 09 timing-fix reuse as this close.** Util DSP=0 BRAM=2 vs 09 DSP=2 BRAM=0; different top; different WNS.

6. **Not a load_v / TB-load cheat in this bag.** Impl has no TB. r2 `load_from_tb_o=0`. AXI W tied off.

7. **Not empty-store 09 wrap.** 09 wrap still default `PLANT_R2_BASE=0` + `freeze_i=1`. This bag does not upgrade 09.

8. **SHA256_BIT theatre risk (narrow).** Extra `SHA256_BIT.txt` is not produced by the run scripts. Do not treat `8116fa77` as auditor-rehashed. Bit **file** and UNPROGRAMMED status are independently evidenced.

9. **No LOOP_STATE self-grade of this bag.** `soc_rtp_wrap_route=PENDING_AUDITOR`. Marker `ASTRA_SOC_RTP_WRAP_ROUTE_DONE` is the tcl string, not promotion.

10. **Replay / existence-narrow (admitted).** Route proves the wrap netlist times at 50 MHz with 2 BRAM tiles. It does not prove UART fire→ans=4 on silicon. WRAP-XSIM remains the fetch exam.

---

## Logic bugs

1. **REQP-1839 / RBOR-1:** async reset on BRAM address/control; RAMB output not using built-in regs (Synth 8-7052). STA does not fully analyze those controls. POR/read corruption residual. Not a WNS FAIL.

2. **`word_of` default** `{1'b1, a[10:4]}` can alias in 256 words. Unmapped AR untested on silicon. Same as 0152Z.

3. **Wrap UART/MMCM/FIFO/fire/TX still un-XSim’d as the SoC top.** 0152Z item 3 remains if parent still wants it. This bag is impl+route only.

4. **EMPTY cannot be reproduced on this wrap** (`PLANT_R2_BASE` hardcoded 1; no `fill_i`). Do not PREREG wrap EMPTY.

5. **Unconstrained IO delays** (2 in / 5 out). Board UART timing vs pin delay is not closed as an I/O constraint. Internal 50 MHz is.

6. **`cbuf_reg` / wrap `fifo_reg`:** Synth 8-7137 same-priority set/reset; 8-4767 cbuf in registers not BRAM. Same as WRAP-XSIM synth.

7. **Bit hash not in the freeze script.** Optional hygiene.

---

## Verdict per bag

| Object | Verdict | Why |
|--------|---------|-----|
| ASTRA-SOC-RTP-WRAP-ROUTE **as impl+route of `arty_a7_astra_rtp_soc_top`** | **PASS_NARROW** | raw top = RTP wrap not 09; route 0 errors; summary **WNS=5.733 ≥ 0**, **WHS=0.029 ≥ 0** at **50 MHz `clk50u`**; post-route **BRAM Tile=2** (`u_sram/mem_reg`); bit written |
| Identity vs 09 wrap | **PASS (not 09)** | log/filelist/netlist; 09 KEEP hashed not compiled |
| Post-route BRAM empty? | **NO** (tiles>0; plant param=1) | 2× RAMB36E1 named `u_sram`; not 09 Tile=0 |
| PROGRAM / BOARD_PASS | **NO** | `BITSTREAM.txt` STATUS=UNPROGRAMMED; no JTAG program log |
| UART MAGIC `A2` / wrap-top XSim / ASTRA-13 | **not accepted** | not in this bag |
| RESULTS `WNS_CLK50U=7.150` vs extract `5.733` | **hygiene mismatch** | both numbers exist in `timing.rpt`; summary WNS honest |

**Bag headline: PASS_NARROW.**

LOOP_STATE `soc_rtp_wrap_route` may be labeled `PASS_NARROW_ROUTE_WNS5733_BRAM2_UNPROGRAMMED` after parent reads this. It is **not** BOARD_PASS, **not** ASTRA-13, **not** UART capture, **not** 100 MHz close. Keep `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`.

**This bag must not receive BOARD_PASS.** WNS≥0 is necessary, not sufficient.

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO. COM12 / JTAG `210319BE776EA` untouched.

1. **LOOP_STATE:** `soc_rtp_wrap_route=PASS_NARROW_ROUTE_WNS5733_BRAM2_UNPROGRAMMED` (or equivalent). `soc_rtp_wrap_xsim` stays `PASS_NARROW_R2_BRAM128_XSIM_SYNTH_BRAM2`. `soc_rtp_glue` stays stripped r1+plant128. **`astra13=BLOCKED`**, **`program=false`**, **`final_promotion=REJECT`**. Do **not** set BOARD_PASS.

2. **Do not program COM12 / JTAG `210319BE776EA`.** Existing `arty_a7_astra_rtp_soc_top.bit` stays UNPROGRAMMED until ASTRA-13 + owner + routed WNS≥0 **and** auditor ACCEPT **board** with a JTAG program log. This report is not that ACCEPT.

3. **RESULTS hygiene (optional, same bag, no RTL):** rename table cell so `WNS_CLK50U` matches `TIMING_EXTRACT.txt` (5.733) or cite Intra 7.150 under a different name (`WNS_CLK50U_INTRA`). Keep summary WNS=5.733 as the worst.

4. **Hash hygiene (optional):** hash the `.bit` inside `run_impl.ps1` after `write_bitstream`; live `Get-FileHash` vs `SHA256.txt` (this sandbox could not). Do not treat current `SHA256_BIT.txt` as auditor-verified.

5. **UART/MMCM wrap-top XSim** remains 0152Z item 3 if still in queue — harness must instantiate the wrap (unisim MMCM in scope). Do not claim MAGIC `A2` TX from this route bag.

6. **EMPTY:** keep as TB `PLANT_R2_BASE=0` mux only. Do not PREREG wrap EMPTY.

7. **REQP-1839 / RBOR-1:** not a gate for this PASS_NARROW. If silicon fetch is the next *existence* unknown, consider sync reset on BRAM addr — **do not** mix with programming.

8. **Do not edit** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, r2, frozen LM06 tops. Do not put `plant128` / r1 on this Arty top. Do not restore wrap as glue DUT.

9. **Never map this bag to ASTRA-13 / BOARD_PASS / 100 MHz / LM06 / F2 / 09-wrap fetch / encoder H5.** 09 wrap stays frozen empty-store co-fit (Tile=0, `freeze_i=1`).

10. **unblocked_item:** do **not** invent board work. Parent may idle (`NONE`) or dispatch wrap-top UART XSim. Not program.

---

## Final

**ACCEPT_PARTIAL**

**REJECT_PROMOTION**

Raw `timing.rpt` / `util.rpt` / `vivado.log` / `BITSTREAM.txt` close auditor 20260906T0152Z item 2: wrap top (not 09) routed, WNS=5.733≥0, WHS=0.029≥0 at 50 MHz pipe, post-route BRAM Tile=2, bit UNPROGRAMMED. Not **FAIL_LOOP**. Not BOARD_PASS. Promotion of ASTRA-13 / UART-on-board / JTAG stays **REJECT**.

```text
Final              = ACCEPT_PARTIAL
Bag                = PASS_NARROW (arty_a7_astra_rtp_soc_top route; not 09 wrap; not UART; not BOARD_PASS)
Promotion          = REJECT_PROMOTION
FAIL_LOOP          = NO
BOARD_PASS         = NO
PROGRAM            = NO
COM12              = UNTOUCHED
JTAG               = 210319BE776EA UNTOUCHED
RTL_EDIT           = NO
DUT_IMPL           = arty_a7_astra_rtp_soc_top
PIPE               = a7ng_astra_rtp_pipe_r2
MEM                = a7ng_axi_bram128 PLANT_R2_BASE=1
NOT_DUT            = a7ng_astra09_pipe / arty_a7_astra09_soc_top / r1 / plant128
WNS                = 5.733  (timing.rpt Design Timing Summary; TIMING_EXTRACT)
WHS                = 0.029
WNS_CLK50U_INTRA   = 7.150  (timing.rpt Intra Clock Table only)
WNS_CLK50U_EXTRACT = 5.733  (TIMING_EXTRACT; async_default recovery)
PIPE_CLK           = 50 MHz clk50u (MMCM); pin E3 = 100 MHz 10 ns
BRAM_TILE_ROUTED   = 2
DSP                = 0
ROUTE              = COMPLETE 5864/5864
BIT                = UNPROGRAMMED
```
