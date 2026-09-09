#!/usr/bin/env python3
"""ASTRA-02 independent host gold: QSE keys, overflow pages, scale ladder.

Law: qse-v1-lexicon-hdc-00 / U4A-R6 validity / P4_4k_h64.
Keys come only from twin.extract. Never k2/k3 from nid.
Occupancy is archived as NOT_SEMANTIC. Gold is generator labels.
RTL is not modified. 800k XSim is not claimed.
"""
from __future__ import annotations

import array
import hashlib
import json
import sys
import time
from collections import defaultdict
from math import ceil
from pathlib import Path

BAG = Path(__file__).resolve().parent
NG = BAG.parent
BAG_U3Q = NG / "GROK-ORCH-00" / "U3Q-R3-STRUCTURED-QUERY-FEATURE-00"
BAG_R6 = NG / "GROK-ORCH-00" / "U4A-R6-ROUTE-VALIDITY-00"
BAG_A01 = NG / "ASTRA-01-U4-REAL-AXI-SPARSE-00"
sys.path.insert(0, str(BAG_U3Q))
from lexicon import ADV_SEED, ENTITY_CANON, UNRELATED  # noqa: E402
from twin import extract  # noqa: E402

LAW = "qse-v1-lexicon-hdc-00"
GATE = "ASTRA-02-SCALE-SELECTIVITY-00"
INDEX_BASE = 0x05000000
POST_HEAP = INDEX_BASE + 0x40000
N_TABLES = 4
N_BUCKETS = 4096
HEAD_CAP = 64
PAGE_CAP = 64
ENTRY = 16
BYTE_BUDGET = 32768
EPOCH = 7
LADDER = (256, 4096, 16384, 65536, 262144, 800000)
CAPS = (64, 128, 256, 512, 1024)
MODES = (
    "rtl_head_union",
    "full_ovf_union",
    "full_ovf_union_keychk",
    "full_ovf_intersect_keychk",
)
TH_RECALL = 0.95
TH_REDUCTION = 0.90
TH_UNRELATED = 0.95
TH_COVERAGE = 1.0
NS_PER_BEAT_EST = 80  # 8 cyc * 10 ns @ 100 MHz; ESTIMATE_NOT_SILICON

ENT_WORDS = [
    "chiller", "condenser", "evaporator", "compressor", "refrigerant", "ahu",
    "duct", "vav", "tower", "pump", "valve", "sensor",
]
INT_WORDS = ["install", "leak", "balance", "insulate", "startup", "replace"]
CTX_WORDS = ["water", "air", "dx", "chilled", "return"]
REL_WORDS = ["pipe", "coil", "unit", "plant"]

KIND_UNRELATED = 0
KIND_ROLE_FWD = 1
KIND_ROLE_REV = 2
KIND_INTENT = 3
KIND_CTX = 4
KIND_ENTITY = 5
KIND_AUDIT_FWD = 6
KIND_AUDIT_REV = 7


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest().upper()


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
    return INDEX_BASE + table * 65536 + (key & 0xFFF) * ENTRY


_FEAT_CACHE: dict[str, dict] = {}


def feat_cached(base: str) -> dict:
    f = _FEAT_CACHE.get(base)
    if f is None:
        f = feat(base)
        _FEAT_CACHE[base] = f
    return f


def salt_text(base: str, nid: int) -> str:
    s = f"{base} z{nid:06x}"
    if len(s) > 48 or len(s.split()) > 8:
        return base[:48]
    return s


def role_indices(nid: int) -> tuple[int, int, int]:
    seed = nid // 10
    subj_i = seed % 12
    obj_i = (seed // 12) % 12
    if obj_i == subj_i:
        obj_i = (obj_i + 1) % 12
    rel_i = (seed // 144) % 4
    return subj_i, obj_i, rel_i


def record_base(nid: int, n: int) -> tuple[str, int, int, int, int, int, int, int]:
    """Return (base_text, kind, entity, intent, ctx, rel, subj, obj). Labels independent of hash.

    Kind uses nid%10; entity/intent/context use nid//10 so every class×entity
    cell is reachable (nid%12 coupled to kind made water+chiller impossible).
    """
    if n >= 800000 and nid == 799999:
        return "chiller", KIND_ENTITY, 1, 0, 0, 0, 0, 0
    if n > 0x10010 and nid == 0x10:
        return "chiller", KIND_ENTITY, 1, 0, 0, 0, 0, 0
    if n > 0x10010 and nid == 0x10010:
        return "pump", KIND_ENTITY, 10, 0, 0, 0, 0, 0
    if n >= 256 and nid == 191:
        return "chiller supplies pump", KIND_AUDIT_FWD, 1, 0, 0, 0, 1, 10
    if n >= 256 and nid == 192:
        return "pump supplies chiller", KIND_AUDIT_REV, 10, 0, 0, 0, 10, 1

    r = nid % 10
    rest = nid // 10
    e = rest % 12
    if r == 0:
        u = UNRELATED[rest % len(UNRELATED)]
        return u, KIND_UNRELATED, 0, 0, 0, 0, 0, 0

    subj_i, obj_i, rel_i = role_indices(nid)
    supplies = rest % 20 == 19
    if r == 1:
        if supplies:
            text = f"{ENT_WORDS[subj_i]} supplies {ENT_WORDS[obj_i]}"
            return text, KIND_AUDIT_FWD, subj_i + 1, 0, 0, 0, subj_i + 1, obj_i + 1
        text = f"{ENT_WORDS[subj_i]} {REL_WORDS[rel_i]} {ENT_WORDS[obj_i]}"
        return text, KIND_ROLE_FWD, subj_i + 1, 0, 0, rel_i + 1, subj_i + 1, obj_i + 1
    if r == 2:
        if supplies:
            text = f"{ENT_WORDS[obj_i]} supplies {ENT_WORDS[subj_i]}"
            return text, KIND_AUDIT_REV, obj_i + 1, 0, 0, 0, obj_i + 1, subj_i + 1
        text = f"{ENT_WORDS[obj_i]} {REL_WORDS[rel_i]} {ENT_WORDS[subj_i]}"
        return text, KIND_ROLE_REV, obj_i + 1, 0, 0, rel_i + 1, obj_i + 1, subj_i + 1
    if r == 3:
        ii = (rest // 12) % 6
        text = f"{INT_WORDS[ii]} {ENT_WORDS[e]}"
        return text, KIND_INTENT, e + 1, ii + 1, 0, 0, 0, 0
    if r in (4, 5):
        ci = (rest // 12) % 5
        text = f"{CTX_WORDS[ci]} {ENT_WORDS[e]}"
        return text, KIND_CTX, e + 1, 0, ci + 1, 0, 0, 0
    return ENT_WORDS[e], KIND_ENTITY, e + 1, 0, 0, 0, 0, 0


def query_specs() -> list[dict]:
    return [
        {"name": "known_domain_chiller", "class": "known_domain", "text": "chiller",
         "entity": 1, "intent": 0, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "known_domain_pump", "class": "known_domain", "text": "pump",
         "entity": 10, "intent": 0, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "paraphrase_water_chiller", "class": "paraphrase", "text": "water chiller",
         "entity": 1, "intent": 0, "ctx": 1, "rel": 0, "subj": 0, "obj": 0},
        {"name": "entity_context_water_chiller", "class": "entity_context", "text": "water chiller",
         "entity": 1, "intent": 0, "ctx": 1, "rel": 0, "subj": 0, "obj": 0},
        {"name": "intent_leak_chiller", "class": "same_entity_diff_intent", "text": "leak chiller",
         "entity": 1, "intent": 2, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "intent_install_chiller", "class": "same_entity_diff_intent", "text": "install chiller",
         "entity": 1, "intent": 1, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "role_fwd", "class": "role_fwd", "text": "chiller pipe condenser",
         "entity": 1, "intent": 0, "ctx": 0, "rel": 1, "subj": 1, "obj": 2},
        {"name": "role_rev", "class": "role_rev", "text": "condenser pipe chiller",
         "entity": 2, "intent": 0, "ctx": 0, "rel": 1, "subj": 2, "obj": 1},
        {"name": "role_audit_fwd", "class": "role_audit_fwd", "text": "chiller supplies pump",
         "entity": 1, "intent": 0, "ctx": 0, "rel": 0, "subj": 1, "obj": 10},
        {"name": "role_audit_rev", "class": "role_audit_rev", "text": "pump supplies chiller",
         "entity": 10, "intent": 0, "ctx": 0, "rel": 0, "subj": 10, "obj": 1},
        {"name": "unrelated_payroll", "class": "unrelated", "text": "payroll tax form",
         "entity": 0, "intent": 0, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "unrelated_soccer", "class": "unrelated", "text": "soccer match score",
         "entity": 0, "intent": 0, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
        {"name": "unrelated_adv", "class": "unrelated", "text": adv0(),
         "entity": 0, "intent": 0, "ctx": 0, "rel": 0, "subj": 0, "obj": 0},
    ]


class Corpus:
    def __init__(self, n: int):
        self.n = n
        self.k0 = array.array("H", [0]) * n
        self.k1 = array.array("H", [0]) * n
        self.k2 = array.array("H", [0]) * n
        self.k3 = array.array("H", [0]) * n
        self.vm = array.array("B", [0]) * n
        self.kind = array.array("B", [0]) * n
        self.entity = array.array("B", [0]) * n
        self.intent = array.array("B", [0]) * n
        self.ctx = array.array("B", [0]) * n
        self.rel = array.array("B", [0]) * n
        self.subj = array.array("B", [0]) * n
        self.obj = array.array("B", [0]) * n
        self.by_entity = [[] for _ in range(13)]
        self.by_ent_ctx: dict[tuple[int, int], list[int]] = defaultdict(list)
        self.by_ent_int: dict[tuple[int, int], list[int]] = defaultdict(list)
        self.by_triple: dict[tuple[int, int, int], list[int]] = defaultdict(list)
        self.by_audit: dict[tuple[int, int], list[int]] = defaultdict(list)

    def key(self, nid: int, t: int) -> int:
        if t == 0:
            return self.k0[nid]
        if t == 1:
            return self.k1[nid]
        if t == 2:
            return self.k2[nid]
        return self.k3[nid]


def build_corpus(n: int) -> Corpus:
    c = Corpus(n)
    nid_formula_hits = 0
    verify_n = min(64, n)
    for nid in range(n):
        base, kind, ent, intent, ctx, rel, subj, obj = record_base(nid, n)
        f = feat_cached(base)
        if nid < verify_n:
            full = feat(salt_text(base, nid))
            if full["k"] != f["k"] or full["v"] != f["v"]:
                f = full
        if f["n_host"] != 0:
            raise SystemExit(f"HOST_SEMANTIC_LEAK nid={nid}")
        c.k0[nid], c.k1[nid], c.k2[nid], c.k3[nid] = f["k"]
        c.vm[nid] = (
            (1 if f["v"][0] else 0)
            | (2 if f["v"][1] else 0)
            | (4 if f["v"][2] else 0)
            | (8 if f["v"][3] else 0)
        )
        c.kind[nid] = kind
        c.entity[nid] = ent
        c.intent[nid] = intent
        c.ctx[nid] = ctx
        c.rel[nid] = rel
        c.subj[nid] = subj
        c.obj[nid] = obj
        if (c.k2[nid] == (nid & 0xFFFF)) and (c.k3[nid] == ((nid >> 4) & 0xFFFF)):
            nid_formula_hits += 1
        if ent:
            c.by_entity[ent].append(nid)
        if ent and ctx:
            c.by_ent_ctx[(ent, ctx)].append(nid)
        if ent and intent:
            c.by_ent_int[(ent, intent)].append(nid)
        if subj and obj and rel:
            c.by_triple[(subj, rel, obj)].append(nid)
        if kind in (KIND_AUDIT_FWD, KIND_AUDIT_REV) and subj and obj:
            c.by_audit[(subj, obj)].append(nid)
    c.nid_formula_hits = nid_formula_hits
    c.nid_formula_n = n
    return c


def gold_ids(c: Corpus, q: dict) -> list[int]:
    cls = q["class"]
    if cls == "unrelated":
        return []
    if cls == "known_domain":
        return c.by_entity[q["entity"]]
    if cls in ("paraphrase", "entity_context"):
        return c.by_ent_ctx.get((q["entity"], q["ctx"]), [])
    if cls == "same_entity_diff_intent":
        return c.by_ent_int.get((q["entity"], q["intent"]), [])
    if cls in ("role_fwd", "role_rev"):
        return c.by_triple.get((q["subj"], q["rel"], q["obj"]), [])
    if cls in ("role_audit_fwd", "role_audit_rev"):
        return c.by_audit.get((q["subj"], q["obj"]), [])
    return []


def build_index(c: Corpus):
    posts = [defaultdict(list) for _ in range(N_TABLES)]
    n_valid = 0
    n_indexed = 0
    for nid in range(c.n):
        vm = c.vm[nid]
        if vm == 0:
            continue
        n_valid += 1
        placed = False
        for t in range(N_TABLES):
            if not (vm & (1 << t)):
                continue
            b = c.key(nid, t) & 0xFFF
            posts[t][b].append(nid)
            placed = True
        if placed:
            n_indexed += 1
    occ = []
    n_pages = 0
    n_ovf_pages = 0
    max_post = 0
    for t in range(N_TABLES):
        for b in range(N_BUCKETS):
            ln = len(posts[t][b]) if b in posts[t] else 0
            occ.append(ln)
            if ln:
                pg = ceil(ln / PAGE_CAP)
                n_pages += pg
                n_ovf_pages += max(pg - 1, 0)
                if ln > max_post:
                    max_post = ln
    occ_sorted = sorted(occ)
    nonempty = [x for x in occ if x]
    mean_occ = (sum(occ) / len(occ)) if occ else 0.0
    mean_post = (sum(nonempty) / len(nonempty)) if nonempty else 0.0
    p99 = (
        nonempty[int(0.99 * (len(nonempty) - 1))] if nonempty else 0
    )
    coverage = (n_indexed / n_valid) if n_valid else 1.0
    stats = {
        "N": c.n,
        "n_valid_key": n_valid,
        "n_indexed": n_indexed,
        "n_unrelated_or_novalid": c.n - n_valid,
        "coverage_valid": coverage,
        "coverage_is_not_semantic": True,
        "n_pages": n_pages,
        "n_overflow_pages": n_ovf_pages,
        "posting_len_max": max_post,
        "posting_len_mean_nonzero": mean_post,
        "bucket_occ_max": occ_sorted[-1] if occ_sorted else 0,
        "bucket_occ_mean": mean_occ,
        "bucket_occ_p99_nonzero": p99,
        "empty_frac": (sum(1 for x in occ if x == 0) / len(occ)) if occ else 1.0,
        "sentinel_799999": (c.n >= 800000 and c.entity[799999] == 1 and c.vm[799999] != 0),
        "low16_pair": (
            c.n > 0x10010
            and c.entity[0x10] == 1
            and c.entity[0x10010] == 10
            and c.k0[0x10] != c.k0[0x10010]
        ),
        "nid_formula_hit_frac": c.nid_formula_hits / max(c.nid_formula_n, 1),
        "key_source": "qse-twin-extract",
    }
    return posts, stats


def beats_for_ids(n: int) -> int:
    if n <= 0:
        return 0
    return (n + 3) // 4


def walk_query(c: Corpus, posts, qfeat: dict, mode: str, cap: int) -> dict:
    walk_ovf = mode != "rtl_head_union"
    keychk = mode.endswith("keychk")
    intersect = "intersect" in mode
    probed = []
    lists = []
    dir_as = []
    n_dir = 0
    bytes_q = 0
    for t in range(N_TABLES):
        if qfeat["v"][t] == 0:
            continue
        k = qfeat["k"][t]
        b = k & 0xFFF
        n_dir += 1
        bytes_q += ENTRY
        dir_as.append(dir_addr(t, k))
        ids = posts[t].get(b, [])
        probed.append(t)
        lists.append((t, k, ids))

    incomplete_budget = False
    overflow_unread = False
    n_predup = 0
    n_dup = 0
    n_trunc = 0
    n_keydrop = 0
    n_post_beats = 0
    n_hdr = 0
    n_pages_read = 0
    n_pages_total = 0
    seen: list[int] = []
    seen_set: set[int] = set()
    predup_sample: list[int] = []

    def consider(nid: int, t: int, k: int) -> None:
        nonlocal n_predup, n_dup, n_trunc, n_keydrop
        n_predup += 1
        if len(predup_sample) < 32:
            predup_sample.append(nid)
        if keychk and c.key(nid, t) != k:
            n_keydrop += 1
            return
        if nid in seen_set:
            n_dup += 1
            return
        if len(seen) >= cap:
            n_trunc += 1
            return
        seen.append(nid)
        seen_set.add(nid)

    def consume_list(t: int, k: int, ids: list[int], stop_on_budget: bool) -> None:
        nonlocal bytes_q, incomplete_budget, overflow_unread, n_post_beats, n_hdr
        nonlocal n_pages_read, n_pages_total
        n = len(ids)
        if n == 0:
            return
        n_pages = ceil(n / PAGE_CAP)
        n_pages_total += n_pages
        max_pages = 1 if not walk_ovf else n_pages
        if n_pages > max_pages:
            overflow_unread = True
        for p in range(max_pages):
            chunk = ids[p * PAGE_CAP : (p + 1) * PAGE_CAP]
            if p > 0:
                hdr = ENTRY
                if stop_on_budget and bytes_q + hdr > BYTE_BUDGET:
                    incomplete_budget = True
                    overflow_unread = True
                    return
                bytes_q += hdr
                n_hdr += 1
            nb = beats_for_ids(len(chunk))
            cost = nb * ENTRY
            if stop_on_budget and bytes_q + cost > BYTE_BUDGET:
                remain = max(0, (BYTE_BUDGET - bytes_q) // ENTRY)
                take = min(len(chunk), remain * 4)
                if take:
                    bytes_q += beats_for_ids(take) * ENTRY
                    n_post_beats += beats_for_ids(take)
                    n_pages_read += 1
                    for nid in chunk[:take]:
                        consider(nid, t, k)
                incomplete_budget = True
                overflow_unread = True
                return
            bytes_q += cost
            n_post_beats += nb
            n_pages_read += 1
            for nid in chunk:
                consider(nid, t, k)

    if intersect and lists:
        lists_sorted = sorted(lists, key=lambda x: len(x[2]))
        other_sets = []
        for t, k, ids in lists_sorted[1:]:
            if keychk:
                other_sets.append({nid for nid in ids if c.key(nid, t) == k})
            else:
                other_sets.append(set(ids))
        t0, k0, ids0 = lists_sorted[0]
        # AXI-claimed bytes: dirs already counted + rarest posting walk.
        # Membership in other lists is HOST_SET, not AXI.
        def consider_isect(nid: int, t: int, k: int) -> None:
            nonlocal n_predup, n_dup, n_trunc, n_keydrop
            n_predup += 1
            if len(predup_sample) < 32:
                predup_sample.append(nid)
            if keychk and c.key(nid, t) != k:
                n_keydrop += 1
                return
            for s in other_sets:
                if nid not in s:
                    n_keydrop += 1
                    return
            if nid in seen_set:
                n_dup += 1
                return
            if len(seen) >= cap:
                n_trunc += 1
                return
            seen.append(nid)
            seen_set.add(nid)

        n = len(ids0)
        if n:
            n_pages = ceil(n / PAGE_CAP)
            n_pages_total += n_pages
            max_pages = 1 if not walk_ovf else n_pages
            if n_pages > max_pages:
                overflow_unread = True
            for p in range(max_pages):
                chunk = ids0[p * PAGE_CAP : (p + 1) * PAGE_CAP]
                if p > 0:
                    if bytes_q + ENTRY > BYTE_BUDGET:
                        incomplete_budget = True
                        overflow_unread = True
                        break
                    bytes_q += ENTRY
                    n_hdr += 1
                nb = beats_for_ids(len(chunk))
                cost = nb * ENTRY
                if bytes_q + cost > BYTE_BUDGET:
                    remain = max(0, (BYTE_BUDGET - bytes_q) // ENTRY)
                    take = min(len(chunk), remain * 4)
                    if take:
                        bytes_q += beats_for_ids(take) * ENTRY
                        n_post_beats += beats_for_ids(take)
                        n_pages_read += 1
                        for nid in chunk[:take]:
                            consider_isect(nid, t0, k0)
                    incomplete_budget = True
                    overflow_unread = True
                    break
                bytes_q += cost
                n_post_beats += nb
                n_pages_read += 1
                for nid in chunk:
                    consider_isect(nid, t0, k0)
    else:
        for t, k, ids in lists:
            consume_list(t, k, ids, stop_on_budget=walk_ovf)
            if walk_ovf and incomplete_budget:
                # still note remaining tables unread
                overflow_unread = True

    ovf_any = any(len(ids) > HEAD_CAP for _t, _k, ids in lists)
    if not walk_ovf and ovf_any:
        overflow_unread = True

    if n_dir == 0:
        status = "NO_EVIDENCE"
    elif overflow_unread or incomplete_budget or n_trunc > 0:
        status = "SEARCH_INCOMPLETE"
    elif len(seen) == 0:
        status = "NO_EVIDENCE"
    else:
        status = "COMPLETE"

    posting_lens = [len(ids) for _t, _k, ids in lists]
    return {
        "n_dir": n_dir,
        "dir_addr": [hex(a) for a in dir_as],
        "n_emit": len(seen),
        "emit": seen,
        "n_predup": n_predup,
        "n_dup": n_dup,
        "n_trunc": n_trunc,
        "n_keydrop": n_keydrop,
        "bytes": bytes_q,
        "n_post_beats": n_post_beats,
        "n_hdr": n_hdr,
        "n_pages_read": n_pages_read,
        "n_pages_total": n_pages_total,
        "overflow_unread": overflow_unread,
        "overflow_flag": ovf_any,
        "incomplete_budget": incomplete_budget,
        "status": status,
        "posting_lens": posting_lens,
        "probed": probed,
        "predup_sample": predup_sample,
        "est_ns_100mhz": (n_dir + n_post_beats + n_hdr) * NS_PER_BEAT_EST,
    }


def unlimited_cover(c: Corpus, posts, qfeat: dict, gold: list[int], keychk: bool) -> dict:
    if not gold:
        return {"n_gold_in_index": 0, "index_recall": None, "n_union": 0}
    gset = set(gold)
    hit = 0
    union_n = 0
    seen_u: set[int] = set()
    for t in range(N_TABLES):
        if qfeat["v"][t] == 0:
            continue
        k = qfeat["k"][t]
        ids = posts[t].get(k & 0xFFF, [])
        if keychk:
            for nid in ids:
                if c.key(nid, t) != k:
                    continue
                if nid not in seen_u:
                    seen_u.add(nid)
                    if nid in gset:
                        hit += 1
        else:
            for nid in ids:
                if nid not in seen_u:
                    seen_u.add(nid)
                    if nid in gset:
                        hit += 1
    union_n = len(seen_u)
    return {
        "n_gold_in_index": hit,
        "index_recall": (hit / len(gold)) if gold else None,
        "n_union": union_n,
        "index_recall_is_not_budgeted": True,
    }


def pr_metrics(emit: list[int], gold: list[int], n: int) -> dict:
    if not gold:
        prec = 1.0 if not emit else 0.0
        rec = None
        tp = 0
    else:
        gset = set(gold)
        tp = sum(1 for x in emit if x in gset)
        prec = (tp / len(emit)) if emit else 0.0
        rec = tp / len(gold)
    red = 1.0 - (len(emit) / n) if n else 0.0
    return {
        "tp": tp,
        "n_gold": len(gold),
        "precision": prec,
        "recall": rec,
        "reduction": red,
    }


def r6_regression() -> dict:
    r6 = json.loads((BAG_R6 / "METRICS.json").read_text(encoding="utf-8"))
    by = {x["query"]: x for x in r6["queries"]}
    docs = []
    for lab, forms in ENTITY_CANON.items():
        for t in forms:
            info = feat(t)
            docs.append({"nid": len(docs), "label": lab, **info})
    heads = [[list() for _ in range(N_BUCKETS)] for _ in range(N_TABLES)]
    for d in docs:
        for t in range(N_TABLES):
            if d["v"][t] == 0:
                continue
            b = d["k"][t] & 0xFFF
            if len(heads[t][b]) < HEAD_CAP:
                heads[t][b].append(d["nid"])
    checks = []
    fail = []
    for name in (
        "known_domain",
        "paraphrase",
        "same_entity_diff_intent",
        "unrelated_payroll",
        "unrelated_soccer",
        "adversarial",
    ):
        text = {
            "known_domain": "chiller",
            "paraphrase": "water chiller",
            "same_entity_diff_intent": "leak chiller",
            "unrelated_payroll": "payroll tax form",
            "unrelated_soccer": "soccer match score",
            "adversarial": adv0(),
        }[name]
        q = feat(text)
        g = by[name]
        if q["k"] != [g["k0"], g["k1"], g["k2"], g["k3"]]:
            fail.append(f"KEY_MISMATCH {name}")
        if q["v"] != [g["v0"], g["v1"], g["v2"], g["v3"]]:
            fail.append(f"VALID_MISMATCH {name}")
        seen = []
        seen_set = set()
        for t in range(N_TABLES):
            if q["v"][t] == 0:
                continue
            for nid in heads[t][q["k"][t] & 0xFFF]:
                if nid in seen_set:
                    continue
                if len(seen) >= 64:
                    break
                seen.append(nid)
                seen_set.add(nid)
        gold_ids_r6 = g["candidate_ids"]
        ok = seen == gold_ids_r6
        if not ok:
            fail.append(f"EMIT_MISMATCH {name} host={seen} r6={gold_ids_r6}")
        checks.append({
            "name": name,
            "text": text,
            "k": q["k"],
            "v": q["v"],
            "n_emit": len(seen),
            "emit": seen,
            "r6_n": len(gold_ids_r6),
            "match": ok,
        })
    wc = next(x for x in checks if x["name"] == "paraphrase")
    if wc["n_emit"] != 22:
        fail.append(f"WATER_CHILLER_NOT_22 got={wc['n_emit']}")
    return {
        "result": "PASS" if not fail else "FAIL",
        "fail": fail,
        "corpus_size": len(docs),
        "water_chiller_emit": wc["n_emit"],
        "checks": checks,
    }


def needle_hits(emit: list[int], gold: list[int], posts, qfeat: dict) -> dict:
    if not gold:
        return {"head_nid": None, "tail_nid": None, "head_hit": None, "tail_hit": None}
    longest = []
    for t in range(N_TABLES):
        if qfeat["v"][t] == 0:
            continue
        ids = posts[t].get(qfeat["k"][t] & 0xFFF, [])
        if len(ids) > len(longest):
            longest = ids
    gset = set(gold)
    head_nid = next((x for x in longest if x in gset), gold[0])
    tail_nid = next((x for x in reversed(longest) if x in gset), gold[-1])
    eset = set(emit)
    return {
        "head_nid": head_nid,
        "tail_nid": tail_nid,
        "head_hit": head_nid in eset,
        "tail_hit": tail_nid in eset,
        "longest_posting": len(longest),
    }


def eval_n(n: int, queries: list[dict]) -> dict:
    t0 = time.perf_counter()
    print(f"ASTRA02 BUILD N={n}", flush=True)
    c = build_corpus(n)
    posts, istats = build_index(c)
    if istats["coverage_valid"] < TH_COVERAGE - 1e-12:
        istats["coverage_fail"] = True
    rows = []
    q_out = []
    for spec in queries:
        qf = feat(spec["text"])
        if qf["n_host"] != 0:
            raise SystemExit(f"HOST_SEMANTIC_LEAK query {spec['name']}")
        gold = gold_ids(c, spec)
        cover_bucket = unlimited_cover(c, posts, qf, gold, keychk=False)
        cover_key = unlimited_cover(c, posts, qf, gold, keychk=True)
        modes_out = {}
        for mode in MODES:
            cap_out = {}
            for cap in CAPS:
                tq = time.perf_counter()
                w = walk_query(c, posts, qf, mode, cap)
                host_ms = (time.perf_counter() - tq) * 1000.0
                pr = pr_metrics(w["emit"], gold, n)
                ndl = needle_hits(w["emit"], gold, posts, qf)
                inadmissible = cap >= n
                rec = {
                    "cap": cap,
                    "cap_lt_N": cap < n,
                    "selectivity_inadmissible": inadmissible,
                    "n_dir": w["n_dir"],
                    "n_emit": w["n_emit"],
                    "n_predup": w["n_predup"],
                    "n_dup": w["n_dup"],
                    "n_trunc": w["n_trunc"],
                    "n_keydrop": w["n_keydrop"],
                    "bytes": w["bytes"],
                    "bytes_not_16xn_emit": w["bytes"] != 16 * w["n_emit"],
                    "n_post_beats": w["n_post_beats"],
                    "n_hdr": w["n_hdr"],
                    "n_pages_read": w["n_pages_read"],
                    "n_pages_total": w["n_pages_total"],
                    "overflow_flag": w["overflow_flag"],
                    "overflow_unread": w["overflow_unread"],
                    "incomplete_budget": w["incomplete_budget"],
                    "status": w["status"],
                    "precision": pr["precision"],
                    "recall": pr["recall"],
                    "reduction": pr["reduction"],
                    "tp": pr["tp"],
                    "n_gold": pr["n_gold"],
                    "posting_lens": w["posting_lens"],
                    "dir_addr": w["dir_addr"],
                    "probed": w["probed"],
                    "host_ms": round(host_ms, 4),
                    "est_ns_100mhz": w["est_ns_100mhz"],
                    "est_latency_is_not_silicon": True,
                    "needle": ndl,
                    "emit_head": w["emit"][:16],
                    "emit_has_gt16bit": any(x > 65535 for x in w["emit"]),
                }
                if n <= 4096 and cap == 64:
                    rec["emit_full"] = w["emit"]
                cap_out[str(cap)] = rec
                rows.append({
                    "N": n,
                    "cap": cap,
                    "mode": mode,
                    "qclass": spec["class"],
                    "qname": spec["name"],
                    **{k: rec[k] for k in (
                        "n_gold", "n_emit", "n_predup", "n_dup", "n_trunc", "n_keydrop",
                        "precision", "recall", "reduction", "bytes", "status",
                        "overflow_unread", "cap_lt_N", "host_ms",
                    )},
                })
            modes_out[mode] = cap_out
        q_out.append({
            "name": spec["name"],
            "class": spec["class"],
            "text": spec["text"],
            "k": qf["k"],
            "v": qf["v"],
            "packet": {"eid": qf["eid"], "iid": qf["iid"], "rid": qf["rid"], "xid": qf["xid"]},
            "n_gold": len(gold),
            "gold_head": gold[:8],
            "gold_tail": gold[-8:] if gold else [],
            "cover_bucket": cover_bucket,
            "cover_keychk": cover_key,
            "modes": modes_out,
        })
    role_collapse = None
    try:
        e_fwd = q_out[6]["modes"]["rtl_head_union"]["64"]["emit_head"]
        e_rev = q_out[7]["modes"]["rtl_head_union"]["64"]["emit_head"]
        # compare full emit when archived else head
        ef = q_out[6]["modes"]["rtl_head_union"]["64"].get("emit_full", e_fwd)
        er = q_out[7]["modes"]["rtl_head_union"]["64"].get("emit_full", e_rev)
        role_collapse = ef == er
    except Exception:
        role_collapse = None
    audit_collapse = None
    try:
        af = q_out[8]["modes"]["rtl_head_union"]["64"].get(
            "emit_full", q_out[8]["modes"]["rtl_head_union"]["64"]["emit_head"]
        )
        ar = q_out[9]["modes"]["rtl_head_union"]["64"].get(
            "emit_full", q_out[9]["modes"]["rtl_head_union"]["64"]["emit_head"]
        )
        audit_collapse = af == ar
    except Exception:
        audit_collapse = None
    dt = time.perf_counter() - t0
    print(f"ASTRA02 DONE N={n} seconds={dt:.3f} coverage={istats['coverage_valid']}", flush=True)
    return {
        "N": n,
        "build_s": dt,
        "index": istats,
        "role_fwd_rev_emit_equal_rtl64": role_collapse,
        "audit_fwd_rev_emit_equal_rtl64": audit_collapse,
        "queries": q_out,
        "rows": rows,
        "class_summary_rtl64": class_summary(rows, n, 64, "rtl_head_union"),
        "class_summary_fullkey64": class_summary(rows, n, 64, "full_ovf_union_keychk"),
    }


def class_summary(rows, n, cap, mode):
    by = defaultdict(list)
    for r in rows:
        if r["N"] == n and r["cap"] == cap and r["mode"] == mode:
            by[r["qclass"]].append(r)
    out = {}
    for cls, xs in by.items():
        recs = [x["recall"] for x in xs if x["recall"] is not None]
        precs = [x["precision"] for x in xs]
        reds = [x["reduction"] for x in xs]
        out[cls] = {
            "n_q": len(xs),
            "mean_precision": sum(precs) / len(precs) if precs else None,
            "mean_recall": sum(recs) / len(recs) if recs else None,
            "mean_reduction": sum(reds) / len(reds) if reds else None,
            "mean_n_emit": sum(x["n_emit"] for x in xs) / len(xs),
            "mean_bytes": sum(x["bytes"] for x in xs) / len(xs),
            "n_incomplete": sum(1 for x in xs if x["status"] == "SEARCH_INCOMPLETE"),
            "n_no_evidence": sum(1 for x in xs if x["status"] == "NO_EVIDENCE"),
            "unrelated_reject": (
                sum(1 for x in xs if x["n_emit"] == 0) / len(xs)
                if cls == "unrelated"
                else None
            ),
        }
    return out


def fmt(x, nd=4):
    if x is None:
        return "n/a"
    if isinstance(x, float):
        return f"{x:.{nd}f}"
    return str(x)


def write_results(r6, ladder, max_n, incomplete_reason, sha) -> str:
    lines = []
    lines.append("# RESULTS — ASTRA-02-SCALE-SELECTIVITY-00")
    lines.append("")
    lines.append("```text")
    lines.append(f"GATE        = {GATE}")
    r6s = r6["result"]
    cov_ok = all(s["index"]["coverage_valid"] >= TH_COVERAGE - 1e-12 for s in ladder)
    lines.append(f"R6_REGRESSION = {r6s}  water_chiller_emit={r6['water_chiller_emit']}/42")
    lines.append(f"HOST_LADDER  = RAN max_N={max_n} rungs={',' .join(str(s['N']) for s in ladder)}")
    lines.append(f"FULL_INDEX_COVERAGE = {'PASS' if cov_ok else 'FAIL'}")
    lines.append("XSIM_800K   = NOT_RUN")
    lines.append("BIT         = NO")
    lines.append("PROGRAM     = NO")
    lines.append("COM12       = UNTOUCHED")
    lines.append("JTAG        = 210319BE776EA UNTOUCHED")
    lines.append("RTL_EDIT    = NO")
    lines.append("U4_SEMANTIC = NO")
    lines.append("OCCUPANCY_AS_SEMANTIC = NO")
    lines.append("K2K3_FROM_NID = NO")
    lines.append("GATE14_PASS = NO")
    lines.append("SILICON     = NOT_RUN")
    lines.append("V31_WRITES  = 0")
    if incomplete_reason:
        lines.append(f"SEARCH_NOTE = {incomplete_reason}")
    lines.append("```")
    lines.append("")
    lines.append("## Primary unknown — answered at HOST_MODEL class")
    lines.append("")
    lines.append(
        "Independent gold (generator labels) + actual QSE keys/valid bits, "
        "with overflow pages storing every valid-key record. Not occupancy-from-nid. "
        "Not board. Not 800k XSim."
    )
    lines.append("")
    if max_n < 800000:
        lines.append(
            f"**Honest max N this turn = {max_n}.** Remaining rungs were not fabricated. "
            "That is SEARCH_INCOMPLETE on the ladder, not NO_EVIDENCE."
        )
        lines.append("")
    lines.append("## Lineage")
    lines.append("")
    lines.append("| Field | Value |")
    lines.append("|--|--|")
    lines.append("| HEAD | `5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1` |")
    lines.append("| Query law | `qse-v1-lexicon-hdc-00` unchanged |")
    lines.append("| Validity | U4A-R6 bind/hit; **not** `(key != 0)` |")
    lines.append("| Geometry | U4-PRE0 P4_4k_h64 |")
    lines.append("| Index | `astra02-ovf-page-v1` HOST; RTL walker still head-only |")
    lines.append("| Gold | generator labels, before hash |")
    lines.append("| Not used as authority | U4A-R3 `k2=nid&0xffff` scale path |")
    lines.append("")
    lines.append("SHA256 of reused law sources:")
    lines.append("")
    lines.append("```text")
    for k, v in sha.items():
        lines.append(f"{v}  {k}")
    lines.append("```")
    lines.append("")
    lines.append("## R6 freeze (42-title corpus)")
    lines.append("")
    lines.append(
        f"Result **{r6s}**. `water chiller` emit={r6['water_chiller_emit']} "
        "(AUDIT/HANDOFF: still 22/42 under this law)."
    )
    lines.append("")
    lines.append("| query | n_emit | match R6 |")
    lines.append("|-------|-------:|:--------:|")
    for ch in r6["checks"]:
        lines.append(f"| {ch['name']} `{ch['text']}` | {ch['n_emit']} | {'Y' if ch['match'] else 'N'} |")
    if r6["fail"]:
        lines.append("")
        lines.append("Failures: " + "; ".join(r6["fail"]))
    lines.append("")
    lines.append("## Index integrity (FULL overflow pages, NOT_SEMANTIC occupancy)")
    lines.append("")
    lines.append(
        "| N | valid-key | indexed | coverage | ovf pages | post max | bucket max | empty frac | sentinel | low16 pair |"
    )
    lines.append("|--:|--:|--:|--:|--:|--:|--:|--:|:--:|:--:|")
    for s in ladder:
        ix = s["index"]
        lines.append(
            f"| {ix['N']} | {ix['n_valid_key']} | {ix['n_indexed']} | "
            f"{ix['coverage_valid']:.6f} | {ix['n_overflow_pages']} | {ix['posting_len_max']} | "
            f"{ix['bucket_occ_max']} | {ix['empty_frac']:.4f} | "
            f"{ix['sentinel_799999']} | {ix['low16_pair']} |"
        )
    lines.append("")
    lines.append(
        "Coverage is “every record with a valid bit sits in a posting chain”, "
        "including overflow pages. It is **not** semantic recall."
    )
    lines.append("")
    lines.append("## Ladder @ CAND_CAP=64 (selectivity only where cap < N)")
    lines.append("")
    for s in ladder:
        n = s["N"]
        lines.append(f"### N={n}")
        lines.append("")
        lines.append(
            f"role_fwd vs role_rev emit-equal (rtl_head cap=64): "
            f"**{s['role_fwd_rev_emit_equal_rtl64']}**. "
            f"audit supplies pair emit-equal: **{s['audit_fwd_rev_emit_equal_rtl64']}**."
        )
        lines.append("")
        lines.append(
            "| mode | class | n_gold | emit | prec | rec | red | bytes | status | ovf_unread |"
        )
        lines.append("|------|-------|-------:|-----:|-----:|----:|----:|------:|--------|------------|")
        for q in s["queries"]:
            for mode in ("rtl_head_union", "full_ovf_union_keychk"):
                rec = q["modes"][mode]["64"]
                lines.append(
                    f"| {mode} | {q['class']} `{q['name']}` | {q['n_gold']} | {rec['n_emit']} | "
                    f"{fmt(rec['precision'])} | {fmt(rec['recall'])} | {fmt(rec['reduction'])} | "
                    f"{rec['bytes']} | {rec['status']} | {rec['overflow_unread']} |"
                )
        lines.append("")
        lines.append("Per-class means @ cap=64 `rtl_head_union`:")
        lines.append("")
        cs = s["class_summary_rtl64"]
        lines.append("| class | mean prec | mean rec | mean red | mean emit | mean bytes | incomplete | no_ev |")
        lines.append("|-------|----------:|---------:|---------:|----------:|-----------:|-----------:|------:|")
        for cls, m in cs.items():
            lines.append(
                f"| {cls} | {fmt(m['mean_precision'])} | {fmt(m['mean_recall'])} | "
                f"{fmt(m['mean_reduction'])} | {fmt(m['mean_n_emit'], 2)} | {fmt(m['mean_bytes'], 1)} | "
                f"{m['n_incomplete']} | {m['n_no_evidence']} |"
            )
        lines.append("")
        ur = cs.get("unrelated", {})
        if ur:
            lines.append(
                f"Unrelated rejection (emit==0): {fmt(ur.get('unrelated_reject'))} "
                f"(threshold {TH_UNRELATED})."
            )
            lines.append("")
    lines.append("## SEARCH_INCOMPLETE vs NO_EVIDENCE")
    lines.append("")
    lines.append(
        "- **NO_EVIDENCE**: all valid bits 0 (unrelated/adversarial) so n_dir=0, "
        "or every probed posting empty with no unread overflow."
    )
    lines.append(
        "- **SEARCH_INCOMPLETE**: overflow pages not walked (RTL head), byte budget "
        f"{BYTE_BUDGET} exhausted, or CAND_CAP truncation. Gold may exist; abstain ≠ empty corpus."
    )
    lines.append("")
    lines.append("Needle head/tail (known_domain_chiller, cap=64):")
    lines.append("")
    lines.append("| N | mode | head_nid | head_hit | tail_nid | tail_hit | longest_posting |")
    lines.append("|--:|------|---------:|:--------:|---------:|:--------:|----------------:|")
    for s in ladder:
        q = next(x for x in s["queries"] if x["name"] == "known_domain_chiller")
        for mode in ("rtl_head_union", "full_ovf_union"):
            rec = q["modes"][mode]["64"]
            nd = rec["needle"]
            lines.append(
                f"| {s['N']} | {mode} | {nd['head_nid']} | {nd['head_hit']} | "
                f"{nd['tail_nid']} | {nd['tail_hit']} | {nd['longest_posting']} |"
            )
    lines.append("")
    lines.append("## Cap sweep (known_domain_chiller only; skip selectivity if cap≥N)")
    lines.append("")
    lines.append("| N | cap | cap<N | rtl emit/rec/bytes | full_keychk emit/rec/bytes | isect emit/rec/bytes |")
    lines.append("|--:|----:|:-----:|--------------------|----------------------------|----------------------|")
    for s in ladder:
        q = next(x for x in s["queries"] if x["name"] == "known_domain_chiller")
        for cap in CAPS:
            a = q["modes"]["rtl_head_union"][str(cap)]
            b = q["modes"]["full_ovf_union_keychk"][str(cap)]
            d = q["modes"]["full_ovf_intersect_keychk"][str(cap)]
            def cell(r):
                return f"{r['n_emit']}/{fmt(r['recall'])}/{r['bytes']}/{r['status'][:4]}"
            lines.append(
                f"| {s['N']} | {cap} | {a['cap_lt_N']} | {cell(a)} | {cell(b)} | {cell(d)} |"
            )
    lines.append("")
    lines.append("Intersect bytes are HOST_SET membership plus rarest-list AXI walk; not an AXI claim.")
    lines.append("")
    lines.append("## Profile freeze verdict")
    lines.append("")
    freeze_ok = True
    reasons = []
    for s in ladder:
        if s["N"] < 4096:
            continue
        cs = s["class_summary_rtl64"]
        recs = []
        for cls in ("known_domain", "same_entity_diff_intent", "role_fwd", "role_rev"):
            if cls in cs and cs[cls]["mean_recall"] is not None:
                recs.append(cs[cls]["mean_recall"])
        mean_rec = sum(recs) / len(recs) if recs else 0.0
        reds = []
        for cls, m in cs.items():
            if m["mean_reduction"] is not None:
                reds.append(m["mean_reduction"])
        mean_red = sum(reds) / len(reds) if reds else 0.0
        ur = cs.get("unrelated", {}).get("unrelated_reject")
        if mean_rec < TH_RECALL:
            freeze_ok = False
            reasons.append(f"N={s['N']} rtl_head cap64 mean_recall={mean_rec:.4f} < {TH_RECALL}")
        if mean_red < TH_REDUCTION:
            freeze_ok = False
            reasons.append(f"N={s['N']} rtl_head cap64 mean_reduction={mean_red:.4f} < {TH_REDUCTION}")
        if ur is not None and ur < TH_UNRELATED:
            freeze_ok = False
            reasons.append(f"N={s['N']} unrelated_reject={ur:.4f} < {TH_UNRELATED}")
        if s["role_fwd_rev_emit_equal_rtl64"]:
            freeze_ok = False
            reasons.append(f"N={s['N']} ROLE_COLLAPSE role_fwd emit == role_rev emit")
        if s["index"]["coverage_valid"] < TH_COVERAGE - 1e-12:
            freeze_ok = False
            reasons.append(f"N={s['N']} FULL coverage {s['index']['coverage_valid']}")
    if max_n < 800000:
        freeze_ok = False
        reasons.append(f"ladder incomplete max_N={max_n}")
    if freeze_ok:
        lines.append("**SELECTED_PROFILE_FREEZE = YES** (all prereg thresholds held).")
    else:
        lines.append("**SELECTED_PROFILE_FREEZE = NO.** P4_4k_h64 is measured, not promoted.")
        lines.append("")
        lines.append("Reasons (not retargeted):")
        for r in reasons:
            lines.append(f"- {r}")
    lines.append("")
    lines.append("## Not claimed")
    lines.append("")
    lines.append(
        "U4 semantic PASS, occupancy semantic recall, board/MIG/BIT/PROGRAM, "
        "role-aware parse (ASTRA-03), 2-hop, reward learner, LM language, GATE14, "
        "production profile freeze, FPGA latency from host wall time, "
        "intersect AXI byte bound."
    )
    lines.append("")
    lines.append("## Next")
    lines.append("")
    lines.append(
        "ASTRA-03 role-aware query: subject/object must not collapse. "
        "Do not program COM12. Do not call this occupancy semantic recall."
    )
    lines.append("")
    return "\n".join(lines) + "\n"


def write_tsv(rows, path: Path) -> None:
    cols = [
        "N", "cap", "mode", "qclass", "qname", "n_gold", "n_emit", "n_predup",
        "n_dup", "n_trunc", "n_keydrop", "precision", "recall", "reduction",
        "bytes", "status", "overflow_unread", "cap_lt_N", "host_ms",
    ]
    with path.open("w", encoding="utf-8", newline="\n") as f:
        f.write("\t".join(cols) + "\n")
        for r in rows:
            f.write("\t".join("" if r.get(c) is None else str(r.get(c)) for c in cols) + "\n")


def main(argv: list[str]) -> int:
    max_want = 800000
    if "--max-n" in argv:
        max_want = int(argv[argv.index("--max-n") + 1])
    (BAG / "LOCK.txt").write_text("ASTRA-02 running\n", encoding="utf-8")
    t_all = time.perf_counter()
    print("ASTRA02 R6_REGRESSION", flush=True)
    r6 = r6_regression()
    (BAG / "R6_REGRESSION.json").write_text(json.dumps(r6, indent=2) + "\n", encoding="utf-8")
    print("R6", r6["result"], "water_chiller", r6["water_chiller_emit"], r6["fail"], flush=True)
    if r6["result"] != "PASS":
        (BAG / "RESULTS.md").write_text(
            "# RESULTS — ASTRA-02\n\nR6 regression FAIL. Scale ladder not started.\n"
            + json.dumps(r6, indent=2),
            encoding="utf-8",
        )
        return 7

    queries = query_specs()
    ladder = []
    all_rows = []
    incomplete_reason = None
    max_n = 0
    try:
        for n in LADDER:
            if n > max_want:
                incomplete_reason = f"stopped by --max-n {max_want}"
                break
            s = eval_n(n, queries)
            max_n = n
            all_rows.extend(s["rows"])
            slim = {k: v for k, v in s.items() if k != "rows"}
            ladder.append(slim)
    except MemoryError as e:
        incomplete_reason = f"MemoryError after max_N={max_n}: {e}"
        print(incomplete_reason, flush=True)
    except Exception as e:
        incomplete_reason = f"{type(e).__name__} after max_N={max_n}: {e}"
        print(incomplete_reason, flush=True)
        if max_n == 0:
            raise

    sha = {
        "twin.py": sha256_file(BAG_U3Q / "twin.py"),
        "lexicon.py": sha256_file(BAG_U3Q / "lexicon.py"),
        "a7ng_sparse_dir_axi.sv": sha256_file(
            BAG.parents[2] / "rtl" / "native_graph" / "memory" / "a7ng_sparse_dir_axi.sv"
        ),
        "a7ng_query_struct_extract.sv": sha256_file(
            BAG.parents[2] / "rtl" / "native_graph" / "query" / "a7ng_query_struct_extract.sv"
        ),
        "host_astra02.py": sha256_file(Path(__file__)),
        "_PREREG.md": sha256_file(BAG / "_PREREG.md"),
    }
    # BAG.parents[2] is repo? BAG=results/A7-NATIVE-GRAPH/ASTRA-02... parents[0]=A7-NATIVE-GRAPH, [1]=results, [2]=repo
    metrics = {
        "gate": GATE,
        "law": LAW,
        "validity_law": "U4A-R6 bind-state; NOT (key != 0)",
        "geometry": "P4_4k_h64",
        "index_law": "astra02-ovf-page-v1 HOST overflow pages",
        "byte_budget": BYTE_BUDGET,
        "cand_cap_sweep": list(CAPS),
        "ladder_N": [s["N"] for s in ladder],
        "max_N": max_n,
        "ladder_incomplete_reason": incomplete_reason,
        "r6": {"result": r6["result"], "water_chiller_emit": r6["water_chiller_emit"]},
        "sha256": sha,
        "elapsed_s": time.perf_counter() - t_all,
        "bit": "NO",
        "program": "NO",
        "com12": "UNTOUCHED",
        "occupancy_as_semantic": False,
        "k2k3_from_nid": False,
        "ladder": ladder,
    }
    (BAG / "METRICS.json").write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")
    write_tsv(all_rows, BAG / "LADDER.tsv")
    (BAG / "INDEX_STATS.json").write_text(
        json.dumps([s["index"] for s in ladder], indent=2) + "\n", encoding="utf-8"
    )
    sample = []
    for s in ladder:
        if s["N"] > 4096:
            continue
        sample.append({
            "N": s["N"],
            "queries": [
                {
                    "name": q["name"],
                    "class": q["class"],
                    "k": q["k"],
                    "v": q["v"],
                    "n_gold": q["n_gold"],
                    "rtl64": q["modes"]["rtl_head_union"]["64"],
                    "full_keychk64": q["modes"]["full_ovf_union_keychk"]["64"],
                }
                for q in s["queries"]
            ],
        })
    (BAG / "SAMPLE.json").write_text(json.dumps(sample, indent=2) + "\n", encoding="utf-8")
    md = write_results(r6, ladder, max_n, incomplete_reason, sha)
    (BAG / "RESULTS.md").write_text(md, encoding="utf-8")
    (BAG / "LOCK.txt").write_text("ASTRA-02 done\n", encoding="utf-8")
    print("ASTRA02_HOST_GOLDEN_DONE max_N", max_n, "seconds", f"{metrics['elapsed_s']:.3f}", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
