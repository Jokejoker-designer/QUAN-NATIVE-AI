# WO — ASTRA-C1-PAGE-SKIP-01

Auditor 20260907T1250Z ACCEPT_PARTIAL DIR-FULL16 (16-bit buckets). P2 lexicon shadow is NOT this bag.
Independent PLAN bag 5: min/max page skip bytes. Do NOT change key law / lexicon / N_BUCKETS.
Do NOT write independent audit tree. Do NOT edit KEEP bags. Do NOT edit stream-02 14f75db7 file.

ONE UNKNOWN: NEW named walker (copy-derived from stream-02, new filename) uses posting **min/max nid** in overflow/page headers to skip pages that cannot contain the merge cursor — does **early-gold emit stay ID-identical** to STREAM-02 N=256 control (direct {110,144,145}) AND **POST_R_BEATS < full-drain** on a high-occupancy class vs AXI-BEAT 14 R-beats / 256 B?

Use C0 frozen 59-word lexicon (include C0 path, **no bag lexicon shadow**). N=256. N_BUCKETS=4096 (not 65536 this bag).
leftover A09 off poke_v=0 PROGRAM=NO.
Do not freeze C1 800k / CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL.
Do not add context keys.

If posting format has no min/max today, add them only in NEW named dir page format used by this walker + host twin; do not patch a7ng_sparse_dir_axi.sv. If that requires a new page layout module, new file only.

Bag: results/A7-NATIVE-GRAPH/ASTRA-C1-PAGE-SKIP-01/
Marker ASTRA_C1_PAGE_SKIP_XSIM_PASS only if emit-identical on direct AND R-beats drop on high_occupancy vs AXI-BEAT baseline (print both).
Gold hash BEFORE xvlog.
