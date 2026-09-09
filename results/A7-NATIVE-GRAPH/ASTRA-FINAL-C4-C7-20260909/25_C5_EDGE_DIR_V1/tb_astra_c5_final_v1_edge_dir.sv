`timescale 1ns / 1ps
// ASTRA-C5-FINAL-V1 WO §15 wrong-direction + evidence replace. PROGRAM=NO.
// Not C5_MASTER. Modeled AXI. Empty alias → S_SAFE. PROD_DICT=OPEN.
`include "a7ng_astra_c5_prod_top_final_v1.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c5_sgd32_ckpt_pend.svh"
`include "a7ng_astra_c3_held_out.svh"
`include "tb_oracles.svh"
module tb_astra_c5_final_v1_edge_dir;
  localparam int unsigned SIM_CLK_HZ = 8000;
  localparam int unsigned SIM_BAUD   = 800;
  localparam int CPB = (SIM_CLK_HZ + SIM_BAUD/2) / SIM_BAUD;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam logic [27:0] POST_1H = POST_HEAP + 28'd32;
  localparam int SLOTS = 96;
  localparam int E0 = 16, E1 = 17, E2 = 20, MID = 32'h30, DST2 = 64, DST1 = 80, VALVE = 11;
  localparam int K0_1H = 16'h0A02, K1_1H = 16'h0B02;
  localparam logic [19:0] K_SRC = 20'(C3_W_SUBJ[0]);
  localparam logic [19:0] K_DST = 20'(VALVE);
  localparam logic [31:0] SYM_SRC_R = 32'h68676D76;
  localparam logic [31:0] SYM_DST_F = 32'h68666974;
  logic clk, rst_n, urx, utx;
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
  logic cap_v, cap_pok;
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
  function automatic logic [127:0] dir_pack_ovf(input int count, input logic [27:0] post);
    dir_pack_ovf = {48'd0, 16'd7, 16'd1, count[15:0], 4'd0, post};
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
    .alias_wr_ovf_i(alias_wr_ovf), .bank_r_i(1'b0),
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
    .c3_pend_acc_o(pacc), .c3_busy_o(c3busy),
    .c3_txn_o(txn), .c3_gen_o(gen),
    .c3_nupd_o(nupd), .c3_ndup_o(ndup), .c3_nbad_o(nbad),
    .c3_w_o(cw),
    .n_rew_ok_o(nrok), .n_rew_crc_o(ncrc), .n_rew_sess_o(nsess),
    .n_rew_range_o(nrng), .n_rew_frz_o(nfrz), .n_rew_len_o(nlen),
    .persist_valid_o(pvalid), .persist_w0_o(pw0), .persist_phase_o(pph),
    .gen_done_o(gdone), .gen_last_o(glast),
    .parser_hit_o(phit), .evid_has_o(ehas), .last_aw_o(last_aw),
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
        if (d == A7NG_C5P_EOL) return;
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
      guard = 0;
      while (!done && guard < 2000000) begin
        @(posedge clk);
        guard = guard + 1;
        if (c3res && !cap_v) begin
          cap_st = c3st; cap_ans = c3ans; cap_p0 = c3p0; cap_p1 = c3p1; cap_pok = pok; cap_v = 1'b1;
        end
      end
      chk("NO_TIMEOUT", done && guard < 2000000);
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
    begin
      fork
        pin_line();
        begin
          uart_str(q);
          wait_next_done();
        end
      join
      $display("MEAS_Q q=%s npin=%0d nstr=%0d novf=%0d st=%0d ans=%0d pok=%0d gnout=%0d glast=%0d",
               q, npin, nstr, novf, cap_st, cap_ans, cap_pok, gnout, glast);
      for (t = 0; t < npin; t = t + 1) $display("PIN[%0d]=%0d", t, pinb[t]);
    end
  endtask
  task automatic chk_safe(input string tag);
    begin
      chk(tag, (npin == 3) && (pinb[0] == 8'h6E) && (pinb[1] == 8'h6F) && (pinb[2] == 8'd0)
          && (nstr == 16'd3) && (novf == 16'd0));
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(fact_addr(e), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_all;
    logic [127:0] b0, b1;
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
    end
  endtask
  task automatic plant_index_ovf;
    begin
      mem_wr(dir_addr(0, C3_W_K0[0]), dir_pack_ovf(2, POST_HEAP));
      mem_wr(dir_addr(1, C3_W_K1[0]), dir_pack_ovf(2, POST_HEAP));
      mem_wr(dir_addr(2, C3_W_K2[0]), dir_pack_ovf(2, POST_HEAP));
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
      alias_wr_v <= 1'b0;
      @(posedge clk);
    end
  endtask

  initial begin
    fail = 0; first_div = ""; nslot = 0;
    urx = 1'b1; rst_n = 0;
    alias_wr_v = 0; alias_wr_idx = 0; alias_wr_key = 0; alias_wr_sym = 0; alias_wr_ovf = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_all();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_FINAL_V1_EDGE_DIR PROGRAM=NO C5_MASTER=OPEN BOARD_PASS=OPEN");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);

    one_query("pump requires indirect");
    chk("TWOHOP_C3", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == DST2) && (cap_p0 == E0) && (cap_p1 == E1) && cap_pok);
    chk_safe("TWOHOP_SAFE_NO_DICT");
    if ((cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == DST2))
      $display("CLASS_base_two_hop HIT ans=%0d", cap_ans);
    else $display("CLASS_base_two_hop MISS st=%0d ans=%0d", cap_st, cap_ans);

    one_query("valve requires pump");
    chk("REV_NOT_ANSWER", cap_st != A7NG_C3_ST_ANSWER);
    chk("REV_NOT_DST64", cap_ans != DST2);
    chk_safe("REV_SAFE");
    if ((cap_st != A7NG_C3_ST_ANSWER) && (cap_ans != DST2))
      $display("CLASS_role_reversal HIT st=%0d ans=%0d", cap_st, cap_ans);
    else $display("CLASS_role_reversal MISS st=%0d ans=%0d", cap_st, cap_ans);

    mem_wr(fact_addr(E1), 128'd0);
    one_query("pump requires indirect");
    chk("DEL_UNKNOWN", cap_st == A7NG_C3_ST_UNKNOWN);
    chk("DEL_NOT_64", cap_ans != DST2);
    chk_safe("DEL_SAFE");
    if ((cap_st == A7NG_C3_ST_UNKNOWN) && (cap_ans != DST2))
      $display("CLASS_edge_delete HIT");
    else $display("CLASS_edge_delete MISS st=%0d ans=%0d", cap_st, cap_ans);

    wr_f(E1, MID, DST1, C3_W_REL[0], C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
    one_query("pump requires indirect");
    chk("REP_ANSWER", (cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == DST1) && (cap_p0 == E0) && (cap_p1 == E1) && cap_pok);
    chk("REP_CHANGED", cap_ans != DST2);
    chk_safe("REP_SAFE_NO_DICT");
    if ((cap_st == A7NG_C3_ST_ANSWER) && (cap_ans == DST1) && (cap_ans != DST2))
      $display("CLASS_edge_replace HIT ans=%0d", cap_ans);
    else $display("CLASS_edge_replace MISS st=%0d ans=%0d", cap_st, cap_ans);

    chk("HOST0", nht == 16'd0);
    chk("NOQID", !qid);
    chk("NOA09", !a09);
    chk("NOPLANT", !plant);
    chk("DUAL0", !dual);

    if (fail == 0) $display("ASTRA_C5_FINAL_V1_EDGE_DIR_XSIM_PASS");
    else $display("ASTRA_C5_FINAL_V1_EDGE_DIR_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=OPEN PROGRAM=NO PROD_DICT=OPEN");
    $finish;
  end
endmodule
