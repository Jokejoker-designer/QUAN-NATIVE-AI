#!/usr/bin/env python3
"""C7 silicon exam runner. Refuses unless freeze+explicit auth. Never programs."""
from __future__ import annotations

import json
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
FREEZE = BAG / "C6_FREEZE_PRECHECK.json"
EXAM = BAG / "C7_BOARD_EXAM_V1.json"
AUTH = BAG / "C7_PROGRAM_AUTH.txt"
LIVE = ROOT / "results/A7-NATIVE-GRAPH/STATUS/ASTRA_C4_C7_LIVE.json"


def _load(p: Path) -> dict:
    if not p.is_file():
        return {}
    return json.loads(p.read_text(encoding="utf-8"))


def main() -> int:
    freeze = _load(FREEZE)
    exam = _load(EXAM)
    live = _load(LIVE)
    allowed = bool(freeze.get("freeze_allowed"))
    bit_sha = (freeze.get("bitstream") or {}).get("sha256")
    filled = bool(exam.get("queries_filled")) and bool(exam.get("locked"))
    auth_ok = AUTH.is_file() and "PROGRAM=YES" in AUTH.read_text(encoding="utf-8", errors="replace")
    print("C7_GATE PROGRAM=NO freeze_allowed", allowed, "bit", bool(bit_sha), "queries_locked", filled, "auth", auth_ok)
    if live.get("PROGRAM") != "NO":
        print("C7_ABORT live PROGRAM flag must stay NO until this script is explicitly authorized")
        return 2
    if not allowed or not bit_sha:
        print("C7_ABORT freeze_allowed=false or bit SHA missing; will not open UART or JTAG")
        return 2
    if not filled:
        print("C7_ABORT C7 queries not filled/locked; do not invent a live set after seeing silicon")
        return 2
    if not auth_ok:
        print("C7_ABORT C7_PROGRAM_AUTH.txt missing PROGRAM=YES; default is PROGRAM=NO")
        return 2
    print("C7_ABORT runner has no program/UART path yet; do not add program_hw here")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
