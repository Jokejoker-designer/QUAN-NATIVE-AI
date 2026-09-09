# PREREG — ASTRA-F2R-R3-SEMANTIC-GUARD-01

Frozen before xvlog. PROGRAM=NO. No board.
Does not edit `ASTRA-F2R-SHARED-RANK-PENDING-01` or `ASTRA-F2R-R2-PENDING-HANDSHAKE-LAW`.
Does not patch `a7ng_astra_f2r2_hs_law.sv` or `a7ng_shared_rank_sgd_q8_sym_f2r2.sv`.

## Claim this revision may close

F2R_ACCEPTANCE item **4** only: latch/use query object and context; proof legality independent of score; declared conflict/ambiguity/incomplete before selection; wrong-object, direct-vs-indirect, opposing polarity/context, fifth legal path.

F2R2 smoke/handshake/UNREL and ISO +3,x0=50 → dw0=+5 remain regressions in this DUT.

Does **not** close item 5 (post-timeout AXI), F3 transfer, LM06, SoC/timing, BOARD_PASS.

## One unknown

Can the FPGA refuse to rank away contradiction, honor query object/context/polarity, distinguish direct vs 2-hop, and declare incomplete when a fifth legal path exists — without using IDs/gold as features and without breaking F2R2 handshake/law regressions?

## Law `native-rank-sgd-q8-v1-sym-f2r2` (instantiated, not copied)

Same Master + DESIGN_CANDIDATE §5.2 law as F2R2. SHIFT=6. Sequential 1-MAC.

```text
acc     = signed40(sum_i w_i * x_i)
v_q8    = clamp(RSH(acc, 7), -768, +768)
target  = reward * 256                 # reward in [-3,+3]
error   = clamp(target - v_q8, -1536, +1536)
w_next  = sat16(w + RSH(error * x, 7 + SHIFT))
RSH(v,s)= sign(v) * floor((abs(v) + 2^(s-1)) / 2^s)
```

ISO: +3, x0=50, w=0 → dw0=+5 (floor-shift contrast +4). Instantiates frozen `a7ng_shared_rank_sgd_q8_sym_f2r2`.

## Query latch

On `qse_valid`, latch `{subj, obj, rel, ctx}` from LAW_SEL=1 role extract. Use all four in legality.

- `r_two` iff `ctx == CTX_INDIRECT (2)`
- `r_obj_v` iff `obj != 0`
- `r_dom` iff `ctx != 0 && ctx != CTX_INDIRECT` (domain context, e.g. water=1)

## Descriptor `rtp-desc-v1-f2r3`

128-bit fact (same geometry as F2R2 plus ctx byte):

```text
src[19:0], obj[39:20], rel[47:40], eid[67:48],
trans[68], pol[69], valid[70], ver[75:72]=1,
fact_ctx[83:76], src_conf[91:84]
```

pol=1 allows; pol=0 forbids. Smoke plants fact_ctx=0.

## Path legality (independent of score)

`requires` contract for this bag: **unique conclusion** for ANSWER. Ranker may order same-conclusion legal positive proofs only **after** policy.

**Direct** (`!r_two`): 1-hop only. `src==subj`, `rel==query.rel`, dest≠subj; if `r_obj_v` dest==query.obj; if `r_dom` fact_ctx==query.ctx. trans not required.

**Indirect** (`r_two`): 2-hop only. Both hops trans=1, `rel` match, hop1.src==subj, hop2.src==hop1.obj, hop2.dest≠subj; if `r_obj_v` hop2.dest==query.obj; if `r_dom` both fact_ctx==query.ctx.

Positive legal path: all used hops pol=1.
Negative evidence: structural match with some pol=0.

Not legal: 2-hop under a direct query; 1-hop under an indirect query; object mismatch; domain-context mismatch.

## Policy before selection (S_GUARD)

After enumerating **all** retrieved facts (not stopping at four):

| Condition | status | select? | pending? |
|-----------|--------|---------|----------|
| parser amb | 7 AMB | no | no |
| parser neg | 8 NEG | no | no |
| AXI/walk overflow | 6 INCOMP | no | no |
| n_legal > MAX_PATH(4) | 6 INCOMP | no | no |
| ≥2 distinct positive dests | 5 CONFLICT | no | no |
| positive dest D and negative evidence for D | 5 CONFLICT | no | no |
| n_legal==0 | 1 UNKNOWN | no | no |
| else unique dest, n_legal in 1..4 | 0 ANSWER | yes, score slots | yes |

INCOMP wins over CONFLICT if both (search incomplete). Fifth legal path must not appear as ANSWER with n_path=4.

`n_path_o` reports `n_legal` (5-bit, cap 31), including the fifth, not the stored-slot cap.

## Phi (not IDs)

Same as F2R2 for scored slots:

- phi[0] = min(conf_h1, conf_h2)>>2  (1-hop: conf>>2)
- phi[1]=64 iff both hops trans (1-hop: 0)
- phi[2]=64 iff used hops pol=1
- phi[3]=64 schema ver==1
- phi[4]=64 iff rel==query.rel
- else 0

No query/answer/entity ID, proof index, class-byte, or gold in phi.

## Handshake / pending (F2R2 regression)

Unchanged: gen+txn on PICK, latch reward on valid cycle, bus invert ignored, freeze/dup/stale/oor/retire-drain. No pending on non-ANSWER.

## Corpus / tests (static TB)

| Tag | Query | Plant | Expect |
|-----|-------|-------|--------|
| SMOKE | `pump requires indirect` | two 2-hops dest compressor(4) | ANSWER npath=2 p0=17 ans=4 phi0=50 tbl=0; HS latch |
| WRONG_OBJ | `pump requires indirect valve` | same 2-hops dest 4 | UNKNOWN ans=0 not 4; obj_o=11 ctx_o=2 |
| DIR_NO_STEAL | `pump requires compressor` | 2-hop only dest 4 | UNKNOWN (must not use 2-hop) |
| IND_USE_2HOP | `pump requires indirect compressor` | 2-hop dest 4 | ANSWER ans=4 |
| DIR_1HOP | `pump requires chiller` | 1-hop pump→chiller trans=0 | ANSWER ans=1 p1=0 |
| IND_NO_1HOP | `pump requires indirect chiller` | 1-hop only | UNKNOWN |
| POLARITY | `pump requires indirect` | pos 2-hop dest 4 + pol=0 2-hop dest 4 | CONFLICT ans=0 |
| CONTEXT | `pump requires water` | 1-hop valve fctx=2 conf 200 + 1-hop chiller fctx=1 conf 8 | ANSWER ans=1 (not 11, not CONFLICT) |
| FIFTH | `pump requires indirect` | five 2-hops dest 4 | INCOMP npath>=5 ans=0 |
| CONFLICT_DEST | `pump requires indirect` | dest 4 and dest 7, w0=-16 | CONFLICT ans=0 (not rank 7) |
| UNREL | `payroll tax form` after ANSWER | — | UNKNOWN npath=0 ans=0 p0=0 |
| SLOT0..3 | `pump requires indirect` | four same-dest 2-hops | ANSWER npath=4 sel=slot |

ISO isolated SGD: +3×50 → +5; −3×64 → −6.

## Controls

Positive/negative/zero/freeze handshake; dup/wrong txn/stale gen/rew=-4; retire pending/drain. Descriptor mutation after PICK. `load_from_tb_o=0`.

## Out of scope

Item 5 LATE_R after TO_CYC, SLVERR, post-timeout drain. F3 multi-seed transfer. LM06. BOARD. Gen/txn wrap lifetime.
