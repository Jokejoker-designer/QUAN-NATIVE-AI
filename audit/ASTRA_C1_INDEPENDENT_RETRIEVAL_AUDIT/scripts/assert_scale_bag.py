#!/usr/bin/env python3
"""Validate one scale bag against C1 close rules. Read-only.

Usage:
  python scripts/assert_scale_bag.py D:\\FPGA\\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\\results\\A7-NATIVE-GRAPH\\ASTRA-C1-N65536-SCALE-01 65536
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

KEEP_16K_CORPUS = "6991adc75ffc4d0c50bdf780f455bac5a8eb97ecf4e575d49f42f1716e0aa597"


def fail(msg: str) -> int:
    print("FAIL", msg)
    return 1


def banner_n(xsim: str) -> int | None:
    m = re.search(r"_N=(\d+)", xsim)
    if m:
        return int(m.group(1))
    m = re.search(r"(?<![A-Z_])N=(\d+)", xsim)
    return int(m.group(1)) if m else None


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        return fail("usage: assert_scale_bag.py BAG_DIR EXPECTED_N")
    bag = Path(argv[1])
    expected_n = int(argv[2])
    if not bag.is_dir():
        return fail(f"bag missing: {bag}")
    xsim_p = bag / "xsim.log"
    if not xsim_p.is_file():
        return fail("xsim.log missing")
    xsim = xsim_p.read_text(encoding="utf-8", errors="replace")
    got_n = banner_n(xsim)
    if got_n != expected_n:
        return fail(f"banner N={got_n} expected {expected_n} (silent N drop / overclaim)")
    if expected_n == 800000 and KEEP_16K_CORPUS[:16] in xsim and "CORPUS = KEEP copy SHA 6991adc7" in (bag / "CLOSEOUT.md").read_text(encoding="utf-8", errors="replace") if (bag / "CLOSEOUT.md").is_file() else False:
        return fail("16k KEEP corpus 6991adc7 used as 800k")
    if "REDUCTION_X1000=NOT_EMITTED" in xsim:
        return fail("REDUCTION_X1000=NOT_EMITTED")
    if re.search(r"1\s*-\s*CAND_CAP\s*/\s*N", (bag / "RESULTS.md").read_text(encoding="utf-8", errors="replace") if (bag / "RESULTS.md").is_file() else ""):
        return fail("tautology reduction 1-CAND_CAP/N")
    incomp = re.findall(
        r"CLASS_(\w+).*\bgold_n=(\d+).*incomp=(\d+)", xsim
    )
    for cls, gold_n, inc in incomp:
        if int(gold_n) >= 1 and int(inc) == 1 and "excluded" not in cls:
            # distractor excluded classes may differ; fail retrieve incomp
            if cls not in ("distractor",):
                return fail(f"SEARCH_INCOMPLETE on {cls} gold_n={gold_n}")
    late = expected_n - 2
    sent = expected_n - 1
    if expected_n >= 4096:
        if f"LATE_GOLD" in xsim or str(late) in xsim:
            pass
        else:
            return fail(f"late gold nid {late} not evidenced in xsim")
        if str(sent) not in xsim:
            return fail(f"sentinel nid {sent} not evidenced in xsim")
    golden_p = bag / "GOLDEN.json"
    if golden_p.is_file():
        g = json.loads(golden_p.read_text(encoding="utf-8"))
        gn = g.get("n")
        if gn is not None and int(gn) != expected_n:
            return fail(f"GOLDEN n={gn} expected {expected_n}")
    print("PASS_NARROW", bag.name, f"N={expected_n}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
