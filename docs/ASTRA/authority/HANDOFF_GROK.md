# Bàn giao audit và hướng thiết kế — chờ đọc ở điểm dừng an toàn

Mục tiêu tiếp tục là NATIVE_V1_MINI_AI_BOARD_PASS theo Master V3.1. Đề xuất khả năng reasoning/learning trong DESIGN_CANDIDATE.md chưa tự thay thế contract hoặc cho phép program. Gói này do Codex viết ở thư mục audit riêng, không sửa source/build của Grok.

Đọc AUDIT.md, nhất là §2: Codex đã refresh đến d166ca8. Không làm lại R4/R5/R6, không vá lại lỗi low16 đã có schemaV2. Không dùng kết luận e54096f để ghi đè tiến độ mới.

Khi run hiện tại hoàn thành, ưu tiên kiểm tra dependency đúng với bằng chứng mới:

1. Đối chiếu actual raw log của U4-PRE0 và schemaV2; giữ mức unit/geometry, không gọi U4 semantic/full integration PASS.
2. U4A quality tiếp theo phải dùng actual qse keys + valid masks, corpus≥4096 trước scale800k và gold độc lập. Include unrelated, entity-context distractors, role reversal và per-class precision/reduction. R6 water chiller vẫn22/42; scale law không được quay lại k2/k3 từ nid.
3. Freeze selected profile trên tất cả criteria, không chỉ ref profile. Index phải đại diện đầy đủ valid records qua overflow pages; archive candidates/bytes kể cả fetch rồi bỏ/dedup. Tránh dùng cap≥dataset size để chứng minh sparse selectivity.
4. Tích hợp schemaV2 cần version header/migration, AXI address range≥65 logical beats, canonical identity và atomically committed state. Full store case phải phân biệt accepted/failed/committed; C7 không success nếu không ghi.
5. Lập bảng current path: raw token→parser→router→real descriptor→selected pending tuple→reward→state→held-out Top-K→materialized evidence→LM. Đánh dấu fixture map_q/fi_of và start_train=0; không lấy host counters0 để chứng minh numeric token không mang hidden tuple selection.
6. Trước khi thêm phần reasoning đề xuất, xây reference feasibility nhỏ theo DESIGN_CANDIDATE: role-preserving parse, typed2/3hop proof, shared32-feature reward estimator, ablation. Đây là design amendment mới; không sửa frozen numeric oracle tại chỗ.
7. Archive weight-image provenance/vocab/language metrics. LM activity không tự bằng language understanding. Byte ID transport và lexical meaning phải được kiểm độc lập.

Phải báo cái gì đã có trong RTL, cái gì đã XSim, cái gì đã post-route, cái gì đã board. Không merge quyền program từ prompt cũ. Giữ một worktree và không chạm Cursor. Không gửi task trùng khi Grok đang chạy.
