#!/usr/bin/env python3
"""Finish E3n OOC (shared acc keep). Baseline = E3m: WNS -5.998 ns, rq_snap from di.

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

E3M_WNS = -5.998
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
    delta = None if wns is None else (wns - E3M_WNS)
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
        note = "rq_snap still 20/20. acc keep may not have cut the last-di snapshot. Next: SNAP one named last-di site."
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3n.rpt before RTL."
    next_gate = "READ_TOPN"
    if case in ("A", "B"):
        if fam and fam != TARGET:
            next_gate = f"E3o_{fam}"
    elif case == "C":
        next_gate = "E3O_LAST_DI_SNAP"
    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3m_ns": delta,
        "wns_strong": strong,
        "next_gate": next_gate,
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3m.rpt"
    summ = BAG / "timing_summary_e3m.rpt"
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    fail = 0
    if six["worst_dest_family"] != TARGET:
        print("FAIL family", six)
        fail += 1
    if six["rq_snap_in_top20"] != 19:
        print("FAIL rq_snap count", six)
        fail += 1
    if cls["case"] != "MIXED":
        print("FAIL classify E3m-as-E3n should be MIXED", cls)
        fail += 1
    if fail == 0:
        print("E3N_FINISH_SELFTEST_PASS PROGRAM=NO")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3n OOC readout — shared acc keep (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. No last-di SNAP in this gate.

| Item | E3m | E3n |
|------|-----|-----|
| WNS | −5.998 ns | **{six.get("wns_ns")} ns** |
| TNS | −2234.909 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 647 | {six.get("failing_endpoints")} |
| Top-20 family | rq_snap 19, acc 1 | {six.get("top20_family_counts")} |
| Worst logic levels | 21 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 9 / 1 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3m: **{cls.get("wns_delta_vs_e3m_ns")} ns**. Next gate: `{cls.get("next_gate")}`.

`timing_n20_e3n.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite prior n20.

| Resource | E3m | E3n |
|----------|-----|-----|
| Slice LUTs | 27895 | {util.get("slice_luts")} |
| Slice Registers | 42960 | {util.get("slice_registers")} |
| DSP | 25 | {util.get("dsps")} |
| Block RAM Tile | 0 | {util.get("block_ram_tile")} |
| LUT as Memory | 224 | {util.get("lut_as_memory")} |
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3n.rpt"
    summ = BAG / "timing_summary_e3n.rpt"
    util_p = BAG / "util_e3n.rpt"
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
        "scope": "ACC_KEEP_ONLY",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "util": util,
    }
    (BAG / "E3N_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3N_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")
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
                "e3n_ooc": "DONE",
                "e3n_wns_ns": six.get("wns_ns"),
                "e3n_case": cls.get("case"),
                "e3n_next_gate": cls.get("next_gate"),
                "updated": now,
            },
        )
    print(
        "E3N_OOC_PARSED PROGRAM=NO",
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
