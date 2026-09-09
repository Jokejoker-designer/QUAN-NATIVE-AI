`timescale 1ns / 1ps
// ASTRA-C1-IMAGE-CONTRACT-01. PROGRAM=NO.
// Independent Python samples vs unedited gen_800k.svh g_rdata_of.
// Does not edit C1 KEEP. Does not dump 800k bytes. Does not freeze DDR_QUERY_BOUND_FINAL.
module tb_astra_c1_image_contract;
  `include "query_gold.svh"
  `include "gen_800k.svh"
  `include "tb_samples.svh"
  int fail, i, nmiss;
  string first_div;
  logic [127:0] got;
  logic [127:0] pfill;
  logic [127:0] phigh;
  logic [127:0] pspecial;
  logic [127:0] povf;
  int occ_fill;
  int occ_high0;
  int occ_high1;

  task automatic chk(input string tag, input bit cond);
    begin
      if (!cond) begin
        if (first_div=="") first_div=tag;
        $display("FAIL %s", tag); fail=fail+1;
      end else $display("PASS %s", tag);
    end
  endtask

  initial begin
    fail=0; first_div=""; nmiss=0;
    $display("C1_IMAGE_CONTRACT PROGRAM=NO N=%0d STREAM=%0d CAND_CAP=%0d",
      G_N, G_N_STREAM, G_CAND_CAP);
    $display("DDR_QUERY_BOUND_FINAL=NOT_FROZEN");
    $display("DICTIONARY_DDR_IMAGE=NOT_PINNED");
    $display("CLASS_bound_not_frozen HIT");
    $display("CLASS_dict_unpinned HIT");
    $display("CLASS_no_full_dump HIT sample_n=%0d", C1IMG_N);

    for (i = 0; i < C1IMG_N; i = i + 1) begin
      got = g_rdata_of(C1IMG_ADDR[i]);
      if (got !== C1IMG_DATA[i]) begin
        nmiss = nmiss + 1;
        if (first_div == "") first_div = "SAMPLE";
        $display("MISS_SAMPLE i=%0d addr=%h got=%h exp=%h",
          i, C1IMG_ADDR[i], got, C1IMG_DATA[i]);
      end
    end
    if (nmiss == 0) $display("CLASS_sample_bytes HIT n=%0d", C1IMG_N);
    else $display("CLASS_sample_bytes MISS nmiss=%0d", nmiss);
    chk("SAMPLE_BYTES", nmiss == 0);

    chk("BELOW_DIR_ZERO", g_rdata_of(28'h0000010) == 128'd0);
    if (g_rdata_of(28'h0000010) == 128'd0) $display("CLASS_below_dir_zero HIT");
    else $display("CLASS_below_dir_zero MISS");

    occ_fill = g_occ_of(0, 16'h0D04);
    chk("FILL_OCC202", occ_fill == 202);
    if (occ_fill == 202) $display("CLASS_fill_occ202 HIT occ=%0d", occ_fill);
    else $display("CLASS_fill_occ202 MISS occ=%0d", occ_fill);

    pfill = g_pack_post(0, 16'h0D04, 0);
    chk("FILL_NIDS", (pfill[31:0] == 32'd120) && (pfill[63:32] == 32'd121) &&
      (pfill[95:64] == 32'd122));
    if ((pfill[31:0] == 32'd120) && (pfill[63:32] == 32'd121) &&
        (pfill[95:64] == 32'd122))
      $display("CLASS_fill_nids_120_122 HIT");
    else $display("CLASS_fill_nids_120_122 MISS w=%h", pfill);

    pspecial = g_pack_post(0, 3380, 0);
    chk("SPECIAL_3380", (g_occ_of(0, 3380) == 1) && (pspecial[31:0] == 32'd121));
    if ((g_occ_of(0, 3380) == 1) && (pspecial[31:0] == 32'd121))
      $display("CLASS_special_3380 HIT");
    else $display("CLASS_special_3380 MISS");

    occ_high0 = g_occ_of(0, 16'hD514);
    occ_high1 = g_occ_of(1, 16'h0D14);
    phigh = g_pack_post(0, 16'hD514, 0);
    chk("HIGH_K0_OCC1", occ_high0 == 1);
    chk("HIGH_NID", phigh[31:0] == 32'd799999);
    chk("HIGH_K1_OCC200", occ_high1 == 200);
    if ((occ_high0 == 1) && (phigh[31:0] == 32'd799999))
      $display("CLASS_high_nid HIT occ_k0=1 nid=799999");
    else $display("CLASS_high_nid MISS occ=%0d w=%h", occ_high0, phigh);
    if (occ_high1 == 200) $display("CLASS_high_k1_occ200 HIT");
    else $display("CLASS_high_k1_occ200 MISS occ=%0d", occ_high1);

    chk("TBL2_EMPTY", g_rdata_of(28'h5200000) == 128'd0);
    if (g_rdata_of(28'h5200000) == 128'd0) $display("CLASS_tbl2_empty HIT");
    else $display("CLASS_tbl2_empty MISS");

    povf = g_pack_post(0, 16'h0D04, 50);
    chk("OVERFLOW_BEAT50", povf[31:0] != 32'd0);
    if (povf[31:0] != 32'd0) $display("CLASS_overflow_page HIT");
    else $display("CLASS_overflow_page MISS");

    $display("C1_MASTER_CLAIM=NO BOARD_PASS=REJECT PROGRAM=NO DDR_QUERY_BOUND_FINAL=NOT_FROZEN");
    if (fail == 0) $display("ASTRA_C1_IMAGE_CONTRACT_01_XSIM_PASS");
    else $display("ASTRA_C1_IMAGE_CONTRACT_01_XSIM_FAIL n=%0d first=%s", fail, first_div);
    $finish;
  end
endmodule
