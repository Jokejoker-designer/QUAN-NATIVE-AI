# ASTRA auditor REPORT — 20260906T1600Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA09_R2_CAND_OVF_INDEPENDENT_AUDIT; astra09_r2=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra07=AUDITOR_PASS_NARROW_WRAP_INCOMP_A09_LEFTOVER_ANS4; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-09 (§7 one integrated production path; remove fixture shortcuts; all functional regressions) + work order ASTRA-09-R2-CAND-OVF-01 + prior auditor 20260906T1530Z (ASTRA-07-SCALE-NARROW-01 PASS_NARROW; ACCEPT_PARTIAL | REJECT_PROMOTION; residual 3: new named A09 may close ntrunc→INCOMP; do not patch frozen a7ng_astra_09_integ_path.sv)
EVIDENCE   = bag ACK.json / PREREG.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / run_xsim.ps1 / tb_astra_09_r2_cand_ovf.sv + RAW xsim.log / xvlog.log / xvlog_dut.log / xvlog_fail_r0.log / xsim_fail_r0.log / xelab.log / work.rlx + new DUT RTL / frozen A09 RTL / sparse_dir_axi — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (including this bag’s `run_xsim.ps1` and prior A07/A09 `run_*.ps1`).

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/A07-wrap/pkg hashes vs `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` and `ASTRA-07-SCALE-NARROW-01/SHA256.txt` (those bags not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `8e7482fa…` is **content-verified** against the opened log, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-09-R2-CAND-OVF-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.sv` (new named A09 revision) instantiating frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. Contract `a7ng_astra_09_r2_cand_ovf.svh` (+ frozen `a7ng_astra_09_integ_path.svh` parameters only). TB `tb_astra_09_r2_cand_ovf.sv` (bag-local). Frozen `a7ng_astra_09_integ_path.sv` is **not** instantiated.

Gate under review is **work-order ASTRA-09-R2-CAND-OVF-01 only** — T1530Z residual 3: on a **new named** integrator (not a wrap around frozen A09 leftover `ans=4`, not a silent patch of frozen A09), when walker truncates / `nc==CAND_CAP` with leftover legal 2-hops, does **the DUT itself** publish `ST_INCOMP` `ans=0` `p0=0` (hierarchical peek must not show `ans=4`)?

**Not** Master ASTRA-09 production path (fixture shortcuts removed; all functional regressions). **Not** Master ASTRA-07 `65536→262144→800000` / full index image. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** LM06. **Not** Master F3 10pp.

Judged against:

1. Work order `.agents/handoff/ASTRA-09-R2-CAND-OVF-01.md`: ACK first; new named RTL; frozen A09 hash `9fdbe0d6…` unchanged; plant `N>CAND_CAP` like ASTRA-07: DUT status INCOMP, `ans=0`, `p0=0`; hierarchical peek of this DUT must not show `ans=4`; MAX_PATH `5>4` still INCOMP; smoke two-proof after overflow still ANSWER 4; UNREL no stale; ISO +5; `load_from_tb=0`; SHA including `.svh` before xvlog; do not close Master ASTRA-07 65536/800k, BOARD, LM06, ASTRA-13; do not patch frozen `a7ng_astra_09_integ_path.sv`; PROGRAM=NO.
2. **Master ASTRA-09** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“One integrated production path; remove fixture shortcuts; all functional regressions.”*
3. Auditor `20260906T1530Z`: ASTRA-07-SCALE-NARROW-01 wrap **PASS_NARROW**; wrap CLOSED_NARROW; frozen A09 leftover `ans=4` is a **known hole**; residual 3 = this named A09 revision; Final `ACCEPT_PARTIAL | REJECT_PROMOTION`; `PRODUCTION_TOP=UNKNOWN`; ASTRA-13 BLOCKED.

Hunt (this dispatch):

1. Overflow: DUT itself `ans=0` `p0=0` `st=INCOMP`, `hier_ans=0` — not a wrap around leftover `ans=4`. Quote RTL (`ntrunc` / `w_ovf` / `nc==CAND_CAP`) + raw log.
2. Frozen A09 file not in xvlog DUT list? Hash unchanged `9fdbe0d6…`?
3. Fail r0 preserved; TB goldens not edited to manufacture PASS?
4. MAX_PATH `5>4` INCOMP; smoke after overflow ANSWER 4; UNREL; ISO +5; `load_from_tb=0`.
5. Overclaim Master ASTRA-09 production / ASTRA-07 800k / BOARD?

Confirm: `a7ng_astra_09_integ_path.sv` hash still `9fdbe0d6…` and was **not** compiled as the DUT.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

ACK.json present. `SHA256.txt` CONFIG hashes it (`edcbf392…`). `write_scope` = new bag + distinctly named A09 revision only; do not patch frozen A09; do not edit ASTRA-07-SCALE-NARROW-01 or ASTRA-09-INTEGRATED-PATH-01; instantiate frozen SGD; **not a wrap** around leftover A09 `ans=4`. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master ASTRA-07 65536/262144/800000, ASTRA-07 index image, **Master ASTRA-09**, Master F3 10pp/CI, Master ASTRA-06, LM06, BOARD_PASS, ASTRA-13, production_top_identity, write_bitstream.

Prior bags **not rewritten**:
- `ASTRA-09-INTEGRATED-PATH-01/xsim.log` still session **Sun Sep 6 18:53:05 2026** PID **40928** snapshot `a09ip`.
- `ASTRA-07-SCALE-NARROW-01/xsim.log` still session **Sun Sep 6 20:46:35 2026** PID **2904** snapshot `a07sn`.
- ASTRA-12-R2 `RESULTS.md` still `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN`.

This bag listing has **no** `.bit`, no `timing*.rpt`, no `vivado.log`. `run_xsim.ps1` is xvlog/xelab/xsim only (no JTAG/xsdb/COM12/`write_bitstream` strings). Script **throws** if live frozen A09 hash ≠ `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c` **before** xvlog.

### Hash freeze (compiled + .svh) — MATCH

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T21:05:29.4884508+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (both `.svh`) + CONFIG + provenance **then** calls xvlog (script lines 42–64).  
Raw `xsim.log` session **Sun Sep 6 21:05:33–21:05:35 2026**, PID **22184**, snapshot `a09r2`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T21:05:35.9195080+07:00` (matches log exit).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp and compiled/include/config/provenance lines).

Compiled + transitive `.svh` vs POST: **14/14 MATCH** (opened manifests; not re-hashed). Frozen A09 `.sv` is extra in POST provenance (not in COMPILED list).

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
| `.../tb_astra_09_r2_cand_ovf.sv` | `45a048b5…a6719335` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d3…e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `38189974…fa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9…49c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh` | `ad2d66d4…fb4e94302` |
| `rtl/native_graph/integrate/a7ng_astra_09_r2_cand_ovf.svh` | `feaed571…171afd329` |

`.svh` **is** in the pre-xvlog freeze (new R2 contract and frozen A09 header). PROGRAM=NO.

### Hunt 2 — Frozen A09 file not in xvlog DUT list; hash unchanged — MATCH

Live freeze digest of `a7ng_astra_09_integ_path.sv` in this bag PRE/POST/SOURCE:

`9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c`

Same digest in:

- `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` (freeze `2026-09-06T18:53:00`)
- `ASTRA-07-SCALE-NARROW-01/SHA256.txt` (freeze `2026-09-06T20:46:31`)
- auditor `20260906T1530Z`

Frozen SGD `b66ef328…fc67aac` MATCH A09/A07 freeze. Frozen A07 wrap `13c1ae1e…066ad577` MATCH A07 bag (provenance only; **not** compiled here). Frozen A09 `.svh` `ad2d66d4…` MATCH A09 bag.

**xvlog DUT list does not include `a7ng_astra_09_integ_path.sv`.** Raw `xvlog.log` / `xvlog_dut.log` analyze:

```text
.../a7ng_astra_09_r2_cand_ovf.sv  → module a7ng_astra_09_r2_cand_ovf
.../tb_astra_09_r2_cand_ovf.sv    → module tb_astra_09_r2_cand_ovf
```

plus pkg / QSE / sparse / frozen SGD. **No** `analyzing module a7ng_astra_09_integ_path`. Zero ERROR/WARNING in `xvlog.log`.

`xelab.log` compiles `a7ng_astra_09_r2_cand_ovf_defaul…` and `tb_astra_09_r2_cand_ovf` into snapshot `a09r2`. **No** `a7ng_astra_09_integ_path` compile line.

`xsim_work/xsim.dir/work/` has `a7ng_astra_09_r2_cand_ovf.sdb` and **no** `a7ng_astra_09_integ_path.sdb`. `work.rlx` lists frozen `a7ng_astra_09_integ_path.svh` as a **header include** only; the `.sv` module file is absent.

New DUT instantiates `a7ng_query_axi_sparse` + frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. It does **not** instantiate frozen A09, A07 wrap, F2R3/F2R4/F2R5, persist, or F3. `poke_v_i=1'b0`. Not a wrap mux around leftover `ans=4`.

Live frozen A09 **content** still has the leftover hole (see hunt 1 contrast). Consistent with unpatched `9fdbe0d6…`, not a silent A09 edit.

### Hunt 1 — Overflow: DUT itself INCOMP ans=0 p0=0 hier_ans=0; not a wrap — MATCH

PREREG (frozen before xvlog): `CAND_CAP=16`, `MAX_PATH=4`, `OVF_PLANT_N=20`, `EXPECT_STATUS=ST_INCOMP=6`, `EXPECT_ANS=0`, `EXPECT_P0=0`. Law: on walk done, `r_ovf <= w_ovf || (w_trunc != 0)`; if set, DUT `S_HOLD` `ST_INCOMP` with `best_a/p0=0` `pend_acc=0`. Not a wrap around frozen leftover `ans=4`.

**TB plants count=20 and leftover `{17,34}` first; it does not drive `status_o` / `ans_o`.** No `force`, no `$deposit`, no assign into DUT status. Checks are `chk()` on DUT ports plus hierarchical `u_dut.ans_o` / `u_dut.best_a` / `u_dut.r_st`.

TB plant (leftover two-proof in the **truncated** window):

```text
mem_wr(POST_HEAP+28'd0,  post_beat(17,34,18,35));
...
plant_keys(OVF_PLANT_N);   // 20
```

`dir_pack` = `{48'd0,16'd7,16'd0,count[15:0],4'd0,POST_HEAP}` → `rdata[47:32]=count`, `rdata[48]=0`, `rdata[79:64]=7` (matches `live_epoch_i=7`). Encoding matches frozen `a7ng_sparse_dir_axi` `S_RDIR` (`post_count <= m_axi_rdata[47:32]`; `ovf_ent <= m_axi_rdata[48]`; `if (m_axi_rdata[48]) ovf_q <= 1'b1`).

Walker identity (frozen `a7ng_sparse_dir_axi`, **not** patched): posting-count overflow with dir[48]=0 is **truncation**, not `q_overflow_o`:

```text
else if (nemit >= CAND_CAP[15:0])
  ntrunc <= ntrunc + 16'd1;
...
S_DONE: begin
  q_overflow_o <= ovf_q;    // dir[48] only
  n_trunc_o    <= ntrunc;
```

DUT buffer still `nc < 5'd16` (hardcoded, same as frozen A09; this bag’s `CAND_CAP=16`).

**New named DUT identity (RTL, not TB, not wrap mux):**

```text
assign walk_ovf = w_ovf || (w_trunc != 16'd0);
assign n_trunc_o = w_trunc;
assign r_ovf_o = r_ovf;
assign w_ovf_o = w_ovf;
assign ans_o = best_a;
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

**Frozen A09 leftover hole (still live, unpatched) — contrast, not this DUT:**

```text
S_WALK: ...
  if (w_done) begin
    r_ovf <= w_ovf;          // ntrunc ignored
    ...
    else st <= (nc==0) ? S_HOLD : S_AR;   // fetches leftover, scores ANSWER 4
```

Frozen `S_EI` INCOMP only if `r_ovf || r_axi`. Frozen `S_HOLD` zeros `best_a` on `axi_abort` only, **not** on `r_st==ST_INCOMP`. T1530Z raw wrap probe of that hole: `a09st=0 a09ans=4 a09p0=17`. This bag does **not** instantiate that module, so leftover `ans=4` cannot appear as a wrap inner probe. Hierarchical peek of **this** DUT must be 0.

Raw `xsim.log` (authority):

```text
OVF_CAND_CAP st=6 npath=0 ans=0 p0=0 acc=0 ntrunc=4 rov=1 wov=0 hier_st=6 hier_ans=0 hier_best=0 tbl=0 abort=0 ost=0 w0=0
PASS OVF_CAND_CAP
PASS OVF_CAND_NO_STALE_ANS4
PASS OVF_HIER_NO_ANS4
PASS OVF_DUT_NTRUNC
```

Published `ST_INCOMP` / `ans=0` / `p0=0` / `acc=0` / `ntrunc=4` / `r_ovf=1` / `w_ovf=0`. Hierarchical `hier_st=6 hier_ans=0 hier_best=0` (**not 4**). `ntrunc=4` MATCH `N=20` minus `CAND_CAP=16` (second table IDs dup against the first 16). **Not TB-forced. Not a wrap mux.** Marker later in the same log. Zero `FAIL` lines in `xsim.log`. xvlog: no ERROR/WARNING. `$finish` at **9025 ns** TB line 261. Marker `ASTRA_09_R2_CAND_OVF_XSIM_PASS`.

`npath=0` on overflow: DUT zeros `n_legal` in the `walk_ovf` arm **before** `S_EJ`. `S_HOLD` does not zero `n_legal`; so leftover proofs were **not** enumerated then hidden. Not a post-score wipe of a leftover ANSWER 4.

`load_from_tb_o`: DUT `assign load_from_tb_o = 1'b0`. All dumps `tbl=0`. TB `load_v=0`. Isolated SGD `freeze_i=1'b0`; DUT SGD `freeze_i=1'b0`. `ctrl=0` → `freeze_q=0`.

### Hunt 3 — Fail r0 preserved; TB goldens not edited to manufacture PASS — MATCH

`xvlog_fail_r0.log` and `xsim_fail_r0.log` both preserved, both:

```text
ERROR: [XSIM 43-4316] Can not find file: 0
```

RESULTS/metrics: first divergence = xvlog treating `PROGRAM_FPGA=0` as a file; `corrective_kind=xvlog_args_drop_define_eq_zero`; **one** xvlog-arg corrective; marker on the next xvlog/xelab/xsim. Current `run_xsim.ps1` xvlog line is `& xvlog.bat --sv -i $incq -i $incc -i $inci $files` (no trailing `0`). `if (-not (Test-Path $r0))` copy means r0 was **not** overwritten by the PASS run.

Fail r0 is a **compile-arg** miss, not an assertion/golden fail. Editing overflow goldens cannot fix `Can not find file: 0`. PASS-run TB still requires:

- overflow: `st===INCOMP && ans===0 && p0===0 && ntrunc!=0 && r_ovf && !w_ovf`
- `ans!==4 && st!==ANSWER && p0!==17`
- hierarchical `u_dut.ans_o===0 && u_dut.best_a===0 && u_dut.r_st===INCOMP`
- smoke: `ans===4 && p0===17`

That is the declared identity, not a weakened golden. TB SHA `45a048b5…` is in the **pre-xvlog** freeze of the PASS run. No evidence goldens were edited to manufacture PASS.

Prior A07/A09 `xsim.log` sessions still 20:46:35 / 18:53:05 (this bag did not wipe those logs).

### Hunt 4 — MAX_PATH 5>4 INCOMP; smoke after overflow ANSWER 4; UNREL; ISO +5; load_from_tb=0 — MATCH

MAX_PATH plant: 10 postings (`count=10 ≤ 16`), five legal 2-hops `(17,34)(18,35)(19,36)(20,37)(21,38)`. `ntrunc`/`r_ovf` must stay 0. DUT `S_GUARD` (same as frozen A09):

```text
S_GUARD: begin
  if (n_legal > MAX_PATH[4:0]) begin
    r_st <= ST_INCOMP;
    best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
    st <= S_HOLD;
```

`n_path_o = n_legal`, so published `npath=5`, `ans=0`, `st=6`, `r_ovf=0`.

Raw log:

```text
OVF_MAX_PATH st=6 npath=5 ans=0 p0=0 acc=0 ntrunc=0 rov=0 wov=0 hier_st=6 hier_ans=0 hier_best=0 tbl=0 abort=0 ost=0 w0=0
PASS OVF_MAX_PATH
PASS OVF_MAX_PATH_NO_STALE_ANS4
```

**INCOMP is DUT `S_GUARD`, not ntrunc overlay.** `ntrunc=0 r_ovf=0` proves hunt-1 refuse did not fire. Asymmetry vs hunt 1 (`npath` zeroed only on ntrunc refuse) is documented in PREREG and is not a stale ANSWER.

Smoke two-proof after overflow: TB `retire_q()` then `plant2()` **without** `hard_rst` (handoff: after overflow retire). Same DUT.

Raw log:

```text
SMOKE_AFTER_OVF st=0 npath=2 ans=4 p0=17 acc=1 ntrunc=0 rov=0 wov=0 hier_st=0 hier_ans=4 hier_best=4 tbl=0 abort=0 ost=0 w0=0
PASS SMOKE_AFTER_OVF
UNREL st=1 npath=0 ans=0 p0=0 acc=0 ntrunc=0 rov=0 wov=0 hier_st=1 hier_ans=0 hier_best=0 tbl=0 abort=0 ost=0 w0=0
PASS UNREL_NO_STALE
...
SMOKE_AFTER_MAXPATH st=0 npath=2 ans=4 p0=17 acc=1 ntrunc=0 rov=0 wov=0 hier_st=0 hier_ans=4 hier_best=4 tbl=0 abort=0 ost=0 w0=0
PASS SMOKE_AFTER_MAXPATH
ASTRA_09_R2_CAND_OVF_XSIM_PASS
```

Two-proof smoke after overflow retire: **ANSWER** `npath=2` `ans=4` `p0=17` `tbl=0` `r_ovf=0`. DUT is **not** stuck-zero. Hierarchical smoke `hier_ans=4` is the legal two-proof, not leftover overflow. UNREL on the same DUT (`payroll tax form`): **UNKNOWN** `ans=0` `p0=0` `npath=0`. Smoke after MAX_PATH retire also two-proof `ans=4` `p0=17`.

ISO (frozen SGD instance, not DUT): raw `ISO_P3 w0=5 viso=0` / `PASS ISO_P3_X50_DW5`. Matches PREREG `+3, x0=50 → dw0=+5` (not floor-shift +4).

`load_from_tb=0`: hard assign; dumps `tbl=0`; TB `load_v=0`.

### Hunt 5 — Overclaim Master ASTRA-09 / ASTRA-07 800k / BOARD — NO

ACK/PREREG/RESULTS/CLOSEOUT/metrics all write **not** 65536, **not** 800k, **not** BOARD, **not** Master ASTRA-07 closed, **not** Master ASTRA-09 closed, **not** LM06, **not** ASTRA-13, `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

The only `65536` in the TB is directory **table stride** `INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16`, which equals frozen `TABLE_BYTES = N_BUCKETS * ENTRY_BYTES = 4096*16`. Geometry, not a 65536-record ladder claim.

RESULTS proposed verdict is `PASS_NARROW (this bag only: new named A09 ntrunc→INCOMP ans=0; …)`. CLOSEOUT `PASS_THIS_GATE_ONLY`. Marker is `ASTRA_09_R2_CAND_OVF_XSIM_PASS`, not a Master-09 / BOARD marker.

No BOARD_PASS language as a claim. Board plugged in LOOP_STATE ≠ authority.

### Raw XSim vs RESULTS table

RESULTS case table **MATCH** opened `xsim.log` dump lines (not RESULTS as authority). `FAIL_R0=xvlog_fail_r0.log` MATCH preserved files. `sim_time_ns=9025` MATCH `$finish called at time : 9025 ns`. ISO / OVF_CAND / SMOKE_AFTER_OVF / UNREL / OVF_MAX_PATH / SMOKE_AFTER_MAXPATH integers MATCH the log.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| TB-force DUT `ST_INCOMP` / `ans=0` | **No.** DUT RTL `walk_ovf` at `S_WALK`; TB only `chk()` ports + hier peek. No `force`/`$deposit`. |
| Wrap around frozen A09 leftover `ans=4` | **No.** Frozen A09 **not instantiated**, **not** in xvlog/xelab/`*.sdb`. New named integrator. |
| Frozen A09 patched | **No.** Hash `9fdbe0d6…` MATCH A09/A07 bags; live RTL still `r_ovf <= w_ovf` then `S_AR`. |
| Leftover ANSWER 4 hidden by output mux | **No.** `hier_ans=0 hier_best=0 npath=0`; refuse before fetch. Not A07 wrap `a09ans=4` overlay. |
| Score leftover then `S_HOLD` wipe | **No.** `S_HOLD` does not zero `n_legal`; log `npath=0` ⇒ proofs not enumerated. |
| Stuck-zero DUT (cannot ANSWER 4) | **No.** Smoke after overflow `ans=4 p0=17 npath=2`. |
| MAX_PATH INCOMP claimed as ntrunc | **No.** Log `ntrunc=0 rov=0 npath=5`. DUT `S_GUARD`. |
| Smoke after overflow is a different DUT / reset-only | **No.** Same DUT; retire then `plant2()`; `ans=4 p0=17`. |
| `load_from_tb` retrieval | **No.** Hard 0; dumps `tbl=0`. |
| `freeze_i=1` cheat | **No.** DUT and ISO SGD `freeze_i=1'b0`. |
| ID one-hot as transfer | **No.** Not claimed. Fact IDs 17/34/… |
| 65536/800k / Master ASTRA-07 closed | **Not claimed.** Open lists explicit. TB `65536` is table stride. |
| Master ASTRA-09 production path closed | **Not claimed.** ACK `does_not_close` includes `Master_ASTRA-09`. Fixture TB BRAM remains. |
| BOARD_PASS / ASTRA-13 / programmable bit | **Not claimed.** No `.bit`. PROGRAM=NO. |
| Master F3 10pp / LM06 language | **Not claimed.** Listed OPEN. |
| Hash after looking at scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes both `.svh`. POST 14/14 MATCH PRE compiled+includes. |
| Edit golden / wipe xsim.log | **Not found.** Fail r0 is xvlog `file: 0`; A07/A09 prior logs still 20:46:35 / 18:53:05. |
| Tautology `(OVF_PLANT_N > CAND_CAP)` as the only check | **No.** TB does not AND a compile-time `20>16`. Checks real DUT `st/ans/ntrunc/r_ovf/w_ovf` + hier. |
| Cap ≥ dataset as selectivity | N/A. This bag is overflow **refuse**, not 800k selectivity. |
| Named copy as Master A09 production path | **Not claimed** as Master close. Residual: frozen A09 leftover still `ans=4` if instantiated bare. |

**Not OVERCLAIM** of Master ASTRA-09 / 800k / BOARD. Narrow PASS language is bounded to this XSim named-revision unknown.

---

## Logic bugs

None that break this bag’s declared unknown (named DUT: ntrunc overflow → INCOMP `ans=0` without leftover ANSWER 4; hierarchical peek 0; MAX_PATH INCOMP from `S_GUARD`; smoke two-proof still works; UNREL clean; ISO +5; frozen A09 unpatched and not compiled as DUT).

Residuals (not this-bag FAIL):

1. Frozen `a7ng_astra_09_integ_path.sv` / `a7ng_sparse_dir_axi` still treat posting-count overflow as **truncation** (`ntrunc`), not `q_overflow_o`, unless dir[48] is set. Leftover legal proofs still ANSWER 4 **inside frozen A09**. This named revision is the refuse identity. Do not instantiate **bare frozen A09** as a production overflow DUT.
2. Two integrator sources now exist (`a7ng_astra_09_integ_path` leftover hole vs `a7ng_astra_09_r2_cand_ovf` ntrunc refuse). Do not silently patch the frozen file to “merge” them.
3. DUT `S_WALK` buffers `nc < 5'd16` hardcoded, not `CAND_CAP`. This bag’s DUT/TB/svh all use 16, so no desync. Would matter if `CAND_CAP` were parameterized away from 16.
4. New DUT `S_HOLD` also zeros `best_a` when `r_st==ST_INCOMP` (frozen A09 zeros only on `axi_abort`). Related fail-close, not a second undeclared unknown.
5. ACK `gate_claim` says “the DUT itself publishes”. Evidence is **XSim**, not silicon. Bag RESULTS/CLOSEOUT stay on XSim. P2 wording.
6. `xsim_fail_r0.log` content is the xvlog `file: 0` error (same as `xvlog_fail_r0.log`), not an xsim golden fail. Naming sloppy; files preserved. P2.
7. No independent `Get-FileHash` this process. Overlapping A09/SGD/pkg hashes MATCH prior bags. New DUT/TB/svh digests are first-recorded here.
8. Claimed `xsim.log` SHA `8e7482fab48e5fecf01205eb2e00bcd83fca65fc18f115c3edee3bca977529b1` not re-digested; log **content** MATCH RESULTS quotes.
9. ACK `observed_session_id=UNKNOWN`. Does not affect the overflow unknown.
10. `xelab.log` prints `CAND_CAP=32'...` truncated; DUT/svh/TB defaults are 16. Not a 32-cap plant.
11. This bag does **not** rerun the full A09 functional regression suite (conflict/AXI-drain/pending/etc.). Out of work-order scope; blocks Master ASTRA-09 promotion.

---

## This bag vs Master ASTRA-09

Work-order unknown **answered** on one named XSim A09 revision: `CAND_CAP=16` overflow plant `N=20` → DUT itself `ST_INCOMP` `ans=0` `p0=0` `ntrunc=4` `r_ovf=1` `w_ovf=0`; hierarchical peek `hier_ans=0 hier_best=0` (not leftover 4); not a wrap around frozen A09; frozen A09 hash `9fdbe0d6…` unchanged and **not compiled as DUT**; `MAX_PATH` `n_legal=5>4` → DUT `S_GUARD` INCOMP `r_ovf=0`; two-proof smoke after overflow retire still `ans=4` `p0=17` `npath=2`; UNREL no stale; ISO +5; `.svh` hashed before xvlog; fail r0 preserved (xvlog `file: 0`); PROGRAM=NO.

**Master ASTRA-09** (*one integrated production path; remove fixture shortcuts; all functional regressions*) remains **OPEN**. This is a named XSim overflow-refuse revision with planted BRAM, not a production path, not fixture-free, not the full regression set, not UART/LM06.

**Master ASTRA-07** (`65536→262144→800000` plus lower-N controls; full index image) remains **OPEN**. `N=20` vs cap 16 is a **lower-N overflow smoke**, not the scale ladder.

Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06, BOARD_PASS, ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

T1530Z residual 3 (new named A09; do not patch frozen A09) is **honored**. This bag did not silent-edit frozen A09, did not wrap leftover `ans=4`, did not open ASTRA-13 / BOARD.

---

## Verdict per bag: PASS_NARROW

`ASTRA-09-R2-CAND-OVF-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: named DUT fail-closes walker `ntrunc` (`N=20>CAND_CAP=16`, dir[48]=0 so `w_ovf=0`) to `ST_INCOMP` `ans=0` `p0=0` without publishing leftover ANSWER 4; hierarchical peek of this DUT is `ans=0` / `best_a=0` / `r_st=6`; not a wrap; frozen A09 `9fdbe0d6…` unpatched and not in xvlog DUT list; MAX_PATH INCOMP is DUT `S_GUARD`; smoke two-proof after overflow still `ans=4` `p0=17`; UNREL/ISO/`load_from_tb=0` hold; SHA includes `.svh` before xvlog; fail r0 preserved; PROGRAM=NO.

Not PASS (Master ASTRA-09 production path / all regressions / fixture removal; Master ASTRA-07 65536/800k; BOARD).  
Not FAIL (required artifacts present; raw log MATCH RTL identity; not TB-forced; frozen A09 unpatched and not compiled as DUT; smoke after overflow real; fail r0 preserved; no 65536/BOARD/Master-09 claim).  
Not OVERCLAIM (Master ASTRA-09 / 800k / BOARD_PASS / ASTRA-13 not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared ntrunc→INCOMP XSim unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this named revision to Master ASTRA-09 production path, Master ASTRA-07 (`65536→262144→800000` / index image), BOARD_PASS, ASTRA-13, `write_bitstream`, or `PRODUCTION_TOP=<module>`.
2. Keep PROGRAM=NO. Board plugged ≠ authority. Do not JTAG/xsdb/COM12.
3. Do **not** patch frozen `a7ng_astra_09_integ_path.sv`. Leftover frozen A09 `ans=4` remains a **known hole** in that file. This bag closed the hole only in `a7ng_astra_09_r2_cand_ovf`.
4. Do not instantiate **bare frozen A09** as the overflow DUT. A path that needs cap-count refuse must use this named revision (or a later named one), not the frozen leftover module.
5. Optional: parameterize `S_WALK` `nc < 5'd16` from `CAND_CAP`. Not required to accept this bag.
6. Optional wording: ACK “DUT publishes” → “XSim DUT publishes”; rename `xsim_fail_r0.log` provenance if a later bag repeats the xvlog-arg miss.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **XSim named A09 ntrunc refuse**: `CAND_CAP=16` / `MAX_PATH=4` / plant `N=20`; DUT itself `ST_INCOMP` `ans=0` `p0=0` `ntrunc=4` `r_ovf=1` `w_ovf=0`; `hier_ans=0` `hier_best=0`; not a wrap around leftover 4; DUT `S_GUARD` INCOMP for `n_legal=5>4`; smoke after overflow `ans=4` `p0=17` `npath=2`; UNREL/ISO; `.svh` pre-xvlog; fail r0 preserved; PROGRAM=NO; frozen A09 `9fdbe0d6…` unpatched and not compiled as DUT.

`REJECT_PROMOTION` — Master **ASTRA-09** (one integrated production path; remove fixture shortcuts; all functional regressions) is **not** closed. This is ntrunc→INCOMP on a named XSim revision, not production-path promotion.

Master ASTRA-07 65536/800k: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1600Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — DUT overflow ans=0 — frozen A09 hash unchanged yes.
