# PREREG — ASTRA-C5-PROD-TOP-MIG-01

PROGRAM=NO. Frozen before xvlog. Does not edit C0/C1/C2 KEEP, C3 held-out,
C4 adapters, C5 DDR arbiter, C5 prod_top source, `a7ng_lm_graph_arb.sv`,
leftover A09, frozen LM-06 `tiny_gpt803k_core`, official `mig.prj`,
`ddr3_model`, or `mig_native_wrap`.
Does not freeze `DDR_QUERY_BOUND_FINAL` or `PERSIST_SCHEMA_VERSION`.
A09R8 is not this top. Does not overwrite routed `a7ng_astra_c6_wholechip.sv`.

## One unknown

After `init_calib_complete`, can UART → role parser → sparse DDR index →
descriptor fetch → shared scorer → typed proof → pending reward → C2 persist
→ evidence → compact LM06 gen → UART egress still complete in **one**
production hierarchy (`a7ng_astra_c5_prod_top` instantiated, not edited)
when the C5 exclusive-owner AXI AR/AW path goes through official Digilent
AXI MIG (`mig_7series_0_mig_sim` + `ddr3_model`) instead of the modeled
1-beat TB slave from `ASTRA-C5-PROD-TOP-01`?

TB-only: `defparam u_dut.u_c3.TO_CYC = 65535` (16-bit fact-fetch ceiling;
prod_top default 64 is a compact-slave bound, not KEEP). Plant stays in TB
(MIG AW mux while DUT held in reset). No in-DUT plant.

C5 `a7ng_astra_c5_axi1b` (inside prod_top, not KEEP) ACKs AR only when MIG
`arready` is high, waits for wrap to drop `arvalid`, captures R in S_R, and
drains leftover R in S_AR before a new AR. Prod_top also drains orphan R when
arbiter owner is NONE. First MIG runs livelocked on directory beat
`0504/0008/0007` (early AR ACK) then finished a 63-cycle fake walk on leftover
boot `rvalid`. GOLDEN was not regenerated. C6 routed bit remains the prior
this-gate image (not rebuilt). Post-PREREG prod_top axi1b/rready edits are
this bag's MIG handshake, not a KEEP edit.

## HIT letter this bag may measure (XSim MIG PHY)

```text
CLASS_mig_calib_complete
UART ingress bytes reach the role parser
parser + sparse index + descriptor path produce a C3 result
shared scorer + typed proof + pending commit visible
C2 persist journal at AWADDR=0x06000000 through owner=ckpt
evidence → compact LM06 gen → UART egress
six client grants observed; dual_err=0
qid-map / host-winner / A09 / in-DUT plant = 0
```

Unified Master regression (role reversal, 5-seed 4-arm, CONFLICT, 90%
language, 800k corpus, silicon) is **out of scope**. UART baud remains the
C5 sim localparam 8000/800 (quality bound). Compact C4 head, not 802k.
This bag must not self-stamp `C5_MASTER=CLOSED` or `BOARD_PASS`.

## Quality bound

Planted 2-hop facts written through MIG AW (same compact world as C5
prod-top), not 800k cartesian. UART is sim baud, not 115200. C3 timeout
override is TB `defparam` only; C6 routed default TO_CYC=64 is unchanged.

## FAIL if

- KEEP C0/C1/C2 hashes drift
- official `mig.prj` / `mig_native_wrap` hash drifts
- `a7ng_lm_graph_arb` edited
- A09 or `tiny_gpt803k_core` compiled as DUT
- STREAM-02 / ctx `8255a798` / synth `mig_7series_0_mig.v` compiled as DUT
- GOLDEN edited after xvlog
- PROGRAM=YES
- C6 wrap source overwritten, or KEEP C0/C1/C2 / arbiter / official MIG edited
  (prod_top axi1b handshake edits for this bag are recorded above, not KEEP)
