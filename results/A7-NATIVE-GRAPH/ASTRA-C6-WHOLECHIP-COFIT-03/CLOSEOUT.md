# CLOSEOUT — ASTRA-C6-WHOLECHIP-COFIT-03

PROGRAM=NO. Marker `ASTRA_C6_WHOLECHIP_COFIT_03_PASS` after in-context route of
UART-loop `a7ng_astra_c6_wholechip` (wrap `64275ba0…`, prod_top `c4fcca30…`,
live C3 polarity CONFLICT `cfb89632…`, official Digilent AXI MIG) on
`xc7a100tcsg324-1`.

Raw `ROUTE_LETTERS.txt`: WNS=0.233 TNS=0 WHS=0.013 THS=0 UNROUTED=0
DRC ERROR/FATAL=0 CRITICAL_UNCONSTRAINED=0 FIT_OK=1.
UTIL routed LUT=9056 FF=7095 BRAM_TILE=0 DSP=0.
A09R8 is not this top. `BOARD_PASS=REJECT`. `C6_MASTER=OPEN` pending
independent auditor hunt. `DDR_QUERY_BOUND_FINAL=NOT_FROZEN`.

r0: synth OK; `opt_design -propconst -sweep` ACCESS_VIOLATION in Phase 3
Constant propagation. GOLDEN not regenerated.
r1: resume `ckpt/synth.dcp`, skip opt, place + route + post-route phys_opt
+ tns_cleanup → WNS=0.233.

Bit SHA `edda8575f3130b6f645af223c5d9000539a1a80db23731bb18f7a280ad06c0ba`
is freeze evidence only. Do not program (`PINNED_SHA_e51bdca2_ONLY`).
C6-02 bit `d69d39f9…` is stale and must not be programmed.
Does not close C3 silicon, C4 TinyGPT 90%, or BOARD.
