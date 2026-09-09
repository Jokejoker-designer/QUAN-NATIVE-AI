// tb_astra03_role_parse.sv — qse-role-v1-00 vs qse-v1 control. PROGRAM=NO.
`timescale 1ns / 1ps

module tb_astra03_role_parse;
  import a7ng_pkg::*;
  `include "query_gold.svh"

  logic clk, rst_n, tok_v, tok_r, tok_r_q, fire, retire;
  logic busy, acc, valid, q_busy, q_acc, q_valid;
  logic [7:0] tok, subj, obj, rel, eid, iid, qrid, xid;
  logic [1:0] dir;
  logic neg, amb, sv, ov, rv;
  logic [15:0] n_host, k0, k1, k2, k3, crc;
  logic v0, v1, v2, v3;
  logic [63:0] ec, ic, rc, xc;
  logic [15:0] h_ent, h_int, h_hash, h_sh, h_bkt, h_cand, h_win, h_addr, h_rel, h_nxt, h_ans;

  integer qi, bi, fail, timeout;

  a7ng_query_role_parse dut (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(busy), .accepted_o(acc), .valid_o(valid),
    .subject_id_o(subj), .object_id_o(obj), .relation_id_o(rel),
    .direction_o(dir), .negation_o(neg), .ambiguous_o(amb),
    .subj_valid_o(sv), .obj_valid_o(ov), .rel_valid_o(rv),
    .n_host_any_o(n_host)
  );

  a7ng_query_struct_extract u_qse (
    .clk(clk), .rst_n(rst_n),
    .tok_valid_i(tok_v), .tok_ready_o(tok_r_q), .tok_i(tok),
    .fire_i(fire), .retire_i(retire),
    .busy_o(q_busy), .accepted_o(q_acc), .valid_o(q_valid),
    .entity_id_o(eid), .intent_id_o(iid), .relation_id_o(qrid), .context_id_o(xid),
    .entity_cue_o(ec), .intent_cue_o(ic), .relation_cue_o(rc), .context_cue_o(xc),
    .crc16_dbg_o(crc), .k0_o(k0), .k1_o(k1), .k2_o(k2), .k3_o(k3),
    .k0_valid_o(v0), .k1_valid_o(v1), .k2_valid_o(v2), .k3_valid_o(v3),
    .n_host_entity_o(h_ent), .n_host_intent_o(h_int), .n_host_hash_o(h_hash),
    .n_host_shard_o(h_sh), .n_host_bucket_o(h_bkt), .n_host_cand_o(h_cand),
    .n_host_winner_o(h_win), .n_host_addr_o(h_addr), .n_host_relpath_o(h_rel),
    .n_host_next_o(h_nxt), .n_host_answer_o(h_ans)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic diverge(input string code, input string d);
    begin
      $display("FIRST_DIVERGENCE %s %s", code, d);
      fail = fail + 1;
      #20 $finish;
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 0; tok_v = 0; tok = 0; fire = 0; retire = 0;
    repeat (8) @(posedge clk);
    rst_n = 1;
    repeat (4) @(posedge clk);

    for (qi = 0; qi < G_N_Q; qi = qi + 1) begin
      for (bi = 0; bi < G_LEN[qi]; bi = bi + 1) begin
        @(posedge clk);
        tok_v <= 1'b1;
        tok   <= G_BYTES[qi][8*bi +: 8];
        @(posedge clk);
        if (!tok_r || !tok_r_q)
          diverge("KEY_MISMATCH", $sformatf("q=%0d NOT_READY", qi));
        tok_v <= 1'b0;
      end
      @(posedge clk); fire <= 1'b1;
      @(posedge clk); fire <= 1'b0;
      timeout = 0;
      while (!valid) begin
        @(posedge clk);
        timeout = timeout + 1;
        if (timeout > 64) diverge("KEY_MISMATCH", $sformatf("q=%0d NO_VALID", qi));
      end
      if (n_host != 0)
        diverge("HOST_SEMANTIC_LEAK", $sformatf("q=%0d", qi));
      if (subj !== G_SUBJ[qi] || obj !== G_OBJ[qi] || rel !== G_REL[qi])
        diverge("PACKET_MISMATCH", $sformatf("q=%0d s=%0d o=%0d r=%0d", qi, subj, obj, rel));
      if (sv !== G_SV[qi] || ov !== G_OV[qi] || rv !== G_RV[qi])
        diverge("VALIDITY_MISMATCH", $sformatf("q=%0d", qi));
      if (neg !== G_NEG[qi] || amb !== G_AMB[qi])
        diverge("PACKET_MISMATCH", $sformatf("q=%0d neg/amb", qi));
      if (!q_valid)
        diverge("KEY_MISMATCH", $sformatf("q=%0d QSE_NO_VALID", qi));
      if (k0 !== G_QSE_K0[qi] || k1 !== G_QSE_K1[qi] || k2 !== G_QSE_K2[qi] || k3 !== G_QSE_K3[qi])
        diverge("CONTROL_QSE_MISMATCH", $sformatf("q=%0d", qi));
      $display("Q%0d ROLE s=%0d r=%0d o=%0d sv=%0d rv=%0d ov=%0d neg=%0d amb=%0d QSE %h %h %h %h",
        qi, subj, rel, obj, sv, rv, ov, neg, amb, k0, k1, k2, k3);
      @(posedge clk); retire <= 1'b1;
      @(posedge clk); retire <= 1'b0;
      @(posedge clk);
    end

    if (G_SUBJ[0] === G_SUBJ[1] && G_OBJ[0] === G_OBJ[1] && G_REL[0] === G_REL[1])
      diverge("R1_ROLE_COLLAPSE", "supplies pair identical");
    if (G_SUBJ[2] === G_SUBJ[3] && G_OBJ[2] === G_OBJ[3] && G_REL[2] === G_REL[3])
      diverge("R2_ROLE_COLLAPSE", "requires pair identical");
    if (G_QSE_K0[0] !== G_QSE_K0[1] || G_QSE_K1[0] !== G_QSE_K1[1] ||
        G_QSE_K2[0] !== G_QSE_K2[1] || G_QSE_K3[0] !== G_QSE_K3[1])
      diverge("R3_CONTROL", "qse-v1 supplies pair did not collapse");

    $display("ASTRA03_ROLE_PARSE_PASS");
    $display("LAW=qse-role-v1-00");
    $display("CONTROL=qse-v1-lexicon-hdc-00 COLLAPSE_CONFIRMED");
    $display("NOT_CLAIMED=open_nlu,2hop,board");
    #20 $finish;
  end
endmodule
