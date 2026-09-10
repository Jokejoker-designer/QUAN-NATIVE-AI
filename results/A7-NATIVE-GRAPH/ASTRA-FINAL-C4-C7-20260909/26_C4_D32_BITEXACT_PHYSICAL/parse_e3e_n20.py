#!/usr/bin/env python3
"""Parse E3e report_timing -max_paths 20. Does not touch E3a/E3d files.

Classifies the worst destination so the next cut is measured:
  vv_wdata  → E3e cone not cut (stay in S_V; do not expand to Q/K)
  qv_wdata  → E3f S_Q only
  kv_wdata  → E3f S_K only
  other named site → new measured gate after this top-N
"""
from __future__ import annotations

from collections import Counter
from pathlib import Path
import hashlib
import json
import re
import sys

BAG = Path(__file__).resolve().parent
sys.path.insert(0, str(BAG))
import parse_e3a_n20 as p  # noqa: E402

p.RPT = BAG / "timing_n20_e3e.rpt"
E3D_WNS = -24.357
PROGRAM_NO = "NO"


def dest_family(name: str | None) -> str:
    n = (name or "").lower()
    checks = (
        ("vv_wdata", "vv_wdata"),
        ("qv_wdata", "qv_wdata"),
        ("kv_wdata", "kv_wdata"),
        ("x_wdata", "x_wdata"),
        ("zv_wdata", "zv_wdata"),
        ("logits_wdata", "logits_wdata"),
        ("tv_reg", "tv"),
        ("val0", "f1_rq"),
        ("rq_val", "rq_snap"),
        ("rq_q", "rq_snap"),
        ("acc_reg", "acc"),
        ("dots", "dots"),
        ("hv_reg", "hv"),
        ("yv_reg", "yv"),
        ("elut", "smres"),
        ("attn", "smres"),
        ("eden", "smres"),
        ("acc1", "smres"),
    )
    for needle, fam in checks:
        if needle in n:
            return fam
    if re.search(r"\bhv\[", n) or n.startswith("hv["):
        return "hv"
    if re.search(r"\byv\[", n) or n.startswith("yv["):
        return "yv"
    return "other"


def next_gate(dst_fam: str, src: str | None = None, levels: int | None = None) -> tuple[str, str]:
    src_l = (src or "").lower()
    if dst_fam == "qv_wdata":
        return (
            "E3f_S_Q",
            "Worst dest is qv_wdata. Instantiate the existing rq_mcycle on S_Q only. Do not silently refactor S_K/S_V.",
        )
    if dst_fam == "kv_wdata":
        return (
            "E3f_S_K",
            "Worst dest is kv_wdata. Instantiate the existing rq_mcycle on S_K only. Do not silently refactor S_Q/S_V.",
        )
    if dst_fam == "vv_wdata":
        if "di_reg" in src_l and (levels is None or levels >= 30):
            return (
                "E3e_SV_NOT_CUT",
                "vv_wdata still worst from di_reg at high logic depth: snapshot did not cut the S_V cone. Stay in S_V. Do not expand to Q/K.",
            )
        if "rq_" in src_l or (levels is not None and levels < 20):
            return (
                "E3e2_SV_SAT",
                "vv_wdata still worst but cone looks like leftover c4_sat(rq_q) in S_V_FIN. Pipeline sat in S_V only. Do not expand to Q/K.",
            )
        return (
            "E3e_SV_NOT_CUT",
            "vv_wdata still worst: E3e did not cut the S_V cone (or leftover c4_sat in S_V_FIN). Stay in S_V. Do not expand to Q/K.",
        )
    if dst_fam in ("x_wdata", "dots", "hv", "yv", "zv_wdata", "logits_wdata", "rq_snap"):
        return (
            f"E3g_{dst_fam}",
            f"New named site {dst_fam}. New measured cut after this top-N. Do not silently expand E3e/E3f.",
        )
    if dst_fam == "smres":
        return (
            "SMRES_RECHECK",
            "SMRES-named cells returned to top-N. Re-read the path before another divider change.",
        )
    return (
        "READ_TOPN",
        "Unclassified dest. Read timing_n20_e3e.rpt before any RTL.",
    )


def build_payload(rpt: Path) -> dict:
    text = rpt.read_text(encoding="utf-8", errors="replace")
    paths = [p.parse_path(b, i) for i, b in enumerate(p.split_paths(text))]
    for x in paths:
        x["dest_family"] = dest_family(x.get("destination"))
    n_smres = sum(1 for x in paths if x["smres_name_hit"] > x["weight_name_hit"])
    n_weight = sum(1 for x in paths if x["weight_name_hit"] > x["smres_name_hit"])
    src0 = paths[0]["source"] if paths else None
    dst0 = paths[0]["destination"] if paths else None
    fam0 = dest_family(dst0)
    levels0 = paths[0].get("logic_levels") if paths else None
    gate, why = next_gate(fam0, src0, levels0)
    fam_counts = dict(Counter(x["dest_family"] for x in paths))
    wns = paths[0]["slack_ns"] if paths else None
    return {
        "PROGRAM": PROGRAM_NO,
        "C4_MASTER": "OPEN",
        "ASTRA_NATIVE_AI_BOARD_PASS": "OPEN",
        "e3e": "TOPN_PARSED" if paths else "EMPTY",
        "scope": "S_V_ONLY",
        "e3d_wns_ns": E3D_WNS,
        "e3e_wns_ns": wns,
        "wns_improved_vs_e3d": (wns is not None) and (wns > E3D_WNS),
        "wns_closed": wns is not None and wns >= 0.0,
        "worst_source": src0,
        "worst_destination": dst0,
        "worst_dest_family": fam0,
        "vv_wdata_still_worst": fam0 == "vv_wdata",
        "next_gate": gate,
        "next_gate_why": why,
        "dest_family_counts": fam_counts,
        "report_sha256": hashlib.sha256(rpt.read_bytes()).hexdigest(),
        "n_paths": len(paths),
        "n_paths_smres_named": n_smres,
        "n_paths_weight_named": n_weight,
        "note": (
            "Does not overwrite E3A_N20.json or E3D_N20.json. "
            "OOC WNS>=0 is not C4_MASTER and not BOARD_PASS. "
            "Q/K still combo; E3f only if they become top-N."
        ),
        "paths": paths,
    }


def main() -> None:
    if not p.RPT.is_file():
        print("MISSING", p.RPT)
        return
    payload = build_payload(p.RPT)
    out = BAG / "E3E_N20.json"
    out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(
        "WROTE",
        out,
        "n",
        payload["n_paths"],
        "wns",
        payload["e3e_wns_ns"],
        "dest",
        payload["worst_dest_family"],
        "next",
        payload["next_gate"],
        "smres",
        payload["n_paths_smres_named"],
    )


if __name__ == "__main__":
    main()
