# Prompt tiếp theo cho Cursor

Đọc DEEP_REVIEW_LATEST.md cùng thư mục và MASTER_CLOSURE_PLAN.md. Refresh live source/hash/work ownership. Giữ mọi corrective đã PASS ở named modules; không patch KEEP hoặc old bags. PROGRAM=NO, không JTAG/COM12/bit build trong hai task này. Grok một parent; Cursor implement; independent auditor quyết định scope acceptance.

## Task A — ASTRA-C5-CHECKPOINT-LIFETIME-ATOMIC-01

Unknown: restore chỉ nhận snapshot có marker đúng phiên ghi, allocator không tái dùng reward identity và consumer không nhìn thấy partial install.

Tạo revision riêng của ckpt_pend/pendld. Trước code, đưa state schema diagram: full32weights, full pending phi/proofs/prediction/session/model/generation/txn, allocator watermark, sequence/CRC/commit marker. Latch metadata khi capture. Không sửa C2 KEEP.

Falsifiers bắt buộc trước PASS:
- A valid persisted; ghi B tới payload cuối, không ghi marker B, reset: không install B với marker A; A còn recoverable theo policy.
- marker/header sequence hoặc CRC mismatch; epoch/schema mismatch; wrong RID/BID; non-last single-beat response; AW/W/B/R stalls/timeouts không false PERSISTED.
- Restore pending key1/1, retire, tạo pending mới, gửi delayed old reward: no update. Fresh key vẫn update exact32.
- Query/reward chen trong sequential load: bị refuse/stall rõ, không dùng mixed bank/phi.
- Commit/install marker sát reset: không half bank, không duplicate reward. Compare full snapshot, không chỉ w0.

Sau unit pass mới nối vào canonical resp+stream+explicit reward candidate cùng C3 pendld. Regress transport errors và pin UART; chọn một top cho integration, không tạo thêm sibling chỉ để tick marker. Sau đó official MIG same tests; không gọi modeled AXI là MIG.

## Task B — ASTRA-C4-NUMERIC-PARITY-AND-FRESH-CONFIRM-01

Unknown: một deployed fixed-point model có tái hiện đúng candidate float đã chọn, trước khi tiếp tục tìm model/language quality không?

Không thêm model variants ngay. Pin checkpoint và forward graph được chọn theo DEV; hose/drum/vent/bolt20case hiện là DEV vì đã dùng chọn best snapshot. Không đổi old reports/gold, chỉ ghi correction scope. Tách fresh confirm disjoint chưa dùng tuning và không xem mỗi epoch.

Viết tensor scale contract (weights/activations/accumulator/residual/attention/logit); loại q8=round không scale và arbitrary /16 nếu không có derivation. Giữ attention1/sqrt(D), same opcode-gating rule trong reference/deployment. Mỗi layer log float versus fixed MSE/saturation/zero fraction/logit margin/first wrong token. Argmax parity trên dev là numerical milestone, không C4 language PASS.

Nếu PTQ fail, một QAT corrective đúng deployment graph; có thể giữ int16 activation/state để bảo toàn precision và đo area/latency trước giảm tiếp. Không mặc định int8 là yêu cầu bất biến. Check actual integer softmax/LUT approximation, không để numpy floating softmax trong FPGA oracle mà gọi bit-exact.

Sau numeric parity, kiểm một checkpoint duy nhất cho grounded>=90%, unsupported-safe>=95%, hallucination<=5%, EOS/MAX100% trên fresh prereg set đủ class và mẫu số. Status/proof gate có thể refuse theo semantics đã khai báo; learned ANSWER phải phụ thuộc context/prefix/weights, không literal answer lookup. Normal/zero/corrupt weights + removed/replaced evidence + prefix intervention; host không chọn token/answer.

Kết thúc mỗi task: raw commands/exit, immutable input/model/source/hex hashes, first divergence, exact gate pass và open items. Không tự C4/C5/C6_MASTER PASS. Không chạy broad route trước canonical integrated quality/state readiness. Nếu Codex không có mặt, independent auditor review rồi Grok chọn đúng next dependency; không self_accept.
