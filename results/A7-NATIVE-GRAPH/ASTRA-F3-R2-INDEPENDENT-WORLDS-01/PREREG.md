# PREREG — ASTRA-F3-R2-INDEPENDENT-WORLDS-01

Frozen **before xvlog**. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 or
ASTRA-F3-SHARED-TRANSFER-01 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`).
Does not rerun those bags' run scripts.

## Claim this revision may close

**PASS_NARROW plumbing only** for auditor residuals 1–5 and 7 on a **new**
named bag. After FPGA-owned reward updates on a train world, shared non-ID
32-φ improve held-out selection on worlds that are **not** the train φ with
new IDs — vs no-update and vs a true shuffled action-pairing — with
accuracy / coverage / UNKNOWN reported separately.

Does **not** close Master F3 (10pp / paired CI / retention), LM06, BOARD,
ASTRA-13, persistence/DDR, or power-loss journal.

## One unknown

Can shared non-ID features transfer to held-out worlds that are **not** the
train φ with new IDs — vs no-update and a true shuffled pairing — with
accuracy/coverage/UNKNOWN reported separately?

## Master transfer numbers — not claimed

Master §8: gain ≥10pp vs no-update, paired CI lower bound >0, retention drop
≤5pp, shuffled and per-ID controls.

This bag **will not claim those numbers**, even if compact XSim counts look
large. Frozen here (not after scores):

1. Unit of analysis is 5 **designed plants**, not a sampled world generator
   with 24 queries × 8 epochs (ASTRA-07 host twin protocol).
2. n=5 binary XSim TB-AXI is not Master confirmation. **Do not print Wilson
   or paired CI on these 5 designed plants as Master confirmation.**
3. Corpus is TB-planted postings, not production MIG/DDR.
4. Two updates + register reload is not a population retention curve.

Do **not** lower Master 10pp after seeing scores. Do not relabel this bag
Master F3 closed.

## Plumbing pass (frozen; do not retarget)

- ISO +3, x0=50 → dw0=+5 on isolated frozen SGD (not DUT weights).
- `load_from_tb_o=0`. Queries are tokens.
- 5 seeds below are independent **world/role/relation/support** draws.
  No S0/S3 quality-twin copies. Hold changes query/role/context/hop/support
  so **hold gold φ ≠ train gold φ** (TB checks `PHI_NEQ` per seed). Hold is
  not an eid remap of train φ.
- **Enabled:** one FPGA `go_upd` with +3 on the train gold action (min p0
  at w=0 selects gold). Hold must pick hold gold.
- **No-update:** rst, plant HOLD, query. w=0 min p0 = hold dist.
- **Shuffled:** independent run; permute reward/label pairing so +3 attaches
  to the **train distractor** action (shuffle plant gives dist lower p0 so
  DUT selects dist). Not a sign-flip `−3` on gold φ. Hold must **not** pick
  gold.
- **Per-ID:** dest-keyed table `pid[ans]+=3` on the enabled train pick;
  scored on hold as argmax pid[dest] among {hold gold dest, hold dist dest},
  tie → min p0. Not `train_ans==hold_gold_ans`. Expect hold gold not picked
  (disjoint dests, or same-dest object-bound tie).
- **Retention:** held-out after a **second** train epoch (no rst) and after
  **reload** (snapshot `w_o`, `rst_n`, `load_v_i` restore, hold query).
  Not train re-query smoke.
- Unrelated `payroll tax form` → UNKNOWN, npath=0, ans=0, p0=0. After that
  rst, `wdut[0]===0` (replaces tautological `ISO_DUT_W0_CLEARED_LAST`).
- Coverage on ranking queries: all ANSWER. Selective accuracy =
  `n_gold_pick / n_ANSWER` per arm, reported separately.
- If enabled hold (epoch-1) does not beat both no-update and shuffle on all
  5 seeds: **FAIL**. Do not drop a seed or flip gold after scores.

## Seeds (independent structure, frozen)

Not `eid XOR k` of one plant. Not two quality twins. Each seed changes
subject and/or relation and/or hop length and/or support topology. Train
gold φ is not copied onto hold.

| Seed | Train query | Hold query | Discriminant | Structure change |
|------|-------------|------------|--------------|------------------|
| S0 | `pump requires indirect` 2-hop quality 200 vs 8 | `pump requires water` 1-hop quality | conf_min / conf_hi | hop 2→1, ctx 2→1 |
| S1 | `valve supplies water` 1-hop ctx-match vs ctx=0 | `chiller requires indirect` 2-hop ctx-match | ctx_match | subj/rel/hop 1→2 |
| S2 | `pump requires indirect compressor` hop2-ctx 3 vs 0 | `valve requires indirect evaporator` hop2-ctx 5 vs 0 + mixed hop1 | obj_ctx_h2 | subj/obj, mixed_ctx on hold |
| S3 | `ahu connects indirect` mixed-ctx + 1 dead-end | `tower requires indirect` mixed-ctx + 2 dead-ends | mixed_ctx | rel connects→requires, support |
| S4 | `compressor supplies air` 1-hop ctx=3 (nz, not match) vs 0 | `sensor requires indirect` 2-hop ctx=1 (nz, not match) vs 0 | ctx_nz | subj/rel/hop; not ctx_match |

Hold dests disjoint from that seed's train dests except S2 object-bound
(train dest=4 compressor, hold dest=3 evaporator — still disjoint).

## Law (instantiated, not copied)

Frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`. SHIFT=6. Sequential 1-MAC.

```text
acc     = signed40(sum_i w_i * x_i)
v_q8    = clamp(RSH(acc, 7), -768, +768)
target  = reward * 256
error   = clamp(target - v_q8, -1536, +1536)
w_next  = sat16(w + RSH(error * x, 7 + SHIFT))
RSH(v,s)= sign(v) * floor((abs(v) + 2^(s-1)) / 2^s)
```

ISO: +3, x0=50, w=0 → dw0=+5.

## Feature law — phi[0:31] signed8, non-ID

Same `rtp-desc-v1-f2r3` / F3 packing. FORBIDDEN in shared w: query ID,
answer ID, raw eid, gold bit, class-winner, proof slot index, one-hot
exam entity.

1-hop scores copy hop1 into hop2 slots of the function (c2=c1, ctx2=ctx1,
t2=0, p2=p1, hop2=0). Flags are `{0,64}`.

| i  | name           | definition |
|----|----------------|------------|
| 0  | conf_min       | min(c1,c2)>>2 |
| 1  | both_trans     | t1 && t2 |
| 2  | both_pos       | p1 && p2 |
| 3  | ctx_match      | ctx1==qctx && ctx2==qctx |
| 4  | ctx_nz         | ctx1!=0 && ctx2!=0 |
| 5  | obj_ctx_h2_nz  | hop2 ? ctx2!=0 : ctx1!=0 |
| 6  | hop2_complete  | hop2 |
| 7  | conf_hi        | min(c1,c2)>=128 |
| 8  | pol_x_trans    | both_trans && both_pos |
| 9  | conf_x_ctx     | ctx_match ? conf_min : 0 |
| 10 | conf_h1        | c1>>2 |
| 11 | conf_h2        | hop2 ? c2>>2 : c1>>2 |
| 12 | mixed_ctx      | ctx1!=ctx2 |
| 13 | ctx_pair       | ctx1==ctx2 |
| 14 | path_len_1     | !hop2 |
| 15 | path_len_2     | hop2 |
| 16–31 | (zero)      | unused |

Tie-break at equal `v_q8`: lowest proof0, then lowest proof1.

## Path legality (independent of score)

Parser latch `{subj, obj, rel, ctx}`. `r_two` iff `ctx==2` (indirect).
`r_obj_v` iff `obj!=0`. No unique-dest CONFLICT. No domain-ctx hard filter.

- Direct (`!r_two`): 1-hop, src==subj, rel match, dest≠subj; if `r_obj_v` dest==obj; pol=1.
- Indirect (`r_two`): 2-hop, both trans=1, both pol=1, rel match, hop1.src==subj, hop2.src==hop1.obj, hop2.dest≠subj; if `r_obj_v` hop2.dest==obj.

np==0 → UNKNOWN. np in 1..4 → ANSWER and score.

## Protocol per seed

1. **frozen / no-update:** rst, plant HOLD, query. Expect dist p0.
2. **enabled epoch-1:** rst, plant TRAIN, query, expect gold p0, pulse +3,
   retire; plant HOLD, query, expect gold p0; `PHI_NEQ` vs train gold φ.
3. **enabled epoch-2:** no rst; plant TRAIN, +3, retire; plant HOLD, expect gold.
4. **reload:** snapshot `w_o`; rst; `load_v_i` restore 32 weights; plant HOLD,
   expect gold.
5. **shuffled:** rst, plant SHUFFLE TRAIN (dist lower p0), query selects dist,
   pulse +3 on that action, retire; plant HOLD, expect **not** gold.

Shuffled is an independent on-policy run with **permuted pairing**, not
`−3` on gold φ and not a post-hoc permutation of the enabled stream.

## Metrics (formulas frozen; values filled after XSim)

| Name | Formula |
|------|---------|
| `en_e1_c` / `fr_c` / `sh_c` | count seeds hold p0==gold (en / frozen / shuffle) |
| `en_e2_c` / `en_rl_c` | count seeds hold gold after epoch-2 / after reload |
| `pid_c` | count seeds dest-keyed pid pick equals hold gold |
| `phi_neq_c` | count seeds train-gold φ ≠ hold-gold φ |
| `sel_acc_en` | en_e1_c / n_ANSWER_en_hold |
| `coverage_rank` | n_ANSWER / n_rank_queries |
| `unrel_unknown` | 1 iff UNREL status=UNKNOWN npath=0 |
| `ret_drop_count` | en_e1_c − en_rl_c (descriptive counts only) |

No Wilson / paired CI printed as Master confirmation.

## Out of scope

Master F3 confirmation. LM06. BOARD. MIG/DDR production retrieval. 3-hop.
Power-loss journal. Patching live F2R2–F2R5 or F3 plumbing DUT.

`load_from_tb_o=0`.
