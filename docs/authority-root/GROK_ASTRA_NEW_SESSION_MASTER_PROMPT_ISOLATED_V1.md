# GROK ASTRA NEW-SESSION MASTER PROMPT — ISOLATED RESEARCH WORKSPACE

**Status:** Forward architecture research prompt  
**Target:** `Jokejoker-designer/FPGG_ART_Y` → ASTRA Native V1 research line  
**Important:** This version adds a mandatory **full isolated project copy / independent clone** so ASTRA research does not modify the existing V3.1 working folder.

---

You are taking over an FPGA Native AI project.

Your job is NOT to preserve old claims.
Your job is to preserve proven engineering assets and rebuild the AI capability layer
according to the new ASTRA design blueprint.

==================================================
REPOSITORY
==================================================

REPO:
https://github.com/Jokejoker-designer/FPGG_ART_Y

EXISTING LINEAGE BRANCH:
grok-orch/v31-canonical-00

KNOWN BASELINE COMMIT:
d166ca8edc8c01630efbcc648df8001f40dca572

First action:
verify the remote branch and commit lineage.

Do NOT assume the local tree is clean.
Do NOT assume d166ca8 is still remote HEAD.
Report:

REMOTE_HEAD
WORKTREE_HEAD
DIRTY_STATE
BASELINE_ANCESTRY

If current HEAD is a clean descendant of d166ca8,
use the latest clean descendant.

If history diverged:
STOP and report.

==================================================
NEW EXECUTION BRANCH
==================================================

Create/use a separate forward-development branch:

grok-orch/astra-native-v1-00

Do NOT rewrite:
grok-orch/v31-canonical-00

Do NOT squash historical evidence.
Do NOT amend old PASS/FAIL bags.

The old branch is historical evidence.
The new ASTRA branch is the forward architecture.


==================================================
ASTRA ISOLATED WORKSPACE — MANDATORY FULL PROJECT COPY
==================================================

Before ANY ASTRA RTL edit, create a completely separate project folder.

The ASTRA research session MUST NOT develop inside the existing V3.1 project folder.

Preferred method:
create a FULL INDEPENDENT GIT CLONE, not a shared git worktree.

Reason:
- preserve the original project folder untouched
- preserve historical evidence and local state
- avoid accidental cross-branch build/output contamination
- allow ASTRA experiments to add/remove/refactor modules freely
- keep independent `.git`, build directories, caches, logs and evidence bags

Required workspace law:

SOURCE_PROJECT_FOLDER
= current existing FPGG_ART_Y project folder

ASTRA_PROJECT_FOLDER
= a brand-new sibling or otherwise isolated folder

Recommended folder name:

FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH

Example only:

<parent>/
  FPGG_ART_Y/
  FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/

Do NOT reuse the original build directory.
Do NOT point Vivado generated outputs from ASTRA back into the old folder.
Do NOT share `.Xil`, `runs`, project cache, generated IP cache, simulation work,
temporary build products, evidence bags, or generated manifests by path.

Preferred creation flow:

1. Verify the authoritative remote HEAD and source lineage first.
2. Ensure every accepted source commit that ASTRA depends on is published.
3. Create a new full clone:

   git clone https://github.com/Jokejoker-designer/FPGG_ART_Y.git FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH

4. Enter the new clone.
5. Fetch all relevant refs.
6. Checkout the exact accepted baseline descendant.
7. Create/switch to:

   grok-orch/astra-native-v1-00

8. Confirm that the original project directory remains untouched.

If network cloning is unavailable but a local repository exists,
a full local clone is acceptable:

   git clone <SOURCE_PROJECT_FOLDER> <ASTRA_PROJECT_FOLDER>

But the resulting ASTRA folder must have its own independent `.git`
and must NOT be a `git worktree` sharing the original worktree state.

Do NOT use:

git worktree add ...

for this isolation requirement unless the owner explicitly overrides it.

==================================================
COPY LOCAL ASTRA AUTHORITY MATERIAL INTO THE NEW FOLDER
==================================================

The three local ASTRA documents currently live outside the repository.

After creating the isolated ASTRA clone, COPY them into the NEW ASTRA folder only.

Recommended destination:

docs/ASTRA/authority/

Copy:

AUDIT.md
DESIGN_CANDIDATE.md
HANDOFF_GROK.md

Also copy, if available:

UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md
APPENDIX_A_DOMAIN_TOKEN_EVIDENCE_TEACHER_REWARD_V1.md

Do NOT delete or move the originals.

Generate SHA256 for every copied authority document and record:

SOURCE_PATH
DESTINATION_PATH
SOURCE_SHA256
COPIED_SHA256
MATCH = YES/NO

PASS requires byte-identical copies.

If an authority document cannot be accessed:
STOP and report exactly which file is missing.
Do NOT recreate it from memory.

==================================================
ISOLATED WORKSPACE FREEZE RECORD
==================================================

ASTRA-00 must record:

SOURCE_PROJECT_FOLDER
ASTRA_PROJECT_FOLDER
SOURCE_REMOTE_HEAD
ASTRA_CLONE_HEAD
ASTRA_BRANCH
SOURCE_TREE_DIRTY_STATE
ASTRA_TREE_DIRTY_STATE
AUTHORITY_COPY_MANIFEST
ORIGINAL_FOLDER_TOUCHED = NO

Also record:

ORIGINAL_FOLDER_WRITE_COUNT = 0

for all ASTRA execution after the isolated clone is created.

The only allowed interaction with the old project after isolation is READ-ONLY
verification unless the owner explicitly authorizes otherwise.

==================================================
NO CROSS-WORKSPACE CONTAMINATION
==================================================

Forbidden:

- copying ASTRA-generated RTL back into the V3.1 working folder
- reusing old generated Vivado run directories as ASTRA outputs
- writing ASTRA evidence into old V3.1 evidence bags
- silently pulling ASTRA branch changes into v31-canonical-00
- using an old untracked/generated file without recording its source SHA
- treating the old folder and the ASTRA folder as interchangeable

If ASTRA needs a historical artifact from the old project:

READ it,
COPY it into the ASTRA workspace,
record SHA256 and provenance,
then use the ASTRA copy.

==================================================
ASTRA RESEARCH FOLDER CLAIM
==================================================

The isolated ASTRA folder is a research/development copy.

It does NOT replace:
grok-orch/v31-canonical-00

It does NOT invalidate:
historical PASS/FAIL evidence

It does NOT become project authority merely because it exists.

Promotion back to the main lineage requires a separate owner decision
after ASTRA acceptance gates and full co-fit evidence.


==================================================
DOCUMENT AUTHORITY
==================================================

Read these three local documents FIRST:

C:/Users/phant/.codex/.chatgpt-projects/g-p-68c95e6ae97c8191978788a39b2b2d1c/audits/NATIVE_AI_ASTRA_20260905/AUDIT.md

C:/Users/phant/.codex/.chatgpt-projects/g-p-68c95e6ae97c8191978788a39b2b2d1c/audits/NATIVE_AI_ASTRA_20260905/DESIGN_CANDIDATE.md

C:/Users/phant/.codex/.chatgpt-projects/g-p-68c95e6ae97c8191978788a39b2b2d1c/audits/NATIVE_AI_ASTRA_20260905/HANDOFF_GROK.md

Also read:

UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md
APPENDIX_A_DOMAIN_TOKEN_EVIDENCE_TEACHER_REWARD_V1.md

Authority for FORWARD ASTRA work:

1. AUDIT.md = evidence/claim correction
2. DESIGN_CANDIDATE.md = forward architecture candidate
3. HANDOFF_GROK.md = execution intent
4. V3.1 = historical architecture + proven constraints
5. frozen evidence bags = factual truth

Conflict law:

EVIDENCE > AUDIT CLAIM > ASTRA DESIGN CANDIDATE > OLD BLUEPRINT CLAIMS

Do NOT erase old evidence.
Do NOT reinterpret historical PASS as proving more than it actually proved.

==================================================
CORE DOCTRINE
==================================================

The project contains real FPGA hardware work and real computation.

But do NOT claim the system currently proves:

natural-language understanding
general reasoning
open-domain AI
meaningful language generation
800k semantic retrieval
autonomous knowledge acquisition

unless a new ASTRA gate explicitly proves it.

Use narrow capability language.

Preferred final target claim:

"An FPGA-native, memory-augmented domain reasoning system with
FPGA-owned structured query parsing, sparse evidence retrieval,
bounded relational inference, reward-adaptive evidence ranking,
persistent learned state, and FPGA-generated output tokens."

==================================================
DO NOT START OVER
==================================================

Preserve and reuse proven infrastructure where valid:

Arty A7-100T bring-up
MIG / DDR
AXI infrastructure
UART
DDR ping-pong
PHYS parallel scoring
Top-K machinery
fixed-point/saturating arithmetic
persistence framework
LM06 datapath where still valid
evidence methodology
query validity work from U4A-R6
4x4096 sparse directory geometry from U4-PRE0
existing board observability
existing frozen board evidence

Do NOT rebuild these merely because ASTRA changes the AI architecture.

Replace or refactor only where capability evidence requires it.

==================================================
KNOWN CURRENT FACTS
==================================================

Board:
Digilent Arty A7-100T
part xc7a100tcsg324-1

Historical final-observability board outputs exist:
653
689
237
60

Historical HOLD_A C9:
8382238122802120

These prove a real hardware chain under the historical benchmark.
They do NOT prove natural-language understanding.

Current important fixes already exist:

U4A-R6:
explicit route validity

PERSIST-IDENTITY-SCHEMA-V2:
two-beat full 32-bit subject/object persistence

U4-PRE0:
4 tables
4096 buckets
exact k0..k3
explicit valid bits
CAND_CAP=64
no synthetic XOR table keys

Do not regress them.

==================================================
KNOWN ARCHITECTURAL GAPS
==================================================

1. Current representation does not reliably preserve role direction.

Example falsifier:

"chiller supplies pump"
vs
"pump supplies chiller"

These must NOT collapse to the same semantic role representation.

2. Existing query frontend is a bounded lexicon/parser,
not proven learned language understanding.

3. Sparse retrieval quality is not proven at 800k scale.

4. Historical board query path used benchmark-oriented query mapping.

5. LM active != meaningful natural-language generation.

6. Existing learned prior is largely identity-specific and does not yet prove transfer.

7. Full current HEAD co-fit has not been proven.

8. C7_ADDR still has low-16-bit observe-only identity truncation.
It is telemetry debt, not canonical identity.

==================================================
ASTRA TARGET ARCHITECTURE
==================================================

Target path:

raw text/tokens
→ FPGA-owned structured parser
→ subject / relation / object / context
→ sparse retrieval
→ evidence candidate set
→ bounded relational inference
→ proof-path validation
→ learned ranking
→ evidence package
→ LM06
→ FPGA-generated output tokens

Host roles:

keyboard/input
tokenization if fixed deterministic codec
UART framing
DDR image loading
logging
scalar reward

Host MUST NOT provide:

subject
object
relation
intent
semantic cue
bucket
candidate list
winner
proof path
evidence address
next token
final answer

==================================================
ASTRA STRUCTURED QUERY LAW
==================================================

The query representation must preserve at least:

subject identity
relation identity
object identity
direction
context
validity

Required behavioral distinction:

A relation B
!=
B relation A

Do not call bag-of-keywords matching "relational understanding".

Parser may initially be deterministic and domain-bounded.

That is allowed.

Do NOT falsely label a deterministic parser as learned language understanding.

==================================================
ASTRA RELATIONAL INFERENCE
==================================================

Implement a bounded finite reasoning engine.

Preferred model:
Horn/Datalog-style rules with explicit variable binding.

Example:

requires(A,B)
requires(B,C)
→ depends_indirectly(A,C)

The conclusion must NOT need to exist as a stored fact.

Rules must be explicitly typed.

Do NOT assume all relations are transitive.

Maintain a rule table such as:

rule_id
lhs_relation_0
lhs_relation_1
direction constraints
rhs_relation
max_hop
enabled

Initial bounded target:

MAX_HOPS = 2

Only expand to 3 hops if evidence and resources justify it.

==================================================
PROOF PATH IS MANDATORY
==================================================

A reasoning result is not PASS merely because the final answer matches.

A successful inferred conclusion must expose:

proof_length
rule_id
support_edge_0
support_edge_1
derived_relation
subject
object
confidence/status

Acceptance must include causal perturbation.

Example:

Facts:
A requires B
B requires C

Query:
Does A depend indirectly on C?

Expected:
YES
proof=A→B→C

Then mutate corpus:

remove B→C

Expected:
NO / UNKNOWN

Then replace:

B→D

Expected:
A depends indirectly on D,
not C.

If answer does not change with causal evidence,
reasoning FAILS.

==================================================
ASTRA LEARNING TARGET
==================================================

Do NOT add a large neural network merely to use the word "AI".

Preferred learner:

shared fixed-point linear reward predictor.

Approximately:

32 features

r_hat = w^T phi(query, path)

update:

w <- SAT(
  w + eta * (reward - r_hat) * phi
)

Exact fixed-point widths and eta must be evidence-gated.

Do NOT freeze them without experiments.

Features may include:

query-relation match
direction match
context match
source confidence
path length
rule type
conflict indicator
evidence age
retrieval margin
support count
unknown-state indicators

==================================================
PENDING TRANSACTION LAW
==================================================

When FPGA chooses an answer/path,
it stores its own pending transaction:

txn_id
query representation
selected evidence IDs
proof path
feature vector phi
predicted reward
generation

Teacher/user sends ONLY:

txn_id
scalar reward

Teacher does NOT select:
which evidence to update
which weight to update
which path should have won

The FPGA applies the update from its own saved transaction.

==================================================
LEARNING ACCEPTANCE
==================================================

Training-set improvement is NOT enough.

Must compare at least:

A. shared-feature learner enabled
B. weights frozen
C. shuffled reward
D. existing/per-ID prior baseline

On HELD-OUT entities/relations:

gain(A) > gain(B)
gain(A) > gain(C)

and ideally:

gain(A) > gain(D)

Only then claim transferable reward learning.

==================================================
UNKNOWN / CONFLICT / SEARCH_INCOMPLETE
==================================================

System must support explicit non-answer states:

UNKNOWN
CONFLICT
SEARCH_INCOMPLETE

UNKNOWN:
no sufficient evidence

CONFLICT:
credible contradictory evidence

SEARCH_INCOMPLETE:
candidate/path cap or overflow prevents a safe conclusion

Never turn retrieval overflow into confident false answer.

Reward cannot create missing facts.

NO EVIDENCE + NO NEW DATA = STILL UNKNOWN

==================================================
LM06 CLAIM LAW
==================================================

Do not assume LM06 produces meaningful text.

Audit before claim:

TOKENIZER_VERSION
VOCAB_VERSION
CHECKPOINT_SHA
training/checkpoint provenance
input token IDs
output token IDs
detokenized text
held-out prompts

CPU may map output token ID → text.

CPU must NOT map:
class ID → hand-written semantic sentence

If FPGA only emits class=653 and host writes the answer,
that is not FPGA-generated language.

==================================================
RESOURCE LAW
==================================================

Arty A7-100T is resource-constrained.

Historical U2R candidate approximately:

LUT 36911
FF 45656
BRAM36-equivalent 106.5
DSP 19
free slices 313
WNS +1.126 ns
WHS +0.014 ns

Treat these only as historical candidate numbers,
not proof of current HEAD fit.

313 free slices is a serious constraint.

Therefore:

REMOVE / REUSE before ADD.

Prefer:

one authoritative retrieval path
shared MACs
BRAM-backed state
sequential comparators
bounded frontier
bounded beam
bounded hops
bounded candidates
DDR backing for bulk data

Avoid duplicate old+new architectures existing simultaneously.

==================================================
RESOURCE OPTIMIZATION CANDIDATES
==================================================

Evaluate, do not assume:

- sequential ROM/trie parser instead of wide parallel lexicon comparators
- BRAM dedup with sequential compare
- logits/state migration LUTRAM → BRAM where scheduler can absorb latency
- reuse old retrieval BRAM after unified sparse path replaces it
- shared arithmetic between scorer/reasoner/learner
- bounded frontier queues in BRAM
- fixed-point learner without DSP explosion

Every new major block should get:

OOC synth
resource delta
timing estimate

before full integration.

==================================================
EXECUTION DAG
==================================================

Do NOT jump directly to reasoning.

Execute this order:

ASTRA-00 BASELINE-AUTHORITY-FREEZE
↓
ASTRA-01 U4-REAL-AXI-SPARSE-INTEGRATION
↓
ASTRA-02 U5-SCALE-SELECTIVITY-800K
↓
ASTRA-03 ROLE-AWARE-QUERY-REPRESENTATION
↓
ASTRA-04 RELATION-ENGINE-2HOP
↓
ASTRA-05 CAUSAL-PROOF-PERTURBATION
↓
ASTRA-06 SHARED-REWARD-LEARNER
↓
ASTRA-07 HELD-OUT-TRANSFER
↓
ASTRA-08 LM06-VOCAB-CHECKPOINT-AUDIT
↓
ASTRA-09 UNIFIED-PIPELINE
↓
ASTRA-10 OOC-RESOURCE-RECONCILIATION
↓
ASTRA-11 FULLCHIP-COFIT
↓
ASTRA-12 FINAL-SOURCE-FREEZE
↓
ASTRA-13 FINAL-BOARD-ACCEPTANCE

==================================================
ASTRA-00
==================================================

First gate only:

ASTRA-00-BASELINE-AUTHORITY-FREEZE

No RTL edit.

Produce:

CURRENT_REMOTE_HEAD
BASE_COMMIT
TREE_STATUS
proven blocks
unproven claims
known defects
open residuals
files/modules intended to reuse
files/modules intended to retire
resource baseline references

Freeze a forward architecture manifest.

BIT=NO
PROGRAM=NO
COM12=UNTOUCHED

==================================================
ASTRA-01
REAL AXI SPARSE INTEGRATION
==================================================

Primary unknown:

Can raw FPGA query processing drive the exact 4x4096 AXI directory
and reproduce independent host-golden candidate IDs?

Must compare:

query packet
valid bits
keys
directory addresses
posting addresses
pre-dedup IDs
post-dedup IDs
bounded candidate stream

No host semantic help.

This is implementation correctness,
not 800k semantic-quality proof.

==================================================
ASTRA-02
800K SCALE/SELECTIVITY
==================================================

Do not call occupancy semantic recall.

Use independent gold.

Test scale ladder:

256
4096
16384
65536
262144
800000

Measure:

recall
precision
candidate reduction
candidate count
bytes/query
overflow
bucket skew
posting lengths
dedup
latency

Include unrelated queries.

Include relevant records in overflow/adversarial buckets.

A high-address sentinel alone is NOT enough.

If quality fails:
return to router architecture.

Do not lower threshold to save the design.

==================================================
ASTRA-03
ROLE-AWARE QUERY
==================================================

Primary unknown:

Can the parser preserve ordered semantic roles?

Mandatory falsifiers:

A supplies B
B supplies A

A requires B
B requires A

same words
different direction

Expected:
different structured packets.

Also test:
paraphrases within supported domain vocabulary.

Do not claim open natural-language understanding.

==================================================
ASTRA-04
2-HOP RELATIONAL ENGINE
==================================================

Implement bounded rule engine.

No LM required for this gate.

Input:
structured query + candidate facts

Output:
derived result + proof path

Test:
stored fact
1-hop
2-hop
invalid chain
wrong direction
non-transitive relation
cycle
duplicate edge
missing edge

==================================================
ASTRA-05
CAUSAL REASONING
==================================================

This is mandatory before "reasoning" claim.

Corpus mutation must change the answer.

Delete support edge:
conclusion disappears.

Replace support edge:
conclusion changes.

Add contradiction:
CONFLICT or rule-defined result.

Cap search before completion:
SEARCH_INCOMPLETE.

==================================================
ASTRA-06/07
LEARNING
==================================================

Introduce the shared learner only after reasoning behavior is stable.

Do not let learning hide retrieval/reasoning defects.

Run deterministic reward sequences.

Then held-out transfer.

Required baselines:
enabled
frozen
shuffled reward
per-ID prior

Archive all seeds.

==================================================
ASTRA-08
LM06 AUDIT
==================================================

Determine whether LM06 can produce meaningful output tokens.

Do not redesign it before audit.

If checkpoint/vocab are insufficient:
classify honestly.

Possible outcomes:

LM06_GENERATION_PROVEN
LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN
LM06_REQUIRES_RETRAINING

==================================================
ASTRA-09
UNIFIED PIPELINE
==================================================

Only now integrate:

raw query
→ parser
→ sparse retrieval
→ reasoning
→ learned ranking
→ evidence
→ LM06
→ output token

No synthetic production path.

No benchmark qid path.

==================================================
PROGRAM POLICY
==================================================

PROGRAM=NO until:

full current ASTRA pipeline
synth PASS
impl PASS
timing PASS
route PASS
DRC PASS
resource co-fit PASS
preprogram closure PASS

Board is the FINAL falsification instrument,
not the debugger.

Do not touch COM12 before final preprogram gate.

==================================================
EVIDENCE CLASSES
==================================================

Use:

BOARD
POST_ROUTE
MIG_XSIM
XSIM
OOC
RTL_FACT
HOST_MODEL
HYPOTHESIS
ENGINEERING

Do not mix them.

==================================================
FINDING CLASSES
==================================================

Use:

CONFIRMED_ROOT_CAUSE
CONFIRMED_DEFECT
HIGH_RISK_ARCHITECTURAL_HAZARD
LATENT_DEFECT
EVIDENCE_GAP
CODE_CLEANLINESS_DEBT
FALSIFIED
NOT_REACHABLE
INCONCLUSIVE

==================================================
ROOT-CAUSE METHOD
==================================================

SYMPTOM
→ FIRST_DIVERGENCE
→ VIOLATED_INVARIANT
→ ARCHITECTURAL OWNER
→ DUPLICATE IMPLEMENTATIONS
→ DOWNSTREAM EFFECTS

One causal unknown per experiment.

==================================================
EVIDENCE BAG LAW
==================================================

Every gate gets:

PREREG.md
LOCK.txt
RESULTS.md
METRICS.json
CLOSEOUT.md
raw logs
SHA256.txt

CLOSEOUT must state:

GATE
BASE
SOURCE_COMMIT
FILES_CHANGED
RTL_EDIT
PRIMARY_UNKNOWN
RESULT
EVIDENCE_CLASS
FIRST_DIVERGENCE
VIOLATED_INVARIANT
FALSIFIED_ALTERNATIVES
RESOURCE_DELTA
BIT_BUILD
PROGRAM
NEXT

==================================================
CLAIM DISCIPLINE
==================================================

Never convert:

"module active"
into
"AI capability proven"

Never convert:

"output matched"
into
"reasoning proven"

Never convert:

"recall=1"
into
"retrieval quality proven"
without precision/selectivity.

Never convert:

"reward changed state"
into
"generalized learning proven"

Never convert:

"LM start/done"
into
"meaningful language generation proven"

==================================================
AUTO-ADVANCE POLICY
==================================================

After a PASS:
automatically proceed to the next DAG gate.

After a FAIL:
STOP.

Do not patch across multiple unknowns.

Return:

BLOCKER
FIRST_DIVERGENCE
VIOLATED_INVARIANT
EVIDENCE_CLASS
AFFECTED_MODULE
AFFECTED_COMMIT
WHY CONTINUATION_IS_UNSAFE
SMALLEST_NEXT_EXPERIMENT

==================================================
ABSOLUTE PROHIBITIONS
==================================================

NO benchmark-ID shortcuts in production.

NO hidden host semantic cues.

NO hard-coded answer mapping.

NO relevant=set(router_union).

NO CRC used as semantic routing.

NO full 800k scan disguised as sparse retrieval.

NO lossy identity hash.

NO key==0 used as semantic validity.

NO silently changing thresholds after seeing results.

NO programming intermediate candidates.

NO claiming general AI.

==================================================
BEGIN NOW
==================================================

1. Read all authority documents.
2. Verify repo/branch/commit state.
3. Create the mandatory FULL ISOLATED ASTRA project clone/folder:
   FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
4. Copy the ASTRA authority documents into:
   docs/ASTRA/authority/
   and verify SHA256 byte identity.
5. In the NEW ASTRA folder only, create or switch to:
   grok-orch/astra-native-v1-00
6. Execute:
   ASTRA-00-BASELINE-AUTHORITY-FREEZE
7. Record SOURCE_PROJECT_FOLDER and ASTRA_PROJECT_FOLDER and prove:
   ORIGINAL_FOLDER_TOUCHED = NO
8. Report the exact forward DAG and NEXT.
9. Continue automatically only after ASTRA-00 PASS.

Do NOT ask for permission after an ordinary PASS.

TRUTH > PROGRESS
CAUSAL EVIDENCE > MATCHED OUTPUT
TRANSFER > MEMORIZATION
PROOF PATH > CLASS LABEL
CO-FIT > FEATURE COUNT