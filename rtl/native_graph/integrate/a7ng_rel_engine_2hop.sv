// a7ng_rel_engine_2hop.sv — ASTRA-04/05 bounded Horn step. PROGRAM=NO.
// requires(x,y) AND requires(y,z) → depends_indirect(x,z) with two edge IDs.
// Sequential scan: q_budget / q_max_hop can yield SEARCH_INCOMPLETE.
// Polarity 0 = forbids. No exam answer ROM. No entity-ID constants.
`timescale 1ns / 1ps

module a7ng_rel_engine_2hop #(
  parameter int unsigned N_EDGES = 16,
  parameter int unsigned ID_W    = 8
) (
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic                 load_v,
  input  logic [3:0]           load_idx,
  input  logic [ID_W-1:0]      load_s,
  input  logic [ID_W-1:0]      load_r,
  input  logic [ID_W-1:0]      load_o,
  input  logic [ID_W-1:0]      load_eid,
  input  logic                 load_trans,
  input  logic                 load_pol,
  input  logic                 clr_v,
  input  logic [3:0]           clr_idx,
  input  logic                 q_v,
  input  logic [ID_W-1:0]      q_s,
  input  logic [ID_W-1:0]      q_r,
  input  logic [ID_W-1:0]      q_o,
  input  logic                 q_obj_valid,
  input  logic                 q_two_hop,
  input  logic [7:0]           q_budget,
  input  logic [3:0]           q_max_hop,
  output logic                 q_ready,
  output logic                 ans_v,
  output logic [ID_W-1:0]      ans_o,
  output logic [ID_W-1:0]      proof0,
  output logic [ID_W-1:0]      proof1,
  output logic [2:0]           status_o,
  output logic [7:0]           scan_used_o
);
  localparam logic [2:0] ST_ANSWER     = 3'd0;
  localparam logic [2:0] ST_UNKNOWN    = 3'd1;
  localparam logic [2:0] ST_WRONGDIR   = 3'd2;
  localparam logic [2:0] ST_NTRANS     = 3'd3;
  localparam logic [2:0] ST_CYCLE      = 3'd4;
  localparam logic [2:0] ST_CONFLICT   = 3'd5;
  localparam logic [2:0] ST_INCOMPLETE = 3'd6;

  typedef enum logic [1:0] { S_IDLE, S_H1, S_H2, S_FIN } sst_t;
  sst_t sst;

  logic [ID_W-1:0] es  [0:N_EDGES-1];
  logic [ID_W-1:0] er  [0:N_EDGES-1];
  logic [ID_W-1:0] eo  [0:N_EDGES-1];
  logic [ID_W-1:0] eid [0:N_EDGES-1];
  logic            et  [0:N_EDGES-1];
  logic            ep  [0:N_EDGES-1];
  logic            ev  [0:N_EDGES-1];

  logic [ID_W-1:0] qs, qr, qo, e1, e2, ans, mid, neg0;
  logic            qov, q2, found, wrong, ntrans, cyc, conf, incomp, saw_neg;
  logic [7:0]      budget, steps;
  logic [3:0]      max_hop;
  logic [4:0]      i, j;
  integer          k;

  assign q_ready = (sst == S_IDLE);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (k = 0; k < N_EDGES; k = k + 1) begin
        es[k] <= '0; er[k] <= '0; eo[k] <= '0; eid[k] <= '0;
        et[k] <= 1'b0; ep[k] <= 1'b1; ev[k] <= 1'b0;
      end
      sst <= S_IDLE;
      ans_v <= 1'b0; ans_o <= '0; proof0 <= '0; proof1 <= '0;
      status_o <= ST_UNKNOWN; scan_used_o <= 8'd0;
      qs <= '0; qr <= '0; qo <= '0; e1 <= '0; e2 <= '0; ans <= '0; mid <= '0; neg0 <= '0;
      qov <= 1'b0; q2 <= 1'b0; found <= 1'b0; wrong <= 1'b0;
      ntrans <= 1'b0; cyc <= 1'b0; conf <= 1'b0; incomp <= 1'b0; saw_neg <= 1'b0;
      budget <= 8'd0; steps <= 8'd0; max_hop <= 4'd0; i <= '0; j <= '0;
    end else begin
      if (sst == S_IDLE)
        ans_v <= 1'b0;

      if (load_v && (sst == S_IDLE) && (32'(load_idx) < N_EDGES)) begin
        es[load_idx]  <= load_s;
        er[load_idx]  <= load_r;
        eo[load_idx]  <= load_o;
        eid[load_idx] <= load_eid;
        et[load_idx]  <= load_trans;
        ep[load_idx]  <= load_pol;
        ev[load_idx]  <= 1'b1;
      end
      if (clr_v && (sst == S_IDLE) && (32'(clr_idx) < N_EDGES))
        ev[clr_idx] <= 1'b0;

      unique case (sst)
        S_IDLE: begin
          if (q_v) begin
            qs <= q_s; qr <= q_r; qo <= q_o; qov <= q_obj_valid; q2 <= q_two_hop;
            budget <= q_budget; max_hop <= q_max_hop;
            steps <= 8'd0; i <= '0; j <= '0;
            found <= 1'b0; wrong <= 1'b0; ntrans <= 1'b0; cyc <= 1'b0;
            conf <= 1'b0; incomp <= 1'b0; saw_neg <= 1'b0;
            e1 <= '0; e2 <= '0; ans <= '0; mid <= '0; neg0 <= '0;
            if (q_two_hop && (q_max_hop != 4'd0) && (q_max_hop < 4'd2)) begin
              incomp <= 1'b1;
              sst <= S_FIN;
            end else begin
              sst <= S_H1;
            end
          end
        end
        S_H1: begin
          steps <= steps + 8'd1;
          if ((budget != 8'd0) && (steps + 8'd1 >= budget)) begin
            incomp <= 1'b1;
            sst <= S_FIN;
          end else if (32'(i) >= N_EDGES) begin
            sst <= S_FIN;
          end else begin
            if (ev[i[3:0]] && (er[i[3:0]] == qr) && qov &&
                (es[i[3:0]] == qo) && (eo[i[3:0]] == qs))
              wrong <= 1'b1;
            if (ev[i[3:0]] && (er[i[3:0]] == qr) && (es[i[3:0]] == qs) &&
                q2 && et[i[3:0]] && ep[i[3:0]]) begin
              mid <= eo[i[3:0]];
              j <= '0;
              sst <= S_H2;
            end else begin
              if (ev[i[3:0]] && (er[i[3:0]] == qr) && (es[i[3:0]] == qs)) begin
                if (!q2) begin
                  if (!qov || (eo[i[3:0]] == qo)) begin
                    if (!ep[i[3:0]]) begin
                      saw_neg <= 1'b1;
                      neg0 <= eo[i[3:0]];
                      if (found && (ans == eo[i[3:0]]))
                        conf <= 1'b1;
                    end else begin
                      if (found && (ans != eo[i[3:0]]))
                        conf <= 1'b1;
                      if (saw_neg && (neg0 == eo[i[3:0]]))
                        conf <= 1'b1;
                      found <= 1'b1;
                      e1 <= eid[i[3:0]];
                      e2 <= '0;
                      ans <= eo[i[3:0]];
                    end
                  end
                end else if (!et[i[3:0]])
                  ntrans <= 1'b1;
              end
              i <= i + 5'd1;
            end
          end
        end
        S_H2: begin
          steps <= steps + 8'd1;
          if ((budget != 8'd0) && (steps + 8'd1 >= budget)) begin
            incomp <= 1'b1;
            sst <= S_FIN;
          end else if (32'(j) >= N_EDGES) begin
            i <= i + 5'd1;
            sst <= S_H1;
          end else begin
            if (ev[j[3:0]] && (er[j[3:0]] == qr) && (es[j[3:0]] == mid)) begin
              if (eo[j[3:0]] == qs)
                cyc <= 1'b1;
              else if (!ep[j[3:0]]) begin
                if (!qov || (eo[j[3:0]] == qo)) begin
                  saw_neg <= 1'b1;
                  neg0 <= eo[j[3:0]];
                  if (found && (ans == eo[j[3:0]]))
                    conf <= 1'b1;
                end
              end else if (!qov || (eo[j[3:0]] == qo)) begin
                if (found && (ans != eo[j[3:0]]))
                  conf <= 1'b1;
                if (saw_neg && (neg0 == eo[j[3:0]]))
                  conf <= 1'b1;
                found <= 1'b1;
                e1 <= eid[i[3:0]];
                e2 <= eid[j[3:0]];
                ans <= eo[j[3:0]];
              end
            end
            j <= j + 5'd1;
          end
        end
        S_FIN: begin
          ans_v <= 1'b1;
          scan_used_o <= steps;
          if (conf) begin
            status_o <= ST_CONFLICT;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end else if (cyc) begin
            status_o <= ST_CYCLE;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end else if (incomp && !found) begin
            status_o <= ST_INCOMPLETE;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end else if (ntrans && !found) begin
            status_o <= ST_NTRANS;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end else if (found) begin
            status_o <= ST_ANSWER;
            ans_o <= ans; proof0 <= e1; proof1 <= e2;
          end else if (wrong) begin
            status_o <= ST_WRONGDIR;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end else begin
            status_o <= ST_UNKNOWN;
            ans_o <= '0; proof0 <= '0; proof1 <= '0;
          end
          sst <= S_IDLE;
        end
        default: sst <= S_IDLE;
      endcase
    end
  end
endmodule
