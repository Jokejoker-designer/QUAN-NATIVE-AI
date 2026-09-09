# CLOSEOUT — ASTRA-C6-WHOLECHIP-COFIT-02

PROGRAM=NO. Marker `ASTRA_C6_WHOLECHIP_COFIT_02_PASS` after in-context route of
UART-loop `a7ng_astra_c6_wholechip` (wrap `64275ba0…`, prod_top grant-hold +
`m_wstrb_o=p_wstrb`, official Digilent AXI MIG) on `xc7a100tcsg324-1`.

Raw `ROUTE_LETTERS.txt`: WNS=0.150 TNS=0 WHS=0.012 THS=0 UNROUTED=0
DRC ERROR/FATAL=0 CRITICAL_UNCONSTRAINED=0 FIT_OK=1.
UTIL routed LUT=8908 FF=6981 BRAM_TILE=0 DSP=0.
A09R8 is not this top. `BOARD_PASS=REJECT`. `C6_MASTER=OPEN` pending
independent auditor hunt. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

r0: Vivado 2026.1 ACCESS_VIOLATION in `opt_design` Retarget. GOLDEN not regenerated.
r1: skip Retarget, signoff WNS=-0.019 MISS.
r2: resume `route.dcp`, post-route phys_opt + `route_design -tns_cleanup` → WNS=0.150.

Bit SHA `d69d39f9c5881c301b802ae06941ba1c27c32228c0557680e308eaf25b29d097`
is freeze evidence only. Do not program (`PINNED_SHA_e51bdca2_ONLY`).
Does not close C3 silicon, C4 TinyGPT 90%, KEEP C3 CONFLICT, or BOARD.
