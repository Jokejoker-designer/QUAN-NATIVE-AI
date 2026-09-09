// a7ng_astra_c5_sgd32_ckpt.sv — ASTRA-C5-SGD32-CKPT-01. PROGRAM=NO.
// Named A/B-capable SGD32 snapshot backend. Does not edit C2 KEEP.
// Snapshot copies the committed 32-weight bank; restore loads that same bank.
// Reward is not a substitute for the weight vector. Not BOARD. Not 01B close of C5.
`timescale 1ns / 1ps
`include "a7ng_astra_c5_sgd32_ckpt.svh"
`include "a7ng_gate14_crc.svh"

module a7ng_astra_c5_sgd32_ckpt (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [15:0] live_epoch_i,
  input  logic        go_persist_i,
  input  logic        go_reload_i,
  input  logic        retire_i,
  input  logic        clr_i,
  input  logic signed [15:0] w_i [0:31],
  output logic        load_v_o,
  output logic [4:0]  load_idx_o,
  output logic signed [15:0] load_w_o,
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
    S_IDLE, S_CAP, S_AW, S_W, S_B, S_HOLD, S_AR, S_R, S_CHK, S_CRC, S_LD, S_FAIL
  } st_t;
  st_t st;

  logic signed [15:0] cap [0:31];
  logic signed [15:0] sh  [0:31];
  logic [15:0] seq, crc_lat, crc_rd;
  logic [2:0] beat;
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

  function automatic logic [127:0] pack_hdr(input logic [15:0] s, input logic [15:0] c);
    pack_hdr = {7'd0, 1'b1, 24'd0, c, 8'd0, A7NG_C5K_NW, s, live_epoch_i,
                A7NG_C5K_SCHEMA, A7NG_C5K_VER, A7NG_C5K_MAGIC};
  endfunction

  function automatic logic [127:0] pack_mark(input logic [15:0] s, input logic [15:0] c);
    pack_mark = {1'b1, 79'd0, c, s, A7NG_C5K_MAGIC};
  endfunction

  always_comb begin
    crc_lat = 16'hFFFF;
    for (kc = 0; kc < 32; kc = kc + 1) begin
      crc_lat = crc16_byte(crc_lat, cap[kc][7:0]);
      crc_lat = crc16_byte(crc_lat, cap[kc][15:8]);
    end
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
  assign m_axi_awid = 4'd1;
  assign m_axi_awaddr = A7NG_C5K_BASE + {25'd0, beat, 4'd0};
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
  assign m_axi_araddr = A7NG_C5K_BASE + {25'd0, beat, 4'd0};
  assign m_axi_arlen = 8'd0;
  assign m_axi_arsize = 3'd4;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arvalid = arv;
  assign m_axi_rready = (st == S_R);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      phase <= A7NG_C5K_PH_IDLE;
      fail <= A7NG_C5K_F_NONE;
      seq <= 16'd0;
      beat <= 3'd0;
      li <= 5'd0;
      tocnt <= 16'd0;
      awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
      persisted <= 1'b0; restored <= 1'b0;
      wbeat <= 128'd0;
      crc_rd <= 16'd0;
      for (kf = 0; kf < 32; kf = kf + 1) begin cap[kf] <= 16'sd0; sh[kf] <= 16'sd0; end
    end else begin
      if (clr_i) begin
        persisted <= 1'b0;
        restored <= 1'b0;
      end
      unique case (st)
        S_IDLE: begin
          phase <= A7NG_C5K_PH_IDLE;
          fail <= A7NG_C5K_F_NONE;
          awv <= 1'b0; wv <= 1'b0; arv <= 1'b0;
          tocnt <= 16'd0;
          if (retire_i) begin
            persisted <= 1'b0;
            restored <= 1'b0;
          end else if (go_persist_i) begin
            for (kf = 0; kf < 32; kf = kf + 1) cap[kf] <= w_i[kf];
            beat <= 3'd0;
            persisted <= 1'b0;
            restored <= 1'b0;
            phase <= A7NG_C5K_PH_CAPTURE;
            st <= S_CAP;
          end else if (go_reload_i) begin
            beat <= 3'd0;
            restored <= 1'b0;
            phase <= A7NG_C5K_PH_READ;
            st <= S_AR;
          end
        end
        S_CAP: begin
          phase <= A7NG_C5K_PH_CAPTURE;
          wbeat <= pack_hdr(seq + 16'd1, crc_lat);
          awv <= 1'b1;
          phase <= A7NG_C5K_PH_WRITE;
          st <= S_AW;
        end
        S_AW: begin
          phase <= A7NG_C5K_PH_WRITE;
          tocnt <= tocnt + 16'd1;
          if (awv && m_axi_awready) begin
            awv <= 1'b0;
            wv <= 1'b1;
            tocnt <= 16'd0;
            st <= S_W;
          end else if (tocnt >= A7NG_C5K_TO[15:0]) begin
            fail <= A7NG_C5K_F_TO; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
          end
        end
        S_W: begin
          phase <= A7NG_C5K_PH_WRITE;
          tocnt <= tocnt + 16'd1;
          if (wv && m_axi_wready) begin
            wv <= 1'b0;
            tocnt <= 16'd0;
            st <= S_B;
          end else if (tocnt >= A7NG_C5K_TO[15:0]) begin
            fail <= A7NG_C5K_F_TO; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
          end
        end
        S_B: begin
          phase <= A7NG_C5K_PH_WAITB;
          tocnt <= tocnt + 16'd1;
          if (m_axi_bvalid) begin
            tocnt <= 16'd0;
            if (m_axi_bresp != 2'b00) begin
              fail <= A7NG_C5K_F_BRESP; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
            end else if (beat == 3'd5) begin
              seq <= seq + 16'd1;
              persisted <= 1'b1;
              phase <= A7NG_C5K_PH_PERSISTED;
              st <= S_HOLD;
            end else begin
              beat <= beat + 3'd1;
              unique case (beat + 3'd1)
                3'd1: wbeat <= pack8(0);
                3'd2: wbeat <= pack8(8);
                3'd3: wbeat <= pack8(16);
                3'd4: wbeat <= pack8(24);
                default: wbeat <= pack_mark(seq + 16'd1, crc_lat);
              endcase
              awv <= 1'b1;
              st <= S_AW;
            end
          end else if (tocnt >= A7NG_C5K_TO[15:0]) begin
            fail <= A7NG_C5K_F_TO; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
          end
        end
        S_HOLD: begin
          phase <= persisted ? A7NG_C5K_PH_PERSISTED : A7NG_C5K_PH_READY;
          if (retire_i) begin
            persisted <= 1'b0;
            restored <= 1'b0;
            st <= S_IDLE;
          end
        end
        S_AR: begin
          phase <= A7NG_C5K_PH_READ;
          if (!arv) arv <= 1'b1;
          tocnt <= tocnt + 16'd1;
          if (arv && m_axi_arready) begin
            arv <= 1'b0;
            tocnt <= 16'd0;
            st <= S_R;
          end else if (tocnt >= A7NG_C5K_TO[15:0]) begin
            fail <= A7NG_C5K_F_TO; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
          end
        end
        S_R: begin
          phase <= A7NG_C5K_PH_READ;
          tocnt <= tocnt + 16'd1;
          if (m_axi_rvalid && m_axi_rlast) begin
            tocnt <= 16'd0;
            if (m_axi_rresp != 2'b00) begin
              fail <= A7NG_C5K_F_RRESP; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
            end else begin
              unique case (beat)
                3'd0: begin
                  if (m_axi_rdata[15:0] != A7NG_C5K_MAGIC) begin
                    fail <= A7NG_C5K_F_MAGIC; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
                  end else if ((m_axi_rdata[23:16] != A7NG_C5K_VER) ||
                               (m_axi_rdata[31:24] != A7NG_C5K_SCHEMA) ||
                               (m_axi_rdata[71:64] != A7NG_C5K_NW) ||
                               !m_axi_rdata[120]) begin
                    fail <= A7NG_C5K_F_SCHEMA; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
                  end else begin
                    crc_rd <= m_axi_rdata[95:80];
                    beat <= 3'd1;
                    st <= S_AR;
                  end
                end
                3'd1: begin
                  sh[0] <= m_axi_rdata[15:0]; sh[1] <= m_axi_rdata[31:16];
                  sh[2] <= m_axi_rdata[47:32]; sh[3] <= m_axi_rdata[63:48];
                  sh[4] <= m_axi_rdata[79:64]; sh[5] <= m_axi_rdata[95:80];
                  sh[6] <= m_axi_rdata[111:96]; sh[7] <= m_axi_rdata[127:112];
                  beat <= 3'd2; st <= S_AR;
                end
                3'd2: begin
                  sh[8] <= m_axi_rdata[15:0]; sh[9] <= m_axi_rdata[31:16];
                  sh[10] <= m_axi_rdata[47:32]; sh[11] <= m_axi_rdata[63:48];
                  sh[12] <= m_axi_rdata[79:64]; sh[13] <= m_axi_rdata[95:80];
                  sh[14] <= m_axi_rdata[111:96]; sh[15] <= m_axi_rdata[127:112];
                  beat <= 3'd3; st <= S_AR;
                end
                3'd3: begin
                  sh[16] <= m_axi_rdata[15:0]; sh[17] <= m_axi_rdata[31:16];
                  sh[18] <= m_axi_rdata[47:32]; sh[19] <= m_axi_rdata[63:48];
                  sh[20] <= m_axi_rdata[79:64]; sh[21] <= m_axi_rdata[95:80];
                  sh[22] <= m_axi_rdata[111:96]; sh[23] <= m_axi_rdata[127:112];
                  beat <= 3'd4; st <= S_AR;
                end
                3'd4: begin
                  sh[24] <= m_axi_rdata[15:0]; sh[25] <= m_axi_rdata[31:16];
                  sh[26] <= m_axi_rdata[47:32]; sh[27] <= m_axi_rdata[63:48];
                  sh[28] <= m_axi_rdata[79:64]; sh[29] <= m_axi_rdata[95:80];
                  sh[30] <= m_axi_rdata[111:96]; sh[31] <= m_axi_rdata[127:112];
                  beat <= 3'd5; st <= S_AR;
                end
                default: begin
                  if ((m_axi_rdata[15:0] != A7NG_C5K_MAGIC) || !m_axi_rdata[127]) begin
                    fail <= A7NG_C5K_F_COMMIT; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
                  end else st <= S_CHK;
                end
              endcase
            end
          end else if (tocnt >= A7NG_C5K_TO[15:0]) begin
            fail <= A7NG_C5K_F_TO; phase <= A7NG_C5K_PH_FAILED; st <= S_FAIL;
          end
        end
        S_CHK: begin
          for (kf = 0; kf < 32; kf = kf + 1) cap[kf] <= sh[kf];
          phase <= A7NG_C5K_PH_LOAD;
          st <= S_CRC;
        end
        S_CRC: begin
          if (crc_lat != crc_rd) begin
            fail <= A7NG_C5K_F_CRC;
            phase <= A7NG_C5K_PH_FAILED;
            st <= S_FAIL;
          end else begin
            li <= 5'd0;
            st <= S_LD;
          end
        end
        S_LD: begin
          phase <= A7NG_C5K_PH_LOAD;
          if (li == 5'd31) begin
            restored <= 1'b1;
            phase <= A7NG_C5K_PH_READY;
            st <= S_HOLD;
          end else li <= li + 5'd1;
        end
        S_FAIL: begin
          phase <= A7NG_C5K_PH_FAILED;
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
