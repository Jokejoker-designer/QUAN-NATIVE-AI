# WO — C1 k0∩k1 intersect law

Auditor 20260907T0955Z ACCEPT_PARTIAL (relbind measured). leak 10→9. Remaining = k0∪k1 (WO∪WE).
On PSC query, k0 posting = pump supplies *; k1 = * supplies chiller; **k0∩k1 = {110,144,145} = direct gold**.

NEW named law `qse-v2-intersect-01`: emit candidates in **both** k0 and k1 when both valid.
Do NOT patch C0 files. Do NOT drop threshold. Do NOT relevant=router_union. Do NOT nid keys.
Do NOT another k2/k3-only rebind. Do NOT start N=4096.

Reuse relbind keys (instantiate frozen extract + a7ng_query_role_keys_relbind).
New walker/integrator file. Keep R3 excluded gold polarity (leak=FAIL). Query "pump supplies chiller".

PASS iff leak_n=0 AND direct_tp>0 (expect {110,144,145}).
Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-KEY-INTERSECT-01/
PROGRAM=NO. C1 800k OPEN.
