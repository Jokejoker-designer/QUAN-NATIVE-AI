# RTP independent review

Verdict: ACCEPT_PASS_NARROW_RETRIEVAL_TO_PROOF_CAUSALITY, based on inspected RTL/TB and stored XSim log. No fresh simulation was run by manager. Overall ACCEPT_PARTIAL_RESEARCH / REJECT_FINAL_PROMOTION remains.

The current RTP source buffers walker cand_id, computes FACT_BASE + (ID << 4), fetches AXI descriptors, clears the engine between queries and internally loads descriptor fields into the reasoner. There is no external load_v port and the inspected TB has no hierarchical edge-table write/force. load_from_tb_o=0 alone is not evidence; the source/interface inspection is the evidence.

Stored log confirms all four declared cases: BASE ANSWER 4/proof17,34; posting-drop UNKNOWN with descriptor34 still in AXI memory; descriptor-object-swap ANSWER7/proof17,34; unrelated UNKNOWN with nc=nl=ndir=0. Successive queries retire without resetting the DUT, giving useful narrow evidence against stale facts across these interventions. The old astra09_pipe hash remains 48c9e480cbf2f6820f61a379f95f948f942340fbf478f6fb036fa011212b488b.

This closes the specific dead candidate-ID-to-facts connection on this new, small-ID XSim path. It does not close all F1 production semantics, full identity, transport robustness or change the old SoC path.

Residuals before production promotion:

- S_R accepts f_rvalid and loads data without checking RID=2, RRESP=OKAY or RLAST for the single-beat fetch. No fetch timeout/status exists. Add preregistered wrong-RID/error/missing-last and stalled-response cases; never load a failed response as a fact.
- Descriptor subject/relation/object/eid are sliced to 8 bits even though walker ID is 20 bits; no descriptor identity consistency check against the requested ID. This is a narrow 8-bit descriptor law, not full-ID closure. Freeze a versioned full-ID schema before scale.
- w_ovf, qse_neg and qse_amb remain unused for result policy; context does not bind engine facts. Preserve these as F1 residuals, not silently closed by four success cases.
- Buffer counters are 5-bit and clear/load indices assume 16 slots. CAND_CAP[4:0] becomes zero for cap32. Freeze supported parameters or add guards/appropriate widths before extending cap; current default16 is the reviewed case.
- UNREL TB assertion only fails when nload!=0 AND status==ANSWER; log observes zero loads, but the assertion does not enforce zero fetches independently. Assert nc/nload/actual descriptor-AR count ==0 directly. Instrument actual fetch addresses/handshakes, not just load_from_tb_o tied zero.
- Original RTP bag has no SHA256.txt; LOCK.txt contains policy fields, no source hashes. observed-hashes.json is a manager observation now, not retroactive proof of pre-run freeze or run-source identity. Preserve it and freeze the next revision before its run.

Next direction is correct. Keep this result and original units. Close bounded RTP transport/identity/uncertainty residuals in a new revision, then develop F2/F3 with at least two admissible competing proofs, ranking before selection, FPGA-generated phi/pending state and scalar reward/txn only. Include the fixed-proof-validity control discovered in the earlier audit. F4 LM06 and F5 final SoC/timing remain open. No board/program or duplicate dispatch was performed.
