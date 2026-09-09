# ASTRA auditor REPORT — 20260906T0120Z

```text
ROLE       = independent auditor (gstack /review + /qa-only; qstack validation-adversary + code-review)
CWD        = D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
PROGRAM    = NO
COM12      = UNTOUCHED
JTAG       = 210319BE776EA UNTOUCHED
RTL_EDIT   = NO
FIX        = NO (report only)
LOOP_STATE = auditor=IN_PROGRESS, unblocked_item=AUDITOR_HEALTH_PASS, final_promotion=REJECT
```

MUST_READ_UNBLOCK_H5: not this lane (encoder H5). This ticket is ASTRA RTP + ASTRA-11 wrap/timing.

---

## Scope

Read-only health pass over:

| Bag | Path |
|-----|------|
| RTP-0 | `results/A7-NATIVE-GRAPH/ASTRA-RTP-RETRIEVAL-TO-PROOF/` |
| RTP-R1 | `results/A7-NATIVE-GRAPH/ASTRA-RTP-R1-TRANSPORT-IDENTITY/` |
| RTP-R2 | `results/A7-NATIVE-GRAPH/ASTRA-RTP-R2-HIGHID-ARTO/` |
| RTP-F2 | `results/A7-NATIVE-GRAPH/ASTRA-RTP-F2-COMPETE-RANK-REWARD/` |
| RTP-F2T | `results/A7-NATIVE-GRAPH/ASTRA-RTP-F2T-SHARED-TRANSFER/` |
| HOP3 | `results/A7-NATIVE-GRAPH/ASTRA-RTP-HOP3/` |
| SGD-PERSIST | `results/A7-NATIVE-GRAPH/ASTRA-SGD-PERSIST/` |
| ASTRA-11 wrap | `results/A7-NATIVE-GRAPH/ASTRA-11-SOC-WRAP/` |
| ASTRA-11 timing | `results/A7-NATIVE-GRAPH/ASTRA-11-TIMING-FIX/` |

Authority: `docs/ASTRA/AUDITOR_BOOT.md`, `docs/ASTRA/GSTACK_LOOP.md`, `docs/ASTRA/LOOP_STATE.json`, `docs/ASTRA/PARENT_ORCHESTRATOR.md`, `docs/ASTRA/RTP_REVIEW_ACCEPTANCE.md`, `docs/ASTRA/ACCEPTANCE_INDEPENDENT_20260905.md`.

DUT skim (no edits): `a7ng_astra_rtp_pipe.sv`, `_r1`, `_r2`, `_f2`, `_f2t`, `a7ng_astra_rtp_hop3.sv`, `arty_a7_astra09_soc_top.sv`, `a7ng_astra09_pipe.sv`, `a7ng_shared_rank_sgd_q8.sv`, `a7ng_shared_rank_sgd_q8_v1.sv`, `a7ng_axi_bram128.sv`. TBs in each bag.

Hunt: overclaim, cheat, tautology, RESULTS vs raw log, hash theatre, ID one-hot as transfer, TB-load as retrieval, LM06 language, BOARD_PASS without WNS≥0 **and** JTAG program log.

---

## Evidence re-derived

### Raw XSim vs RESULTS.md

All cited `xsim.log` files are Vivado `xsim v2026.1` sessions on `laptop-Quan`. Banner PASS/FAIL strings match RESULTS.md. `tbl=0` / `load_from_tb_o=0` where printed.

| Bag | Raw banner | RESULTS claim | Match? |
|-----|------------|---------------|--------|
| RTP-0 | `ASTRA_RTP_XSIM_PASS`; BASE ans=4 p0=17 p1=34 nc=2 tbl=0 nhost=0; POST_DROP_BC st=1 ans=0 nc=1; DESC_SWAP ans=7; UNREL nc=0 | PASS_NARROW, TB_LOAD=0 | YES |
| R1 | `ASTRA_RTP_R1_XSIM_PASS`; 11 CASE PASS including AXI_BAD_RID/SLVERR/NOLAST/TIMEOUT st=6, OVF st=6, NEG st=8, AMB st=7; tbl=0 nhost=0 | PASS_NARROW | YES |
| R2 | `ASTRA_RTP_R2_XSIM_PASS`; HIGH_ID ans=4 p0=a0011 p1=a0022; EID_MISMATCH st=6 nferr=1; AR_STALL st=6 narto=2; LATE_R ans=4 | PASS_NARROW | YES |
| F2 | `ASTRA_RTP_F2_XSIM_FAIL n=1`; R0 chiller; `DBG w0=0 w1=0 … do_upd=1`; R1 still p0=17 mid=1; CONTROL PASS | FAIL reward-switch; not F2 PASS | YES on fail; CONTROL claim is cheat (below) |
| F2T | `ASTRA_RTP_F2T_XSIM_PASS`; TRAIN0 cls=1; AFTER_REW w0=-6 w1=0; HOLD p0=33333 cls=2 ans=4 | PASS_NARROW shared-class | YES as **narrow** class-byte transfer |
| HOP3 | `ASTRA_RTP_HOP3_XSIM_PASS`; BASE ans=7 p=17,34,51 tbl=0; DROP_LAST/TWO_ONLY/UNREL st=1 | PASS_NARROW | YES |
| PERSIST | `ASTRA_SGD_PERSIST_XSIM_PASS`; AFTER_UPD v=0 w0=6; AFTER_RST v=0; AFTER_RELOAD v=3 w0=6 | PASS_NARROW register snapshot | YES vs log; weaker than PREREG v_A==v_B |

### Raw timing vs RESULTS / TIMING_EXTRACT

**Wrap** `timing.rpt` Design Timing Summary (routed, -1 PRODUCTION, 2026-09-05 22:59):

- WNS=**-4.765** ns, TNS=**-2392.529** ns, 587 failing endpoints / 4034
- WHS=**0.046** ns, THS=0
- Clock: `sys_clk_pin` 10.000 ns (100 MHz only; no MMCM child)
- Text: `Timing constraints are not met.`
- Matches `TIMING_EXTRACT.txt` and RESULTS.md. Route complete. **Not** WNS≥0.

**Timing-fix** `timing.rpt` (2026-09-06 01:09):

- Design Timing Summary WNS=**7.179**, TNS=0, WHS=**0.083**, failing endpoints=0 / 4162
- Text: `All user specified timing constraints are met.`
- Clocks: `sys_clk_pin` 10 ns (pin E3), generated `clk50u` 20 ns **50 MHz**
- Intra-clock WNS is on `clk50u` (7.179), not 100 MHz fabric
- Matches `TIMING_EXTRACT.txt` and RESULTS.md (`@ 50 MHz (pipe domain)`)
- `util.rpt`: LUT 3102, FF 1577, **Block RAM Tile = 0**, DSP 2

BITSTREAM.txt both bags: `STATUS=UNPROGRAMMED`, `PROGRAM=NO`, COM12/JTAG untouched. No xsdb/fpga program log in either bag. **Cannot** be BOARD_PASS.

### SHA256 freeze vs live (re-hash)

No `Get-FileHash` in this auditor sandbox. Re-hash is **cross-manifest + live-content identity**, not a claimed SHA256 of every byte.

| Check | Result |
|-------|--------|
| `a7ng_astra09_pipe.sv` | `48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b` identical in R1, R2, HOP3, F2, wrap | KEEP |
| `a7ng_astra_rtp_pipe_r1.sv` | `35ad8a172fac50adbb9d04d3c80ae4740b1ac3a862f8e3b76fa3b4d02ed5c056` identical in R1, R2, HOP3 | KEEP |
| `a7ng_astra_rtp_pipe.sv` | R1 freeze `9a0d945b…` (RTP-0 bag has **no** SHA256.txt) | incomplete freeze on RTP-0 |
| `a7ng_shared_rank_sgd_q8_v1.sv` | F2T freeze `c124f39a452ed34f4a52a562395a5c731c2e273f1d919c3f69e0918dcfc744fe` vs persist freeze `01ef40079f1407c1067ed98a6e1b0a4b0e8d0b6911f21afb0542e43728a73c24` | **DRIFT** (persist added `load_v_i` / `w_o`) |
| HOP3 `SHA256.txt` | `a7ng_astra_rtp_hop3.sv` listed **twice**; **TB not hashed** | hash slop |
| ASTRA-11-TIMING-FIX | **no SHA256.txt** | hash theatre gap |
| live `arty_a7_astra09_soc_top.sv` | now contains `MMCME2_BASE` 100→50, `CLK_HZ=50_000_000`, `freeze_i(1'b1)` | wrap freeze `f8cef9a0…` is a **prior** 100 MHz netlist; do not mix wrap bit with live source |
| F2 `a7ng_shared_rank_sgd_q8.sv` | `c6f37a273960a318…` (ACCEPTANCE 12B DRIFT still cited) | DSP-pipelined SGD ≠ v1 |

Frozen qse-v1 SHA in wrap SHA256.txt / RESULTS: `ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768` — wrap bag only; not re-derived here as a live hash.

### DUT / TB cheat-hunt facts

- Every RTP* DUT: `assign load_from_tb_o = 1'b0`. Engine facts come from AXI beats the TB **plants in a memory model**, not `load_v` during query. That is the intended F1 pattern, not a TB-load cheat.
- `poke_v_i` tied 0 on walkers.
- Original RTP-0 pack is **not** rtp-desc-v1: valid at bit 34, 8-bit s/r/o/e. R1+ uses rtp-desc-v1 20-bit + `beat_ok` (RID==2, RRESP OKAY, RLAST, schema_ver=1, eid==cand).
- SoC wrap: `freeze_i(1'b1)`, `load_v(1'b0)`, AXI writes tied off, BRAM `initial` zeros, post-route **0 BRAM tiles** (const-prop empty). `a7ng_astra09_pipe` **does not** fetch descriptors into the 2-hop engine (`eng_load = load_v && IDLE` only; walker IDs never become facts). Empty store + frozen SGD.
- Composer `a7ng_evidence_compose` still on 09 pipe; not language; LOOP_STATE `astra08=LM06_NOT_INTEGRATED` is correct.

---

## Overclaim / cheat / tautology

1. **F2 CONTROL is a tautology (CHEAT).**  
   `tb_astra_f2.sv` lines 90 + 109–110: `ctrl0 = 17; ctrl1 = 17; if (ctrl0==ctrl1) PASS CONTROL_VALIDITY_DOES_NOT_SWITCH`. No second query, no validity-only phi. PREREG promised `phi[2]=64 iff complete` and “control does not switch”. DUT forces `phi[2] = 0` always (`a7ng_astra_rtp_f2.sv` score comb). RESULTS.md still writes `CONTROL = validity-only does not switch (PASS)`. **Strip CONTROL PASS.** Rank-before-select R0 and the honest R1 FAIL remain.

2. **F2 feature is ID one-hot, not shared structure.**  
   `phi[0]=(pmid==1)`, `phi[1]=(pmid==8)`. That is the gstack cheat “ID one-hot called transfer”. F2 RESULTS does **not** claim transfer PASS (good). F2T moved to class byte — do not back-port F2 as transfer.

3. **F2T is 2-way one-hot of a TB-planted CLASS byte, not 32-φ ASTRA-06 transfer.**  
   `phi[0]=(cls==1)?64:0; phi[1]=(cls==2)?64:0`. HOLD world new eids `0x11111…0x44444` and new mids `0x10/0x20` still pick class2 `p0=0x33333` after w0=-6 — **not** mid==1/8 one-hot (that would still prefer min-id class1). Claim allowed: **shared planted class-byte**. Claim forbidden: general held-out / paraphrase / language.

4. **F2T PREREG vs DUT mismatch (narrow, not log-lie).**  
   PREREG: “object CLASS of hop-1 (desc[83:76])”. DUT: `pcls <= fc[ei]` (hop-0). TB plants the same class on both edges, so the test cannot distinguish hop-0 vs hop-1 class.

5. **SGD persist PREREG vs TB.**  
   PREREG: `v_B must equal v_A after load`. Log: AFTER_UPD **v=0** (score of **zero** weights during `go_upd`), AFTER_RELOAD **v=3**. TB checks `wo[0]===snap[0] && v!=0`, not v_A==v_B. Snapshot of `w` is real; it is **not** DDR/AXI schemaV2 persist.

6. **ASTRA-11 wrap RESULTS `PASS_NARROW` at WNS=-4.765 is allowed by wrap PREREG** (route complete, WNS reported). It is **OVERCLAIM** if anyone maps it to timing close or board. LOOP_STATE `astra11=TIMING_PASS_50MHZ` must not be read as 100 MHz close.

7. **Timing-fix WNS=7.179 is 50 MHz pipe domain**, pin still 10 ns. Honest in RESULTS. **OVERCLAIM** if labeled 100 MHz PASS or BOARD_PASS. Bit UNPROGRAMMED. Empty BRAM.

8. **No LM06 language, no NLU, no BOARD_PASS** in these RESULTS.md files. Parent ACCEPTANCE already REJECT_FINAL_PROMOTION. Do not reopen.

9. **Hash theatre:** HOP3 duplicate DUT line / missing TB hash; timing-fix bag without SHA256.txt; RTP-0 without SHA256.txt; SGD v1 hash changed between F2T and persist without a DRIFT.md in those bags.

---

## Logic bugs

1. **DSP SGD `a7ng_shared_rank_sgd_q8` update does not land in F2.** Raw: `do_upd=1` and `xsel0=64` but `w0=0` after 200 cycles. 3-stage DSP + `uv0..uv3` / `UFLUSH` pipeline is not bit-exact with `a7ng_shared_rank_sgd_q8_v1` (which **does** move w0 to -6 / +6). SoC wrap still instantiates the DSP SGD (`a7ng_astra09_pipe`). Timing-fix closed WNS by **downclock**, not by proving Q8 update math.

2. **ASTRA-09 SoC cannot run RTP exam.** Walker AXI is live; 2-hop table only fills via `load_v` (tied 0); index BRAM empty and optimized to 0 tiles. UART fire would walk zeros and score a frozen ranker. Glue RTP fetch into the wrap before any ASTRA-13 thought.

3. **RTP-0 fetch is protocol-blind** (no RID/RRESP/RLAST/eid check; 8-bit IDs). Frozen on purpose; R1/R2 exist. Do not treat RTP-0 as transport-identity.

4. **R1 has no AR-ready timeout** (R2 adds `narto`). Keep R1 frozen; do not retarget.

5. **HOP3 last-match wins** (triple loop overwrites `r_ans`). Fine for a unique chain; ambiguous 3-hop worlds are untested.

6. **Original RTP `S_R` uses `m_axi_rdata[34]` as valid** — incompatible with rtp-desc-v1. Mixing plants would silently drop/accept wrong beats.

---

## Verdict per bag

| Bag | Verdict | Why |
|-----|---------|-----|
| ASTRA-RTP-RETRIEVAL-TO-PROOF | **PASS_NARROW** | Raw causality holds; tbl=0; 8-bit old pack; not SoC/LM06/board |
| ASTRA-RTP-R1-TRANSPORT-IDENTITY | **PASS_NARROW** | Log matches 11 cases; rtp-desc-v1 + beat_ok; 09 pipe hash kept |
| ASTRA-RTP-R2-HIGHID-ARTO | **PASS_NARROW** | High-ID 20-bit + AR stall + late R; R1 file hash unchanged |
| ASTRA-RTP-F2-COMPETE-RANK-REWARD | **FAIL** (R0 rank-before-select **PASS_NARROW**; CONTROL **CHEAT**; reward-switch **FAIL**) | Do not promote F2 |
| ASTRA-RTP-F2T-SHARED-TRANSFER | **PASS_NARROW** | Class-byte transfer on new IDs; not ID-one-hot of mid 1/8; not 32-φ / language |
| ASTRA-RTP-HOP3 | **PASS_NARROW** | 3-hop BASE + DROP_LAST + TWO_ONLY (must not report 2-hop ans=4); SHA freeze incomplete |
| ASTRA-SGD-PERSIST | **PASS_NARROW** | Register snapshot/reload on v1; not DDR; PREREG v_A==v_B not actually tested |
| ASTRA-11-SOC-WRAP | **PASS_NARROW** | Synth+impl+route real; **WNS=-4.765 FAIL timing**; empty BRAM; UNPROGRAMMED |
| ASTRA-11-TIMING-FIX | **PASS_NARROW** | WNS=7.179 / WHS=0.083 **at 50 MHz**; not 100 MHz; not filled store; not ASTRA-13; no SHA256.txt |

LOOP_STATE `rtp_r1/r2/f2t=PASS_NARROW_KEEP`, `hop3/sgd_persist=PASS_NARROW`, `astra11=TIMING_PASS_50MHZ`, `astra08=LM06_NOT_INTEGRATED`, `astra13=BLOCKED`, `program=false` — **accepted as labels**, except F2 FAIL is omitted from LOOP_STATE (should be recorded, not silently dropped).

---

## Required fixes (for parent to dispatch)

Owner = implementer clone only. Auditor will not patch. PROGRAM=NO.

1. **F2 honesty:** Delete CONTROL PASS from RESULTS/CLOSEOUT or implement a real validity-only world (phi[2] on both paths, second query). Do not leave `ctrl0=ctrl1=17`.
2. **F2 remainder (if still in queue):** Prove scalar reward changes **next** selection. Either fix DSP SGD commit vs v1 golden (bit-exact Q8, same SHIFT/err), or freeze DSP SGD as score-only and use v1 for learn — do not retarget ASTRA-06 name/law without a new bag.
3. **Do not call F2 PASS.** Keep R0 two-proof + min-p0 tie-break as the only F2 closed slice.
4. **Hash hygiene:** Write SHA256.txt for TIMING-FIX (RTL + bit + XDC cite). Hash HOP3 TB. Record SGD v1 F2T→persist drift in DRIFT.md (load ports). Optional: SHA for RTP-0 DUT/TB.
5. **F2T claim lock:** Document 2-class one-hot of planted `[83:76]`; hop-0 vs hop-1; F4/F5 still open. No paraphrase / LM06.
6. **Persist:** If claiming v_A==v_B, `go_score` after update before snapshot. Separate bag for AXI/DDR schemaV2 weight store.
7. **SoC exam path (blocks ASTRA-13):** Map RTP descriptor fetch into the wrap (or a new top). Do not rely on `load_v`. Un-freeze only with a learn policy. Fill or DMA index; empty BRAM is co-fit only. Keep `CLK100MHZ` E3 10 ns; 50 MHz is pipe-domain only.
8. **Never program COM12 / JTAG `210319BE776EA`** until ASTRA-13 + owner + WNS≥0 **and** auditor ACCEPT **board**. Existing bits stay UNPROGRAMMED.
9. **LOOP_STATE:** set `rtp_f2=FAIL` (or `PASS_NARROW_R0_ONLY`). Keep `final_promotion=REJECT`, `astra13=BLOCKED`. Do not set `unblocked_item` to board.
10. **12B:** `a7ng_shared_rank_sgd_q8.sv` DSP pipeline remains a documented drift vs freeze; do not quietly retarget 09 pipe SGD.

---

## Final

**ACCEPT_PARTIAL**

Promotion stays **REJECT** (not BOARD_PASS, not 100 MHz silicon exam, not language, not unified filled store).

Not **FAIL_LOOP**: raw xsim.log / timing.rpt match the non-F2 PASS_NARROW bags; F2 fail is already admitted in RESULTS.

```text
Final              = ACCEPT_PARTIAL
Promotion          = REJECT_PROMOTION
FAIL_LOOP          = NO
PROGRAM            = NO
COM12              = UNTOUCHED
```
