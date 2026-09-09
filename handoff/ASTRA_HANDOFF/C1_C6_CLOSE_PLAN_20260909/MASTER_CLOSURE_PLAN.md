# Native AI: nghiệm thu và kế hoạch đóng C1–C6

Ngày lập: 09/09/2026. Target: Arty A7-100T, xc7a100tcsg324-1, Vivado2026.1.
Repo: D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH.
Phạm vi: review độc lập và kế hoạch cho Cursor; không sửa RTL, không đổi LOOP_STATE/automation, không program. Các tài liệu/work order đã cung cấp là đầu vào để đối chiếu, không phải bằng chứng thực thi hoặc quyền thay Master tự động.

## 1. Kết luận quản trị

**ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION.** Có tiến bộ thực về retrieval, AXI/MIG, transaction, các ca reasoning và route. Chưa đủ để đóng Master C1–C6 cho một sản phẩm duy nhất.

18/18 file KEEP khớp live. Bit C6-03 khớp SHA edda8575f3130b6f645af223c5d9000539a1a80db23731bb18f7a280ad06c0ba. Đây là integrity, không phải chất lượng ngôn ngữ hay bảo đảm các thuật toán nằm trong bit đều đáp ứng Master. Không làm lại C1/C2 unit đã được chứng minh chỉ để thêm marker.

Các bottleneck chính theo thứ tự tác động:
1. C4 canonical hiện tại là head chọn token theo object, không có contextual/autoregressive language dependence đã chứng minh; thêm20 câu không giải quyết architecture gap.
2. C5 tự thưởng +3, thay vì tiếp nhận reward người dùng cho pending transaction; C2 đang lưu một accumulator w0 riêng, không phải vector SGD32 của C3.
3. C5 chỉ phát token cuối qua UART; cấu hình baud mô phỏng đi vào production hierarchy.
4. C1 cartesian procedural image và C3/C5 planted images chưa thành một bộ corpus/index/schema/chất lượng/traffic contract dùng chung được đóng băng.
5. C6 có bit/timing nhưng source commit, model/vocab, image và initial state chưa được pin thành một final artifact.

Nhiệm vụ là hội tụ các đường đã có, không mở thêm các wrapper hoặc bảng so sánh PASS riêng lẻ. C7 là bước xác nhận silicon cuối, không phải điều kiện vòng tròn ngăn C1–C6 đạt readiness trước board.

## 2. Chất lượng bằng chứng và giới hạn review

Đã đọc source trọng yếu C2/C3/C4/C5/C6, bit manifest, trạng thái live, hard-block/addendum và hai work order được chỉ định. Đã kiểm hash KEEP/bit; chưa rerun XSim/Vivado hay board. Nhiều báo cáo dài chỉ đọc phần liên quan; không tuyên bố kiểm toán toàn repo hoặc chứng minh mọi đường FSM. Finding RTL_FACT dưới đây dựa trên nguồn hiện tại; test đề xuất chưa chạy.

Nguồn pin trong SOURCE_SNAPSHOT.json; kết quả KEEP trong KEEP_VERIFICATION.json. Đọc snapshot này trước khi dùng số dòng vì Cursor có thể tiếp tục sửa live.

## 3. Phán định từng C-letter

| Letter | Giữ được | Chưa được đóng toàn bộ | Điều kiện hoàn tất trước board |
|---|---|---|---|
| C1 | XSim800k cartesian/procedural, cap-sweep và index/query-law đã kiểm trong scope cũ | DDR_QUERY_BOUND_FINAL chưa freeze; image thật/full coverage cùng schema của C5 chưa pin | Builder xuất image đầy đủ và manifest; same-law parser/index/descriptors; per-class recall/selectivity/bytes/incomplete trên ladder; integrated sample dùng đúng image |
| C2 | Journal/commit/multi-slot/stall/MIG unit | Production state không phải toàn bộ SGD/pending C3; PERSIST_SCHEMA_VERSION chưa freeze | Serialized full state, write completion/commit marker, reset/reload phục hồi đúng bank và identity; không TB restore weight |
| C3 | Một số arms, ID-disjoint và mutation XSim | Statistical protocol/controls phải audit lại; reload chỉ w0 + TB restore phần còn lại không đủ; chưa final integrated transfer | >=5 training seeds thật, A/B/C/D, CI, nontrivial held-out và reload full vector trên canonical path |
| C4 | Adapter, compact head, dict/copy tests | Chưa có conditional language model/checkpoint/vocab/context đạt Master; current head có bug bias load | Model phụ thuộc evidence + prefix + weights; held-out language metrics; 4 ablations đầy đủ; không class-ID oracle |
| C5 | Một hierarchy, MIG regression, fix deadlock r4 | Auto+3, persist riêng, token cuối, sim UART, error-path interface và image loader | Một path inference/train/persist/generation thật qua UART/MIG; end-to-end regressions |
| C6 | Routed bit edda8575…, WNS+0.233/WHS+0.013 được report | C5/C4 chưa chuẩn, source dirty, image chưa pin | Exact source/config/images/model/schema commit + full build từ freeze, fit/timing/CDC/DRC và reproducer |

Tách `VERIFIED_XSIM`, `PREBOARD_READY` và `VERIFIED_BOARD`. C3 statistical/preboard có thể hoàn thành trước C6. Microexam silicon và retained behavior thuộc C7; toàn sản phẩm chỉ final PASS khi C7 đạt. C6 không đòi đã program mới được close; nó đòi đúng final bit/source và physical closure. Chỉ báo cáo `C1_C2_XSIM_ACCEPTED` trong scope cũ, không biến thành final C1/C2 vô điều kiện.

## 4. Finding có thể hành động

### F01 — C4 bias load bị vô hiệu hóa (RTL_FACT, P1)

a7ng_astra_c4_lm06_grounded_gen.svh định nghĩa V=64. Source .sv ở nhánh LD_BIAS kiểm `load_idx_i < A7NG_C4G_V[5:0]`; 64 cắt6-bit bằng0. Mọi index0..63 đều bị từ chối. Khả năng load bias được mô tả trong WO0550 không đúng source này.

Sửa ở module revision mới: width guard đủ rộng hoặc bỏ guard khi mọi giá trị index đều hợp lệ; không sửa KEEP. Test đọc/quan sát ảnh hưởng bias tại index0,1,63; tải hai bank khác nhau giữ evidence cố định, output phải đổi theo oracle. Không dùng chỉ g_match/g_safe thay kiểm bias.

### F02 — Head chọn object không phải contextual generation (RTL_FACT, P1)

score_at(t)=bias[t]+bonus nếu t==evid_obj + SAFE/EOS bonus. x_rel được latch nhưng không đi vào score. last_tok chỉ truyền tới BYTE256 adapter; adapter chọn argmax từ cand_sc, in_tok không ảnh hưởng lựa chọn. Vì vậy feedback có dây nhưng không có ảnh hưởng nhân quả lên phân phối token kế tiếp. Không có QUERY/PROOF sequence input trong head này. Score là tổng số nguyên, không phải bằng chứng một phân phối xác suất đã được học.

V=64 không biểu diễn trực tiếp ID64,112,144. Byte-vocabulary256 cũng không đồng nghĩa database ID là token ngôn ngữ. Test object-ID20/20 không đóng grounded language. g_match còn cộng khi evid_has=0; SAFE thắng chỉ nếu cài trọng số phù hợp. Phải có status/proof gate trước model cho unsupported query.

### F03 — Work order C4 0550 có kết luận vượt authority (SPEC_CONFLICT, P1)

Grok prompt dòng550 nằm dưới ASTRA LEARNING TARGET và cấm thêm mạng lớn **merely to use the word AI**; không phải lệnh cấm mọi LM hay đủ lý do đổi Master §10. Kết quả TinyGPT0/2 và BRAM260 ở một cấu hình là bằng chứng ứng viên đó không đạt, không chứng minh mọi LM nhỏ đều bất khả thi.

Không thực hiện bước WO0550 sửa trực tiếp bag cũ lên20 mẫu rồi đặt C4_MASTER=CLOSED. Bốn intervention dependency có thể pass với renderer nếu chỉ đổi bonus; chúng cần thiết nhưng không đủ. WO còn thiếu decisive-evidence-replaced trong bộ ablation được chọn. Giữ báo cáo đó làm proposal, cần thay bằng contract kiểm được trong CURSOR_WORK_ORDERS.md.

Không ép quay lại802k. Chọn compact learned sequence model khả thi với footprint đo được; nếu literal Master bắt buộc specific LM06 core, ghi architecture amendment rõ ràng trước promotion. Chỉ chủ sở hữu có thể chấp nhận thay product requirement; kế hoạch này không tự phê duyệt việc thay nó. Có thể tiến hành feasibility local và làm quyết định cụ thể trước khi cần chốt amendment.

### F04 — C5 tự phát reward cố định (RTL_FACT, P1)

prod_top:470 c3_rew=+3, :483 p_urew=+3; không có assignment cập nhật từ UART. ST_WAITQ tự pulse c3_rew_v khi ANSWER. Đây là online auto-reward mặc định, không phải host chỉ gửi scalar reward cho transaction đã quyết định. A/B thay đổi sau nhiều query chưa chứng minh quy trình reward đúng.

Thêm framed reward packet chứa version/session/txn/model generation/scalar, CRC/length và response status. Không tự update ở query inference. Test hai query không reward giữ nguyên32 weight; -3/+3/0, duplicate, stale, malformed và freeze; quan sát actual weight bank. Internal txn output nối ngược input không chứng minh host echo validation.

### F05 — C2 persist sai đối tượng học khi tích hợp (RTL_FACT, P1)

u_c2 nhận scalar reward và cập nhật `live_w0 += reward` tại c2_persist_commit:234. Nó không serialize `c3_w[0:31]`. u_c3 load_v tied0 ở prod_top:372; không có đường restore toàn vector. Ví dụ C3 SGD có Δw0=-5, nhưng C2 là accumulator ±3 riêng: hai state khác nhau. Flush/reload w0=3 là transport test có giá trị, không proof retained learned behavior.

Tạo production state backend mới, giữ C2 KEEP làm control. Snapshot bank đã commit + pending state + schema/version/generation + CRC/hash và commit sequence. A/B DDR slot/journal: payload trước, marker sau, phản hồi write đúng ID/RESP; chỉ restore bản hoàn chỉnh. Restore qua cổng load của cùng C3 bank, không force/hierarchical TB write. So sánh đủ32 weight, phi, identities và hành vi held-out sau on-chip clear.

### F06 — C5 làm mất token stream (RTL_FACT, P1)

ST_GEN cập nhật last_gen mỗi g_tv; sau g_done mới ST_TXNL phát last_gen và EOL. Nhiều token trước đó không được gửi; nếu token cuối EOS thì nội dung câu trả lời bị mất. C4Q sibling bag không chứng minh sửa trên canonical C5.

Thêm ready/valid và FIFO/backpressure hoặc scheduler một-token-một-ACK. Không để generator chạy vượt UART. Test pin-level decode toàn sequence>=3 token, stall TX, EOS/MAX và hai query liên tiếp; oracle sequence cố định trước run.

### F07 — UART sim constants nằm trong C6 (RTL_FACT, P1)

prod_top.svh:7–8 CLK_HZ=8000, BAUD=800 =>10 clock/bit. C6 clock C5 bằng MIG ui_clk, không phải8000Hz. Tốc độ vật lý vì vậy không phải115200. Giá trị12ns của clock trong report tương ứng khoảng83.33MHz, 10cycles/bit xấp xỉ8.33Mbaud; phải xác nhận net clock thật khi final pin.

Chuyển thành top parameters clock/baud; simulation tăng tốc bằng test override rõ ràng, final default là clock-domain thực và115200. Compile cùng hierarchy final; test bit-time và UART frames ở full clock ratio. Không chỉnh core MIG để chữa UART.

### F08 — Interface C5/C6 làm mất AXI lỗi (RTL_FACT, P1)

axi1b adapter trả s_rresp=OKAY, s_rid từ ID lưu, s_rlast tự tính; top simplified ports thiếu downstream error channels. C6 dùng MIG nhưng C5 không nhận đầy đủ response semantics. Tương tự C2 response phải kiểm endpoint thực thay vì dựng OKAY. Điều này giới hạn negative-test validity qua actual top.

Backend có thể serialize một request tại một thời điểm, nhưng phải mang RRESP/BRESP, identity/last và outstanding ownership đến client. Inject SLVERR/DECERR, wrong/late ID, malformed last, independent AW/W/B stalls trên cùng adapter. “No dual owner” không thay “no orphan/drop/false success”. Giữ fix grant/ckpt buffer r4, không làm lại từ đầu.

### F09 — C3 full-feature/generalization chưa tự suy ra từ bag count (EVIDENCE_GAP)

C3 fphi chỉ có case0..15, phần16..31=0; 32weight interface không chứng minh32 feature hoạt động độc lập. Redundant validity flags và confidence tạo bài toán dễ vẫn hợp lệ cho plumbing, chưa đủ broad transfer. Báo actual active-feature rank/uniqueness. Arm per-ID phải có decision code riêng, không dùng output của SGD armD rồi gọi là per-ID. Kiểm raw seed generation, không lấy cùng phi đổi ID làm independent worlds. Bổ sung fixed-validity/fixed-confidence control, world có>=2 proof hợp lệ với source reliability/context preference thay đổi có chủ đích qua reward.

### F10 — C6 measured fit chưa phải final fit (FACT/EVIDENCE_GAP)

FREEZE_MANIFEST tự ghi NOT_A_CLEAN_TREE_PIN, NOT_A_800K_CARTESIAN_IMAGE, index/dictionary/initial state NOT_PINNED. Util9056LUT/7095FF/0BRAM/0DSP là cấu hình hiện tại, không footprint future learned generator+full persistence. Không cộng OOC để suy ra fit. Bất cứ sửa C4/C5/config nào đều phải tạo final bit mới; bit edda8575… giữ làm physical evidence cũ.

## 5. Kiến trúc hội tụ đề xuất

Một candidate integration root duy nhất, không nhất thiết final physical top ngay lập tức:

UART framed commands → parser/full-ID symbol map → C1 frozen index/descriptor fetch → legal proof frontier → shared rank → selected pending → explicit reward → committed SGD bank → versioned DDR checkpoint.

Answer branch: selected proof/status → FPGA materializer đọc dictionary/text payload trong DDR → compact learned conditional generator → bounded token FIFO → UART. Proof validity/status nằm ngoài learned score. Không model nào được biến invalid proof thành ANSWER.

Tách states: RECEIVED, ACCEPTED, COMMITTED, PERSISTED, FAILED. `ACCEPTED != COMMITTED`; ACK nhận không hứa lưu. Cache/DDR commit boundary cần một definition duy nhất. Với warm persistence, mất BRAM chỉ được hứa phục hồi bản PERSISTED; nếu API hứa mọi COMMITTED phải survive thì chỉ phát COMMITTED sau DDR durable-with-power marker. Power-loss NVM ngoài V1 trừ khi owner bổ sung.

Địa chỉ corpus/index/state/weights/dictionary không chồng lấn; builder xuất toàn bộ images và coverage manifest. Procedural memory model phải được đối chiếu byte-for-byte với image serializer trên sample/ranges, không query-specific plant/answer overlay ở test cuối. DDR bound tách request/response bytes và LM traffic; không dùng1632B của một workload làm universal final bound.

## 6. DAG hiệu quả và điều kiện đóng

| Work package | Phụ thuộc | Output và stop condition |
|---|---|---|
| P0 contract + evidence reconcile | hiện trạng | C1/C2 scope giữ nguyên; model architecture decision record; matrix gaps không circular; source manifest |
| P1 canonical state/reward I/O | P0 | Explicit reward; full32-bank DDR restore; status/txn đúng. No half/false commit |
| P2 C4 feasibility | P0; chạy song song độc lập P1 | Small trained conditional generator + vocab+data provenance, held-out sequence tests; model size/latency estimate. Không blanket PASS từ head hiện tại |
| P3 C1 production image closure | P0; C1 KEEP | Image/hash/coverage/bounds fixed; same-law integrated query regression; không rerun toàn ladder vô cớ |
| P4 C3 integrated transfer | P1,P3 | >=5 independent training seeds, A/B/C/D + validity baseline; gain>=10pp, paired CI lower>0, A>shuffled, per-ID comparison; reload drop<=5pp |
| P5 C4 canonical closure | P2, materializer API stable | >=90% grounded held-out, >=95% unsupported safe, <=5% hallucinated facts, termination100%; weights/prefix/evidence interventions; no host answer/token |
| P6 C5 unified regression | P1,P3,P4,P5 | Same hierarchy/token FIFO/baud/MIG/response errors; no test shortcuts; all functional gates ready |
| P7 C6 final freeze/build | P6 | One source commit/tag plus all config/images; full synth/route/CDC/DRC; bit hash verified; reproducible build |
| C7 silicon | P7 + explicit artifact board authority | Blind final episodes parser/retrieval/proof/reward/heldout/persist/language; final BOARD_PASS only here |

P2 feasibility không cần chờ P4: phát hiện model bất khả thi sớm. P4/C3 không phải chờ C7 mới chạy/đóng preboard; label `C3_PREBOARD_VERIFIED` rồi `C3_BOARD_CONFIRMED` tại C7. Mỗi gate fail chỉ trả về dependency bị ảnh hưởng, không xóa acceptance của unrelated KEEP.

## 7. Thiết kế thử nghiệm C3/C4 để không tự lừa mình

C3: separate dev vs sealed confirm seeds; >=5 independent initialization/training streams, mỗi seed nhiều held-out query và entity/world disjoint theo claim. Cùng world cho A/B/C/D; report per-seed accuracy counts, coverage, invalid-proof count, cost. Paired CI dùng seed/world làm đơn vị độc lập (paired bootstrap hoặc method ghi trước), không coi hundreds correlated queries là hundreds independent seeds. Không chỉ in pair_pos5/5. Reward chỉ cho action đã chọn; diagnostic per-ID model nhận cùng feedback budget, nếu baseline dùng full labels phải ghi là upper-bound khác điều kiện.

C4: object IDs thay đổi nhưng text semantics giữ; query context/role khác nhau; nhiều target answer có cùng token đầu; confidence không encode answer. Dataset có câu đúng supported và unknown/conflict; metric mẫu số riêng cho grounded/safe/hallucination;20 câu không đủ tự chứng minh95% safe nếu unsupported subset ít. Chọn số mẫu trước theo coverage và CI mong muốn, không coi20 là số thần kỳ.

Normal/zero/corrupt weights + evidence removed/replaced đều cần. Thêm prefix intervention giữ evidence: next-token distribution phải đổi theo learned prefix state; chỉ dây feed_tok chưa đủ. Exact argmax integer match là arithmetic test riêng; semantic quality chấm output sequence, không token ID bằng object. Tách safety gate từ language fluency; corruption không được fabricate proof hợp lệ.

## 8. Chính sách resource và milestone completion

Không bắt802k hoặc0BRAM. Giữ architecture bounded có model objective/context thật. Một compact recurrent/conditional token model hoặc LM06-compatible nhỏ là candidate, chưa measured fit. Quyết định dựa dataset, inference RAM/state/tile và full-chip estimate, không dựa số model params một mình. Tối đa2 candidate model/index rivals mỗi revision để tránh search vô hạn.

C6 hard: part fit, WNS>=0/TNS0, WHS>=0/THS0, route/unrouted0, DRC error0, critical unconstrained0, CDC và interface exceptions được justify. Preferred40kLUT/50kFF/115BRAM36eq/32DSP/free slices800 là budget planning, không đo hiện tại. Không thêm false paths chỉ để đổi số âm thành dương. UART async constraints phải bám interface/CDC, không invent synchronous timing law.

Trước C6 final: source sạch ở exact commit của **accepted files** do Cursor quản lý, không git clean hoặc reset user work. Có thể tạo reproducible source archive từ manifest trong lúc chuẩn bị commit; final requirement commit không được thay bằng “HEAD cũ + dirty”. Đóng image hashes, compiler/IP/XDC, model weights, training/export sources, initial bank, baud/clock. Run từ output dir mới và giữ fail artifacts.

## 9. Vai trò và điều phối

Grok giữ parent hiện hữu và dispatch, Cursor implement ở clone live, Antigravity auditor riêng, Codex review/giải pháp. Không tạo thêm parent. Auditor không sửa DUT và implementer không self-accept Master. Mỗi source một writer; P1/P2 chạy song song chỉ khi API/write ownership không trùng. Một heavy Vivado/MIG job tại một thời điểm, read-only audit có thể song song.

Mỗi task: ACK → contract/prereg/input hash → implementation → raw test → review → scoped accept/corrective. Tối đa một corrective một giả thuyết, lưu source lỗi; nếu lại fail thì RCA trước run tiếp, không đổi oracle. Build script không ghi đè log hoặc xóa bag cũ. Count bag không phải tiến độ; dashboard chỉ hiển thị required capability, remaining falsifier, owner và next dependency.

## 10. Mục tiêu hoàn thành thực tế

Đóng C1–C6 nghĩa là một final candidate đáp ứng tất cả quality/dataflow/state/language/resource contracts ở preboard level. Không thể hứa ngày PASS hoặc bảo đảm thuật toán chưa thử sẽ đạt90%/10pp. Nếu C4 learned candidate không đạt, cung cấp failure class và quyết định kiến trúc có dữ liệu; không đổi tên renderer thành LM. Nếu cần scope amendment, đưa hai phương án cụ thể kèm claim/resource/quality loss để owner quyết định; không tự sửa chuẩn.

Chưa cấp quyền program bit edda8575… hoặc bit mới. Quyền checkpoint e51bdca2 được báo trong state không chuyển sang C6. Plan này không thay automation/board token. Xem CURSOR_WORK_ORDERS.md để thực thi theo thứ tự ưu tiên.
