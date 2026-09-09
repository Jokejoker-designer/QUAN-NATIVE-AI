# PREREG — ASTRA-07 HELD-OUT-TRANSFER

Frozen **before** hold metrics. Do not retarget 10pp. Do not reuse train x as test x.

```text
GATE        = ASTRA-07-HELD-OUT-TRANSFER
LAST        = ASTRA-06 PASS_NARROW
LAW         = native-rank-sgd-q8-v1
SHIFT       = 6
RTL         = rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv  (REUSE, no law edit)
BIT         = NO
PROGRAM     = NO
COM12       = UNTOUCHED
EVIDENCE    = HOST_MODEL (bit-exact twin, all seeds) + XSIM (compact fixture, seed 0xA701)
```

## Primary unknown

Do trained **shared** 32-weights beat frozen and shuffled-reward on **held-out**
feature vectors / worlds (different entity IDs, same feature-structure generator)?

ASTRA-06 proved unit SGD on constant `x[i]=64` (frozen v=0, enabled v=688,
shuffle v=48). Repeating that x on "test" is cheating. This gate forbids it.

## Frozen seeds (archive all)

```text
SEEDS = [0xA701, 0xA702, 0xA703, 0xA704, 0xA705]
XSIM_SEED = 0xA701
```

World RNG = `random.Random(seed)`.
Epsilon LCG = `s := seed XOR 0x9E3779B9`; `s := s*1664525+1013904223` (uint32).
Shuffle-reward label RNG = `random.Random(seed XOR 0xC0FFEE01)` (permutes
each train query's K-vector of rewards). Shuffle epsilon LCG seed
`seed XOR 0x51ED51ED`.

## Frozen world law

Two worlds per seed, **disjoint entity ID ranges**, same generator:

| World   | ID range           | Queries | Candidates/query |
|---------|--------------------|--------:|-----------------:|
| W_train | `0x0100 .. 0x2FFF` |      24 |                8 |
| W_hold  | `0x4000 .. 0x6FFF` |      24 |                8 |
| W_miss  | hold IDs, hop-2 gold edge **deleted** | 8 (first 8 hold queries) | 7 (gold path absent) |

K=8 path kinds extracted from that world's edges (never synthesized missing edges):

| idx kind   | path                         | why not gold                         |
|------------|------------------------------|--------------------------------------|
| 0 gold     | S -REQ+t-> M -REQ+t-> O      | unique complete 2-hop for query S    |
| 1 rev2     | O -REQ+t-> M2 -REQ+t-> S     | reverse; subject mismatch            |
| 2 h1       | S -REQ+t-> M                 | length 1                             |
| 3 wrongrel | S -REQ+t-> M -CONN+t-> X     | hop2 relation ≠ query rel            |
| 4 neg      | S -REQ+t-> M -REQ-t-> Z      | negative polarity hop2               |
| 5 unrel    | A -REQ+t-> B -REQ+t-> C      | different subject (other chain)      |
| 6 dead     | S -REQ+t-> M3                | 1-hop dead-end                       |
| 7 rev1     | O -REQ+t-> M2                | reverse 1-hop                        |

Candidate **order is shuffled** per query (`Random(seed ^ 0xA55A0000 ^ qid)`).
Gold is **not** glued at index 0 (frozen argmax-of-zeros would otherwise cheat).

Relation/type constants (not exam-entity one-hots):

```text
REL_REQ=0x21  REL_CONN=0x31
TYP_PROC=1 TYP_STATE=2 TYP_CALIB=3 TYP_NOISE=4
CTX_GOLD=1 CTX_NOISE=2
CONF_GOLD=96 CONF_NOISE=24
GEN_GOLD=16 GEN_NOISE=4
```

Labels/rewards: `+3` iff selected path is the gold 2-hop support **in that world**,
else `-3`. Reward cannot create an absent edge.

## Frozen feature law — phi(q,path) signed8[32]

Allowed families only (DESIGN_CANDIDATE §5.1). **FORBIDDEN** in shared w:
query ID value, answer ID value, raw nid, one-hot of any exam entity.

Boolean flags use `{0,127}`. Interactions are `(a*b)>>7`.

| i  | name              | definition |
|----|-------------------|------------|
| 0  | subj_match        | path.start == query.s |
| 1  | rel_match         | every hop.rel == query.r |
| 2  | obj_unbound       | 127 (this exam never binds object) |
| 3  | mid_not_subj      | hop2 and mid != query.s |
| 4  | type_subj_ok      | type(start) compatible as REQ/CONN subject |
| 5  | type_mid_ok       | hop2 and type(mid) compatible as REQ object and subject |
| 6  | type_obj_ok       | type(end) compatible as REQ/CONN object |
| 7  | type_all_ok       | F4 and (hop1? F6 : F5 and F6) |
| 8  | context_match     | path.ctx == query.ctx |
| 9  | context_nz        | path.ctx != 0 |
| 10 | src_conf_mean     | mean edge confidence 0..127 |
| 11 | pos_support       | all edges polarity + |
| 12 | neg_support       | any edge polarity − |
| 13 | mixed_polarity    | mix of + and − |
| 14 | path_len_1        | n_hops==1 |
| 15 | path_len_2        | n_hops==2 |
| 16 | valid_edge_frac   | 0/64/127 for 0/1/2 edges present in **this** world |
| 17 | both_edges_valid  | hop2 and both edges present |
| 18 | trans_ok          | all edges transitive |
| 19 | contradiction     | neg_support and (subj_match and rel_match) |
| 20 | cycle_flag        | path.end == path.start |
| 21 | reverse_dir       | path.end == query.s and path.start != query.s |
| 22 | freshness         | min(127, 8 * min edge.gen) |
| 23 | rel_x_ctx         | (F1 * F8) >> 7 |
| 24 | subj_x_rel        | (F0 * F1) >> 7 |
| 25 | type_x_rel        | (F7 * F1) >> 7 |
| 26 | hop2_x_valid      | (F15 * F17) >> 7 |
| 27 | hop2_x_rel_x_subj | ((F15 * F1) >> 7 * F0) >> 7 |
| 28 | pos_x_noconflict  | (F11 * (F19?0:127)) >> 7 |
| 29 | conf_x_valid      | (F10 * F16) >> 7 |
| 30 | neg_or_reverse    | F12 or F21 |
| 31 | complete_proof    | F0,F1,F7,F11,F15,F17,F18 and not F12,F19,F20,F21 |

Per-ID prior is a **separate** table keyed by answer entity ID, trained on
W_train gold IDs (`prior[gold_o] += 3`, `prior[other_o] -= 3`). Not mixed
into shared w. Point of the ablation: IDs differ ⇒ prior must **fail transfer**.

## Frozen train / eval protocol

```text
EPOCHS          = 8
EPS_INV         = 16          # TRAIN epsilon ≈ 1/16; EXAM epsilon = 0
TIE_BREAK       = lowest candidate index
UPDATE          = selected path only (reward-only bandit; no pairwise PA)
EVAL            = greedy argmax v_q8, no update
```

Controls on the **same** held-out set:

1. **enabled** — train shared w on W_train, eval W_hold
2. **frozen** — zero-weight / no-update
3. **shuffled** — independent on-policy run on W_train; each query's
   reward vector (one +3, seven −3) is permuted so +3 is **not** bound
   to the gold path. Same epsilon/update law. (Post-hoc permutation of
   an already gold-selected enabled stream is degenerate and is not used.)
4. **per-ID** — identity table from W_train IDs only

Missing-fact: gold hop-2 edge absent in W_miss. Ranker may score leftovers.
Decision layer emits **ANSWER** only if a candidate is a valid 2-hop proof
in **that** world. Else **UNKNOWN**. Reward history of W_train must not
invent the missing edge.

## Pass criteria (do not lower)

Classification (primary):

- ≥5 seeds archived
- held-out gain vs frozen **and** vs shuffled: mean ≥ **10 percentage points**
- paired integer analogue `enabled_hold_correct - control_hold_correct`
  reported for every seed; paired-gain CI lower bound **> 0** (mean − 1.96·SEM)
- enabled beats frozen **and** shuffled on hold for **every** seed (counts)
- retention drop on W_train ≤ **5 pp** (best-epoch greedy train acc − final)
- W_miss: `answer_emitted = 0` (no hallucination)
- per-ID hold gain vs frozen < 10 pp (fails transfer); per-ID **does** beat
  frozen on W_train (memorizes IDs)
- train vs hold entity-ID intersection = ∅
- twin bit-exact vs ASTRA-06 unit: frozen 0 / enabled 688 / shuffle 48
- XSim compact fixture bit-exact vs host on seed 0xA701 hold v_q8

If classification 10 pp fails but every seed has integer score-gain
`(v_gold - max v_distractor) > 0` on hold vs both controls: **PASS_NARROW**.
If enabled does not beat frozen **and** shuffled on held-out: **FAIL**.
Do not retarget 10 pp. Do not reuse train x.

## Not claimed even on PASS

Open-world causality, generalized learning beyond this feature family,
DDR 800k, LM, Gate14, board, silicon.

## Twin / XSim

Host twin of `a7ng_shared_rank_sgd_q8` is bit-exact (same RSH, sat16, SHIFT=6).
XSim reuses the ASTRA-06 RTL module (no law change). Compact fixture = seed
0xA701 train stream + hold scores + one miss query. Not 800k.
