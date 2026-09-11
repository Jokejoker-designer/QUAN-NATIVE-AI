#!/usr/bin/env python3
"""Finish E3r OOC (S_F2 fi-indexed acc product pipeline). Baseline = E3q: WNS -4.089 ns, acc 13 / smres 7.

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

E3Q_WNS = -4.089
TARGET = "acc"
STRONG_WNS_NS = 3.0
TZ7 = timezone(timedelta(hours=7))


def six_numbers(n20: dict, setup: dict) -> dict:
    paths = n20.get("paths") or []
    p0 = paths[0] if paths else {}
    cells = p0.get("cell_histogram") or {}
    counts = n20.get("dest_family_counts") or {}
    n_tgt = int(counts.get(TARGET) or 0)
    n_paths = int(n20.get("n_paths") or 0)
    src = n20.get("worst_source") or ""
    return {
        "wns_ns": setup.get("wns_ns") if setup.get("wns_ns") is not None else n20.get("e3e_wns_ns"),
        "tns_ns": setup.get("tns_ns"),
        "failing_endpoints": setup.get("failing_endpoints"),
        "top20_family_counts": counts,
        "acc_in_top20": n_tgt,
        "acc_left_top20": n_paths > 0 and n_tgt == 0,
        "acc_still_20_of_20": n_paths == 20 and n_tgt == 20,
        "worst_logic_levels": p0.get("logic_levels"),
        "worst_carry4": int(cells.get("CARRY4") or 0),
        "worst_dsp48e1": int(cells.get("DSP48E1") or 0),
        "worst_source": src,
        "worst_destination": n20.get("worst_destination"),
        "worst_dest_family": n20.get("worst_dest_family"),
        "source_is_fi": "fi_reg" in src.lower(),
    }


def classify(six: dict) -> dict:
    wns = six.get("wns_ns")
    delta = None if wns is None else (wns - E3Q_WNS)
    left = bool(six.get("acc_left_top20"))
    still20 = bool(six.get("acc_still_20_of_20"))
    strong = delta is not None and delta >= STRONG_WNS_NS
    fi_src = bool(six.get("source_is_fi"))
    dsp = int(six.get("worst_dsp48e1") or 0) > 0
    fam = six.get("worst_dest_family")
    if left and strong:
        case, label = "A", "path_cut_and_wns_moved"
        note = "acc left top-20 and WNS improved strongly."
    elif left:
        case, label = "B", "path_cut_new_family"
        note = "acc left top-20; WNS slight/flat. Path-cut PASS. Target the new named family only."
    elif still20 and fi_src and dsp and not strong:
        case, label = "C", "register_boundary_may_not_have_survived"
        note = "acc still 20/20 from fi through DSP. S_F2_MAC/prod_r may have collapsed."
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3r.rpt before RTL."
    next_gate = "READ_TOPN"
    if case in ("A", "B"):
        if fam and fam != TARGET:
            next_gate = f"E3s_{fam}"
    elif case == "C":
        next_gate = "E3R_PIPE_NOT_CUT"
    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3q_ns": delta,
        "wns_strong": strong,
        "next_gate": next_gate,
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3q.rpt"
    summ = BAG / "timing_summary_e3q.rpt"
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    fail = 0
    if six["acc_in_top20"] != 13:
        print("FAIL acc count", six)
        fail += 1
    if not six["source_is_fi"]:
        print("FAIL E3q source should be fi", six)
        fail += 1
    if cls["case"] != "MIXED":
        print("FAIL classify E3q-as-E3r should be MIXED", cls)
        fail += 1
    if fail == 0:
        print("E3R_FINISH_SELFTEST_PASS PROGRAM=NO")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3r OOC readout — S_F2 fi-indexed acc product pipeline (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3q | E3r |
|------|-----|-----|
| WNS | −4.089 ns | **{six.get("wns_ns")} ns** |
| TNS | −1556.346 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 627 | {six.get("failing_endpoints")} |
| Top-20 family | acc 13, smres 7 | {six.get("top20_family_counts")} |
| Worst logic levels | 24 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 17 / 1 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3q: **{cls.get("wns_delta_vs_e3q_ns")} ns**. Next gate: `{cls.get("next_gate")}`.

`timing_n20_e3r.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite prior n20.
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3r.rpt"
    summ = BAG / "timing_summary_e3r.rpt"
    util_p = BAG / "util_e3r.rpt"
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
        "scope": "F2_PROD_PIPE",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "util": util,
    }
    (BAG / "E3R_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3R_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")
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
                "e3r_ooc": "DONE",
                "e3r_wns_ns": six.get("wns_ns"),
                "e3r_case": cls.get("case"),
                "e3r_next_gate": cls.get("next_gate"),
                "last_closed_ooc": "E3r",
                "last_closed_wns_ns": six.get("wns_ns"),
                "updated": now,
            },
        )
    print(
        "E3R_OOC_PARSED PROGRAM=NO",
        "case",
        cls.get("case"),
        "wns",
        six.get("wns_ns"),
        "acc_top20",
        six.get("acc_in_top20"),
        "fi_src",
        six.get("source_is_fi"),
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
