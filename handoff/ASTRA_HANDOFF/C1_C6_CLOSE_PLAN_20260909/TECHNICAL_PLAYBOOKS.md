# Technical playbooks — Cursor tự triển khai các phần khó

09/09/2026. Companion cho MASTER_CLOSURE_PLAN.md và CURSOR_WORK_ORDERS.md. Đây là thiết kế đề xuất và tiêu chuẩn kiểm chứng, không phải RTL đã thử hoặc authority tự đóng gate. Các lỗi source đã xác minh nằm trong báo cáo chính. Khi bắt đầu, refresh hash/state/work ownership; không mặc định source vẫn như snapshot. Không sửa KEEP/bag cũ. Không board/program trong các playbook này.

## A. C4: learned grounded sequence generation

### A1. Chọn bài toán trước model

Không học lại tri thức corpus trong decoder. Reasoner cung cấp proof đã kiểm; decoder học chuyển query + facts/proof thành chuỗi câu trả lời ngắn. Model phải dùng cả evidence và prefix, không chỉ object-ID rồi EOS.

Hai contract tách biệt:
- Semantic: proof/status/query/context nào cho phép nội dung nào. Logic kiểm proof không nằm trong model.
- Language: cách diễn đạt nội dung đó bằng token sequence. Vocab, EOS, format và scorer phải versioned.

Với UNKNOWN/CONFLICT/INCOMPLETE, status gate có thể giới hạn loại câu trả lời nhưng phải khai báo. Không dùng câu mẫu cố định thay toàn đường ANSWER rồi gọi đó là learned generation.

### A2. Phương án khuyến nghị để thử trước

Một compact conditional recurrent decoder, embedding byte256, hidden state nhỏ, sequential MAC dùng chung. Đây là candidate engineering, không phải cam kết đạt C4 hoặc thay LM06 được phê duyệt. Chỉ dùng khi compatibility/architecture amendment phù hợp Master đã được ghi; nếu literal LM06 core bắt buộc, so sánh phương án sửa/tái cấu hình core đó trước khi quyết định.

Luồng: materialized context bytes → recurrent context encoder/state → BOS → decoder từng token với previous token + context state → output head → argmax/EOS → feedback. Recurrent state hoặc context attention phải được tiêu thụ thật trong score. Chọn tối đa hai rivals, ví dụ compact recurrent decoder và reduced LM06-compatible decoder; không mở cuộc tìm model vô hạn.

Tính chi phí bằng công thức, không đoán fit:
- Embedding V×E parameters; output head H×V và biasV.
- Recurrent cell phụ thuộc E,H, số gate; tính chính xác từ code model chọn.
- State/activation/accumulator widths, port count và buffers là footprint riêng với weights.
- Cycles/token = số MAC thực / MAC lanes + memory/control stalls; báo end-to-end context+generation.
- Int8 weight không có nghĩa activation/state cũng int8 hoặc BRAM tự giảm tương ứng.

Bắt đầu floating/reference nhỏ để kiểm feasibility, sau đó integer reference với calibration và saturation metrics. Freeze rounding, accumulator widths, nonlinear LUT nếu dùng, argmax tie-break và MAX_TOKENS. Chỉ RTL hóa candidate có quality và định lượng resource/latency khả thi. Không cần đợi full800k để thử decoder với schema/materializer đã ổn định.

### A3. Data contract

Mỗi record gồm input query bytes, ordered verified facts, proof IDs, status, canonical allowed propositions, target text và split/world IDs. IDs chỉ identity; materializer lấy text từ dictionary/image có version. Không TB cấp câu trả lời vào context hoặc inject token thắng.

Split theo world/entity/composition, không chỉ shuffle câu. Có cặp cùng token đầu nhưng phần sau khác; cùng entity khác role/context; hai-hop novel combination; xóa/đổi edge; unrelated/conflict. Không cố định confidence/source-class theo answer label. Aliases là prior được khai báo.

Training data/weights/export/model/tokenizer hashes phải nối thành provenance chain. Local bootstrap training là một workload riêng có compute budget; chưa có quyền tải/cloud thì chỉ lập feasibility và local synthetic-domain corpus có nguồn rõ. Không tự mua tài nguyên hoặc tải pretrained model.

### A4. Các test chặn renderer giả

1. Giữ weights/evidence, thay valid prefix → ít nhất case đăng ký phải đổi next-token logits hoặc sequence đúng ngữ cảnh.
2. Giữ prefix, đổi decisive fact → nội dung kết luận đổi đúng; evidence removed → safe response.
3. Normal/zero/corrupt weights → có sự khác biệt phù hợp; corruption không tạo proof hợp lệ giả.
4. Hai object cùng low8 hoặc cùng token đầu không collapse; high-ID text materialization đúng.
5. Check toàn sequence, không token0 hoặc EOS duy nhất. Host chỉ detokenize.
6. Backpressure giữ token và state ổn định, không skip token; reset/retire abort đúng contract.

Metrics dùng nhóm mẫu riêng: grounded accuracy≥90%, unsupported-safe≥95%, unsupported facts≤5%, termination100%. Đăng ký denominators/sample size/semantic rubric trước confirm; báo confidence intervals, coverage, worst classes. Không tăng lên20 câu rồi mặc định đủ mọi threshold. Offline loss/perplexity là diagnostic, không thay semantic exam.

### A5. Nếu không đạt

- Reference cũng fail: sửa dataset representation/model hypothesis; chưa làm RTL.
- Float pass, integer fail: isolate quantization/rounding/clipping; không chỉnh gold.
- Integer pass, RTL fail: first mismatch context state/logit/token; checkpoint từng boundary.
- RTL pass, fit fail: thử sequentialization/weight streaming/buffer reuse; không bỏ learned dependence để lấy fit.
- Không candidate nào đạt: báo hai product options với claim/resource/quality gap; không tự đổi Master thành renderer-only.

## B. Production persistence: lưu đúng state của learner

### B1. Architectural owner

Chỉ một canonical SGD bank dùng score/update. Backend persist không tự tính lại reward accumulator. Snapshot lấy từ committed bank; restore nạp lại chính bank đó. Full state gồm32 signed weights, model/schema ID, state sequence, session/generation/txn watermark, pending selected proof/phi/prediction nếu contract giữ pending. Không cần per-entity weight table nếu model là global shared32; đừng tạo multi-slot per-ID chỉ để tick capacity.

Multi-slot có thể là A/B snapshots hoặc nhiều model/context heads có lý do. Phân biệt model-store capacity với pending capacity và cache descriptor capacity; mỗi loại có policy riêng.

### B2. State machine khuyến nghị

IDLE → CAPTURE_STABLE → SERIALIZE → WRITE_PAYLOAD → WAIT_RESPONSES → WRITE_COMMIT_MARKER → WAIT_MARKER_RESP → PERSISTED.

Restore: READ_HEADERS → VALIDATE_VERSION_LENGTH_GENERATION → READ_PAYLOAD → VERIFY_CHECKSUM → LOAD_SHADOW_BANK → ATOMIC_INSTALL → READY.

Inference/update bị block hoặc dùng old bank nhất quán trong lúc install. Không cho score đọc nửa bank mới. Snapshot nguyên tử có thể quiesce learner một đoạn ngắn; chưa cần double-buffer nếu resources không đủ.

A/B slots: write inactive slot, checksum+sequence, marker cuối. Giữ old valid slot đến khi new marker thành công. On-chip-state loss nhưng DDR còn điện: chọn bản có sequence hợp lệ cao nhất. Nếu cả hai invalid, fail/empty explicit; không dựng state0 rồi báo restore PASS. Header/payload stale mix phải bị phát hiện.

Checksum phát hiện hỏng dữ liệu, không tự bảo đảm atomicity hoặc security. ACK write response không thay read-back integrity khi contract yêu cầu. Reset ngay marker boundary phải test; DDR reset/calibration có thể phá retention nên xác định chính xác reset domain.

### B3. ACK semantics

RECEIVED = packet valid framing; ACCEPTED = pending key hợp lệ và update scheduled; COMMITTED = canonical bank transition hoàn tất; PERSISTED = backing image hoàn chỉnh theo contract. Nếu API hứa COMMITTED sống qua BRAM loss, dời commit boundary tới sau persistence hoặc trả distinct volatile-commit status. Không dùng accepted==committed.

Reward replay identity phải tồn tại đủ vòng đời. Session nonce/counter uniqueness là protocol, không semantic input; reset không được tái sinh identity cũ khi delayed packet còn có thể tới. Trước counter wrap: refuse/new session contract, không silently wrap. Persistence của replay watermark phải đi cùng state tương ứng, tránh duplicate after reboot.

### B4. Test matrix tối thiểu

Nạp bank có nhiều weight dương/âm khác nhau và pending có high-ID, phi không đồng nhất. Persist → clear toàn live bank/pending/cache → reload bằng AXI → compare32 weights/full IDs/model version/checksum + score/heldout behavior.

Inject fail sau từng header/payload/marker beat, AW/W độc lập stalls, bad BRESP, early/late RLAST, wrong ID, truncated payload, old schema, bad checksum, duplicate reward trước/sau reset. Old bank phải còn valid hoặc trạng thái explicit failure; tuyệt đối không half-commit.

Tách persistence transfer test khỏi mathematical SGD oracle. TB ghi weight để dựng baseline unit được phép nếu ghi rõ; final integrated restore không có TB write/hierarchy force.

## C. AXI owner/arbiter: đừng sửa deadlock bằng nuốt response

### C1. Contract đơn giản hóa có kiểm soát

Bắt đầu một outstanding read và một write transaction nếu chưa chứng minh nhiều outstanding; throughput thấp hơn nhưng audit dễ. Client giữ owner từ lúc request accepted tới last response consumed. Owner lifetime không phụ thuộc req còn high. Giữ r4 fix và response skid buffer đã có; không rewrite tất cả.

Channel rules: VALID/payload ổn định khi READY=0; handshake=VALID&&READY; đếm outstanding từ handshake thật. AW/W có thể đến khác lúc; B chỉ giải phóng write owner khi consumed. READ owner kết thúc RLAST consumed, không khi ARVALID hạ. Mang RESP/ID/last qua mọi adapter; không hardwire OKAY để client tests đẹp.

Một response buffer phải tách accept-from-MIG và consume-by-client. Không double-count khi replace buffer cùng chu kỳ consume. Assert data conserved: accepted upstream response = delivered client response + explicitly quarantined protocol-error response, không mất im lặng.

### C2. Timeout đúng nghĩa

AR chưa handshake: protocol đang giữ VALID thì không rút transaction tùy ý trừ reset/cancellation contract của interface. Sau AR handshake: timeout là tình trạng outstanding chưa hết, không giấy phép cấp lại same RID rồi nhận stale beat như request mới.

Chọn một trong các policy được freeze: drain outstanding trước retry; quarantine poisoned RID đến reset/late completion; hoặc reset channel/subsystem có tác động được kiểm. Không chỉ “timeout rồi S_IDLE”. Late R qua query boundary là test bắt buộc, không chỉ delay20 < timeout64.

### C3. Test trước MIG full simulation

Adversarial slave nhỏ có scheduling độc lập ARREADY/RVALID/AWREADY/WREADY/BVALID và configurable error. Check arbitration scoreboard, outstanding counters, no-overlap/deadlock bounds. Sau khi invariant pass, chạy selected same tests qua official MIG simulation; không chạy MIG hàng giờ để debug lỗi owner combinational có thể bắt trong vài chu kỳ.

Giữ actual MIG/IP/XDC provenance; không sửa vendor model để test pass. Nếu physical simulation/tool crash, phân loại tool failure riêng với protocol failure.

## D. C3: thiết kế transfer có ý nghĩa

Task phải có>=2 admissible proofs; validity không trực tiếp cho biết preferred action. Reward học preference nguồn/context/độ tin cậy có thể khái quát qua entities. Không dùng entity ID, winner class, proof index hoặc gold-derived confidence.

Baseline bắt buộc: A trained shared, B frozen, C shuffled feedback, D per-ID với cùng feedback budget; thêm fixed-validity/fixed-confidence. Tất cả dùng cùng heldout worlds và tie-break độc lập labels. Nếu D được full-information thì báo là diagnostic upper-bound, không cùng protocol.

Mỗi seed = fresh bank/init + độc lập train stream/world generation; ID permutation trên cùng trained bank không phải seed mới. Freeze dev/confirm trước tuning. Chạy≥5 seeds với đủ query phủ class; báo gain A-B≥10pp và CI paired lower>0 theo unit độc lập đã đăng ký. Không bootstrap từng query như independent nếu cùng world/episode gây correlation.

Measure PRE/POST/RELOAD trên cùng heldout set. Phần tử nhớ trong DDR là toàn bank/pending, không C2 w0 + TB restore31weights. Tách accuracy, answer coverage, selective accuracy, unknown/conflict/incomplete rates và latency/traffic. Giá trị +100pp trên confidence toy là diagnostic, không mặc định final quality.

Nếu A không thắng fixed-confidence: reward dataset chưa cần learner hoặc feature không phân giải preference. Nếu A thắng train không thắng hold: leakage/overfit/feature missing. Nếu A/B cùng pass100%: benchmark không chứng minh improvement; không sửa gold để làm B thua.

## E. C5/C6: hội tụ trước route cuối

### E1. Một hierarchy thật

Chọn một candidate integration root với API ổn định; phụ thuộc C1,C3,production state,C4. Không ép mọi source thành một file. Reuse modules bằng exact hash; named revisions chỉ khi thay law/behavior. Test-only weight-load/plant/debug route phải disabled bằng final config và kiểm netlist reachability.

UART protocol có query/reward/flush/reload/status rõ. CLK_HZ lấy từ domain thực, BAUD115200 final; fast sim override không được leak final. FIFO token output có backpressure, gửi đủ sequence, không last-token-only. Parser token null/EOL có escaping/length rule rõ.

### E2. Source-to-bit receipt

Pin source commit + RTL/includes/generated inputs + tool/IP version + constraints + top parameters + corpus/index/model/dict/state image hashes. Kiểm tất cả path tồn tại, độc lập workspace/cache. Không sạch cây bằng git clean/reset; stage/commit đúng file đã review theo permission của repo, giữ user changes khác. Dirty source archive có thể là staging receipt, không mạo nhận exact final commit.

Sau C5 pass, một whole-chip build. Kiểm netlist block/state/RAM thực sự tồn tại và nối output; DONT_TOUCH chỉ giữ cell không chứng minh behavioral reachability. Check resources, WNS/TNS/WHS/THS, unrouted/DRC, CDC, clock-domain and UART exception rationale. Artifact models/images khác nhau không gộp PASS.

Chỉ rebuild rộng khi source/config/model liên quan thay đổi hoặc unresolved physical issue. Không lặp wrapper route/LED/button inventory như milestones AI. C6_PREBOARD_READY trước C7; final board claim chỉ sau authorized one-bit/one-image blind exam.

## F. Cursor tự chủ: quy tắc ra quyết định

Trước mỗi task trả lời bằng một trang: observed failure, source-to-effect chain, hai hypothesis tối đa, test phân biệt, minimal change, invariants, expected artifact. Sau đó tự triển khai trong scope đã giao, không hỏi từng dòng.

Nếu một invariant fail: lưu first divergence, chọn corrective nhỏ nhất. Sau hai fail cùng nguyên nhân: dừng broad rerun, làm isolating experiment và báo causal chain. Không sửa scope/oracle âm thầm. Nếu tài liệu cũ mâu thuẫn Master: ghi conflict với exact clause, làm phần độc lập được phép, chưa tự close claim.

Definition of done mỗi task: ACK ownership, frozen contract/data, raw commands/exits, source diffs/hashes, positive/negative/control tests, measured limit, no unexplained expected mismatch, independent review. Marker không tự là verdict. Cursor được chọn implementation; acceptance contract và historical truth không được tùy biến.

Khi Codex hết usage: tiếp tục local work theo các WO đã giao và scope này; Antigravity review độc lập; Grok một parent giữ queue. Không lấy việc Codex vắng làm quyền tự đổi Master, program bit mới hoặc bỏ benchmark khó. Nếu chưa có độc lập acceptor, trạng thái là REVIEW_PENDING, không tự PASS.
