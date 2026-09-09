#!/usr/bin/env python3
"""Parse E3d report_timing -max_paths 20. READ-ONLY. Does not touch E3a files."""
from pathlib import Path
import hashlib
import json
import sys

BAG = Path(__file__).resolve().parent
sys.path.insert(0, str(BAG))
import parse_e3a_n20 as p  # noqa: E402

p.RPT = BAG / "timing_n20_e3d.rpt"


def main() -> None:
    if not p.RPT.is_file():
        print("MISSING", p.RPT)
        return
    text = p.RPT.read_text(encoding="utf-8", errors="replace")
    paths = [p.parse_path(b, i) for i, b in enumerate(p.split_paths(text))]
    n_smres = sum(1 for x in paths if x["smres_name_hit"] > x["weight_name_hit"])
    n_weight = sum(1 for x in paths if x["weight_name_hit"] > x["smres_name_hit"])
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "e3d": "TOPN_PARSED" if paths else "EMPTY",
        "e3a_wns_ns_pre_divider": -83.427,
        "e3d_wns_ns": paths[0]["slack_ns"] if paths else None,
        "report_sha256": hashlib.sha256(p.RPT.read_bytes()).hexdigest(),
        "n_paths": len(paths),
        "n_paths_smres_named": n_smres,
        "n_paths_weight_named": n_weight,
        "note": "Does not overwrite E3A_N20.json. BRAM is in ram_e3d.rpt, not this parser.",
        "paths": paths,
    }
    out = BAG / "E3D_N20.json"
    out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print("WROTE", out, "n", len(paths), "smres", n_smres, "weight", n_weight)


if __name__ == "__main__":
    main()
