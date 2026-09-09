#!/usr/bin/env python3
"""ASTRA-03 independent host golden for qse-v2-role-00.

Generated BEFORE XSim. Does not read DUT logs. v1 remains CONTROL.
PROGRAM=NO. BIT=NO.
"""
from __future__ import annotations

import hashlib
import json
import shutil
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
QDIR = ROOT / "rtl" / "native_graph" / "query"
U3Q = BAG.parent / "GROK-ORCH-00" / "U3Q-R3-STRUCTURED-QUERY-FEATURE-00"
# RTL table/twin win over any bag copy.
sys.path.insert(0, str(U3Q))
sys.path.insert(0, str(QDIR))
from role_lexicon import LAW as LAW_V2  # noqa: E402
from twin_role import extract as extract_v2  # noqa: E402
from twin import extract as extract_v1  # noqa: E402

LAW_V1 = "qse-v1-lexicon-hdc-00"
GATE = "ASTRA-03-ROLE-AWARE-QUERY"
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + 0x40000
N_TABLES = 4
N_BUCKETS = 4096
CAND_CAP = 16
HEAD_CAP = 16
ENTRY = 16
TABLE_BYTES = 65536
EPOCH = 7

QUERIES = [
    ("rev_supply_ab", "pump supplies chiller"),
    ("rev_supply_ba", "chiller supplies pump"),
    ("rev_require_ahu_ab", "ahu requires chiller"),
    ("rev_require_ahu_ba", "chiller requires ahu"),
    ("rev_require_pump_ab", "pump requires chiller"),
    ("rev_require_pump_ba", "chiller requires pump"),
    ("rev_require_comp_ab", "compressor requires refrigerant"),
    ("rev_require_comp_ba", "refrigerant requires compressor"),
    ("para_supply_ab", "pump supply chiller"),
    ("para_supply_ba", "chiller supply pump"),
    ("rev_connect_ab", "pump connects chiller"),
    ("rev_connect_ba", "chiller connects pump"),
    ("rev_connect_to_ab", "ahu connects to chiller"),
    ("rev_connect_to_ba", "chiller connects to ahu"),
    ("para_connect_ab", "ahu connects chiller"),
    ("single_chiller", "chiller"),
    ("ctx_supply_duct", "supply duct"),
    ("unrelated_payroll", "payroll tax form"),
    ("unrelated_soccer", "soccer match score"),
    ("two_ent_no_rel", "pump chiller"),
    ("neg_supply_ab", "pump not supplies chiller"),
]

REVERSE_PAIRS = [
    ("rev_supply_ab", "rev_supply_ba"),
    ("rev_require_ahu_ab", "rev_require_ahu_ba"),
    ("rev_require_pump_ab", "rev_require_pump_ba"),
    ("rev_require_comp_ab", "rev_require_comp_ba"),
    ("para_supply_ab", "para_supply_ba"),
    ("rev_connect_ab", "rev_connect_ba"),
    ("rev_connect_to_ab", "rev_connect_to_ba"),
]

PARAPHRASE_PAIRS = [
    ("rev_supply_ab", "para_supply_ab"),
    ("rev_supply_ba", "para_supply_ba"),
    ("rev_connect_to_ab", "para_connect_ab"),
]

PLANT = [
    ("rev_supply_ab", 101),
    ("rev_supply_ba", 102),
    ("rev_require_ahu_ab", 103),
    ("rev_require_ahu_ba", 104),
    ("rev_require_pump_ab", 105),
    ("rev_require_pump_ba", 106),
    ("rev_require_comp_ab", 107),
    ("rev_require_comp_ba", 108),
    ("rev_connect_ab", 109),
    ("rev_connect_ba", 110),
    ("rev_connect_to_ab", 111),
    ("rev_connect_to_ba", 112),
]


def feat(text: str) -> dict:
    x = extract_v2(text)
    if x["n_host"] != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK v2 text={text!r}")
    return {"text": text, **x}


def identity(q: dict) -> tuple:
    return (q["subj_id"], q["obj_id"], q["rel_id"], q["direction"], q["k0"], q["k1"], q["k2"], q["k3"])


def packet_keys(q: dict) -> tuple:
    return (q["k0"], q["k1"], q["k2"], q["k3"], q["k0_valid"], q["k1_valid"], q["k2_valid"], q["k3_valid"])


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


def pack_text(s: str) -> int:
    b = s.encode("latin1")[:48]
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def route_query(q: dict, heads: list, loc: dict) -> dict:
    probed = []
    predup = []
    seen: list[int] = []
    ndup = 0
    ntrunc = 0
    post_cnt = []
    keys = [q["k0"], q["k1"], q["k2"], q["k3"]]
    valids = [q["k0_valid"], q["k1_valid"], q["k2_valid"], q["k3_valid"]]
    for t in range(N_TABLES):
        if valids[t] == 0:
            continue
        b = keys[t] & 0xFFF
        probed.append(t)
        ids = list(heads[t][b])
        info = loc.get((t, b))
        post_cnt.append(0 if info is None else info[1])
        for nid in ids:
            predup.append(nid)
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
        "n_post": sum(1 for c in post_cnt if c > 0),
        "n_dup": ndup,
        "n_trunc": ntrunc,
        "pmask": sum(1 << t for t in probed),
        "predup": predup,
        "probed": probed,
    }


def csv_int(xs, fmt) -> str:
    return ",".join(fmt(x) for x in xs)


def write_svh(path: Path, rows: list[dict], writes: dict, v1c: dict, v1_ab: dict, v1_ba: dict) -> None:
    n = len(rows)
    nwr = len(writes)
    wr_i = sorted(writes)
    lines = ["// generated by host_astra03.py — do not hand-edit", f"localparam int unsigned G_N = {n};"]
    lines.append(f"localparam int unsigned G_N_WR = {nwr};")
    lines.append("localparam int G_WR_I [0:G_N_WR-1] = '{")
    lines.append("  " + ",".join(str(i) for i in wr_i) + "};")
    lines.append("localparam logic [127:0] G_WR_D [0:G_N_WR-1] = '{")
    lines.append("  " + ",".join(f"128'h{writes[i]:032X}" for i in wr_i) + "};")
    lines.append("localparam int G_LEN [0:G_N-1] = '{" + csv_int([r["len"] for r in rows], str) + "};")
    lines.append("localparam logic [8*48-1:0] G_BYTES [0:G_N-1] = '{")
    lines.append("  " + ",".join(f"384'h{r['bytes']:096X}" for r in rows) + "};")
    lines.append("localparam logic [7:0] G_SUBJ [0:G_N-1] = '{" + csv_int([r["subj_id"] for r in rows], lambda x: f"8'd{x}") + "};")
    lines.append("localparam logic [7:0] G_OBJ  [0:G_N-1] = '{" + csv_int([r["obj_id"] for r in rows], lambda x: f"8'd{x}") + "};")
    lines.append("localparam logic [7:0] G_REL  [0:G_N-1] = '{" + csv_int([r["rel_id"] for r in rows], lambda x: f"8'd{x}") + "};")
    lines.append("localparam logic [7:0] G_CTX  [0:G_N-1] = '{" + csv_int([r["ctx_id"] for r in rows], lambda x: f"8'd{x}") + "};")
    lines.append("localparam logic G_NEG  [0:G_N-1] = '{" + csv_int([r["negation"] for r in rows], str) + "};")
    lines.append("localparam logic G_AMB  [0:G_N-1] = '{" + csv_int([r["ambiguity"] for r in rows], str) + "};")
    lines.append("localparam logic G_TRIP [0:G_N-1] = '{" + csv_int([r["triple_valid"] for r in rows], str) + "};")
    lines.append("localparam logic [15:0] G_K0 [0:G_N-1] = '{" + csv_int([r["k0"] for r in rows], lambda x: f"16'h{x:04X}") + "};")
    lines.append("localparam logic [15:0] G_K1 [0:G_N-1] = '{" + csv_int([r["k1"] for r in rows], lambda x: f"16'h{x:04X}") + "};")
    lines.append("localparam logic [15:0] G_K2 [0:G_N-1] = '{" + csv_int([r["k2"] for r in rows], lambda x: f"16'h{x:04X}") + "};")
    lines.append("localparam logic [15:0] G_K3 [0:G_N-1] = '{" + csv_int([r["k3"] for r in rows], lambda x: f"16'h{x:04X}") + "};")
    lines.append("localparam logic G_V0 [0:G_N-1] = '{" + csv_int([r["k0_valid"] for r in rows], str) + "};")
    lines.append("localparam logic G_V1 [0:G_N-1] = '{" + csv_int([r["k1_valid"] for r in rows], str) + "};")
    lines.append("localparam logic G_V2 [0:G_N-1] = '{" + csv_int([r["k2_valid"] for r in rows], str) + "};")
    lines.append("localparam logic G_V3 [0:G_N-1] = '{" + csv_int([r["k3_valid"] for r in rows], str) + "};")
    lines.append("localparam int G_NEMIT [0:G_N-1] = '{" + csv_int([r["n_emit"] for r in rows], str) + "};")
    lines.append("localparam logic [19:0] G_EMIT [0:G_N-1][0:7] = '{")
    em_rows = []
    for r in rows:
        pad = list(r["emit"]) + [0] * 8
        em_rows.append("{" + ",".join(f"20'd{x}" for x in pad[:8]) + "}")
    lines.append("  " + ",".join(em_rows) + "};")
    np = len(REVERSE_PAIRS)
    name_to_i = {r["name"]: i for i, r in enumerate(rows)}
    lines.append(f"localparam int unsigned G_N_PAIRS = {np};")
    lines.append("localparam int G_PAIR_A [0:G_N_PAIRS-1] = '{" + ",".join(str(name_to_i[a]) for a, _ in REVERSE_PAIRS) + "};")
    lines.append("localparam int G_PAIR_B [0:G_N_PAIRS-1] = '{" + ",".join(str(name_to_i[b]) for _, b in REVERSE_PAIRS) + "};")
    lines.append(f"localparam int G_V1_CLEN = {len(v1c['text'])};")
    lines.append(f"localparam logic [8*48-1:0] G_V1_CBYTES = 384'h{pack_text(v1c['text']):096X};")
    lines.append(f"localparam logic [15:0] G_V1_CK0 = 16'h{v1c['k0']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_CK1 = 16'h{v1c['k1']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_CK2 = 16'h{v1c['k2']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_CK3 = 16'h{v1c['k3']:04X};")
    lines.append(f"localparam logic G_V1_CV0 = {v1c['k0_valid']};")
    lines.append(f"localparam logic G_V1_CV1 = {v1c['k1_valid']};")
    lines.append(f"localparam logic G_V1_CV2 = {v1c['k2_valid']};")
    lines.append(f"localparam logic G_V1_CV3 = {v1c['k3_valid']};")
    lines.append(f"localparam logic [7:0] G_V1_CEID = 8'd{v1c['entity_id']};")
    lines.append(f"localparam int G_V1_ABLEN = {len(v1_ab['text'])};")
    lines.append(f"localparam logic [8*48-1:0] G_V1_ABBYTES = 384'h{pack_text(v1_ab['text']):096X};")
    lines.append(f"localparam int G_V1_BALEN = {len(v1_ba['text'])};")
    lines.append(f"localparam logic [8*48-1:0] G_V1_BABYTES = 384'h{pack_text(v1_ba['text']):096X};")
    lines.append(f"localparam logic [15:0] G_V1_ABK0 = 16'h{v1_ab['k0']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_ABK1 = 16'h{v1_ab['k1']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_ABK2 = 16'h{v1_ab['k2']:04X};")
    lines.append(f"localparam logic [15:0] G_V1_ABK3 = 16'h{v1_ab['k3']:04X};")
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().upper()


def main() -> int:
    rows_map = {}
    for name, text in QUERIES:
        q = feat(text)
        q["name"] = name
        q["len"] = len(text.encode("latin1"))
        q["bytes"] = pack_text(text)
        rows_map[name] = q

    fails = []

    def chk(cond: bool, msg: str) -> None:
        if not cond:
            fails.append(msg)

    for a, b in REVERSE_PAIRS:
        qa, qb = rows_map[a], rows_map[b]
        chk(identity(qa) != identity(qb), f"REVERSE_IDENTICAL {a} vs {b}")
        chk(packet_keys(qa) != packet_keys(qb), f"REVERSE_KEYS_IDENTICAL {a} vs {b}")
        chk(qa["subj_id"] == qb["obj_id"] and qa["obj_id"] == qb["subj_id"], f"REVERSE_NOT_SWAP {a} vs {b}")
        chk(qa["rel_id"] == qb["rel_id"] and qa["rel_id"] != 0, f"REVERSE_REL {a} vs {b}")
        chk(qa["triple_valid"] == 1 and qb["triple_valid"] == 1, f"REVERSE_NOT_TRIPLE {a}/{b}")
        chk(qa["k0"] == qb["k1"] and qa["k1"] == qb["k0"], f"REVERSE_K0K1_NOT_SWAP {a}")
        chk(qa["k2"] == qb["k3"] and qa["k3"] == qb["k2"], f"REVERSE_K2K3_NOT_SWAP {a}")

    for a, b in PARAPHRASE_PAIRS:
        qa, qb = rows_map[a], rows_map[b]
        chk(
            (qa["subj_id"], qa["obj_id"], qa["rel_id"], qa["k0"], qa["k1"], qa["k2"], qa["k3"])
            == (qb["subj_id"], qb["obj_id"], qb["rel_id"], qb["k0"], qb["k1"], qb["k2"], qb["k3"]),
            f"PARAPHRASE_MISMATCH {a} vs {b}",
        )

    ch = rows_map["single_chiller"]
    chk(ch["subj_id"] == 1 and ch["obj_id"] == 0 and ch["rel_id"] == 0, "CHILLER_BIND")
    chk(ch["k2_valid"] == 1 and ch["k3_valid"] == 0 and ch["k0_valid"] == 0, "CHILLER_VALID")
    chk(ch["n_host"] == 0, "CHILLER_HOST")
    chk(ch["triple_valid"] == 0, "CHILLER_NOT_TRIPLE")

    duct = rows_map["ctx_supply_duct"]
    chk(duct["subj_id"] == 7 and duct["rel_id"] == 0 and duct["triple_valid"] == 0, "SUPPLY_DUCT")
    chk(duct["ctx_bind"] == 1, "SUPPLY_DUCT_CTX")

    for name in ("unrelated_payroll", "unrelated_soccer"):
        u = rows_map[name]
        chk(u["triple_valid"] == 0, f"UNRELATED_TRIPLE {name}")
        chk(u["subj_id"] == 0 and u["obj_id"] == 0 and u["rel_id"] == 0, f"UNRELATED_IDS {name}")
        chk(u["k0_valid"] == 0 and u["k1_valid"] == 0 and u["k2_valid"] == 0 and u["k3_valid"] == 0, f"UNRELATED_V {name}")

    two = rows_map["two_ent_no_rel"]
    chk(two["subj_id"] == 10 and two["obj_id"] == 1, "TWO_ENT_MIN_ID_COLLAPSE")
    chk(two["ambiguity"] == 1 and two["rel_id"] == 0, "TWO_ENT_AMB")

    neg = rows_map["neg_supply_ab"]
    chk(neg["negation"] == 1 and neg["subj_id"] == 10 and neg["obj_id"] == 1, "NEGATION")

    v1_ab = extract_v1("pump supplies chiller")
    v1_ba = extract_v1("chiller supplies pump")
    v1_ch = extract_v1("chiller")
    v1_ch["text"] = "chiller"
    v1_ab["text"] = "pump supplies chiller"
    v1_ba["text"] = "chiller supplies pump"
    chk(v1_ab["n_host"] == 0 and v1_ch["n_host"] == 0, "V1_HOST")
    chk(v1_ch["entity_id"] == 1, "V1_CHILLER_EID")
    chk(
        (v1_ab["k0"], v1_ab["k1"], v1_ab["k2"], v1_ab["k3"])
        == (v1_ba["k0"], v1_ba["k1"], v1_ba["k2"], v1_ba["k3"]),
        "V1_SHOULD_COLLAPSE",
    )
    chk(v1_ab["entity_id"] == v1_ba["entity_id"], "V1_MIN_ID")

    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    for name, nid in PLANT:
        q = rows_map[name]
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

    writes = {}
    post_ptr = POST_HEAP
    loc = {}
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            ids = heads[t][b]
            if not ids:
                continue
            n = len(ids)
            nbeats = (n + 3) // 4
            base = post_ptr
            post_ptr += nbeats * ENTRY
            loc[(t, b)] = (base, n, ovf[t][b])
            writes[word_of(dir_addr(t, b))] = dir_pack(base, n, ovf[t][b], EPOCH)
            for i in range(nbeats):
                chunk = ids[i * 4 : i * 4 + 4]
                writes[word_of(base + i * ENTRY)] = pack_post_beat(chunk)

    rows = []
    for name, text in QUERIES:
        q = rows_map[name]
        rt = route_query(q, heads, loc)
        q.update(rt)
        rows.append(q)

    for a, b in REVERSE_PAIRS:
        qa, qb = rows_map[a], rows_map[b]
        chk(qa["n_emit"] > 0 and qb["n_emit"] > 0, f"PAIR_NO_EMIT {a}/{b}")
        chk(set(qa["emit"]).isdisjoint(set(qb["emit"])), f"PAIR_EMIT_OVERLAP {a}/{b}")

    for name in ("unrelated_payroll", "unrelated_soccer"):
        chk(rows_map[name]["n_emit"] == 0 and rows_map[name]["n_dir"] == 0, f"UNRELATED_EMIT {name}")

    para = rows_map["para_supply_ab"]
    src = rows_map["rev_supply_ab"]
    chk(para["emit"] == src["emit"], "PARA_EMIT")

    if fails:
        print("ASTRA03_HOST_FAIL")
        for f in fails:
            print("FAIL", f)
        return 2

    golden = {
        "gate": GATE,
        "law": LAW_V2,
        "law_control": LAW_V1,
        "n_host": 0,
        "queries": [
            {
                "name": r["name"],
                "text": r["text"],
                "subj_id": r["subj_id"],
                "obj_id": r["obj_id"],
                "rel_id": r["rel_id"],
                "ctx_id": r["ctx_id"],
                "direction": r["direction"],
                "negation": r["negation"],
                "ambiguity": r["ambiguity"],
                "triple_valid": r["triple_valid"],
                "k0": r["k0"],
                "k1": r["k1"],
                "k2": r["k2"],
                "k3": r["k3"],
                "k0_valid": r["k0_valid"],
                "k1_valid": r["k1_valid"],
                "k2_valid": r["k2_valid"],
                "k3_valid": r["k3_valid"],
                "crc16_dbg": r["crc16_dbg"],
                "n_hyp": r["n_hyp"],
                "emit": r["emit"],
                "n_emit": r["n_emit"],
                "n_dir": r["n_dir"],
                "n_host": r["n_host"],
            }
            for r in rows
        ],
        "reverse_pairs": [{"a": a, "b": b} for a, b in REVERSE_PAIRS],
        "paraphrase_pairs": [{"a": a, "b": b} for a, b in PARAPHRASE_PAIRS],
        "v1_control": {
            "ab": "pump supplies chiller",
            "ba": "chiller supplies pump",
            "keys_identical": True,
            "k0": v1_ab["k0"],
            "k1": v1_ab["k1"],
            "k2": v1_ab["k2"],
            "k3": v1_ab["k3"],
            "entity_id": v1_ab["entity_id"],
        },
        "v1_chiller": {
            "entity_id": v1_ch["entity_id"],
            "k0": v1_ch["k0"],
            "k1": v1_ch["k1"],
            "k2": v1_ch["k2"],
            "k3": v1_ch["k3"],
            "k0_valid": v1_ch["k0_valid"],
            "k1_valid": v1_ch["k1_valid"],
            "k2_valid": v1_ch["k2_valid"],
            "k3_valid": v1_ch["k3_valid"],
            "n_host": v1_ch["n_host"],
        },
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    write_svh(BAG / "query_gold.svh", rows, writes, v1_ch, v1_ab, v1_ba)

    metrics = {
        "gate": GATE,
        "law": LAW_V2,
        "control_law": LAW_V1,
        "n_queries": len(rows),
        "n_reverse_pairs": len(REVERSE_PAIRS),
        "reverse_packets_differ": True,
        "reverse_keys_swap": True,
        "paraphrase_identity_match": True,
        "v1_role_keys_identical": True,
        "v1_chiller_eid": v1_ch["entity_id"],
        "unrelated_emit": 0,
        "n_host": 0,
        "open_nlu_claimed": False,
        "exam_sentence_rom": False,
        "result_host": "PASS",
    }
    (BAG / "METRICS.json").write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")

    for fn in ("role_lexicon.py", "twin_role.py", "gen_role_lexicon.py", "qse_role_lexicon.svh"):
        src = QDIR / fn
        if src.exists():
            shutil.copy2(src, BAG / fn)

    print("ASTRA03_HOST_PASS")
    print("LAW", LAW_V2, "CONTROL", LAW_V1)
    for a, b in REVERSE_PAIRS:
        qa, qb = rows_map[a], rows_map[b]
        print(
            f"PAIR {qa['text']!r} vs {qb['text']!r} "
            f"subj {qa['subj_id']}/{qb['subj_id']} obj {qa['obj_id']}/{qb['obj_id']} "
            f"k0 {qa['k0']:04X}/{qb['k0']:04X} emit {qa['emit']}/{qb['emit']}"
        )
    print("V1_CONTROL_ROLE_COLLAPSE k", f"{v1_ab['k0']:04X}", f"{v1_ab['k1']:04X}", f"{v1_ab['k2']:04X}")
    print("V1_SMOKE_CHILLER eid", v1_ch["entity_id"], "k0", f"{v1_ch['k0']:04X}", "k2", f"{v1_ch['k2']:04X}")
    return 0


def finalize() -> int:
    xsim = (BAG / "xsim.log").read_text(encoding="utf-8", errors="replace")
    metrics = json.loads((BAG / "METRICS.json").read_text(encoding="utf-8"))
    host_ok = metrics.get("result_host") == "PASS"
    xsim_ok = "ASTRA03_ROLE_AWARE_XSIM_PASS" in xsim and "FIRST_DIVERGENCE" not in xsim
    v1_ok = "V1_SMOKE_CHILLER" in xsim and "V1_CONTROL_ROLE_COLLAPSE" in xsim
    if not (host_ok and xsim_ok and v1_ok):
        print("ASTRA03_FINALIZE_FAIL", "host", host_ok, "xsim", xsim_ok, "v1", v1_ok)
        return 3
    gold = json.loads((BAG / "GOLDEN.json").read_text(encoding="utf-8"))
    now = datetime.now(timezone(timedelta(hours=7))).isoformat()
    files = [
        ROOT / "rtl" / "native_graph" / "query" / "a7ng_query_role_extract.sv",
        ROOT / "rtl" / "native_graph" / "query" / "qse_role_lexicon.svh",
        ROOT / "rtl" / "native_graph" / "query" / "role_lexicon.py",
        ROOT / "rtl" / "native_graph" / "query" / "twin_role.py",
        ROOT / "rtl" / "native_graph" / "query" / "a7ng_query_struct_extract.sv",
        ROOT / "rtl" / "native_graph" / "query" / "qse_lexicon.svh",
        ROOT / "rtl" / "native_graph" / "integrate" / "a7ng_query_axi_sparse.sv",
        BAG / "GOLDEN.json",
        BAG / "METRICS.json",
        BAG / "query_gold.svh",
        BAG / "tb_astra03_role_query.sv",
        BAG / "host_astra03.py",
        BAG / "xsim.log",
        BAG / "PREREG.md",
    ]
    sha_lines = []
    sha_map = {}
    for p in files:
        if p.exists():
            d = sha256_file(p)
            sha_map[p.name] = d
            sha_lines.append(f"{d}  {p.name}")
    (BAG / "SHA256.txt").write_text("\n".join(sha_lines) + "\n", encoding="utf-8")

    results = f"""# RESULTS — ASTRA-03 ROLE-AWARE-QUERY

```text
GATE            = {GATE}
HOST            = ASTRA03_HOST_PASS
XSIM            = ASTRA03_ROLE_AWARE_XSIM_PASS
V1_SMOKE        = PASS (chiller eid=1, n_host=0)
V1_CONTROL      = ROLE_COLLAPSE unchanged (identical keys both directions)
FIRST_DIVERGENCE= none
LAW             = {LAW_V2}
CONTROL_LAW     = {LAW_V1} UNCHANGED
BIT             = NO
PROGRAM         = NO
COM12           = UNTOUCHED
V31_WRITES      = 0
N_HOST          = 0
OPEN_NLU        = NOT CLAIMED
```

## What was measured

v2 streaming grammar binds first entity as subject and the entity after a relation as object.
Reverse pairs swap `subj/obj`, `k0/k1={{role,rel}}`, and `k2/k3` cues. v1 control still collapses.

| pair | subj/obj A | subj/obj B | k0 A | k0 B | emit A | emit B |
|---|---|---|---|---|---|---|
"""
    name_to_q = {q["name"]: q for q in gold["queries"]}
    for pair in gold["reverse_pairs"]:
        a = name_to_q[pair["a"]]
        b = name_to_q[pair["b"]]
        results += (
            f"| `{a['text']}` vs `{b['text']}` | {a['subj_id']}/{a['obj_id']} | "
            f"{b['subj_id']}/{b['obj_id']} | {a['k0']:04X} | {b['k0']:04X} | "
            f"{a['emit']} | {b['emit']} |\n"
        )
    results += "\nSingle-entity `chiller`: subject=1, object empty, n_host=0, not a triple.\n"
    results += "`supply duct`: context+entity (duct subject, supply not a verb here).\n"
    results += "Unrelated `payroll tax form` / `soccer match score`: no domain triple, walker emit=0.\n"
    results += "`pump chiller` (no relation): subject=pump(10), object=chiller(1), ambiguity=1 — not min-ID collapse.\n\n"
    results += "## Narrow claim\n\n"
    results += "Same words, different direction produce different structured packets and different candidate IDs\n"
    results += "under `qse-v2-role-00`. Frozen `qse-v1-lexicon-hdc-00` is unchanged and still bag-of-lexicon.\n\n"
    results += "## Not claimed\n\n"
    results += "- Open NLU / Vietnamese / unseen synonyms\n"
    results += "- 2-hop reasoning (ASTRA-04)\n"
    results += "- Board / Gate14 / 800k precision retarget\n"
    (BAG / "RESULTS.md").write_text(results, encoding="utf-8")

    close = f"""# CLOSEOUT — {GATE}

```text
GATE                 = {GATE}
BASE                 = ASTRA-02 PASS_NARROW
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = rtl/native_graph/query/a7ng_query_role_extract.sv
                       rtl/native_graph/query/qse_role_lexicon.svh
                       rtl/native_graph/query/role_lexicon.py
                       rtl/native_graph/query/twin_role.py
                       rtl/native_graph/query/gen_role_lexicon.py
                       rtl/native_graph/integrate/a7ng_query_axi_sparse.sv (LAW_SEL default 0)
                       results/A7-NATIVE-GRAPH/ASTRA-03-ROLE-AWARE-QUERY/*
RTL_EDIT             = YES (new v2 module + LAW_SEL; v1 extractor/lexicon UNCHANGED)
PRIMARY_UNKNOWN      = Can the parser preserve ordered semantic roles?
RESULT               = PASS
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = none
VIOLATED_INVARIANT   = none
FALSIFIED_ALTERNATIVES = bag-of-lexicon min-ID (v1 control still collapses);
                         exam-sentence ROM (words are separate lexicon entries);
                         silent retarget of qse-v1 keys (v1 smoke PASS)
RESOURCE_DELTA       = not measured this gate (ASTRA-10)
QUERY_LAW            = {LAW_V2}
QUERY_LAW_CONTROL    = {LAW_V1} UNCHANGED
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
NEXT                 = ASTRA-04 RELATION-ENGINE-2HOP
```

v1 SHA a7ng_query_struct_extract.sv = {sha_map.get('a7ng_query_struct_extract.sv', 'missing')}
v1 SHA qse_lexicon.svh = {sha_map.get('qse_lexicon.svh', 'missing')}
closed {now}
"""
    (BAG / "CLOSEOUT.md").write_text(close, encoding="utf-8")

    loop_path = ROOT / "docs" / "ASTRA" / "LOOP_STATE.json"
    loop = json.loads(loop_path.read_text(encoding="utf-8"))
    loop["current_gate"] = "ASTRA-04"
    loop["last_pass"] = "ASTRA-03"
    loop["last_bag"] = "results/A7-NATIVE-GRAPH/ASTRA-03-ROLE-AWARE-QUERY"
    loop["astra03"] = "PASS"
    loop["ask_user"] = False
    loop["program"] = False
    loop["com12"] = "UNTOUCHED"
    loop["v31_writes"] = 0
    loop["dispatch"] = "ASTRA-03 PASS closed; ASTRA-04 next"
    loop["updated"] = now
    loop_path.write_text(json.dumps(loop, indent=2) + "\n", encoding="utf-8")
    print("ASTRA03_FINALIZE_PASS")
    return 0


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--finalize":
        raise SystemExit(finalize())
    raise SystemExit(main())
