# RESULTS — ASTRA-C1-KEY-RELBIND-01

Authority = raw `xsim.log` CLASS_* / FAIL DISTRACTOR_LEAK / NOT_SELECTIVE /
UNRELATED_EMPTY_WALK. This file does not promote C1 800k, N=4096, or BOARD_PASS.

```text
GATE             = ASTRA-C1-KEY-RELBIND-01
N                = 256
CAND_CAP         = 16   (< 256; not CAND_CAP_FINAL)
LAW              = qse-v2-relbind-01
EXTRACT          = qse-v2-role-00 (frozen instantiate; hash cd7baf49… MATCH C0)
k2               = {rel_id, subj_cue[7:0]}   (direct k2=510; frozen cue was 766)
k3               = {rel_id, obj_cue[7:0]}    (direct k3=312; frozen cue was 4408)
k0,k1            = pass-through {subj,rel}/{obj,rel}  (2561 / 257)
PROGRAM          = NO
BIT              = NOT_BUILT
POKE_V           = 0
LEFTOVER_A09     = not compiled (xvlog units: pkg, role_extract, role_keys_relbind,
                   route_valid_gate, sparse_dir_axi, axi_mem_model,
                   query_axi_sparse_relbind, tb_astra_c1_key_relbind)
                   frozen a7ng_query_axi_sparse.sv NOT compiled as DUT
GOLD_PRE         = GOLD_HASH_PRE_XVLOG.txt  (09:48:35, before first xvlog 09:49:06)
GOLD_LIVE        = MATCH 0f1ba57a… / f8835b2e… / 4f981fd9…  (not rewritten after FAIL)
FAIL_R0          = xsim_fail_r0.log (copy of this xsim.log; DISTRACTOR_LEAK, not packing)
XSIM_MARKER      = ASTRA_C1_KEY_RELBIND_XSIM_PASS NOT emitted
                   ASTRA_C1_KEY_RELBIND_XSIM_NO_MARKER fail=1 dist_no_leak=0 direct_tp=3
SIM_TIME         = 17335 ns
PID              = 24464
SESSION          = Mon Sep 7 09:49:09–09:49:11 2026
REDUCTION_X1000  = NOT_EMITTED
C1_800K          = OPEN
N_4096           = NOT STARTED
BOARD_PASS       = NOT_CLAIMED
RESULT           = FAIL
```

Prior bags were not edited:
- KEEP `ASTRA-C1-N256-ROLE-RETRIEVAL-01` gold 08:31:44 hashes 414f9952 / 4b61d88f / 8c342aa2
- KEEP `ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01` gold 08:59:20 hashes e2091bac / 181958be / a089afda
- KEEP `ASTRA-C1-N256-R3-DISTRACTOR-01` gold 09:24:14 hashes 96f445a9 / a0d99311 / 0ce3bfff

Walker twin locked (no FIRST_DIVERGENCE / ROLE_COLLAPSE / CANDIDATE_ID_MISMATCH).
Gold was **not** regenerated after FAIL. Leak is the four-table union of the
**new** relbind keys still probing k0 (no object) and k1 (no subject).

C0 frozen hashes MATCH (not silently patched):
`cd7baf49` / `38189974` / `09334e42` / `5a4ad04d` / `49a66da2`.

## Unknown (this bag)

At N=256, new law `qse-v2-relbind-01` (`k2={rel_id,subj_cue[7:0]}`
`k3={rel_id,obj_cue[7:0]}`, k0/k1 unchanged), does CLASS_distractor
`leak_n=0` on R3 excluded gold while CLASS_direct still retrieves its gold ids?

Direct retrieve: **yes** (`tp=3` of gold `{110,144,145}`; `rec_x1000=1000`).

Wrong-relation exclusion via k2/k3: **partial** (R3 WR leaks 114 via cue-only k2
are gone; excluded `{114,118}` not in emit).

Entity-context exclusion (`leak_n=0`): **no** (`leak_n=9/11`). Gate requires
`leak_n=0` for `PASS_THIS_GATE_ONLY`. Therefore **RESULT=FAIL**.

## Per-class (authority = xsim.log)

Quality number is **precision** (`prec_ev1` excludes evidence=0 fillers).
Recall on 1–3 retrieve-class gold ids inside CAND_CAP is not the quality headline.
Direct `prec_ev1=250` is still k0∪k1 (WO+WE) union, not Master retrieval quality.

| class | gold_n | emit_n | tp | leak_n | fp_ev1 | fp_fill0 | prec_ev1 | prec_all | rec | notes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| direct | 3 | 12 | 3 | — | 9 | 0 | 250 | 250 | 1000 | gold hits>0; EV1 FPs are WO+WE via k0/k1 |
| paraphrase | 3 | 12 | 3 | — | 9 | 0 | 250 | 250 | 1000 | same walk as direct |
| role_reversal | 1 | 16 | 1 | — | 15 | 0 | 62 | 62 | 1000 | 0 fillers |
| wrong_relation | 1 | 16 | 1 | — | 7 | 8 | 125 | 62 | 1000 | fillers present; prec_ev1 ≠ prec_all |
| wrong_context | 1 | 12 | 1 | — | 11 | 0 | 83 | 83 | 1000 | **NOT_SELECTIVE** (xid still not a key) |
| distractor | 11 | 12 | 0 | 9 | 12 | 0 | 0 | 0 | undef | **EXCLUDED**; **FAIL DISTRACTOR_LEAK** |
| unrelated | 0 | 0 | 0 | — | 0 | 0 | — | — | — | **UNRELATED_EMPTY_WALK** |
| high_occupancy | 1 | 16 | 1 | — | 4 | 11 | 200 | 62 | 1000 | fillers counted separately |
| overflow_page | 1 | 16 | 1 | — | 11 | 4 | 83 | 62 | 1000 | gold 172 in emit; ovf=1 |
| high_id_sentinel | 1 | 16 | 1 | — | 11 | 4 | 83 | 62 | 1000 | id 255 present |

Raw CLASS / named lines:

```text
CLASS_direct gold_n=3 emit_n=12 tp=3 fp_ev1=9 fp_fill0=0 prec_ev1_x1000=250 prec_all_x1000=250 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
CLASS_paraphrase gold_n=3 emit_n=12 tp=3 fp_ev1=9 fp_fill0=0 prec_ev1_x1000=250 prec_all_x1000=250 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
CLASS_role_reversal gold_n=1 emit_n=16 tp=1 fp_ev1=15 fp_fill0=0 prec_ev1_x1000=62 prec_all_x1000=62 rec_x1000=1000 occ=11 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
CLASS_wrong_relation gold_n=1 emit_n=16 tp=1 fp_ev1=7 fp_fill0=8 prec_ev1_x1000=125 prec_all_x1000=62 rec_x1000=1000 occ=28 ovf=1 trunc=15 dirB=32 postB=48 discB=4 descB=0 incomp=0
NOT_SELECTIVE class=wrong_context k0=2561 k1=257 k2=510 k3=312 vs_direct k0=2561 k1=257 k2=510 k3=312 keys_match=1 emit_match=1 law=qse-v2-relbind-01 xid_not_directory_key rec_is_not_context_selectivity=1
CLASS_wrong_context gold_n=1 emit_n=12 tp=1 fp_ev1=11 fp_fill0=0 prec_ev1_x1000=83 prec_all_x1000=83 rec_x1000=1000 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0
FAIL DISTRACTOR_LEAK leak_n=9 emit_n=12 fp_ev1=12 fp_fill0=0 gold_n=11
CLASS_distractor gold_n=11 emit_n=12 leak_n=9 tp=0 fp_ev1=12 fp_fill0=0 prec_ev1_x1000=0 prec_all_x1000=0 rec_undef=1 occ=9 ovf=1 trunc=0 dirB=64 postB=128 discB=72 descB=0 incomp=0 gold_polarity=excluded
CLASS_unrelated UNRELATED_EMPTY_WALK gold_n=0 emit_n=0 tp=0 fp_ev1=0 fp_fill0=0
CLASS_high_occupancy gold_n=1 emit_n=16 tp=1 fp_ev1=4 fp_fill0=11 prec_ev1_x1000=200 prec_all_x1000=62 rec_x1000=1000 occ=25 ovf=1 trunc=9 dirB=16 postB=32 discB=0 descB=0 incomp=0
CLASS_overflow_page gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=12 ovf=1 trunc=1 dirB=32 postB=64 discB=20 descB=0 incomp=0
CLASS_high_id_sentinel gold_n=1 emit_n=16 tp=1 fp_ev1=11 fp_fill0=4 prec_ev1_x1000=83 prec_all_x1000=62 rec_x1000=1000 occ=10 ovf=1 trunc=2 dirB=32 postB=64 discB=4 descB=0 incomp=0
ASTRA_C1_KEY_RELBIND_XSIM_NO_MARKER fail=1 dist_gold_ok=1 dist_excl_ok=1 dist_no_leak=0 unrelated_empty=1 wc_not_sel=1 direct_tp=3
```

## Leak composition (label gold, not posting tautology)

Excluded gold (same R3 two-role nids): `{99,108,109,111,114,118,121,132,193,214,235}`.

```text
k0=2561 {subj,rel} occ=6  → 108,109,110,111,144,145     pump supplies *     (WO + PSC)
k1=257  {obj,rel}  occ=9  → 99,121,132,193,214,235      * supplies chiller  (WE + PSC)
k2=510  {rel,subj_cue[7:0]} occ=6  → same as k0 (dups)
k3=312  {rel,obj_cue[7:0]}  occ=9  → same as k1 (dups)
```

```text
excluded ∩ emit = {108,109,111,99,121,132,193,214,235}   leak_n=9
excluded \ emit = {114,118}                               WR no longer in k2/k3
emit \ excluded = {110,144,145}                           PSC retrieve (direct gold)
```

WR exclusion is the measured effect of binding `rel_id` into k2/k3.
WO/WE remain because k0 has no object and k1 has no subject. That is the
registered law, not a TB packing bug, not a license to drop threshold or
relabel `relevant=router_union` or derive keys from nid.

## Not claimed

`PASS_THIS_GATE_ONLY`. `ASTRA_C1_KEY_RELBIND_XSIM_PASS`. C1 800k. N=4096.
BOARD_PASS. ACCEPT_BOARD. ASTRA-13. `CAND_CAP_FINAL`. leftover A09 as DUT.
numeric `reduction_x1000`. silent C0 patch. fake context keys.

## Hash / process

Gold hashed 09:48:35. SHA256.txt freeze 09:49:05. first xvlog 09:49:06.
`xsim.log` SHA256 `48cb3b7feb7822d7f7d54d78044869d84d5890471a92bb553f63a287d0203cd5`
equals `xsim_fail_r0.log`. Single session. Gold not rewritten after FAIL.
