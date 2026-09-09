`timescale 1ns / 1ps
// 4-case C4 surface wrap. PROGRAM=NO. Not C4_MASTER.
// TB alias table is synthetic 20-bit keys. Production dictionary OPEN.
`include "a7ng_astra_c3_held_out.svh"
`include "a7ng_astra_c4_context_v2.svh"
`include "a7ng_astra_c4_entity_alias_v1.svh"

module tb_astra_c4_prod_wrap_v2;
  localparam int unsigned N = A7NG_C4_ALIAS_N_TB;
  localparam logic [19:0] K_SRC_F = 20'hA0001;
  localparam logic [19:0] K_DST_F = 20'hB0002;
  localparam logic [19:0] K_SRC_R = 20'hC0003;
  localparam logic [19:0] K_DST_R = 20'hD0004;
  localparam logic [19:0] K_COLL  = 20'h10001;

  logic clk, rst_n, go, retire, zero_w, busy, done, tok_v, eos, bank_sel, bank_out;
  logic pok, allow, mvalid, movf, aok, dknown;
  logic [3:0] st, vver;
  logic [4:0] np;
  logic [1:0] dir;
  logic [19:0] esrc, edst;
  logic [7:0] tok, n_out;
  logic [7:0] ctx [0:15];
  logic [15:0] n_host;
  logic [19:0] akey [0:N-1];
  logic [31:0] asym [0:N-1];
  logic aval [0:N-1];
  logic aovf [0:N-1];
  int fail, guard, nt, i;
  int got [0:7];

  a7ng_astra_c4_prod_wrap_v2 #(.ENT_W(20), .ALIAS_N(N)) u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .go_i(go),
    .retire_i(retire),
    .zero_w_i(zero_w),
    .c3_status_i(st),
    .c3_npath_i(np),
    .c3_proof_ok_i(pok),
    .direction_i(dir),
    .bank_r_i(bank_sel),
    .entity_src_i(esrc),
    .entity_dst_i(edst),
    .alias_key_i(akey),
    .alias_sym_i(asym),
    .alias_valid_i(aval),
    .alias_ovf_i(aovf),
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
    .alias_ok_o(aok),
    .dir_known_o(dknown),
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
    dir = A7NG_C4_DIR_SVO_AS_WRITTEN;
    bank_sel = 1'b0;
    esrc = 20'd0;
    edst = 20'd0;
    for (i = 0; i < N; i = i + 1) begin
      akey[i] = 20'd0;
      asym[i] = 32'd0;
      aval[i] = 1'b0;
      aovf[i] = 1'b0;
    end
    akey[0] = K_SRC_F; aval[0] = 1'b1; asym[0] = 32'h76656B70;
    akey[1] = K_DST_F; aval[1] = 1'b1; asym[1] = 32'h68666974;
    akey[2] = K_SRC_R; aval[2] = 1'b1; asym[2] = 32'h68676D76;
    akey[3] = K_DST_R; aval[3] = 1'b1; asym[3] = 32'h766E6D70;
    repeat (8) @(posedge clk);
    rst_n = 1'b1;
    repeat (4) @(posedge clk);
    $display("C4_PROD_WRAP_V2 PROGRAM=NO C4_MASTER=OPEN BOARD_PASS=OPEN");
    $display("ENTITY_ALIAS_V1 ENT_W=20 PROD_DICT=OPEN");
    if (n_host !== 16'd0) begin
      $display("FAIL HOST0");
      fail = fail + 1;
    end else $display("CLASS_host_tok0 HIT");

    st = A7NG_C3_ST_ANSWER; np = 5'd1; pok = 1'b1;
    dir = A7NG_C4_DIR_SVO_AS_WRITTEN; bank_sel = 1'b0;
    esrc = K_SRC_F; edst = K_DST_F;
    #1;
    if (!dknown) begin
      $display("FAIL DIR_KNOWN");
      fail = fail + 1;
    end
    if (!allow || !mvalid || !aok) begin
      $display("FAIL F_ALLOW allow=%0d valid=%0d alias=%0d", allow, mvalid, aok);
      fail = fail + 1;
    end
    run_case("F_LEARNED", 5, 8'd116, 8'd105, 8'd102, 8'd104, 8'd0);

    bank_sel = 1'b1; esrc = K_SRC_R; edst = K_DST_R;
    dir = A7NG_C4_DIR_SVO_AS_WRITTEN;
    #1;
    if (!allow) begin
      $display("FAIL R_ALLOW");
      fail = fail + 1;
    end
    if (dir !== A7NG_C4_DIR_SVO_AS_WRITTEN) begin
      $display("FAIL R_DIR_NOT_PARSER");
      fail = fail + 1;
    end
    run_case("R_LEARNED", 5, 8'd118, 8'd109, 8'd103, 8'd104, 8'd0);

    st = A7NG_C3_ST_UNKNOWN; pok = 1'b0; np = 5'd0;
    bank_sel = 1'b0; esrc = K_SRC_F; edst = K_DST_F;
    #1;
    if (allow) begin
      $display("FAIL UNK_STILL_ALLOWED");
      fail = fail + 1;
    end
    run_case("UNK_SAFE", 3, 8'h6E, 8'h6F, 8'd0, 8'd0, 8'd0);

    st = A7NG_C3_ST_ANSWER; pok = 1'b1; np = 5'd1;
    esrc = K_COLL; edst = K_DST_F;
    #1;
    if (K_COLL[7:0] !== K_SRC_F[7:0]) begin
      $display("FAIL TB_COLLIDE_SETUP");
      fail = fail + 1;
    end
    if (allow || aok || !movf) begin
      $display("FAIL ALIAS_MISS_8BIT_COLLIDE allow=%0d alias=%0d ovf=%0d", allow, aok, movf);
      fail = fail + 1;
    end else $display("PASS ALIAS_KEEP20 collide_lo8=0x%02h", K_COLL[7:0]);
    run_case("ALIAS_MISS_SAFE", 3, 8'h6E, 8'h6F, 8'd0, 8'd0, 8'd0);

    if (fail == 0) begin
      $display("CLASS_ref_match HIT");
      $display("ASTRA_C4_PROD_WRAP_V2_XSIM_PASS");
    end else begin
      $display("CLASS_ref_match MISS");
      $display("ASTRA_C4_PROD_WRAP_V2_XSIM_FAIL n=%0d", fail);
    end
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO C5_INTEGRATE=NO");
    $finish;
  end
endmodule
