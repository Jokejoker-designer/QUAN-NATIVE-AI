# Nghiệm thu độc lập Astra — 2026-09-05

## Kết luận

ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION.

Grok đi đúng hướng ở các prototype parser giữ vai trò, sparse AXI có overflow, suy luận hai bước có proof/intervention, và số học SGD dùng chung. Nhưng đường tích hợp hiện tại chưa thực hiện kiến trúc sản phẩm của ASTRA_NATIVE_AI_MASTER_V1.md. Tiếp tục coi ASTRA-11/12 là final co-fit/freeze sẽ đi sai hướng. Giữ nguyên các kết quả unit có giá trị; không làm lại toàn bộ.

Repo: D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH. HEAD 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1, branch grok-orch/astra-native-v1-00; có source chưa commit. Hash các nguồn được review nằm trong reviewed-source-hashes.json. Manager: 01a0723e-f20c-7270-983e-6aca89596308. Không thay RTL, loop, scheduler, session, board hay nhánh V3.1.

## Phạm vi nghiệm thu

Đây là review source, raw log đã lưu, report route và thí nghiệm HOST_MODEL mới; không phải rerun XSim/Vivado hay board exam. Các số XSim dưới đây là bằng chứng lưu trữ, không phải chạy mới. Chưa chứng nhận toàn bộ prereg chronology, từng writer/session, mọi ignored cache hay toàn bộ gate. ASTRA-00A takeover vẫn cần đóng ownership/session/isolation trước dispatch.

Kiểm tra 15/15 entry ASTRA-12B khớp source hiện tại. Đây là integrity của danh sách đó; không phải full-chip freeze: wrapper SoC, SRAM và run_impl không nằm trong 15 entry. Sáu authority copy cũ đã khớp nguồn gốc; khác gói handoff mới không có nghĩa corrupt.

## Thành quả được giữ

| Theo tên gate cũ | Nghiệm thu có giới hạn |
|---|---|
| 01 sparse AXI | Raw log có PASS, query tạo key/valid và AXI directory/posting. Behavioral memory, chưa DDR silicon. |
| 02 scale/overflow | Giữ overflow XSim và host workload hẹp. Không chuyển thành same-law role-aware 800k: thí nghiệm này dùng v1 trước v2. |
| 03 role parser | Raw log 21 query và 7 reverse pairs khác subject/object/key; giữ PASS_NARROW supported grammar. |
| 04/05 reasoner | Raw log có suy luận hai edge; xóa/đổi/đảo edge thay kết quả, cap trả incomplete trong unit. Giữ PASS_NARROW bảng edge nhỏ. |
| 06 SGD | RTL có MAC/update 32 weight; raw log unit PASS. Không chứng minh end-to-end reward learning. |
| 07 transfer | Tái lập host 5 seed đúng số báo cáo. XSim fixture một seed kiểm số học từ feature host cấp; cần hạ claim về toy feature-family transfer. |
| 09 glue | Raw log có role parse + walker + bảng facts nạp riêng + proof bytes. Chấp nhận smoke integration; chưa unified evidence pipeline. |
| 10/10B | Giữ OOC utilization-only; không bao gồm LM06/MIG và không chứng minh final fit. |
| 11 SoC mới | Có route/report/bit chưa program; timing FAIL và thiếu datapath sản phẩm. Không nghiệm thu final co-fit. |

## Finding trọng yếu

### F1 — Retrieved evidence chưa quyết định proof (RTL_FACT, P1)

rtl/native_graph/integrate/a7ng_astra09_pipe.sv:108-109,139,210-225: cand_id/cand_v chỉ nhận output walker, không fetch descriptor hay điều khiển load của engine. Engine lấy load_s/r/o/eid từ cổng riêng. S_WALK chỉ đợi done rồi chạy bảng facts nạp độc lập. Khi thay posting IDs nhưng giữ facts riêng, source không có đường cho các ID đó thay proof. Counter AXI tăng không chứng minh lựa chọn evidence.

qse_neg, qse_amb và w_ovf cũng không được dùng để quyết định status; context không có trong bảng edge của engine. Vì vậy unit xử lý cap/conflict không tự chuyển thành uncertainty/context correctness trong integrate. Cần thí nghiệm intervention ở chính directory/posting/descriptor, không chỉ xóa bảng facts riêng.

### F2 — Learner không học hoặc chọn đường trong integrate (RTL_FACT, P1)

Pipe:236 nối go_upd_i=0 và reward=0; wrapper:88 còn freeze=1. FSM lấy đáp án ở S_QWAIT rồi mới S_SCORE_GO; score không được dùng để chọn frontier/path. Không có pending txn/reward/commit/reload trong interface này. Phi integrate cũng khác schema phi của host_astra07. Unit SGD không đóng yêu cầu online learning/persistence của Master V1.

### F3 — Bộ transfer chưa phân biệt học với proof legality có sẵn (HOST_MODEL + TB_FACT, P1)

Audit chạy lại make_worlds, train_enabled, train_shuffled và eval_class bằng Python -B, không gọi main sinh lại bag. Enabled đạt 24/24 mỗi seed; frozen 0,2,5,6,6; shuffled 0 mỗi seed — khớp báo cáo.

Counter-control không học, chỉ argmax(x[31]), đạt 24/24 trên cả 5 seed (120/120). host_astra07.py:322 trở đi bắt buộc đúng một complete_proof và nó luôn là gold. Đây không phải bằng chứng gian lận: proof validity là feature hợp lệ; nhưng benchmark quá dễ để chứng minh learned preference giữa nhiều proof hợp lệ. Quy tắc không học cũng giải được toàn bộ.

tb_astra07_hold.sv:163-175 gán n_ans=0 rồi in ra; không quan sát output ANSWER từ reasoner. Kết quả miss ANSWER=0 ở đây không chứng minh FPGA uncertainty. host_astra07.py:686-687 tính retention_drop từ best training epoch so với final train accuracy, không reset/flush/reload held-out. Không nghiệm thu persistence/retention từ con số này.

### F4 — LM06 chưa được nối vào Astra SoC (RTL_FACT, P1)

a7ng_evidence_compose.sv chỉ serialize entity/intent và ba word 32-bit thành 14 byte. lm_path_active_o là st != S_IDLE; không instantiate Transformer hoặc đọc weight/checkpoint. run_impl.tcl liệt kê source không có tiny_gpt803k_core; wrapper còn bỏ output token của composer và phát frame proof/status riêng. Nhãn LM06_ACTIVE_BUT_LANGUAGE_UNPROVEN chỉ có thể nói về asset lịch sử, không mô tả sự hiện diện LM06 trong SoC này. Phải ghi LM06_NOT_INTEGRATED cho đường hiện tại.

### F5 — SoC hiện tại là kho rỗng và timing không đạt (RTL_FACT + POST_ROUTE, P1)

wrapper:92 nối load_v=0. Reasoner reset mọi ev=0 và không có đường nạp khác. SRAM khởi tạo toàn zero; wrapper khóa AWVALID/WVALID=0. Do đó sau reset hợp lệ, không có facts để tạo ANSWER. Có thể dùng làm scaffold UART/physical preflight; không đủ capability exam.

SRAM 256 x 128 chỉ 4096 byte, word_of cắt địa chỉ xuống 8-bit index và trả OKAY, không đủ geometry 4 x 4096 directory. Đây là địa chỉ alias của scaffold, không thay được DDR store. Report còn cho BRAM=0; không thể dùng số tài nguyên nhỏ để hứa final fit.

timing.rpt:141: WNS=-4.765 ns, TNS=-2392.529 ns, 587 failing endpoints; WHS=+0.046, THS=0. Route có 2776 fully routed nets và 0 routing errors. Util: LUT=2956, FF=1550, BRAM=0, DSP=2. DRC có 9 warning pipeline DSP; timing report còn 2 input/4 output thiếu delay cần phân loại/review. Route complete không phải timing PASS.

run_impl.tcl vẫn write_bitstream khi first_div rỗng, không fail gate theo WNS/TNS. BITSTREAM.txt ghi UNPROGRAMMED. Không có bằng chứng program trong review này. Bit tồn tại không được coi preprogram-ready.

## Hướng tiếp tục

Giữ các source/log/freeze lịch sử. Sửa trạng thái điều phối theo Master V1, map gate theo năng lực thay vì số thứ tự. Không tiến final board từ wrapper hiện tại.

Một corrective experiment ưu tiên: RETRIEVAL_TO_PROOF_CAUSALITY. Sau takeover/session closure, nối candidate ID → fetch full-ID descriptor → facts/frontier → proof. Giữ cùng query, can thiệp posting/descriptor của edge quyết định phải thay proof hoặc UNKNOWN/SEARCH_INCOMPLETE; không được có bảng edge do TB nạp độc lập làm authority. Đăng ký cases/oracle trước run, giữ fail cũ, output trong bag mới. Chưa dispatch trong audit này.

Tiếp theo mới nối ranker trước lựa chọn, pending reward/commit/reload với feature schema thống nhất và >=2 proof hợp lệ cạnh tranh; kiểm lại held-out với fixed-proof control. Audit checkpoint/vocab ngay, tích hợp LM06 về sau theo Master; whole-chip synth/route cuối phải chứa các chức năng ấy. Timing correction của scaffold không tự đóng các thiếu hụt kiến trúc.

PROGRAM=NO. Verdict không bác bỏ unit progress, nhưng bác bỏ diễn giải rằng nhiều PASS_NARROW cộng lại đã gần thành final Astra.

## Cập nhật cuối khi kiểm tra drift

Các source/report trong reviewed-source-hashes.json không đổi trong thời gian review; riêng LOOP_STATE.json được writer khác cập nhật. Bản đọc cuối đã ghi astra11=TIMING_FAIL, astra11_wrap=PASS_NARROW, next=ASTRA11_TIMING_FIX và worker 01a0724d-a6b5-73b0-bd98-a15b9faf3507. Đây là sửa phân loại timing đúng hướng; không nên nói Grok đang tuyên bố timing PASS. Chưa kiểm chứng worker đã chạy hay đã sửa RTL. Các thiếu hụt retrieval/proof, reward, LM và dữ liệu rỗng vẫn còn. Manager không gửi task trùng hoặc can thiệp writer trong audit này.
