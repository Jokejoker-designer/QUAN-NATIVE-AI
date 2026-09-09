#!/usr/bin/env python3
"""ASTRA-C1-STREAM-INTERSECT-02 independent host gold for qse-v2-stream-intersect-02.

Law: postings sorted by nid; two-pointer merge; 1-beat page buffer (4 IDs);
rare-list-first fetch; CAND_CAP applies only AFTER emit; budget exhaust →
SEARCH_INCOMPLETE (never empty-as-UNKNOWN).

Frozen extract (qse-v2-role-00) instantiated unchanged. Relbind keys reused.
Walker emits k0∩k1 when both valid. Does NOT union k0 with k1. Does NOT
probe k2/k3. Does NOT load full posting into BRAM. Does NOT patch C0 dir.
N=256. LATE_GOLD nid at posting index ≥16 on both k0 and k1 (cap-then-AND
misses; stream AND-then-cap hits). Direct {110,144,145} remain if those
records stay.

Gold is label match, computed BEFORE walker twin and BEFORE xvlog.
FORBIDDEN: relevant=set(router_union); nid-derived keys; cap>=N as proof;
inspect/generate N>256; patch frozen C0 RTL; leftover A09 as DUT;
regenerate GOLDEN/corpus/query_gold after FAIL; emit reduction=1-CAND_CAP/N;
fake context keys; freeze CAND_CAP_FINAL / DDR_QUERY_BOUND_FINAL / C1 800k.
PROGRAM=NO. BIT=NO.
G_BYTES: LSB-first (char0 at bits[7:0]) matching TB bytes[8*bi +: 8].
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
QDIR = ROOT / "rtl" / "native_graph" / "query"
sys.path.insert(0, str(QDIR))
from twin_role import extract as extract_v2  # noqa: E402
from role_lexicon import LAW as LAW_V2  # noqa: E402

GATE = "ASTRA-C1-STREAM-INTERSECT-02"
LAW = "qse-v2-stream-intersect-02"
LAW_V1 = "qse-v1-lexicon-hdc-00"
LAW_EXTRACT = LAW_V2
N = 256
N_TABLES = 4
N_BUCKETS = 4096
CAND_CAP = 16
INDEX_HEAD = 4
ENTRY = 16
TABLE_BYTES = 65536
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + 0x40000
EPOCH = 7
MEM_DEPTH = 32768
MAX_REL = 16
MAX_EMIT = 16
MERGE_POST_AR_MAX = 256
LATE_K0_N = 16
LATE_K1_N = 16
HOC_SYNTH_N = 15

ENT = {
    1: "chiller",
    2: "condenser",
    3: "evaporator",
    4: "compressor",
    5: "refrigerant",
    6: "ahu",
    7: "duct",
    8: "vav",
    9: "tower",
    10: "pump",
    11: "valve",
    12: "sensor",
}
RELW = {1: "supplies", 2: "requires", 3: "connects"}

# LATE_GOLD: compressor requires tower. k0-fill compressor requires valve;
# k1-fill condenser requires tower. Not in block_a (off=1..4).
LATE_S, LATE_R, LATE_O = 4, 2, 9
LATE_K0_O = 11
LATE_K1_S = 2


def relbind_keys(x: dict) -> dict:
    """Same packing as a7ng_query_role_keys_relbind.sv. k0/k1/valids unchanged."""
    rid = int(x["rel_id"]) & 0xFF
    y = dict(x)
    y["k2_frozen"] = int(x["k2"]) & 0xFFFF
    y["k3_frozen"] = int(x["k3"]) & 0xFFFF
    y["k2"] = ((rid << 8) | (int(x["subj_cue"]) & 0xFF)) & 0xFFFF
    y["k3"] = ((rid << 8) | (int(x["obj_cue"]) & 0xFF)) & 0xFFFF
    return y


def feat(text: str) -> dict:
    x = extract_v2(text)
    if x["n_host"] != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK text={text!r}")
    y = relbind_keys(x)
    y["text"] = text
    y["law"] = LAW
    return y


def triple_text(s: int, r: int, o: int, ctx_word: str | None = None) -> str:
    t = f"{ENT[s]} {RELW[r]} {ENT[o]}"
    if ctx_word:
        t = f"{t} {ctx_word}"
    return t


def rec_of(nid: int, text: str, evidence: int, kind: str) -> dict:
    q = feat(text)
    return {
        "nid": nid,
        "text": text,
        "evidence": evidence,
        "kind": kind,
        "subj_id": q["subj_id"],
        "obj_id": q["obj_id"],
        "rel_id": q["rel_id"],
        "ctx_id": q["ctx_id"],
        "k0": q["k0"],
        "k1": q["k1"],
        "k2": q["k2"],
        "k3": q["k3"],
        "k2_frozen": q["k2_frozen"],
        "k3_frozen": q["k3_frozen"],
        "subj_cue": q["subj_cue"],
        "obj_cue": q["obj_cue"],
        "k0_valid": q["k0_valid"],
        "k1_valid": q["k1_valid"],
        "k2_valid": q["k2_valid"],
        "k3_valid": q["k3_valid"],
        "triple_valid": q["triple_valid"],
        "n_host": q["n_host"],
    }


def build_corpus() -> list[dict]:
    docs: list[dict] = []
    used: set[tuple[int, int, int]] = set()
    late_n = LATE_K0_N + LATE_K1_N + 1

    def add(text: str, evidence: int, kind: str, sro: tuple[int, int, int] | None = None) -> dict:
        if len(docs) >= N:
            raise SystemExit("corpus overflow before N")
        nid = len(docs)
        row = rec_of(nid, text, evidence, kind)
        if sro is not None:
            used.add(sro)
        docs.append(row)
        return row

    for s in range(1, 13):
        for r in range(1, 4):
            for off in range(1, 5):
                o = ((s - 1 + off) % 12) + 1
                add(triple_text(s, r, o), 1, "block_a", (s, r, o))
    if len(docs) != 144:
        raise SystemExit(f"block_a {len(docs)}")

    add(triple_text(10, 1, 1, "water"), 1, "psc_water", (10, 1, 1))
    add(triple_text(10, 1, 1, "indirectly"), 1, "psc_indirect", (10, 1, 1))
    add(triple_text(1, 1, 10), 1, "role_reverse", (1, 1, 10))
    add(triple_text(6, 2, 1), 1, "high_occ_gold", (6, 2, 1))
    hoc_txt = triple_text(6, 2, 1)
    for _ in range(HOC_SYNTH_N):
        add(hoc_txt, 0, "high_occ_synth")
    ovf_txt = triple_text(12, 3, 8)
    for _ in range(INDEX_HEAD):
        add(ovf_txt, 0, "ovf_synth")
    add(ovf_txt, 1, "ovf_gold", (12, 3, 8))

    reserved = {
        (12, 3, 9),
        (LATE_S, LATE_R, LATE_O),
        (LATE_S, LATE_R, LATE_K0_O),
        (LATE_K1_S, LATE_R, LATE_O),
    }
    fill_lim = N - 1 - late_n
    for s in range(1, 13):
        for r in range(1, 4):
            for o in range(1, 13):
                if s == o:
                    continue
                if (s, r, o) in used or (s, r, o) in reserved:
                    continue
                if len(docs) >= fill_lim:
                    break
                add(triple_text(s, r, o), 1, "fill", (s, r, o))
            if len(docs) >= fill_lim:
                break
        if len(docs) >= fill_lim:
            break
    if len(docs) != fill_lim:
        raise SystemExit(f"fill stop {len(docs)} want {fill_lim}")

    k0_txt = triple_text(LATE_S, LATE_R, LATE_K0_O)
    for _ in range(LATE_K0_N):
        add(k0_txt, 0, "late_k0_fill")
    k1_txt = triple_text(LATE_K1_S, LATE_R, LATE_O)
    for _ in range(LATE_K1_N):
        add(k1_txt, 0, "late_k1_fill")
    add(triple_text(LATE_S, LATE_R, LATE_O), 1, "late_gold", (LATE_S, LATE_R, LATE_O))
    add(triple_text(12, 3, 9), 1, "high_id_sentinel", (12, 3, 9))
    if len(docs) != N:
        raise SystemExit(f"corpus N={len(docs)} want {N}")
    if docs[-1]["nid"] != 255:
        raise SystemExit("high-id sentinel is not nid 255")
    return docs


def gold_ids(docs: list[dict], pred) -> list[int]:
    return [d["nid"] for d in docs if d["evidence"] == 1 and pred(d)]


def pred_psc(d: dict) -> bool:
    return d["subj_id"] == 10 and d["rel_id"] == 1 and d["obj_id"] == 1


def pred_excl(d: dict) -> bool:
    """Entity-context distractors for target 'pump supplies chiller'."""
    if pred_psc(d):
        return False
    wo = d["subj_id"] == 10 and d["rel_id"] == 1 and d["obj_id"] != 1
    wr = d["subj_id"] == 10 and d["rel_id"] != 1 and d["obj_id"] == 1
    we = d["subj_id"] != 10 and d["rel_id"] == 1 and d["obj_id"] == 1
    return wo or wr or we


def pred_late(d: dict) -> bool:
    return d["subj_id"] == LATE_S and d["rel_id"] == LATE_R and d["obj_id"] == LATE_O


def index_docs(docs: list[dict]):
    buckets = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    for d in docs:
        keys = [d["k0"], d["k1"], d["k2"], d["k3"]]
        valids = [d["k0_valid"], d["k1_valid"], d["k2_valid"], d["k3_valid"]]
        for t in range(N_TABLES):
            if not valids[t]:
                continue
            b = keys[t] & 0xFFF
            buckets[t][b].append(d["nid"])
    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    overflow = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf_flag = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    post_len = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            lst = sorted(buckets[t][b])
            post_len[t][b] = len(lst)
            heads[t][b] = lst[:INDEX_HEAD]
            overflow[t][b] = lst[INDEX_HEAD:]
            ovf_flag[t][b] = 1 if overflow[t][b] else 0
    return heads, overflow, ovf_flag, post_len


def posting_of(q: dict, t: int, heads, overflow) -> list[int]:
    keys = [q["k0"], q["k1"], q["k2"], q["k3"]]
    valids = [q["k0_valid"], q["k1_valid"], q["k2_valid"], q["k3_valid"]]
    if not valids[t]:
        return []
    b = keys[t] & 0xFFF
    return list(heads[t][b]) + list(overflow[t][b])


def two_pointer(a: list[int], b: list[int], cap: int) -> tuple[list[int], int, int]:
    i = j = 0
    emit: list[int] = []
    ntrunc = 0
    incomp = 0
    while i < len(a) and j < len(b):
        if a[i] == b[j]:
            if len(emit) >= cap:
                ntrunc += 1
                incomp = 1
                break
            emit.append(a[i])
            i += 1
            j += 1
        elif a[i] < b[j]:
            i += 1
        else:
            j += 1
    return emit, ntrunc, incomp


def cap_then_and(a: list[int], b: list[int], cap: int) -> list[int]:
    bset = set(b[:cap])
    out: list[int] = []
    for nid in a[:cap]:
        if nid in bset:
            if len(out) >= cap:
                break
            out.append(nid)
    return out


def nbeats(n: int) -> int:
    if n <= 0:
        return 0
    return (n + 3) // 4


def route(q: dict, heads, overflow, ovf_flag, post_len) -> dict:
    """qse-v2-stream-intersect-02: two-pointer AND, CAND_CAP after emit."""
    v0 = bool(q["k0_valid"])
    v1 = bool(q["k1_valid"])
    if v0 and v1:
        a = posting_of(q, 0, heads, overflow)
        b = posting_of(q, 1, heads, overflow)
        emit, ntrunc, incomp = two_pointer(a, b, CAND_CAP)
        b0 = q["k0"] & 0xFFF
        b1 = q["k1"] & 0xFFF
        n_dir = 2
        n_post = nbeats(len(a)) + nbeats(len(b))
        if n_post > MERGE_POST_AR_MAX:
            incomp = 1
            ntrunc = max(ntrunc, 1)
        ovf = 1 if (ovf_flag[0][b0] or ovf_flag[1][b1]) else 0
        cap_and = cap_then_and(a, b, CAND_CAP)
        rare_first = 0 if len(a) <= len(b) else 1
        return {
            "emit": emit,
            "n_emit": len(emit),
            "n_dir": n_dir,
            "n_post": n_post,
            "n_dup": 0,
            "n_trunc": ntrunc,
            "overflow_flag": ovf,
            "occupancies": [len(a), len(b)],
            "posting_lens": [len(a), len(b)],
            "probed": [0, 1],
            "bytes": (n_dir + n_post) * ENTRY,
            "search_incomplete_walk": incomp,
            "cap_then_and": cap_and,
            "full_k0": a,
            "full_k1": b,
            "rare_first": rare_first,
        }
    if v0:
        a = posting_of(q, 0, heads, overflow)
        emit = a[:CAND_CAP]
        ntrunc = max(0, len(a) - CAND_CAP)
        incomp = 1 if ntrunc else 0
        b0 = q["k0"] & 0xFFF
        n_post = nbeats(min(len(a), CAND_CAP + (1 if ntrunc else 0)))
        return {
            "emit": emit,
            "n_emit": len(emit),
            "n_dir": 1,
            "n_post": n_post,
            "n_dup": 0,
            "n_trunc": ntrunc,
            "overflow_flag": ovf_flag[0][b0],
            "occupancies": [len(a)],
            "posting_lens": [len(a)],
            "probed": [0],
            "bytes": (1 + n_post) * ENTRY,
            "search_incomplete_walk": incomp,
            "cap_then_and": emit,
            "full_k0": a,
            "full_k1": [],
            "rare_first": 0,
        }
    if v1:
        b = posting_of(q, 1, heads, overflow)
        emit = b[:CAND_CAP]
        ntrunc = max(0, len(b) - CAND_CAP)
        incomp = 1 if ntrunc else 0
        b1 = q["k1"] & 0xFFF
        n_post = nbeats(min(len(b), CAND_CAP + (1 if ntrunc else 0)))
        return {
            "emit": emit,
            "n_emit": len(emit),
            "n_dir": 1,
            "n_post": n_post,
            "n_dup": 0,
            "n_trunc": ntrunc,
            "overflow_flag": ovf_flag[1][b1],
            "occupancies": [len(b)],
            "posting_lens": [len(b)],
            "probed": [1],
            "bytes": (1 + n_post) * ENTRY,
            "search_incomplete_walk": incomp,
            "cap_then_and": emit,
            "full_k0": [],
            "full_k1": b,
            "rare_first": 1,
        }
    return {
        "emit": [],
        "n_emit": 0,
        "n_dir": 0,
        "n_post": 0,
        "n_dup": 0,
        "n_trunc": 0,
        "overflow_flag": 0,
        "occupancies": [],
        "posting_lens": [],
        "probed": [],
        "bytes": 0,
        "search_incomplete_walk": 0,
        "cap_then_and": [],
        "full_k0": [],
        "full_k1": [],
        "rare_first": 0,
    }


def dir_addr(table: int, key: int) -> int:
    return INDEX_BASE + table * TABLE_BYTES + (key & 0xFFF) * ENTRY


def word_of(addr: int) -> int:
    return 6144 + ((addr - INDEX_BASE) >> 4)


def dir_pack(base, count, ovf, ep, ovf_base=0, ovf_count=0) -> int:
    return (
        ((ovf_count & 0xFFFF) << 108)
        | ((ovf_base & 0x0FFFFFFF) << 80)
        | ((ep & 0xFFFF) << 64)
        | ((ovf & 1) << 48)
        | ((count & 0xFFFF) << 32)
        | (base & 0x0FFFFFFF)
    )


def pack_post_beat(ids: list[int]) -> int:
    v = 0
    for lane, nid in enumerate(ids[:4]):
        v |= (nid & 0xFFFFFFFF) << (32 * lane)
    return v


def pack_text(s: str) -> int:
    """LSB-first: character 0 at bits[7:0]. TB reads bytes[8*bi +: 8]."""
    b = s.encode("latin1")[:48]
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def write_index(heads, overflow, ovf_flag) -> dict[int, int]:
    writes: dict[int, int] = {}
    post_ptr = POST_HEAP
    max_word = 0
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            h = heads[t][b]
            o = overflow[t][b]
            if not h and not o:
                continue
            nbeats_h = (len(h) + 3) // 4
            base = post_ptr
            post_ptr += max(nbeats_h, 1) * ENTRY if h else 0
            if h:
                for i in range(nbeats_h):
                    chunk = h[i * 4 : i * 4 + 4]
                    w = word_of(base + i * ENTRY)
                    writes[w] = pack_post_beat(chunk)
                    max_word = max(max_word, w)
            ovf_base = 0
            if o:
                obeats = (len(o) + 3) // 4
                ovf_base = post_ptr
                post_ptr += obeats * ENTRY
                for i in range(obeats):
                    chunk = o[i * 4 : i * 4 + 4]
                    w = word_of(ovf_base + i * ENTRY)
                    writes[w] = pack_post_beat(chunk)
                    max_word = max(max_word, w)
            dw = word_of(dir_addr(t, b))
            writes[dw] = dir_pack(
                base if h else 0,
                len(h),
                1 if o else 0,
                EPOCH,
                ovf_base,
                len(o),
            )
            max_word = max(max_word, dw)
    if max_word >= MEM_DEPTH:
        raise SystemExit(f"mem word {max_word} >= MEM_DEPTH {MEM_DEPTH}")
    return writes


def metrics_of(emit: list[int], relevant: list[int], by_nid: dict[int, dict]) -> dict:
    rset = set(relevant)
    tp = sum(1 for i in emit if i in rset)
    fp_ev1 = 0
    fp_fill0 = 0
    for i in emit:
        if i in rset:
            continue
        ev = by_nid[i]["evidence"] if i in by_nid else 1
        if ev == 0:
            fp_fill0 += 1
        else:
            fp_ev1 += 1
    den_ev1 = tp + fp_ev1
    prec_ev1 = (tp / den_ev1) if den_ev1 else None
    prec_all = (tp / len(emit)) if emit else None
    rec = (tp / len(relevant)) if relevant else None
    missed = [i for i in relevant if i not in set(emit)]
    return {
        "tp": tp,
        "fp_ev1": fp_ev1,
        "fp_fill0": fp_fill0,
        "prec_ev1": prec_ev1,
        "prec_all": prec_all,
        "recall": rec,
        "missed": missed,
    }


def metrics_excl(emit: list[int], excluded: list[int], by_nid: dict[int, dict]) -> dict:
    xset = set(excluded)
    leak_ids = [i for i in emit if i in xset]
    fp_ev1 = 0
    fp_fill0 = 0
    for i in emit:
        ev = by_nid[i]["evidence"] if i in by_nid else 1
        if ev == 0:
            fp_fill0 += 1
        else:
            fp_ev1 += 1
    den_ev1 = fp_ev1
    prec_ev1 = (0 / den_ev1) if den_ev1 else None
    prec_all = (0 / len(emit)) if emit else None
    return {
        "tp": 0,
        "fp_ev1": fp_ev1,
        "fp_fill0": fp_fill0,
        "prec_ev1": prec_ev1,
        "prec_all": prec_all,
        "recall": None,
        "leak_n": len(leak_ids),
        "leak_ids": leak_ids,
        "missed": [],
    }


def csv_int(xs, fmt) -> str:
    return ",".join(fmt(x) for x in xs)


def write_svh(path: Path, queries: list[dict], writes: dict[int, int], docs: list[dict]) -> None:
    n = len(queries)
    nwr = len(writes)
    wr_i = sorted(writes)
    ev = [d["evidence"] for d in docs]
    late_i = next(i for i, q in enumerate(queries) if q["name"] == "late_gold")
    late_id = queries[late_i]["relevant"][0]
    lines = [
        "// generated by host_astra_c1_stream_intersect.py — independent gold BEFORE xvlog. do not hand-edit after FAIL",
        "// Law qse-v2-stream-intersect-02: sorted-nid two-pointer; 1-beat page; rare-first; CAND_CAP after emit",
        "// G_BYTES LSB-first: char0 at [7:0]; TB must use bytes[8*bi +: 8]",
        "// G_GOLD_EXCLUDED=1 => G_RELEVANT is the EXCLUDED set (leak=FAIL), not retrieve gold",
        f"localparam int unsigned G_N = {N};",
        f"localparam int unsigned G_NQ = {n};",
        f"localparam int unsigned G_CAND_CAP = {CAND_CAP};",
        f"localparam int unsigned G_INDEX_HEAD = {INDEX_HEAD};",
        f"localparam int unsigned G_MAX_EMIT = {MAX_EMIT};",
        f"localparam int unsigned G_MAX_REL = {MAX_REL};",
        f"localparam int unsigned G_N_WR = {nwr};",
        f"localparam int unsigned G_LATE_Q = {late_i};",
        f"localparam logic [19:0] G_LATE_GOLD_ID = 20'd{late_id};",
        "localparam int G_WR_I [0:G_N_WR-1] = '{",
        "  " + ",".join(str(i) for i in wr_i) + "};",
        "localparam logic [127:0] G_WR_D [0:G_N_WR-1] = '{",
        "  " + ",".join(f"128'h{writes[i]:032X}" for i in wr_i) + "};",
        "localparam int G_LEN [0:G_NQ-1] = '{"
        + csv_int([q["len"] for q in queries], str)
        + "};",
        "localparam logic [8*48-1:0] G_BYTES [0:G_NQ-1] = '{",
        "  " + ",".join(f"384'h{q['tok_pack']:096X}" for q in queries) + "};",
        "localparam logic [7:0] G_SUBJ [0:G_NQ-1] = '{"
        + csv_int([q["subj_id"] for q in queries], lambda x: f"8'd{x}")
        + "};",
        "localparam logic [7:0] G_OBJ  [0:G_NQ-1] = '{"
        + csv_int([q["obj_id"] for q in queries], lambda x: f"8'd{x}")
        + "};",
        "localparam logic [7:0] G_REL  [0:G_NQ-1] = '{"
        + csv_int([q["rel_id"] for q in queries], lambda x: f"8'd{x}")
        + "};",
        "localparam logic [7:0] G_CTX  [0:G_NQ-1] = '{"
        + csv_int([q["ctx_id"] for q in queries], lambda x: f"8'd{x}")
        + "};",
        "localparam logic [15:0] G_K0 [0:G_NQ-1] = '{"
        + csv_int([q["k0"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic [15:0] G_K1 [0:G_NQ-1] = '{"
        + csv_int([q["k1"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic [15:0] G_K2 [0:G_NQ-1] = '{"
        + csv_int([q["k2"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic [15:0] G_K3 [0:G_NQ-1] = '{"
        + csv_int([q["k3"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic G_V0 [0:G_NQ-1] = '{"
        + csv_int([q["k0_valid"] for q in queries], str)
        + "};",
        "localparam logic G_V1 [0:G_NQ-1] = '{"
        + csv_int([q["k1_valid"] for q in queries], str)
        + "};",
        "localparam logic G_V2 [0:G_NQ-1] = '{"
        + csv_int([q["k2_valid"] for q in queries], str)
        + "};",
        "localparam logic G_V3 [0:G_NQ-1] = '{"
        + csv_int([q["k3_valid"] for q in queries], str)
        + "};",
        "localparam int G_NEMIT [0:G_NQ-1] = '{"
        + csv_int([q["n_emit"] for q in queries], str)
        + "};",
        "localparam int G_NDIR [0:G_NQ-1] = '{"
        + csv_int([q["n_dir"] for q in queries], str)
        + "};",
        "localparam int G_NPOST [0:G_NQ-1] = '{"
        + csv_int([q["n_post"] for q in queries], str)
        + "};",
        "localparam int G_NDUP [0:G_NQ-1] = '{"
        + csv_int([q["n_dup"] for q in queries], str)
        + "};",
        "localparam int G_NTRUNC [0:G_NQ-1] = '{"
        + csv_int([q["n_trunc"] for q in queries], str)
        + "};",
        "localparam int G_OVF [0:G_NQ-1] = '{"
        + csv_int([q["overflow_flag"] for q in queries], str)
        + "};",
        "localparam int G_OCC [0:G_NQ-1] = '{"
        + csv_int([max(q["occupancies"] or [0]) for q in queries], str)
        + "};",
        "localparam int G_NREL [0:G_NQ-1] = '{"
        + csv_int([len(q["relevant"]) for q in queries], str)
        + "};",
        "localparam logic G_GOLD_EXCLUDED [0:G_NQ-1] = '{"
        + csv_int([1 if q["name"] == "distractor" else 0 for q in queries], str)
        + "};",
        "localparam int G_EXPECT_INCOMP [0:G_NQ-1] = '{"
        + csv_int([q["search_incomplete"] for q in queries], str)
        + "};",
        "localparam logic G_CAP_THEN_AND_MISS [0:G_NQ-1] = '{"
        + csv_int([1 if q.get("cap_then_and_miss") else 0 for q in queries], str)
        + "};",
        "localparam int G_EVIDENCE [0:G_N-1] = '{"
        + csv_int(ev, str)
        + "};",
    ]
    em_rows = []
    for q in queries:
        pad = list(q["emit"]) + [0] * MAX_EMIT
        em_rows.append("{" + ",".join(f"20'd{x}" for x in pad[:MAX_EMIT]) + "}")
    lines.append("localparam logic [19:0] G_EMIT [0:G_NQ-1][0:G_MAX_EMIT-1] = '{")
    lines.append("  " + ",".join(em_rows) + "};")
    rel_rows = []
    for q in queries:
        pad = list(q["relevant"]) + [0] * MAX_REL
        rel_rows.append("{" + ",".join(f"20'd{x}" for x in pad[:MAX_REL]) + "}")
    lines.append("localparam logic [19:0] G_RELEVANT [0:G_NQ-1][0:G_MAX_REL-1] = '{")
    lines.append("  " + ",".join(rel_rows) + "};")
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def main() -> int:
    if (BAG / "xsim_fail_r0.log").exists() or (BAG / "xvlog.log").exists() or (BAG / "xsim.log").exists():
        print("GOLD_IMMUTABLE after xvlog/fail_r0; do not regenerate")
        return 3

    docs = build_corpus()
    by_nid = {d["nid"]: d for d in docs}
    fails: list[str] = []

    def chk(cond: bool, msg: str) -> None:
        if not cond:
            fails.append(msg)

    psc = [d for d in docs if d["evidence"] == 1 and pred_psc(d)]
    chk(len(psc) == 3, f"PSC evidence count {len(psc)}")
    chk(any(d["ctx_id"] == 0 for d in psc), "PSC ctx0")
    chk(any(d["ctx_id"] == 1 for d in psc), "PSC ctx1 water")
    chk(any(d["ctx_id"] == 2 for d in psc), "PSC ctx2 indirect")
    chk({d["nid"] for d in psc} == {110, 144, 145}, f"PSC nids {[d['nid'] for d in psc]}")
    chk(docs[255]["kind"] == "high_id_sentinel", "sentinel kind")
    chk(docs[255]["evidence"] == 1, "sentinel evidence")

    ovf_gold = [d for d in docs if d["kind"] == "ovf_gold"]
    chk(len(ovf_gold) == 1, "one ovf gold")
    hoc_gold = [d for d in docs if d["kind"] == "high_occ_gold"]
    chk(len(hoc_gold) == 1, "one high-occ gold")
    late_gold = [d for d in docs if d["kind"] == "late_gold"]
    chk(len(late_gold) == 1, "one late gold")
    synth = [d for d in docs if d["evidence"] == 0]
    chk(len(synth) == HOC_SYNTH_N + INDEX_HEAD + LATE_K0_N + LATE_K1_N, f"synth {len(synth)}")

    queries_spec = [
        ("direct", "pump supplies chiller", pred_psc),
        ("paraphrase", "pump supply chiller", pred_psc),
        ("role_reversal", "chiller supplies pump", lambda d: d["subj_id"] == 1 and d["rel_id"] == 1 and d["obj_id"] == 10),
        ("wrong_relation", "pump requires chiller", lambda d: d["subj_id"] == 10 and d["rel_id"] == 2 and d["obj_id"] == 1),
        ("wrong_context", "pump supplies chiller water", lambda d: pred_psc(d) and d["ctx_id"] == 1),
        ("distractor", "pump supplies chiller", pred_excl),
        ("unrelated", "payroll tax form", lambda d: False),
        ("high_occupancy", "ahu requires chiller", lambda d: d["subj_id"] == 6 and d["rel_id"] == 2 and d["obj_id"] == 1),
        ("overflow_page", "sensor connects vav", lambda d: d["subj_id"] == 12 and d["rel_id"] == 3 and d["obj_id"] == 8),
        ("high_id_sentinel", "sensor connects tower", lambda d: d["nid"] == 255),
        ("late_gold", triple_text(LATE_S, LATE_R, LATE_O), pred_late),
    ]

    gold_map = {}
    for name, text, pred in queries_spec:
        gold_map[name] = gold_ids(docs, pred)
        if len(gold_map[name]) > MAX_REL:
            fails.append(f"gold too wide {name} n={len(gold_map[name])}")

    chk(set(gold_map["direct"]) != set(gold_map["role_reversal"]), "direct/reverse gold overlap")
    chk(set(gold_map["direct"]) != set(gold_map["wrong_relation"]), "direct/wrongrel gold overlap")
    chk(gold_map["wrong_context"] and set(gold_map["wrong_context"]).issubset(set(gold_map["direct"])), "ctx subset")
    chk(len(gold_map["wrong_context"]) == 1, "wrong_context singleton")
    chk(gold_map["unrelated"] == [], "unrelated gold")
    chk(len(gold_map["distractor"]) >= 1, "distractor gold_n>=1")
    chk(255 in gold_map["high_id_sentinel"], "sentinel gold")
    chk(ovf_gold[0]["nid"] in gold_map["overflow_page"], "ovf gold id")
    chk(hoc_gold[0]["nid"] in gold_map["high_occupancy"], "hoc gold id")
    chk(late_gold[0]["nid"] in gold_map["late_gold"], "late gold id")
    chk(gold_map["direct"] == [110, 144, 145], f"direct gold {gold_map['direct']}")
    chk(all(by_nid[i]["evidence"] == 1 for ids in gold_map.values() for i in ids), "gold evidence")
    chk(queries_spec[5][1] != "supply duct", "forbidden supply duct query")
    chk(set(gold_map["direct"]).isdisjoint(set(gold_map["distractor"])), "excluded contains PSC")

    heads, overflow, ovf_flag, post_len = index_docs(docs)

    lg = late_gold[0]
    lq = feat(triple_text(LATE_S, LATE_R, LATE_O))
    k0_list = posting_of(lq, 0, heads, overflow)
    k1_list = posting_of(lq, 1, heads, overflow)
    chk(lg["nid"] in k0_list, "late gold not in k0 posting")
    chk(lg["nid"] in k1_list, "late gold not in k1 posting")
    idx0 = k0_list.index(lg["nid"])
    idx1 = k1_list.index(lg["nid"])
    chk(idx0 >= 16, f"late gold k0 index {idx0} < 16")
    chk(idx1 >= 16, f"late gold k1 index {idx1} < 16")
    cap_miss = cap_then_and(k0_list, k1_list, CAND_CAP)
    chk(lg["nid"] not in cap_miss, f"late gold in cap-then-AND {cap_miss}")
    stream_hit, _, _ = two_pointer(k0_list, k1_list, CAND_CAP)
    chk(lg["nid"] in stream_hit, f"late gold not in stream AND {stream_hit}")

    ovf_nid = ovf_gold[0]["nid"]
    in_ovf_page = False
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            if ovf_nid in overflow[t][b]:
                in_ovf_page = True
    chk(in_ovf_page, "ovf gold not in overflow page")

    hoc_occ = 0
    hq = feat("ahu requires chiller")
    if hq["k0_valid"]:
        hoc_occ = post_len[0][hq["k0"] & 0xFFF]
    chk(hoc_occ > CAND_CAP, f"high occupancy {hoc_occ} not > CAND_CAP")
    chk(CAND_CAP < N, "cap>=N")

    must_hit = {
        "direct",
        "paraphrase",
        "role_reversal",
        "wrong_relation",
        "high_occupancy",
        "overflow_page",
        "high_id_sentinel",
        "late_gold",
    }

    queries = []
    for name, text, pred in queries_spec:
        q = feat(text)
        q["name"] = name
        raw = text.encode("latin1")
        q["len"] = len(raw)
        q["tok_pack"] = pack_text(text)
        if raw:
            chk((q["tok_pack"] & 0xFF) == raw[0], f"{name} tok_pack LSB != char0")
        q["relevant"] = gold_map[name]
        rt = route(q, heads, overflow, ovf_flag, post_len)
        q.update(rt)
        if name == "distractor":
            met = metrics_excl(q["emit"], q["relevant"], by_nid)
            q["leak_n"] = met["leak_n"]
            q["leak_ids"] = met["leak_ids"]
            q["tp"] = 0
            q["fp_ev1"] = met["fp_ev1"]
            q["fp_fill0"] = met["fp_fill0"]
            q["prec_ev1"] = met["prec_ev1"]
            q["prec_all"] = met["prec_all"]
            q["recall"] = None
            q["search_incomplete"] = 0
            q["cap_then_and_miss"] = False
        else:
            met = metrics_of(q["emit"], q["relevant"], by_nid)
            missed = met["missed"]
            incomp = 1 if (q["n_trunc"] > 0 or q.get("search_incomplete_walk")) else 0
            if missed and name in must_hit:
                fails.append(f"GOLD_MISS {name} missed={missed} emit={q['emit']} incomp={incomp}")
            q["leak_n"] = 0
            q["leak_ids"] = []
            q["tp"] = met["tp"]
            q["fp_ev1"] = met["fp_ev1"]
            q["fp_fill0"] = met["fp_fill0"]
            q["prec_ev1"] = met["prec_ev1"]
            q["prec_all"] = met["prec_all"]
            q["recall"] = met["recall"]
            q["search_incomplete"] = incomp
            q["cap_then_and_miss"] = (
                name == "late_gold" and lg["nid"] not in set(q.get("cap_then_and") or [])
            )
        q["returns_entire_corpus"] = q["n_emit"] >= N
        chk(q["n_emit"] < N, f"{name} emit>=N tautology cap")
        chk(q["n_host"] == 0, f"{name} host")
        queries.append(q)

    qd = {q["name"]: q for q in queries}
    chk(qd["paraphrase"]["k0"] == qd["direct"]["k0"] and qd["paraphrase"]["k1"] == qd["direct"]["k1"], "para keys")
    chk(qd["role_reversal"]["subj_id"] == qd["direct"]["obj_id"], "reverse swap")
    chk(qd["role_reversal"]["obj_id"] == qd["direct"]["subj_id"], "reverse swap2")
    chk(qd["role_reversal"]["k0"] == qd["direct"]["k1"], "reverse k0k1")
    chk(qd["role_reversal"]["k1"] == qd["direct"]["k0"], "reverse k1k0")
    chk(qd["direct"]["k2"] != qd["direct"]["k2_frozen"], "relbind k2 did not change vs frozen cue")
    chk(qd["unrelated"]["n_emit"] == 0 and qd["unrelated"]["n_dir"] == 0, "unrelated emit")
    chk(qd["unrelated"]["k0_valid"] == 0 and qd["unrelated"]["k1_valid"] == 0, "unrelated valid")
    chk(qd["unrelated"]["prec_all"] is None and qd["unrelated"]["recall"] is None, "unrelated not scored 0/0")
    chk(qd["overflow_page"]["overflow_flag"] == 1, "ovf flag")
    chk(qd["high_occupancy"]["occupancies"] and max(qd["high_occupancy"]["occupancies"]) > CAND_CAP, "hoc occ")
    chk(qd["direct"]["n_emit"] <= CAND_CAP, "direct cap")
    chk(qd["direct"]["tp"] > 0, "direct gold hits==0")
    chk(set(qd["direct"]["emit"]) >= {110, 144, 145}, f"direct emit {qd['direct']['emit']}")
    chk(qd["late_gold"]["tp"] == 1, "late_gold tp")
    chk(lg["nid"] in qd["late_gold"]["emit"], "late_gold not in emit")
    chk(qd["late_gold"]["cap_then_and_miss"], "late_gold cap-then-AND did not miss")
    chk(qd["late_gold"]["search_incomplete"] == 0, "late_gold SEARCH_INCOMPLETE")
    chk(qd["distractor"]["tp"] == 0, "distractor tp must be 0")
    chk(qd["distractor"]["recall"] is None, "distractor rec must be undef")
    chk(set(qd["direct"]["emit"]).isdisjoint(set(qd["distractor"]["relevant"])), "direct emit contains excluded")

    wc = qd["wrong_context"]
    dd = qd["direct"]
    chk(
        wc["k0"] == dd["k0"] and wc["k1"] == dd["k1"] and wc["k2"] == dd["k2"] and wc["k3"] == dd["k3"],
        "wrong_context keys != direct",
    )
    chk(wc["emit"] == dd["emit"], "wrong_context emit != direct")
    chk(qd["distractor"]["emit"] == dd["emit"], "distractor emit != direct")

    if fails:
        print("ASTRA_C1_STREAM_INTERSECT_02_HOST_FAIL")
        for f in fails:
            print("FAIL", f)
        return 2

    writes = write_index(heads, overflow, ovf_flag)
    n_ovf_buckets = sum(ovf_flag[t][b] for t in range(N_TABLES) for b in range(N_BUCKETS))
    n_occ_ge16 = sum(1 for t in range(N_TABLES) for b in range(N_BUCKETS) if post_len[t][b] >= 16)

    corpus_pub = {
        "gate": GATE,
        "n": N,
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "law": LAW,
        "extract_law_frozen": LAW_EXTRACT,
        "late_gold_nid": lg["nid"],
        "late_gold_k0_index": idx0,
        "late_gold_k1_index": idx1,
        "records": [
            {
                "nid": d["nid"],
                "text": d["text"],
                "evidence": d["evidence"],
                "kind": d["kind"],
                "subj_id": d["subj_id"],
                "rel_id": d["rel_id"],
                "obj_id": d["obj_id"],
                "ctx_id": d["ctx_id"],
                "k0": d["k0"],
                "k1": d["k1"],
                "k2": d["k2"],
                "k3": d["k3"],
                "k2_frozen": d["k2_frozen"],
                "k3_frozen": d["k3_frozen"],
            }
            for d in docs
        ],
    }
    (BAG / "corpus.json").write_text(json.dumps(corpus_pub) + "\n", encoding="utf-8")

    def qpub(q: dict) -> dict:
        row = {
            "name": q["name"],
            "text": q["text"],
            "subj_id": q["subj_id"],
            "obj_id": q["obj_id"],
            "rel_id": q["rel_id"],
            "ctx_id": q["ctx_id"],
            "k0": q["k0"],
            "k1": q["k1"],
            "k2": q["k2"],
            "k3": q["k3"],
            "k2_frozen": q["k2_frozen"],
            "k3_frozen": q["k3_frozen"],
            "k0_valid": q["k0_valid"],
            "k1_valid": q["k1_valid"],
            "k2_valid": q["k2_valid"],
            "k3_valid": q["k3_valid"],
            "relevant": q["relevant"],
            "emit": q["emit"],
            "n_emit": q["n_emit"],
            "gold_n": len(q["relevant"]),
            "tp": q["tp"],
            "fp_ev1": q["fp_ev1"],
            "fp_fill0": q["fp_fill0"],
            "prec_ev1": q["prec_ev1"],
            "prec_all": q["prec_all"],
            "recall": q["recall"],
            "n_dir": q["n_dir"],
            "n_post": q["n_post"],
            "n_dup": q["n_dup"],
            "n_trunc": q["n_trunc"],
            "overflow_flag": q["overflow_flag"],
            "occupancies": q["occupancies"],
            "search_incomplete": q["search_incomplete"],
            "bytes": q["bytes"],
            "reduction_x1000": "NOT_EMITTED",
            "cap_then_and": q.get("cap_then_and"),
            "cap_then_and_miss": q.get("cap_then_and_miss"),
            "rare_first": q.get("rare_first"),
        }
        if q["name"] == "wrong_context":
            row["NOT_SELECTIVE"] = True
            row["keys_match_direct"] = True
            row["emit_match_direct"] = q["emit"] == dd["emit"]
            row["rec_is_not_context_selectivity"] = True
            row["frozen_law"] = "xid_not_directory_key"
        if q["name"] == "unrelated":
            row["UNRELATED_EMPTY_WALK"] = q["n_emit"] == 0
        if q["name"] == "distractor":
            row["gold_polarity"] = "excluded"
            row["leak_n"] = q["leak_n"]
            row["leak_ids"] = q["leak_ids"]
            row["DISTRACTOR_LEAK"] = q["leak_n"] > 0
            row["rec_is_not_retrieve"] = True
        if q["name"] == "late_gold":
            row["LATE_GOLD_HIT"] = lg["nid"] in q["emit"]
            row["k0_index"] = idx0
            row["k1_index"] = idx1
        return row

    golden = {
        "gate": GATE,
        "law": LAW,
        "extract_law_frozen": LAW_EXTRACT,
        "law_control_not_used": LAW_V1,
        "key_rebind": "relbind reused; walker=stream_k0_intersect_k1; k2k3_not_probed",
        "intersect_law": "sorted-nid two-pointer AND; 1-beat page; rare-first; CAND_CAP after emit",
        "n": N,
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "merge_post_ar_max": MERGE_POST_AR_MAX,
        "n_host": 0,
        "gold_source": "independent_labels_before_router",
        "relevant_is_router_union": False,
        "cap_ge_n_used_as_selectivity": False,
        "g_bytes_layout": "lsb_first_char0_at_bits7_0",
        "reduction_x1000_emitted": False,
        "overflow_buckets": n_ovf_buckets,
        "high_occupancy_buckets_ge16": n_occ_ge16,
        "n_index_writes": len(writes),
        "wrong_context_policy": "NOT_SELECTIVE qse-v2-stream-intersect-02 xid not directory key; do not fake ctx keys",
        "distractor_gold_polarity": "excluded",
        "distractor_query": "pump supplies chiller",
        "late_gold_nid": lg["nid"],
        "late_gold_k0_index": idx0,
        "late_gold_k1_index": idx1,
        "late_gold_cap_then_and_miss": True,
        "CAND_CAP_FINAL": "NOT_FROZEN",
        "DDR_QUERY_BOUND_FINAL": "NOT_FROZEN",
        "queries": [qpub(q) for q in queries],
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    write_svh(BAG / "query_gold.svh", queries, writes, docs)

    gsha = sha256_file(BAG / "GOLDEN.json")
    ssha = sha256_file(BAG / "query_gold.svh")
    csha = sha256_file(BAG / "corpus.json")
    (BAG / "GOLD_HASH_PRE_XVLOG.txt").write_text(
        "\n".join(
            [
                "# independent gold hashed BEFORE first xvlog — do not regenerate after FAIL",
                f"{gsha}  GOLDEN.json",
                f"{ssha}  query_gold.svh",
                f"{csha}  corpus.json",
                "",
            ]
        ),
        encoding="utf-8",
    )

    print("ASTRA_C1_STREAM_INTERSECT_02_HOST_PASS")
    print("N", N, "CAND_CAP", CAND_CAP, "INDEX_HEAD", INDEX_HEAD, "WRITES", len(writes))
    print("OVF_BUCKETS", n_ovf_buckets, "OCC_GE16", n_occ_ge16)
    print("LATE_GOLD_NID", lg["nid"], "K0_IDX", idx0, "K1_IDX", idx1)
    print("GOLD_SHA", gsha)
    print("SVH_SHA", ssha)
    print("CORPUS_SHA", csha)
    for q in queries:
        pe = "NA" if q["prec_ev1"] is None else f"{q['prec_ev1']:.3f}"
        pa = "NA" if q["prec_all"] is None else f"{q['prec_all']:.3f}"
        rr = "NA" if q["recall"] is None else f"{q['recall']:.3f}"
        extra = ""
        if q["name"] == "wrong_context":
            extra = " NOT_SELECTIVE"
        if q["name"] == "unrelated":
            extra = " UNRELATED_EMPTY_WALK"
        if q["name"] == "distractor":
            extra = f" EXCLUDED leak_n={q['leak_n']}"
        if q["name"] == "late_gold":
            extra = f" LATE_GOLD_HIT cap_then_and_miss={int(q['cap_then_and_miss'])} k0_idx={idx0} k1_idx={idx1}"
        print(
            f"Q {q['name']} text={q['text']!r} gold={q['relevant']} emit={q['emit']} "
            f"gold_n={len(q['relevant'])} emit_n={q['n_emit']} tp={q['tp']} "
            f"fp_ev1={q['fp_ev1']} fp_fill0={q['fp_fill0']} prec_ev1={pe} prec_all={pa} rec={rr} "
            f"occ={q['occupancies']} ovf={q['overflow_flag']} trunc={q['n_trunc']} "
            f"incomp={q['search_incomplete']}{extra}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
