#!/usr/bin/env python3
"""Finish E3e OOC artifacts after Vivado writes reports.

Does not overwrite E3a/E3d n20/dcp/json.
Does not stamp C4_MASTER / BOARD_PASS.
Does not program.

Usage:
  python finish_e3e_ooc.py              # WAITING or write E3e artifacts
  python finish_e3e_ooc.py --selftest   # parse E3d reports; write nothing E3e
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[3]
sys.path.insert(0, str(BAG))
import parse_e3e_n20 as e3e  # noqa: E402

E3D_WNS = -24.357
TZ7 = timezone(timedelta(hours=7))


def parse_setup_line(text: str) -> dict:
    m = re.search(
        r"Setup\s*:\s+(\d+)\s+Failing Endpoints,\s+Worst Slack\s+([-0-9.]+)ns,\s+Total Violation\s+([-0-9.]+)ns",
        text,
    )
    if not m:
        return {"failing_endpoints": None, "wns_ns": None, "tns_ns": None}
    return {
        "failing_endpoints": int(m.group(1)),
        "wns_ns": float(m.group(2)),
        "tns_ns": float(m.group(3)),
    }


def parse_util(text: str) -> dict:
    def cell(label: str) -> int | None:
        m = re.search(rf"\|\s*{re.escape(label)}\s*\|+\s*(\d+)", text)
        return int(m.group(1)) if m else None

    return {
        "slice_luts": cell("Slice LUTs*"),
        "lut_as_memory": cell("LUT as Memory"),
        "slice_registers": cell("Slice Registers"),
        "block_ram_tile": cell("Block RAM Tile"),
        "dsps": cell("DSPs"),
    }


def sha256_file(path: Path) -> str | None:
    if not path.is_file():
        return None
    return hashlib.sha256(path.read_bytes()).hexdigest()


def selftest() -> int:
    n20 = BAG / "timing_n20_e3d.rpt"
    summ = BAG / "timing_summary_e3d.rpt"
    util = BAG / "util_e3d.rpt"
    fail = 0
    payload = e3e.build_payload(n20)
    if payload["worst_dest_family"] != "vv_wdata":
        print("FAIL dest_family", payload["worst_dest_family"])
        fail += 1
    if abs((payload["e3e_wns_ns"] or 0) - E3D_WNS) > 1e-6:
        print("FAIL n20 wns", payload["e3e_wns_ns"])
        fail += 1
    if payload["next_gate"] != "E3e_SV_NOT_CUT":
        print("FAIL next_gate", payload["next_gate"])
        fail += 1
    setup = parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    if setup["wns_ns"] != E3D_WNS or setup["failing_endpoints"] != 3927:
        print("FAIL summary", setup)
        fail += 1
    u = parse_util(util.read_text(encoding="utf-8", errors="replace"))
    expect = {
        "slice_luts": 31781,
        "lut_as_memory": 224,
        "slice_registers": 42364,
        "block_ram_tile": 0,
        "dsps": 106,
    }
    if u != expect:
        print("FAIL util", u)
        fail += 1
    if fail == 0:
        print("E3E_FINISH_SELFTEST_PASS PROGRAM=NO (parsed E3d only; no E3e write)")
    return fail


def write_md(n20: dict, setup: dict, util: dict, shas: dict) -> str:
    wns = n20.get("e3e_wns_ns")
    improved = n20.get("wns_improved_vs_e3d")
    return f"""# E3e OOC — S_V-only rq_mcycle D32

**PROGRAM=NO.** `C4_MASTER` remains **OPEN**. This is not `BOARD_PASS`.

| Item | Value |
|------|--------|
| Marker | `E3E_OOC_DONE PROGRAM=NO C4_MASTER=OPEN` |
| Tool | Vivado 2026.1 OOC synth `a7ng_astra_c4_lm06_d32_fr_v2` + divider + `a7ng_astra_c4_rq_mcycle` |
| Device | `xc7a100tcsg324-1` / 100 MHz constraint |
| Scope | **S_V only** (`S_Q`/`S_K` still combo `c4_rq`) |
| D32 SHA256 | `f3e84760009e15596afa2dd53d582fc7ac2129506c6e4b76a3b47101ebe40fd1` |
| RQ SHA256 | `cc287b5b438de4a46b881a0368f2cdfc121fc319d7f9e6998862506e19eb7bbc` |

## Timing vs E3d

| | E3d | E3e |
|--|-----|-----|
| WNS | **−24.357 ns** | **{wns} ns** |
| TNS / failing endpoints | −66304.710 ns / 3927 | {setup.get("tns_ns")} ns / {setup.get("failing_endpoints")} |
| Worst dest family | vv_wdata | **{n20.get("worst_dest_family")}** |
| WNS improved vs E3d | — | {improved} |
| Next gate | — | `{n20.get("next_gate")}` |

Worst: `{n20.get("worst_source")}` → `{n20.get("worst_destination")}`.

{n20.get("next_gate_why")}

`timing_n20_e3e.rpt` SHA256 `{shas.get("n20")}`.  
Parser output: `E3E_N20.json`. Does **not** overwrite `timing_n20.rpt` / `timing_n20_e3d.rpt`.

## Util / RAM (OOC)

| Resource | E3d | E3e |
|----------|-----|-----|
| Slice LUTs | 31781 | {util.get("slice_luts")} |
| Slice Registers | 42364 | {util.get("slice_registers")} |
| DSP | 106 | {util.get("dsps")} |
| Block RAM Tile | 0 | {util.get("block_ram_tile")} |
| LUT as Memory | 224 | {util.get("lut_as_memory")} |

OOC WNS≥0 is **not** `C4_MASTER`. Do not program.

`.dcp` is gitignored. Re-run `run_e3e_ooc.ps1` to regenerate.
"""


def patch_json(path: Path, updates: dict) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    data.update(updates)
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def finish() -> int:
    rpt = BAG / "timing_n20_e3e.rpt"
    summ = BAG / "timing_summary_e3e.rpt"
    util_p = BAG / "util_e3e.rpt"
    ram_p = BAG / "ram_e3e.rpt"
    if not rpt.is_file():
        print("WAITING", rpt)
        return 2
    n20 = e3e.build_payload(rpt)
    (BAG / "E3E_N20.json").write_text(json.dumps(n20, indent=2) + "\n", encoding="utf-8")
    setup = (
        parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
        if summ.is_file()
        else {}
    )
    util = (
        parse_util(util_p.read_text(encoding="utf-8", errors="replace"))
        if util_p.is_file()
        else {}
    )
    now = datetime.now(TZ7).strftime("%Y-%m-%dT%H:%M:%S+07:00")
    shas = {
        "n20": n20["report_sha256"],
        "summary": sha256_file(summ),
        "util": sha256_file(util_p),
        "ram": sha256_file(ram_p),
    }
    md = write_md(n20, setup, util, shas)
    (BAG / "E3E_OOC.md").write_text(md, encoding="utf-8")

    live = ROOT / "results/A7-NATIVE-GRAPH/STATUS/ASTRA_C4_C7_LIVE.json"
    if live.is_file():
        patch_json(
            live,
            {
                "PROGRAM": "NO",
                "C4_MASTER": "OPEN",
                "C5_MASTER": "OPEN",
                "C6_MASTER": "OPEN",
                "ASTRA_NATIVE_AI_BOARD_PASS": "NOT_EVIDENCED",
                "G14": "BLOCKED_PRE_BOARD",
                "e3e_ooc": "DONE",
                "e3e_wns_ns": n20.get("e3e_wns_ns"),
                "e3e_worst_dest_family": n20.get("worst_dest_family"),
                "e3e_next_gate": n20.get("next_gate"),
                "e3e_wns_closed": n20.get("wns_closed"),
                "updated": now,
            },
        )

    g14 = ROOT / "results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/G14_STAGE14_BOARD_GATE.json"
    if g14.is_file():
        data = json.loads(g14.read_text(encoding="utf-8"))
        data["recorded_at"] = now
        data["smallest_remaining_experiment"] = (
            f"E3e OOC parsed. next_gate={n20.get('next_gate')}. "
            "Do not program. Do not stamp BOARD_PASS."
        )
        data["e3a"]["e3e"] = (
            f"OOC_DONE wns={n20.get('e3e_wns_ns')} dest={n20.get('worst_dest_family')} "
            f"next={n20.get('next_gate')} PROGRAM=NO"
        )
        for item in data.get("section_22", []):
            if item.get("id") == "FINAL PHYSICAL CLOSURE":
                item["note"] = (
                    f"E3e OOC WNS {n20.get('e3e_wns_ns')} ns dest={n20.get('worst_dest_family')}; "
                    "not routed C6"
                )
        g14.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")

    print(
        "E3E_OOC_PARSED PROGRAM=NO",
        "wns",
        n20.get("e3e_wns_ns"),
        "dest",
        n20.get("worst_dest_family"),
        "next",
        n20.get("next_gate"),
        "closed",
        n20.get("wns_closed"),
    )
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    if args.selftest:
        return selftest()
    return finish()


if __name__ == "__main__":
    raise SystemExit(main())
