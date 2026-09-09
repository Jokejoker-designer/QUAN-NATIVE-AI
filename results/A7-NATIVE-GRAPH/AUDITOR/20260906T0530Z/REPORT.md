# ASTRA auditor REPORT — 20260906T0530Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F2R2_HS_LAW_INDEPENDENT_AUDIT; f2r_r2_hs_law=IMPLEMENTER_CLAIM_PASS_THIS_GATE_PENDING_AUDITOR
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER + DESIGN_CANDIDATE §5.2 + F2R_ACCEPTANCE_20260906
EVIDENCE   = raw xsim.log / xsim_fail_r0.log / RTL / TB / SHA manifests (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1` or `run_f2r2.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware.

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW/`

DUT `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` + SGD `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`.

Gate under review is **only** F2R_ACCEPTANCE items **1, 2, 3, 6** (selected-path pending, reward handshake latch, Master symmetric integer law, pending gen/txn lifetime as tested). Items **4 and 5**, F3 transfer, LM06, SoC/timing, and BOARD_PASS are out of this bag’s close.

F2R-01 floor-shift bag is a separate experiment and was not edited here. Fail r0 in this bag must remain first-class evidence; a later PASS must not erase it.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T12:15:17.7334437+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T12:15:25.7811993+07:00` (matches raw pass-log exit `Sun Sep 6 12:15:25 2026`).

Pass-run `SHA256.txt` COMPILED + TRANSITIVE_INCLUDES vs `SHA256_POST.txt`: **12/12 MATCH**.

| Path | SHA256.txt / POST |
|------|-------------------|
| `rtl/native_graph/pkg/a7ng_pkg.sv` | `7cf9885217562c8e26b3c8818b10b4488fd637621b62f6a3652fe7ff5aee57a6` |
| `rtl/native_graph/query/a7ng_query_struct_extract.sv` | `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | `cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27` |
| `rtl/native_graph/query/a7ng_route_valid_gate.sv` | `49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385` |
| `rtl/native_graph/memory/a7ng_sparse_dir_axi.sv` | `09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24` |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse.sv` | `5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa` |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | `b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac` |
| `rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv` | `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` |
| `.../tb_astra_f2r2_hs_law.sv` | `3168ae78f09b67f471c5ffefb27d1f1e087e3ccf208f44c792ffc44773c39d37` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |

This revision freeze **includes .svh transitive includes** (the F2R-01 acceptance residual).

`SHA256_fail_r0.txt` (freeze `2026-09-06T12:13:20.2997534+07:00`) vs pass `SHA256.txt`: **11/12 MATCH**. Sole delta is SGD:

```text
r0  a7abcbf74c4b0f6b846a46a60d479a39f1a54fa2cf83b00ae7c4fd793ab89a08  a7ng_shared_rank_sgd_q8_sym_f2r2.sv
r1  b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac  a7ng_shared_rank_sgd_q8_sym_f2r2.sv
```

TB, DUT integrator, `oracle.json`, `oracle_gen.py`, `PREREG.md`, `run_f2r2.ps1` hashes are **identical** r0↔r1. Goldens were not edited to manufacture PASS.

Live content check (opened the files named above; this process has **no shell**, so `Get-FileHash` was **not** executed; xvlog/xsim **not** invoked):

- Live SGD contains `rew_se` / `v_se` / `w_se` / `dw_se` sign-extends (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`) — pass revision, not r0 zero-extend.
- Live DUT `S_PICK` copies `phis[c_best_idx][0:31]` (`a7ng_astra_f2r2_hs_law.sv:367`).
- Live TB `$finish` at line 383 — both raw logs cite that line.
- `.svh` files exist at the freeze paths (CRC16 header; QSE lexicons).

Bag-claimed log hashes (from `EVIDENCE_HASHES.txt` / `metrics.json`; **not** re-hashed here):

```text
xsim.log           337ca164ce48171c9b54c1f0d3d047c6ab871f445a84ef0791a73353d4bcf3db
xsim_fail_r0.log   bed425f60c614423d4b98d99251a8bdfe45629367f3d30e57d1b56a23bab19f3
```

`FAIL_R0.md` records the same fail-log SHA and `FIRST_DIVERGENCE = ISO_M3_X64_DW6`.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 12:15:23–12:15:25 2026**, PID 32496, snapshot `f2r2`, `$finish` at **67695 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_X64_DW6
SMOKE npath=2 p0=17 p1=34 ans=4 sel=0 phi0=50 txn=1 gen=1 tbl=0
PASS SMOKE_TWO_PROOFS
HS nupd=1 cmt=1 w0=-5 w1=-6
PASS HS_LATCH_NUPD
PASS HS_ALL32_M3_P50
PASS MUT_PHI_FROZEN
PASS MUT_PRECOMMIT_USES_SNAPSHOT
SHARE npath=2 p0=17 p1=36 ans=7 sel=1 phi0=2
PASS SHARE_P0
PASS SHARE_REWARD_SLOT1_PHI
SLOT0 npath=4 sel=0 p0=20 phi0=50 ans=4
PASS SLOT0_WIN
PASS SLOT0_DW32
SLOT1 npath=4 sel=1 p0=22 phi0=50 ans=4
PASS SLOT1_WIN
PASS SLOT1_DW32
SLOT2 npath=4 sel=2 p0=24 phi0=50 ans=4
PASS SLOT2_WIN
PASS SLOT2_DW32
SLOT3 npath=4 sel=3 p0=26 phi0=50 ans=4
PASS SLOT3_WIN
PASS SLOT3_DW32
PASS ZERO_COMMIT
PASS ZERO_DW0
PASS FREEZE_NO_UPD
PASS POS_ALL32_P50
PASS DUP
PASS DUP_NO_SECOND_DW
PASS WRONG_TXN
PASS STALE_GEN
PASS OOR_M4
PASS GUARDS_NO_EXTRA_DW
PASS RETIRE_PENDING_NO_UPD
PASS RETIRE_DRAIN_COMMIT
PASS RETIRE_DRAIN_FULL_W
PASS PRE_UNREL
UNREL st=1 npath=0 ans=0 p0=0
PASS UNREL_NO_STALE
ASTRA_F2R2_HS_LAW_XSIM_PASS
```

Marker **present**. `tbl=0` (not TB-load-as-query). `gen=1` with `txn=1` on first pending.

`xvlog.log` / `xelab.log` compiled `a7ng_shared_rank_sgd_q8_sym_f2r2` + `a7ng_astra_f2r2_hs_law` + `tb_astra_f2r2_hs_law`; snapshot `f2r2`. Floor-shift `*_v1_f2r` was **not** compiled into this run.

### Fail r0 preserved (must not be erased by later PASS)

`xsim_fail_r0.log`: session **Sun Sep 6 12:13:26–12:13:29 2026**, PID **42928**, same TB line 383, **same sim time 67695 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
FAIL ISO_M3_X64_DW6
...
HS nupd=1 cmt=1 w0=32767 w1=32767
PASS HS_LATCH_NUPD
DIVERGE HS_ALL32_M3_P50 i=0 got=32767 exp=-5
...
DIVERGE SLOT0_DW32 i=0 got=32767 exp=11
...
ASTRA_F2R2_HS_LAW_XSIM_FAIL n=11 first=ISO_M3_X64_DW6
```

**First divergence = `ISO_M3_X64_DW6`.** Positive ISO already matched symmetric `dw0=+5` on r0; negatives sat16 to `+32767` (unsigned add of a negative `dw`). Handshake counters still ticked (`HS_LATCH_NUPD` PASS on r0) — r0 is an integer-law sign-extend bug, not a missing latch.

`xsim_42928.backup.log` is the same fail PID; authority is `xsim_fail_r0.log`. Pass `xsim.log` overwrote the live `xsim.log` path; fail file remains.

TB expected on r0 (`exp=-5`, `exp=11`) is the **same oracle** the pass run satisfies. SLOT `exp=11` is `load_w0(16)` then `-3` on `x0=50` (see independent law below), not a post-hoc golden edit.

### RTL cites (live)

**Item 1 — full scored phi, not proof0 reconstruct**

```355:368:rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv
          for (kf = 0; kf < 32; kf = kf + 1) phis[pi[1:0]][kf] <= phi[kf];
          ...
          sel_idx <= c_best_idx;
          ...
          for (kf = 0; kf < 32; kf = kf + 1) pend_phi[kf] <= phis[c_best_idx][kf];
```

S_SW banks the scored vector; S_PICK copies `phis[c_best_idx]`. Tie-break may use `pp0`/`pp1` IDs (`:187-195`) only as **score-equal** ordering, not as phi.

TB: `SHARE` (same proof0=17, hop2 36, `sel=1`, `phi0=2`) and `SLOT0..3` (`sel=slot`, `phi0=50`). Raw log matches.

**Item 2 — latch on valid; next-cycle bus ignored**

```238:238:rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv
    .go_score_i(sgd_go), .go_upd_i(sgd_upd), .x_i(phi), .reward_i(rew_lat),
```

```382:386:rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv
            else if (sgd_ready) begin
              rew_lat <= rew_i;
              sgd_upd <= 1'b1;
              st <= S_UW;
            end
```

TB `pulse_rew` (`tb_astra_f2r2_hs_law.sv:184-190`): one-cycle `rew_v`, then `rew<=~rew`, `rew_txn/gen<=8'hFF`. Raw `HS nupd=1 cmt=1 w0=-5 w1=-6` + `HS_ALL32_M3_P50` = latched `-3` on snapshot `p50`, not the inverted bus. `MUT_*` mutates descriptors after PICK; `phi0` stays 50; 32-dw still matches snapshot oracle.

SGD samples `reward_i` when leaving IDLE (`sym_f2r2.sv:96-100`) on the cycle after `sgd_upd` is high; `rew_lat` is already held.

**Item 3 — Master symmetric RSH + clamps, not floor `>>>`**

```41:67:rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv
  function automatic logic signed [39:0] rsh40(...);
      a = (v < 0) ? -v : v;
      addend = 40'sd1 <<< (s - 1);
      a = (a + addend) >>> s;
      rsh40 = (v < 0) ? -a : a;
  ...
    if (r > 40'sd768) return 16'sd768;
    if (r < -40'sd768) return -16'sd768;
  ...
    if (e > 32'sd1536) return 16'sd1536;
    if (e < -32'sd1536) return -16'sd1536;
```

`acc` is `signed [39:0]` (`:30`). `SHIFT=6`. Floor-shift F2R (`a7ng_shared_rank_sgd_q8_v1_f2r.sv` uses `acc >>> 7` / `>>> (7+SHIFT)`) is **not** this DUT.

Raw: `ISO_P3 w0=5 viso=0` (floor contrast is +4). `PASS ISO_M3_X64_DW6` after the sign-extend corrective.

**Item 6 — gen+txn, stale, oor=-4, retire vs drain**

```364:365:rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv
          pend_id <= txn + 8'd1; txn <= txn + 8'd1;
          pend_gen <= gen + 8'd1; gen <= gen + 8'd1;
```

```376:378:rtl/native_graph/integrate/a7ng_astra_f2r2_hs_law.sv
            else if (rew_gen_i != pend_gen) nstale <= nstale + 16'd1;
            else if (rew_txn_i != pend_id) nbad <= nbad + 16'd1;
            else if ((rew_i < -4'sd3) || (rew_i > 4'sd3)) noor <= noor + 16'd1;
```

Retire in HOLD drops pending (`:387-388`). Retire in `S_UW` sets `retire_hold` and still commits on `sgd_done` (`:391-397`). Raw: `STALE_GEN`, `OOR_M4`, `RETIRE_PENDING_NO_UPD`, `RETIRE_DRAIN_COMMIT`, `RETIRE_DRAIN_FULL_W`.

`load_from_tb_o = 1'b0` (`:115`). SGD `freeze_i` tied `1'b0` (`:237`); freeze is handshake-level `freeze_q = (ctrl_i != 0)` (`:157`, `:380-381`).

### Independent integer re-derivation (not RESULTS.md)

Law: `RSH(v,s)=sign(v)*floor((|v|+2^(s-1))/2^s)`, `SHIFT=6` so update shift `13`, `target=rew*256`, `v=clamp(RSH(acc,7),±768)`, `err=clamp(target-v,±1536)`, `dw_i=sat16(RSH(err*x_i,13))`.

**+3, x0=50, w=0:** `v=0`, `err=768`, `dw0=RSH(38400,13)=(38400+4096)//8192=5`.  
Floor-shift contrast: `38400>>13=4` (`oracle.json` `contrast_floor_p3_x50_dw0=4`). Matches raw `ISO_P3 w0=5` and `oracle.json` `iso_p3_x50`.

**-3, x0=64, w=0:** `err=-768`, `dw0=RSH(-49152,13)=-((49152+4096)//8192)=-6` (exact half rounds away from 0). Matches `iso_m3_x64` and pass `ISO_M3_X64_DW6`. Floor `>>>` of `-49152` is also `-6` at this point; the **discriminating** vector is +3×50 (`+5` vs `+4`).

**-3, x=[50,64,64,64,64], w=0:** `dw=[-5,-6,-6,-6,-6]`. Matches `oracle.json` `p50_m3` and raw HS `w0=-5 w1=-6`.

**SLOT `load_w0(16)`, -3, x0=50:** `v=RSH(800,7)=(800+64)//128=6`, `err=-774`, `dw0=RSH(-38700,13)=-5`, `w1=11`. Matches r0 `DIVERGE SLOT0_DW32 ... exp=11` — TB expected was already the symmetric law, r0 DUT was wrong.

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, sim time 67695 ns, smoke/HS/share/slot/guard/UNREL strings match. RESULTS is **not** used as evidence. |
| Editing goldens to PASS | **Not found.** r0 vs r1: TB/oracle/DUT-integrator hashes identical; only SGD hash changed. r0 `exp=-5` / `exp=11` still the pass oracles. |
| Floor-shift labeled Master symmetric | **Not found in this bag.** Separate named SGD; F2R-01 provenance hashes listed as not-compiled. Discriminating ISO +3,x0=50 is +5 not +4. |
| F3 / 5 seeds / BOARD_PASS / LM06 | **Not claimed as closed.** PREREG/CLOSEOUT/metrics list them OPEN. SHARE/SLOT plant `load_w0` to pick a winner — plumbing, not held-out transfer. Do not promote. |
| `load_from_tb` as retrieval | `load_from_tb_o=0`, smoke `tbl=0`. Corpus is TB AXI plant (admissible for this plumbing XSim; not DMA/DDR production retrieval). |
| ID one-hot as transfer | Phi is conf/flags, not IDs. Tie-break uses proof IDs only when scores equal. SHARE win is low-conf path under planted `w0=-16`, then reward on **slot1 phi0=2**, not on proof0. |
| Closing semantic item4 or transport item5 | **Not closed.** No wrong-object/context/conflict/fifth-path policy tests. No LATE_R beyond TO_CYC, SLVERR, post-timeout drain. |
| Hash theatre | Pass freeze 12:15:17 is **before** xsim 12:15:23–25. Fail freeze 12:13:20 is before fail xsim 12:13:26–29. `.svh` in manifest. |
| Cheat: PASS erases r0 | **Not found.** `xsim_fail_r0.log` + `FAIL_R0.md` + `SHA256_fail_r0.txt` retained. First divergence remains `ISO_M3_X64_DW6`. |
| Tautology `phi[3]/phi[4]` | During S_SC/S_SW, `phi[3]=phi[4]=64` always (`:178-179`) because S_EJ already required `fr==r_rel` and fetch required `ver==1`. Features are constant on legal enumerated paths. Not a handshake cheat; not a selectivity claim. |

Implementer language `PASS (this gate only)` / `PASS_THIS_GATE_ONLY` is scoped. Not OVERCLAIM if the auditor grade stays **narrow**.

---

## Logic bugs (file:line, confidence /10)

Demonstrated r0 bug (sign-extend of `dw`/`w`) is **fixed** in live SGD (`:76-79`) and must stay archived, not reopened as a live fail.

Remaining (none demonstrated in the pass log):

1. **Gen/txn wrap and post-reset replay — 8/10.** `pend_id`/`pend_gen` are 8-bit counters from 0 (`a7ng_astra_f2r2_hs_law.sv:364-365`, reset `:252-253`). After 256 PICKs, or after `rst_n` then first PICK, `{gen,txn}` returns to `{1,1}`. A delayed host reward with that pair can match a **new** pending (`:376-377` equality). PREREG documents wrap and says TB does not wrap. Dedup is only shown **inside one episode**. Not a pass-log fail.

2. **1-cycle `rew_v` while `!sgd_ready` is dropped with no nack — 6/10.** S_HOLD accepted handshake is `else if (sgd_ready)` (`:382-386`); otherwise no `n_bad`/`rew_lat`. In this FSM, S_HOLD after PICK/DONE has SGD IDLE, and TB waits `result_v` before `pulse_rew`, so not hit here. A 1-cycle valid during a not-ready window is lost.

3. **Stale `pend_phi` / `pend_id` after no-path query — 5/10.** Retire clears `pend_acc` (`:387-388`) but not `pend_phi`. UNREL (`np=0`) does not PICK, so `phi0_o` can still hold the previous snapshot while `ans/p0=0`. TB `UNREL_NO_STALE` checks `st/npath/ans/p0`, not phi. Reward is still rejected (`!pend_acc` → `nbad`). No false commit observed.

4. **Freeze during `S_UW` still commits — 4/10.** SGD `freeze_i` is tied `1'b0` (`:237`). Freeze only blocks the S_HOLD handshake. An in-flight update drains/commits. PREREG specifies drain for retire-during-upd, not freeze-abort.

5. **`dw_se` from `dw40[15:0]` not full `dw40` — 3/10.** `sym_f2r2.sv:79`. Under clamped `\|err\|≤1536` and `\|x\|≤127`, `|dw|≤24`. Not a hole at this law. r0 was **zero-extend** of that 16-bit slice, which **is** fixed.

6. **AXI burst TB vs DUT — 3/10 for this bag.** Fact fetch `arlen=0`, `arburst=INCR`, `arsize=16B` (`:119-121`). TB slave honors `arlen` and always `rresp=OK`. No LATE_R/SLVERR/post-timeout coverage (item 5, not this gate). Smoke retrieved two facts; does not prove production AXI drain.

No remaining **demonstrated** P1 that falsifies items 1–3 on this bag’s tests.

---

## F2R_ACCEPTANCE items 1,2,3,6 vs this bag (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| **1** selected-path full phi | **CLOSED** | S_PICK copies scored `phis[c_best_idx]` 32-wide. SLOT2/SLOT3 win+32-dw PASS. SHARE same `p0=17`, different hop2, `sel=1`, `phi0=2`, 32-dw vs slot1 phi. |
| **2** reward handshake latch | **CLOSED** | `rew_lat` + `pulse_rew` bus invert; `HS_ALL32_M3_P50` matches `-3` snapshot. Pre-commit descriptor mutation does not change phi or dw. `accepted` vs `committed` distinguished (`nupd`/`pend_cmt`). |
| **3** Master integer law | **CLOSED** | Symmetric `rsh40`, `acc` signed40, v ±768, err ±1536, SHIFT=6. Raw `ISO_P3 w0=5` (not floor +4). `-3` 32-vector matches independent oracle. r0 fail preserved; one SGD sign-extend corrective; TB/oracle unchanged. |
| **6** pending identity lifetime | **PARTIAL** | **Closed in-episode:** gen+txn on PICK, stale gen, wrong txn, dup, `rew=-4` oor, retire-before-upd, retire-during-upd drain. **Open across reset/wrap:** 8-bit collision / post-reset `{1,1}` replay untested (PREREG admits wrap). Reset-during-upd is RTL abort (`rst_n` zeros `w[]` and pending) but not TB’d. |

---

## Items 4 and 5 (must remain OPEN unless you found they were actually implemented)

**Item 4 OPEN.** DUT still latches `r_subj`/`r_rel` only (`:267`). `qse_obj` / `qse_ctx` are not used as ranking/object/context guards. Enumeration is 2-hop, `np < MAX_PATH` silent drop (`:337`). No conflict/ambiguity-before-select policy beyond parser `r_amb`/`r_neg` short-circuit. No wrong-object / direct-vs-indirect / opposing polarity / fifth-legal-path tests in this TB.

**Item 5 OPEN.** `TO_CYC=64` still (`:8`). TB has no LATE_R-after-timeout, SLVERR, NOLAST, or abort/drain-after-AR-timeout sequence. Fact fetch is single-beat. Do not call post-timeout AXI recovery closed.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW`

Narrow = selected-pending + reward handshake + Master symmetric law + in-episode gen/txn guards, as shown in raw XSim. Not F3, not items 4–5, not LM06, not timing, not BOARD_PASS, not wrap-lifetime.

r0 remains **FAIL** evidence (`ISO_M3_X64_DW6`); it does not contaminate the pass run because it is a separate log with a distinct SGD hash.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this plumbing bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (wrap/reset replay, silent `!sgd_ready` drop, stale phi after UNREL) are **not** P1 for this gate. Parent already queued item 4 (semantic object/context/conflict/fifth path) and item 5 (transport post-timeout AXI drain) as `f2r_open_after_hs`. Keep them separate named bags. Preserve r0 files. Do not rerun `run_f2r.ps1`. Do not rerun `run_f2r2.ps1` in a way that wipes `xsim.log` / `xsim_fail_r0.log`.

Optional later (not this close): epoch that does not reuse `{gen,txn}` after wrap/reset if host delay can outlive the episode.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of F3 / items 4–5 / LM06 / BOARD / COM12 remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.
