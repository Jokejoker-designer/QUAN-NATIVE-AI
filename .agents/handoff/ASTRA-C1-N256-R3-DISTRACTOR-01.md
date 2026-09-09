# WO — C1 N=256 R3 distractor polarity

Do NOT edit ASTRA-C1-N256-ROLE-RETRIEVAL-01 or ASTRA-C1-N256-R2-ROLE-RETRIEVAL-01.
Auditor 20260907T0915Z ACCEPT_PARTIAL (reporting only). P1 distractor polarity.

Parent freeze for this bag:
- Distractor gold = **excluded** evidence=1 nids (entity-context overlap), gold_n>=1.
- Presence of any excluded id in emit = FAIL DISTRACTOR_LEAK (fp), never tp/rec=1000.
- Do NOT reuse query "supply duct" + gold {72,73,74,75}.
- Suggested: target query "pump supplies chiller"; excluded = overlapping wrong-entity / wrong-relation / wrong-object records sharing tokens.
- Keep R2 reporting: fp_ev1/fp_fill0, UNRELATED_EMPTY_WALK, NOT_SELECTIVE, no cap/N reduction.
- Do not patch C0 RTL. Direct prec~187 is frozen four-table union, not this bag's unknown.
- Gold hash ONCE before first xvlog. Never regen after FAIL.

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-N256-R3-DISTRACTOR-01/
PROGRAM=NO. N=4096 NOT STARTED. C1 800k OPEN.
