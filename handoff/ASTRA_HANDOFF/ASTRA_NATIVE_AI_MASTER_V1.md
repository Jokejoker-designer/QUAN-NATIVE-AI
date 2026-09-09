# ASTRA Native AI — Master V1

Date: 2026-09-05
Status: ACTIVE DESIGN AUTHORITY FOR NEW ASTRA BRANCH; IMPLEMENTATION/BOARD UNPROVEN
Target: Digilent Arty A7-100T, xc7a100tcsg324-1; Vivado2026.1 baseline, verify installed version.
Workspace container: D:/FPGA
Intended independent repository: D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
Intended branch: grok-orch/astra-native-v1-00
Final new-branch goal: ASTRA_NATIVE_AI_BOARD_PASS

## 1. Human direction and separation

User explicitly requested a NEW manager session for a NEW Grok session following Astra's design in D:/FPGA. The existing Grok Native AI branch continues its own V3.1 master and development. Neither branch replaces the other automatically.

Existing lane: D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00, grok-orch/v31-canonical-00. Also keep Cursor and all other Arty worktrees untouched. Their milestones, locks and board authorizations do not transfer to Astra.

This document makes the previously proposed Astra design the architecture direction for THIS NEW BRANCH ONLY. No new hardware capability is claimed by activating this document. It supersedes conflicting forward-execution statements in the older D:/FPGA/GROK_ASTRA_NEW_SESSION_MASTER_PROMPT_ISOLATED_V1.md without deleting or editing that file.

## 2. Authority

1. Latest explicit human direction for this branch.
2. This master: scope, architecture, roadmap, claim conditions.
3. references/DESIGN_CANDIDATE.md: detailed numerical algorithms, proposed budgets, schemas and experimental methods, except where this master changes stage ordering or old-branch authority language.
4. Per-experiment prereg frozen BEFORE confirmation; cannot override master scope.
5. references/AUDIT.md: dated evidence and findings, refresh live facts when needed.
6. references/HANDOFF_GROK.md and historical V3.1 material: background only for this branch.

Evidence determines whether a claim is true. A report, law document, audit opinion or master cannot turn missing/failed evidence into PASS. Define claims separately from normative authority.

Do not import old AGENTS/LOOP_STATE/BRIDGE as Astra execution instructions merely because they arrive in a clone. Keep historical files archived; author Astra-specific root AGENTS and current-state pointers inside the independent clone at ASTRA-00. Follow applicable D:/AGENTS.md. Human branch separation supersedes old statements about one shared project or dispatching old Cursor/Grok.

## 3. Product and limits

Build an FPGA-owned bounded-domain AI with role-aware query parsing, sparse evidence retrieval, typed relational inference with proof, transferable reward-adaptive ranking, persistence and meaningful FPGA-generated output through the LM06 path.

Operational definition of understanding: distinguish roles and direction; answer novel combinations of supported facts; change conclusion under evidence interventions; reject insufficient/conflicting evidence. No claim of consciousness, AGI, open-domain language or arbitrary unseen vocabulary.

Learning means improvement on held-out entities/worlds after FPGA state updates. Merely changing a counter/weight or memorizing per-ID rewards is insufficient for transfer claim. Parser vocabulary and fixed rules are designed priors, not automatically learned knowledge.

V1 corpus is static/versioned during an experiment, expandable up to800k records. Reward updates behavior over that knowledge. Dynamic arbitrary insertion, autonomous discovery of facts and unbounded rule induction are future work.

Do not claim final success from a grammar-only renderer. A structured proof-output milestone is valuable but the selected final goal retains LM participation and a measured language-output contract. If LM language quality is not feasible, report that blocker and a reviewable alternative claim, rather than silently removing it.

## 4. One production path

Raw bytes/tokens → query transaction → role-aware parser → valid typed route keys → sparse index/postings → bounded descriptors → PHYS4 scoring + shared learned ranker → retained Top-K/frontier → bounded relation expansion → proof validity/uncertainty → materialized evidence → LM06 generation → UART tokens/proof/status.

The ranker schedules admissible paths; proof legality does not depend on score being high. Proof edges, polarity, context and variable binding must be checked independently.

Reuse known-correct MIG/DDR/UART/AXI/ping-pong/Top-K modules only with provenance and regression in the new clone. Keep old benchmark query-ID candidate generators as simulation controls, never hidden production retrieval.

## 5. Algorithm choices

### Parser

Start with bounded technical grammar and streaming dictionary/trie lookup. Preserve subject, object or variable, relation, direction, context, negation, validity, ambiguity. 'A supplies B' must differ from 'B supplies A'. Lexical aliases can be preloaded as documented prior. Do not use lowest numeric ID as entity role selection.

Freeze wire token law before interface implementation. Current legacy input8-bit/output10-bit incompatibility must be resolved for autoregressive feedback. Tokenization at host is allowed as reversible fixed codec; host semantic role extraction, routing or answer selection is forbidden.

### Sparse retrieval

Keys come from actual query and corpus representation under the same law and validity semantics. Key zero is not invalid by definition. Never replace data-dependent cues with nid-derived keys in a semantic scale test.

Compare at most two primary index rivals per revision, with a preregistered cap sweep64/128/256/512/1024. Store full posting representation, explicit overflow pages and full identities. Probe rare/typed keys and perform budgeted intersection/refinement. Return SEARCH_INCOMPLETE on incomplete search, not an invented answer.

Exact dedup may use BRAM sequential comparisons. A Bloom filter alone cannot prove no dropped legitimate candidate. Measure all directory/posting/duplicate/discard/descriptor/state bytes, and report LM weight traffic separately.

### Reasoning

Initial MAX_HOPS=2, beam≤8. Promote3 hops only after transfer, quality and resource evidence. Typed Horn/Datalog-style rules with explicit variables; e.g. requires(x,y) AND requires(y,z) implies depends_indirectly_on(x,z). Do not grant transitivity to all relations or infer physical causality from graph reachability.

Maintain edge/rule IDs, parent proof index, depth, direction, context and generation. Conclusion must not be pre-stored in exam corpus. Removal/replacement/reversal of decisive edge must change proof/result. Missing fact under open-world semantics means UNKNOWN, not NO unless the query's relation contract explicitly supports closed-world reasoning.

### Reward learner

Shared32-feature linear reward estimator with saturating fixed-point SGD, not a new large neural network. Phi uses relation/direction/context/source/path/conflict features shared across entities. Saved FPGA pending object supplies the selected action's features and prediction; host sends only txn_id plus reward[-3,+3].

Detailed Q8/rounding law in references/DESIGN_CANDIDATE.md is a proposal to be frozen after dev feasibility. Use symmetric rounding, sufficient intermediate width, saturation metrics. Optional TRAIN-only epsilon-greedy exploration; EXAM deterministic. This is reward prediction with partial feedback, not a guarantee of LinUCB or language learning.

Compare learned shared weights vs frozen/no-update, shuffled reward and per-ID prior. Held-out gain must be measured over multiple seeds and retained after reload. Do not invent labels/winners for unchosen actions.

### Transaction and storage

Single pending object is acceptable first: txn_id, generation/model version, selected identities/path, phi and predicted reward. Acknowledgement of receipt differs from committed state. Capacity miss, reset, duplicates and DDR stalls must not create false success.

Full32 subject/object persistence schemaV2 is reusable with version/migration checks. No low8/low16 identity authority. DDR retention across BRAM loss is warm persistence; power-loss durability requires separately tested nonvolatile checkpoint/journal.

### LM and answers

Audit weights actually used, vocabulary, checkpoint provenance, training objective, context encoding, generation loop and held-out text. LM start/done and integer golden outputs do not prove language. Materialize facts/proof content, not just low-byte IDs. Keep generation on FPGA; CPU may only decode token IDs to text.

Offline bootstrap weights/corpus are separate from online FPGA learning. Do not assume permission for expensive/cloud pretraining or downloading an unreviewed model. Establish a concrete dataset/checkpoint/resource plan before expanding that scope.

## 6. Fixed budget policy

Historical candidate only: LUT36911, FF45656, RAMB36eq106.5, DSP19, slices15537/15850, WNS+1.126ns, WHS+0.014ns. These do not describe unbuilt Astra.

Hard requirements: device fit, WNS≥0/TNS0, WHS≥0/THS0, route/DRC errors0, reviewed CDC and constrained relevant paths.

Preferred: free slices≥800, BRAM36eq≤115, LUT≤40k, FF≤50k, DSP≤32. Do not mistake preferred targets for measured results or automatically add all OOC counts as full-chip evidence.

Remove/reuse before add. Priorities: one retrieval/Top-K engine, sequential parser ROM, BRAM dedup, phase-owned scratch, synchronous logits RAM if bit-exact scheduler permits. Retain PHYS4 default; trade latency/beam/query length only under a versioned measured contract. Fewer features or hops are acceptable if the declared final capability and acceptance still hold; removing learning or proof to get fit does not satisfy this goal.

Proposed additional working set is13RAMB36eq; not approved utilization. Map it against freed existing allocations. Never promise it fits because RAMB36 total is below135 while slices are nearly full.

## 7. Roadmap — corrected dependency order

The older isolated prompt placed full800k selectivity before role representation. This master separates early infrastructure reuse from final scale promotion so a later representation change does not invalidate a premature scale victory.

| Gate | Outcome / promotion condition |
|---|---|
| ASTRA-00 | Independent clone, identity/authority/provenance, exact reviewed baseline, isolated paths |
| ASTRA-00A | If a pre-existing Astra clone is found: takeover integrity/dirty ownership/session binding; accept or correct prior ASTRA-00 before implementation |
| ASTRA-01 | Dataset/domain/token/metric contract; small reference feasibility; audit available LM checkpoint now |
| ASTRA-02 | Role-aware parser; direction/negation/ambiguity tests; new query/record key law frozen |
| ASTRA-03 | Same-law sparse retrieval at256→4096→16384; actual keys, independent gold, selective candidates, negative cases; reuse AXI geometry without redoing valid evidence |
| ASTRA-04 | 2-hop rule engine + valid proof; causal edge intervention, cycles/conflict/incomplete; no LM required for local proof |
| ASTRA-05 | Shared reward learner + multi-seed held-out transfer, controls and bounded state |
| ASTRA-06 | Pending/commit, full-ID schema, migration, capacity/eviction and warm persistence on chosen state architecture |
| ASTRA-07 | Stable-law scale ladder65536→262144→800000 plus lower-N controls; full index image/provenance, quality and traffic bounds |
| ASTRA-08 | Materialized evidence→LM checkpoint/vocab→autoregressive FPGA token output with measured language grounding |
| ASTRA-09 | One integrated production path; remove fixture shortcuts; all functional regressions |
| ASTRA-10 | Current-source whole-chip resource reconciliation; early preflights may run earlier in isolated bags |
| ASTRA-11 | Final source/config freeze, full synth/implementation from exact frozen manifest; if RTL changes return to affected gates |
| ASTRA-12 | Preprogram closure, unique bit, current board token/identity/UART plan |
| ASTRA-13 | Final blind board capability exam + final claim reconciliation |

Reference quality and cheap physical estimates are preflight checks, not permission to bypass prerequisites. Do not postpone discovering missing LM training until after an entire silicon campaign: audit it at01, integrate at08.

## 8. Acceptance to freeze at ASTRA-01

Proposal: supported-grammar role accuracy≥95%; small-domain evidence recall≥95% at selected cap and candidate reduction≥90% for N≥4096; index representation covers all valid records; 1/2-hop answer accuracy≥95/90% with proof validity100% for ANSWER. Final thresholds must be realistic for declared scope, fixed before confirmation and reported per class.

Transfer: ≥5 seeds; shared learner gain target≥10 percentage points over no-update, paired CI lower bound>0, retention drop≤5pp. Also compare shuffled reward and per-ID controls. UNKNOWN should reject unrelated queries; report selective accuracy and answer coverage so always-UNKNOWN cannot PASS.

Do not change thresholds after confirmation to save a candidate. Old R3 phrases are regression/dev material, not new blind confirmation. Use held-out entity/world/role combinations, randomized IDs, support-edge interventions and same-query opposite-context cases.

The old outputs653/689/237/60 are historical compatibility checks, not required semantic answers of the new model. Archive their original artifact/law. New model law or serialization may require new registered oracles; never overwrite old expected outputs or add a production branch returning them as constants.

## 9. Isolation, new sessions and board

Use a full independent clone with its own .git, no linked worktree, alternates, shared mutable IP cache or absolute output paths into old lane. Local fallback clone must use --no-hardlinks; remote clone preferred. A commit can be a source baseline, but cleanliness/ancestry alone does not make its behaviors accepted.

New manager and new Grok identities start UNBOUND. Bind each once with observed session ID, workspace and role. Never identify the old Grok by window title alone; do not resume old session019ffa1c-a65c-71e0-8521-7d285e7c2ffd as the Astra agent.

Local work proceeds without board. Final board is shared: resolve current owner, exact target, port and authorized artifact immediately before use. An empty local board-lock file is not a lease. Do not claim board available because a process is absent or because user plugged it in earlier. New branch starts PROGRAM=NO / COM12=UNTOUCHED, no authority inherited from V3.1.

Do not stop or edit old processes/builds to gain resources. Build concurrency has RAM/CPU limits; pause launching new heavy work locally if necessary rather than kill another lane.

## 10. Manager/implementer workflow

Manager owns authority interpretation, one next work order, acceptance review and durable handoff. New Grok owns implementation in new clone. One active writer per file and one current primary unknown. No proactive extra top-level sessions or cross-lane agent messaging.

Allow safe local fixes and tests within the assigned gate, preserving failed evidence and versioning changed laws. Do not bounce every small step to the user. After verified PASS, manager issues next dependency-ready work order. After FAIL, archive first divergence and route one bounded corrective experiment; acceptance/law changes require an explicit recorded decision, not editing expected results.

Every gate records PREREG, source/config/input hashes, actual command/exit/raw logs, metrics, limitations, verdict and residuals. Independent acceptance means checking data/code/logs, not echoing Grok's summary. OOC/XSIM/POST_ROUTE/BOARD remain separate.

Final declaration ASTRA_NATIVE_AI_BOARD_PASS requires same final artifact proving role-aware parsing, bounded evidence retrieval, valid novel relational conclusions, reward transfer, persistence, uncertainty, LM output and physical closure. It neither closes nor invalidates the old V3.1 project's Gate14.
