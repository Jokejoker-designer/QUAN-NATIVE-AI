# ASTRA auditor REPORT — 20260907T0100Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R6_UART_ISO_PUBLIC_INDEPENDENT_AUDIT; astra09_r6=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR; astra09_r5=AUDITOR_PASS_NARROW_INNER_FORCE; astra09_r4=AUDITOR_PASS_NARROW_SIBLING_ISO; astra12_r3=AUDITOR_PASS_NARROW_9_ROW_TABLE; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + MASTER ASTRA-13 FINAL-BOARD-ACCEPTANCE + work order ASTRA-09-R6-UART-ISO-PUBLIC-01 + prior auditor 20260907T0030Z (R5 UART ISO-INNER PASS_NARROW ACCEPT_PARTIAL; residual 5: wrap force/release of inner ports, not A09-R2 public ports / query-learn FSM; BOARD blocked YES) + auditor 20260907T0005Z (R4 UART ISO PASS_NARROW sibling u_iso) + auditor 20260906T1700Z (A09-R3 UART XSim PASS_NARROW) + auditor 20260906T1600Z (A09-R2 DUT-level ISO_P3 w0=5 viso=0 on sibling SGD, TB-poked go_u)
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / xelab_fail_r0.log / Compile_Options.txt / xsim.dir/work sdb names / DUT+wrap+TB SV + SVH / uart_rx.sv / uart_tx.sv / frozen A09-R2 SV+SVH (KEEP unused) / frozen SGD / MMCM_MODE.txt / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / PREREG.md / ACK.json / run_xsim.ps1 / metrics.json / CLOSEOUT.md (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun `run_xsim.ps1` (would overwrite `xsim.log` / wipe `xsim_work`). Did not xvlog/xsim.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping SGD/A09/A09-R2/uart hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`, `ASTRA-09-R4-UART-ISO-01/SHA256.txt`, `ASTRA-09-R5-UART-ISO-INNER-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `6faf6f9862d634e9a6a985336ae8b822f9a4f46f2e1c1dbb09e8e0c7b3935be2` is **content-verified** against the opened log, not independently re-digested.

Evidence labels: XSim quotes below are **EVIDENCE**. SGD integer re-derive is **EVIDENCE** from frozen RTL. “UART-real timing matches 8N1” is **ENGINEERING_INFERENCE** from `%t` deltas vs CPB. Silicon / BOARD / bitstream claims are **absent** (correct). Absence of `force`/`release`/`deposit` on pass sources is **EVIDENCE** (grep of wrap/TB/DUT/SVH). New named DUT ISO opcode `0xA5` ≠ A09-R2 query-learn FSM is **EVIDENCE** (ports + FSM) and is **NARROW vs Master ASTRA-09**, not a silent cheat of this bag’s declared XSim unknown.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R6-UART-ISO-PUBLIC-01/`

New named DUT `a7ng_astra_09_r6_iso_pub` (bag-local) instantiates:

- inner `u_sgd` = frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`b66ef328…`) — **the one SGD**
- **does not** instantiate frozen `a7ng_astra_09_r2_cand_ovf` (`15a919f1…`) — **UNUSED, not patched**

Wrap `a7ng_astra_09_r6_uart_iso_public_wrap` instantiates that DUT as `u_r6` only. Pin clock `CLK100MHZ` 10 ns → `MMCME2_BASE` 100→50 + `BUFG`. UART `uart_rx` / `uart_tx` `CLK_HZ=50_000_000` `BAUD=115200` 8N1. TB `tb_astra_09_r6_uart_iso_public`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not** instantiated and **not** compiled. ASTRA-09-R5 wrap/TB **not** this DUT and **not** overwritten. ASTRA-09-R4 wrap/TB **not** this DUT. ASTRA-09-R3 wrap/TB **not** this DUT.

Gate under review is **work-order ASTRA-09-R6-UART-ISO-PUBLIC-01 only** — one unknown (handoff):

> Can UART 8N1 drive the learner **without** `force`/`release`/`deposit` — only module ports and FSM — so ISO_P3 inner w0=+5 and ISO_M3 w0=-6, `load_from_tb=0`?

Parent after auditor **20260907T0030Z residual 5**: R5 UART ISO was real and inner-only, but wrap used XSim `force`/`release` of inner SGD ports. Need UART → **exported ports / query-learn FSM**, no sim force. **Do not patch frozen A09-R2. New named DUT if ports must be added.** Board plugged. **PROGRAM=NO.** Not a bit. Not a freeze.

**Not** Master ASTRA-09 production path. **Not** A09-R2 public token/reward/query ISO. **Not** ASTRA-09-R5 sim-override inner-port close. **Not** ASTRA-09-R4 sibling-ISO close. **Not** ASTRA-09-R3 MAGIC A2 query OVF/SMOKE/UNREL. **Not** wrap-route bit. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** `PRODUCTION_TOP` freeze. **Not** silicon UART / silicon MMCM.

Hunt (parent / work order / this dispatch):

1. Grep wrap/TB/DUT for `force`/`release`/`deposit` — must be none on the pass sources.
2. UART 8N1 → module ports → one inner SGD? Frozen A09-R2 unused is honest?
3. Raw log inner w0=+5 then -6, tbl=0?
4. `xelab_fail_r0` preserved; frozen A09-R2 hash unchanged?
5. Overclaim BOARD_PASS / `PRODUCTION_TOP` / query-learn FSM (ISO opcode vs query path)?
6. Hash `.svh` before xvlog? PROGRAM=NO?

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R6-UART-ISO-PUBLIC-01.md` + PREREG: UART 8N1 drives learner without `force`/`release`/`deposit`; only module ports and FSM; one SGD = new named DUT inner `u_sgd`; ISO_P3 +5 and ISO_M3 -6 on hierarchical `u_r6.u_sgd.w_o[0]`; `load_from_tb=0`; frozen A09-R2 unused (hash unchanged) or new named copy listed; `PRODUCTION_TOP=UNKNOWN`; PROGRAM=NO; SHA including `.svh` before xvlog; one corrective if FAIL; do not edit R5 / R4 / frozen A09-R2 / SGD.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *one integrated production path; remove fixture shortcuts; all functional regressions.* Master §4 production path is `Raw bytes/tokens → query transaction → role-aware parser → valid typed route keys → sparse index/postings → bounded descriptors → PHYS4 scoring + shared learned ranker → retained Top-K/frontier → bounded relation expansion → proof validity/uncertainty → materialized evidence → LM06 generation → UART tokens/proof/status.`
3. **Master ASTRA-13**: silicon / BOARD_PASS. `docs/ASTRA/PROJECT_PATHS.md`: *ASTRA-13 BLOCKED. PROGRAM=NO.*
4. Auditor `20260907T0030Z`: R5 PASS_NARROW UART-driven **inner** ISO via sim `force` of inner ports; residual 5 = public-path ISO through A09-R2 exported ports / query-learn FSM still open.
5. Auditor `20260907T0005Z`: R4 PASS_NARROW UART-driven sibling ISO; residual 5 then was inner `u_sgd`.
6. Auditor `20260906T1700Z`: A09-R3 UART XSim PASS_NARROW.
7. Auditor `20260906T1600Z`: A09-R2 bag ISO_P3 `w0=5 viso=0` on a **sibling** frozen SGD, TB-poked `go_u`.

Out of this bag’s close: Master ASTRA-09 production UART (SoC top + on-chip plant + ISO through A09-R2 **public** `tok_valid_i` / `rew_v_i` / fire/retire into **that** inner `u_sgd`), ASTRA-13 BOARD_PASS, wrap-route bit of this UART ISO wrap, LM06 language, Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, `PRODUCTION_TOP` identity, silicon UART.

Prior bags `ASTRA-09-R5-UART-ISO-INNER-01`, `ASTRA-09-R4-UART-ISO-01`, `ASTRA-09-R3-UART-XSIM-01`, `ASTRA-12-R3-UART-WRAP-CANDIDATES-01`, `ASTRA-09-R2-CAND-OVF-01`, `ASTRA-11-A09R3-UART-*` are **comparison / provenance only** and must not have been rewritten.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

`ACK.json` present. `SHA256.txt` CONFIG hashes it (`9a4abf4c…e1e72b19`). `write_scope` = new bag + distinctly named public-ISO DUT/wrap/TB. Frozen `a7ng_astra_09_r2_cand_ovf.sv` **unused** (hash `15a919f1…` unchanged; it does not export `iso`/`go_upd`/`x`/`rew`). New named DUT `a7ng_astra_09_r6_iso_pub` instantiates frozen SGD as inner `u_sgd` only and exports `iso_req`/`iso_x0`/`iso_rew`. Wrap UART FSM drives those ports. Wrap/TB/DUT contain no `force`/`release`/`deposit`. No parallel `u_iso`. ASTRA-09-R5 wrap/TB not edited. ASTRA-09-R4 wrap/TB not edited. Frozen leftover A09 not compiled as DUT. Frozen SGD not patched. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master_ASTRA-09, Master_F3_10pp_CI, Master_ASTRA-06, LM06, BOARD_PASS, ASTRA-13, ASTRA-11_SoC_UART_wrap, ASTRA-09-R3-UART-XSIM-01, ASTRA-09-R4-UART-ISO-01, **ASTRA-09-R5-UART-ISO-INNER-01**, ASTRA-SOC-RTP-WRAP-UART-XSIM, production_top_identity, write_bitstream, wrap_route_bit, silicon_UART, sibling_u_iso_as_production_law, **frozen_A09R2_public_token_reward_ISO**.

`run_xsim.ps1` is xvlog/xelab/xsim only. **No** `write_bitstream` / `xsdb` / `COM12` / `hw_server` / `program_device` strings (grep). Script **throws** if live frozen A09 hash ≠ `9fdbe0d6…` or live R2 hash ≠ `15a919f1…` or live SGD hash ≠ `b66ef328…` **before** xvlog. Script **throws** `A09R6_SIM_OVERRIDE_IN_{WRAP,TB,DUT,SVH}` on `(?i)\bforce\b|\brelease\b|\bdeposit\b|\$force|\$deposit`. Script **throws** `A09R6_SIBLING_SGD_IN_WRAP` / `_IN_TB` if wrap/TB match `(?m)^\s*a7ng_shared_rank_sgd_q8_sym_f2r2\s+\w+`. Script **throws** `FORBIDDEN_DUT_IN_COMPILE_LIST` if compile list matches `astra_09_integ_path|astra_rtp_soc_top|astra09_pipe|astra_09_r2_cand|astra_09_r3_uart|astra_09_r4_uart|astra_09_r5_uart`. Prints `FORCE_PRESENT=NO` before xvlog.

Bag listing: **no** `.bit`, no `timing*.rpt`, no `vivado.log`, no `xsim_fail_r0.log` (fail was xelab, not xsim). **`xelab_fail_r0.log` present** (first-elab fail preserved). Wrap/TB/DUT live **only** in this bag — grep `a7ng_astra_09_r6` under `rtl/` = **no matches**. `MMCM_MODE.txt`:

```text
MMCM_MODE=UNISIM_MMCME2_BASE
NOT_SILICON_MMCM=1
PROGRAM=NO
PRODUCTION_TOP=UNKNOWN
FORCE_PRESENT=NO
FROZEN_A09R2=UNUSED
```

Prior bags **not rewritten** (headers / markers opened this session):

| Bag | Raw identity still on disk |
|-----|----------------------------|
| `ASTRA-09-R5-UART-ISO-INNER-01/xsim.log` | session **Mon Sep 7 00:34:46 2026** PID **11336** snapshot `a09r5iso`; still prints `ASTRA_09_R5_UART_ISO_INNER_PASS`; `$finish` **3471615 ns**; exit **00:35:10** |
| `ASTRA-09-R5-UART-ISO-INNER-01` wrap SHA | KEEP in this bag `ee02935e…2f95999e` **MATCH** R5 `SHA256.txt` compiled wrap |
| `ASTRA-09-R4-UART-ISO-01/xsim.log` | session **Mon Sep 7 00:12:53 2026** PID **47704** snapshot `a09r4iso`; still prints `ASTRA_09_R4_UART_ISO_PASS` |
| `ASTRA-09-R4-UART-ISO-01` wrap SHA | KEEP in this bag `cc8ffdaa…836703ab` **MATCH** R4 `SHA256.txt` compiled wrap |
| `ASTRA-09-R3-UART-XSIM-01/xsim.log` | session **Sun Sep 6 21:45:37 2026** PID **19596** snapshot `a09r3uart` |
| `ASTRA-12-R3-UART-WRAP-CANDIDATES-01/RESULTS.md` | `PRODUCTION_TOP=UNKNOWN`; `BOARD_PASS` not claimed |

R5 wrap still contains the residual-5 glue (`force u_a09r2.u_sgd.x_i` / `reward_i` / `go_upd_i`). That file was **not** this compile and **not** overwritten.

### Hash freeze (compiled + .svh) — MATCH (manifest, not re-hashed)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-07T00:55:25.9945858+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (bag `a7ng_astra_09_r6_iso_pub.svh`) + CONFIG + stub-on-disk + KEEP_NOT_COMPILED (leftover A09 + **unused A09-R2** + R3/R4/R5 UART wraps + both frozen `.svh`) + PROVENANCE **then** calls xvlog.  
Raw `xsim.log` session **Mon Sep 7 00:55:33–00:55:55 2026**, PID **13656**, snapshot `a09r6iso`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-07T00:55:55.5975892+07:00` (matches log exit `Exiting xsim at Mon Sep  7 00:55:55 2026`).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + bag `.svh` vs POST: **7/7 MATCH** (opened manifests). Frozen leftover A09 `.sv` and frozen A09-R2 `.sv` are KEEP_NOT_COMPILED / POST provenance, **not** in COMPILED list.

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…c67aac` |
| bag `a7ng_astra_09_r6_iso_pub.sv` | `3c0b3fa8…a19590c3` |
| `rtl/board/uart_rx.sv` | `8e802d0b…cd5369a` |
| `rtl/board/uart_tx.sv` | `b4b7d097…b36367b` |
| bag `a7ng_astra_09_r6_uart_iso_public_wrap.sv` | `2fcb59c7…20202044` |
| bag `tb_astra_09_r6_uart_iso_public.sv` | `f1418fbb…a1f5cd2` |
| bag `a7ng_astra_09_r6_iso_pub.svh` | `241e8a9f…0702748a` |
| KEEP leftover A09 `.sv` (not compiled) | `9fdbe0d6…bb5c776c` |
| KEEP frozen A09-R2 `.sv` (not compiled) | `15a919f1…8b70ee23` |
| KEEP A09 `.svh` / A09-R2 `.svh` | `ad2d66d4…b4e94302` / `feaed571…71afd329` |
| KEEP R5 UART wrap (not compiled) | `ee02935e…2f95999e` |
| KEEP R4 UART wrap (not compiled) | `cc8ffdaa…836703ab` |
| KEEP R3 UART wrap (not compiled) | `20cdeb8e…a3e88b41` |

Overlapping SGD / leftover A09 / A09-R2 / A09-R2 `.svh` hashes **MATCH** `ASTRA-09-R2-CAND-OVF-01/SHA256.txt` **and** R4 **and** R5. `uart_rx` / `uart_tx` prefixes **MATCH** R4/R5. Handoff required R2 `15a919f1…` unused-unchanged, leftover A09 `9fdbe0d6…`, SGD `b66ef328…`: **all three present; SGD compiled; A09 and A09-R2 not compiled**. Frozen hashes **unchanged**.

`.svh` hashed **before** xvlog: **YES** (bag SVH in TRANSITIVE_INCLUDES; frozen A09/R2 SVH in KEEP). PROGRAM=NO: **YES**. ASTRA-09-R5 not overwritten: **YES**.

### Compiled identity (raw xvlog / xelab / work sdb) — one SGD module, one inner instance; A09-R2 unused

`xvlog.log` (bag copy after first xvlog) analyzes, in order: **SGD**, **`a7ng_astra_09_r6_iso_pub`**, `uart_rx`, `uart_tx`, bag wrap, bag TB. **No** `a7ng_astra_09_r2_cand_ovf.sv`, **no** `a7ng_astra_09_integ_path.sv`, **no** R3/R4/R5 wraps, **no** `mmcm_stub`. No ERROR lines in that log.

(`xsim_work/xvlog.log` is **glbl-only**: script’s second xvlog of `glbl.v` overwrites the work copy. Bag `xvlog.log` is the SV analyze list. Not a missing compile.)

Pass `xelab.log` command:

```text
xelab.exe tb_astra_09_r6_uart_iso_public glbl -s a09r6iso -timescale 1ns/1ps -L unisims_ver --debug typical
```

Compiled modules (raw pass xelab): `unisims_ver.MMCME2_BASE` / `MMCME2_ADV` / `BUFG`, `uart_rx(CLK_HZ=50000000)`, `uart_tx(CLK_HZ=50000000)`, **`a7ng_shared_rank_sgd_q8_sym_f2r2`** (once), **`a7ng_astra_09_r6_iso_pub`**, `a7ng_astra_09_r6_uart_iso_public_wrap`, `tb_astra_09_r6_uart_iso_public`, `glbl`. One unconnected-port WARNING on `CLKFBOUTB` (wrap line 24) — not a FAIL. **Built simulation snapshot `a09r6iso`.**

`Compile_Options.txt`: `"tb_astra_09_r6_uart_iso_public" "glbl" -s "a09r6iso" -timescale "1ns/1ps" -L "unisims_ver" --debug "typical"`.

`xsim.dir/work` sdb names (bag listing): `a7ng_astra_09_r6_iso_pub.sdb`, `a7ng_astra_09_r6_uart_iso_public_wrap.sdb`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sdb` (**one**), `uart_rx.sdb`, `uart_tx.sdb`, `tb_astra_09_r6_uart_iso_public.sdb`, `glbl.sdb`. **No** `a7ng_astra_09_r2_cand_ovf.sdb`, **no** `a7ng_astra_09_integ_path.sdb`, **no** R3/R4/R5 wrap sdb, **no** `mmcm_stub.sdb`, **no** `arty_a7_astra_rtp_soc_top.sdb`.

SGD is compiled because the new named DUT instantiates it as inner `u_sgd`. That is **one instance**, not a wrap sibling.

### Fail-r0 preserved (one DUT loop-index corrective)

`xelab_fail_r0.log` is present and is a real first-elab fail:

```text
Running: .../xelab.exe tb_astra_09_r6_uart_iso_public glbl -s a09r6iso -timescale 1ns/1ps --debug typical
WARNING: [VRFC 10-3645] port 'CLKFBOUTB' remains unconnected ... wrap.sv:24
ERROR: [VRFC 10-3818] variable 'k' is driven by invalid combination of procedural drivers [.../a7ng_astra_09_r6_iso_pub.sv:28]
WARNING: [VRFC 10-2921] 'k' driven by this always_comb block should not be driven by any other process [.../a7ng_astra_09_r6_iso_pub.sv:34]
ERROR: [XSIM 43-3322] Static elaboration of top level Verilog design unit(s) in library work failed.
```

Pass DUT now declares **`integer kc, kf;`** at line 28: `kc` only in `always_comb` copy of `x_lat`→`x_sgd`; `kf` only in `always_ff` reset/latch of `x_lat`. Structure of `always_comb` remains at line 34. **One named DUT corrective** (shared loop index). Frozen SGD / A09-R2 **not** patched.

Note (not P1): fail-r0 command line **lacks** `-L unisims_ver`; pass xelab **has** it. Functional fail is VRFC 10-3818 on `k`, not a missing-unisim error (`MMCME2_BASE` already warned CLKFBOUTB). Current `run_xsim.ps1` always xelabs with `-L unisims_ver` and does **not** itself copy `xelab_fail_r0.log` (that file was preserved by the implementer). Pass `MMCM_MODE=UNISIM_MMCME2_BASE`. Not a second unknown.

---

### Hunt 1 — wrap/TB/DUT/SVH `force`/`release`/`deposit` on pass sources — NONE

Grep of bag `*.sv` for `force|release|deposit|$force|$deposit`: **no matches**. Opened pass sources:

- `a7ng_astra_09_r6_iso_pub.sv` — public `iso_req_i` / `iso_x0_i` / `iso_rew_i`; inner `go_upd` is a DUT FF driven by `L_GO`.
- `a7ng_astra_09_r6_uart_iso_public_wrap.sv` — UART FSM pulses **`iso_req`** into DUT ports; **no** hierarchical assign into `u_r6.u_sgd.*`.
- `tb_astra_09_r6_uart_iso_public.sv` — bit-bangs `uart_txd_in`; `wrap_rst` uses pin `btn[0]`; hierarchical **reads** of `dut.u_r6.u_sgd.w_o[0]` in `decode_iso` / `chk` only.
- `a7ng_astra_09_r6_iso_pub.svh` — opcode/magic/EOL params only.

Hits on `force` in the bag are **docs / ACK / PREREG / RESULTS / metrics `force_present: false` / `run_xsim.ps1` ban-pattern**. Script would throw `A09R6_SIM_OVERRIDE_*` if pass sources contained the tokens.

Contrast R5 wrap (KEEP, not this compile): `force u_a09r2.u_sgd.x_i` / `reward_i` / `go_upd_i`. That is residual 5. **This bag does not use it.**

`FORCE_PRESENT=NO` on pass sources: **YES.**

---

### Hunt 2 — UART 8N1 → module ports → one inner SGD; frozen A09-R2 unused is honest — YES / YES

**One SGD, inner only.** Grep bag `*.sv` for `a7ng_shared_rank_sgd_q8_sym_f2r2`: **one** instantiation, DUT inner `u_sgd`. Wrap instantiates **`a7ng_astra_09_r6_iso_pub u_r6`** only. TB instantiates the wrap only. No `u_iso`. No wrap/TB SGD ident.

DUT:

```text
(* keep_hierarchy = "yes" *)
a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
  .clk(clk), .rst_n(rst_n), .freeze_i(1'b0),
  .go_score_i(1'b0), .go_upd_i(go_upd), .x_i(x_sgd), .reward_i(rew_lat),
  .load_v_i(1'b0), ...
  .w_o(w_o), .ready_o(sgd_rdy), .done_o(sgd_dn), .v_q8_o(v_q8_o)
);
assign load_from_tb_o = 1'b0;
```

Learn FSM (`L_IDLE` → `L_GO` → `L_WAIT`): on `iso_req_i && sgd_rdy`, zero `x_lat`, `x_lat[0] <= iso_x0_i`, `rew_lat <= iso_rew_i`; next cycle pulse `go_upd` if `sgd_rdy`; then wait `sgd_dn` and pulse `iso_done_o`. **Synthesizable port/FSM glue. Not `force`.**

Wrap binds UART RX (50 MHz pipe, 115200) to pin `uart_txd_in`:

```text
uart_rx #(.CLK_HZ(CLK_HZ), .BAUD(BAUD)) u_rx (
  .clk(clk), .rst_n(rst_n), .rx(uart_txd_in), .data(rx_data), .valid(rx_valid)
);
```

`uart_rx.sv` is a real 8N1 sampler (IDLE→START mid-bit check→DATA 8 bits LSB-first→STOP, `valid` one cycle). `uart_tx.sv` is a real start/data/stop serializer. Not a byte-wide backdoor.

Wrap FSM (`C_IDLE→C_X→C_REW→C_EOL→C_HOLDX→C_GO→C_WAIT→C_TX`):

```text
C_IDLE: if (rx_valid && (rx_data == CMD_ISO) && !tx_active) cst <= C_X;
C_X:    if (rx_valid) begin x0_lat <= rx_data; cst <= C_REW; end
C_REW:  if (rx_valid) begin rew8_lat <= rx_data; iso_rew <= rx_data[3:0]; cst <= C_EOL; end
C_EOL:  if (rx_valid) cst <= (rx_data == EOL) ? C_HOLDX : C_IDLE;
C_HOLDX: if (iso_rdy) cst <= C_GO;
C_GO:   begin if (iso_rdy) iso_req <= 1'b1; cst <= C_WAIT; end
C_WAIT: if (iso_dn) begin ... pack tx_bytes from inner_w0 ... cst <= C_TX; end
```

`iso_req` is default-cleared every cycle (`iso_req <= 1'b0` at the top of the FF). **One-cycle pulse** into DUT public `iso_req_i`. Raw log shows **one** `INNER_GO` per ISO (not R5’s two adjacent force pulses).

TB drives **only** pin `uart_txd_in` (idle 1) plus `btn[0]` for wrap reset. Bit-bang is 8N1 at pin-clock CPB (100 MHz / 115200 → 868). ISO command on the wire: `CMD_ISO=0xA5`, `x0`, `rew8`, `EOL=0x0A`. Result path is real `uart_tx` serialize of public `w_o[0]` after `iso_dn`, sampled by TB 8N1 on `uart_rxd_out`. Frame MAGIC A2 / EOL 0x0A.

Wrap observability of inner w0 is **public port**, not a hierarchical force:

```text
assign inner_w0 = w_pub[0];   // w_pub is DUT .w_o, mapped from inner u_sgd.w_o
```

TB additionally **reads** `dut.u_r6.u_sgd.w_o[0]` as `hier_sgd_w0`. Observation only.

**Frozen A09-R2 unused is honest.** Opened `a7ng_astra_09_r2_cand_ovf.sv` public ports are query/learn handshake (`tok_valid_i`, `tok_i`, `fire_i`, `retire_i`, `rew_v_i`, `rew_i`, AXI, …). **No** `iso_req` / `iso_x0` / `iso_rew` / exported `go_upd` / exported `x_i`. Inner SGD ports are internal (`.go_upd_i(sgd_upd)` at line 300). A09-R2 learn is `rew_v_i` while `pend_acc` in `S_HOLD` → `S_UW`. Work order: *Do not patch frozen A09-R2. New named DUT if ports must be added.* Hash `15a919f1…` KEEP, not compiled, MATCH R2/R4/R5. **UNUSED = honest, not a silent drop of a public ISO port that already existed.**

UART-real timing (raw log, `%t` = 1 ps; `$finish` reports ns):

| Event | t (ps) | ns |
|-------|--------:|---:|
| `ISO_P3_CMD_SENT` | 6_285_000 | 6.285 |
| `INNER_GO x0=50 rew=3` | 349_285_000 | 349.285 |
| `INNER_DONE w0=5` | 350_685_000 | 350.685 |
| `UART_RX n=1 byte=a2` | 433_185_000 | 433.185 |
| `UART_RX n=2 byte=40` | 520_025_000 | 520.025 |
| `ISO_M3_CMD_SENT` | 1_742_215_000 | 1742.215 |
| `INNER_GO x0=64 rew=-3` | 2_085_225_000 | 2085.225 |
| `INNER_DONE w0=-6` | 2_086_625_000 | 2086.625 |

CMD_SENT → INNER_GO Δ = **343.000 µs**. Four host bytes × 10 bits × 8680 ns = 347.200 µs; last `rx_valid` is ~1 stop-bit early on the 50 MHz sampler (CLKS_PER_BIT=434, HALF=217). **MATCH UART-real, not a zero-delay poke.**

TX byte spacing n=1→n=2: 520_025_000 − 433_185_000 = **86_840_000 ps = 86840 ns**. Ten bits × 8680 ns = 86800 ns. Extra 40 ns = pin-clock alignment. **UART-real TX.** Same 86840 ns spacing n=2→n=3.

INNER_DONE is 60 ns later than R5’s 350625000: extra DUT `L_IDLE` latch + `L_GO` pulse vs R5 same-cycle `force`. Honest FSM cost, not a second ISO step. P3 inner w0=+5 **not** +10.

---

### Hunt 3 — raw log hierarchical `u_r6.u_sgd.w_o[0]` +5 then -6; `tbl=0` — MATCH

Raw `xsim.log` (authority; session Mon Sep 7 00:55:33 PID 13656; `$finish` **3471735 ns**):

```text
ISO_P3_CMD_SENT x0=50 rew=+3 t=6285000
INNER_GO x0=50 rew=3 t=349285000
INNER_DONE w0=5 v=0 w1=0 tbl=0 pub_w0=5 t=350685000
...
FRAME ISO_P3 a2 40 05 00 00 00 32 03 00 00 00 00 00 00 00 0a
ISO_P3 w0=5 v=0 w1=0 x0=50 rew=3 tbl=0 iso=1 inner_w0=5 hier_sgd_w0=5 pub_w0=5 hier_tbl=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_PRE_W0
ISO_M3_CMD_SENT x0=64 rew=-3 t=1742215000
INNER_GO x0=64 rew=-3 t=2085225000
INNER_DONE w0=-6 v=0 w1=0 tbl=0 pub_w0=-6 t=2086625000
...
FRAME ISO_M3 a2 40 fa ff 00 00 40 fd 00 00 00 00 00 00 00 0a
ISO_M3 w0=-6 v=0 w1=0 x0=64 rew=-3 tbl=0 iso=1 inner_w0=-6 hier_sgd_w0=-6 pub_w0=-6 hier_tbl=0
PASS ISO_M3_X64_DW6
ASTRA_09_R6_UART_ISO_PUBLIC_PASS
```

Zero `FAIL` lines in `xsim.log` (opened full log; TB FAIL `$display` templates did not fire). Marker present. RESULTS `SIM_TIME=3471735 ns` MATCH `$finish`.

Frame decode (little-endian w0):

| Case | UART bytes | w0 LE | x0 | rew8 | tbl bit | hier `u_sgd.w_o[0]` | `pub_w0` |
|------|------------|------:|---:|-----:|--------:|--------------------:|---------:|
| ISO_P3 | `a2 40 05 00 00 00 32 03 … 0a` | **+5** (`05 00`) | 50 (`32`) | +3 (`03`) | 0 | **+5** | **+5** |
| ISO_M3 | `a2 40 fa ff 00 00 40 fd … 0a` | **-6** (`fa ff`) | 64 (`40`) | -3 (`fd`) | 0 | **-6** | **-6** |

`pub_w0` matches inner `u_sgd.w_o[0]` because DUT exports `w_o` from that child. Contrast T0005Z R4: same frames on sibling `wiso` but `a09_w0=0`. Contrast T0030Z R5: same integers on inner A09-R2 `u_sgd` via **force**. This bag: same integers on **new DUT inner `u_sgd` via public `iso_*` ports**.

`load_from_tb=0` on both:

- DUT RTL: `assign load_from_tb_o = 1'b0;`
- Inner SGD: `.load_v_i(1'b0)`
- TB: no `load_v` / weight preload; ISO_M3 `wrap_rst()` then `chk("ISO_M3_PRE_W0", dut.inner_w0 === 16'sd0 && dut.u_r6.u_sgd.w_o[0] === 16'sd0)` so M3 starts from **reset zero**, not leftover P3 +5
- Raw dumps: `tbl=0` `hier_tbl=0` `PASS ISO_P3_TBL0` `PASS ISO_M3_TBL0`

`freeze_i=1'b0` on inner `u_sgd`. `go_score_i=1'b0`. Weights come from the SGD update.

SGD law re-derived from frozen `a7ng_shared_rank_sgd_q8_sym_f2r2.sv` (`SHIFT=6`, `dw40=rsh40(err*x, 7+SHIFT)`, `err=rew*256-v`, `w=0` ⇒ `v=0`):

- P3: `rew=+3`, `x0=50` → `err=768`, `prod=38400`, `rsh40(38400,13)=(38400+4096)>>>13=5` → **w0=+5**
- M3: `rew=-3`, `x0=64` → `err=-768`, `prod=-49152`, `rsh40(-49152,13)=-(49152+4096)>>>13=-6` → **w0=-6**

Not floor-shift +4. Matches T1600 / T0005Z / T0030Z ISO integers, now on **port-driven** inner `w_o[0]`. `v=0` is the from-zero score, not a tautology of a constant TX template: w0 bytes differ (`05 00` vs `fa ff`) and match hierarchical `u_r6.u_sgd.w_o[0]` after `INNER_DONE`.

`iso_rew <= rx_data[3:0]` is the frozen SGD port width (`reward_i` is `signed [3:0]`). `0x03` → +3; `0xFD` → nibble `0xD` = -3. Honest for this ISO pair.

---

### Hunt 4 — `xelab_fail_r0` preserved; frozen A09-R2 hash unchanged — MET

See fail-r0 and hash sections. Frozen R2 `15a919f1…` / SGD `b66ef328…` / leftover A09 `9fdbe0d6…` MATCH R2 bag, MATCH R4 bag, MATCH R5 bag, MATCH this PRE/POST. R2 **not compiled** this bag. R5 `xsim.log` still 00:34:46 PID 11336 with `ASTRA_09_R5_UART_ISO_INNER_PASS`. R5 wrap KEEP hash `ee02935e…` MATCH R5 compiled wrap. R4 log still 00:12:53 PID 47704. R3 log still 21:45:37 PID 19596. R6 wrap is a **new** file `2fcb59c7…`, not an edit of R5 wrap.

---

### Hunt 5 — Overclaim BOARD_PASS / PRODUCTION_TOP / query-learn FSM — NO BOARD / NO TOP; ISO opcode ≠ A09-R2 query (disclosed NARROW)

ACK / PREREG / RESULTS / CLOSEOUT / metrics / MMCM_MODE / TB banner all keep:

- `PRODUCTION_TOP=UNKNOWN`
- `PROGRAM=false` / `PROGRAM=NO`
- `BIT=NOT_BUILT`
- `BOARD_PASS` in `not_claimed` / OPEN
- `ASTRA-13` OPEN / BLOCKED
- silicon UART / silicon MMCM **not** claimed (`UNISIM_MMCME2_BASE`, `NOT_SILICON_MMCM=1`)
- ASTRA-09-R5 force-inner frames **not** claimed as this bag
- ASTRA-09-R4 sibling frames **not** claimed as this bag
- ASTRA-09-R3 MAGIC A2 query frames **not** claimed as this bag
- wrap **not** named as production top
- **`frozen_A09R2_public_token_reward_ISO` in `does_not_close` / `not_claimed`**

Marker is bag-local `ASTRA_09_R6_UART_ISO_PUBLIC_PASS`, not `BOARD_PASS`, not `ASTRA_09_R5_UART_ISO_INNER_PASS`. CLOSEOUT `PASS_THIS_GATE_ONLY`. RESULTS proposed `PASS_NARROW (this bag only: UART-facing PUBLIC ISO of new named DUT inner u_sgd via module ports + learn FSM …)`.

No `.bit` / `.bin` / `.mcs` in the bag. `run_xsim.ps1` cannot program.

**ISO opcode vs query path (required hunt):** this wrap accepts **only** `CMD_ISO=0xA5` then `x0`, `rew8`, `EOL=0x0A`. There is **no** query token stream, **no** `fire`/`retire`, **no** `tok_valid_i`, **no** A09-R2 `S_HOLD`/`S_UW` `rew_v_i` handshake. DUT FSM is ISO-only `L_IDLE/L_GO/L_WAIT`. Implementer language is “learn FSM” / “module ports”, **not** “A09-R2 query-learn FSM closed”. That is **honest NARROW**, not OVERCLAIM.

T0030Z residual 5 therefore **splits**:

| Residual-5 fragment | This bag |
|---------------------|----------|
| No sim `force`/`release`/`deposit` | **CLOSED_NARROW** |
| UART → exported module ports + FSM | **CLOSED_NARROW** (new named DUT `iso_*`) |
| Same integers inner w0=+5 / −6, tbl=0 | **CLOSED_NARROW** |
| UART tokens/reward through **A09-R2 exported ports / query-learn FSM** into **that** inner `u_sgd` | **OPEN** (A09-R2 unused; ISO opcode `0xA5` ≠ query path) |

Do **not** read “PUBLIC ISO” as “A09-R2 public query/reward ISO”. PUBLIC here = new DUT’s `iso_req_i`/`iso_x0_i`/`iso_rew_i`.

---

### Hunt 6 — Hash `.svh` before xvlog; PROGRAM=NO — MET

See hash section. Bag `.svh` in `TRANSITIVE_INCLUDES` of `SHA256.txt` **before** xvlog. Frozen A09/R2 `.svh` hashed KEEP before xvlog. POST 7/7 compiled+svh MATCH. PROGRAM=NO throughout.

---

### This bag vs Master ASTRA-09 public-path ISO

| Claim | This bag | Master ASTRA-09 |
|-------|----------|-----------------|
| UART 8N1 isolated SGD ISO `+3,x0=50→w0=+5` and `-3,x0=64→w0=-6` on **byte stream** + hier inner `u_r6.u_sgd.w_o[0]`, `load_from_tb=0`, **no sibling SGD**, **no force** | **YES** (XSim) | Required as **one** functional regression, not the whole gate |
| Drive learner through **module ports + FSM** (not sim `force`) | **YES** (new named DUT `iso_*` + `L_*`) | Required to remove the R5 fixture shortcut |
| Same learner the **A09-R2 query path** uses | **NO** — A09-R2 unused; new ISO-only DUT wraps frozen SGD | **OPEN** (one-path identity) |
| UART tokens/reward through A09-R2 **public** `tok_*` / `rew_v_i` / fire/retire | **NO** — ISO opcode `0xA5` only | **OPEN** |
| One integrated production path; remove fixture shortcuts | **NO** — bag-local wrap; query path absent; ISO DUT ≠ production top | **OPEN** |
| SoC UART identity / on-chip plant / wrap-route bit | **NO** | **OPEN** |
| Silicon UART on COM12 | **NO** | ASTRA-13 / BOARD — **BLOCKED** |

T0030Z residual 5 (*no force; public ports*) is **answered on force-absence and port/FSM drive**, narrowly. It is **not** answered as production-path ISO through A09-R2’s own query-learn handshake. Do **not** promote Master ASTRA-09.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| Wrap/TB/DUT `force`/`release`/`deposit` on pass sources | **No.** Grep `*.sv` empty. Script would throw. Hierarchical TB access is **read** of `w_o[0]`. |
| Wrap/TB instantiate sibling `u_iso` / second SGD for pass numbers | **No.** One `u_r6`; inner `u_sgd` only. One SGD sdb. |
| TB poke `go_upd` / `x_i` / `iso_req` as ISO authority | **No.** TB bit-bangs `uart_txd_in` only (plus `btn[0]` reset). Wrap FSM pulses `iso_req` after UART `A5 x0 rew 0A`. |
| UART TX is a constant template (tautology) | **No.** P3/M3 frames differ in w0 (`05 00` vs `fa ff`) and x0/rew; match `INNER_DONE` hier `u_sgd.w_o[0]`; TX spacing is 86840 ns/byte. |
| Force / hierarchical assign `w_o` to the golden | **No.** No force. `w_o` is SGD output mapped to DUT public port. w0 re-derives from frozen SGD law. |
| `load_from_tb` as query/ISO authority | **No.** DUT hard 0; `load_v_i=0`; dumps `tbl=0`. Weights from reset-zero SGD update, not TB preload. |
| `freeze_i=1` cheat | **No.** Inner `u_sgd.freeze_i=1'b0`. |
| Claim A09-R2 **query-learn FSM** ISO as this result | **No — disclosed NARROW.** A09-R2 unused. Opcode is ISO `0xA5`, not query tokens. ACK lists `frozen_A09R2_public_token_reward_ISO` as not closed. |
| Claim R5 force-inner / R4 sibling-ISO / R3 OVF/SMOKE as this result | **No.** R5 `xsim.log` still 00:34:46 PID 11336; R4 still 00:12:53 PID 47704; R3 still 21:45:37 PID 19596; this marker is `ASTRA_09_R6_UART_ISO_PUBLIC_PASS`. |
| Silent A09-R2 patch labeled unused | **No.** Hash `15a919f1…` MATCH R2/R4/R5; not in xvlog list; no R2 sdb; ports do not export ISO. Unused is honest. |
| Golden edit / wipe prior xsim.log | **Not found.** `xelab_fail_r0.log` preserved; prior R2/R3/R4/R5/12-R3 logs/headers intact. |
| Hash theatre after scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes bag `.svh` + KEEP frozen `.svh`. POST 7/7 MATCH. |
| BOARD_PASS / silicon UART / `PRODUCTION_TOP` freeze | **Not claimed.** |
| Floor-shift +4 labeled as Master symmetric +5 | **No.** Raw inner w0=+5 / -6; auditor re-derived `rsh40(...,13)` on frozen SGD. |
| ID one-hot as transfer / LM06 language | **Not claimed.** |
| RESULTS vs raw log mismatch | **No** on frames, inner w0, tbl, sim time, marker, INNER_GO times. Minor RESULTS wording: “DUT FSM pulses `iso_req`” — wrap pulses `iso_req`, DUT pulses `go_upd`. Numbers MATCH. |
| MMCM stub silently used | **No.** `MMCM_MODE=UNISIM_MMCME2_BASE`; xelab `-L unisims_ver`; no `mmcm_stub.sdb`. Stub hashed STUB_ON_DISK only. |

Remaining **narrowness** (not cheats): bag-local ISO DUT (not `a7ng_astra_09_r2_cand_ovf` / not `arty_a7_astra_rtp_soc_top` / not a frozen production top); ISO opcode path (not A09-R2 query-learn FSM); unisim MMCM (not silicon); XSim UART (not COM12).

---

## Logic bugs

None that break this bag’s declared unknown.

Notes (not P1):

1. New named DUT is **ISO-only**. Instantiation + inner w0 **is** the ISO datapath. Do not read this as “UART tokens walked the A09-R2 query FSM and then learned +5.”
2. `iso_rew <= rx_data[3:0]` truncates the UART reward byte to the frozen 4-bit SGD port. Correct for `+3`/`-3`. A later host sending a wide reward would silently wrap. Out of this ISO pair.
3. `x0_lat <= rx_data` treats the UART byte as signed Q8. `50` and `64` are in range. Not a bug here.
4. xelab WARNING `CLKFBOUTB` unconnected on `MMCME2_BASE` — same class as T1700/T0005Z/T0030Z UART wraps. Not a functional ISO fail.
5. fail-r0 xelab command line omitted `-L unisims_ver`; pass adds it. Functional first fail was shared integer `k`. Implementer preserved `xelab_fail_r0.log` even though current `run_xsim.ps1` does not auto-copy that filename.
6. `C_GO` always advances to `C_WAIT` in one cycle (pulses `iso_req` if `iso_rdy`). One `INNER_GO` per ISO. Improvement vs R5 double force-pulse; cosmetic relative to this unknown.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R6-UART-ISO-PUBLIC-01`: **PASS_NARROW**

Work-order unknown answered **narrowly** with raw XSim: UART 8N1 command bytes into `uart_rx` (not TB poke of `go_upd`/`x_i`, **not** sim `force`) delivered isolated frozen-SGD updates **into new named DUT inner `u_sgd` via public `iso_*` ports and DUT learn FSM**, visible on the serialized `uart_rxd_out` byte stream and hierarchical `u_r6.u_sgd.w_o[0]`:

- ISO_P3: `x0=50` `rew=+3` → **inner w0=+5** `v=0` `w1=0` `tbl=0` `pub_w0=+5` frame `a2 40 05 00 00 00 32 03 … 0a`
- ISO_M3: `x0=64` `rew=-3` → **inner w0=-6** `v=0` `w1=0` `tbl=0` `pub_w0=-6` frame `a2 40 fa ff 00 00 40 fd … 0a`

`load_from_tb=0`. One SGD instance = inner `u_sgd`. **`FORCE_PRESENT=NO`** on pass wrap/TB/DUT/SVH. Frozen A09-R2 unused, hash unchanged (honest: no public ISO ports to drive without patch). Frozen SGD hash unchanged. Leftover A09 not compiled. ASTRA-09-R5 **not** overwritten. `xelab_fail_r0.log` preserved (shared `k`; one DUT corrective). UNISIM MMCM (not stub, not silicon). PROGRAM=NO. `PRODUCTION_TOP=UNKNOWN`. No BOARD_PASS.

Not PASS (Master ASTRA-09 production path / A09-R2 query-learn public ISO / SoC UART / silicon UART / BOARD).  
Not FAIL (raw log matches PREREG tests; UART path is real; inner w0 is the pass number; no force on pass sources; SGD law re-derives +5/−6; hashes PRE/POST aligned; prior bags intact; no sibling SGD; A09-R2 unused is honest).  
Not OVERCLAIM (ACK/RESULTS keep Master 09/13/BOARD/`PRODUCTION_TOP`/silicon UART/R5-force/R4-sibling/A09-R2-query open; marker is bag-local `ASTRA_09_R6_UART_ISO_PUBLIC_PASS`; ISO opcode vs query path is disclosed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared UART-facing PUBLIC ISO XSim unknown (no force; module ports + FSM; inner w0=+5/−6; tbl=0).

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this XSim to BOARD_PASS, ASTRA-13, silicon UART, silicon MMCM, wrap-route bit, or `PRODUCTION_TOP=a7ng_astra_09_r6_uart_iso_public_wrap` / `a7ng_astra_09_r6_iso_pub`. XSim UART ≠ COM12.
2. Do **not** claim ASTRA-09-R5 force-inner ISO, ASTRA-09-R4 sibling-ISO, or ASTRA-09-R3 MAGIC A2 query OVF/SMOKE/UNREL as closed by this bag. Different wrap, different unknown. R5 `xsim.log` must stay 00:34:46 PID 11336. R4 must stay 00:12:53 PID 47704. R3 must stay 21:45:37 PID 19596.
3. Keep PROGRAM=NO. Board plugged ≠ authority. No `write_bitstream`. ASTRA-13 remains BLOCKED. Do not freeze `PRODUCTION_TOP`.
4. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv`, frozen A09-R2 (`15a919f1…`), or frozen SGD (`b66ef328…`).
5. Force-free **public-port ISO of a new ISO-only DUT** is proven. **A09-R2 query-learn public-path ISO is not.** Master ASTRA-09 “one integrated production path; remove fixture shortcuts” still needs a named path where UART **query tokens / reward** hit inner `u_sgd` **through A09-R2’s exported `tok_*` / `rew_v_i` / fire/retire FSM** — or an explicit recorded decision that this ISO-opcode DUT is the production law check. Not a silent close from `CMD_ISO=0xA5`.
6. Host parsers must not mix this wrap’s 16-byte ISO pack (`A2`, flags `{tbl,iso,6'd0}`, inner w0 LE, v LE, x0, rew8, w1 LE, EOL) with A09-R3 query frames, R4 sibling-ISO layout, R5 inner-force layout, or RTP SoC wrap layout.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated UART-facing PUBLIC ISO XSim around new named `a7ng_astra_09_r6_iso_pub`: ISO commands are **UART-real 8N1 into `uart_rx`**, result MAGIC A2 is **real `uart_tx` serialize**, ISO_P3 **inner w0=+5** and ISO_M3 **inner w0=-6** on the **byte stream** and hier `u_r6.u_sgd.w_o[0]`, `pub_w0` matches inner, `load_from_tb=0`, **no sibling `u_iso`**, **`FORCE_PRESENT=NO`** on pass sources, frozen A09-R2 unused hash unchanged, leftover A09 not compiled, ASTRA-09-R5 not overwritten, `xelab_fail_r0` preserved, UNISIM MMCM not stub, BIT=NOT_BUILT, PROGRAM=NO, `PRODUCTION_TOP=UNKNOWN`.

`REJECT_PROMOTION` — Master **ASTRA-09** (production UART path / fixture-free plant / **A09-R2 public query-learn ISO** / SoC top), **ASTRA-13** (FINAL-BOARD-ACCEPTANCE), and **BOARD_PASS** are **not** closed. Do not freeze `PRODUCTION_TOP`. Public-port ISO of a new ISO-opcode DUT **≠** A09-R2 query-learn FSM. XSim UART **≠** silicon UART.

Master ASTRA-09 UART / BOARD / A09-R2 public-path ISO: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
ASTRA-09-R5-UART-ISO-INNER-01: **untouched, inner-force still PASS_NARROW, not this result**.  
ASTRA-09-R4-UART-ISO-01: **untouched, sibling-ISO still PASS_NARROW, not this result**.  
ASTRA-09-R3-UART-XSIM-01: **untouched, different unknown**.  
ASTRA-12-R3 9-row table: **untouched; PRODUCTION_TOP still UNKNOWN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**. Force on pass sources: **NO**. Inner-only SGD: **YES**. Frozen A09-R2 unused honest: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0100Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-09-R6-UART-ISO-PUBLIC-01; force present NO; BOARD blocked YES.
