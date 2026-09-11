# E3_REVIEW — local E3 stop after E3y (no E3z)

**PROGRAM=NO.** `C4_MASTER` OPEN. `C5_MASTER` OPEN. `C6_MASTER` OPEN.  
`ASTRA_NATIVE_AI_BOARD_PASS` NOT_EVIDENCED. G14 **BLOCKED_PRE_BOARD**. Do not program.

Authority: user E3 convergence plan (E3w → E3x → at most one E3y → E3_REVIEW; no E3z) + WO-FINAL ASTRA C4–C7 + amendment E0 (Gemini “nghiệm thu toàn bộ C4” is **not** approval).

---

## Decision

| Question | Decision | Class |
|----------|----------|--------|
| Keep ASTRA D32 FR v2 as the **WO C4 decoder candidate**? | **YES** — it is still the only WO-authorized C4. GOLDEN n=242 PASS on this DUT. | INFERENCE from WO + FACT GOLDEN |
| Is that C4 **physically closed** / production-ready to freeze? | **NO** — last OOC WNS **−1.332 ns**, failing 88, no post-route C6, `freeze_allowed=false`. | FACT |
| Adopt GEMINI (`top_decoder.bit`) as C4 replacement? | **NO under this WO.** Sibling tree; not the frozen C6 path; not G14 §22. Would need a **new human WO**. | FACT WO/amendment; INFERENCE on replacement |
| Continue local OOC E3 (E3z S_F2)? | **NO.** Plan §3 already spent the one extra gate. | FACT plan |

---

## E3y six numbers (FACT)

OOC synth `a7ng_astra_c4_lm06_d32_fr_v2` + RQ + SMRES, Vivado 2026.1, `xc7a100tcsg324-1`, 10 ns, `maxThreads 4`. Marker `E3Y_CHAIN_OK PROGRAM=NO`.

| Item | E3x | E3y |
|------|-----|-----|
| WNS | −1.532 ns | **−1.332 ns** (Δ **+0.200**) |
| TNS | −101.238 ns | −88.438 ns |
| Failing endpoints | 88 | 88 (not materially better) |
| Top-20 dest | prod_r 20 | prod_r 20 |
| Worst source | `kv_reg[23][30][15]/C` (S_DOT) | **`fi_reg[5]/C` (S_F2)** |
| Worst dest | `prod_r_reg[31]/D` | `prod_r_reg[31]/D` |
| Logic levels | 10 | 8 |
| CARRY4 / DSP48E1 | 0 / 1 | 1 / 1 |
| LUT / FF / DSP / BRAM | 26915 / 43308 / 12 / 0 | 26799 / 43326 / 12 / 0 |

n20 SHA256 `7c59f524db4c3f4ccf905433e6b35597620008b35a55728924a4615361f075da`.  
E3x n20 SHA256 `778e6a55838d379afcdf63d394fe621b499e391d7d06def8ed80d986285519b0` **intact** (not overwritten).  
DUT SHA256 `a39c39c08b682dc8f1134105268e93e7528a3d17e8abce30485cd168bfad1879`.

GOLDEN (this DUT, 2026-09-11 03:59–04:12 +07, ~12:25): `CLASS_host_tok0` HIT, `CLASS_ref_match` HIT, `ASTRA_C4_D32_FR_V2_XSIM_PASS n=242`, `C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO`.

Case: **MIXED / cone-read**. Dest still `prod_r` 20/20; source cone **changed** `kv`→`fi`. S_DOT cut. Remaining critical cone is **S_F2** `prod_r <= wgt8(W2[dj*Ff+fi]) * tv[fi]` in the same cycle as the index. `stop_local_e3` (same `kv` cone ∧ ΔWNS<0.15) = **false**. **Stop further local E3 by plan** = **true**.

OOC WNS≥0 is **not** WO §19 physical PASS. Post-route C6 was **not** started.

---

## Why GEMINI is not the C4 replacement here

- WO: one production C4 is the rescued **D32** decoder in this ASTRA tree, not a sibling bitstream.
- Amendment: Gemini “nghiệm thu toàn bộ C4” is **not** approval.
- GEMINI independently synthesizes/programs `top_decoder.bit` via `program.tcl`. That bit is **not** a frozen C6 ASTRA bit and is **not** a G14 §22 exam on ASTRA.
- BASIC license contention with GEMINI `program.tcl` is operational, not a C4-pass argument.

Selecting GEMINI as C4 would be a **WO change**, not an E3 result.

---

## What remains if ASTRA C4 stays the candidate

Local OOC E3 chain **closed** at E3y. Not started and not authorized by this plan:

- E3z / S_F2 operand pipe
- Post-route C6 of the whole-chip top
- E1 reverse (NEW GATE)
- C5 18/18 matrix
- Unique C6 freeze + unique bit SHA
- G14 program / silicon exam

Scoring (unchanged): `LEARNED_NUMERICAL` GOLDEN 242 PASS; `SYSTEM_360` observed 0/360; prefix causal FAIL 0/16 retained. Those still block `C4_MASTER` even if timing later closes.

---

## Next (human)

1. Treat this E3_REVIEW as the local-E3 stop. Do not start E3z unless a **new** written plan overrides §3.
2. Keep ASTRA D32 FR v2 as the WO C4 decoder candidate; do **not** stamp MASTER.
3. If GEMINI should replace C4, write that WO explicitly. Until then, do not mix Gemini bits into ASTRA G14.
4. G14 stays BLOCKED until post-route WNS≥0, TNS=0, WHS≥0, THS=0, unique freeze, unique bit, and **explicit** program authorization — all on that same bit+manifest.

---

## Override (2026-09-11) — one E3z gate

`E3Z_F2_OP_PIPE_SPEC.md` is the **new written plan** that overrides §3 for **one** additional local OOC gate: snap `w8_r`/`val_r` in `S_F2`, multiply in `S_F2_PROD`, KEEP `S_F2_MAC`. GOLDEN n=242 before OOC. Do not overwrite E3y n20. Do not auto-start a further pipe. Still `PROGRAM=NO`. Not MASTER. Not WO §19.
