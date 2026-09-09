# RTP-R1 / F2 review — 2026-09-06

Verdict: RTP-R1 ACCEPT_PASS_NARROW for observed cases; F1 production closure remains partial. F2/F3 NOT_ACCEPTED. Overall ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION, PROGRAM=NO.

Evidence: manager read current R1/F2 RTL, testbench cases, stored raw XSim logs, manifests and current SGD source. No new simulation or RTL edits. R1 manifest 9/9 matches. Its header timestamp precedes stored XSim start, but a text timestamp alone is not independent proof of immutable pre-run chronology or all transitive build inputs. Old astra09 hash remains 48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b.

R1 confirmed narrow improvements: descriptor RID/RRESP/RLAST/version/valid/eid validation gates eng_load; descriptor fields and engine instantiate use 20-bit IDs. Raw log has BASE4, POST_DROP UNKNOWN, DESC_SWAP7, UNREL nc=nl=nfar=0, BAD_RID/SLVERR/NOLAST nerr=2 nl=0 status6, timeout nto=2, OVF6, NEG8, AMB7. The direct UNREL assertion was corrected.

Remaining scope limits:
- Only low IDs are exercised; need high-bit identity/alias and wrong-eid/schema/invalid-descriptor vectors before claiming tested full-ID closure. Query entities still originate as 8-bit parser IDs.
- Timeout counter runs in S_R only. S_AR can wait indefinitely. After timeout the implementation advances to another fetch without draining/resetting outstanding AXI traffic; no tested late-response recovery contract exists. Do not call this complete AXI robustness.
- Engine clear/load still assumes 16 slots and context is not checked in facts. CAND_CAP parameterization is not general capacity proof. NEG status is abstention, not proof of reasoning over negated queries.

F2 findings:
1. Stored log honestly FAILS reward-switch. R0 has two paths, R1 still selects proof17,34 after -3. Keep the failure.
2. F2 manifest uses SGD c6f37a273960a3187934b1439c74915a913bf5b12e44114a907e714036061a1f; historical unit/freeze used 1786bd82f36a0872b93215dadf471b5db84e68ee8c86ba686e7ea7051f38767b. Canceling timing work did not restore or validate that changed dependency. Do not overwrite either version or reuse old unit PASS as current-source evidence.
3. Candidate diagnosis (ENGINEERING INFERENCE, needs cycle trace): updated pipelined SGD delays ui/uv through three stages but computes sh_r from upd_m when uv2 is set. With NBA timing, first uv2-consumed product appears to correspond to x[1] while delayed index is 0. x[0]=64,x[1]=0 can therefore leave w[0]=0. Isolate arithmetic before changing selection: one-hot x[0]=64, reward=-3, zero weights, SHIFT6 should produce delta w[0]=-6 and every other delta zero. Trace i/ui*, uv*, upd_m, sh_r, err, rew and all weight writes. Also test last index and asymmetric features. This is not yet a simulation-proven root cause.
4. F2 phi[0]=(mid==1), phi[1]=(mid==8), including saved xsel. This is identity-specific preference, not transferable shared relation/context/source features. Keep it only as a declared reward plumbing control. A successful switch alone will not close F3.
5. F2 duplicates fetch logic rather than preserving all R1 guards: no timeout/result-status interface, no propagated overflow/negation/ambiguity policy. On no candidates/no paths it goes to S_HOLD without clearing best_* from a previous result. This source has a stale-result risk; run ANSWER then unrelated on the same reset session. R1 PASS does not transfer to this module automatically.
6. v_alt=-32768 at the initial tie is explained by picker logic excluding equal-score alternatives; it is not evidence that the second legal path scored -32768. Correct telemetry before using margins as evidence.
7. Reward input has no txn_id/dedup/commit contract yet. Keep F2 pending/commit and F3 held-out acceptance open.

Next bounded experiment: isolate current SGD pipeline in a new diagnostic revision/bag and compare one-hot per-index updates against the frozen arithmetic law, preserving first divergence and existing fail logs. Do not patch the frozen unit in place or move to board. After arithmetic is verified, rerun two-proof reward plumbing and R1 negative cases on the actual F2 path; then use shared non-identity features and held-out ID permutations for F3.
