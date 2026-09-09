# ASTRA-F2R-SHARED-RANK-PENDING-01

Manager work order, 2026-09-06. User explicitly requests the next Grok assignment on Arty A7-100T. Codex manager session 01a0723e-f20c-7270-983e-6aca89596308.

Root D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH; branch grok-orch/astra-native-v1-00; observed base 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1 plus dirty research artifacts. Target Digilent Arty A7-100T xc7a100tcsg324-1, Vivado2026.1 (verify installed tools). Board is reported connected. PROGRAM=NO; no serial/JTAG/hardware calls in this task. Board connection is not final-artifact programming authorization.

## Acknowledge and preserve

You are the NEW Grok Astra implementer for this bounded work order, not a manager of the old V3.1 lane. First write ACK.json inside a new results/A7-NATIVE-GRAPH/ASTRA-F2R-SHARED-RANK-PENDING-01/ bag: task ID, observed session ID (or UNKNOWN honestly), cwd, branch, base, role, write scope, PROGRAM=false. Do this before substantial work. If this bag already has another active writer, report conflict without overwriting or starting duplicate work. No subagents, schedulers or extra top-level sessions.

Read D:/AGENTS.md and applicable local instructions. Current Astra authority is D:/FPGA/ASTRA_HANDOFF/ASTRA_NATIVE_AI_MASTER_V1.md, followed by its references/DESIGN_CANDIDATE.md. Read manager acceptance under D:/FPGA/ASTRA_HANDOFF/INDEPENDENT_ACCEPTANCE_20260905/, including RTP_R1_F2_REVIEW.md. Historical AGENTS/parent-loop gate numbering must not redirect this explicitly authorized task to H5/V3.1, board, or idle merely because older unblocked_item=NONE. Read required local Xilinx reference guides before generating tool scripts; do not invent APIs.

Retain RTP0/R1/R2, F2 failure, F2T class control, HOP3, persisted-unit and wrapper bags. Do not reset/clean/checkout/reclone, commit or push. Do not change old lane D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00 or traverse the Basys junction. Do not edit existing source, frozen bags, existing loop state or automation. Only create the new bag and distinctly named candidate RTL/TB/helpers used by it, after inspecting nearest policies and path isolation. Preserve source provenance and hash every reused dependency.

## One primary unknown

Can an FPGA-owned shared non-identity ranker select among at least two independently valid retrieved proofs, save the selected features/prediction in one pending transaction, accept only scalar reward plus txn_id, and change its subsequent preference without corrupting proof legality or repeating updates?

Use two-hop initially. Keep class-one-hot F2T as a labeled control; do not claim it is a complete feature representation. Use the verified arithmetic v1 candidate by explicit source hash, not the cancelled DSP timing-fix implementation. Do not patch the original SGD file. If adapting, create a new named module and compare it to the immutable integer law.

## Contract before implementation

Freeze PREREG, descriptor/feature schema, integer rounding/update law, input corpus, train/dev/exam split, controls and oracle before confirmation tests. Feature count may be bounded for this experiment; claim only what is implemented. Features must derive on FPGA from actual query/descriptor/path relation, context, source quality or confidence fields. No query/answer/entity ID, proof index, fixed winner-class byte, or gold label as shared feature. Do not populate a quality field by consulting the exam answer.

Reuse validated RTP R2 transport/identity/uncertainty behavior, preserving it in the actual new path. Walker ID must fetch full-ID descriptors into facts; TB supplies versioned static corpus/index via modeled storage and query bytes only, not internal features/winner/proof or engine load. Keep proof admissibility independent of score. Distinguish alternative valid proofs for one conclusion from contradictory conclusions; do not rank away a conflict.

Define exactly one pending transaction containing txn_id, generation, chosen full identities/proof, copied phi and predicted reward. Reward channel only txn_id plus [-3,+3]. Define accepted versus committed, duplicate/wrong txn behavior and retirement/reset semantics. No claim of DDR persistence from register dump/load.

## Required bounded evidence

1. At least two legal proofs are enumerated and scored before the winner is selected; accurate best/second-best telemetry including ties. Log actual derived phi, scores, selected IDs and proof validation.
2. Frozen/no-update and fixed-proof-validity controls execute real decision code. They must not be constants copied from expected outputs. Compare negative reward, positive reward and shuffled reward in preregistered episodes.
3. Subsequent preference responds to committed scalar reward where integer-law oracle predicts a switch; assert exact weight deltas. One-hot per-index arithmetic checks may be controls, never the transfer claim.
4. Held-out ID permutations/worlds preserve the structural feature law. Use >=5 seeds if claiming transfer; report accuracy, coverage and uncertainty separately. If scope only establishes plumbing, label PASS_NARROW and leave Master transfer gate open.
5. Duplicate reward must not double-update; wrong txn cannot update; changing the live query/descriptor bus after decision cannot alter saved pending phi. Reset/retire behavior must match prereg.
6. Regress current-path RTP negative cases: posting drop, descriptor swap, high-ID/eid mismatch, AXI errors/stalls/late response policy, overflow, ambiguity, negation, ANSWER then unrelated with no reset. No stale proof on empty/no-path queries.

Produce source/config/input hashes before xvlog, actual command/exit logs, separate xvlog DUT/glbl logs, raw XSim, independently derived metrics, first divergence and RESULTS/CLOSEOUT limitations. Verify post-run hashes. No implementation route/bit build required. LM06_NOT_INTEGRATED, F4/F5 and BOARD_PASS remain open.

On a real failure, preserve it and perform one bounded corrective experiment in a separate revision within this task; never lower thresholds or edit golden answers to pass. Finish with evidence and next dependency. Do not autonomously advance to a different gate. Manager independently accepts the result.
