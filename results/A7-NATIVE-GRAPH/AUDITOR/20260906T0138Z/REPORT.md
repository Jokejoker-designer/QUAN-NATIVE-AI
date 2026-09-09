# ASTRA auditor REPORT — 20260906T0138Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
SCOPE      = ASTRA-SOC-RTP-GLUE bag + rtl/board/arty_a7_astra_rtp_soc_top.sv + planted mem
LOOP_STATE = auditor=AUDITOR_NEEDED, soc_rtp_glue=PASS_NARROW_XSIM (pre-graded; rejected below)
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA SoC RTP glue (auditor 20260906T0120Z item 7).

---

## Scope

Read-only. Wrote only this `REPORT.md`. Did not edit `rtl/`. Did not program.

| Object | Path |
|--------|------|
| Bag | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-GLUE/` |
| Wrap | `rtl/board/arty_a7_astra_rtp_soc_top.sv` |
| Planted mem (XSim) | `rtl/native_graph/memory/a7ng_axi_rtp_plant128.sv` |
| Planted mem (wrap) | `rtl/native_graph/memory/a7ng_axi_bram128.sv` (`PLANT_R2_BASE=1`) |
| Raw log | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-GLUE/xsim.log` (not RESULTS.md) |
| Authority | `docs/ASTRA/AUDITOR_BOOT.md`, `GSTACK_LOOP.md`, `LOOP_STATE.json` |
| Prior | `results/A7-NATIVE-GRAPH/AUDITOR/20260906T0120Z/REPORT.md` item 7 |

Hunt: overclaim, cheat, tautology, RESULTS vs raw log, hash theatre, TB-load as retrieval, empty BRAM, wrap vs 09 wrap, WNS if impl, PROGRAM=NO.

Out of bag (cited only where the wrap file forces it): `ASTRA-11-RTP-SOC/` shares wrap SHA `a1f7a063…` and has synth-only util. **No verdict on that bag.**

---

## Evidence re-derived

### What XSim actually elaborated

`xvlog.log` analyzed: pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_rtp_plant128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r1`**, **`tb_astra_soc_rtp_glue`**.

`xelab.log` compiled snapshot `glue`: `a7ng_astra_rtp_pipe_r1_default` + `a7ng_axi_rtp_plant128` + `tb_astra_soc_rtp_glue`.

**Not compiled:** `arty_a7_astra_rtp_soc_top`, `a7ng_astra_rtp_pipe_r2`, `a7ng_axi_bram128`, `uart_rx`/`uart_tx`, MMCM/BUFG.

`run_glue.ps1` file list matches xvlog. TB instantiates `a7ng_astra_rtp_pipe_r1` + `a7ng_axi_rtp_plant128` with `fill_i`. Comment on TB: `UART/MMCM not in this TB`.

### Raw xsim.log (session Sun Sep 6 01:35:08 2026, xsim v2026.1, laptop-Quan)

Do not trust RESULTS.md alone. Banner and CASE lines:

```text
CASE BASE st=0 ans=4 p0=17 p1=34 nc=2 nl=2 nfar=2 nok=2 nerr=0 nto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=1
PASS BASE
CASE EMPTY st=1 ans=0 p0=0 p1=0 nc=0 nl=0 nfar=0 nok=0 nerr=0 nto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=0
PASS EMPTY
ASTRA_SOC_RTP_GLUE_XSIM_PASS
$finish ... tb_astra_soc_rtp_glue.sv Line 122
```

AXI on BASE (non-zero plant, fetch not `load_v`):

| n | AR addr | arid | R data (truncated) | rid |
|---|---------|------|--------------------|-----|
| 1 | `0500a020` | 1 | `...00070000000205040000` | 1 |
| 2 | `05040000` | 1 | `...0000002200000011` (ids 17,34) | 1 |
| 3 | `05022fe0` | 1 | same dir beat | 1 |
| 4 | `05040000` | 1 | same post | 1 |
| 5 | `05800110` | **2** | fact eid=17 rtp-desc-v1 | 2 |
| 6 | `05800220` | **2** | fact eid=34 rtp-desc-v1 | 2 |

EMPTY: dir AR `0500a020` / `05022fe0` return **all-zero**, **no fact AR**, ans is not 4.

`tbl=0` / `nhost=0` printed on both cases. Matches RESULTS table. Marker string matches.

Backup logs in the same bag (`xsim_18544`, `_47636`, `_35264`, 01:31–01:33) are **FAIL BASE** (`st=1 ans=0`). `_35264` shows a **wrong dir pack** (`...000700000002000005040000`, epoch slot shifted) so walker epoch≠7 and never posts. Final 01:35 log uses `DIR_BEAT = {48'd0,16'd7,16'd0,count,4'd0,base}` which matches `a7ng_sparse_dir_axi` fields `[27:0]=post_base`, `[47:32]=count`, `[79:64]=epoch`. Iteration, not a swapped pass log.

### load_from_tb

- `a7ng_astra_rtp_pipe_r1.sv`: `assign load_from_tb_o = 1'b0`.
- `a7ng_astra_rtp_pipe_r2.sv`: same.
- TB checks `tb_load` and fails the case if set. Raw `tbl=0`.
- Engine fill is `eng_load` from **AXI fact beats** (`beat_ok`: RID==2, RRESP OKAY, RLAST, `schema_ver=1`, `rdata[70]`, eid==cand). Not host `load_v` during query.
- `poke_v_i` tied 0 on the walker inside r1.

This is the intended F1 plant-in-memory pattern, **not** a TB-load cheat — **for the r1+plant128 TB only**.

### Plant / BRAM empty?

**XSim mem `a7ng_axi_rtp_plant128`:** not empty when `fill_i=1`. Combinational ROM (`rom_of`) holds DIR/POST/FACT17/FACT34 at the R1/R2 BASE addresses. `fill_i=0` forces zeros (EMPTY control). AXI writes tied off in TB (`awvalid=0`); CAM unused. **This is a case-ROM + 16-deep CAM, not Block RAM.** It will not close auditor item 7’s “BRAM tiles > 0” on its own.

**Wrap mem `a7ng_axi_bram128` `PLANT_R2_BASE=1`:** not empty. `initial` writes 7 words (two dir aliases, POST 17/34, two rtp-desc-v1 facts, extra dir(1)/dir(3) slots). Compact `word_of` remap avoids the INDEX_BASE vs FACT_BASE 8 MB alias trap on a 256-word array. Wrap ties AXI writes off (`awvalid=0`). **This plant is the SoC-side one. It was not in the glue XSim.**

**09 wrap contrast:** `arty_a7_astra09_soc_top` instantiates the **same** `a7ng_axi_bram128` with **default `PLANT_R2_BASE=0`** (all-zero `initial`) + `a7ng_astra09_pipe` `load_v(1'b0)` `freeze_i(1'b1)`. Prior health pass: post-route **0 BRAM tiles**. New wrap’s delta vs 09 is r2 + planted INIT, not a claim that the 09 wrap now fetches.

### WNS / impl / PROGRAM

Glue bag has **no** `timing.rpt`, **no** `TIMING_EXTRACT.txt`, **no** util, **no** bit, **no** xsdb/JTAG log. **WNS = N/A.** Cannot be timing PASS or BOARD_PASS.

`PROGRAM=NO` is consistent in PREREG / RESULTS / CLOSEOUT / `run_glue.ps1` / wrap header / LOOP_STATE `program=false`. COM12 not touched by this auditor.

Out-of-bag (same wrap SHA): `ASTRA-11-RTP-SOC/util_synth.rpt` 2026-09-06 01:37, **Design State = Synthesized**, `arty_a7_astra_rtp_soc_top`, **Block RAM Tile = 2**, LUT 4352, FF 3867. `UTIL_EXTRACT.txt` still `LUT=NA` / `BRAM_TILE=NA` (impl extract empty). **No routed WNS for this wrap in any file this audit opened.** Synth BRAM>0 is existence-adjacent for the wrap INIT; it is **not** this bag’s evidence and **not** ASTRA-13.

### Wrap RTL vs bag contract

Live `arty_a7_astra_rtp_soc_top.sv`:

- Instantiates **`a7ng_astra_rtp_pipe_r2`** (has `n_ar_to_o`; r1 does **not**).
- Instantiates **`a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)`**, not `a7ng_axi_rtp_plant128`.
- **No `fill_i`.** EMPTY as specified in glue PREREG cannot run on the wrap.
- UART + MMCM 100→50 copied from `arty_a7_astra09_soc_top` (MAGIC `8'hA2` vs 09 `8'hA9`; TX_N=16 vs 12). `CLK_HZ=50_000_000`. Pin still `CLK100MHZ` E3 10 ns (XDC cite, not proven here).
- `load_from_tb_o` wired to `tbl` (r2 ties 0). No `freeze_i` (r2 has no SGD).
- Does **not** edit `a7ng_astra09_pipe` / `arty_a7_astra09_soc_top` / LM06 tops.

Glue **PREREG** says the opposite: new top maps **`a7ng_astra_rtp_pipe_r1`** onto **`a7ng_axi_rtp_plant128`**, `fill_i=1` **on the wrap**.

Glue **RESULTS** header: `TOP = arty_a7_astra_rtp_soc_top` and `PIPE = a7ng_astra_rtp_pipe_r1`. Both cannot be the simulated DUT. Raw log is r1+plant128.

r1 cannot be instantiated in the current wrap without a port error (`n_ar_to_o`). PREREG is physically false vs live wrap.

### SHA256 freeze vs live (re-hash)

No `Get-FileHash` in this auditor sandbox. Re-hash is **cross-manifest identity** against other bags that already froze the same paths, plus “was this file in the snapshot?”.

| File | Glue SHA256.txt | Cross-check |
|------|-----------------|-------------|
| `a7ng_astra_rtp_pipe_r1.sv` | `35ad8a172fac50adbb9d04d3c80ae4740b1ac3a862f8e3b76fa3b4d02ed5c056` | identical R1 / R2 / HOP3 — **KEEP** |
| `a7ng_astra09_pipe.sv` | `48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b` | identical 12B / R1 / R2 / TIMING-FIX / ASTRA-11-RTP-SOC — **KEEP** |
| `arty_a7_astra09_soc_top.sv` | `71f4ebe08e846bccda61d182351c8503cceb8ec3d5c24cf7fdd46b38cf014554` | identical TIMING-FIX + ASTRA-11-RTP-SOC — **KEEP** (09 wrap not edited this ticket) |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239739f321f31800037785f399f2178016426230770853905fa` | identical ASTRA-11-RTP-SOC — freeze of the **r2+bram128 wrap**, hashed here **but not XSim’d** |
| `a7ng_axi_rtp_plant128.sv` | `15e45d9dc3e539134886745de175754342c5f4202e3ebd13169da22cee2eb935` | this bag only (XSim mem) |
| TB | `a3576424e5f6d714eb1e11ac347c8517c2be2beb1340850e6945afdf15cfd026` | this bag only |

**Missing from glue SHA256.txt** even though the hashed wrap depends on them:

- `a7ng_astra_rtp_pipe_r2.sv` (`3d27091d…` in R2 + ASTRA-11-RTP-SOC)
- `a7ng_axi_bram128.sv` (`6e254828…` in ASTRA-11-RTP-SOC)

Hashing the wrap without hashing r2/bram128 is incomplete freeze. Hashing the wrap in a bag whose xelab never compiled it is **hash theatre**.

---

## Overclaim / cheat / tautology

1. **OVERCLAIM: RESULTS/CLOSEOUT treat the wrap as the DUT.**  
   RESULTS `TOP = arty_a7_astra_rtp_soc_top`. CLOSEOUT: “New top + planted AXI”. Raw snapshot is `tb` + r1 + `plant128`. “Not claimed: UART/MMCM unisim of the new top” does **not** excuse naming a top that was never elaborated. Item 7 was map RTP **fetch into the wrap**. This bag XSim’d a TB sibling.

2. **OVERCLAIM vs 09 wrap.**  
   Honest slice in RESULTS: `a7ng_astra09_pipe` still `load_v`-only on the **old** wrap. Forbidden: reading glue PASS as “ASTRA-11 09 wrap now has a filled exam path”, or as 50 MHz **board** close of either wrap. 09 wrap still empty-init BRAM + `freeze_i=1`. New wrap is a **new** top (MAGIC `A2`); it is not a silent retarget of the frozen 09 bit.

3. **PREREG vs live wrap mismatch (contract fail, not a log lie).**  
   PREREG: r1 + `plant128` + `fill_i=1` on the wrap. Live wrap: r2 + `axi_bram128` plant, no `fill_i`. Two implementer stories share one filename (`arty_a7_astra_rtp_soc_top.sv`).

4. **LOOP_STATE / PROJECT_PATHS / ACCEPTANCE pre-grade.**  
   `LOOP_STATE.soc_rtp_glue=PASS_NARROW_XSIM` (updated 01:36, after xsim 01:35, **before** this auditor). `PROJECT_PATHS.md` already lists glue PASS_NARROW. `ACCEPTANCE_INDEPENDENT_20260905.md` parent note: “New top + `a7ng_axi_rtp_plant128`” as if connected. GSTACK: implementer does not self-grade promotion. Parent must not take ASTRA-13 from this label.

5. **Not a load_v cheat; not ID-one-hot-as-transfer; not LM06 language; not BOARD_PASS.**  
   BASE is the same planted 17/34 → ans=4 world as RTP-R1/R2. Expect is independently specified in TB (not copied from DUT score). EMPTY is a real negative control (`fill_i` gates ROM; TB fails if `ans===4 && st===0`). EMPTY is **weak** (any non-4/st0 passes) but not the F2 `ctrl0=ctrl1=17` tautology.

6. **plant128 EMPTY vs CAM.**  
   `r_lookup = fill_i ? rom_of : 0` then CAM can overwrite **even when `fill_i=0`**. TB does not write, so the logged EMPTY is valid. Do not reuse this mem as a writable slave and still claim EMPTY.

7. **Replay risk.**  
   r1+plant128 BASE is the R1 BASE exam with a ROM instead of the R1 TB mem model. That is **narrow glue of fetch-to-AXI-ROM**, not a new SoC/UART/MMCM/BRAM-tile fact.

---

## Logic bugs

1. **Wrap never XSim’d.** UART FIFO/fire/TX, MMCM lock/POR, r2 `narto`, and `axi_bram128` `word_of` compact map are untested in this bag. Default `word_of` for unmapped addrs (`{1'b1,a[10:4]}`) can alias into the 256-word space; BASE only hits mapped slots.

2. **Two plants, two pipes.** Board-facing plant is `axi_bram128` INIT (synth-friendly, sibling synth 2 tiles). Lab plant is combo ROM `plant128` (will not prove BRAM tiles). Shipping both without one TB that instantiates the wrap (or wrap-equivalent r2+bram128) leaves item 7 open.

3. **`fill_i` is not a wrap pin.** EMPTY cannot be reproduced on silicon without a different empty-index mechanism. Do not PREREG wrap EMPTY.

4. **r1 has no AR-ready timeout** (r2 adds it). Wrap correctly picked r2 for a SoC path; glue TB picked r1. Do not retarget r1.

5. **No impl WNS** for the new top. Timing-fix WNS=7.179 was the **09** wrap at 50 MHz, empty BRAM. Do not inherit that number onto this top.

---

## Verdict per bag

| Object | Verdict | Why |
|--------|---------|-----|
| ASTRA-SOC-RTP-GLUE **as SoC exam path / wrap proven** | **OVERCLAIM** | DUT in RESULTS ≠ DUT in xvlog/xelab/xsim.log; wrap is r2+bram128; no impl WNS; 09 wrap not upgraded |
| ASTRA-SOC-RTP-GLUE **as r1 + plant128 XSim only** | **PASS_NARROW** *if RESULTS is rewritten* | Raw `ASTRA_SOC_RTP_GLUE_XSIM_PASS`; BASE 4/17/34 nload=2 tbl=0; EMPTY not ans=4; AXI beats real; not board, not BRAM tiles, not UART |
| Wrap RTL plant empty? | **NO** (INIT non-empty) | `PLANT_R2_BASE=1`; not proven by this XSim |
| load_from_tb | **0** | r1/r2 assign 0; raw tbl=0 |
| PROGRAM / BOARD_PASS | **NO** | no bit, no JTAG log, no WNS |
| 09 wrap / 09 pipe | **KEEP / not this close** | hashes match freeze; still load_v-only + empty default BRAM |

**Bag headline: OVERCLAIM.**

LOOP_STATE `soc_rtp_glue=PASS_NARROW_XSIM` is **not accepted** as wrap/SoC close. `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT` stay.

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO. COM12 / JTAG `210319BE776EA` untouched.

1. **Strip wrap-as-DUT from glue RESULTS/CLOSEOUT/PROJECT_PATHS/ACCEPTANCE/LOOP_STATE.** Allowed remaining sentence: *r1 + `a7ng_axi_rtp_plant128` XSim BASE/EMPTY, tbl=0, not wrap, not BRAM, not UART.* Or delete the SoC-exam claim.

2. **One pipe, one mem, one TB.** Either:
   - **Wrap path (item 7 remaining):** XSim `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128` `PLANT_R2_BASE=1` (same instances as the wrap), expect BASE 4/17/34 tbl=0; **then** synth+impl the wrap; record **WNS at 50 MHz pipe clk** and **Block RAM Tile > 0** from **routed** util (not synth-only, not 09 timing-fix numbers). Or instantiate the wrap in a harness if MMCM unisim is in scope — do not claim UART until that harness exists.
   - **Do not** put combo-ROM `plant128` on the Arty top and call it BRAM existence.

3. **Hash hygiene:** SHA256 of the **actual** snapshot. Wrap bag must list r2 + `a7ng_axi_bram128` + wrap + 09 KEEP files. Glue-if-kept must not list the wrap unless xvlog compiled it. Live `Get-FileHash` vs SHA256.txt before RESULTS.

4. **PREREG rewrite** to match live wrap (r2, bram128 plant, no `fill_i`) or change the wrap to match PREREG — not both stories on one filename. r1 cannot plug into the current wrap ports.

5. **EMPTY:** keep as TB `fill_i` on `plant128` only. For wrap/bram, define a real empty mechanism or drop EMPTY from the wrap contract.

6. **Never map this bag to ASTRA-13 / BOARD_PASS / 100 MHz / LM06 / F2 / 09-wrap fetch.** 09 wrap stays frozen empty-store co-fit.

7. **LOOP_STATE:** `soc_rtp_glue=OVERCLAIM` (or `PASS_NARROW_XSIM_R1_PLANT_NOT_WRAP`). Keep `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`. `unblocked_item` = implementer to fix (2)+(3), **not** board.

8. **Do not program COM12.** Existing bits stay UNPROGRAMMED until ASTRA-13 + owner + routed WNS≥0 **and** auditor ACCEPT **board**.

---

## Final

**REJECT_PROMOTION**

Raw xsim.log is not fake; the SoC/wrap promotion is. Not **FAIL_LOOP**. Not **ACCEPT_PARTIAL** for ASTRA-13 or wrap timing.

```text
Final              = REJECT_PROMOTION
Bag                = OVERCLAIM (SoC wrap) / PASS_NARROW only if relabeled r1+plant128 XSim
FAIL_LOOP          = NO
PROGRAM            = NO
COM12              = UNTOUCHED
JTAG               = 210319BE776EA UNTOUCHED
RTL_EDIT           = NO
```
