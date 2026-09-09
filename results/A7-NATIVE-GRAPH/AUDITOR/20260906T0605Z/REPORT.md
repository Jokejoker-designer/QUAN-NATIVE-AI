# ASTRA auditor REPORT — 20260906T0605Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = read-only; unblocked_item=F2R3_SEMANTIC_GUARD_INDEPENDENT_AUDIT; f2r_r3_sem_guard=IMPLEMENTER_CLAIM_PASS_PENDING_AUDITOR
AUTHORITY  = AUDITOR_BOOT + GSTACK_LOOP + MASTER + DESIGN_CANDIDATE §5.2 + F2R_ACCEPTANCE_20260906 item 4 + work order ASTRA-F2R-R3-SEMANTIC-GUARD-01
EVIDENCE   = raw xsim.log / xvlog.log / xelab.log / RTL / TB / SHA manifests (NOT RESULTS.md as authority)
```

PROGRAM=NO. COM12 UNTOUCHED. Did not run `run_f2r.ps1`, `run_f2r2.ps1`, or `run_f2r3.ps1`. Did not invoke xvlog/xelab/xsim. Did not program, JTAG, xsdb, or Vivado hardware. Did not edit `rtl/` or implementer bags.

This process has **no shell**, so `Get-FileHash` was **not** executed. Freeze lists were compared to opened files and to the F2R2 freeze (overlapping hashes).

---

## Scope

Read-only except this file. Primary object is implementer bag

`results/A7-NATIVE-GRAPH/ASTRA-F2R-R3-SEMANTIC-GUARD-01/`

DUT `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` instantiating frozen `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv`. TB `tb_astra_f2r3_sem_guard.sv` (bag-local).

Gate under review is **only** F2R_ACCEPTANCE item **4** (latch/use query object and context; proof legality independent of score; declared conflict/ambiguity/incomplete before selection; wrong-object, direct-vs-indirect, opposing polarity/context, fifth legal path) plus F2R2 handshake/law **regressions** in this DUT.

Out of this bag’s close: item **5** (post-timeout AXI), F3 transfer, LM06, SoC/timing, BOARD_PASS, gen/txn wrap lifetime.

Frozen F2R2 integrator `a7ng_astra_f2r2_hs_law.sv` and F2R-01 bags are **not** this DUT. They must remain unpatched; this audit checks they were not edited.

---

## Evidence re-derived (hashes, raw log quotes, RTL cites)

### Hash freeze (compiled + .svh)

`SHA256.txt` stamp **BEFORE xvlog** `2026-09-06T12:57:52.0959240+07:00`.  
`SHA256_POST.txt` stamp **AFTER xsim** `2026-09-06T12:57:58.4804014+07:00` (matches raw log exit `Sun Sep 6 12:57:58 2026`).

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
| `rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv` | `9a7a5941b5ee2522c0491808d7cb23b5f7d58520ace19ac46bd3b9edfd324489` |
| `.../tb_astra_f2r3_sem_guard.sv` | `2deba81ce9bb99da7389441643ae9ac73ce5fe18f5c23b769e4607628267958f` |
| `rtl/native_graph/control/a7ng_gate14_crc.svh` | `9a06e6d390dff66db34daa395a29ea563bed2365e9f2db5bdedcfcb9e9added7` |
| `rtl/native_graph/query/qse_role_lexicon.svh` | `381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c` |
| `rtl/native_graph/query/qse_lexicon.svh` | `420c04b9dfb649a0569af25024a08c44f59d7598f2f2a3f1ae13c68b349c5cf7` |

This revision freeze **includes .svh transitive includes before xvlog** (F2R-01 acceptance residual). `run_f2r3.ps1` writes `SHA256.txt` then calls xvlog.

Overlapping hashes vs F2R2 freeze `ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW/SHA256.txt`: pkg, both QSE extracts, route gate, sparse dir/AXI, **SGD**, and all three `.svh` are **byte-identical**. F2R2 DUT provenance in this bag `5e2f23c311bfa1cbdbb9b10b8ceb26726df78dcff62c8dbd9071e219d4cbb638` matches the compiled F2R2 integrator hash (listed here as **not compiled**). Floor-shift `a7ng_shared_rank_sgd_q8_v1_f2r.sv` `d34f418b…` is provenance-only.

Live content check (opened named files; xvlog/xsim **not** invoked):

- Live R3 DUT latches `{r_subj,r_obj,r_rel,r_ctx}` and uses them in `S_ED`/`S_EJ` (`a7ng_astra_f2r3_sem_guard.sv:276-280`, `:342-347`, `:376-382`). `S_GUARD` is before `S_SC`/`S_PICK` (`:408-424`).
- Live F2R2 integrator still latches **only** `r_subj`/`r_rel` (`a7ng_astra_f2r2_hs_law.sv:267`). Not patched.
- Live SGD still has `rew_se`/`v_se`/`w_se`/`dw_se` sign-extends (`a7ng_shared_rank_sgd_q8_sym_f2r2.sv:76-79`) — F2R2 pass revision, not r0 zero-extend.
- Live TB `$finish` at line 483 — raw log cites that line.
- `.svh` files exist at freeze paths.

Bag-claimed log hash (from `metrics.json`; **not** re-hashed here):

```text
xsim.log  806026f2772fd4a8d157473c48b60747966c61acb493089250618b921ebb56bc
```

F2R2 bag `xsim.log` was **not** overwritten: still session `Sun Sep 6 12:15:23 2026` PID 32496 (claimed SHA `337ca164…`). `run_f2r2.ps1` was not rerun.

### Raw pass `xsim.log` (not RESULTS.md)

xsim v2026.1, session **Sun Sep 6 12:57:56–12:57:58 2026**, PID **34860**, snapshot `f2r3`, `$finish` at **78905 ns**.

```text
ISO_P3 w0=5 viso=0
PASS ISO_P3_X50_DW5
PASS ISO_M3_X64_DW6
SMOKE npath=2 p0=17 p1=34 ans=4 sel=0 phi0=50 txn=1 gen=1 tbl=0 obj=0 ctx=2 st=0
PASS SMOKE_TWO_PROOFS
HS nupd=1 cmt=1 w0=-5 w1=-6
PASS HS_LATCH_NUPD
PASS HS_ALL32_M3_P50
PASS MUT_PHI_FROZEN
PASS MUT_PRECOMMIT_USES_SNAPSHOT
CONFLICT_DEST npath=2 ans=0 p0=0 st=5 acc=0
PASS CONFLICT_DEST
PASS CONFLICT_NO_UPD
SLOT0 npath=4 sel=0 p0=20 phi0=50 ans=4 st=0
...
SLOT3 npath=4 sel=3 p0=26 phi0=50 ans=4 st=0
PASS ZERO_COMMIT
PASS FREEZE_NO_UPD
PASS POS_ALL32_P50
PASS DUP / WRONG_TXN / STALE_GEN / OOR_M4 / RETIRE_*
WRONG_OBJ st=1 npath=0 ans=0 p0=0 obj=11 ctx=2 acc=0
PASS WRONG_OBJ
DIR_NO_STEAL st=1 npath=0 ans=0 obj=4 ctx=0
PASS DIR_NO_STEAL
IND_USE_2HOP st=0 npath=2 ans=4 p0=17 obj=4 ctx=2
PASS IND_USE_2HOP
DIR_1HOP st=0 npath=1 ans=1 p0=40 p1=0 obj=1
PASS DIR_1HOP
IND_NO_1HOP st=1 npath=0 ans=0 obj=1 ctx=2
PASS IND_NO_1HOP
POLARITY st=5 npath=1 ans=0 acc=0
PASS POLARITY
CONTEXT st=0 npath=1 ans=1 p0=51 obj=0 ctx=1
PASS CONTEXT
FIFTH st=6 npath=5 ans=0 p0=0 acc=0
PASS FIFTH
UNREL st=1 npath=0 ans=0 p0=0
PASS UNREL_NO_STALE
ASTRA_F2R3_SEM_GUARD_XSIM_PASS
```

Marker **present**. `tbl=0`. `fail==0` implied by marker (TB prints FAIL lines otherwise; none in the log).

`xvlog.log` analyzed `a7ng_astra_f2r3_sem_guard` + `a7ng_shared_rank_sgd_q8_sym_f2r2` + bag TB. `xelab.log` built snapshot `f2r3`. F2R2 integrator and floor-shift SGD were **not** compiled into this run.

No `xsim_fail.log` in this bag. First recorded run is the pass run (work-order fail-archive clause not triggered).

### RTL cites (live) — item 4 hunts

**Hunt 1 — latch and use query object and context, not comments**

```276:280:rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv
          if (qse_valid) begin
            r_subj <= qse_subj; r_obj <= qse_obj; r_rel <= qse_rel; r_ctx <= qse_ctx;
            r_two <= (qse_ctx == CTX_INDIRECT);
            r_obj_v <= (qse_obj != 8'd0);
            r_dom <= (qse_ctx != 8'd0) && (qse_ctx != CTX_INDIRECT);
```

`LAW_SEL=1` maps role-extract `obj_id_o` → `intent_id_o` / DUT `qse_obj`, `ctx_id_o` → `qse_ctx` (`a7ng_query_axi_sparse.sv:142-143`). `poke_v_i=1'b0`. Queries are `send_text(...)` tokens, not TB-poked roles.

Object/context are **comparators**, not display-only:

```342:347:rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv
              && (!r_obj_v || (fo[ei[3:0]]=={{12{1'b0}}, r_obj}))
              && (!r_dom || (fcx[ei[3:0]]==r_ctx))) begin
```

Same guards on 2-hop hop2 dest / both-hop `fact_ctx` in `S_EJ` (`:381-382`).

Contrast: frozen F2R2 still ignores object/context (`a7ng_astra_f2r2_hs_law.sv:267`).

Raw: WRONG_OBJ `obj=11 ctx=2` + `ans=0`; CONTEXT `ctx=1 obj=0` + `ans=1` (chiller) not high-conf valve.

**Hunt 2 — conflict declared before selection, not ranked away like DESC_SWAP 4|7**

```408:424:rtl/native_graph/integrate/a7ng_astra_f2r3_sem_guard.sv
        S_GUARD: begin
          if (n_legal > MAX_PATH[4:0]) begin
            r_st <= ST_INCOMP;
            ...
            st <= S_HOLD;
          end else if (r_conf) begin
            r_st <= ST_CONFLICT;
            ...
            st <= S_HOLD;
          end else if (np == 0) begin
            r_st <= ST_UNKNOWN;
            ...
            st <= S_HOLD;
          end else begin
            pi <= '0;
            st <= S_SC;
          end
```

Scoring (`S_SC`) and pending (`S_PICK`) run **only** after unique dest and `n_legal ∈ 1..4`. `r_conf` is set during enumeration on ≥2 positive dests or positive dest D plus negative evidence for D (`:348-354`, `:383-389`).

TB `plant_shared` is the F2R2 SHARE / DESC_SWAP corpus (hop2 dest **4** and dest **7**, `load_w0(-16)` would have selected the low-conf dest 7). Check is `st===ST_CONFLICT && ans===20'd0 && !pend_acc` — **not** `ans==4 || ans==7`.

Raw: `CONFLICT_DEST npath=2 ans=0 p0=0 st=5 acc=0` then `CONFLICT_NO_UPD` (`nupd=0`, `w0` stays −16). Contradiction was **not** ranked away.

POLARITY: pos 2-hop dest 4 + `pol=0` 2-hop dest 4 → `st=5 npath=1 ans=0 acc=0`. High-conf forbid (conf 200) did not win.

Bag-local `requires` contract (PREREG): unique conclusion for ANSWER. That is the missing relation contract from F2R_ACCEPTANCE item 4.

**Hunt 3 — fifth legal path declared INCOMP, not silent drop at MAX_PATH=4**

Slot store caps at `np < MAX_PATH` (`:355`, `:390`) but `n_legal` still increments (`:367`, `:402`). `n_path_o = n_legal` (`:151`). `S_GUARD` INCOMP if `n_legal > 4` **before** conflict/select. AXI/walk overflow INCOMP at `S_EI` skips enum and would leave `n_legal=0` — FIFTH cannot be that cheat because raw `npath=5`.

TB `plant5` writes **five** 2-hop pairs (facts 20..29, dest 4). Check: `st===ST_INCOMP && npath>=5 && ans===0 && !pend_acc`.

Raw: `FIFTH st=6 npath=5 ans=0 p0=0 acc=0`. If silent drop, this would have been `st=0 npath=4 ans=4`.

INCOMP is checked before CONFLICT, matching PREREG (joint INCOMP+CONFLICT not TB’d).

**Hunt 4 — wrong-object / direct-vs-indirect / polarity / context are DUT paths**

| Tag | Query tokens | Plant | DUT rule exercised | Raw |
|-----|--------------|-------|--------------------|-----|
| WRONG_OBJ | `pump requires indirect valve` | same 2-hops dest 4 as SMOKE | `r_obj_v` dest==valve(11) fails | st=1 npath=0 ans=0 obj=11 |
| DIR_NO_STEAL | `pump requires compressor` | 2-hop only dest 4 | `!r_two` → `S_ED` 1-hop only; 2-hop not stolen | st=1 npath=0 obj=4 ctx=0 |
| IND_USE_2HOP | `pump requires indirect compressor` | same 2-hop dest 4 | `r_two` + dest==4 | st=0 npath=2 ans=4 obj=4 ctx=2 |
| DIR_1HOP | `pump requires chiller` | 1-hop pump→chiller trans=0 | 1-hop ANSWER p1=0 | st=0 npath=1 ans=1 p0=40 |
| IND_NO_1HOP | `pump requires indirect chiller` | 1-hop only | 2-hop required; 1-hop not promoted | st=1 npath=0 ctx=2 |
| POLARITY | `pump requires indirect` | pos dest 4 + forbid dest 4 | `r_conf` before pick | st=5 ans=0 |
| CONTEXT | `pump requires water` | valve fctx=2 conf 200 vs chiller fctx=1 conf 8, `load_w0(+16)` | `r_dom` fact_ctx==water(1); score must not pick valve | st=0 npath=1 ans=1 p0=51 ctx=1 obj=0 |

Lexicon (opened `qse_role_lexicon.svh`): pump=10, chiller=1, compressor=4, valve=11, requires=2, water=CTX 1, indirect=CTX 2. Matches DUT outputs. If object/context were unused, WRONG_OBJ would ANSWER 4 (SMOKE corpus), DIR_NO_STEAL would ANSWER 4, CONTEXT would CONFLICT (two dests) or rank valve under `w0=+16`. Observed statuses falsify those.

**Hunt 7 — F2R2 handshake / ISO law regression**

DUT instantiates frozen `a7ng_shared_rank_sgd_q8_sym_f2r2` (`:243-248`). Handshake: `rew_lat` on accepted valid (`:455-458`); `pulse_rew` inverts bus next cycle; MUT after PICK leaves `phi0=50`.

Independent integer re-derivation (Master / DESIGN_CANDIDATE §5.2, SHIFT=6, `RSH(v,s)=sign(v)*floor((|v|+2^(s-1))/2^s)`):

- **+3, x0=50, w=0:** `err=768`, `RSH(38400,13)=(38400+4096)//8192=5`. Floor contrast `38400>>13=4`. Raw `ISO_P3 w0=5`.
- **−3, x0=64, w=0:** `RSH(-49152,13)=-6`. Raw `ISO_M3_X64_DW6`.
- **−3, x=[50,64,64,64,64]:** `dw=[-5,-6,-6,-6,-6]`. Raw HS `w0=-5 w1=-6` on DUT SGD (not only TB `u_iso`).

ISO instance in TB is extra; DUT path is proven by `HS_ALL32_M3_P50` / SLOT 32-dw.

---

## Overclaim / cheat / tautology

| Hunt | Finding |
|------|---------|
| RESULTS.md vs raw log | No material mismatch. Marker, 78905 ns, smoke/HS/conflict/slot/semantic/UNREL strings match. RESULTS is **not** used as evidence. |
| Editing goldens to PASS | **Not found.** No fail-r0 in this bag. TB oracles are live `oracle_upd` from `pphi` snapshot + ISO `===5`/`===-6`. `oracle.json` hashed in PRE CONFIG; TB does not `$readmem` it. Semantic checks are status/ans/obj/ctx, not relaxed `ans==4\|\|7`. |
| Floor-shift labeled Master symmetric | **Not found.** Instantiates frozen F2R2 SGD hash `b66ef328…`. Discriminating ISO +3,x0=50 is **+5** not +4. Floor file hashed as not-compiled. |
| F3 / 5 seeds / BOARD_PASS / LM06 / item 5 | **Not claimed as closed.** ACK/PREREG/CLOSEOUT/metrics list them OPEN. SLOT `load_w0` is plumbing winner control, not held-out transfer. |
| `load_from_tb` as retrieval | `load_from_tb_o=1'b0` (`:120`). Smoke `tbl=0`. Corpus is TB AXI plant (admissible for this XSim; not DMA/DDR production retrieval). `poke_v_i=0`. |
| ID one-hot as transfer | Phi is conf/flags (`qphi0`, trans, pol, schema, rel-match). No query/answer/entity ID in phi. Tie-break uses proof IDs only when scores equal (`:194-196`), and CONFLICT/INCOMP never reach that mux. |
| Closing item 4 with comments only | **Not found.** Object/context/conflict/fifth-path are live FSM paths; raw statuses match. |
| DESC_SWAP still accepted | **Not found.** Same 4-vs-7 plant now `st=5 ans=0 acc=0`. |
| Silent fifth-path drop | **Not found.** `n_legal` reported 5, status 6, no pending. |
| Hash theatre | Freeze 12:57:52 is **before** xsim 12:57:56–58. `.svh` in manifest. Compiled 12/12 pre/post match. |
| F2R2 / F2R-01 wipe | **Not found.** F2R2 `xsim.log` still 12:15:23 PID 32496. F2R2 DUT/SGD hashes unchanged. |
| Tautology `phi[3]/phi[4]` | During `S_SC`/`S_SW`, `phi[3]=phi[4]=64` always (`:185-186`) because enum already required `fr==r_rel` and fetch required `ver==1`. Constant on legal scored paths. Not an item-4 cheat; not a selectivity claim. |
| Implementer `PASS (this gate only)` | Scoped. Not OVERCLAIM if auditor grade stays **narrow**. |

---

## Logic bugs (file:line, confidence /10)

None demonstrated in the pass log that falsify item 4 on this bag’s tests.

Residuals (not P1 for this gate):

1. **Sparse keys still F2R2 subj/rel plant, not object-keyed retrieval — 6/10 as residual, 2/10 as item-4 fail.** TB `plant_keys` always writes `dir_addr(0,2562)` (`{pump,requires}=0x0A02`) and `dir_addr(2,766)`. Object/context legality is **post-fetch**. Item 4 required latch/use in proof legality, which is present. Do not promote this bag as ASTRA-03 key-law closure.

2. **Parser AMB/NEG short-circuit untested — 5/10.** `r_amb`/`r_neg` skip fetch at `S_WALK` (`:291-292`). PREREG lists status 7/8. No TB query fires them. RTL exists; not a silent drop of legal proofs in the observed sequence.

3. **`have_neg` remembers one dest (`neg0`) — 4/10.** Pos dest 4 + forbid dest 7 (different) does not set `r_conf` unless a later pos matches `neg0`. PREREG conflict is “negative evidence **for D**”. Unique remaining positive dest may ANSWER. Not hit by POLARITY (same dest).

4. **1-hop polarity / domain-context two-dest conflict not separately TB’d — 3/10.** `S_ED` has the same `r_obj`/`r_dom`/`r_conf` ops as `S_EJ`. POLARITY and CONFLICT_DEST are 2-hop; CONTEXT is 1-hop unique dest.

5. **Joint fifth-path + two dests (INCOMP-over-CONFLICT) untested — 3/10.** Code order is correct (`n_legal>4` first).

6. **Gen/txn wrap and post-reset replay — 8/10 as lifetime, 0/10 as this gate.** Same 8-bit counters as F2R2 (`:438-439`). PREREG leaves wrap OPEN. In-episode DUP/STALE/OOR/retire still PASS here.

7. **AXI always-OK TB slave; `TO_CYC=64` unused for LATE_R — item 5, not this gate.** `S_AR`/`S_R` timeout still sets `r_axi` → INCOMP without drain/cancel contract.

8. **Stale `pend_phi` after UNKNOWN — 4/10.** UNREL checks `st/npath/ans/p0`, not phi. No false commit (`!pend_acc`). Same class as F2R2.

No remaining **demonstrated** P1 that falsifies item 4.

---

## F2R_ACCEPTANCE item 4 vs this bag (CLOSED / PARTIAL / OPEN)

| Item | Grade | Why |
|------|-------|-----|
| **4** semantic guards | **CLOSED (narrow)** | Object+context latched from QSE and used in hop legality. Unique-conclusion `requires` contract declared. CONFLICT/INCOMP/UNKNOWN **before** `S_SC`/`S_PICK`. WRONG_OBJ, DIR/IND 1-hop vs 2-hop, POLARITY, CONTEXT, FIFTH all PASS on raw log with DUT status, not TB constants. |
| **1,2,3** (F2R2) | **regression PASS in this DUT** | Full scored phi copy on PICK (`:441`); reward latch + bus invert; ISO +5 / HS −5/−6. Frozen SGD not patched. |
| **6** pending identity | **PARTIAL (unchanged)** | In-episode guards PASS. Wrap/reset replay still OPEN. |
| **5** post-timeout AXI | **OPEN** | Not this bag. Do not close. |

Narrow = bag-local unique-conclusion contract + XSim TB-planted AXI corpus + post-fetch object/context filters. Not production retrieval, not F3, not item 5, not LM06, not BOARD.

---

## Verdict per bag: PASS / PASS_NARROW / FAIL / OVERCLAIM

**PASS_NARROW** — `ASTRA-F2R-R3-SEMANTIC-GUARD-01`

Narrow = F2R_ACCEPTANCE item 4 as shown in raw XSim on the new named DUT, plus F2R2 handshake/law regressions. Not F3, not item 5, not LM06, not timing, not BOARD_PASS, not wrap-lifetime, not sparse-key redesign.

---

## Required fixes (numbered, owner=implementer, P1 first) OR none

**none** for closing this item-4 bag.

Do not dispatch a DUT “fix” against the pass evidence. Residuals (parser AMB/NEG TB, 1-hop polarity TB, wrap/reset replay, object-in-index-keys) are **not** P1 for this gate.

Parent: keep item **5** (post-timeout AXI drain/SLVERR/abort) as the next **named** bag. Do not reopen F2R2 handshake. Do not treat this as F3/LM06/BOARD. Preserve F2R-01 and F2R-R2 bags. Do not rerun `run_f2r.ps1` or `run_f2r2.ps1`. Do not rerun `run_f2r3.ps1` in a way that wipes `xsim.log`.

---

## Final: ACCEPT_PARTIAL | REJECT_PROMOTION | FAIL_LOOP

**ACCEPT_PARTIAL**

Promotion of F3 / item 5 / LM06 / BOARD / COM12 remains **REJECT**. PROGRAM=NO. COM12 UNTOUCHED.
