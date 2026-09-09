# CLOSEOUT — ASTRA-C4-LM06-802K-GROUNDED-01

PROGRAM=NO. Marker `ASTRA_C4_LM06_802K_GROUNDED_XSIM_PASS` on raw `xsim.log`.
`C4_MASTER=OPEN`. `BOARD_PASS=REJECT`. `LM06_BYTE256=NOT_FROZEN`.

This-gate: frozen `tiny_gpt803k_core` SIM_FULL DUT, checkpoint
`a7lm06_wmem.hex` SHA `c204e559…`, FPGA QUERY/PROOF bytes → start_fwd →
BYTE256 → EOS. `n_host_tok_o=0`. GOLDEN hash unchanged
`29ded797a51137ff0c9fdcff4b342c7ef15b5772e4a97a776d5d5e0de0ccfbd2`.

Measured (not Master close):
- `CLASS_grounded_acc_ge90 MISS acc=0/2`
- first-token BYTE256 always 0 because pred was 861/460/949 (>255) or 0
- `pred_raw` did change: normal obj10=861, zero-weights=0, evid obj30=949
- TinyGPT+wt BRAM additive LIMIT 260>135 still blocks C6 co-fit of this DUT

Independent auditor must hunt mask-collapse tautology. This bag does not
close 90%/95% language, QUERY-PROOF text dictionary, or silicon LM06.
