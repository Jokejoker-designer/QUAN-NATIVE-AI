#!/usr/bin/env python3
"""ASTRA-C1-SEMANTIC-HELDOUT-01 independent host gold.

ONE UNKNOWN: held-out gold queries whose surface form is NOT the cartesian
index fill template `{ent} {rel} {ent}` used to build the N=16384 index,
yet independent labeled nids still retrieve; plus a fill-template control
that still hits. Instantiate ctx keys 124be808 + DUT 8255a798 not edited.
Named lexicon law qse-v2-lex-semantic-16k-01 (copied SHA df0e8833; do not
edit C0 38189974). leftover A09 off poke_v=0 PROGRAM=NO.

Index fill stays the SEMANTIC-16K cartesian generator. Gold queries for
paraphrase / role-reversal / wrong-relation / wrong-context / occupancy
/ overflow / sentinel / late-gold are skip-word + morphological forms
that frozen extract still binds to the same SRO. SEARCH_INCOMPLETE on
gold_n>=1 retrieve = FAIL. C1 800k stays OPEN. BOARD_PASS not claimed.
Do not edit KEEP bags. Do not write independent audit tree.
G_BYTES: LSB-first (char0 at bits[7:0]) matching TB bytes[8*bi +: 8].
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

GATE = "ASTRA-C1-SEMANTIC-HELDOUT-01"
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
EPOCH = 7
MAX_REL = 16
MAX_EMIT = 16
MERGE_POST_AR_MAX = 256
LATE_K0_N = 16
LATE_K1_N = 16
HOC_SYNTH_N = 15
HOC_K0_EXTRA = 8

# Direct plant: NEW entities/rel (not pump supplies chiller).
DIR_S, DIR_R, DIR_O = 13, 4, 14  # boiler feeds header
REV_S, REV_R, REV_O = 14, 4, 13
WREL_S, WREL_R, WREL_O = 13, 5, 14  # boiler isolates header
HOC_S, HOC_R, HOC_O = 17, 7, 18  # damper modulates grille
OVF_S, OVF_R, OVF_O = 21, 6, 20  # strainer bypasses riser
LATE_S, LATE_R, LATE_O = 131, 8, 132  # cyclone discharges beacon
LATE_K0_O = 128  # blender
LATE_K1_S = 130  # agitator
SEN_S, SEN_R, SEN_O = 93, 5, 94  # hopper isolates silo
CTX_GLYCOL = 3
CTX_STEAM = 4

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
CTXW = {3: "glycol", 4: "steam"}

NEW_SUBJ_IDS = list(range(13, 13 + len(NEW_ENT)))
FILL_RE = re.compile(r"^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$")
HELD_QUERY_NAMES = (
    "paraphrase",
    "role_reversal",
    "wrong_relation",
    "wrong_context",
    "high_occupancy",
    "overflow_page",
    "high_id_sentinel",
    "late_gold",
)


def pack_plain(sid: int, rid: int) -> int:
    return ((sid & 0xFF) << 8) | (rid & 0xFF)


def pack_ctx(sid: int, rid: int, xid: int) -> int:
    return ((sid & 0xFF) << 8) | ((xid & 0xF) << 4) | (rid & 0xF)


def pack_lex_word(w: str) -> int:
    b = w.encode("ascii")
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


EXPECTED_LEX_NAMED = "df0e8833ff9664cd4e21a6aa6d3d223112c8d6733871d6398b133e37296e1aa4"
EXPECTED_LEX_SHIM = "7966f321171cfe97b396ad90bb1ebd156c09a165782df40a3a98109ee59ac263"


def sha256_bytes(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def write_named_lexicon() -> None:
    # KEEP named semantic-16k law bytes (copied; do not rewrite header to this bag).
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


def build_corpus() -> list[dict]:
    docs: list[dict] = []
    used: set[tuple[int, int, int]] = set()
    late_n = LATE_K0_N + LATE_K1_N + 1
    fill_lim = N - 1 - late_n

    def add(text: str, evidence: int, kind: str, sro: tuple[int, int, int] | None = None) -> dict:
        if len(docs) >= N:
            raise SystemExit("corpus overflow before N")
        nid = len(docs)
        row = rec_of(nid, text, evidence, kind)
        if sro is not None:
            used.add(sro)
        docs.append(row)
        return row

    reserved = {
        (DIR_S, DIR_R, DIR_O),
        (REV_S, REV_R, REV_O),
        (WREL_S, WREL_R, WREL_O),
        (HOC_S, HOC_R, HOC_O),
        (OVF_S, OVF_R, OVF_O),
        (LATE_S, LATE_R, LATE_O),
        (LATE_S, LATE_R, LATE_K0_O),
        (LATE_K1_S, LATE_R, LATE_O),
        (SEN_S, SEN_R, SEN_O),
    }

    for i, s in enumerate(NEW_SUBJ_IDS):
        r = 1 + (i % 8)
        o = 13 + ((i + 17) % len(NEW_ENT))
        if o == s:
            o = 13 + ((i + 18) % len(NEW_ENT))
        sro = (s, r, o)
        if sro in reserved:
            o = 13 + ((i + 23) % len(NEW_ENT))
            if o == s:
                o = 13 + ((i + 29) % len(NEW_ENT))
            sro = (s, r, o)
        if sro in reserved:
            raise SystemExit(f"core sro still reserved {sro}")
        add(triple_text(s, r, o), 1, "semantic_core", sro)

    add(triple_text(DIR_S, DIR_R, DIR_O), 1, "direct_plain", (DIR_S, DIR_R, DIR_O))
    add(triple_text(DIR_S, DIR_R, DIR_O, "glycol"), 1, "direct_glycol", (DIR_S, DIR_R, DIR_O))
    add(triple_text(DIR_S, DIR_R, DIR_O, "steam"), 1, "direct_steam", (DIR_S, DIR_R, DIR_O))
    add(triple_text(REV_S, REV_R, REV_O), 1, "role_reverse", (REV_S, REV_R, REV_O))
    add(triple_text(WREL_S, WREL_R, WREL_O), 1, "wrong_rel", (WREL_S, WREL_R, WREL_O))
    add(triple_text(HOC_S, HOC_R, HOC_O), 1, "high_occ_gold", (HOC_S, HOC_R, HOC_O))
    hoc_txt = triple_text(HOC_S, HOC_R, HOC_O)
    for _ in range(HOC_SYNTH_N):
        add(hoc_txt, 0, "high_occ_synth")
    hoc_extra_objs = [15, 16, 19, 22, 23, 24, 25, 26]
    if len(hoc_extra_objs) != HOC_K0_EXTRA:
        raise SystemExit("hoc extra count")
    for o in hoc_extra_objs:
        add(triple_text(HOC_S, HOC_R, o), 0, "high_occ_k0_extra")
    ovf_txt = triple_text(OVF_S, OVF_R, OVF_O)
    for _ in range(INDEX_HEAD):
        add(ovf_txt, 0, "ovf_synth")
    add(ovf_txt, 1, "ovf_gold", (OVF_S, OVF_R, OVF_O))

    for s in NEW_SUBJ_IDS:
        for r in range(1, 9):
            for o in NEW_SUBJ_IDS:
                if s == o:
                    continue
                sro = (s, r, o)
                if sro in used or sro in reserved:
                    continue
                if len(docs) >= fill_lim:
                    break
                add(triple_text(s, r, o), 1, "fill", sro)
            if len(docs) >= fill_lim:
                break
        if len(docs) >= fill_lim:
            break

    fi = 0
    pad_src = [(s, r, o) for s in NEW_SUBJ_IDS for r in range(1, 9) for o in NEW_SUBJ_IDS if s != o]
    if not pad_src:
        raise SystemExit("no pad fillers")
    while len(docs) < fill_lim:
        s, r, o = pad_src[fi % len(pad_src)]
        add(triple_text(s, r, o), 0, "pad_synth")
        fi += 1
    if len(docs) != fill_lim:
        raise SystemExit(f"fill stop {len(docs)} want {fill_lim}")

    k0_txt = triple_text(LATE_S, LATE_R, LATE_K0_O)
    for _ in range(LATE_K0_N):
        add(k0_txt, 0, "late_k0_fill")
    k1_txt = triple_text(LATE_K1_S, LATE_R, LATE_O)
    for _ in range(LATE_K1_N):
        add(k1_txt, 0, "late_k1_fill")
    add(triple_text(LATE_S, LATE_R, LATE_O), 1, "late_gold", (LATE_S, LATE_R, LATE_O))
    add(triple_text(SEN_S, SEN_R, SEN_O), 1, "high_id_sentinel", (SEN_S, SEN_R, SEN_O))
    if len(docs) != N:
        raise SystemExit(f"corpus N={len(docs)} want {N}")
    if docs[-1]["nid"] != N - 1:
        raise SystemExit(f"high-id sentinel is not nid {N - 1}")
    return docs


def gold_ids(docs: list[dict], pred) -> list[int]:
    return [d["nid"] for d in docs if d["evidence"] == 1 and pred(d)]


def pred_direct(d: dict) -> bool:
    return d["subj_id"] == DIR_S and d["rel_id"] == DIR_R and d["obj_id"] == DIR_O


def pred_excl(d: dict) -> bool:
    if pred_direct(d):
        return False
    wo = d["subj_id"] == DIR_S and d["rel_id"] == DIR_R and d["obj_id"] != DIR_O
    wr = d["subj_id"] == DIR_S and d["rel_id"] != DIR_R and d["obj_id"] == DIR_O
    we = d["subj_id"] != DIR_S and d["rel_id"] == DIR_R and d["obj_id"] == DIR_O
    return wo or wr or we


def pred_late(d: dict) -> bool:
    return d["subj_id"] == LATE_S and d["rel_id"] == LATE_R and d["obj_id"] == LATE_O


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
    idx0: int,
    idx1: int,
) -> None:
    n = len(queries)
    nwr = len(writes)
    wr_i = sorted(writes)
    ev = [d["evidence"] for d in docs]
    late_i = next(i for i, q in enumerate(queries) if q["name"] == "late_gold")
    late_id = queries[late_i]["relevant"][0]
    lines = [
        "// generated by host_astra_c1_semantic_heldout.py — independent gold BEFORE xvlog. do not hand-edit after FAIL",
        f"// Law {LAW} + named lexicon {LAW_LEX}; STREAM-02 walker in context wrapper; N=16384 held-out queries",
        "// G_BYTES LSB-first: char0 at [7:0]; TB must use bytes[8*bi +: 8]",
        "// G_GOLD_EXCLUDED=1 => G_RELEVANT is the EXCLUDED set (leak=FAIL), not retrieve gold",
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
        f"localparam int unsigned G_LATE_Q = {late_i};",
        f"localparam int unsigned G_SENTINEL_ID = {N - 1};",
        f"localparam int unsigned G_LATE_K0_IDX = {idx0};",
        f"localparam int unsigned G_LATE_K1_IDX = {idx1};",
        f"localparam logic [19:0] G_LATE_GOLD_ID = 20'd{late_id};",
        "localparam logic [27:0] G_POST_HEAP = 28'h05400000;",
        "localparam logic [27:0] G_DIR_LO = 28'h05000000;",
        "localparam logic [27:0] G_DIR_HI = 28'h053FFFF0;",
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
        + csv_int([1 if q["name"] == "distractor" else 0 for q in queries], str)
        + "};",
        "localparam int G_EXPECT_INCOMP [0:G_NQ-1] = '{"
        + csv_int([q["search_incomplete"] for q in queries], str)
        + "};",
        "localparam logic G_CAP_THEN_AND_MISS [0:G_NQ-1] = '{"
        + csv_int([1 if q.get("cap_then_and_miss") else 0 for q in queries], str)
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

    write_named_lexicon()
    docs = build_corpus()
    by_nid = {d["nid"]: d for d in docs}
    fails: list[str] = []

    def chk(cond: bool, msg: str) -> None:
        if not cond:
            fails.append(msg)

    subj_ids = {d["subj_id"] for d in docs if d["evidence"] == 1}
    rel_ids = {d["rel_id"] for d in docs if d["evidence"] == 1}
    chk(len(subj_ids) >= 100, f"subj mass {len(subj_ids)} < 100")
    chk(len(rel_ids) >= 8, f"rel mass {len(rel_ids)} < 8")
    chk(N == 16384, "N dropped")
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
        all(
            (d["k0"] == pack_ctx(d["subj_id"], d["rel_id"], d["ctx_id"]) if d["ctx_valid"] else d["k0"] == d["k0_plain"])
            for d in docs
        ),
        "k0 not ctx-fold packing",
    )
    chk(
        all(
            (d["k1"] == pack_ctx(d["obj_id"], d["rel_id"], d["ctx_id"]) if d["ctx_valid"] else d["k1"] == d["k1_plain"])
            for d in docs
        ),
        "k1 not ctx-fold packing",
    )
    n_k_eq_nid = sum(1 for d in docs if d["k0"] == d["nid"] or d["k1"] == d["nid"])
    chk(
        all(d["k0_plain"] == pack_plain(d["subj_id"], d["rel_id"]) and d["k0"] != (d["nid"] << 8) for d in docs),
        "nid-shifted keys",
    )

    for d in docs:
        if d["subj_id"] != 0 and d["rel_id"] != 0:
            chk(d["k0_valid"] == 1, f"k0_valid nid={d['nid']}")
        if d["kind"] in ("semantic_core", "direct_plain", "late_gold", "high_id_sentinel"):
            chk(d["subj_id"] == feat(d["text"])["subj_id"], f"extract mismatch {d['nid']}")

    direct_rows = [d for d in docs if d["evidence"] == 1 and pred_direct(d)]
    chk(len(direct_rows) == 3, f"direct evidence count {len(direct_rows)}")
    chk(any(d["ctx_id"] == 0 for d in direct_rows), "direct ctx0")
    chk(any(d["ctx_id"] == CTX_GLYCOL for d in direct_rows), "direct glycol")
    chk(any(d["ctx_id"] == CTX_STEAM for d in direct_rows), "direct steam")
    chk(docs[N - 1]["kind"] == "high_id_sentinel", "sentinel kind")
    chk(docs[N - 1]["evidence"] == 1, "sentinel evidence")
    ovf_gold = [d for d in docs if d["kind"] == "ovf_gold"]
    chk(len(ovf_gold) == 1, "one ovf gold")
    hoc_gold = [d for d in docs if d["kind"] == "high_occ_gold"]
    chk(len(hoc_gold) == 1, "one high-occ gold")
    late_gold = [d for d in docs if d["kind"] == "late_gold"]
    chk(len(late_gold) == 1, "one late gold")

    queries_spec = [
        ("fill_template", triple_text(DIR_S, DIR_R, DIR_O), pred_direct),
        ("paraphrase", "what does the boiler feed to the header", pred_direct),
        ("role_reversal", "what does the header feed to the boiler", lambda d: d["subj_id"] == REV_S and d["rel_id"] == REV_R and d["obj_id"] == REV_O),
        ("wrong_relation", "does the boiler isolates the header", lambda d: d["subj_id"] == WREL_S and d["rel_id"] == WREL_R and d["obj_id"] == WREL_O),
        ("wrong_context", "does the boiler feed the header glycol", lambda d: pred_direct(d) and d["ctx_id"] == CTX_GLYCOL),
        ("distractor", triple_text(DIR_S, DIR_R, DIR_O), pred_excl),
        ("unrelated", "payroll tax form", lambda d: False),
        ("high_occupancy", "does the damper modulates the grille", lambda d: d["subj_id"] == HOC_S and d["rel_id"] == HOC_R and d["obj_id"] == HOC_O),
        ("overflow_page", "does the strainer bypasses the riser", lambda d: d["subj_id"] == OVF_S and d["rel_id"] == OVF_R and d["obj_id"] == OVF_O),
        ("high_id_sentinel", "does the hopper isolates the silo", lambda d: d["nid"] == N - 1),
        ("late_gold", "does the cyclone discharges the beacon", pred_late),
    ]

    gold_map = {}
    for name, text, pred in queries_spec:
        ids = gold_ids(docs, pred)
        if name == "distractor" and len(ids) > MAX_REL:
            ids = ids[:MAX_REL]
        gold_map[name] = ids
        if len(gold_map[name]) > MAX_REL:
            fails.append(f"gold too wide {name} n={len(gold_map[name])}")

    chk(set(gold_map["fill_template"]) != set(gold_map["role_reversal"]), "fill/reverse gold overlap")
    chk(set(gold_map["fill_template"]) != set(gold_map["wrong_relation"]), "fill/wrongrel gold overlap")
    chk(gold_map["wrong_context"] and set(gold_map["wrong_context"]).issubset(set(gold_map["fill_template"])), "ctx subset")
    chk(len(gold_map["wrong_context"]) == 1, "wrong_context singleton")
    chk(gold_map["unrelated"] == [], "unrelated gold")
    chk(len(gold_map["distractor"]) >= 1, "distractor gold_n>=1")
    chk((N - 1) in gold_map["high_id_sentinel"], "sentinel gold")
    chk(ovf_gold[0]["nid"] in gold_map["overflow_page"], "ovf gold id")
    chk(hoc_gold[0]["nid"] in gold_map["high_occupancy"], "hoc gold id")
    chk(late_gold[0]["nid"] in gold_map["late_gold"], "late gold id")
    chk(len(gold_map["fill_template"]) >= 1, "fill_template gold empty")
    chk(gold_map["paraphrase"] == gold_map["fill_template"], "paraphrase labels != fill_template")
    chk(all(by_nid[i]["evidence"] == 1 for ids in gold_map.values() for i in ids), "gold evidence")
    chk(set(gold_map["fill_template"]).isdisjoint(set(gold_map["distractor"])), "excluded contains fill")
    chk("pump supplies chiller" not in [t for _, t, _ in queries_spec], "cloned psc query")
    chk(all(FILL_RE.match(d["text"]) is not None for d in docs), "index row not fill template")
    for name, text, _pred in queries_spec:
        if name in HELD_QUERY_NAMES:
            chk(FILL_RE.match(text) is None, f"{name} still fill template {text!r}")
            chk(len(text.split()) >= 6, f"{name} too short to be held-out {text!r}")
        if name == "fill_template":
            chk(FILL_RE.match(text) is not None, f"fill_template control not cartesian {text!r}")

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

    hq = feat(triple_text(HOC_S, HOC_R, HOC_O))
    hoc_occ = post_len[0][hq["k0"] & BUCKET_MASK] if hq["k0_valid"] else 0
    chk(hoc_occ > CAND_CAP, f"high occupancy {hoc_occ} not > CAND_CAP")
    chk(CAND_CAP < N, "cap>=N")

    must_hit = {
        "fill_template",
        "paraphrase",
        "role_reversal",
        "wrong_relation",
        "wrong_context",
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
            if incomp and name in must_hit and len(q["relevant"]) >= 1:
                fails.append(f"SEARCH_INCOMPLETE {name} gold_n={len(q['relevant'])} emit={q['emit']}")
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
    chk(qd["paraphrase"]["k0"] == qd["fill_template"]["k0"] and qd["paraphrase"]["k1"] == qd["fill_template"]["k1"], "para keys")
    chk(qd["paraphrase"]["subj_id"] == qd["fill_template"]["subj_id"], "para subj")
    chk(qd["paraphrase"]["rel_id"] == qd["fill_template"]["rel_id"], "para rel")
    chk(qd["paraphrase"]["obj_id"] == qd["fill_template"]["obj_id"], "para obj")
    chk(qd["paraphrase"]["emit"] == qd["fill_template"]["emit"], "para emit != fill_template control")
    chk(qd["paraphrase"]["tp"] > 0, "paraphrase gold hits==0")
    chk(qd["role_reversal"]["subj_id"] == qd["fill_template"]["obj_id"], "reverse swap")
    chk(qd["role_reversal"]["obj_id"] == qd["fill_template"]["subj_id"], "reverse swap2")
    chk(qd["fill_template"]["ctx_id"] == 0 and qd["fill_template"]["ctx_valid"] == 0, "fill_template ctx unbound")
    chk(qd["fill_template"]["k0"] == qd["fill_template"]["k0_plain"], "fill_template k0 not plain")
    chk(qd["unrelated"]["n_emit"] == 0 and qd["unrelated"]["n_dir"] == 0, "unrelated emit")
    chk(qd["unrelated"]["k0_valid"] == 0 and qd["unrelated"]["k1_valid"] == 0, "unrelated valid")
    chk(qd["unrelated"]["prec_all"] is None and qd["unrelated"]["recall"] is None, "unrelated not scored 0/0")
    chk(qd["overflow_page"]["overflow_flag"] == 1, "ovf flag")
    chk(qd["high_occupancy"]["occupancies"] and max(qd["high_occupancy"]["occupancies"]) > CAND_CAP, "hoc occ")
    chk(qd["fill_template"]["n_emit"] <= CAND_CAP, "fill_template cap")
    chk(qd["fill_template"]["tp"] > 0, "fill_template gold hits==0")
    chk(qd["late_gold"]["tp"] == 1, "late_gold tp")
    chk(lg["nid"] in qd["late_gold"]["emit"], "late_gold not in emit")
    chk(qd["late_gold"]["cap_then_and_miss"], "late_gold cap-then-AND did not miss")
    chk(qd["late_gold"]["search_incomplete"] == 0, "late_gold SEARCH_INCOMPLETE")
    chk(qd["distractor"]["tp"] == 0, "distractor tp must be 0")
    chk(qd["distractor"]["recall"] is None, "distractor rec must be undef")
    chk(set(qd["fill_template"]["emit"]).isdisjoint(set(qd["distractor"]["relevant"])), "fill emit contains excluded")

    wc = qd["wrong_context"]
    dd = qd["fill_template"]
    chk(wc["ctx_id"] == CTX_GLYCOL, "wrong_context ctx_id")
    chk(wc["ctx_valid"] == 1, "wrong_context ctx_valid")
    chk(wc["ctx_bind"] == 1, "wrong_context extract xh")
    chk(wc["k0"] != dd["k0"] or wc["k1"] != dd["k1"], "NOT_SELECTIVE keys still match")
    chk(wc["k0"] != wc["k0_plain"], "wrong_context k0 not folded")
    chk(wc["emit"] != dd["emit"], "NOT_SELECTIVE emit still == direct")
    chk(wc["tp"] == 1, "wrong_context tp")
    chk(set(wc["emit"]).issubset(set(gold_map["wrong_context"]) | set(wc["emit"])), "wc emit")

    not_selective = (wc["k0"] == dd["k0"] and wc["k1"] == dd["k1"] and wc["emit"] == dd["emit"])

    if fails:
        print("ASTRA_C1_SEMANTIC_HELDOUT_HOST_FAIL")
        for f in fails:
            print("FAIL", f)
        if not_selective:
            print("NOT_SELECTIVE lexicon/extract cannot bind distinguishable ctx; do not fake nid keys")
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
        "late_gold_nid": lg["nid"],
        "late_gold_k0_index": idx0,
        "late_gold_k1_index": idx1,
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
            "cap_then_and": q.get("cap_then_and"),
            "cap_then_and_miss": q.get("cap_then_and_miss"),
            "rare_first": q.get("rare_first"),
            "fill_template_surface": FILL_RE.match(q["text"]) is not None,
            "held_out_surface": q["name"] in HELD_QUERY_NAMES,
        }
        if q["name"] == "wrong_context":
            row["NOT_SELECTIVE"] = False
            row["CONTEXT_SELECTIVE"] = True
            row["keys_match_direct"] = False
            row["emit_match_direct"] = q["emit"] == dd["emit"]
            row["frozen_law"] = "k0k1_fold_ctx_when_ctx_valid"
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
        "index_fill_template": "{ent} {rel} {ent}",
        "held_out_query_surface": True,
        "fill_template_control_text": triple_text(DIR_S, DIR_R, DIR_O),
        "paraphrase_text": "what does the boiler feed to the header",
        "g_bytes_layout": "lsb_first_char0_at_bits7_0",
        "reduction_x1000_emitted": False,
        "overflow_buckets": n_ovf_buckets,
        "high_occupancy_buckets_ge16": n_occ_ge16,
        "n_index_writes": len(writes),
        "wrong_context_policy": "CONTEXT_SELECTIVE qse-v2-intersect-context-02 fold ctx into k0/k1 when ctx_valid; host dual-indexes plain+ctx",
        "distractor_gold_polarity": "excluded",
        "late_gold_nid": lg["nid"],
        "late_gold_k0_index": idx0,
        "late_gold_k1_index": idx1,
        "late_gold_cap_then_and_miss": True,
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
        idx0,
        idx1,
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

    print("ASTRA_C1_SEMANTIC_HELDOUT_HOST_PASS")
    print("N", N, "CAND_CAP", CAND_CAP, "N_BUCKETS", N_BUCKETS, "WRITES", len(writes), "MEM_DEPTH", mem_depth, "MAX_WORD", max_word)
    print("N_SUBJECTS", len(subj_ids), "N_RELS", len(rel_ids), "LEX_N", len(role_lexicon.LEX))
    print("OVF_BUCKETS", n_ovf_buckets, "OCC_GE16", n_occ_ge16)
    print("LATE_GOLD_NID", lg["nid"], "K0_IDX", idx0, "K1_IDX", idx1)
    print("FILL_TEMPLATE", qd["fill_template"]["text"], "EMIT", qd["fill_template"]["emit"], "TP", qd["fill_template"]["tp"])
    print("PARAPHRASE", qd["paraphrase"]["text"], "EMIT", qd["paraphrase"]["emit"], "TP", qd["paraphrase"]["tp"])
    print("WC_K0", wc["k0"], "FILL_K0", dd["k0"], "WC_EMIT", wc["emit"], "FILL_EMIT", dd["emit"])
    print("GOLD_SHA", gsha)
    print("SVH_SHA", ssha)
    print("CORPUS_SHA", csha)
    print("LEX_SHA", lsha)
    for q in queries:
        pe = "NA" if q["prec_ev1"] is None else f"{q['prec_ev1']:.3f}"
        pa = "NA" if q["prec_all"] is None else f"{q['prec_all']:.3f}"
        rr = "NA" if q["recall"] is None else f"{q['recall']:.3f}"
        extra = ""
        if q["name"] == "wrong_context":
            extra = " CONTEXT_SELECTIVE"
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
            f"k0={q['k0']} k1={q['k1']} ctx={q['ctx_id']} ctx_valid={q['ctx_valid']} "
            f"occ={q['occupancies']} ovf={q['overflow_flag']} trunc={q['n_trunc']} "
            f"incomp={q['search_incomplete']}{extra}"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
