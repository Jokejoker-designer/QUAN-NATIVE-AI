# PREREG — ASTRA-C5-AXI-ERRORS-04B

PROGRAM=NO. Named DUT `a7ng_astra_c5_prod_top_resp`.
Does not edit live `a7ng_astra_c5_prod_top.sv` hash c4fcca30….
Does not edit `prod_top_stream` / `prod_top_ckpt` / `ddr_arb` / C2 KEEP / C3 wrap /
grounded_gen KEEP.

Unknown: AXI RID/RRESP/RLAST/BID/BRESP/WSTRB reach clients through canonical
adapters. The named top does not fabricate OKAY.

Final defaults in `a7ng_astra_c5_prod_top_resp.svh`: CLK_HZ=83333333, BAUD=115200.
This bag instantiates **sim override** `#(.CLK_HZ(8000), .BAUD(800))`. 04A already
proved pin-level 115200 on the stream sibling. Final build must not ship 8000/800.

HIT if:
- C3 fact beat with SLVERR latches `last_c3_rresp=2'b10` (not fabricated OKAY)
- persist with BRESP SLVERR yields `ckpt_fail==F_BRESP` and `persist_valid=0`
- reload with RRESP SLVERR yields `ckpt_fail==F_RRESP`, `restored=0`, no install
- delayed BVALID still OKAY-completes persist
- accepted AR/AW/W handshakes equal completed R/B (no silent drop)
- happy-path persist then flush then reload still exact-32 after error classes

Does not stamp C5_MASTER. Modeled AXI, not MIG. Not board.
