# ASTRA-F2R-R3-TXN-LIFETIME-RESET

Bạn là Grok implementer tại D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH, Arty A7-100T xc7a100tcsg324-1, Vivado2026.1. PROGRAM=NO: không COM12/JTAG/bitstream/board.

Đọc Master D:/FPGA/ASTRA_HANDOFF/ASTRA_NATIVE_AI_MASTER_V1.md và nghiệm thu D:/FPGA/ASTRA_HANDOFF/INDEPENDENT_ACCEPTANCE_20260905/F2R2_ACCEPTANCE.md. Giữ PASS_NARROW F2R-R2 về selected-pending/handshake/symmetric law. Không làm lại các unit đó hoặc sửa source/bag cũ.

Một mục tiêu: reward của transaction cũ không thể tác động transaction mới sau retire, reset hoặc counter wrap; reset giữa update không tạo false commit/partial state được công nhận.

ACK task/session/cwd/base/write ownership, kiểm tra không có writer khác. Tạo bag mới results/A7-NATIVE-GRAPH/ASTRA-F2R-R3-TXN-LIFETIME-RESET/ và candidate source tên riêng. Không reset/clean/reclone, sửa nhánh cũ hoặc scheduler. Không tạo subagent/task trùng.

Trước code/run, freeze contract identity lifetime và oracle. Hiện gen và txn cùng tăng8-bit, cùng reset0: không coi đó là chống replay sau reset/wrap. Chọn cơ chế fail-closed có thể kiểm: counter không tái sử dụng trong session; từ chối khi sắp wrap; reset yêu cầu session/epoch mới và flush kênh theo protocol rõ ràng. Nếu dùng host session nonce, chỉ là metadata transport, không semantic cue; chỉ rõ điều kiện uniqueness và trust. Không hứa chống replay xuyên mất nguồn khi chưa có state/protocol hỗ trợ. Tăng width đơn thuần không thay được contract reset.

Test prereg bắt buộc:
1. Giữ reward A, retire A, tạo B, gửi A: không update B; gửi reward B đúng: update đúng một lần.
2. Giữ reward A qua reset, tạo query đầu sau reset, replay A: không update; fresh session hoạt động đúng.
3. Boundary/wrap bằng cấu hình test nhỏ hoặc setup kiểm thử được ghi rõ, không force DUT trong exam: không tái nhận cặp ID cũ; exhaustion trả trạng thái rõ.
4. Reset tại handshake, giữa SCORE/UPD và sát done: pending/weight/commit đúng contract, không công bố half-commit. Phân biệt hard reset abort và retire drain.
5. Hai update liên tiếp không reset; duplicate/wrong/stale bị từ chối; kiểm đủ32 weight, saved prediction và phi bằng oracle độc lập từ corpus, không chỉ lấy DUT phi làm expected.
6. Smoke slot0..3/shared-prefix và reward valid1cycle đã đạt vẫn đúng. Giữ hạn chế load-weight port; không host overwrite weight khi pending để tạo PASS.

Sử dụng nguyên luật symmetric đã nghiệm thu. Snapshot/dump-load chỉ được gọi đúng mức, không gọi DDR persistence. Freeze compiled+includes/config/input trước xvlog, hash lại sau run, lưu raw commands/exit/logs/metrics. Fail giữ first divergence; tối đa một corrective revision với nguồn lỗi được lưu, không sửa oracle để cứu PASS.

Chỉ đóng transaction-lifetime/reset trong contract cụ thể. Không đóng F3, object/context/conflict, post-timeout AXI, LM06, SoC/timing hoặc BOARD_PASS. Không build/nạp bit. Xong báo manager nghiệm thu, không tự mở gate khác.
