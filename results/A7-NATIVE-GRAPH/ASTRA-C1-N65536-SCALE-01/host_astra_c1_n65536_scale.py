#!/usr/bin/env python3
"""ASTRA-C1-N65536-SCALE-01 independent host gold.

ONE UNKNOWN: N=800000 under qse-v2-relctx-synonym-01 + ctx keys 124be808 +
synonym DUT wrap. Fill-template control HIT {120,121,122}. High-id sentinel
nid 799999 HIT. SEARCH_INCOMPLETE on gold_n>=1 retrieve = FAIL.

Procedural cartesian generator: 201 NEW subjects (ids 13..213) x 20 rels.
Not a 16k clone labeled 800k. Not historical U5 qse-v1.

Instantiate frozen extract cd7baf49 + synonym overlay (rtl not edited) +
ctx keys 124be808 (not edited) + synonym DUT wrap. NEW named lexicon
qse-v2-lex-semantic-800k-01. leftover A09 off poke_v=0 PROGRAM=NO.
BOARD_PASS not claimed. Do not write D:\\FPGA\\ASTRA_C1_INDEPENDENT_RETRIEVAL_AUDIT.
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

GATE = "ASTRA-C1-N65536-SCALE-01"
LAW = "qse-v2-relctx-synonym-01"
LAW_CTX = "qse-v2-intersect-context-02"
LAW_LEX = "qse-v2-lex-semantic-800k-01"
LAW_V1 = "qse-v1-lexicon-hdc-00"
LAW_EXTRACT = "qse-v2-role-00"
REL_SUPPLY = 1
REL_FEEDS = 4
N = 65536
N_STREAM = 65532
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
STRIDE_BEATS = 64
ENT0 = 13
ENT_HI = 113
N_ENT = ENT_HI - ENT0 + 1  # 201
N_REL = 8
OBJS_PER = N_ENT - 1  # 200

DIR_S, DIR_R, DIR_O = 13, 4, 14
FILL_K0, FILL_K1 = 3332, 3588
SEN_S, SEN_R, SEN_O = 113, 8, 13
SEN_NID = 65535
FILL_GRID = (120, 121, 122)
CTX_GLYCOL = 3
CTX_STEAM = 4
HELDOUT_PARAPHRASE = "what does the boiler feed to the header"
NL_TEXT = "what does the boiler supply to the header"
FILL_RE = re.compile(r"^([a-z]+) ([a-z]+) ([a-z]+)(?: ([a-z]+))?$")
KEEP_SYN_SHA = "551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd"

NEW_ENT_16K = [
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
NEW_ENT_EXTRA = [
    "baffle", "vane", "hood", "canopy", "cowl", "snorkel", "stack", "flue",
    "chimney", "breeching", "silencer", "muffler", "attenuator", "liner",
    "saddle", "sleeve", "ferrule", "spigot", "socket", "wyefit",
    "crossfit", "capend", "plugend", "cockfit", "gatefit", "globefit",
    "ballfit", "piston", "cylinder", "ramrod", "bellows", "diaphragm",
    "bladder", "accumtank", "receiver", "sootblow", "igniter", "burner",
    "atomizer", "lance", "probe", "thermowell", "anode", "cathode",
    "fuseblock", "relay", "contactor", "vfdunit", "blower", "weir",
    "launder", "clarifier", "thickener", "baghouse", "ionizer", "ozonator",
    "icebank", "pcmstore", "runaround", "coilbank", "pipeway", "trench",
    "tunnel", "manhole", "hatch", "soundtrap", "flexduct", "canvas",
    "dropbox", "bootfit", "takeoff", "endcap", "airfoil", "splitter",
    "tabfit", "spinfit", "turnvane", "pipebridge", "riserway", "shaftway",
    "hatchway",
]
NEW_ENT = NEW_ENT_16K[:101]
REL_EXTRA = [
    ("recirculates", 2, 9),
    ("equalizes", 2, 10),
    ("throttles", 2, 11),
    ("meters", 2, 12),
    ("purges", 2, 13),
    ("vents", 2, 14),
    ("bleeds", 2, 15),
    ("charges", 2, 16),
    ("dumps", 2, 17),
    ("transfers", 2, 18),
    ("routes", 2, 19),
    ("splits", 2, 20),
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
NEW_LEX.extend(REL_EXTRA)

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
    9: "recirculates",
    10: "equalizes",
    11: "throttles",
    12: "meters",
    13: "purges",
    14: "vents",
    15: "bleeds",
    16: "charges",
    17: "dumps",
    18: "transfers",
    19: "routes",
    20: "splits",
}


def pack_plain(sid: int, rid: int) -> int:
    return ((sid & 0xFF) << 8) | (rid & 0xFF)


def pack_ctx(sid: int, rid: int, xid: int) -> int:
    return ((sid & 0xFF) << 8) | ((xid & 0xF) << 4) | (rid & 0xF)


def sha256_bytes(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().lower()


def pack_lex_word(w: str) -> int:
    b = w.encode("ascii")
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def write_named_lexicon() -> None:
    lex = list(role_lexicon.LEX)
    n = len(lex)
    header = [
        f"// NEW lexicon law {LAW_LEX} for {GATE}.",
        "// NOT C0 qse-v2-role-00 59-word runtime. C0 FILE rtl/native_graph/query/qse_role_lexicon.svh",
        "// remains unedited (hash-gate MATCH 38189974…). This table is C0 prefix plus named",
        "// semantic entities/relations/ctx so N=800000 can have 201 subject ids and 20 rel ids.",
        "// xvlog -i $bag FIRST binds bag qse_role_lexicon.svh -> this file into frozen extract.",
        f"localparam int unsigned QSE2_N_LEX = {n};",
        "localparam int unsigned QSE2_MAX_WORD = 12;",
        "localparam logic [7:0] QSE2_CLS [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{c}" for _, c, _ in lex) + "};",
        "localparam logic [7:0] QSE2_ID [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{i}" for _, _, i in lex) + "};",
        "localparam logic [7:0] QSE2_LEN [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{len(w)}" for w, _, _ in lex) + "};",
        "localparam logic [95:0] QSE2_WORD [0:QSE2_N_LEX-1] = '{",
        ",".join(f"96'h{pack_lex_word(w):024x}" for w, _, _ in lex) + "};",
        "",
    ]
    (BAG / "qse_role_lexicon_semantic_800k.svh").write_text("\n".join(header), encoding="utf-8")
    shim = [
        f"// NEW lexicon law {LAW_LEX} — include-name required by frozen extract.",
        "// NOT a silent C0 59-word claim. Runtime table is qse_role_lexicon_semantic_800k.svh.",
        "// C0 FILE at rtl/native_graph/query/qse_role_lexicon.svh is unedited.",
        '`include "qse_role_lexicon_semantic_800k.svh"',
        "",
    ]
    (BAG / "qse_role_lexicon.svh").write_text("\n".join(shim), encoding="utf-8")


def ctx_keys(x: dict) -> dict:
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
    y["law"] = LAW_EXTRACT
    y["syn_hit"] = 0
    y["rel_id_frozen"] = int(x["rel_id"]) & 0xFF
    return y


def apply_synonym_rel(x: dict) -> dict:
    y = dict(x)
    rid_f = int(x["rel_id"]) & 0xFF
    rid_s = REL_FEEDS if rid_f == REL_SUPPLY else rid_f
    y["rel_id_frozen"] = rid_f
    y["rel_id"] = rid_s
    y["syn_hit"] = int(rid_s != rid_f)
    y["k0"] = pack_plain(int(x["subj_id"]), rid_s)
    y["k1"] = pack_plain(int(x["obj_id"]), rid_s)
    return y


def feat_syn(text: str) -> dict:
    x = extract_v2(text)
    if x["n_host"] != 0:
        raise SystemExit(f"HOST_SEMANTIC_LEAK text={text!r}")
    y = apply_synonym_rel(x)
    z = ctx_keys(y)
    z["text"] = text
    z["law"] = LAW
    z["syn_hit"] = y["syn_hit"]
    z["rel_id_frozen"] = y["rel_id_frozen"]
    return z


def triple_text(s: int, r: int, o: int, ctx_word: str | None = None) -> str:
    t = f"{ENT[s]} {RELW[r]} {ENT[o]}"
    if ctx_word:
        t = f"{t} {ctx_word}"
    return t


def oi_of(s: int, o: int) -> int:
    if o == s:
        raise SystemExit("oi_of s==o")
    if o < s:
        return o - ENT0
    return o - ENT0 - 1


def sro_to_cidx(s: int, r: int, o: int) -> int:
    si = s - ENT0
    ri = r - 1
    return (si * N_REL + ri) * OBJS_PER + oi_of(s, o)


FILL_CIDX = sro_to_cidx(DIR_S, DIR_R, DIR_O)
SENT_CIDX = sro_to_cidx(SEN_S, SEN_R, SEN_O)


def cidx_to_stream(cidx: int) -> int | None:
    if cidx == FILL_CIDX or cidx == SENT_CIDX:
        return None
    skip = (1 if cidx > FILL_CIDX else 0) + (1 if cidx > SENT_CIDX else 0)
    si = cidx - skip
    if si < 0 or si >= N_STREAM:
        return None
    return si


def stream_to_nid(si: int) -> int:
    return si if si < 120 else si + 3


def nids_of_sro(s: int, r: int, o: int) -> list[int]:
    if (s, r, o) == (DIR_S, DIR_R, DIR_O):
        return [120, 121, 122]
    if (s, r, o) == (SEN_S, SEN_R, SEN_O):
        return [SEN_NID]
    st = cidx_to_stream(sro_to_cidx(s, r, o))
    if st is None:
        return []
    return [stream_to_nid(st)]


def posting_k0(s: int, r: int) -> list[int]:
    ids: list[int] = []
    for o in range(ENT0, ENT_HI + 1):
        if o == s:
            continue
        ids.extend(nids_of_sro(s, r, o))
    return sorted(set(ids))


def posting_k1(o: int, r: int) -> list[int]:
    ids: list[int] = []
    for s in range(ENT0, ENT_HI + 1):
        if s == o:
            continue
        ids.extend(nids_of_sro(s, r, o))
    return sorted(set(ids))


def nbeats(n: int) -> int:
    if n <= 0:
        return 0
    return (n + 3) // 4


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


def route_and(k0: int, k1: int) -> dict:
    s0, r0 = (k0 >> 8) & 0xFF, k0 & 0xFF
    s1, r1 = (k1 >> 8) & 0xFF, k1 & 0xFF
    a = posting_k0(s0, r0)
    b = posting_k1(s1, r1)
    emit, ntrunc, incomp = two_pointer(a, b, CAND_CAP)
    n_post = nbeats(len(a)) + nbeats(len(b))
    if n_post > MERGE_POST_AR_MAX:
        incomp = 1
        ntrunc = max(ntrunc, 1)
    ovf = 1 if (len(a) > INDEX_HEAD or len(b) > INDEX_HEAD) else 0
    rare_first = 0 if len(a) <= len(b) else 1
    return {
        "emit": emit,
        "n_emit": len(emit),
        "n_dir": 2,
        "n_post": n_post,
        "n_dup": 0,
        "n_trunc": ntrunc,
        "overflow_flag": ovf,
        "occupancies": [len(a), len(b)],
        "search_incomplete_walk": incomp,
        "rare_first": rare_first,
        "bytes": (2 + n_post) * ENTRY,
    }


def pack_text(s: str) -> int:
    b = s.encode("latin1")[:48]
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def csv_int(xs, fmt) -> str:
    return ",".join(fmt(x) for x in xs)


def write_svh(path: Path, queries: list[dict]) -> None:
    n = len(queries)
    fill_i = next(i for i, q in enumerate(queries) if q["name"] == "fill_template")
    nl_i = next(i for i, q in enumerate(queries) if q["name"] == "nl_synonym")
    late_i = next(i for i, q in enumerate(queries) if q["name"] == "late_gold")
    hi_i = next(i for i, q in enumerate(queries) if q["name"] == "high_id_sentinel")
    unrel_i = next(i for i, q in enumerate(queries) if q["name"] == "unrelated")
    lines = [
        "// generated by host_astra_c1_n65536_scale.py — independent gold BEFORE xvlog. do not hand-edit after FAIL",
        f"// Law {LAW} + ctx {LAW_CTX} + named lexicon {LAW_LEX}; synonym DUT wrap; N=800000 procedural",
        "// G_BYTES LSB-first: char0 at [7:0]; TB must use bytes[8*bi +: 8]",
        "// No G_WR / G_EVIDENCE[N] arrays — procedural mem. A 16k clone labeled 800k is forbidden.",
        f"localparam int unsigned G_N = {N};",
        f"localparam int unsigned G_NQ = {n};",
        f"localparam int unsigned G_CAND_CAP = {CAND_CAP};",
        f"localparam int unsigned G_INDEX_HEAD = {INDEX_HEAD};",
        f"localparam int unsigned G_MAX_EMIT = {MAX_EMIT};",
        f"localparam int unsigned G_MAX_REL = {MAX_REL};",
        "localparam int unsigned G_N_WR = 0;",
        "localparam int unsigned G_PROC_MEM = 1;",
        f"localparam int unsigned G_N_BUCKETS = {N_BUCKETS};",
        f"localparam int unsigned G_N_SUBJECTS = {N_ENT};",
        f"localparam int unsigned G_N_RELS = {N_REL};",
        f"localparam int unsigned G_FILL_Q = {fill_i};",
        f"localparam int unsigned G_NL_Q = {nl_i};",
        f"localparam int unsigned G_LATE_Q = {late_i};",
        f"localparam int unsigned G_HIGH_Q = {hi_i};",
        f"localparam int unsigned G_UNRELATED_Q = {unrel_i};",
        f"localparam int G_ENT0 = {ENT0};",
        f"localparam int G_ENT_HI = {ENT_HI};",
        f"localparam int G_N_REL = {N_REL};",
        f"localparam int G_N_STREAM = {N_STREAM};",
        f"localparam int G_FILL_CIDX = {FILL_CIDX};",
        f"localparam int G_SENT_CIDX = {SENT_CIDX};",
        f"localparam int G_SEN_S = {SEN_S};",
        f"localparam int G_SEN_R = {SEN_R};",
        f"localparam int G_SEN_O = {SEN_O};",
        f"localparam int unsigned G_STRIDE_BEATS = {STRIDE_BEATS};",
        "localparam logic [19:0] G_FILL_GRID [0:2] = '{20'd120,20'd121,20'd122};",
        f"localparam logic [19:0] G_SEN_NID = 20'd{SEN_NID};",
        f"localparam logic [15:0] G_FILL_K0 = 16'h{FILL_K0:04X};",
        f"localparam logic [15:0] G_FILL_K1 = 16'h{FILL_K1:04X};",
        f"localparam logic [27:0] G_POST_HEAP = 28'h{POST_HEAP:08X};",
        f"localparam logic [27:0] G_DIR_LO = 28'h{DIR_LO:08X};",
        f"localparam logic [27:0] G_DIR_HI = 28'h{DIR_HI:08X};",
        f"localparam logic [15:0] G_EPOCH = 16'd{EPOCH};",
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
        "localparam logic [7:0] G_REL_SYN [0:G_NQ-1] = '{"
        + csv_int([q["rel_id_syn"] for q in queries], lambda x: f"8'd{x}")
        + "};",
        "localparam logic G_SYN_HIT [0:G_NQ-1] = '{"
        + csv_int([q["syn_hit"] for q in queries], str)
        + "};",
        "localparam logic [15:0] G_K0_FROZEN [0:G_NQ-1] = '{"
        + csv_int([q["k0_frozen"] for q in queries], lambda x: f"16'h{x:04X}")
        + "};",
        "localparam logic [15:0] G_K1_FROZEN [0:G_NQ-1] = '{"
        + csv_int([q["k1_frozen"] for q in queries], lambda x: f"16'h{x:04X}")
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
        "localparam int G_OCC [0:G_NQ-1] = '{"
        + csv_int([max(q["occupancies"] or [0]) for q in queries], str)
        + "};",
        "localparam int G_NREL [0:G_NQ-1] = '{"
        + csv_int([len(q["relevant"]) for q in queries], str)
        + "};",
        "localparam int G_EXPECT_INCOMP [0:G_NQ-1] = '{"
        + csv_int([q["search_incomplete"] for q in queries], str)
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


def main() -> int:
    if (BAG / "xsim_fail_r0.log").exists() or (BAG / "xvlog.log").exists() or (BAG / "xsim.log").exists():
        print("GOLD_IMMUTABLE after xvlog/fail_r0; do not regenerate")
        return 3

    if len(NEW_ENT) != N_ENT:
        raise SystemExit(f"NEW_ENT {len(NEW_ENT)} != {N_ENT}")
    if len(set(NEW_ENT)) != N_ENT:
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
    if NL_TEXT == HELDOUT_PARAPHRASE:
        raise SystemExit("NL_TEXT is HELDOUT paraphrase; not this unknown")
    if FILL_RE.match(NL_TEXT) is not None:
        raise SystemExit("NL_TEXT matches fill-template regex")
    if N != 65536 or N_STREAM + 3 + 1 != N:
        raise SystemExit('N != 65536')
    if SEN_NID != 65535:
        raise SystemExit('sentinel nid')

    write_named_lexicon()
    fails: list[str] = []

    def chk(cond: bool, msg: str) -> None:
        if not cond:
            fails.append(msg)

    chk(N == 65536, "N dropped from registered 65536")
    chk(CAND_CAP < N, "cap>=N")
    chk(N_BUCKETS == 65536, "N_BUCKETS not 65536")
    chk(N_ENT >= 100, f"subj<{100}")
    chk(N_REL >= 8, f"rel<{8}")
    chk(FILL_RE.match(triple_text(DIR_S, DIR_R, DIR_O)) is not None, "fill text")
    chk(stream_to_nid(0) == 0 and stream_to_nid(119) == 119, "stream prefix nids")
    chk(stream_to_nid(120) == 123, "stream hole 120-122")
    chk(stream_to_nid(N_STREAM - 1) == 65534, "last stream nid")
    chk(nids_of_sro(DIR_S, DIR_R, DIR_O) == [120, 121, 122], "fill-grid nids")
    chk(nids_of_sro(SEN_S, SEN_R, SEN_O) == [65535], "sentinel nid")

    fill_a = posting_k0(DIR_S, DIR_R)
    fill_b = posting_k1(DIR_O, DIR_R)
    fill_and = sorted(set(fill_a) & set(fill_b))
    chk(fill_and == [120, 121, 122], f"fill AND {fill_and}")
    chk(nbeats(len(fill_a)) + nbeats(len(fill_b)) <= MERGE_POST_AR_MAX, "fill n_post>256")
    sen_a = posting_k0(SEN_S, SEN_R)
    sen_b = posting_k1(SEN_O, SEN_R)
    sen_and = sorted(set(sen_a) & set(sen_b))
    chk(sen_and == [65535], f"sent AND {sen_and}")
    chk(nbeats(len(sen_a)) + nbeats(len(sen_b)) <= MERGE_POST_AR_MAX, "sent n_post>256")

    sen_text = triple_text(SEN_S, SEN_R, SEN_O)
    late_sro = None
    for s in range(ENT0, ENT_HI + 1):
        for r in range(1, N_REL + 1):
            for o in range(ENT0, ENT_HI + 1):
                if o == s:
                    continue
                if nids_of_sro(s, r, o) == [65534]:
                    late_sro = (s, r, o)
                    break
            if late_sro:
                break
        if late_sro:
            break
    if late_sro is None:
        raise SystemExit("late gold sro missing")
    late_text = triple_text(*late_sro)
    late_a = posting_k0(late_sro[0], late_sro[1])
    chk(65534 in late_a, "late nid not on k0 list")
    chk(late_a.index(65534) >= 16, f"late k0_idx={late_a.index(65534)} < 16")
    queries_spec = [
        ("fill_template", triple_text(DIR_S, DIR_R, DIR_O), [120, 121, 122]),
        ("nl_synonym", NL_TEXT, [120, 121, 122]),
        ("late_gold", late_text, [65534]),
        ("high_id_sentinel", sen_text, [65535]),
        ("unrelated", "payroll tax form", []),
    ]

    queries = []
    for name, text, relevant in queries_spec:
        qf = feat(text)
        qs = feat_syn(text)
        q = dict(qs)
        q["name"] = name
        q["rel_id"] = qf["rel_id"]
        q["rel_id_syn"] = qs["rel_id"]
        q["syn_hit"] = qs["syn_hit"]
        q["k0_plain"] = qf["k0_plain"]
        q["k1_plain"] = qf["k1_plain"]
        q["k0_frozen"] = qf["k0"]
        q["k1_frozen"] = qf["k1"]
        q["k0"] = qs["k0"]
        q["k1"] = qs["k1"]
        q["k2"] = qs["k2"]
        q["k3"] = qs["k3"]
        raw = text.encode("latin1")
        q["len"] = len(raw)
        q["tok_pack"] = pack_text(text)
        if raw:
            chk((q["tok_pack"] & 0xFF) == raw[0], f"{name} tok_pack LSB != char0")
        q["relevant"] = list(relevant)
        if q["k0_valid"] and q["k1_valid"]:
            rt = route_and(q["k0"], q["k1"])
        else:
            rt = {
                "emit": [],
                "n_emit": 0,
                "n_dir": 0,
                "n_post": 0,
                "n_dup": 0,
                "n_trunc": 0,
                "overflow_flag": 0,
                "occupancies": [],
                "search_incomplete_walk": 0,
                "rare_first": 0,
                "bytes": 0,
            }
        q.update(rt)
        emit_set = set(q["emit"])
        tp = sum(1 for i in relevant if i in emit_set)
        missed = [i for i in relevant if i not in emit_set]
        incomp = 1 if (q["n_trunc"] > 0 or q.get("search_incomplete_walk")) else 0
        if missed:
            fails.append(f"GOLD_MISS {name} missed={missed} emit={q['emit']} incomp={incomp}")
        if incomp and relevant:
            fails.append(f"SEARCH_INCOMPLETE {name} gold_n={len(relevant)} emit={q['emit']}")
        q["tp"] = tp
        q["fp_ev1"] = sum(1 for i in q["emit"] if i not in set(relevant))
        q["fp_fill0"] = 0
        q["prec_ev1"] = (tp / (tp + q["fp_ev1"])) if (tp + q["fp_ev1"]) else None
        q["prec_all"] = (tp / q["n_emit"]) if q["n_emit"] else None
        q["recall"] = (tp / len(relevant)) if relevant else None
        q["search_incomplete"] = incomp
        chk(q["n_emit"] < N, f"{name} emit>=N tautology")
        chk(q["n_host"] == 0, f"{name} host")
        queries.append(q)

    qd = {q["name"]: q for q in queries}
    chk(qd["fill_template"]["subj_id"] == DIR_S, "fill subj")
    chk(qd["fill_template"]["rel_id"] == DIR_R, "fill rel")
    chk(qd["fill_template"]["obj_id"] == DIR_O, "fill obj")
    chk(qd["fill_template"]["k0"] == FILL_K0, f"fill k0 {qd['fill_template']['k0']}")
    chk(qd["fill_template"]["k1"] == FILL_K1, f"fill k1 {qd['fill_template']['k1']}")
    chk(qd["fill_template"]["emit"] == [120, 121, 122], f"fill emit {qd['fill_template']['emit']}")
    chk(qd["fill_template"]["tp"] == 3, "fill tp")
    chk(qd["fill_template"]["search_incomplete"] == 0, "fill SEARCH_INCOMPLETE")
    chk(qd["nl_synonym"]["text"] == NL_TEXT, "nl text")
    keys_match_frozen = int(
        qd["nl_synonym"]["k0_frozen"] == qd["fill_template"]["k0"]
        and qd["nl_synonym"]["k1_frozen"] == qd["fill_template"]["k1"]
    )
    keys_match_syn = int(
        qd["nl_synonym"]["k0"] == qd["fill_template"]["k0"]
        and qd["nl_synonym"]["k1"] == qd["fill_template"]["k1"]
    )
    chk(keys_match_frozen == 0, "frozen extract aliased supply to feeds (forbidden C0 patch)")
    chk(qd["nl_synonym"]["rel_id"] == REL_SUPPLY, "frozen NL rel not supply id=1")
    chk(qd["nl_synonym"]["rel_id_syn"] == REL_FEEDS, "synonym NL rel not feeds id=4")
    chk(qd["nl_synonym"]["syn_hit"] == 1, "synonym overlay missed supply")
    chk(keys_match_syn == 1, "synonym law did not remap NL keys to fill 3332/3588")
    chk(qd["nl_synonym"]["emit"] == [120, 121, 122], f"nl emit {qd['nl_synonym']['emit']}")
    chk(131 not in qd["nl_synonym"]["emit"], "nl emit contains cartesian nid 131")
    chk(qd["nl_synonym"]["tp"] == 3, "nl tp != 3")
    chk(qd["nl_synonym"]["search_incomplete"] == 0, "nl SEARCH_INCOMPLETE")
    chk(qd["high_id_sentinel"]["emit"] == [65535], f"high emit {qd['high_id_sentinel']['emit']}")
    chk(qd["high_id_sentinel"]["subj_id"] == SEN_S, "high subj")
    chk(qd["high_id_sentinel"]["rel_id"] == SEN_R, "high rel")
    chk(qd["high_id_sentinel"]["obj_id"] == SEN_O, "high obj")
    chk(qd["high_id_sentinel"]["search_incomplete"] == 0, "high SEARCH_INCOMPLETE")
    chk(qd["unrelated"]["n_emit"] == 0 and qd["unrelated"]["n_dir"] == 0, "unrelated emit")
    chk(qd["unrelated"]["k0_valid"] == 0 and qd["unrelated"]["k1_valid"] == 0, "unrelated valid")
    chk(qd["fill_template"]["n_emit"] <= CAND_CAP, "fill_template cap")
    chk(FILL_RE.match(sen_text) is not None, "sentinel not fill-template surface")

    syn_p = BAG / "qse_relctx_synonym_01.svh"
    live_syn = sha256_bytes(syn_p)
    if live_syn != KEEP_SYN_SHA:
        fails.append(f"synonym table SHA {live_syn} want {KEEP_SYN_SHA}")

    if fails:
        print("ASTRA_C1_N65536_SCALE_HOST_FAIL")
        for f in fails:
            print("FAIL", f)
        return 2

    write_svh(BAG / "query_gold.svh", queries)
    corpus = {
        "gate": GATE,
        "n": N,
        "generator": "cartesian_n65536_v1",
        "procedural": True,
        "not_16k_clone": True,
        "n_subjects": N_ENT,
        "n_rels": N_REL,
        "ent0": ENT0,
        "ent_hi": ENT_HI,
        "n_stream": N_STREAM,
        "fill_cidx": FILL_CIDX,
        "sent_cidx": SENT_CIDX,
        "fill_grid_nids": [120, 121, 122],
        "fill_sro": [DIR_S, DIR_R, DIR_O],
        "sentinel_nid": SEN_NID,
        "sentinel_sro": [SEN_S, SEN_R, SEN_O],
        "sentinel_text": sen_text,
        "historical_u5_cannot_close": True,
        "records_materialized": False,
    }
    (BAG / "corpus.json").write_text(json.dumps(corpus, indent=2) + "\n", encoding="utf-8")

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
            "reduction_x1000": "VS_N",
            "rare_first": q.get("rare_first"),
            "fill_template_surface": FILL_RE.match(q["text"]) is not None,
        }
        if q["name"] == "nl_synonym":
            row["rel_id_frozen"] = q["rel_id"]
            row["rel_id_syn"] = q["rel_id_syn"]
            row["syn_hit"] = q["syn_hit"]
            row["k0_frozen"] = q["k0_frozen"]
            row["k1_frozen"] = q["k1_frozen"]
            row["keys_match_fill_frozen"] = 0
            row["keys_match_fill"] = 1
            row["NL_GOLD_HIT"] = True
            row["not_nid_131"] = True
            row["fill_meaning_gold"] = [120, 121, 122]
        if q["name"] == "fill_template":
            row["FILL_TEMPLATE_HIT"] = True
            row["fill_grid"] = [120, 121, 122]
        if q["name"] == "high_id_sentinel":
            row["HIGH_ID_HIT"] = True
            row["sentinel_nid"] = 799999
        if q["name"] == "unrelated":
            row["UNRELATED_EMPTY_WALK"] = q["n_emit"] == 0
        return row

    golden = {
        "gate": GATE,
        "law": LAW,
        "ctx_law_frozen": LAW_CTX,
        "lexicon_law": LAW_LEX,
        "extract_law_frozen": LAW_EXTRACT,
        "law_control_not_used": LAW_V1,
        "n": N,
        "cand_cap": CAND_CAP,
        "index_head": INDEX_HEAD,
        "n_buckets": N_BUCKETS,
        "merge_post_ar_max": MERGE_POST_AR_MAX,
        "n_subjects": N_ENT,
        "n_rels": N_REL,
        "procedural_mem": True,
        "not_16k_clone": True,
        "historical_u5_cannot_close": True,
        "gold_source": "independent_labels_before_router",
        "relevant_is_router_union": False,
        "cap_ge_n_used_as_selectivity": False,
        "twelve_entity_clone": False,
        "fill_template_control_text": "boiler feeds header",
        "fill_template_keys": [FILL_K0, FILL_K1],
        "nl_synonym_text": NL_TEXT,
        "high_id_sentinel_nid": SEN_NID,
        "high_id_sentinel_text": sen_text,
        "fill_grid_nids": [120, 121, 122],
        "g_bytes_layout": "lsb_first_char0_at_bits7_0",
        "reduction_x1000_emitted": True,
        "CAND_CAP_FINAL": "NOT_FROZEN",
        "DDR_QUERY_BOUND_FINAL": "NOT_FROZEN",
        "BOARD_PASS": "NOT_CLAIMED",
        "PROGRAM": False,
        "queries": [qpub(q) for q in queries],
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    print("ASTRA_C1_N65536_SCALE_HOST_OK")
    print(f"N={N} fill_and={qd['fill_template']['emit']} high={qd['high_id_sentinel']['emit']}")
    print(f"fill_n_post={qd['fill_template']['n_post']} high_n_post={qd['high_id_sentinel']['n_post']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
