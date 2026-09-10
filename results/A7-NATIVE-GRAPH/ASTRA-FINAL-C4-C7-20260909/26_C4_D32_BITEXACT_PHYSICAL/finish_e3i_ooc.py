#!/usr/bin/env python3
"""Finish E3i OOC (S_F1-only). Same 6-number + Case A/B/C readout as E3f_S_Q.

Baseline = E3f_S_Q: WNS -20.614 ns, f1_rq/val0 20/20.
Does not overwrite E3a/E3d/E3e/E3g/E3f/E3h/E3f_sq n20/dcp.
Does not stamp C4_MASTER / BOARD_PASS. Does not program.

Usage:
  python finish_e3i_ooc.py
  python finish_e3i_ooc.py --selftest   # classify E3f_sq n20 as if E3i; write nothing
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

E3FSQ_WNS = -20.614
E3FSQ_LEVELS = 45
E3FSQ_CARRY4 = 30
E3FSQ_DSP = 7
TARGET = "f1_rq"
STRONG_WNS_NS = 3.0
UNCHANGED_WNS_NS = 0.35
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
        "f1_rq_in_top20": n_tgt,
        "f1_left_top20": n_paths > 0 and n_tgt == 0,
        "f1_still_20_of_20": n_paths == 20 and n_tgt == 20,
        "worst_logic_levels": p0.get("logic_levels"),
        "worst_carry4": int(cells.get("CARRY4") or 0),
        "worst_dsp48e1": int(cells.get("DSP48E1") or 0),
        "worst_source": n20.get("worst_source"),
        "worst_destination": n20.get("worst_destination"),
        "worst_dest_family": n20.get("worst_dest_family"),
        "e3f_sq_ref": {
            "wns_ns": E3FSQ_WNS,
            "logic_levels": E3FSQ_LEVELS,
            "carry4": E3FSQ_CARRY4,
            "dsp48e1": E3FSQ_DSP,
            "family": "f1_rq/val0 20/20",
        },
    }


def classify(six: dict) -> dict:
    wns = six.get("wns_ns")
    delta = None if wns is None else (wns - E3FSQ_WNS)
    left = bool(six.get("f1_left_top20"))
    still20 = bool(six.get("f1_still_20_of_20"))
    strong = delta is not None and delta >= STRONG_WNS_NS
    fam = six.get("worst_dest_family")
    if left and strong:
        case, label = "A", "path_cut_and_wns_moved"
        note = "f1_rq/val0 left top-20 and WNS improved strongly. E3i S_F1 physical hypothesis confirmed."
    elif left:
        case, label = "B", "path_cut_new_family"
        note = (
            "f1_rq/val0 left top-20; WNS only slight/flat. E3i still PASS as a path cut. "
            "Target the new named family. Do not mass-refactor remaining c4_rq sites."
        )
    elif still20 and (delta is None or delta < STRONG_WNS_NS):
        case, label = "C", "register_boundary_may_not_have_survived"
        note = (
            "f1_rq/val0 still 20/20 and WNS nearly unchanged. "
            "Check whether the S_F1 register boundary survived synthesis."
        )
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3i.rpt before RTL."

    next_gate = "READ_TOPN"
    if case in ("A", "B"):
        if fam == "zv_wdata":
            next_gate = "E3i_F2"
        elif fam == "tv":
            next_gate = "E3i_F1_SAT"
        elif fam and fam != TARGET:
            next_gate = f"E3j_{fam}"
    elif case == "C":
        next_gate = "E3i_F1_NOT_CUT"

    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3f_sq_ns": delta,
        "wns_strong": strong,
        "next_gate": next_gate,
        "thresholds": {"strong_wns_ns": STRONG_WNS_NS, "unchanged_wns_ns": UNCHANGED_WNS_NS},
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3f_sq.rpt"
    summ = BAG / "timing_summary_e3f_sq.rpt"
    fail = 0
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    if not six["f1_still_20_of_20"]:
        print("FAIL e3f_sq f1_rq 20/20", six)
        fail += 1
    if six["worst_logic_levels"] != E3FSQ_LEVELS:
        print("FAIL levels", six["worst_logic_levels"])
        fail += 1
    if cls["case"] != "C":
        print("FAIL classify E3f_sq-as-E3i should be C", cls)
        fail += 1
    if fail == 0:
        print("E3I_FINISH_SELFTEST_PASS PROGRAM=NO (E3f_sq n20 classified C as baseline; no E3i write)")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3i OOC readout — S_F1-only (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. `S_Y`/`S_F2`/`S_EMB`/`S_DOT` were not touched.

| Item | E3f_S_Q | E3i |
|------|---------|-----|
| WNS | −20.614 ns | **{six.get("wns_ns")} ns** |
| TNS | −51896.881 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 3531 | {six.get("failing_endpoints")} |
| Top-20 family | f1_rq/val0 20/20 | {six.get("top20_family_counts")} |
| Worst logic levels | 45 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 30 / 7 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3f_S_Q: **{cls.get("wns_delta_vs_e3f_sq_ns")} ns**. Next gate: `{cls.get("next_gate")}`.

`timing_n20_e3i.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite E3a/E3d/E3e/E3g/E3f/E3h/E3f_sq.

| Resource | E3f_S_Q | E3i |
|----------|---------|-----|
| Slice LUTs | 29908 | {util.get("slice_luts")} |
| Slice Registers | 42798 | {util.get("slice_registers")} |
| DSP | 56 | {util.get("dsps")} |
| Block RAM Tile | 0 | {util.get("block_ram_tile")} |
| LUT as Memory | 224 | {util.get("lut_as_memory")} |
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3i.rpt"
    summ = BAG / "timing_summary_e3i.rpt"
    util_p = BAG / "util_e3i.rpt"
    ram_p = BAG / "ram_e3i.rpt"
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
    shas = {
        "n20": raw.get("report_sha256"),
        "summary": e3e_fin.sha256_file(summ),
        "util": e3e_fin.sha256_file(util_p),
        "ram": e3e_fin.sha256_file(ram_p),
    }
    payload = {
        "PROGRAM": "NO",
        "C4_MASTER": "OPEN",
        "ASTRA_NATIVE_AI_BOARD_PASS": "OPEN",
        "e3i": "TOPN_PARSED",
        "scope": "S_F1_ONLY",
        "e3f_sq_case_b_stands": True,
        "e3i_functional": "PASS_n242",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "n_paths": raw.get("n_paths"),
        "util": util,
        "note": "Does not overwrite prior n20. Top-N points; no mass c4_rq refactor.",
        "paths": raw.get("paths"),
    }
    (BAG / "E3I_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3I_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")

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
                "e3i_ooc": "DONE",
                "e3i_wns_ns": six.get("wns_ns"),
                "e3i_case": cls.get("case"),
                "e3i_next_gate": cls.get("next_gate"),
                "e3i_f1_left_top20": six.get("f1_left_top20"),
                "updated": now,
            },
        )

    g14 = ROOT / "results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/G14_STAGE14_BOARD_GATE.json"
    if g14.is_file():
        data = json.loads(g14.read_text(encoding="utf-8"))
        data["recorded_at"] = now
        data["smallest_remaining_experiment"] = (
            f"E3i Case {cls.get('case')} next={cls.get('next_gate')}. Do not program."
        )
        data.setdefault("e3a", {})["e3i"] = (
            f"OOC_DONE case={cls.get('case')} wns={six.get('wns_ns')} "
            f"dest={six.get('worst_dest_family')} PROGRAM=NO"
        )
        for item in data.get("section_22", []):
            if item.get("id") == "FINAL PHYSICAL CLOSURE":
                item["note"] = f"E3i Case {cls.get('case')} WNS {six.get('wns_ns')} ns; not routed C6"
        g14.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")

    print(
        "E3I_OOC_PARSED PROGRAM=NO",
        "case",
        cls.get("case"),
        "wns",
        six.get("wns_ns"),
        "delta",
        cls.get("wns_delta_vs_e3f_sq_ns"),
        "f1_top20",
        six.get("f1_rq_in_top20"),
        "levels",
        six.get("worst_logic_levels"),
        "carry4",
        six.get("worst_carry4"),
        "dsp",
        six.get("worst_dsp48e1"),
        "next",
        cls.get("next_gate"),
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
