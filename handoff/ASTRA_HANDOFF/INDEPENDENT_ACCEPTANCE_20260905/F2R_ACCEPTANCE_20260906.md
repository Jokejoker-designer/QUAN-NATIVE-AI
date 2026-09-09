# Independent F2R acceptance — 2026-09-06

Verdict: ACCEPT_OBSERVED_NARROW_PROGRESS / WORK_ORDER_NOT_CLOSED. Preserve the bag and its PASS marker as evidence of its assertions; do not accept full pending/semantic/transport correctness or promote Master F3/F4/F5/board.

Manager reviewed source, TB, prereg, run script and stored raw logs; no fresh XSim was run. All 13 listed pre-manifest entries match live files, and log hash matches A51BD80A9CECCAE5D9A8D7FE6D316A6BC314F13EF7EFC8B231CEADDE9C2C8975. Source/code validity is separate from hash integrity. Included .svh dependencies are not all covered by the explicit compiled-file manifest; extend next revision freeze to transitive includes. Do not rerun run_f2r.ps1 in the old bag: it deletes xsim_work and rewrites evidence.

## Accepted observations

Raw log confirms rank-before-select for two retrieved same-conclusion proofs, confidence-based phi rather than numeric-ID equality; scalar negative reward changes selection17 to18; one observed duplicate/wrong txn is rejected; actual frozen and validity-only controls do not switch. The named sequential SGD avoids editing the old module. Stored RTP cases match reported outputs within their tested scope.

Independent Python integer calculation for actual floor-shift F2R law gives weight deltas [-5,-6,-6,-6,-6] for phi=[50,64,64,64,64], reward=-3. Subsequent high/low scores are exactly -14/-13. This explains measurements, but does not retroactively satisfy prereg one-feature score expectations -2/-1. Those expectations must remain recorded as mismatched, even though the TB did not assert them.

Five planted ID variants select the low-confidence path as reported. This is a small preference-transfer observation, not five independent training seeds, broad held-out transfer, or Master F3. Positive +3 is one sign control; labeling that same episode SHUF does not create a shuffled-reward experiment.

## Required corrections before closing the assigned work order

1. **Wrong pending phi for general winner (RTL_FACT, P1).** S_PICK selects among four paths, but pend_phi[0] resolves only pp0[0]/pp0[1], else zero, and matches proof0 alone. Shared-prefix paths can have different second edges/confidences. Preserve selected path index and copy exactly the scored full phi and prediction for every slot. Test winning slots2/3 and two paths sharing proof0, then apply reward and compare all 32 weight deltas. The observed three-path held-out case increases relevance; it never rewards those winners.

2. **Reward sampled one cycle late (RTL_FACT, P1).** S_HOLD checks rew_v/rew_txn and registers sgd_upd; SGD samples reward_i=rew_i the following cycle. No saved reward exists. TB holds rew unchanged after dropping valid, masking this. Latch reward/control with the accepted handshake. Test one-cycle valid followed immediately by opposite reward/bus changes. The descriptor-bus mutation test currently changes memory after update already committed, so it does not verify pre-commit pending isolation.

3. **Different integer law (RTL_FACT).** The new v1 copy uses arithmetic right shift (floor), sat16 score and 32-bit accumulator. Historical reviewed native-rank-sgd-q8-v1 used symmetric RSH and reward-prediction clamp ±768. Example +3,x0=50 gives +4 here, +5 with symmetric RSH. Work order required the verified immutable law, and Master requires symmetric rounding. Naming a floor-law prereg does not override that. Keep this bag as a distinct experimental law; use a new revision to restore the authorized law and freeze a full-vector oracle before run. Never change this bag's expected values to manufacture compliance.

4. **Semantic guards lost (RTL_FACT, P1).** F2R latches subject/relation only; ignores explicit object and context, always enumerates two hops, has no conflict detection, and silently discards paths beyond four. DESC_SWAP TB explicitly accepts either conclusion4/7. Whether multiple conclusions are valid set-valued answers depends on the relation contract; without such a contract this is not proof that contradictions cannot be ranked away. Test wrong-object, direct-vs-indirect, opposing polarity/context, and fifth legal path; propagate declared ambiguity/conflict/incomplete policy before selection.

5. **Transport negative coverage is narrower than labels.** LATE_R injects 20-cycle delay, below TO_CYC64; it does not test a response arriving after timeout or crossing a subsequent query. SLVERR/NOLAST/no-response modes exist in TB but are not invoked in the observed sequence. AR timeout drops ARVALID without an AXI cancellation/drain contract. Preserve the tested stall result but do not claim post-timeout recovery. Register and test abort/drain/reset behavior on the actual path.

6. **Pending identity lifetime incomplete.** txn_id is 8-bit, resets to1 and wraps; no generation accompanies reward. Old delayed rewards can collide after reset/wrap. Define epoch/generation and outstanding lifetime before claiming dedup outside one pending episode. Snapshot has no explicit generation field despite prereg, and reset/retire-in-flight assertions are missing. Reject reward=-4 explicitly.

## Next bounded correction

First correct selected-path pending capture and reward handshake in a new named revision, while reconciling the authorized arithmetic law with a frozen full-vector oracle. Tests: each possible winner slot/shared-prefix case; one-cycle reward with subsequent bus mutation; exact all-weight deltas and score; duplicate/wrong/stale generation; reset/retire semantics. Preserve original source and failure evidence. Do not jump to board or call the outstanding semantic/transport items closed by this plumbing correction.

No Grok message, source edit, board/COM12/JTAG/bit action was performed in this acceptance. PROGRAM=NO. Manager conclusion is stricter than the proposed PASS_NARROW for the work order as a whole, while retaining the demonstrated preference-update progress.
