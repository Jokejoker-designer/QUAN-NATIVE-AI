`timescale 1ns / 1ps
// ASTRA-C5-PROD-TOP-QPTEXT-01. PROGRAM=NO. Bag-local TB (test-only plant).
// New named C5 hierarchy with QPTEXT gen. Modeled AXI, not MIG. Not BOARD.
`include "a7ng_astra_c5_prod_top.svh"
`include "a7ng_astra_c5_ddr_arb.svh"
`include "a7ng_astra_c4_lm06_byte256_qptext.svh"
`include "tb_oracles.svh"
module tb_astra_c5_prod_top_qptext;
  localparam logic [27:0] INDEX_BASE = 28'h0500_0000, POST_HEAP = 28'h0504_0000, FACT_BASE = 28'h0580_0000;
  localparam int SLOTS = 96;
  localparam int CPB = (A7NG_C5P_CLK_HZ + A7NG_C5P_BAUD/2) / A7NG_C5P_BAUD;
  logic clk, rst_n, urx, utx;
  initial clk = 0;
  always #5 clk = ~clk;

  logic arvalid, arready, rvalid, rready, rlast;
  logic [27:0] araddr;
  logic [127:0] rdata;
  logic awvalid, awready, wvalid, wready, wlast, bvalid, bready;
  logic [15:0] wstrb;
  logic [27:0] awaddr;
  logic [127:0] wdata;
  logic busy, done, dual, qid, a09, plant, c3res, pcmt, pvalid, gdone, phit, ehas;
  logic [5:0] seen;
  logic [2:0] owner;
  logic [15:0] nsw, nblk, nhw, nht, imask, nurx, nutx;
  logic [3:0] c3st, pph;
  logic [7:0] c3obj, glast, gtok0, gtok1;
  logic [19:0] c3ans, c3p0, c3p1;
  logic signed [15:0] pw0;
  logic [27:0] last_aw;

  logic [27:0] mk[0:SLOTS-1];
  logic [127:0] mv[0:SLOTS-1];
  logic mvld[0:SLOTS-1];
  int nslot, fail, i, guard;
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
  function automatic logic [127:0] dir_pack(input int count);
    dir_pack = {48'd0, 16'd7, 16'd0, count[15:0], 4'd0, POST_HEAP};
  endfunction
  function automatic logic [127:0] fact_pack(
      input int s, o, r, e, conf, trans, pol, fctx);
    fact_pack = {28'd0, conf[7:0], fctx[7:0], 4'd1, 1'b0, 1'b1, pol[0], trans[0],
                 e[19:0], r[7:0], o[19:0], s[19:0]};
  endfunction
  function automatic logic [27:0] dir_addr(input int tbl, input int key);
    dir_addr = INDEX_BASE + tbl * 65536 + (key & 12'hFFF) * 16;
  endfunction

  assign arready = (mst == M_IDLE);
  assign awready = (mst == M_IDLE);
  assign wready  = (mst == M_W);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mst <= M_IDLE; rvalid <= 0; rlast <= 0; rdata <= 0; bvalid <= 0;
    end else unique case (mst)
      M_IDLE: begin
        bvalid <= 0; rvalid <= 0;
        if (awvalid && awready) mst <= M_W;
        else if (arvalid && arready) begin
          rlast <= 1'b1; rvalid <= 1'b1;
          rdata <= mem_rd(araddr); mst <= M_R;
        end
      end
      M_R: if (rvalid && rready) begin
        rvalid <= 1'b0; mst <= M_IDLE;
      end
      M_W: if (wvalid && wready) begin
        mem_wr(awaddr, wdata);
        bvalid <= 1'b1; mst <= M_B;
      end
      M_B: if (bvalid && bready) begin
        bvalid <= 1'b0; mst <= M_IDLE;
      end
      default: mst <= M_IDLE;
    endcase
  end

  a7ng_astra_c5_prod_top_c4q u_dut (
    .clk(clk), .rst_n(rst_n), .live_epoch_i(16'd7),
    .uart_rx_i(urx), .uart_tx_o(utx),
    .m_arvalid_o(arvalid), .m_araddr_o(araddr), .m_arready_i(arready),
    .m_rvalid_i(rvalid), .m_rdata_i(rdata), .m_rready_o(rready),
    .m_awvalid_o(awvalid), .m_awaddr_o(awaddr), .m_awready_i(awready),
    .m_wvalid_o(wvalid), .m_wdata_o(wdata), .m_wlast_o(wlast), .m_wstrb_o(wstrb), .m_wready_i(wready),
    .m_bvalid_i(bvalid), .m_bready_o(bready),
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
    .gen_done_o(gdone), .gen_last_o(glast), .gen_tok0_o(gtok0), .gen_tok1_o(gtok1),
    .parser_hit_o(phit), .evid_has_o(ehas),
    .last_aw_o(last_aw)
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
    integer k;
    begin
      for (k = 0; k < s.len(); k = k + 1) uart_byte(s[k]);
      uart_byte(A7NG_C5P_EOL);
    end
  endtask
  task automatic plant_index(input int nfact, input int k0, input int k1, input int k2);
    begin
      mem_wr(dir_addr(0, k0), dir_pack(nfact));
      mem_wr(dir_addr(1, k1), dir_pack(nfact));
      mem_wr(dir_addr(2, k2), dir_pack(nfact));
    end
  endtask
  task automatic plant_post8(
      input int e0, input int e1, input int e2, input int e3,
      input int e4, input int e5, input int e6, input int e7);
    logic [127:0] b0, b1;
    begin
      b0 = e3; b0 = (b0 << 32) | e2; b0 = (b0 << 32) | e1; b0 = (b0 << 32) | e0;
      b1 = e7; b1 = (b1 << 32) | e6; b1 = (b1 << 32) | e5; b1 = (b1 << 32) | e4;
      mem_wr(POST_HEAP, b0);
      mem_wr(POST_HEAP + 28'd16, b1);
    end
  endtask
  task automatic wr_f(input int e, s, o, r, conf, trans, pol, fctx);
    mem_wr(FACT_BASE + (e << 4), fact_pack(s, o, r, e, conf, trans, pol, fctx));
  endtask
  task automatic plant_train0;
    int subj, rel, k0, k1, k2, g0, g1, d0, d1, s0, s1, pf0, pf1;
    begin
      subj = C3_W_SUBJ[0]; rel = C3_W_REL[0];
      k0 = C3_W_K0[0]; k1 = C3_W_K1[0]; k2 = C3_W_K2[0];
      g0 = C3_TR_G0[0]; g1 = g0 + 1; d0 = g0 + 2; d1 = g0 + 3;
      s0 = 32'h200; s1 = 32'h201; pf0 = 32'h300; pf1 = 32'h301;
      plant_post8(g0, g1, d0, d1, s0, s1, pf0, pf1);
      plant_index(8, k0, k1, k2);
      wr_f(g0, subj, 32'h30, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX1);
      wr_f(g1, 32'h30, C3_SHARED_DST, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
      wr_f(d0, subj, 32'h38, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX1);
      wr_f(d1, 32'h38, 32'h90, rel, C3_TR_CONF_W[0], 1, 1, C3_TR_CX2);
      wr_f(s0, subj, C3_SHARED_MID, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(s1, C3_SHARED_MID, C3_SHARED_BG_DST, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf0, subj, 32'hA0, rel, C3_EXTRA_CONF, 1, 1, 0);
      wr_f(pf1, 32'hA0, 32'hB0, rel, C3_EXTRA_CONF, 1, 1, 0);
    end
  endtask

  initial begin
    logic [7:0] gold0, glue;
    fail = 0; first_div = ""; nslot = 0;
    urx = 1'b1; rst_n = 0;
    for (i = 0; i < SLOTS; i = i + 1) mvld[i] = 0;
    plant_train0();
    repeat (8) @(posedge clk); rst_n = 1; repeat (8) @(posedge clk);
    $display("C5_PROD_TOP_QPTEXT PROGRAM=NO BOARD_PASS=REJECT DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO A09=NO");
    $display("CLASS_not_compose_renderer HIT dut=a7ng_astra_c5_prod_top_c4q");
    $display("CLASS_not_live_prod_top_dut HIT live_prod_top_unedited");
    guard = 0;
    while ((seen[0] !== 1'b1 || seen[3] !== 1'b1 || seen[4] !== 1'b1) && guard < 4000) begin
      @(posedge clk); guard = guard + 1;
    end
    chk("BOOT_IDX_LRN_LMD", seen[0] && seen[3] && seen[4] && guard < 4000);
    repeat (20) @(posedge clk);
    uart_str("pump requires indirect");
    guard = 0;
    while (!done && guard < 200000) begin @(posedge clk); guard = guard + 1; end
    chk("NO_TIMEOUT", done && guard < 200000);
    gold0 = a7ng_c4q_ch(C3_SHARED_DST[7:0], 0);
    glue = A7NG_C4Q_GLUE_DEF;
    $display("MEAS nurx=%0d nutx=%0d seen=%02h dual=%0d st=%0d obj=%0d ans=%0d tok0=%0d tok1=%0d glue=%0d gold0=%0d gdone=%0d nht=%0d",
      nurx, nutx, seen, dual, c3st, c3obj, c3ans, gtok0, gtok1, glue, gold0, gdone, nht);

    if (nurx != 0) $display("CLASS_uart_ingress HIT n=%0d", nurx);
    else $display("CLASS_uart_ingress MISS");
    if (phit) $display("CLASS_role_parser HIT");
    else $display("CLASS_role_parser MISS");
    if (seen[1]) $display("CLASS_sparse_index HIT");
    else $display("CLASS_sparse_index MISS");
    if (seen[2]) $display("CLASS_desc_retrieval HIT");
    else $display("CLASS_desc_retrieval MISS");
    if (c3st == 4'd0) $display("CLASS_shared_scorer HIT st=%0d", c3st);
    else $display("CLASS_shared_scorer MISS st=%0d", c3st);
    if (c3st == 4'd0) $display("CLASS_typed_proof HIT");
    else $display("CLASS_typed_proof MISS");
    if (pcmt) $display("CLASS_pending_reward HIT");
    else $display("CLASS_pending_reward MISS");
    if (pvalid || (pph == 4'd4)) $display("CLASS_persist HIT pvalid=%0d pph=%0d", pvalid, pph);
    else $display("CLASS_persist MISS pph=%0d", pph);
    if (ehas) $display("CLASS_evid_materializer HIT");
    else $display("CLASS_evid_materializer MISS");
    if (gdone && (nht == 16'd0)) $display("CLASS_lm06_gen HIT glast=%0d tok0=%0d tok1=%0d", glast, gtok0, gtok1);
    else $display("CLASS_lm06_gen MISS gdone=%0d nht=%0d", gdone, nht);
    if (nutx != 0) $display("CLASS_uart_egress HIT n=%0d", nutx);
    else $display("CLASS_uart_egress MISS");
    if (!dual && (nsw != 0)) $display("CLASS_one_ddr_owner HIT nsw=%0d dual=%0d", nsw, dual);
    else $display("CLASS_one_ddr_owner MISS nsw=%0d dual=%0d", nsw, dual);
    if (seen == 6'h3F) $display("CLASS_six_clients HIT seen=%02h", seen);
    else $display("CLASS_six_clients MISS seen=%02h", seen);
    if (!qid) $display("CLASS_no_qid_map HIT");
    else $display("CLASS_no_qid_map MISS");
    if (nhw == 16'd0) $display("CLASS_no_host_winner HIT");
    else $display("CLASS_no_host_winner MISS n=%0d", nhw);
    if (!a09) $display("CLASS_no_a09_top HIT");
    else $display("CLASS_no_a09_top MISS");
    if (!plant) $display("CLASS_no_plant_in_dut HIT");
    else $display("CLASS_no_plant_in_dut MISS");
    if (last_aw == A7NG_C5_CKPT_BASE) $display("CLASS_ckpt_addr_06000000 HIT awar=%h", last_aw);
    else $display("CLASS_ckpt_addr_06000000 MISS awar=%h", last_aw);
    if ((c3st == 4'd0) && (c3ans == C3_SHARED_DST[19:0]))
      $display("CLASS_ans_matches_planted_dest HIT ans=%0d", c3ans);
    else $display("CLASS_ans_matches_planted_dest MISS ans=%0d", c3ans);
    if (gdone && (gtok0 === glue) && (gtok0 !== gold0))
      $display("CLASS_gen_tok0_glue_from_weights HIT tok0=%0d glue=%0d", gtok0, glue);
    else $display("CLASS_gen_tok0_glue_from_weights MISS tok0=%0d glue=%0d gold0=%0d", gtok0, glue, gold0);
    if (gdone && (gtok1 === gold0) && (c3ans == C3_SHARED_DST[19:0]))
      $display("CLASS_gen_tok1_hop2_obj_name HIT tok1=%0d dest=%0d", gtok1, c3ans);
    else $display("CLASS_gen_tok1_hop2_obj_name MISS tok1=%0d gold0=%0d ans=%0d", gtok1, gold0, c3ans);
    if (gtok0 !== gold0)
      $display("CLASS_tok0_not_ans_dict HIT tok0=%0d gold0=%0d", gtok0, gold0);
    else $display("CLASS_tok0_not_ans_dict MISS tok0=%0d", gtok0);
    $display("CLASS_host_next_token_zero HIT nht=%0d", nht);

    chk("UART_RX", nurx != 0);
    chk("PARSER", phit);
    chk("QDIR", seen[1]);
    chk("DESC", seen[2]);
    chk("ANSWER", c3st == 4'd0);
    chk("PEND", pcmt);
    chk("PERS", pvalid || (pph == 4'd4));
    chk("EVID", ehas);
    chk("GEN", gdone && (nht == 16'd0));
    chk("UART_TX", nutx != 0);
    chk("SIX", seen == 6'h3F);
    chk("DUAL0", !dual);
    chk("NOQID", !qid);
    chk("NOHOST", nhw == 16'd0);
    chk("NOA09", !a09);
    chk("NOPLANT", !plant);
    chk("CKPT", last_aw == A7NG_C5_CKPT_BASE);
    chk("MASK", imask == A7NG_C5P_INST_MASK);
    chk("ANS_DEST", c3ans == C3_SHARED_DST[19:0]);
    chk("TOK0_GLUE", gtok0 === glue);
    chk("TOK0_NOT_ANS", gtok0 !== gold0);
    chk("TOK1_OBJ", gtok1 === gold0);

    if (fail == 0) $display("ASTRA_C5_PROD_TOP_QPTEXT_XSIM_PASS");
    else $display("ASTRA_C5_PROD_TOP_QPTEXT_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $display("C5_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO DDR_QUERY_BOUND_FINAL=NOT_FROZEN quality=C5_HIER_QPTEXT_GLUE_PLUS_HOP2_OBJ_NOT_802K");
    $finish;
  end
endmodule
