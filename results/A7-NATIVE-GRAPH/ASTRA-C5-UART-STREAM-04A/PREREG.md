# PREREG — ASTRA-C5-UART-STREAM-04A

PROGRAM=NO. Named DUT `a7ng_astra_c5_prod_top_stream`.
Does not edit live `a7ng_astra_c5_prod_top.sv` (still 8000/800 in that file).
Does not edit `prod_top_ckpt` / `prod_top_rew`. Does not edit grounded_gen KEEP.

Unknown: UART TX emits the full generator token FIFO (>=3 tokens) plus EOL,
not a single `last_gen` byte.

Final defaults in `a7ng_astra_c5_prod_top_stream.svh`: CLK_HZ=83333333
(MIG ui_clk 12 ns estimate), BAUD=115200. This bag instantiates those
defaults (no 8000/800 sim override). TB clock period is 12 ns.

HIT if:
- pin-decoded UART line has >=3 token bytes then EOL
- n_stream == gen n_out and n_stream > 1 (falsifies last_gen-only)
- FIFO overflow count is 0
- a second consecutive query also streams >=3 tokens

Does not stamp C5_MASTER. Modeled AXI, not MIG. Not board.
04B AXI RESP transport remains OPEN.
