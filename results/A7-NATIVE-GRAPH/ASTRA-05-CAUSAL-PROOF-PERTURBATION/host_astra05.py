#!/usr/bin/env python3
"""ASTRA-05 host golden + XSim compare. PROGRAM=NO. BIT=NO.

Entity IDs are opaque. Derived READ_A→CALIB_C is never stored as a row.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

from twin_rel_engine import RelEngine2HopV2, ST_ANSWER, ST_CONFLICT, ST_INCOMPLETE, ST_UNKNOWN

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
RTL = ROOT / "rtl" / "native_graph" / "integrate" / "a7ng_rel_engine_2hop.sv"
GATE = "ASTRA-05-CAUSAL-PROOF-PERTURBATION"

# Opaque IDs — not a string ROM of the exam sentence.
READ_A = 0xA1
READY_B = 0xB2
CALIB_C = 0xC3
CALIB_D = 0xD4
REL_REQ = 0x21
EID_AB = 0x11
EID_BC = 0x22
EID_BD = 0x33
EID_NEG = 0x44
RND_X = 0x3E
RND_Y = 0x91
RND_Z = 0x07
RND_E0 = 0x54
RND_E1 = 0xA8

IDS_SVH = """// Opaque entity/edge IDs for ASTRA-05 TB. Not an answer ROM.
// Generated/owned by host_astra05.py. Engine RTL must not contain these constants.
`ifndef ASTRA05_IDS_SVH
`define ASTRA05_IDS_SVH
localparam logic [7:0] A5_READ_A  = 8'hA1;
localparam logic [7:0] A5_READY_B = 8'hB2;
localparam logic [7:0] A5_CALIB_C = 8'hC3;
localparam logic [7:0] A5_CALIB_D = 8'hD4;
localparam logic [7:0] A5_REL_REQ = 8'h21;
localparam logic [7:0] A5_EID_AB  = 8'h11;
localparam logic [7:0] A5_EID_BC  = 8'h22;
localparam logic [7:0] A5_EID_BD  = 8'h33;
localparam logic [7:0] A5_EID_NEG = 8'h44;
localparam logic [7:0] A5_RND_X   = 8'h3E;
localparam logic [7:0] A5_RND_Y   = 8'h91;
localparam logic [7:0] A5_RND_Z   = 8'h07;
localparam logic [7:0] A5_RND_E0  = 8'h54;
localparam logic [7:0] A5_RND_E1  = 8'hA8;
`endif
"""

CASE_RE = re.compile(
    r"ASTRA05_CASE (\S+) st=(\d+) ans=(\d+) p0=(\d+) p1=(\d+)(?: scan=(\d+))?"
)


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest()


def rec(name: str, q: dict) -> dict:
    return {
        "name": name,
        "st": q["st"],
        "st_name": q["st_name"],
        "ans": q["ans"],
        "p0": q["p0"],
        "p1": q["p1"],
        "scan": q["scan"],
    }


def run_golden() -> dict:
    eng = RelEngine2HopV2()
    cases: list[dict] = []

    eng.clr()
    eng.load(0, READ_A, REL_REQ, READY_B, EID_AB, trans=1, pol=1, keep=1)
    eng.load(1, READY_B, REL_REQ, CALIB_C, EID_BC, trans=1, pol=1, keep=1)
    if eng.has_tuple(READ_A, REL_REQ, CALIB_C):
        raise SystemExit("FAIL exam pair stored as a row after base load")
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("BASE", q))
    if q["st"] != ST_ANSWER or q["ans"] != CALIB_C or q["p0"] != EID_AB or q["p1"] != EID_BC:
        raise SystemExit(f"FAIL BASE {q}")

    q = eng.query(READ_A, REL_REQ, CALIB_C, obj_valid=1, two_hop=0)
    cases.append(rec("BASE_NOT_STORED", q))
    if q["st"] != ST_UNKNOWN or q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL BASE_NOT_STORED {q}")

    # A. DELETE hop2
    eng.load(1, 0, 0, 0, 0, keep=0)
    if eng.has_tuple(READ_A, REL_REQ, CALIB_C):
        raise SystemExit("FAIL exam pair stored after delete")
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("DEL", q))
    if q["st"] != ST_UNKNOWN:
        raise SystemExit(f"FAIL DEL status {q}")
    if q["ans"] == CALIB_C or q["st"] == ST_ANSWER:
        raise SystemExit(f"FAIL DEL kept CALIB_C {q}")

    # B. REPLACE C with D, new edge id
    eng.load(1, READY_B, REL_REQ, CALIB_D, EID_BD, trans=1, pol=1, keep=1)
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("REP", q))
    if q["st"] != ST_ANSWER or q["ans"] != CALIB_D:
        raise SystemExit(f"FAIL REP {q}")
    if q["p1"] == EID_BC or q["p1"] != EID_BD or q["p0"] != EID_AB:
        raise SystemExit(f"FAIL REP proof ids {q}")
    if q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL REP still C {q}")

    # C. contradiction: pos + forbids on hop2
    eng.load(1, READY_B, REL_REQ, CALIB_C, EID_BC, trans=1, pol=1, keep=1)
    eng.load(2, READY_B, REL_REQ, CALIB_C, EID_NEG, trans=0, pol=0, keep=1)
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("CONF_NEG", q))
    if q["st"] != ST_CONFLICT or q["st"] == ST_ANSWER:
        raise SystemExit(f"FAIL CONF_NEG {q}")
    if q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL CONF_NEG still answered C {q}")

    # C2. two derived objects
    eng.load(2, READY_B, REL_REQ, CALIB_D, EID_BD, trans=1, pol=1, keep=1)
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("CONF_TWO", q))
    if q["st"] != ST_CONFLICT:
        raise SystemExit(f"FAIL CONF_TWO {q}")

    # D. CAP max_scan=1 on 2-edge proof
    eng.load(2, 0, 0, 0, 0, keep=0)
    q = eng.query(READ_A, REL_REQ, two_hop=1, max_scan=1)
    cases.append(rec("CAP", q))
    if q["st"] != ST_INCOMPLETE:
        raise SystemExit(f"FAIL CAP {q}")
    if q["st"] == ST_UNKNOWN or q["st"] == ST_ANSWER or q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL CAP false answer/unknown {q}")
    if q["scan"] != 1:
        raise SystemExit(f"FAIL CAP scan {q}")

    q = eng.query(READ_A, REL_REQ, two_hop=1, max_hop=1)
    cases.append(rec("CAP_HOP", q))
    if q["st"] != ST_INCOMPLETE or q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL CAP_HOP {q}")

    q = eng.query(READ_A, REL_REQ, two_hop=1, max_scan=0)
    cases.append(rec("CAP_RESTORE", q))
    if q["st"] != ST_ANSWER or q["ans"] != CALIB_C:
        raise SystemExit(f"FAIL CAP_RESTORE {q}")

    # invert hop2 direction
    eng.load(1, CALIB_C, REL_REQ, READY_B, EID_BC, trans=1, pol=1, keep=1)
    q = eng.query(READ_A, REL_REQ, two_hop=1)
    cases.append(rec("INV", q))
    if q["st"] == ST_ANSWER or q["ans"] == CALIB_C:
        raise SystemExit(f"FAIL INV kept C {q}")
    if q["st"] != ST_UNKNOWN:
        raise SystemExit(f"FAIL INV status {q}")

    # randomize IDs, same structure
    eng.clr()
    eng.load(0, RND_X, REL_REQ, RND_Y, RND_E0, trans=1, pol=1, keep=1)
    eng.load(1, RND_Y, REL_REQ, RND_Z, RND_E1, trans=1, pol=1, keep=1)
    if eng.has_tuple(RND_X, REL_REQ, RND_Z):
        raise SystemExit("FAIL randomized exam pair stored")
    q = eng.query(RND_X, REL_REQ, two_hop=1)
    cases.append(rec("RND", q))
    if q["st"] != ST_ANSWER or q["ans"] != RND_Z or q["p0"] != RND_E0 or q["p1"] != RND_E1:
        raise SystemExit(f"FAIL RND {q}")

    rtl_txt = RTL.read_text(encoding="utf-8", errors="replace")
    forbidden = ["CALIB_C", "READ_A", "8'hC3", "8'hA1", "0xC3", "0xA1"]
    hits = [t for t in forbidden if t in rtl_txt]
    if hits:
        raise SystemExit(f"FAIL RTL contains exam constants {hits}")

    golden = {
        "gate": GATE,
        "law": "qse-v2-role-00 control; 2hop-v2 polarity+budget",
        "exam_pair_stored": False,
        "open_world_claimed": False,
        "ids": {
            "READ_A": READ_A,
            "READY_B": READY_B,
            "CALIB_C": CALIB_C,
            "CALIB_D": CALIB_D,
            "REL_REQ": REL_REQ,
            "EID_AB": EID_AB,
            "EID_BC": EID_BC,
            "EID_BD": EID_BD,
            "RND_X": RND_X,
            "RND_Y": RND_Y,
            "RND_Z": RND_Z,
        },
        "cases": cases,
        "result_host": "PASS",
    }
    return golden


def write_ids() -> None:
    (BAG / "ids.svh").write_text(IDS_SVH, encoding="utf-8", newline="\n")


def compare_xsim(golden: dict, log_path: Path) -> None:
    if not log_path.is_file():
        raise SystemExit(f"FAIL missing {log_path}")
    body = log_path.read_text(encoding="utf-8", errors="replace")
    if "FIRST_DIVERGENCE" in body:
        raise SystemExit("FAIL xsim FIRST_DIVERGENCE")
    if "ASTRA05_CAUSAL_XSIM_PASS" not in body:
        raise SystemExit("FAIL xsim missing ASTRA05_CAUSAL_XSIM_PASS")
    got = {}
    for m in CASE_RE.finditer(body):
        got[m.group(1)] = {
            "st": int(m.group(2)),
            "ans": int(m.group(3)),
            "p0": int(m.group(4)),
            "p1": int(m.group(5)),
            "scan": int(m.group(6)) if m.group(6) is not None else None,
        }
    for c in golden["cases"]:
        name = c["name"]
        if name not in got:
            raise SystemExit(f"FAIL xsim missing case {name}")
        g = got[name]
        if g["st"] != c["st"] or g["ans"] != c["ans"] or g["p0"] != c["p0"] or g["p1"] != c["p1"]:
            raise SystemExit(f"FAIL mismatch {name} host={c} xsim={g}")
    print("ASTRA05_HOST_XSIM_COMPARE_PASS")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--golden-only", action="store_true")
    ap.add_argument("--compare", action="store_true")
    args = ap.parse_args()
    write_ids()
    golden = run_golden()
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    print("ASTRA05_HOST_GOLDEN_PASS")
    for c in golden["cases"]:
        print(
            f"ASTRA05_CASE {c['name']} st={c['st']} ans={c['ans']} "
            f"p0={c['p0']} p1={c['p1']} scan={c['scan']}"
        )
    if args.golden_only:
        return 0
    if args.compare or (BAG / "xsim.log").is_file():
        compare_xsim(golden, BAG / "xsim.log")
    return 0


if __name__ == "__main__":
    sys.exit(main())
