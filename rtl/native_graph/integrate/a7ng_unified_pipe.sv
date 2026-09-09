// a7ng_unified_pipe.sv — ASTRA-09 OOC-sized path: tokens → role packet → 2-hop → rank. PROGRAM=NO.
// Sparse AXI walker is wired on the exam path in a7ng_astra09_pipe.sv (SPARSE09_GLUE).
// Host does not drive subject/object/winner. LM06 language OPEN.
`timescale 1ns / 1ps

module a7ng_unified_pipe (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        tok_valid_i,
  output logic        tok_ready_o,
  input  logic [7:0]  tok_i,
  input  logic        fire_i,
  input  logic        retire_i,
  input  logic        load_v,
  input  logic [3:0]  load_idx,
  input  logic [7:0]  load_s,
  input  logic [7:0]  load_r,
  input  logic [7:0]  load_o,
  input  logic [7:0]  load_eid,
  input  logic        load_trans,
  input  logic        go_i,
  output logic        ready_o,
  output logic        done_o,
  output logic [7:0]  subj_o,
  output logic [7:0]  obj_o,
  output logic [7:0]  rel_o,
  output logic        triple_valid_o,
  output logic [15:0] n_host_o,
  output logic [7:0]  ans_o,
  output logic [7:0]  proof0_o,
  output logic [7:0]  proof1_o,
  output logic [2:0]  status_o,
  output logic signed [15:0] v_q8_o
);
  typedef enum logic [2:0] { P_IDLE, P_WAITP, P_ISSUE, P_WAIT2, P_SCORE, P_DONE } pst_t;
  pst_t pst;

  logic p_valid, p_busy, p_acc, p_neg, p_amb, trip;
  logic [1:0] p_dir, nhyp;
  logic [7:0] sid, oid, rid, xid;
  logic [15:0] k0, k1, k2, k3, crc;
  logic v0, v1, v2, v3;
  logic [3:0] vmask;
  logic [63:0] sc, oc, rc, xc;
  logic [15:0] h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10;
  logic hop_rdy, hop_ans, hop_qv;
  logic [7:0] hop_a, hop_p0, hop_p1;
  logic [2:0] hop_st;
  logic sgd_rdy, sgd_done, sgd_go;
  logic signed [7:0] xf [0:31];
  integer fi;

  a7ng_query_role_extract u_parse (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(tok_valid_i), .tok_ready_o(tok_ready_o), .tok_i(tok_i),
    .fire_i(fire_i), .retire_i(retire_i),
    .busy_o(p_busy), .accepted_o(p_acc), .valid_o(p_valid),
    .subj_id_o(sid), .obj_id_o(oid), .rel_id_o(rid), .ctx_id_o(xid),
    .direction_o(p_dir), .negation_o(p_neg), .ambiguity_o(p_amb),
    .triple_valid_o(trip), .n_hyp_o(nhyp),
    .subj_cue_o(sc), .obj_cue_o(oc), .rel_cue_o(rc), .ctx_cue_o(xc),
    .crc16_dbg_o(crc), .k0_o(k0), .k1_o(k1), .k2_o(k2), .k3_o(k3),
    .k0_valid_o(v0), .k1_valid_o(v1), .k2_valid_o(v2), .k3_valid_o(v3),
    .valid_mask_o(vmask),
    .n_host_entity_o(h0), .n_host_intent_o(h1), .n_host_hash_o(h2),
    .n_host_shard_o(h3), .n_host_bucket_o(h4), .n_host_cand_o(h5),
    .n_host_winner_o(h6), .n_host_addr_o(h7), .n_host_relpath_o(h8),
    .n_host_next_o(h9), .n_host_answer_o(h10)
  );

  a7ng_rel_engine_2hop #(.N_EDGES(16), .ID_W(8)) u_hop (
    .clk(clk), .rst_n(rst_n),
    .load_v(load_v), .load_idx(load_idx),
    .load_s(load_s), .load_r(load_r), .load_o(load_o), .load_eid(load_eid),
    .load_trans(load_trans), .load_pol(1'b1),
    .clr_v(1'b0), .clr_idx(4'd0),
    .q_v(hop_qv), .q_s(sid), .q_r(rid), .q_o(8'd0),
    .q_obj_valid(1'b0), .q_two_hop(1'b1),
    .q_budget(8'd0), .q_max_hop(4'd0),
    .q_ready(hop_rdy), .ans_v(hop_ans), .ans_o(hop_a),
    .proof0(hop_p0), .proof1(hop_p1), .status_o(hop_st), .scan_used_o()
  );

  a7ng_shared_rank_sgd_q8 u_rank (
    .clk(clk), .rst_n(rst_n), .freeze_i(1'b1),
    .go_score_i(sgd_go), .go_upd_i(1'b0), .x_i(xf), .reward_i(3'sd0),
    .ready_o(sgd_rdy), .done_o(sgd_done), .v_q8_o(v_q8_o)
  );

  assign n_host_o = h0|h1|h2|h3|h4|h5|h6|h7|h8|h9|h10;
  assign ready_o  = (pst == P_IDLE) && hop_rdy;
  assign subj_o   = sid;
  assign obj_o    = oid;
  assign rel_o    = rid;
  assign triple_valid_o = trip;

  always_comb begin
    for (fi = 0; fi < 32; fi = fi + 1)
      xf[fi] = 8'sd0;
    xf[0] = trip ? 8'sd64 : 8'sd0;
    xf[1] = (status_o == 3'd0) ? 8'sd64 : 8'sd0;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pst <= P_IDLE;
      hop_qv <= 1'b0;
      sgd_go <= 1'b0;
      done_o <= 1'b0;
      ans_o <= '0; proof0_o <= '0; proof1_o <= '0; status_o <= 3'd1;
    end else begin
      hop_qv <= 1'b0;
      sgd_go <= 1'b0;
      done_o <= 1'b0;
      unique case (pst)
        P_IDLE: begin
          if (go_i && p_valid)
            pst <= P_WAITP;
        end
        P_WAITP: begin
          if (!trip) begin
            status_o <= 3'd1;
            ans_o <= '0; proof0_o <= '0; proof1_o <= '0;
            pst <= P_SCORE;
          end else if (hop_rdy)
            pst <= P_ISSUE;
        end
        P_ISSUE: begin
          hop_qv <= 1'b1;
          pst <= P_WAIT2;
        end
        P_WAIT2: begin
          if (hop_ans) begin
            ans_o <= hop_a;
            proof0_o <= hop_p0;
            proof1_o <= hop_p1;
            status_o <= hop_st;
            pst <= P_SCORE;
          end
        end
        P_SCORE: begin
          if (sgd_rdy)
            sgd_go <= 1'b1;
          if (sgd_done)
            pst <= P_DONE;
        end
        P_DONE: begin
          done_o <= 1'b1;
          pst <= P_IDLE;
        end
        default: pst <= P_IDLE;
      endcase
    end
  end
endmodule
