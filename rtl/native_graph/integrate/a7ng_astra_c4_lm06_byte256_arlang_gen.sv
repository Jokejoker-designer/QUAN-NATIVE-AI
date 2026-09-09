// a7ng_astra_c4_lm06_byte256_arlang_gen.sv — ASTRA-C4-LM06-BYTE256-ARLANG-01.
// PROGRAM=NO. Compact tied-embed AR: tok = argmax_v E[v]·h, h from last+B[step]+gated proof bytes.
// New bag-local hex. Does not edit TinyGPT / a7lm06_wmem.hex / qptext_gen / KEEP / C3 wrap.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_byte256.svh"
`include "a7ng_astra_c4_lm06_byte256_arlang.svh"

module a7ng_astra_c4_lm06_byte256_arlang_gen (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic        load_v_i,
  input  logic [1:0]  load_sel_i,
  input  logic signed [15:0] load_w_i,
  input  logic [7:0]  q0_i,
  input  logic [7:0]  e0_i,
  input  logic [7:0]  obj0_i,
  input  logic [7:0]  obj1_i,
  input  logic [7:0]  obj2_i,
  input  logic        evid_has_i,
  output logic        busy_o,
  output logic        done_o,
  output logic        tok_valid_o,
  output logic [7:0]  tok_o,
  output logic        eos_o,
  output logic [9:0]  head10_o,
  output logic        masked_hi_o,
  output logic [15:0] n_host_tok_o,
  output logic [7:0]  n_out_o,
  output logic [7:0]  mat_q0_o,
  output logic [7:0]  mat_p0_o,
  output logic [3:0]  vocab_ver_o
);
  typedef enum logic [2:0] { S_IDLE, S_H, S_SCAN, S_GO256, S_WAIT256, S_EMIT, S_DONE } st_t;
  st_t st;

  logic signed [7:0] wmem [0:A7NG_C4L_W_N-1];
  logic              zflag, cflag;
  logic [7:0]        last_tok, step, n_out, o0, o1, o2, q0, e0;
  logic              evid_has;
  logic signed [7:0] h [0:A7NG_C4L_D-1];
  logic [5:0]        di;
  logic [8:0]        vi;
  logic [9:0]        best_id;
  logic signed [15:0] best_sc;
  logic signed [31:0] acc, acc_s;
  logic signed [15:0] acc_h;
  logic [2:0]        s3;
  integer k;

  logic b_go, b_ret, b_busy, b_done, b_valid, b_mask, b_eos, b_phys;
  logic [7:0] b_in, b_out, b_feed;
  logic [9:0] b_head;
  logic [15:0] b_nhost;
  logic [4:0] b_iw, b_ow, b_hw;
  logic [9:0] cid [0:3];
  logic signed [15:0] csc [0:3];

  initial $readmemh("a7ng_astra_c4_lm06_byte256_arlang.hex", wmem);

  function automatic logic signed [7:0] Ee(input logic [7:0] v, input logic [4:0] d);
    begin
      Ee = zflag ? 8'sd0 : wmem[{v, d}];
    end
  endfunction
  function automatic logic signed [7:0] Bb(input logic [2:0] s, input logic [4:0] d);
    begin
      Bb = zflag ? 8'sd0 : wmem[A7NG_C4L_W_E + {s, d}];
    end
  endfunction
  function automatic logic signed [7:0] Gg(input logic [2:0] s, input logic [1:0] kix);
    begin
      Gg = zflag ? 8'sd0 : wmem[A7NG_C4L_W_E + A7NG_C4L_W_B + (s * 3) + kix];
    end
  endfunction
  function automatic logic signed [7:0] cl8(input logic signed [15:0] x);
    begin
      if (x > 16'sd127) cl8 = 8'sd127;
      else if (x < -16'sd127) cl8 = -8'sd127;
      else cl8 = x[7:0];
    end
  endfunction
  function automatic logic signed [15:0] sx8(input logic signed [7:0] x);
    begin
      sx8 = {{8{x[7]}}, x};
    end
  endfunction

  a7ng_astra_c4_lm06_byte256 u_b256 (
    .clk(clk), .rst_n(rst_n), .go_i(b_go), .retire_i(b_ret),
    .in_tok_i(b_in), .cand_id_i(cid), .cand_sc_i(csc),
    .busy_o(b_busy), .done_o(b_done),
    .head10_o(b_head), .out_tok_o(b_out), .out_valid_o(b_valid),
    .masked_hi_o(b_mask), .eos_o(b_eos), .feed_tok_o(b_feed),
    .n_host_tok_o(b_nhost), .in_w_o(b_iw), .out_w_o(b_ow), .head_w_o(b_hw),
    .phys_head_present_o(b_phys)
  );

  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign n_host_tok_o = 16'd0;
  assign n_out_o = n_out;
  assign head10_o = b_head;
  assign masked_hi_o = b_mask;
  assign mat_q0_o = q0;
  assign mat_p0_o = e0;
  assign vocab_ver_o = A7NG_C4L_VOCAB_VER;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      zflag <= 1'b0;
      cflag <= 1'b0;
      last_tok <= 8'd0; step <= 8'd0; n_out <= 8'd0;
      o0 <= 8'd0; o1 <= 8'd0; o2 <= 8'd0; q0 <= 8'd0; e0 <= 8'd0;
      evid_has <= 1'b0; di <= 6'd0; vi <= 9'd0;
      best_id <= 10'd0; best_sc <= 16'sd0; acc <= 16'sd0;
      tok_valid_o <= 1'b0; tok_o <= 8'd0; eos_o <= 1'b0;
      b_go <= 1'b0; b_ret <= 1'b0; b_in <= 8'd0;
      for (k = 0; k < A7NG_C4L_D; k = k + 1) h[k] <= 8'sd0;
      for (k = 0; k < 4; k = k + 1) begin cid[k] <= 10'd0; csc[k] <= 16'sd0; end
    end else begin
      tok_valid_o <= 1'b0;
      b_go <= 1'b0;
      b_ret <= 1'b0;
      if (load_v_i && (st == S_IDLE)) begin
        if (load_sel_i == A7NG_C4L_LD_ZERO) zflag <= (load_w_i != 16'sd0);
        if (load_sel_i == A7NG_C4L_LD_SCALE) cflag <= (load_w_i != 16'sd0);
      end
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            q0 <= q0_i; e0 <= e0_i;
            o0 <= obj0_i; o1 <= obj1_i; o2 <= obj2_i;
            evid_has <= evid_has_i;
            step <= 8'd0; n_out <= 8'd0; last_tok <= 8'd0;
            di <= 6'd0;
            st <= S_H;
          end
        end
        S_H: begin
          s3 = step[2:0];
          if ((!evid_has) || (step >= 8'd6))
            acc_h = Bb(3'd7, di[4:0]);
          else begin
            acc_h = sx8(cl8(sx8(Ee(last_tok, di[4:0])) + sx8(Bb(s3, di[4:0]))));
            if (Gg(s3, 2'd0) != 8'sd0)
              acc_h = sx8(cl8(acc_h + (sx8(Ee(o0, di[4:0])) <<< 2)));
            if (Gg(s3, 2'd1) != 8'sd0)
              acc_h = sx8(cl8(acc_h + (sx8(Ee(o1, di[4:0])) <<< 2)));
            if (Gg(s3, 2'd2) != 8'sd0)
              acc_h = sx8(cl8(acc_h + (sx8(Ee(o2, di[4:0])) <<< 2)));
          end
          h[di[4:0]] <= cl8(acc_h);
          if (di == 6'd31) begin
            di <= 6'd0; vi <= 9'd0; acc <= 16'sd0;
            best_id <= 10'd0; best_sc <= -16'sd32767;
            st <= S_SCAN;
          end else di <= di + 6'd1;
        end
        S_SCAN: begin
          acc_s = acc + (32'(sx8(Ee(vi[7:0], di[4:0]))) * 32'(sx8(h[di[4:0]])));
          if (di == 6'd31) begin
            acc_s = cflag ? -acc_s : acc_s;
            if ((vi == 9'd0) || ((acc_s >>> A7NG_C4L_SHIFT) > best_sc)) begin
              best_sc <= acc_s >>> A7NG_C4L_SHIFT;
              best_id <= {2'b00, vi[7:0]};
            end
            acc <= 16'sd0;
            di <= 6'd0;
            if (vi == 9'd255) begin
              cid[0] <= ((vi == 9'd0) || ((acc_s >>> A7NG_C4L_SHIFT) > best_sc))
                        ? {2'b00, vi[7:0]} : best_id;
              csc[0] <= 16'sd100;
              cid[1] <= 10'd0; csc[1] <= 16'sd0;
              cid[2] <= 10'd0; csc[2] <= 16'sd0;
              cid[3] <= 10'd0; csc[3] <= 16'sd0;
              b_in <= last_tok;
              st <= S_GO256;
            end else vi <= vi + 9'd1;
          end else begin
            acc <= acc_s;
            di <= di + 6'd1;
          end
        end
        S_GO256: begin
          b_go <= 1'b1;
          st <= S_WAIT256;
        end
        S_WAIT256: begin
          if (b_done) st <= S_EMIT;
        end
        S_EMIT: begin
          tok_valid_o <= b_valid;
          tok_o <= b_valid ? b_out : A7NG_C4L_EOS;
          eos_o <= (!b_valid) || b_eos || (b_out == A7NG_C4L_EOS);
          last_tok <= b_valid ? b_out : A7NG_C4L_EOS;
          n_out <= n_out + 8'd1;
          b_ret <= 1'b1;
          if ((!b_valid) || b_eos || (b_out == A7NG_C4L_EOS)
              || (n_out + 8'd1 >= A7NG_C4L_MAX_TOKENS[7:0]))
            st <= S_DONE;
          else begin
            step <= step + 8'd1;
            di <= 6'd0;
            st <= S_H;
          end
        end
        S_DONE: begin
          if (retire_i) st <= S_IDLE;
        end
        default: st <= S_IDLE;
      endcase
    end
  end
endmodule
