# ASTRA auditor REPORT — 20260907T0005Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R4_UART_ISO_INDEPENDENT_AUDIT; astra09_r4=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR; astra12_r3=AUDITOR_PASS_NARROW_9_ROW_TABLE; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + MASTER ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-09-R4-UART-ISO-01 + prior auditor 20260906T1930Z (12-R3 UART candidate table PASS_NARROW ACCEPT_PARTIAL; PRODUCTION_TOP UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + auditor 20260906T1700Z (A09-R3 UART XSim PASS_NARROW; residual 6: ISO_P3 was not replayed on the UART byte stream) + auditor 20260906T1600Z (A09-R2 DUT-level ISO_P3 w0=5 viso=0 on sibling SGD, TB-poked go_u)
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / Compile_Options.txt / xsim.dir/work sdb names / wrap+TB SV / uart_rx.sv / uart_tx.sv / frozen A09-R2 SV+SVH / frozen SGD / MMCM_MODE.txt / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / PREREG.md / ACK.json / run_xsim.ps1 / metrics.json / CLOSEOUT.md (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_xsim.ps1` (would overwrite `xsim.log`). Did not xvlog/xsim.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/pkg/uart hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` and `ASTRA-09-R3-UART-XSIM-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `523cdf657f3f992ee8a4181d5408d8a8846a974390fd3265c6125cddc194eee0` is **content-verified** against the opened log, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R4-UART-ISO-01/`

New named wrap `a7ng_astra_09_r4_uart_iso_wrap` (bag-local) instantiates:

- `u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` (`15a919f1…`)
- `u_iso` = frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`b66ef328…`)

Pin clock `CLK100MHZ` 10 ns → `MMCME2_BASE` 100→50 + `BUFG`. UART `uart_rx` / `uart_tx` `CLK_HZ=50_000_000` `BAUD=115200` 8N1. TB `tb_astra_09_r4_uart_iso`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not** instantiated and **not** compiled. ASTRA-09-R3 wrap/TB **not** this DUT.

Gate under review is **work-order ASTRA-09-R4-UART-ISO-01 only** — one unknown (handoff): can UART 8N1 (or the existing UART wrap path) deliver an isolated SGD update `x[0]=50` `rew=+3` and show `w0=+5` (and `x[0]=64` `rew=-3` → `w0=-6`) on the result stream or hierarchical `w_o` — with `load_from_tb=0` — **without** claiming BOARD_PASS?

This is T1700 residual 6: ISO_P3 was not replayed on the UART byte stream. **Not** a bit. **Not** a freeze.

**Not** Master ASTRA-09 production path. **Not** ASTRA-09-R3-UART-XSIM-01 MAGIC A2 query OVF/SMOKE/UNREL. **Not** wrap-route bit. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** `PRODUCTION_TOP` freeze. **Not** silicon UART / silicon MMCM.

Hunt (parent / work order / this dispatch):

1. Are ISO updates driven by UART 8N1 bytes, or TB poking `go_upd` / `x_i` directly? Quote RTL/TB.
2. Raw log ISO_P3 `w0=+5` and ISO_M3 `w0=-6`? `load_from_tb=0`?
3. Overclaim BOARD_PASS / silicon UART / `PRODUCTION_TOP` freeze?
4. Hash `.svh` before xvlog? PROGRAM=NO?

Confirm: frozen SGD + A09-R2 instantiated; ASTRA-09-R3 **not** claimed as this result.

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R4-UART-ISO-01.md` + PREREG: ISO_P3 and ISO_M3 on the UART-facing path; quote raw log `w0`; `load_from_tb=0`; `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD, silicon UART, wrap-route bit; PROGRAM=NO; SHA including `.svh` before xvlog; instantiate frozen SGD + A09-R2; do not claim ASTRA-09-R3 as this result.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *one integrated production path; remove fixture shortcuts; all functional regressions.*
3. **Master ASTRA-13**: silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1930Z`: 12-R3 table PASS_NARROW; `PRODUCTION_TOP=UNKNOWN`; BOARD blocked YES.
5. Auditor `20260906T1700Z`: A09-R3 UART XSim PASS_NARROW; residual 6 = ISO_P3 not on UART stream.
6. Auditor `20260906T1600Z`: A09-R2 bag ISO_P3 `w0=5 viso=0` on a **sibling** frozen SGD (`u_iso` in that TB), TB-poked `go_u` — not UART.

Out of this bag’s close: Master ASTRA-09 production UART (SoC top + on-chip plant + ISO through A09-R2 inner `u_sgd`), ASTRA-13 BOARD_PASS, wrap-route bit of this UART ISO wrap, LM06 language, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, `PRODUCTION_TOP` identity, silicon UART.

Prior bags `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-11-A09R3-UART-*` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`07e91b1f…ac601169`). `write_scope` = new bag + distinctly named UART ISO wrap/TB that **instantiate** frozen SGD + frozen `a7ng_astra_09_r2_cand_ovf` (no copy-paste graph; frozen `a7ng_astra_09_integ_path.sv` not compiled as DUT; A09-R2 DUT source not patched; ASTRA-09-R3 wrap/TB not edited). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-09-R3-UART-XSIM-01, ASTRA-SOC-RTP-WRAP-UART-XSIM, production_top_identity, write_bitstream, wrap_route_bit, silicon_UART.

`run_xsim.ps1` is xvlog/xelab/xsim only. **No** `write_bitstream` / `xsdb` / `COM12` / `hw_server` / `program_device` strings (grep). Script **throws** if live frozen A09 hash ≠ `9fdbe0d6…` or live R2 hash ≠ `15a919f1…` or live SGD hash ≠ `b66ef328…` **before** xvlog. Script **throws** if compile list matches `astra_09_integ_path|astra_rtp_soc_top|astra09_pipe|astra_09_r3_uart`.

Bag listing: **no** `.bit`, no `timing*.rpt`, no `vivado.log`, no `xsim_fail_r0.log` (first-run marker; no fail-corrective). `MMCM_MODE.txt`:

```text
MMCM_MODE=UNISIM_MMCME2_BASE
NOT_SILICON_MMCM=1
PROGRAM=NO
PRODUCTION_TOP=UNKNOWN
```

Prior bags **not rewritten** (headers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| `ASTRA-09-R3-UART-XSIM-01/xsim.log` | session **Sun Sep 6 21:45:37 2026** PID **19596** snapshot `a09r3uart` |
| `ASTRA-09-R2-CAND-OVF-01/xsim.log` | session **Sun Sep 6 21:05:33 2026** PID **22184** snapshot `a09r2`; still prints `ISO_P3 w0=5 viso=0` |
| `ASTRA-12-R3-UART-WRAP-CANDIDATES-01/RESULTS.md` | `PRODUCTION_TOP=UNKNOWN`; `CANDIDATE_COUNT=9`; `BOARD_PASS=NOT_CLAIMED` |

### Hash freeze (compiled + .svh) — MATCH (manifest, not re-hashed)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-07T00:12:46.6497405+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (five `.svh`, including both A09 leftover `.svh` and A09-R2 `.svh`) + CONFIG + stub-on-disk + KEEP_NOT_COMPILED **then** calls xvlog.  
Raw `xsim.log` session **Mon Sep 7 00:12:53–00:13:17 2026**, PID **47704**, snapshot `a09r4iso`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-07T00:13:17.7722668+07:00` (matches log exit `Exiting xsim at Mon Sep  7 00:13:17 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + transitive `.svh` vs POST: **17/17 MATCH** (opened manifests). Frozen leftover A09 `.sv` is KEEP_NOT_COMPILED / POST provenance, **not** in COMPILED list.

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf98852…5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0…05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49…83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da2…be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42…c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d…b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…c67aac` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…8b70ee23` |
| `rtl/board/uart_rx.sv` | `8e802d0b…cd5369a` |
| `rtl/board/uart_tx.sv` | `b4b7d097…b36367b` |
| bag `a7ng_astra_09_r4_uart_iso_wrap.sv` | `cc8ffdaa…836703ab` |
| bag `tb_astra_09_r4_uart_iso.sv` | `179dc2c5…22b86c5b` |
| `a7ng_astra_09_integ_path.svh` (include only) | `ad2d66d4…b4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…71afd329` |
| KEEP leftover A09 `.sv` (not compiled) | `9fdbe0d6…bb5c776c` |
| KEEP R3 UART wrap (not compiled) | `20cdeb8e…a3e88b41` |

Overlapping R2 / SGD / leftover A09 / pkg hashes **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`. `uart_rx` / `uart_tx` / R3 wrap prefixes **MATCH** `ASTRA-09-R3-UART-XSIM-01/SHA256.txt`. Handoff required R2 `15a919f1…` and leftover A09 `9fdbe0d6…`: **both present, R2 compiled, leftover A09 not compiled**. Frozen SGD `b66ef328…` compiled.

`.svh` hashed **before** xvlog: **YES**. PROGRAM=NO: **YES**.

### Compiled identity (raw xvlog / xelab / work sdb) — SGD + A09-R2 instantiated; leftover A09 and R3 wrap not compiled

`xvlog.log` analyzes, in order: pkg, QSE, role, route gate, sparse_dir, query_axi_sparse, **SGD**, **`a7ng_astra_09_r2_cand_ovf`**, `uart_rx`, `uart_tx`, bag wrap, bag TB. **No** `a7ng_astra_09_integ_path.sv`, **no** `a7ng_astra_09_r3_uart_wrap`, **no** `mmcm_stub`, **no** `astra_rtp_soc_top`. No ERROR lines in that log.

`xelab.log` command:

```text
xelab.exe tb_astra_09_r4_uart_iso glbl -s a09r4iso -timescale 1ns/1ps -L unisims_ver --debug typical
```

Compiled modules (raw xelab): `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, **`a7ng_shared_rank_sgd_q8_sym_f2r2`**, **`a7ng_astra_09_r2_cand_ovf_default`**, `a7ng_astra_09_r4_uart_iso_wrap`, `tb_astra_09_r4_uart_iso`, `glbl`. One unconnected-port WARNING on `CLKFBOUTB` (wrap line 22) — not a FAIL.

`Compile_Options.txt`: `"tb_astra_09_r4_uart_iso" "glbl" -s "a09r4iso" -timescale "1ns/1ps" -L "unisims_ver" --debug "typical"`.

`xsim.dir/work` sdb names (bag listing): `a7ng_astra_09_r2_cand_ovf.sdb`, `a7ng_astra_09_r4_uart_iso_wrap.sdb`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sdb`, `uart_rx.sdb`, `uart_tx.sdb`, `tb_astra_09_r4_uart_iso.sdb`, SGD / sparse / QSE / pkg / `glbl`. **No** `a7ng_astra_09_integ_path.sdb`, **no** `a7ng_astra_09_r3_uart_wrap.sdb`, **no** `mmcm_stub.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`.

Wrap RTL instantiates, does not copy, frozen A09-R2 and frozen SGD:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 (
  ...
  .tok_valid_i(tok_v), ... .tok_i(tok_b),
  .fire_i(fire), .retire_i(retire),
  .rew_v_i(1'b0), ...
  .load_v_i(1'b0), ...
  .load_from_tb_o(tbl),
  ...
);

assign go_s     = 1'b0;
assign iso_load = 1'b0;

(* keep_hierarchy = "yes" *)
a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso (
  .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
  .go_score_i(go_s), .go_upd_i(go_u), .x_i(xiso), .reward_i(iso_rew),
  .load_v_i(iso_load), ...
  .w_o(wiso)
);
```

A09-R2 query inputs are **starved** this bag (`tok_v=0`, `fire=0`, `retire=0`, AXI slave dummy `rvalid=0`). ISO datapath is wrap `u_iso`, **not** `u_a09r2.u_sgd`. Disclosed in RESULTS: *A09-R2 query path is idle this bag (ISO is isolated SGD).* Same sibling-ISO architecture as the A09-R2 bag (T1600: *ISO (frozen SGD instance, not DUT)*), now UART-facing instead of TB-poked.

A09-R2 itself `include`s leftover A09 **`.svh` parameters only**. Leftover A09 module was not elaborated. ASTRA-09-R3 wrap was not compiled.

---

### Hunt 1 — ISO updates are UART 8N1 bytes, not TB poke of `go_upd` / `x_i` — UART-DRIVEN

**CONFIRMED UART-real on the ISO command and result path. TB does not poke `go_u` / `x_i`.**

Contrast with A09-R2 bag TB (T1600), which **did** poke:

```text
xiso[0]=8'sd50; iso_rew=4'sd3;
wait(rdy); @(posedge clk); go_u=1; @(posedge clk); go_u=0; wait(dn);
```

This bag’s TB drives **only** pin `uart_txd_in` (idle 1). No `force` / `deposit` / hierarchical assign of `go_u` / `xiso` / `iso_rew`. The only TB `go_u` reference is a **display** probe:

```text
always @(posedge dut.clk) begin
  if (dut.go_u)
    $display("ISO_GO x0=%0d rew=%0d t=%0t", $signed(dut.x0_lat),
      $signed(dut.iso_rew), $time);
```

Bit-bang is 8N1 at pin-clock CPB (100 MHz / 115200 → 868):

```text
localparam int CPB = (CLK_PIN_HZ + BAUD/2) / BAUD;
task automatic uart_send_byte(input logic [7:0] b);
  uart_txd_in = 1'b0;                  // start
  repeat (CPB) @(posedge CLK100MHZ);
  for (i = 0; i < 8; i = i + 1) begin
    uart_txd_in = b[i];                // LSB-first data
    repeat (CPB) @(posedge CLK100MHZ);
  end
  uart_txd_in = 1'b1;                  // stop
  repeat (CPB) @(posedge CLK100MHZ);
```

ISO command on the wire: `CMD_ISO=0xA5`, `x0`, `rew8`, `EOL=0x0A`.

Wrap binds that pin to board UART RX (50 MHz pipe, 115200):

```text
uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_rx (
  .clk(clk), .rst_n(rst_n), .rx(uart_txd_in), .data(rx_data), .valid(rx_valid)
);
```

`uart_rx.sv` is a real 8N1 sampler (IDLE→START mid-bit check→DATA 8 bits LSB-first→STOP, `valid` one cycle). Not a byte-wide backdoor.

Wrap FSM (`C_IDLE→C_X→C_REW→C_EOL→C_GO→C_WAIT→C_TX`) latches UART bytes then pulses `go_u` **inside the wrap** when `rdy`:

```text
C_IDLE: if (rx_valid && (rx_data == CMD_ISO) && !tx_active) cst <= C_X;
C_X:    if (rx_valid) begin x0_lat <= rx_data; cst <= C_REW; end
C_REW:  if (rx_valid) begin rew8_lat <= rx_data; iso_rew <= rx_data[3:0]; cst <= C_EOL; end
C_EOL:  if (rx_valid) cst <= (rx_data == EOL) ? C_GO : C_IDLE;
C_GO:   if (rdy) begin go_u <= 1'b1; cst <= C_WAIT; end
```

`xiso[0] = x0_lat` (combinational from the UART-latched byte). `go_u` is wrap-internal, default-cleared every cycle (`go_u <= 1'b0` in the `else` of the same FF). **Not** a TB hierarchical poke.

Result path is real `uart_tx` serialize of `wiso[0]` after `dn`, sampled by TB 8N1 on `uart_rxd_out` (negedge start, mid-bit sample, LSB-first). Frame MAGIC A2 / EOL 0x0A.

UART-real timing (raw log, `%t` = 1 ps; `$finish` reports ns):

| Event | t (ps) | ns |
|-------|--------:|---:|
| `ISO_P3_CMD_SENT` | 6_285_000 | 6.285 |
| `ISO_GO x0=50 rew=3` | 349_265_000 | 349.265 |
| `ISO_DONE w0=5` | 350_605_000 | 350.605 |
| `UART_RX n=1 byte=a2` | 433_105_000 | 433.105 |
| `UART_RX n=2 byte=40` | 519_945_000 | 519.945 |

CMD_SENT → ISO_GO Δ = **342.980 µs**. Four host bytes × 10 bits × 8680 ns = 347.200 µs; last `rx_valid` is ~1 stop-bit early on the 50 MHz sampler (CLKS_PER_BIT=434, HALF=217) → ~342.86 µs + a few pin clocks. **MATCH UART-real, not a zero-delay poke.**

TX byte spacing n=1→n=2: 519_945_000 − 433_105_000 = **86_840_000 ps = 86840 ns**. Ten bits × 8680 ns = 86800 ns. Extra 40 ns = pin-clock alignment. **UART-real TX.**

---

### Hunt 2 — raw log ISO_P3 w0=+5 and ISO_M3 w0=-6; load_from_tb=0 — MATCH

Raw `xsim.log` (authority; session Mon Sep 7 00:12:53 PID 47704; `$finish` **3471575 ns**):

```text
ISO_P3_CMD_SENT x0=50 rew=+3 t=6285000
ISO_GO x0=50 rew=3 t=349265000
ISO_DONE w0=5 viso=0 w1=0 tbl=0 a09_w0=0 t=350605000
...
FRAME ISO_P3 a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a
ISO_P3 w0=5 viso=0 w1=0 x0=50 rew=3 tbl=0 iso=1 hier_w0=5 hier_tbl=0 a09_w0=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_PRE_W0
ISO_M3_CMD_SENT x0=64 rew=-3 t=1742135000
ISO_GO x0=64 rew=-3 t=2085125000
ISO_DONE w0=-6 viso=0 w1=0 tbl=0 a09_w0=0 t=2086465000
...
FRAME ISO_M3 a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a
ISO_M3 w0=-6 viso=0 w1=0 x0=64 rew=-3 tbl=0 iso=1 hier_w0=-6 hier_tbl=0 a09_w0=0
PASS ISO_M3_X64_DW6
ASTRA_09_R4_UART_ISO_PASS
```

Zero `FAIL` lines in `xsim.log` (grep). Marker present. `FAIL_R0` file absent (first xvlog/xelab/xsim). RESULTS `SIM_TIME=3471575 ns` MATCH `$finish`.

Frame decode (little-endian w0):

| Case | UART bytes | w0 LE | x0 | rew8 | tbl bit | viso |
|------|------------|------:|---:|-----:|--------:|-----:|
| ISO_P3 | `a2 40 05 00 00 00 32 03 … 0a` | **+5** (`05 00`) | 50 (`32`) | +3 (`03`) | 0 | 0 |
| ISO_M3 | `a2 40 fa ff 00 00 40 fd … 0a` | **-6** (`fa ff`) | 64 (`40`) | -3 (`fd`) | 0 | 0 |

`load_from_tb=0` on both:

- A09-R2 RTL: `assign load_from_tb_o = 1'b0;`
- Wrap: `.load_v_i(1'b0)` into A09-R2; `assign iso_load = 1'b0` into `u_iso.load_v_i`
- TB: no `load_v` / weight preload; ISO_M3 `wrap_rst()` then `chk("ISO_M3_PRE_W0", dut.wiso[0] === 16'sd0)` so M3 starts from **reset zero**, not leftover P3 +5
- Raw dumps: `tbl=0` `hier_tbl=0` `PASS ISO_P3_TBL0` `PASS ISO_M3_TBL0`

`freeze_i=1'b0` on `u_iso`. A09-R2 `w_o[0]` stays 0 (`a09_w0=0`, `PASS *_A09_W0_UNTOUCHED`) — inner `u_a09r2.u_sgd` did not take the ISO update. ISO weights are `u_iso.w_o`.

SGD law re-derived from frozen `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`SHIFT=6`, `dw40=rsh40(err*x, 7+SHIFT)`, `err=rew*256-v`, `w=0` ⇒ `v=0`):

- P3: `rew=+3`, `x0=50` → `err=768`, `prod=38400`, `rsh40(38400,13)=(38400+4096)>>>13=5` → **w0=+5**
- M3: `rew=-3`, `x0=64` → `err=-768`, `prod=-49152`, `rsh40(-49152,13)=-(49152+4096)>>>13=-6` → **w0=-6**

Not floor-shift +4. Matches T1600 ISO_P3 `w0=5 viso=0` and this bag’s M3. `viso=0` is the from-zero score, not a tautology of a constant TX template: w0 bytes differ (`05 00` vs `fa ff`) and match hierarchical `wiso[0]` after `ISO_DONE`.

`iso_rew <= rx_data[3:0]` is the frozen SGD port width (`reward_i` is `signed [3:0]`). `0x03` → +3; `0xFD` → nibble `0xD` = -3. Honest for this ISO pair.

---

### Hunt 3 — Overclaim BOARD_PASS / silicon UART / PRODUCTION_TOP freeze — NO

ACK / PREREG / RESULTS / CLOSEOUT / metrics / MMCM_MODE / TB banner all keep:

- `PRODUCTION_TOP=UNKNOWN`
- `PROGRAM=false` / `PROGRAM=NO`
- `BIT=NOT_BUILT`
- `BOARD_PASS` in `not_claimed` / OPEN
- `ASTRA-13` OPEN / BLOCKED
- silicon UART / silicon MMCM **not** claimed (`UNISIM_MMCME2_BASE`, `NOT_SILICON_MMCM=1`)
- ASTRA-09-R3 MAGIC A2 query frames **not** claimed as this bag
- wrap **not** named as production top

Marker is bag-local `ASTRA_09_R4_UART_ISO_PASS`, not `BOARD_PASS`, not `ASTRA_09_R3_UART_XSIM_PASS`. CLOSEOUT `PASS_THIS_GATE_ONLY`. RESULTS proposed `PASS_NARROW (this bag only: UART-facing ISO …)`.

No `.bit` / `.bin` / `.mcs` in the bag. `run_xsim.ps1` cannot program.

---

### Hunt 4 — Hash .svh before xvlog; PROGRAM=NO — MET

See hash section. Five `.svh` in `TRANSITIVE_INCLUDES` of `SHA256.txt` **before** xvlog. POST 17/17 MATCH. PROGRAM=NO throughout.

---

### This bag vs Master ASTRA-09 UART ISO

| Claim | This bag | Master ASTRA-09 |
|-------|----------|-----------------|
| UART 8N1 isolated SGD ISO `+3,x0=50→w0=+5` and `-3,x0=64→w0=-6` on **byte stream** + hier `w_o`, `load_from_tb=0` | **YES** (XSim) | Required as **one** functional regression, not the whole gate |
| One integrated production path; remove fixture shortcuts | **NO** — bag-local wrap; A09-R2 query/learn idle; ISO is sibling `u_iso` | **OPEN** |
| SoC UART identity / on-chip plant / wrap-route bit | **NO** | **OPEN** |
| Silicon UART on COM12 | **NO** | ASTRA-13 / BOARD — **BLOCKED** |

T1700 residual 6 (*ISO_P3 not on the UART stream*) is **answered on this named bag**, narrowly. It does **not** promote Master ASTRA-09.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| TB poke `go_upd` / `x_i` as ISO authority | **No.** TB bit-bangs `uart_txd_in` only. Wrap FSM pulses `go_u` after UART `A5 x0 rew 0A`. No `force`/`$deposit`. |
| UART TX is a constant template (tautology) | **No.** P3/M3 frames differ in w0 (`05 00` vs `fa ff`) and x0/rew; match `ISO_DONE` hier `wiso[0]`; TX spacing is 86840 ns/byte. |
| `load_from_tb` as query/ISO authority | **No.** A09-R2 hard 0; `iso_load=0`; dumps `tbl=0`. Weights from reset-zero SGD update, not TB preload. |
| `freeze_i=1` cheat | **No.** `u_iso.freeze_i=1'b0`. |
| ISO through A09-R2 inner `u_sgd` | **No — disclosed NARROW.** Inner SGD starved; `a09_w0=0`. ISO is wrap `u_iso` (same sibling pattern as A09-R2 bag, now UART-facing). |
| Claim A09-R3 OVF/SMOKE as this result | **No.** R3 `xsim.log` still 21:45:37 PID 19596; R3 wrap KEEP_NOT_COMPILED; this marker is `ASTRA_09_R4_UART_ISO_PASS`. |
| Golden edit / wipe prior xsim.log | **Not found.** No `xsim_fail_r0.log`; prior R2/R3/12-R3 logs/headers intact. |
| Hash theatre after scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes both `.svh`. POST 17/17 MATCH. |
| BOARD_PASS / silicon UART / `PRODUCTION_TOP` freeze | **Not claimed.** |
| Floor-shift +4 labeled as Master symmetric +5 | **No.** Raw w0=+5 / -6; auditor re-derived `rsh40(...,13)` on frozen SGD. |
| ID one-hot as transfer / LM06 language | **Not claimed.** |
| RESULTS vs raw log mismatch | **No.** Frames, w0, tbl, sim time, marker MATCH opened `xsim.log`. |
| MMCM stub silently used | **No.** `MMCM_MODE=UNISIM_MMCME2_BASE`; xelab `-L unisims_ver`; no `mmcm_stub.sdb`. Stub hashed STUB_ON_DISK only. |

Remaining **narrowness** (not cheats): sibling ISO SGD (not A09-R2 inner learner); bag-local wrap (not `arty_a7_astra_rtp_soc_top` / not a frozen production top); unisim MMCM (not silicon); XSim UART (not COM12); A09-R2 instantiated but query-idle.

---

## Logic bugs

None that break this bag’s declared unknown.

Notes (not P1):

1. `iso_rew <= rx_data[3:0]` truncates the UART reward byte to the frozen 4-bit SGD port. Correct for `+3`/`-3`. A later host sending a wide reward would silently wrap. Out of this ISO pair.
2. `x0_lat <= rx_data` treats the UART byte as signed Q8. `50` and `64` are in range. Not a bug here.
3. xelab WARNING `CLKFBOUTB` unconnected on `MMCME2_BASE` — same class as T1700 UART wrap. Not a functional ISO fail.
4. A09-R2 is a keep-hierarchy passenger this bag. Instantiation requirement MET; ISO datapath is `u_iso`. Do not read this as “A09-R2 learned +5”.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R4-UART-ISO-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw XSim: UART 8N1 command bytes into `uart_rx` (not TB poke of `go_upd`/`x_i`) delivered isolated frozen-SGD updates **on the serialized `uart_rxd_out` byte stream** and hierarchical `wiso[0]`:

- ISO_P3: `x0=50` `rew=+3` → **w0=+5** `viso=0` `w1=0` `tbl=0` frame `a2 40 05 00 00 00 32 03 … 0a`
- ISO_M3: `x0=64` `rew=-3` → **w0=-6** `viso=0` `w1=0` `tbl=0` frame `a2 40 fa ff 00 00 40 fd … 0a`

`load_from_tb=0`. Frozen SGD + frozen A09-R2 instantiated. Leftover A09 not compiled. ASTRA-09-R3 not claimed. UNISIM MMCM (not stub, not silicon). PROGRAM=NO. `PRODUCTION_TOP=UNKNOWN`. No BOARD_PASS.

Not PASS (Master ASTRA-09 production path / ISO through A09-R2 inner `u_sgd` / fixture-free SoC UART / silicon UART / BOARD).  
Not FAIL (raw log matches PREREG tests; UART path is real; SGD law re-derives +5/−6; hashes PRE/POST aligned; prior bags intact).  
Not OVERCLAIM (ACK/RESULTS keep Master 09/13/BOARD/`PRODUCTION_TOP`/silicon UART open; marker is bag-local `ASTRA_09_R4_UART_ISO_PASS`).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared UART-facing ISO XSim unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this XSim to BOARD_PASS, ASTRA-13, silicon UART, silicon MMCM, wrap-route bit, or `PRODUCTION_TOP=a7ng_astra_09_r4_uart_iso_wrap` / `a7ng_astra_09_r2_cand_ovf`.
2. Do **not** claim ASTRA-09-R3 MAGIC A2 query OVF/SMOKE/UNREL as closed by this bag. Different wrap, different unknown. R3 `xsim.log` must stay 21:45:37 PID 19596.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), or frozen SGD (`b66ef328…`).
5. ISO remains a **sibling** `u_iso`, not A09-R2 inner `u_sgd`. Master ASTRA-09 “one integrated production path; remove fixture shortcuts” still needs a named path where UART tokens/reward hit the **same** learner the query path uses — or an explicit recorded decision that sibling ISO is the production law check. Not a silent close from this glue.
6. Host parsers must not mix this wrap’s 16-byte ISO pack (`A2`, flags `{tbl,iso,6'd0}`, w0 LE, viso LE, x0, rew8, w1 LE, EOL) with A09-R3 query frames or RTP SoC wrap layout.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated UART-facing ISO XSim around instantiated frozen SGD + frozen `a7ng_astra_09_r2_cand_ovf`: ISO commands are **UART-real 8N1 into `uart_rx`**, result MAGIC A2 is **real `uart_tx` serialize**, ISO_P3 **w0=+5** and ISO_M3 **w0=-6** on the **byte stream** and hier `wiso[0]`, `load_from_tb=0`, leftover A09 not compiled, ASTRA-09-R3 not claimed, UNISIM MMCM not stub, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`.

`REJECT_PROMOTION` — Master **ASTRA-09** (production UART path / fixture-free plant / ISO through A09-R2 inner SGD / SoC top), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. UART-real **≠** silicon UART.

Master ASTRA-09 UART / BOARD: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, different unknown**.  
ASTRA-12-R3 9-row table: **untouched; PRODUCTION_TOP still UNKNOWN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0005Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-R4-UART-ISO-01; UART-driven (8N1 into uart_rx / wrap FSM go_u) vs poke=NO; ISO_P3 w0=+5 ISO_M3 w0=-6 load_from_tb=0; Master ASTRA-09 UART/BOARD OPEN; PROGRAM=NO; BOARD still blocked YES.
