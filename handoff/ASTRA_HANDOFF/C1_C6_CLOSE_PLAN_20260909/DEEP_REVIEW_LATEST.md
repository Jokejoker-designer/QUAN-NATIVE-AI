# Nghiệm thu sâu cập nhật Cursor — 09/09/2026, snapshot sau các bag buổi trưa

## Verdict

ACCEPT_PARTIAL_PROGRESS / REJECT_FULL_CLOSURE. Cursor đã làm đúng nhiều corrective trong module mới; không yêu cầu làm lại chúng. Tuy nhiên các module mới chưa hội tụ vào final production top, C4 vẫn chưa có learned integer language candidate đạt chuẩn và persist còn lỗ hổng integrity/lifetime.

Phạm vi: read-only RTL/TB/raw-log/manifest review, phân tích checkpoint numpy; không rerun XSim/route/training và không program. LOOP_STATE vẫn snapshot07:07, DONE/HARD_BLOCK; file mới hơn nằm ngoài trạng thái đó. Không dùng LOOP_STATE để kết luận Cursor idle hoặc không tiến bộ.

## Thành quả giữ nguyên

| Bag | Raw evidence được kiểm | Live manifest |
|---|---|---|
| C5-UART-STREAM-04A | Pin decode4 bytes+EOL, query liên tiếp, no FIFO overflow; đây là class-token stream transport |28/28 MATCH|
| C5-AXI-ERRORS-04B | SLVERR đưa tới fail, no restore install; OKAY reload exact32;46 reads/7writes counted |31/31 MATCH|
| C5-PEND-PROOF-PHI-01 | Exact32weights+phi/high-ID proof, corrupt payload/schema/BRESP rejected |13/13 MATCH|
| C3-PEND-LOAD-01 | Pending/phi được nạp vào named C3 và HOLD visible |22/22 MATCH|

Đây là stored XSim observations. Không chuyển những PASS riêng thành C5/C6 full closure hoặc MIG verification của module mới. Old production top/old C6 bit không tự có các sửa đổi trong named siblings.

## F1 — Checkpoint marker chưa bind đúng snapshot (P1, RTL_FACT)

`a7ng_astra_c5_sgd32_ckpt_pend.sv`: pack_hdr và pack_mark chứa sequence/CRC; reload header lưu crc_rd nhưng không lưu/so sequence hoặc epoch. Final beat chỉ kiểm magic và bit127; bỏ qua marker sequence/CRC. Do đó ghi header+payload mới xong, reset trước marker mới có thể chấp nhận marker cũ vẫn valid. Payload CRC khớp header không chứng minh final commit marker của lần ghi đó đã thành công.

Source cũng ghi đè cùng vùng BASE; failed replacement có thể làm mất snapshot trước dù trước đó đã PERSISTED. Chưa có A/B slot recovery. S_B không kiểm BID, S_R không kiểm RID. S_R chỉ xử lý rvalid&&rlast trong khi RREADY=1, nên malformed non-last beat đã handshake cần được phân loại lỗi ngay, không chờ timeout như không có data.

Fix candidate: header seq/epoch/schema/length + payload CRC + marker seq/CRC phải đồng nhất; snapshot alternate slot hoặc policy old-state loss explicit. Latch metadata tại CAPTURE; không đọc live_epoch bus khi pack/header về sau. Restore highest valid committed sequence với wrap policy. Chỉ atomic-install sau toàn payload/metadata verified và backend/consumer handshake. Tests reset từng beat, old marker/new payload, header epoch flip, BID/RID mismatch, missing RLAST, A valid/B interrupted.

## F2 — Pending restored nhưng allocator chưa restored (P1, RTL_FACT)

`a7ng_astra_c3_held_out_pendld.sv` S_IDLE pend_load copies pend_txn/pend_gen nhưng không cập nhật txn/gen allocator. Source reset allocator0; PICK tiếp theo dùng bộ đếm đó. Restore pending1/1 → retire → query mới có thể phát lại1/1, cho phép delayed reward cũ trùng key. Test hiện tại kết thúc sau exact reload/HOLD nên chưa chứng minh lifecycle.

Checkpoint interface còn thiếu saved prediction/model version/session identity đầy đủ. Bộ32weights/phi đã đúng là tiến bộ; bổ sung state contract để không gọi partial struct là full pending. Fix restore allocator high-water mark/session epoch hoặc prevent new issue đến khi new session handshake. Không chỉ thêm byte gen cùng tăng với txn.

C3 load ports nhận dần32weights rồi32phi; tok_ready/issue phải bị khóa bởi install transaction. Không để query chen giữa partial install. Test query/reward trong reload, restored pending reward rồi query mới, replay old key, reset/wrap.

## F3 — Int8 thử nghiệm không tương đương float model (P1, ALGORITHM_FACT)

`train_float.py:q8` chỉ clip(round(a),-127,127); decode_i tự chia các matmul16, bỏ scaling1/sqrt(D) của float attention dots, vẫn dùng numpy float softmax. Đây chưa phải một quantization contract tái hiện float và cũng không phải integer-only FPGA oracle.

Đo read-only `snap_best.npz`: We66.14%, Wq87.01%, Wk86.72%, Wv94.24%, W1 97.56%, W2 99.46% phần tử thành0 với q8 đó. Đây là mất precision rõ, không tự chứng minh nguyên nhân duy nhất của0/20. Cần layer-by-layer first divergence trước thêm capacity/train variants.

Giải pháp: signed fixed-point tensor scales, accumulators đủ rộng, explicit requantization per op; preserve attention scale, residual scale alignment, activation quantization. Bắt đầu mixed precision/int16 activations nếu cần; đo footprint rồi giảm. Zero rate/saturation/MSE/logit margin/token mismatch theo layer. Nếu calibration không đủ, QAT/fake-quant đúng deployment graph trên TRAIN/DEV. Không model-size escalation tiếp trước khi numerical path có nghĩa.

## F4 — Held-out đang là dev-set (P1, EVIDENCE_FACT)

`train_float_best.py:75–77` chọn snapshot theo held_g accuracy; `train_gated.py` cũng chọn best theo held F/R. Hose/drum/vent/bolt được dùng lặp lại để fine-tune, gating, branch selection. Không phải gradient trực tiếp trên test label nhưng vẫn là model-selection leakage: mọi20/20 ở đó chỉ DEV result. Giữ lịch sử, không đổi nhãn quá khứ thành blind PASS. Freeze new disjoint confirm set một lần sau chọn model; không xem từng epoch.

`decode_gated` chọn attention bank bằng ctx[:1]=='R'. Nếu opcode là public frozen parser output, có thể là architectural prior hợp lệ; phải triển khai cùng gate trong FPGA và không gọi learned routing. Nhánh evid=False trả literal 'no' trong reference không chứng minh model tự sinh safe response. Tests cần phân biệt external proof/status safety policy được khai báo với learned sentence generation. Không blanket bác bỏ mọi safety gate như glue; không dùng safety gate thay toàn ANSWER path.

## F5 — Training đang biến thành search không có exit rule

Nhiều best/aux/rup/film/pcgrad/gated variants chạy trên cùng20mẫu, float copy và unrelated safe chưa cùng đạt ở một deployed checkpoint. Đây là bottleneck experiment design/numeric parity, không thêm một dòng marker. Chọn một best-dev architecture, pin nó, isolate precision và grounded/safe losses. Chỉ mở rival khác nếu có measured falsifier cho architecture hiện tại.

## Hướng đóng tổng thể

Hai đường làm việc độc lập, không trùng writer:
1. State/integration: sửa F1/F2 trong revision mới → nối pendld+ckpt_pend+resp+stream+explicit reward thành một canonical candidate → same-hierarchy full32state/error/UART regression → official MIG selected tests.
2. Language: relabel exposed20mẫu DEV → numerical parity checkpoint/layers → QAT nếu cần → frozen fresh confirm, proof-grounded and safe metrics, actual FPGA prefix/evidence/weight ablations.

Không cần đợi language để kiểm state path, nhưng C5_MASTER/C6 final chỉ đóng khi cả hai đã đạt. C1/C3 image/quality regressions chạy trên candidate hội tụ; freeze schema/bounds từ dữ liệu thật. C6 cũ chỉ baseline; final rebuild sau source/model/images pinned và no simulation override.

Board cắm không thay điều kiện. Không program bit mới ở review này. Một final accepted bit mới + exact corpus/index/model + authorized physical identity mới đi C7 blind exam. Final goal không được hạ thành reasoner-only; có thể công bố reasoner-only riêng như hiện tại, không gộp claim.

Next prompt: CURSOR_NEXT_STATE_AND_NUMERIC_PARITY.md. Không gửi vào Cursor/Grok trong review này; không sửa live loop, source, old bags hoặc independent Antigravity tree.
