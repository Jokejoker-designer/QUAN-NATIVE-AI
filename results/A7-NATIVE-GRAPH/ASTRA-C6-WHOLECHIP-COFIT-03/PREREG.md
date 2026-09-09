# PREREG — ASTRA-C6-WHOLECHIP-COFIT-03

PROGRAM=NO. Frozen before Vivado. Does not edit C0/C1/C2 KEEP, leftover A09,
frozen LM-06 `tiny_gpt803k_core`, official `mig.prj`, or `mig_native_wrap.sv`.
Does not freeze `DDR_QUERY_BOUND_FINAL`. A09R8 is not C6 co-fit authority.
Does not program. Unique bit is freeze evidence only.

## One unknown

C6-02 routed UART-loop top WNS=0.150 on wrap `64275ba0…` + prod_top `c4fcca30…`
with **pre-CONFLICT** C3. Live C3 wrap is now `cfb89632…` (`ST_CONFLICT=5`,
polarity only). Does that exact hierarchy plus official Digilent AXI MIG still
fit and close timing on `xc7a100tcsg324-1`?

## HIT letter this bag may measure (post-route)

```text
DEVICE_FIT = PASS
WNS >= 0, TNS = 0, WHS >= 0, THS = 0
UNROUTED = 0, FAILED_ROUTE = 0
DRC ERROR/FATAL = 0
critical unconstrained paths = 0
CDC reviewed (sys_clk_pin / MIG ui / uart_io_vclk)
C5 prod_top instantiated; A09 not top; PROGRAM=NO
marker ASTRA_C6_WHOLECHIP_COFIT_03_PASS
```

Preferred LUT<=40k FF<=50k BRAM36eq<=115 DSP<=32 is envelope, not hard fail.

## Quality bound

Does not close C3 silicon, C4 TinyGPT 90%, or BOARD. UART baud remains C5 sim
localparam (8000/800). `program_scope=PINNED_SHA_e51bdca2_ONLY` forbids
programming. Do not self-stamp BOARD_PASS or ASTRA_NATIVE_AI_BOARD_PASS.
C6-02 bit SHA `d69d39f9…` remains historical and must not be programmed.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- A09 or `tiny_gpt803k_core` compiled as DUT, or synth `mig_7series_0_mig.v` is the top
- GOLDEN edited after first Vivado
- PROGRAM=YES / open_hw
- WNS/TNS/WHS/THS/UNROUTED/DRC letters miss
- A09R8 treated as this top
