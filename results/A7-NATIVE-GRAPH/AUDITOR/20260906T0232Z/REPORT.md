# ASTRA auditor REPORT — 20260906T0232Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
SCOPE      = results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-UART-XSIM/
LOOP_STATE = auditor=IN_PROGRESS, soc_rtp_wrap_uart_xsim=PENDING_AUDITOR, astra13=BLOCKED, program=false
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA wrap-top UART/MMCM XSim (auditor 20260906T0215Z item 5 / 0152Z item 3). Next encoder work stays ungated DIFF twin (not S2, not glue).

---

## Scope

Read-only. Wrote only this `REPORT.md`. Did not edit `rtl/`. Did not program. Did not touch COM12 / JTAG `210319BE776EA`. Did not run `xsdb` / `program_hw_*` / Vivado hardware. Did not re-run XSim.

| Object | Path |
|--------|------|
| Bag | `results/A7-NATIVE-GRAPH/ASTRA-SOC-RTP-WRAP-UART-XSIM/` |
| Raw XSim | `xsim.log` (not RESULTS.md) |
| xvlog index | `xsim_work/xvlog.log` (glbl overwrite) + `xsim_work/xsim.dir/work/work.rlx` |
| xelab | `xsim_work/xelab.log` + `xsim.dir/wrapuart/Compile_Options.txt` |
| MMCM | `MMCM_MODE.txt` vs raw xelab `-L unisims_ver` |
| Freeze | `SHA256.txt` (stamp 2026-09-06T02:28:37.8265117+07, before xvlog) |
| TB | `tb_astra_soc_rtp_wrap_uart.sv` |
| Wrap | `rtl/board/arty_a7_astra_rtp_soc_top.sv` |
| Pipe | `rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r2.sv` |
| Mem | `rtl/native_graph/memory/a7ng_axi_bram128.sv` `.PLANT_R2_BASE(1)` |
| UART | `rtl/board/uart_rx.sv` / `uart_tx.sv` `#(.CLK_HZ(50_000_000), .BAUD(115200))` |
| Authority | `docs/ASTRA/AUDITOR_BOOT.md`, `GSTACK_LOOP.md`, `LOOP_STATE.json` |
| Prior | `AUDITOR/20260906T0215Z`, `20260906T0152Z`, `20260906T0138Z`, `20260906T0120Z`, `20260905T1841Z` |

Hunt: overclaim, cheat, tautology, RESULTS vs raw FRAME, hash theatre, TB-load as retrieval, empty BRAM, **r1+plant128 vs wrap+uart+r2+bram128**, unisim vs stub MMCM, tbl=0, BOARD_PASS without WNS≥0 **and** JTAG program log.

Out of bag (identity/residual only): WRAP-XSIM (r2+bram128, wrap not xvlog’d), WRAP-ROUTE (impl+route WNS=5.733 BRAM=2 UNPROGRAMMED), glue (stripped r1+plant128), 09 wrap (`freeze_i=1`, default empty BRAM).

---

## Evidence re-derived

### DUT identity (raw `xelab.log` / `work.rlx` / sdb, not RESULTS)

`run_wrap_uart_xsim.ps1` file list: pkg, QSE, role, gate, sparse_dir, **`a7ng_axi_bram128`**, query_axi_sparse, rel_engine_2hop, **`a7ng_astra_rtp_pipe_r2`**, **`uart_rx`**, **`uart_tx`**, **`arty_a7_astra_rtp_soc_top`**, bag TB. Forbidden-name abort `astra09|pipe_r1|plant128` on the compile list. Did not fire.

Raw `xvlog.log` is **only** `glbl.v` (second `xvlog.bat $glbl` overwrote the DUT analyze log). Compile identity is **not** taken from that truncated log.

`xsim.dir/work/work.rlx` (xvlog library index) lists, among others:

- `rtl/board/arty_a7_astra_rtp_soc_top.sv` → `arty_a7_astra_rtp_soc_top`
- `rtl/board/uart_rx.sv` → `uart_rx`
- `rtl/board/uart_tx.sv` → `uart_tx`
- `rtl/native_graph/integrate/a7ng_astra_rtp_pipe_r2.sv` → `a7ng_astra_rtp_pipe_r2`
- `rtl/native_graph/memory/a7ng_axi_bram128.sv` → `a7ng_axi_bram128`
- bag `tb_astra_soc_rtp_wrap_uart.sv`

**Not** in `work.rlx`: `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, `a7ng_astra_rtp_pipe_r1`, `a7ng_axi_rtp_plant128`, `mmcm_stub`.

Raw `xelab.log`:

```text
Running: .../xelab.exe tb_astra_soc_rtp_wrap_uart glbl -s wrapuart -timescale 1ns/1ps -L unisims_ver --debug typical
...
Compiling module unisims_ver.MMCME2_ADV(CLKFBOUT_MULT_F=10.0,...
Compiling module unisims_ver.MMCME2_BASE(CLKFBOUT_MULT_F=10.0...
Compiling module unisims_ver.BUFG
Compiling module work.uart_rx(CLK_HZ=50000000)
Compiling module work.uart_tx(CLK_HZ=50000000)
...
Compiling module work.a7ng_astra_rtp_pipe_r2_default
Compiling module work.a7ng_axi_bram128(PLANT_R2_BASE=1...
Compiling module work.arty_a7_astra_rtp_soc_top
Compiling module work.tb_astra_soc_rtp_wrap_uart
Compiling module work.glbl
Built simulation snapshot wrapuart
```

`Compile_Options.txt`: `-L unisims_ver`. Matches `MMCM_MODE.txt`:

```text
MMCM_MODE=UNISIM_MMCME2_BASE
NOT_SILICON_MMCM=1
PROGRAM=NO
```

`xsim.dir/work` sdb: wrap top, r2, bram128, uart_rx, uart_tx, TB, query/engine. **No** `a7ng_astra09_pipe.sdb`, **no** `arty_a7_astra09_soc_top.sdb`, **no** `a7ng_astra_rtp_pipe_r1.sdb`, **no** `a7ng_axi_rtp_plant128.sdb`, **no** `mmcm_stub`.

**Identity gate PASS:** compile set is **wrap + uart + r2 + bram128**. Not r1+plant128. Not 09 wrap. Stub not xvlog’d.

xelab warning only: `CLKFBOUTB` unconnected on wrap `u_mmcm` (port unused). `xsimcrash.log` empty. `$finish` at TB line **185** matches live TB.

TB instantiates **`arty_a7_astra_rtp_soc_top`** on pin `CLK100MHZ` 10 ns, `uart_txd_in` / `uart_rxd_out`. Inside wrap (not TB-rewired): `u_pipe = a7ng_astra_rtp_pipe_r2`, `u_sram = a7ng_axi_bram128 #(.PLANT_R2_BASE(1'b1), .DEPTH_WORDS(256))`, UART `#(.CLK_HZ(50_000_000), .BAUD(115200))`, `MMCME2_BASE` 100→50 (`MULT_F=10`, `DIVIDE_F=20`) + `BUFG`. AXI writes tied off.

**Not the 09 wrap.** Live `arty_a7_astra09_soc_top.sv` still `a7ng_astra09_pipe` with **`freeze_i(1'b1)`**, `load_v(1'b0)`, `a7ng_axi_bram128` **without** `PLANT_R2_BASE` (default `1'b0` = empty INIT). Not in this compile set.

### Raw `xsim.log` FRAME (session Sun Sep 6 02:28:45–02:29:02 2026, xsim v2026.1, laptop-Quan)

Do not trust RESULTS.md alone. Banner and UART path:

```text
TB WRAP-UART-XSIM DUT=arty_a7_astra_rtp_soc_top PROGRAM=NO
UART 115200 8N1 CPB_PIN100=868 BIT_NS=8680
RST_N=1 locked=1 t=5645000
FIRE t=1998465000
HIER result_v ans=4 p0=17 p1=34 st=0 tbl=0 nload=2 ncand=2 nfok=2 ndir=2 nfar=2 ovf=0 neg=0 amb=0 t=2000505000
QUERY_SENT t=2002685000
UART_RX n=1 byte=a2 t=2083005000
...
UART_RX n=16 byte=0a t=3385605000
FRAME a2 00 04 00 00 11 00 00 22 00 00 02 02 02 02 0a
DECODE magic=a2 tbl=0 st=0 ans=4 p0=17 p1=34 nload=2 nfok=2 ndir=2 ncand=2 eol=0a
PASS BASE UART ans=4 p0=17 p1=34 tbl=0
ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS
$finish called at time : 3385615 ns : File ".../tb_astra_soc_rtp_wrap_uart.sv" Line 185
```

Matches RESULTS table, GOLDEN `frame_hex=a200040000110000220000020202020a`, METRICS BASE_UART, CLOSEOUT. Marker is the TB string, not promotion.

**tbl=0** on (1) HIER `dut.tbl`, (2) DECODE `fr[1][7]`, (3) PASS line. No `FAIL TBL` / `FAIL HIER_TBL`.

Byte pack vs wrap RTL (`tx_bytes` on `result_v`): `[0]=MAGIC A2`, `[1]={tbl,ovf,neg,amb,status}=0x00`, ans LE 20-bit `04 00 00`, p0 `11 00 00` (17), p1 `22 00 00` (34), nload=2, nfok=2, ndir=2, ncand=2, `[15]=0x0A`.

PASS of ans/p0/p1 is from **UART pin bytes**, not from copying `dut.ans` into the score. Hier `result_v` is concurrent log only. Extra `dut.tbl` check is redundant (`assign load_from_tb_o = 1'b0`); the UART tbl bit is the wrap-pack check.

### UART timing (raw stamps, 1 ps res)

CPB pin = `(100e6+115200/2)/115200 = 868` × 10 ns = 8680 ns/bit. DUT UART at 50 MHz: `(50e6+115200/2)/115200 = 434` × 20 ns = **same 8680 ns**. xelab `CLK_HZ=50000000` matches wrap.

Query `"pump requires indirect\n"` = 23 bytes × 10 bits × 8680 ns = 1,996,400 ns. `RST_N` at 5645 ns + 64 pin clocks (640 ns) + 1,996,400 ns = **2,002,685 ns** = raw `QUERY_SENT t=2002685000`. Inter-byte UART_RX spacing is **86800 ns** (exactly 10 bit periods) for all 16 TX bytes.

FIRE at 1,998,465 ns is during the last byte’s stop bit (EOL already in the wrap FIFO) — expected, not a log swap.

First TX byte complete at 2,083,005 ns is ~9.5 bit periods after `result_v` (start-bit mid-sample + 8 data + stop). This is pin-level 8N1, not a TB `$display` of a packed array.

### load_from_tb / freeze_i / plant empty?

- `a7ng_astra_rtp_pipe_r2.sv`: `assign load_from_tb_o = 1'b0`. No `freeze_i` (r2 has no SGD). `poke_v_i` tied 0 on the walker.
- Wrap maps `load_from_tb_o` → `tbl` → MAGIC byte[1][7]. Raw tbl=0.
- Engine fill is AXI `beat_ok` (RID==2, RRESP OKAY, RLAST, VER=1, eid==cand). Wrap AXI W tied off (`awvalid=0`, `wvalid=0`). TB has no `load_v` / no AXI poke / no mem backdoor.
- HIER `nload=2 nfok=2 ndir=2 nfar=2` — fetch happened. Not empty BRAM.
- `a7ng_axi_bram128` `.PLANT_R2_BASE(1)` INIT: dir aliases, POST 17/34, rtp-desc-v1 facts at compact `word_of` slots 0–6. Default param is 0; this instance is 1.
- EMPTY not in this bag (wrap has no `fill_i`; PREREG said so). Do not cite as silicon empty-index.

This is wrap-top UART of the same planted BASE 17/34 world as WRAP-XSIM / RTP-R2. Not a TB-load cheat.

### MMCM: unisim vs stub

Script default: `xelab ... -L unisims_ver`; only if that fails, xvlog `mmcm_stub.sv` and set `MMCM_MODE=MMCM_STUB`. Raw xelab succeeded with `unisims_ver.MMCME2_BASE`. Stub is hashed as `STUB_ON_DISK` and is **not** in `work.rlx`. `LOCK.txt` `MMCM_STUB_USED=NO`. `NOT_SILICON_MMCM=1` is true: unisim behavioral lock + wrap POR (`por_cnt==0xFF`) at t=5.645 µs is **not** silicon MMCM lock time.

**Forbidden:** reading this bag as silicon MMCM, pin E3 analog, or board UART PHY.

### SHA256 freeze vs live

`SHA256.txt` stamp **2026-09-06T02:28:37.8265117+07** (ps1, before xvlog). xsim session **02:28:45–02:29:02**. Not hash-after-scores.

This auditor sandbox cannot execute `Get-FileHash`. Live identity is **cross-manifest** of every freeze line against WRAP-ROUTE `SHA256.txt` (audited 20260906T0215Z, freeze 02:09:06+07) and WRAP-XSIM `SHA256_SYNTH.txt` (0152Z, freeze 01:50:40+07), plus `work.rlx` paths matching the freeze list.

| File | This bag SHA256.txt | Cross-check |
|------|---------------------|-------------|
| `a7ng_astra_rtp_pipe_r2.sv` | `3d27091d64ff7782…` | identical WRAP-ROUTE + WRAP-XSIM SYNTH + R2 KEEP |
| `a7ng_axi_bram128.sv` | `6e25482890d69df9…` | identical WRAP-ROUTE + WRAP-XSIM SYNTH (planted param is wrap instance) |
| `arty_a7_astra_rtp_soc_top.sv` | `a1f7a063f95d9239…` | identical WRAP-ROUTE + WRAP-XSIM SYNTH |
| `uart_rx.sv` / `uart_tx.sv` | `8e802d0b…` / `b4b7d097…` | identical WRAP-ROUTE + WRAP-XSIM SYNTH |
| QSE / role / gate / sparse_dir / query_axi / rel_engine / pkg | same as WRAP-ROUTE | **KEEP** |
| TB `tb_astra_soc_rtp_wrap_uart.sv` | `4faa91a586e22607…` | this bag only; `$finish` line 185 matches raw log |
| `mmcm_stub.sv` | `55707db07298bafe…` | hashed; **not compiled** |
| `a7ng_astra09_pipe.sv` KEEP_NOT_COMPILED | `48c9e480cbf2f682…` | identical WRAP-ROUTE / 12B / TIMING-FIX — **KEEP, not DUT** |
| `arty_a7_astra09_soc_top.sv` KEEP_NOT_COMPILED | `71f4ebe08e846bcc…` | identical WRAP-ROUTE / TIMING-FIX — **KEEP, not DUT** |

No compiled-DUT drift vs the routed wrap freeze. Not wrap-hash-theatre of a 09 top. Live `Get-FileHash` of the files on disk vs `SHA256.txt` is **UNVERIFIED** in this sandbox (same gap as 0152Z / 0215Z).

### PROGRAM / BOARD_PASS

`LOCK.txt` `BIT=NO`. No `.bit`, no `BITSTREAM.txt`, no xsdb, no `open_hw_manager` in this bag. RESULTS / PREREG / CLOSEOUT / METRICS / LOOP_STATE `program=false` / `board_pass=false` agree.

**BOARD_PASS = NO.** Gate is WNS≥0 **and** JTAG program log. This bag has neither a new timing extract nor a program log. WRAP-ROUTE WNS=5.733 is a **sibling** bag; do not inherit it as this close, and do not combine it with this XSim to declare BOARD_PASS.

### Glue / prior bags left as labeled

Glue `xelab.log` still compiles **`a7ng_astra_rtp_pipe_r1_default`** + **`a7ng_axi_rtp_plant128`**. Wrap was **not** restored as that DUT.

WRAP-XSIM still wrap-equivalent r2+bram128 (wrap not in that xvlog). WRAP-ROUTE still UNPROGRAMMED.

LOOP_STATE `soc_rtp_wrap_uart_xsim=PENDING_AUDITOR` (not pre-graded PASS). Marker `ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS` is the TB string.

---

## Overclaim / cheat / tautology

1. **Not OVERCLAIM of wrap-top identity.** Raw xelab/work.rlx DUT is `arty_a7_astra_rtp_soc_top` + r2 + `a7ng_axi_bram128(PLANT_R2_BASE=1)` + uart_rx/tx. RESULTS `DUT_XSIM` / `NOT_DUT` match. 1841Z/0152Z “UART/MMCM not in this TB” is **this** bag’s job and is now evidenced.

2. **Not BOARD_PASS.** RESULTS `BOARD_PASS = NO` matches evidence. **Forbidden:** promoting UART XSim + sibling routed WNS to ASTRA-13 / COM12 / JTAG.

3. **Not silicon MMCM.** `MMCM_MODE=UNISIM_MMCME2_BASE` + `NOT_SILICON_MMCM=1` + xelab `-L unisims_ver`. Stub unused. RESULTS “Not claimed” includes silicon_MMCM. Honest.

4. **Not a load_v / TB-load cheat.** r2 `load_from_tb_o=0`; raw tbl=0 on UART byte[1][7] and hier; AXI W tied off; tokens are UART RX of `"pump requires indirect\n"`.

5. **Not ID-one-hot-as-transfer; not LM06 language; not F2 tautology.** BASE is the planted 17/34 → ans=4 exam. TB expect is hardcoded (`ans===4`, `p0===17`, `p1===34`), not copied from DUT score. `beat_ok` still the fetch law (nload=2 / nfok=2). No EMPTY negative in this bag (admitted).

6. **Not 09-wrap fetch.** 09 wrap still `freeze_i=1` + default empty BRAM. This bag does not upgrade 09.

7. **Replay / existence-narrow (admitted).** Same BASE query/world as WRAP-XSIM / R2. New fact is **wrap UART FIFO → fire → MAGIC A2 TX on `uart_rxd_out`**, not a new retrieval. METRICS `open_world_claimed=false`.

8. **HIER_TBL is tautological; UART tbl is not.** `load_from_tb_o` is a constant 0, so `dut.tbl !== 0` cannot fail. `fr[1][7]` would fail if wrap packed tbl wrong. Raw FRAME byte[1]=`00` is the wrap-pack evidence.

9. **Reset MAGIC is not the PASS.** Wrap reset preloads `tx_bytes[0]=A2` / `[15]=0A` zeros elsewhere; TX starts only on `result_v`. Reset frame would fail ANS/PROOF (ans would be 0, not 4).

10. **No LOOP_STATE self-grade of this bag.** `soc_rtp_wrap_uart_xsim=PENDING_AUDITOR`. METRICS `"result":"PASS_NARROW"` is implementer opinion; this report re-derives.

11. **xvlog.log overwrite (hygiene, not inflated PASS).** RESULTS already cites xelab/sdb as identity, not the truncated `xvlog.log`. Compile set is independently in `work.rlx` + xelab.

---

## Logic bugs

1. **No negative UART query / no wrap EMPTY.** A wrong string or empty-EOL-only fire is untested. Do not PREREG wrap EMPTY. Optional next *existence* unknown only if parent wants it — **not** board.

2. **`word_of` default** `{1'b1, a[10:4]}` can alias in 256 words. BASE only hits mapped slots. Unmapped AR untested. Same as 0152Z / 0215Z.

3. **Unisim MMCM lock ≠ silicon lock.** POR at 5.645 µs is behavioral. Board bring-up still needs real LOCKED + UART sampling vs pin delay (WRAP-ROUTE `no_output_delay` on UART remains).

4. **This bag has no WNS.** Do not cite WRAP-ROUTE 5.733 as this RESULTS. Do not mix 09 timing-fix 7.179 / BRAM=0 / DSP=2.

5. **`is_eol` treats `0x00` as EOL** as well as `0x0A`. Harmless for this query; residual if a token is NUL.

6. **REQP-1839 / RBOR-1** (WRAP-ROUTE) still residual for silicon BRAM POR. Not a sim fail.

7. **Live Get-FileHash unverified** in this sandbox.

---

## Verdict per bag

| Object | Verdict | Why |
|--------|---------|-----|
| ASTRA-SOC-RTP-WRAP-UART-XSIM **as wrap-top UART MAGIC `A2` XSim** | **PASS_NARROW** | raw FRAME `a2 00 04 00 00 11 00 00 22 00 00 02 02 02 02 0a`; ans=4 p0=17 p1=34; **tbl=0**; pin 8N1 spacing exact; DUT = wrap+uart+r2+bram128 |
| Identity vs r1+plant128 / 09 wrap | **PASS (not those DUTs)** | xelab + work.rlx + sdb; 09 KEEP hashed not compiled |
| MMCM | **PASS_NARROW (unisim, not silicon)** | `MMCM_MODE=UNISIM_MMCME2_BASE`; stub unused; `NOT_SILICON_MMCM=1` |
| Plant / BRAM empty? | **NO** (INIT plant; nload=2 nfok=2 ndir=2 nfar=2) | same SHA as WRAP-ROUTE tiles=2 |
| load_from_tb | **0** | r2 assign 0; raw tbl=0 UART + hier |
| PROGRAM / BOARD_PASS | **NO** | no bit, no JTAG log; sibling WNS not this bag |
| ASTRA-13 / 100 MHz / LM06 / F2 / 09-wrap fetch / silicon MMCM | **not accepted** | not claimed honestly; not proven |

**Bag headline: PASS_NARROW.**

LOOP_STATE `soc_rtp_wrap_uart_xsim` may be labeled `PASS_NARROW_WRAP_UART_UNISIM_TBL0` after parent reads this. It is **not** BOARD_PASS, **not** ASTRA-13, **not** silicon MMCM, **not** COM12. Keep `astra13=BLOCKED`, `program=false`, `final_promotion=REJECT`.

**This bag must not receive BOARD_PASS.** UART XSim is necessary for wrap-top existence, not sufficient for silicon.

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO. COM12 / JTAG `210319BE776EA` untouched.

1. **LOOP_STATE:** `soc_rtp_wrap_uart_xsim=PASS_NARROW_WRAP_UART_UNISIM_TBL0` (or equivalent). Keep `soc_rtp_wrap_xsim=PASS_NARROW_R2_BRAM128_XSIM_SYNTH_BRAM2`, `soc_rtp_wrap_route=PASS_NARROW_ROUTE_WNS5733_BRAM2_UNPROGRAMMED`, glue stripped r1+plant128. **`astra13=BLOCKED`**, **`program=false`**, **`final_promotion=REJECT`**. Do **not** set BOARD_PASS.

2. **Do not program COM12 / JTAG `210319BE776EA`.** Existing WRAP-ROUTE `arty_a7_astra_rtp_soc_top.bit` stays UNPROGRAMMED until ASTRA-13 + owner + routed WNS≥0 **and** auditor ACCEPT **board** with a JTAG program log. This report is not that ACCEPT.

3. **unblocked_item:** `NONE`. Do **not** invent board work. Parent boot: ACCEPT_PARTIAL + NONE → idle. Optional hygiene only (below) is not a promotion gate.

4. **xvlog hygiene (optional, same bag, no RTL):** `xvlog -log xvlog_dut.log` for the SV list so the DUT analyze log is not overwritten by `glbl`. Identity this round already stands on `work.rlx` + xelab.

5. **Hash hygiene (optional):** live `Get-FileHash` vs `SHA256.txt` (this sandbox could not).

6. **EMPTY / negative UART:** keep EMPTY as TB `PLANT_R2_BASE=0` mux only (WRAP-XSIM). Do not PREREG wrap EMPTY. A wrong-query UART case is optional and not board.

7. **Do not edit** `a7ng_astra09_pipe`, `arty_a7_astra09_soc_top`, r2, frozen LM06 tops. Do not put `plant128` / r1 on this Arty top. Do not restore wrap as glue DUT.

8. **Never map this bag to ASTRA-13 / BOARD_PASS / 100 MHz / LM06 / F2 / 09-wrap fetch / encoder H5 / silicon MMCM.** 09 wrap stays frozen empty-store co-fit (`freeze_i=1`, default BRAM empty).

---

## Final

**ACCEPT_PARTIAL**

**REJECT_PROMOTION**

Raw `xsim.log` FRAME is wrap-top UART MAGIC `A2`, tbl=0, ans=4 p0=17 p1=34. Compile set is wrap + uart + r2 + bram128 (not r1+plant128). MMCM is unisim, stub unused, not silicon. Not **FAIL_LOOP**. Not BOARD_PASS. Promotion of ASTRA-13 / UART-on-board / JTAG stays **REJECT**.

```text
Final              = ACCEPT_PARTIAL
Bag                = PASS_NARROW (arty_a7_astra_rtp_soc_top UART MAGIC A2; unisim MMCM; tbl=0; not BOARD_PASS)
Promotion          = REJECT_PROMOTION
FAIL_LOOP          = NO
BOARD_PASS         = NO
PROGRAM            = NO
COM12              = UNTOUCHED
JTAG               = 210319BE776EA UNTOUCHED
RTL_EDIT           = NO
tbl                = 0
DUT_XSIM           = arty_a7_astra_rtp_soc_top + uart_rx/tx + a7ng_astra_rtp_pipe_r2 + a7ng_axi_bram128(PLANT_R2_BASE=1)
NOT_DUT_XSIM       = r1 + plant128 ; a7ng_astra09_pipe ; arty_a7_astra09_soc_top ; mmcm_stub
MMCM               = UNISIM_MMCME2_BASE
MMCM_STUB_USED     = NO
NOT_SILICON_MMCM   = 1
FRAME              = a2 00 04 00 00 11 00 00 22 00 00 02 02 02 02 0a
QUERY              = pump requires indirect\n
WNS                = N/A (this bag); sibling WRAP-ROUTE 5.733 not inherited as BOARD_PASS
BIT                = NO
```
