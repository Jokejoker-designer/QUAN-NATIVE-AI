#!/usr/bin/env python3
"""ASTRA-09-SPARSE-GLUE host gold. PROGRAM=NO.

Packets from qse-v2 twin. Index image independent of DUT.
2-hop gold from loaded edges. Walker plant IDs are not answers.
qse-v1 keys are not retargeted.
"""
from __future__ import annotations

import argparse
import hashlib
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
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + 0x40000
N_TABLES = 4
N_BUCKETS = 4096
CAND_CAP = 16
HEAD_CAP = 16
ENTRY = 16
TABLE_BYTES = 65536
EPOCH = 7
PLANT_BASE = 201

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


def dir_addr(table: int, key: int) -> int:
    return INDEX_BASE + table * TABLE_BYTES + (key & 0xFFF) * ENTRY


def dir_pack(base: int, count: int, ovf: int, ep: int) -> int:
    return (
        ((ep & 0xFFFF) << 64)
        | ((ovf & 1) << 48)
        | ((count & 0xFFFF) << 32)
        | (base & 0x0FFFFFFF)
    )


def word_of(addr: int) -> int:
    return 6144 + ((addr - INDEX_BASE) >> 4)


def pack_post_beat(ids: list[int]) -> int:
    v = 0
    for lane, nid in enumerate(ids[:4]):
        v |= (nid & 0xFFFFFFFF) << (32 * lane)
    return v


def nvalid(pkt: dict) -> int:
    return int(pkt["k0_valid"]) + int(pkt["k1_valid"]) + int(pkt["k2_valid"]) + int(pkt["k3_valid"])


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


def route_query(q: dict, heads: list) -> dict:
    probed = []
    seen: list[int] = []
    ndup = 0
    ntrunc = 0
    npost = 0
    keys = [q["k0"], q["k1"], q["k2"], q["k3"]]
    valids = [q["k0_valid"], q["k1_valid"], q["k2_valid"], q["k3_valid"]]
    daddr = [0, 0, 0, 0]
    for t in range(N_TABLES):
        if valids[t] == 0:
            continue
        b = keys[t] & 0xFFF
        probed.append(t)
        daddr[t] = dir_addr(t, keys[t])
        ids = list(heads[t][b])
        if ids:
            npost += 1
        for nid in ids:
            if nid in seen:
                ndup += 1
            elif len(seen) >= CAND_CAP:
                ntrunc += 1
            else:
                seen.append(nid)
    return {
        "emit": seen,
        "n_emit": len(seen),
        "n_dir": len(probed),
        "n_post": npost,
        "n_dup": ndup,
        "n_trunc": ntrunc,
        "pmask": sum(1 << t for t in probed),
        "n_valid": nvalid(q),
        "dir0": daddr[0],
        "dir1": daddr[1],
        "dir2": daddr[2],
        "dir3": daddr[3],
    }


def gold_engine(name: str, pkt: dict, edges: list[dict]) -> dict:
    two = pkt["ctx_id"] == CTX_INDIRECT
    k0v = bool(pkt["k0_valid"])
    if not k0v:
        return {
            "st": ST_UNKNOWN,
            "ans": 0,
            "p0": 0,
            "p1": 0,
            "st_name": "UNKNOWN",
            "skip": 1,
            "two_hop": int(two),
        }
    eng = run_engine(
        edges,
        pkt["subj_id"],
        pkt["rel_id"],
        pkt["obj_id"],
        bool(pkt["k1_valid"]),
        two,
    )
    eng["skip"] = 0
    eng["two_hop"] = int(two)
    return eng


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def build_golden() -> dict:
    pkts = {}
    for name, text in QUERIES.items():
        pkt = extract(text)
        if pkt["n_host"] != 0:
            raise SystemExit(f"HOST_SEMANTIC_LEAK gold {name}")
        packed, n = pack48(text)
        pkt["name"] = name
        pkt["text"] = text
        pkt["n"] = n
        pkt["bytes_hex"] = f"{packed:096x}"
        pkts[name] = pkt

    if pkts["C1_FWD"]["k0"] == pkts["C1_REV"]["k0"] and pkts["C1_FWD"]["subj_id"] == pkts["C1_REV"]["subj_id"]:
        raise SystemExit("GOLD_FAIL reverse packets collapsed")
    if pkts["C1_FWD"]["k0"] != pkts["C1_REV"]["k1"] or pkts["C1_FWD"]["k1"] != pkts["C1_REV"]["k0"]:
        raise SystemExit("GOLD_FAIL reverse k0/k1 not swapped")
    if pkts["C1_FWD"]["k2"] != pkts["C1_REV"]["k3"] or pkts["C1_FWD"]["k3"] != pkts["C1_REV"]["k2"]:
        raise SystemExit("GOLD_FAIL reverse k2/k3 not swapped")
    if nvalid(pkts["C4_UNREL"]) != 0:
        raise SystemExit("GOLD_FAIL payroll has valid keys")

    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    plant = {}
    for i, name in enumerate(QUERIES):
        q = pkts[name]
        if nvalid(q) == 0:
            plant[name] = 0
            continue
        nid = PLANT_BASE + i
        plant[name] = nid
        keys = [q["k0"], q["k1"], q["k2"], q["k3"]]
        valids = [q["k0_valid"], q["k1_valid"], q["k2_valid"], q["k3_valid"]]
        for t in range(N_TABLES):
            if valids[t] == 0:
                continue
            b = keys[t] & 0xFFF
            if nid not in heads[t][b]:
                if len(heads[t][b]) < HEAD_CAP:
                    heads[t][b].append(nid)
                else:
                    ovf[t][b] = 1

    writes: dict[int, int] = {}
    post_ptr = POST_HEAP
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            ids = heads[t][b]
            if not ids:
                continue
            n = len(ids)
            nbeats = (n + 3) // 4
            base = post_ptr
            post_ptr += nbeats * ENTRY
            writes[word_of(dir_addr(t, b))] = dir_pack(base, n, ovf[t][b], EPOCH)
            for j in range(nbeats):
                chunk = ids[j * 4 : j * 4 + 4]
                writes[word_of(base + j * ENTRY)] = pack_post_beat(chunk)

    edges = corpus_full()
    cases = {}
    for name, text in QUERIES.items():
        ed = [dict(x) for x in edges]
        if name == "C5_MISS":
            ed[1]["v"] = 0
        pkt = pkts[name]
        rt = route_query(pkt, heads)
        eng = gold_engine(name, pkt, ed)
        if eng["ans"] >= PLANT_BASE:
            raise SystemExit(f"GOLD_FAIL plant id leaked into answer {name}")
        if rt["n_dir"] > rt["n_valid"]:
            raise SystemExit(f"GOLD_FAIL n_dir>n_valid {name}")
        if rt["n_dir"] > N_TABLES:
            raise SystemExit(f"GOLD_FAIL n_dir>4 {name}")
        cases[name] = {
            "name": name,
            "text": text,
            "n": pkt["n"],
            "bytes_hex": pkt["bytes_hex"],
            "subj_id": pkt["subj_id"],
            "obj_id": pkt["obj_id"],
            "rel_id": pkt["rel_id"],
            "ctx_id": pkt["ctx_id"],
            "triple_valid": pkt["triple_valid"],
            "k0": pkt["k0"],
            "k1": pkt["k1"],
            "k2": pkt["k2"],
            "k3": pkt["k3"],
            "k0_valid": pkt["k0_valid"],
            "k1_valid": pkt["k1_valid"],
            "k2_valid": pkt["k2_valid"],
            "k3_valid": pkt["k3_valid"],
            "n_valid": rt["n_valid"],
            "two_hop": eng["two_hop"],
            "skip": eng["skip"],
            "st": eng["st"],
            "st_name": eng["st_name"],
            "ans": eng["ans"],
            "p0": eng["p0"],
            "p1": eng["p1"],
            "vq8": 0,
            "n_host": 0,
            "ac_stored": False,
            "n_dir": rt["n_dir"],
            "n_post": rt["n_post"],
            "n_emit": rt["n_emit"],
            "n_dup": rt["n_dup"],
            "pmask": rt["pmask"],
            "dir0": rt["dir0"],
            "dir1": rt["dir1"],
            "dir2": rt["dir2"],
            "dir3": rt["dir3"],
            "emit": rt["emit"],
            "plant_id": plant[name],
        }

    if cases["C3_2HOP"]["st"] != ST_ANSWER or cases["C3_2HOP"]["ans"] != COMPRESSOR:
        raise SystemExit("GOLD_FAIL 2hop")
    if cases["C3_NO_AC"]["st"] == ST_ANSWER:
        raise SystemExit("GOLD_FAIL A→C stored in gold")
    if cases["C4_UNREL"]["st"] != ST_UNKNOWN or cases["C4_UNREL"]["triple_valid"]:
        raise SystemExit("GOLD_FAIL unrelated")
    if cases["C4_UNREL"]["n_dir"] != 0 or cases["C4_UNREL"]["n_emit"] != 0:
        raise SystemExit("GOLD_FAIL payroll walk")
    if cases["C5_MISS"]["st"] != ST_UNKNOWN or cases["C5_MISS"]["ans"] == COMPRESSOR:
        raise SystemExit("GOLD_FAIL missing kept C")
    if cases["C6_REV1"]["ans"] == CHILLER or cases["C6_REV1"]["st"] == ST_ANSWER:
        raise SystemExit("GOLD_FAIL reverse kept old object")
    if cases["C1_NTRANS"]["st"] != ST_NTRANS:
        raise SystemExit("GOLD_FAIL supplies 2hop not NTRANS")
    if cases["C1_FWD"]["n_emit"] == 0 or cases["C1_REV"]["n_emit"] == 0:
        raise SystemExit("GOLD_FAIL reverse pair no emit")
    if cases["C1_FWD"]["n_dir"] != 4 or cases["C1_REV"]["n_dir"] != 4:
        raise SystemExit("GOLD_FAIL reverse n_dir")

    wr_i = sorted(writes)
    v1_qse = ROOT / "rtl" / "native_graph" / "query" / "a7ng_query_struct_extract.sv"
    v1_lex = ROOT / "rtl" / "native_graph" / "query" / "qse_lexicon.svh"
    return {
        "gate": "ASTRA-09-SPARSE-GLUE",
        "law_qse": "qse-v2-role-00",
        "law_qse_control": "qse-v1-lexicon-hdc-00 UNCHANGED",
        "law_rank": "native-rank-sgd-q8-v1",
        "engine": "a7ng_rel_engine_2hop",
        "walker": "a7ng_query_axi_sparse LAW_SEL=1",
        "freeze_i": 1,
        "live_epoch": EPOCH,
        "n_host": 0,
        "ac_stored": False,
        "v1_qse_sha256": sha256_file(v1_qse),
        "v1_lex_sha256": sha256_file(v1_lex),
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
            "plant_base": PLANT_BASE,
        },
        "corpus": [
            "pump requires chiller eid=1 trans=1",
            "chiller requires compressor eid=2 trans=1",
            "pump supplies chiller eid=3 trans=0",
            "chiller supplies condenser eid=4 trans=0",
            "NOT stored: pump requires compressor",
        ],
        "index_writes": {str(i): f"{writes[i]:032x}" for i in wr_i},
        "cases": cases,
        "lm06": "LANGUAGE_UNPROVEN",
        "sparse_axi": "wired_law_sel_1",
        "bit": False,
        "program": False,
        "com12": "UNTOUCHED",
    }


def write_svh(gold: dict) -> None:
    wr = gold["index_writes"]
    wr_i = sorted(int(k) for k in wr)
    lines = [
        "// generated by host_astra09_sparse.py — qse-v2 twin + sparse index. PROGRAM=NO.",
        "`ifndef ASTRA09_SPARSE_QUERY_CASES_SVH",
        "`define ASTRA09_SPARSE_QUERY_CASES_SVH",
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
        "localparam int unsigned G_N_WR = {0};".format(len(wr_i)),
        "localparam int G_WR_I [0:G_N_WR-1] = '{",
        "  " + ",".join(str(i) for i in wr_i) + "};",
        "localparam logic [127:0] G_WR_D [0:G_N_WR-1] = '{",
        "  " + ",".join(f"128'h{wr[str(i)]}" for i in wr_i) + "};",
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
        lines.append(f"localparam logic {u}_K1V = 1'b{c['k1_valid']};")
        lines.append(f"localparam logic {u}_K2V = 1'b{c['k2_valid']};")
        lines.append(f"localparam logic {u}_K3V = 1'b{c['k3_valid']};")
        lines.append(f"localparam logic [15:0] {u}_K0 = 16'h{c['k0']:04X};")
        lines.append(f"localparam logic [15:0] {u}_K1 = 16'h{c['k1']:04X};")
        lines.append(f"localparam logic [15:0] {u}_K2 = 16'h{c['k2']:04X};")
        lines.append(f"localparam logic [15:0] {u}_K3 = 16'h{c['k3']:04X};")
        lines.append(f"localparam logic [2:0] {u}_ST = 3'd{c['st']};")
        lines.append(f"localparam logic [7:0] {u}_ANS = 8'd{c['ans']};")
        lines.append(f"localparam logic [7:0] {u}_P0 = 8'd{c['p0']};")
        lines.append(f"localparam logic [7:0] {u}_P1 = 8'd{c['p1']};")
        lines.append(f"localparam int {u}_NDIR = {c['n_dir']};")
        lines.append(f"localparam int {u}_NPOST = {c['n_post']};")
        lines.append(f"localparam int {u}_NEMIT = {c['n_emit']};")
        lines.append(f"localparam int {u}_NVALID = {c['n_valid']};")
        lines.append(f"localparam logic [3:0] {u}_PMASK = 4'h{c['pmask']:X};")
        lines.append(f"localparam logic [27:0] {u}_D0 = 28'h{c['dir0']:07X};")
        lines.append(f"localparam logic [27:0] {u}_D1 = 28'h{c['dir1']:07X};")
        lines.append(f"localparam logic [27:0] {u}_D2 = 28'h{c['dir2']:07X};")
        lines.append(f"localparam logic [27:0] {u}_D3 = 28'h{c['dir3']:07X};")
        lines.append(f"localparam int {u}_PLANT = {c['plant_id']};")
    lines.append("`endif")
    (BAG / "query_cases.svh").write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_golden_md(gold: dict) -> None:
    lines = [
        "# GOLDEN — ASTRA-09-SPARSE-GLUE",
        "",
        "Independent host twin. Walker plant IDs ≥ 201 are retrieval-only, not 2-hop answers.",
        "",
        f"v1 QSE SHA = `{gold['v1_qse_sha256']}` (must stay ede064f0…)",
        f"v1 lexicon SHA = `{gold['v1_lex_sha256']}`",
        "",
        "| Case | Query | n_dir | n_emit | st | ans | p0 | p1 |",
        "|------|-------|------:|-------:|----|----:|---:|---:|",
    ]
    for name, c in gold["cases"].items():
        lines.append(
            f"| {name} | {c['text']} | {c['n_dir']} | {c['n_emit']} | "
            f"{c['st_name']} | {c['ans']} | {c['p0']} | {c['p1']} |"
        )
    lines.append("")
    (BAG / "GOLDEN.md").write_text("\n".join(lines), encoding="utf-8")


CASE_RE = re.compile(
    r"CASE\s+(\S+)\s+subj=(\d+)\s+obj=(\d+)\s+rel=(\d+)\s+ctx=(\d+)\s+"
    r"k0=(\d+)\s+k1=(\d+)\s+two=(\d+)\s+trip=(\d+)\s+st=(\d+)\s+"
    r"ans=(\d+)\s+p0=(\d+)\s+p1=(\d+)\s+skip=(\d+)\s+vq8=(-?\d+)\s+nhost=(\d+)\s+"
    r"ndir=(\d+)\s+nemit=(\d+)\s+npost=(\d+)"
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
    if "ASTRA09_SPARSE_XSIM_PASS" not in body:
        print("COMPARE_FAIL no ASTRA09_SPARSE_XSIM_PASS")
        return 4
    tb = (BAG / "tb_astra09_sparse.sv").read_text(encoding="utf-8", errors="replace")
    for bad in (".q_s(", ".q_o(", ".q_r(", "poke_v_i", "winner_i", "ans_i"):
        if bad in tb:
            print(f"COMPARE_FAIL TB poke token {bad}")
            return 5
    exp_v1 = "ede064f0c2a5c956eeba5269f539690dbd63c0773b9ded11128bd9be05496768"
    if gold["v1_qse_sha256"] != exp_v1:
        print(f"COMPARE_FAIL v1 QSE SHA retarget {gold['v1_qse_sha256']}")
        return 6
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
            "n_dir": int(m.group(17)),
            "n_emit": int(m.group(18)),
            "n_post": int(m.group(19)),
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
            "n_dir",
            "n_emit",
        )
        for k in keys:
            if int(got[k]) != int(exp[k]):
                print(f"COMPARE_FAIL {name}.{k} got={got[k]} exp={exp[k]}")
                fail += 1
        if got["vq8"] != 0:
            print(f"COMPARE_FAIL {name}.vq8={got['vq8']} freeze-zero expected 0")
            fail += 1
        if got["n_dir"] > exp["n_valid"]:
            print(f"COMPARE_FAIL {name} n_dir {got['n_dir']} > n_valid {exp['n_valid']}")
            fail += 1
        if got["ans"] >= PLANT_BASE:
            print(f"COMPARE_FAIL {name} ans is plant id {got['ans']}")
            fail += 1
    if seen.get("C1_FWD", {}).get("k0") == seen.get("C1_REV", {}).get("k0"):
        print("COMPARE_FAIL reverse packets identical")
        fail += 1
    if seen.get("C4_UNREL", {}).get("st") == ST_ANSWER:
        print("COMPARE_FAIL payroll ANSWER")
        fail += 1
    if fail:
        print(f"COMPARE_FAIL n={fail}")
        return 1
    print("ASTRA09_SPARSE_HOST_COMPARE_PASS")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--golden-only", action="store_true")
    ap.add_argument("--compare", action="store_true")
    args = ap.parse_args()
    gold = build_golden()
    (BAG / "GOLDEN.json").write_text(json.dumps(gold, indent=2) + "\n", encoding="utf-8")
    write_svh(gold)
    write_golden_md(gold)
    print("WROTE", BAG / "GOLDEN.json")
    print("WROTE", BAG / "GOLDEN.md")
    print("WROTE", BAG / "query_cases.svh")
    print("V1_QSE_SHA", gold["v1_qse_sha256"])
    if args.compare:
        return compare(gold)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
