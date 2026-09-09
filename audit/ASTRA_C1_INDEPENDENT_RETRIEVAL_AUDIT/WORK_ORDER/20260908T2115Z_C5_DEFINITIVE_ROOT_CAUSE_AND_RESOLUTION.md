# HƯỚNG DẪN DỨT ĐIỂM TOÀN BỘ BUG & ĐIỂM NGHẼN C5 (MASTER DEFINITIVE WORK ORDER)

**Mã tài liệu:** `WO-20260908T2115Z-C5-DEFINITIVE-ROOT-CAUSE-FIX`  
**Đơn vị ban hành:** Antigravity (Independent Auditor & System Architect)  
**Đối tượng thực thi:** Cursor (Live Clone `D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH`)  
**Mục tiêu:** Xử lý triệt để nguyên nhân gốc rễ khiến test `ASTRA-C5-FLUSH-RELOAD-MIG-01` (và toàn bộ flow C5) liên tục treo ở r0, r1, r2, r3; đóng dứt điểm gate C5.

---

## I. NGUYÊN NHÂN GỐC RỄ THỰC SỰ (THE SMOKING GUN)

Qua deep audit song song 3 subagent trên toàn bộ 9 bag C5 và RTL, **8/9 bag C5 đều đã PASS XSim**. Chỉ duy nhất một bag bị treo: `ASTRA-C5-FLUSH-RELOAD-MIG-01`.

Các lần sửa r1, r2, r3 của Cursor bị thất bại vì **chuẩn đoán nhầm hiện tượng thành nguyên nhân**:
- Cursor tưởng MIG trả "orphan read" dư thừa nên viết logic drain orphan (r2).
- Cursor tưởng C2 persist chưa kịp nhận nên thêm "1-beat skid buffer" (r3).

### Cơ chế Deadlock thực sự diễn ra như sau:
1. **Lệnh UART Reload**: TB gửi 2 byte qua UART: byte `0x12` (`CMD_RELOAD`) và byte `0x0A` (`EOL`).
2. **Pulse kích hoạt quá sớm**: Khi vừa nhận byte `0x12`, `prod_top` (dòng 574) kích xung `p_rel <= 1'b1` ngay lập tức và đặt `reload_pend <= 1'b1`. Nhưng FSM chính `pst` **vẫn ở `ST_UART`** vì đang chờ byte `EOL` (`0x0A`) truyền tiếp theo baudrate (mất hàng trăm chu kỳ clock).
3. **Mở grant tạm thời**: C2 persist nhận `p_rel`, chuyển sang `S_AR` và assert `p_arv = 1`. Tại dòng 330 của `prod_top`:
   ```systemverilog
   if ((pst == ST_PERS) || (pst == ST_DRAIN) || p_arv || p_awv || p_wv) req[A7NG_C5_CKPT] = 1'b1;
   ```
   Do `p_arv == 1`, arbiter cấp grant cho CKPT (`owner = 5`).
4. **MẤT GRANT GIỮA CHỪNG (THE SMOKING GUN)**:
   MIG bắt tay địa chỉ đọc (`arready == 1`). C2 chuyển sang `S_R` chờ dữ liệu và hạ `p_arv = 0`.
   Lúc này:
   - `pst` vẫn là `ST_UART` (chưa nhận xong EOL).
   - `p_arv = 0`, `p_awv = 0`, `p_wv = 0`.
   - `reload_pend` và `p_busy` **hoàn toàn KHÔNG có trong điều kiện gán `req[CKPT]`**!
   => `req[A7NG_C5_CKPT]` lập tức rớt về `0`!
5. **Dữ liệu thật bị nuốt chửng**: Arbiter thấy `req` mất liền giật quyền lại (`owner = NONE`). Khi MIG hoàn tất độ trễ đọc DRAM (~30 chu kỳ) và trả data thật (`m_rvalid_i = 1`), `prod_top` thấy `owner == NONE` nên kích hoạt logic **"draining orphan"** (dòng 288) và nuốt sạch dữ liệu đọc của C2!
6. **Treo vĩnh viễn**: Hàng trăm chu kỳ sau, byte `EOL` mới tới. `pst` chuyển sang `ST_DRAIN` và cấp lại grant cho CKPT. Nhưng MIG đã hoàn tất transaction từ lâu và sẽ **không bao giờ trả lại beat dữ liệu đó nữa**. C2 nằm chờ trong `S_R` vô tận, `pph` kẹt ở `0`, testbench guard loop hết giờ và bị kill!

---

## II. DANH MỤC 4 ĐIỂM NGHẼN HỆ THỐNG CẦN XỬ LÝ TRIỆT ĐỂ

### 1. [P0] Mất grant giữa chừng trong `a7ng_astra_c5_prod_top.sv`
- **File**: `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv` (Dòng 330)
- **Lỗi**: `req[A7NG_C5_CKPT]` không giữ grant khi C2 đang bận (`p_busy`) hoặc đang chờ reload (`reload_pend`).

### 2. [P0] Arbiter giật grant khi AXI handshake chưa xong trong `a7ng_astra_c5_ddr_arb.sv`
- **File**: `rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv` (Dòng 55, 84-90)
- **Lỗi**: Vi phạm chuẩn AXI: hạ ARVALID trước khi có ARREADY; chuyển state `S_OWN -> S_IDLE` ngay khi `req` rớt mà không đợi các beat đọc đang in-flight (`pend != 0`).

### 3. [P0] Mất tín hiệu Byte Strobe ghi DDR `m_wstrb_o`
- **File**: `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv` (Dòng 130-136, 310)
- **Lỗi**: Module `prod_top` bỏ quên port `m_wstrb_o`. Mặc dù C2 xuất `p_wstrb`, nhưng top-level không nối ra MIG khiến lệnh ghi DDR có thể bị hỏng byte strobe.

### 4. [P1] Nguy cơ treo `ST_WAITQ` nếu `c3_res` là xung 1 chu kỳ
- **File**: `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv` (Dòng 594)
- **Lỗi**: Khi `c3_res` hạ xuống 0 sau 1 chu kỳ, FSM bị kẹt không thể vào nhánh kiểm tra `c3_pcmt`.

---

## III. HƯỚNG DẪN CHI TIẾT TỪNG BƯỚC CHO CURSOR THỰC HIỆN

### BƯỚC 1: Sửa giữ grant cho CKPT trong `a7ng_astra_c5_prod_top.sv`
Mở file `rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv`, tìm đến dòng 330:

**Thay thế đoạn code:**
```systemverilog
    if ((pst == ST_PERS) || (pst == ST_DRAIN) || p_arv || p_awv || p_wv) begin
      req[A7NG_C5_CKPT] = 1'b1;
      s_arv[A7NG_C5_CKPT] = p_arv;
      s_ara[A7NG_C5_CKPT] = p_ara;
    end
```

**Bằng đoạn code sau:**
```systemverilog
    // FIX: Giữ grant liên tục khi C2 đang bận (p_busy) hoặc đang pending reload/drain
    if ((pst == ST_PERS) || (pst == ST_DRAIN) || reload_pend || p_busy || p_arv || p_awv || p_wv) begin
      req[A7NG_C5_CKPT] = 1'b1;
      s_arv[A7NG_C5_CKPT] = p_arv;
      s_ara[A7NG_C5_CKPT] = p_ara;
    end
```

---

### BƯỚC 2: Bổ sung cổng `m_wstrb_o` trong `a7ng_astra_c5_prod_top.sv`

1. Tại khai báo module `a7ng_astra_c5_prod_top` (khoảng dòng 135):
```systemverilog
  output logic        m_wvalid_o,
  output logic [127:0] m_wdata_o,
  output logic        m_wlast_o,
  output logic [15:0] m_wstrb_o,    // <-- THÊM DÒNG NÀY
  input  logic        m_wready_i,
```

2. Tại phần assign bus ghi (khoảng dòng 311):
```systemverilog
  assign m_wvalid_o  = (owner == A7NG_C5_CKPT) && p_wv;
  assign m_wdata_o   = p_wd;
  assign m_wlast_o   = p_wl;
  assign m_wstrb_o   = p_wstrb;      // <-- THÊM DÒNG NÀY
  assign p_wr        = (owner == A7NG_C5_CKPT) && m_wready_i;
```

---

### BƯỚC 3: Chuẩn hóa AXI & In-Flight Tracking trong `a7ng_astra_c5_ddr_arb.sv`
Mở file `rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv`:

1. Khai báo thêm counter theo dõi read transaction in-flight:
```systemverilog
  logic [3:0] pend;
```

2. Trong khối `always_ff @(posedge clk or negedge rst_n)`:
```systemverilog
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      own <= A7NG_C5_NONE;
      n_sw <= 16'd0;
      n_blk <= 16'd0;
      pend <= 4'd0;
    end else begin
      // Theo dõi số lượng read beat đang bay trên đường truyền
      if (m_arvalid_o && m_arready_i && !(m_rvalid_i && m_rready_o))
        pend <= pend + 4'd1;
      else if (!(m_arvalid_o && m_arready_i) && m_rvalid_i && m_rready_o && (pend > 4'd0))
        pend <= pend - 4'd1;

      unique case (st)
        S_IDLE: begin
          if (pick != A7NG_C5_NONE) begin
            own <= pick;
            n_sw <= n_sw + 16'd1;
            st <= S_OWN;
          end
        end
        S_OWN: begin
          if ((req_i & ~(6'd1 << own)) != 6'd0)
            n_blk <= n_blk + 16'd1;

          // FIX: Chỉ nhả grant khi client hết req VÀ không còn AR pending VÀ không còn R beat in-flight
          if (!req_i[own] && (pend == 4'd0) && !(s_arvalid_i[own] && !m_arready_i)) begin
            own <= A7NG_C5_NONE;
            st <= S_IDLE;
          end
        end
        default: st <= S_IDLE;
      endcase
    end
  end
```

---

### BƯỚC 4: Chống kẹt FSM tại `ST_WAITQ` trong `a7ng_astra_c5_prod_top.sv`
Tại dòng 594 của `a7ng_astra_c5_prod_top.sv`:

**Thay thế:**
```systemverilog
        ST_WAITQ: begin
          if (c3_res) begin
```

**Bằng:**
```systemverilog
        ST_WAITQ: begin
          if (c3_res || rew_sent) begin
```

---

### BƯỚC 5: Chạy lại Testbench và Xác minh Gate

1. Vào thư mục bag:
   ```powershell
   cd D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C5-FLUSH-RELOAD-MIG-01
   ```
2. Thực thi mô phỏng:
   ```powershell
   .\run_xsim.ps1
   ```
3. Tiêu chí kiểm tra PASS hoàn toàn:
   - `CLASS_mig_calib_complete HIT`
   - `CLASS_two_hop_answer HIT`
   - `CLASS_flush_w0_zero HIT`
   - `CLASS_c2_persist_reload HIT w0=3` (Hoặc giá trị w0 tương ứng)
   - `CLASS_one_ddr_owner HIT`
   - Xuất hiện dòng chữ: `ASTRA_C5_FLUSH_RELOAD_MIG_XSIM_PASS`
   - Không còn lỗi `C5FRM_XSIM_CONTROL_FAIL`.

4. Cập nhật `CLOSEOUT.md` cho bag `ASTRA-C5-FLUSH-RELOAD-MIG-01`.

---

## IV. BẢO ĐẢM NGUYÊN TẮC BẢO VỆ DỰ ÁN (AUDIT LAW)
- **Tuyệt đối không sửa C0/C1/C2 KEEP RTL** (đã chứng minh C2 hoàn toàn chạy đúng khi gắn độc lập với MIG trong C2-PERSIST-MIG-01).
- **Không regenerate GOLDEN.json**.
- **Không tự ý set PROGRAM=YES hoặc BOARD_PASS=PASS** (chỉ dừng ở XSim close per Master V1.1).
