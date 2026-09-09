# ASTRA auditor REPORT — 20260907T0030Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R5_UART_ISO_INNER_INDEPENDENT_AUDIT; astra09_r5=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR; astra09_r4=AUDITOR_PASS_NARROW_SIBLING_ISO; astra12_r3=AUDITOR_PASS_NARROW_9_ROW_TABLE; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + MASTER ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-09-R5-UART-ISO-INNER-01 + prior auditor 20260907T0005Z (R4 UART ISO PASS_NARROW ACCEPT_PARTIAL; residual 5: sibling u_iso, not inner u_sgd; BOARD blocked YES) + auditor 20260906T1700Z (A09-R3 UART XSim PASS_NARROW) + auditor 20260906T1600Z (A09-R2 DUT-level ISO_P3 w0=5 viso=0 on sibling SGD, TB-poked go_u)
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / Compile_Options.txt / xsim.dir/work sdb names / wrap+TB SV / uart_rx.sv / uart_tx.sv / frozen A09-R2 SV+SVH / frozen SGD / MMCM_MODE.txt / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / PREREG.md / ACK.json / run_xsim.ps1 / metrics.json / CLOSEOUT.md (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_xsim.ps1` (would overwrite `xsim.log`). Did not xvlog/xsim.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/pkg/uart hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` and `ASTRA-09-R4-UART-ISO-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `15fab87b404bc20ad94fc588e8b20fe9a55d473aef86cf65dc886e1c49b5a4fb` is **content-verified** against the opened log, not independently re-digested.

Evidence labels: XSim quotes below are **EVIDENCE**. SGD integer re-derive is **EVIDENCE** from frozen RTL. “UART-real timing matches 8N1” is **ENGINEERING_INFERENCE** from `%t` deltas vs CPB. Silicon / BOARD / bitstream claims are **absent** (correct). Hierarchical `force`/`release` of inner SGD ports is **EVIDENCE** (wrap RTL) and is a **fixture shortcut** vs Master ASTRA-09, not a silent cheat of this bag’s declared XSim unknown.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R5-UART-ISO-INNER-01/`

New named wrap `a7ng_astra_09_r5_uart_iso_inner_wrap` (bag-local) instantiates:

- `u_a09r2` = frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` (`15a919f1…`) **only**
- inner child `u_a09r2.u_sgd` = frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`b66ef328…`) — **not** a wrap sibling

Pin clock `CLK100MHZ` 10 ns → `MMCME2_BASE` 100→50 + `BUFG`. UART `uart_rx` / `uart_tx` `CLK_HZ=50_000_000` `BAUD=115200` 8N1. TB `tb_astra_09_r5_uart_iso_inner`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not** instantiated and **not** compiled. ASTRA-09-R4 wrap/TB **not** this DUT and **not** overwritten. ASTRA-09-R3 wrap/TB **not** this DUT.

Gate under review is **work-order ASTRA-09-R5-UART-ISO-INNER-01 only** — one unknown (handoff):

> Can UART 8N1 drive `go_upd`/`x`/`rew` into **A09-R2 inner `u_sgd`** (hierarchical `u_a09r2.u_sgd.w_o[0]`) so ISO_P3 w0=+5 and ISO_M3 w0=-6, with `load_from_tb=0` — **without a sibling SGD**?

This is auditor **20260907T0005Z residual 5**: R4 UART ISO was real but hit wrap sibling `u_iso`; `a09_w0=0`; inner learner starved. Parent chose the **inner learner** path. **Not** a bit. **Not** a freeze.

**Not** Master ASTRA-09 production path. **Not** ASTRA-09-R4 sibling-ISO close. **Not** ASTRA-09-R3 MAGIC A2 query OVF/SMOKE/UNREL. **Not** wrap-route bit. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** `PRODUCTION_TOP` freeze. **Not** silicon UART / silicon MMCM.

Hunt (parent / work order / this dispatch):

1. Only one SGD: A09-R2 inner `u_sgd`? No `u_iso` / second `a7ng_shared_rank_sgd` in wrap/TB?
2. UART 8N1 drives `go_upd` into that inner instance? Quote wrap FSM.
3. Raw log hierarchical `u_a09r2.u_sgd.w_o[0]` +5 then -6? `tbl=0`?
4. Frozen A09-R2/SGD hashes unchanged? ASTRA-09-R4 not overwritten?
5. Overclaim BOARD_PASS / `PRODUCTION_TOP` freeze?
6. Hash `.svh` before xvlog? PROGRAM=NO?

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R5-UART-ISO-INNER-01.md` + PREREG: one SGD = inner A09-R2 learner; wrap/TB must not instantiate parallel `u_iso` for pass numbers; raw log quotes inner w0 ISO_P3 +5 and ISO_M3 -6; `PRODUCTION_TOP=UNKNOWN`; do not close ASTRA-13, BOARD, silicon UART; PROGRAM=NO; SHA including `.svh` before xvlog; do not edit R4 / frozen A09-R2 / SGD.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *one integrated production path; remove fixture shortcuts; all functional regressions.*
3. **Master ASTRA-13**: silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260907T0005Z`: R4 PASS_NARROW UART-driven sibling ISO; residual 5 = inner `u_sgd` still open.
5. Auditor `20260906T1700Z`: A09-R3 UART XSim PASS_NARROW; residual 6 was ISO_P3 not on UART stream (answered narrowly on R4, sibling).
6. Auditor `20260906T1600Z`: A09-R2 bag ISO_P3 `w0=5 viso=0` on a **sibling** frozen SGD, TB-poked `go_u`.

Out of this bag’s close: Master ASTRA-09 production UART (SoC top + on-chip plant + ISO through A09-R2 **public** token/reward/query into inner `u_sgd` **without** sim `force`), ASTRA-13 BOARD_PASS, wrap-route bit of this UART ISO wrap, LM06 language, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, `PRODUCTION_TOP` identity, silicon UART.

Prior bags `ASTRA-09-R4-UART-ISO-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-11-A09R3-UART-*` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`f45de6e7…5a9f9c69`). `write_scope` = new bag + distinctly named UART ISO-INNER wrap/TB that **instantiate frozen `a7ng_astra_09_r2_cand_ovf` only** (inner `u_sgd` is the one SGD; no parallel `u_iso`; frozen leftover A09 not compiled as DUT; A09-R2 DUT source not patched; ASTRA-09-R4 wrap/TB not edited; ASTRA-09-R3 wrap/TB not edited). `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-09-R3-UART-XSIM-01, **ASTRA-09-R4-UART-ISO-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, production_top_identity, write_bitstream, wrap_route_bit, silicon_UART, sibling_u_iso_as_production_law.

`run_xsim.ps1` is xvlog/xelab/xsim only. **No** `write_bitstream` / `xsdb` / `COM12` / `hw_server` / `program_device` strings (grep; the only `vivado` hit is the license env path). Script **throws** if live frozen A09 hash ≠ `9fdbe0d6…` or live R2 hash ≠ `15a919f1…` or live SGD hash ≠ `b66ef328…` **before** xvlog. Script **throws** `A09R5_SIBLING_SGD_IN_WRAP` / `_IN_TB` if wrap/TB match `(?m)^\s*a7ng_shared_rank_sgd_q8_sym_f2r2\s+\w+`. Script **throws** if compile list matches `astra_09_integ_path|astra_rtp_soc_top|astra09_pipe|astra_09_r3_uart|astra_09_r4_uart`.

Bag listing: **no** `.bit`, no `timing*.rpt`, no `vivado.log`, no `xsim_fail_r0.log` (first-run marker; no fail-corrective). Wrap/TB live **only** in this bag — grep `a7ng_astra_09_r5` under `rtl/` = **no matches**. `MMCM_MODE.txt`:

```text
MMCM_MODE=UNISIM_MMCME2_BASE
NOT_SILICON_MMCM=1
PROGRAM=NO
PRODUCTION_TOP=UNKNOWN
```

Prior bags **not rewritten** (headers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| `ASTRA-09-R4-UART-ISO-01/xsim.log` | session **Mon Sep 7 00:12:53 2026** PID **47704** snapshot `a09r4iso`; still prints `ASTRA_09_R4_UART_ISO_PASS`; `$finish` **3471575 ns**; exit **00:13:17** |
| `ASTRA-09-R4-UART-ISO-01` wrap SHA | KEEP in this bag `cc8ffdaa…836703ab` **MATCH** R4 `SHA256.txt` compiled wrap |
| `ASTRA-09-R3-UART-XSIM-01/xsim.log` | session **Sun Sep 6 21:45:37 2026** PID **19596** snapshot `a09r3uart` |
| `ASTRA-09-R2-CAND-OVF-01/xsim.log` | session **Sun Sep 6 21:05:33 2026** PID **22184** snapshot `a09r2` |
| `ASTRA-12-R3-UART-WRAP-CANDIDATES-01/RESULTS.md` | `PRODUCTION_TOP=UNKNOWN`; `CANDIDATE_COUNT=9`; `BOARD_PASS=NOT_CLAIMED`; `ASTRA-13=BLOCKED` |

### Hash freeze (compiled + .svh) — MATCH (manifest, not re-hashed)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-07T00:34:39.7026168+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (five `.svh`, including leftover A09 `.svh` and A09-R2 `.svh`) + CONFIG + stub-on-disk + KEEP_NOT_COMPILED **then** calls xvlog.  
Raw `xsim.log` session **Mon Sep 7 00:34:46–00:35:10 2026**, PID **11336**, snapshot `a09r5iso`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-07T00:35:10.6283814+07:00` (matches log exit `Exiting xsim at Mon Sep  7 00:35:10 2026`).  
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
| bag `a7ng_astra_09_r5_uart_iso_inner_wrap.sv` | `ee02935e…2f95999e` |
| bag `tb_astra_09_r5_uart_iso_inner.sv` | `05e73db9…ac0d1d98` |
| `a7ng_astra_09_integ_path.svh` (include only) | `ad2d66d4…b4e94302` |
| `a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…71afd329` |
| KEEP leftover A09 `.sv` (not compiled) | `9fdbe0d6…bb5c776c` |
| KEEP R4 UART wrap (not compiled) | `cc8ffdaa…836703ab` |
| KEEP R3 UART wrap (not compiled) | `20cdeb8e…a3e88b41` |

Overlapping R2 / SGD / leftover A09 / pkg hashes **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` **and** `ASTRA-09-R4-UART-ISO-01/SHA256.txt`. `uart_rx` / `uart_tx` prefixes **MATCH** R4. Handoff required R2 `15a919f1…`, leftover A09 `9fdbe0d6…`, SGD `b66ef328…`: **all three present, R2+SGD compiled, leftover A09 not compiled**. Frozen hashes **unchanged**.

`.svh` hashed **before** xvlog: **YES**. PROGRAM=NO: **YES**. ASTRA-09-R4 not overwritten: **YES**.

### Compiled identity (raw xvlog / xelab / work sdb) — one SGD module, one inner instance

`xvlog.log` analyzes, in order: pkg, QSE, role, route gate, sparse_dir, query_axi_sparse, **SGD**, **`a7ng_astra_09_r2_cand_ovf`**, `uart_rx`, `uart_tx`, bag wrap, bag TB. **No** `a7ng_astra_09_integ_path.sv`, **no** `a7ng_astra_09_r3_uart_wrap`, **no** `a7ng_astra_09_r4_uart_iso_wrap`, **no** `mmcm_stub`. No ERROR lines in that log.

`xelab.log` command:

```text
xelab.exe tb_astra_09_r5_uart_iso_inner glbl -s a09r5iso -timescale 1ns/1ps -L unisims_ver --debug typical
```

Compiled modules (raw xelab): `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, **`a7ng_shared_rank_sgd_q8_sym_f2r2`** (once), **`a7ng_astra_09_r2_cand_ovf_default`**, `a7ng_astra_09_r5_uart_iso_inner_wrap`, `tb_astra_09_r5_uart_iso_inner`, `glbl`. One unconnected-port WARNING on `CLKFBOUTB` (wrap line 24) — not a FAIL.

`Compile_Options.txt`: `"tb_astra_09_r5_uart_iso_inner" "glbl" -s "a09r5iso" -timescale "1ns/1ps" -L "unisims_ver" --debug "typical"`.

`xsim.dir/work` sdb names (bag listing): `a7ng_astra_09_r2_cand_ovf.sdb`, `a7ng_astra_09_r5_uart_iso_inner_wrap.sdb`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sdb` (**one**), `uart_rx.sdb`, `uart_tx.sdb`, `tb_astra_09_r5_uart_iso_inner.sdb`, sparse / QSE / pkg / `glbl`. **No** `a7ng_astra_09_integ_path.sdb`, **no** `a7ng_astra_09_r3_uart_wrap.sdb`, **no** `a7ng_astra_09_r4_uart_iso_wrap.sdb`, **no** `mmcm_stub.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`.

SGD is compiled because frozen A09-R2 instantiates it as inner `u_sgd`. That is **one instance**, not a wrap sibling.

---

### Hunt 1 — Only one SGD: inner A09-R2 `u_sgd`; no wrap/TB `u_iso` — YES

Wrap instantiates frozen A09-R2 **only**:

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 (
  ...
  .tok_valid_i(tok_v), ... .tok_i(tok_b),
  .fire_i(fire), .retire_i(retire),
  .rew_v_i(1'b0), .rew_i(4'sd0), ...
  .load_v_i(1'b0), ...
  .load_from_tb_o(tbl),
  .w_o(w_a09),
  ...
);
```

Grep wrap for `u_iso`: **no matches**. Grep wrap/TB for an instantiation `a7ng_shared_rank_sgd_q8_sym_f2r2 <name>`: **none** (TB has no SGD ident at all). Contrast R4 wrap, which **did** instantiate sibling:

```text
a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso ( ... .go_upd_i(go_u), .w_o(wiso) );
```

Frozen A09-R2 itself contains the one learner:

```text
a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
  .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
  .go_score_i(sgd_go), .go_upd_i(sgd_upd), .x_i(phi), .reward_i(rew_lat),
  .load_v_i(load_v_i && (st==S_IDLE)), ...
  .w_o(w_o), .ready_o(sgd_ready), .done_o(sgd_done), .v_q8_o(sgd_v)
);
```

`assign load_from_tb_o = 1'b0;` in A09-R2. Wrap ties `.load_v_i(1'b0)`. Query/learn public path is **starved** this bag (`tok_v=0`, `fire=0`, `retire=0`, `rew_v_i=0`, AXI `rvalid=0`). Pass numbers are hierarchical probes of **that** inner child:

```text
assign inner_rdy = u_a09r2.u_sgd.ready_o;
assign inner_dn  = u_a09r2.u_sgd.done_o;
assign inner_w0  = u_a09r2.u_sgd.w_o[0];
```

**Inner-only SGD: YES.** Compiled SGD file + inner instance ≠ a second ISO block.

---

### Hunt 2 — UART 8N1 drives `go_upd` into that inner instance — UART-DRIVEN (via wrap FSM + sim `force`)

**CONFIRMED UART-real on the ISO command and result path. TB does not poke `go_upd` / `x_i`.**

TB drives **only** pin `uart_txd_in` (idle 1). No TB `force` / `$deposit` / hierarchical assign of inner SGD inputs. The only TB `pulse_go` reference is a **display** probe:

```text
always @(posedge dut.clk) begin
  if (dut.pulse_go)
    $display("INNER_GO x0=%0d rew=%0d t=%0t", $signed(dut.x0_lat),
      $signed(dut.iso_rew), $time);
```

Bit-bang is 8N1 at pin-clock CPB (100 MHz / 115200 → 868):

```text
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

Wrap FSM (`C_IDLE→C_X→C_REW→C_EOL→C_HOLDX→C_GO→C_WAIT→C_TX`) latches UART bytes, then pulses inner `go_upd` **inside the wrap**:

```text
C_IDLE: if (rx_valid && (rx_data == CMD_ISO) && !tx_active) cst <= C_X;
C_X:    if (rx_valid) begin x0_lat <= rx_data; cst <= C_REW; end
C_REW:  if (rx_valid) begin rew8_lat <= rx_data; iso_rew <= rx_data[3:0]; cst <= C_EOL; end
C_EOL:  if (rx_valid) cst <= (rx_data == EOL) ? C_HOLDX : C_IDLE;
C_HOLDX: begin hold_x <= 1'b1; if (inner_rdy) cst <= C_GO; end
C_GO:   begin hold_x <= 1'b1; if (inner_rdy) pulse_go <= 1'b1; else cst <= C_WAIT; end
C_WAIT: if (inner_dn) begin ... pack tx_bytes from inner_w0 ... cst <= C_TX; end
```

Frozen A09-R2 does **not** export `go_upd`/`x`/`rew`. Wrap injects the UART-latched vector into the **same** inner instance with sim `force`/`release` (not a second SGD):

```text
always @(*) begin
  if (!rst_n) begin
    release u_a09r2.u_sgd.x_i;
    release u_a09r2.u_sgd.reward_i;
    release u_a09r2.u_sgd.go_upd_i;
  end else begin
    if (hold_x) begin
      force u_a09r2.u_sgd.x_i = xiso;
      force u_a09r2.u_sgd.reward_i = iso_rew;
    end else begin
      release u_a09r2.u_sgd.x_i;
      release u_a09r2.u_sgd.reward_i;
    end
    if (pulse_go)
      force u_a09r2.u_sgd.go_upd_i = 1'b1;
    else
      release u_a09r2.u_sgd.go_upd_i;
  end
end
```

`xiso[0] = x0_lat` (combinational from the UART-latched byte). `pulse_go` is wrap-internal, default-cleared every cycle (`pulse_go <= 1'b0` at the top of the FF). **Not** a TB hierarchical poke.

**Disclosed NARROW vs Master ASTRA-09:** this is UART-triggered **sim `force` of inner SGD primitive ports**, not A09-R2 public `rew_v_i` / `tok_valid_i` (those are tied 0). A09-R2’s own `sgd_upd` path (`rew_v_i` while `pend_acc`, line 581–592 of frozen DUT) is **idle**. `force`/`release` is not a bitstream construct. Do **not** freeze this wrap as `PRODUCTION_TOP`. For **this bag’s declared XSim unknown** (drive `go_upd`/`x`/`rew` into inner `u_sgd` without a sibling), the force is the glue, not a second learner.

Result path is real `uart_tx` serialize of `inner_w0` after `inner_dn`, sampled by TB 8N1 on `uart_rxd_out` (negedge start, mid-bit sample, LSB-first). Frame MAGIC A2 / EOL 0x0A.

UART-real timing (raw log, `%t` = 1 ps; `$finish` reports ns):

| Event | t (ps) | ns |
|-------|--------:|---:|
| `ISO_P3_CMD_SENT` | 6_285_000 | 6.285 |
| `INNER_GO x0=50 rew=3` | 349_285_000 | 349.285 |
| `INNER_DONE w0=5` | 350_625_000 | 350.625 |
| `UART_RX n=1 byte=a2` | 433_125_000 | 433.125 |
| `UART_RX n=2 byte=40` | 519_965_000 | 519.965 |

CMD_SENT → INNER_GO Δ = **343.000 µs**. Four host bytes × 10 bits × 8680 ns = 347.200 µs; last `rx_valid` is ~1 stop-bit early on the 50 MHz sampler (CLKS_PER_BIT=434, HALF=217). **MATCH UART-real, not a zero-delay poke.**

TX byte spacing n=1→n=2: 519_965_000 − 433_125_000 = **86_840_000 ps = 86840 ns**. Ten bits × 8680 ns = 86800 ns. Extra 40 ns = pin-clock alignment. **UART-real TX.**

Note (not FAIL): `INNER_GO` prints two adjacent 50 MHz cycles (349285000 then 349305000, Δ=20 ns). Wrap `C_GO` stays in-state while `inner_rdy` and re-arms `pulse_go`. Frozen SGD `ready_o=(st==IDLE)` accepts `go_upd` **once** (leaves IDLE NBA); second pulse lands in SCORE and is ignored. P3 inner w0=+5 **not** +10. Same class as implementer RESULTS note.

---

### Hunt 3 — raw log hierarchical `u_a09r2.u_sgd.w_o[0]` +5 then -6; `tbl=0` — MATCH

Raw `xsim.log` (authority; session Mon Sep 7 00:34:46 PID 11336; `$finish` **3471615 ns**):

```text
ISO_P3_CMD_SENT x0=50 rew=+3 t=6285000
INNER_GO x0=50 rew=3 t=349285000
INNER_GO x0=50 rew=3 t=349305000
INNER_DONE w0=5 v=0 w1=0 tbl=0 a09_w0=5 t=350625000
...
FRAME ISO_P3 a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a
ISO_P3 w0=5 v=0 w1=0 x0=50 rew=3 tbl=0 iso=1 inner_w0=5 hier_sgd_w0=5 a09_w0=5 hier_tbl=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_PRE_W0
ISO_M3_CMD_SENT x0=64 rew=-3 t=1742155000
INNER_GO x0=64 rew=-3 t=2085165000
INNER_DONE w0=-6 v=0 w1=0 tbl=0 a09_w0=-6 t=2086505000
...
FRAME ISO_M3 a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a
ISO_M3 w0=-6 v=0 w1=0 x0=64 rew=-3 tbl=0 iso=1 inner_w0=-6 hier_sgd_w0=-6 a09_w0=-6 hier_tbl=0
PASS ISO_M3_X64_DW6
ASTRA_09_R5_UART_ISO_INNER_PASS
```

Zero `FAIL` lines in `xsim.log` (opened full log; TB FAIL `$display` templates did not fire). Marker present. `FAIL_R0` file absent (first xvlog/xelab/xsim). RESULTS `SIM_TIME=3471615 ns` MATCH `$finish`.

Frame decode (little-endian w0):

| Case | UART bytes | w0 LE | x0 | rew8 | tbl bit | hier `u_sgd.w_o[0]` | `a09_w0` |
|------|------------|------:|---:|-----:|--------:|--------------------:|---------:|
| ISO_P3 | `a2 40 05 00 00 00 32 03 … 0a` | **+5** (`05 00`) | 50 (`32`) | +3 (`03`) | 0 | **+5** | **+5** |
| ISO_M3 | `a2 40 fa ff 00 00 40 fd … 0a` | **-6** (`fa ff`) | 64 (`40`) | -3 (`fd`) | 0 | **-6** | **-6** |

Contrast T0005Z R4: same frames on sibling `wiso`, but **`a09_w0=0`**. This bag: **`a09_w0` matches inner `u_sgd.w_o[0]`** because frozen A09-R2 exports `w_o` from that child. Residual 5’s inner-learner observable is **answered**.

`load_from_tb=0` on both:

- A09-R2 RTL: `assign load_from_tb_o = 1'b0;`
- Wrap: `.load_v_i(1'b0)` into A09-R2
- TB: no `load_v` / weight preload; ISO_M3 `wrap_rst()` then `chk("ISO_M3_PRE_W0", dut.inner_w0 === 16'sd0 && dut.u_a09r2.u_sgd.w_o[0] === 16'sd0)` so M3 starts from **reset zero**, not leftover P3 +5
- Raw dumps: `tbl=0` `hier_tbl=0` `PASS ISO_P3_TBL0` `PASS ISO_M3_TBL0`

`freeze_i=1'b0` on inner `u_sgd` (A09-R2 port tie). Force does **not** target `w_o` — only `x_i` / `reward_i` / `go_upd_i`. Weights come from the SGD update.

SGD law re-derived from frozen `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`SHIFT=6`, `dw40=rsh40(err*x, 7+SHIFT)`, `err=rew*256-v`, `w=0` ⇒ `v=0`):

- P3: `rew=+3`, `x0=50` → `err=768`, `prod=38400`, `rsh40(38400,13)=(38400+4096)>>>13=5` → **w0=+5**
- M3: `rew=-3`, `x0=64` → `err=-768`, `prod=-49152`, `rsh40(-49152,13)=-(49152+4096)>>>13=-6` → **w0=-6**

Not floor-shift +4. Matches T1600 / T0005Z ISO integers, now on **inner** `w_o[0]`. `v=0` is the from-zero score, not a tautology of a constant TX template: w0 bytes differ (`05 00` vs `fa ff`) and match hierarchical `u_a09r2.u_sgd.w_o[0]` after `INNER_DONE`.

`iso_rew <= rx_data[3:0]` is the frozen SGD port width (`reward_i` is `signed [3:0]`). `0x03` → +3; `0xFD` → nibble `0xD` = -3. Honest for this ISO pair.

---

### Hunt 4 — Frozen A09-R2/SGD hashes unchanged; ASTRA-09-R4 not overwritten — MET

See hash section. Frozen R2 `15a919f1…` / SGD `b66ef328…` / leftover A09 `9fdbe0d6…` MATCH R2 bag, MATCH R4 bag, MATCH this PRE/POST. R4 `xsim.log` still 00:12:53 PID 47704 with `ASTRA_09_R4_UART_ISO_PASS`. R4 wrap KEEP hash `cc8ffdaa…` MATCH R4 compiled wrap. R5 wrap is a **new** file `ee02935e…`, not an edit of R4 wrap. R3 log still 21:45:37 PID 19596.

---

### Hunt 5 — Overclaim BOARD_PASS / silicon UART / PRODUCTION_TOP freeze — NO

ACK / PREREG / RESULTS / CLOSEOUT / metrics / MMCM_MODE / TB banner all keep:

- `PRODUCTION_TOP=UNKNOWN`
- `PROGRAM=false` / `PROGRAM=NO`
- `BIT=NOT_BUILT`
- `BOARD_PASS` in `not_claimed` / OPEN
- `ASTRA-13` OPEN / BLOCKED
- silicon UART / silicon MMCM **not** claimed (`UNISIM_MMCME2_BASE`, `NOT_SILICON_MMCM=1`)
- ASTRA-09-R4 sibling frames **not** claimed as this bag
- ASTRA-09-R3 MAGIC A2 query frames **not** claimed as this bag
- wrap **not** named as production top

Marker is bag-local `ASTRA_09_R5_UART_ISO_INNER_PASS`, not `BOARD_PASS`, not `ASTRA_09_R4_UART_ISO_PASS`. CLOSEOUT `PASS_THIS_GATE_ONLY`. RESULTS proposed `PASS_NARROW (this bag only: UART-facing ISO of frozen A09-R2 INNER u_sgd …)`.

No `.bit` / `.bin` / `.mcs` in the bag. `run_xsim.ps1` cannot program.

---

### Hunt 6 — Hash `.svh` before xvlog; PROGRAM=NO — MET

See hash section. Five `.svh` in `TRANSITIVE_INCLUDES` of `SHA256.txt` **before** xvlog. POST 17/17 MATCH. PROGRAM=NO throughout.

---

### This bag vs Master ASTRA-09 one-path learner

| Claim | This bag | Master ASTRA-09 |
|-------|----------|-----------------|
| UART 8N1 isolated SGD ISO `+3,x0=50→w0=+5` and `-3,x0=64→w0=-6` on **byte stream** + hier **inner** `u_a09r2.u_sgd.w_o[0]`, `load_from_tb=0`, **no sibling SGD** | **YES** (XSim) | Required as **one** functional regression, not the whole gate |
| Same learner the query path uses (inner `u_sgd`) | **YES** (instance identity) | Required |
| Drive that learner through A09-R2 **public** token/reward/query (no sim `force`) | **NO** — public ports starved; wrap `force` of inner `go_upd_i`/`x_i`/`reward_i` | **OPEN** (fixture shortcut remains) |
| One integrated production path; remove fixture shortcuts | **NO** — bag-local wrap; query idle; sim `force` | **OPEN** |
| SoC UART identity / on-chip plant / wrap-route bit | **NO** | **OPEN** |
| Silicon UART on COM12 | **NO** | ASTRA-13 / BOARD — **BLOCKED** |

T0005Z residual 5 (*UART tokens/reward must hit the same learner A09-R2 query uses*) is **answered on instance identity and inner w0 numbers**, narrowly. It is **not** answered as production-path ISO through the DUT’s own `rew_v_i`/`tok_*` FSM. Do **not** promote Master ASTRA-09.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| Wrap/TB instantiate sibling `u_iso` / second SGD for pass numbers | **No.** One `u_a09r2`; inner `u_sgd` only. Grep `u_iso` in wrap/TB = empty. Script would throw on a wrap/TB SGD instantiation. |
| TB poke `go_upd` / `x_i` as ISO authority | **No.** TB bit-bangs `uart_txd_in` only. Wrap FSM pulses `pulse_go` after UART `A5 x0 rew 0A`. No TB `force`/`$deposit`. |
| UART TX is a constant template (tautology) | **No.** P3/M3 frames differ in w0 (`05 00` vs `fa ff`) and x0/rew; match `INNER_DONE` hier `u_sgd.w_o[0]`; TX spacing is 86840 ns/byte. |
| Force `w_o` to the golden | **No.** Force targets `x_i` / `reward_i` / `go_upd_i` only. w0 re-derives from frozen SGD law. |
| `load_from_tb` as query/ISO authority | **No.** A09-R2 hard 0; `load_v_i=0`; dumps `tbl=0`. Weights from reset-zero SGD update, not TB preload. |
| `freeze_i=1` cheat | **No.** Inner `u_sgd.freeze_i=1'b0`. |
| ISO through A09-R2 **public** token/reward | **No — disclosed NARROW.** Public `tok_v`/`rew_v_i` tied 0. Inner ports driven by sim `force`. Same inner instance, not the production handshake. |
| Claim R4 sibling-ISO / R3 OVF/SMOKE as this result | **No.** R4 `xsim.log` still 00:12:53 PID 47704; R3 still 21:45:37 PID 19596; this marker is `ASTRA_09_R5_UART_ISO_INNER_PASS`. |
| Golden edit / wipe prior xsim.log | **Not found.** No `xsim_fail_r0.log`; prior R2/R3/R4/12-R3 logs/headers intact. |
| Hash theatre after scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes both A09 `.svh`. POST 17/17 MATCH. |
| BOARD_PASS / silicon UART / `PRODUCTION_TOP` freeze | **Not claimed.** |
| Floor-shift +4 labeled as Master symmetric +5 | **No.** Raw inner w0=+5 / -6; auditor re-derived `rsh40(...,13)` on frozen SGD. |
| ID one-hot as transfer / LM06 language | **Not claimed.** |
| RESULTS vs raw log mismatch | **No.** Frames, inner w0, `a09_w0`, tbl, sim time, marker MATCH opened `xsim.log`. |
| MMCM stub silently used | **No.** `MMCM_MODE=UNISIM_MMCME2_BASE`; xelab `-L unisims_ver`; no `mmcm_stub.sdb`. Stub hashed STUB_ON_DISK only. |

Remaining **narrowness** (not cheats): sim `force`/`release` of inner SGD ports (not synthesizable; not A09-R2 public ISO); bag-local wrap (not `arty_a7_astra_rtp_soc_top` / not a frozen production top); unisim MMCM (not silicon); XSim UART (not COM12); A09-R2 query path idle.

---

## Logic bugs

None that break this bag’s declared unknown.

Notes (not P1):

1. `force`/`release` in `always @(*)` is **XSim-only glue**. It cannot ride this wrap to a bitstream or `PRODUCTION_TOP`. Honest for the work-order unknown; forbidden as a silent production-path close.
2. `C_GO` re-asserts `pulse_go` while `inner_rdy` remains 1, producing two adjacent `INNER_GO` prints. Frozen SGD consumes one update (`ready_o` drops after IDLE). P3 w0=+5 not +10. Cosmetic FSM; not a second ISO step.
3. `iso_rew <= rx_data[3:0]` truncates the UART reward byte to the frozen 4-bit SGD port. Correct for `+3`/`-3`. A later host sending a wide reward would silently wrap. Out of this ISO pair.
4. `x0_lat <= rx_data` treats the UART byte as signed Q8. `50` and `64` are in range. Not a bug here.
5. xelab WARNING `CLKFBOUTB` unconnected on `MMCME2_BASE` — same class as T1700/T0005Z UART wraps. Not a functional ISO fail.
6. A09-R2 public query/learn is idle. Instantiation + inner w0 **is** the ISO datapath. Do not read this as “UART tokens walked the A09-R2 query FSM and then learned +5.”

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R5-UART-ISO-INNER-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw XSim: UART 8N1 command bytes into `uart_rx` (not TB poke of `go_upd`/`x_i`) delivered isolated frozen-SGD updates **into A09-R2 inner `u_sgd`** (no wrap sibling `u_iso`), visible on the serialized `uart_rxd_out` byte stream and hierarchical `u_a09r2.u_sgd.w_o[0]`:

- ISO_P3: `x0=50` `rew=+3` → **inner w0=+5** `v=0` `w1=0` `tbl=0` `a09_w0=+5` frame `a2 40 05 00 00 00 32 03 … 0a`
- ISO_M3: `x0=64` `rew=-3` → **inner w0=-6** `v=0` `w1=0` `tbl=0` `a09_w0=-6` frame `a2 40 fa ff 00 00 40 fd … 0a`

`load_from_tb=0`. One SGD instance = inner `u_sgd`. Frozen A09-R2 + frozen SGD hashes unchanged. Leftover A09 not compiled. ASTRA-09-R4 **not** overwritten. UNISIM MMCM (not stub, not silicon). PROGRAM=NO. `PRODUCTION_TOP=UNKNOWN`. No BOARD_PASS.

Not PASS (Master ASTRA-09 production path / fixture-free public-port ISO / SoC UART / silicon UART / BOARD).  
Not FAIL (raw log matches PREREG tests; UART path is real; inner w0 is the pass number; SGD law re-derives +5/−6; hashes PRE/POST aligned; prior bags intact; no sibling SGD).  
Not OVERCLAIM (ACK/RESULTS keep Master 09/13/BOARD/`PRODUCTION_TOP`/silicon UART/R4-sibling open; marker is bag-local `ASTRA_09_R5_UART_ISO_INNER_PASS`; `force` is disclosed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared UART-facing INNER ISO XSim unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this XSim to BOARD_PASS, ASTRA-13, silicon UART, silicon MMCM, wrap-route bit, or `PRODUCTION_TOP=a7ng_astra_09_r5_uart_iso_inner_wrap` / `a7ng_astra_09_r2_cand_ovf`. `force`/`release` is not a silicon net.
2. Do **not** claim ASTRA-09-R4 sibling-ISO or ASTRA-09-R3 MAGIC A2 query OVF/SMOKE/UNREL as closed by this bag. Different wrap, different unknown. R4 `xsim.log` must stay 00:12:53 PID 47704. R3 must stay 21:45:37 PID 19596.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), or frozen SGD (`b66ef328…`).
5. Inner-instance ISO is proven; **public-path** ISO is not. Master ASTRA-09 “one integrated production path; remove fixture shortcuts” still needs a named path where UART tokens/reward hit inner `u_sgd` **through A09-R2’s exported ports / query-learn FSM** — or an explicit recorded decision that sim-forced inner ISO is the production law check. Not a silent close from this glue.
6. Host parsers must not mix this wrap’s 16-byte ISO pack (`A2`, flags `{tbl,iso,6'd0}`, inner w0 LE, v LE, x0, rew8, w1 LE, EOL) with A09-R3 query frames, R4 sibling-ISO layout, or RTP SoC wrap layout.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated UART-facing INNER ISO XSim around instantiated frozen `a7ng_astra_09_r2_cand_ovf`: ISO commands are **UART-real 8N1 into `uart_rx`**, result MAGIC A2 is **real `uart_tx` serialize**, ISO_P3 **inner w0=+5** and ISO_M3 **inner w0=-6** on the **byte stream** and hier `u_a09r2.u_sgd.w_o[0]`, `a09_w0` matches inner (not 0), `load_from_tb=0`, **no sibling `u_iso`**, leftover A09 not compiled, ASTRA-09-R4 not overwritten, UNISIM MMCM not stub, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`.

`REJECT_PROMOTION` — Master **ASTRA-09** (production UART path / fixture-free plant / public-port ISO / SoC top), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Inner-SGD XSim **≠** silicon UART. Sim `force` of inner ports **≠** removed fixture shortcut.

Master ASTRA-09 UART / BOARD: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-09-R4-UART-ISO-01: **untouched, sibling-ISO still PASS_NARROW, not this result**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, different unknown**.  
ASTRA-12-R3 9-row table: **untouched; PRODUCTION_TOP still UNKNOWN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. Inner-only SGD: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0030Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-R5-UART-ISO-INNER-01; inner-only SGD YES; UART-driven (8N1 into uart_rx / wrap FSM force inner go_upd) vs poke=NO; ISO_P3 inner w0=+5 ISO_M3 inner w0=-6 load_from_tb=0; Master ASTRA-09 UART/BOARD OPEN; PROGRAM=NO; BOARD still blocked YES.
