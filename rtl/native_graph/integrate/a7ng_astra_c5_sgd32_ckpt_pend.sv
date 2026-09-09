// a7ng_astra_c5_sgd32_ckpt_pend.sv — ASTRA-C5-PEND-PROOF-PHI-01. PROGRAM=NO.
// Named snapshot of 32 weights + pending proof IDs + 32 phi.
// Does not edit C2 KEEP or a7ng_astra_c5_sgd32_ckpt. Schema 2, not frozen.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_sgd32_ckpt_pend.svh"
`include "a7ng_gate14_crc.svh"

module a7ng_astra_c5_sgd32_ckpt_pend (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic        go_persist_i,
  input  logic        go_reload_i,
  input  logic        retire_i,
  input  logic        clr_i,
  input  logic signed [15:0] w_i [0:31],
  input  logic signed [7:0]  phi_i [0:31],
  input  logic [19:0] p0_i,
  input  logic [19:0] p1_i,
  input  logic [19:0] ans_i,
  input  logic [1:0]  sel_i,
  input  logic [3:0]  st_i,
  input  logic [7:0]  txn_i,
  input  logic [7:0]  gen_i,
  input  logic        pend_acc_i,
  input  logic        pend_cmt_i,
  output logic        load_v_o,
  output logic [4:0]  load_idx_o,
  output logic signed [15:0] load_w_o,
  output logic        phi_load_v_o,
  output logic [4:0]  phi_idx_o,
  output logic signed [7:0]  phi_o,
  output logic        pend_load_v_o,
  output logic [19:0] p0_o,
  output logic [19:0] p1_o,
  output logic [19:0] ans_o,
  output logic [1:0]  sel_o,
  output logic [3:0]  st_o,
  output logic [7:0]  txn_o,
  output logic [7:0]  gen_o,
  output logic        pend_acc_o,
  output logic        pend_cmt_o,
  output logic        busy_o,
  output logic [3:0]  phase_o,
  output logic [3:0]  fail_o,
  output logic        persisted_o,
  output logic        restored_o,
  output logic [15:0] seq_o,
  output logic [15:0] crc_o,
  output logic [3:0]  m_axi_awid,
  output logic [27:0] m_axi_awaddr,
  output logic [7:0]  m_axi_awlen,
  output logic [2:0]  m_axi_awsize,
  output logic [1:0]  m_axi_awburst,
  output logic        m_axi_awvalid,
  input  logic        m_axi_awready,
  output logic [127:0] m_axi_wdata,
  output logic [15:0] m_axi_wstrb,
  output logic        m_axi_wlast,
  output logic        m_axi_wvalid,
  input  logic        m_axi_wready,
  input  logic [3:0]  m_axi_bid,
  input  logic [1:0]  m_axi_bresp,
  input  logic        m_axi_bvalid,
  output logic        m_axi_bready,
  output logic [3:0]  m_axi_arid,
  output logic [27:0] m_axi_araddr,
  output logic [7:0]  m_axi_arlen,
  output logic [2:0]  m_axi_arsize,
  output logic [1:0]  m_axi_arburst,
  output logic        m_axi_arvalid,
  input  logic        m_axi_arready,
  input  logic [3:0]  m_axi_rid,
  input  logic [127:0] m_axi_rdata,
  input  logic [1:0]  m_axi_rresp,
  input  logic        m_axi_rlast,
  input  logic        m_axi_rvalid,
  output logic        m_axi_rready
);
  typedef enum logic [3:0] {
    S_IDLE, S_CAP, S_AW, S_W, S_B, S_HOLD, S_AR, S_R, S_CHK, S_CRC,
    S_LD, S_LPHI, S_LPEND, S_FAIL
  } st_t;
  st_t st;

  logic signed [15:0] cap [0:31];
  logic signed [15:0] sh  [0:31];
  logic signed [7:0]  pcap [0:31];
  logic signed [7:0]  psh  [0:31];
  logic [19:0] cap_p0, cap_p1, cap_ans, sh_p0, sh_p1, sh_ans;
  logic [1:0]  cap_sel, sh_sel;
  logic [3:0]  cap_st, sh_st;
  logic [7:0]  cap_txn, cap_gen, sh_txn, sh_gen;
  logic        cap_acc, cap_cmt, sh_acc, sh_cmt;
  logic [15:0] seq, crc_lat, crc_rd;
  logic [3:0] beat;
  logic [4:0] li;
  logic [15:0] tocnt;
  logic [3:0] phase, fail;
  logic awv, wv, arv, persisted, restored;
  logic [127:0] wbeat;
  integer kc, kf;

  function automatic logic [127:0] pack8(input int base);
    pack8 = {cap[base+7], cap[base+6], cap[base+5], cap[base+4],
             cap[base+3], cap[base+2], cap[base+1], cap[base+0]};
  endfunction
  function automatic logic [127:0] pack_phi(input int base);
    pack_phi = {pcap[base+15], pcap[base+14], pcap[base+13], pcap[base+12],
                pcap[base+11], pcap[base+10], pcap[base+9], pcap[base+8],
                pcap[base+7], pcap[base+6], pcap[base+5], pcap[base+4],
                pcap[base+3], pcap[base+2], pcap[base+1], pcap[base+0]};
  endfunction
  function automatic logic [127:0] pack_pend();
    pack_pend = {44'd0, cap_cmt, cap_acc, cap_gen, cap_txn, cap_st, cap_sel,
                 cap_ans, cap_p1, cap_p0};
  endfunction
  function automatic logic [127:0] pack_hdr(input logic [15:0] s, input logic [15:0] c);
    pack_hdr = {7'd0, 1'b1, 24'd0, c, 8'd0, A7NG_C5P_NW, s, live_epoch_i,
                A7NG_C5P_SCHEMA, A7NG_C5P_VER, A7NG_C5P_MAGIC};
  endfunction
  function automatic logic [127:0] pack_mark(input logic [15:0] s, input logic [15:0] c);
    pack_mark = {1'b1, 79'd0, c, s, A7NG_C5P_MAGIC};
  endfunction

  always_comb begin
    crc_lat = 16'hFFFF;
    for (kc = 0; kc < 32; kc = kc + 1) begin
      crc_lat = crc16_byte(crc_lat, cap[kc][7:0]);
      crc_lat = crc16_byte(crc_lat, cap[kc][15:8]);
      crc_lat = crc16_byte(crc_lat, pcap[kc]);
    end
    crc_lat = crc16_byte(crc_lat, cap_p0[7:0]);
    crc_lat = crc16_byte(crc_lat, cap_p0[15:8]);
    crc_lat = crc16_byte(crc_lat, {4'd0, cap_p0[19:16]});
    crc_lat = crc16_byte(crc_lat, cap_p1[7:0]);
    crc_lat = crc16_byte(crc_lat, cap_p1[15:8]);
    crc_lat = crc16_byte(crc_lat, {4'd0, cap_p1[19:16]});
    crc_lat = crc16_byte(crc_lat, cap_ans[7:0]);
    crc_lat = crc16_byte(crc_lat, cap_ans[15:8]);
    crc_lat = crc16_byte(crc_lat, {4'd0, cap_ans[19:16]});
    crc_lat = crc16_byte(crc_lat, cap_txn);
    crc_lat = crc16_byte(crc_lat, cap_gen);
    crc_lat = crc16_byte(crc_lat, {2'd0, cap_cmt, cap_acc, cap_sel, cap_st});
  end

  assign busy_o = (st != S_IDLE) && (st != S_HOLD) && (st != S_FAIL);
  assign phase_o = phase;
  assign fail_o = fail;
  assign persisted_o = persisted;
  assign restored_o = restored;
  assign seq_o = seq;
  assign crc_o = crc_lat;
  assign load_v_o = (st == S_LD);
  assign load_idx_o = li;
  assign load_w_o = sh[li];
  assign phi_load_v_o = (st == S_LPHI);
  assign phi_idx_o = li;
  assign phi_o = psh[li];
  assign pend_load_v_o = (st == S_LPEND);
  assign p0_o = sh_p0;
  assign p1_o = sh_p1;
  assign ans_o = sh_ans;
  assign sel_o = sh_sel;
  assign st_o = sh_st;
  assign txn_o = sh_txn;
  assign gen_o = sh_gen;
  assign pend_acc_o = sh_acc;
  assign pend_cmt_o = sh_cmt;
  assign m_axi_awid = 4'd1;
  assign m_axi_awaddr = A7NG_C5P_BASE + {24'd0, beat, 4'd0};
  assign m_axi_awlen = 8'd0;
  assign m_axi_awsize = 3'd4;
  assign m_axi_awburst = 2'b01;
  assign m_axi_awvalid = awv;
  assign m_axi_wdata = wbeat;
  assign m_axi_wstrb = 16'hFFFF;
  assign m_axi_wlast = 1'b1;
  assign m_axi_wvalid = wv;
  assign m_axi_bready = (st == S_B);
  assign m_axi_arid = 4'd2;
  assign m_axi_araddr = A7NG_C5P_BASE + {24'd0, beat, 4'd0};
  assign m_axi_arlen = 8'd0;
  assign m_axi_arsize = 3'd4;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arvalid = arv;
  assign m_axi_rready = (st == S_R);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      phase <= A7NG_C5P_PH_IDLE;
      fail <= A7NG_C5P_F_NONE;
      seq <= 16'd0;
      beat <= 4'd0;
      li <= 5'd0;
      tocnt <= 16'd0;
      awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
      persisted <= 1'b0; restored <= 1'b0;
      wbeat <= 128'd0;
      crc_rd <= 16'd0;
      cap_p0 <= 20'd0; cap_p1 <= 20'd0; cap_ans <= 20'd0;
      cap_sel <= 2'd0; cap_st <= 4'd0; cap_txn <= 8'd0; cap_gen <= 8'd0;
      cap_acc <= 1'b0; cap_cmt <= 1'b0;
      sh_p0 <= 20'd0; sh_p1 <= 20'd0; sh_ans <= 20'd0;
      sh_sel <= 2'd0; sh_st <= 4'd0; sh_txn <= 8'd0; sh_gen <= 8'd0;
      sh_acc <= 1'b0; sh_cmt <= 1'b0;
      for (kf = 0; kf < 32; kf = kf + 1) begin
        cap[kf] <= 16'sd0; sh[kf] <= 16'sd0;
        pcap[kf] <= 8'sd0; psh[kf] <= 8'sd0;
      end
    end else begin
      if (clr_i) begin
        persisted <= 1'b0;
        restored <= 1'b0;
      end
      unique case (st)
        S_IDLE: begin
          phase <= A7NG_C5P_PH_IDLE;
          fail <= A7NG_C5P_F_NONE;
          awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
          tocnt <= 16'd0;
          if (retire_i) begin
            persisted <= 1'b0;
            restored <= 1'b0;
          end else if (go_persist_i) begin
            for (kf = 0; kf < 32; kf = kf + 1) begin
              cap[kf] <= w_i[kf];
              pcap[kf] <= phi_i[kf];
            end
            cap_p0 <= p0_i; cap_p1 <= p1_i; cap_ans <= ans_i;
            cap_sel <= sel_i; cap_st <= st_i; cap_txn <= txn_i; cap_gen <= gen_i;
            cap_acc <= pend_acc_i; cap_cmt <= pend_cmt_i;
            beat <= 4'd0;
            persisted <= 1'b0;
            restored <= 1'b0;
            phase <= A7NG_C5P_PH_CAPTURE;
            st <= S_CAP;
          end else if (go_reload_i) begin
            beat <= 4'd0;
            restored <= 1'b0;
            phase <= A7NG_C5P_PH_READ;
            st <= S_AR;
          end
        end
        S_CAP: begin
          phase <= A7NG_C5P_PH_WRITE;
          wbeat <= pack_hdr(seq + 16'd1, crc_lat);
          awv <= 1'b1;
          st <= S_AW;
        end
        S_AW: begin
          phase <= A7NG_C5P_PH_WRITE;
          tocnt <= tocnt + 16'd1;
          if (awv && m_axi_awready) begin
            awv <= 1'b0;
            wv <= 1'b1;
            tocnt <= 16'd0;
            st <= S_W;
          end else if (tocnt >= A7NG_C5P_TO[15:0]) begin
            fail <= A7NG_C5P_F_TO; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
          end
        end
        S_W: begin
          phase <= A7NG_C5P_PH_WRITE;
          tocnt <= tocnt + 16'd1;
          if (wv && m_axi_wready) begin
            wv <= 1'b0;
            tocnt <= 16'd0;
            st <= S_B;
          end else if (tocnt >= A7NG_C5P_TO[15:0]) begin
            fail <= A7NG_C5P_F_TO; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
          end
        end
        S_B: begin
          phase <= A7NG_C5P_PH_WAITB;
          tocnt <= tocnt + 16'd1;
          if (m_axi_bvalid) begin
            tocnt <= 16'd0;
            if (m_axi_bresp != 2'b00) begin
              fail <= A7NG_C5P_F_BRESP; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
            end else if (beat == 4'd8) begin
              seq <= seq + 16'd1;
              persisted <= 1'b1;
              phase <= A7NG_C5P_PH_PERSISTED;
              st <= S_HOLD;
            end else begin
              beat <= beat + 4'd1;
              unique case (beat + 4'd1)
                4'd1: wbeat <= pack8(0);
                4'd2: wbeat <= pack8(8);
                4'd3: wbeat <= pack8(16);
                4'd4: wbeat <= pack8(24);
                4'd5: wbeat <= pack_pend();
                4'd6: wbeat <= pack_phi(0);
                4'd7: wbeat <= pack_phi(16);
                default: wbeat <= pack_mark(seq + 16'd1, crc_lat);
              endcase
              awv <= 1'b1;
              st <= S_AW;
            end
          end else if (tocnt >= A7NG_C5P_TO[15:0]) begin
            fail <= A7NG_C5P_F_TO; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
          end
        end
        S_HOLD: begin
          phase <= persisted ? A7NG_C5P_PH_PERSISTED : A7NG_C5P_PH_READY;
          if (retire_i) begin
            persisted <= 1'b0;
            restored <= 1'b0;
            st <= S_IDLE;
          end
        end
        S_AR: begin
          phase <= A7NG_C5P_PH_READ;
          if (!arv) arv <= 1'b1;
          tocnt <= tocnt + 16'd1;
          if (arv && m_axi_arready) begin
            arv <= 1'b0;
            tocnt <= 16'd0;
            st <= S_R;
          end else if (tocnt >= A7NG_C5P_TO[15:0]) begin
            fail <= A7NG_C5P_F_TO; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
          end
        end
        S_R: begin
          phase <= A7NG_C5P_PH_READ;
          tocnt <= tocnt + 16'd1;
          if (m_axi_rvalid && m_axi_rlast) begin
            tocnt <= 16'd0;
            if (m_axi_rresp != 2'b00) begin
              fail <= A7NG_C5P_F_RRESP; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
            end else begin
              unique case (beat)
                4'd0: begin
                  if (m_axi_rdata[15:0] != A7NG_C5P_MAGIC) begin
                    fail <= A7NG_C5P_F_MAGIC; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
                  end else if ((m_axi_rdata[23:16] != A7NG_C5P_VER) ||
                               (m_axi_rdata[31:24] != A7NG_C5P_SCHEMA) ||
                               (m_axi_rdata[71:64] != A7NG_C5P_NW) ||
                               !m_axi_rdata[120]) begin
                    fail <= A7NG_C5P_F_SCHEMA; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
                  end else begin
                    crc_rd <= m_axi_rdata[95:80];
                    beat <= 4'd1;
                    st <= S_AR;
                  end
                end
                4'd1: begin
                  sh[0] <= m_axi_rdata[15:0]; sh[1] <= m_axi_rdata[31:16];
                  sh[2] <= m_axi_rdata[47:32]; sh[3] <= m_axi_rdata[63:48];
                  sh[4] <= m_axi_rdata[79:64]; sh[5] <= m_axi_rdata[95:80];
                  sh[6] <= m_axi_rdata[111:96]; sh[7] <= m_axi_rdata[127:112];
                  beat <= 4'd2; st <= S_AR;
                end
                4'd2: begin
                  sh[8] <= m_axi_rdata[15:0]; sh[9] <= m_axi_rdata[31:16];
                  sh[10] <= m_axi_rdata[47:32]; sh[11] <= m_axi_rdata[63:48];
                  sh[12] <= m_axi_rdata[79:64]; sh[13] <= m_axi_rdata[95:80];
                  sh[14] <= m_axi_rdata[111:96]; sh[15] <= m_axi_rdata[127:112];
                  beat <= 4'd3; st <= S_AR;
                end
                4'd3: begin
                  sh[16] <= m_axi_rdata[15:0]; sh[17] <= m_axi_rdata[31:16];
                  sh[18] <= m_axi_rdata[47:32]; sh[19] <= m_axi_rdata[63:48];
                  sh[20] <= m_axi_rdata[79:64]; sh[21] <= m_axi_rdata[95:80];
                  sh[22] <= m_axi_rdata[111:96]; sh[23] <= m_axi_rdata[127:112];
                  beat <= 4'd4; st <= S_AR;
                end
                4'd4: begin
                  sh[24] <= m_axi_rdata[15:0]; sh[25] <= m_axi_rdata[31:16];
                  sh[26] <= m_axi_rdata[47:32]; sh[27] <= m_axi_rdata[63:48];
                  sh[28] <= m_axi_rdata[79:64]; sh[29] <= m_axi_rdata[95:80];
                  sh[30] <= m_axi_rdata[111:96]; sh[31] <= m_axi_rdata[127:112];
                  beat <= 4'd5; st <= S_AR;
                end
                4'd5: begin
                  sh_p0 <= m_axi_rdata[19:0];
                  sh_p1 <= m_axi_rdata[39:20];
                  sh_ans <= m_axi_rdata[59:40];
                  sh_sel <= m_axi_rdata[61:60];
                  sh_st <= m_axi_rdata[65:62];
                  sh_txn <= m_axi_rdata[73:66];
                  sh_gen <= m_axi_rdata[81:74];
                  sh_acc <= m_axi_rdata[82];
                  sh_cmt <= m_axi_rdata[83];
                  beat <= 4'd6; st <= S_AR;
                end
                4'd6: begin
                  psh[0] <= m_axi_rdata[7:0]; psh[1] <= m_axi_rdata[15:8];
                  psh[2] <= m_axi_rdata[23:16]; psh[3] <= m_axi_rdata[31:24];
                  psh[4] <= m_axi_rdata[39:32]; psh[5] <= m_axi_rdata[47:40];
                  psh[6] <= m_axi_rdata[55:48]; psh[7] <= m_axi_rdata[63:56];
                  psh[8] <= m_axi_rdata[71:64]; psh[9] <= m_axi_rdata[79:72];
                  psh[10] <= m_axi_rdata[87:80]; psh[11] <= m_axi_rdata[95:88];
                  psh[12] <= m_axi_rdata[103:96]; psh[13] <= m_axi_rdata[111:104];
                  psh[14] <= m_axi_rdata[119:112]; psh[15] <= m_axi_rdata[127:120];
                  beat <= 4'd7; st <= S_AR;
                end
                4'd7: begin
                  psh[16] <= m_axi_rdata[7:0]; psh[17] <= m_axi_rdata[15:8];
                  psh[18] <= m_axi_rdata[23:16]; psh[19] <= m_axi_rdata[31:24];
                  psh[20] <= m_axi_rdata[39:32]; psh[21] <= m_axi_rdata[47:40];
                  psh[22] <= m_axi_rdata[55:48]; psh[23] <= m_axi_rdata[63:56];
                  psh[24] <= m_axi_rdata[71:64]; psh[25] <= m_axi_rdata[79:72];
                  psh[26] <= m_axi_rdata[87:80]; psh[27] <= m_axi_rdata[95:88];
                  psh[28] <= m_axi_rdata[103:96]; psh[29] <= m_axi_rdata[111:104];
                  psh[30] <= m_axi_rdata[119:112]; psh[31] <= m_axi_rdata[127:120];
                  beat <= 4'd8; st <= S_AR;
                end
                default: begin
                  if ((m_axi_rdata[15:0] != A7NG_C5P_MAGIC) || !m_axi_rdata[127]) begin
                    fail <= A7NG_C5P_F_COMMIT; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
                  end else st <= S_CHK;
                end
              endcase
            end
          end else if (tocnt >= A7NG_C5P_TO[15:0]) begin
            fail <= A7NG_C5P_F_TO; phase <= A7NG_C5P_PH_FAILED; st <= S_FAIL;
          end
        end
        S_CHK: begin
          for (kf = 0; kf < 32; kf = kf + 1) begin
            cap[kf] <= sh[kf];
            pcap[kf] <= psh[kf];
          end
          cap_p0 <= sh_p0; cap_p1 <= sh_p1; cap_ans <= sh_ans;
          cap_sel <= sh_sel; cap_st <= sh_st; cap_txn <= sh_txn; cap_gen <= sh_gen;
          cap_acc <= sh_acc; cap_cmt <= sh_cmt;
          phase <= A7NG_C5P_PH_LOAD;
          st <= S_CRC;
        end
        S_CRC: begin
          if (crc_lat != crc_rd) begin
            fail <= A7NG_C5P_F_CRC;
            phase <= A7NG_C5P_PH_FAILED;
            st <= S_FAIL;
          end else begin
            li <= 5'd0;
            st <= S_LD;
          end
        end
        S_LD: begin
          phase <= A7NG_C5P_PH_LOAD;
          if (li == 5'd31) begin
            li <= 5'd0;
            st <= S_LPHI;
          end else li <= li + 5'd1;
        end
        S_LPHI: begin
          phase <= A7NG_C5P_PH_LOAD;
          if (li == 5'd31) st <= S_LPEND;
          else li <= li + 5'd1;
        end
        S_LPEND: begin
          restored <= 1'b1;
          phase <= A7NG_C5P_PH_READY;
          st <= S_HOLD;
        end
        S_FAIL: begin
          phase <= A7NG_C5P_PH_FAILED;
          persisted <= 1'b0;
          restored <= 1'b0;
          awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
          if (retire_i) st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
