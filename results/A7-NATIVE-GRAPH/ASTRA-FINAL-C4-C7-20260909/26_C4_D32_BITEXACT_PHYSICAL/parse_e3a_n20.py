#!/usr/bin/env python3
"""Parse report_timing -max_paths 20. READ-ONLY. No Vivado."""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path

BAG = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/26_C4_D32_BITEXACT_PHYSICAL"
)
RPT = BAG / "timing_n20.rpt"


def family(name: str) -> str:
    n = name.lower()
    for key in ("attn", "eden", "psum", "elut", "acc1", "we", "wq", "wk", "wv", "pe"):
        if key in n:
            return key
    return "other"


def split_paths(text: str) -> list[str]:
    parts = re.split(r"(?=^Slack \()", text, flags=re.M)
    return [p for p in parts if p.startswith("Slack (")]


def parse_path(block: str, idx: int) -> dict:
    slack = re.search(r"Slack \(([^)]+)\)\s*:\s+([-0-9.]+)ns", block)
    src = re.search(r"Source:\s+(\S+)", block)
    dst = re.search(r"Destination:\s+(\S+)", block)
    delay = re.search(r"Data Path Delay:\s+([-0-9.]+)ns", block)
    levels = re.search(r"Logic Levels:\s+(\d+)\s+\(([^)]+)\)", block)
    cells = re.findall(
        r"^\s+(CARRY4|LUT[1-6]|FDRE|DSP48E1|RAMB36E1|RAMB18E1|MUXF[78])\b",
        block,
        flags=re.M,
    )
    nets = re.findall(r"net \(fo=\d+[^)]*\)\s+[0-9.]+\s+[0-9.]+\s+(\S+)", block)
    fam = Counter(family(x) for x in nets)
    return {
        "rank": idx,
        "status": slack.group(1) if slack else None,
        "slack_ns": float(slack.group(2)) if slack else None,
        "source": src.group(1) if src else None,
        "destination": dst.group(1) if dst else None,
        "data_path_delay_ns": float(delay.group(1)) if delay else None,
        "logic_levels": int(levels.group(1)) if levels else None,
        "level_breakdown": levels.group(2) if levels else None,
        "cell_histogram": dict(Counter(cells)),
        "name_family_counts": dict(fam),
        "smres_name_hit": fam.get("attn", 0) + fam.get("eden", 0) + fam.get("psum", 0) + fam.get("elut", 0),
        "weight_name_hit": fam.get("we", 0) + fam.get("wq", 0) + fam.get("wk", 0) + fam.get("wv", 0) + fam.get("pe", 0),
        "has_ramb": any("RAMB" in c for c in cells),
        "has_dsp": any("DSP" in c for c in cells),
    }


def main() -> None:
    if not RPT.is_file():
        (BAG / "E3A_N20_STATUS.json").write_text(
            json.dumps(
                {
                    "PROGRAM": "NO",
                    "status": "WAITING_FOR_TIMING_N20",
                    "report": str(RPT).replace("\\", "/"),
                    "e3b": "BLOCKED",
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        print("WAITING", RPT)
        return
    text = RPT.read_text(encoding="utf-8", errors="replace")
    paths = [parse_path(b, i) for i, b in enumerate(split_paths(text))]
    n_smres = sum(1 for p in paths if p["smres_name_hit"] > p["weight_name_hit"])
    n_weight = sum(1 for p in paths if p["weight_name_hit"] > p["smres_name_hit"])
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "e3a": "TOPN_PARSED" if paths else "EMPTY",
        "report_sha256": hashlib.sha256(RPT.read_bytes()).hexdigest(),
        "n_paths": len(paths),
        "n_paths_smres_named": n_smres,
        "n_paths_weight_named": n_weight,
        "e3b_unblocked": bool(paths) and n_smres >= 1 and paths[0]["smres_name_hit"] > 0,
        "note": "e3b_unblocked is name-family INFERENCE on dumped paths, not a DIVIDE unisim.",
        "paths": paths,
    }
    (BAG / "E3A_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print("WROTE", BAG / "E3A_N20.json", "n", len(paths), "smres", n_smres, "weight", n_weight)


if __name__ == "__main__":
    main()
