#!/usr/bin/env python3
"""ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01 independent host gold.

ONE UNKNOWN: N=16384 cartesian fill PLUS >=8 off-grid planted (s,r,o)
facts not in the fill generator; retrieve one planted nid (gold_n>=1);
query bound to an unindexed SRO must UNBOUND_EMPTY_WALK and must NOT
emit fill-grid neighbors {120,121,122}. Instantiate ctx keys 124be808
+ DUT 8255a798 not edited. Named lexicon law qse-v2-lex-semantic-16k-01
(copied SHA df0e8833; do not edit C0 38189974). leftover A09 off
poke_v=0 PROGRAM=NO.

If XSim MEM cannot host 16384, FAIL honestly FIRST_DIVERGENCE MEM —
do not silently drop to N=256. SEARCH_INCOMPLETE on gold_n>=1 retrieve
= FAIL. C1 800k stays OPEN. BOARD_PASS not claimed. Do not edit KEEP
bags. Do not write independent audit tree. G_BYTES: LSB-first (char0
at bits[7:0]) matching TB bytes[8*bi +: 8].
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
QDIR = ROOT / "rtl" / "native_graph" / "query"
sys.path.insert(0, str(QDIR))
import role_lexicon  # noqa: E402
from twin_role import extract as extract_v2  # noqa: E402

GATE = "ASTRA-C1-SEMANTIC-UNSEEN-SRO-16K-01"
LAW = "qse-v2-intersect-context-02"
LAW_LEX = "qse-v2-lex-semantic-16k-01"
LAW_V1 = "qse-v1-lexicon-hdc-00"
LAW_EXTRACT = "qse-v2-role-00"
N = 16384
N_TABLES = 4
N_BUCKETS = 65536
BUCKET_MASK = N_BUCKETS - 1
CAND_CAP = 16
INDEX_HEAD = 4
ENTRY = 16
TABLE_BYTES = N_BUCKETS * ENTRY
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + N_TABLES * TABLE_BYTES
DIR_LO = INDEX_BASE
DIR_HI = POST_HEAP - ENTRY
EPOCH = 7
MAX_REL = 16
MAX_EMIT = 16
MERGE_POST_AR_MAX = 256
FILL_GRID_NIDS = (120, 121, 122)
UNSEEN_NID = 123

DIR_S, DIR_R, DIR_O = 13, 4, 14  # boiler feeds header (fill-grid)
UNSEEN_S, UNSEEN_R, UNSEEN_O = 1, 1, 2  # chiller supplies condenser (NOT in fill)
UNBOUND_S, UNBOUND_R, UNBOUND_O = 13, 4, 1  # boiler feeds chiller (NOT indexed)
CTX_GLYCOL = 3
CTX_STEAM = 4

# Off-grid plants: C0 HVAC ids {1..12} are outside NEW_SUBJ_IDS {13..132}.
# None may be (s,4,1) — that would index unbound k1.
PLANTED = [
    (1, 1, 2),    # chiller supplies condenser     nid 123  RETRIEVE
    (1, 2, 3),    # chiller requires evaporator    nid 124
    (4, 1, 2),    # compressor supplies condenser  nid 125
    (6, 3, 7),    # ahu connects duct              nid 126
    (10, 1, 11),  # pump supplies valve            nid 127  (not psc clone)
    (9, 8, 2),    # tower discharges condenser     nid 128
    (12, 5, 6),   # sensor isolates ahu            nid 129
    (3, 6, 4),    # evaporator bypasses compressor nid 130
]

NEW_ENT = [
    "boiler", "header", "coil", "filter", "damper", "grille", "plenum", "riser",
    "strainer", "actuator", "humidistat", "humidifier", "dehumidifier", "economizer",
    "recuperator", "heatwheel", "reheat", "preheat", "mixbox", "inverter",
    "starter", "breaker", "xformer", "busbar", "panel", "motor", "impeller", "volute",
    "shaft", "bearing", "coupling", "gearbox", "sheave", "belt", "pulley", "diffuser",
    "nozzle", "orifice", "trap", "drain", "sump", "basin", "fillpack", "eliminator",
    "louver", "screen", "mesh", "gasket", "flange", "unionfit", "elbow", "tee",
    "reducer", "nipple", "bushing", "hanger", "clamp", "jacket", "tracer", "manifold",
    "tap", "branch", "loop", "jumper", "circuit", "zone", "wing", "floor",
    "chase", "closet", "penthouse", "rooftop", "basement", "plant", "skid", "rack",
    "frame", "chassis", "enclosure", "cabinet", "hopper", "silo", "tank", "vessel",
    "kettle", "reactor", "column", "tray", "packing", "reboiler", "still", "scrubber",
    "absorber", "dryer", "kiln", "oven", "furnace", "feedwater", "condensate", "makeup",
    "blowdown", "steamdrum", "deaerator", "airsep", "vacuum", "ejector", "desuper", "attemper",
    "spray", "quench", "cooler", "heater", "exchanger", "autoclave", "blender", "mixer",
    "agitator", "centrifuge", "cyclone", "beacon",
]
NEW_LEX = []
for i, w in enumerate(NEW_ENT):
    NEW_LEX.append((w, 1, 13 + i))
NEW_LEX.extend(
    [
        ("feeds", 2, 4),
        ("feed", 4, 4),
        ("isolates", 2, 5),
        ("bypasses", 2, 6),
        ("modulates", 2, 7),
        ("discharges", 2, 8),
        ("glycol", 3, 3),
        ("steam", 3, 4),
    ]
)

FROZEN_C0 = {w for w, _, _ in role_lexicon.LEX}
role_lexicon.LEX.extend(NEW_LEX)

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
for i, w in enumerate(NEW_ENT):
    ENT[13 + i] = w
RELW = {
    1: "supplies",
    2: "requires",
    3: "connects",
    4: "feeds",
    5: "isolates",
    6: "bypasses",
    7: "modulates",
    8: "discharges",
}

NEW_SUBJ_IDS = list(range(13, 13 + len(NEW_ENT)))
FILL_RE = re.compile(r"^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$")

EXPECTED_LEX_NAMED = "df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4"
EXPECTED_LEX_SHIM = "7966f321171cfe97b396ad90bb1ebd156c09a165782df40a3a98109ee59ac263"


def pack_plain(sid: int, rid: int) -> int:
    return ((sid & 0xFF) << 8) | (rid & 0xFF)


def pack_ctx(sid: int, rid: int, xid: int) -> int:
    return ((sid & 0xFF) << 8) | ((xid & 0xF) << 4) | (rid & 0xF)


def sha256_bytes(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def write_named_lexicon() -> None:
    named = BAG / "qse_role_lexicon_semantic_16k.svh"
    shim = BAG / "qse_role_lexicon.svh"
    if not named.is_file() or not shim.is_file():
        raise SystemExit("named semantic-16k lexicon copy missing")
    live_n = sha256_bytes(named)
    live_s = sha256_bytes(shim)
    if live_n != EXPECTED_LEX_NAMED:
        raise SystemExit(f"named lexicon SHA drift {live_n} want {EXPECTED_LEX_NAMED}")
    if live_s != EXPECTED_LEX_SHIM:
        raise SystemExit(f"lexicon shim SHA drift {live_s} want {EXPECTED_LEX_SHIM}")


def ctx_keys(x: dict) -> dict:
    """Same packing as a7ng_query_role_keys_ctx.sv. Valids unchanged. No nid keys."""
    sid = int(x["subj_id"]) & 0xFF
    oid = int(x["obj_id"]) & 0xFF
    rid = int(x["rel_id"]) & 0xFF
    xid = int(x["ctx_id"]) & 0xFF
    ctx_valid = 1 if xid != 0 else 0
    k0_plain = pack_plain(sid, rid)
    k1_plain = pack_plain(oid, rid)
    if ctx_valid:
        k0 = pack_ctx(sid, rid, xid)
        k1 = pack_ctx(oid, rid, xid)
    else:
        k0, k1 = k0_plain, k1_plain
    y = dict(x)
    y["k0_plain"] = k0_plain
    y["k1_plain"] = k1_plain
    y["k2_frozen"] = int(x["k2"]) & 0xFFFF
    y["k3_frozen"] = int(x["k3"]) & 0xFFFF
    y["k0"] = k0 & 0xFFFF
    y["k1"] = k1 & 0xFFFF
    y["k2"] = ((rid << 8) | xid) & 0xFFFF
    y["k3"] = ((sid << 8) | xid) & 0xFFFF
    y["ctx_valid"] = ctx_valid
    return y


def feat(text: str) -> dict:
    x = extract_v2(text)
    if x["n_host"] != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK text={text!r}")
    y = ctx_keys(x)
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
        "ctx_bind": q.get("ctx_bind", 0),
        "ctx_valid": q["ctx_valid"],
        "k0": q["k0"],
        "k1": q["k1"],
        "k2": q["k2"],
        "k3": q["k3"],
        "k0_plain": q["k0_plain"],
        "k1_plain": q["k1_plain"],
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


def cartesian_fill_sros() -> list[tuple[int, int, int]]:
    reserved = {(DIR_S, DIR_R, DIR_O)}
    out: list[tuple[int, int, int]] = []
    for s in NEW_SUBJ_IDS:
        for r in range(1, 9):
            for o in NEW_SUBJ_IDS:
                if s == o:
                    continue
                sro = (s, r, o)
                if sro in reserved:
                    continue
                out.append(sro)
    return out


def build_corpus() -> list[dict]:
    docs: list[dict] = []
    used: set[tuple[int, int, int]] = set()

    def add(text: str, evidence: int, kind: str, sro: tuple[int, int, int] | None = None) -> dict:
        if len(docs) >= N:
            raise SystemExit("corpus overflow before N")
        nid = len(docs)
        row = rec_of(nid, text, evidence, kind)
        if sro is not None:
            used.add(sro)
        docs.append(row)
        return row

    fill_sros = cartesian_fill_sros()
    fill_sro_set = set(fill_sros)
    if not fill_sros:
        raise SystemExit("empty cartesian fill")
    if (UNSEEN_S, UNSEEN_R, UNSEEN_O) in fill_sro_set:
        raise SystemExit("unseen SRO is inside cartesian fill generator")
    if (UNBOUND_S, UNBOUND_R, UNBOUND_O) in fill_sro_set:
        raise SystemExit("unbound SRO is inside cartesian fill generator")
    if (DIR_S, DIR_R, DIR_O) in fill_sro_set:
        raise SystemExit("fill-grid SRO leaked into cartesian fill")
    for sro in PLANTED:
        if sro in fill_sro_set:
            raise SystemExit(f"planted SRO {sro} is inside cartesian fill generator")
        if sro == (UNBOUND_S, UNBOUND_R, UNBOUND_O):
            raise SystemExit("planted SRO collides unbound")
        if sro[1] == UNBOUND_R and sro[2] == UNBOUND_O:
            raise SystemExit(f"planted {sro} would index unbound k1")

    # nids 0..119: one cartesian SRO per NEW entity (keeps fill-grid at 120-122).
    for i, s in enumerate(NEW_SUBJ_IDS):
        r = 1 + (i % 8)
        o = 13 + ((i + 17) % len(NEW_ENT))
        if o == s:
            o = 13 + ((i + 18) % len(NEW_ENT))
        sro = (s, r, o)
        if sro == (DIR_S, DIR_R, DIR_O):
            o = 13 + ((i + 23) % len(NEW_ENT))
            if o == s:
                o = 13 + ((i + 29) % len(NEW_ENT))
            sro = (s, r, o)
        if sro == (DIR_S, DIR_R, DIR_O):
            raise SystemExit(f"core sro still reserved {sro}")
        if sro not in fill_sro_set:
            raise SystemExit(f"core sro not in cartesian generator {sro}")
        add(triple_text(s, r, o), 1, "fill", sro)
    if len(docs) != FILL_GRID_NIDS[0]:
        raise SystemExit(f"fill-grid base {len(docs)} want {FILL_GRID_NIDS[0]}")

    add(triple_text(DIR_S, DIR_R, DIR_O), 1, "direct_plain", (DIR_S, DIR_R, DIR_O))
    add(triple_text(DIR_S, DIR_R, DIR_O, "glycol"), 1, "direct_glycol", (DIR_S, DIR_R, DIR_O))
    add(triple_text(DIR_S, DIR_R, DIR_O, "steam"), 1, "direct_steam", (DIR_S, DIR_R, DIR_O))
    if docs[120]["nid"] != 120 or docs[121]["nid"] != 121 or docs[122]["nid"] != 122:
        raise SystemExit("fill-grid nids drifted")

    for sro in PLANTED:
        add(triple_text(*sro), 1, "unseen_sro", sro)
    if docs[UNSEEN_NID]["nid"] != UNSEEN_NID:
        raise SystemExit("unseen nid drifted")
    if len(PLANTED) < 8:
        raise SystemExit("planted_n < 8")
    if len(docs) != UNSEEN_NID + len(PLANTED):
        raise SystemExit(f"after plants {len(docs)} want {UNSEEN_NID + len(PLANTED)}")

    for sro in fill_sros:
        if sro in used:
            continue
        if len(docs) >= N:
            break
        add(triple_text(*sro), 1, "fill", sro)

    pad_src = [triple_text(*sro) for sro in fill_sros]
    fi = 0
    while len(docs) < N:
        add(pad_src[fi % len(pad_src)], 0, "pad_synth")
        fi += 1
    if len(docs) != N:
        raise SystemExit(f"corpus N={len(docs)} want {N}")
    return docs


def gold_ids(docs: list[dict], pred) -> list[int]:
    return [d["nid"] for d in docs if d["evidence"] == 1 and pred(d)]


def pred_direct(d: dict) -> bool:
    return d["subj_id"] == DIR_S and d["rel_id"] == DIR_R and d["obj_id"] == DIR_O


def pred_unseen(d: dict) -> bool:
    return d["subj_id"] == UNSEEN_S and d["rel_id"] == UNSEEN_R and d["obj_id"] == UNSEEN_O


def pred_unbound(d: dict) -> bool:
    return d["subj_id"] == UNBOUND_S and d["rel_id"] == UNBOUND_R and d["obj_id"] == UNBOUND_O


def add_nid(buckets, t: int, key: int, nid: int, valid: int) -> None:
    if not valid:
        return
    b = key & BUCKET_MASK
    lst = buckets[t][b]
    if nid not in lst:
        lst.append(nid)


def index_docs(docs: list[dict]):
    buckets = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    for d in docs:
        nid = d["nid"]
        add_nid(buckets, 0, d["k0_plain"], nid, d["k0_valid"])
        add_nid(buckets, 1, d["k1_plain"], nid, d["k1_valid"])
        if d["ctx_valid"]:
            add_nid(buckets, 0, d["k0"], nid, d["k0_valid"])
            add_nid(buckets, 1, d["k1"], nid, d["k1_valid"])
        add_nid(buckets, 2, d["k2"], nid, d["k2_valid"])
        add_nid(buckets, 3, d["k3"], nid, d["k3_valid"])
    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    overflow = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    ovf_flag = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    post_len = [[0] * N_BUCKETS for _ in range(N_TABLES)]
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            lst = buckets[t][b]
            if not lst:
                continue
            lst = sorted(lst)
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
    b = keys[t] & BUCKET_MASK
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


def nbeats(n: int) -> int:
    if n <= 0:
        return 0
    return (n + 3) // 4


def route(q: dict, heads, overflow, ovf_flag, post_len) -> dict:
    v0 = bool(q["k0_valid"])
    v1 = bool(q["k1_valid"])
    if v0 and v1:
        a = posting_of(q, 0, heads, overflow)
        b = posting_of(q, 1, heads, overflow)
        emit, ntrunc, incomp = two_pointer(a, b, CAND_CAP)
        b0 = q["k0"] & BUCKET_MASK
        b1 = q["k1"] & BUCKET_MASK
        n_dir = 2
        n_post = nbeats(len(a)) + nbeats(len(b))
        if n_post > MERGE_POST_AR_MAX:
            incomp = 1
            ntrunc = max(ntrunc, 1)
        ovf = 1 if (ovf_flag[0][b0] or ovf_flag[1][b1]) else 0
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
            "full_k0": a,
            "full_k1": b,
            "rare_first": rare_first,
        }
    if v0:
        a = posting_of(q, 0, heads, overflow)
        emit = a[:CAND_CAP]
        ntrunc = max(0, len(a) - CAND_CAP)
        incomp = 1 if ntrunc else 0
        b0 = q["k0"] & BUCKET_MASK
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
            "full_k0": a,
            "full_k1": [],
            "rare_first": 0,
        }
    if v1:
        b = posting_of(q, 1, heads, overflow)
        emit = b[:CAND_CAP]
        ntrunc = max(0, len(b) - CAND_CAP)
        incomp = 1 if ntrunc else 0
        b1 = q["k1"] & BUCKET_MASK
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
        "full_k0": [],
        "full_k1": [],
        "rare_first": 0,
    }


def dir_addr(table: int, key: int) -> int:
    return INDEX_BASE + table * TABLE_BYTES + (key & BUCKET_MASK) * ENTRY


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
    b = s.encode("latin1")[:48]
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def write_index(heads, overflow, ovf_flag):
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
    mem_depth = max(max_word + 1024, 6144 + N_TABLES * N_BUCKETS + 4096)
    if max_word >= mem_depth:
        raise SystemExit(f"FIRST_DIVERGENCE MEM mem word {max_word} >= MEM_DEPTH {mem_depth}")
    if mem_depth > 1048576:
        raise SystemExit(f"FIRST_DIVERGENCE MEM MEM_DEPTH {mem_depth} too large for XSim honest fail")
    return writes, mem_depth, max_word


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


def csv_int(xs, fmt) -> str:
    return ",".join(fmt(x) for x in xs)


def wrap_items(items: list[str], per: int = 8) -> str:
    if not items:
        return "  "
    lines = []
    for i in range(0, len(items), per):
        chunk = items[i : i + per]
        suffix = "," if i + per < len(items) else ""
        lines.append("  " + ",".join(chunk) + suffix)
    return "\n".join(lines)


def write_svh(
    path: Path,
    queries: list[dict],
    writes: dict[int, int],
    docs: list[dict],
    mem_depth: int,
    n_subj: int,
    n_rel: int,
) -> None:
    n = len(queries)
    nwr = len(writes)
    wr_i = sorted(writes)
    ev = [d["evidence"] for d in docs]
    unseen_i = next(i for i, q in enumerate(queries) if q["name"] == "unseen_sro")
    unbound_i = next(i for i, q in enumerate(queries) if q["name"] == "unbound_sro")
    unrel_i = next(i for i, q in enumerate(queries) if q["name"] == "unrelated")
    planted_nids = list(range(UNSEEN_NID, UNSEEN_NID + len(PLANTED)))
    lines = [
        "// generated by host_astra_c1_semantic_unseen_sro_16k.py — independent gold BEFORE xvlog. do not hand-edit after FAIL",
        f"// Law {LAW} + named lexicon {LAW_LEX}; STREAM-02 walker in context wrapper; N=16384 unseen SRO",
        "// G_BYTES LSB-first: char0 at [7:0]; TB must use bytes[8*bi +: 8]",
        f"localparam int unsigned G_N = {N};",
        f"localparam int unsigned G_NQ = {n};",
        f"localparam int unsigned G_CAND_CAP = {CAND_CAP};",
        f"localparam int unsigned G_INDEX_HEAD = {INDEX_HEAD};",
        f"localparam int unsigned G_MAX_EMIT = {MAX_EMIT};",
        f"localparam int unsigned G_MAX_REL = {MAX_REL};",
        f"localparam int unsigned G_N_WR = {nwr};",
        f"localparam int unsigned G_MEM_DEPTH = {mem_depth};",
        f"localparam int unsigned G_N_BUCKETS = {N_BUCKETS};",
        f"localparam int unsigned G_N_SUBJECTS = {n_subj};",
        f"localparam int unsigned G_N_RELS = {n_rel};",
        f"localparam int unsigned G_UNSEEN_Q = {unseen_i};",
        f"localparam int unsigned G_UNBOUND_Q = {unbound_i};",
        f"localparam int unsigned G_UNRELATED_Q = {unrel_i};",
        f"localparam int unsigned G_PLANTED_N = {len(PLANTED)};",
        f"localparam logic [19:0] G_UNSEEN_NID = 20'd{UNSEEN_NID};",
        "localparam logic [19:0] G_FILL_GRID [0:2] = '{20'd120,20'd121,20'd122};",
        "localparam logic [19:0] G_PLANTED_NIDS [0:G_PLANTED_N-1] = '{"
        + ",".join(f"20'd{x}" for x in planted_nids)
        + "};",
        f"localparam logic [27:0] G_POST_HEAP = 28'h{POST_HEAP:08X};",
        f"localparam logic [27:0] G_DIR_LO = 28'h{DIR_LO:08X};",
        f"localparam logic [27:0] G_DIR_HI = 28'h{DIR_HI:08X};",
        "localparam int G_WR_I [0:G_N_WR-1] = '{",
        wrap_items([str(i) for i in wr_i], 16) + "};",
        "localparam logic [127:0] G_WR_D [0:G_N_WR-1] = '{",
        wrap_items([f"128'h{writes[i]:032X}" for i in wr_i], 4) + "};",
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
        "localparam logic G_CTX_VALID [0:G_NQ-1] = '{"
        + csv_int([q["ctx_valid"] for q in queries], str)
        + "};",
        "localparam logic [15:0] G_K0_PLAIN [0:G_NQ-1] = '{"
        + csv_int([q["k0_plain"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic [15:0] G_K1_PLAIN [0:G_NQ-1] = '{"
        + csv_int([q["k1_plain"] for q in queries], lambda x: f"16'h{x:04X}")
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
        + csv_int([0 for _ in queries], str)
        + "};",
        "localparam int G_EXPECT_INCOMP [0:G_NQ-1] = '{"
        + csv_int([q["search_incomplete"] for q in queries], str)
        + "};",
        "localparam int G_EVIDENCE [0:G_N-1] = '{",
        wrap_items([str(x) for x in ev], 32) + "};",
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

    if len(NEW_ENT) != 120:
        raise SystemExit(f"NEW_ENT {len(NEW_ENT)} != 120")
    if len(set(NEW_ENT)) != 120:
        raise SystemExit("NEW_ENT not unique")
    for w in NEW_ENT:
        if w in FROZEN_C0:
            raise SystemExit(f"NEW_ENT collides C0 {w}")
        if len(w) > 12 or not w.isascii() or not w.islower():
            raise SystemExit(f"bad NEW_ENT word {w!r}")
    for w, _, _ in NEW_LEX:
        if w in FROZEN_C0:
            raise SystemExit(f"NEW_LEX collides C0 {w}")
        if len(w) > 12:
            raise SystemExit(f"NEW_LEX word too long {w}")
    if len(PLANTED) < 8:
        raise SystemExit("PLANTED < 8")
    if PLANTED[0] != (UNSEEN_S, UNSEEN_R, UNSEEN_O):
        raise SystemExit("PLANTED[0] must be retrieve SRO")

    write_named_lexicon()
    fill_sros = cartesian_fill_sros()
    fill_sro_set = set(fill_sros)
    docs = build_corpus()
    by_nid = {d["nid"]: d for d in docs}
    fails: list[str] = []

    def chk(cond: bool, msg: str) -> None:
        if not cond:
            fails.append(msg)

    subj_ids = {d["subj_id"] for d in docs if d["evidence"] == 1}
    rel_ids = {d["rel_id"] for d in docs if d["evidence"] == 1}
    chk(N == 16384, "N dropped from registered 16384")
    chk(CAND_CAP < N, "cap>=N")
    chk(N_BUCKETS == 65536, "N_BUCKETS not 65536")
    chk(len(subj_ids) >= 100, f"subj<{100} n={len(subj_ids)}")
    chk(len(rel_ids) >= 8, f"rel<{8} n={len(rel_ids)}")
    psc_clone = [
        d
        for d in docs
        if d["evidence"] == 1
        and d["subj_id"] == 10
        and d["rel_id"] == 1
        and d["obj_id"] == 1
    ]
    chk(len(psc_clone) == 0, f"pump-supplies-chiller clone present n={len(psc_clone)}")
    chk(all((d["ctx_valid"] == 1) == (d["ctx_id"] != 0) for d in docs), "ctx_valid != (ctx_id!=0)")
    chk(all(d["k0_plain"] == pack_plain(d["subj_id"], d["rel_id"]) for d in docs), "k0_plain packing")
    chk(all(d["k1_plain"] == pack_plain(d["obj_id"], d["rel_id"]) for d in docs), "k1_plain packing")
    chk(
        all(d["k0_plain"] == pack_plain(d["subj_id"], d["rel_id"]) and d["k0"] != (d["nid"] << 8) for d in docs),
        "nid-shifted keys",
    )

    fill_ev1 = [d for d in docs if d["kind"] == "fill" and d["evidence"] == 1]
    chk(len(fill_ev1) >= 100, f"fill count too small {len(fill_ev1)}")
    chk(all((d["subj_id"], d["rel_id"], d["obj_id"]) in fill_sro_set for d in fill_ev1), "fill row outside generator")
    chk((UNSEEN_S, UNSEEN_R, UNSEEN_O) not in fill_sro_set, "unseen SRO in fill generator")
    chk((UNBOUND_S, UNBOUND_R, UNBOUND_O) not in fill_sro_set, "unbound SRO in fill generator")
    chk((DIR_S, DIR_R, DIR_O) not in fill_sro_set, "fill-grid SRO in fill generator")
    for sro in PLANTED:
        chk(sro not in fill_sro_set, f"planted {sro} in fill generator")
        chk(sro[0] not in NEW_SUBJ_IDS, f"planted subj in NEW_SUBJ {sro}")
        chk(sro[2] not in NEW_SUBJ_IDS, f"planted obj in NEW_SUBJ {sro}")

    for d in docs:
        if d["kind"] in ("fill", "pad_synth"):
            chk(FILL_RE.match(d["text"]) is not None, f"bulk row not fill template nid={d['nid']}")
            if d["kind"] == "fill":
                chk(d["subj_id"] in NEW_SUBJ_IDS and d["obj_id"] in NEW_SUBJ_IDS, f"fill ent not NEW_SUBJ nid={d['nid']}")

    direct_rows = [d for d in docs if d["evidence"] == 1 and pred_direct(d)]
    chk([d["nid"] for d in direct_rows] == [120, 121, 122], f"fill-grid nids {[d['nid'] for d in direct_rows]}")
    chk(docs[120]["kind"] == "direct_plain" and docs[120]["ctx_id"] == 0, "nid120")
    chk(docs[121]["kind"] == "direct_glycol" and docs[121]["ctx_id"] == CTX_GLYCOL, "nid121")
    chk(docs[122]["kind"] == "direct_steam" and docs[122]["ctx_id"] == CTX_STEAM, "nid122")
    planted_rows = [d for d in docs if d["kind"] == "unseen_sro"]
    chk(len(planted_rows) >= 8, f"planted_n {len(planted_rows)}")
    chk(docs[UNSEEN_NID]["kind"] == "unseen_sro", "unseen kind")
    chk(docs[UNSEEN_NID]["evidence"] == 1, "unseen evidence")
    chk(pred_unseen(docs[UNSEEN_NID]), "unseen SRO bind")
    chk(docs[UNSEEN_NID]["text"] == "chiller supplies condenser", "unseen text")
    chk(not any(pred_unbound(d) for d in docs), "unbound SRO is indexed")
    for i, sro in enumerate(PLANTED):
        row = docs[UNSEEN_NID + i]
        chk(row["kind"] == "unseen_sro", f"plant kind nid={row['nid']}")
        chk((row["subj_id"], row["rel_id"], row["obj_id"]) == sro, f"plant SRO bind nid={row['nid']} {sro}")
        chk(row["evidence"] == 1, f"plant evidence nid={row['nid']}")

    queries_spec = [
        ("fill_template", triple_text(DIR_S, DIR_R, DIR_O), pred_direct),
        ("unseen_sro", triple_text(UNSEEN_S, UNSEEN_R, UNSEEN_O), pred_unseen),
        ("unbound_sro", triple_text(UNBOUND_S, UNBOUND_R, UNBOUND_O), pred_unbound),
        ("unrelated", "payroll tax form", lambda d: False),
    ]

    gold_map = {}
    for name, text, pred in queries_spec:
        ids = gold_ids(docs, pred)
        gold_map[name] = ids
        if len(ids) > MAX_REL:
            fails.append(f"gold too wide {name} n={len(ids)}")

    chk(gold_map["fill_template"] == [120, 121, 122], f"fill gold {gold_map['fill_template']}")
    chk(gold_map["unseen_sro"] == [UNSEEN_NID], f"unseen gold {gold_map['unseen_sro']}")
    chk(gold_map["unbound_sro"] == [], f"unbound gold {gold_map['unbound_sro']}")
    chk(gold_map["unrelated"] == [], "unrelated gold")
    chk(set(gold_map["unseen_sro"]).isdisjoint(set(gold_map["fill_template"])), "unseen overlaps fill-grid")
    chk(all(by_nid[i]["evidence"] == 1 for ids in gold_map.values() for i in ids), "gold evidence")
    chk("pump supplies chiller" not in [t for _, t, _ in queries_spec], "cloned psc query")
    chk(FILL_RE.match(queries_spec[0][1]) is not None, "fill_template control not cartesian")
    chk(FILL_RE.match(queries_spec[1][1]) is not None, "unseen query not SRO surface")
    chk(FILL_RE.match(queries_spec[2][1]) is not None, "unbound query not SRO surface")

    heads, overflow, ovf_flag, post_len = index_docs(docs)

    must_hit = {"fill_template", "unseen_sro"}
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
        met = metrics_of(q["emit"], q["relevant"], by_nid)
        missed = met["missed"]
        incomp = 1 if (q["n_trunc"] > 0 or q.get("search_incomplete_walk")) else 0
        if missed and name in must_hit:
            fails.append(f"GOLD_MISS {name} missed={missed} emit={q['emit']} incomp={incomp}")
        if incomp and name in must_hit and len(q["relevant"]) >= 1:
            fails.append(f"SEARCH_INCOMPLETE {name} gold_n={len(q['relevant'])} emit={q['emit']}")
        q["tp"] = met["tp"]
        q["fp_ev1"] = met["fp_ev1"]
        q["fp_fill0"] = met["fp_fill0"]
        q["prec_ev1"] = met["prec_ev1"]
        q["prec_all"] = met["prec_all"]
        q["recall"] = met["recall"]
        q["search_incomplete"] = incomp
        q["returns_entire_corpus"] = q["n_emit"] >= N
        chk(q["n_emit"] < N, f"{name} emit>=N tautology cap")
        chk(q["n_host"] == 0, f"{name} host")
        queries.append(q)

    qd = {q["name"]: q for q in queries}
    chk(qd["fill_template"]["subj_id"] == DIR_S, "fill subj")
    chk(qd["fill_template"]["rel_id"] == DIR_R, "fill rel")
    chk(qd["fill_template"]["obj_id"] == DIR_O, "fill obj")
    chk(qd["fill_template"]["emit"] == [120, 121, 122], f"fill emit {qd['fill_template']['emit']}")
    chk(qd["fill_template"]["tp"] == 3, "fill tp")
    chk(qd["fill_template"]["search_incomplete"] == 0, "fill SEARCH_INCOMPLETE")
    chk(qd["unseen_sro"]["subj_id"] == UNSEEN_S, "unseen subj")
    chk(qd["unseen_sro"]["rel_id"] == UNSEEN_R, "unseen rel")
    chk(qd["unseen_sro"]["obj_id"] == UNSEEN_O, "unseen obj")
    chk(qd["unseen_sro"]["k0"] != qd["fill_template"]["k0"] or qd["unseen_sro"]["k1"] != qd["fill_template"]["k1"], "unseen keys == fill-grid")
    chk(qd["unseen_sro"]["emit"] == [UNSEEN_NID], f"unseen emit {qd['unseen_sro']['emit']}")
    chk(qd["unseen_sro"]["tp"] == 1, "unseen tp")
    chk(qd["unseen_sro"]["search_incomplete"] == 0, "unseen SEARCH_INCOMPLETE")
    chk(qd["unbound_sro"]["subj_id"] == UNBOUND_S, "unbound subj")
    chk(qd["unbound_sro"]["rel_id"] == UNBOUND_R, "unbound rel")
    chk(qd["unbound_sro"]["obj_id"] == UNBOUND_O, "unbound obj")
    chk(qd["unbound_sro"]["k0"] == qd["fill_template"]["k0"], "unbound k0 should share fill-grid k0")
    chk(qd["unbound_sro"]["k1"] != qd["fill_template"]["k1"], "unbound k1 == fill-grid k1")
    leak = [i for i in qd["unbound_sro"]["emit"] if i in FILL_GRID_NIDS]
    chk(leak == [], f"UNBOUND_FILL_GRID_LEAK emit={qd['unbound_sro']['emit']}")
    chk(qd["unbound_sro"]["n_emit"] == 0, f"unbound emit not empty {qd['unbound_sro']['emit']}")
    chk(qd["unrelated"]["n_emit"] == 0 and qd["unrelated"]["n_dir"] == 0, "unrelated emit")
    chk(qd["unrelated"]["k0_valid"] == 0 and qd["unrelated"]["k1_valid"] == 0, "unrelated valid")
    chk(qd["unrelated"]["prec_all"] is None and qd["unrelated"]["recall"] is None, "unrelated not scored 0/0")
    chk(qd["fill_template"]["n_emit"] <= CAND_CAP, "fill_template cap")

    if fails:
        print("ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_HOST_FAIL")
        for f in fails:
            print("FAIL", f)
        return 2

    writes, mem_depth, max_word = write_index(heads, overflow, ovf_flag)
    n_ovf_buckets = sum(1 for t in range(N_TABLES) for b in range(N_BUCKETS) if ovf_flag[t][b])
    n_occ_ge16 = sum(1 for t in range(N_TABLES) for b in range(N_BUCKETS) if post_len[t][b] >= 16)

    corpus_pub = {
        "gate": GATE,
        "n": N,
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "n_buckets": N_BUCKETS,
        "law": LAW,
        "lexicon_law": LAW_LEX,
        "extract_law_frozen": LAW_EXTRACT,
        "n_subjects": len(subj_ids),
        "n_rels": len(rel_ids),
        "subject_ids": sorted(subj_ids),
        "rel_ids": sorted(rel_ids),
        "fill_ent_ids": list(NEW_SUBJ_IDS),
        "cartesian_fill_sro_n": len(fill_sros),
        "planted_n": len(PLANTED),
        "planted_sros": [list(s) for s in PLANTED],
        "planted_nids": list(range(UNSEEN_NID, UNSEEN_NID + len(PLANTED))),
        "unseen_sro": [UNSEEN_S, UNSEEN_R, UNSEEN_O],
        "unseen_nid": UNSEEN_NID,
        "unbound_sro": [UNBOUND_S, UNBOUND_R, UNBOUND_O],
        "fill_grid_nids": list(FILL_GRID_NIDS),
        "clone_pump_supplies_chiller": 0,
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
                "ctx_valid": d["ctx_valid"],
                "k0": d["k0"],
                "k1": d["k1"],
                "k2": d["k2"],
                "k3": d["k3"],
                "k0_plain": d["k0_plain"],
                "k1_plain": d["k1_plain"],
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
            "ctx_valid": q["ctx_valid"],
            "k0": q["k0"],
            "k1": q["k1"],
            "k2": q["k2"],
            "k3": q["k3"],
            "k0_plain": q["k0_plain"],
            "k1_plain": q["k1_plain"],
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
            "rare_first": q.get("rare_first"),
            "fill_template_surface": FILL_RE.match(q["text"]) is not None,
        }
        if q["name"] == "unseen_sro":
            row["UNSEEN_SRO_HIT"] = UNSEEN_NID in q["emit"]
            row["sro_in_cartesian_fill"] = False
        if q["name"] == "unbound_sro":
            row["UNBOUND_EMPTY_WALK"] = q["n_emit"] == 0
            row["fill_grid_leak"] = [i for i in q["emit"] if i in FILL_GRID_NIDS]
            row["shares_k0_with_fill_grid"] = True
        if q["name"] == "unrelated":
            row["UNRELATED_EMPTY_WALK"] = q["n_emit"] == 0
        if q["name"] == "fill_template":
            row["FILL_TEMPLATE_HIT"] = q["tp"] > 0
            row["fill_grid"] = list(FILL_GRID_NIDS)
        return row

    golden = {
        "gate": GATE,
        "law": LAW,
        "lexicon_law": LAW_LEX,
        "extract_law_frozen": LAW_EXTRACT,
        "law_control_not_used": LAW_V1,
        "key_rebind": "instantiate a7ng_query_role_keys_ctx 124be808; walker=context wrapper 8255a798 STREAM-02 two-pointer; k2k3_not_probed",
        "intersect_law": "sorted-nid two-pointer AND; 1-beat page; rare-first; CAND_CAP after emit; ctx folded into k0/k1 when ctx_valid",
        "n": N,
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "n_buckets": N_BUCKETS,
        "mem_depth": mem_depth,
        "max_word": max_word,
        "merge_post_ar_max": MERGE_POST_AR_MAX,
        "n_host": 0,
        "n_subjects": len(subj_ids),
        "n_rels": len(rel_ids),
        "gold_source": "independent_labels_before_router",
        "relevant_is_router_union": False,
        "cap_ge_n_used_as_selectivity": False,
        "twelve_entity_clone": False,
        "index_fill_template": "{ent} {rel} {ent} over NEW_SUBJ_IDS={13..132}",
        "planted_n": len(PLANTED),
        "planted_sros": [list(s) for s in PLANTED],
        "planted_nids": list(range(UNSEEN_NID, UNSEEN_NID + len(PLANTED))),
        "unseen_sro_text": triple_text(UNSEEN_S, UNSEEN_R, UNSEEN_O),
        "unseen_sro": [UNSEEN_S, UNSEEN_R, UNSEEN_O],
        "unseen_nid": UNSEEN_NID,
        "unbound_sro_text": triple_text(UNBOUND_S, UNBOUND_R, UNBOUND_O),
        "unbound_sro": [UNBOUND_S, UNBOUND_R, UNBOUND_O],
        "fill_template_control_text": triple_text(DIR_S, DIR_R, DIR_O),
        "fill_grid_nids": list(FILL_GRID_NIDS),
        "g_bytes_layout": "lsb_first_char0_at_bits7_0",
        "reduction_x1000_emitted": False,
        "overflow_buckets": n_ovf_buckets,
        "high_occupancy_buckets_ge16": n_occ_ge16,
        "n_index_writes": len(writes),
        "CAND_CAP_FINAL": "NOT_FROZEN",
        "DDR_QUERY_BOUND_FINAL": "NOT_FROZEN",
        "C1_800K": "OPEN",
        "BOARD_PASS": "NOT_CLAIMED",
        "queries": [qpub(q) for q in queries],
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    write_svh(
        BAG / "query_gold.svh",
        queries,
        writes,
        docs,
        mem_depth,
        len(subj_ids),
        len(rel_ids),
    )

    gsha = sha256_file(BAG / "GOLDEN.json")
    ssha = sha256_file(BAG / "query_gold.svh")
    csha = sha256_file(BAG / "corpus.json")
    lsha = sha256_file(BAG / "qse_role_lexicon_semantic_16k.svh")
    (BAG / "GOLD_HASH_PRE_XVLOG.txt").write_text(
        "\n".join(
            [
                "# independent gold hashed BEFORE first xvlog — do not regenerate after FAIL",
                f"{gsha}  GOLDEN.json",
                f"{ssha}  query_gold.svh",
                f"{csha}  corpus.json",
                f"{lsha}  qse_role_lexicon_semantic_16k.svh",
                "",
            ]
        ),
        encoding="utf-8",
    )

    print("ASTRA_C1_SEMANTIC_UNSEEN_SRO_16K_HOST_PASS")
    print("N", N, "CAND_CAP", CAND_CAP, "N_BUCKETS", N_BUCKETS, "WRITES", len(writes), "MEM_DEPTH", mem_depth, "MAX_WORD", max_word)
    print("N_SUBJECTS", len(subj_ids), "N_RELS", len(rel_ids), "LEX_N", len(role_lexicon.LEX))
    print("FILL_SRO_N", len(fill_sros), "PLANTED_N", len(PLANTED), "UNSEEN_NID", UNSEEN_NID, "FILL_GRID", list(FILL_GRID_NIDS))
    print("GOLD_SHA", gsha)
    print("SVH_SHA", ssha)
    print("CORPUS_SHA", csha)
    print("LEX_SHA", lsha)
    for q in queries:
        pe = "NA" if q["prec_ev1"] is None else f"{q['prec_ev1']:.3f}"
        pa = "NA" if q["prec_all"] is None else f"{q['prec_all']:.3f}"
        rr = "NA" if q["recall"] is None else f"{q['recall']:.3f}"
        extra = ""
        if q["name"] == "unseen_sro":
            extra = " UNSEEN_SRO_HIT"
        if q["name"] == "unbound_sro":
            extra = " UNBOUND_EMPTY_WALK"
        if q["name"] == "unrelated":
            extra = " UNRELATED_EMPTY_WALK"
        if q["name"] == "fill_template":
            extra = " FILL_TEMPLATE_HIT"
        print(
            f"Q {q['name']} text={q['text']!r} gold={q['relevant']} emit={q['emit']} "
            f"gold_n={len(q['relevant'])} emit_n={q['n_emit']} tp={q['tp']} "
            f"fp_ev1={q['fp_ev1']} fp_fill0={q['fp_fill0']} prec_ev1={pe} prec_all={pa} rec={rr} "
            f"k0={q['k0']} k1={q['k1']} ctx={q['ctx_id']} ctx_valid={q['ctx_valid']} "
            f"occ={q['occupancies']} ovf={q['overflow_flag']} trunc={q['n_trunc']} "
            f"incomp={q['search_incomplete']}{extra}"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
