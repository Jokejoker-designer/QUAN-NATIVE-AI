# C4_CONTEXT_CONTRACT_V2

**SUPERSEDES V1 FOR FINAL PRODUCTION.**  
**V1 = HISTORICAL ONLY.**  
**REASON = answer-aligned endpoint permutation violated causal direction test.**

PROGRAM=NO. C4_MASTER=OPEN. BOARD_PASS=OPEN.

Do not rewrite `C4_CONTEXT_CONTRACT_V1`. V1 WO360 360/360 remains historical numerical-parity evidence for the V1 serialization only. It cannot close final C4 under V2.

## Two layers

### V2-G06 minimal canonical context (this G06)

Used to prove endpoint-direction causality without layout cues:

```text
[OP][SRC][DST][PAD=----]
```

C3 already owns parser, retrieval, relation, context, and proof. Under this boundary, C4 only vocalizes a proof endpoint. Relation/query-context bytes are **intentionally absent** from the G06 context. That is an architectural split, not an accidental omission.

### V2 production context (not this G06)

If a later corpus requires C4 to change tokens because of relation or query-context after proof, those fields must be added in a **separate** production-context contract. Do not smuggle them in by duplicating SRC/DST or by permuting slots. Do not treat G06 PAD as a hidden relation field.

Until that separate contract exists, production C4 under V2 is the G06 minimal context: opcode + SRC + DST + PAD.

## Materializer inputs (FPGA-owned)

```text
opcode / direction     (F or R)
proof_src_id           (C3 proof source endpoint id)
proof_dst_id           (C3 proof dest endpoint id)
dictionary             (id → 4-byte name, hit, overflow)
```

Forbidden: `answer_i`, `answer_id_i`, `target_slot_i`, `selected_answer_i`, host sentence, qid→answer. Do not look up `c3_answer_id`.

## 16-byte layout

```text
 0        opcode     'F' (70) or 'R' (82)
 1        space      0x20
 2..5     SRC        dictionary[proof_src_id], once
 6        space      0x20
 7..10    DST        dictionary[proof_dst_id], once
11        '>'        0x3e
12..15    PAD        0x2d × 4  ("----"), not an endpoint
```

Same `(src_id, dst_id)` ⇒ F and R identical except byte 0.

## Overflow

If an endpoint id misses the dictionary or the name is not a valid 4-byte entity:

```text
that slot = "????"
ovf_o = 1
valid_o = 0
factual C4 prohibited
```

Do not shuffle the other endpoint into a new slot.

## Decoder copy law (not a materializer output)

Preregistered semantics for a V2 decoder, independent of any one checkpoint:

```text
F  SRC=drum DST=hose  → hose
R  SRC=drum DST=hose  → drum
R  SRC=bolt DST=hose  → bolt
R  SRC=vent DST=hose  → vent
```

G06-A does not score these tokens. G06-B scores a frozen checkpoint against them with `EXPECTED_OUTCOME = UNKNOWN`.
