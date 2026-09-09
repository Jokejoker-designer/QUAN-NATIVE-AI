# PREREG — ASTRA-F2R-SHARED-RANK-PENDING-01

Frozen before xvlog. PROGRAM=NO. No board.

## Law `rank-sgd-q8-v1-f2r` (copy of sequential v1, new module name)

SHIFT=6. v = sat16(acc>>>7). err = sat16(rew*256 - v). dw[i] = sat16((err*x[i])>>>(7+SHIFT)).
Source copied from `a7ng_shared_rank_sgd_q8_v1.sv` live SHA `01ef40079f1407c1067ed98a6e1b0a4b0e8d0b6911f21afb0542e43728a73c24`. Not DSP tfix. Original file not patched.

One-hot control (x[0]=64, w=0, rew=-3): dw[0]=-6, others 0. (64>>>2 not used here; 64*err>>>13: (-768*64)>>13=-6.)

## Descriptor `rtp-desc-v1-f2r` (128-bit)

R2 fields plus `src_conf[91:84]` planted in static corpus (not from exam gold).
phi[0] = min(conf_h1,conf_h2)>>2  (0..63) — source quality
phi[1] = 64 iff both trans
phi[2] = 64 iff both pol
phi[3] = 64 iff both schema_ver==1
phi[4] = 64 iff both rel==query.rel
No query/answer/entity ID, no proof index, no class-byte, no gold.

## Corpus (two legal 2-hops, same conclusion 4)

Train: 10-1-4 eids 17,34 conf=200,200; 10-8-4 eids 18,35 conf=8,8. Query `pump requires indirect`.
x_hi=50, x_lo=2.

Oracle w=0: v=0,0 tie-break lower p0 → 17 (high-conf).
rew=-3 on pending txn: dw0=-5. Next v_hi=-2 v_lo=-1 → select 18.
rew=+3: dw0=+4; v_hi=1 v_lo=0 → stay 17.
SHUF=+3 when switch needed: no switch.
freeze_i=1: no dw.
validity-only ctrl=2: phi[5]=64 both, freeze, no switch (real scorer).

Held-out: same structure, eids XOR seed. Seeds 0xA701..0xA705 after one train on 0xA701 plant. Claim at most PASS_NARROW plumbing+5-world structural; Master F3 transfer remains open if coverage incomplete.

## Pending txn

{txn_id[7:0], gen, p0,p1,ans, phi[32], v_pred, accepted, committed}
Reward bus: {txn_id, reward[-3,+3]}.
Accept: HOLD sets accepted, !committed.
Commit: matching txn && accepted && !committed → one SGD upd, committed=1.
Dup same txn: n_dup++, no dw.
Wrong txn: n_bad++, no dw.
Bus mutate after HOLD cannot change pend_phi.
retire_i discards uncommitted pending.

## RTP negatives on THIS path

POST_DROP, DESC_SWAP, HIGH_ID, EID_MISMATCH, AXI_BAD_RID, AR_STALL, LATE_R, OVF, NEG, AMB, ANSWER then UNREL no reset (no stale proof).
