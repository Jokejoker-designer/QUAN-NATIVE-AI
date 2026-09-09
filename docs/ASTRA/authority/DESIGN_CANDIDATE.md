# Native AI khả thi trên Arty A7 — đề xuất thiết kế Astra

Ngày: 05-09-2026. Trạng thái: **DESIGN CANDIDATE / NEEDS EXPERIMENT**.

Companion cho `UNIFIED_NATIVE_AI_FINAL_BLUEPRINT_V3_1.md`, không tự thay execution authority. Giữ nguyên các frozen regression và final Gate14; đề xuất thêm acceptance năng lực. Các số ngân sách dưới đây là mục tiêu kỹ thuật, không phải utilization đã đo.

Cập nhật cuối audit: tại d166ca8, Grok đã làm R6 valid-mask, schemaV2 full-ID persistence unit và U4-PRE0 geometry. Các yêu cầu tương ứng trong tài liệu này là invariant phải kế thừa/kiểm tích hợp, không phải đề nghị viết lại những bản sửa đó. Xem AUDIT.md §2. Quality trên corpus lớn, reasoning, shared reward learning và LM language vẫn là phần thiếu.

## 1. Sản phẩm thực sự định xây

Một hệ thống AI miền hẹp trên FPGA có thể:

1. Nhận câu hỏi trong ngôn ngữ kỹ thuật có giới hạn, tự phân tích đối tượng/vai trò/quan hệ.
2. Truy xuất bằng chứng bằng index và ngân sách hữu hạn.
3. Suy ra kết luận chưa được lưu sẵn bằng ghép 2–3 quan hệ hợp lệ, trả cả đường chứng minh.
4. Cải thiện lựa chọn evidence/path trên câu hỏi chưa dùng nhận reward, bằng cập nhật tham số ngay trên FPGA.
5. Từ chối kết luận khi bằng chứng thiếu, mâu thuẫn hoặc search budget chưa đủ.
6. Lưu/restores learned state theo đúng mức persistence đã công bố.
7. Dùng LM06 thực sự trong đường trả lời của Gate14; chỉ claim ngôn ngữ hữu dụng sau khi model/vocabulary/generation đã được kiểm riêng.

Không hứa hiểu mọi tiếng Việt, tự khám phá mọi định luật hoặc tự học factual knowledge không có dữ liệu. “Hiểu” ở đây có định nghĩa thực nghiệm: giữ đúng vai trò, chuyển được sang tổ hợp/entity mới, thay đáp án khi sự thật thay đổi, và biết khi không thể kết luận. Không suy ra ý thức từ các phép thử này.

## 2. Luồng duy nhất

```text
UART query bytes/tokens
 → query transaction + bounded parser
 → role-bound query packet
 → exact sparse index / budgeted posting intersection
 → descriptor fetch, 2 wave buffers
 → 4-lane features + learned ranker
 → K=8 local/global min-heaps
 → bounded typed graph expansion (up to 3 hops)
 → proof checker + uncertainty gate
 → evidence materialization
 → LM06 context and response-token loop
 → UART tokens + compact proof/status

completed FPGA decision → pending transaction → scalar reward
 → selected-feature update on FPGA → learned cache → DDR write-back
```

Các phase có thể time-share MAC, scratchpad và DDR; graph scoring vẫn có PHYS=4. Tuần tự hóa một thao tác hoặc share resource không biến thiết kế thành CPU; điều cần giữ là các engine dữ liệu và protocol có mục đích rõ, không phải số PE càng lớn càng “AI”.

## 3. Frontend: giữ vai trò, không gắn nghĩa vào số ID

### 3.1 Giao thức

Chọn một wire format trước khi viết interface. Đề xuất giai đoạn đầu giữ byte-token 8-bit cho tương thích ingress/LM cũ, có length, version, CRC, query_id phi ngữ nghĩa. Text normalization không được làm entity resolution hoặc chọn evidence ở host.

Nội bộ có `symbol_id`, `entity_id` 20-bit, `relation_id` 8-bit, context versioned. Chúng là những không gian riêng, không lấy low8 database ID làm token semantic.

Vocab/dictionary là data image versioned, nằm ở DDR/BRAM, không chứa prompt→answer hay winner table. Dictionary có thể nói “MIG là một ký hiệu loại component”; không được nói “query X phải trả evidence Y”. Alias list do người thiết kế cấp là prior, phải báo riêng với learned state.

Miền nên thống nhất với Appendix A: FPGA/Vivado/DDR/AXI trong câu hỏi dạng kiểm soát. Bộ HVAC R3 giữ làm fixture legacy, không được gọi là chứng minh tiếng Việt/FPGA-domain. Nếu chọn HVAC làm domain sản phẩm, phải sửa phụ lục trước, không trộn hai benchmark.

### 3.2 Thuật toán parser

Streaming tokenizer → exact word lookup → finite-state grammar với tối đa hai parse hypothesis. Hỗ trợ dạng versioned như:

- `A requires B` / `what does A require?`
- `A connects to B` / `does A reach C?`
- `A is before B` / `what must happen before C?`
- marker phủ định, unknown, context và order rõ ràng.

Packet gồm `subject`, `object_or_variable`, `relation`, `direction`, `negation`, `context`, `valid_mask`, `ambiguity`. Không chọn lowest-ID giữa nhiều entity. Giữ cả subject/object theo vị trí hoặc grammar; khi đa nghĩa chưa giải được thì AMBIGUOUS.

Các biến thể ngôn ngữ đã hỗ trợ phải được kiểm; synonym chưa xuất hiện trong dictionary không thể tự được coi là hiểu. Muốn học alias mới là gate representation mới, không lén thêm alias từ exam vào ROM.

HDC/hash chỉ dùng như feature phụ hoặc bucket accelerator. Nếu giữ HDC, dùng representation role/position riêng và kiểm collision/selectivity thực; không lấy XOR một bag-of-words làm typed reasoning. Exact tuple/role mới là identity authority.

## 4. Corpus và index: lưu đủ, tìm có giới hạn

### 4.1 Record 32 byte đề xuất

Schema đóng gói 256 bit, ví dụ:

| Field | Bit |
|---|---:|
| episode_id / subject_id / object_id | 20 × 3 = 60 |
| relation_id | 8 |
| context_tag | 16 |
| generation | 32 |
| source_id | 24 |
| payload_offset | 28 |
| payload_length | 16 |
| confidence | 8 |
| flags (valid, polarity, schema bits…) | 8 |
| compact_features | 32 |
| reserved | 24 |
| Tổng | 256 |

20-bit phục vụ 800k ID, với sentinel 799999 và invalid code riêng ngoài range. Arithmetic địa chỉ dùng đủ 28 bit cho 256MB; cộng offset phải kiểm range và không chồng vùng weights/index/state. Chưa thể dùng memory map ví dụ dưới đây như địa chỉ program.

### 4.2 Index

Đề xuất đối chiếu hai rival thực: sorted posting intersection và bounded radix/directory lookup. Primary keys lấy từ các role fields thực của cả query và record: subject+relation, object+relation (đảo chiều), context/type. Dùng full-key verification sau hash; không lấy ID để làm giả phân bố semantic cues.

Index builder offline được phép tổ chức corpus tĩnh. Nó phải lưu mọi record hợp lệ trong ít nhất một chuỗi posting đầy đủ, kể cả phần tràn head. Không precompute đáp án multi-hop cho exam. Posting-ID 32-bit chứa 20-bit ID và bits reserved/flags theo schema; một beat128 chứa bốn ID.

Mỗi posting có count, range/skip metadata, corpus version và page pointer. FPGA chọn list hiếm hơn, intersection theo key/role, sau đó mới fetch descriptors. Nếu dùng giới hạn head, phải có đường overflow page có thể truy cập; không vứt 67% ID rồi nói đã hỗ trợ 800k.

Bốn key cần bốn valid bit. Giá trị key=0 có thể hợp lệ; “không có intent” phải là valid=0, không map tất cả vào universal zero bucket. Nếu budget cạn giữa posting lớn: SEARCH_INCOMPLETE, không NO_EVIDENCE giả.

### 4.3 Ngân sách khởi điểm để sweep

- candidate cap sweep: 64/128/256/512/1024, đúng nhu cầu U4A.
- candidate limit ví dụ cho model đầu: 256 **trên toàn query**, gồm seed và graph expansion.
- index/posting traffic budget: 32 KiB/query đề xuất, không gồm LM weights.
- descriptors tối đa 256 × 32 B = 8 KiB/query.
- initial seed quota: 64 candidate; còn 192 cho tối đa 3 lớp expansion. Budget guard được áp global, không nhân lại mỗi hop.
- beam=8, fanout cap=8/hypothesis/hop, hop cap=3; dừng sớm khi global256 đạt. Tất cả cắt tỉa/bỏ trang phải có telemetry.

Những con số này cần thí nghiệm, chưa được đóng thành final cap. Byte bound thực phải cộng directory/skip/posting/descriptor/delta read, kể cả duplicate/discard/padding; archive thêm LM DMA bytes và write-back bytes riêng. Không dùng bytes=16×số candidate được giữ để thay đo bus.

Trên bất kỳ corpus tùy ý, không thể đồng thời đảm bảo bounded traffic, exact global recall=1 và arbitrary skew. Contract đúng là workload đã công bố + measured recall + index đầy đủ + flag incomplete, không phải lời hứa universal retrieval.

## 5. Học thật với reward-only: contextual bandit dùng linear value estimator

### 5.1 Cái gì học

Một vector tham số dùng chung giữa các entity/query, để có cơ hội chuyển sang tình huống mới. Chỉ có prior per-ID sẽ thiên về ghi nhớ. Bản đầu dùng 32 features và một global weight vector; optional tối đa 8 context-head sau khi có ablation chứng minh đáng giá.

Feature vector phi(q,path) gồm role/entity match, requested relation, type compatibility, context compatibility, source confidence, positive/negative support, path length, valid edge fraction, contradiction flags, freshness và một số interaction định nghĩa trước. Numeric equality/identity được kiểm đúng, không dùng khoảng cách số giữa token IDs làm similarity.

Chọn feature tương tác có cấu trúc, chẳng hạn `relation_match × context_match`. Tách identity-specific prior khỏi shared features và báo ablation cho mỗi nhóm. Không feed query ID/answer ID cố định vào global features để tạo shortcut.

### 5.2 Luật số nguyên candidate

Đề xuất law mới `native-rank-sgd-q8-v1`, không đổi frozen learned-prior law cũ tại chỗ:

```text
x_i = signed8 feature, interpreted as x_i / 128
w_i = signed16, interpreted as w_i / 256
acc = signed40(sum_i w_i * x_i)
v_q8 = clamp(RSH(acc,7), -768, +768)
target_q8 = reward * 256             # reward -3..+3
error_q8 = clamp(target_q8 - v_q8, -1536, +1536)
w_i_next = sat16(w_i + RSH(error_q8 * x_i, 7 + learning_shift))
```

`RSH` là round-to-nearest đối xứng: sign(v) × floor((abs(v)+2^(s-1))/2^s), tính ở width đủ rộng. Tránh arithmetic-shift gây bias âm khi các delta rất nhỏ. learning_shift được freeze sau dev, ví dụ sweep 4/6/8. Counter saturation và norm/entropy monitored. Không decay mặc định nếu chưa đăng ký thí nghiệm; không bổ sung Adam/RLS và covariance lớn.

Đây là SGD dự đoán reward của action được chọn, không phải LinUCB đầy đủ và không kèm lời hứa hội tụ trên mọi workload. Contextual bandit là cách đặt bài toán; epsilon-greedy là exploration đầu tiên: trong TRAIN epsilon≈1/16 chọn một action hợp lệ trong frontier bằng PRNG có seed audit được; EXAM epsilon=0. Log propensity và sampled action để phân biệt exploration với lỗi.

Có thể time-share 4 MAC để score32 feature khoảng8 MAC issue cycles/candidate, chưa gồm lookup/control. Update32 weight cũng khoảng8 issue cycles ở4MAC; không gọi đó là latency end-to-end. Nếu timing/resource không fit thì1MAC≈32 cycles/candidate là phương án tradeoff.

### 5.3 Credit assignment và commit

Sau inference, FPGA lưu pending object: txn_id, generation, model_version, query context, selected evidence IDs, proof path, phi, predicted_reward. Host chỉ reward + txn echo. Full update được tính từ pending, không recompute từ bus đã thay đổi.

Một pending transaction đầu tiên là đủ. UPDATE_ACCEPTED khác UPDATE_COMMITTED. Chỉ phát success/commit khi toàn bộ state cần thiết đã ghi; nếu trả early-ack thì status phải nói accepted, không persist_done. Freeze từ chối update mới và quy định rõ pending cũ; reset abort hoặc drain theo contract, không commit nửa chừng.

Reward cuối một path dùng để cập nhật feature aggregate của path đó; không tự thưởng mọi neighbor/top8. Không có nhãn đúng cho action chưa chọn. Chính vì vậy không dùng pairwise PA với positive/negative winner do host cung cấp trong reward-only gate. PA là lựa chọn riêng nếu một phiên huấn luyện supervised có nhãn được cho phép rõ ràng.

Điều kiện chứng minh học: trên cùng held-out worlds, trained shared weights phải thắng zero-weight/no-update và shuffled-reward control. Thay đổi w đơn thuần không đủ. Reward không thể tạo ra factual knowledge bị thiếu; corpus update vẫn là kênh khác theo Appendix A.

## 6. Suy luận thật: typed bounded graph execution và proof

### 6.1 Thuật toán

Một rule engine kiểu Horn/Datalog hữu hạn, không recursion vô hạn. Rule ROM chứa quy tắc tổng quát và type constraints, không chứa đáp án theo query. Graph data nằm DDR, query-time variable binding và join thực hiện trên FPGA.

Ví dụ rule được cho phép theo semantics domain:

```text
requires(x,y) AND requires(y,z) → depends_indirectly_on(x,z)
before(x,y) AND before(y,z)     → before(x,z)
is_a(x,c) AND inheritable_property(c,p) → has_property(x,p)
```

Không áp transitivity tự động cho mọi relation: CAUSES/PART_OF/CONNECTED có semantics khác nhau. “Đường phụ thuộc” không tự chứng minh nguyên nhân thực nghiệm của lỗi. Câu trả lời phải nói requires/reachable khi đó là thứ rule chứng minh.

Frontier entry giữ node/entity, relation automaton state, context, depth, parent index, source edge ID, score, polarity. Fetch outgoing/incoming list theo direction. Check type, context, generation, variable bindings và cycle, rồi mới apply rule. Learned score điều khiển thứ tự search, không thay logic để biến edge sai thành proof hợp lệ.

Min-heap dùng giữ BEST K theo comparator hiện hành: root là phần tử tệ nhất trong tập đang giữ. Frontier beam scheduling có thể drain sort nhỏ; đừng suy ra mọi priority queue phải dùng cùng hướng heap.

### 6.2 Ví dụ phân biệt deduction với answer ROM

Corpus chỉ lưu:

```text
READ_A requires READY_B
READY_B requires CALIB_C
```

Hỏi “READ_A phụ thuộc gián tiếp gì?” FPGA phải tìm CALIB_C qua hai edge và trả hai edge ID làm proof. Không lưu sẵn READ_A→CALIB_C.

Đổi CALIB_C thành CALIB_D trong corpus test mới sau freeze source: đáp án phải thành D. Xóa edge thứ hai: phải UNKNOWN/INCOMPLETE theo search status. Đảo chiều edge: không được tự giữ C. Đổi ngẫu nhiên mọi ID nhưng giữ structure: đáp án ngữ nghĩa phải tương đương.

Điều này là suy luận symbolic thật trong miền hữu hạn. Việc tự khám phá rule mới là *inductive learning* khác, chưa nằm trong model đầu. Sau khi base chạy ổn, có thể thêm chọn trọng số trong một thư viện rule nhỏ từ reward; không gọi việc áp fixed rules là tự học luật.

### 6.3 UNKNOWN và mâu thuẫn

Kết quả không chỉ là token pred:

- ANSWER: proof hợp lệ, đủ confidence.
- UNKNOWN: không có bằng chứng trong phạm vi đã hoàn tất.
- AMBIGUOUS: nhiều parse hoặc nhiều đáp án không phân giải được.
- CONFLICT: có evidence đối nghịch cùng context/time semantics.
- SEARCH_INCOMPLETE: budget exhausted.

Missing edge không đồng nghĩa edge false trong open-world store. Khi có cả positive và negative evidence, không gộp chúng thành một score mờ rồi tự khẳng định đúng. Threshold confidence phải hiệu chỉnh ở dev và freeze trước exam; score margin không phải xác suất đã hiệu chuẩn.

## 7. Evidence → LM: phải nối nội dung, không chỉ ID

Giữ full20/32-bit identity xuyên descriptor, dedup, cache, persist, proof. Với evidence payload, vật chất hóa subject/relation/object/context/source trên FPGA. ID là địa chỉ và identity; LM chưa được train không hiểu ý nghĩa số ID.

Phương án ít phá interface nhất để thử: encode mỗi20-bit ID bằng3 byte kèm role marker; dùng nhiều ctx beats có length, không cắt low8. LM C=128 nên token budget phải tính theo packet thật; ví dụ toàn Top8 IDs cần24 byte, các tuple/proof dùng thêm token và phải bounded. Điều này chỉ sửa identity transport, chưa khiến LM hiểu evidence.

Model gate cần:

1. SHA weight image thực boot từ flash; source→generator/train history→image provenance.
2. Tokenizer/vocab gắn với weights, token ranges hợp lệ. LM hiện input8-bit/output10-bit là contract mismatch nếu muốn autoregressive mọi1024 output. Hoặc nâng input10-bit và ctx interface, hoặc huấn luyện model byte-vocab với output mask phù hợp. Đây là candidate version mới phải kiểm riêng; không mask rồi nói oracle cũ vẫn nguyên.
3. Data huấn luyện evidence-to-text có input evidence và câu trả lời grounded; held-out world, phrasing, graph combination tách biệt. Nếu offline weight training là bootstrap được chấp thuận, phải báo đó là offline; online behavioral learning vẫn phải thực hiện trên FPGA. Nếu cấm offline trained weight, phải budget một chương trình train FPGA riêng và không hứa chất lượng sớm.
4. Autoregressive controller: feedback token FPGA → next context → EOS/max tokens, counts start/done chính xác; không CPU quyết định next token.
5. So với copy/evidence-only và bounded grammar renderer. Output fluency/grounded accuracy/error rate phải đo; exact integer regression không thay semantic scoring.

Một grammar renderer chạy FPGA có thể tạo câu có ý nghĩa từ proof và không phải prompt→answer lookup. Nhưng nó không thay thế điều kiện LM06-active của Gate14. Nếu LM chưa đủ chất lượng, báo “reasoner verified, language composer OPEN”; không đổi sản phẩm thành renderer-only rồi tuyên bố Gate14 đã đóng.

Oracle 653/689/237/60 vẫn là frozen legacy regression. New natural-language/serialized-evidence model có law/dataset/oracle riêng đăng ký trước. Cần chốt rõ compatibility mode để kiểm control và production path mới; không hardcode old outputs trên production để thỏa cả hai.

## 8. Memory và phân bổ tài nguyên

### 8.1 DDR footprint ước tính

| Thành phần | Logical payload ví dụ |
|---|---:|
| 800k record ×32B | 25.600.000 B |
| Tối đa4 postings/record ×4B | 12.800.000 B |
| Dense backing delta16B/record, nếu dùng | 12.800.000 B |
| LM INT8 weights | 802.816 B |
| Directory/skip metadata/payload text/journal | đo và reserve riêng |

Đây là dung lượng payload, chưa padding/index amplification. Arty A7 có256MB DDR3L theo Digilent, nhưng không có nghĩa mọi vùng hiện trống. Lập memory map không overlap boot/weights/learned/graph trước DMA. Payload text của800k tài liệu dài có thể không fit; giới hạn record/token payload và external corpus image phải rõ.

DDR là volatile. Flush/reload + BRAM kill chứng minh warm persistence. Nếu cần power-loss survival, journal/A-B checkpoints vào QSPI/SD có CRC/generation và wear policy; không dùng ghi flash mỗi reward.

### 8.2 BRAM working-set budget đề xuất, chưa synth

| Working set | RAMB36-equivalent budget |
|---|---:|
| Parser dictionary hot cache / token buffer | 2 |
| Index metadata/page buffers | 2 |
| Learned hot cache512 entries×32B | 4 |
| Dedup ID list/tags | 1 |
| Frontier/proof scratch | 2 |
| Evidence/output buffers | 2 |
| Tổng phần chức năng dự kiến | 13 |

Byte payload 4KiB/RAMB36 là planning conservative; actual inference phụ thuộc port/width/packing. 512×32B=16KiB cache không có nghĩa thêm4BRAM luôn đủ mọi tags/ECC/port. Exact mapping phải OOC rồi full route.

U2R hiện106,5BRAM; nếu cộng thẳng13 thành119,5, còn fit danh nghĩa dưới135 nhưng vượt preferred115 và chưa tính mọi duplication. Do đó phải thay working set cũ hoặc thu hồi ít nhất4,5BRAM để quay về preferred115. Đây là kiểm khả thi thô, không phép cộng chứng minh final fit.

Resource targets cho integrated candidate: LUT≤40k preferred, FF≤50k preferred, DSP≤32 preferred, BRAM≤115 preferred; hard device fit và WNS/TNS/WHS/THS/DRC/route theo V3.1. Free slices≥800 preferred. Không tự nâng preferred thành hard acceptance hoặc đảo lại.

### 8.3 Ưu tiên tối ưu theo measured hierarchy

1. Hợp nhất learned graph + SOA thành một scorer/Top-K/evidence path; giữ store/transaction cần thiết. U_g1g5 ~2.982LUT trong report chỉ là envelope, không được tính toàn bộ là savings vì chức năng học phải giữ.
2. Logits hiện1024×32bit distributed RAM có704 LUTRAM +392 logicLUT. Thử synchronous BRAM một/two tile theo synthesis, thêm read latency và sửa scheduler; chỉ promote nếu bit-exact và full-chip slice giảm. Đừng đổi RAM attribute mà quên read latency.
3. Parser lexicon so sánh song song ~2389 SliceLUT OOC: cân nhắc sequential ROM/trie lookup. UART115200 rất chậm so với FPGA, không cần một cycle cho cả dictionary. Freeze same token law rồi differential so sánh.
4. Dedup exact bằng BRAM list scan:256 candidate, tối đa32.640 so sánh pairwise nếu scan toàn history; 50MHz lý tưởng ~0,653ms cho phần so sánh, chưa BRAM cycles. Đổi latency lấy tránh256 comparators song song. Hash set chỉ promote nếu xử lý collision không mất candidate; Bloom-only không đủ exact dedup.
5. Với inference-only logits, thử streaming argmax và recompute/store cần thiết; không xóa state backward/CE của frozen core theo phỏng đoán. Const inputs có thể đã được synth prune; report mới mới chứng minh savings.
6. Activation/weight tile là bulk BRAM. Retile/recompute là can thiệp riêng có lifetime proof; không dùng quantize weights để hứa tự giảm activation RAM.

PHYS4 giữ mặc định. Không hạ clock MIG tùy ý; có thể giảm core frequency bằng clock plan hợp lệ và chứng minh CDC. Resource sharing không tự giảm area nếu synthesis đã share; mọi gain cần measured delta.

## 9. Phép thử chống tự lừa mình

Trước candidate design, freeze dev/train/confirmation. Confirmation do generator có seed chưa dùng tuning; alias/graph/index/model không được sửa sau khi xem test để vẫn gọi cùng gate PASS. R3 phrases hiện được xem là dev/regression, không tái sử dụng làm “blind novel understanding”.

Các ngưỡng sau là **đề xuất để prereg trước triển khai**, không sửa threshold lịch sử:

| Năng lực | Phép thử | Điều kiện đề xuất |
|---|---|---|
| Role parsing | A→B so B→A, phủ định/context, ambiguous | ≥95% đúng trong grammar công bố; outside grammar phải flag |
| Sparse retrieval | 4096+ evidence thực có distractor rồi scale ladder | evidence recall@cap≥95%; candidate reduction≥90% tại N≥4096; báo per-class |
| Index integrity | storage coverage và high IDs | 100% valid record có posting đầy đủ; ID799999 và low16 collision cases đúng |
| Reasoning | 1/2/3hop, kết luận không lưu sẵn | proposed accuracy≥95/90/85%; proof validity100% cho ANSWER |
| Counterfactual | remove/reverse decisive edge, context swap | không giữ proof không còn hợp lệ |
| Reward learning | ≥5 seeds, shared-feature model vs no-update/shuffled reward | ≥10 percentage points held-out gain và CI của paired gain >0; retention giảm≤5pp |
| Uncertainty | unrelated, ambiguous, contradictory, incomplete | ≥95% unrelated rejection; report coverage vs error; không tính abstain thành correct answer |
| Persistence | cache thrash, full slot, reset, BRAM-loss | exact state/digest/IDs, duplicate reward không double-commit |
| LM semantics | evidence-to-text, EOS, unsupported answer | metric/threshold do domain exam quy định trước; không thay bằng pred checksum |

Chance/no-learning/fixed-lexicon/single-hop controls phải chạy. Báo tất cả failed classes, số câu và confidence interval; không gộp chúng thành một accuracy duy nhất. At scale giữ data/query law giống nhau; không đổi sang ID-derived keys. Khi memory skew khiến cap không đạt recall, trả failure và đánh giá rival, không hạ min coverage xuống20%.

## 10. Lộ trình gắn vào V3.1, không thêm chiến dịch vô hạn

### Bước 1 — U4A correction + representation contract

Một mục tiêu: profile sparse có chọn lọc trên key thật. Dùng valid masks, dataset đủ lớn, full posting index, negative queries, measured byte model và report selected-profile thresholds. Không promote model42-title trả41-record. Domain/token law giữa Appendix và RTL phải thống nhất. Hai rival + cap sweep đã định trước là đủ; không search features vô hạn.

### Bước 2 — U4/U5 integrity và scale

Full-ID persistence/descriptor, all-key capture, AXI RID/RRESP/RLAST/length/timeout, exact dedup, budget accounting. V1 dataset static800k còn giữ nguyên. Đóng high-ID transport/storage trước khi language model phụ thuộc vào nó.

### Bước 3 — U6/U7A/U7 learning và bounded reasoning

Một production candidate stream, selected pending proof, proper commit; shared-feature reward law và ablation trên data nhỏ. Reasoning proof engine triển khai sau reference feasibility. Đây là bổ sung capability cho mục tiêu “suy luận thật” của người dùng; fixed rules không tự trở thành inductive learning.

### Bước 4 — U8/U8R semantics + physical preflight

LM checkpoint/vocab/context bridge/generation proof. Remove synthetic production hierarchy. Kiểm tra early cofit để thấy area trước khi chờ mọi test; report chỉ là preflight, final source freeze vẫn sau gate correctness.

### Bước 5 — U9 → U10 → final reconciliation

Clean source/config manifests, full implementation mới, bit unique, đúng final authorization, UART trước program và blind exam trên cùng bit. Giữ acceptance board cũ theo compatibility contract và capability exam mới theo prereg riêng. Không dùng PASS của hai bit khác nhau để ghép thành một hệ thống đã PASS.

Nếu reference của bước1 hoặc3 không đạt, dừng silicon expansion và sửa giả thuyết. Nếu resource không fit sau hợp nhất/share, thu hẹp beam/latency/query length trong candidate law có version; không xóa reasoning/learning proof hoặc bỏ LM rồi vẫn claim cùng final Gate14.

## 11. Nguồn phương pháp và giới hạn suy diễn

- [Li et al., contextual-bandit recommendation](https://arxiv.org/abs/1003.0146): động lực cho partial feedback. Luật SGD fixed-point/epsilon-greedy ở đây là đề xuất engineering riêng, không phải kết quả LinUCB của paper.
- [Crammer et al., Online Passive-Aggressive Algorithms](https://www.jmlr.org/papers/v7/crammer06a.html): phù hợp khi có nhãn/full-information. Không tạo positive target từ reward-only bằng giả định.
- [Weston et al., bAbI tasks](https://arxiv.org/abs/1502.05698): nền tảng cho tách chain/deduction/induction tests. Bộ test dự án phải tự công bố và chạy.
- [Cropper et al., Inductive logic programming at30](https://arxiv.org/abs/2102.10556): phân biệt học logic từ dữ liệu với áp dụng rule có sẵn. Engine rule giới hạn đề xuất ở đây không được hứa tự phát minh rule.
- [AMD UG474](https://docs.amd.com/r/en-US/ug474_7Series_CLB/CLB-Slices), [Digilent Arty A7](https://digilent.com/shop/arty-a7-100t-artix-7-fpga-development-board/): ràng buộc vật lý. Mọi budget cụ thể vẫn cần measured synthesis/route trên source candidate.
