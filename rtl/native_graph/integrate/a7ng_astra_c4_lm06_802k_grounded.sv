// a7ng_astra_c4_lm06_802k_grounded.sv — ASTRA-C4-LM06-802K-GROUNDED-01. PROGRAM=NO.
// New named adapter. Instantiates frozen tiny_gpt803k_core (SIM_FULL) and
// BYTE256. Does not edit KEEP, tiny_gpt803k_core, a7lm06_pkg, BYTE256, or
// a7ng_evidence_compose. Host next-token = 0. Does not freeze LM06_BYTE256.
`timescale 1ns / 1ps
`include "a7ng_astra_c4_lm06_byte256.svh"
`include "a7ng_astra_c4_lm06_802k_grounded.svh"

module a7ng_astra_c4_lm06_802k_grounded (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        go_i,
  input  logic        retire_i,
  input  logic [7:0]  evid_obj_i,
  input  logic [7:0]  evid_rel_i,
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
  output logic        lm_busy_o,
  output logic [9:0]  pred_raw_o
);
  typedef enum logic [2:0] {
    S_IDLE, S_CTX, S_START, S_WAIT, S_BGO, S_BHOLD, S_DONE
  } st_t;
  st_t st;

  logic [7:0] evid_obj, evid_rel, last_tok, n_out, step;
  logic evid_has, saw_busy;
  logic [63:0] pack;

  logic mem_we;
  logic [19:0] mem_addr;
  logic signed [7:0] mem_wdata, mem_rdata;
  logic ctx_we;
  logic [6:0] ctx_idx, ctx_n_in;
  logic start_fwd, start_train, start_ce, start_corpus;
  logic after_mode, do_snap, do_restore, do_fold;
  logic [9:0] tgt_in, pred;
  logic [3:0] lr_in;
  logic [7:0] corpus_n, corpus_ep, phase;
  logic lm_busy, lm_done, w_stall;
  logic [15:0] last_loss;
  logic [31:0] ce0, ce1, wr_n, xor32, add32;

  logic b_go, b_ret, b_busy, b_done, b_valid, b_mask, b_eos, b_phys;
  logic [7:0] b_in, b_out, b_feed;
  logic [9:0] b_head;
  logic [15:0] b_nhost;
  logic [4:0] b_iw, b_ow, b_hw;
  logic [9:0] cid [0:3];
  logic signed [15:0] csc [0:3];
  integer k;

  function automatic logic [63:0] mat_pack(
      input logic [7:0] obj, input logic [7:0] rel, input logic has,
      input logic [7:0] fb, input logic [7:0] stp
  );
    begin
      mat_pack = {
        stp, fb, obj, A7NG_C4K_PMARK,
        A7NG_C4K_QMARK, (has ? 8'h01 : 8'h00), rel, obj
      };
    end
  endfunction

  tiny_gpt803k_core #(.SIM_FULL(1'b1)) u_lm (
    .clk(clk), .rst_n(rst_n),
    .mem_we(mem_we), .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_rdata(mem_rdata),
    .ctx_we(ctx_we), .ctx_idx(ctx_idx), .ctx_n_in(ctx_n_in), .ctx_pack(pack),
    .start_fwd(start_fwd), .start_train(start_train), .start_ce(start_ce),
    .start_corpus(start_corpus), .after_mode(after_mode),
    .do_snap(do_snap), .do_restore(do_restore), .do_fold(do_fold),
    .tgt_in(tgt_in), .lr_in(lr_in), .corpus_n(corpus_n), .corpus_ep(corpus_ep),
    .busy(lm_busy), .done(lm_done), .pred(pred), .last_loss(last_loss),
    .ce0(ce0), .ce1(ce1), .wr_n(wr_n), .xor32(xor32), .add32(add32),
    .phase(phase), .w_stall(w_stall),
    .clk_dma(clk), .rst_dma_n(rst_n)
  );

  a7ng_astra_c4_lm06_byte256 u_b256 (
    .clk(clk), .rst_n(rst_n), .go_i(b_go), .retire_i(b_ret),
    .in_tok_i(b_in), .cand_id_i(cid), .cand_sc_i(csc),
    .busy_o(b_busy), .done_o(b_done),
    .head10_o(b_head), .out_tok_o(b_out), .out_valid_o(b_valid),
    .masked_hi_o(b_mask), .eos_o(b_eos), .feed_tok_o(b_feed),
    .n_host_tok_o(b_nhost), .in_w_o(b_iw), .out_w_o(b_ow), .head_w_o(b_hw),
    .phys_head_present_o(b_phys)
  );

  assign mem_we = 1'b0;
  assign mem_addr = 20'd0;
  assign mem_wdata = 8'sd0;
  assign start_train = 1'b0;
  assign start_ce = 1'b0;
  assign start_corpus = 1'b0;
  assign after_mode = 1'b0;
  assign do_snap = 1'b0;
  assign do_restore = 1'b0;
  assign do_fold = 1'b0;
  assign tgt_in = 10'd0;
  assign lr_in = 4'd0;
  assign corpus_n = 8'd0;
  assign corpus_ep = 8'd0;
  assign ctx_idx = 7'd0;
  assign ctx_n_in = 7'd8;
  assign pack = mat_pack(evid_obj, evid_rel, evid_has, last_tok, step);
  assign b_in = last_tok;
  assign n_host_tok_o = 16'd0;
  assign busy_o = (st != S_IDLE) && (st != S_DONE);
  assign done_o = (st == S_DONE);
  assign n_out_o = n_out;
  assign head10_o = b_head;
  assign masked_hi_o = b_mask;
  assign lm_busy_o = lm_busy;
  assign pred_raw_o = pred;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      evid_obj <= 8'd0;
      evid_rel <= 8'd0;
      evid_has <= 1'b0;
      last_tok <= 8'd0;
      n_out <= 8'd0;
      step <= 8'd0;
      saw_busy <= 1'b0;
      tok_valid_o <= 1'b0;
      tok_o <= 8'd0;
      eos_o <= 1'b0;
      ctx_we <= 1'b0;
      start_fwd <= 1'b0;
      b_go <= 1'b0;
      b_ret <= 1'b0;
      for (k = 0; k < 4; k = k + 1) begin
        cid[k] <= 10'd0;
        csc[k] <= 16'sd0;
      end
    end else begin
      tok_valid_o <= 1'b0;
      ctx_we <= 1'b0;
      start_fwd <= 1'b0;
      b_go <= 1'b0;
      b_ret <= 1'b0;
      unique case (st)
        S_IDLE: begin
          eos_o <= 1'b0;
          if (go_i) begin
            evid_obj <= evid_obj_i;
            evid_rel <= evid_rel_i;
            evid_has <= evid_has_i;
            last_tok <= 8'd0;
            n_out <= 8'd0;
            step <= 8'd0;
            saw_busy <= 1'b0;
            st <= S_CTX;
          end
        end
        S_CTX: begin
          ctx_we <= 1'b1;
          st <= S_START;
        end
        S_START: begin
          start_fwd <= 1'b1;
          st <= S_WAIT;
        end
        S_WAIT: begin
          if (lm_busy) saw_busy <= 1'b1;
          if (saw_busy && lm_done) begin
            saw_busy <= 1'b0;
            st <= S_BGO;
          end
        end
        S_BGO: begin
          cid[0] <= pred;
          csc[0] <= 16'sd1;
          cid[1] <= 10'd0; csc[1] <= 16'sd0;
          cid[2] <= 10'd0; csc[2] <= 16'sd0;
          cid[3] <= 10'd0; csc[3] <= 16'sd0;
          b_go <= 1'b1;
          st <= S_BHOLD;
        end
        S_BHOLD: begin
          if (b_done) begin
            tok_valid_o <= 1'b1;
            if (b_mask) begin
              tok_o <= A7NG_C4K_EOS;
              eos_o <= 1'b1;
            end else begin
              tok_o <= b_out;
              eos_o <= b_eos;
            end
            last_tok <= b_mask ? A7NG_C4K_EOS : b_out;
            n_out <= n_out + 8'd1;
            step <= step + 8'd1;
            b_ret <= 1'b1;
            if (b_mask || b_eos || ((step + 8'd1) >= A7NG_C4K_MAX_TOKENS[7:0]))
              st <= S_DONE;
            else
              st <= S_CTX;
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
