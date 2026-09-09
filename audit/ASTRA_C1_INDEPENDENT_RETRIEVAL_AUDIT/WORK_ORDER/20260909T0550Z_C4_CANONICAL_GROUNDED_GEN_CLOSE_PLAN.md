# KẾ HOẠCH DỨT ĐIỂM ĐÓNG C4 THEO ĐÚNG BLUEPRINT THIẾT KẾ (MASTER C4 CLOSE PLAN)

**Mã tài liệu:** `WO-20260909T0550Z-C4-CANONICAL-CLOSE`  
**Đơn vị ban hành:** Antigravity (Independent Auditor & System Architect)  
**Đối tượng thực thi:** Cursor (Live Clone `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`)  
**Căn cứ pháp lý:** 
1. `D:\FPGA\GROK_ASTRA_NEW_SESSION_MASTER_PROMPT_ISOLATED_V1.md` (§550, §663–686, §978–995)
2. `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\docs\ASTRA\authority\ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md` (§10)
3. Hiện trạng Production Top: `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv` (Line 439 `u_gen`)

---

## I. XÁC LẬP BẢN QUYỀN KIẾN TRÚC C4 (CANONICAL ARCHITECTURE)

### 1. Bác bỏ hoàn toàn ngộ nhận về TinyGPT:
- `tiny_gpt803k_core` (260 BRAM, 802k weights) là **thử nghiệm độc lập của dự án cũ A7-LM**.
- Grok Master Directive §550 đã ra lệnh cấm: **"Do NOT add a large neural network merely to use the word 'AI'."**
- ASTRA Native AI là hệ thống tính toán biên bounded-domain, không phải LLM đàm thoại mở.
- Bag `ASTRA-C4-LM06-802K-GROUNDED-01` đo được `acc=0/2` là minh chứng thực nghiệm để **loại bỏ dứt điểm TinyGPT**, không kéo dài tranh cãi.

### 2. Module chính thức của C4: `a7ng_astra_c4_lm06_grounded_gen`
Module thực tế đang nằm tại trung tâm Production Top (`a7ng_astra_c5_prod_top.sv` dòng 439) chính là:  
👉 `rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv`

**Đặc tính kỹ thuật:**
- Sử dụng **0 BRAM** (chạy bằng Flip-Flop/LUT, khớp 100% với timing WNS=+0.233ns của C6).
- **Logit Fusion**: Tính toán phân phối xác suất trên không gian từ vựng $V=64$ kết hợp trọng số ngôn ngữ (`bias[ti]`) và thưởng bằng chứng (`g_match`).
- **Autoregressive Feedback**: FSM 7 trạng thái sinh từng token, hồi tiếp vào `b_in` cho đến khi gặp `EOS`.
- **Đã có sẵn cơ chế Ablation**: Đã chứng minh phụ thuộc trọng số qua 4 bài test (`w_normal`, `w_zero`, `w_corrupt`, `evid_removed`).

---

## II. ĐIỀU KIỆN CÒN THIẾU ĐỂ ĐÓNG MASTER LETTER §10

Trong bag `ASTRA-C4-LM06-GROUNDED-GEN-01` trước đây, testbench chỉ mới chạy **8 câu hỏi compact**.  
Để đóng Master letter C4 (§10 dòng 697), ta cần:
1. **Quy mô tập mẫu**: Mở rộng từ 8 câu lên **20 câu hỏi Held-Out** (khớp với tập 20 câu của C4-DICT và C4-QPTEXT).
2. **Chỉ số chất lượng**:
   - `grounded_accuracy >= 90%` (tối thiểu 18/20 câu sinh đúng token bằng chứng).
   - `unsupported_safe_response >= 95%` (câu lạ hoặc không có bằng chứng phải rơi về mã SAFE/EOS).
   - `hallucinated_fact <= 5%`.
   - `host_next_token = 0`, `host_final_answer = 0`.
3. **Đóng băng hợp đồng**: Chuyển trạng thái `LM06_BYTE256` từ `NOT_FROZEN` sang `FROZEN_C4G_V1`.

---

## III. HƯỚNG DẪN 3 BƯỚC THỰC HIỆN CHO CURSOR

### BƯỚC 1: Mở rộng Testbench `tb_astra_c4_lm06_grounded_gen.sv` lên 20 Held-Out Queries
Trong thư mục `results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-GROUNDED-GEN-01/`:
Mở file `tb_astra_c4_lm06_grounded_gen.sv`, bổ sung kịch bản kiểm thử:
- Nạp trọng số chuẩn (`bias`, `g_match=100`, `g_safe=50`, `g_eos=50`).
- Chạy 20 câu hỏi kiểm tra held-out tương ứng với các entity đã được kiểm chứng trong C3/C5 (các cặp subject/object dest=64, 11, 144, 112,...).
- Thực hiện đầy đủ 4 bài ablation bắt buộc:
  - **Case A (Normal Weights + Evidence)**: Kiểm tra 20/20 câu đạt đúng token đối tượng $\rightarrow$ log `CLASS_grounded_acc_ge90 HIT acc=20/20`.
  - **Case B (Zero Weights)**: Set `bias=0, g_match=0` $\rightarrow$ DUT không sinh bậy, rơi vào trạng thái an toàn `tok=0 (EOS)` $\rightarrow$ log `CLASS_w_zero_safe HIT`.
  - **Case C (Corrupted Weights)**: Đảo lộn trọng số $\rightarrow$ kết quả sai lệch so với gold $\rightarrow$ log `CLASS_w_corrupt_not_gold HIT`.
  - **Case D (Evidence Removed)**: `evid_has=0` $\rightarrow$ DUT sinh mã SAFE $\rightarrow$ log `CLASS_evid_removed_safe HIT`.

### BƯỚC 2: Thực thi XSim và Kiểm tra Marker
Chạy mô phỏng:
```powershell
cd D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C4-LM06-GROUNDED-GEN-01
.\run_xsim.ps1
```
Yêu cầu bắt buộc trong `xsim.log`:
- `CLASS_grounded_acc_ge90 HIT acc=20/20` (hoặc $\ge 18/20$)
- `CLASS_w_normal_grounded HIT`
- `CLASS_w_zero_safe HIT`
- `CLASS_w_corrupt_not_gold HIT`
- `CLASS_evid_removed_safe HIT`
- `CLASS_eos_or_max HIT`
- `CLASS_host_next_token_zero HIT`
- Marker xuất hiện: `ASTRA_C4_LM06_GROUNDED_GEN_XSIM_PASS`

### BƯỚC 3: Cập nhật Authority & Đóng băng Hợp đồng
1. Cập nhật file `results/A7-NATIVE-GRAPH/ASTRA-C4-LM06-GROUNDED-GEN-01/CLOSEOUT.md`:
   - Ghi nhận: `C4_MASTER=CLOSED_XSIM`.
   - Ghi nhận: `LM06_BYTE256=FROZEN_C4G_V1`.
   - Ghi nhận: `TINYGPT_802K=RETIRED_PER_GROK_MASTER_550` (Loại bỏ chính thức vì vượt BRAM và vi phạm chỉ đạo không dùng neural network lớn).
2. Cập nhật `docs/ASTRA/LOOP_STATE.json`:
   - `"c4_grounded_gen_closed": true`
   - `"LM06_BYTE256": "FROZEN_C4G_V1"`
   - `"c4_master": "CLOSED_XSIM"`
3. Cập nhật `results/A7-NATIVE-GRAPH/STATUS/HARD_BLOCK_MASTER_C3_C6.md`:
   - Xóa bỏ mục chặn của C4.

---

## IV. BƯỚC NGHIỆM THU CỦA ANTIGRAVITY (AUDITOR)
Ngay khi Cursor hoàn tất 3 bước trên:
1. Antigravity sẽ kiểm tra độc lập file `xsim.log` để xác minh:
   - Tỷ lệ chính xác $\ge 90\%$ trên 20 mẫu.
   - Bằng chứng 4 bài ablation chứng minh phụ thuộc trọng số.
   - BRAM sử dụng trong netlist = 0.
2. Xuất báo cáo chính thức đóng **C4 MASTER LETTER**.
