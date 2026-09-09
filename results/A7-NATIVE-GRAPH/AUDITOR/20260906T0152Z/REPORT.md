# ASTRA auditor REPORT — 20260906T0152Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
SCOPE      = results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-XSIM/
LOOP_STATE = auditor=IN_PROGRESS, soc_rtp_wrap_xsim=PENDING_AUDITOR, astra13=BLOCKED, program=false
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA wrap-equivalent RTP XSim (auditor 20260906T0138Z item 2 / 20260905T1841Z wrap path).

---

## Scope

Read-only. Wrote only this `REPORT.md`. Did not edit `rtl/`. Did not program. Did not touch COM12 / JTAG `210319BE776EA`.

| Object | Path |
|--------|------|
| Bag | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-XSIM/` |
| Raw XSim | `xsim.log` (not RESULTS.md) |
| xvlog / xelab | `xsim_work/xvlog.log`, `xsim_work/xelab.log` |
| Freeze | `SHA256.txt` (before xvlog), `SHA256_SYNTH.txt` (before synth) |
| Synth util | `util_synth.rpt`, `UTIL_EXTRACT_SYNTH.txt`, `vivado_synth.log` |
| TB | `tb_astra_soc_rtp_wrap.sv` |
| Wrap (synth only) | `rtl/board/arty_a7_astra_rtp_soc_top.sv` |
| Authority | `docs/ASTRA/AUDITOR_BOOT.md`, `GSTACK_LOOP.md`, `LOOP_STATE.json` |
| Prior | `AUDITOR/20260906T0120Z`, `20260906T0138Z`, `20260905T1841Z` |

Hunt: overclaim, cheat, tautology, RESULTS vs raw log, hash theatre, TB-load as retrieval, empty BRAM, r1+plant128 vs r2+axi_bram128, synth BRAM tiles, tbl=0, BOARD_PASS without WNS≥0 **and** JTAG program log.

Out of bag (cited only as identity/residual): glue `ASTRA-SOC-RTP-GLUE/` (must stay stripped), `ASTRA-11-RTP-SOC/` sibling synth of the same wrap SHA.

---

## Evidence re-derived

### What xvlog / xelab actually compiled

`xvlog.log` analyzed, in order: pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_bram128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r2`**, **`tb_astra_soc_rtp_wrap`**.

`xelab.log` snapshot `wrapxsim`: `a7ng_astra_rtp_pipe_r2_default` + `a7ng_axi_bram128_default` + `tb_astra_soc_rtp_wrap`.

`xsim.dir/work` has `a7ng_astra_rtp_pipe_r2.sdb` and `a7ng_axi_bram128.sdb`. **No** `a7ng_astra_rtp_pipe_r1.sdb`, **no** `a7ng_axi_rtp_plant128.sdb`, **no** wrap-top sdb.

`xsim_work/` grep for `r1` / `plant128` / `arty_a7_astra_rtp_soc_top`: **no matches**.

`run_wrap_xsim.ps1` file list matches xvlog.

**Not compiled in this XSim:** `arty_a7_astra_rtp_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`, `uart_rx` / `uart_tx`, MMCM/BUFG.

This is the parent-allowed **wrap-equivalent** DUT (r2 + `a7ng_axi_bram128` `PLANT_R2_BASE=1`), **not** the glue DUT (r1 + plant128), **not** the wrap module.

TB instantiates the same r2 / BRAM parameters as wrap `u_pipe` / `u_sram` (`N_EDGES=16`, `ID_W=20`, `CAND_CAP=16`, `INDEX_BASE=28'h0500_0000`, `FACT_BASE=28'h0580_0000`, `DEPTH_WORDS=256`, `PLANT_R2_BASE=1'b1`). CLK 20 ns = 50 MHz pipe domain. AXI writes tied off. Comment: `UART/MMCM not in this TB`.

EMPTY is a **second** `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b0)` with `arvalid && !fill`. Wrap has no `fill_i`. PREREG states this. Not combo-ROM plant128.

xelab printed only `a7ng_axi_bram128_default` once. BASE returned planted beats and EMPTY returned zeros, so both parameter values elaborated. Not a fail.

`xsimcrash.log` is empty. `$finish` at TB line 166 matches live TB.

### Raw xsim.log (session Sun Sep 6 01:50:14–01:50:15 2026, xsim v2026.1, laptop-Quan)

Do not trust RESULTS.md alone. Banner and CASE lines:

```text
CASE BASE st=0 ans=4 p0=17 p1=34 nc=2 nl=2 nfar=2 nok=2 nerr=0 nto=0 narto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=1
PASS BASE
CASE EMPTY st=1 ans=0 p0=0 p1=0 nc=0 nl=0 nfar=0 nok=0 nerr=0 nto=0 narto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=0
PASS EMPTY
ASTRA_SOC_RTP_WRAP_XSIM_PASS
$finish ... tb_astra_soc_rtp_wrap.sv Line 166
```

Matches RESULTS table and marker. `tbl=0` / `nhost=0` on both cases. `narto` present (r2 port; r1 has no `n_ar_to_o`).

AXI on BASE (non-zero plant, fetch not `load_v`):

| n | AR addr | arid | R data (truncated) | rid |
|---|---------|------|--------------------|-----|
| 1 | `500a020` | 1 | `...00070000000205040000` (epoch=7, count=2, post=`05040000`) | 1 |
| 2 | `5040000` | 1 | `...0000002200000011` (ids 17,34) | 1 |
| 3 | `5022fe0` | 1 | same dir beat | 1 |
| 4 | `5040000` | 1 | same post | 1 |
| 5 | `5800110` | **2** | fact eid=17 rtp-desc-v1 schema=1 | 2 |
| 6 | `5800220` | **2** | fact eid=34 rtp-desc-v1 schema=1 | 2 |

Beats match `a7ng_axi_bram128` `r2_dir_pack` / `{96'd0,32'd34,32'd17}` / `r2_fact_pack` at `word_of` slots 0–4.

EMPTY: dir AR `500a020` / `5022fe0` return **all-zero**, **no fact AR**, ans is not 4.

### load_from_tb / freeze_i / plant empty?

- `a7ng_astra_rtp_pipe_r2.sv`: `assign load_from_tb_o = 1'b0`. No `freeze_i` (r2 has no SGD).
- TB fails the case if `tb_load`. Raw `tbl=0`.
- `poke_v_i` tied 0 on the walker inside r2.
- Engine fill is `eng_load` from **AXI fact beats** (`beat_ok`: RID==2, RRESP OKAY, RLAST, `rdata[75:72]==VER=1`, `rdata[70]`, eid==cand). Not host `load_v` during query.
- `n_host_any_o` printed 0.

This is the intended F1 plant-in-memory pattern for **r2 + axi_bram128**, not a TB-load cheat.

**XSim mem:** `PLANT_R2_BASE=1` INIT is not empty (7 words: two dir aliases, POST 17/34, two rtp-desc-v1 facts, extra dir slots). `PLANT_R2_BASE=0` INIT is all-zero. Compact `word_of` remap avoids INDEX_BASE vs FACT_BASE 8 MB alias on a 256-word array. Writes tied off.

**Wrap mem (synth, not this XSim):** same `u_sram` `.PLANT_R2_BASE(1'b1)`. Not empty INIT.

**09 wrap contrast:** still default `PLANT_R2_BASE=0` + `a7ng_astra09_pipe` `load_v(1'b0)` `freeze_i(1'b1)`. This bag does not upgrade the 09 wrap.

### Synth util BRAM tiles

`run_synth.tcl` top `arty_a7_astra_rtp_soc_top`, part `xc7a100tcsg324-1`. `vivado_synth.log`: `synth_design -top arty_a7_astra_rtp_soc_top` synthesizing **`a7ng_astra_rtp_pipe_r2`** then **`a7ng_axi_bram128`**. **Not** r1, **not** plant128. `WRAP_XSIM_SYNTH_DONE`. No bitstream. No xsdb. Impl not run.

`util_synth.rpt` 2026-09-06 01:52:21, **Design State = Synthesized**, design `arty_a7_astra_rtp_soc_top`:

- Slice LUTs = **4352**
- Slice Registers = **3867**
- **Block RAM Tile = 2** (2× RAMB36E1)
- DSPs = **0**
- MMCME2_ADV = 1, BUFGCTRL = 1 (wrap MMCM present in netlist; **not** XSim’d)

Final mapping in `vivado_synth.log`:

```text
|u_sram      | mem_reg    | 256 x 128(READ_FIRST)  | ... | 0 RAMB18 | 2 RAMB36 |
```

`UTIL_EXTRACT_SYNTH.txt` matches: `LUT=4352 FF=3867 BRAM_TILE=2 DSP=0 DESIGN_STATE=Synthesized PROGRAM=NO`.

`cbuf_reg` (r2) and wrap UART `fifo_reg` were **not** inferred as BRAM (Synth 8-4767 → registers). The 2 tiles are `u_sram/mem_reg`, not token FIFO.

**WNS = N/A.** No `timing.rpt`, no `TIMING_EXTRACT.txt`, no impl DCP, no `.bit`. Cannot be timing PASS or BOARD_PASS. Synth BRAM>0 is existence-adjacent for the wrap INIT; it is **not** post-route survival (Vivado’s own note: some BRAMs may be reimplemented later). Do not inherit 09 timing-fix WNS=7.179 (that is `arty_a7_astra09_soc_top`, empty BRAM, DSP=2).

Sibling `ASTRA-11-RTP-SOC/UTIL_EXTRACT_SYNTH.txt` also `BRAM_TILE=2 FF=3867 DSP=0` (LUT extract NA there). Same wrap SHA. Corroboration only; that bag still has no RESULTS and no routed WNS.

### SHA256 freeze vs live (re-hash)

This auditor sandbox has no `Get-FileHash` tool. Re-hash is **cross-manifest identity** of every freeze line against other bags + **SHA256.txt ∩ SHA256_SYNTH.txt** (same 9 RTL paths hashed twice: 01:50:09 before xvlog, 01:50:40 before synth). Order is not hash-after-scores: SHA stamp 01:50:09, xsim 01:50:14–01:50:15, synth SHA 01:50:40, util 01:52:21.

XSim freeze (`SHA256.txt`) lists **exactly** the xvlog file list (honest vs glue’s wrap-hash-theatre). Wrap top is **not** in `SHA256.txt` because xvlog did not compile it; it **is** in `SHA256_SYNTH.txt` because synth did.

| File | This bag SHA256.txt / SYNTH | Cross-check |
|------|-----------------------------|-------------|
| `a7ng_astra_rtp_pipe_r2.sv` | `3d27091d64ff7782…` both freezes | identical R2 + ASTRA-11-RTP-SOC — **KEEP** |
| `a7ng_axi_bram128.sv` | `6e25482890d69df9…` both | identical ASTRA-11-RTP-SOC — **KEEP** (planted `PLANT_R2_BASE`) |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239…` **SYNTH only** | identical ASTRA-11-RTP-SOC + glue freeze of wrap file — **MATCH**; not xvlog’d |
| `a7ng_query_struct_extract.sv` | `ede064f0c2a5c956…` both | identical 12B / 09-SPARSE / R1 — **KEEP** |
| `a7ng_query_role_extract.sv` | `cd7baf49bb433220…` both | identical 12B / R1 — **KEEP** |
| `a7ng_route_valid_gate.sv` | `49a66da21dc075d1…` both | identical 12B / ASTRA-01 — **KEEP** |
| `a7ng_sparse_dir_axi.sv` | `09334e42c3913d4d…` both | identical 12B / R1 — **KEEP** |
| `a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b…` both | identical 12B / R1 / 09-SPARSE — **KEEP** |
| `a7ng_rel_engine_2hop.sv` | `47e8a27f12f55e39…` both | identical 12B / R1 / 05 — **KEEP** |
| `a7ng_pkg.sv` | `7cf9885217562c8e…` both | overlap MATCH (no second-bag witness in this search) |
| TB | `9a69feafb1bd2ded…` XSim only | this bag only; `$finish` line 166 matches raw log |
| `constraints/arty_a7_100.xdc` | `1c12e6f8943261c7…` SYNTH | identical TIMING-FIX + ASTRA-11-RTP-SOC — **KEEP** |
| `uart_rx.sv` / `uart_tx.sv` | `8e802d0b…` / `b4b7d097…` SYNTH only | **no second-bag witness**; synth compiled them; **not** xvlog’d |
| `a7ng_astra09_pipe.sv` | **not hashed in this bag** | RESULTS KEEP cite `48c9e480…` still identical 12B / R2 / TIMING-FIX / RTP-SOC — **KEEP**, hygiene gap |
| `arty_a7_astra09_soc_top.sv` | **not hashed in this bag** | RESULTS KEEP cite `71f4ebe0…` still identical TIMING-FIX / RTP-SOC — **KEEP**, hygiene gap |

No DUT drift vs R2 / ASTRA-11-RTP-SOC freezes. Not hash theatre of the XSim snapshot. KEEP of 09 files is cross-manifest, not this bag’s freeze list.

### Glue bag left stripped?

Glue `xvlog.log` still analyzes **`a7ng_axi_rtp_plant128`** + **`a7ng_astra_rtp_pipe_r1`** + `tb_astra_soc_rtp_glue`. Wrap was **not** restored as that DUT.

Glue **RESULTS** header is now honest (`DUT_XSIM = r1 + plant128 (NOT the SoC wrap)`). Glue **CLOSEOUT.md** still says `New top + planted AXI` — leftover overclaim, **not** this bag.

LOOP_STATE `soc_rtp_wrap_xsim=PENDING_AUDITOR` (not pre-graded PASS). `docs/ASTRA/` has no other WRAP-XSIM PASS stamp.

`PROGRAM=NO` consistent in PREREG / RESULTS / CLOSEOUT / run scripts / wrap header / LOOP_STATE `program=false`. No `.bit`, no xsdb, no program log in this bag. `BOARD_PASS = NO` is written and is true.

---

## Overclaim / cheat / tautology

1. **Not OVERCLAIM of wrap-top XSim.** RESULTS line 5: `DUT_XSIM = a7ng_astra_rtp_pipe_r2 + a7ng_axi_bram128 (NOT arty_a7_astra_rtp_soc_top)`. PREREG says wrap-equivalent. CLOSEOUT says r2+bram128, synth BRAM not routed. 1841Z required exactly this RESULTS wording. **Forbidden:** reading this bag as UART/MMCM/FIFO/fire/TX of `arty_a7_astra_rtp_soc_top`, or as 09-wrap fetch.

2. **Not a load_v cheat; not ID-one-hot-as-transfer; not LM06 language; not BOARD_PASS.** BASE is the same planted 17/34 → ans=4 world as RTP-R1/R2. TB expect is hardcoded (`st===0`, `ans===4`, `p0===17`, `p1===34`, `nload===2`), not copied from DUT score. `beat_ok` is real AXI. EMPTY is a real negative control (zero INIT; TB fails if `ans===4 && st===0`). EMPTY is **weak** (any non-4/st0 passes) but not the F2 `ctrl0=ctrl1=17` tautology.

3. **EMPTY is a TB mux, not a wrap pin.** Do not cite EMPTY as silicon empty-index. Wrap cannot run this EMPTY without a new mechanism.

4. **Synth BRAM=2 is not routed WNS and not BOARD_PASS.** RESULTS already says Design State=Synthesized, WNS=N/A, BOARD_PASS=NO. **Forbidden:** mapping this to ASTRA-13, 100 MHz close, TIMING-FIX WNS=7.179, or JTAG program.

5. **Replay risk (narrow, admitted).** BASE is the R2 BASE exam with `axi_bram128` INIT instead of the R2 TB mem model. That is **narrow glue of fetch-to-planted-BRAM**, plus synth proof the wrap INIT infers 2 tiles. It is not a new UART/MMCM/board fact.

6. **Glue CLOSEOUT leftover (out of bag).** Glue RESULTS stripped wrap-as-DUT; glue CLOSEOUT still `New top + planted AXI`. Do not let that sentence ride this PASS_NARROW.

7. **Bag name WRAP-XSIM** can be misread. Authority is RESULTS `DUT_XSIM`, not the directory name.

8. **No LOOP_STATE self-grade of this bag.** `soc_rtp_wrap_xsim=PENDING_AUDITOR`. Marker `ASTRA_SOC_RTP_WRAP_XSIM_PASS` is the TB string, not promotion.

---

## Logic bugs

1. **Wrap module still un-XSim’d.** UART FIFO/fire/TX, MMCM lock/POR, wrap `tbl` packing into MAGIC `A2` frame, and `word_of` default alias are untested in this bag. Item 7’s “fetch into the wrap” is proven for **pipe+BRAM instances**, not for the SoC top ports.

2. **No impl WNS** for `arty_a7_astra_rtp_soc_top`. Synth-only. 1841Z remainder (route + post-route BRAM>0 + WNS at 50 MHz pipe clk) is still open. Parent PREREG said impl optional; that does not close timing.

3. **`word_of` default** `{1'b1, a[10:4]}` can alias in 256 words. BASE only hits mapped slots (DIR0/DIR2/POST/F17/F34/DIR1/DIR3). Unmapped AR untested.

4. **EMPTY cannot be reproduced on silicon** without a different empty-index mechanism. Do not PREREG wrap EMPTY.

5. **DSP=0** on this wrap (no SGD). 09 timing-fix had DSP=2. Do not mix util/timing numbers across tops.

6. **Synth 8-7052:** `u_sram/mem_reg_0/1` have no optional output register. Timing risk at route; not a sim fail.

7. **09 pipe / 09 wrap KEEP not hashed in this bag.** Cross-manifest still MATCH. Hygiene only; files were not in xvlog or synth file lists.

---

## Verdict per bag

| Object | Verdict | Why |
|--------|---------|-----|
| ASTRA-SOC-RTP-WRAP-XSIM **as wrap-equivalent r2 + `a7ng_axi_bram128` XSim** | **PASS_NARROW** | Raw `ASTRA_SOC_RTP_WRAP_XSIM_PASS`; xvlog/xelab **r2 + axi_bram128**, **not** r1+plant128, **not** wrap top; BASE 4/17/34 nload=2 **tbl=0**; EMPTY not ans=4; AXI beats match plant INIT |
| ASTRA-SOC-RTP-WRAP-XSIM **as wrap-top UART/MMCM XSim** | **not claimed / not proven** | wrap not in xvlog |
| ASTRA-SOC-RTP-WRAP-XSIM **as synth BRAM existence** | **PASS_NARROW** (synth-only) | `u_sram/mem_reg` 256×128 → **2** RAMB36E1; Design State=Synthesized; **not** routed |
| ASTRA-SOC-RTP-WRAP-XSIM **as SoC exam / ASTRA-13 / BOARD_PASS** | **not accepted** | no impl WNS, no bit, no JTAG log, UART untested |
| load_from_tb | **0** | r2 assign 0; raw tbl=0 both cases |
| Plant / BRAM empty? | **NO** (INIT non-empty when `PLANT_R2_BASE=1`) | XSim beats + synth 2 tiles |
| PROGRAM / BOARD_PASS | **NO** | no bit, no xsdb, WNS=N/A |
| Glue bag | **left stripped** (r1+plant128 XSim) | glue xvlog unchanged; wrap not restored as that DUT |
| 09 wrap / 09 pipe | **KEEP / not this close** | cross-manifest `48c9e480…` / `71f4ebe0…`; still load_v-only + empty default BRAM |

**Bag headline: PASS_NARROW.**

LOOP_STATE `soc_rtp_wrap_xsim` may be labeled `PASS_NARROW_R2_BRAM128_XSIM_SYNTH_BRAM2` after parent reads this. It is **not** wrap-UART close, **not** routed WNS, **not** ASTRA-13. Keep `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`.

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO. COM12 / JTAG `210319BE776EA` untouched.

1. **LOOP_STATE:** `soc_rtp_wrap_xsim=PASS_NARROW_R2_BRAM128_XSIM_SYNTH_BRAM2` (or equivalent). Do **not** set wrap-UART / BOARD_PASS / ASTRA-13. Keep `soc_rtp_glue` as stripped r1+plant128 (OVERCLAIM if still labeled wrap). `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`. `unblocked_item` = remaining wrap **route**, **not** board.

2. **Item 7 remainder (if still in queue):** impl+route `arty_a7_astra_rtp_soc_top`; record **WNS at 50 MHz pipe clk** and **post-route Block RAM Tile > 0** from **routed** util (not this synth-only 2, not 09 timing-fix 7.179 / 0 BRAM). Do not put combo-ROM `plant128` on the Arty top.

3. **UART/MMCM:** only if a harness instantiates the wrap (unisim MMCM in scope). Do not claim MAGIC `A2` TX from this bag.

4. **EMPTY:** keep as TB `PLANT_R2_BASE=0` mux only. Do not PREREG wrap EMPTY. Define a real empty-index for silicon or drop it from the wrap contract.

5. **Glue CLOSEOUT rewrite:** delete `New top + planted AXI`. Allowed remaining sentence matches glue RESULTS: *r1 + plant128 XSim, not wrap, not BRAM tiles, not UART.*

6. **Hash hygiene:** optional live `Get-FileHash` vs `SHA256.txt` / `SHA256_SYNTH.txt` (this sandbox could not). If claiming 09 KEEP in this bag, hash those two files. uart_rx/tx have no second-bag witness.

7. **Do not edit** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, r2, or frozen LM06 tops. Do not restore wrap as glue DUT.

8. **Never map this bag to ASTRA-13 / BOARD_PASS / 100 MHz / LM06 / F2 / 09-wrap fetch.** 09 wrap stays frozen empty-store co-fit.

9. **Do not program COM12.** Existing bits stay UNPROGRAMMED until ASTRA-13 + owner + routed WNS≥0 **and** auditor ACCEPT **board**.

---

## Final

**ACCEPT_PARTIAL**

Raw xsim.log is r2 + `a7ng_axi_bram128`, tbl=0, not r1+plant128. Synth BRAM tiles = 2 on the real wrap, not routed. Not **FAIL_LOOP**. Not BOARD_PASS. Promotion of ASTRA-13 / UART / routed timing stays **REJECT**.

```text
Final              = ACCEPT_PARTIAL
Bag                = PASS_NARROW (r2+axi_bram128 XSim + synth BRAM=2; not wrap-top UART; not routed WNS)
Promotion          = REJECT_PROMOTION
FAIL_LOOP          = NO
BOARD_PASS         = NO
PROGRAM            = NO
COM12              = UNTOUCHED
JTAG               = 210319BE776EA UNTOUCHED
RTL_EDIT           = NO
tbl                = 0
DUT_XSIM           = a7ng_astra_rtp_pipe_r2 + a7ng_axi_bram128
NOT_DUT_XSIM       = r1 + plant128 ; arty_a7_astra_rtp_soc_top
BRAM_TILE_SYNTH    = 2
WNS                = N/A
```
