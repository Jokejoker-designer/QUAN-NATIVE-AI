# PREREG — ASTRA-F3-R3-SAMPLED-WORLDS-01

Frozen **before xvlog**. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5,
ASTRA-F3-SHARED-TRANSFER-01, or ASTRA-F3-R2-INDEPENDENT-WORLDS-01
bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`, `a7ng_astra_f3_shared_xfer.sv`,
`a7ng_astra_f3r2_ind_worlds.sv`).
Does not rerun those bags' run scripts.

## Claim this revision may close

**PASS_NARROW plumbing only** for auditor 20260906T0815Z residuals 1–4 and 6
on a **new** named bag. On a sampled held-out protocol (shared+private facts,
overlapping IDs allowed), FPGA shared non-ID weights beat no-update and a
shuffle that mislabels the transferred overlapping features — with accuracy,
coverage, UNKNOWN, and 32-φ dumps on the log.

Does **not** close Master F3 (10pp / paired CI / retention), LM06, BOARD,
ASTRA-13, persistence/DDR, or power-loss journal.

## One unknown

On a sampled held-out protocol (shared+private facts, overlapping IDs
allowed), do FPGA shared non-ID weights beat no-update and a shuffle that
mislabels the transferred overlapping features — with accuracy, coverage,
UNKNOWN, and uncertainty frozen before xvlog?

## Master transfer numbers — not claimed

Master §8: gain ≥10pp vs no-update, paired CI lower bound >0, retention drop
≤5pp, shuffled and per-ID controls.

This bag **will not claim those numbers**. Frozen here (not after scores):

1. Unit of analysis is a **compact sampled TB-AXI protocol**: N_worlds=5,
   N_hold_q=8, N_epoch=2. This is **not** ASTRA-07 (24 queries × 8 epochs ×
   5 seeds). ASTRA-07 scale is **not** run and is **not** claimed.
2. n=8 hold queries on designed templates drawn by a frozen generator is
   not Master confirmation. **Do not print Wilson or paired CI on these
   hold queries as Master confirmation.**
3. Corpus is TB-planted postings, not production MIG/DDR.
4. Two epochs + register reload is not a population retention curve.

Do **not** lower Master 10pp after seeing scores. Do not relabel this bag
Master F3 closed.

## Frozen generator (sample, not hop/ctx tweaks of one query)

```text
GEN_SEED          = 0xA5F33001
N_WORLDS          = 5
N_SHARED_FACTS    = 3
N_PRIVATE_FACTS   = 2
N_TRAIN_Q         = 8
N_HOLD_Q          = 8
N_EPOCH           = 2
OVERLAP_HOLD_Q    = {6, 7}
TRANSFER_F        = mixed_ctx (phi[12]); S3-style shuffle
```

World catalog — **distinct subject-relation**, all `ctx=indirect` (2-hop).
Not a hop/ctx intervention on one query (auditor 0815Z hunt 2 / residual 1).

| W | Query | subj | rel | k0=(subj<<8)\|rel | k2 |
|---|-------|-----:|----:|------------------:|---:|
| 0 | `pump requires indirect` | 10 | 2 | 2562 | 766 |
| 1 | `valve requires indirect` | 11 | 2 | 2818 | 1361 |
| 2 | `chiller requires indirect` | 1 | 2 | 258 | 4408 |
| 3 | `ahu connects indirect` | 6 | 3 | 1539 | 289 |
| 4 | `tower requires indirect` | 9 | 2 | 2306 | 1372 |

Frozen sample (generator output of seed `0xA5F33001`; not retargeted):

```text
TR_W = [0,1,2,3,4,0,1,2]
HO_W = [4,3,0,1,2,4,3,1]
```

Paired train[i] world ≠ hold[i] world for all i.

Every world plant contains:

- **SF0 (shared complete):** 2-hop to shared dest `0x40` when that path is
  the labeled gold/overlap path; otherwise present as hop-1 stub.
- **SF1, SF2 (shared stubs):** hop-1 only, mids `0x50` / `0x51` (in every
  world; do not complete 2-hop).
- **PF0, PF1 (private):** hop-1 dead-ends, dests `0xA0+2W` / `0xA1+2W`.

Hold queries 0–5: gold dest `0x70+q` (held-out IDs; per-ID cannot win).
Hold queries 6–7: gold dest `0x40` (overlapping shared dest; per-ID can win).
Train gold dest is always shared `0x40`.

## Plumbing pass (frozen; do not retarget)

- ISO +3, x0=50 → dw0=+5 on isolated frozen SGD (not DUT weights).
- `load_from_tb_o=0`. Queries are tokens.
- 5 distinct subject-relation worlds; 8 hold queries; 2 epochs.
- **Enabled stream:** one FPGA `go_upd` +3 on each of 8 train gold actions
  (min p0 at w=0 selects gold). Then 8 hold queries must pick hold gold.
- **No-update:** rst, 8 hold queries. w=0 min p0 = hold dist.
- **Shuffled:** independent stream; +3 on the train **distractor** action
  whose φ **has mixed_ctx** (overlapping transferable feature gets the
  wrong label; S3-style). Not `−3` on gold. Not +3 on a distractor that
  lacks mixed_ctx. Shuffle hold plants mixed_ctx on dist, not gold.
  Hold must **not** pick gold.
- **Per-ID:** dest-keyed table `pid[ans]+=3` on enabled train picks;
  scored on hold dests. Overlap queries (6,7) dest=`0x40` — per-ID **can
  win**. Disjoint dest queries (0–5) — per-ID must not pick gold (tie →
  min p0 = dist). Keep per-ID off shared `w` (no eid in φ).
- **Retention:** held-out after a **second** train epoch (no rst) and after
  **reload** (snapshot `w_o`, `rst_n`, `load_v_i` restore, hold queries).
- **32-φ dump:** each train-gold and hold-gold prints all 32 signed bytes
  and a hash on the xsim log (not TB-internal only). `PHI_NEQ` requires
  train-gold φ ≠ hold-gold φ per paired query (hold mixed 3/1 vs train
  mixed 1/0: ctx_nz / obj_ctx differ; mixed_ctx shared).
- Unrelated `payroll tax form` → UNKNOWN, npath=0, ans=0, p0=0.
  After that rst, `wdut[0]===0`.
- Coverage on ranking queries: all ANSWER. Selective accuracy =
  `n_gold_pick / n_ANSWER` per arm, reported separately.
- If enabled hold (epoch-1) does not beat both no-update and shuffle on
  all 8 hold queries: **FAIL**. Do not drop a query or flip gold after scores.

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
t2=0, p2=p1, hop2=0). Flags are `{0,64}`. This bag's queries are 2-hop.

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

## Protocol

1. **frozen / no-update:** rst; for q=0..7 plant HOLD, query. Expect dist p0.
2. **enabled epoch-1:** rst; for q=0..7 plant TRAIN, query, expect gold p0,
   `pid[ans]+=3`, pulse +3, retire; then for q=0..7 plant HOLD, expect gold
   p0; dump 32-φ + hash; `PHI_NEQ` vs that index's train gold φ; score per-ID.
3. **enabled epoch-2:** no rst; 8 train +3; 8 hold expect gold.
4. **reload:** snapshot `w_o`; rst; `load_v_i` restore 32 weights; 8 hold
   expect gold.
5. **shuffled:** rst; 8 shuffle-train (dist has mixed_ctx, min p0 = dist),
   +3 on that action; 8 shuffle-hold (dist has mixed_ctx, gold lacks it);
   expect **not** gold.

Shuffled is an independent on-policy stream with **permuted φ→reward**
on the overlapping feature, not `−3` on gold φ.

## Metrics (formulas frozen; values filled after XSim)

| Name | Formula |
|------|---------|
| `en_e1_c` / `fr_c` / `sh_c` | count hold q p0==gold (en / frozen / shuffle) |
| `en_e2_c` / `en_rl_c` | count hold gold after epoch-2 / after reload |
| `pid_ov_c` | count overlap hold q dest-keyed pid pick equals hold gold |
| `pid_dj_c` | count disjoint hold q dest-keyed pid pick equals hold gold |
| `phi_neq_c` | count paired train-gold φ ≠ hold-gold φ |
| `sel_acc_en` | en_e1_c / n_ANSWER_en_hold |
| `coverage_rank` | n_ANSWER / n_rank_queries |
| `unrel_unknown` | 1 iff UNREL status=UNKNOWN npath=0 |
| `ret_drop_count` | en_e1_c − en_rl_c (descriptive counts only) |

No Wilson / paired CI printed as Master confirmation.

## Out of scope

Master F3 confirmation. LM06. BOARD. MIG/DDR production retrieval. 3-hop.
Power-loss journal. Patching live F2R2–F2R5, F3 plumbing DUT, or F3R2 DUT.
ASTRA-07 24×8 host twin.

`load_from_tb_o=0`.
