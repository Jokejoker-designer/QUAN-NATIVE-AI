# WO — C1 N=4096 same law qse-v2-intersect-01

Auditor 20260907T1020Z ACCEPT_PARTIAL on KEY-INTERSECT at N=256. P1 none for that unknown.
Parent: next = **scale only**. Same law. Not C2. Not 800k. Not a new key law.

LAW: qse-v2-intersect-01 (k0∩k1, instantiate a7ng_query_axi_sparse_intersect.sv — do not edit it unless hash-gate still MATCH live SHA from KEY-INTERSECT bag).
C0 frozen files MATCH. Relbind instantiate not edit.

ONE UNKNOWN: at N=4096, same intersect law + independent gold + required classes, does distractor leak_n=0 on excluded gold AND direct still retrieve gold AND no cap>=N selectivity?

Required classes: direct, paraphrase, role_reversal, wrong_relation, wrong_context(NOT_SELECTIVE if keys match), distractor EXCLUDED leak=FAIL, unrelated UNRELATED_EMPTY_WALK, high_occupancy, overflow_page, high_id_sentinel near 4095.

Gold hash BEFORE xvlog. Never regen after FAIL. leftover A09 off. poke_v=0. PROGRAM=NO.
Do not emit cap/N as reduction_x1000. Master ≥90% reduction is posting-selectivity at N>=4096 — report real posting bytes / emit, not 1-16/4096.
CAND_CAP=16 still (not CAND_CAP_FINAL). SEARCH_INCOMPLETE if relevant beyond budget — never false UNKNOWN.

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-N4096-INTERSECT-01/
PASS marker ASTRA_C1_N4096_INTERSECT_XSIM_PASS only if FAIL=0 leak_n=0 direct_tp>0.
C1 800k OPEN. N=16384 not this bag.
