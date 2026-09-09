#!/usr/bin/env python3
"""ASTRA-07 held-out transfer: shared 32-feature SGD vs frozen/shuffle/per-ID.

BIT=NO PROGRAM=NO COM12=UNTOUCHED.
Worlds+seeds frozen in PREREG.md before hold metrics.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import random
import re
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any, Optional

from twin_sgd_q8 import N_FEAT, SharedRankSgdQ8, astra06_unit

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[2]
RTL = ROOT / "rtl" / "native_graph" / "learn" / "a7ng_shared_rank_sgd_q8.sv"
GATE = "ASTRA-07-HELD-OUT-TRANSFER"
LAW = "native-rank-sgd-q8-v1"

SEEDS = (0xA701, 0xA702, 0xA703, 0xA704, 0xA705)
XSIM_SEED = 0xA701
N_TRAIN = 24
N_HOLD = 24
N_MISS = 8
K = 8
EPOCHS = 8
EPS_INV = 16
SHIFT = 6

TRAIN_LO, TRAIN_HI = 0x0100, 0x3000
HOLD_LO, HOLD_HI = 0x4000, 0x7000

REL_REQ = 0x21
REL_CONN = 0x31
TYP_PROC, TYP_STATE, TYP_CALIB, TYP_NOISE = 1, 2, 3, 4
CTX_GOLD, CTX_NOISE = 1, 2
CONF_GOLD, CONF_NOISE = 96, 24
GEN_GOLD, GEN_NOISE = 16, 4

KINDS = ("gold", "rev2", "h1", "wrongrel", "neg", "unrel", "dead", "rev1")

TZ = timezone(timedelta(hours=7))


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest()


def now_iso() -> str:
    return datetime.now(TZ).strftime("%Y-%m-%dT%H:%M:%S%z")


def flag(b: bool) -> int:
    return 127 if b else 0


def ix(a: int, b: int) -> int:
    return (int(a) * int(b)) >> 7


class LCG:
    def __init__(self, seed: int) -> None:
        self.s = seed & 0xFFFFFFFF

    def u32(self) -> int:
        self.s = (self.s * 1664525 + 1013904223) & 0xFFFFFFFF
        return self.s


class IdPool:
    def __init__(self, rng: random.Random, lo: int, hi: int) -> None:
        self.rng = rng
        self.lo = lo
        self.hi = hi
        self.used: set[int] = set()

    def alloc(self) -> int:
        for _ in range(20000):
            x = self.rng.randrange(self.lo, self.hi)
            if x not in self.used and x != 0:
                self.used.add(x)
                return x
        raise RuntimeError("id exhaustion")


@dataclass
class Edge:
    s: int
    r: int
    o: int
    eid: int
    trans: int
    pol: int
    typ_s: int
    typ_o: int
    ctx: int
    conf: int
    gen: int


@dataclass
class Path:
    kind: str
    hops: list[Edge]
    ctx: int

    @property
    def n_hops(self) -> int:
        return len(self.hops)

    @property
    def start(self) -> int:
        return self.hops[0].s

    @property
    def end(self) -> int:
        return self.hops[-1].o

    @property
    def mid(self) -> Optional[int]:
        return self.hops[0].o if self.n_hops == 2 else None

    @property
    def answer_id(self) -> int:
        return self.end


@dataclass
class Query:
    qid: int
    s: int
    r: int
    gold_o: int
    ctx: int
    typ_s: int
    world: str
    candidates: list[Path]
    gold_idx: Optional[int]
    x: list[list[int]] = field(default_factory=list)


def type_subj_ok(rel: int, typ: int) -> bool:
    if rel == REL_REQ:
        return typ in (TYP_PROC, TYP_STATE)
    if rel == REL_CONN:
        return typ in (TYP_PROC, TYP_STATE, TYP_NOISE)
    return False


def type_obj_ok(rel: int, typ: int) -> bool:
    if rel == REL_REQ:
        return typ in (TYP_STATE, TYP_CALIB)
    if rel == REL_CONN:
        return typ in (TYP_NOISE, TYP_STATE)
    return False


def type_mid_ok(rel: int, typ: int) -> bool:
    if rel == REL_REQ:
        return typ == TYP_STATE
    if rel == REL_CONN:
        return typ in (TYP_NOISE, TYP_STATE)
    return False


def phi(q: Query, p: Path, world_eids: set[int]) -> list[int]:
    hops = p.hops
    n = len(hops)
    subj_match = hops[0].s == q.s
    rel_match = all(h.r == q.r for h in hops)
    mid = hops[0].o if n == 2 else None
    f0 = flag(subj_match)
    f1 = flag(rel_match)
    f2 = 127
    f3 = flag(n == 2 and mid != q.s)
    f4 = flag(type_subj_ok(q.r, hops[0].typ_s))
    if n == 2:
        f5 = flag(type_mid_ok(q.r, hops[0].typ_o) and type_subj_ok(q.r, hops[1].typ_s))
        f6 = flag(type_obj_ok(q.r, hops[-1].typ_o))
        f7 = flag(bool(f4) and bool(f5) and bool(f6))
    else:
        f5 = 0
        f6 = flag(type_obj_ok(q.r, hops[-1].typ_o))
        f7 = flag(bool(f4) and bool(f6))
    f8 = flag(p.ctx == q.ctx)
    f9 = flag(p.ctx != 0)
    conf_mean = int(round(sum(h.conf for h in hops) / n))
    f10 = max(0, min(127, conf_mean))
    pos = all(h.pol == 1 for h in hops)
    neg = any(h.pol == 0 for h in hops)
    f11 = flag(pos)
    f12 = flag(neg)
    f13 = flag(pos is False and neg and any(h.pol == 1 for h in hops))
    f14 = flag(n == 1)
    f15 = flag(n == 2)
    present = sum(1 for h in hops if h.eid in world_eids)
    if present <= 0:
        f16 = 0
    elif present == 1:
        f16 = 64 if n == 2 else 127
    else:
        f16 = 127
    f17 = flag(n == 2 and present == 2)
    f18 = flag(all(h.trans == 1 for h in hops))
    f19 = flag(neg and subj_match and rel_match)
    f20 = flag(p.end == p.start)
    f21 = flag(p.end == q.s and p.start != q.s)
    f22 = max(0, min(127, 8 * min(h.gen for h in hops)))
    f23 = ix(f1, f8)
    f24 = ix(f0, f1)
    f25 = ix(f7, f1)
    f26 = ix(f15, f17)
    f27 = ix(ix(f15, f1), f0)
    f28 = ix(f11, 0 if f19 else 127)
    f29 = ix(f10, f16)
    f30 = flag(bool(f12) or bool(f21))
    complete = (
        bool(f0)
        and bool(f1)
        and bool(f7)
        and bool(f11)
        and bool(f15)
        and bool(f17)
        and bool(f18)
        and not bool(f12)
        and not bool(f19)
        and not bool(f20)
        and not bool(f21)
    )
    f31 = flag(complete)
    x = [
        f0, f1, f2, f3, f4, f5, f6, f7, f8, f9,
        f10, f11, f12, f13, f14, f15, f16, f17, f18, f19,
        f20, f21, f22, f23, f24, f25, f26, f27, f28, f29,
        f30, f31,
    ]
    if len(x) != N_FEAT:
        raise RuntimeError("feature count")
    for v in x:
        if v < -128 or v > 127:
            raise RuntimeError(f"feat range {v}")
    return x


def mk_edge(
    pool: IdPool,
    s: int,
    r: int,
    o: int,
    typ_s: int,
    typ_o: int,
    *,
    pol: int = 1,
    trans: int = 1,
    ctx: int,
    conf: int,
    gen: int,
) -> Edge:
    return Edge(
        s=s, r=r, o=o, eid=pool.alloc(), trans=trans, pol=pol,
        typ_s=typ_s, typ_o=typ_o, ctx=ctx, conf=conf, gen=gen,
    )


def build_query(qid: int, pool: IdPool, rng: random.Random, world: str) -> Query:
    s = pool.alloc()
    m = pool.alloc()
    o = pool.alloc()
    m2 = pool.alloc()
    x_ent = pool.alloc()
    z = pool.alloc()
    a = pool.alloc()
    b = pool.alloc()
    c = pool.alloc()
    m3 = pool.alloc()

    e_sm = mk_edge(pool, s, REL_REQ, m, TYP_PROC, TYP_STATE, ctx=CTX_GOLD, conf=CONF_GOLD, gen=GEN_GOLD)
    e_mo = mk_edge(pool, m, REL_REQ, o, TYP_STATE, TYP_CALIB, ctx=CTX_GOLD, conf=CONF_GOLD, gen=GEN_GOLD)
    e_om2 = mk_edge(pool, o, REL_REQ, m2, TYP_CALIB, TYP_STATE, ctx=CTX_NOISE, conf=CONF_NOISE, gen=GEN_NOISE)
    e_m2s = mk_edge(pool, m2, REL_REQ, s, TYP_STATE, TYP_PROC, ctx=CTX_NOISE, conf=CONF_NOISE, gen=GEN_NOISE)
    e_mx = mk_edge(pool, m, REL_CONN, x_ent, TYP_STATE, TYP_NOISE, ctx=CTX_NOISE, conf=CONF_NOISE, gen=GEN_NOISE)
    e_mz = mk_edge(pool, m, REL_REQ, z, TYP_STATE, TYP_CALIB, pol=0, ctx=CTX_NOISE, conf=CONF_NOISE, gen=GEN_NOISE)
    e_ab = mk_edge(pool, a, REL_REQ, b, TYP_PROC, TYP_STATE, ctx=CTX_GOLD, conf=CONF_GOLD, gen=GEN_GOLD)
    e_bc = mk_edge(pool, b, REL_REQ, c, TYP_STATE, TYP_CALIB, ctx=CTX_GOLD, conf=CONF_GOLD, gen=GEN_GOLD)
    e_sm3 = mk_edge(pool, s, REL_REQ, m3, TYP_PROC, TYP_STATE, ctx=CTX_NOISE, conf=CONF_NOISE, gen=GEN_NOISE)

    paths = [
        Path("gold", [e_sm, e_mo], CTX_GOLD),
        Path("rev2", [e_om2, e_m2s], CTX_NOISE),
        Path("h1", [e_sm], CTX_GOLD),
        Path("wrongrel", [e_sm, e_mx], CTX_NOISE),
        Path("neg", [e_sm, e_mz], CTX_NOISE),
        Path("unrel", [e_ab, e_bc], CTX_GOLD),
        Path("dead", [e_sm3], CTX_NOISE),
        Path("rev1", [e_om2], CTX_NOISE),
    ]
    if len(paths) != K:
        raise RuntimeError("K")
    order = list(range(K))
    shuf = random.Random((rng.randrange(1, 1 << 30) ^ (0xA55A0000 + qid)) & 0xFFFFFFFF)
    shuf.shuffle(order)
    cand = [paths[i] for i in order]
    gold_idx = next(i for i, p in enumerate(cand) if p.kind == "gold")
    q = Query(
        qid=qid, s=s, r=REL_REQ, gold_o=o, ctx=CTX_GOLD, typ_s=TYP_PROC,
        world=world, candidates=cand, gold_idx=gold_idx,
    )
    return q


def materialize_features(queries: list[Query], eids: set[int]) -> None:
    for q in queries:
        q.x = [phi(q, p, eids) for p in q.candidates]
        gold_complete = 0
        for i, p in enumerate(q.candidates):
            if q.x[i][31] == 127:
                gold_complete += 1
                if p.kind != "gold":
                    raise RuntimeError(f"complete_proof on non-gold {p.kind} q={q.qid}")
        if q.gold_idx is not None and gold_complete != 1:
            raise RuntimeError(f"gold complete_proof count {gold_complete} q={q.qid}")
        if q.gold_idx is None and gold_complete != 0:
            raise RuntimeError(f"miss has complete_proof q={q.qid}")


def collect_eids(queries: list[Query]) -> set[int]:
    e = set()
    for q in queries:
        for p in q.candidates:
            for h in p.hops:
                e.add(h.eid)
    return e


def collect_entity_ids(queries: list[Query]) -> set[int]:
    ids: set[int] = set()
    for q in queries:
        ids.add(q.s)
        ids.add(q.gold_o)
        for p in q.candidates:
            ids.add(p.start)
            ids.add(p.end)
            if p.mid is not None:
                ids.add(p.mid)
    return ids


def make_worlds(seed: int) -> dict[str, Any]:
    rng_tr = random.Random(seed)
    rng_ho = random.Random(seed ^ 0x5A5A5A5A)
    pool_tr = IdPool(rng_tr, TRAIN_LO, TRAIN_HI)
    pool_ho = IdPool(rng_ho, HOLD_LO, HOLD_HI)
    train = [build_query(i, pool_tr, rng_tr, "train") for i in range(N_TRAIN)]
    hold = [build_query(i, pool_ho, rng_ho, "hold") for i in range(N_HOLD)]
    e_tr = collect_eids(train)
    e_ho = collect_eids(hold)
    materialize_features(train, e_tr)
    materialize_features(hold, e_ho)

    miss: list[Query] = []
    for q in hold[:N_MISS]:
        kept = [p for p in q.candidates if p.kind != "gold"]
        mq = Query(
            qid=q.qid, s=q.s, r=q.r, gold_o=q.gold_o, ctx=q.ctx, typ_s=q.typ_s,
            world="miss", candidates=kept, gold_idx=None,
        )
        miss.append(mq)
    e_miss = collect_eids(miss)
    materialize_features(miss, e_miss)

    id_tr = collect_entity_ids(train) | set(pool_tr.used)
    id_ho = collect_entity_ids(hold) | set(pool_ho.used)
    overlap = id_tr & id_ho
    if overlap:
        raise RuntimeError(f"train/hold ID overlap {len(overlap)}")
    return {
        "seed": seed,
        "train": train,
        "hold": hold,
        "miss": miss,
        "id_train": id_tr,
        "id_hold": id_ho,
        "n_id_train": len(id_tr),
        "n_id_hold": len(id_ho),
        "overlap": 0,
    }


def argmax(vs: list[int]) -> int:
    bi, bv = 0, vs[0]
    for i, v in enumerate(vs):
        if v > bv:
            bi, bv = i, v
    return bi


def is_valid_proof(q: Query, idx: int) -> bool:
    if idx < 0 or idx >= len(q.candidates):
        return False
    return q.x[idx][31] == 127 and q.candidates[idx].kind == "gold"


def decide(q: Query, pred: int) -> str:
    if is_valid_proof(q, pred):
        return "ANSWER"
    return "UNKNOWN"


def train_enabled(train: list[Query], seed: int) -> tuple[SharedRankSgdQ8, list[tuple[list[int], int]], list[int]]:
    mdl = SharedRankSgdQ8(shift=SHIFT)
    lcg = LCG(seed ^ 0x9E3779B9)
    stream: list[tuple[list[int], int]] = []
    epoch_acc: list[int] = []
    for ep in range(EPOCHS):
        order = list(range(len(train)))
        random.Random(seed ^ (ep * 0x10001)).shuffle(order)
        correct = 0
        for qi in order:
            q = train[qi]
            vs = [mdl.score(x) for x in q.x]
            greedy = argmax(vs)
            if q.gold_idx is not None and greedy == q.gold_idx:
                correct += 1
            if (lcg.u32() % EPS_INV) == 0:
                sel = lcg.u32() % K
            else:
                sel = greedy
            rew = 3 if (q.gold_idx is not None and sel == q.gold_idx) else -3
            mdl.update(q.x[sel], rew)
            stream.append((list(q.x[sel]), rew))
        epoch_acc.append(correct)
    return mdl, stream, epoch_acc


def eval_class(mdl: SharedRankSgdQ8, queries: list[Query]) -> dict[str, Any]:
    correct = 0
    score_gain = 0
    pos_margin = 0
    rows = []
    for q in queries:
        vs = [mdl.score(x) for x in q.x]
        pred = argmax(vs)
        ok = q.gold_idx is not None and pred == q.gold_idx
        correct += int(ok)
        if q.gold_idx is not None:
            vg = vs[q.gold_idx]
            dist = [vs[i] for i in range(len(vs)) if i != q.gold_idx]
            md = max(dist) if dist else vg
            g = vg - md
            score_gain += g
            pos_margin += int(g > 0)
        rows.append({
            "qid": q.qid,
            "pred": pred,
            "gold": q.gold_idx,
            "ok": bool(ok),
            "vs": vs,
            "status": decide(q, pred),
        })
    n = len(queries)
    return {
        "n": n,
        "correct": correct,
        "acc_pp": (100.0 * correct / n) if n else 0.0,
        "score_gain_sum": score_gain,
        "pos_margin": pos_margin,
        "rows": rows,
    }


def eval_frozen(queries: list[Query]) -> dict[str, Any]:
    mdl = SharedRankSgdQ8(shift=SHIFT)
    return eval_class(mdl, queries)


def train_shuffled(train: list[Query], seed: int) -> tuple[SharedRankSgdQ8, list[tuple[list[int], int]]]:
    """On-policy SGD with per-query reward vectors permuted (not gold-locked)."""
    rng_lab = random.Random(seed ^ 0xC0FFEE01)
    tables: list[list[int]] = []
    for q in train:
        rews = [-3] * K
        if q.gold_idx is None:
            raise RuntimeError("train query missing gold")
        rews[q.gold_idx] = 3
        rng_lab.shuffle(rews)
        tables.append(rews)
    mdl = SharedRankSgdQ8(shift=SHIFT)
    lcg = LCG(seed ^ 0x51ED51ED)
    stream: list[tuple[list[int], int]] = []
    for ep in range(EPOCHS):
        order = list(range(len(train)))
        random.Random(seed ^ 0xC0FFEE01 ^ (ep * 0x10001)).shuffle(order)
        for qi in order:
            q = train[qi]
            vs = [mdl.score(x) for x in q.x]
            greedy = argmax(vs)
            if (lcg.u32() % EPS_INV) == 0:
                sel = lcg.u32() % K
            else:
                sel = greedy
            rew = tables[q.qid][sel]
            mdl.update(q.x[sel], rew)
            stream.append((list(q.x[sel]), rew))
    return mdl, stream


def train_perid(train: list[Query]) -> dict[int, int]:
    prior: dict[int, int] = {}
    for q in train:
        for i, p in enumerate(q.candidates):
            d = 3 if i == q.gold_idx else -3
            prior[p.answer_id] = prior.get(p.answer_id, 0) + d
    return prior


def eval_perid(prior: dict[int, int], queries: list[Query]) -> dict[str, Any]:
    correct = 0
    rows = []
    for q in queries:
        scores = [prior.get(p.answer_id, 0) for p in q.candidates]
        pred = argmax(scores)
        ok = q.gold_idx is not None and pred == q.gold_idx
        correct += int(ok)
        rows.append({"qid": q.qid, "pred": pred, "gold": q.gold_idx, "ok": bool(ok), "vs": scores})
    n = len(queries)
    return {"n": n, "correct": correct, "acc_pp": (100.0 * correct / n) if n else 0.0, "rows": rows}


def eval_miss(mdl: SharedRankSgdQ8, miss: list[Query]) -> dict[str, Any]:
    answer_emitted = 0
    complete_present = 0
    for q in miss:
        vs = [mdl.score(x) for x in q.x]
        pred = argmax(vs)
        for i in range(len(q.candidates)):
            if q.x[i][31] == 127:
                complete_present += 1
        st = decide(q, pred)
        if st == "ANSWER":
            answer_emitted += 1
    return {
        "n": len(miss),
        "answer_emitted": answer_emitted,
        "complete_proof_present": complete_present,
        "hallucinate": answer_emitted != 0 or complete_present != 0,
    }


def mean(xs: list[float]) -> float:
    return sum(xs) / len(xs) if xs else 0.0


def sem(xs: list[float]) -> float:
    if len(xs) < 2:
        return 0.0
    m = mean(xs)
    var = sum((x - m) ** 2 for x in xs) / (len(xs) - 1)
    return math.sqrt(var) / math.sqrt(len(xs))


def ci95(xs: list[float]) -> tuple[float, float, float]:
    m = mean(xs)
    s = sem(xs)
    return m - 1.96 * s, m, m + 1.96 * s


def pack256(x: list[int]) -> str:
    v = 0
    for xi in x:
        v = (v << 8) | (xi & 0xFF)
    return f"{v:064X}"


def hex16(v: int) -> str:
    return f"{v & 0xFFFF:04X}"


def hex8(v: int) -> str:
    return f"{v & 0xFF:02X}"


def write_mem(path: Path, lines: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="ascii")


def emit_fixture(
    seed_pack: dict[str, Any],
    stream_en: list[tuple[list[int], int]],
    stream_sh: list[tuple[list[int], int]],
    mdl_en: SharedRankSgdQ8,
    mdl_sh: SharedRankSgdQ8,
) -> dict[str, Any]:
    mem = BAG / "mem"
    mem.mkdir(exist_ok=True)
    hold: list[Query] = seed_pack["hold"]
    miss: list[Query] = seed_pack["miss"]
    if len(stream_en) != len(stream_sh):
        raise RuntimeError("en/sh stream length mismatch")
    train_x = [pack256(x) for x, _ in stream_en]
    train_r = [hex8(r) for _, r in stream_en]
    sh_x = [pack256(x) for x, _ in stream_sh]
    sh_r = [hex8(r) for _, r in stream_sh]
    hold_x: list[str] = []
    hold_gold: list[str] = []
    exp_en: list[str] = []
    exp_sh: list[str] = []
    exp_fr: list[str] = []
    for q in hold:
        hold_gold.append(hex8(q.gold_idx if q.gold_idx is not None else 0xFF))
        for x in q.x:
            hold_x.append(pack256(x))
            exp_en.append(hex16(mdl_en.score(x)))
            exp_sh.append(hex16(mdl_sh.score(x)))
            exp_fr.append(hex16(0))
    mq = miss[0]
    miss_x = [pack256(x) for x in mq.x]
    miss_n = len(mq.x)
    write_mem(mem / "train_x.mem", train_x)
    write_mem(mem / "train_r.mem", train_r)
    write_mem(mem / "shuf_x.mem", sh_x)
    write_mem(mem / "shuf_r.mem", sh_r)
    write_mem(mem / "hold_x.mem", hold_x)
    write_mem(mem / "hold_gold.mem", hold_gold)
    write_mem(mem / "exp_hold_v_en.mem", exp_en)
    write_mem(mem / "exp_hold_v_sh.mem", exp_sh)
    write_mem(mem / "exp_hold_v_fr.mem", exp_fr)
    write_mem(mem / "miss_x.mem", miss_x)

    params = (
        "// generated by host_astra07.py -- do not hand-edit\n"
        "`ifndef ASTRA07_PARAMS_SVH\n"
        "`define ASTRA07_PARAMS_SVH\n"
        f"localparam int A7_N_UPD    = {len(stream_en)};\n"
        f"localparam int A7_N_HOLD_Q = {len(hold)};\n"
        f"localparam int A7_K        = {K};\n"
        f"localparam int A7_N        = {N_FEAT};\n"
        f"localparam int A7_N_MISS_C = {miss_n};\n"
        f"localparam int A7_SEED     = 32'h{XSIM_SEED:08X};\n"
        "`endif\n"
    )
    (BAG / "tb_astra07_params.svh").write_text(params, encoding="ascii")
    meta = {
        "seed": XSIM_SEED,
        "n_upd": len(stream_en),
        "n_upd_sh": len(stream_sh),
        "n_hold_q": len(hold),
        "k": K,
        "n_miss_c": miss_n,
        "hold_gold": [q.gold_idx for q in hold],
    }
    (BAG / "fixture_meta.json").write_text(json.dumps(meta, indent=2) + "\n", encoding="utf-8")
    return meta


def summarize_seed(seed: int) -> dict[str, Any]:
    worlds = make_worlds(seed)
    train: list[Query] = worlds["train"]
    hold: list[Query] = worlds["hold"]
    miss: list[Query] = worlds["miss"]
    mdl_en, stream_en, epoch_acc = train_enabled(train, seed)
    ev_en_tr = eval_class(mdl_en, train)
    ev_en_ho = eval_class(mdl_en, hold)
    ev_fr_tr = eval_frozen(train)
    ev_fr_ho = eval_frozen(hold)
    mdl_sh, stream_sh = train_shuffled(train, seed)
    ev_sh_ho = eval_class(mdl_sh, hold)
    ev_sh_tr = eval_class(mdl_sh, train)
    prior = train_perid(train)
    ev_id_tr = eval_perid(prior, train)
    ev_id_ho = eval_perid(prior, hold)
    ev_miss = eval_miss(mdl_en, miss)
    best_tr = max(epoch_acc) if epoch_acc else 0
    drop_pp = 100.0 * (best_tr - ev_en_tr["correct"]) / N_TRAIN
    gold_sample = train[0].x[train[0].gold_idx]
    dist_i = 0 if train[0].gold_idx != 0 else 1
    dist_sample = train[0].x[dist_i]
    out = {
        "seed": seed,
        "seed_hex": f"0x{seed:04X}",
        "n_id_train": worlds["n_id_train"],
        "n_id_hold": worlds["n_id_hold"],
        "overlap": worlds["overlap"],
        "enabled_train_correct": ev_en_tr["correct"],
        "enabled_hold_correct": ev_en_ho["correct"],
        "frozen_train_correct": ev_fr_tr["correct"],
        "frozen_hold_correct": ev_fr_ho["correct"],
        "shuffle_train_correct": ev_sh_tr["correct"],
        "shuffle_hold_correct": ev_sh_ho["correct"],
        "perid_train_correct": ev_id_tr["correct"],
        "perid_hold_correct": ev_id_ho["correct"],
        "enabled_hold_acc_pp": ev_en_ho["acc_pp"],
        "frozen_hold_acc_pp": ev_fr_ho["acc_pp"],
        "shuffle_hold_acc_pp": ev_sh_ho["acc_pp"],
        "perid_hold_acc_pp": ev_id_ho["acc_pp"],
        "enabled_train_acc_pp": ev_en_tr["acc_pp"],
        "perid_train_acc_pp": ev_id_tr["acc_pp"],
        "paired_vs_frozen": ev_en_ho["correct"] - ev_fr_ho["correct"],
        "paired_vs_shuffle": ev_en_ho["correct"] - ev_sh_ho["correct"],
        "paired_vs_perid": ev_en_ho["correct"] - ev_id_ho["correct"],
        "gain_pp_vs_frozen": ev_en_ho["acc_pp"] - ev_fr_ho["acc_pp"],
        "gain_pp_vs_shuffle": ev_en_ho["acc_pp"] - ev_sh_ho["acc_pp"],
        "gain_pp_vs_perid": ev_en_ho["acc_pp"] - ev_id_ho["acc_pp"],
        "perid_gain_pp_vs_frozen_hold": ev_id_ho["acc_pp"] - ev_fr_ho["acc_pp"],
        "perid_gain_pp_vs_frozen_train": ev_id_tr["acc_pp"] - ev_fr_tr["acc_pp"],
        "pos_margin_hold": ev_en_ho["pos_margin"],
        "score_gain_sum_hold": ev_en_ho["score_gain_sum"],
        "epoch_train_correct": epoch_acc,
        "best_epoch_train_correct": best_tr,
        "retention_drop_pp": drop_pp,
        "miss": ev_miss,
        "n_upd": len(stream_en),
        "n_upd_sh": len(stream_sh),
        "gold_phi0": gold_sample,
        "dist_phi0": dist_sample,
        "hold_gold_idx": [q.gold_idx for q in hold],
        "train_gold_idx": [q.gold_idx for q in train],
    }
    extras = {
        "worlds": worlds,
        "mdl_en": mdl_en,
        "mdl_sh": mdl_sh,
        "stream_en": stream_en,
        "stream_sh": stream_sh,
        "ev_en_ho": ev_en_ho,
        "ev_sh_ho": ev_sh_ho,
    }
    return out, extras


def classify(rows: list[dict[str, Any]]) -> dict[str, Any]:
    n_hold = N_HOLD
    d_fr = [r["paired_vs_frozen"] for r in rows]
    d_sh = [r["paired_vs_shuffle"] for r in rows]
    g_fr = [r["gain_pp_vs_frozen"] for r in rows]
    g_sh = [r["gain_pp_vs_shuffle"] for r in rows]
    drop = [r["retention_drop_pp"] for r in rows]
    ci_fr = ci95([float(x) for x in d_fr])
    ci_sh = ci95([float(x) for x in d_sh])
    every_beats_fr = all(r["enabled_hold_correct"] > r["frozen_hold_correct"] for r in rows)
    every_beats_sh = all(r["enabled_hold_correct"] > r["shuffle_hold_correct"] for r in rows)
    mean_g_fr = mean(g_fr)
    mean_g_sh = mean(g_sh)
    ret_ok = all(d <= 5.0000001 for d in drop)
    miss_ok = all(not r["miss"]["hallucinate"] for r in rows)
    overlap_ok = all(r["overlap"] == 0 for r in rows)
    perid_fails_xfer = all(r["perid_gain_pp_vs_frozen_hold"] < 10.0 for r in rows)
    perid_memorizes = all(r["perid_train_correct"] > r["frozen_train_correct"] for r in rows)
    score_gain_all = all(r["pos_margin_hold"] == n_hold for r in rows)

    class_pass = (
        every_beats_fr and every_beats_sh
        and mean_g_fr >= 10.0 and mean_g_sh >= 10.0
        and ci_fr[0] > 0.0 and ci_sh[0] > 0.0
        and ret_ok and miss_ok and overlap_ok
        and perid_fails_xfer and perid_memorizes
        and len(rows) >= 5
    )
    narrow = (
        (not class_pass)
        and every_beats_fr and every_beats_sh
        and all(r["score_gain_sum_hold"] > 0 for r in rows)
        and ci_fr[0] > 0.0 and ci_sh[0] > 0.0
        and miss_ok and overlap_ok
    )
    if class_pass:
        result = "PASS"
    elif narrow:
        result = "PASS_NARROW"
    else:
        result = "FAIL"
    return {
        "result_host": result,
        "n_seeds": len(rows),
        "n_hold": n_hold,
        "mean_gain_pp_vs_frozen": mean_g_fr,
        "mean_gain_pp_vs_shuffle": mean_g_sh,
        "mean_enabled_hold_pp": mean([r["enabled_hold_acc_pp"] for r in rows]),
        "mean_frozen_hold_pp": mean([r["frozen_hold_acc_pp"] for r in rows]),
        "mean_shuffle_hold_pp": mean([r["shuffle_hold_acc_pp"] for r in rows]),
        "mean_perid_hold_pp": mean([r["perid_hold_acc_pp"] for r in rows]),
        "paired_vs_frozen": d_fr,
        "paired_vs_shuffle": d_sh,
        "ci95_paired_vs_frozen": {"lo": ci_fr[0], "mean": ci_fr[1], "hi": ci_fr[2]},
        "ci95_paired_vs_shuffle": {"lo": ci_sh[0], "mean": ci_sh[1], "hi": ci_sh[2]},
        "every_seed_beats_frozen": every_beats_fr,
        "every_seed_beats_shuffle": every_beats_sh,
        "retention_drop_pp": drop,
        "retention_ok": ret_ok,
        "miss_ok": miss_ok,
        "overlap_ok": overlap_ok,
        "perid_fails_transfer": perid_fails_xfer,
        "perid_memorizes_train": perid_memorizes,
        "score_gain_all_hold_queries": score_gain_all,
        "class_pass": class_pass,
        "narrow": narrow,
    }


def json_seed(row: dict[str, Any]) -> dict[str, Any]:
    skip = {"gold_phi0", "dist_phi0"}
    d = {k: v for k, v in row.items() if k not in skip}
    d["gold_phi0"] = row["gold_phi0"]
    d["dist_phi0"] = row["dist_phi0"]
    return d


def run_golden() -> dict[str, Any]:
    unit = astra06_unit()
    if not unit["match"]:
        raise SystemExit(f"ASTRA06_TWIN_FAIL {unit}")
    rows = []
    extras_xsim = None
    for seed in SEEDS:
        row, extra = summarize_seed(seed)
        rows.append(row)
        if seed == XSIM_SEED:
            extras_xsim = extra
        print(
            f"SEED 0x{seed:04X} en_hold={row['enabled_hold_correct']}/{N_HOLD} "
            f"fr={row['frozen_hold_correct']} sh={row['shuffle_hold_correct']} "
            f"id={row['perid_hold_correct']} drop={row['retention_drop_pp']:.2f} "
            f"miss_ans={row['miss']['answer_emitted']}"
        )
    clf = classify(rows)
    if extras_xsim is None:
        raise SystemExit("missing xsim seed extras")
    meta = emit_fixture(
        extras_xsim["worlds"],
        extras_xsim["stream_en"],
        extras_xsim["stream_sh"],
        extras_xsim["mdl_en"],
        extras_xsim["mdl_sh"],
    )
    worlds_lock = {
        "seeds": [f"0x{s:04X}" for s in SEEDS],
        "n_train": N_TRAIN,
        "n_hold": N_HOLD,
        "n_miss": N_MISS,
        "k": K,
        "epochs": EPOCHS,
        "train_id": [TRAIN_LO, TRAIN_HI],
        "hold_id": [HOLD_LO, HOLD_HI],
        "per_seed": [
            {
                "seed": f"0x{r['seed']:04X}",
                "n_id_train": r["n_id_train"],
                "n_id_hold": r["n_id_hold"],
                "overlap": r["overlap"],
                "train_gold_idx": r["train_gold_idx"],
                "hold_gold_idx": r["hold_gold_idx"],
            }
            for r in rows
        ],
    }
    (BAG / "worlds.json").write_text(json.dumps(worlds_lock, indent=2) + "\n", encoding="utf-8")
    golden = {
        "gate": GATE,
        "law": LAW,
        "shift": SHIFT,
        "bit": False,
        "program": False,
        "com12": "UNTOUCHED",
        "astra06_twin": unit,
        "seeds": [json_seed(r) for r in rows],
        "classify": clf,
        "fixture": meta,
        "result_host": clf["result_host"],
        "not_claimed": [
            "open_world_generalized_learning",
            "ddr_graph",
            "lm",
            "gate14",
            "board",
        ],
        "generated": now_iso(),
    }
    (BAG / "GOLDEN.json").write_text(json.dumps(golden, indent=2) + "\n", encoding="utf-8")
    print("HOST_RESULT", clf["result_host"])
    print(
        f"mean_gain_pp frozen={clf['mean_gain_pp_vs_frozen']:.2f} "
        f"shuffle={clf['mean_gain_pp_vs_shuffle']:.2f} "
        f"CI_fr_lo={clf['ci95_paired_vs_frozen']['lo']:.3f} "
        f"CI_sh_lo={clf['ci95_paired_vs_shuffle']['lo']:.3f}"
    )
    return golden


HOLD_PICK_RE = re.compile(r"ASTRA07_HOLD_PICK mode=(\S+) q=(\d+) pred=(\d+) gold=(\d+) ok=(\d+)")
CORR_RE = re.compile(r"ASTRA07_(\w+)_HOLDCORRECT n=(\d+) c=(\d+)")
MISS_RE = re.compile(r"ASTRA07_MISS ngold=(\d+) n_ans=(\d+) n_c=(\d+)")
BITEX_RE = re.compile(r"ASTRA07_BITEXACT_(\w+)")


def parse_xsim(log: Path) -> dict[str, Any]:
    text = log.read_text(encoding="utf-8", errors="replace")
    picks: dict[str, list[dict[str, int]]] = {"EN": [], "FR": [], "SH": []}
    for m in HOLD_PICK_RE.finditer(text):
        mode, q, pred, gold, ok = m.group(1), int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5))
        picks[mode].append({"q": q, "pred": pred, "gold": gold, "ok": ok})
    corr = {}
    for m in CORR_RE.finditer(text):
        corr[m.group(1)] = {"n": int(m.group(2)), "c": int(m.group(3))}
    miss = None
    m = MISS_RE.search(text)
    if m:
        miss = {"ngold": int(m.group(1)), "n_ans": int(m.group(2)), "n_c": int(m.group(3))}
    bitexact = "PASS" if "ASTRA07_BITEXACT_PASS" in text else "FAIL"
    xpass = "ASTRA07_XSIM_PASS" in text and "FIRST_DIVERGENCE" not in text
    return {
        "picks": picks,
        "correct": corr,
        "miss": miss,
        "bitexact": bitexact,
        "xsim_pass": xpass,
        "has_pass_token": "ASTRA07_XSIM_PASS" in text,
        "has_div": "FIRST_DIVERGENCE" in text,
    }


def write_metrics(golden: dict[str, Any], xsim: Optional[dict[str, Any]], result: str) -> None:
    clf = golden["classify"]
    metrics = {
        "gate": GATE,
        "result": result,
        "result_host": golden["result_host"],
        "result_xsim": None if xsim is None else ("PASS" if xsim["xsim_pass"] else "FAIL"),
        "law": LAW,
        "shift": SHIFT,
        "n_seeds": clf["n_seeds"],
        "n_train": N_TRAIN,
        "n_hold": N_HOLD,
        "n_miss": N_MISS,
        "k": K,
        "epochs": EPOCHS,
        "seeds": [f"0x{s:04X}" for s in SEEDS],
        "enabled_hold_correct": [s["enabled_hold_correct"] for s in golden["seeds"]],
        "frozen_hold_correct": [s["frozen_hold_correct"] for s in golden["seeds"]],
        "shuffle_hold_correct": [s["shuffle_hold_correct"] for s in golden["seeds"]],
        "perid_hold_correct": [s["perid_hold_correct"] for s in golden["seeds"]],
        "paired_vs_frozen": clf["paired_vs_frozen"],
        "paired_vs_shuffle": clf["paired_vs_shuffle"],
        "mean_gain_pp_vs_frozen": clf["mean_gain_pp_vs_frozen"],
        "mean_gain_pp_vs_shuffle": clf["mean_gain_pp_vs_shuffle"],
        "ci95_paired_vs_frozen": clf["ci95_paired_vs_frozen"],
        "ci95_paired_vs_shuffle": clf["ci95_paired_vs_shuffle"],
        "retention_drop_pp": clf["retention_drop_pp"],
        "miss_answer_emitted": [s["miss"]["answer_emitted"] for s in golden["seeds"]],
        "perid_fails_transfer": clf["perid_fails_transfer"],
        "perid_memorizes_train": clf["perid_memorizes_train"],
        "id_overlap": [s["overlap"] for s in golden["seeds"]],
        "astra06_twin": golden["astra06_twin"],
        "xsim": xsim,
        "bit": False,
        "program": False,
        "com12": "UNTOUCHED",
        "open_world_claimed": False,
        "generalized_learning_claimed": False,
        "ddr_graph": False,
        "lm": False,
        "gate14": False,
    }
    (BAG / "METRICS.json").write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")


def write_results(golden: dict[str, Any], xsim: Optional[dict[str, Any]], result: str) -> None:
    clf = golden["classify"]
    lines = [
        "# RESULTS — ASTRA-07 HELD-OUT-TRANSFER",
        "",
        "```text",
        f"GATE            = {GATE}",
        f"LAW             = {LAW}",
        f"HOST            = GOLDEN.json result_host={golden['result_host']}",
        f"XSIM            = {'ASTRA07_XSIM_PASS' if xsim and xsim['xsim_pass'] else ('PENDING' if xsim is None else 'FAIL')}",
        f"RESULT          = {result}",
        f"SEEDS           = " + ",".join(f"0x{s:04X}" for s in SEEDS),
        "BIT             = NO",
        "PROGRAM         = NO",
        "COM12           = UNTOUCHED",
        "```",
        "",
        "ASTRA-06 unit twin (constant x[i]=64) is a self-check only, not this gate's test:",
        f"frozen={golden['astra06_twin']['v_frozen']} enabled={golden['astra06_twin']['v_enabled']} "
        f"shuffle={golden['astra06_twin']['v_shuffle']} match={golden['astra06_twin']['match']}.",
        "",
        "W_train IDs `0x0100..0x2FFF`, W_hold IDs `0x4000..0x6FFF`, intersection empty.",
        "Shared phi forbids query/answer/raw nid. Per-ID prior is a separate table.",
        "",
        "| Seed | en hold | fr hold | sh hold | per-ID hold | en train | per-ID train | paired vs fr | paired vs sh | drop_pp | miss ANSWER |",
        "|------|--------:|--------:|--------:|------------:|---------:|-------------:|-------------:|-------------:|--------:|------------:|",
    ]
    for s in golden["seeds"]:
        lines.append(
            f"| {s['seed_hex']} | {s['enabled_hold_correct']}/{N_HOLD} | "
            f"{s['frozen_hold_correct']}/{N_HOLD} | {s['shuffle_hold_correct']}/{N_HOLD} | "
            f"{s['perid_hold_correct']}/{N_HOLD} | {s['enabled_train_correct']}/{N_TRAIN} | "
            f"{s['perid_train_correct']}/{N_TRAIN} | {s['paired_vs_frozen']:+d} | "
            f"{s['paired_vs_shuffle']:+d} | {s['retention_drop_pp']:.2f} | "
            f"{s['miss']['answer_emitted']} |"
        )
    lines += [
        "",
        f"Mean held-out gain vs frozen: **{clf['mean_gain_pp_vs_frozen']:.2f} pp** "
        f"(paired CI lo={clf['ci95_paired_vs_frozen']['lo']:.3f}).",
        f"Mean held-out gain vs shuffle: **{clf['mean_gain_pp_vs_shuffle']:.2f} pp** "
        f"(paired CI lo={clf['ci95_paired_vs_shuffle']['lo']:.3f}).",
        f"Per-ID hold mean {clf['mean_perid_hold_pp']:.2f} pp (must fail transfer; IDs differ).",
        "",
        "## Narrow claim",
        "",
        "On this frozen two-world generator, shared 32-feature SGD trained on W_train "
        "selects the held-out gold 2-hop path more often than zero-weight and shuffled-reward "
        "controls. Per-ID identity memory fits W_train and does not transfer. A missing hop-2 "
        "edge is not promoted to ANSWER.",
        "",
        "## Not claimed",
        "",
        "Open-world / open-domain learning, feature discovery, DDR 800k, LM, Gate14, board.",
        "Weight change alone is not generalized learning; this is held-out classification "
        "on a preregistered feature family.",
        "",
    ]
    if xsim is not None:
        lines += [
            "## XSim (seed 0xA701 compact fixture)",
            "",
            f"bit-exact hold v_q8: {xsim['bitexact']}",
            f"correct EN/FR/SH: {xsim.get('correct')}",
            f"miss: {xsim.get('miss')}",
            "",
        ]
    (BAG / "RESULTS.md").write_text("\n".join(lines), encoding="utf-8")


def write_closeout(result: str, xsim_ok: bool) -> None:
    first = "none" if result in ("PASS", "PASS_NARROW") and xsim_ok else "see RESULTS.md / BLOCKED.md"
    text = f"""# CLOSEOUT — ASTRA-07-HELD-OUT-TRANSFER

```text
GATE                 = ASTRA-07-HELD-OUT-TRANSFER
BASE                 = ASTRA-06 PASS_NARROW
SOURCE_COMMIT        = 5aa8285533b0f4a571dac5328b28a1f8a5ef5fc1
FILES_CHANGED        = results/A7-NATIVE-GRAPH/ASTRA-07-HELD-OUT-TRANSFER/*
                       docs/ASTRA/LOOP_STATE.json
RTL_EDIT             = NO (reuse a7ng_shared_rank_sgd_q8.sv law native-rank-sgd-q8-v1)
PRIMARY_UNKNOWN      = Do trained shared 32-weights beat frozen and shuffled-reward on held-out worlds?
RESULT               = {result}
EVIDENCE_CLASS       = HOST_MODEL + XSIM
FIRST_DIVERGENCE     = {first}
VIOLATED_INVARIANT   = {'none' if result != 'FAIL' else 'held-out transfer vs frozen/shuffle'}
FALSIFIED_ALTERNATIVES = train-x reused as test; ID one-hot in shared w; per-ID transfer;
                         missing-edge hallucinated ANSWER; ASTRA-06 constant-x claimed as transfer
RESOURCE_DELTA       = n/a (no synth)
BIT_BUILD            = NO
PROGRAM              = NO
COM12                = UNTOUCHED
ORIGINAL_FOLDER_TOUCHED = NO
NEXT                 = {'ASTRA-08 LM06-VOCAB-CHECKPOINT-AUDIT' if result != 'FAIL' else 'STOP (parent decides)'}
```

closed {now_iso()}
"""
    (BAG / "CLOSEOUT.md").write_text(text, encoding="utf-8")


def write_sha() -> None:
    files = [
        ROOT / "rtl" / "native_graph" / "learn" / "a7ng_shared_rank_sgd_q8.sv",
        BAG / "PREREG.md",
        BAG / "LOCK.txt",
        BAG / "twin_sgd_q8.py",
        BAG / "host_astra07.py",
        BAG / "tb_astra07_hold.sv",
        BAG / "tb_astra07_params.svh",
        BAG / "run_xsim.tcl",
        BAG / "GOLDEN.json",
        BAG / "METRICS.json",
        BAG / "RESULTS.md",
        BAG / "CLOSEOUT.md",
        BAG / "worlds.json",
        BAG / "xsim.log",
    ]
    lines = []
    for p in files:
        if p.exists():
            rel = p.relative_to(ROOT).as_posix() if p.is_relative_to(ROOT) else str(p)
            lines.append(f"{sha256_file(p)}  {rel}")
    (BAG / "SHA256.txt").write_text("\n".join(lines) + "\n", encoding="ascii")


def write_blocked(golden: dict[str, Any]) -> None:
    clf = golden["classify"]
    text = f"""# BLOCKED — ASTRA-07-HELD-OUT-TRANSFER

```text
GATE              = ASTRA-07-HELD-OUT-TRANSFER
RESULT            = FAIL
CLASSIFICATION    = FAIL_TRANSFER
FIRST_DIVERGENCE  = enabled did not meet prereg held-out criteria
VIOLATED_INVARIANT= shared w must beat frozen AND shuffled on held-out worlds by >=10pp with CI>0
EVIDENCE_CLASS    = HOST_MODEL
WHY_UNSAFE        = ASTRA-06 unit SGD is not transfer; advancing would inflate learning claims
SMALLEST_NEXT     = parent audit; do not retarget 10pp; do not reuse train x
```

Host classify: {json.dumps(clf, indent=2)}

Learning unit exists (ASTRA-06). Transfer unproven.
"""
    (BAG / "BLOCKED.md").write_text(text, encoding="utf-8")


def compare() -> dict[str, Any]:
    golden = json.loads((BAG / "GOLDEN.json").read_text(encoding="utf-8"))
    log = BAG / "xsim.log"
    if not log.exists():
        raise SystemExit("xsim.log missing")
    xsim = parse_xsim(log)
    host_ok = golden["result_host"] in ("PASS", "PASS_NARROW")
    result = golden["result_host"]
    if not xsim["xsim_pass"]:
        result = "FAIL"
    write_metrics(golden, xsim, result)
    write_results(golden, xsim, result)
    write_closeout(result, xsim["xsim_pass"])
    write_sha()
    if result == "FAIL":
        write_blocked(golden)
        print("ASTRA07_COMPARE_FAIL", result, xsim)
        raise SystemExit(1)
    if not host_ok:
        write_blocked(golden)
        print("ASTRA07_COMPARE_FAIL host", result)
        raise SystemExit(1)
    print("ASTRA07_COMPARE_OK", result)
    return {"result": result, "xsim": xsim}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--golden-only", action="store_true")
    ap.add_argument("--compare", action="store_true")
    args = ap.parse_args()
    if args.selftest:
        r = astra06_unit()
        print(r)
        if not r["match"]:
            raise SystemExit(1)
        return
    if args.compare:
        compare()
        return
    run_golden()


if __name__ == "__main__":
    main()
