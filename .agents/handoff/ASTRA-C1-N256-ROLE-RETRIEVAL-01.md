# WO — C1 first rung: N=256 role-law retrieval (not 800k)

CWD: D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH
Master V1.1 §7. C0 auditor 20260907T0745Z ACCEPT_PARTIAL. Historical ASTRA-02-U5 800k does NOT close C1.

ONE UNKNOWN: with frozen qse-v2-role-00 + frozen sparse dir (C0 hashes), at N=256, do the required query classes retrieve with independent gold, no host semantic route, no cap≥N as selectivity?

PROGRAM=NO. No JTAG. No new bit. No V3.1. Do not patch frozen RTL (instantiate only).
Do not inspect/generate N>256 in this bag. Do not freeze CAND_CAP_FINAL.

Hash-gate vs C0 FINAL_CONTRACT before xvlog:
- a7ng_query_role_extract.sv cd7baf49…
- qse_role_lexicon.svh 38189974…
- a7ng_sparse_dir_axi.sv 09334e42…
- a7ng_query_axi_sparse.sv 5a4ad04d…
- a7ng_shared_rank_sgd_q8_sym_f2r2.sv b66ef328… (may instantiate or omit; retrieval is the unknown)
- leftover a7ng_astra_09_integ_path.sv NOT compiled as DUT

Required classes (each with independent gold, not router_union):
direct relevant, supported paraphrase, role reversal, same entity/wrong relation,
same relation/wrong context, entity-context distractor, unrelated,
adversarial high-occupancy bucket, relevant in overflow page, high-ID sentinel near 255.

Metrics: recall, precision per class, candidate count, reduction (must not use cap>=256 as proof),
directory/posting/descriptor/discard bytes, overflow count, SEARCH_INCOMPLETE if relevant beyond budget.

PASS this bag only if XSim FAIL=0 and no class is closed by tautology.
RESULT=PASS_THIS_GATE_ONLY. C1 800k remains OPEN.
Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/
