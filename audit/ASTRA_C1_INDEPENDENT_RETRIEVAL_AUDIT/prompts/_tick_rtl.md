# RTL draft for ASTRA-C6-WHOLECHIP-COFIT-01 after v4-pro reasoner
Output ONLY new named SystemVerilog DUT+TB drafts. Mark DRAFT.
Instantiate REAL KEEP listed below. Do not invent parser_keep.sv.
Do not put acc_a_pp / CLASS HIT as DUT input ports.
PROGRAM=NO. Gold hashed before xvlog. One unknown.

REAL KEEP (instantiate, do not edit, do not invent parser_keep.sv):
- rtl/native_graph/query/a7ng_query_role_extract.sv (C0 prefix cd7baf49)
- rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv (C1 KEEP e862208c)
- rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv (C1 KEEP a84bbf7e)
- rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv (32-feature SGD; freeze_i for arm B)
- rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv (C2 KEEP; reload bag only)
Do not compile STREAM-02 / ctx DUT 8255a798 / synth mig_7series_0_mig.v as DUT.
CAND_CAP_FINAL=16. poke_v held 0. PROGRAM=NO.
Held-out-01 CLASS names: CLASS_arm_A_learner CLASS_arm_B_frozen
CLASS_arm_C_shuffled CLASS_arm_D_perid CLASS_entities_disjoint
CLASS_host_winner_zero CLASS_gain_A_over_B
Reload bag CLASS names (one unknown = retention after C2 persist_clr+reload):
CLASS_entities_disjoint CLASS_host_winner_zero CLASS_awaddr_06000000
CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_c2_w0_match CLASS_retention_le5pp
Those CLASS lines must be measured from DUT outputs (v_q8 / cand / persist_w0 / acc),
not from TB-fed acc_a_pp ports.
C2 KEEP journals w0 only (128-bit beat at AWADDR=0x06000000). Do not edit KEEP.
Do not silent-extend C2 to 32 weights. Remaining w[1:31] TB-restore is a quality bound.
C4 BYTE256 CONTRACT bag (one unknown = wire/vocab/mask law, NOT 90% grounded gen):
CLASS_in_tok_width_8 CLASS_out_domain_0_255 CLASS_phys_head10_present
CLASS_mask_ge256 CLASS_hist_653_masked CLASS_hist_689_masked
CLASS_shared_byte_vocab CLASS_host_next_token_zero CLASS_hist_oracle_not_this_gold
Do not edit frozen LM-06 tiny_gpt803k_core / a7lm06_pkg. Do not overwrite 653/689/237/60 oracle.
Do not freeze LM06_BYTE256 in FINAL_CONTRACT. PROGRAM=NO. New named adapter only.
C4 GROUNDED-GEN bag (one unknown = tokens depend on weights AND evidence, not compose renderer):
CLASS_path_evid_lm_feedback_eos CLASS_host_next_token_zero
CLASS_w_normal_grounded CLASS_w_zero_safe CLASS_w_corrupt_not_gold
CLASS_evid_removed_safe CLASS_evid_replaced_changes CLASS_eos_or_max
CLASS_not_compose_renderer
Do not compile a7ng_evidence_compose or tiny_gpt803k_core as DUT.
Do not claim 90% Master close from a compact linear head. PROGRAM=NO.
C5 DDR-ARB bag (one unknown = six DDR clients, one owner, no mid-flight switch):
CLASS_six_clients CLASS_one_owner CLASS_no_midflight_switch
CLASS_dual_owner_zero CLASS_axi_only_grant CLASS_ckpt_addr_06000000
Do not edit a7ng_lm_graph_arb. Do not compile synth mig.v. Do not freeze DDR_QUERY_BOUND_FINAL.
A09R8 is not C5. PROGRAM=NO. New named 6-port arbiter only.
C5 PROD-TOP bag (one unknown = one production hierarchy, no forbidden shortcuts):
CLASS_uart_ingress CLASS_role_parser CLASS_sparse_index CLASS_desc_retrieval
CLASS_shared_scorer CLASS_typed_proof CLASS_pending_reward CLASS_persist
CLASS_evid_materializer CLASS_lm06_gen CLASS_uart_egress CLASS_one_ddr_owner
CLASS_six_clients CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top
CLASS_no_plant_in_dut CLASS_ckpt_addr_06000000
Do not use A09 as the production top. Do not compile tiny_gpt803k_core or synth mig.v.
Do not freeze DDR_QUERY_BOUND_FINAL. PROGRAM=NO. Plant stays in TB only.
C6 OOC-PREFLIGHT bag (one unknown = OOC resource estimate of changed C3-C5 blocks):
CLASS_ooc_parser CLASS_ooc_index CLASS_ooc_proof_learner CLASS_ooc_persist
CLASS_ooc_lm_autoreg CLASS_ooc_prod_top CLASS_no_a09_top CLASS_no_mig_synth
CLASS_no_wholechip_wns CLASS_envelope_reported
OOC synth only. Do not run whole-chip route. Do not stamp C6_MASTER or BOARD_PASS.
A09R8 is not C6 co-fit. Do not compile synth mig.v or tiny_gpt803k_core.
Preferred LUT<=40k FF<=50k BRAM36eq<=115 DSP<=32 is envelope, not hard fail.
C6 WHOLECHIP-COFIT bag (one unknown = routed fit+timing of C5 prod_top + official MIG):
CLASS_device_fit CLASS_wns_ge0 CLASS_tns_0 CLASS_whs_ge0 CLASS_ths_0
CLASS_unrouted_0 CLASS_drc_clean CLASS_mig_user_design CLASS_c5_prod_inst
CLASS_no_a09_top CLASS_no_program_hw CLASS_cdc_reviewed
CLASS_drc_clean means DRC ERROR/FATAL=0 (Master letter). A documented Warning (e.g. REQP-1709) is not a miss.
In-context synth/place/route. A09R8 is not this top. Do not compile synth mig.v as DUT.
Do not freeze DDR_QUERY_BOUND_FINAL. PROGRAM=NO. Unique bit is evidence only, not BOARD_PASS.

## Reasoner WO (may be wrong — do not copy invented KEEP names)
```
## WORK_ORDER — ASTRA-C6-WHOLECHIP-COFIT-01

**Last verdict:** REJECT  
**Checker model:** deepseek-v4-pro, NOT v4.1  
**Bag:** ASTRA-C6-WHOLECHIP-COFIT-01 only  

### Classification
- **FACT:** C0/C1/C2 KEEP block hashes and C5 PROD-TOP inputs are fixed. KEEP blocks must be instantiated, not edited.
- **UNKNOWN — exactly one bag unknown:** routed fit + timing of the C5 `prod_top` + official Xilinx 7-series MIG on the target device.
- No additional unknown may be introduced for acceptance.
- No BOARD_PASS, no C6_MASTER stamping. Unique bit is evidence only.

---

## 1. Scope

Whole-chip, post-route co-fit of:

1. Accepted C5 production top, instantiated as `c5_prod_inst`
2. Official Xilinx 7-series MIG user design, not the synth MIG model
3. Target device: Arty A7-100T / XC7A100T class

**Non-goals:**
- Do not use A09R8 as this top.
- Do not compile `synth mig.v` / `synth mig_7series_0_mig.v` as DUT.
- Do not compile `tiny_gpt803k_core`, `a7ng_evidence_compose`, STREAM-02, or ctx DUT 8255a798.
- Do not create a scorecard DUT with `acc_a_pp_*` class-hit ports.
- Do not freeze `DDR_QUERY_BOUND_FINAL`.
- Do not freeze `PERSIST_SCHEMA_VERSION`.
- PROGRAM=NO.

---

## 2. DUT/TB File Plan

### DUT Hierarchy

```
a7ng_astra_c6_wholechip_top            -- new named top
├── c5_prod_inst                        -- accepted C5 PROD-TOP wrapper, no edit
│     └── inherited C0/C1/C2 KEEP blocks
│           ├── a7ng_query_role_extract.sv
│           ├── a7ng_query_role_relctx_synonym.sv
│           ├── a7ng_query_axi_sparse_intersect_synonym.sv
│           ├── a7ng_shared_rank_sgd_q8_sym_f2r2.sv
│           └── a7ng_astra_c2_persist_commit.sv
├── official MIG IP user design         -- official Xilinx MIG, not synth mig.v
└── no A09 top, no acc_a_pp ports
```

### Planned DUT Files

Only top-level wrapper and build files are new. No KEEP edits.

| File | Role |
|---|---|
| `rtl/native_graph/integrate/a7ng_astra_c6_wholechip_top.sv` | New C6 top wrapper only |
| `rtl/native_graph/query/a7ng_query_role_extract.sv` | KEEP C0 `cd7baf49`, instantiate |
| `rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv` | KEEP C1 `e862208c`, instantiate |
| `rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv` | KEEP C1 `a84bbf7e`, instantiate |
| `rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv` | KEEP SGD, instantiate |
| `rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv` | KEEP C2, instantiate |
| Accepted C5 PROD-TOP wrapper | Input from C5 PROD-TOP bag; do not edit |
| Official MIG IP `mig_7series_0.xci` | Official MIG user design |
| `xdc/arty_a7_100t_c6_wholechip.xdc` | Pin constraints, clocks, CDC review constraints |
| `tcl/c6_wholechip_build.tcl` | Vivado synth/place/route/report flow |

### Planned TB Files

Only optional functional smoke; implementation classes come from Vivado reports and netlist checks.

| File | Role |
|---|---|
| `tb/astra_c6_wholechip_smoke_tb.sv` | Optional top-level UART/clock/reset smoke TB |
| No `acc_a_pp_*` sideband ports | Forbidden in DUT and TB |
| No scorecard DUT | Forbidden |

### Build/Route Flow

1. Read KEEP files and accepted C5 PROD-TOP.
2. Read official MIG IP XCI, not synth MIG.
3. Read top XDC.
4. Set top to `a7ng_astra_c6_wholechip_top`.
5. `synth_design`
6. `place_design`
7. `route_design`
8. Run reports:
   - `report_utilization -hierarchical`
   - `report_timing_summary`
   - `report_route_status`
   - `report_drc`
   - CDC review report
9. Write unique bitstream only as evidence, labeled `evidence_only=1`.
10. Do not stamp BOARD_PASS or C6_MASTER.

---

## 3. One-Unknown Measurement

**Single unknown:** routed fit + timing of C5 `prod_top` + official MIG.

This is measured only from DUT implementation reports, netlist hierarchy, and routed design status. It is not measured from TB-fed `acc_a_pp` ports.

| Class | DUT/implementation measurement |
|---|---|
| `CLASS_device_fit` | Post-route utilization report shows no overmapping on target device |
| `CLASS_wns_ge0` | Post-route worst negative setup slack `WNS >= 0` |
| `CLASS_tns_0` | Post-route total negative setup slack `TNS == 0` |
| `CLASS_whs_ge0` | Post-route worst negative hold slack `WHS >= 0` |
| `CLASS_ths_0` | Post-route total negative hold slack `THS == 0` |
| `CLASS_unrouted_0` | Post-route route status: `unrouted == 0` |
| `CLASS_drc_clean` | DRC `ERROR/FATAL == 0`; documented Warning such as REQP-1709 allowed |
| `CLASS_mig_user_design` | DUT netlist contains official MIG user design instance, not synth MIG |
| `CLASS_c5_prod_inst` | DUT netlist contains `c5_prod_inst` from C5 PROD-TOP |
| `CLASS_no_a09_top` | DUT top is not A09R8; no A09 top instance |
| `CLASS_no_program_hw` | PROGRAM=0 tie-off present; no program HW hierarchy |
| `CLASS_cdc_reviewed` | CDC review report exists; no unreviewed CDC crossings |

---

## 4. Acceptance

- All 12 C6-WHOLECHIP-COFIT class lines must be measured from DUT implementation outputs/reports, not TB sideband.
- No scorecard DUT ports may be used.
- Generated bitstream is **evidence only**, not BOARD_PASS.
- No `DDR_QUERY_BOUND_FINAL` freeze.
- No PROGRAM hardware.
- On any class miss, verdict remains FAIL/REJECT and the bag must be re-run after correcting build/constraint issues.

**Output:** C6 wholechip co-fit evidence for ASTRA-C6-WHOLECHIP-COFIT-01 only.
```
