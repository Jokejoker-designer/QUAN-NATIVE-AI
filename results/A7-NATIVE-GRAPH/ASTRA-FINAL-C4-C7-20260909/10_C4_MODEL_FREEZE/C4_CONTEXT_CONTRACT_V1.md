# C4_CONTEXT_CONTRACT_V1

PROGRAM=NO. Materializer must build this from FPGA-owned proof/evidence. Host must not inject the answer.

## Encoding

- Alphabet: 8-bit tokens. Context is exactly 16 ASCII bytes. EOS/BOS = `0`.
- Vocab: 256. Printable answers are lowercase ASCII letters or the 2-byte refusal `no` (learned-U only; production non-ANSWER is hardware `n`,`o`,EOS).

## 16-byte layout (byte index)

```text
 0     opcode          'F' (70) or 'R' (82)
 1     space           0x20
 2..5  slot A          4-char name
 6     space           0x20
 7..10 slot B          4-char name
11     '>'             0x3e
12..15 slot C          4-char name
```

## Slot meaning by opcode

| opcode | slot A [2:6] | slot B [7:11] | slot C [12:16] | learned answer |
|---|---|---|---|---|
| F | dest / query | src / copy source | dest (must equal slot A) | src (slot B) |
| R | src | src (repeat) | dest / copy source | dest (slot C) |

Examples:

```text
F tank pump>tank   → copy "pump"
R tmom tmom>txjf   → copy "txjf"
```

## Bank selection (public bytes only)

```text
if ctx[0] == 'R' (82) → R attention bank WqR/WkR/WvR
else                  → F attention bank Wq/Wk/Wv
```

No U-bank in the frozen FR product decoder. Query≠dest on an F opcode is **not** a license to learn refusal.

## Seed / generation

1. Tokens = context[16] + [0]
2. At last index, compute logits (integer reference).
3. Next token = argmax. Append. Repeat until token 0 or 6 tokens.
4. Feedback is the generated token, never a host token (`n_host_tok_o = 0`).

## What C3 / proof may supply

FPGA-owned:

- direction/role → opcode F vs R
- dest name (4 bytes)
- src name (4 bytes)
- proof-accepted ANSWER gate (outside this 16-byte string)

Must **not** come from host:

- expected answer bytes
- next token
- target_slot / winner / evidence address presented as gold
- qid→answer table

## Non-ANSWER (not this context's job)

If C3 status ≠ ANSWER or n_path==0 or proof_ok==0: do **not** run the learned decoder. Hardware S_SAFE emits `'n'` then `'o'` then EOS.
