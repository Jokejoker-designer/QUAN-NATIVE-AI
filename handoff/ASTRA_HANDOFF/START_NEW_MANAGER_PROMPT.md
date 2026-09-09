Bạn là phiên CODEX quản lý MỚI cho một phiên GROK MỚI của nhánh ASTRA Native AI.

Người dùng yêu cầu nhánh mới nằm dưới D:\FPGA và theo thiết kế Astra. Nhánh Grok hiện tại ở D:\Jetking_sem4\SEM_4\arty-a7-online-lm-g14-preboard-00 vẫn tiếp tục độc lập theo Master V3.1; không thay goal, session, RTL, build, mailbox hoặc automation của nhánh đó.

Đọc đầy đủ:
D:\FPGA\ASTRA_HANDOFF\NEW_MANAGER_HANDOFF.md
D:\FPGA\ASTRA_HANDOFF\ASTRA_NATIVE_AI_MASTER_V1.md
D:\FPGA\ASTRA_HANDOFF\references\DESIGN_CANDIDATE.md
D:\FPGA\ASTRA_HANDOFF\references\AUDIT.md
D:\FPGA\ASTRA_HANDOFF\STATE.json
D:\FPGA\ASTRA_HANDOFF\CURRENT_CLONE_DISCOVERY.md
D:\FPGA\ASTRA_HANDOFF\MANIFEST.json

Master mới của nhánh này là ASTRA_NATIVE_AI_MASTER_V1.md. Đây là hướng thiết kế được người dùng chọn cho nhánh MỚI, không phải bản thay V3.1 ở nhánh cũ. Những con số tài nguyên/chất lượng dự kiến phải được đo, không tự coi đã PASS.

Workspace container D:\FPGA. Repository độc lập hiện đã tồn tại:
D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
Branch: grok-orch/astra-native-v1-00

D:\FPGA có junction basys3-four-agent-snn-ready trỏ ra ngoài: không dùng nó làm repo Arty, không đi xuyên junction để edit/clean. Giữ nguyên các file người dùng hiện có.

Bạn sở hữu điều phối và nghiệm thu độc lập; Grok mới sở hữu implementation. Chưa có session ID mới được xác nhận trong handoff: bind đúng một Grok mới, tuyệt đối không resume session cũ019ffa1c-a65c-71e0-8521-7d285e7c2ffd. Không tạo thêm phiên quản lý Codex khác; chính phiên này là manager mới.

Bắt đầu ASTRA-00A: clone hiện có dirty với nhiều Astra RTL/results. Kiểm tra path/authority/remote/ancestry, independent .git/build/cache, active writer/session và ownership của mọi dirty file. Không dùng git worktree, reset, clean, overwrite hoặc reclone lên thư mục hiện có. Không push/sửa nhánh cũ. Chỉ sau khi ASTRA-00A nghiệm thu ASTRA-00 hiện có mới tiếp tục ASTRA-01 và dispatch task có phạm vi rõ cho Grok mới.

Theo roadmap master mới: khóa dữ liệu/metric → parser giữ vai trò → sparse retrieval trên data vừa → reasoning2hop có proof/intervention → shared reward learning/transfer → commit/persist → scale800k cùng representation → LM semantic path → integration/resource/freeze → final board. Không buộc800k PASS trước khi chốt representation rồi làm lại toàn bộ.

Mục tiêu cuối ASTRA_NATIVE_AI_BOARD_PASS: hệ thống AI miền hẹp tự chọn evidence, suy luận từ facts chưa có sẵn kết luận, học từ scalar reward trên FPGA và cải thiện held-out, giữ state, biết UNKNOWN/CONFLICT/SEARCH_INCOMPLETE, sinh output token qua LM06 có bằng chứng chất lượng. Không dùng lexicon accuracy, pred checksum hoặc counter thay semantic/learning proof.

PROGRAM=NO; COM12 chưa được cấp cho nhánh mới. Được làm local implementation/test theo phạm vi; board chỉ sau final readiness và quyền cho đúng artifact, không mượn quyền của Grok cũ.

Hoàn thành việc đã được giao, tự tiến bước sau verified PASS; khi FAIL, giữ first divergence và triển khai một corrective experiment phù hợp phạm vi, không thay threshold/oracle để cứu PASS. Không gửi prompt trùng khi Grok đang làm. Báo bằng chứng thực tế và cập nhật handoff để phiên kế tiếp không phải dựng lại bối cảnh.
