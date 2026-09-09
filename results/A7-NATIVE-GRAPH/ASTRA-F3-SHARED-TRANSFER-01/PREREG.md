# PREREG — ASTRA-F3-SHARED-TRANSFER-01

Frozen **before xvlog**. PROGRAM=NO. No board.
Does not edit F2R-01 / F2R-R2 / F2R-R3 / F2R-R4 / F2R-R5 bags or frozen RTL
(`a7ng_astra_f2r2_hs_law.sv`, `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`,
`a7ng_astra_f2r3_sem_guard.sv`, `a7ng_astra_f2r4_axi_drain.sv`,
`a7ng_astra_f2r5_txn_wrap.sv`).
Does not rerun those bags' run scripts.

## Claim this revision may close

**PASS_NARROW plumbing only.** After one FPGA-owned reward update on each
train world, shared non-ID 32-φ improve held-out selection vs no-update and
vs shuffled-reward on 5 **structurally independent** seeds (not 5 ID-permutations
of one plant). UNKNOWN rejects an unrelated query. Accuracy, coverage, and
uncertainty are reported separately.

Does **not** close Master F3 (10pp / paired CI / retention), LM06, BOARD,
ASTRA-13, persistence/DDR, or power-loss journal.

## One unknown

After one (or few) FPGA-owned reward updates on train worlds, do shared
non-ID features improve held-out selection vs (a) no-update and (b)
shuffled-reward, on ≥5 independent seeds — not 5 ID-permutations of one plant?

## Master transfer numbers — not claimed

Master §8: gain ≥10pp vs no-update, paired CI lower bound >0, retention drop
≤5pp, shuffled and per-ID controls.

This bag **will not claim those numbers**, even if compact XSim counts look
large. Reasons frozen here (not after scores):

1. Unit of analysis is 5 **designed plants**, one update each — not a sampled
   world generator with 24 queries × 8 epochs (ASTRA-07 host twin protocol).
2. n=5 binary XSim TB-AXI is not Master confirmation; CI on designed plants
   is not a population interval.
3. Corpus is TB-planted postings, not production MIG/DDR.
4. Retention-over-epochs is not this protocol (one update; train re-query is
   a smoke, not an epoch curve).

Do **not** lower Master 10pp after seeing scores. Do not relabel this bag
Master F3 closed. Observed pp/CI may be printed as **descriptive** only.

## Plumbing pass (frozen; do not retarget)

- ISO +3, x0=50 → dw0=+5 on isolated frozen SGD (not DUT weights).
- `load_from_tb_o=0`. Queries are tokens.
- 5 seeds below are structurally different (query/role/context/mid/support
  /path-length). Hold IDs disjoint from that seed's train IDs.
- Per seed, **one** FPGA `go_upd` with true reward **+3** on the train gold
  (selected because train gold has the lower proof0; w=0 tie-break).
- **Enabled** hold: pick train-feature gold (higher proof0 than hold distractor).
- **No-update** hold: w=0, pick min proof0 = hold distractor, **not** gold.
- **Shuffled** hold: one FPGA update with **−3** on the same train gold
  features; hold must **not** pick gold.
- Unrelated query `payroll tax form` → status UNKNOWN, npath=0, ans=0, p0=0.
- Coverage on the 5×(train+hold) ranking queries: all ANSWER (not UNKNOWN).
- Selective accuracy reported as `n_gold_pick / n_ANSWER` per arm.
- If enabled does not beat both controls on all 5 seeds: **FAIL**.
  Do not drop a seed or flip gold after scores.

Per-ID is a **TB diagnostic**, not mixed into shared w. Keyed by answer
entity. Claimed only on seeds whose hold dest IDs are disjoint from train
(S0, S1, S3, S4). S2 is object-bound to vocabulary `compressor` (dest=4
train and hold) — per-ID N/A, not a transfer ablation.

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

Descriptor `rtp-desc-v1-f2r3`:

```text
src[19:0], obj[39:20], rel[47:40], eid[67:48],
trans[68], pol[69], valid[70], ver[75:72]=1,
fact_ctx[83:76], src_conf[91:84]
```

FORBIDDEN in shared w: query ID, answer ID, raw eid, gold bit, class-winner,
proof slot index, one-hot of exam entity.

1-hop scores copy hop1 into the hop2 slots of the function (c2=c1, ctx2=ctx1,
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

Tie-break at w=0: lowest proof0, then lowest proof1. Ranker argmax `v_q8`.

## Path legality (independent of score)

Parser latch `{subj, obj, rel, ctx}`. `r_two` iff `ctx==2` (indirect).
`r_obj_v` iff `obj!=0`. **No unique-dest CONFLICT** (ranking would be vacuous).
**No domain-ctx hard filter** (ctx is a feature).

- Direct (`!r_two`): 1-hop, src==subj, rel match, dest≠subj; if `r_obj_v` dest==obj; pol=1. trans not required.
- Indirect (`r_two`): 2-hop, both trans=1, both pol=1, rel match, hop1.src==subj, hop2.src==hop1.obj, hop2.dest≠subj; if `r_obj_v` hop2.dest==obj.

np==0 → UNKNOWN. np in 1..4 → ANSWER and score. np>4 → INCOMP (not used).

## Seeds (independent structure, frozen)

Not `eid XOR k` of one plant. Each seed changes query/role and/or mid/support
and/or context/path-length. Hold IDs in `0x1xx..0xCxx`; train IDs < 80.

| Seed | Query | Structure | Train gold p0 / dist p0 | Hold gold p0 / dist p0 | Discriminant φ |
|------|-------|-----------|-------------------------|------------------------|----------------|
| S0 | `pump requires indirect` | 2-hop same dest=4; quality 200 vs 8; mids 1 vs 8 | 17 / 18 | 0x211 / 0x111 | conf_min, conf_hi |
| S1 | `pump requires indirect` | 2-hop same dest=4; ctx 2 vs 1; mids 3 vs 9; equal conf | 40 / 42 | 0x411 / 0x311 | ctx_match, conf_x_ctx |
| S2 | `pump requires indirect compressor` | object-bound dest=4; hop2 ctx 3 vs 0; mids 12 vs 13 | 50 / 52 | 0x611 / 0x511 | obj_ctx_h2_nz |
| S3 | `pump requires indirect` | 2-hop dest=11; extra dead-end; mids 2 vs 6; quality | 60 / 62 | 0x811 / 0x711 | conf + dead-end support |
| S4 | `pump requires water` | **1-hop** domain ctx=1; dest 11 vs 8; ctx 1 vs 0 | 70 / 71 | 0xC10 / 0xC00 | ctx_match on 1-hop |

Train plants (src=10 pump, rel=2 requires). `fact_pack(s,o,r,e,conf,trans,pol,ctx)`:

```text
S0 train: (10,1,2,17,200,1,1,0) (1,4,2,34,200,1,1,0)
          (10,8,2,18,8,1,1,0)   (8,4,2,35,8,1,1,0)
S0 hold:  (10,0x20,2,0x111,8,1,1,0)   (0x20,0x40,2,0x122,8,1,1,0)
          (10,0x10,2,0x211,200,1,1,0) (0x10,0x40,2,0x222,200,1,1,0)

S1 train: (10,3,2,40,200,1,1,2) (3,4,2,41,200,1,1,2)
          (10,9,2,42,200,1,1,1) (9,4,2,43,200,1,1,1)
S1 hold:  (10,0x39,2,0x311,200,1,1,1) (0x39,0x40,2,0x322,200,1,1,1)
          (10,0x30,2,0x411,200,1,1,2) (0x30,0x40,2,0x422,200,1,1,2)

S2 train: (10,12,2,50,200,1,1,0) (12,4,2,51,200,1,1,3)
          (10,13,2,52,200,1,1,0) (13,4,2,53,200,1,1,0)
S2 hold:  (10,0x53,2,0x511,200,1,1,0) (0x53,4,2,0x522,200,1,1,0)
          (10,0x50,2,0x611,200,1,1,0) (0x50,4,2,0x622,200,1,1,3)

S3 train: (10,2,2,60,200,1,1,0) (2,11,2,61,200,1,1,0)
          (10,6,2,62,8,1,1,0)   (6,11,2,63,8,1,1,0)
          dead (10,5,2,64,200,1,1,0)  // no hop2
S3 hold:  (10,0x16,2,0x711,8,1,1,0)    (0x16,0xB0,2,0x722,8,1,1,0)
          (10,0x12,2,0x811,200,1,1,0)  (0x12,0xB0,2,0x822,200,1,1,0)
          dead (10,0x15,2,0x833,200,1,1,0)

S4 train: (10,11,2,70,200,0,1,1) (10,8,2,71,200,0,1,0)
S4 hold:  (10,0xC8,2,0xC00,200,0,1,0) (10,0xC1,2,0xC10,200,0,1,1)
```

Index keys for all `pump requires *` queries: dir(0,2562) and dir(2,766)
(same LAW_SEL=1 keys as F2R bags). live_epoch=7.

## Protocol per seed (three arms; rst between arms)

1. **frozen / no-update:** rst, plant HOLD, query, no reward. Expect dist p0.
2. **enabled:** rst, plant TRAIN, query, expect gold p0, pulse +3, wait n_upd,
   retire; plant HOLD, query, expect gold p0. Optional train re-query (retention smoke).
3. **shuffled:** rst, plant TRAIN, query, pulse −3 (reward not bound to gold),
   retire; plant HOLD, query, expect **not** gold p0.

Shuffled is an independent on-policy run, not a post-hoc permutation of the
enabled stream.

## Metrics (formulas frozen; values filled after XSim)

| Name | Formula |
|------|---------|
| `en_hold_n` / `fr_hold_n` / `sh_hold_n` | 5 |
| `en_hold_c` | count seeds enabled hold p0==gold |
| `fr_hold_c` | count seeds frozen hold p0==gold (expect 0) |
| `sh_hold_c` | count seeds shuffled hold p0==gold (expect 0) |
| `pid_hold_c` | TB per-ID on S0/S1/S3/S4 (expect 0) |
| `sel_acc_en` | en_hold_c / n_ANSWER_en_hold |
| `coverage_rank` | n_ANSWER / n_rank_queries |
| `unrel_unknown` | 1 iff UNREL status=UNKNOWN npath=0 |
| `gain_pp_vs_fr` | 100*(en_hold_c-fr_hold_c)/5  (descriptive) |
| `gain_pp_vs_sh` | 100*(en_hold_c-sh_hold_c)/5  (descriptive) |
| `paired_ci_lo` | mean(en-fr) − 1.96·SEM  (descriptive; not Master) |
| `retention_drop_pp` | 0 if train re-query still gold else 100 |

## Out of scope

Master F3 confirmation. LM06. BOARD. MIG/DDR production retrieval. 3-hop.
Power-loss journal. Host sess_id reuse. Patching live F2R2–F2R5.

`load_from_tb_o=0`.
