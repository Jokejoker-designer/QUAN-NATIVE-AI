#!/usr/bin/env python3
"""ASTRA-01 independent host golden.

Law: qse-v1-lexicon-hdc-00 / P4_4k_h64 / U4A-R6 validity.
Generated BEFORE XSim. Does not read DUT logs. Does not use U4-MEM02 GOLDEN.json
as authority. Cross-checks corpus keys/valid/IDs against frozen U4A-R6 METRICS.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
NG = BAG.parent
BAG_U3Q = NG / "GROK-ORCH-00" / "U3Q-R3-STRUCTURED-QUERY-FEATURE-00"
BAG_R6 = NG / "GROK-ORCH-00" / "U4A-R6-ROUTE-VALIDITY-00"
sys.path.insert(0, str(BAG_U3Q))
from lexicon import ENTITY_CANON, ADV_SEED  # noqa: E402
from twin import extract  # noqa: E402

LAW = "qse-v1-lexicon-hdc-00"
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + 0x40000
N_TABLES = 4
N_BUCKETS = 4096
CAND_CAP = 64
HEAD_CAP = 64
ENTRY = 16
TABLE_BYTES = 65536
EPOCH = 7
GATE = "ASTRA-01-U4-REAL-AXI-SPARSE-00"


def feat(text: str) -> dict:
    x = extract(text)
    return {
        "k": [x["k0"], x["k1"], x["k2"], x["k3"]],
        "v": [x["k0_valid"], x["k1_valid"], x["k2_valid"], x["k3_valid"]],
        "crc": x["crc16_dbg"],
        "eid": x["entity_id"],
        "iid": x["intent_id"],
        "rid": x["relation_id"],
        "xid": x["context_id"],
        "n_host": x["n_host"],
        "text": text,
    }


def adv0() -> str:
    s = ADV_SEED
    ws = []
    for _w in range(2):
        chars = []
        for _k in range(5):
            s = (s * 1103515245 + 12345) & 0x7FFFFFFF
            chars.append(chr(ord("a") + (s % 26)))
        ws.append("".join(chars))
    return " ".join(ws)


def dir_addr(table: int, key: int) -> int:
    return INDEX_BASE + table * TABLE_BYTES + (key & 0xFFF) * ENTRY


def dir_pack(base: int, count: int, ovf: int, ep: int) -> int:
    return ((ep & 0xFFFF) << 64) | ((ovf & 1) << 48) | ((count & 0xFFFF) << 32) | (base & 0x0FFFFFFF)


def word_of(addr: int) -> int:
    return 6144 + ((addr - INDEX_BASE) >> 4)


def pack_post_beat(ids: list[int]) -> int:
    v = 0
    for lane, nid in enumerate(ids[:4]):
        v |= (nid & 0xFFFFFFFF) << (32 * lane)
    return v


def build_docs():
    docs = []
    for lab, forms in ENTITY_CANON.items():
        for t in forms:
            info = feat(t)
            docs.append({"nid": len(docs), "label": lab, **info})
    return docs


def index_docs(docs):
    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    for d in docs:
        for t in range(N_TABLES):
            if d["v"][t] == 0:
                continue
            b = d["k"][t] & 0xFFF
            if len(heads[t][b]) < HEAD_CAP:
                heads[t][b].append(d["nid"])
            else:
                ovf[t][b] = 1
    return heads, ovf


def plant_directed(heads, ovf):
    """Directed protocol records. Not corpus semantics."""
    if 200 not in heads[2][0]:
        heads[2][0].append(200)
    b = 0x0FE0 & 0xFFF
    heads[0][b] = list(range(1000, 1080))
    ovf[0][b] = 1
    return heads, ovf


def alloc_image(heads, ovf):
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
    return writes, loc, post_ptr


def route_query(q, heads, loc):
    probed = []
    skipped = []
    dir_as = []
    post_as = []
    post_cnt = []
    predup = []
    seen = []
    ndup = 0
    ntrunc = 0
    for t in range(N_TABLES):
        if q["v"][t] == 0:
            skipped.append(t)
            continue
        k = q["k"][t]
        b = k & 0xFFF
        da = dir_addr(t, k)
        probed.append(t)
        dir_as.append(da)
        ids = list(heads[t][b])
        info = loc.get((t, b))
        if info is None:
            post_as.append(0)
            post_cnt.append(0)
        else:
            post_as.append(info[0])
            post_cnt.append(info[1])
            if info[1] != len(ids):
                raise SystemExit(f"POST_COUNT loc mismatch t={t} b={b}")
        for nid in ids:
            predup.append(nid)
            if nid in seen:
                ndup += 1
            elif len(seen) >= CAND_CAP:
                ntrunc += 1
            else:
                seen.append(nid)
    return {
        "k": q["k"],
        "v": q["v"],
        "crc": q.get("crc", 0),
        "eid": q.get("eid", 0),
        "iid": q.get("iid", 0),
        "rid": q.get("rid", 0),
        "xid": q.get("xid", 0),
        "n_host": q.get("n_host", 0),
        "probed": probed,
        "skipped": skipped,
        "dir_addr": dir_as,
        "post_addr": post_as,
        "post_count": post_cnt,
        "predup": predup,
        "emit": seen,
        "n_dir": len(dir_as),
        "n_post": sum(1 for c in post_cnt if c > 0),
        "n_dup": ndup,
        "n_trunc": ntrunc,
        "pmask": sum(1 << t for t in probed),
        "n_emit": len(seen),
    }


def freeze_check(name, q):
    r6 = json.loads((BAG_R6 / "METRICS.json").read_text(encoding="utf-8"))
    by = {x["query"]: x for x in r6["queries"]}
    g = by[name]
    if [q["k"][0], q["k"][1], q["k"][2], q["k"][3]] != [g["k0"], g["k1"], g["k2"], g["k3"]]:
        raise SystemExit(f"KEY_MISMATCH vs R6 {name} twin={q['k']} r6={[g['k0'], g['k1'], g['k2'], g['k3']]}")
    if [q["v"][0], q["v"][1], q["v"][2], q["v"][3]] != [g["v0"], g["v1"], g["v2"], g["v3"]]:
        raise SystemExit(f"VALIDITY_MISMATCH vs R6 {name}")
    if q["n_host"] != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK twin {name}")


def hx128(v: int) -> str:
    return f"128'h{v:032X}"


def hx28(v: int) -> str:
    return f"28'h{v:08X}"


def hx16(v: int) -> str:
    return f"16'h{v:04X}"


def pad4(xs, fill=0):
    ys = list(xs) + [fill] * 4
    return ys[:4]


def pack_text(s: str) -> int:
    b = s.encode("latin1")[:48]
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def main() -> int:
    docs = build_docs()
    heads, ovf = index_docs(docs)
    heads, ovf = plant_directed(heads, ovf)
    writes, loc, post_end = alloc_image(heads, ovf)

    corpus_q = [
        ("known_domain", "chiller", 0),
        ("paraphrase", "water chiller", 0),
        ("same_entity_diff_intent", "leak chiller", 0),
        ("unrelated_payroll", "payroll tax form", 0),
        ("unrelated_soccer", "soccer match score", 0),
        ("adversarial", adv0(), 0),
    ]
    queries = []
    for name, text, stall in corpus_q:
        q = feat(text)
        freeze_check(name, q)
        r = route_query(q, heads, loc)
        r.update({"name": name, "text": text, "mode": 0, "stall": stall})
        queries.append(r)

    poke = []
    poke.append(("dir_one_table", {"k": [0x0100, 0, 0, 0], "v": [1, 0, 0, 0]}))
    poke.append(("dir_v1_key0", {"k": [0, 0, 0, 0], "v": [0, 0, 1, 0]}))
    poke.append(("dir_empty", {"k": [0x0EE0, 0, 0, 0], "v": [1, 0, 0, 0]}))
    poke.append(("dir_cap", {"k": [0x0FE0, 0, 0, 0], "v": [1, 0, 0, 0]}))
    poke.append(("dir_unknown", {"k": [0, 0, 0, 0], "v": [0, 0, 0, 0]}))
    poke.append(("dir_v0_knz", {"k": [0, 0, 0x00A7, 0], "v": [0, 0, 0, 0]}))
    for name, q in poke:
        q = {**q, "crc": 0, "eid": 0, "iid": 0, "rid": 0, "xid": 0, "n_host": 0, "text": ""}
        r = route_query(q, heads, loc)
        r.update({"name": name, "text": "", "mode": 1, "stall": 0})
        queries.append(r)

    qch = feat("chiller")
    r = route_query(qch, heads, loc)
    r.update({"name": "chiller_stall", "text": "chiller", "mode": 0, "stall": 8})
    queries.append(r)

    r6 = json.loads((BAG_R6 / "METRICS.json").read_text(encoding="utf-8"))
    by = {x["query"]: x for x in r6["queries"]}
    for r in queries:
        if r["name"] in by:
            gold_ids = by[r["name"]]["candidate_ids"]
            if r["emit"] != gold_ids:
                raise SystemExit(
                    f"CANDIDATE_ID_MISMATCH vs R6 {r['name']} "
                    f"host={r['emit']} r6={gold_ids}"
                )

    fail = []
    if queries[0]["n_dup"] < 1:
        fail.append("CHILLER_EXPECTED_CROSS_TABLE_DUP")
    cap = next(x for x in queries if x["name"] == "dir_cap")
    if cap["n_emit"] != 64 or cap["n_trunc"] != 16:
        fail.append(f"CAP_GOLDEN emit={cap['n_emit']} trunc={cap['n_trunc']}")
    unk = next(x for x in queries if x["name"] == "dir_unknown")
    if unk["n_dir"] != 0 or unk["n_emit"] != 0:
        fail.append("UNKNOWN_GOLDEN")
    v1k0 = next(x for x in queries if x["name"] == "dir_v1_key0")
    if v1k0["dir_addr"] != [dir_addr(2, 0)] or v1k0["emit"] != [200]:
        fail.append("V1K0_GOLDEN")
    v0knz = next(x for x in queries if x["name"] == "dir_v0_knz")
    if v0knz["n_dir"] != 0:
        fail.append("V0KNZ_GOLDEN")
    payroll = next(x for x in queries if x["name"] == "unrelated_payroll")
    if payroll["n_dir"] != 0 or payroll["n_emit"] != 0:
        fail.append("PAYROLL_NOT_ZERO")

    result = "PASS" if not fail else "FAIL"
    out = {
        "gate": GATE,
        "law": LAW,
        "validity_law": "U4A-R6 bind-state; NOT (key != 0)",
        "geometry": "P4_4k_h64",
        "index_base": hex(INDEX_BASE),
        "n_tables": N_TABLES,
        "n_buckets": N_BUCKETS,
        "cand_cap": CAND_CAP,
        "corpus_size": len(docs),
        "n_writes": len(writes),
        "post_end": hex(post_end),
        "authority_not_used": "U4-MEM02 GOLDEN.json",
        "r6_crosscheck": str(BAG_R6 / "METRICS.json"),
        "queries": [
            {
                "name": r["name"],
                "mode": r["mode"],
                "text": r["text"],
                "packet": {"eid": r["eid"], "iid": r["iid"], "rid": r["rid"], "xid": r["xid"], "crc": r["crc"]},
                "k": r["k"],
                "v": r["v"],
                "probed": r["probed"],
                "skipped": r["skipped"],
                "dir_addr": [hex(a) for a in r["dir_addr"]],
                "post_addr": [hex(a) for a in r["post_addr"]],
                "post_count": r["post_count"],
                "predup": r["predup"],
                "emit": r["emit"],
                "n_dir": r["n_dir"],
                "n_post": r["n_post"],
                "n_dup": r["n_dup"],
                "n_trunc": r["n_trunc"],
                "n_emit": r["n_emit"],
                "pmask": r["pmask"],
                "stall": r["stall"],
                "n_host": r["n_host"],
            }
            for r in queries
        ],
        "result": result,
        "fail_reasons": fail,
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")

    wr_i = sorted(writes)
    lines = ["// generated by host_astra01.py — do not hand-edit"]
    lines.append(f"localparam int unsigned G_N_WR = {len(wr_i)};")
    lines.append("localparam int G_WR_I [0:G_N_WR-1] = '{")
    lines.append("  " + ", ".join(str(i) for i in wr_i) + "};")
    lines.append("localparam logic [127:0] G_WR_D [0:G_N_WR-1] = '{")
    lines.append("  " + ", ".join(hx128(writes[i]) for i in wr_i) + "};")
    nq = len(queries)
    lines.append(f"localparam int unsigned G_N_Q = {nq};")
    lines.append("localparam int G_MODE [0:G_N_Q-1] = '{" + ", ".join(str(r["mode"]) for r in queries) + "};")
    lines.append("localparam int G_STALL [0:G_N_Q-1] = '{" + ", ".join(str(r["stall"]) for r in queries) + "};")
    lines.append(
        "localparam int G_LEN [0:G_N_Q-1] = '{"
        + ", ".join(str(len(r["text"].encode("latin1")[:48])) for r in queries)
        + "};"
    )
    lines.append("localparam logic [8*48-1:0] G_BYTES [0:G_N_Q-1] = '{")
    lines.append("  " + ", ".join(f"384'h{pack_text(r['text']):096X}" for r in queries) + "};")
    for fld, key in (("K0", 0), ("K1", 1), ("K2", 2), ("K3", 3)):
        lines.append(
            f"localparam logic [15:0] G_{fld} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(hx16(r["k"][key]) for r in queries)
            + "};"
        )
    for fld, key in (("V0", 0), ("V1", 1), ("V2", 2), ("V3", 3)):
        lines.append(
            f"localparam logic G_{fld} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(str(r["v"][key]) for r in queries)
            + "};"
        )
    for fld, key in (("EID", "eid"), ("IID", "iid"), ("RID", "rid"), ("XID", "xid")):
        lines.append(
            f"localparam logic [7:0] G_{fld} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(f"8'h{r[key]:02X}" for r in queries)
            + "};"
        )
    lines.append("localparam logic [15:0] G_NDIR [0:G_N_Q-1] = '{" + ", ".join(hx16(r["n_dir"]) for r in queries) + "};")
    lines.append("localparam logic [15:0] G_NPOST [0:G_N_Q-1] = '{" + ", ".join(hx16(r["n_post"]) for r in queries) + "};")
    lines.append("localparam logic [15:0] G_NEMIT [0:G_N_Q-1] = '{" + ", ".join(hx16(r["n_emit"]) for r in queries) + "};")
    lines.append("localparam logic [15:0] G_NDUP [0:G_N_Q-1] = '{" + ", ".join(hx16(r["n_dup"]) for r in queries) + "};")
    lines.append("localparam logic [15:0] G_NTRUNC [0:G_N_Q-1] = '{" + ", ".join(hx16(r["n_trunc"]) for r in queries) + "};")
    lines.append("localparam logic [3:0] G_PMASK [0:G_N_Q-1] = '{" + ", ".join(f"4'd{r['pmask']}" for r in queries) + "};")
    lines.append("localparam logic [15:0] G_NPRED [0:G_N_Q-1] = '{" + ", ".join(hx16(len(r["predup"])) for r in queries) + "};")
    for i in range(4):
        lines.append(
            f"localparam logic [27:0] G_DIR{i} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(hx28(pad4(r["dir_addr"])[i]) for r in queries)
            + "};"
        )
        lines.append(
            f"localparam logic [27:0] G_POST{i} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(hx28(pad4(r["post_addr"])[i]) for r in queries)
            + "};"
        )
        lines.append(
            f"localparam logic [15:0] G_PCNT{i} [0:G_N_Q-1] = '"
            + "{"
            + ", ".join(hx16(pad4(r["post_count"])[i]) for r in queries)
            + "};"
        )
    max_pred = max(len(r["predup"]) for r in queries)
    max_em = max(len(r["emit"]) for r in queries)
    lines.append(f"localparam int unsigned G_MAX_PRED = {max_pred};")
    lines.append(f"localparam int unsigned G_MAX_EMIT = {max_em};")
    pred_flat = []
    em_flat = []
    for r in queries:
        pred_flat.extend((r["predup"] + [0] * max_pred)[:max_pred])
        em_flat.extend((r["emit"] + [0] * max_em)[:max_em])
    lines.append(
        "localparam logic [19:0] G_PRED [0:G_N_Q*G_MAX_PRED-1] = '{"
        + ", ".join(f"20'h{x:05X}" for x in pred_flat)
        + "};"
    )
    lines.append(
        "localparam logic [19:0] G_EMIT [0:G_N_Q*G_MAX_EMIT-1] = '{"
        + ", ".join(f"20'h{x:05X}" for x in em_flat)
        + "};"
    )
    (BAG / "query_gold.svh").write_text("\n".join(lines) + "\n", encoding="utf-8")

    print("CORPUS", len(docs), "WRITES", len(writes), "QUERIES", nq)
    for r in queries:
        print(
            r["name"], "mode", r["mode"],
            "packet", r["eid"], r["iid"], r["rid"], r["xid"],
            "k", r["k"], "v", r["v"],
            "dir", [hex(a) for a in r["dir_addr"]],
            "post", [hex(a) for a in r["post_addr"]],
            "predup", r["predup"][:16], "emit", r["emit"][:16],
            "n_dir", r["n_dir"], "n_post", r["n_post"],
            "n_dup", r["n_dup"], "n_trunc", r["n_trunc"],
        )
    print("RESULT", result, fail)
    print("ASTRA_01_HOST_GOLDEN_DONE")
    return 0 if result == "PASS" else 7


if __name__ == "__main__":
    raise SystemExit(main())
