# F2R-R2 acceptance

ACCEPT_PASS_NARROW_SELECTED_PENDING_HANDSHAKE_SYMMETRIC_LAW. This accepts the observed bounded gate, not production transaction lifetime, Master F3, semantic/context/conflict handling, AXI recovery, LM06, final physical closure or board.

Manager read current RTL, TB, prereg, oracle generator/JSON, stored pass log and compared manifests. 19/19 listed files match live. 12/12 compiled/include entries match pre/post. Pass log SHA 337ca164ce48171c9b54c1f0d3d047c6ab871f445a84ef0791a73353d4bcf3db; failed log SHA bed425f60c614423d4b98d99251a8bdfe45629367f3d30e57d1b56a23bab19f3. Between fail/pass manifests only symmetric SGD source hash differs; TB/prereg/oracle hashes are unchanged. This supports a bounded corrective, not proof that a manifest timestamp is independently immutable. No new XSim was run by manager.

New independent Python arithmetic check of oracle.json: all six vector cases, all32 dw/w1 and v/error agree with symmetric formula, exit0. RTL now sign-extends dw and uses signed40 accumulator, symmetric RSH and required clamps. Tests observe slot0..3 selection, shared-prefix slot identity, saved phi, one-cycle reward followed by inverted bus, whole-weight checks, duplicate/wrong/stale-generation/out-of-range/freeze/zero cases, retirement and drain, and unrelated-query stale-answer smoke.

Source confirmation: phis[c_best_idx] is copied, v_pred retained, rew_lat sampled at validation, SGD freeze tied0 with freeze gated at acceptance, commit follows done. Keep test weight-load port explicitly limited to verification/checkpoint scope; it is not a production host-learning channel.

Limits requiring the next revision: gen and txn increment together and both reset0, so the pair repeats after256 births and after reset; stale-gen test only submits a different number, not a real old reward after reset/wrap. Hard reset during UPD is specified but not explicitly tested. TB snapshots DUT phi to derive many expected updates; slot tests assert phi0, but independent full phi-content/prediction checks should supplement all-weight checks. Named source recomputes score on update; equivalence to saved v_pred relies on unchanged weights during pending. Claim that invariant only within the current single-pending/no-load-during-HOLD design. Numeric saturation boundaries were inspected, not exhaustively simulated.

Next: bounded transaction lifetime/reset/wrap gate before reusing this pending engine in long-running learning. Preserve F2R-R2, do not amend its oracle or rerun into its bag. PROGRAM=NO.
