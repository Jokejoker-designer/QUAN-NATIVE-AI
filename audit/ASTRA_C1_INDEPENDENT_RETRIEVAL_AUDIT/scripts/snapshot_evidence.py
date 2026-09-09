#!/usr/bin/env python3
"""Copy Grok C1 evidence into the independent tree. Does not write Grok trees.

Skips corpus.json, xsim_work/, and files larger than 8 MiB.
"""
from __future__ import annotations

import hashlib
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path

GROK = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")
DEST = Path(__file__).resolve().parents[1] / "snapshots"
MAX_BYTES = 8 * 1024 * 1024

BAGS = [
    "ASTRA-C1-AXI-BEAT-ACCOUNTING-01",
    "ASTRA-C1-KEY-INTERSECT-01",
    "ASTRA-C1-N4096-INTERSECT-01",
    "ASTRA-C1-STREAM-INTERSECT-02",
    "ASTRA-C1-N4096-STREAM-02",
    "ASTRA-C1-DIR-FULL16-01",
    "ASTRA-C1-PAGE-SKIP-01",
    "ASTRA-C1-CONTEXT-02",
    "ASTRA-C1-SEMANTIC-16K-01",
    "ASTRA-C1-SEMANTIC-HELDOUT-01",
    "ASTRA-C1-SEMANTIC-UNSEEN-SRO-01",
    "ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01",
    "ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-R2-01",
    "ASTRA-C1-SEMANTIC-NL-01",
    "ASTRA-C1-SYNONYM-LAW-01",
    "ASTRA-C1-N65536-SCALE-01",
    "ASTRA-C1-N262144-SCALE-01",
    "ASTRA-C1-N800000-SCALE-01",
    "ASTRA-C1-CAND-CAP-SWEEP-01",
    "ASTRA-C1-SEMANTIC-800K-01",
]

BAG_FILES = [
    "GOLDEN.json",
    "CLOSEOUT.md",
    "RESULTS.md",
    "PREREG.md",
    "xsim.log",
    "GOLD_HASH_PRE_XVLOG.txt",
    "SHA256.txt",
    "FAIL_R0.md",
]

AUDITORS = [
    "20260907T1455Z",
    "20260907T1550Z",
    "20260907T1705Z",
    "20260907T1755Z",
    "20260907T1835Z",
    "20260907T1910Z",
    "20260907T1955Z",
    "20260907T2045Z",
    "20260907T2148Z",
]

RTL = [
    Path("rtl/native_graph/query/a7ng_query_role_extract.sv"),
    Path("rtl/native_graph/query/qse_role_lexicon.svh"),
    Path("rtl/native_graph/query/qse_relctx_synonym_01.svh"),
    Path("rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv"),
    Path("rtl/native_graph/query/a7ng_query_role_keys_ctx.sv"),
    Path("rtl/native_graph/query/a7ng_route_valid_gate.sv"),
    Path("rtl/native_graph/memory/a7ng_sparse_dir_axi.sv"),
    Path("rtl/native_graph/integrate/a7ng_query_axi_sparse.sv"),
    Path("rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv"),
    Path("rtl/native_graph/integrate/a7ng_query_axi_sparse_page_skip.sv"),
    Path("rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv"),
    Path("rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv"),
]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def copy_file(src: Path, dst: Path, manifest: list[dict]) -> None:
    if not src.is_file():
        manifest.append({"src": str(src), "copied": False, "reason": "missing"})
        return
    size = src.stat().st_size
    if size > MAX_BYTES:
        manifest.append(
            {
                "src": str(src),
                "copied": False,
                "reason": f"too_large_{size}",
                "sha256": sha256_file(src),
                "size": size,
            }
        )
        return
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    manifest.append(
        {
            "src": str(src),
            "dst": str(dst),
            "copied": True,
            "size": size,
            "sha256": sha256_file(src),
        }
    )


def main() -> int:
    DEST.mkdir(parents=True, exist_ok=True)
    manifest: list[dict] = []

    copy_file(GROK / "docs" / "ASTRA" / "LOOP_STATE.json", DEST / "LOOP_STATE.json", manifest)
    copy_file(
        GROK / ".agents" / "handoff" / "ASTRA-C1-SEMANTIC-800K-01.md",
        DEST / "handoff" / "ASTRA-C1-SEMANTIC-800K-01.md",
        manifest,
    )
    copy_file(
        GROK / ".agents" / "handoff" / "ASTRA-C1-N65536-SCALE-01.md",
        DEST / "handoff" / "ASTRA-C1-N65536-SCALE-01.md",
        manifest,
    )
    copy_file(
        GROK / "docs" / "ASTRA" / "authority" / "OPEN_GATES.md",
        DEST / "authority" / "OPEN_GATES.md",
        manifest,
    )
    copy_file(
        GROK / "docs" / "ASTRA" / "authority" / "ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md",
        DEST / "authority" / "ASTRA_NATIVE_AI_MASTER_V1_1_POST_SILICON_FINAL.md",
        manifest,
    )

    for stamp in AUDITORS:
        src = GROK / "results" / "A7-NATIVE-GRAPH" / "AUDITOR" / stamp / "REPORT.md"
        copy_file(src, DEST / "AUDITOR" / stamp / "REPORT.md", manifest)

    bag_root = GROK / "results" / "A7-NATIVE-GRAPH"
    for bag in BAGS:
        present = (bag_root / bag).is_dir()
        if not present:
            manifest.append({"bag": bag, "copied": False, "reason": "bag_absent"})
            continue
        for name in BAG_FILES:
            copy_file(bag_root / bag / name, DEST / "bags" / bag / name, manifest)

    rtl_hashes = {}
    for rel in RTL:
        p = GROK / rel
        rtl_hashes[rel.as_posix()] = {
            "present": p.is_file(),
            "sha256": sha256_file(p) if p.is_file() else None,
            "mtime": p.stat().st_mtime if p.is_file() else None,
            "size": p.stat().st_size if p.is_file() else None,
        }
    (DEST / "rtl_hashes.json").write_text(
        json.dumps(rtl_hashes, indent=2) + "\n", encoding="utf-8"
    )
    manifest.append({"dst": str(DEST / "rtl_hashes.json"), "copied": True, "kind": "rtl_hashes"})

    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": str(GROK),
        "dest": str(DEST),
        "copied_n": sum(1 for m in manifest if m.get("copied")),
        "missing_n": sum(1 for m in manifest if not m.get("copied")),
        "files": manifest,
    }
    (DEST / "MANIFEST.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"copied": summary["copied_n"], "missing": summary["missing_n"]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
