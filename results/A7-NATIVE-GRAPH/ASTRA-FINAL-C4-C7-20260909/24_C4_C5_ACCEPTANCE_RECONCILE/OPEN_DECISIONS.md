# E0 open decisions — dispositions recorded, not MASTER stamps

`PROGRAM=NO`. `C4_MASTER=OPEN`. `C5_MASTER=OPEN`. `C6_MASTER=OPEN`.

Evidence classes: FACT / INFERENCE / HYPOTHESIS / UNKNOWN / CONTRADICTED /
expected_by_contract.

## D0 — Gemini vs Codex vs this amendment

| Claim | Class | Disposition |
|---|---|---|
| Gemini “nghiệm thu toàn bộ C4” | CONTRADICTED by Codex REVIEW + this bag | Not approval |
| Codex `ACCEPT_PARTIAL_RESEARCH / REJECT_C4_C5_FINAL_ACCEPTANCE / PROGRAM=NO` | FACT (REVIEW.md) | Stands |
| Four WO amendments this turn (KEEP vs NEW GATE; 240 vs 360; E3a first; exam DICT_LOCK) | FACT (coordinator) | **Accepted.** Pre-amendment WO text kept; amendment sidecar is live |

## D1 — C1/C2/C3 KEEP vs E1 (resolved)

**EXISTING SEMANTICS = KEEP.** Allowed: versioned export of proof_ok, selected-path SRC/DST, transaction/direction sideband.

**Raw query → reverse retrieval/proof = NEW GATE.** Must not silently change existing F. Affected C1/C3 regressions replay. Wiring `direction_o` to `bank_r` is forbidden as a substitute.

Parser FACT: `a7ng_query_role_extract.sv:98` `assign direction_o = 2'd0`.
Wrap FACT: `dir_known_o` computed, `answer_allowed_o` does not include it
(`a7ng_astra_c4_prod_wrap_v2.sv:58,122`).
C5 FACT: `.direction_i(c3_dir)` and `.bank_r_i(bank_r_i)` are separate pins
(`a7ng_astra_c5_prod_top_final_v1.sv:432`).
C6 FACT: `alias_wr_v_i=0`, `bank_r_i=0`.

E1a not opened this session.

## D2 — Learned 240 vs system 360 (resolved as scoring law)

`LEARNED_NUMERICAL` = 240 F/R D32 only.
`SYSTEM_360` = 240 F/R + 120 U, system output, D32 bypassed on U.
Do not demand float/int D32 parity on U.

Observed scorer result (this bag, no rerun):

| Corpus | LEARNED | SYSTEM |
|---|---|---|
| V1 `confirm_wo360_v3_once.json` | 240/240 `allowed_correct` from predicted_tokens | 0 measured; **120 `expected_by_contract`** |
| V2 `eval_once.json` + `confirm_v3.json` | aggregate F120/120 R120/120 in eval_once (**FACT**); per-case tokens **not** in eval_once | 360 `not_measured` |

Legacy `pass_system_safe=true` / `pass_c4_numerical_wo=true` on V1 remain on disk **untouched**. They are not observed PASS.

V2 U: 120 rows, **no `kind`**, built as `v2_ctx("F", src, dst)` + `ans=no`
(`lock_eval_confirm_v3.py:47`). Cannot test six WO U classes.

## D3 — Prefix top-1 FAIL (closed as FAIL; score not a rewrite)

PREREG `prefix_intervention_min_changed: 1`.
Raw `prefix_changed=0`, `prefix_pass=false`, `learned_causal_pass=false`.
Diagnostic: top-1 **0/16**, score **16/16**.

**Retain PREFIX_TOP1 = FAIL.** Score is dependency evidence only.
No retrain. No silent criterion swap.
Prospective disjoint §8.2 score test = **OPEN, needs authority**.
Independent E3a/E4 provenance **may continue**.
`C4_MASTER` stays OPEN.

Other causal (gate held ANSWER): normal 64/64, zero/corrupt 0/64,
replace new-gold 62/64, wrong_bank 0/64 — useful, **not** MASTER close.

## D4 — 4-char endpoints (closed for current V2 freeze)

4-char strings (`pkev`/`tifh`) are **registered product symbols** of G06/V2,
not truncated QSE `pump`/`valve`/`chiller`.

Keep checkpoint `fcfe37be…` + context V2 + 12 HEX for the bit-exact loop.
Claim only vocabulary that is fully mapped.
English QSE words or longer symbols = reopen model/context + new blind confirm.
TB alias per query is not a production dictionary.

## D5 — Audit-time hashes ≠ run-time freeze

Codex `EVIDENCE_HASHES.json` is **audit-time**. Current C5
`5d959a6d…` mtime **2026-09-09T17:14:10** must not retro-certify older logs.

Bag 22 `xsim.log` mtime **17:08:55** is **before** current C5 and before
`a7ng_astra_c3_held_out_pendld.sv` mtime **17:14:02**.
Verdict: **source pin missing for current top** → E4 affected rerun only.
Bags 21 (17:16:56) and 23 (17:16:33) are after current C5 mtime; still not
C5_MASTER (TB bank, synthetic alias, AXI model).

## D6 — E3a attribution (OPEN; one path inspected, not top-N)

FACT from `timing_ooc.rpt` (SHA `a50231bd…`): one max-delay path only.

```text
WNS -83.427 ns @ 10 ns; 62840 failing endpoints; TNS -1364570.227 ns
Source:      elut_reg[11][5]/C
Destination: acc1__0__0/B[14]  (DSP48E1)
Delay:       92.893 ns; 319 levels; CARRY4=305
Nets:        eden[*]_i_*, attn[1][31]_i_*, psum3[*]
```

INFERENCE: that **worst** path sits in softmax attn/eden/psum → DSP, matching
RTL `S_SMRES` `/ eden` (`a7ng_astra_c4_lm06_d32_fr_v2.sv:265-268`), not a
named `We` mux.

UNKNOWN / E3a remaining: top-N paths, explicit divider vs adder mapping,
whether other of 62840 endpoints are async weight muxes (BRAM=0 is FACT).

**Do not start E3b divider RTL until E3a top-N attribution is written.**

## D7 — Production dictionary exam lock (OPEN)

C6 `alias_wr_v_i=1'b0` → all alias invalid after reset → learned F/R unreachable
on named whole-chip (INFERENCE: synth may prune; netlist not audited).

Required: boot load ENTITY_ALIAS_V1, schema/version/length/CRC/hash, `DICT_LOCK=1`
for the **entire** acceptance run. No host alias rewrite between queries.

CAM-8 is cache only with backing store. TB fixture ≠ corpus.

## D8 — Host token counter

D32 `n_host_tok_o = 16'd0` hardwired (`…d32_fr_v2.sv:125`) is **not** a
host-leak measurement. `C4_MASTER_STATUS.json` “host_semantic PASS” is an
overclaim. Negative forbidden-host tests remain OPEN.

## D9 — What may run next (ownership)

After Codex reviews this bag:

1. **E3a** READ-ONLY timing path dump (physical; no RTL; independent of prefix FAIL).
2. **E1a** only as NEW GATE contract package (F/R/INVALID) — no parser encoding invention, no `direction_o→bank_r`.
3. **E4** affected rerun of bag 22 against current C5 SHA, plus fill `C5_FINAL_REGRESSION_MATRIX.json`.
4. Do **not** mix 1 and 2 in one run.
5. Do **not** stamp MASTER or program a bit.
