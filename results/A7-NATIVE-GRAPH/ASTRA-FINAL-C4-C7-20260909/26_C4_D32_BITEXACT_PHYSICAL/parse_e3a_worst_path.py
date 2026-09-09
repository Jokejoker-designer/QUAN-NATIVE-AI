#!/usr/bin/env python3
"""Parse the existing OOC timing_summary worst path. READ-ONLY. No Vivado."""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path

RPT = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/14_C4_OOC_V2/timing_ooc.rpt"
)
OUT = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/26_C4_D32_BITEXACT_PHYSICAL"
)


def sha(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def family(name: str) -> str:
    n = name.lower()
    for key in ("attn", "eden", "psum", "elut", "acc1", "we", "wq", "wk", "wv", "pe", "lut"):
        if key in n:
            return key
    return "other"


def main() -> None:
    text = RPT.read_text(encoding="utf-8", errors="replace")
    setup = re.search(
        r"Setup :\s+(\d+)\s+Failing Endpoints,\s+Worst Slack\s+([-0-9.]+)ns,\s+Total Violation\s+([-0-9.]+)ns",
        text,
    )
    hold = re.search(
        r"Hold  :\s+(\d+)\s+Failing Endpoints,\s+Worst Slack\s+([-0-9.]+)ns",
        text,
    )
    max_block = text.split("Max Delay Paths", 1)[1].split("Min Delay Paths", 1)[0]
    n_slack = len(re.findall(r"^Slack ", max_block, flags=re.M))
    src = re.search(r"Source:\s+(\S+)", max_block)
    dst = re.search(r"Destination:\s+(\S+)", max_block)
    slack = re.search(r"Slack \(VIOLATED\) :\s+([-0-9.]+)ns", max_block)
    delay = re.search(r"Data Path Delay:\s+([-0-9.]+)ns", max_block)
    levels = re.search(r"Logic Levels:\s+(\d+)\s+\(([^)]+)\)", max_block)
    cells = re.findall(
        r"^\s+(CARRY4|LUT[1-6]|FDRE|DSP48E1|LUTRAM|RAMB36E1|RAMB18E1|MUXF[78])\b",
        max_block,
        flags=re.M,
    )
    resources = re.findall(r"\s{2}(\S+/\S+)\s*$", max_block)
    nets = re.findall(r"net \(fo=\d+[^)]*\)\s+[0-9.]+\s+[0-9.]+\s+(\S+)", max_block)
    fam = Counter(family(x) for x in resources + nets)
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "e3a": "PARTIAL",
        "e3b_started": False,
        "report": str(RPT).replace("\\", "/"),
        "report_sha256": sha(RPT),
        "setup_failing_endpoints": int(setup.group(1)) if setup else None,
        "wns_ns": float(setup.group(2)) if setup else None,
        "tns_ns": float(setup.group(3)) if setup else None,
        "hold_failing_endpoints": int(hold.group(1)) if hold else None,
        "max_delay_paths_in_report": n_slack,
        "worst_path": {
            "slack_ns": float(slack.group(1)) if slack else None,
            "source": src.group(1) if src else None,
            "destination": dst.group(1) if dst else None,
            "data_path_delay_ns": float(delay.group(1)) if delay else None,
            "logic_levels": int(levels.group(1)) if levels else None,
            "level_breakdown": levels.group(2) if levels else None,
            "cell_histogram": dict(Counter(cells)),
            "name_family_counts": dict(fam),
            "n_named_resources": len(resources),
            "n_nets": len(nets),
            "has_ramb": any("RAMB" in c for c in cells),
            "has_dsp": any("DSP" in c for c in cells),
            "has_carry4": any("CARRY4" in c for c in cells),
            "has_divide_unisim": False,
            "note": "Artix-7 has no DIVIDE unisim; signed / maps to CARRY/LUT.",
        },
        "rtl_map": {
            "source_elut_reg": "S_SMDIV/S_SMRES numerator (softmax exp LUT)",
            "eden_attn_psum_names": "S_SMRES (elut*32767+(eden/2))/eden and psum accumulate",
            "dest_acc1_dsp_B": "S_H MAC attn[ti]*vv[ti][dj] DSP B port",
            "rtl_lines": "a7ng_astra_c4_lm06_d32_fr_v2.sv:265-277",
        },
        "synth_warnings": {
            "unique_case_parallel": "vivado_ooc.log Synth 8-294 lines 76 and 78",
            "ti_acc_blocking_nba": "Synth 8-6090 lines 77 and 79",
        },
        "competing_weight_mux": {
            "this_worst_path": "NOT named We/Wq/Wk/Wv",
            "bram": 0,
            "lut_as_memory": 0,
            "other_62840_endpoints": "UNKNOWN without top-N report",
        },
        "top_n": "MISSING — timing_summary dumps 1 setup path; no DCP saved; re-synth ~54 min",
        "e3b_gate": "BLOCKED until top-N or explicit authority that worst-path INFERENCE is enough",
    }
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "E3A_WORST_PATH.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print("WROTE", OUT / "E3A_WORST_PATH.json")
    print("families", fam)
    print("cells", Counter(cells))
    print("paths_in_report", n_slack)


if __name__ == "__main__":
    main()
