# WO — ASTRA-C1-SEMANTIC-16K-01

Auditor 20260907T1415Z ACCEPT_PARTIAL CONTEXT-02. P1 none.
Independent PLAN bag 7: semantic corpus ladder. This bag is **N=16384 first semantic rung**, not 800k close.

Do NOT write independent tree. Do NOT 12-entity clone corpus. Do NOT BOARD_PASS. C1 800k OPEN.

ONE UNKNOWN: N=16384 facts with **distinct entity/relation mass** (not max_subj=12 clones), independent gold, law `qse-v2-intersect-context-02` (instantiate ctx keys + stream-02 walker, do not edit 14f75db7 / 124be808 unless hash-gate MATCH instantiate), does recall of labeled gold hold on required retrieve classes without SEARCH_INCOMPLETE hiding misses?

Required: ≥100 distinct subj ids, ≥8 rel ids, gold not cloned text. Direct + paraphrase + unrelated + one late-gold. SEARCH_INCOMPLETE on gold_n>=1 retrieve = FAIL.
CAND_CAP=16 after emit not FINAL. leftover A09 off poke_v=0 PROGRAM=NO.
C0 lexicon: if 59 words cannot name 100 entities, FAIL honestly or use bag-local **named** lexicon file with its own SHA (do not shadow C0 path silently — register in RESULTS as NEW lexicon law id).

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/
Marker ASTRA_C1_SEMANTIC_16K_XSIM_PASS only if FAIL=0.
Gold hash BEFORE xvlog.
