# WO — C1 new key law (Master FAIL routing)

Auditor 20260907T0940Z: R3 scoring polarity PASS_NARROW; law exclusion FAIL leak_n=10/11.
Cause: frozen k2=subj_cue[15:0], k3=obj_cue[15:0] have **no relation**; four-table union leaks entity-context distractors.

Do NOT patch C0 files (role extract, sparse, dir, lexicon). NEW named RTL + NEW bag.
Do NOT drop threshold. Do NOT relevant=router_union. Do NOT nid-derived keys.
Do NOT start N=4096. C1 800k OPEN. PROGRAM=NO.

NEW law id: `qse-v2-relbind-01`
- k0,k1 unchanged {subj,rel}/{obj,rel} from frozen extract
- k2 := {rel_id, subj_cue[7:0]}  k3 := {rel_id, obj_cue[7:0]}
- Rebuild N=256 directory/postings with the SAME function (host+RTL must match)
- Reuse R3 distractor EXCLUDED gold nids if labels unchanged; hash gold BEFORE xvlog
- PASS this bag only if DISTRACTOR leak_n=0 AND direct still retrieves its gold (rec of those gold ids >0)
- Frozen LAW_SEL=1 control must remain unpatched (hash-gate)

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-RELBIND-01/
New RTL (named, not overwrite):
  rtl/native_graph/query/a7ng_query_role_keys_relbind.sv
  rtl/native_graph/integrate/a7ng_query_axi_sparse_relbind.sv
  (instantiate frozen extract + dir + gate; do not copy-paste walker if you can wrap; do not edit a7ng_query_axi_sparse.sv)
