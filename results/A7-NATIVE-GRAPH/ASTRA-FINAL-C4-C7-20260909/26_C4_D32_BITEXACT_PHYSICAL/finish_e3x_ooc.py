#!/usr/bin/env python3
"""Finish E3x OOC (S_H operand snap into prod_r). Baseline = E3w: WNS -2.457 ns, prod_r 20/20.

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

E3W_WNS = -2.457
TARGET = "prod_r"
STRONG_WNS_NS = 3.0
STOP_WNS_NS = 0.15
TZ7 = timezone(timedelta(hours=7))


def six_numbers(n20: dict, setup: dict) -> dict:
    paths = n20.get("paths") or []
    p0 = paths[0] if paths else {}
    cells = p0.get("cell_histogram") or {}
    counts = n20.get("dest_family_counts") or {}
    n_tgt = int(counts.get(TARGET) or 0)
    n_paths = int(n20.get("n_paths") or 0)
    src = n20.get("worst_source") or ""
    src_l = src.lower()
    return {
        "wns_ns": setup.get("wns_ns") if setup.get("wns_ns") is not None else n20.get("e3e_wns_ns"),
        "tns_ns": setup.get("tns_ns"),
        "failing_endpoints": setup.get("failing_endpoints"),
        "top20_family_counts": counts,
        "prod_r_in_top20": n_tgt,
        "prod_r_left_top20": n_paths > 0 and n_tgt == 0,
        "prod_r_still_20_of_20": n_paths == 20 and n_tgt == 20,
        "worst_logic_levels": p0.get("logic_levels"),
        "worst_carry4": int(cells.get("CARRY4") or 0),
        "worst_dsp48e1": int(cells.get("DSP48E1") or 0),
        "worst_source": src,
        "worst_destination": n20.get("worst_destination"),
        "worst_dest_family": n20.get("worst_dest_family"),
        "source_is_vv": "vv_reg" in src_l or src_l.startswith("vv["),
    }


def classify(six: dict) -> dict:
    wns = six.get("wns_ns")
    delta = None if wns is None else (wns - E3W_WNS)
    left = bool(six.get("prod_r_left_top20"))
    still20 = bool(six.get("prod_r_still_20_of_20"))
    strong = delta is not None and delta >= STRONG_WNS_NS
    vv_src = bool(six.get("source_is_vv"))
    fam = six.get("worst_dest_family")
    fail_n = six.get("failing_endpoints")
    fail_better = fail_n is not None and fail_n <= 70
    if left and strong:
        case, label = "A", "path_cut_and_wns_moved"
        note = "prod_r left top-20 and WNS improved strongly."
    elif left:
        case, label = "B", "path_cut_new_family"
        note = "prod_r left top-20; WNS slight/flat. Path-cut PASS. At most one E3y on the new named family."
    elif still20 and vv_src and not strong:
        case, label = "C", "register_boundary_may_not_have_survived"
        note = "prod_r still 20/20 from vv. S_H_PROD operand snap may have collapsed."
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3x.rpt before RTL."
    next_gate = "READ_TOPN"
    stop_local = False
    if case in ("A", "B"):
        if fam and fam != TARGET:
            next_gate = f"E3y_{fam}"
    elif case == "C":
        small = delta is not None and delta < STOP_WNS_NS
        stop_local = small and not fail_better
        next_gate = "E3_REVIEW_STOP" if stop_local else "E3X_PIPE_NOT_CUT"
        if stop_local:
            note += " STOP local E3: same cone, ΔWNS<0.15, endpoints not materially better."
    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3w_ns": delta,
        "wns_strong": strong,
        "stop_local_e3": stop_local,
        "next_gate": next_gate,
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3w.rpt"
    summ = BAG / "timing_summary_e3w.rpt"
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    fail = 0
    if six["prod_r_in_top20"] != 20:
        print("FAIL prod_r count", six)
        fail += 1
    if not six["source_is_vv"]:
        print("FAIL E3w source should be vv", six)
        fail += 1
    if cls["case"] != "C":
        print("FAIL classify E3w-as-E3x should be C", cls)
        fail += 1
    if fail == 0:
        print("E3X_FINISH_SELFTEST_PASS PROGRAM=NO")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3x OOC readout — S_H operand snap into prod_r (6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`.

| Item | E3w | E3x |
|------|-----|-----|
| WNS | −2.457 ns | **{six.get("wns_ns")} ns** |
| TNS | −147.021 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 88 | {six.get("failing_endpoints")} |
| Top-20 family | prod_r 20 | {six.get("top20_family_counts")} |
| Worst logic levels | 10 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 0 / 2 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |
| LUT / FF / DSP / BRAM | 27217 / 43255 / 12 / 0 | {util.get("slice_luts")} / {util.get("slice_registers")} / {util.get("dsps")} / {util.get("block_ram_tile")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3w: **{cls.get("wns_delta_vs_e3w_ns")} ns**. Next gate: `{cls.get("next_gate")}`. stop_local_e3={cls.get("stop_local_e3")}.

`timing_n20_e3x.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite prior n20.
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3x.rpt"
    summ = BAG / "timing_summary_e3x.rpt"
    util_p = BAG / "util_e3x.rpt"
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
        "scope": "H_OP_PIPE",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "util": util,
    }
    (BAG / "E3X_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3X_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")
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
                "e3x_ooc": "DONE",
                "e3x_wns_ns": six.get("wns_ns"),
                "e3x_case": cls.get("case"),
                "e3x_next_gate": cls.get("next_gate"),
                "e3x_stop_local": cls.get("stop_local_e3"),
                "last_closed_ooc": "E3x",
                "last_closed_wns_ns": six.get("wns_ns"),
                "updated": now,
            },
        )
    print(
        "E3X_OOC_PARSED PROGRAM=NO",
        "case",
        cls.get("case"),
        "wns",
        six.get("wns_ns"),
        "prod_r_top20",
        six.get("prod_r_in_top20"),
        "vv_src",
        six.get("source_is_vv"),
        "next",
        cls.get("next_gate"),
        "stop",
        cls.get("stop_local_e3"),
    )
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    return selftest() if args.selftest else finish()


if __name__ == "__main__":
    raise SystemExit(main())
