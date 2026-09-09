# ASTRA auditor REPORT — 20260907T0330Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA07_SCALE_MID_INDEPENDENT_AUDIT; astra07_mid=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR; astra12_r5=AUDITOR_PASS_NARROW_TWO_COLUMN_BRIEF; astra13=BLOCKED; production_top=UNKNOWN; production_top_freeze=NEEDS_OWNER_NOT_SILENT; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED; auditor=IN_PROGRESS
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-07 (§7 scale ladder 65536→262144→800000 + index image) + work order ASTRA-07-SCALE-MID-01 + prior auditor 20260907T0300Z (ASTRA-12-R5-FREEZE-BRIEF-01 PASS_NARROW; ACCEPT_PARTIAL | REJECT_PROMOTION; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED; BOARD blocked YES) + T1600Z (ASTRA-09-R2-CAND-OVF-01 PASS_NARROW; DUT ntrunc→INCOMP ans=0; leftover A09 not compiled) + T1530Z (ASTRA-07-SCALE-NARROW-01 PASS_NARROW wrap around leftover A09 ans=4)
EVIDENCE   = bag ACK.json / PREREG.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / run_xsim.ps1 / tb_astra_07_scale_mid.sv + RAW xsim.log / xvlog.log / xvlog_dut.log / xelab.log / work.rlx / Compile_Options.txt + frozen A09-R2 RTL / leftover A09 RTL / sparse_dir_axi — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (including this bag’s `run_xsim.ps1` and prior A07/A09/A12 `run_*.ps1`). Did not program the plugged board. Did not edit `docs/ASTRA/LOOP_STATE.json`.

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/A07-wrap/pkg hashes vs `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`, `ASTRA-07-SCALE-NARROW-01/SHA256.txt`, and `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `41d014e6…` is **content-verified** against the opened log, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-07-SCALE-MID-01/`

Bag-local TB `tb_astra_07_scale_mid.sv` instantiates frozen `a7ng_astra_09_r2_cand_ovf` (hash `15a919f1…`) which instantiates frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. Frozen leftover `a7ng_astra_09_integ_path.sv` is **not** instantiated. A07-NARROW wrap is **not** the DUT. Additive bag only: new TB + helpers; frozen RTL not patched.

Gate under review is **work-order ASTRA-07-SCALE-MID-01 only** — one unknown:

> With posting N=64 and CAND_CAP=16, does **A09-R2 itself** (not a wrap around leftover A09) publish INCOMP ans=0, and does smoke two-proof still ANSWER 4 after reset?

**Not** Master ASTRA-07 `65536→262144→800000` / full index image. **Not** Master ASTRA-09 production path. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** LM06. **Not** Master F3 10pp. **Not** a silent `PRODUCTION_TOP` freeze.

Judged against:

1. Work order `.agents/handoff/ASTRA-07-SCALE-MID-01.md`: ACK first; PREREG `N=64`, `CAND_CAP=16`, expected DUT INCOMP; leftover A09 not the DUT; tests: overflow INCOMP `ans=0 p0=0`; smoke after reset `ans=4 p0=17`; UNREL no stale; ISO +5 if inner SGD reachable without force; do not claim 65536/800k, BOARD, PRODUCTION_TOP freeze; PROGRAM=NO; SHA including `.svh` before xvlog; instantiate `a7ng_astra_09_r2_cand_ovf`; do not patch frozen RTL; do not edit prior bags.
2. **Master ASTRA-07** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“Stable-law scale ladder65536→262144→800000 plus lower-N controls; full index image/provenance, quality and traffic bounds.”*
3. Auditor `20260907T0300Z`: 12-R5 brief **PASS_NARROW**; Final `ACCEPT_PARTIAL | REJECT_PROMOTION`; `PRODUCTION_TOP=UNKNOWN`; ASTRA-13 BLOCKED; parent residual = this scale-mid XSim path, not silent top freeze, not ASTRA-13, not 65536/800k.
4. Auditor `20260906T1600Z`: A09-R2 **PASS_NARROW** at plant `N=20`; DUT itself `ntrunc→INCOMP ans=0`; leftover A09 not compiled. This bag must **instantiate** that frozen DUT, not wrap leftover A09, not re-patch R2.

Hunt (this dispatch):

1. `N=64>CAND_CAP=16`: DUT itself `ans=0` INCOMP, `ntrunc`, `hier_ans=0`? Quote log.
2. Smoke after reset `ans=4 p0=17`? UNREL? ISO +5 without force?
3. Overclaim 65536/800k/Master ASTRA-07/BOARD?
4. Hash `.svh` before xvlog? PROGRAM=NO?

Confirm leftover `a7ng_astra_09_integ_path` was **NOT** compiled; A09-R2 instantiated.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

ACK.json present. `SHA256.txt` CONFIG hashes it (`c1827ebe…`). `write_scope` = new bag + bag-local TB/helpers only; instantiate frozen A09-R2 as DUT (not a wrap around leftover A09); instantiate frozen SGD for ISO without force; do not patch frozen A09-R2 / leftover A09 / A07-NARROW wrap / SGD; do not edit ASTRA-07-SCALE-NARROW-01, ASTRA-09-R2, ASTRA-12-R5, leftover A09 bags. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `hw_server: false`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master ASTRA-07 65536/262144/800000, ASTRA-07 index image, Master ASTRA-09, Master F3 10pp/CI, Master ASTRA-06, LM06, BOARD_PASS, ASTRA-13, production_top_identity, write_bitstream.

Handoff base `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` MATCH ACK / CLOSEOUT / PROJECT_PATHS HEAD.

Prior bags **not rewritten**:

- `ASTRA-09-INTEGRATED-PATH-01/xsim.log` still session **Sun Sep 6 18:53:05 2026** PID **40928** snapshot `a09ip`.
- `ASTRA-07-SCALE-NARROW-01/xsim.log` still session **Sun Sep 6 20:46:35 2026** PID **2904** snapshot `a07sn`.
- `ASTRA-09-R2-CAND-OVF-01/xsim.log` still session **Sun Sep 6 21:05:33 2026** PID **22184** snapshot `a09r2`.
- ASTRA-12-R5 `RESULTS.md` / `BRIEF.md` still `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN`.

This bag listing has **no** `.bit`, no `timing*.rpt`, no `vivado.log`, no `xsim_fail_r0.log` / `xvlog_fail_r0.log`. `run_xsim.ps1` is xvlog/xelab/xsim only (no JTAG/xsdb/COM12/`write_bitstream` strings). Script **throws** before xvlog if live leftover A09 hash ≠ `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` **or** live A09-R2 hash ≠ `15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23`.

### Hash freeze (compiled + .svh) — hunt 4 MATCH

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-07T02:47:54.2246151+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (both `.svh`) + CONFIG + provenance **then** calls xvlog (script lines 46–68).  
Raw `xsim.log` session **Mon Sep 7 02:47:58–02:48:00 2026**, PID **21092**, snapshot `a07sm`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-07T02:48:00.7986445+07:00` (matches log exit).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + transitive `.svh` vs POST: **14/14 MATCH** (opened manifests; not re-hashed). Leftover A09 `.sv` is extra in POST provenance (not in COMPILED list).

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf98852…5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0…05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49…cd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da2…a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42…a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d…b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` | `15a919f1…8b70ee23` |
| `.../tb_astra_07_scale_mid.sv` | `7cc2dcc0…bbad9783` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d3…e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `38189974…fa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9…49c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh` | `ad2d66d4…fb4e94302` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…171afd329` |

`.svh` **is** in the pre-xvlog freeze (R2 contract and frozen A09 header). PROGRAM=NO.

Overlapping frozen hashes MATCH prior bags:

- A09-R2 DUT `15a919f1…` MATCH `ASTRA-09-R2-CAND-OVF-01/SHA256.txt`
- leftover A09 `.sv` `9fdbe0d6…` MATCH A09-INTEG / A07-NARROW / A09-R2
- leftover A09 `.svh` `ad2d66d4…` MATCH those bags
- A09-R2 `.svh` `feaed571…` MATCH A09-R2 bag
- frozen SGD `b66ef328…` MATCH A09 / A07 / A09-R2
- frozen A07 wrap `13c1ae1e…` MATCH A07-NARROW (provenance only; **not** compiled here)

### Leftover A09 was NOT compiled; A09-R2 instantiated — MATCH

**xvlog DUT list does not include `a7ng_astra_09_integ_path.sv`.** Raw `xvlog.log` / `xvlog_dut.log` analyze:

```text
.../a7ng_astra_09_r2_cand_ovf.sv  → module a7ng_astra_09_r2_cand_ovf
.../tb_astra_07_scale_mid.sv      → module tb_astra_07_scale_mid
```

plus pkg / QSE / sparse / frozen SGD. **No** `analyzing module a7ng_astra_09_integ_path`. **No** `a7ng_astra_07_scale_narrow`. Zero ERROR/WARNING in `xvlog.log`.

`xelab.log` compiles `a7ng_astra_09_r2_cand_ovf_defaul…` and `tb_astra_07_scale_mid` into snapshot `a07sm`. **No** leftover-A09 compile line.

`xsim_work/xsim.dir/work/` has `a7ng_astra_09_r2_cand_ovf.sdb` and **no** `a7ng_astra_09_integ_path.sdb`. `work.rlx` lists frozen `a7ng_astra_09_integ_path.svh` as a **header include** only; the leftover `.sv` module file is absent. Compile_Options: `"tb_astra_07_scale_mid" -s "a07sm"`.

TB instantiates `a7ng_astra_09_r2_cand_ovf u_dut` plus sibling `a7ng_shared_rank_sgd_q8_sym_f2r2 u_iso`. DUT instantiates frozen SGD `u_sgd` with `freeze_i=1'b0`. DUT does **not** instantiate leftover A09, A07 wrap, F2R3/F2R4/F2R5, persist, or F3. Not a wrap mux around leftover `ans=4`.

Live leftover A09 **content** still has the leftover hole (`r_ovf <= w_ovf` then `S_AR`). Consistent with unpatched `9fdbe0d6…`, not a silent A09 edit. Frozen A09-R2 **content** still has `walk_ovf = w_ovf || (w_trunc != 0)`. Consistent with unpatched `15a919f1…`, not a silent R2 edit for this bag.

### Hunt 1 — N=64>CAND_CAP=16: DUT itself INCOMP ans=0 ntrunc hier_ans=0 — MATCH

PREREG (frozen before xvlog): `CAND_CAP=16`, `MAX_PATH=4`, `OVF_PLANT_N=64`, `EXPECT_STATUS=ST_INCOMP=6`, `EXPECT_ANS=0`, `EXPECT_P0=0`. Law: on walk done, `r_ovf <= w_ovf || (w_trunc != 0)`; if set, DUT `S_HOLD` `ST_INCOMP` with `best_a/p0=0` `pend_acc=0`. Not a wrap around frozen leftover `ans=4`.

**TB plants count=64 and leftover `{17,34}` first; it does not drive `status_o` / `ans_o`.** No `force`, no `$deposit`, no `release`. Checks are `chk()` on DUT ports plus hierarchical `u_dut.ans_o` / `u_dut.best_a` / `u_dut.r_st`.

TB plant (leftover two-proof in the **truncated** window):

```text
mem_wr(POST_HEAP+28'd0,  post_beat(17,34,18,35));
... 15 more beats (100..) covering 64 IDs ...
plant_keys(OVF_PLANT_N);   // 64
```

`dir_pack` = `{48'd0,16'd7,16'd0,count[15:0],4'd0,POST_HEAP}` → `rdata[47:32]=count`, `rdata[48]=0`, `rdata[79:64]=7` (matches `live_epoch_i=7`). Encoding matches frozen `a7ng_sparse_dir_axi` `S_RDIR`.

Walker identity (frozen `a7ng_sparse_dir_axi`, **not** patched): posting-count overflow with dir[48]=0 is **truncation**, not `q_overflow_o`:

```text
else if (nemit >= CAND_CAP[15:0])
  ntrunc <= ntrunc + 16'd1;
...
S_DONE: begin
  q_overflow_o <= ovf_q;    // dir[48] only
  n_trunc_o    <= ntrunc;
```

DUT buffer still `nc < 5'd16` (hardcoded, same as A09-R2 / leftover A09). Instantiated walker cap is **16**, not the sparse-dir default 64: log `ntrunc=48` = `64-16`. If the walker had been at default 64, `ntrunc` would be 0 and leftover `{17,34}` would be scored.

**Frozen A09-R2 identity (RTL, not TB, not wrap mux):**

```text
assign walk_ovf = w_ovf || (w_trunc != 16'd0);
assign n_trunc_o = w_trunc;
assign r_ovf_o = r_ovf;
assign w_ovf_o = w_ovf;
assign load_from_tb_o = 1'b0;
...
S_WALK: begin
  if (cand_v && cand_ready && (nc < 5'd16)) begin
    cbuf[nc[3:0]] <= cand_id; nc <= nc + 1'b1;
  end
  if (w_done) begin
    r_ovf <= walk_ovf; qse_retire <= 1'b1; fi <= '0;
    ...
    else if (walk_ovf) begin
      r_st <= ST_INCOMP;
      best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
      pend_acc <= 1'b0; pend_cmt <= 1'b0;
      np <= '0; n_legal <= '0;
      st <= S_HOLD;
    end
    else st <= (nc==0) ? S_HOLD : S_AR;
```

Refuse is **inside this DUT** at walk-done: `ntrunc` (`w_trunc != 0`) OR dir[48] (`w_ovf`). On this plant `w_ovf=0` (dir[48]=0); refuse is **ntrunc**, and the DUT **does not fetch/score leftover `{17,34}`**. `S_HOLD` also fail-closes `best_a` while `r_st==ST_INCOMP`.

**Frozen leftover A09 hole (still live, unpatched) — contrast, not this DUT:**

```text
S_WALK: ...
  if (w_done) begin
    r_ovf <= w_ovf;          // ntrunc ignored
    ...
    else st <= (nc==0) ? S_HOLD : S_AR;   // would fetch leftover, score ANSWER 4
```

This bag does **not** instantiate that module, so leftover `ans=4` cannot appear as a wrap inner probe. Hierarchical peek of **this** DUT must be 0.

Raw `xsim.log` (authority):

```text
OVF_CAND_CAP st=6 npath=0 ans=0 p0=0 acc=0 ntrunc=48 rov=1 wov=0 hier_st=6 hier_ans=0 hier_best=0 tbl=0 abort=0 ost=0 w0=0
PASS OVF_CAND_CAP
PASS OVF_CAND_NO_STALE_ANS4
PASS OVF_HIER_NO_ANS4
PASS OVF_DUT_NTRUNC
```

Published `ST_INCOMP` / `ans=0` / `p0=0` / `acc=0` / `ntrunc=48` / `r_ovf=1` / `w_ovf=0`. Hierarchical `hier_st=6 hier_ans=0 hier_best=0` (**not 4**). `ntrunc=48` MATCH `N=64` minus `CAND_CAP=16`. **Not TB-forced. Not a wrap mux.** Marker later in the same log. Zero `FAIL` lines in `xsim.log`. xvlog: no ERROR/WARNING. `$finish` at **5035 ns** TB line 228. Marker `ASTRA_07_SCALE_MID_XSIM_PASS`.

`npath=0` on overflow: DUT zeros `n_legal` in the `walk_ovf` arm **before** `S_EJ`. `S_HOLD` does not zero `n_legal`; so leftover proofs were **not** enumerated then hidden. Not a post-score wipe of a leftover ANSWER 4.

`load_from_tb_o`: DUT `assign load_from_tb_o = 1'b0`. All dumps `tbl=0`. TB `load_v=0`. Isolated SGD `freeze_i=1'b0`; DUT SGD `freeze_i=1'b0`. `ctrl=0` → `freeze_q=0`.

### Hunt 2 — Smoke after reset ans=4 p0=17; UNREL; ISO +5 without force — MATCH

Handoff requires smoke **after reset** (not retire-without-reset as in A09-R2). TB `hard_rst()` then `plant2()` two legal 2-hops.

Raw log:

```text
SMOKE_AFTER_RST st=0 npath=2 ans=4 p0=17 acc=1 ntrunc=0 rov=0 wov=0 hier_st=0 hier_ans=4 hier_best=4 tbl=0 abort=0 ost=0 w0=0
PASS SMOKE_AFTER_RST
UNREL st=1 npath=0 ans=0 p0=0 acc=0 ntrunc=0 rov=0 wov=0 hier_st=1 hier_ans=0 hier_best=0 tbl=0 abort=0 ost=0 w0=0
PASS UNREL_NO_STALE
ASTRA_07_SCALE_MID_XSIM_PASS
```

Two-proof smoke after **hard reset**: **ANSWER** `npath=2` `ans=4` `p0=17` `tbl=0` `r_ovf=0` `ntrunc=0`. DUT is **not** stuck-zero. Hierarchical smoke `hier_ans=4` is the legal two-proof, not leftover overflow. UNREL on the same DUT (`payroll tax form`): **UNKNOWN** `ans=0` `p0=0` `npath=0`.

ISO (sibling frozen SGD instance `u_iso`, not a hierarchical `force` of inner `u_dut.u_sgd`): raw `ISO_P3 w0=5 viso=0` / `PASS ISO_P3_X50_DW5`. Matches PREREG `+3, x0=50 → dw0=+5` (not floor-shift +4). TB: `freeze_i(1'b0)`, no `force`/`$deposit`/`release`. Inner DUT SGD is instantiated and reachable (`u_sgd`, `freeze_i=1'b0`); this bag did not poke it. Same ISO pattern as accepted A09-R2.

`load_from_tb=0`: hard assign; dumps `tbl=0`; TB `load_v=0`.

### Hunt 3 — Overclaim 65536 / 800k / Master ASTRA-07 / BOARD — NO

ACK/PREREG/RESULTS/CLOSEOUT/metrics all write **not** 65536, **not** 800k, **not** BOARD, **not** Master ASTRA-07 closed, **not** Master ASTRA-09 closed, **not** LM06, **not** ASTRA-13, `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

The only `65536` in the TB is directory **table stride** `INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16`, which equals frozen `TABLE_BYTES = N_BUCKETS * ENTRY_BYTES = 4096*16`. Geometry, not a 65536-record ladder claim.

RESULTS proposed verdict is `PASS_NARROW (this bag only: N=64>CAND_CAP=16 on frozen A09-R2 itself → INCOMP ans=0 ntrunc=48; smoke after reset still two-proof ans=4)`. CLOSEOUT `PASS_THIS_GATE_ONLY`. Marker is `ASTRA_07_SCALE_MID_XSIM_PASS`, not a Master-07 / BOARD marker.

No BOARD_PASS language as a claim. Board plugged in LOOP_STATE ≠ authority. `PROJECT_PATHS.md`: ASTRA-13 BLOCKED. PROGRAM=NO.

### FAIL_R0 / goldens

`FAIL_R0=none` MATCH absence of `xvlog_fail_r0.log` / `xsim_fail_r0.log`. First xvlog/xelab/xsim produced the marker. Handoff “one corrective if FAIL” is N/A. PASS-run TB still requires:

- overflow: `st===INCOMP && ans===0 && p0===0 && ntrunc!=0 && r_ovf && !w_ovf`
- `ans!==4 && st!==ANSWER && p0!==17`
- hierarchical `u_dut.ans_o===0 && u_dut.best_a===0 && u_dut.r_st===INCOMP`
- smoke after reset: `ans===4 && p0===17 && npath>=2 && !r_ovf && ntrunc===0`

That is the declared identity, not a weakened golden. TB SHA `7cc2dcc0…` is in the **pre-xvlog** freeze of the PASS run. No evidence goldens were edited to manufacture PASS.

Prior A07/A09/A09-R2 `xsim.log` sessions still 20:46:35 / 18:53:05 / 21:05:33 (this bag did not wipe those logs).

### Raw XSim vs RESULTS table

RESULTS case table **MATCH** opened `xsim.log` dump lines (not RESULTS as authority). `sim_time_ns=5035` MATCH `$finish called at time : 5035 ns`. ISO / OVF_CAND / SMOKE_AFTER_RST / UNREL integers MATCH the log. `FAIL=0` MATCH zero `FAIL` lines.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| TB-force DUT `ST_INCOMP` / `ans=0` | **No.** DUT RTL `walk_ovf` at `S_WALK`; TB only `chk()` ports + hier peek. No `force`/`$deposit`/`release`. |
| Wrap around frozen leftover A09 `ans=4` | **No.** Leftover A09 **not instantiated**, **not** in xvlog/xelab/`*.sdb`. Frozen A09-R2 is the DUT. A07-NARROW wrap **not** compiled. |
| Frozen A09 leftover patched | **No.** Hash `9fdbe0d6…` MATCH A09/A07/A09-R2 bags; live RTL still `r_ovf <= w_ovf` then `S_AR`. |
| Frozen A09-R2 patched for this bag | **No.** Hash `15a919f1…` MATCH A09-R2 bag; live RTL still `walk_ovf`. |
| Leftover ANSWER 4 hidden by output mux | **No.** `hier_ans=0 hier_best=0 npath=0`; refuse before fetch. Not A07 wrap `a09ans=4` overlay. |
| Score leftover then `S_HOLD` wipe | **No.** `S_HOLD` does not zero `n_legal`; log `npath=0` ⇒ proofs not enumerated. |
| Stuck-zero DUT (cannot ANSWER 4) | **No.** Smoke after reset `ans=4 p0=17 npath=2`. |
| Smoke after overflow is a different DUT / no reset when required | **No.** Same DUT; `hard_rst()` then `plant2()` as handoff requires. |
| `load_from_tb` retrieval | **No.** Hard 0; dumps `tbl=0`. |
| `freeze_i=1` cheat | **No.** DUT and ISO SGD `freeze_i=1'b0`. |
| ISO via `force` on inner ports | **No.** Sibling `u_iso`; no force. Inner `u_sgd` freeze_i=0, unused for ISO poke. |
| ID one-hot as transfer | **No.** Not claimed. Fact IDs 17/34/… |
| 65536/800k / Master ASTRA-07 closed | **Not claimed.** Open lists explicit. TB `65536` is table stride. |
| Master ASTRA-09 production path closed | **Not claimed.** ACK `does_not_close` includes `Master_ASTRA-09`. Fixture TB BRAM remains. |
| BOARD_PASS / ASTRA-13 / programmable bit | **Not claimed.** No `.bit`. PROGRAM=NO. |
| Master F3 10pp / LM06 language | **Not claimed.** Listed OPEN. |
| Hash after looking at scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes both `.svh`. POST 14/14 MATCH PRE compiled+includes. |
| Edit golden / wipe xsim.log | **Not found.** FAIL_R0 none; prior A07/A09/A09-R2 logs still 20:46:35 / 18:53:05 / 21:05:33. |
| Tautology `(OVF_PLANT_N > CAND_CAP)` as the only check | **Partial / not cheat.** TB ANDs a compile-time `64>16` onto a real DUT-port check (`st===INCOMP && ans===0 && ntrunc && r_ovf`). Extra conjunct, not a substitute. P2. |
| Cap ≥ dataset as selectivity | N/A. This bag is overflow **refuse**, not 800k selectivity. |
| Instantiating frozen A09-R2 as Master A07 close | **Not claimed** as Master close. Residual: Master ladder 65536/800k still OPEN. |

**Not OVERCLAIM** of 65536/800k/BOARD/Master ASTRA-07. Narrow PASS language is bounded to this XSim N=64 overflow unknown on frozen A09-R2.

---

## Logic bugs

None that break this bag’s declared unknown (frozen A09-R2: posting `N=64>CAND_CAP=16` → DUT itself INCOMP `ans=0` without leftover ANSWER 4; hierarchical peek 0; smoke two-proof after **reset** still `ans=4 p0=17`; UNREL clean; ISO +5 without force; leftover A09 unpatched and not compiled as DUT; A09-R2 hash unchanged).

Residuals (not this-bag FAIL):

1. Frozen leftover `a7ng_astra_09_integ_path.sv` / `a7ng_sparse_dir_axi` still treat posting-count overflow as **truncation** (`ntrunc`), not `q_overflow_o`, unless dir[48] is set. Leftover legal proofs still ANSWER 4 **inside frozen leftover A09**. Do not instantiate **bare leftover A09** as a production overflow DUT. A09-R2 is the refuse identity.
2. Two integrator sources still exist (`a7ng_astra_09_integ_path` leftover hole vs `a7ng_astra_09_r2_cand_ovf` ntrunc refuse). Do not silently patch the leftover file to “merge” them. Do not wrap leftover A09 when the overflow DUT is A09-R2.
3. DUT `S_WALK` buffers `nc < 5'd16` hardcoded, not `CAND_CAP`. This bag’s DUT/TB/svh all use 16, so no desync. Would matter if `CAND_CAP` were parameterized away from 16.
4. This bag does **not** re-run MAX_PATH `5>4` INCOMP (already closed on A09-R2 at T1600Z). Handoff did not require it. Out of this unknown.
5. ISO is a **sibling** frozen SGD instance, not a hierarchical inner `u_dut.u_sgd` poke. Inner SGD is instantiated with `freeze_i=0` and was not forced. Same pattern as accepted A09-R2. P2 wording vs “inner SGD reachable”.
6. ACK `gate_claim` says the DUT “publishes”. Evidence is **XSim**, not silicon. Bag RESULTS/CLOSEOUT stay on XSim. P2 wording.
7. No independent `Get-FileHash` this process. Overlapping A09-R2/SGD/pkg/leftover-A09 hashes MATCH prior bags. New TB digest is first-recorded here.
8. Claimed `xsim.log` SHA `41d014e67d6a35b0e8fa6cb66d1ff5ebf352795c3712f65d79c756ec21e58305` not re-digested; log **content** MATCH RESULTS quotes.
9. ACK `observed_session_id=UNKNOWN`. Does not affect the overflow unknown.
10. `xelab.log` prints `CAND_CAP=32'...` truncated; DUT/svh/TB defaults are 16. Log `ntrunc=48` proves instantiated cap is 16, not 64.
11. TB tautology conjunct `(OVF_PLANT_N > CAND_CAP)`. Extra; not a substitute for DUT-port checks. P2.
12. This bag does **not** rerun the full A09 functional regression suite (conflict/AXI-drain/pending/etc.). Out of work-order scope; blocks Master ASTRA-09 promotion.
13. N=64 is a **lower-N overflow smoke**, not Master ASTRA-07 65536/262144/800000 or an index image.

---

## This bag vs Master ASTRA-07

Work-order unknown **answered** on one named XSim path: posting `N=64` vs frozen A09-R2 `CAND_CAP=16` → DUT itself `ST_INCOMP` `ans=0` `p0=0` `ntrunc=48` `r_ovf=1` `w_ovf=0`; hierarchical peek `hier_ans=0 hier_best=0` (not leftover 4); not a wrap around leftover A09; leftover A09 hash `9fdbe0d6…` unchanged and **not compiled as DUT**; A09-R2 hash `15a919f1…` unchanged and **is** the DUT; two-proof smoke after **reset** still `ans=4` `p0=17` `npath=2`; UNREL no stale; ISO +5 without force; `.svh` hashed before xvlog; FAIL_R0 none (first xvlog/xelab/xsim PASS); PROGRAM=NO.

**Master ASTRA-07** (`65536→262144→800000` plus lower-N controls; full index image/provenance, quality and traffic bounds) remains **OPEN**. `N=64` vs cap 16 is a **lower-N overflow smoke** on already-proven A09-R2 refuse, not the scale ladder, not an index image, not traffic/quality bounds at 64k/256k/800k.

Master ASTRA-09 production path remains **OPEN** (fixture TB BRAM around named A09-R2; LM06/UART not in this DUT; full regressions not rerun).  
Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06, BOARD_PASS, ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

T0300Z residual (do not silent-freeze a top; do not ASTRA-13; do not claim 65536/800k) is **honored**. This bag did not open those gates.

---

## Verdict per bag: PASS_NARROW

`ASTRA-07-SCALE-MID-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: frozen A09-R2 itself fail-closes walker `ntrunc` (`N=64>CAND_CAP=16`, dir[48]=0 so `w_ovf=0`) to `ST_INCOMP` `ans=0` `p0=0` without publishing leftover ANSWER 4; hierarchical peek of this DUT is `ans=0` / `best_a=0` / `r_st=6`; not a wrap; leftover A09 `9fdbe0d6…` unpatched and not in xvlog DUT list; A09-R2 `15a919f1…` unpatched and instantiated; smoke two-proof after reset still `ans=4` `p0=17`; UNREL/ISO/`load_from_tb=0` hold; SHA includes `.svh` before xvlog; FAIL_R0 none; PROGRAM=NO.

Not PASS (Master ASTRA-07 65536/800k ladder + index image; Master ASTRA-09 production path; BOARD).  
Not FAIL (required artifacts present; raw log MATCH RTL identity; not TB-forced; leftover A09 unpatched and not compiled as DUT; A09-R2 instantiated; smoke after reset real; no 65536/BOARD/Master-07 claim).  
Not OVERCLAIM (Master ASTRA-07 / 800k / BOARD_PASS / ASTRA-13 not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared N=64 ntrunc→INCOMP XSim unknown on frozen A09-R2.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this bag to Master ASTRA-07 (`65536→262144→800000` / index image), Master ASTRA-09 production path, BOARD_PASS, ASTRA-13, `write_bitstream`, or `PRODUCTION_TOP=<module>`.
2. Keep PROGRAM=NO. Board plugged ≠ authority. Do not JTAG/xsdb/COM12.
3. Do **not** patch frozen leftover `a7ng_astra_09_integ_path.sv` or frozen `a7ng_astra_09_r2_cand_ovf.sv`. Leftover A09 `ans=4` remains a **known hole** in that file. Cap-count refuse lives in A09-R2.
4. Do not instantiate **bare leftover A09** as the overflow DUT. A path that needs cap-count refuse must use A09-R2 (or a later named one), not leftover A09, not the A07-NARROW wrap-around-leftover.
5. Optional: drop TB tautology `(OVF_PLANT_N > CAND_CAP)` from the chk; ACK “DUT publishes” → “XSim DUT publishes”; parameterize `S_WALK` `nc < 5'd16` from `CAND_CAP`. Not required to accept this bag.
6. Next Master residual is **not** this bag again. Parent picks from remaining Master items (ASTRA-07 65536/800k still too large for this XSim envelope; PRODUCTION_TOP still UNKNOWN; ASTRA-13 still BLOCKED). Do not silent-freeze a top.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **XSim scale-mid** on frozen A09-R2: `CAND_CAP=16` / `MAX_PATH=4` / plant `N=64`; DUT itself `ST_INCOMP` `ans=0` `p0=0` `ntrunc=48` `r_ovf=1` `w_ovf=0`; `hier_ans=0` `hier_best=0`; not a wrap around leftover 4; leftover A09 `9fdbe0d6…` unpatched and **not compiled**; A09-R2 `15a919f1…` unpatched and instantiated; smoke after reset `ans=4` `p0=17` `npath=2`; UNREL/ISO +5 without force; `.svh` pre-xvlog; FAIL_R0 none; PROGRAM=NO.

`REJECT_PROMOTION` — Master **ASTRA-07** (65536→262144→800000 + full index image) is **not** closed. This is lower-N overflow/INCOMP on frozen A09-R2, not the scale ladder.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260907T0330Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — overflow ans=0 — BOARD blocked YES.
