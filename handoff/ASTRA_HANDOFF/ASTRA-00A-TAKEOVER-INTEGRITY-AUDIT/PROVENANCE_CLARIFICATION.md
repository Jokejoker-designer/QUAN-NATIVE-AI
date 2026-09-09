# Provenance clarification from user path catalog

User clarification: existing Astra work is Grok implementation built from the old branch. Preserve and reconcile it; dirty status does not imply unknown project provenance or a requirement to rebuild.

FACT: all six entries in docs/ASTRA/authority/AUTHORITY_COPY_MANIFEST.json were checked against their recorded hashes and current original source files. All six clone copies match both. The earlier three byte mismatches were comparisons against the separate ASTRA_HANDOFF package, not failures of the historical copy manifest. Do not classify those copies as corrupt.

The original dirty-ownership.json remains an immutable first snapshot. Project-level provenance is now USER_ATTESTED_GROK_WORK_FROM_OLD_BRANCH. Exact per-file writer/session attribution and independent acceptance remain separate checks; quarantine means preserve in place, not move/delete/reject.

FACT: a final literal-path existence check confirms rtl/board/arty_a7_astra09_soc_top.sv is present, consistent with the user catalog. The earlier formatted lookup did not display its fields; absence of displayed fields was not evidence of a missing file. Preserve this wrapper.

Current master remains D:/FPGA/ASTRA_HANDOFF/ASTRA_NATIVE_AI_MASTER_V1.md. Historical gates should be mapped to its capability requirements, retaining valid evidence and rerunning only checks justified by source drift or missing coverage. No historical PASS report was edited or invalidated by this audit.

No RTL, old-lane state, session, scheduler, board, COM12 or frozen artifact was changed in this clarification.

