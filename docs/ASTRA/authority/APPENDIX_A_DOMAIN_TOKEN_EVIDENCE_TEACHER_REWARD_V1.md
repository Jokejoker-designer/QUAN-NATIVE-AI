# Appendix A — Domain, Token, Evidence, Teacher & Reward Learning Contract

**Companion to:** `UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md`  
**Status:** FINAL APPENDIX CANDIDATE  
**Date:** 2026-09-04  
**Target:** Native V1 — Arty A7-100T  

> This appendix clarifies training/data/teacher semantics. It does not override the Master Blueprint. If a conflict exists, the Master Blueprint and unchanged Gate14 acceptance law win.

---

## A0. Purpose

This appendix defines:

- token and vocabulary
- domain/topic scope
- FPGA query representation and anchor
- evidence/episode record
- teacher roles
- reward and credit assignment
- unknown/insufficient-evidence behavior
- corpus update versus online learning
- teacher-off autonomy

Final target:

```text
raw query tokens
→ FPGA-owned representation
→ FPGA-owned sparse routing
→ bounded evidence candidates
→ learned scoring
→ exact Top-K
→ structured C9
→ LM-06
→ FPGA-generated output
```

The purpose is to prevent a false architecture where CPU/teacher secretly supplies the semantic route and FPGA only follows it.

---

## A1. Domain-first policy

Native V1 should begin with a bounded domain, for example:

```text
FPGA / Vivado / Arty A7 / Native-AI Debug
```

Suggested subtopics:

```text
FPGA fundamentals
Artix-7 / Arty A7
Vivado synth/impl
timing / CDC / reset
DDR3 / MIG / AXI
UART / JTAG
RTL debugging
Top-K / Min-heap
Native graph retrieval
online learned delta
LM-06 / Gate14 evidence
```

Reason: bounded vocabulary, auditable evidence, measurable retrieval recall, controlled held-out tests.

---

## A2. Token law

A token ID is an opaque stable symbol.

Example:

```text
"FPGA"   -> 417
"DDR"    -> 12
"Vivado" -> 903
```

No semantic meaning is implied by numerical distance.

```text
TOKEN_ID = stable symbol
SEMANTICS != arithmetic distance between token IDs
```

Vocabulary must be:

```text
versioned
deterministic
stable
reproducible
auditable
```

Minimum fields:

```text
vocab_version
token_id
token_text
token_type
normalization_rule
```

CPU may do:

```text
text normalization
tokenization
token lookup
UART framing
output token -> text
display/logging
```

CPU must not do query-time:

```text
anchor selection
semantic route selection
relation classification for FPGA
bucket/winner/candidate selection
episode address selection
Top-K
next-token decision
final-answer generation
```

---

## A3. Query representation

FPGA must transform token sequences into a feature packet.

Native V1 uses:

```text
DETERMINISTIC FPGA-NATIVE QUERY FEATURE EXTRACTOR
```

unless a separately proven learned encoder is later authorized.

Conceptually:

```text
tokens
  ↓
FPGA feature extraction
  ├─ anchor-like feature
  ├─ intent-like feature
  ├─ relation-like feature
  ├─ context tag
  └─ route keys
```

These are routing hypotheses, not truths.

---

## A4. Anchor law

An anchor is not:

```text
the answer
the winner
the correct evidence address
semantic truth
```

It is a bounded FPGA-derived feature used to reduce search space.

Example query:

```text
"Arty A7 boot lên nhưng DDR không đọc được"
```

Possible FPGA feature packet:

```text
board-ish      = Arty A7
subsystem-ish  = DDR
failure-ish    = read/init
context-ish    = boot
```

Router then nominates candidates. Correctness is decided later by:

```text
full scorer
+ learned contextual delta
+ exact retained Top-K
```

Prefer multiple route signals rather than one semantic anchor:

```text
query representation
  ├─ route key A
  ├─ route key B
  ├─ route key C
  └─ route key D
          ↓
      union + dedup
          ↓
 bounded candidate set
```

Exact routing law is selected by `SPARSE-ROUTER-RIVAL-AUDIT-00`.

---

## A5. Evidence / episode record

Evidence is not attached to one token.

A token helps describe the query. An evidence record represents one structured knowledge item.

Conceptual schema:

```text
episode_id
subject_id
relation_id
object_id
context_tag
compact_features
base_prior/confidence
generation
valid
source_id
source_version
payload/text_reference
```

Example:

```text
episode_id      = 103421
subject         = MIG_DDR3
relation        = REQUIRES
object          = INIT_CALIB_COMPLETE
context         = DDR_BOOT
base_confidence = HIGH
source          = verified AMD/Digilent documentation
payload         = DDR access invalid before calibration completes
```

---

## A6. Corpus law

Native V1 final scope:

```text
STATIC / PRELOADED corpus
up to 800,000 addressable episodes
+
ONLINE contextual learned deltas
```

800k means knowledge capacity, not candidates/query.

```text
FULL_SCAN_800K = NO
```

Native V1 does not require runtime creation of record 800001.

Out of scope:

```text
online arbitrary episode allocation
posting-page split/merge
directory rebalance
dynamic corpus growth
```

New factual knowledge is added through a controlled corpus update. Dynamic online episode creation is future Native V2 work.

---

## A7. Teacher roles

A large LLM teacher such as ChatGPT or Grok may participate through two separate channels.

### Channel A — Knowledge bootstrap / corpus building

Teacher may:

```text
read verified sources
extract/propose facts
propose subject/relation/object/context records
generate questions/paraphrases
propose negatives
find coverage gaps
```

Teacher is not automatically truth authority.

Teacher-proposed evidence should carry:

```text
source_id
source_version
teacher/model ID
review_state
confidence
```

Preferred pipeline:

```text
verified sources
→ teacher proposes records
→ schema validation
→ human/deterministic audit where required
→ versioned corpus
→ DDR image
```

### Channel B — Behavioral reward evaluator

Runtime training:

```text
teacher asks question
→ CPU tokenizes only
→ FPGA receives raw tokens
→ FPGA representation
→ FPGA routing
→ FPGA scoring / Top-K
→ FPGA answer
→ teacher/user evaluates
→ scalar reward only
→ FPGA updates learned delta
```

Teacher may send:

```text
question
reward
optional non-semantic session/test ID
```

Teacher must not send:

```text
winner
candidate ID
bucket/hash
route key
episode address
Top-K
correct relation path
next token
final answer to copy
weight write
```

Otherwise the teacher becomes a hidden runtime oracle.

---

## A8. Reward law

Reward says:

```text
"the previous FPGA decision was better or worse"
```

Reward does not create missing factual knowledge.

Therefore:

```text
NEW FACTUAL KNOWLEDGE
= corpus/evidence update

BEHAVIORAL LEARNING
= reward-driven learned delta
```

Recommended first reward scale:

```text
-3 = clearly wrong
-2 = wrong
-1 = weak / partially wrong
 0 = neutral / not evaluated
+1 = partially useful
+2 = correct/useful
+3 = strongly correct/preferred
```

No floating point is required.

Use small signed integer/fixed-point with saturation:

```text
learned_delta ∈ [-D_MAX, +D_MAX]
```

No unbounded accumulation.

---

## A9. Credit assignment

One reward must be assigned to FPGA-selected evidence using an FPGA-owned frozen law.

Pending transaction should store:

```text
txn_id
query context
selected Top-K IDs
primary evidence/winner
confidence
generation
```

Possible initial law:

```text
winner_delta  += reward * ALPHA
support_delta += reward * BETA

ALPHA > BETA >= 0
```

with saturation.

Teacher cannot tell FPGA which candidate receives the update. FPGA uses its own pending transaction.

---

## A10. Unknown / insufficient evidence

If evidence is inadequate, Native V1 must be able to return:

```text
UNKNOWN / INSUFFICIENT_EVIDENCE
```

Possible inputs to this gate:

```text
valid candidate count
Top-1 score
Top-1 vs Top-2 margin
confidence/prior
overflow
evidence coverage
```

Repeatedly asking the same question without new evidence does not create knowledge.

```text
NO EVIDENCE + NO NEW DATA = STILL UNKNOWN
```

This is an uncertainty gate, not a quantum/Heisenberg mechanism.

---

## A11. Learning versus memorization

### Static retrieval

```text
record already exists
query retrieves it
no learned state changes
```

### Behavioral learning

```text
FPGA selects evidence
receives reward
learned delta changes
future ranking/Top-K changes
```

### Knowledge acquisition

```text
new factual record added
corpus version changes
```

### Forbidden clone behavior

```text
teacher sends runtime winner/address/answer
FPGA reproduces it
```

A teacher during training does not make the system a clone if the teacher only builds curriculum/corpus offline and evaluates with reward.

---

## A12. Teacher-off law

Final exam:

```text
teacher = 0
external_LLM = 0
host semantic contribution = 0
```

Allowed during training:

```text
teacher curriculum
teacher sourced evidence proposals
teacher questions
teacher scalar reward
```

Forbidden during final inference:

```text
teacher route
teacher winner
teacher candidate list
teacher evidence address
teacher next token
teacher final answer
```

---

## A13. Example — FPGA / Native AI Debug

Example corpus records:

```text
MIG        REQUIRES    INIT_CALIB_COMPLETE    context=DDR_BOOT
AXI_READ   REQUIRES    VALID_READY_HANDSHAKE  context=DDR_QUERY
TOPK       RETAINS     BEST_K_CANDIDATES      context=NATIVE_RETRIEVAL
TEACHER_OFF FORBIDS    HOST_WINNER             context=GATE14
```

Query:

```text
"Tại sao DDR trên Arty A7 đọc sai ngay sau boot?"
```

CPU:

```text
text → stable token IDs
```

FPGA:

```text
tokens
→ query features
→ route keys
→ bounded candidates
→ scorer
→ Top-K
→ evidence
→ LM output
```

Teacher/user then sends only a reward, for example:

```text
reward = +2
```

FPGA applies its own credit-assignment law.

---

## A14. Example — truly unknown topic

If the corpus only contains FPGA/Native-AI knowledge and user asks an unrelated topic with no evidence:

```text
candidate quality low
→ insufficient evidence
→ UNKNOWN
```

Negative reward cannot create the missing fact.

To teach it, a new sourced evidence record must be added through the corpus-build channel.

---

## A15. Training curriculum

Recommended sequence:

```text
Stage 0 — vocabulary sanity
Stage 1 — single-fact retrieval
Stage 2 — paraphrase retrieval
Stage 3 — unrelated negatives
Stage 4 — contradiction discrimination
Stage 5 — relation/context discrimination
Stage 6 — multi-evidence Top-K
Stage 7 — reward adaptation
Stage 8 — persistence/reload
Stage 9 — held-out teacher-off exam
```

Teacher should generate diverse questions without leaking internal route decisions.

---

## A16. Corpus versioning

Each corpus release records:

```text
CORPUS_VERSION
VOCAB_VERSION
SCHEMA_VERSION
RECORD_COUNT
SOURCE_MANIFEST_SHA
CORPUS_IMAGE_SHA
INDEX_IMAGE_SHA
BUILD_SCRIPT_SHA
```

A corpus update and online reward learning are separate evidence objects.

---

## A17. Required telemetry

Archive where feasible:

```text
query/session ID
raw token count
query feature packet
route keys
candidate count
overflow count
dedup count
Top-K IDs/scores
confidence
UNKNOWN flag
reward
learned delta before/after
txn_id
commit status
generation
```

Final board observability may be compressed, but must still be sufficient to falsify host leakage and false-learning claims.

---

## A18. Mapping to Master Blueprint gates

```text
U1  HARNESS-AUTHORITY-FIX
    canonical token/evidence transport tests

U3Q QUERY-REPRESENTATION-AUTHORITY
    token → FPGA feature law

U4A SPARSE-ROUTER-RIVAL-AUDIT
    route profile / cap selection

U4/U5 M10-SPARSE
    bounded 800k evidence admission

U6 UNIFIED-RETRIEVAL
    real evidence → scorer/Top-K/C9

U7A ROOT-B-REACHABILITY
    reward/commit transaction semantics

U7 CONTEXTUAL-LEARN-PERSIST
    learned delta / persistence

U8 UNIFIED-LM-CHAIN
    evidence → LM → FPGA response

U10 FINAL BOARD
    teacher-off autonomy
```

---

## A19. Acceptance checklist

```text
[ ] vocabulary stable/versioned
[ ] CPU sends raw tokens only
[ ] FPGA creates query representation
[ ] route keys FPGA-owned
[ ] evidence structured/versioned
[ ] corpus provenance exists
[ ] reward separated from factual corpus update
[ ] teacher cannot send winner/address/route/next-token
[ ] FPGA owns credit assignment
[ ] learned delta bounded/saturating
[ ] UNKNOWN behavior exists
[ ] sparse retrieval bounded at 800k
[ ] final unified path uses real evidence
[ ] teacher-off exam passes
[ ] frozen host-leakage counters remain zero
```

---

## A20. Final conceptual law

```text
TOKEN
= what the user said

QUERY FEATURE / ANCHOR
= FPGA hypothesis about where to look

EVIDENCE
= stored knowledge item

ROUTER
= narrows search

SCORER / TOP-K
= selects relevant evidence

REWARD
= evaluates the FPGA's previous decision

LEARNED DELTA
= state changed by experience

TEACHER
= curriculum builder / evaluator during training

TEACHER-OFF
= proof of autonomous FPGA operation
```

Remember:

```text
NO EVIDENCE + NO NEW DATA
= STILL UNKNOWN

NEW EVIDENCE
= NEW KNOWLEDGE

REWARD
= BETTER USE OF EXISTING KNOWLEDGE
```

Native V1 is complete only when:

```text
teacher provides no semantic help
host provides raw tokens only
FPGA creates route features
FPGA retrieves bounded evidence
FPGA applies learned contextual state
FPGA selects exact Top-K
FPGA constructs C9
LM-06 executes
FPGA generates output
```

and learned behavior survives the required persistence/reset/retrain tests.

CPU có thể đóng vai trò “bàn phím + từ điển + màn hình”, còn FPGA là “bộ não quyết định”.
Luồng nên là:
```markdown
Người dùng gõ:
"Tại sao DDR trên Arty A7 chưa đọc được?"

        ↓

CPU / Terminal app
- chuẩn hóa text
- tra vocabulary
- đổi chữ → token ID

Ví dụ:
<BOS>  Tại_sao  DDR  Arty_A7  chưa  đọc  được  ?  <EOS>

↓
[1, 125, 42, 817, 311, 66, 98, 9, 2]

        ↓ UART

FPGA
- nhận chuỗi token ID
- tự tạo query representation
- tự tạo route feature / anchor
- tự tìm evidence
- tự score
- tự Top-K
- tự tạo C9/context
- LM-06 xử lý
- tự sinh token output

        ↓ UART

Ví dụ FPGA trả:
[1, 42, 190, 76, 321, 2]

        ↓

CPU / Terminal app
- tra ngược token ID → chữ

        ↓

"DDR cần hoàn tất calibration trước."
```
Đây là kiến trúc hợp lệ.
CPU được phép:
```css
text → token
token → text
UART send/receive
hiển thị terminal
ghi log
```
CPU không được làm:
```css
text → semantic meaning
text → anchor
text → relation
text → candidate
text → evidence winner
text → câu trả lời
```
Nếu CPU chỉ làm:
```
"DDR" → token 42
```
thì hoàn toàn bình thường.
Token 42 chỉ có nghĩa:
Trong vocabulary version này, ID 42 đại diện cho ký hiệu "DDR".
Không có nghĩa số 42 tự chứa khái niệm DDR.
Không cần random.
Tôi khuyên Native V1 dùng một vocabulary cố định và versioned.
Ví dụ:
```php-template
0     <PAD>
1     <BOS>
2     <EOS>
3     <UNK>

100   fpga
101   ddr
102   uart
103   jtag
104   vivado
105   timing
106   reset
107   mig
108   axi
...
```
Có thể:
```ini
FPGA = 100
DDR  = 101
```
hoặc:
```ini
FPGA = 1742
DDR  = 61
```
đều được.
Điều quan trọng là:
```
FPGA luôn = 100
```
trong cùng VOCAB_VERSION.
Không được hôm nay:
```
FPGA = 100
```
mai lại:
```
FPGA = 551
```
mà không đổi corpus/model theo vocabulary mới.
Cho dự án này:
```cpp
token_t = uint16_t
```
rất hợp lý.
Cho phép:
216=65,5362^{16}=65,536 
token.
Nhưng Native V1 không cần dùng hết.
Ví dụ domain FPGA chuyên sâu chỉ cần:
```
4k–16k vocabulary
```
đã rất nhiều.
UART packet có thể cực đơn giản:
```python-repl
SYNC
CMD_QUERY
N_TOKENS
TOKEN_0
TOKEN_1
...
TOKEN_N
CRC
```
Ví dụ:
```yaml
AA 55
01
0007
0064
0065
006A
...
CRC16
```
FPGA nhận một sequence token hoàn chỉnh rồi bắt đầu query.
Nếu FPGA cuối cùng chỉ gửi:
```ini
evidence_id = 123
```
rồi CPU nhìn evidence 123 và tự tạo câu:
"DDR chưa calibration."
thì CPU đang làm một phần semantic response.
Không nên như vậy cho final Native claim.
Final đúng phải là:
```lua
FPGA LM-06
→ output token ID 1
→ output token ID 2
→ ...
```
CPU chỉ:
```
token → chữ
```
Ví dụ FPGA gửi:
```json
[101, 522, 78, 901, 2]
```
CPU chỉ tra bảng:
```ini
101 = DDR
522 = cần
78  = hoàn_tất
901 = calibration
2   = <EOS>
```
→ hiện:
DDR cần hoàn tất calibration
CPU không quyết định nội dung câu.
Tôi khuyên dùng chung một vocabulary cho V1:
```ini
VOCAB_INPUT = VOCAB_OUTPUT
```
Như vậy:
```
CPU tokenize query
FPGA generate output token
CPU detokenize
```
đơn giản nhất.
Sau này mới tách vocabulary nếu thực sự cần.
Có ba phương án.
```
F P G A
```
Ưu điểm: vocab cực nhỏ.
Nhược điểm: sequence dài, FPGA phải xử lý nhiều token.
```
FPGA
DDR
Vivado
```
Ưu điểm: dễ hiểu.
Nhược điểm: từ mới dễ bị <UNK>.
Ví dụ:
```
config
uration
```
hoặc:
```
init
_calib
_complete
```
Đây là phương án thực tế nhất về lâu dài.
Nhưng cho Native V1 domain hẹp, tôi sẽ không làm BPE phức tạp ngay.
Tôi đề xuất:
```diff
fixed technical vocabulary
+
word/subword hybrid
+
<UNK>
```
Ví dụ các thuật ngữ domain được giữ nguyên:
```
FPGA
DDR3
MIG
AXI
ARVALID
RREADY
WNS
TopK
UART
JTAG
Vivado
```
còn từ thường dùng token đơn giản.
Đường final chính là:
```css
Terminal
   ↓
CPU tokenizer
   ↓
raw token IDs
   ↓ UART
FPGA
   ↓
Query Representation
   ↓
Sparse Router
   ↓
800k Knowledge Corpus
   ↓
Scorer + Learned Delta
   ↓
Top-K
   ↓
C9
   ↓
LM-06
   ↓
output token IDs
   ↓ UART
CPU detokenizer
   ↓
Text
```
Đây là kiến trúc mà tôi khuyến nghị.
Vì CPU không suy nghĩ.
CPU chỉ thực hiện hai hàm:
encode(text)=tokensencode(text)=tokens 
và:
decode(tokens)=textdecode(tokens)=text 
Còn hàm quan trọng:
F(tokens, memory, learned state)→output tokensF(tokens,\ memory,\ learned\ state) \rightarrow output\ tokens 
phải nằm trên FPGA.
Đó mới là ranh giới cần bảo vệ.
Nói đơn giản:
CPU biết số 101 viết ra màn hình là chữ “DDR”. Nhưng CPU không biết khi nào phải nói “DDR”. FPGA mới là bên quyết định token 101 có cần được sinh ra hay không.
Đó chính xác là kiến trúc terminal tôi sẽ dùng cho Native V1. 