# WO — ASTRA-C1-DIR-FULL16-01

Auditor 20260907T1215Z ACCEPT_PARTIAL N=4096 stream-02. P1 none.
Independent PLAN bag 4: 16-bit exact bucket. Do NOT change merge scheduler.
Do NOT write independent audit tree. Do NOT edit KEEP bags.

ONE UNKNOWN: instantiate frozen `a7ng_sparse_dir_axi` with **N_BUCKETS=65536** (parameter, do not patch C0 file) + same stream-02 walker (instantiate, do not edit 14f75db7…) so two facts whose 16-bit keys share a 12-bit nibble **do not collide**.

Control: same queries on 4096-bucket layout would alias; FULL16 must retrieve the intended nid only.

Corpus: small N (256 ok) with entity ids that collide in 12 bits (e.g. subj 10 vs 10+4096). Independent gold. Direct still hits. leftover A09 off poke_v=0 PROGRAM=NO.
No context keys. No page-skip. No C1 800k freeze. No CAND_CAP_FINAL.

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-DIR-FULL16-01/
Marker ASTRA_C1_DIR_FULL16_XSIM_PASS only if alias-pair retrieves the correct nid and no 12-bit collision emit.
Hash-gate C0 files MATCH (dir file hash unchanged even if instantiated N_BUCKETS=65536).
