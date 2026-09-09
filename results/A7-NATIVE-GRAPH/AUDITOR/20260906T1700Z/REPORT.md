# ASTRA auditor REPORT — 20260906T1700Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R3_UART_XSIM_INDEPENDENT_AUDIT; astra09_r3=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra11_a09r2=AUDITOR_PASS_NARROW_ROUTED_WNS_P0648; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + MASTER ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-09-R3-UART-XSIM-01 + prior auditor 20260906T1630Z (A09R2 impl/route WNS=+0.648 PASS_NARROW; ACCEPT_PARTIAL | REJECT_PROMOTION; residual mentions SoC UART wrap as a *candidate* production path — this bag is XSim UART glue around instantiated A09-R2, not a bit, not a freeze) + auditor 20260906T1600Z (A09-R2 XSim ntrunc→INCOMP ans=0 PASS_NARROW; ISO_P3 on that DUT-level bag)
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / Compile_Options.txt / xsim.dir/work sdb names / wrap+plant+TB SV / uart_rx.sv / uart_tx.sv / frozen A09-R2 SV+SVH / MMCM_MODE.txt / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / PREREG.md / ACK.json / run_xsim.ps1 / metrics.json (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_xsim.ps1` (would overwrite `xsim.log`). Did not xvlog/xsim.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/pkg/uart hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` and `ASTRA-SOC-RTP-WRAP-UART-XSIM/RESULTS.md` KEEP lines (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `e9b7f433b7bab28d9c92b359fdcfc075449f8b8dcf1e42c6bf2eb4a5f0110040` is **content-verified** against the opened log, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R3-UART-XSIM-01/`

New named wrap `a7ng_astra_09_r3_uart_wrap` (bag-local) instance **`u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv`**. Pin clock `CLK100MHZ` 10 ns → `MMCME2_BASE` 100→50 + `BUFG`. UART `uart_rx` / `uart_tx` `CLK_HZ=50_000_000` `BAUD=115200` 8N1. Bag-local behavioral AXI plant `a7ng_astra_09_r3_axi_plant`. TB `tb_astra_09_r3_uart_xsim`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not** instantiated and **not** compiled. Frozen SGD is instantiated **inside** A09-R2 only.

Gate under review is **work-order ASTRA-09-R3-UART-XSIM-01 only** — one unknown: can a UART-side XSim (UNISIM or behavioral host) drive tokens into instantiated A09-R2 and observe a smoke ANSWER / overflow INCOMP on the **byte stream**, with `load_from_tb=0`, **without** claiming BOARD_PASS?

**Not** Master ASTRA-09 production path. **Not** ASTRA-SOC-RTP-WRAP-UART-XSIM (`arty_a7_astra_rtp_soc_top` + `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128`). **Not** wrap-route bit. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** `PRODUCTION_TOP` freeze. **Not** silicon UART / silicon MMCM / silicon BRAM.

Hunt (parent / work order / this dispatch):

1. Are tokens actually UART 8N1 into `uart_rx`, or `axi_plant` bypass? Quote RTL.
2. Result bytes MAGIC A2 on `uart_tx` after real serialize? Quote log frames vs DUT wires.
3. `load_from_tb=0`? ISO if present?
4. Overflow INCOMP on UART stream, smoke ANSWER, UNREL?
5. MMCM UNISIM vs stub (`MMCM_MODE.txt`)?
6. Overclaim BOARD_PASS / silicon UART / wrap-route bit / `PRODUCTION_TOP` freeze?

Confirm: `a7ng_astra_09_r2_cand_ovf` instantiated; frozen A09 **not** compiled; ASTRA-SOC-RTP-WRAP-UART-XSIM **not** claimed as this bag.

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R3-UART-XSIM-01.md` + PREREG: instantiate frozen A09-R2 (`15a919f1…`); new named UART TB/wrap; smoke two-proof on UART-facing result bytes; CAND_CAP overflow INCOMP `ans=0`; UNREL no stale; `load_from_tb=0`; `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD, LM06, wrap-route bit; PROGRAM=NO; do not claim ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 as this bag.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *one integrated production path; remove fixture shortcuts; all functional regressions.*
3. **Master ASTRA-13**: silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260906T1630Z`: ASTRA-11-A09R2-IMPL-ROUTE-01 PASS_NARROW routed WNS=+0.648; residual = SoC UART wrap as a *candidate* production path, not this XSim glue, not a freeze.
5. Auditor `20260906T1600Z`: ASTRA-09-R2-CAND-OVF-01 PASS_NARROW DUT-level INCOMP `ans=0`; ISO_P3 +5 on **that** bag.

Out of this bag’s close: Master ASTRA-09 production UART (SoC top + on-chip plant), ASTRA-13 BOARD_PASS, wrap-route bit of this UART wrap or of `arty_a7_astra_rtp_soc_top`, LM06 language, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, `PRODUCTION_TOP` identity.

Prior bags `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-SOC-RTP-WRAP-UART-XSIM`, `ASTRA-11-A09R2-IMPL-ROUTE-01`, `ASTRA-09-INTEGRATED-PATH-01`, `ASTRA-11-A09-IMPL-ROUTE-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`16b2aabc…d012ad0c`). `write_scope` = new bag + distinctly named UART wrap/TB/plant that **instantiate** frozen `a7ng_astra_09_r2_cand_ovf` (no copy-paste graph; frozen `a7ng_astra_09_integ_path.sv` not compiled as DUT; A09-R2 DUT source not patched). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-SOC-RTP-WRAP-UART-XSIM, production_top_identity, write_bitstream, wrap_route_bit.

`run_xsim.ps1` is xvlog/xelab/xsim only. No `write_bitstream` / `xsdb` / `COM12` / `hw_server` / `program_device` strings. Script **throws** if live frozen A09 hash ≠ `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` or live R2 hash ≠ `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23` **before** xvlog. Script **throws** if compile list matches `astra_09_integ_path|astra_rtp_soc_top|astra09_pipe`.

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
| `ASTRA-09-R2-CAND-OVF-01/xsim.log` | session **Sun Sep 6 21:05:33 2026** PID **22184** snapshot `a09r2`; still prints `ISO_P3` / `OVF_CAND_CAP st=6` |
| `ASTRA-SOC-RTP-WRAP-UART-XSIM/xsim.log` | session **Sun Sep 6 02:28:45 2026** PID **39096** snapshot `wrapuart`; DUT=`arty_a7_astra_rtp_soc_top` |
| `ASTRA-11-A09R2-IMPL-ROUTE-01/timing_route.rpt` | Date **Sun Sep 6 21:26:25 2026**; Design State **Routed**; WNS=**0.648** TNS=0.000 WHS=0.126 |
| `ASTRA-09-INTEGRATED-PATH-01/xsim.log` | session **Sun Sep 6 18:53:05 2026** PID **40928** snapshot `a09ip` |

### Hash freeze (compiled + .svh) — MATCH (manifest, not re-hashed)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T21:45:31.3436033+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (both `.svh`) + CONFIG + stub-on-disk + KEEP_NOT_COMPILED **then** calls xvlog.  
Raw `xsim.log` session **Sun Sep 6 21:45:37–21:46:37 2026**, PID **19596**, snapshot `a09r3uart`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T21:46:37.7569149+07:00` (matches log exit `Exiting xsim at Sun Sep 6 21:46:37 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + transitive `.svh` vs POST: **18/18 MATCH** (opened manifests). Frozen leftover A09 `.sv` is KEEP_NOT_COMPILED / POST provenance, **not** in COMPILED list.

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
| bag `a7ng_astra_09_r3_axi_plant.sv` | `21a5ce13…59577519` |
| bag `a7ng_astra_09_r3_uart_wrap.sv` | `20cdeb8e…a3e88b41` |
| bag `tb_astra_09_r3_uart_xsim.sv` | `c6e6fa98…87f733b` |
| `a7ng_astra_09_integ_path.svh` (include only) | `ad2d66d4…b4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…71afd329` |
| KEEP leftover A09 `.sv` (not compiled) | `9fdbe0d6…bb5c776c` |
| KEEP `arty_a7_astra_rtp_soc_top.sv` (not compiled) | `a1f7a063…0853905fa` |

Overlapping R2 / SGD / leftover A09 / pkg hashes **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`. `uart_rx` / `uart_tx` prefixes **MATCH** ASTRA-SOC-RTP-WRAP-UART-XSIM KEEP (`8e802d0b` / `b4b7d097`). RTP wrap top `a1f7a063` is hashed here as KEEP_NOT_COMPILED and was **not** xvlog’d.

Handoff required R2 `15a919f1…` and leftover A09 `9fdbe0d6…`: **both present, R2 compiled, leftover A09 not compiled**.

### Compiled identity (raw xvlog / xelab / work sdb) — A09-R2 instantiated; leftover A09 not compiled

`xvlog.log` analyzes, in order: pkg, QSE, role, route gate, sparse_dir, query_axi_sparse, **SGD**, **`a7ng_astra_09_r2_cand_ovf`**, `uart_rx`, `uart_tx`, bag plant, bag wrap, bag TB. **No** `a7ng_astra_09_integ_path.sv`, **no** `arty_a7_astra_rtp_soc_top`, **no** `mmcm_stub`, **no** `astra09_pipe`. No ERROR/WARNING lines in that log.

`xelab.log` command:

```text
xelab.exe tb_astra_09_r3_uart_xsim glbl -s a09r3uart -timescale 1ns/1ps -L unisims_ver --debug typical
```

Compiled modules (raw xelab): `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, **`a7ng_astra_09_r2_cand_ovf_default`**, `a7ng_astra_09_r3_axi_plant`, `a7ng_astra_09_r3_uart_wrap`, `tb_astra_09_r3_uart_xsim`, `glbl`.

`Compile_Options.txt`: `"tb_astra_09_r3_uart_xsim" "glbl" -s "a09r3uart" -timescale "1ns/1ps" -L "unisims_ver"`.

`xsim.dir/work` sdb names (bag listing): `a7ng_astra_09_r2_cand_ovf.sdb`, `a7ng_astra_09_r3_uart_wrap.sdb`, `a7ng_astra_09_r3_axi_plant.sdb`, `uart_rx.sdb`, `uart_tx.sdb`, `tb_astra_09_r3_uart_xsim.sdb`, SGD / sparse / QSE / pkg / `glbl`. **No** `a7ng_astra_09_integ_path.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`, **no** `mmcm_stub.sdb`, **no** `a7ng_astra_rtp_pipe_r2.sdb`, **no** `a7ng_axi_bram128.sdb`.

Wrap RTL instantiates, does not copy, the frozen DUT:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 (
  .clk(clk), .rst_n(rst_n),
  ...
  .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok_b),
  .fire_i(fire), .retire_i(retire),
  ...
  .load_v_i(1'b0), .load_idx_i(5'd0), .load_w_i(16'sd0),
  ...
  .load_from_tb_o(tbl),
  .m_axi_arid(arid), ...
);
```

A09-R2 itself `include`s leftover A09 **`.svh` parameters only** and does **not** instantiate `a7ng_astra_09_integ_path`. Leftover A09 module was not elaborated.

### Hunt 1 — tokens are UART 8N1 into `uart_rx`, not `axi_plant` bypass

**CONFIRMED UART-real on the query path. Plant is AXI facts only.**

TB drives **only** pin `uart_txd_in` (idle 1). No `force` / `deposit` / hierarchical poke of `tok_i`. Bit-bang is 8N1 at pin-clock CPB:

```text
localparam int CPB = (CLK_PIN_HZ + BAUD/2) / BAUD;  // 100e6/115200 → 868
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

Wrap binds that pin to the board UART RX (50 MHz pipe, 115200):

```text
uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_rx (
  .clk(clk), .rst_n(rst_n), .rx(uart_txd_in), .data(rx_data), .valid(rx_valid)
);
```

`uart_rx.sv` is a real 8N1 sampler (IDLE→START mid-bit check→DATA 8 bits LSB-first→STOP, `valid` one cycle). Not a byte-wide backdoor.

FIFO → DUT tokens (EOL `0x0A`/`0x00` is **not** pushed; it arms `fire_pend`):

```text
assign is_eol = (rx_data == EOL) || (rx_data == 8'h00);
assign push   = rx_valid && !is_eol && !fifo_full;
assign pop    = !fifo_empty && tok_r && !tx_active && !do_retire;
...
if (push) fifo[wr_ptr] <= rx_data;
if (pop) begin tok_b <= fifo[rd_ptr]; tok_v <= 1'b1; ... end
...
if (fire_pend && (count == '0) && !push && tok_r && !busy && !tx_active
    && !do_retire && !pop) fire <= 1'b1;
```

DUT consumes those ports as query tokens (`tok_valid_i`/`tok_i` only while `st==S_IDLE`). `axi_plant` is wired **only** as AXI4-Lite/full AR/R slave (`s_axi_ar*` / `s_axi_r*`). Plant `mem_rd()` returns directory/posting/fact beats. **No plant port connects to `tok_i`.**

Anti-tautology timing (raw `xsim.log`, `%t` = 1 ps as RESULTS states; `$finish` at 9631755 ns):

| Event | t (ps) | Delta vs query start |
|-------|--------|----------------------|
| `QUERY_OVF_SENT` | 6_285_000 | 0 |
| `FIRE … plant=2` | 1_998_465_000 | **1.992 ms** |
| `QUERY_SMOKE_SENT` | 3_389_775_000 | 0 |
| `FIRE … plant=1` | 5_381_965_000 | **1.992 ms** |
| `QUERY_UNREL_SENT` | 6_775_075_000 | 0 |
| `FIRE … plant=1` | 8_246_465_000 | **1.471 ms** |

23-char `"pump requires indirect\n"` × 10 bits × 8680 ns/bit ≈ **1.996 ms**. 18-char `"payroll tax form\n"` ≈ **1.56 ms** (FIRE during last stop, as `uart_rx` raises `valid` at end of STOP while TB task still holds the stop bit). If tokens were hierarchical or plant-injected, FIRE would be microseconds after QUERY_*_SENT, not ~2 ms of 115200 8N1. **Not an `axi_plant` token bypass.**

Plant **is** a fixture for **facts** (behavioral, `N=20` vs `N=4` via `sw[1:0]`). That is disclosed in PREREG (`OVF_PLANT_N=20`, `PLANT_SMOKE`/`PLANT_OVF`). It is **not** a UART-token cheat. It **is** still a Master ASTRA-09 fixture shortcut vs silicon `a7ng_axi_bram128` — that keeps the bag **narrow**, not FAIL.

### Hunt 2 — MAGIC A2 on `uart_tx` after real serialize (not wire peek as the pass)

Wrap packs DUT result wires into 16 `tx_bytes` **then** walks `uart_tx`:

```text
if (result_v && !sent && !tx_active && !do_retire) begin
  tx_bytes[0]  <= MAGIC;                                 // 8'hA2
  tx_bytes[1]  <= {tbl, r_ovf, w_ovf, pend_acc, status};
  tx_bytes[2]  <= ans[7:0];
  ...
  tx_bytes[15] <= EOL;
  tx_active <= 1'b1;
end
if (tx_active && !tx_busy && !tx_start) begin
  tx_data  <= tx_bytes[tx_idx];
  tx_start <= 1'b1;
  ...
end
uart_tx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_tx (
  .clk(clk), .rst_n(rst_n), .start(tx_start), .data(tx_data),
  .tx(uart_rxd_out), .busy(tx_busy)
);
```

`uart_tx.sv` drives start bit 0, 8 data bits LSB-first, stop bit 1, `CLKS_PER_BIT=(50e6+115200/2)/115200=434` at 50 MHz = 8680 ns/bit. TB pass path samples **`uart_rxd_out`** (negedge start, mid-bit sample, CPB=868 on 100 MHz pin). `decode_and_check` asserts on that 16-byte frame, not on a planted `$display`.

Raw log: HIER `result_v` **then** 16 `UART_RX` bytes **then** `FRAME` (same bytes). OVF example:

```text
HIER result_v ans=0 p0=0 p1=0 st=6 tbl=0 npath=0 ntrunc=4 rov=1 wov=0 acc=0 t=1999325000
UART_RX n=1 byte=a2 t=2081825000
...
UART_RX n=16 byte=0a t=3384425000
FRAME OVF_UART a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a
DECODE OVF_UART magic=a2 tbl=0 st=6 ans=0 p0=0 p1=0 npath=0 ntrunc=4 rov=1 wov=0 acc=0 eol=0a hier_tbl=0
```

Byte spacing n=1→n=2: `2168665000-2081825000=86840000 ps = 86840 ns` ≈ 10 bit-times at 115200. Sixteen bytes of OVF occupy ~1.30 ms (15 intervals), matching 8N1 serialize, not an instantaneous hierarchical dump.

Packing of OVF byte `[1]=0x46`: `{tbl=0, r_ovf=1, w_ovf=0, pend_acc=0, status=6}` = `0100_0110`. SMOKE `[1]=0x10`: `{0,0,0,pend_acc=1, status=0}`. UNREL `[1]=0x01`: status=UNKNOWN. Independent of the RTP SoC wrap pack (`a2 00 04 …` with `{tbl,ovf,neg,amb,status}`).

HIER extra checks (`dut.ans`, `dut.status`, `dut.tbl`) **corroborate** the UART frames; they are not the pass authority. Frames would FAIL `_MAGIC` / `_ANS` if serialize were skipped.

### Hunt 3 — `load_from_tb=0`; ISO not in this TB

Frozen A09-R2:

```text
assign load_from_tb_o = 1'b0;
```

Wrap ties `load_v_i=1'b0` (no TB weight load). All three UART frames have `tbl=0` in byte[1][7] **and** byte[14][0], plus `hier_tbl=0`. PASS `*_TBL0` on OVF / SMOKE / UNREL.

**ISO:** not present in this wrap/TB/plant (`ISO` / `iso_` grep on the bag = no matches). ISO_P3 +5 remains evidence on **`ASTRA-09-R2-CAND-OVF-01`** (`xsim.log` still `ISO_P3 w0=5 viso=0` at 21:05:33). Work order for **this** bag did not require ISO. Not a miss against PREREG tests (OVF_UART / SMOKE_UART / UNREL_UART / HIER_TBL0).

No `freeze_i` pin on this wrap. `ctrl_i=2'd0`.

### Hunt 4 — overflow INCOMP, smoke ANSWER, UNREL on the UART stream

Raw `xsim.log` (zero `FAIL` lines; marker present; `$finish` 9631755 ns):

| Case | UART frame | Decode (UART bytes) | HIER wires |
|------|------------|---------------------|------------|
| OVF_UART | `a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a` | MAGIC A2; st=6 INCOMP; ans=0 p0=0 p1=0; ntrunc=4; rov=1; tbl=0 | ans=0 st=6 ntrunc=4 rov=1 **not** ANSWER 4 |
| SMOKE_UART | `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` | MAGIC A2; st=0 ANSWER; ans=4 p0=17 p1=34; npath=2; ntrunc=0; tbl=0 | ans=4 p0=17 p1=34 npath=2 |
| UNREL_UART | `a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a` | MAGIC A2; st=1 UNKNOWN; ans=0 p0=0 npath=0 tbl=0 | ans=0 npath=0 st=1 tbl=0 |

Marker:

```text
ASTRA_09_R3_UART_XSIM_PASS
$finish called at time : 9631755 ns
```

Overflow is the **DUT itself**, not a wrap rewrite of leftover A09 `ans=4`. Frozen A09-R2 `S_WALK` on `w_done`:

```text
walk_ovf = w_ovf || (w_trunc != 16'd0);
...
if (walk_ovf) begin
  r_st <= ST_INCOMP;
  best_a <= '0; best_p0 <= '0; best_p1 <= '0;
  pend_acc <= 1'b0;
  st <= S_HOLD;
end
```

`CAND_CAP=16` (`A7NG_A09R2_CAND_CAP`). Plant OVF `dir_pack(20)` and 16 extra fact ids 100–115. `ntrunc=4` = 20−16. Same query string as smoke; plant_sel=2 vs 1. **Not** leftover frozen-A09 `ans=4` (that module is not in the snapshot). Smoke after OVF retire is ANSWER 4 two-proof (`npath=2`). UNREL on smoke plant is UNKNOWN, not stale 4.

Selectivity: cap **16 < plant 20**. Not the “cap ≥ dataset” cheat.

### Hunt 5 — MMCM UNISIM, not stub, not silicon

`MMCM_MODE.txt` = `UNISIM_MMCME2_BASE` / `NOT_SILICON_MMCM=1`.  
xelab used `-L unisims_ver` and compiled **`unisims_ver.MMCME2_BASE`**, not `work.MMCME2_BASE`.  
`mmcm_stub.sv` is hashed (`52a43cd8…`) under `STUB_ON_DISK (xvlog only if unisim xelab fails)` and is **absent** from xvlog.log / work sdb.  
Wrap instantiates `MMCME2_BASE` (CLKIN1_PERIOD=10, MULT_F=10, DIVIDE_F=20 → 100 MHz in, 50 MHz out) + `BUFG`.  
`RST_N=1 locked=1 t=5645000` (5.645 µs) is POR `por_cnt==0xFF` after lock: 255 × 20 ns = 5.10 µs plus UNISIM lock, not “instant stub LOCKED + exactly 5100 ns”.

This is **XSim unisim behavioral MMCM**, not silicon MMCM, not a board clock. Implementer RESULTS states that. Not an overclaim.

### Hunt 6 — overclaim BOARD_PASS / silicon UART / wrap-route bit / PRODUCTION_TOP / RTP UART bag

**Not found as a close.** ACK / RESULTS / CLOSEOUT / metrics / MMCM_MODE all keep:

- `BIT = NOT_BUILT`
- `PROGRAM = false / NO`
- `PRODUCTION_TOP = UNKNOWN`
- `BOARD_PASS` listed under **Not claimed** / `does_not_close`
- silicon MMCM **not** claimed
- ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 **not** claimed as this bag
- wrap-route bit **not** claimed
- ASTRA-13 **not** opened

ASTRA-SOC-RTP-WRAP-UART-XSIM remains a **different DUT**: `arty_a7_astra_rtp_soc_top` + `a7ng_astra_rtp_pipe_r2` + `a7ng_axi_bram128`, session 02:28:45, FRAME `a2 00 04 00 00 11 00 00 22 00 00 02 02 02 02 0a`. This bag’s SMOKE FRAME is `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` (different byte[1] pack, different npath/ntrunc slots). Same smoke **integers** (ans=4 p0=17 p1=34) because the **query and two-hop facts** are the same recipe, now retrieved by instantiated **A09-R2** through this UART glue — not a copy of that bag’s log.

No BOARD_PASS, no JTAG serial in this bag’s logs, no COM12 transcript, no `.bit`.

Implementer `VERDICT_PROPOSED = PASS_NARROW (this bag only: UART XSim glue around instantiated A09-R2)` is **aligned** with the raw evidence. Not OVERCLAIM.

### RESULTS.md vs raw xsim.log — MATCH

| Claim | Raw |
|-------|-----|
| marker `ASTRA_09_R3_UART_XSIM_PASS` | present, after all PASS lines |
| SIM_TIME 9631755 ns | `$finish … 9631755 ns` |
| FAIL=0 | no `FAIL` lines |
| FAIL_R0 none | no `xsim_fail_r0.log` in bag |
| session 21:45:37–21:46:37 PID 19596 | xsim.log header + exit |
| three frames as quoted | exact byte match |
| `load_from_tb_o=0` | DECODE `hier_tbl=0` + TBL0 PASS ×3 |
| MMCM UNISIM | xelab `-L unisims_ver` + `unisims_ver.MMCME2_BASE` |
| leftover A09 not compiled | xvlog/xelab/sdb |

No log/RESULTS mismatch. No golden-edit theatre (first xvlog/xelab/xsim produced the marker; SHA frozen **before** xvlog).

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| UART tokens vs plant bypass | **UART-real.** Plant is AXI facts, not `tok_i`. FIRE delayed by full 8N1 query. |
| MAGIC A2 without serialize | **No.** `uart_tx` → sampled `uart_rxd_out`; 86840 ns/byte. |
| `load_from_tb` as query authority | **No.** Hardwired 0; wrap `load_v_i=0`; frames tbl=0. |
| ISO cheat / missing required ISO | ISO **not in this TB**; not required by this work order. A09-R2 ISO_P3 bag intact. |
| Cap ≥ dataset | **No.** CAND_CAP=16, OVF plant N=20, ntrunc=4. |
| Wrap around leftover A09 `ans=4` | **No.** Leftover A09 not compiled. OVF UART ans=0 st=6. |
| Stolen RTP-WRAP-UART MAGIC A2 close | **No.** Different DUT, different frame pack, that `xsim.log` still 02:28:45. |
| Stolen A09-R2 XSim as this bag | **No.** This snapshot includes `uart_rx`/`uart_tx`/wrap; A09-R2 log still 21:05:33. |
| Stolen wrap-route WNS=+0.648 / +5.733 / leftover A09 +1.041 | **No.** This bag has no timing reports. A11-A09R2 `timing_route.rpt` still 21:26:25 WNS=0.648. |
| BOARD_PASS / silicon UART / silicon MMCM | **Not claimed.** Unisim XSim only. |
| `PRODUCTION_TOP` freeze | **UNKNOWN.** Wrap comment: *Not PRODUCTION_TOP.* |
| Hash theatre / golden edit | SHA before xvlog; first-run PASS; compiled 18/18 PRE=POST (manifest). |
| TB hierarchical peek as sole pass | Extra checks exist; **UART frames independently sampled and checked.** Not tautology. |

Remaining **narrowness** (not cheats): behavioral AXI plant (not silicon BRAM / not `a7ng_axi_bram128`); bag-local wrap (not `arty_a7_astra_rtp_soc_top`); unisim MMCM (not silicon); no ISO_P3 on the UART stream; no bitstream.

---

## Logic bugs

None that break this bag’s declared UART-glue unknown.

Noted, not P1:

1. Wrap FIFO `unique case ({push,pop})` ignores `2'b11` for `count` (correct occupancy if both pointers move; not exercised as a fail).
2. Byte pack is **this wrap’s** `{tbl,r_ovf,w_ovf,pend_acc,status}` + ntrunc at [12:13] — **not** the RTP SoC wrap layout. Host software for a future board path must not assume the RTP frame. Disclosed in RESULTS.
3. Plant is combinatorial `mem_rd` (behavioral). Fine for XSim; not a BRAM model.
4. `mmcm_stub.sv` exists on disk as fallback; unused this run. Must not be cited as the MMCM that ran.
5. Synth/sim 8-7137 set+reset warning from frozen R2 (T1630) is **not re-litigated**; R2 hash `15a919f1…` unchanged. Do not patch frozen R2 from this bag.

Auditor does not fix.

---

## This bag vs Master ASTRA-09 UART / BOARD

Work-order unknown **answered**: a named UART-side XSim (UNISIM MMCM host, 115200 8N1) drove ASCII tokens into instantiated frozen `a7ng_astra_09_r2_cand_ovf` and observed, **on the serialized `uart_rxd_out` byte stream**, overflow INCOMP `ans=0` `ntrunc=4` and smoke ANSWER `ans=4 p0=17 p1=34` plus UNREL UNKNOWN, with `load_from_tb=0`, **without** BOARD_PASS.

Master **ASTRA-09** (*one integrated production path; remove fixture shortcuts*) remains **OPEN**:

- This wrap is bag-local `a7ng_astra_09_r3_uart_wrap`, **not** a frozen production SoC top.
- Memory plant is **behavioral AXI**, not on-chip `a7ng_axi_bram128` / not the RTP BASE BRAM image as silicon.
- Functional regressions of Master ASTRA-09 (ISO +5, MAX_PATH, full fixture-removal, SoC UART identity) are **not** all re-run here. ISO lives on the A09-R2 DUT bag, not on this UART stream.
- Leftover frozen A09 `ans=4` hole in `a7ng_astra_09_integ_path.sv` is **unpatched and unused** — still not a production close of that file.

Master **ASTRA-09 UART / BOARD** as a silicon UART loop (COM12 115200, programmed bit, MAGIC A2 on the wire) is **not** this bag. No `.bit`. PROGRAM=NO.

Master **ASTRA-13 FINAL-BOARD-ACCEPTANCE** remains **BLOCKED**. Board plugged ≠ authority.

ASTRA-SOC-RTP-WRAP-UART-XSIM remains a **separate** XSim PASS_NARROW on a **different** DUT (`rtp_pipe_r2` + BRAM128). It is also **not** BOARD. This bag does not inherit or overwrite it.

T1630 residual (*SoC UART wrap as a candidate production path*) is **not** closed by this XSim glue. Candidate path identity (`PRODUCTION_TOP`) stays **UNKNOWN**.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R3-UART-XSIM-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw XSim: UART 8N1 tokens into instantiated `a7ng_astra_09_r2_cand_ovf`, MAGIC A2 frames after real `uart_tx` serialize, OVF INCOMP `ans=0` `ntrunc=4` + smoke ANSWER 4/17/34 + UNREL no stale on the **byte stream**, `load_from_tb=0`, leftover A09 not compiled, RTP UART bag not claimed, UNISIM MMCM (not stub, not silicon), PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`, no BOARD_PASS.

Not PASS (Master ASTRA-09 production path / fixture-free SoC UART / silicon plant / BOARD).  
Not FAIL (raw log matches PREREG tests; UART path is real; overflow is DUT INCOMP not leftover `ans=4`; hashes PRE/POST aligned; prior bags intact).  
Not OVERCLAIM (ACK/RESULTS keep Master 09/13/BOARD/RTP-UART/`PRODUCTION_TOP` open; marker is bag-local `ASTRA_09_R3_UART_XSIM_PASS`).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared UART-side XSim glue unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this XSim to BOARD_PASS, ASTRA-13, silicon UART, silicon MMCM, wrap-route bit, or `PRODUCTION_TOP=a7ng_astra_09_r3_uart_wrap` / `a7ng_astra_09_r2_cand_ovf`.
2. Do **not** claim ASTRA-SOC-RTP-WRAP-UART-XSIM MAGIC A2 (`a2 00 04…` / `arty_a7_astra_rtp_soc_top`) as closed by this bag. Different DUT, different frame pack.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` (leftover `ans=4` hole remains in that file) and do **not** patch frozen A09-R2 (`15a919f1…`).
5. Behavioral `a7ng_astra_09_r3_axi_plant` remains a **fixture**. A production UART path still needs a named SoC top + on-chip plant (or an explicit `PRODUCTION_TOP` decision). That is Master ASTRA-09 / ASTRA-11 residual, not a silent close from this glue.
6. ISO_P3 was **not** replayed on the UART stream. If parent still wants ISO on the byte stream, that is a **new** named bag — not a P1 on this one.
7. Host parsers must not mix this wrap’s 16-byte layout with the RTP SoC wrap layout.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated UART-side XSim around instantiated frozen `a7ng_astra_09_r2_cand_ovf`: tokens are **UART-real 8N1 into `uart_rx`**, result MAGIC A2 is **real `uart_tx` serialize**, OVF INCOMP + smoke ANSWER + UNREL visible on the byte stream, `load_from_tb=0`, leftover A09 not compiled, RTP UART bag not claimed, UNISIM MMCM not stub, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`.

`REJECT_PROMOTION` — Master **ASTRA-09** (production UART path / fixture-free plant / SoC top), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. UART-real **≠** silicon UART.

Master ASTRA-09 UART / BOARD: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-SOC-RTP-WRAP-UART-XSIM: **untouched, different DUT, still not BOARD**.  
ASTRA-11-A09R2-IMPL-ROUTE-01 routed WNS=+0.648: **untouched**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1700Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-R3-UART-XSIM-01; UART-real (8N1 into uart_rx / MAGIC A2 after uart_tx serialize) vs plant=AXI-facts-only-fixture not token-bypass; Master ASTRA-09 UART/BOARD OPEN; PROGRAM=NO; BOARD still blocked YES.
