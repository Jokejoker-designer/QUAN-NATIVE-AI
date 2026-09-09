// a7ng_astra_09_r6_iso_pub.sv — ASTRA-09-R6-UART-ISO-PUBLIC-01. PROGRAM=NO.
// New named DUT. Public iso_req/iso_x0/iso_rew. Inner u_sgd is the one SGD.
// Frozen a7ng_astra_09_r2_cand_ovf is unused (no public iso ports).
// Not PRODUCTION_TOP. Not a bit.
`timescale 1ns / 1ps
`include "a7ng_astra_09_r6_iso_pub.svh"

module a7ng_astra_09_r6_iso_pub (
  input  logic               clk,
  input  logic               rst_n,
  input  logic               iso_req_i,
  input  logic signed [7:0]  iso_x0_i,
  input  logic signed [3:0]  iso_rew_i,
  output logic               iso_ready_o,
  output logic               iso_done_o,
  output logic               iso_busy_o,
  output logic signed [15:0] w_o [0:31],
  output logic signed [15:0] v_q8_o,
  output logic               load_from_tb_o
);
  typedef enum logic [1:0] { L_IDLE, L_GO, L_WAIT } lst_t;
  lst_t lst;

  logic signed [7:0]  x_lat [0:31];
  logic signed [7:0]  x_sgd [0:31];
  logic signed [3:0]  rew_lat;
  logic               sgd_rdy, sgd_dn, go_upd;
  integer             kc, kf;

  assign load_from_tb_o = 1'b0;
  assign iso_ready_o    = (lst == L_IDLE) && sgd_rdy;
  assign iso_busy_o     = (lst != L_IDLE);

  always_comb begin
    for (kc = 0; kc < 32; kc = kc + 1)
      x_sgd[kc] = x_lat[kc];
  end

  (* keep_hierarchy = "yes" *)
  a7ng_shared_rank_sgd_q8_sym_f2r2 u_sgd (
    .clk(clk),
    .rst_n(rst_n),
    .freeze_i(1'b0),
    .go_score_i(1'b0),
    .go_upd_i(go_upd),
    .x_i(x_sgd),
    .reward_i(rew_lat),
    .load_v_i(1'b0),
    .load_idx_i(5'd0),
    .load_w_i(16'sd0),
    .w_o(w_o),
    .ready_o(sgd_rdy),
    .done_o(sgd_dn),
    .v_q8_o(v_q8_o)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lst      <= L_IDLE;
      go_upd   <= 1'b0;
      iso_done_o <= 1'b0;
      rew_lat  <= 4'sd0;
      for (kf = 0; kf < 32; kf = kf + 1)
        x_lat[kf] <= 8'sd0;
    end else begin
      go_upd     <= 1'b0;
      iso_done_o <= 1'b0;
      unique case (lst)
        L_IDLE: begin
          if (iso_req_i && sgd_rdy) begin
            for (kf = 0; kf < 32; kf = kf + 1)
              x_lat[kf] <= 8'sd0;
            x_lat[0] <= iso_x0_i;
            rew_lat  <= iso_rew_i;
            lst      <= L_GO;
          end
        end
        L_GO: begin
          if (sgd_rdy)
            go_upd <= 1'b1;
          lst <= L_WAIT;
        end
        L_WAIT: begin
          if (sgd_dn) begin
            iso_done_o <= 1'b1;
            lst        <= L_IDLE;
          end
        end
        default: lst <= L_IDLE;
      endcase
    end
  end
endmodule
