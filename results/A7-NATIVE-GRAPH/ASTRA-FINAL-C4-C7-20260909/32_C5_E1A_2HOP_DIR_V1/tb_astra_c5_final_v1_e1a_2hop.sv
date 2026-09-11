`timescale 1ns / 1ps
// E1a 2-hop orientation: F KEEP S_EJ + inverse S_EJ. bank_r_i=0.
// Not C5_MASTER. Not BOARD. PROGRAM=NO.
`include "a7ng_astra_c5_prod_top_final_v1.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c3_held_out.svh"
`include "tb_oracles.svh"
module tb_astra_c5_final_v1_e1a_2hop;
  localparam int unsigned SIM_CLK_HZ = 8000;
  localparam int unsigned SIM_BAUD   = 800;
  localparam int CPB = (SIM_CLK_HZ + SIM_BAUD/2) / SIM_BAUD;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000;
  localparam logic [27:0] POST_HEAP  = 28'h0504_0000;
  localparam logic [27:0] FACT_BASE  = 28'h0580_0000;
  localparam logic [27:0] POST_1H    = POST_HEAP + 28'd32;
  localparam logic [27:0] POST_R2    = POST_HEAP + 28'd64;
  localparam int SLOTS = 96;
  localparam int E0 = 16;
  localparam int E1 = 17;
  localparam int E2 = 20;
  localparam int E3 = 21;
  localparam int MID = 32'h30;
  localparam int DST2 = 64;
  localparam int PUMP = C3_W_SUBJ[0];
  localparam int VALVE = 11;
  localparam int K0_1H = 16'h0A02;
  localparam int K1_1H = 16'h0B02;
  localparam int K1_2H = 16'h0B22;
  localparam logic [19:0] K_SRC = 20'(C3_W_SUBJ[0]);
  localparam logic [19:0] K_DST = 20'(VALVE);
  localparam logic [19:0] K_DST2 = 20'(DST2);
  localparam logic [31:0] SYM_SRC_R = 32'h68676D76;
  localparam logic [31:0] SYM_DST_F = 32'h68666974;
  localparam logic [31:0] SYM_DST2_F = 32'h64636261;

  logic clk, rst_n, urx, utx, bank_r;
  logic alias_wr_v, alias_wr_ovf;
  logic [2:0] alias_wr_idx;
  logic [19:0] alias_wr_key;
  logic [31:0] alias_wr_sym;
  initial clk = 0;
  always #5 clk = ~clk;

  logic arvalid, arready, rvalid, rready, rlast;
  logic [27:0] araddr, awaddr, last_aw;
  logic [127:0] rdata, wdata;
  logic [1:0] rresp, bresp, last_c3rr, last_br, last_ckrr;
  logic [3:0] rid, bid;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [15:0] wstrb;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pacc, c3busy, pvalid, gdone, phit, ehas;
  logic crest, cbusy, pok, allow, aok;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx, nupd, ndup, nbad;
  logic [15:0] nrok, ncrc, nsess, nrng, nfrz, nlen, nstr, novf;
  logic [3:0] c3st, pph, cfail;
  logic [7:0] c3obj, glast, txn, gen, gnout;
  logic [19:0] c3ans, c3p0, c3p1;
  logic signed [15:0] pw0;
  logic signed [15:0] cw [0:31];

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard, npin, t;
  logic [7:0] pinb [0:15];
  logic [3:0] cap_st;
  logic [19:0] cap_ans, cap_p0, cap_p1;
  logic cap_v, cap_pok, cap_allow, cap_aok;
  logic signed [15:0] w0_before;
  string first_div;
  typedef enum logic [2:0] { M_IDLE, M_R, M_W, M_B } mst_t;
  mst_t mst;

  function automatic integer slot_of(input logic [27:0] a);
    integer s; begin slot_of = -1; for (s = 0; s < SLOTS; s = s + 1) if (mvld[s] && mk[s] == a) slot_of = s; end
  endfunction
  function automatic logic [127:0] mem_rd(input logic [27:0] a);
    integer s; begin s = slot_of(a); mem_rd = (s >= 0) ? mv[s] : 128'd0; end
  endfunction
  task automatic mem_wr(input logic [27:0] a, input logic [127:0] d);
    integer s; begin s = slot_of(a); if (s < 0) begin s = nslot; nslot = nslot + 1; end mk[s] = a; mv[s] = d; mvld[s] = 1; end
  endtask
  function automatic logic [127:0] dir_pack(input int count, input logic [27:0] post);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, post};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0, conf[7:0], fctx[7:0], 4'd1, 1'b0, 1'b1, pol[0], trans[0],
                 e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction
  function automatic logic [27:0] fact_addr(input int e);
    fact_addr = FACT_BASE + (e << 4);
  endfunction
  function automatic logic [3:0] rid_of(input logic [27:0] a);
    rid_of = (a >= FACT_BASE) ? A7NG_C3_FACT_RID : 4'd1;
  endfunction

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rdata <= 0; rresp <= 0; rlast <= 0; rid <= 0;
      bvalid <= 0; bresp <= 0; bid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          rvalid <= 1'b1;
          rdata <= mem_rd(araddr);
          rresp <= A7NG_C5P_OKAY;
          rlast <= 1'b1;
          rid <= rid_of(araddr);
          mst <= M_R;
        end
      end
      M_R: if (rvalid && rready) begin rvalid <= 1'b0; mst <= M_IDLE; end
      M_W: if (wvalid && wready) begin
        mem_wr(awaddr, wdata);
        bvalid <= 1'b1;
        bresp <= A7NG_C5P_OKAY;
        bid <= 4'd1;
        mst <= M_B;
      end
      M_B: if (bvalid && bready) begin bvalid <= 1'b0; mst <= M_IDLE; end
      default: mst <= M_IDLE;
    endcase
  end

  a7ng_astra_c5_prod_top_final_v1 #(.CLK_HZ(SIM_CLK_HZ), .BAUD(SIM_BAUD)) u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .alias_wr_v_i(alias_wr_v), .alias_wr_idx_i(alias_wr_idx),
    .alias_wr_key_i(alias_wr_key), .alias_wr_sym_i(alias_wr_sym),
    .alias_wr_ovf_i(alias_wr_ovf), .bank_r_i(bank_r),
    .m_arvalid_o(arvalid), .m_araddr_o(araddr), .m_arready_i(arready),
    .m_rvalid_i(rvalid), .m_rdata_i(rdata), .m_rresp_i(rresp),
    .m_rlast_i(rlast), .m_rid_i(rid), .m_rready_o(rready),
    .m_awvalid_o(awvalid), .m_awaddr_o(awaddr), .m_awready_i(awready),
    .m_wvalid_o(wvalid), .m_wdata_o(wdata), .m_wlast_o(wlast), .m_wstrb_o(wstrb),
    .m_wready_i(wready),
    .m_bvalid_i(bvalid), .m_bresp_i(bresp), .m_bid_i(bid), .m_bready_o(bready),
    .busy_o(busy), .done_o(done),
    .seen_gnt_o(seen), .owner_o(owner), .dual_err_o(dual),
    .n_switch_o(nsw), .n_block_o(nblk),
    .n_host_winner_o(nhw), .n_host_tok_o(nht),
    .qid_map_o(qid), .a09_o(a09), .plant_dut_o(plant), .inst_mask_o(imask),
    .n_uart_rx_o(nurx), .n_uart_tx_o(nutx),
    .c3_status_o(c3st), .c3_obj_o(c3obj),
    .c3_ans_o(c3ans), .c3_p0_o(c3p0), .c3_p1_o(c3p1),
    .c3_result_v_o(c3res), .c3_pend_cmt_o(pcmt),
    .persist_valid_o(pvalid), .persist_w0_o(pw0), .persist_phase_o(pph),
    .gen_done_o(gdone), .gen_last_o(glast), .parser_hit_o(phit), .evid_has_o(ehas),
    .last_aw_o(last_aw),
    .c3_pend_acc_o(pacc), .c3_busy_o(c3busy),
    .c3_txn_o(txn), .c3_gen_o(gen),
    .c3_nupd_o(nupd), .c3_ndup_o(ndup), .c3_nbad_o(nbad),
    .c3_w_o(cw),
    .n_rew_ok_o(nrok), .n_rew_crc_o(ncrc), .n_rew_sess_o(nsess),
    .n_rew_range_o(nrng), .n_rew_frz_o(nfrz), .n_rew_len_o(nlen),
    .ckpt_restored_o(crest), .ckpt_busy_o(cbusy), .ckpt_fail_o(cfail),
    .n_stream_o(nstr), .n_fifo_ovf_o(novf), .gen_n_out_o(gnout),
    .last_c3_rresp_o(last_c3rr), .last_bresp_o(last_br), .last_ckpt_rresp_o(last_ckrr),
    .c3_proof_ok_o(pok), .answer_allowed_o(allow), .alias_ok_o(aok)
  );

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div == "") first_div = tag;
        $display("FAIL %s", tag); fail = fail + 1;
      end else $display("PASS %s", tag);
    end
  endtask
  task automatic uart_byte(input logic [7:0] d);
    integer b;
    begin
      urx = 1'b0; repeat (CPB) @(posedge clk);
      for (b = 0; b < 8; b = b + 1) begin
        urx = d[b]; repeat (CPB) @(posedge clk);
      end
      urx = 1'b1; repeat (CPB + 2) @(posedge clk);
    end
  endtask
  task automatic uart_str(input string s);
    integer u;
    begin
      for (u = 0; u < s.len(); u = u + 1) uart_byte(s[u]);
      uart_byte(A7NG_C5P_EOL);
    end
  endtask
  task automatic pin_byte(output logic [7:0] d, output bit ok);
    integer g, b;
    begin
      ok = 1'b0; d = 8'd0;
      g = 0;
      while (utx && (g < 2000000)) begin @(posedge clk); g = g + 1; end
      if (utx) return;
      repeat (CPB/2) @(posedge clk);
      for (b = 0; b < 8; b = b + 1) begin
        repeat (CPB) @(posedge clk);
        d[b] = utx;
      end
      repeat (CPB) @(posedge clk);
      ok = 1'b1;
    end
  endtask
  task automatic pin_line;
    logic [7:0] d;
    bit ok;
    integer g;
    begin
      npin = 0;
      g = 0;
      ok = 1'b1;
      while (ok && (g < 16)) begin
        pin_byte(d, ok);
        if (!ok) begin
          if (first_div == "") first_div = "PIN_TIMEOUT";
          $display("FAIL PIN_TIMEOUT"); fail = fail + 1;
          return;
        end
        if (d == A7NG_C5P_EOL) begin
          $display("MEAS_PIN_EOL n=%0d", npin);
          return;
        end
        if (npin < 16) pinb[npin] = d;
        npin = npin + 1;
        g = g + 1;
      end
      chk("PIN_NO_EOL", 1'b0);
    end
  endtask
  task automatic wait_until_done;
    begin
      cap_v = 0; cap_st = 4'hF; cap_ans = 20'd0; cap_p0 = 20'd0; cap_p1 = 20'd0; cap_pok = 0;
      cap_allow = 0; cap_aok = 0;
      guard = 0;
      while (!done && guard < 4000000) begin
        @(posedge clk);
        guard = guard + 1;
        if (c3res && !cap_v) begin
          cap_st = c3st; cap_ans = c3ans; cap_p0 = c3p0; cap_p1 = c3p1; cap_pok = pok; cap_v = 1'b1;
        end
        if (gdone) begin
          cap_allow = allow;
          cap_aok = aok;
        end
      end
      chk("NO_TIMEOUT", done && guard < 4000000);
    end
  endtask
  task automatic wait_next_done;
    begin
      guard = 0;
      while (done && guard < 80000) begin @(posedge clk); guard = guard + 1; end
      wait_until_done();
    end
  endtask
  task automatic one_query(input string q);
    integer t;
    begin
      fork
        pin_line();
        begin
          uart_str(q);
          wait_next_done();
        end
      join
      $display("MEAS_Q q=%s n_stream=%0d npin=%0d st=%0d ans=%0d p0=%0d p1=%0d pok=%0d allow=%0d aok=%0d nht=%0d nrok=%0d",
               q, nstr, npin, cap_st, cap_ans, cap_p0, cap_p1, cap_pok, cap_allow, cap_aok, nht, nrok);
      for (t = 0; t < npin; t = t + 1) $display("PIN[%0d]=%0d", t, pinb[t]);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(fact_addr(e), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_all;
    logic [127:0] b0, b1, b2;
    begin
      b0 = 32'd0; b0 = (b0 << 32) | 32'd0; b0 = (b0 << 32) | E1; b0 = (b0 << 32) | E0;
      mem_wr(POST_HEAP, b0);
      mem_wr(dir_addr(0, C3_W_K0[0]), dir_pack(2, POST_HEAP));
      mem_wr(dir_addr(1, C3_W_K1[0]), dir_pack(2, POST_HEAP));
      mem_wr(dir_addr(2, C3_W_K2[0]), dir_pack(2, POST_HEAP));
      wr_f(E0, C3_W_SUBJ[0], MID, C3_W_REL[0], C3_TR_CONF_W[0], 1, 1, C3_TR_CX1);
      wr_f(E1, MID, DST2, C3_W_REL[0], C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
      b1 = E2;
      mem_wr(POST_1H, b1);
      mem_wr(dir_addr(0, K0_1H), dir_pack(1, POST_1H));
      mem_wr(dir_addr(1, K1_1H), dir_pack(1, POST_1H));
      wr_f(E2, C3_W_SUBJ[0], VALVE, C3_W_REL[0], C3_TR_CONF_W[0], 0, 1, 0);
      b2 = 32'd0; b2 = (b2 << 32) | 32'd0; b2 = (b2 << 32) | E3; b2 = (b2 << 32) | E0;
      mem_wr(POST_R2, b2);
      mem_wr(dir_addr(1, K1_2H), dir_pack(2, POST_R2));
      wr_f(E3, MID, VALVE, C3_W_REL[0], C3_TR_CONF_W[0], 1, 1, 0);
    end
  endtask
  task automatic load_alias;
    begin
      @(posedge clk);
      alias_wr_v <= 1'b1;
      alias_wr_idx <= 3'd0;
      alias_wr_key <= K_SRC;
      alias_wr_sym <= SYM_SRC_R;
      alias_wr_ovf <= 1'b0;
      @(posedge clk);
      alias_wr_idx <= 3'd1;
      alias_wr_key <= K_DST;
      alias_wr_sym <= SYM_DST_F;
      @(posedge clk);
      alias_wr_idx <= 3'd2;
      alias_wr_key <= K_DST2;
      alias_wr_sym <= SYM_DST2_F;
      @(posedge clk);
      alias_wr_v <= 1'b0;
      @(posedge clk);
    end
  endtask
  task automatic chk_pin(input string tag, input int exp_n, input int e0, input int e1, input int e2, input int e3, input int e4);
    begin
      if (npin != exp_n) begin
        $display("FAIL %s N exp=%0d got=%0d", tag, exp_n, npin);
        if (first_div == "") first_div = tag;
        fail = fail + 1;
      end else if ((exp_n >= 1 && pinb[0] !== e0) || (exp_n >= 2 && pinb[1] !== e1) ||
                   (exp_n >= 3 && pinb[2] !== e2) || (exp_n >= 4 && pinb[3] !== e3) ||
                   (exp_n >= 5 && pinb[4] !== e4)) begin
        $display("FAIL %s TOK t0=%0d t1=%0d t2=%0d t3=%0d t4=%0d", tag, pinb[0], pinb[1], pinb[2], pinb[3], pinb[4]);
        if (first_div == "") first_div = tag;
        fail = fail + 1;
      end else $display("PASS %s n=%0d", tag, npin);
    end
  endtask

  initial begin
    fail = 0; first_div = ""; nslot = 0;
    urx = 1'b1; rst_n = 0; bank_r = 0;
    alias_wr_v = 0; alias_wr_idx = 0; alias_wr_key = 0; alias_wr_sym = 0; alias_wr_ovf = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_all();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_FINAL_V1_E1A_2HOP PROGRAM=NO C5_MASTER=OPEN BOARD_PASS=OPEN");
    $display("PROD_DICT=OPEN TB_ALIAS=SYNTHETIC_CONFIRM_V3_ON_C3_ENDPOINTS");
    $display("MEAS_BAUD CLK_HZ=%0d BAUD=%0d CPB=%0d SIM_OVERRIDE_8000_800=YES", SIM_CLK_HZ, SIM_BAUD, CPB);
    $display("E1A_2HOP F KEEP S_EJ + inverse S_EJ bank_r_i=0");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);
    w0_before = cw[0];

    load_alias();
    bank_r = 1'b0;
    one_query("pump requires valve");
    chk("F_C3_ANSWER", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == VALVE) && (cap_p0 == E2) && (cap_p1 == 20'd0) && cap_pok);
    chk("F_ALLOWED", cap_allow && cap_aok);
    chk_pin("F_LEARNED", 5, 8'd116, 8'd105, 8'd102, 8'd104, 8'd0);

    bank_r = 1'b0;
    one_query("what requires valve");
    chk("R_C3_ANSWER", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == PUMP) && (cap_p0 == E2) && (cap_p1 == 20'd0) && cap_pok);
    chk("R_ALLOWED", cap_allow && cap_aok);
    chk_pin("R_LEARNED", 5, 8'd118, 8'd109, 8'd103, 8'd104, 8'd0);

    bank_r = 1'b0;
    one_query("pump requires indirect");
    chk("F2H_C3", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == DST2) && (cap_p0 == E0) && (cap_p1 == E1) && cap_pok);
    chk("F2H_ALLOWED", cap_allow && cap_aok);
    chk("F2H_BANK_PIN0", bank_r === 1'b0);
    chk_pin("F2H_LEARNED", 5, 8'd97, 8'd98, 8'd99, 8'd100, 8'd0);

    bank_r = 1'b0;
    one_query("what requires valve indirectly");
    chk("R2H_C3", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == PUMP) && (cap_p0 == E0) && (cap_p1 == E3) && cap_pok);
    chk("R2H_ALLOWED", cap_allow && cap_aok);
    chk("R2H_BANK_PIN0", bank_r === 1'b0);
    chk_pin("R2H_LEARNED", 5, 8'd118, 8'd109, 8'd103, 8'd104, 8'd0);

    bank_r = 1'b0;
    one_query("what requires chiller");
    chk("UNK_NOT_ANSWER", cap_st != A7NG_C3_ST_ANSWER);
    chk("UNK_NOT_ALLOWED", !cap_allow);
    chk_pin("UNK_SAFE", 3, 8'h6E, 8'h6F, 8'd0, 8'd0, 8'd0);

    chk("HOST0", nht == 16'd0);
    chk("NO_AUTO_REWARD", nrok == 16'd0);
    chk("NO_WEIGHT_DRIFT", cw[0] === w0_before);
    chk("DUAL0", !dual);
    chk("NOQID", !qid);
    chk("NOHOSTWIN", nhw == 16'd0);
    chk("NOA09", !a09);
    chk("NOPLANT", !plant);

    if (fail == 0) begin
      $display("CLASS_e1a_2hop HIT");
      $display("ASTRA_C5_FINAL_V1_E1A_2HOP_XSIM_PASS");
    end else begin
      $display("CLASS_e1a_2hop MISS first=%s", first_div);
      $display("ASTRA_C5_FINAL_V1_E1A_2HOP_XSIM_FAIL n=%0d first=%s", fail, first_div);
    end
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO C6_SWITCH=NO PROD_DICT=OPEN");
    $finish;
  end
endmodule
