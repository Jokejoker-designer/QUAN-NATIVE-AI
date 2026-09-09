# WO-FINAL-ASTRA-C4-C7-CONVERGENCE-20260909

**Project:** QUAN / ASTRA Native AI  
**Target:** Digilent Arty A7-100T — `xc7a100tcsg324-1`  
**Primary local repository:** `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`  
**Intended branch:** `grok-orch/astra-native-v1-00`  
**Public mirror/reference:** `Jokejoker-designer/QUAN-NATIVE-AI`  
**C4 rescue workspace:** `D:\FPGA\C4_RESCUE_20260909`  
**Final target:** `ASTRA_NATIVE_AI_BOARD_PASS`  
**Execution owner:** Cursor  
**Policy:** TRUTH > PROGRESS. One authoritative production path. No host semantic authority. No intermediate board programming.

---

# 0. MISSION

Close the remaining ASTRA chain from C4 through C7 without changing the already-proven C1/C2/C3 semantics except where an integration bug is explicitly demonstrated.

The final accepted artifact must be one physical bitstream that, on the same Arty A7-100T board, demonstrates the complete bounded-domain path:

```text
raw UART bytes/tokens
→ FPGA role-aware parser
→ same-law sparse retrieval
→ bounded candidate descriptors
→ learned ranker
→ typed 1/2-hop reasoning + proof
→ uncertainty/status
→ evidence materializer
→ C4 D32 learned autoregressive decoder
→ deterministic refusal on non-ANSWER
→ token FIFO
→ UART 115200

completed FPGA decision
→ FPGA-owned pending transaction
→ host scalar reward only
→ FPGA validates transaction
→ SGD32 update
→ atomic DDR persistence
→ reload/replay
```

`ASTRA_NATIVE_AI_BOARD_PASS` is forbidden until the **same final bitstream** proves parsing, retrieval, proof-backed reasoning, uncertainty/refusal, reward adaptation, persistence, C4 output, and physical closure.

---

# 1. AUTHORITY AND NON-NEGOTIABLE FACTS

Use this authority order:

1. Latest explicit human direction and this WO.
2. ASTRA Native AI Master / current authority docs in the local ASTRA repository.
3. Frozen experiment preregistration and actual raw evidence.
4. Current local RTL + model/checkpoint/manifest hashes.
5. Public GitHub mirror only as a baseline/reference when local work is newer.
6. Historical V3.1 artifacts are regression/background only.

Evidence overrides summaries. Never promote a report into a capability claim without the underlying logs/data.

The following facts are mandatory starting assumptions unless the live local source proves a newer version:

- Canonical C3 status width is 4 bits.
- `ANSWER = 4'd0`.
- `UNKNOWN = 4'd1`.
- `CONFLICT = 4'd5`.
- `SEARCH_INCOMPLETE = 4'd6`.
- `AMBIGUOUS = 4'd7`.
- `NEG = 4'd8`.
- Do **not** use `3'd1` or any numeric magic constant for ANSWER.
- The historical `a7ng_astra_c4_lm06_red.sv` public module is a D4/F8 reduced decoder and is **not** numerically compatible with the rescued D32 model.
- The rescued C4 model is D32 with F/R-isolated learned banks; exact tensor names, F width, scales, LUTs and offsets must come from the rescue checkpoint/quantization manifest, not from memory or this WO.
- The existing D4 RED RTL already contains a deterministic `S_SAFE` state that emits `n`, `o`, `EOS`. Reuse the refusal concept, but do not confuse that D4 module with the final D32 learned decoder.
- Reverse rescue evidence reported: old 20-set `20/20`, new disjoint F/R set `228/240 = 95%`, float/integer token parity on those sets. Treat these as development/rescue evidence, not the new blind final confirmation.
- Unsupported-safe previously remained `0/120` at the learned-model level. The final architecture intentionally makes non-ANSWER refusal a deterministic system safety behavior; do not claim the LM learned refusal.
- Public C5 fixes exist as separate named candidates (`*_rew`, `*_stream`, `*_resp`, `*_ckpt*`, `*_pend*`). Their existence is not a unified C5 PASS. Cursor must integrate and retest one final hierarchy.
- Public `a7ng_astra_c6_wholechip.sv` still instantiates the older `a7ng_astra_c5_prod_top`; it is not the final whole-chip authority.

---

# 2. ABSOLUTE PROHIBITIONS

Cursor must not do any of the following:

- No host-provided subject, relation, object, direction, target slot, bucket, candidate, winner, proof path, evidence address, next token or final answer.
- No prompt/query ID → answer table.
- No benchmark-specific bypass.
- No `target_slot` used as a hidden gold label.
- No `evid_has` alone as semantic authority.
- No low-byte/low-16 identity used as canonical semantic identity.
- No full 800k scan disguised as sparse retrieval.
- No fabricated AXI `OKAY` response in the final path.
- No auto `+3` reward on ANSWER.
- No persistence of only `w0` when the active learner is SGD32.
- No last-token-only UART output.
- No simulation UART constants such as `8000/800` in the silicon hierarchy.
- No loading a D32 checkpoint into D4/F8 RTL.
- No replacing scale-aware integer inference with arbitrary shifts such as `>>>4`, `/16`, or unscaled weight rounding unless the frozen D32 manifest explicitly requires it.
- No changing thresholds after seeing final confirmation results.
- No using the safety gate to hide a C4 that does not causally depend on learned weights/evidence on the ANSWER path.
- No board programming before C6 freeze/physical closure.
- No combining evidence from two different bitstreams into one BOARD_PASS.
- No deleting failed evidence, resetting the repository destructively, or cleaning away today's uncommitted work.

---

# 3. FINAL ARCHITECTURE CONTRACT

The final semantic boundary is:

```text
                         C3 / PROOF ENGINE
                               │
                 status + n_path + proof acceptance
                               │
                    CANONICAL ANSWER GATE
                               │
             ┌─────────────────┴─────────────────┐
             │                                   │
     ANSWER_ALLOWED=1                    ANSWER_ALLOWED=0
             │                                   │
   materialized proof/evidence              deterministic
             │                              refusal FSM
             │                              "n"→"o"→EOS
             ▼                                   │
     C4 D32 F/R learned                           │
    autoregressive decoder                       │
             └─────────────────┬─────────────────┘
                               ▼
                         TOKEN FIFO
                               ▼
                         UART 115200
```

The final gate is conceptually:

```systemverilog
answer_allowed =
    (c3_status == CANONICAL_C3_ST_ANSWER)
    && (c3_npath != 0)
    && c3_proof_ok;
```

Important implementation law:

- `CANONICAL_C3_ST_ANSWER` must come from the authoritative C3 status package/include. Do not duplicate a new numeric definition in C5.
- `c3_proof_ok` must represent the real proof-checker acceptance. If the current C3 API does not expose it, expose the existing internal proof-valid result or prove and assert the invariant that `status==ANSWER` can only occur after proof acceptance. Do **not** fake `proof_ok=1`.
- `CONFLICT`, `SEARCH_INCOMPLETE`, `AMBIGUOUS`, `UNKNOWN`, and other non-ANSWER terminal states must never enter factual C4 generation.
- Bank F/R selection for the learned decoder must come from FPGA-owned query direction/role state. It must not come from a host bit or a hidden target-slot label.

The system report must state explicitly:

```text
SUPPORTED ANSWER PATH = learned C4 generation
NON-ANSWER PATH       = deterministic hardware refusal
```

Never write “C4 learned to refuse” unless a separate experiment actually proves that.

---

# 4. EVIDENCE BAG ROOT

Create one final root:

```text
results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/
```

Create these sub-bags:

```text
00_PREFLIGHT/
10_C4_MODEL_FREEZE/
11_C4_BLIND_CONFIRM/
12_C4_D32_RTL/
13_C4_DIFFERENTIAL/
14_C4_OOC/
20_C5_UNIFIED/
21_C5_SYSTEM_XSIM/
22_C5_MIG_STALL_REPLAY/
30_C6_FREEZE/
31_C6_IMPL/
40_C7_PREREG/
41_C7_BOARD/
FINAL_RECONCILIATION/
```

Every major bag must contain, where applicable:

```text
PREREG.md
LOCK.txt
RESULTS.md
METRICS.json
CLOSEOUT.md
SHA256.txt
logs/
```

`CLOSEOUT.md` must record:

```text
GATE
BASE_COMMIT
SOURCE_COMMIT
TREE_STATUS
FILES_CHANGED
PRIMARY_UNKNOWN
FIRST_DIVERGENCE
VIOLATED_INVARIANT
ACTUAL_COMMANDS
ACTUAL_EXIT_CODES
METRICS
RESOURCE_DELTA
EVIDENCE_CLASS
RESULT
LIMITATIONS
BIT_BUILD
PROGRAM
NEXT
```

---

# 5. STAGE 0 — PREFLIGHT / PRESERVE TODAY'S WORK

Before editing RTL:

```powershell
cd D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git status --short
git diff --stat
git diff
```

Record outputs verbatim.

Rules:

- If today's F1/F2/C4/C5 fixes are uncommitted, preserve them first. Do not `reset --hard`, `clean -fdx`, checkout over them, or discard them.
- Record SHA256 of the rescue artifacts:
  - `D:\FPGA\C4_RESCUE_20260909\train_c4_reverse_isolated.py`
  - `D:\FPGA\C4_RESCUE_20260909\reverse_isolated_identity01\best_dev.npz`
  - `D:\FPGA\C4_RESCUE_20260909\reverse_isolated_identity01_ptq\quant_manifest.json`
  - every `.hex` generated from the accepted checkpoint
  - `quantize_c4_parity.py`
- Inventory current local versions of:
  - C3 status/proof package
  - C3 pending-load wrapper
  - C5 explicit reward candidate
  - C5 SGD32 checkpoint/pending candidate
  - checkpoint atomicity marker/CRC changes
  - allocator watermark replay changes
  - UART stream candidate
  - AXI response/error candidate
  - C6 whole-chip wrapper.
- Do not assume the public GitHub mirror contains the newest local fixes.

PASS condition for Stage 0: exact source baseline, rescue artifact hashes, dirty-tree preservation, and candidate-module inventory are frozen.

---

# 6. STAGE 1 — FREEZE THE RESCUED C4 NUMERICAL LAW

## 6.1 Checkpoint authority

Use:

```text
D:\FPGA\C4_RESCUE_20260909\reverse_isolated_identity01\best_dev.npz
```

and the corresponding PTQ manifest as the numerical authority.

Do not retrain F/R during final convergence unless the new blind confirmation fails the frozen quality threshold. If blind confirmation fails, archive the failure first and return to a bounded C4 model correction; do not patch the benchmark.

## 6.2 Generate a machine-readable numerical contract

Create:

```text
C4_D32_NUMERICAL_CONTRACT_V1.json
```

It must be generated from the actual checkpoint/manifest and contain at minimum:

- architecture version
- vocab size/version
- D
- F
- context length
- max generation length
- seed token law
- EOS token
- all tensor names
- every tensor shape
- F/R bank selection law
- every quantization scale
- activation widths
- accumulator widths
- rounding mode
- saturation law
- requantization law
- integer softmax/LUT law if used
- token feedback law
- weight file offsets
- `.hex` file names and SHA256
- checkpoint SHA256
- quant manifest SHA256.

If the actual manifest says something different from “D32/F64”, the actual manifest wins. Record the mismatch and use the actual frozen architecture. Do not silently force F64.

## 6.3 Freeze context/materializer contract

Read `train_c4_reverse_isolated.py` and the integer reference implementation. Extract the exact context seen by the model.

Create:

```text
C4_CONTEXT_CONTRACT_V1.md
C4_CONTEXT_CONTRACT_V1.json
```

Freeze:

- byte/token encoding
- exact field order
- slot ordering
- separators
- direction/role encoding
- maximum context length
- seed/prefix rules
- how F vs R bank is selected
- what data comes from C3/proof/descriptor memory
- what is forbidden from host input.

The final RTL materializer must create this context from FPGA-owned evidence/proof data. It must not inject the expected answer from the test harness.

---

# 7. STAGE 2 — NEW BLIND C4 CONFIRMATION

Create and hash the confirm set **before running the frozen model**.

Use exactly 360 cases:

```text
SUPPORTED 240
  120 Forward
  120 Reverse

UNSUPPORTED 120
  20 unrelated
  20 missing evidence
  20 wrong context
  20 conflict
  20 ambiguous
  20 search incomplete
```

Requirements:

- Supported entities/world combinations are disjoint from train/dev/rescue selection sets.
- Unsupported cases are not trivial string duplicates.
- IDs are randomized independently of semantics.
- Confirm set SHA is frozen before inference.
- Do not edit examples after seeing failures.

Run both float and exported integer inference.

C4 numerical PASS requires all of:

```text
overall grounded accuracy        >= 90%
Forward grounded accuracy        >= 90%
Reverse grounded accuracy        >= 90%
unsupported safe response        >= 95%
unsupported factual hallucination <= 5%
termination                     = 100%
float vs integer token sequence = 360/360 exact
```

For unsupported cases, the final **system-level** expected response is the registered refusal contract `n → o → EOS`. Report learned-model unsupported behavior separately; do not hide it.

Confusion matrix must distinguish:

```text
SUPPORTED:
  allowed_correct
  allowed_wrong
  false_refuse

UNSUPPORTED:
  safe_refuse
  unsafe_accept
  hallucinated_fact
```

Use:

```text
grounded_accuracy = allowed_correct / supported_total
safe_rate         = safe_refuse / unsupported_total
hallucination     = factual_output_on_unsupported / unsupported_total
```

Do not substitute `gate_allowed/supported_total` for grounded accuracy.

---

# 8. STAGE 3 — C4 CAUSAL ABLATIONS

Safety-gate tests and learned-decoder tests are separate experiments.

## 8.1 End-to-end safety ablation

Change evidence/status before the semantic gate.

Expected:

```text
proof lost / UNKNOWN / CONFLICT / AMBIGUOUS / INCOMPLETE
→ answer_allowed = 0
→ deterministic refusal
```

This proves the safety boundary, not C4 learned grounding.

## 8.2 Learned C4 causal ablation

Hold the synthetic test harness state at:

```text
status = ANSWER
answer_allowed = 1
```

Then vary only C4 inputs/weights.

Run:

```text
A. Normal weights
B. Zero learned weights
C. Corrupted learned weights
D. Decisive evidence removed from C4 context while gate held open
E. Decisive evidence replaced while gate held open
F. Prefix/seed/token-feedback intervention
G. Force wrong F/R bank only as a diagnostic
```

Required evidence:

- Normal weights meet the supported quality gate.
- Zero/corrupt controls materially degrade supported generation; preregister a minimum degradation before viewing blind results. Recommended final contract: `>=20 percentage-point` grounded-accuracy loss versus Normal on the ablation subset.
- Evidence replacement must change output toward the replacement evidence on the preregistered paired cases.
- Evidence removal must materially collapse factual accuracy or alter the output distribution/sequence; the safety gate must not be allowed to mask this test.
- Prefix/previous-token intervention must change at least one subsequent token score/top-1 choice on preregistered causal probes.
- Wrong-bank diagnostic must affect direction-sensitive examples, proving the F/R bank is on the active path.

If a recommended numeric ablation threshold is impossible to preregister for a specific diagnostic, preregister the exact paired observable before running; never invent a PASS criterion after results.

---

# 9. STAGE 4 — PORT THE EXACT D32 INTEGER MODEL TO RTL

Create a new versioned module. Do not mutate the D4 module into pretending it is D32.

Preferred names:

```text
rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1.sv
rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1.svh
```

The RTL numerical datapath must implement the **integer reference**, not the float model.

Mandatory:

- INT8 weights exactly as exported.
- Activation widths exactly as the contract.
- MAC accumulator width exactly as the integer reference, expected MAC32 unless manifest differs.
- Exact requantization scales.
- Exact signed rounding.
- Exact saturation.
- Exact integer softmax/LUT if present.
- Exact F/R bank selection.
- Exact autoregressive previous-token feedback.
- Exact EOS/max-length termination.
- Full token stream output.
- `n_host_tok_o = 0` or equivalent proof that host never supplies next token.

Do not copy the D4 RED arithmetic (`shift-by-4`, D4 loops, ReLU-attention approximation) unless the D32 numerical contract independently requires the same operation.

Add diagnostic counters only if they do not alter semantics:

```text
n_mac
n_tokens
sat_count
overflow_count
selected_bank
```

## RTL unit differential

For each frozen C4 confirm case:

```text
Python integer reference token stream
vs
RTL token stream
```

must be byte/token exact.

Required:

```text
RTL vs integer Python = 360/360 exact
```

Also run targeted internal traces on at least:

- one Forward supported case
- one Reverse supported case
- one replaced-evidence case
- one zero-weight case
- one refusal case.

At the first mismatch, stop the differential run and archive:

```text
first mismatching layer/state
expected integer value
RTL value
tensor/index
cycle
rounding/saturation state
```

Do not patch multiple numerical stages at once.

---

# 10. STAGE 5 — DETERMINISTIC REFUSAL FSM + SEMANTIC GATE

Implement the refusal logic in the final D32 wrapper or adjacent semantic gateway.

Use symbolic C3 status constants only.

Do not use an “entity logit mask” to assume the decoder will naturally spell `no`. BYTE256 does not have a clean entity-token partition.

The refusal path is deterministic:

```text
state 0 → 0x6E ('n')
state 1 → 0x6F ('o')
state 2 → EOS
```

Freeze whether EOS is serialized onto UART or consumed internally. The Python golden, RTL XSim, and board script must use one identical `UART_RESPONSE_V1` contract.

Add assertions:

```text
non_answer |-> !factual_decoder_go
answer_allowed |-> c3_status == ANSWER
answer_allowed |-> c3_npath != 0
ANSWER status |-> proof accepted
CONFLICT/INCOMP/AMB/UNKNOWN |-> refusal path
```

No non-ANSWER case may enter learned factual decoding.

---

# 11. STAGE 6 — MATERIALIZER: C3 PROOF → C4 CONTEXT

This is a mandatory final integration step.

The final C4 must not receive only a low-byte answer ID.

Materialize semantic evidence/proof content according to `C4_CONTEXT_CONTRACT_V1`.

Inputs may include, as declared by the frozen contract:

```text
query subject / relation / direction / context
selected proof edge IDs
descriptor/entity symbols from DDR dictionary
proof path order
answer-side evidence
```

Requirements:

- Data comes from FPGA-owned parser/retrieval/proof outputs and versioned DDR/BRAM dictionary/descriptor images.
- Host does not provide a sentence, target slot, answer entity or evidence address.
- Same C3 proof with replaced decisive evidence changes the materialized context.
- The materializer preserves F/R role direction.
- Context truncation must be explicit; overflow cannot silently reorder or drop the decisive field.
- Context bytes seen by RTL must match the independent Python materializer golden.

Create a materializer differential test before full C5 integration.

---

# 12. STAGE 7 — OOC SYNTHESIS OF D32 C4

Before merging into C5, run out-of-context synthesis for the new D32 module with the exact final numerical contract.

Report:

```text
LUT
FF
BRAM36/18
DSP
estimated Fmax / worst path
ROM/RAM inference
critical warnings
```

If D32 does not fit the expected whole-chip budget, allow **one bounded bit-exact microarchitecture optimization**:

- sequentialize/time-share MACs
- infer BRAM/ROM for weights/state
- reuse arithmetic across phases
- reduce duplicate storage
- pipeline without changing integer semantics.

Forbidden physical “fixes”:

- reducing D/F
- changing quant scales
- dropping F/R bank
- replacing learned decoder with dictionary/template output
- removing autoregressive feedback
- changing accepted model quality

unless C4 is explicitly reopened and the new architecture repeats blind confirmation.

After any RTL microarchitecture change, rerun C4 differential.

---

# 13. C4 CLOSE CONDITION

Stamp only a local `C4_MASTER_PASS` evidence marker if all are true:

```text
new blind 360 set frozen before run
Grounded overall >=90%
Forward >=90%
Reverse >=90%
Safe >=95%
Hallucination <=5%
Termination 100%
Float/int parity 100%
RTL/int parity 100%
learned causal ablations PASS
semantic gate/refusal PASS
materializer differential PASS
D32 OOC synthesis completed and reviewable
no host semantic/token authority
```

Do not call `ASTRA_NATIVE_AI_BOARD_PASS` here.

---

# 14. STAGE 8 — BUILD ONE FINAL C5 PRODUCTION HIERARCHY

Do not keep “feature proof by sibling modules” as the final design.

Create one final versioned production top, for example:

```text
a7ng_astra_c5_prod_top_final_v1.sv
a7ng_astra_c5_prod_top_final_v1.svh
```

It must integrate the verified behavior from the current candidate lanes:

- real C3 parser/retrieval/reasoning/proof
- C3 pending-load/replay if required
- explicit UART scalar reward
- full SGD32 weight state
- pending proof/phi transaction state
- atomic checkpoint marker/sequence/CRC
- allocator replay/watermark recovery
- AXI response/error propagation
- D32 C4 + semantic safety gate
- evidence materializer
- full token FIFO
- real 115200-baud UART.

The final top must not instantiate the old D4 `grounded_gen` as the production language authority.

## 14.1 Reward contract

Remove every automatic reward such as:

```text
ANSWER → +3
```

Host reward authority is limited to transport metadata + scalar reward.

Preferred semantic payload:

```text
txn_id
scalar_reward [-3,+3]
```

Transport may contain version/length/CRC and non-semantic anti-replay metadata, but those fields must never choose the winner/evidence/answer.

FPGA must validate reward against its own pending transaction.

Tests:

```text
valid reward
duplicate reward
stale txn
wrong txn
bad CRC
bad length
reward before pending
reward after retire
reward after reload
```

Only a valid matching pending transaction can update weights.

## 14.2 Full learning-state persistence

Persist/restore the active learned state, not only `w0`.

At minimum final chosen schema must preserve:

```text
w[0:31]
pending txn identity
pending selected proof/path IDs
phi[0:31]
generation/model/schema version
allocator/watermark state required for safe replay
atomic sequence/marker/CRC
```

Verify:

- no double-commit
- no false success on DDR error
- reset during write
- torn checkpoint
- duplicate replay
- stale schema
- CRC corruption
- allocator replay after reload
- exact 32-weight restoration
- pending transaction restoration or explicit safe invalidation under the frozen contract.

If pending state is intentionally invalidated on a class of reset, document it and prove no stale reward can commit.

## 14.3 AXI correctness

The final path must propagate/validate:

```text
RID
RRESP
RLAST
BID
BRESP
burst length / beat count
timeout
```

No final adapter may hard-wire every response to `OKAY`.

Inject error responses and prove:

```text
error → query/persist failure or safe terminal status
error != factual ANSWER
error != successful commit
```

## 14.4 UART stream

Final silicon hierarchy must derive clock/baud from the actual final clock domain.

Expected target:

```text
115200 baud, 8N1
```

Do not use `CLK_HZ=8000, BAUD=800` in final hierarchy.

C4 output must drain a token FIFO. It must not retain/employ only `last_gen`.

Test FIFO backpressure at UART rate.

---

# 15. STAGE 9 — C5 INTEGRATED XSIM / MIG REGRESSION

Run the complete production top, not sibling proofs, through the final regression.

Mandatory end-to-end classes:

```text
1. Forward supported answer
2. Reverse supported answer
3. novel 2-hop supported proof
4. wrong direction
5. wrong context
6. unrelated → UNKNOWN/refusal
7. CONFLICT → refusal
8. AMBIGUOUS → refusal
9. SEARCH_INCOMPLETE → refusal
10. evidence replacement changes answer
11. scalar reward changes later ranking/decision
12. duplicate/stale reward rejected
13. 32-weight persist/reload exact
14. pending replay/atomicity
15. DDR RRESP/BRESP error
16. UART FIFO full-sequence output
17. zero/corrupt C4 control
18. host semantic-authority counters remain zero
```

When possible, run the same frozen 360 C4 examples through the integrated path, plus focused C5 transaction/persistence/error sequences.

Final C5 must demonstrate:

```text
n_host_winner = 0
n_host_token  = 0
no qid answer map
no benchmark shortcut
no auto reward
one production C4
one production retrieval/reasoning path
```

C5 PASS is a property of the single final hierarchy only.

---

# 16. C5 CLOSE CONDITION

Stamp `C5_MASTER_PASS` only if:

```text
C4 final module is integrated
all required raw-UART→output regressions pass
explicit reward path passes
SGD32 update is FPGA-owned
full chosen learning state persists/reloads
pending/atomicity/replay passes
AXI error behavior passes
full token FIFO output passes
real-baud parameters are selected for final top
host semantic authority remains zero
no old/synthetic production bypass is active
```

If any one item is only proven in a sibling module but not in the final top, C5 remains OPEN.

---

# 17. STAGE 10 — C6 FINAL WHOLE-CHIP WRAPPER

Create/promote one final whole-chip top that instantiates `a7ng_astra_c5_prod_top_final_v1`.

Do not leave the public old `a7ng_astra_c5_prod_top` as the instantiated final C5.

The C6 wrapper must connect the real MIG response information required by the final C5, including response/error/last/ID semantics used by the C5 AXI adapter.

Before freezing, add a non-semantic build fingerprint/telemetry field if practical, so C7 can identify the exact loaded build. This value may encode a truncated final commit/manifest hash; it must never affect semantic computation.

---

# 18. STAGE 11 — C6 FINAL FREEZE MANIFEST

Create:

```text
FINAL_SOURCE_MANIFEST.json
```

Freeze exact SHA256 for:

```text
repo commit
all RTL/SVH sources in elaborated hierarchy
XDC
MIG project/XCI/PRJ/IP config
clock config
build TCL/scripts
C4 checkpoint
quant manifest
C4 numerical contract
all C4 weight HEX files
vocab/dictionary
corpus
800k index/postings
descriptor image
initial learned-state/checkpoint image
C5 protocol/schema constants
test preregistration files
Vivado executable/version
part
top module
```

Requirements:

```text
git status = clean
source commit pinned
build output directory new/clean
no stale bitstream reused
no generated weight file edited by hand
```

If RTL/model/data changes after freeze, C6 freeze is invalid and must be regenerated.

---

# 19. STAGE 12 — VIVADO C6 BUILD

Use the exact frozen manifest and Vivado 2026.1 baseline unless the installed tool is different; if different, record exact version and do not mislabel.

Build:

```text
SYNTHESIS
→ OPT
→ PLACE
→ ROUTE
→ BITSTREAM
```

Hard physical PASS:

```text
device fit                 PASS
WNS                        >= 0 ns
TNS                        = 0
WHS                        >= 0 ns
THS                        = 0
unrouted nets              = 0
DRC errors                 = 0
critical unconstrained     = 0
relevant clocks constrained PASS
CDC review                 PASS / no unresolved unsafe CDC
```

Report separately:

```text
LUT
FF
Slices
BRAM36/18
DSP
free slices
clock frequencies
power estimate if available
critical warnings
```

Preferred resource targets from the Master are advisory, not substitutes for measured final implementation.

Generate and hash:

```text
a7ng_astra_c6_wholechip_final_v1.bit
```

Archive:

```text
report_timing_summary
report_utilization
report_route_status
report_drc
report_cdc
synth log
impl log
bitstream SHA256
source manifest SHA256
```

Do not program the board if any hard physical requirement fails.

---

# 20. STAGE 13 — C7 BLIND BOARD PREREGISTRATION

Before programming, create and hash:

```text
C7_BOARD_EXAM_V1.json
C7_BOARD_EXAM_V1.md
```

The C7 queries/sequences must not be used to tune RTL/model after preregistration.

Use one final 10-phase silicon exam:

```text
P1  Build/board identity + UART link
P2  Raw parser role/direction: F vs R
P3  Sparse retrieval on frozen corpus / high-ID evidence
P4  Novel 2-hop proof-backed supported query
P5  C4 Forward learned generation
P6  C4 Reverse learned generation
P7  UNKNOWN/CONFLICT/AMB/INCOMP deterministic refusal
P8  Scalar reward → causal ranking/decision update
P9  Full SGD32 persistence + reload + replay/duplicate rejection
P10 Repeated end-to-end run: full token stream, no host semantic/token authority, counters clean
```

The board exam is a falsification test, not a debugger.

If C7 fails:

- archive raw UART bytes/logs first;
- do not patch the loaded bit;
- identify earliest affected gate;
- return to that gate;
- after any fix, create a new C6 freeze/bit hash;
- create a new blind C7 set before retest.

Never call a second, patched bit “the same C7 artifact”.

---

# 21. STAGE 14 — BOARD PROGRAMMING AND C7 EXECUTION

Immediately before programming, verify:

```text
target part       = xc7a100tcsg324-1
expected board    = Arty A7-100T
expected JTAG     = 210319BE776EA
expected UART     = COM12
baud              = 115200 8N1
bit SHA           = frozen C6 SHA
source manifest   = frozen C6 manifest
```

If JTAG/UART identity differs, stop before programming and record the mismatch. Do not guess the port.

Open/arm UART capture before programming where the board procedure requires it.

Program **only** the frozen C6 bit.

Run all 10 phases without source/weight/corpus modification.

Capture:

```text
program log
JTAG identity
UART open parameters
raw RX/TX bytes
decoded tokens
status/proof IDs
reward frame bytes
pre/post weights or digest
persistence/reload evidence
build fingerprint
timestamps
script hash
exit codes
```

---

# 22. FINAL BOARD PASS LAW

`ASTRA_NATIVE_AI_BOARD_PASS` may be written only if the same final bitstream proves all of:

```text
ROLE-AWARE PARSING            PASS
SAME-LAW SPARSE RETRIEVAL     PASS
BOUNDED PROOF REASONING       PASS
UNCERTAINTY / SAFE REFUSAL    PASS
C4 GROUNDED LEARNED OUTPUT    PASS
REVERSE GENERATION            PASS
AUTOREGRESSIVE TOKEN FEEDBACK PASS
SCALAR-REWARD UPDATE          PASS
HELD-OUT/TRANSFER CLAIM       already accepted and not regressed
FULL ACTIVE STATE PERSISTENCE PASS
DUPLICATE/STALE REWARD GUARD  PASS
AXI ERROR SAFETY              PASS
UART 115200 FULL STREAM       PASS
HOST SEMANTIC AUTHORITY       ZERO
FINAL PHYSICAL CLOSURE        PASS
SAME BIT / SAME MANIFEST      PASS
```

If any mandatory capability comes from a different bitstream, BOARD_PASS = FAIL.

---

# 23. ACCEPTED FINAL CLAIM — ONLY AFTER C7 PASS

Allowed claim:

> ASTRA/QUAN is a bounded-domain FPGA-native neuro-symbolic adaptive AI system that accepts raw user input, preserves role-aware structured semantics, retrieves evidence from its frozen sparse knowledge memory, performs bounded proof-backed relational reasoning, explicitly handles uncertainty, adapts decision ranking from scalar reward with persistent FPGA-owned state, and generates evidence-grounded output tokens on the FPGA without host semantic control.

Do not claim:

```text
AGI
human-level intelligence
open-domain understanding
self-awareness/consciousness
autonomous discovery of arbitrary facts
unbounded reasoning
general ChatGPT-like language ability
```

If C4 learned ANSWER generation passes but refusal is deterministic, say exactly that.

---

# 24. FAILURE / AUTO-ADVANCE POLICY

Cursor should not ask the user for ordinary engineering decisions.

After PASS:
- archive evidence;
- commit/version the accepted change;
- automatically proceed to the next stage.

After FAIL:
- preserve the failed run;
- identify `FIRST_DIVERGENCE`;
- classify the violated invariant;
- make the smallest bounded correction within the same gate;
- rerun only the affected test plus required regressions.

Do not patch unrelated gates simultaneously.

If the same invariant still fails after two bounded corrective revisions, emit:

```text
BLOCKED
FIRST_DIVERGENCE
VIOLATED_INVARIANT
AFFECTED_MODULE
AFFECTED_COMMIT
WHY_CONTINUATION_IS_UNSAFE
SMALLEST_REMAINING_EXPERIMENT
```

and stop rather than entering an unbounded redesign loop.

Board failures always return to pre-board gates and require a new frozen bit + new blind C7 exam.

---

# 25. FINAL REQUIRED DELIVERABLES

At completion, produce:

```text
1. FINAL_RECONCILIATION/RESULTS.md
2. FINAL_RECONCILIATION/METRICS.json
3. FINAL_RECONCILIATION/FINAL_SOURCE_MANIFEST.json
4. FINAL_RECONCILIATION/SHA256.txt
5. FINAL_RECONCILIATION/C4_NUMERICAL_PARITY.md
6. FINAL_RECONCILIATION/C4_CAUSAL_ABLATIONS.md
7. FINAL_RECONCILIATION/C5_PRODUCTION_HIERARCHY.md
8. FINAL_RECONCILIATION/C6_PHYSICAL_CLOSURE.md
9. FINAL_RECONCILIATION/C7_BOARD_RAW_EVIDENCE.md
10. FINAL_RECONCILIATION/CLAIM.md
11. final `.bit` + SHA256
12. exact board test script + SHA256
```

`CLAIM.md` must say PASS only when the same final bit and manifest satisfy the entire final law.

---

# 26. START COMMAND FOR CURSOR

Copy this instruction into Cursor together with this WO:

```text
EXECUTE WO-FINAL-ASTRA-C4-C7-CONVERGENCE-20260909 from Stage 0 through final reconciliation.

Work only in D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH and the declared C4 rescue artifacts. Preserve all existing local work before edits. Do not touch the historical V3.1 worktree. Do not ask for ordinary confirmations. Auto-advance after evidence-backed PASS. On FAIL, archive the first divergence and make only the smallest bounded correction in the same gate.

Critical laws:
1) ANSWER is the canonical symbolic C3 status (currently 4'd0), never 3'd1.
2) Do not load D32 weights into D4 RTL. Port the exact integer D32 F/R architecture from quant_manifest.json into a new versioned RTL module.
3) Non-ANSWER uses deterministic hardware refusal n→o→EOS; do not claim learned refusal.
4) ANSWER path must remain learned and must pass zero/corrupt/evidence/token-feedback causal ablations.
5) C5 must be one unified hierarchy containing explicit scalar reward, full SGD32/pending atomic persistence, AXI response/error handling, materializer, D32 C4, full token FIFO and real 115200 UART.
6) No board programming until the exact frozen C6 source closes timing/hold/route/DRC/CDC.
7) C7 uses only the unique frozen C6 bit. Never combine evidence from different bits.

Final completion condition is ASTRA_NATIVE_AI_BOARD_PASS from one final bitstream, not a collection of module-level PASS reports.
```
