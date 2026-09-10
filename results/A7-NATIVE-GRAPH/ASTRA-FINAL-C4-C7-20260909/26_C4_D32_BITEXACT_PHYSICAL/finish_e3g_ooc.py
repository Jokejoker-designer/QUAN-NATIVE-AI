#!/usr/bin/env python3
"""Finish E3g OOC. Anh 2026-09-09 readout: 6 numbers + Case A/B/C.

Does not overwrite E3a/E3d/E3e n20/dcp.
Does not stamp C4_MASTER / BOARD_PASS.
Does not program.
No other C4 physical RTL in this script.

Usage:
  python finish_e3g_ooc.py
  python finish_e3g_ooc.py --selftest   # classify E3e n20 as if it were E3g; write nothing
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

E3E_WNS = -23.439
E3E_LEVELS = 53
E3E_CARRY4 = 35
E3E_DSP = 4
# E3e family-swap delta was +0.918 ns = "slight". Strong = clearly more than that.
STRONG_WNS_NS = 3.0
UNCHANGED_WNS_NS = 0.35
TZ7 = timezone(timedelta(hours=7))


def six_numbers(n20: dict, setup: dict) -> dict:
    paths = n20.get("paths") or []
    p0 = paths[0] if paths else {}
    cells = p0.get("cell_histogram") or {}
    counts = n20.get("dest_family_counts") or {}
    n_logits = int(counts.get("logits_wdata") or 0)
    n_paths = int(n20.get("n_paths") or 0)
    return {
        "wns_ns": setup.get("wns_ns") if setup.get("wns_ns") is not None else n20.get("e3e_wns_ns"),
        "tns_ns": setup.get("tns_ns"),
        "failing_endpoints": setup.get("failing_endpoints"),
        "top20_family_counts": counts,
        "logits_wdata_in_top20": n_logits,
        "logits_left_top20": n_paths > 0 and n_logits == 0,
        "logits_still_20_of_20": n_paths == 20 and n_logits == 20,
        "worst_logic_levels": p0.get("logic_levels"),
        "worst_carry4": int(cells.get("CARRY4") or 0),
        "worst_dsp48e1": int(cells.get("DSP48E1") or 0),
        "worst_source": n20.get("worst_source"),
        "worst_destination": n20.get("worst_destination"),
        "worst_dest_family": n20.get("worst_dest_family"),
        "e3e_ref": {
            "wns_ns": E3E_WNS,
            "logic_levels": E3E_LEVELS,
            "carry4": E3E_CARRY4,
            "dsp48e1": E3E_DSP,
            "family": "logits_wdata 20/20",
        },
    }


def classify(six: dict) -> dict:
    wns = six.get("wns_ns")
    delta = None if wns is None else (wns - E3E_WNS)
    left = bool(six.get("logits_left_top20"))
    still20 = bool(six.get("logits_still_20_of_20"))
    strong = delta is not None and delta >= STRONG_WNS_NS
    slight = delta is not None and UNCHANGED_WNS_NS <= delta < STRONG_WNS_NS
    unchanged = delta is not None and abs(delta) < UNCHANGED_WNS_NS
    new_fam = six.get("worst_dest_family") not in (None, "logits_wdata")

    if left and strong:
        case, label = "A", "path_cut_and_wns_moved"
        note = "logits_wdata left top-20 and WNS improved strongly. E3g physical hypothesis confirmed."
    elif left:
        case, label = "B", "path_cut_new_family"
        note = (
            "logits_wdata left top-20; WNS only slight/flat. E3g still PASS as a path cut. "
            "Target the new named family. Do not mass-refactor remaining c4_rq sites."
        )
    elif still20 and (unchanged or (delta is not None and delta < STRONG_WNS_NS)):
        case, label = "C", "register_boundary_may_not_have_survived"
        note = (
            "logits_wdata still 20/20 and WNS nearly unchanged. "
            "Check whether the S_LOG register boundary survived synthesis or the optimizer collapsed/retimed the cone."
        )
    else:
        case, label = "MIXED", "read_topn"
        note = "Neither clean A/B/C. Read timing_n20_e3g.rpt before RTL."

    next_gate = "READ_TOPN"
    if case == "A" or case == "B":
        fam = six.get("worst_dest_family")
        if fam == "qv_wdata":
            next_gate = "E3f_S_Q"
        elif fam == "kv_wdata":
            next_gate = "E3f_S_K"
        elif fam and fam != "logits_wdata":
            next_gate = f"E3h_{fam}"
        else:
            next_gate = "READ_TOPN"
    elif case == "C":
        next_gate = "E3g_LOG_NOT_CUT"

    return {
        "case": case,
        "label": label,
        "note": note,
        "wns_delta_vs_e3e_ns": delta,
        "wns_strong": strong,
        "wns_slight": slight,
        "wns_unchanged_band": unchanged,
        "new_family": new_fam,
        "next_gate": next_gate,
        "thresholds": {
            "strong_wns_ns": STRONG_WNS_NS,
            "unchanged_wns_ns": UNCHANGED_WNS_NS,
            "why": "E3e family-swap was +0.918 ns (slight). Strong means clearly above that.",
        },
    }


def selftest() -> int:
    rpt = BAG / "timing_n20_e3e.rpt"
    summ = BAG / "timing_summary_e3e.rpt"
    fail = 0
    n20 = e3e.build_payload(rpt)
    setup = e3e_fin.parse_setup_line(summ.read_text(encoding="utf-8", errors="replace"))
    six = six_numbers(n20, setup)
    cls = classify(six)
    if not six["logits_still_20_of_20"]:
        print("FAIL e3e logits 20/20", six)
        fail += 1
    if six["worst_logic_levels"] != E3E_LEVELS:
        print("FAIL levels", six["worst_logic_levels"])
        fail += 1
    if six["worst_carry4"] != E3E_CARRY4 or six["worst_dsp48e1"] != E3E_DSP:
        print("FAIL cells", six["worst_carry4"], six["worst_dsp48e1"])
        fail += 1
    if cls["case"] != "C":
        print("FAIL classify E3e-as-E3g should be C", cls)
        fail += 1
    if fail == 0:
        print("E3G_FINISH_SELFTEST_PASS PROGRAM=NO (E3e n20 classified C as baseline; no E3g write)")
    return fail


def write_md(six: dict, cls: dict, util: dict, shas: dict) -> str:
    return f"""# E3g OOC readout — S_LOG-only (Anh 6-number + Case A/B/C)

**PROGRAM=NO.** `C4_MASTER` OPEN. Not `BOARD_PASS`. E3e path-cut PASS stands. This is not a mass `c4_rq` refactor.

| Item | E3e | E3g |
|------|-----|-----|
| WNS | −23.439 ns | **{six.get("wns_ns")} ns** |
| TNS | −60692.415 ns | {six.get("tns_ns")} ns |
| Failing endpoints | 3734 | {six.get("failing_endpoints")} |
| Top-20 family | logits_wdata 20/20 | {six.get("top20_family_counts")} |
| Worst logic levels | 53 | {six.get("worst_logic_levels")} |
| Worst CARRY4 / DSP48E1 | 35 / 4 | {six.get("worst_carry4")} / {six.get("worst_dsp48e1")} |

Worst: `{six.get("worst_source")}` → `{six.get("worst_destination")}`.

## Case {cls.get("case")} — `{cls.get("label")}`

{cls.get("note")}

WNS Δ vs E3e: **{cls.get("wns_delta_vs_e3e_ns")} ns**. Next gate: `{cls.get("next_gate")}`.

Do not silently call this E3f. E3f remains Q/K if they become top-N.

`timing_n20_e3g.rpt` SHA256 `{shas.get("n20")}`. Does **not** overwrite E3a/E3d/E3e.

| Resource | E3e | E3g |
|----------|-----|-----|
| Slice LUTs | 31778 | {util.get("slice_luts")} |
| Slice Registers | 42605 | {util.get("slice_registers")} |
| DSP | 99 | {util.get("dsps")} |
| Block RAM Tile | 0 | {util.get("block_ram_tile")} |
| LUT as Memory | 224 | {util.get("lut_as_memory")} |
"""


def finish() -> int:
    rpt = BAG / "timing_n20_e3g.rpt"
    summ = BAG / "timing_summary_e3g.rpt"
    util_p = BAG / "util_e3g.rpt"
    ram_p = BAG / "ram_e3g.rpt"
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
        "e3g": "TOPN_PARSED",
        "scope": "S_LOG_ONLY",
        "e3e_functional": "PASS",
        "e3e_path_cut": "PASS",
        "e3e_timing_target": "FAIL_STILL_OPEN",
        "e3g_functional": "PASS_n242",
        "six": six,
        "classification": cls,
        "report_sha256": raw.get("report_sha256"),
        "n_paths": raw.get("n_paths"),
        "util": util,
        "note": "Does not overwrite E3A/E3D/E3E n20. OOC WNS>=0 is not C4_MASTER. Top-N points; no mass c4_rq refactor.",
        "paths": raw.get("paths"),
    }
    (BAG / "E3G_N20.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    (BAG / "E3G_OOC.md").write_text(write_md(six, cls, util, shas), encoding="utf-8")

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
                "e3g_ooc": "DONE",
                "e3g_wns_ns": six.get("wns_ns"),
                "e3g_case": cls.get("case"),
                "e3g_next_gate": cls.get("next_gate"),
                "e3g_logits_left_top20": six.get("logits_left_top20"),
                "updated": now,
            },
        )

    g14 = ROOT / "results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/G14_STAGE14_BOARD_GATE.json"
    if g14.is_file():
        data = json.loads(g14.read_text(encoding="utf-8"))
        data["recorded_at"] = now
        data["smallest_remaining_experiment"] = (
            f"E3g Case {cls.get('case')} next={cls.get('next_gate')}. Do not program. Do not stamp BOARD_PASS."
        )
        data.setdefault("e3a", {})["e3g"] = (
            f"OOC_DONE case={cls.get('case')} wns={six.get('wns_ns')} "
            f"dest={six.get('worst_dest_family')} PROGRAM=NO"
        )
        for item in data.get("section_22", []):
            if item.get("id") == "FINAL PHYSICAL CLOSURE":
                item["note"] = (
                    f"E3g Case {cls.get('case')} WNS {six.get('wns_ns')} ns; not routed C6"
                )
        g14.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")

    print(
        "E3G_OOC_PARSED PROGRAM=NO",
        "case",
        cls.get("case"),
        "wns",
        six.get("wns_ns"),
        "delta",
        cls.get("wns_delta_vs_e3e_ns"),
        "logits_top20",
        six.get("logits_wdata_in_top20"),
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
