#!/usr/bin/env python3
"""Finish E3o OOC (last-di S_ACC_SNAP). Baseline = E3n: WNS -5.840 ns, acc 10 / rq_snap 10.

Does not overwrite prior n20/dcp. Does not stamp MASTER / BOARD_PASS. Does not program.
"""
from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[3]
sys.path.insert(0, str(BAG))
import finish_e3e_ooc as e3e_fin  # noqa: E402
import parse_e3e_n20 as e3e  # noqa: E402

E3N_WNS = -5.840
TARGET = "rq_snap"
STRONG_WNS_NS = 3.0
TZ7 = timezone(timedelta(hours=7))


def six_numbers(n20: dict, setup: dict) -> dict:
    paths = n20.get("paths") or []
    p0 = paths[0] if paths else {}
    cells = p0.get("cell_histogram") or {}
    counts = n20.get("dest_family_counts") or {}
    n_tgt = int(counts.get(TARGET) or 0)
    n_paths = int(n20.get("n_paths") or 0)
    return {
        "wns_ns": setup.get("wns_ns") if setup.get("wns_ns") is not None else n20.get("e3e_wns_ns"),
        "tns_ns": setup.get("tns_ns"),
        "failing_endpoints": setup.get("failing_endpoints"),
        "top20_family_counts": counts,
        "rq_snap_in_top20": n_tgt,
        "rq_left_top20": n_paths > 0 and n_tgt == 0,
        "rq_still_20_of_20": n_paths == 20 and n_tgt == 20,
        "worst_logic_levels": p0.get("logic_levels"),
        "worst_carry4": int(cells.get("CARRY4") or 0),
        "worst_dsp48e1": int(cells.get("DSP48E1") or 0),
        "worst_source": n20.get("worst_source"),
        "worst_destination": n20.get("worst_destination"),
        "worst_dest_family": n20.get("worst_dest_family"),
    }


def classify(six: dict) -> dict:
    wns = six.get("wns_ns")
    delta = None if wns is None else (wns - E3N_WNS)
    left = bool(six.get("rq_left_top20"))
    still20 = bool(six.get("rq_still_20_of_20"))
    strong = delta is not None and delta >= STRONG_WNS_NS
    fam = six.get("worst_dest_family")
    if left and strong:
        case, label = "A", "path_cut_and_wns_moved"
        note = "rq_snap left top-20 and WNS improved strongly."
    elif left:
        case, label = "B", "path_cut_new_family"
        note = "rq_snap left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only."
    elif still20 and (delta is None or delta < STRONG_WNS_NS):
        case, label = "C", "register_boundary_may_not_have_survived"
        note = "rq_snap still 20/20. S_ACC_SNAP may not have cut last-di flatten."
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3o.rpt before RTL."
    next_gate = "READ_TOPN"
    if case in ("A", "B"):
        if fam and fam != TARGET:
            next_gate = f"E3p_{fam}"
    elif case == "C":
        next_gate = "E3O_SNAP_NOT_CUT"
    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3n_ns": delta,
        "wns_strong": strong,
        "next_gate": next_gate,
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3n.rpt"
    summ = BAG / "timing_summary_e3n.rpt"
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    fail = 0
    if six["rq_snap_in_top20"] != 10:
        print("FAIL rq_snap count", six)
        fail += 1
    if cls["case"] != "MIXED":
        print("FAIL classify E3n-as-E3o should be MIXED", cls)
        fail += 1
    if fail == 0:
        print("E3O_FINISH_SELFTEST_PASS PROGRAM=NO")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3o OOC readout — last-di S_ACC_SNAP (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. S_F2 was not SNAPped.

| Item | E3n | E3o |
|------|-----|-----|
| WNS | −5.840 ns | **{six.get("wns_ns")} ns** |
| TNS | −2060.058 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 647 | {six.get("failing_endpoints")} |
| Top-20 family | acc 10, rq_snap 10 | {six.get("top20_family_counts")} |
| Worst logic levels | 27 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 17 / 1 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3n: **{cls.get("wns_delta_vs_e3n_ns")} ns**. Next gate: `{cls.get("next_gate")}`.

`timing_n20_e3o.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite prior n20.

| Resource | E3n | E3o |
|----------|-----|-----|
| Slice LUTs | 28023 | {util.get("slice_luts")} |
| Slice Registers | 42901 | {util.get("slice_registers")} |
| DSP | 25 | {util.get("dsps")} |
| Block RAM Tile | 0 | {util.get("block_ram_tile")} |
| LUT as Memory | 224 | {util.get("lut_as_memory")} |
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3o.rpt"
    summ = BAG / "timing_summary_e3o.rpt"
    util_p = BAG / "util_e3o.rpt"
    if not rpt.is_file():
        print("WAITING", rpt)
        return 2
    raw = e3e.build_payload(rpt)
    setup = (
        e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
        if summ.is_file()
        else {}
    )
    util = (
        e3e_fin.parse_util(util_p.read_text(encoding="utf-8", errors="replace"))
        if util_p.is_file()
        else {}
    )
    six = six_numbers(raw, setup)
    cls = classify(six)
    now = datetime.now(TZ7).strftime("%Y-%m-%dT%H:%M:%S+07:00")
    shas = {"n20": raw.get("report_sha256"), "summary": e3e_fin.sha256_file(summ)}
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "ASTRA_NATIVE_AI_BOARD_PASS": "OPEN",
        "scope": "LAST_DI_ACC_SNAP",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "util": util,
    }
    (BAG / "E3O_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3O_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")
    live = ROOT / "results/A7-NATIVE-GRAPH/STATUS/ASTRA_C4_C7_LIVE.json"
    if live.is_file():
        e3e_fin.patch_json(
            live,
            {
                "PROGRAM": "NO",
                "C4_MASTER": "OPEN",
                "C5_MASTER": "OPEN",
                "C6_MASTER": "OPEN",
                "ASTRA_NATIVE_AI_BOARD_PASS": "NOT_EVIDENCED",
                "G14": "BLOCKED_PRE_BOARD",
                "e3o_ooc": "DONE",
                "e3o_wns_ns": six.get("wns_ns"),
                "e3o_case": cls.get("case"),
                "e3o_next_gate": cls.get("next_gate"),
                "last_closed_ooc": "E3o",
                "last_closed_wns_ns": six.get("wns_ns"),
                "updated": now,
            },
        )
    print(
        "E3O_OOC_PARSED PROGRAM=NO",
        "case",
        cls.get("case"),
        "wns",
        six.get("wns_ns"),
        "rq_top20",
        six.get("rq_snap_in_top20"),
        "next",
        cls.get("next_gate"),
    )
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    return selftest() if args.selftest else finish()


if __name__ == "__main__":
    raise SystemExit(main())
