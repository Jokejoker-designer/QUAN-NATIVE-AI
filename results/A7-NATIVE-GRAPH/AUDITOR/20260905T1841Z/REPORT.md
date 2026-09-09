# ASTRA auditor REPORT — 20260905T1841Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = auditor=IN_PROGRESS, unblocked_item=AUDITOR_NEEDED, soc_rtp_glue=PASS_NARROW_XSIM (pre-grade; not accepted as wrap close)
PRIOR      = AUDITOR/20260906T0120Z/REPORT.md is STALE vs glue RESULTS 2026-09-06 01:36:13 +07
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA SOC_RTP_GLUE re-derive + remaining 0120Z findings.

---

## Scope

Read-only except this file. Did not edit `rtl/`. Did not program COM12 / JTAG `210319BE776EA`. Did not write V3.1 tree. Did not self-grade BOARD_PASS.

| Object | Path |
|--------|------|
| **Primary** | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-GLUE/` |
| Wrap RTL | `rtl/board/arty_a7_astra_rtp_soc_top.sv` |
| Plant (glue XSim) | `rtl/native_graph/memory/a7ng_axi_rtp_plant128.sv` |
| Plant (wrap) | `rtl/native_graph/memory/a7ng_axi_bram128.sv` |
| R1 DUT | `rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r1.sv` (must stay `35ad8a17`) |
| Timing | `ASTRA-11-TIMING-FIX/`, `ASTRA-11-SOC-WRAP/` |
| Remaining 0120Z | F2, F2T, HOP3, SGD-PERSIST, R1/R2 as needed |
| Concurrent (not parent-closed) | `ASTRA-11-RTP-SOC/`, `ASTRA-SOC-RTP-WRAP-XSIM/` |

Authority: `docs/ASTRA/AUDITOR_BOOT.md`, `GSTACK_LOOP.md`, `LOOP_STATE.json`, `RTP_REVIEW_ACCEPTANCE.md`, `ACCEPTANCE_INDEPENDENT_20260905.md`.

Hunt: overclaim, cheat, tautology, RESULTS vs raw `xsim.log` / `TIMING_EXTRACT.txt`, hash theatre, ID one-hot as transfer, TB-load as retrieval, INIT-plant as DMA, UART/MMCM claimed XSim’d, LM06 language, BOARD_PASS without WNS≥0 **and** JTAG program log.

`AUDITOR/20260906T0138Z/REPORT.md` exists (glue-only). This stamp is the assigned dest and **also** re-checks 0120Z items 1–6 / 10 that glue did not implement.

---

## Evidence re-derived

### ASTRA-SOC-RTP-GLUE — what XSim actually ran

`run_glue.ps1` xvlog list and `xsim_work/xvlog.log` / `xelab.log`:

- compiled: pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_rtp_plant128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r1`**, **`tb_astra_soc_rtp_glue`**
- snapshot `glue`: `a7ng_astra_rtp_pipe_r1_default` + `a7ng_axi_rtp_plant128` + TB
- **not compiled:** `arty_a7_astra_rtp_soc_top`, `a7ng_astra_rtp_pipe_r2`, `a7ng_axi_bram128`, `uart_rx`/`uart_tx`, MMCM/BUFG

TB instantiates r1 + plant128 with `fill_i`. Header: `UART/MMCM not in this TB`. Clock is TB `#(20/2)` (50 MHz period), not unisim MMCM.

### Raw `xsim.log` (not RESULTS.md)

Session **Sun Sep 6 01:35:08–01:35:10 2026**, xsim v2026.1, `laptop-Quan`, `$finish` TB line 122.

```text
CASE BASE st=0 ans=4 p0=17 p1=34 nc=2 nl=2 nfar=2 nok=2 nerr=0 nto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=1
PASS BASE
CASE EMPTY st=1 ans=0 p0=0 p1=0 nc=0 nl=0 nfar=0 nok=0 nerr=0 nto=0 ndir=2 ovf=0 neg=0 amb=0 tbl=0 nhost=0 fill=0
PASS EMPTY
ASTRA_SOC_RTP_GLUE_XSIM_PASS
```

AXI BASE (dir arid=1, facts **arid=2**, matches r1 `beat_ok` RID==2):

| n | AR | arid | R beat |
|---|----|------|--------|
| 1 | `0500a020` | 1 | DIR epoch=7 count=2 post=`05040000` |
| 2 | `05040000` | 1 | POST ids 17,34 |
| 3 | `05022fe0` | 1 | same DIR |
| 4 | `05040000` | 1 | same POST |
| 5 | `05800110` | **2** | FACT17 rtp-desc-v1 |
| 6 | `05800220` | **2** | FACT34 rtp-desc-v1 |

EMPTY: dir AR return **all-zero**, **no fact AR**, `ans` is not 4, `st=1` (r1 `ST_UNKNOWN`). `tbl=0` `nhost=0` both cases.

RESULTS table matches these numbers. Marker string matches. RESULTS timestamp 01:36:13 is after this log (not a swapped older PASS).

Backup logs **01:31–01:33** (`xsim_18544`, `_47636`, `_35264`) are **FAIL BASE** (`st=1 ans=0`). `_35264` DIR pack is field-shifted (`...000700000002000005040000`) so epoch/count do not sit where `a7ng_sparse_dir_axi` reads them. Final plant `DIR_BEAT = 128'h0000_0000_0000_0007_0000_0002_0504_0000` matches the walker. Iteration, not log theatre.

### load_from_tb / freeze_i / fill_i / one-hot

- r1: `assign load_from_tb_o = 1'b0`. Engine load is AXI `beat_ok` (RID==2, RRESP OKAY, RLAST, `rdata[75:72]==1`, `rdata[70]`, eid==cand). `poke_v_i=0`. **Not a TB-load cheat** for this TB.
- r1 has **no** `freeze_i` (no SGD). Wrap has **no** `freeze_i`. 09 wrap still `freeze_i(1'b1)` + `load_v(1'b0)`.
- `fill_i` exists only on `plant128`. Live wrap has **no** `fill_i` pin (grep empty).
- No `qid_oh`/`kid_oh` in native_graph. F2 still `phi[0]=(pmid==1)`, `phi[1]=(pmid==8)` (ID one-hot). Glue path has no ranker phi.

### Wrap RTL vs glue contract

Live `arty_a7_astra_rtp_soc_top.sv`:

- `a7ng_astra_rtp_pipe_r2` (has `n_ar_to_o`; r1 does not — r1 cannot plug into this wrap)
- `a7ng_axi_bram128` `.PLANT_R2_BASE(1'b1)` — INIT 17/34, not `plant128`
- UART + MMCM 100→50, MAGIC `8'hA2`, `CLK_HZ=50_000_000`, pin still `CLK100MHZ`
- AXI writes tied off

Glue **PREREG**: new top maps **r1** onto **plant128**, `fill_i=1` **on the wrap**.

Glue **RESULTS** header: `TOP = arty_a7_astra_rtp_soc_top` **and** `PIPE = a7ng_astra_rtp_pipe_r1`. Those cannot both be the simulated DUT. Raw DUT is r1+plant128.

09 wrap / 09 pipe not edited this bag (hashes below). 09 wrap still empty-default BRAM + frozen SGD.

### WNS / PROGRAM

Glue bag: **no** `timing.rpt`, **no** bit, **no** xsdb. WNS = N/A. `PROGRAM=NO` consistent. Cannot be BOARD_PASS.

**ASTRA-11-SOC-WRAP** `timing.rpt` Design Timing Summary: WNS=**-4.765**, TNS=**-2392.529**, 587 failing / 4034, `Timing constraints are not met.`, clock `sys_clk_pin` 10 ns only. `TIMING_EXTRACT.txt` matches. `util.rpt` **Block RAM Tile = 0**. `BITSTREAM.txt` UNPROGRAMMED.

**ASTRA-11-TIMING-FIX** `timing.rpt`: WNS=**7.179**, TNS=0, WHS=**0.083**, `All user specified timing constraints are met.`, generated `clk50u` 20 ns **50 MHz**. Intra-clock WNS is on `clk50u`, not 100 MHz fabric. `TIMING_EXTRACT.txt` matches. `util.rpt` LUT 3102, FF 1577, **BRAM Tile = 0**, DSP 2. Bit UNPROGRAMMED. This is the **09** top, not the RTP wrap.

**ASTRA-11-RTP-SOC** (same wrap SHA): `synth_design` of `arty_a7_astra_rtp_soc_top` completed; `UTIL_EXTRACT_SYNTH.txt` **BRAM_TILE=2**; `vivado.log` truncated in **place** Phase 3.5; `UTIL_EXTRACT.txt` still `BRAM_TILE=NA`; **no** `timing.rpt`. Backup synth failed `module 'a7ng_astra_rtp_pipe_r1' not found` then wrap was switched to r2. **No routed WNS.**

### Concurrent `ASTRA-SOC-RTP-WRAP-XSIM/` (not parent-closed; no RESULTS.md)

Raw `xsim.log` 01:50:14–01:50:15: `ASTRA_SOC_RTP_WRAP_XSIM_PASS`. xvlog compiled **r2 + `a7ng_axi_bram128` + TB**, **not** `arty_a7_astra_rtp_soc_top`, not UART/MMCM. BASE 4/17/34 tbl=0; EMPTY via **TB mux** of a second `PLANT_R2_BASE=0` instance (wrap has no `fill_i`). SHA256 lists compiled files only (honest vs glue). Synth of the real wrap was in-flight in that bag (`vivado_synth.log` still in cross-boundary opt when sampled). **Does not rewrite glue RESULTS. Does not XSim the wrap module. Does not close UART/MMCM/impl WNS.**

### SHA256 vs live

This subagent dispatched `Get-FileHash` via Shell; **no `tool_started`/`tool_completed` for Shell in session events** (sandbox did not run the hash). Live byte SHA of each file is therefore **not independently re-derived here**. Cross-manifest identity (same path, same digest in multiple freeze lists) plus “was this file in the xvlog snapshot?”:

| File | Glue `SHA256.txt` | Cross-check |
|------|-------------------|-------------|
| `a7ng_astra_rtp_pipe_r1.sv` | `35ad8a172fac50adbb9d04d3c80ae4740b1ac3a862f8e3b76fa3b4d02ed5c056` | identical R1 / R2 / HOP3 — **KEEP** (r1 not retargeted) |
| `a7ng_astra09_pipe.sv` | `48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b` | identical 12B / R1 / R2 / TIMING-FIX / RTP-SOC — **KEEP** |
| `arty_a7_astra09_soc_top.sv` | `71f4ebe08e846bccda61d182351c8503cceb8ec3d5c24cf7fdd46b38cf014554` | identical TIMING-FIX / RTP-SOC — **KEEP** this cycle |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239739f321f31800037785f399f2178016426230770853905fa` | identical RTP-SOC — freeze of **r2+bram128 wrap**, hashed in glue **but not xvlog’d** |
| `a7ng_axi_rtp_plant128.sv` | `15e45d9dc3e539…` | glue only (XSim mem) |
| TB | `a3576424e5f6d7…` | glue only |

Glue SHA256 **omits** wrap dependencies `a7ng_astra_rtp_pipe_r2.sv` (`3d27091d…` in R2 / RTP-SOC / WRAP-XSIM) and `a7ng_axi_bram128.sv` (`6e254828…` in RTP-SOC / WRAP-XSIM vs older wrap-bag `bfd706f0…` before `PLANT_R2_BASE`). Hashing a wrap that xelab never compiled is **hash theatre**.

ASTRA-11-SOC-WRAP freeze of 09 top is still `f8cef9a0…` (100 MHz netlist). Live 09 top digest in TIMING-FIX/glue is `71f4ebe0…` (50 MHz MMCM). **Do not mix wrap bit `C7442D16…` with live 09 source.**

12B freeze SGD `1786bd82…` vs F2 live cite `c6f37a273960a318…` — **still DRIFT**. F2T v1 `c124f39a…` vs persist v1 `01ef4007…` — **still DRIFT** (`load_v_i` / `w_o`). No persist-bag `DRIFT.md`.

TIMING-FIX now **has** `SHA256.txt` (0120Z item 4 partial). HOP3 TB is now hashed; `a7ng_astra_rtp_hop3.sv` still listed **twice**. RTP-0 still has **no** `SHA256.txt`.

### Remaining 0120Z bags — raw logs (unchanged this cycle)

| Bag | Raw banner | RESULTS | Match? |
|-----|------------|---------|--------|
| RTP-0 | `ASTRA_RTP_XSIM_PASS` | PASS_NARROW | YES |
| R1 | `ASTRA_RTP_R1_XSIM_PASS` (11 cases) | PASS_NARROW | YES |
| R2 | `ASTRA_RTP_R2_XSIM_PASS` | PASS_NARROW | YES |
| F2 | `ASTRA_RTP_F2_XSIM_FAIL n=1`; R0 chiller; `DBG w0=0 w1=0 … do_upd=1`; R1 still p0=17; **still prints** `PASS CONTROL_VALIDITY_DOES_NOT_SWITCH` | FAIL reward-switch; RESULTS now says `CONTROL = CHEAT … STRIPPED` | YES on fail; TB cheat **not removed** |
| F2T | `ASTRA_RTP_F2T_XSIM_PASS`; TRAIN0 cls=1; AFTER_REW w0=-6; HOLD p0=33333 cls=2 | PASS_NARROW + added “not 32-φ / paraphrase / LM06” | YES as **narrow** class-byte; FEATURE= still claims hop-1 |
| HOP3 | `ASTRA_RTP_HOP3_XSIM_PASS`; BASE ans=7 p=17,34,51 tbl=0 | PASS_NARROW | YES |
| PERSIST | `ASTRA_SGD_PERSIST_XSIM_PASS`; AFTER_UPD **v=0** w0=6; AFTER_RELOAD **v=3** | PASS_NARROW snapshot | YES vs log; PREREG `v_A==v_B` still not tested |

---

## Overclaim / cheat / tautology

1. **Glue RESULTS `TOP = arty_a7_astra_rtp_soc_top` is OVERCLAIM.** Raw snapshot is TB + r1 + plant128. “Not claimed: UART/MMCM unisim” does not excuse naming a top xvlog never analyzed. Item 7 was map RTP **fetch into the wrap**. This bag XSim’d a TB sibling. CLOSEOUT “New top + planted AXI” and parent ACCEPTANCE “New top + plant128” fuse two artifacts.

2. **Not DMA / not 800k store.** plant128 is combinational `rom_of` + 16-deep CAM. RESULTS “INIT dir+post+rtp-desc-v1” and “Not claimed: Filled 800k store” are honest. Forbidden: “DMA filled store”, “09 wrap now fetches”, inheriting TIMING-FIX WNS=7.179 onto this top.

3. **PREREG vs live wrap (contract split, not a log lie).** PREREG r1+plant128+`fill_i` on wrap. Live wrap r2+bram128, no `fill_i`. RTP-SOC backup log proves the wrap **was** r1 until synth `module r1 not found`, then switched. Two stories, one filename.

4. **LOOP_STATE `soc_rtp_glue=PASS_NARROW_XSIM` is a parent pre-grade** (01:41, before this report). Allowed only as *r1+plant128 XSim*. Forbidden as wrap/SoC/ASTRA-13.

5. **F2 CONTROL cheat — not implemented this cycle.** RESULTS prose now says CHEAT STRIPPED. TB lines 90+109–110 still `ctrl0=17; ctrl1=17; if (ctrl0==ctrl1) PASS CONTROL_VALIDITY_DOES_NOT_SWITCH`. Raw log still prints that PASS. DUT `phi[2]=0` always. **Strip the TB print or implement a real validity-only world.** Reward-switch still FAIL (`do_upd=1`, `w0` stayed 0, DSP SGD).

6. **F2 feature is still ID one-hot** (`pmid==1/8`). Do not back-port as transfer. F2T moved to class byte.

7. **F2T claim lock — partial only.** RESULTS added “not 32-φ / paraphrase / LM06” (good) but `FEATURE=hop1 object CLASS`. DUT `pcls[np] <= fc[ei]` (**hop-0**). TB plants the same class on both edges of a path, so the test cannot distinguish hop-0 vs hop-1. Still 2-way one-hot of a planted `[83:76]` byte on new eids. F4/F5 open. No LM06 language.

8. **Persist PREREG `v_B must equal v_A` still untested.** Log AFTER_UPD **v=0** (no `go_score` after update). TB checks `wo[0]===snap[0] && v!=0`, not v_A==v_B. Register snapshot is real; not DDR/AXI schemaV2.

9. **09 wrap empty-store co-fit unchanged.** `load_v=0`, `freeze_i=1`, default `PLANT_R2_BASE=0`, post-route 0 BRAM tiles. Glue does not upgrade it.

10. **No LM06 language, no BOARD_PASS** in these RESULTS. TIMING-FIX WNS≥0 is **50 MHz pipe domain**, bit UNPROGRAMMED, no JTAG log.

11. **WRAP-XSIM EMPTY is a TB mux**, not a wrap pin. Do not cite it as silicon empty-index. Wrap-equivalent BASE is real r2+planted BRAM XSim; wrap **module** (UART FIFO/fire/TX, MMCM lock/POR) still un-XSim’d.

---

## Logic bugs

1. **DSP SGD update does not land in F2.** Raw `do_upd=1` `xsel0=64` `w0=0` after 200 cycles. v1 SGD **does** move w0 to ±6 (F2T/persist). 09 wrap still instantiates DSP SGD. Timing-fix closed WNS by **downclock**, not Q8 math.

2. **plant128 CAM overrides `fill_i=0`.** `r_lookup = fill_i ? rom_of : 0` then CAM can still hit. TB never writes, so logged EMPTY is valid. Do not reuse as a writable slave and still claim EMPTY.

3. **r1 has no AR-ready timeout** (r2 adds `narto`). Keep r1 frozen; wrap correctly picked r2. Do not retarget r1 (`35ad8a17` KEEP).

4. **09 SoC cannot run the RTP exam** (`eng_load = load_v && IDLE` only; walker IDs never become facts). New wrap is a **new** top (MAGIC A2). Do not inherit 09 timing-fix WNS onto it.

5. **HOP3 last-match wins** (triple loop overwrites `r_ans`). Fine for unique chain; ambiguous 3-hop untested.

6. **Wrap `axi_bram128` `word_of` default** `{1'b1, a[10:4]}` can alias in 256 words. BASE only hits mapped slots. Unmapped AR untested.

7. **12B SGD drift** `c6f37a27…` vs freeze `1786bd82…` remains. Do not quietly retarget 09 pipe SGD / ASTRA-06 law.

---

## Verdict per bag

| Bag | Verdict | Why |
|-----|---------|-----|
| **ASTRA-SOC-RTP-GLUE as SoC exam / wrap proven** | **OVERCLAIM** | RESULTS TOP ≠ xvlog DUT; wrap is r2+bram128; no impl WNS; UART/MMCM not XSim’d |
| **ASTRA-SOC-RTP-GLUE as r1+plant128 XSim** | **PASS_NARROW** *if RESULTS is rewritten* | Raw marker; BASE 4/17/34 nload=2 tbl=0; EMPTY not ans=4; AXI beats real; INIT ROM not BRAM tiles |
| ASTRA-SOC-RTP-WRAP-XSIM | **INCOMPLETE** | Raw wrap-equivalent r2+bram128 XSim PASS; **no RESULTS.md**; wrap top not compiled; synth in flight; EMPTY is TB mux |
| ASTRA-11-RTP-SOC | **INCOMPLETE** | Synth BRAM_TILE=2; place truncated; no routed WNS; no RESULTS |
| ASTRA-RTP-RETRIEVAL-TO-PROOF | **PASS_NARROW** | Unchanged; 8-bit old pack; no SHA256.txt |
| ASTRA-RTP-R1-TRANSPORT-IDENTITY | **PASS_NARROW** | Log matches; r1 hash KEEP |
| ASTRA-RTP-R2-HIGHID-ARTO | **PASS_NARROW** | Log matches; r1 file unchanged |
| ASTRA-RTP-F2-COMPETE-RANK-REWARD | **FAIL** (R0 **PASS_NARROW**; CONTROL **CHEAT** still in TB; reward-switch **FAIL**) | Glue did not close this |
| ASTRA-RTP-F2T-SHARED-TRANSFER | **PASS_NARROW** | Class-byte on new IDs; hop-0 vs hop-1 still unlocked; not 32-φ / language |
| ASTRA-RTP-HOP3 | **PASS_NARROW** | Raw BASE/DROP_LAST/TWO_ONLY/UNREL; SHA still duplicates DUT |
| ASTRA-SGD-PERSIST | **PASS_NARROW** | w snapshot/reload; not v_A==v_B; not DDR |
| ASTRA-11-SOC-WRAP | **PASS_NARROW** | Route real; **WNS=-4.765**; empty BRAM; UNPROGRAMMED |
| ASTRA-11-TIMING-FIX | **PASS_NARROW** | WNS=7.179 **at 50 MHz**; SHA256.txt now present; not 100 MHz; not filled store; not this wrap |

LOOP_STATE `rtp_f2=FAIL`, `rtp_r1/r2/f2t=PASS_NARROW_KEEP`, `hop3/sgd_persist=PASS_NARROW`, `astra11=TIMING_PASS_50MHZ`, `astra08=LM06_NOT_INTEGRATED`, `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT` — **accepted as labels**, except `soc_rtp_glue=PASS_NARROW_XSIM` must not be read as wrap/SoC close.

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO.

1. **Rewrite glue RESULTS/CLOSEOUT.** Allowed: *r1 + `a7ng_axi_rtp_plant128` XSim BASE/EMPTY, tbl=0, not wrap, not BRAM tiles, not UART.* Remove `TOP = arty_a7_astra_rtp_soc_top` as the XSim DUT. Hash only files xvlog compiled.

2. **Do not treat glue as closing 0120Z items 1–6 / 10.** F2 CONTROL TB, F2 reward-switch, F2T hop-0 vs hop-1 lock, persist v_A==v_B, 12B SGD, remaining hash slop are **still open**.

3. **Wrap path (item 7 remainder):** either finish WRAP-XSIM with RESULTS that say **wrap-equivalent r2+bram128**, not wrap UART/MMCM; then **route** the real top and record **WNS at 50 MHz** + **post-route BRAM Tile > 0**. Or instantiate the wrap in a harness if MMCM unisim is in scope. Do not put combo-ROM plant128 on the Arty top and call it BRAM existence. Do not inherit 09 timing-fix numbers.

4. **PREREG one story.** Live wrap is r2 + bram128, no `fill_i`. Either change PREREG or change the wrap — not both on one filename. r1 cannot plug into current wrap ports.

5. **F2 honesty:** delete TB `PASS CONTROL_VALIDITY_DOES_NOT_SWITCH` or implement a real validity-only second query. Do not call F2 PASS. Keep R0 two-proof + min-p0 only.

6. **F2 remainder (if still queued):** prove scalar reward changes **next** selection, or freeze DSP SGD as score-only and use v1 for learn. Do not retarget ASTRA-06 name/law without a new bag.

7. **F2T claim lock:** document 2-class one-hot of planted `[83:76]` on **hop-0** (`fc[ei]`), TB plants same class on both edges. No paraphrase / LM06. F4/F5 open.

8. **Persist:** if claiming v_A==v_B, `go_score` after update before snapshot. Separate bag for AXI/DDR schemaV2.

9. **Hash hygiene remainder:** live `Get-FileHash` vs each SHA256.txt (this auditor’s Shell did not run). Dedup HOP3 DUT line. Record F2T→persist v1 drift in that bag. Optional RTP-0 SHA. 12B SGD `c6f37a27…` stays documented DRIFT.

10. **LOOP_STATE:** `soc_rtp_glue=OVERCLAIM` (or `PASS_NARROW_XSIM_R1_PLANT_NOT_WRAP`). Keep `rtp_f2=FAIL`, `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`. `unblocked_item` = RESULTS rewrite + wrap remaining, **not** board.

11. **Never program COM12 / JTAG `210319BE776EA`** until ASTRA-13 + owner + routed WNS≥0 **and** auditor ACCEPT **board**. Existing bits stay UNPROGRAMMED.

---

## Final

**REJECT_PROMOTION**

Raw glue `xsim.log` is not fake. The SoC/wrap promotion is. Remaining 0120Z FAIL/cheat/lock items are **not** closed by this bag. Not **FAIL_LOOP**. Previously KEEP PASS_NARROW bags stay KEEP; they are not this cycle’s promotion.

```text
Final              = REJECT_PROMOTION
Bag (glue SoC)     = OVERCLAIM
Bag (glue XSim)    = PASS_NARROW only if relabeled r1+plant128
FAIL_LOOP          = NO
PROGRAM            = NO
COM12              = UNTOUCHED
JTAG               = 210319BE776EA UNTOUCHED
RTL_EDIT           = NO
```
