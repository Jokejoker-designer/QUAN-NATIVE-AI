# ASTRA auditor REPORT — 20260906T1530Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=ASTRA07_SCALE_NARROW_INDEPENDENT_AUDIT; astra07=IMPLEMENTER_CLAIM_PASS_NARROW_PENDING_AUDITOR; astra13=BLOCKED; production_top=UNKNOWN; program=false; board_pass=false; com12=USER_SAYS_PLUGGED_UNPROGRAMMED
AUTHORITY  = READ_ONLY_AUDIT / REPORT_ONLY; AUDITOR_BOOT + GSTACK_LOOP + MASTER ASTRA-07 (§7 scale ladder 65536→262144→800000 + index image) + work order ASTRA-07-SCALE-NARROW-01 + prior auditor 20260906T1500Z (ASTRA-12-R2-TOP-CANDIDATES PASS_NARROW; ACCEPT_PARTIAL | REJECT_PROMOTION; PRODUCTION_TOP=UNKNOWN; ASTRA-13 BLOCKED)
EVIDENCE   = bag ACK.json / PREREG.md / RESULTS.md / CLOSEOUT.md / metrics.json / SHA256.txt / SHA256_POST.txt / SOURCE_HASHES.txt / run_xsim.ps1 / tb_astra_07_scale_narrow.sv + RAW xsim.log / xvlog.log / xelab.log / wrap RTL / frozen A09 RTL / sparse_dir_axi — NOT RESULTS.md as authority
```

PROGRAM=NO. COM12 UNTOUCHED. Did not invoke Vivado/xvlog/xsim MCP. Did not `write_bitstream`, JTAG, xsdb, COM12, or `hw_server`. Did not edit `rtl/` or implementer bags. Did not spawn agents. Did not freeze `PRODUCTION_TOP`. Did not rerun impl/xsim scripts (including this bag’s `run_xsim.ps1` and prior A09/A12 `run_*.ps1`).

This process has **no shell**, so `Get-FileHash` was **not** executed. Hash check = (1) freeze-list strings vs opened `SHA256.txt` / `SHA256_POST.txt` / `SOURCE_HASHES.txt`, (2) overlapping DUT/SGD/A09/pkg/query/sparse hashes vs `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` and later freeze lists (files not rewritten), (3) live RTL/TB/log **content** vs PREREG/RESULTS quotes. Claimed `xsim.log` SHA256 `91247e60…` is **content-verified** against the opened log, not independently re-digested.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-07-SCALE-NARROW-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_07_scale_narrow.sv` (new named wrap) instantiating frozen `a7ng_astra_09_integ_path` which instantiates frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. Contract `a7ng_astra_07_scale_narrow.svh`. TB `tb_astra_07_scale_narrow.sv` (bag-local).

Gate under review is **work-order ASTRA-07-SCALE-NARROW-01 only** — one unknown: when posting-list / candidate count exceeds the DUT’s registered `CAND_CAP` (or `MAX_PATH`), does the FPGA declare overflow/INCOMP **without a stale ANSWER**, and does a legal two-proof smoke still pass on the same DUT?

**Not** Master ASTRA-07 `65536→262144→800000` / full index image. **Not** Master ASTRA-09 production path. **Not** BOARD_PASS. **Not** ASTRA-13. **Not** LM06. **Not** Master F3 10pp.

Judged against:

1. Work order `.agents/handoff/ASTRA-07-SCALE-NARROW-01.md`: ACK first; PREREG `CAND_CAP` / `MAX_PATH` / overflow plant `> cap` / expected INCOMP / smoke two legal hops; overflow plant → no ANSWER 4 from truncated leftover; UNREL no stale; ISO +5 if SGD in path; smoke two-proof after overflow or reset; instantiate frozen SGD + A09 (or named wrap); **do not patch** `a7ng_astra_09_integ_path.sv`; new TB; SHA including `.svh` before xvlog; do not claim 65536/800k, Master F3, BOARD, LM06; PROGRAM=NO.
2. **Master ASTRA-07** (`ASTRA_NATIVE_AI_MASTER_V1.md` §7): *“Stable-law scale ladder65536→262144→800000 plus lower-N controls; full index image/provenance, quality and traffic bounds.”*
3. Auditor `20260906T1500Z`: ASTRA-12-R2 table **PASS_NARROW**; Final `ACCEPT_PARTIAL | REJECT_PROMOTION`; `PRODUCTION_TOP=UNKNOWN`; ASTRA-13 BLOCKED; parent residual = this scale-narrow XSim path, not silent top freeze, not ASTRA-13.

Hunt (this dispatch):

1. Overflow `N=20>CAND_CAP=16`: DUT/wrap `ST_INCOMP` `ans=0`, or TB force? Quote RTL + raw log.
2. Frozen A09 still answering 4 on truncated leftover — documented honestly, and is wrap the thing that refuses?
3. `MAX_PATH` `5>4` INCOMP in A09 or wrap?
4. Smoke two-proof after overflow still `ans=4` `p0=17`?
5. Overclaim 65536/800k/Master ASTRA-07/BOARD?
6. Hash `.svh` before xvlog? PROGRAM=NO?

Confirm: `a7ng_astra_09_integ_path.sv` was **not** patched.

---

## Evidence re-derived

### ACK first / preserve / PROGRAM=NO

ACK.json present. `SHA256.txt` CONFIG hashes it (`7fb7a615…`). `write_scope` = new bag + named wrap only; instantiate frozen A09 + frozen SGD; do not patch A09/F2R/F3/ASTRA-06/ASTRA-09/ASTRA-11/ASTRA-12. `PROGRAM: false`, `jtag: NO_CALLS`, `bitstream: NOT_BUILT`, `write_bitstream: false`, `xsdb: false`, `com12: UNTOUCHED`, `PRODUCTION_TOP: UNKNOWN`.

`does_not_close` includes Master ASTRA-07 65536/262144/800000, ASTRA-07 index image, Master ASTRA-09, Master F3 10pp/CI, Master ASTRA-06, LM06, BOARD_PASS, ASTRA-13, production_top_identity, write_bitstream.

Prior A09 bag **not rewritten**: `ASTRA-09-INTEGRATED-PATH-01/xsim.log` still session **Sun Sep 6 18:53:05 2026** PID **40928** snapshot `a09ip`. ASTRA-12-R2 `RESULTS.md` still `PRODUCTION_TOP = UNKNOWN` / `WINNER = NOT_FROZEN`. This bag listing has **no** `.bit`, no `timing*.rpt`, no `vivado.log`, no `xsim_fail_r0.log`. `run_xsim.ps1` is xvlog/xelab/xsim only (no JTAG/xsdb/COM12/`write_bitstream` strings).

### Hash freeze (compiled + .svh) — hunt 6 MATCH

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T20:46:31.0528609+07:00`.  
`run_xsim.ps1` writes compiled + `TRANSITIVE_INCLUDES` (both `.svh`) + CONFIG + provenance **then** calls xvlog (script lines 39–67).  
Raw `xsim.log` session **Sun Sep 6 20:46:35–20:46:37 2026**, PID **2904**, snapshot `a07sn`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T20:46:37.3710371+07:00` (matches log exit).  
`SOURCE_HASHES.txt` is a copy of PRE (same first-line stamp).

Compiled + transitive `.svh` vs POST: **15/15 MATCH** (opened manifests; not re-hashed).

| Path | PRE / POST |
|------|------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf98852…5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0…05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49…cd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da2…a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42…a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d…b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef328…fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.sv` | `9fdbe0d6…5c776c` |
| `rtl/native_graph/integrate/a7ng_astra_07_scale_narrow.sv` | `13c1ae1e…066ad577` |
| `.../tb_astra_07_scale_narrow.sv` | `c258c65d…00194029` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d3…e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `38189974…fa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9…49c5cf7` |
| `rtl/native_graph/integrate/a7ng_astra_09_integ_path.svh` | `ad2d66d4…fb4e94302` |
| `rtl/native_graph/integrate/a7ng_astra_07_scale_narrow.svh` | `23cf5d32…1111474c` |

`.svh` **is** in the pre-xvlog freeze (both wrap and frozen A09). PROGRAM=NO.

### Frozen A09 was NOT patched

Live freeze digest of `a7ng_astra_09_integ_path.sv` is `9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c`.

Same digest in:

- `ASTRA-09-INTEGRATED-PATH-01/SHA256.txt` (freeze `2026-09-06T18:53:00`)
- `ASTRA-09-INTEGRATED-PATH-01/SHA256_POST.txt`
- `ASTRA-11-A09-IMPL-ROUTE-01/SHA256.txt`
- `ASTRA-12-PREPROGRAM-PACK-01/SHA256.txt`
- `ASTRA-12-R2-TOP-CANDIDATES-01/SHA256.txt`
- auditor `20260906T1300Z` / `T1330Z` / `T1400Z`

Frozen SGD `b66ef328…fc67aac` likewise matches the A09 / F2R2 freeze. Frozen A09 `.svh` `ad2d66d4…` matches the A09 bag. Implementer claim “leftover A09 still ans=4 on overflow” is **consistent with an unpatched A09**, not a silent A09 edit.

xvlog analyzed wrap + frozen A09 + frozen SGD + bag TB only. xelab compiled `a7ng_astra_09_integ_path_default` and `a7ng_astra_07_scale_narrow_defau…` into snapshot `a07sn`. Wrap does **not** instantiate F2R3/F2R4/F2R5/persist/R2/R3/R4/F3 modules.

### Hunt 1 — Overflow N=20>CAND_CAP=16: wrap ST_INCOMP ans=0, not TB force — MATCH

PREREG (frozen before xvlog): `CAND_CAP=16`, `MAX_PATH=4`, `OVF_PLANT_N=20`, `EXPECT_STATUS=ST_INCOMP=6`, `EXPECT_ANS=0`, `EXPECT_P0=0`.

**TB plants count=20 and leftover `{17,34}` first; it does not drive `status_o` / `ans_o`.** No hierarchical `force`, no assign into DUT status. Checks are `chk()` on wrap ports.

TB plant (leftover two-proof in the **truncated** window):

```text
mem_wr(POST_HEAP+28'd0,  post_beat(17,34,18,35));
...
plant_keys(OVF_PLANT_N);   // 20
```

`dir_pack` puts `count` at `rdata[47:32]`, `ovf-ent` at bit[48] (this plant leaves [48]=0). Encoding matches frozen `a7ng_sparse_dir_axi` `S_RDIR` (`post_count <= m_axi_rdata[47:32]`; `ovf_ent <= m_axi_rdata[48]`).

**Wrap identity (RTL, not TB):** snoops directory beats on the DUT AXI ports and fail-closes published result when `post_count > CAND_CAP` or dir[48]:

```text
if (m_axi_rvalid && m_axi_rready && pend_dir && (m_axi_rid == pend_rid)) begin
  if (m_axi_rdata[47:32] > CAND_CAP[15:0]) cap_ovf <= 1'b1;
  if (m_axi_rdata[48]) cap_ovf <= 1'b1;
end
assign force_incomp = res_a && cap_ovf;
assign status_o     = force_incomp ? A7NG_A07_ST_INCOMP : st_a;
assign ans_o        = force_incomp ? '0 : ans_a;
assign proof0_o     = force_incomp ? '0 : p0_a;
assign n_path_o     = force_incomp ? 5'd0 : np_a;
assign pend_acc_o   = force_incomp ? 1'b0 : acc_a;
```

`A7NG_A07_DIR_SPAN=28'h0004_0000` = 4×4096×16B, so posting-heap `0x0504_0000` and fact `0x0580_0000` are **not** treated as directory beats.

Raw `xsim.log` (authority):

```text
OVF_CAND_CAP st=6 npath=0 ans=0 p0=0 acc=0 cap_ovf=1 a09st=0 a09ans=4 a09p0=17 a09np=2 tbl=0 abort=0 ost=0 w0=0
PASS OVF_CAND_CAP
PASS OVF_CAND_NO_STALE_ANS4
```

Wrap published `ST_INCOMP` / `ans=0` / `p0=0` / `acc=0` / `cap_ovf=1` / `tbl=0`. **Not TB-forced.** Inner A09 still `ANSWER` (see hunt 2). Marker later in the same log. Zero `FAIL` lines in `xsim.log`. xvlog: no ERROR/WARNING. `$finish` at **13155 ns** TB line 259. Marker `ASTRA_07_SCALE_NARROW_XSIM_PASS`.

`load_from_tb_o`: frozen A09 `assign load_from_tb_o = 1'b0`. All dumps `tbl=0`. TB `load_v=0` on the wrap. Isolated SGD `freeze_i=1'b0`; A09 SGD `freeze_i=1'b0`.

### Hunt 2 — Frozen A09 still answers 4 on truncated leftover; wrap refuses — MATCH, documented honestly

Why A09 still answers: frozen sparse walker **truncates** when `nemit >= CAND_CAP` (`ntrunc++`) but **`q_overflow_o` follows dir[48] only**:

```text
if (m_axi_rdata[48])
  ovf_q <= 1'b1;
...
else if (nemit >= CAND_CAP[15:0])
  ntrunc <= ntrunc + 16'd1;
...
q_overflow_o <= ovf_q;    // S_DONE
```

A09 latches `r_ovf <= w_ovf` on walk done. `S_EI` INCOMP only if `r_ovf || r_axi`. Count overflow with dir[48]=0 does **not** set `r_ovf`. Walker still emits the first 16 IDs. Plant puts `{17,34,18,35}` first, so leftover two-proof remains inside the cap. A09 `S_PICK` sets `r_st <= 4'd0` (ANSWER) and `best_a`/`best_p0` from the ranked path.

Raw log inner probe (wrap `a09_*` are A09 ports, unmuxed):

```text
a09st=0 a09ans=4 a09p0=17 a09np=2
```

PREREG law: *“Frozen A09 `q_overflow_o` follows dir[48] only (ntrunc does not set r_ovf); wrap is the cap-count identity so truncated leftover `{17,34}` cannot publish ANSWER 4.”* RESULTS/CLOSEOUT state the same split. **Honest. Wrap is the refuse path. A09 was not patched.**

Work order allowed “instantiate it or a new named scale TB around it” / “named wrap”. Overlay on published ports is the declared DUT, not a hidden TB `if`.

Residual (not this-bag FAIL): wrap muxes **outputs** only. `rew_v_i` still feeds A09. A controller that ignored `pend_acc_o=0` and poked reward could still train A09 internals on leftover ANSWER 4. This TB does not send reward on the overflow case. Published `ans_o`/`status_o`/`pend_acc_o` are fail-closed.

### Hunt 3 — MAX_PATH 5>4 INCOMP is A09 S_GUARD, passed through wrap — MATCH

Plant: 10 postings (`count=10 ≤ 16`), five legal 2-hops `(17,34) (18,35) (19,36) (20,37) (21,38)`. `cap_ovf` must stay 0.

A09 `S_EJ` increments `n_legal` even after `np` saturates at `MAX_PATH`. Then:

```text
S_GUARD: begin
  if (n_legal > MAX_PATH[4:0]) begin
    r_st <= ST_INCOMP;
    best_a <= '0; best_p0 <= '0; best_p1 <= '0; sel_idx <= '0;
    st <= S_HOLD;
```

`n_path_o = n_legal` on A09, so wrap (no `force_incomp`) publishes `npath=5`, `ans=0`, `st=6`.

Raw log:

```text
OVF_MAX_PATH st=6 npath=5 ans=0 p0=0 acc=0 cap_ovf=0 a09st=6 a09ans=0 a09p0=0 a09np=5 tbl=0 abort=0 ost=0 w0=0
PASS OVF_MAX_PATH
PASS OVF_MAX_PATH_A09
PASS OVF_MAX_PATH_NO_STALE_ANS4
```

**INCOMP is in A09, not wrap.** `cap_ovf=0` proves wrap did not overlay this case. Asymmetry vs hunt 1 (`npath` zeroed only on wrap cap-ovf) is documented in PREREG and is not a stale ANSWER.

### Hunt 4 — Smoke two-proof after overflow still ans=4 p0=17 — MATCH

After OVF_CAND the TB `retire_q()` then `plant2()` **without** `hard_rst` (handoff: after overflow **or** reset). Wrap clears `cap_ovf` on busy rising (`if (busy_a && !busy_d) cap_ovf <= 1'b0`).

Raw log:

```text
SMOKE_AFTER_OVF st=0 npath=2 ans=4 p0=17 acc=1 cap_ovf=0 a09st=0 a09ans=4 a09p0=17 a09np=2 tbl=0 abort=0 ost=0 w0=0
PASS SMOKE_AFTER_OVF
UNREL st=1 npath=0 ans=0 p0=0 acc=0 cap_ovf=0 a09st=1 a09ans=0 a09p0=0 a09np=0 tbl=0
PASS UNREL_NO_STALE
...
SMOKE_AFTER_MAXPATH st=0 npath=2 ans=4 p0=17 acc=1 cap_ovf=0 a09st=0 a09ans=4 a09p0=17 a09np=2 tbl=0
PASS SMOKE_AFTER_MAXPATH
ASTRA_07_SCALE_NARROW_XSIM_PASS
```

Two-proof smoke after overflow retire: **ANSWER** `npath=2` `ans=4` `p0=17` `tbl=0` `cap_ovf=0`. UNREL on the same DUT: **UNKNOWN** `ans=0` `p0=0` `npath=0`. Smoke after MAX_PATH retire also two-proof `ans=4` `p0=17`.

ISO (frozen SGD instance, not wrap): raw `ISO_P3 w0=5 viso=0` / `PASS ISO_P3_X50_DW5`. Matches PREREG `+3, x0=50 → dw0=+5` (not floor-shift +4).

### Hunt 5 — Overclaim 65536 / 800k / Master ASTRA-07 / BOARD — NO

ACK/PREREG/RESULTS/CLOSEOUT/metrics all write **not** 65536, **not** 800k, **not** BOARD, **not** Master ASTRA-07 closed, **not** LM06, **not** ASTRA-13, `PRODUCTION_TOP=UNKNOWN`, `BIT=NOT_BUILT`, `PROGRAM=NO`.

The only `65536` in the TB is directory **table stride** `INDEX_BASE + tbl*65536 + (key & 12'hFFF)*16`, which equals frozen `TABLE_BYTES = N_BUCKETS * ENTRY_BYTES = 4096*16`. That is geometry, not a 65536-record ladder claim.

RESULTS proposed verdict is `PASS_NARROW (this bag only: …)`. CLOSEOUT `PASS_THIS_GATE_ONLY`. Marker is `ASTRA_07_SCALE_NARROW_XSIM_PASS`, not a Master-07 / BOARD marker.

No BOARD_PASS language as a claim. Board plugged in LOOP_STATE ≠ authority.

### Raw XSim vs RESULTS table

RESULTS case table **MATCH** opened `xsim.log` dump lines (not RESULTS as authority). `FAIL_R0=none` matches absence of `xsim_fail_r0.log`. First xvlog/xelab/xsim produced the marker.

ISO / OVF_CAND / SMOKE_AFTER_OVF / UNREL / OVF_MAX_PATH / SMOKE_AFTER_MAXPATH integers MATCH the log. `sim_time_ns=13155` MATCH `$finish called at time : 13155 ns`.

---

## Overclaim / cheat / tautology

| Hunt | Result |
|------|--------|
| TB-force wrap `ST_INCOMP` / `ans=0` | **No.** Wrap RTL mux on `cap_ovf` from dir `post_count`; TB only `chk()` wrap ports. |
| A09 patched to refuse leftover | **No.** Hash `9fdbe0d6…` MATCH A09 bag; raw `a09ans=4` on cap plant. |
| Leftover ANSWER 4 hidden | **No.** Dump + PREREG + RESULTS expose `a09st=0 a09ans=4`. Wrap is the refuse path. Honest. |
| MAX_PATH INCOMP claimed as wrap cap_ovf | **No.** Log `cap_ovf=0 a09st=6 a09np=5`. A09 `S_GUARD`. |
| Smoke after overflow is a different DUT / reset-only | **No.** Same wrap; retire then `plant2()`; `ans=4 p0=17`. |
| `load_from_tb` retrieval | **No.** Hard 0; dumps `tbl=0`. |
| `freeze_i=1` cheat | **No.** A09 and ISO SGD `freeze_i=1'b0`. |
| ID one-hot as transfer | **No.** Not claimed. Fact IDs 17/34/… |
| 65536/800k / Master ASTRA-07 closed | **Not claimed.** Open lists explicit. TB `65536` is table stride. |
| BOARD_PASS / ASTRA-13 / programmable bit | **Not claimed.** No `.bit`. PROGRAM=NO. |
| Master F3 10pp / LM06 language | **Not claimed.** Listed OPEN. |
| Hash after looking at scores / `.svh` omitted | **No.** SHA freeze **before** xvlog includes both `.svh`. POST 15/15 MATCH PRE compiled+includes. |
| Edit golden / wipe xsim.log | **Not found.** No FAIL_R0; A09 prior log still 18:53:05. |
| Tautology `(OVF_PLANT_N > CAND_CAP)` as the only check | **Partial / not cheat.** TB ANDs a compile-time `20>16` onto a real wrap-port check (`st===INCOMP && ans===0 && cap_ovf`). Extra conjunct, not a substitute. P2. |
| Cap ≥ dataset as selectivity | N/A. This bag is overflow **refuse**, not 800k selectivity. |
| Overlay wrap as Master A09/07 production path | **Not claimed** as Master close. Residual: bare A09 still answers leftover 4. |

**Not OVERCLAIM** of 65536/800k/BOARD/Master ASTRA-07. Narrow PASS language is bounded to this XSim wrap unknown.

---

## Logic bugs

None that break this bag’s declared unknown (published wrap ports: cap overflow → INCOMP `ans=0` without stale ANSWER 4; MAX_PATH INCOMP from A09; smoke two-proof still works; UNREL clean; ISO +5; A09 unpatched).

Residuals (not this-bag FAIL):

1. Frozen A09 / `a7ng_sparse_dir_axi` still treat posting-count overflow as **truncation** (`ntrunc`), not `q_overflow_o`, unless dir[48] is set. Leftover legal proofs still ANSWER 4 **inside A09**. Wrap is required for the refuse identity. Do not instantiate bare A09 as a production overflow DUT.
2. Wrap fail-close is an **output mux**. It does not inhibit A09 internal `pend_acc` / reward FSM. Safe if the controller honors wrap `pend_acc_o`. Not exercised as a negative test here.
3. A09 `S_WALK` buffers `nc < 5'd16` hardcoded, not `CAND_CAP`. This bag’s wrap/A09/TB all use 16, so no desync. Would matter if CAND_CAP were parameterized away from 16.
4. PREREG row text “plant2 after MAX_PATH **reset**” vs TB: `hard_rst` is before the MAX_PATH plant; smoke after MAX_PATH is retire + `plant2()` without reset. Handoff allows overflow **or** reset. P2 wording.
5. ACK `gate_claim` says “the FPGA declares”. Evidence is **XSim**, not silicon. Bag RESULTS/CLOSEOUT stay on XSim. P2 wording.
6. No independent `Get-FileHash` this process. Overlapping A09/SGD/pkg hashes MATCH prior bags. New wrap/TB/svh digests are first-recorded.
7. Claimed `xsim.log` SHA `91247e60d99380d69449fcb2ed6d188d8be3e9368d3d09293e1870dd6100ba77` not re-digested; log **content** MATCH RESULTS quotes.
8. ACK `observed_session_id=UNKNOWN`. Does not affect the overflow unknown.
9. `xelab.log` prints `CAND_CAP=32'...` truncated; wrap/A09/svh/TB defaults are 16. Not a 32-cap plant.

---

## This bag vs Master ASTRA-07

Work-order unknown **answered** on one named XSim wrap: `CAND_CAP=16` overflow plant `N=20` → wrap `ST_INCOMP` `ans=0` `p0=0` `cap_ovf=1` while frozen A09 leftover still `ans=4`; `MAX_PATH` `n_legal=5>4` → A09 `S_GUARD` INCOMP passed through; two-proof smoke after overflow retire still `ans=4` `p0=17` `npath=2`; UNREL no stale; ISO +5; `.svh` hashed before xvlog; PROGRAM=NO; A09 **not** patched.

**Master ASTRA-07** (`65536→262144→800000` plus lower-N controls; full index image/provenance, quality and traffic bounds) remains **OPEN**. `N=20` vs cap 16 is a **lower-N overflow smoke**, not the scale ladder, not an index image, not traffic/quality bounds at 64k/256k/800k.

Master ASTRA-09 production path remains **OPEN** (fixture wrap around leftover A09 overflow hole; LM06/UART not in this DUT).  
Master F3 10pp/CI, Master ASTRA-06 DDR/NVM, LM06, BOARD_PASS, ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

T1500Z residual (do not silent-freeze a top; do not ASTRA-13) is **honored**. This bag did not open those gates.

---

## Verdict per bag: PASS_NARROW

`ASTRA-07-SCALE-NARROW-01`: **PASS_NARROW**

Work-order unknown answered **narrowly**: named wrap fail-closes `post_count > CAND_CAP` to `ST_INCOMP` `ans=0` without publishing leftover ANSWER 4; frozen A09 leftover `ans=4` is exposed on `a09_*` and documented; MAX_PATH INCOMP is A09 `S_GUARD`; smoke two-proof after overflow still `ans=4` `p0=17`; UNREL/ISO/`load_from_tb=0` hold; SHA includes `.svh` before xvlog; PROGRAM=NO; A09 hash unchanged vs ASTRA-09 freeze.

Not PASS (Master ASTRA-07 65536/800k ladder + index image; Master ASTRA-09 production path; BOARD).  
Not FAIL (required artifacts present; raw log MATCH RTL identity; not TB-forced; A09 unpatched; smoke after overflow real; no 65536/BOARD claim).  
Not OVERCLAIM (Master ASTRA-07 / 800k / BOARD_PASS / ASTRA-13 not claimed).

---

## Required fixes (for parent to dispatch)

**P1: none** for this bag’s declared scale-narrow XSim unknown.

**P2 / residuals (do not reopen this bag as FAIL):**

1. Do **not** promote this wrap to Master ASTRA-07 (`65536→262144→800000` / index image), Master ASTRA-09 production path, BOARD_PASS, ASTRA-13, `write_bitstream`, or `PRODUCTION_TOP=<module>`.
2. Keep PROGRAM=NO. Board plugged ≠ authority. Do not JTAG/xsdb/COM12.
3. Do **not** patch frozen `a7ng_astra_09_integ_path.sv` “to make overflow native” inside this evidence bag. Leftover A09 `ans=4` is a **known frozen hole**; wrap is the refuse identity. A later **new named** A09 revision may close ntrunc→INCOMP if parent dispatches it; that would be a new bag, not a silent edit.
4. Do not instantiate **bare** A09 as the overflow DUT. Production path that needs cap-count refuse must keep this wrap (or a later named revision that fixes A09 overflow without wiping this bag).
5. Optional: wrap should NAND `rew_v` into A09 while `cap_ovf && result_v` if parent wants internals to match published INCOMP. Not required to accept this bag.
6. Optional wording: drop TB tautology `(OVF_PLANT_N > CAND_CAP)` from the chk; PREREG “after MAX_PATH reset” → “after MAX_PATH retire”; ACK “FPGA declares” → “XSim DUT declares”.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION

`ACCEPT_PARTIAL` — this bag’s isolated **XSim scale-narrow wrap**: `CAND_CAP=16` / `MAX_PATH=4` / plant `N=20`; wrap `ST_INCOMP` `ans=0` `p0=0` `cap_ovf=1` on leftover that frozen A09 still answers `4`; A09 `S_GUARD` INCOMP for `n_legal=5>4`; smoke after overflow `ans=4` `p0=17` `npath=2`; UNREL/ISO; `.svh` pre-xvlog; PROGRAM=NO; A09 `9fdbe0d6…` unpatched.

`REJECT_PROMOTION` — Master **ASTRA-07** (65536→262144→800000 + full index image) is **not** closed. This is lower-N overflow/INCOMP on a named wrap around leftover A09, not the scale ladder.

Master ASTRA-09: **OPEN**.  
Master ASTRA-11 FULLCHIP-COFIT: **OPEN**.  
Master F3 10pp/CI: **OPEN**.  
Master ASTRA-06 (schemaV2 DDR / NVM): **OPEN**.  
LM06 / BOARD_PASS / ASTRA-13: **OPEN**.  
PRODUCTION_TOP: **UNKNOWN**.

PROGRAM=NO. COM12 UNTOUCHED. BOARD still blocked: **YES**.

D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\AUDITOR\20260906T1530Z\REPORT.md — Final ACCEPT_PARTIAL | REJECT_PROMOTION — bag PASS_NARROW vs work-order ASTRA-07-SCALE-NARROW-01; Master ASTRA-07 65536/800k OPEN; A09 leftover ans=4 unpatched, wrap refuses; BOARD blocked YES.
