#!/usr/bin/env python3
"""One tick of C3→C6 auto loop.

Assign (v4-flash RTL or v4-pro reasoner) then check with deepseek-v4-pro.
Never stamps BOARD_PASS or Master close.

  python scripts/c3_c6_auto_tick.py
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIVE = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
STATE = ROOT / "loop" / "C3_C6_LOOP.json"
CONSULT = ROOT / "scripts" / "deepseek_consult.py"
DRAFTS = ROOT / "drafts"
PROMPTS = ROOT / "prompts"

BAGS = [
    "ASTRA-C3-HELD-OUT-01",
    "ASTRA-C3-HELD-OUT-RELOAD-01",
    "ASTRA-C4-LM06-BYTE256-CONTRACT-01",
    "ASTRA-C4-LM06-GROUNDED-GEN-01",
    "ASTRA-C5-DDR-ARB-01",
    "ASTRA-C5-PROD-TOP-01",
    "ASTRA-C6-OOC-PREFLIGHT-01",
    "ASTRA-C6-WHOLECHIP-COFIT-01",
    "ASTRA-C3-HELD-OUT-MIG-01",
    "ASTRA-C5-PROD-TOP-MIG-01",
    "ASTRA-C4-LM06-802K-GROUNDED-01",
    "ASTRA-C4-LM06-BYTE256-DICT-HELDOUT-01",
    "ASTRA-C3-HELD-OUT-800K-01",
    "ASTRA-C5-UNIFIED-REGRESSION-01",
    "ASTRA-C5-EDGE-MUTATION-01",
    "ASTRA-C5-DIRECT-FACT-01",
    "ASTRA-C3-HELD-OUT-800K-2HOP-01",
    "ASTRA-C3-HELD-OUT-800K-2HOP-MUT-01",
    "ASTRA-C5-HELDOUT-TRANSFER-01",
    "ASTRA-C5-HELDOUT-TRANSFER-MIG-01",
    "ASTRA-C5-FLUSH-RELOAD-MIG-01",
    "ASTRA-C5-UNIFIED-REGRESSION-MIG-01",
    "ASTRA-C6-WHOLECHIP-COFIT-02",
    "ASTRA-C3-HELD-OUT-800K-RELOAD-01",
    "ASTRA-C5-CONFLICT-01",
    "ASTRA-C6-WHOLECHIP-COFIT-03",
    "ASTRA-C5-CONFLICT-MIG-01",
    "ASTRA-C5-UNIFIED-REGRESSION-MIG-02",
    "ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RTL-01",
    "ASTRA-C3-HELD-OUT-800K-2HOP-CONFLICT-RELOAD-01",
    "ASTRA-C3-HELD-OUT-MIG-02",
    "ASTRA-C4-LM06-BYTE256-CTXCOPY-01",
    "ASTRA-C4-LM06-BYTE256-C3PROOF-01",
    "ASTRA-C5-PROD-TOP-C3PROOF-01",
    "ASTRA-C4-LM06-BYTE256-QPTEXT-01",
    "ASTRA-C5-PROD-TOP-QPTEXT-01",
    "ASTRA-C5-PROD-TOP-QPTEXT-MIG-01",
    "ASTRA-C5-QPTEXT-UNIFIED-MIG-01",
    "ASTRA-C5-QPTEXT-HELDOUT-MIG-01",
    "ASTRA-C4-LM06-GROUNDED-GEN-HELDOUT-20-01",
    "ASTRA-C4-LM06-BYTE256-ARLANG-01",
]

KEEP_REAL = """
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
C4 GROUNDED-GEN-HELDOUT-20 bag (one unknown = 20 held-out class IDs + 4 ablations on same compact head):
CLASS_grounded_acc_ge90 CLASS_w_zero_safe CLASS_w_corrupt_not_gold
CLASS_evid_removed_safe CLASS_evid_removed_halluc_le5 CLASS_not_tinygpt_802k
tok0==evid_obj is class-ID; do NOT stamp C4_MASTER or freeze LM06_BYTE256.
TINYGPT_802K=RETIRED_PER_GROK_550. PROGRAM=NO.
C4 ARLANG bag (one unknown = compact AR BYTE256 yes+dest-name, not TinyGPT):
CLASS_grounded_acc_ge90 CLASS_ar_yes_prefix CLASS_w_zero_safe
CLASS_w_corrupt_not_gold CLASS_evid_removed_safe CLASS_evid_removed_halluc_le5
Do not stamp C4_MASTER or freeze LM06_BYTE256. Dest-name still gated obj ports.
PROGRAM=NO.
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
C3 HELD-OUT-MIG bag (one unknown = same 5-seed 4-arm held-out after MIG calib, not 96-slot TB slave):
CLASS_mig_calib_complete CLASS_entities_disjoint CLASS_arm_A_learner
CLASS_arm_B_frozen CLASS_arm_C_shuffled CLASS_arm_D_perid
CLASS_gain_A_over_B CLASS_host_winner_zero
Instantiate existing a7ng_astra_c3_held_out. Do not edit KEEP. Do not compile synth mig.v.
Do not stamp C3_MASTER or BOARD_PASS. Planted 2-hop through MIG AW is a quality bound, not 800k.
C5 PROD-TOP-MIG bag (one unknown = same production hierarchy AXI through official MIG sim after calib, not modeled 1-beat TB):
CLASS_mig_calib_complete CLASS_uart_ingress CLASS_role_parser CLASS_sparse_index
CLASS_desc_retrieval CLASS_shared_scorer CLASS_typed_proof CLASS_pending_reward
CLASS_persist CLASS_evid_materializer CLASS_lm06_gen CLASS_uart_egress
CLASS_one_ddr_owner CLASS_six_clients CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut CLASS_ckpt_addr_06000000
Instantiate existing a7ng_astra_c5_prod_top. Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap.
TB defparam TO_CYC=65535 only. UART sim baud 8000/800 is a quality bound. Do not stamp C5_MASTER or BOARD_PASS.
C5 UNIFIED-REGRESSION bag (one unknown = same production hierarchy after first UART line):
CLASS_two_hop_answer CLASS_unrelated_unknown CLASS_role_reversal CLASS_parser_amb
CLASS_search_incomp CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_teacher_off
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top
CLASS_no_plant_in_dut
UART 0x0C/0x12/0x14/0x15 = flush/reload/freeze/learn. Modeled AXI not MIG.
KEEP C3 has no CONFLICT opcode — parser AMB is not ASTRA-05 contradiction.
Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap. Do not stamp C5_MASTER or BOARD_PASS.
Do not freeze DDR_QUERY_BOUND_FINAL. PROGRAM=NO. Plant stays in TB only.
C5 EDGE-MUTATION bag (one unknown = delete/replace/reverse of planted 2-hop second hop):
CLASS_base_two_hop CLASS_edge_delete CLASS_edge_replace CLASS_edge_reverse
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top
CLASS_no_plant_in_dut
Measure ans_o/p0_o/p1_o from DUT, not TB-fed scorecards. Modeled AXI not MIG.
KEEP C3 has no CONFLICT opcode. Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap.
Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO. Plant stays in TB only.
C5 DIRECT-FACT bag (one unknown = 1-hop ANSWER vs 2-hop ANSWER on later UART line):
CLASS_direct_fact CLASS_two_hop_novel CLASS_one_ddr_owner
CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top CLASS_no_plant_in_dut
Measure ans_o/p0_o/p1_o from DUT. 1-hop dest=11 p1=0; 2-hop dest=64 p0/p1 eids.
Modeled AXI not MIG. Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap.
Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO. Plant stays in TB only.
C5 HELDOUT-TRANSFER bag (one unknown = PRE distractor vs POST gold dest on prod_top):
CLASS_entities_disjoint CLASS_heldout_pre CLASS_reward_update
CLASS_heldout_post CLASS_heldout_changed CLASS_one_ddr_owner
CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top CLASS_no_plant_in_dut
Measure ans_o/p0_o from DUT. Freeze PRE dest=144; after +rew train POST dest=112.
Modeled AXI not MIG. Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap.
Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO. Plant stays in TB only.
C5 HELDOUT-TRANSFER-MIG bag (one unknown = same PRE/POST dest change through official MIG PHY):
CLASS_mig_calib_complete CLASS_entities_disjoint CLASS_heldout_pre
CLASS_reward_update CLASS_heldout_post CLASS_heldout_changed
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
Measure ans_o/p0_o from DUT. Freeze PRE dest=144; after +rew train POST dest=112.
Official mig_sim + ddr3_model. Do not compile synth mig.v. TB defparam TO_CYC=65535 only.
Do not edit KEEP / a7ng_lm_graph_arb / C6 wrap. Do not stamp C5_MASTER or BOARD_PASS.
PROGRAM=NO. Plant stays in TB only.
C5 FLUSH-RELOAD-MIG bag (one unknown = UART flush then C2 reload of planted persist through official MIG PHY):
CLASS_mig_calib_complete CLASS_two_hop_answer CLASS_flush_w0_zero
CLASS_c2_persist_reload CLASS_one_ddr_owner CLASS_no_qid_map
CLASS_no_host_winner CLASS_no_a09_top CLASS_no_plant_in_dut
Official mig_sim + ddr3_model. TB uart_ctl sends cmd then EOL 0x0A. Do not compile synth mig.v.
Do not edit KEEP C2 / a7ng_lm_graph_arb. Do not regenerate GOLDEN after FAIL.
Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO. Plant stays in TB only.
C3 HELD-OUT-800K-2HOP bag (one unknown = 5-seed 4-arm 2-hop on 800k cartesian facts):
CLASS_entities_disjoint CLASS_two_hop_indirect CLASS_arm_A_learner
CLASS_arm_B_frozen CLASS_arm_C_shuffled CLASS_arm_D_perid
CLASS_gain_A_over_B CLASS_host_winner_zero
Query is "<entity> feeds indirect" (ctx=2, S_EJ). DUT bag-local nb64k wrap.
Do not edit KEEP C3. Ctx-folded k0 overlay is a quality bound, not MIG, not silicon.
Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C3 HELD-OUT-800K-2HOP-MUT bag (one unknown = delete/replace/reverse after +rew):
CLASS_entities_disjoint CLASS_base_two_hop CLASS_edge_delete
CLASS_edge_replace CLASS_edge_reverse CLASS_host_winner_zero
Do not edit KEEP C3. Reverse is empty ctx-key for header=14, not a stored reverse chain.
Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C4 802K-GROUNDED bag (one unknown = TinyGPT-802k path from FPGA QUERY/PROOF bytes, host next-token=0):
CLASS_tinygpt803k_dut CLASS_not_compose_renderer CLASS_path_evid_lm_feedback_eos
CLASS_host_next_token_zero CLASS_eos_or_max CLASS_acc_reported
This named bag MAY compile tiny_gpt803k_core as DUT. Do not edit frozen tiny_gpt803k_core / a7lm06_pkg.
Do not compile a7ng_evidence_compose. Do not freeze LM06_BYTE256. CLASS_grounded_acc_ge90 is measured, not forced.
Do not stamp C4_MASTER or BOARD_PASS. PROGRAM=NO.
C3 HELD-OUT-800K-RELOAD bag (one unknown = retention after C2 persist_clr+reload on 800k 2-hop):
CLASS_entities_disjoint CLASS_host_winner_zero CLASS_awaddr_06000000
CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_c2_w0_match CLASS_retention_le5pp
C2 KEEP journals w0 only; w[1:31] TB-restore is a quality bound. Cartesian overlay not MIG.
Do not edit KEEP C3 / C2. Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C5 CONFLICT bag (one unknown = polarity contradiction on same dest, same C5 hierarchy):
CLASS_base_two_hop CLASS_conflict CLASS_conflict_no_upd
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
Positive 2-hop dest D then negative-polarity 2-hop dest D → ST_CONFLICT=5 ans=0 pend_cmt=0.
Two positive dests still RANK (held-out law). Do not copy A09 have_pos && fo != concl0.
A09 is not DUT. Modeled AXI not MIG. Live C3 wrap may emit opcode 5; KEEP C0/C1/C2 unedited.
C6-02 bit predates this C3 hash and is stale. Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO.
C6 WHOLECHIP-COFIT-03 bag (one unknown = routed fit+timing after live C3 polarity CONFLICT):
CLASS_device_fit CLASS_wns_ge0 CLASS_tns_0 CLASS_whs_ge0 CLASS_ths_0
CLASS_unrouted_0 CLASS_drc_clean CLASS_mig_user_design CLASS_c5_prod_inst
CLASS_no_a09_top CLASS_no_program_hw CLASS_cdc_reviewed
Judge RAW ROUTE_LETTERS.txt. C6-02 bit is stale and must not be programmed.
Do not stamp C6_MASTER or BOARD_PASS. PROGRAM=NO.
C5 CONFLICT-MIG bag (one unknown = polarity contradiction through official MIG PHY):
CLASS_mig_calib_complete CLASS_base_two_hop CLASS_conflict CLASS_conflict_no_upd
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
Official mig_sim + ddr3_model. plant=0 after axi_wr. TB defparam TO_CYC=65535 only.
Two positive dests still RANK. A09 is not DUT. Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO.
C5 UNIFIED-REGRESSION-MIG-02 bag (one unknown = polarity CONFLICT in the same MIG UART unified session):
CLASS_mig_calib_complete CLASS_two_hop_answer CLASS_conflict CLASS_conflict_no_upd
CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_unrelated_unknown
CLASS_role_reversal CLASS_parser_amb CLASS_teacher_off CLASS_search_incomp
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
Restore distractor facts after CONFLICT; do not rewrite C2 checkpoint. UART sim baud.
Do not stamp C5_MASTER or BOARD_PASS. PROGRAM=NO.
C3 800K-2HOP-CONFLICT-RTL bag (one unknown = 5-seed 4-arm 800k 2-hop on live CONFLICT C3 copy):
CLASS_entities_disjoint CLASS_two_hop_indirect CLASS_arm_A_learner CLASS_arm_B_frozen
CLASS_arm_C_shuffled CLASS_arm_D_perid CLASS_gain_A_over_B CLASS_host_winner_zero
CLASS_no_false_conflict
Bag-local nb64k N_BUCKETS=65536 MAX_PATH=16. Do not edit live C3 wrap. Two positive dests RANK.
Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C3 800K-2HOP-CONFLICT-RELOAD bag (one unknown = C2 w0 retention drop<=5pp on live CONFLICT C3 copy):
CLASS_entities_disjoint CLASS_host_winner_zero CLASS_awaddr_06000000
CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_c2_w0_match CLASS_retention_le5pp
CLASS_no_false_conflict
C2 KEEP journals w0 only; w[1:31] TB-restore. Bag-local CONFLICT nb64k. Not MIG. Not silicon.
Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C3 HELD-OUT-MIG-02 bag (one unknown = 5-seed 4-arm held-out through official MIG PHY on live CONFLICT C3):
CLASS_mig_calib_complete CLASS_entities_disjoint CLASS_arm_A_learner CLASS_arm_B_frozen
CLASS_arm_C_shuffled CLASS_arm_D_perid CLASS_gain_A_over_B CLASS_host_winner_zero
CLASS_no_false_conflict
Instantiate live a7ng_astra_c3_held_out. Official mig_sim + ddr3_model. Do not edit KEEP.
Two positive dests RANK. Do not stamp C3_MASTER or BOARD_PASS. PROGRAM=NO.
C4 BYTE256-CTXCOPY bag (one unknown = cand IDs from PROOF context bytes, not obj LUT):
CLASS_no_obj_lut CLASS_dict_fpga_visible CLASS_query_proof_bytes
CLASS_entities_disjoint CLASS_path_evid_lm_feedback_eos CLASS_host_next_token_zero
CLASS_grounded_acc_ge90 CLASS_unsupported_safe_ge95 CLASS_halluc_le5
CLASS_w_zero_differs CLASS_evid_replaced_changes CLASS_eos_or_max
CLASS_not_compose_renderer
DUT a7ng_astra_c4_lm06_byte256_ctxcopy. Instantiates BYTE256 only. No evid_obj port.
TB plants PROOF bytes. Extractive copy-head is a quality bound, not TinyGPT, not C4_MASTER.
Do not overwrite a7lm06_wmem.hex. Do not freeze LM06_BYTE256. PROGRAM=NO.
C4 BYTE256-C3PROOF bag (one unknown = PROOF bytes from live C3 ANSWER dest IDs via FPGA dict):
CLASS_c3_reasoner_instantiated CLASS_fpga_dict_from_c3_ans CLASS_entities_disjoint
CLASS_ans_matches_planted_dest CLASS_path_c3_dict_ctxcopy_eos CLASS_host_next_token_zero
CLASS_grounded_acc_ge90 CLASS_unsupported_safe_ge95 CLASS_halluc_le5
CLASS_w_zero_differs CLASS_evid_replaced_changes CLASS_eos_or_max
CLASS_not_compose_renderer
DUT a7ng_astra_c4_lm06_byte256_c3proof instantiates live C3 wrap + ctxcopy. Do not edit C3 wrap.
TB plants graph facts only. Extractive dest-dict copy is a quality bound, not TinyGPT, not C4_MASTER.
Do not overwrite a7lm06_wmem.hex. Do not freeze LM06_BYTE256. PROGRAM=NO.
C5 PROD-TOP-C3PROOF bag (one unknown = C5 hierarchy gen tok0 is FPGA dict of live C3 ANSWER dest):
CLASS_uart_ingress CLASS_role_parser CLASS_sparse_index CLASS_desc_retrieval
CLASS_shared_scorer CLASS_typed_proof CLASS_pending_reward CLASS_persist
CLASS_evid_materializer CLASS_lm06_gen CLASS_uart_egress CLASS_one_ddr_owner
CLASS_six_clients CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top
CLASS_no_plant_in_dut CLASS_ckpt_addr_06000000
CLASS_ans_matches_planted_dest CLASS_gen_tok0_fpga_dict_of_c3_ans
CLASS_host_next_token_zero CLASS_not_compose_renderer
DUT a7ng_astra_c5_prod_top_c4p. Do not edit live a7ng_astra_c5_prod_top.sv or C3 wrap.
Modeled AXI not MIG. Extractive dest-dict copy is a quality bound, not TinyGPT, not C5_MASTER.
PROGRAM=NO.
C4 BYTE256-QPTEXT bag (one unknown = weight glue tok0 then hop-2 object name from C3 QUERY/PROOF FPGA dict):
CLASS_c3_reasoner_instantiated CLASS_fpga_dict_query_proof CLASS_entities_disjoint
CLASS_query_proof_bytes CLASS_glue_from_weights CLASS_tok0_not_ans_dict
CLASS_ans_matches_planted_dest CLASS_path_qptext_glue_proof_eos CLASS_host_next_token_zero
CLASS_grounded_acc_ge90 CLASS_unsupported_safe_ge95 CLASS_halluc_le5
CLASS_w_zero_differs CLASS_evid_replaced_changes CLASS_eos_or_max
CLASS_not_compose_renderer
DUT a7ng_astra_c4_lm06_byte256_qptext instantiates live C3 wrap + qptext gen. Do not edit C3 wrap.
TB plants graph facts only. Glue-plus-object copy is a quality bound, not TinyGPT, not C4_MASTER.
Do not overwrite a7lm06_wmem.hex. Do not freeze LM06_BYTE256. PROGRAM=NO.
C5 PROD-TOP-QPTEXT bag (one unknown = C5 hierarchy tok0 is weight glue, tok1 is hop-2 object FPGA name):
CLASS_uart_ingress CLASS_role_parser CLASS_sparse_index CLASS_desc_retrieval
CLASS_shared_scorer CLASS_typed_proof CLASS_pending_reward CLASS_persist
CLASS_evid_materializer CLASS_lm06_gen CLASS_uart_egress CLASS_one_ddr_owner
CLASS_six_clients CLASS_no_qid_map CLASS_no_host_winner CLASS_no_a09_top
CLASS_no_plant_in_dut CLASS_ckpt_addr_06000000
CLASS_ans_matches_planted_dest CLASS_gen_tok0_glue_from_weights
CLASS_gen_tok1_hop2_obj_name CLASS_tok0_not_ans_dict
CLASS_host_next_token_zero CLASS_not_compose_renderer
DUT a7ng_astra_c5_prod_top_c4q. Do not edit live a7ng_astra_c5_prod_top.sv or C3 wrap.
Modeled AXI not MIG. Glue-plus-object copy is a quality bound, not TinyGPT, not C5_MASTER.
PROGRAM=NO.
C5 PROD-TOP-QPTEXT-MIG bag (one unknown = same c4q hierarchy AXI through official MIG sim after calib):
CLASS_mig_calib_complete CLASS_uart_ingress CLASS_role_parser CLASS_sparse_index
CLASS_desc_retrieval CLASS_shared_scorer CLASS_typed_proof CLASS_pending_reward
CLASS_persist CLASS_evid_materializer CLASS_lm06_gen CLASS_uart_egress
CLASS_one_ddr_owner CLASS_six_clients CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut CLASS_ckpt_addr_06000000
CLASS_ans_matches_planted_dest CLASS_gen_tok0_glue_from_weights
CLASS_gen_tok1_hop2_obj_name CLASS_tok0_not_ans_dict
CLASS_host_next_token_zero CLASS_not_compose_renderer
Instantiate existing a7ng_astra_c5_prod_top_c4q. Do not edit live prod_top / c4q / C3 wrap.
Official mig_sim + ddr3_model. TB defparam TO_CYC=65535 only. UART sim baud 8000/800.
Glue-plus-object copy through MIG PHY is a quality bound, not TinyGPT, not C5_MASTER.
PROGRAM=NO.
C5 QPTEXT-UNIFIED-MIG bag (one unknown = same c4q hierarchy unified UART plus polarity CONFLICT through official MIG):
CLASS_mig_calib_complete CLASS_two_hop_answer CLASS_conflict CLASS_conflict_no_upd
CLASS_flush_w0_zero CLASS_c2_persist_reload CLASS_unrelated_unknown
CLASS_role_reversal CLASS_parser_amb CLASS_teacher_off CLASS_search_incomp
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut
CLASS_ans_matches_planted_dest CLASS_gen_tok0_glue_from_weights
CLASS_gen_tok1_hop2_obj_name CLASS_not_compose_renderer
Instantiate existing a7ng_astra_c5_prod_top_c4q. Do not edit live prod_top / c4q / C3 wrap.
Official mig_sim + ddr3_model. Restore distractors after CONFLICT. UART sim baud.
Glue-plus-object copy is a quality bound, not TinyGPT, not C5_MASTER.
PROGRAM=NO.
C5 QPTEXT-HELDOUT-MIG bag (one unknown = same c4q hierarchy held-out PRE/POST through official MIG):
CLASS_mig_calib_complete CLASS_entities_disjoint CLASS_heldout_pre
CLASS_reward_update CLASS_heldout_post CLASS_heldout_changed
CLASS_one_ddr_owner CLASS_no_qid_map CLASS_no_host_winner
CLASS_no_a09_top CLASS_no_plant_in_dut CLASS_not_compose_renderer
Instantiate existing a7ng_astra_c5_prod_top_c4q. Do not edit live prod_top / c4q / C3 wrap.
Official mig_sim + ddr3_model. TB defparam TO_CYC=65535 only. UART sim baud 8000/800.
Held-out PRE dest=144 POST dest=112. Glue CLASS after TRAIN is extra, not GOLDEN.
Glue-plus-object copy is a quality bound, not TinyGPT, not C5_MASTER.
PROGRAM=NO.
"""


def load_state() -> dict:
    if STATE.is_file():
        return json.loads(STATE.read_text(encoding="utf-8"))
    return {
        "goal": "C3-C6 Master letter PASS with raw evidence",
        "checker_model": "deepseek-v4-pro",
        "implement_rtl_model": "deepseek-v4-flash",
        "bag_index": 0,
        "last_verdict": None,
        "ticks": 0,
        "master_c3": "OPEN",
        "master_c4": "OPEN",
        "master_c5": "OPEN",
        "master_c6": "OPEN",
        "board_pass": "REJECT",
    }


def save_state(st: dict) -> None:
    STATE.parent.mkdir(parents=True, exist_ok=True)
    st["updated"] = datetime.now(timezone.utc).isoformat()
    STATE.write_text(json.dumps(st, indent=2) + "\n", encoding="utf-8")


def run_consult(role: str, src: Path) -> tuple[Path | None, str | None]:
    env = os.environ.copy()
    env["PYTHONIOENCODING"] = "utf-8"
    env["PYTHONUTF8"] = "1"
    r = subprocess.run(
        [sys.executable, str(CONSULT), "--role", role, "--in", str(src), "--out", str(DRAFTS)],
        cwd=str(ROOT),
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        env=env,
    )
    print(r.stdout, end="")
    dest = None
    verdict = None
    for line in (r.stdout or "").splitlines():
        if line.startswith("DEEPSEEK_DRAFT="):
            dest = Path(line.split("=", 1)[1].split()[0])
            if not dest.is_absolute():
                dest = ROOT / dest
        if line.startswith("CHECKER_VERDICT="):
            verdict = line.split("=", 1)[1].split()[0]
    if r.returncode != 0 and dest is None:
        print(r.stderr, file=sys.stderr)
        raise SystemExit(r.returncode)
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
    return dest, verdict


def latest_drafts() -> list[Path]:
    files = sorted(DRAFTS.glob("*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    out = []
    for p in files:
        if p.name in ("README.md",) or "CURSOR_ACCEPT" in p.name:
            continue
        # C6 route 验收 must not be poisoned by placeholder DUT drafts.
        if "_rtl_" in p.name:
            continue
        out.append(p)
        if len(out) >= 4:
            break
    return out


def main() -> int:
    st = load_state()
    bag = BAGS[min(st.get("bag_index", 0), len(BAGS) - 1)]
    st["current_bag"] = bag
    st["ticks"] = int(st.get("ticks", 0)) + 1

    prior = latest_drafts()
    chk_in = PROMPTS / "_tick_checker.md"
    body = [
        f"# 验收 tick {st['ticks']} bag={bag}",
        "Checker model MUST be deepseek-v4-pro (not v4.1 — that id does not exist, not flash).",
        "Reject tautology scorecards. This loop never stamps BOARD_PASS.",
        "C3-C5 bags: MASTER_CLOSE=NO unless raw xsim CLASS HIT on real path.",
        "C6 WHOLECHIP: judge RAW ROUTE_LETTERS.txt WNS>=0 TNS=0 WHS>=0 THS=0 UNROUTED=0 DRC_ERROR_FATAL=0.",
        "Master DRC letter is ERROR/FATAL=0, not zero Warning. Documented REQP-1709 Warning does not fail this bag.",
        "Do not treat a DeepSeek .sv draft as the routed DUT. Live wrap a7ng_astra_c6_wholechip.sv is authority.",
        "MASTER_C6_BAG_HIT is not BOARD_PASS and not ASTRA_NATIVE_AI_BOARD_PASS.",
        "",
        "## Prior drafts (newest first)",
    ]
    for p in prior:
        snippet = p.read_text(encoding="utf-8", errors="replace")[:12000]
        body += [f"### {p.name}", "```", snippet, "```", ""]
    live_bag = LIVE / "results" / "A7-NATIVE-GRAPH" / bag
    body += ["", "## RAW live bag files (primary evidence, not Cursor prose)"]
    for name in (
        "ROUTE_LETTERS.txt",
        "TIMING_EXTRACT.txt",
        "UTIL_EXTRACT.txt",
        "KEEP_NETLIST.txt",
        "CLOSEOUT.md",
        "SHA256_POST.txt",
        "KEEP_VERIFY.txt",
        "xsim.log",
        "CLASS_EXTRACT.txt",
        "PREREG.md",
        "GOLD_HASH_PRE_XVLOG.txt",
    ):
        rp = live_bag / name
        if rp.is_file():
            raw = rp.read_text(encoding="utf-8", errors="replace")
            if name == "xsim.log" and len(raw) > 24000:
                snippet = raw[:8000] + "\n...\n# xsim.log truncated; tail follows (CLASS/marker live here)\n...\n" + raw[-16000:]
            else:
                cap = 24000 if name == "xsim.log" else 8000
                snippet = raw[:cap]
            body += [f"### {rp}", "```", snippet, "```", ""]
    acc = DRAFTS / "CURSOR_ACCEPT_C3_C6.md"
    if acc.is_file():
        body += ["## Cursor prior 验收", acc.read_text(encoding="utf-8", errors="replace")[:4000]]
    chk_in.write_text("\n".join(body), encoding="utf-8")

    _dest, verdict = run_consult("checker", chk_in)
    st["last_verdict"] = verdict or "UNKNOWN"
    st["last_checker_draft"] = str(_dest) if _dest else None

    if st["last_verdict"] != "ACCEPT":
        assign = PROMPTS / "_tick_assign.md"
        assign.write_text(
            f"""# Assignment after v4-pro REJECT/unknown
Current bag: {bag}
Last verdict: {st['last_verdict']}
Checker model: deepseek-v4-pro (NOT v4.1).
Do NOT emit a scorecard DUT (no acc_a_pp ports that become CLASS HIT).
C3 must measure 4 arms on parser→retrieval→32-feature learner vs frozen/shuffled/per-ID.
Disjoint entities. host winner=0. Instantiate KEEP, do not edit KEEP.
PROGRAM=NO. One unknown. Output WORK_ORDER + DUT/TB file plan for {bag} only.
{KEEP_REAL}
""",
            encoding="utf-8",
        )
        dest, _ = run_consult("reasoner", assign)
        st["last_assign_draft"] = str(dest) if dest else None
        rtl_in = PROMPTS / "_tick_rtl.md"
        latest = dest.read_text(encoding="utf-8", errors="replace")[:8000] if dest else ""
        rtl_in.write_text(
            f"""# RTL draft for {bag} after v4-pro reasoner
Output ONLY new named SystemVerilog DUT+TB drafts. Mark DRAFT.
Instantiate REAL KEEP listed below. Do not invent parser_keep.sv.
Do not put acc_a_pp / CLASS HIT as DUT input ports.
PROGRAM=NO. Gold hashed before xvlog. One unknown.
{KEEP_REAL}
## Reasoner WO (may be wrong — do not copy invented KEEP names)
```
{latest}
```
""",
            encoding="utf-8",
        )
        rdest, _ = run_consult("rtl", rtl_in)
        st["last_rtl_draft"] = str(rdest) if rdest else None

    st["board_pass"] = "REJECT"
    save_state(st)
    print(
        f"C3C6_TICK={st['ticks']} bag={bag} checker=deepseek-v4-pro "
        f"VERDICT={st['last_verdict']} MASTER_C3={st['master_c3']} BOARD_PASS=REJECT"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
