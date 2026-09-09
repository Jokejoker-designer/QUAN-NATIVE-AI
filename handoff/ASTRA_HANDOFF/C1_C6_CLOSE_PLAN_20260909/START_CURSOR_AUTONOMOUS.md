# Prompt bàn giao tự chủ cho Cursor

Bạn là implementer Native AI trên D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH. Target Arty A7-100T xc7a100tcsg324-1, Vivado2026.1. Grok giữ một parent dispatcher; Antigravity auditor độc lập; Codex cung cấp kế hoạch và nghiệm thu khi có mặt. Không tạo thêm parent. PROGRAM=NO cho task hiện tại; không kế thừa quyền checkpoint e51bdca2 cho bit khác.

Đọc đầy đủ bộ kế hoạch:
- D:/FPGA/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/MASTER_CLOSURE_PLAN.md
- D:/FPGA/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/CURSOR_WORK_ORDERS.md
- D:/FPGA/ASTRA_HANDOFF/C1_C6_CLOSE_PLAN_20260909/TECHNICAL_PLAYBOOKS.md

Đối chiếu Master V1.1, trạng thái live và hash trước hành động; báo nếu source đã thay đổi và finding cũ không còn đúng. Không implement theo snapshot lỗi thời. Giữ18KEEP, các bag đã freeze, vendor MIG và old V3.1; không edit audit tree Antigravity. Không reset/clean/reclone hoặc ghi đè evidence. Không hỏi lại cho local work đã giao.

Ưu tiên: WO00 reconcile contract → WO01A explicit reward → WO01B checkpoint toàn state. C4 feasibility WO02 có thể song song bằng worker với write scope khác, sau khi parent cấp owner; chỉ một heavy build cùng lúc. WO03/04/05/06 theo dependencies ghi rõ. Không tự mở các gates khác hoặc gọi scope hẹp là Master close.

Trước triển khai mỗi WO, ghi ACK và một trang: lỗi quan sát, source causal chain, phương án chọn/đánh đổi, test falsifier, file ownership, prereg/expected và giới hạn. Sau đó tự thực hiện, không chờ Codex chỉ từng dòng. Nếu current worker đã sở hữu task, không tạo duplicate.

Chặn các shortcut:
1. Không tự thưởng+3 cho inference. Reward packet explicit và exact pending key.
2. Persist bank SGD32 thật, không accumulator C2 riêng; restore bằng production bus vào same bank.
3. C4 không đóng bằng class-ID20/20 hoặc head không dùng prefix. Compact learned model được thử, không ép802k và không tự phê duyệt bỏ LM requirement.
4. UART gửi toàn sequence; final clock/baud thật; AXI không fabricate OKAY hoặc mất outstanding khi owner đổi.
5. C3≥5 train seeds thật + baselines + CI + full-bank reload; C6 chỉ build cuối sau canonical C5 đạt.

Mỗi fail giữ source/log/oracle, first divergence và tối đa một corrective đúng giả thuyết trong revision riêng. Không thay threshold/gold để pass. Trước kết thúc đưa actual evidence và yêu cầu auditor độc lập, self_accept=false. Nếu chưa có acceptor thì REVIEW_PENDING. Không nạp board, không tự đổi C4_MASTER/FULL_BOARD_PASS. Các quyết định product-scope cần đề xuất có evidence, không lấy tên module làm authority.
