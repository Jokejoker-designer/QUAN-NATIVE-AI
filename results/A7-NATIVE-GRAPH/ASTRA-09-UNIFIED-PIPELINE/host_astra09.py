#!/usr/bin/env python3
"""ASTRA-09 host gold: packets from qse-v2 twin; engine from loaded edges. PROGRAM=NO."""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
sys.path.insert(0, str(ROOT / "rtl" / "native_graph" / "query"))
from twin_role import extract  # noqa: E402

ST_ANSWER, ST_UNKNOWN, ST_WRONGDIR, ST_NTRANS = 0, 1, 2, 3
PUMP, CHILLER, CONDENSER, COMPRESSOR = 10, 1, 2, 4
REL_SUP, REL_REQ = 1, 2
E_AB, E_BC, E_SUP0, E_SUP1 = 1, 2, 3, 4
CTX_INDIRECT = 2

QUERIES = {
    "C1_FWD": "pump supplies chiller",
    "C1_REV": "chiller supplies pump",
    "C1_NTRANS": "pump supplies indirect condenser",
    "C2_1HOP": "pump requires chiller",
    "C3_2HOP": "pump requires indirect compressor",
    "C3_NO_AC": "pump requires compressor",
    "C4_UNREL": "payroll tax form",
    "C5_MISS": "pump requires indirect compressor",
    "C6_REV1": "chiller requires pump",
    "C6_REV2": "compressor requires indirect pump",
}


def pack48(text: str) -> tuple[int, int]:
    raw = text.encode("ascii")
    v = 0
    for i, b in enumerate(raw):
        v |= b << (8 * i)
    return v, len(raw)


def run_engine(edges: list[dict], s: int, r: int, o: int, ov: bool, two: bool) -> dict:
    found = False
    wrong = False
    ntrans = False
    cyc = False
    conf = False
    ans = p0 = p1 = 0
    for e in edges:
        if not e["v"]:
            continue
        if ov and e["r"] == r and e["s"] == o and e["o"] == s:
            wrong = True
        if e["r"] != r or e["s"] != s:
            continue
        if two:
            if not e["t"]:
                ntrans = True
                continue
            if not e["p"]:
                continue
            for f in edges:
                if not f["v"] or f["r"] != r or f["s"] != e["o"]:
                    continue
                if f["o"] == s:
                    cyc = True
                    continue
                if not ov or f["o"] == o:
                    if not f["p"]:
                        continue
                    if found and ans != f["o"]:
                        conf = True
                    found = True
                    ans, p0, p1 = f["o"], e["e"], f["e"]
        else:
            if ov and e["o"] != o:
                continue
            if not e["p"]:
                continue
            if found and ans != e["o"]:
                conf = True
            found = True
            ans, p0, p1 = e["o"], e["e"], 0
    if conf:
        return {"st": 5, "ans": 0, "p0": 0, "p1": 0, "st_name": "CONFLICT"}
    if cyc:
        return {"st": 4, "ans": 0, "p0": 0, "p1": 0, "st_name": "CYCLE"}
    if ntrans and not found:
        return {"st": ST_NTRANS, "ans": 0, "p0": 0, "p1": 0, "st_name": "NTRANS"}
    if found:
        return {"st": ST_ANSWER, "ans": ans, "p0": p0, "p1": p1, "st_name": "ANSWER"}
    if wrong:
        return {"st": ST_WRONGDIR, "ans": 0, "p0": 0, "p1": 0, "st_name": "WRONGDIR"}
    return {"st": ST_UNKNOWN, "ans": 0, "p0": 0, "p1": 0, "st_name": "UNKNOWN"}


def corpus_full() -> list[dict]:
    return [
        {"s": PUMP, "r": REL_REQ, "o": CHILLER, "e": E_AB, "t": 1, "p": 1, "v": 1},
        {"s": CHILLER, "r": REL_REQ, "o": COMPRESSOR, "e": E_BC, "t": 1, "p": 1, "v": 1},
        {"s": PUMP, "r": REL_SUP, "o": CHILLER, "e": E_SUP0, "t": 0, "p": 1, "v": 1},
        {"s": CHILLER, "r": REL_SUP, "o": CONDENSER, "e": E_SUP1, "t": 0, "p": 1, "v": 1},
    ]


def gold_case(name: str, text: str, edges: list[dict], skip_if_no_k0: bool = True) -> dict:
    pkt = extract(text)
    two = pkt["ctx_id"] == CTX_INDIRECT
    k0v = bool(pkt["k0_valid"])
    if skip_if_no_k0 and not k0v:
        eng = {"st": ST_UNKNOWN, "ans": 0, "p0": 0, "p1": 0, "st_name": "UNKNOWN"}
        skip = True
    else:
        eng = run_engine(
            edges,
            pkt["subj_id"],
            pkt["rel_id"],
            pkt["obj_id"],
            bool(pkt["k1_valid"]),
            two,
        )
        skip = False
    packed, n = pack48(text)
    return {
        "name": name,
        "text": text,
        "n": n,
        "bytes_hex": f"{packed:096x}",
        "subj_id": pkt["subj_id"],
        "obj_id": pkt["obj_id"],
        "rel_id": pkt["rel_id"],
        "ctx_id": pkt["ctx_id"],
        "triple_valid": pkt["triple_valid"],
        "k0": pkt["k0"],
        "k1": pkt["k1"],
        "k0_valid": pkt["k0_valid"],
        "k1_valid": pkt["k1_valid"],
        "two_hop": int(two),
        "skip": int(skip),
        "st": eng["st"],
        "st_name": eng["st_name"],
        "ans": eng["ans"],
        "p0": eng["p0"],
        "p1": eng["p1"],
        "vq8": 0,
        "n_host": 0,
        "ac_stored": False,
    }


def build_golden() -> dict:
    edges = corpus_full()
    cases = {}
    for name, text in QUERIES.items():
        ed = [dict(x) for x in edges]
        if name == "C5_MISS":
            ed[1]["v"] = 0
        cases[name] = gold_case(name, text, ed)
    fwd = cases["C1_FWD"]
    rev = cases["C1_REV"]
    if fwd["k0"] == rev["k0"] and fwd["subj_id"] == rev["subj_id"]:
        raise SystemExit("GOLD_FAIL reverse packets collapsed")
    if cases["C3_2HOP"]["st"] != ST_ANSWER or cases["C3_2HOP"]["ans"] != COMPRESSOR:
        raise SystemExit("GOLD_FAIL 2hop")
    if cases["C3_NO_AC"]["st"] == ST_ANSWER:
        raise SystemExit("GOLD_FAIL A→C stored in gold")
    if cases["C4_UNREL"]["st"] != ST_UNKNOWN or cases["C4_UNREL"]["triple_valid"]:
        raise SystemExit("GOLD_FAIL unrelated")
    if cases["C5_MISS"]["st"] != ST_UNKNOWN or cases["C5_MISS"]["ans"] == COMPRESSOR:
        raise SystemExit("GOLD_FAIL missing kept C")
    if cases["C6_REV1"]["ans"] == CHILLER or cases["C6_REV1"]["st"] == ST_ANSWER:
        raise SystemExit("GOLD_FAIL reverse kept old object")
    if cases["C1_NTRANS"]["st"] != ST_NTRANS:
        raise SystemExit("GOLD_FAIL supplies 2hop not NTRANS")
    return {
        "gate": "ASTRA-09-UNIFIED-PIPELINE",
        "law_qse": "qse-v2-role-00",
        "law_rank": "native-rank-sgd-q8-v1",
        "engine": "a7ng_rel_engine_2hop",
        "freeze_i": 1,
        "n_host": 0,
        "ac_stored": False,
        "ids": {
            "pump": PUMP,
            "chiller": CHILLER,
            "condenser": CONDENSER,
            "compressor": COMPRESSOR,
            "rel_supplies": REL_SUP,
            "rel_requires": REL_REQ,
            "eid_ab": E_AB,
            "eid_bc": E_BC,
            "eid_sup0": E_SUP0,
            "eid_sup1": E_SUP1,
            "ctx_indirect": CTX_INDIRECT,
        },
        "corpus": [
            "pump requires chiller eid=1 trans=1",
            "chiller requires compressor eid=2 trans=1",
            "pump supplies chiller eid=3 trans=0",
            "chiller supplies condenser eid=4 trans=0",
            "NOT stored: pump requires compressor",
        ],
        "cases": cases,
        "lm06": "LANGUAGE_UNPROVEN",
        "sparse_axi": "omitted_optional",
        "bit": False,
        "program": False,
        "com12": "UNTOUCHED",
    }


def write_svh(gold: dict) -> None:
    lines = [
        "// generated by host_astra09.py — packet gold from qse-v2 twin. PROGRAM=NO.",
        "`ifndef ASTRA09_QUERY_CASES_SVH",
        "`define ASTRA09_QUERY_CASES_SVH",
        "localparam logic [7:0] A9_PUMP = 8'd10;",
        "localparam logic [7:0] A9_CHILLER = 8'd1;",
        "localparam logic [7:0] A9_COND = 8'd2;",
        "localparam logic [7:0] A9_COMP = 8'd4;",
        "localparam logic [7:0] A9_REL_SUP = 8'd1;",
        "localparam logic [7:0] A9_REL_REQ = 8'd2;",
        "localparam logic [7:0] A9_E_AB = 8'd1;",
        "localparam logic [7:0] A9_E_BC = 8'd2;",
        "localparam logic [7:0] A9_E_S0 = 8'd3;",
        "localparam logic [7:0] A9_E_S1 = 8'd4;",
    ]
    for name, c in gold["cases"].items():
        u = name
        lines.append(f"localparam int {u}_N = {c['n']};")
        lines.append(f"localparam logic [8*48-1:0] {u}_B = 384'h{c['bytes_hex']};")
        lines.append(f"localparam logic [7:0] {u}_SUBJ = 8'd{c['subj_id']};")
        lines.append(f"localparam logic [7:0] {u}_OBJ = 8'd{c['obj_id']};")
        lines.append(f"localparam logic [7:0] {u}_REL = 8'd{c['rel_id']};")
        lines.append(f"localparam logic [7:0] {u}_CTX = 8'd{c['ctx_id']};")
        lines.append(f"localparam logic {u}_TRIP = 1'b{c['triple_valid']};")
        lines.append(f"localparam logic {u}_TWO = 1'b{c['two_hop']};")
        lines.append(f"localparam logic {u}_SKIP = 1'b{c['skip']};")
        lines.append(f"localparam logic {u}_K0V = 1'b{c['k0_valid']};")
        lines.append(f"localparam logic [15:0] {u}_K0 = 16'h{c['k0']:04X};")
        lines.append(f"localparam logic [15:0] {u}_K1 = 16'h{c['k1']:04X};")
        lines.append(f"localparam logic [2:0] {u}_ST = 3'd{c['st']};")
        lines.append(f"localparam logic [7:0] {u}_ANS = 8'd{c['ans']};")
        lines.append(f"localparam logic [7:0] {u}_P0 = 8'd{c['p0']};")
        lines.append(f"localparam logic [7:0] {u}_P1 = 8'd{c['p1']};")
    lines.append("`endif")
    (BAG / "query_cases.svh").write_text("\n".join(lines) + "\n", encoding="utf-8")


CASE_RE = re.compile(
    r"CASE\s+(\S+)\s+subj=(\d+)\s+obj=(\d+)\s+rel=(\d+)\s+ctx=(\d+)\s+"
    r"k0=(\d+)\s+k1=(\d+)\s+two=(\d+)\s+trip=(\d+)\s+st=(\d+)\s+"
    r"ans=(\d+)\s+p0=(\d+)\s+p1=(\d+)\s+skip=(\d+)\s+vq8=(-?\d+)\s+nhost=(\d+)"
)


def compare(gold: dict) -> int:
    logp = BAG / "xsim.log"
    if not logp.exists():
        print("COMPARE_FAIL missing xsim.log")
        return 2
    body = logp.read_text(encoding="utf-8", errors="replace")
    if "FIRST_DIVERGENCE" in body:
        print("COMPARE_FAIL FIRST_DIVERGENCE in xsim.log")
        return 3
    if "ASTRA09_UNIFIED_XSIM_PASS" not in body:
        print("COMPARE_FAIL no ASTRA09_UNIFIED_XSIM_PASS")
        return 4
    tb = (BAG / "tb_astra09_pipe.sv").read_text(encoding="utf-8", errors="replace")
    for bad in (".q_s(", ".q_o(", ".q_r(", "poke_v", "winner_i", "ans_i"):
        if bad in tb:
            print(f"COMPARE_FAIL TB poke token {bad}")
            return 5
    seen = {}
    for m in CASE_RE.finditer(body):
        name = m.group(1)
        seen[name] = {
            "subj_id": int(m.group(2)),
            "obj_id": int(m.group(3)),
            "rel_id": int(m.group(4)),
            "ctx_id": int(m.group(5)),
            "k0": int(m.group(6)),
            "k1": int(m.group(7)),
            "two_hop": int(m.group(8)),
            "triple_valid": int(m.group(9)),
            "st": int(m.group(10)),
            "ans": int(m.group(11)),
            "p0": int(m.group(12)),
            "p1": int(m.group(13)),
            "skip": int(m.group(14)),
            "vq8": int(m.group(15)),
            "n_host": int(m.group(16)),
        }
    fail = 0
    for name, exp in gold["cases"].items():
        got = seen.get(name)
        if got is None:
            print(f"COMPARE_FAIL missing {name}")
            fail += 1
            continue
        keys = (
            "subj_id",
            "obj_id",
            "rel_id",
            "ctx_id",
            "k0",
            "k1",
            "two_hop",
            "triple_valid",
            "st",
            "ans",
            "p0",
            "p1",
            "skip",
            "n_host",
        )
        for k in keys:
            if int(got[k]) != int(exp[k]):
                print(f"COMPARE_FAIL {name}.{k} got={got[k]} exp={exp[k]}")
                fail += 1
        if got["vq8"] != 0:
            print(f"COMPARE_FAIL {name}.vq8={got['vq8']} freeze-zero expected 0")
            fail += 1
    if seen.get("C1_FWD", {}).get("k0") == seen.get("C1_REV", {}).get("k0"):
        print("COMPARE_FAIL reverse packets identical")
        fail += 1
    if fail:
        print(f"COMPARE_FAIL n={fail}")
        return 1
    print("ASTRA09_HOST_COMPARE_PASS")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--golden-only", action="store_true")
    ap.add_argument("--compare", action="store_true")
    args = ap.parse_args()
    gold = build_golden()
    (BAG / "GOLDEN.json").write_text(json.dumps(gold, indent=2) + "\n", encoding="utf-8")
    write_svh(gold)
    print("WROTE", BAG / "GOLDEN.json")
    print("WROTE", BAG / "query_cases.svh")
    if args.compare:
        return compare(gold)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
