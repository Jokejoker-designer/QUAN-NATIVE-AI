`timescale 1ns / 1ps
// ASTRA-C4-COND-RNN-LANG-01. PROGRAM=NO. Language measurement on rival-1 DUT.
// Does not edit a7ng_astra_c4_cond_rnn.sv. Trained hex is bag-local.
`include "a7ng_astra_c4_cond_rnn.svh"
module tb_astra_c4_cond_rnn_lang;
`include "tb_heldout.svh"
  logic clk, rst_n, go, retire, evid_has, zero_w, busy, done, tok_v, eos;
  logic [7:0] seed, tok, n_out;
  logic [4:0] ctx_n;
  logic [7:0] ctx [0:15];
  logic [15:0] n_mac, n_host;
  logic [3:0] vver;
  int fail, guard, nt, i, k, gi, ok_g, hall_u, ok_s, ntok;
  int cap [0:7];
  string first_div, sctx, sans, got;
  bit prefix_ok;

  a7ng_astra_c4_cond_rnn u_dut (
    .clk(clk), .rst_n(rst_n), .go_i(go), .retire_i(retire),
    .evid_has_i(evid_has), .zero_w_i(zero_w), .seed_tok_i(seed),
    .ctx_n_i(ctx_n), .ctx_i(ctx),
    .busy_o(busy), .done_o(done), .tok_valid_o(tok_v), .tok_o(tok), .eos_o(eos),
    .n_out_o(n_out), .n_mac_o(n_mac), .n_host_tok_o(n_host), .vocab_ver_o(vver)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic plant_ctx(input string s);
    begin
      ctx_n = (s.len() > 16) ? 5'd16 : 5'(s.len());
      for (i = 0; i < 16; i = i + 1)
        ctx[i] = (i < s.len() && i < 16) ? s[i] : 8'd0;
    end
  endtask
  task automatic run_cap(input string s, input bit has);
    begin
      plant_ctx(s);
      evid_has = has;
      seed = 8'd0;
      zero_w = 1'b0;
      ntok = 0;
      for (k = 0; k < 8; k = k + 1) cap[k] = 0;
      @(posedge clk); go <= 1'b1; @(posedge clk); go <= 1'b0;
      guard = 0;
      while (!done && guard < 200000) begin
        @(posedge clk);
        guard = guard + 1;
        if (tok_v && ntok < 8) begin
          cap[ntok] = tok;
          ntok = ntok + 1;
        end
      end
      chk("NO_TIMEOUT", done && guard < 200000);
      @(posedge clk); retire <= 1'b1; @(posedge clk); retire <= 1'b0;
      guard = 0;
      while (done && guard < 40) begin @(posedge clk); guard = guard + 1; end
    end
  endtask
  function automatic string body_of();
    string t; int j; byte unsigned ch; begin
      t = "";
      for (j = 0; j < ntok; j = j + 1) begin
        if (cap[j] == 0) return t;
        if (cap[j] >= 32 && cap[j] <= 126) begin
          ch = cap[j][7:0];
          t = {t, ch};
        end
      end
      return t;
    end
  endfunction

  initial begin
    fail = 0; first_div = ""; ok_g = 0; hall_u = 0; ok_s = 0;
    rst_n = 0; go = 0; retire = 0; evid_has = 0; zero_w = 0; seed = 0; ctx_n = 0;
    for (i = 0; i < 16; i = i + 1) ctx[i] = 0;
    repeat (8) @(posedge clk); rst_n = 1; repeat (4) @(posedge clk);
    $display("C4_COND_RNN_LANG PROGRAM=NO BOARD_PASS=REJECT C4_MASTER=OPEN");
    $display("DUT=a7ng_astra_c4_cond_rnn unedited HEX=bag_local_trained");

    for (gi = 0; gi < int'(C4L_NG); gi = gi + 1) begin
      sctx = c4l_gctx(gi[31:0]);
      sans = c4l_gans(gi[31:0]);
      run_cap(sctx, 1'b1);
      got = body_of();
      prefix_ok = (got.len() >= sans.len());
      if (prefix_ok) for (k = 0; k < sans.len(); k = k + 1)
        if (got[k] != sans[k]) prefix_ok = 1'b0;
      if (prefix_ok) ok_g = ok_g + 1;
      $display("MEAS_G i=%0d ctx=%s ans=%s got=%s hit=%0d ntok=%0d t0=%0d",
               gi, sctx, sans, got, prefix_ok, ntok, cap[0]);
      chk("HOST0", n_host == 16'd0);
    end

    for (gi = 0; gi < int'(C4L_NU); gi = gi + 1) begin
      sctx = c4l_uctx(gi[31:0]);
      run_cap(sctx, 1'b1);
      got = body_of();
      if (!(got == "no" || got == "n" || got == "")) hall_u = hall_u + 1;
      $display("MEAS_U i=%0d ctx=%s got=%s hall=%0d", gi, sctx, got,
               !(got == "no" || got == "n" || got == ""));
    end

    for (gi = 0; gi < 20; gi = gi + 1) begin
      run_cap(c4l_gctx(0), 1'b0);
      if ((ntok == 3) && (cap[0] == 110) && (cap[1] == 111) && (cap[2] == 0))
        ok_s = ok_s + 1;
    end

    $display("MEAS_LANG ok_g=%0d / %0d hall_u=%0d / %0d ok_s=%0d / 20",
             ok_g, C4L_NG, hall_u, C4L_NU, ok_s);
    if (ok_g * 100 >= 90 * int'(C4L_NG)) $display("CLASS_lang_90 HIT ok=%0d n=%0d", ok_g, C4L_NG);
    else $display("CLASS_lang_90 MISS ok=%0d n=%0d", ok_g, C4L_NG);
    if (ok_s * 100 >= 95 * 20) $display("CLASS_lang_safe95 HIT ok=%0d / 20", ok_s);
    else $display("CLASS_lang_safe95 MISS ok=%0d / 20", ok_s);
    if (hall_u * 100 <= 5 * int'(C4L_NU)) $display("CLASS_lang_hall5 HIT hall=%0d n=%0d", hall_u, C4L_NU);
    else $display("CLASS_lang_hall5 MISS hall=%0d n=%0d", hall_u, C4L_NU);
    if (ok_s == 20) $display("CLASS_safe_no HIT");
    else $display("CLASS_safe_no MISS ok_s=%0d", ok_s);
    if (n_host == 16'd0) $display("CLASS_host_tok0 HIT");
    else $display("CLASS_host_tok0 MISS");

    if (fail == 0) $display("ASTRA_C4_COND_RNN_LANG_XSIM_PASS");
    else $display("ASTRA_C4_COND_RNN_LANG_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO LM06_BYTE256=NOT_FROZEN");
    $finish;
  end
endmodule
