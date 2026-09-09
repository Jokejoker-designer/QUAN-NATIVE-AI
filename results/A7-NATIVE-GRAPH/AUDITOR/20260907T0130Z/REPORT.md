# ASTRA auditor REPORT — 20260907T0130Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R7_UART_QUERY_REW_INDEPENDENT_AUDIT; astra09_r7=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR; astra09_r6=AUDITOR_PASS_NARROW_ISO_PUB_DUT; astra09_r5=AUDITOR_PASS_NARROW_INNER_FORCE; astra09_r4=AUDITOR_PASS_NARROW_SIBLING_ISO; astra09_r3=AUDITOR_PASS_NARROW_UART_QUERY_REW0; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + MASTER ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-09-R7-UART-QUERY-REW-01 + prior auditor 20260907T0100Z (R6 UART ISO-PUBLIC PASS_NARROW ACCEPT_PARTIAL; residual 5: UART query tokens / reward must hit inner u_sgd through A09-R2 exported tok_*/rew_v_i/fire/retire — not CMD_ISO on a separate iso_pub; BOARD blocked YES) + auditor 20260907T0030Z (R5 UART ISO-INNER PASS_NARROW force of inner ports) + auditor 20260906T1700Z (A09-R3 UART XSim PASS_NARROW; rew_v_i tied 0)
EVIDENCE   = raw xsim.log / xsim_fail_r0.log / xsim_fail.log / xvlog.log / xelab.log / Compile_Options.txt / xsim.dir/work sdb names / wrap+TB+plant+SVH + frozen A09-R2 SV+SVH / frozen SGD / uart_rx.sv / uart_tx.sv / MMCM_MODE.txt / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / PREREG.md / ACK.json / run_xsim.ps1 / metrics.json / CLOSEOUT.md (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_xsim.ps1` (would overwrite `xsim.log` / wipe `xsim_work` / risk `xsim_fail_r0.log` policy). Did not xvlog/xsim.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping SGD/A09/A09-R2/uart/R3-wrap/R6-wrap hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`, `ASTRA-09-R3-UART-XSIM-01/SHA256.txt`, `ASTRA-09-R6-UART-ISO-PUBLIC-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `7cdffce10f07ff20cf2e1866f6275f6c5f4738f01aee0741bf4895d989b256d5` is **content-verified** against the opened log, not independently re-digested.

Evidence labels: XSim quotes below are **EVIDENCE**. SGD integer re-derive is **EVIDENCE** from frozen RTL. “UART-real timing matches 8N1” is **ENGINEERING_INFERENCE** from `%t` deltas vs CPB. Silicon / BOARD / bitstream claims are **absent** (correct). Absence of `force`/`release`/`deposit` on pass sources is **EVIDENCE** (grep of wrap/TB/plant/SVH/frozen A09-R2). Instantiation of frozen A09-R2 as `u_a09r2` with UART-mapped `tok_*` / `fire_i` / `retire_i` / `rew_*` is **EVIDENCE** and is the **declared unknown** of this bag vs T0100Z residual 5. AXI plant as labeled fixture (not token bypass) is **EVIDENCE** (ports + TB drive). Bag-local wrap ≠ Master ASTRA-09 production path is **NARROW**, not a silent cheat.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R7-UART-QUERY-REW-01/`

New named wrap `a7ng_astra_09_r7_uart_query_rew_wrap` (bag-local) instantiates frozen `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` (`15a919f1…`) as **`u_a09r2`**. Inner SGD is frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`b66ef328…`) **inside A09-R2 only** (`u_a09r2.u_sgd`). Pin clock `CLK100MHZ` 10 ns → `MMCME2_BASE` 100→50 + `BUFG`. UART `uart_rx` / `uart_tx` `CLK_HZ=50_000_000` `BAUD=115200` 8N1. Bag-local labeled AXI plant `a7ng_astra_09_r7_axi_plant`. TB `tb_astra_09_r7_uart_query_rew`. Frozen leftover `a7ng_astra_09_integ_path.sv` (`9fdbe0d6…`) is **not** instantiated and **not** compiled. ASTRA-09-R6 `iso_pub` DUT is **not** this compile. ASTRA-09-R5/R4/R3 wraps **not** this DUT and **not** overwritten.

Gate under review is **work-order ASTRA-09-R7-UART-QUERY-REW-01 only** — one unknown (handoff):

> Can UART 8N1 drive A09-R2 **query** (tokens+fire) then **pending reward** (`rew_v_i`/`rew_i`/`txn`/`gen` as exported) so a two-proof smoke ANSWER is followed by inner w0 matching the frozen symmetric-law oracle — with no force, `load_from_tb=0`?

Parent after auditor **20260907T0100Z residual 5**: R6 public ISO was real and force-free, but on a **new ISO-opcode DUT** (`iso_pub`). Need UART **query tokens / reward** through **frozen A09-R2 exported** `tok_*` / `rew_v_i` / fire/retire into **that** inner `u_sgd`. Do **not** patch frozen A09-R2. New named wrap. Board plugged. **PROGRAM=NO.** Not a bit. Not a freeze. ISO opcode on a second DUT is **out of scope**.

**Not** Master ASTRA-09 production path. **Not** ASTRA-09-R6 ISO-opcode close. **Not** ASTRA-09-R5 sim-override inner-port ISO. **Not** ASTRA-09-R4 sibling-ISO. **Not** ASTRA-09-R3 `rew_v_i=0` query-only wrap as this result (R3 is provenance: tokens+fire already UART; R7 adds exported reward). **Not** wrap-route bit. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** `PRODUCTION_TOP` freeze. **Not** silicon UART / silicon MMCM.

Hunt (parent / work order / this dispatch):

1. Frozen A09-R2 instantiated? UART → `tok`/`fire`/`rew`/`retire` ports? Grep `force`/`release`/`deposit` none?
2. Raw log smoke `ans=4 p0=17` then rew `-3` inner `w0=-5`? OVF INCOMP? UNREL? `tbl=0`?
3. `axi_plant` labeled fixture not token bypass?
4. Fail r0 preserved; frozen hashes unchanged?
5. Overclaim BOARD_PASS / `PRODUCTION_TOP` / R6 ISO closed by this bag?
6. Hash `.svh` before xvlog? PROGRAM=NO?

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R7-UART-QUERY-REW-01.md` + PREREG: instantiate frozen A09-R2 only (hash `15a919f1…`); wrap maps UART bytes onto `tok_*`, `fire_i`, `retire_i`, `rew_*`; no `force`/`release`/`deposit`; smoke two-proof `ans=4 p0=17`; matching-txn reward `-3` → inner `w0=-5` (oracle phi0=50); overflow INCOMP `ans=0`; UNREL no stale; `load_from_tb=0`; AXI plant allowed if labeled fixture (as R3); `PRODUCTION_TOP=UNKNOWN`; PROGRAM=NO; SHA including `.svh` before xvlog; one corrective if FAIL; do not edit R6 / R5 / R4 / frozen A09-R2 / SGD.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *one integrated production path; remove fixture shortcuts; all functional regressions.* Master §4 production path is `Raw bytes/tokens → query transaction → role-aware parser → valid typed route keys → sparse index/postings → bounded descriptors → PHYS4 scoring + shared learned ranker → retained Top-K/frontier → bounded relation expansion → proof validity/uncertainty → materialized evidence → LM06 generation → UART tokens/proof/status.`
3. **Master ASTRA-13**: silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260907T0100Z`: R6 PASS_NARROW UART-driven **public ISO of new `iso_pub` DUT**; residual 5 = A09-R2 query-learn public path still open.
5. Auditor `20260906T1700Z`: A09-R3 UART XSim PASS_NARROW query SMOKE/OVF/UNREL; wrap ties **`rew_v_i=1'b0`**.
6. Auditor `20260906T1600Z`: A09-R2 bag DUT-level ISO on sibling SGD (not this UART path).

Out of this bag’s close: Master ASTRA-09 production UART (SoC top + on-chip plant + wrap-route bit + LM06), ASTRA-13 BOARD_PASS, silicon UART, `PRODUCTION_TOP` identity, ASTRA-09-R6 ISO-opcode promotion.

Prior bags `ASTRA-09-R6-UART-ISO-PUBLIC-01`, `ASTRA-09-R5-UART-ISO-INNER-01`, `ASTRA-09-R4-UART-ISO-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-09-R2-CAND-OVF-01` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`55487d5f…e72b25`). `write_scope` = new bag + distinctly named UART wrap/TB/plant/svh that instantiate frozen `a7ng_astra_09_r2_cand_ovf` as `u_a09r2`. Wrap UART FSM maps bytes onto exported `tok_valid_i`/`tok_i`/`fire_i`/`retire_i`/`rew_v_i`/`rew_i`/`rew_txn_i`/`rew_gen_i`/`rew_epoch_i`. Wrap/TB/plant/svh contain no `force`/`release`/`deposit`. No second `iso_pub` DUT. No parallel `u_iso`. ASTRA-09-R6 wrap/TB/DUT not edited. Frozen A09-R2 **not patched** (`INSTANTIATED_NOT_PATCHED`). Frozen leftover A09 not compiled as DUT. Frozen SGD not patched. AXI plant is a labeled bag-local fixture. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-09-R3-UART-XSIM-01, ASTRA-09-R4-UART-ISO-01, ASTRA-09-R5-UART-ISO-INNER-01, **ASTRA-09-R6-UART-ISO-PUBLIC-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, production_top_identity, write_bitstream, wrap_route_bit, silicon_UART, **iso_opcode_second_dut**.

`run_xsim.ps1` is xvlog/xelab/xsim only. **No** `write_bitstream` / `xsdb` / `COM12` / `hw_server` / `program_device` strings (grep). Script **throws** if live leftover A09 hash ≠ `9fdbe0d6…` or live R2 hash ≠ `15a919f1…` or live SGD hash ≠ `b66ef328…` **before** xvlog. Script **throws** `A09R7_SIM_OVERRIDE_IN_{WRAP,TB,PLANT,SVH}` on `(?i)\bforce\b|\brelease\b|\bdeposit\b|\$force|\$deposit`. Script **throws** `A09R7_ISO_PUB_DUT_IN_WRAP` / `_IN_TB` if wrap/TB match `a7ng_astra_09_r6_iso_pub`. Script **throws** `A09R7_SIBLING_SGD_IN_{WRAP,TB,PLANT}` if those files instantiate SGD at wrap/TB/plant scope. Script **throws** `FORBIDDEN_DUT_IN_COMPILE_LIST` if compile list matches leftover A09 / SoC top / R3–R6 UART / `iso_pub`. Requires A09-R2 **in** the compile list. Prints `FORCE_PRESENT=NO` before xvlog.

Bag listing: **no** `.bit`, no `timing*.rpt`, no `vivado.log`. **`xsim_fail_r0.log` present** (first-sim fail preserved). Also `xsim_fail.log` and `xsim_45728.backup.log` (same PID **45728** as fail-r0). Wrap/TB/plant live **only** in this bag — grep `a7ng_astra_09_r7` under `rtl/` = **no matches**. `MMCM_MODE.txt`:

```text
MMCM_MODE=UNISIM_MMCME2_BASE
NOT_SILICON_MMCM=1
PROGRAM=NO
PRODUCTION_TOP=UNKNOWN
FORCE_PRESENT=NO
FROZEN_A09R2=INSTANTIATED
```

Prior bags **not rewritten** (headers / markers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| `ASTRA-09-R6-UART-ISO-PUBLIC-01/xsim.log` | session **Mon Sep 7 00:55:33 2026** PID **13656** snapshot `a09r6iso`; still prints `ASTRA_09_R6_UART_ISO_PUBLIC_PASS` |
| `ASTRA-09-R6` wrap SHA | KEEP in this bag `2fcb59c7…20202044` **MATCH** R6 `SHA256.txt` compiled wrap |
| `ASTRA-09-R6` DUT SHA | KEEP `3c0b3fa8…a19590c3` **MATCH** R6 compiled DUT |
| `ASTRA-09-R5-UART-ISO-INNER-01/xsim.log` | session **Mon Sep 7 00:34:46 2026** PID **11336** snapshot `a09r5iso`; still prints `ASTRA_09_R5_UART_ISO_INNER_PASS` |
| `ASTRA-09-R5` wrap SHA | KEEP `ee02935e…2f95999e` |
| `ASTRA-09-R4-UART-ISO-01/xsim.log` | session **Mon Sep 7 00:12:53 2026** PID **47704**; still prints `ASTRA_09_R4_UART_ISO_PASS` |
| `ASTRA-09-R4` wrap SHA | KEEP `cc8ffdaa…836703ab` |
| `ASTRA-09-R3-UART-XSIM-01/xsim.log` | session **Sun Sep 6 21:45:37 2026** PID **19596**; still prints `ASTRA_09_R3_UART_XSIM_PASS` |
| `ASTRA-09-R3` wrap SHA | KEEP `20cdeb8e…a3e88b41` **MATCH** R3 `SHA256.txt` compiled wrap |

R3 wrap still ties `.rew_v_i(1'b0)` (opened). That file was **not** this compile and **not** overwritten. This bag is the exported-reward wrap of the same frozen A09-R2.

### Hash freeze (compiled + .svh) — MATCH (manifest, not re-hashed)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-07T01:24:40.2260107+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (bag `a7ng_astra_09_r7_uart_query_rew.svh` + frozen A09/R2 `.svh` + lexicons + `a7ng_gate14_crc.svh`) + CONFIG + stub-on-disk + KEEP_NOT_COMPILED (leftover A09 + SoC top + R3/R4/R5/R6 UART wraps + R6 `iso_pub`) + PROVENANCE **then** calls xvlog.  
Raw `xsim.log` session **Mon Sep 7 01:24:47–01:26:05 2026**, PID **46472**, snapshot `a09r7qr`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-07T01:26:05.2586765+07:00` (matches log exit `Exiting xsim at Mon Sep  7 01:26:05 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + `.svh` vs POST: **19/19 MATCH** (opened manifests). Frozen leftover A09 `.sv` is KEEP_NOT_COMPILED / POST provenance, **not** in COMPILED list. Frozen A09-R2 `.sv` **is compiled** this bag (required).

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf98852…ee57a6` |
| query/route/sparse/axi-sparse (5 files) | MATCH R2/R3 manifests |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…c67aac` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…8b70ee23` **compiled** |
| `rtl/board/uart_rx.sv` | `8e802d0b…cd5369a` |
| `rtl/board/uart_tx.sv` | `b4b7d097…b36367b` |
| bag `a7ng_astra_09_r7_axi_plant.sv` | `5d16a2b2…d7f5ed82` |
| bag `a7ng_astra_09_r7_uart_query_rew_wrap.sv` | `aeb7e194…fc2c608c` |
| bag `tb_astra_09_r7_uart_query_rew.sv` | `fae5c4f9…022d1c76` |
| bag `a7ng_astra_09_r7_uart_query_rew.svh` | `adca3ef9…5cbe1ea1` |
| frozen A09-R2 `.svh` | `feaed571…71afd329` |
| leftover A09 `.svh` | `ad2d66d4…b4e94302` |
| KEEP leftover A09 `.sv` (not compiled) | `9fdbe0d6…bb5c776c` |
| KEEP R6 UART wrap / `iso_pub` | `2fcb59c7…` / `3c0b3fa8…` |
| KEEP R3 UART wrap | `20cdeb8e…a3e88b41` |

Overlapping SGD / leftover A09 / A09-R2 / A09-R2 `.svh` hashes **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` **and** R3 **and** R6 KEEP. `uart_rx` / `uart_tx` prefixes **MATCH** R3/R6. Handoff required R2 `15a919f1…` instantiated-unchanged, leftover A09 `9fdbe0d6…` unused, SGD `b66ef328…`: **all three present; R2+SGD compiled; leftover A09 not compiled**. Frozen hashes **unchanged**.

`.svh` hashed **before** xvlog: **YES** (bag SVH + frozen A09/R2 SVH in TRANSITIVE_INCLUDES). PROGRAM=NO: **YES**. ASTRA-09-R6 not overwritten: **YES**.

### Compiled identity (raw xvlog / xelab / work sdb) — frozen A09-R2 + one inner SGD; no iso_pub

`xvlog.log` (bag copy after first xvlog) analyzes, in order: pkg, struct extract, role extract, route gate, sparse dir, query-axi-sparse, **SGD**, **`a7ng_astra_09_r2_cand_ovf`**, `uart_rx`, `uart_tx`, bag plant, bag wrap, bag TB. **No** `a7ng_astra_09_integ_path.sv`, **no** `a7ng_astra_09_r6_iso_pub.sv`, **no** R3/R4/R5 wraps, **no** `mmcm_stub`. No ERROR lines in that log.

(`xsim_work/xvlog.log` is **glbl-only**: script’s second xvlog of `glbl.v` overwrites the work copy. Bag `xvlog.log` is the SV analyze list. Not a missing compile.)

Pass `xelab.log` command:

```text
xelab.exe tb_astra_09_r7_uart_query_rew glbl -s a09r7qr -timescale 1ns/1ps -L unisims_ver --debug typical
```

Compiled modules (raw pass xelab): `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, query/sparse chain, **`a7ng_shared_rank_sgd_q8_sym_f2r2`** (once), **`a7ng_astra_09_r2_cand_ovf_default`**, `a7ng_astra_09_r7_axi_plant`, `a7ng_astra_09_r7_uart_query_rew_wrap`, `tb_astra_09_r7_uart_query_rew`, `glbl`. One unconnected-port WARNING on `CLKFBOUTB` (wrap line 27) — not a FAIL. **Built simulation snapshot `a09r7qr`.** No `mmcm_stub` in xelab.log.

`Compile_Options.txt`: `"tb_astra_09_r7_uart_query_rew" "glbl" -s "a09r7qr" -timescale "1ns/1ps" -L "unisims_ver" --debug "typical"`.

`xsim.dir/work` sdb names (bag listing): `a7ng_astra_09_r2_cand_ovf.sdb`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sdb` (**one**), `a7ng_astra_09_r7_uart_query_rew_wrap.sdb`, `a7ng_astra_09_r7_axi_plant.sdb`, query/sparse sdb set, `uart_rx.sdb`, `uart_tx.sdb`, `tb_astra_09_r7_uart_query_rew.sdb`, `glbl.sdb`. **No** `a7ng_astra_09_integ_path.sdb`, **no** `a7ng_astra_09_r6_iso_pub.sdb`, **no** R3/R4/R5 wrap sdb, **no** `mmcm_stub.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`.

SGD is compiled because frozen A09-R2 instantiates it as inner `u_sgd`. That is **one instance**, not a wrap sibling.

### Fail-r0 preserved (one wrap corrective; frozen DUT not patched)

`xsim_fail_r0.log` is present and is a real first-sim fail (session **Mon Sep 7 01:20:35–01:23:50 2026**, PID **45728**, snapshot `a09r7qr`):

```text
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
...
PASS REW_M3_HIER_SGD_W0
RET_CMD_SENT t=5386395000
HIER result_v ans=4 p0=17 p1=34 st=0 tbl=0 ... w0=-5 ... t=5555785000
RETIRE t=5555785000
UART_RX n=33 byte=a2 t=5638285000
...
FRAME (16-byte re-TX of SMOKE A2 10 04 … 0a)
FAIL IDLE_TIMEOUT busy=0 tx=0 cst=2 rv=0 t=25560005000
QUERY_OVF_SENT t=25560325000
FRAME OVF_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
FAIL OVF_UART_ST
FAIL OVF_UART_ANS
...
ASTRA_09_R7_UART_QUERY_REW_FAIL n=7 first=IDLE_TIMEOUT
$finish called at time : 30588595 ns
Exiting xsim at Mon Sep  7 01:23:50 2026...
```

Root cause (wrap, not DUT): after `CMD_RET`, wrap returned to `C_QRUN` with `sent` cleared while `result_v` was still 1 (DUT still `S_HOLD` for that cycle). Wrap **re-TX** the SMOKE frame, landed in `C_HOLD` (`cst=2`), `wait_idle` timed out, OVF query bytes were ignored (push only in `C_QRUN`), and TB decoded the leftover SMOKE frame as OVF. Smoke+reward already matched PREREG on this fail run. **One wrap corrective** (pass source): `C_QRUN` clears `sent` only when `!result_v`, so retire cannot re-arm TX while `result_v` still 1. Frozen A09-R2 / SGD **not** patched (hashes unchanged vs R2/R3/R6). TB golden **not** edited (same `ans=4` / `w0=-5` / INCOMP / UNKNOWN).

Pass `run_xsim.ps1` copies fail xsim to `xsim_fail_r0.log` only if absent; that file survived the pass rerun. Pass `xsim.log` is PID **46472**, not a wipe of fail-r0.

---

### Hunt 1 — frozen A09-R2 instantiated; UART → tok/fire/rew/retire; `force`/`release`/`deposit` on pass sources — YES / YES / NONE

Grep of bag `*.sv` / `*.svh` for `force|release|deposit|$force|$deposit`: **no matches**. Grep of frozen `a7ng_astra_09_r2_cand_ovf.sv` for the same: **no matches**. Hits on `force` in the bag are **docs / ACK / PREREG / RESULTS / metrics `force_present: false` / `run_xsim.ps1` ban-pattern**. Script would throw `A09R7_SIM_OVERRIDE_*` if pass sources contained the tokens.

Wrap instantiates frozen A09-R2 (not a new ISO DUT):

```text
(* keep_hierarchy = "yes" *)
a7ng_astra_09_r2_cand_ovf u_a09r2 (
  ...
  .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok_b),
  .fire_i(fire), .retire_i(retire),
  .rew_v_i(rew_v), .rew_i(rew_i), .rew_txn_i(rew_txn), .rew_gen_i(rew_gen),
  .rew_epoch_i(rew_epoch),
  .load_v_i(1'b0), ...
  .load_from_tb_o(tbl),
  .m_axi_arid(arid), ...
);
```

Contrast R3 wrap (KEEP, not this compile): same `u_a09r2` but `.rew_v_i(1'b0)`. Contrast R6 wrap: instantiates `a7ng_astra_09_r6_iso_pub u_r6` and drives `iso_*` / `CMD_ISO=0xA5`. This wrap/TB/SVH contain **no** `iso_pub`, **no** `CMD_ISO`, **no** `0xA5`.

UART RX (50 MHz pipe, 115200) binds pin `uart_txd_in`. `uart_rx.sv` is a real 8N1 sampler (IDLE→START mid-bit→DATA 8 bits LSB-first→STOP). `uart_tx.sv` is a real start/data/stop serializer. Not a byte-wide backdoor.

Wrap query path (`C_QRUN`): `rx_valid && !is_eol` pushes bytes into a FIFO; `pop` pulses `tok_v`/`tok_b` when `tok_r`; EOL sets `fire_pend`; when FIFO empty and `tok_r` and `!busy`, one-cycle `fire`. Default-clears `tok_v`/`fire`/`retire`/`rew_v` every cycle (one-cycle pulses).

Wrap reward path (`C_HOLD` after result TX): host `CMD_REW=0xA6` then `rew8`, `txn`, `gen`, `epoch` LE, `EOL=0x0A` → `C_R_PULSE` sets `rew_v<=1` and `rew_i<=rx_data[3:0]`. Host `CMD_RET=0xA7 0x0A` pulses `retire`.

TB drives **only** pin `uart_txd_in` (idle 1) plus `sw[1:0]` plant select and `btn[0]` unused (held 0). Bit-bang is 8N1 at pin-clock CPB (100 MHz / 115200 → 868). Hierarchical TB access is **read** of `dut.u_a09r2.u_sgd.w_o[0]` / `sgd_upd` / `phi[0]` — observe-only.

Frozen A09-R2 public ports (opened) **are** `tok_valid_i` / `tok_i` / `fire_i` / `retire_i` / `rew_v_i` / `rew_i` / `rew_txn_i` / `rew_gen_i` / `rew_epoch_i`. Learn is `S_HOLD`: matching txn/gen/epoch and `pend_acc` → `sgd_upd` → `S_UW`. Inner:

```text
a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
  .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
  .go_score_i(sgd_go), .go_upd_i(sgd_upd), .x_i(phi), .reward_i(rew_lat),
  .load_v_i(load_v_i && (st==S_IDLE)), ...
);
assign load_from_tb_o = 1'b0;
```

Wrap ties `load_v_i=0`, so inner `load_v_i` is 0. **Synthesizable port/FSM glue. Not `force`.** Instantiation of frozen A09-R2 is **honest** (compiled, hash unchanged, ports already exported — no DUT patch required, unlike R6 ISO).

`FORCE_PRESENT=NO` on pass sources: **YES.**

---

### Hunt 2 — raw log smoke ans=4 p0=17 then rew -3 inner w0=-5; OVF INCOMP; UNREL; tbl=0 — MATCH

Raw `xsim.log` (authority; session Mon Sep 7 01:24:47 PID 46472; `$finish` **11975335 ns**). Zero `FAIL` lines. Marker `ASTRA_09_R7_UART_QUERY_REW_PASS`. RESULTS `SIM_TIME=11975335 ns` MATCH `$finish`. TB banner `PRODUCTION_TOP=UNKNOWN` `PROGRAM=NO` `CPB_PIN100=868`.

```text
QUERY_SMOKE_SENT t=6285000
FIRE t=1998465000 plant=1
HIER result_v ans=4 p0=17 p1=34 st=0 tbl=0 npath=2 ntrunc=0 rov=0 wov=0 acc=1 phi0=50 w0=0 txn=1 gen=1 ep=7 t=2001445000
...
FRAME SMOKE_UART a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a
DECODE SMOKE_UART magic=a2 tbl=0 st=0 ans=4 p0=17 p1=34 npath=2 ntrunc=0 rov=0 wov=0 acc=1 eol=0a hier_tbl=0 w0=0 phi0=50 txn=1
PASS SMOKE_UART_ANS / _P0 / _P1 / _TBL0 / _PHI0 / _ACC / SMOKE_PRE_W0
REW_CMD_SENT rew8=fd txn=1 gen=1 ep=7 t=3391535000
REW_PULSE rew=-3 txn=1 gen=1 ep=7 acc=1 t=3994925000
INNER_UPD rew=-3 phi0=50 t=3994945000
...
FRAME REW_OBS a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a
DECODE REW_OBS magic=a2 w0=-5 phi0=50 nupd=1 nbad=0 nstale=0 ndup=0 txn=1 gen=1 tag=57 hier_w0=-5 sgd_w0=-5 pub_w0=-5 tbl=0 cmt=1
PASS REW_M3_W0 / _PHI0 / _NUPD / _NBAD0 / _NSTALE0 / _INNER_W0 / _HIER_SGD_W0 / _PUB_W0 / _TBL0
QUERY_OVF_SENT t=5560955000
FIRE t=7553145000 plant=2
HIER result_v ans=0 p0=0 p1=0 st=6 tbl=0 npath=0 ntrunc=4 rov=1 wov=0 acc=0 ... t=7554005000
FRAME OVF_UART a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a
DECODE OVF_UART magic=a2 tbl=0 st=6 ans=0 p0=0 p1=0 npath=0 ntrunc=4 rov=1 wov=0 acc=0 ...
PASS OVF_UART_ST / _ANS / _NTRUNC / _NO_STALE_ANS4 / _HIER_INCOMP
QUERY_UNREL_SENT t=9118655000
FIRE t=10590045000 plant=1
HIER result_v ans=0 p0=0 p1=0 st=1 tbl=0 npath=0 ... t=10590225000
FRAME UNREL_UART a2 01 00 00 00 00 00 00 00 00 00 00 00 00 00 0a
DECODE UNREL_UART magic=a2 tbl=0 st=1 ans=0 p0=0 p1=0 npath=0 ntrunc=0 ...
PASS UNREL_UART_ST / _ANS / _NO_STALE
ASTRA_09_R7_UART_QUERY_REW_PASS
```

Frame decode:

| Case | UART bytes | Meaning |
|------|------------|---------|
| SMOKE | `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a` | MAGIC A2; flags `0x10`={tbl=0,rov=0,wov=0,acc=1,st=0}; ans=4; p0=17; p1=34; npath=2; ntrunc=0; tbl byte 0 |
| REW_OBS | `a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a` | flags `0x60`={tbl=0,cmt=1,acc=1,st=0}; w0 LE `fb ff`=**-5**; phi0=`0x32`=50; nupd=1; nbad=0; nstale=0; txn=1 gen=1 ep=7; tag `0x57` |
| OVF | `a2 46 00 00 00 00 00 00 00 00 00 00 04 00 00 0a` | flags `0x46`={tbl=0,rov=1,wov=0,acc=0,st=6 INCOMP}; ans=0 p0=0; ntrunc=4 |
| UNREL | `a2 01 00 00 … 0a` | flags `0x01`={st=1 UNKNOWN}; ans=0 p0=0 npath=0 tbl=0 |

`pub_w0` / wrap `inner_w0=w[0]` / hier `u_a09r2.u_sgd.w_o[0]` all **-5** after reward. SMOKE pre-reward `w0=0`. `tbl=0` / `hier_tbl=0` on all four frames.

Note (not a fail): TB `$display INNER_DONE` requires `sgd_done && pend_cmt` in the same cycle. Frozen A09-R2 sets `pend_cmt<=1` **on** `sgd_done` (NBA → next cycle). So `INNER_DONE` never prints. Authority for w0 is `INNER_UPD` + UART OBS + hierarchical `w_o[0]` checks after `pend_cmt`. Not a golden cheat.

`load_from_tb=0` on all:

- A09-R2 RTL: `assign load_from_tb_o = 1'b0;`
- Wrap: `.load_v_i(1'b0)`
- Inner SGD: `.load_v_i(load_v_i && (st==S_IDLE))` → 0
- TB: no `load_v` / weight preload; `SMOKE_PRE_W0` requires inner/pub/hier w0=0 before reward
- Raw dumps: `tbl=0` `hier_tbl=0` `PASS *_TBL0`

`freeze_i=1'b0` on inner `u_sgd`. Reward uses A09-R2 `rew_lat` / `phi` (query phi, not ISO x0).

Oracle re-derived from frozen SGD (`SHIFT=6`, `dw40=rsh40(err*x, 7+SHIFT)`, `err=rew*256-v`, `w=0` ⇒ `v=0`) and frozen A09-R2 `qphi0=min(c1,c2)[7:2]`:

- Plant facts 17/34 `conf=200` → `qphi0(200,200)=200>>2=50`. Matches raw `phi0=50`.
- `rew=-3`, `x0=phi0=50`, `v=0` → `err=-768`, `prod=-38400`, `rsh40(-38400,13)=-(38400+4096)>>>13=-5` → **w0=-5**.

Not R6 ISO integers (`x0=50→+5` / `x0=64→-6`). Here x is **query phi0**, so `-5` is the correct law. `rew_i <= rx_data[3:0]`: UART `0xFD` → nibble `0xD` = -3. Honest for this pair. Matching txn/gen/epoch: raw `REW_PULSE txn=1 gen=1 ep=7 acc=1` and `n_stale=0 n_bad=0 n_upd=1`.

UART-real timing (raw log, `%t` = 1 ps; `$finish` reports ns). CPB=868, bit=8680 ns. Query `"pump requires indirect\n"` = 23 bytes × 10 bits × 8680 ns = **1,996,400 ns**.

| Event | t (ps) | ns |
|-------|--------:|---:|
| `QUERY_SMOKE_SENT` | 6_285_000 | 6.285 |
| `FIRE` plant=1 | 1_998_465_000 | 1998.465 |
| `UART_RX n=1 byte=a2` | 2_083_945_000 | 2083.945 |
| `UART_RX n=2 byte=10` | 2_170_785_000 | 2170.785 |
| `REW_CMD_SENT` | 3_391_535_000 | 3391.535 |
| `REW_PULSE` | 3_994_925_000 | 3994.925 |
| `INNER_UPD` | 3_994_945_000 | 3994.945 |
| `QUERY_OVF_SENT` | 5_560_955_000 | 5560.955 |
| `FIRE` plant=2 | 7_553_145_000 | 7553.145 |

SMOKE sent → FIRE Δ = **1,992.180 µs** vs 1,996.400 µs packed (last stop-bit / FIFO drain to `fire`). **MATCH UART-real, not a zero-delay poke.**

TX byte spacing n=1→n=2: 2_170_785_000 − 2_083_945_000 = **86_840_000 ps = 86840 ns**. Ten bits × 8680 ns = 86800 ns. Extra 40 ns = pin-clock alignment. **UART-real TX.** Same 86840 ns on subsequent SMOKE bytes.

REW_CMD_SENT → REW_PULSE Δ = **603.390 µs**. Seven host bytes (`A6 FD txn gen e0 e1 0A`) × 10 × 8680 ns = 607.600 µs. **UART-real.** INNER_UPD is **20 ns** after REW_PULSE = one 50 MHz pipe cycle (wrap `rew_v` registered, DUT `S_HOLD` sees it next cycle and pulses `sgd_upd`). Honest FSM cost, not ISO opcode.

OVF FIRE plant=**2**; UNREL FIRE plant=**1**. Not a leftover SMOKE decode (fail-r0 was). OVF ntrunc=4 with plant N=20 and `CAND_CAP=16` is **20−16**. UNREL `"payroll tax form\n"` → `st=1 ans=0 p0=0 npath=0`, not stale `ans=4`. Leftover `w0=-5` after reward on OVF/UNREL hier dumps is **expected** (no wrap reset of SGD weights; PREREG does not require w0=0 on those frames).

---

### Hunt 3 — `axi_plant` labeled fixture, not token bypass — YES

Plant header (opened): *Bag-local labeled AXI plant fixture (as R3). Not silicon BRAM. Not an edit of `a7ng_axi_bram128` or ASTRA-09-R3 plant source.*

Module `a7ng_astra_09_r7_axi_plant` is an AXI **slave** (`s_axi_ar*` / `s_axi_r*`) returning combinational `mem_rd(addr)` facts. `plant_sel=sw[1:0]`: SMOKE (`2'd1`) dir count=4 facts 17/34/18/35 conf 200/200/8/8; OVF (`2'd2`) dir count=**20** plus facts 100–115. **No** `tok_*` / `fire` / `rew` ports. **No** UART. **No** SGD.

Tokens reach A09-R2 only from wrap FIFO ← `uart_rx`. Fire is wrap EOL. Reward is wrap `CMD_REW`. Plant is the fact memory the frozen query walk already speaks AXI to — same class as R3, allowed by work order *“AXI plant for facts is allowed if labeled fixture (as R3).”*

Not a token bypass: if it were, SMOKE/OVF/UNREL could not differ by UART string + `sw` plant while sharing the same wrap FSM. Raw FIRE tags follow the UART strings and `plant=` matches `sw`.

---

### Hunt 4 — fail r0 preserved; frozen hashes unchanged — MET

See fail-r0 and hash sections. Frozen R2 `15a919f1…` / SGD `b66ef328…` / leftover A09 `9fdbe0d6…` MATCH R2 bag, MATCH R3 bag, MATCH R6 KEEP, MATCH this PRE/POST. R2 **compiled** this bag (instantiated). Leftover A09 **not compiled**. R6 `xsim.log` still 00:55:33 PID 13656 with `ASTRA_09_R6_UART_ISO_PUBLIC_PASS`. R6 wrap KEEP hash `2fcb59c7…` MATCH R6 compiled wrap. R5 log still 00:34:46 PID 11336. R4 still 00:12:53 PID 47704. R3 still 21:45:37 PID 19596. R7 wrap is a **new** file `aeb7e194…`, not an edit of R3 wrap `20cdeb8e…` or R6 wrap.

---

### Hunt 5 — Overclaim BOARD_PASS / PRODUCTION_TOP / R6 ISO closed by this bag — NO BOARD / NO TOP / R6 NOT CLAIMED

ACK / PREREG / RESULTS / CLOSEOUT / metrics / MMCM_MODE / TB banner all keep:

- `PRODUCTION_TOP=UNKNOWN`
- `PROGRAM=false` / `PROGRAM=NO`
- `BIT=NOT_BUILT`
- `BOARD_PASS` in `not_claimed` / OPEN
- `ASTRA-13` OPEN / BLOCKED
- silicon UART / silicon MMCM **not** claimed (`UNISIM_MMCME2_BASE`, `NOT_SILICON_MMCM=1`)
- **ASTRA-09-R6 ISO-opcode DUT** in `does_not_close` / `not_claimed`
- ASTRA-09-R5 force-inner / R4 sibling-ISO / R3 query-only **not** claimed as this bag
- wrap **not** named as production top
- AXI plant **labeled fixture**

Marker is bag-local `ASTRA_09_R7_UART_QUERY_REW_PASS`, not `BOARD_PASS`, not `ASTRA_09_R6_UART_ISO_PUBLIC_PASS`. CLOSEOUT `PASS_THIS_GATE_ONLY`. RESULTS proposed `PASS_NARROW (this bag only: UART 8N1 query tokens+fire then matching-txn rew=-3 through frozen A09-R2 exported ports; …)`.

No `.bit` / `.bin` / `.mcs` in the bag. `run_xsim.ps1` cannot program.

T0100Z residual 5 therefore **closes narrowly**:

| Residual-5 fragment | This bag |
|---------------------|----------|
| UART query tokens + fire through **A09-R2 exported** `tok_*` / `fire_i` | **CLOSED_NARROW** |
| Matching-txn pending reward through exported `rew_v_i` / `rew_i` / txn/gen/epoch into **that** inner `u_sgd` | **CLOSED_NARROW** |
| No sim `force`/`release`/`deposit` | **CLOSED_NARROW** |
| Smoke `ans=4 p0=17` then inner w0=-5, `tbl=0` | **CLOSED_NARROW** |
| OVF INCOMP / UNREL no stale | **CLOSED_NARROW** |
| Master ASTRA-09 one production path / SoC UART / silicon / BOARD | **OPEN** |
| ASTRA-09-R6 ISO-opcode DUT as this result | **not claimed** (R6 bag intact) |

Do **not** read this as “R6 ISO closed” or “PRODUCTION_TOP frozen.”

---

### Hunt 6 — Hash `.svh` before xvlog; PROGRAM=NO — MET

See hash section. Bag `.svh` in `TRANSITIVE_INCLUDES` of `SHA256.txt` **before** xvlog. Frozen A09/R2 `.svh` hashed in the same PRE list. POST 19/19 compiled+svh MATCH. PROGRAM=NO throughout. Script SHA freeze line is printed before xvlog.

---

### This bag vs Master ASTRA-09 query-learn UART

| Claim | This bag | Master ASTRA-09 |
|-------|----------|-----------------|
| UART 8N1 query tokens + fire into **frozen A09-R2** exported `tok_*` / `fire_i`; smoke two-proof `ans=4 p0=17 p1=34` on **byte stream** | **YES** (XSim; also R3) | Required as **one** functional regression, not the whole gate |
| UART matching-txn pending reward `rew_v_i` / `rew_i` into A09-R2 `S_HOLD`/`S_UW` → inner `u_a09r2.u_sgd` w0=-5 (phi0=50, rew=-3) | **YES** (this bag; R3 had `rew_v_i=0`) | Required query-learn handshake |
| OVF `CAND_CAP` INCOMP `ans=0` ntrunc visible; UNREL UNKNOWN no stale `ans=4` | **YES** | Required regressions |
| `load_from_tb=0`; no `force`; one inner SGD | **YES** | Required to remove sim-override shortcuts |
| Same learner the A09-R2 query path uses (not a second ISO DUT) | **YES** — A09-R2 instantiated | T0100Z residual 5 identity |
| Fixture-free on-chip plant / SoC UART identity / wrap-route bit | **NO** — bag-local AXI plant + bag-local wrap | **OPEN** |
| One integrated production path; LM06 generation | **NO** | **OPEN** |
| Silicon UART on COM12 | **NO** | ASTRA-13 / BOARD — **BLOCKED** |

T0100Z residual 5 (*UART query tokens / reward through A09-R2 exported ports*) is **answered narrowly**. It is **not** answered as Master ASTRA-09 production UART. Do **not** promote Master ASTRA-09. Do **not** promote R6 ISO as closed by this bag.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| Wrap/TB/plant/SVH `force`/`release`/`deposit` on pass sources | **No.** Grep `*.sv`/`*.svh` empty. Script would throw. Hierarchical TB access is **read** of `w_o[0]`. |
| Wrap/TB instantiate sibling `u_iso` / second SGD / `iso_pub` | **No.** One `u_a09r2`; inner `u_sgd` only. One SGD sdb. No `iso_pub` sdb. |
| TB poke `tok_*` / `fire` / `rew_v` / `go_upd` as authority | **No.** TB bit-bangs `uart_txd_in` only (plus `sw` plant select). Wrap FSM pulses exported ports after UART. |
| AXI plant is a token bypass | **No.** AXI slave facts only; labeled fixture. Tokens from UART FIFO. SMOKE/OVF/UNREL differ by UART string + plant_sel. |
| UART TX is a constant template (tautology) | **No.** Four frames differ (SMOKE `a2 10 04…11…22`, OBS `fb ff` w0=-5, OVF `a2 46` st=6 ntrunc=4, UNREL `a2 01`). TX spacing 86840 ns/byte. |
| Force / hierarchical assign `w_o` to the golden | **No.** No force. `inner_w0=w[0]` is DUT output. w0 re-derives from frozen SGD law on query phi0. |
| `load_from_tb` as query/learn authority | **No.** A09-R2 hard 0; wrap `load_v_i=0`; dumps `tbl=0`. Weights from reset-zero SGD update after UART reward. |
| `freeze_i=1` cheat | **No.** Inner `u_sgd.freeze_i=1'b0`. |
| Claim R6 ISO-opcode / R5 force-inner / R4 sibling as this result | **No.** R6 `xsim.log` still 00:55:33 PID 13656; R5 still 00:34:46 PID 11336; R4 still 00:12:53 PID 47704; this marker is `ASTRA_09_R7_UART_QUERY_REW_PASS`. ACK lists `ASTRA-09-R6-UART-ISO-PUBLIC-01` as not closed. |
| Claim R3 query-only wrap as the reward close | **No.** R3 wrap KEEP still `rew_v_i=1'b0`. This wrap drives `rew_v`. R3 log still 21:45:37 PID 19596. |
| Silent A09-R2 patch labeled instantiated | **No.** Hash `15a919f1…` MATCH R2/R3/R6; compiled; ports already exported. Instantiated is honest. |
| Golden edit / wipe prior xsim.log | **Not found.** `xsim_fail_r0.log` preserved (PID 45728 IDLE_TIMEOUT); prior R2/R3/R4/R5/R6 logs/headers intact. |
| Hash theatre after scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes bag `.svh` + frozen `.svh`. POST 19/19 MATCH. |
| BOARD_PASS / silicon UART / `PRODUCTION_TOP` freeze | **Not claimed.** |
| Floor-shift / R6 ISO +5/−6 labeled as this query-learn w0 | **No.** Raw inner w0=**-5** from phi0=50 × rew=-3; auditor re-derived `rsh40(...,13)` on frozen SGD. |
| ID one-hot as transfer / LM06 language | **Not claimed.** |
| RESULTS vs raw log mismatch | **No** on frames, ans/p0, inner w0, tbl, sim time, marker, FIRE times, fail-r0 story. |
| MMCM stub silently used | **No.** `MMCM_MODE=UNISIM_MMCME2_BASE`; xelab `-L unisims_ver`; no `mmcm_stub.sdb`. Stub hashed STUB_ON_DISK only. |

Remaining **narrowness** (not cheats): bag-local wrap (not `arty_a7_astra_rtp_soc_top` / not a frozen production top); bag-local AXI plant fixture (not silicon BRAM); unisim MMCM (not silicon); XSim UART (not COM12).

---

## Logic bugs

None that break this bag’s declared unknown.

Notes (not P1):

1. AXI plant is a **labeled fixture**. Instantiation + UART tokens walking frozen A09-R2 **is** the query-learn datapath. Do not read this as “on-chip production plant” or “SoC UART identity.”
2. `rew_i <= rx_data[3:0]` truncates the UART reward byte to the frozen 4-bit SGD port. Correct for `-3` (`0xFD` → nibble `0xD`). A later host sending a wide reward would silently wrap. Out of this pair.
3. TB `INNER_DONE` display is dead (NBA `pend_cmt`). Pass numbers still come from UART OBS + hier `u_sgd.w_o[0]`. Cosmetic.
4. After reward, OVF/UNREL hier dumps still show `w0=-5`. PREREG does not require a weight reset. Not stale **answers** (OVF ans=0 / UNREL ans=0).
5. xelab WARNING `CLKFBOUTB` unconnected on `MMCME2_BASE` — same class as T1700/T0005Z/T0030Z/T0100Z UART wraps. Not a functional query-learn fail.
6. Fail-r0 was wrap `sent` vs `result_v` after retire. One wrap corrective. Frozen DUT untouched.
7. `C_R_WAIT` also times out at 1023 cycles and TX OBS anyway. This run hit `pend_cmt` immediately (`INNER_UPD` +20 ns). Timeout path unexercised. Out of this unknown.
8. Wrap `is_eol` treats `0x00` as EOL (same as R3). Fine for the ASCII queries used here.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R7-UART-QUERY-REW-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw XSim: UART 8N1 query bytes into `uart_rx` (not TB poke of `tok_*`/`fire`/`rew_v`, **not** sim `force`) delivered frozen-A09-R2 query then matching-txn pending reward **via exported ports** into inner `u_a09r2.u_sgd`, visible on the serialized `uart_rxd_out` byte stream and hierarchical `u_a09r2.u_sgd.w_o[0]`:

- SMOKE: `"pump requires indirect\n"` → **ans=4 p0=17 p1=34** st=0 npath=2 phi0=50 w0=0 pend_acc=1 `tbl=0` frame `a2 10 04 00 00 11 00 00 22 00 00 02 00 00 00 0a`
- REW_M3: UART `A6 FD 01 01 07 00 0A` matching txn/gen/epoch → **inner w0=-5** phi0=50 nupd=1 nbad=0 nstale=0 `tbl=0` hier `u_sgd.w_o[0]=-5` frame `a2 60 fb ff 32 01 00 00 01 01 07 00 00 00 57 0a`
- OVF: same query on N=20 plant → **st=6 INCOMP ans=0 p0=0 ntrunc=4 rov=1** `tbl=0` frame `a2 46 00 … 04 00 00 0a` (not stale ANSWER 4)
- UNREL: `"payroll tax form\n"` → **st=1 UNKNOWN ans=0 p0=0 npath=0** `tbl=0`

`load_from_tb=0`. One SGD instance = inner `u_a09r2.u_sgd`. Frozen A09-R2 instantiated, hash unchanged. **`FORCE_PRESENT=NO`** on pass wrap/TB/plant/SVH. Frozen SGD hash unchanged. Leftover A09 not compiled. ASTRA-09-R6 **not** overwritten. `xsim_fail_r0.log` preserved (wrap `sent`/retire re-TX; one wrap corrective). UNISIM MMCM (not stub, not silicon). PROGRAM=NO. `PRODUCTION_TOP=UNKNOWN`. No BOARD_PASS. AXI plant labeled fixture, not token bypass.

Not PASS (Master ASTRA-09 production path / SoC UART / silicon UART / BOARD / `PRODUCTION_TOP`).  
Not FAIL (raw log matches PREREG tests; UART path is real; inner w0 is the pass number; no force on pass sources; SGD law re-derives -5 from query phi0; hashes PRE/POST aligned; prior bags intact; A09-R2 instantiated is honest; fail-r0 preserved).  
Not OVERCLAIM (ACK/RESULTS keep Master 09/13/BOARD/`PRODUCTION_TOP`/silicon UART/R6-ISO/R5-force/R4-sibling open; marker is bag-local `ASTRA_09_R7_UART_QUERY_REW_PASS`; plant labeled fixture; R6 ISO not claimed closed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared UART query-learn XSim unknown (frozen A09-R2 instantiated; UART → tok/fire/rew/retire; no force; smoke ans=4 p0=17 then inner w0=-5; OVF INCOMP; UNREL no stale; tbl=0).

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this XSim to BOARD_PASS, ASTRA-13, silicon UART, silicon MMCM, wrap-route bit, or `PRODUCTION_TOP=a7ng_astra_09_r7_uart_query_rew_wrap`. XSim UART ≠ COM12.
2. Do **not** claim ASTRA-09-R6 ISO-opcode public ISO, ASTRA-09-R5 force-inner ISO, ASTRA-09-R4 sibling-ISO, or ASTRA-09-R3 `rew_v_i=0` query-only wrap as closed by this bag. Different wrap, different unknown. R6 `xsim.log` must stay 00:55:33 PID 13656. R5 must stay 00:34:46 PID 11336. R4 must stay 00:12:53 PID 47704. R3 must stay 21:45:37 PID 19596.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), or frozen SGD (`b66ef328…`).
5. UART query-learn through A09-R2 exported ports is proven **on this bag-local wrap + labeled AXI plant**. Master ASTRA-09 “one integrated production path; remove fixture shortcuts” still needs SoC UART identity / on-chip plant / wrap-route bit / LM06 — or an explicit recorded decision that this wrap is the production UART. Not a silent freeze from XSim PASS_NARROW.
6. Host parsers must not mix this wrap’s 16-byte **query** pack (`A2`, flags `{tbl,r_ovf,w_ovf,pend_acc,status}`, ans/p0/p1 LE 20-bit, npath, ntrunc, tbl, EOL) or **OBS** pack (`A2`, flags `{tbl,cmt,acc,0,status}`, w0 LE, phi0, nupd, tag `0x57`) with R6 16-byte ISO pack, R5 inner-force layout, R4 sibling-ISO layout, or RTP SoC wrap layout. `CMD_REW=0xA6` / `CMD_RET=0xA7` ≠ R6 `CMD_ISO=0xA5`.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated UART query-learn XSim around instantiated frozen `a7ng_astra_09_r2_cand_ovf`: query tokens and `CMD_REW`/`CMD_RET` are **UART-real 8N1 into `uart_rx`**, result MAGIC A2 is **real `uart_tx` serialize**, smoke **ans=4 p0=17** then matching-txn rew=-3 **inner w0=-5** on the **byte stream** and hier `u_a09r2.u_sgd.w_o[0]`, OVF **INCOMP ans=0 ntrunc=4**, UNREL **UNKNOWN ans=0** no stale, `load_from_tb=0`, **no sibling `u_iso` / no `iso_pub`**, **`FORCE_PRESENT=NO`** on pass sources, frozen A09-R2 instantiated hash unchanged, leftover A09 not compiled, ASTRA-09-R6 not overwritten, `xsim_fail_r0` preserved, AXI plant labeled fixture not token bypass, UNISIM MMCM not stub, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`.

`REJECT_PROMOTION` — Master **ASTRA-09** (production UART path / fixture-free plant / SoC top / LM06), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Do not claim R6 ISO-opcode closed by this bag. XSim UART **≠** silicon UART.

Master ASTRA-09 UART / BOARD / production-path identity: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-09-R6-UART-ISO-PUBLIC-01: **untouched, ISO-opcode still PASS_NARROW, not this result**.  
ASTRA-09-R5-UART-ISO-INNER-01: **untouched, inner-force still PASS_NARROW, not this result**.  
ASTRA-09-R4-UART-ISO-01: **untouched, sibling-ISO still PASS_NARROW, not this result**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, query-only `rew_v_i=0`, not this reward close**.  
ASTRA-12-R3 9-row table: **untouched; PRODUCTION_TOP still UNKNOWN**.  
PRODUCTION_TOP: **UNKNOWN**.  
T0100Z residual 5 (A09-R2 query-learn public path): **CLOSED_NARROW this bag**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. Force on pass sources: **NO**. Frozen A09-R2 instantiated honest: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0130Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-R7-UART-QUERY-REW-01; force present NO; BOARD blocked YES.
