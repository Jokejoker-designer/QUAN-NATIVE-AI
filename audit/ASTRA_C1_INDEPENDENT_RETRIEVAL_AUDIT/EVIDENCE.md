# Independent evidence — C1 retrieval P0/P1/P2

**Date:** 2026-09-07  
**Folder:** `D:/FPGA/ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT`  
**Grok CWD not written.** Read-only sources listed below.  
**Command:** `python scripts/recompute_cap_and_bytes.py` exit 0 → `results/recompute.json`

Classification: **FACT** unless marked otherwise.

---

## Isolation

- Did not edit `rtl/`, `ASTRA-C1-*` bags, or `LOOP_STATE.json`.
- User rar `A7-NATIVE-GRAPH(1).rar` was **not found** under `D:\FPGA` in this session.
- Live clone **does** contain `ASTRA-C1-N4096-INTERSECT-01` including `xsim.log` (session 10:47:58–10:48:02, PID 29188). That log is used as **observed evidence**, not as a closeout we authored.

---

## P0-1 Cap-before-AND — CONFIRMED

### Mechanism (FACT)

Host `host_astra_c1_key_intersect.py` `walk_one_table()` stops appending at `CAND_CAP=16`, then `route()` intersects those prefixes.

RTL `a7ng_query_axi_sparse_intersect.sv` fills `buf0`/`buf1` only while `n0/n1 < CAND_CAP`, then `S_SCAN` ANDs the buffers. Frozen walker `a7ng_sparse_dir_axi.sv` also stops overflow AR when `nemit >= CAND_CAP`.

This is:

```text
first_16(k0) ∩ first_16(k1)
```

not:

```text
first_16( complete(k0) ∩ complete(k1) )
```

### N=256 independent recompute

| Class | occ | full ∩ | cap-then-∩ | ∩-then-cap | operators equal | gold in cap-then |
|-------|-----|--------|------------|------------|-----------------|------------------|
| direct | 6,9 | 3 | 3 | 3 | yes | yes (indices 2/4/5) |
| wrong_relation | 4,28 | 1 | 1 | 1 | yes | yes |
| high_occupancy | 25,28 | **21** | **12** | **16** | **NO** | yes (gold at p0[4], p1[4]) |
| high_id_sentinel | 10,9 | 1 | 1 | 1 | yes | yes |

**FACT:** even at N=256, high_occupancy already proves the two operators differ (12 vs 16). Gold 147 sits at index 4 — **PASS by ordering**, not by operator identity.

xsim N=256: `CLASS_wrong_relation … trunc=12 occ=28`, `CLASS_high_occupancy … trunc=21 occ=28`. Matches.

### N=4096 live log + recompute (observed, not our bag)

| Class | occ | full ∩ | cap-then-∩ | ∩-then-cap | gold in cap-then |
|-------|-----|--------|------------|------------|------------------|
| high_occupancy | 159,147 | 49 | 6 | 16 | yes (still early) |
| high_id_sentinel | 104,110 | **1** | **0** | **1** | **NO** |

Gold nid 4095 is at **p0[103] and p1[109]**, both `> 15`.

Live `xsim.log`:

```text
SEARCH_INCOMPLETE class=high_id_sentinel missed=1 trunc=182 ovf=1
CLASS_high_id_sentinel … emit_n=0 rec_x1000=0 incomp=1
ASTRA_C1_N4096_INTERSECT_XSIM_PASS
```

**FACT:** TB PASS gate (`fail==0 && leak_n==0 && direct_tp>0`) **does not require** sentinel recall. SEARCH_INCOMPLETE is logged, not failed. That is a **promotion hole**, not a twin mismatch (`CANDIDATE_ID_MISMATCH` did not fire — RTL matched the defective host model).

**INFERENCE:** N=4096 is not “fail vì X” as a Grok closeout (we did not wait for RESULTS.md). Independently, the **pre-cap defect already produced a missed gold that full-AND would have kept**.

---

## P0-2 Byte accounting — CONFIRMED

### Mechanism (FACT)

TB/host: `post_bytes = n_post * 16` where `n_post` is **AR count** (`n_post_ar_o` increments once per `S_ARPOST`).

RTL `arlen_post = ceil(post_count/4)-1`. One AR can carry many R beats. `S_DRAIN` still accepts leftover beats after CAND_CAP.

### Independent beat model vs reported

Head page `INDEX_HEAD=4` (1 beat) + overflow `ceil((occ-4)/4)` + 2 directory beats.

| Bag | Class | reported B | model R-beats×16 | undercount |
|-----|-------|------------|------------------|------------|
| N256 | direct occ 6,9 | 96 | 112 | 1.167× |
| N256 | wrong_relation 4,28 | **80** | **160** | **2.0×** |
| N256 | high_occupancy 25,28 | **96** | **256** | **2.667×** |
| N4096 | wrong_relation 111,147 | 96 | 1072 | 11.2× |
| N4096 | high_occupancy 159,147 | 96 | 1264 | 13.2× |
| N4096 | high_id_sentinel 104,110 | 96 | 896 | 9.3× |

N256 numbers match the user’s 80→160 and 96→256. Direct is 96 vs 112 (not 2.67×).

**FACT:** `DDR_QUERY_BOUND_FINAL` must not be frozen from current `dirB/postB`. Candidate IDs of N=256 remain useful.

Model is **INFERENCE** of R-beats (from occupancy + INDEX_HEAD + drain), not a counted `rvalid&&rready` trace. Direction and magnitude are robust; exact beat counts need the P0-2 bag.

---

## P1 Context — CONFIRMED (law property)

Extract: `k0={subj,rel} k1={obj,rel}`; `ctx_id_o` exists; **not** a directory key. xsim `NOT_SELECTIVE … xid_not_directory_key`. N=256 wrong_context prec=333, emit identical to direct `{110,144,145}` vs gold `{144}`.

Do not mix into the N=4096 bag or into C0.

---

## P1 Overflow cost — SUPPORTED as architecture risk

N=256 `overflow_buckets=90` with INDEX_HEAD=4. N=4096 live: emit 1–6 while trunc 182–274 and model bytes ~1 KiB/query vs reported 96 B.

Bounded **candidates** ≠ bounded **DDR bytes**.

---

## P1 prec_ev1 — CONFIRMED metric hazard

N=256 hoc: prec_ev1=1000, prec_all=83, 11 fillers. N=4096 hoc: prec_ev1=1000, prec_all=166, 5 fillers. Fillers still occupy slots and beats.

---

## P2 12-bit bucket — LATENT, not firing yet

`bucket = k_use[11:0]`, `N_BUCKETS=4096`. `k0={subj[7:0],rel[7:0]}` so bits[15:12]=subj[7:4] are **dropped**. Collision when `subj_id >= 16` with same rel.

Both corpora: **12 subject IDs, max 12**. `bucket_drops_high_nibble=false` on tested keys. Hazard is real at 800k/1M entity namespace; **not** the N=4096 sentinel miss.

---

## P2 Dataset — CONFIRMED evidence gap

N=256 and N=4096 both use **12 entities / 3 relations** plus synthetic occupancy clones. Scale stress ≠ semantic 800k.

---

## Native core scope

No evidence here that parser role-binding, 2-hop reasoner, or silicon SGD is the C1 failure mode. Defects sit in **keys / directory / posting walk / intersect scheduler / AR-vs-R accounting**.
