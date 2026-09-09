// a7ng_rel_engine_2hop_v2.sv — ASTRA-05 polarity + scan/hop budget. PROGRAM=NO.
// v1 a7ng_rel_engine_2hop.sv UNCHANGED. No exam answer ROM. No entity-ID constants.
// requires(x,y) AND requires(y,z) → depends_indirect(x,z). Polarity 0 = forbids.
`timescale 1ns / 1ps

module a7ng_rel_engine_2hop_v2 #(
  parameter int unsigned N_EDGES = 16,
  parameter int unsigned ID_W    = 8,
  parameter int unsigned SCAN_W  = 8
) (
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic                 clr,
  input  logic                 load_v,
  input  logic [3:0]           load_idx,
  input  logic [ID_W-1:0]      load_s,
  input  logic [ID_W-1:0]      load_r,
  input  logic [ID_W-1:0]      load_o,
  input  logic [ID_W-1:0]      load_eid,
  input  logic                 load_trans,
  input  logic                 load_pol,
  input  logic                 load_keep,
  input  logic                 q_v,
  input  logic [ID_W-1:0]      q_s,
  input  logic [ID_W-1:0]      q_r,
  input  logic [ID_W-1:0]      q_o,
  input  logic                 q_obj_valid,
  input  logic                 q_two_hop,
  input  logic [SCAN_W-1:0]    q_max_scan,
  input  logic [3:0]           q_max_hop,
  output logic                 q_ready,
  output logic                 ans_v,
  output logic [ID_W-1:0]      ans_o,
  output logic [ID_W-1:0]      proof0,
  output logic [ID_W-1:0]      proof1,
  output logic [2:0]           status_o,
  output logic [15:0]          scan_used_o
);
  localparam logic [2:0] ST_ANSWER     = 3'd0;
  localparam logic [2:0] ST_UNKNOWN    = 3'd1;
  localparam logic [2:0] ST_WRONGDIR   = 3'd2;
  localparam logic [2:0] ST_NTRANS     = 3'd3;
  localparam logic [2:0] ST_CYCLE      = 3'd4;
  localparam logic [2:0] ST_CONFLICT   = 3'd5;
  localparam logic [2:0] ST_INCOMPLETE = 3'd6;

  logic [ID_W-1:0] es  [0:N_EDGES-1];
  logic [ID_W-1:0] er  [0:N_EDGES-1];
  logic [ID_W-1:0] eo  [0:N_EDGES-1];
  logic [ID_W-1:0] eid [0:N_EDGES-1];
  logic            et  [0:N_EDGES-1];
  logic            ep  [0:N_EDGES-1];
  logic            ev  [0:N_EDGES-1];

  integer i, j;
  integer scan_cnt, scan_lim, npos;
  logic incomplete, conflict, wrong, ntrans, cyc, saw_neg;
  logic [ID_W-1:0] pos0, neg0, e1, e2, ans;

  assign q_ready = 1'b1;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i = 0; i < N_EDGES; i = i + 1) begin
        es[i] <= '0; er[i] <= '0; eo[i] <= '0; eid[i] <= '0;
        et[i] <= 1'b0; ep[i] <= 1'b1; ev[i] <= 1'b0;
      end
      ans_v <= 1'b0; ans_o <= '0; proof0 <= '0; proof1 <= '0;
      status_o <= ST_UNKNOWN; scan_used_o <= 16'd0;
    end else begin
      if (clr) begin
        for (i = 0; i < N_EDGES; i = i + 1)
          ev[i] <= 1'b0;
      end
      if (load_v) begin
        if (32'(load_idx) < N_EDGES) begin
          if (load_keep) begin
            es[load_idx]  <= load_s;
            er[load_idx]  <= load_r;
            eo[load_idx]  <= load_o;
            eid[load_idx] <= load_eid;
            et[load_idx]  <= load_trans;
            ep[load_idx]  <= load_pol;
            ev[load_idx]  <= 1'b1;
          end else begin
            ev[load_idx]  <= 1'b0;
          end
        end
      end
      if (q_v) begin
        scan_lim = (q_max_scan == {SCAN_W{1'b0}}) ? 32'd65535 : integer'(q_max_scan);
        scan_cnt = 0;
        incomplete = 1'b0;
        conflict = 1'b0;
        wrong = 1'b0;
        ntrans = 1'b0;
        cyc = 1'b0;
        saw_neg = 1'b0;
        npos = 0;
        pos0 = '0; neg0 = '0; e1 = '0; e2 = '0; ans = '0;

        if (q_two_hop) begin
          if ((q_max_hop != 4'd0) && (q_max_hop < 4'd2))
            incomplete = 1'b1;
          else begin
            for (i = 0; i < N_EDGES; i = i + 1) begin
              if (ev[i]) begin
                if (scan_cnt >= scan_lim)
                  incomplete = 1'b1;
                else begin
                  scan_cnt = scan_cnt + 1;
                  if ((er[i] == q_r) && (es[i] == q_s) && ep[i]) begin
                    if (!et[i])
                      ntrans = 1'b1;
                    else begin
                      for (j = 0; j < N_EDGES; j = j + 1) begin
                        if (ev[j]) begin
                          if (scan_cnt >= scan_lim)
                            incomplete = 1'b1;
                          else begin
                            scan_cnt = scan_cnt + 1;
                            if ((er[j] == q_r) && (es[j] == eo[i])) begin
                              if (eo[j] == q_s)
                                cyc = 1'b1;
                              else if (!ep[j]) begin
                                if (!q_obj_valid || (eo[j] == q_o)) begin
                                  saw_neg = 1'b1;
                                  neg0 = eo[j];
                                  if ((npos != 0) && (pos0 == eo[j]))
                                    conflict = 1'b1;
                                end
                              end else if (!q_obj_valid || (eo[j] == q_o)) begin
                                if ((npos != 0) && (pos0 != eo[j]))
                                  conflict = 1'b1;
                                if (npos == 0) begin
                                  npos = 1;
                                  pos0 = eo[j];
                                  e1 = eid[i];
                                  e2 = eid[j];
                                  ans = eo[j];
                                end
                                if (saw_neg && (neg0 == eo[j]))
                                  conflict = 1'b1;
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          if (conflict) begin
            status_o <= ST_CONFLICT; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (cyc) begin
            status_o <= ST_CYCLE; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (incomplete && (npos == 0)) begin
            status_o <= ST_INCOMPLETE; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (ntrans && (npos == 0)) begin
            status_o <= ST_NTRANS; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (npos != 0) begin
            status_o <= ST_ANSWER; ans_o <= ans; proof0 <= e1; proof1 <= e2; ans_v <= 1'b1;
          end else begin
            status_o <= ST_UNKNOWN; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end
        end else begin
          for (i = 0; i < N_EDGES; i = i + 1) begin
            if (ev[i]) begin
              if (scan_cnt >= scan_lim)
                incomplete = 1'b1;
              else begin
                scan_cnt = scan_cnt + 1;
                if ((er[i] == q_r) && (es[i] == q_s) && (!q_obj_valid || (eo[i] == q_o))) begin
                  if (!ep[i]) begin
                    saw_neg = 1'b1;
                    neg0 = eo[i];
                    if ((npos != 0) && (pos0 == eo[i]))
                      conflict = 1'b1;
                  end else begin
                    if ((npos != 0) && (pos0 != eo[i]))
                      conflict = 1'b1;
                    if (npos == 0) begin
                      npos = 1;
                      pos0 = eo[i];
                      e1 = eid[i];
                      ans = eo[i];
                    end
                    if (saw_neg && (neg0 == eo[i]))
                      conflict = 1'b1;
                  end
                end
                if (q_obj_valid && (er[i] == q_r) && (es[i] == q_o) && (eo[i] == q_s))
                  wrong = 1'b1;
              end
            end
          end
          if (conflict) begin
            status_o <= ST_CONFLICT; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (incomplete && (npos == 0)) begin
            status_o <= ST_INCOMPLETE; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else if (npos != 0) begin
            status_o <= ST_ANSWER; ans_o <= ans; proof0 <= e1; proof1 <= '0; ans_v <= 1'b1;
          end else if (wrong) begin
            status_o <= ST_WRONGDIR; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end else begin
            status_o <= ST_UNKNOWN; ans_o <= '0; proof0 <= '0; proof1 <= '0; ans_v <= 1'b1;
          end
        end
        scan_used_o <= scan_cnt[15:0];
      end
    end
  end
endmodule
