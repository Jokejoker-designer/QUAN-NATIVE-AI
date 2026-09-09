`timescale 1ns / 1ps
// ASTRA-C4-COND-RNN-BYTE256-01. PROGRAM=NO.
// Named Elman BYTE256. Causality this-gate, not C4_MASTER / 90/95/5 close.
`include "a7ng_astra_c4_cond_rnn.svh"
module tb_astra_c4_cond_rnn_byte256;
  logic clk, rst_n, go, retire, evid_has, zero_w, busy, done, tok_v, eos;
  logic [7:0] seed, tok, n_out;
  logic [4:0] ctx_n;
  logic [7:0] ctx [0:15];
  logic [15:0] n_mac, n_host;
  logic [3:0] vver;
  int fail, guard, nt, i, k;
  int seqa [0:7], seqb [0:7], seqe [0:7], seqz [0:7], seqs [0:7];
  int na, nb, ne, nz, ns;
  string first_div;

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
  task automatic run_cap(
      input string s, input bit has, input logic [7:0] sd, input bit zw,
      output int ntok, output int cap [0:7]);
    begin
      plant_ctx(s);
      evid_has = has;
      seed = sd;
      zero_w = zw;
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
  function automatic bit seq_eq(input int n0, input int a [0:7],
                               input int n1, input int b [0:7]);
    int t; begin
      seq_eq = (n0 == n1);
      if (seq_eq) for (t = 0; t < n0; t = t + 1) if (a[t] !== b[t]) seq_eq = 1'b0;
    end
  endfunction

  initial begin
    fail = 0; first_div = "";
    rst_n = 0; go = 0; retire = 0; evid_has = 0; zero_w = 0; seed = 0; ctx_n = 0;
    for (i = 0; i < 16; i = i + 1) ctx[i] = 0;
    repeat (8) @(posedge clk); rst_n = 1; repeat (4) @(posedge clk);
    $display("C4_COND_RNN PROGRAM=NO BOARD_PASS=REJECT C4_MASTER=OPEN");
    $display("RIVAL=compact_recurrent_byte256 V=%0d E=%0d H=%0d N_W=%0d",
             A7NG_C4R_V, A7NG_C4R_E, A7NG_C4R_H, A7NG_C4R_N_W);

    run_cap("valve requires pump", 1'b1, 8'd0, 1'b0, na, seqa);
    $display("MEAS_A n=%0d mac=%0d t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d t5=%0d",
             na, n_mac, seqa[0], seqa[1], seqa[2], seqa[3], seqa[4], seqa[5]);
    chk("HOST0", n_host == 16'd0);
    if (n_host == 16'd0) $display("CLASS_host_tok0 HIT");
    else $display("CLASS_host_tok0 MISS n_host=%0d", n_host);
    chk("SEQ_GE3", na >= 3);
    if (na >= 3) $display("CLASS_seq_ge3 HIT n=%0d", na);
    else $display("CLASS_seq_ge3 MISS n=%0d", na);

    run_cap("valve requires pump", 1'b1, 8'h79, 1'b0, nb, seqb);
    $display("MEAS_B n=%0d t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d t5=%0d",
             nb, seqb[0], seqb[1], seqb[2], seqb[3], seqb[4], seqb[5]);
    chk("PREFIX_NE", !seq_eq(na, seqa, nb, seqb));
    if (!seq_eq(na, seqa, nb, seqb)) $display("CLASS_prefix_changes HIT");
    else $display("CLASS_prefix_changes MISS");

    run_cap("pump requires valve", 1'b1, 8'd0, 1'b0, ne, seqe);
    $display("MEAS_E n=%0d t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d t5=%0d",
             ne, seqe[0], seqe[1], seqe[2], seqe[3], seqe[4], seqe[5]);
    chk("EVID_NE", !seq_eq(na, seqa, ne, seqe));
    if (!seq_eq(na, seqa, ne, seqe)) $display("CLASS_evidence_changes HIT");
    else $display("CLASS_evidence_changes MISS");

    run_cap("valve requires pump", 1'b0, 8'd0, 1'b0, ns, seqs);
    $display("MEAS_SAFE n=%0d t0=%0d t1=%0d t2=%0d", ns, seqs[0], seqs[1], seqs[2]);
    chk("SAFE_NO", (ns == 3) && (seqs[0] == 110) && (seqs[1] == 111) && (seqs[2] == 0));
    if ((ns == 3) && (seqs[0] == 110) && (seqs[1] == 111) && (seqs[2] == 0))
      $display("CLASS_safe_no HIT");
    else $display("CLASS_safe_no MISS");

    run_cap("valve requires pump", 1'b1, 8'd0, 1'b1, nz, seqz);
    $display("MEAS_ZERO n=%0d t0=%0d", nz, seqz[0]);
    chk("ZERO_NE", !seq_eq(na, seqa, nz, seqz));
    if (!seq_eq(na, seqa, nz, seqz)) $display("CLASS_zero_changes HIT");
    else $display("CLASS_zero_changes MISS");

    if ((na == 6) && (seqa[0] == 201) && (seqa[1] == 5) && (seqa[2] == 84)
        && (seqa[3] == 84) && (seqa[4] == 84) && (seqa[5] == 84)
        && (nb == 6) && (seqb[2] == 109) && (ne == 6) && (seqe[0] == 247))
      $display("CLASS_ref_match HIT");
    else $display("CLASS_ref_match MISS");

    $display("CLASS_lang_90 MISS synthetic_elman_not_heldout_language");
    $display("CLASS_lang_safe95 MISS not_measured_on_heldout_corpus");
    $display("CLASS_lang_hall5 MISS not_measured_on_heldout_corpus");

    if (fail == 0) $display("ASTRA_C4_COND_RNN_BYTE256_XSIM_PASS");
    else $display("ASTRA_C4_COND_RNN_BYTE256_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C4_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO");
    $finish;
  end
endmodule
