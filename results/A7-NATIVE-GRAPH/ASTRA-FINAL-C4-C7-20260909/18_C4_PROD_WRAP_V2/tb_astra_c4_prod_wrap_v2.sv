`timescale 1ns / 1ps
// Gate + V2 materializer + D32 V2. PROGRAM=NO. Not C4_MASTER.
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c4_context_v2.svh"

module tb_astra_c4_prod_wrap_v2;
  logic clk, rst_n, go, retire, zero_w, busy, done, tok_v, eos, bank_sel, bank_out;
  logic pok, allow, mvalid, movf;
  logic [3:0] st, vver;
  logic [4:0] np;
  logic [7:0] sid, did, tok, n_out;
  logic [7:0] ctx [0:15];
  logic [15:0] n_host;
  logic [31:0] dict_sym [0:15];
  logic dict_hit [0:15];
  logic dict_ovf [0:15];
  int fail, guard, nt, i;
  int got [0:7];

  a7ng_astra_c4_prod_wrap_v2 u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .go_i(go),
    .retire_i(retire),
    .zero_w_i(zero_w),
    .c3_status_i(st),
    .c3_npath_i(np),
    .c3_proof_ok_i(pok),
    .bank_r_i(bank_sel),
    .proof_src_id_i(sid),
    .proof_dst_id_i(did),
    .dict_sym_i(dict_sym),
    .dict_hit_i(dict_hit),
    .dict_ovf_i(dict_ovf),
    .busy_o(busy),
    .done_o(done),
    .tok_valid_o(tok_v),
    .tok_o(tok),
    .eos_o(eos),
    .n_out_o(n_out),
    .n_host_tok_o(n_host),
    .bank_r_o(bank_out),
    .vocab_ver_o(vver),
    .answer_allowed_o(allow),
    .mat_valid_o(mvalid),
    .mat_ovf_o(movf),
    .ctx_o(ctx)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic retire_done;
    begin
      @(posedge clk);
      retire <= 1'b1;
      @(posedge clk);
      retire <= 1'b0;
      guard = 0;
      while (done && guard < 40) begin
        @(posedge clk);
        guard = guard + 1;
      end
    end
  endtask

  task automatic run_case(input string tag, input int exp_n, input int e0, input int e1, input int e2, input int e3, input int e4);
    begin
      nt = 0;
      for (i = 0; i < 8; i = i + 1) got[i] = 0;
      @(posedge clk);
      go <= 1'b1;
      @(posedge clk);
      go <= 1'b0;
      guard = 0;
      while (!done && guard < 2000000) begin
        @(posedge clk);
        guard = guard + 1;
        if (tok_v && nt < 8) begin
          got[nt] = tok;
          nt = nt + 1;
        end
      end
      if (!done) begin
        $display("FAIL %s TIMEOUT", tag);
        fail = fail + 1;
      end else if (nt != exp_n) begin
        $display("FAIL %s N exp=%0d got=%0d", tag, exp_n, nt);
        fail = fail + 1;
      end else if ((exp_n >= 1 && got[0] !== e0) || (exp_n >= 2 && got[1] !== e1) || (exp_n >= 3 && got[2] !== e2) || (exp_n >= 4 && got[3] !== e3) || (exp_n >= 5 && got[4] !== e4)) begin
        $display("FAIL %s TOK t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d", tag, got[0], got[1], got[2], got[3], got[4]);
        fail = fail + 1;
      end else $display("PASS %s n=%0d", tag, nt);
      retire_done();
    end
  endtask

  initial begin
    fail = 0;
    rst_n = 1'b0;
    go = 1'b0;
    retire = 1'b0;
    zero_w = 1'b0;
    st = A7NG_C3_ST_UNKNOWN;
    np = 5'd0;
    pok = 1'b0;
    bank_sel = 1'b0;
    sid = 8'd0;
    did = 8'd0;
    for (i = 0; i < 16; i = i + 1) begin
      dict_sym[i] = 32'd0;
      dict_hit[i] = 1'b0;
      dict_ovf[i] = 1'b0;
    end
    dict_hit[1] = 1'b1; dict_sym[1] = 32'h76656B70; // pkev
    dict_hit[2] = 1'b1; dict_sym[2] = 32'h68666974; // tifh
    dict_hit[3] = 1'b1; dict_sym[3] = 32'h68676D76; // vmgh
    dict_hit[4] = 1'b1; dict_sym[4] = 32'h766E6D70; // pmnv
    repeat (8) @(posedge clk);
    rst_n = 1'b1;
    repeat (4) @(posedge clk);
    $display("C4_PROD_WRAP_V2 PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN");
    if (n_host !== 16'd0) begin
      $display("FAIL HOST0");
      fail = fail + 1;
    end else $display("CLASS_host_tok0 HIT");

    st = A7NG_C3_ST_ANSWER; np = 5'd1; pok = 1'b1; bank_sel = 1'b0; sid = 8'd1; did = 8'd2;
    #1;
    if (!allow || !mvalid) begin
      $display("FAIL F_ALLOW allow=%0d valid=%0d", allow, mvalid);
      fail = fail + 1;
    end
    run_case("F_LEARNED", 5, 8'd116, 8'd105, 8'd102, 8'd104, 8'd0);

    bank_sel = 1'b1; sid = 8'd3; did = 8'd4;
    #1;
    if (!allow) begin
      $display("FAIL R_ALLOW");
      fail = fail + 1;
    end
    run_case("R_LEARNED", 5, 8'd118, 8'd109, 8'd103, 8'd104, 8'd0);

    st = A7NG_C3_ST_UNKNOWN; bank_sel = 1'b0; sid = 8'd1; did = 8'd2;
    #1;
    if (allow) begin
      $display("FAIL UNK_STILL_ALLOWED");
      fail = fail + 1;
    end
    run_case("UNK_SAFE", 3, 8'h6E, 8'h6F, 8'd0, 8'd0, 8'd0);

    st = A7NG_C3_ST_ANSWER; pok = 1'b1; np = 5'd1; sid = 8'd9; did = 8'd2;
    #1;
    if (allow || !movf) begin
      $display("FAIL OVF_GATE allow=%0d ovf=%0d", allow, movf);
      fail = fail + 1;
    end
    run_case("OVF_SAFE", 3, 8'h6E, 8'h6F, 8'd0, 8'd0, 8'd0);

    if (fail == 0) begin
      $display("CLASS_ref_match HIT");
      $display("ASTRA_C4_PROD_WRAP_V2_XSIM_PASS");
    end else begin
      $display("CLASS_ref_match MISS");
      $display("ASTRA_C4_PROD_WRAP_V2_XSIM_FAIL n=%0d", fail);
    end
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO");
    $finish;
  end
endmodule
