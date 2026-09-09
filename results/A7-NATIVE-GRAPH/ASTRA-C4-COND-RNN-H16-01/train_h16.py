#!/usr/bin/env python3
"""Local STE int8 Elman H=16 untied Wo for ASTRA-C4-COND-RNN-H16-01.
PROGRAM=NO. Rival-1 family (full-H readout). No cloud. Not C4_MASTER.
"""
from __future__ import annotations

import hashlib
import json
import random
from pathlib import Path

import numpy as np

V, E, H, SHR, MAX_TOK = 256, 4, 32, 4, 6
EOS = 0
OFF_WE = 0
OFF_WXH = V * E
OFF_WHH = OFF_WXH + H * E
OFF_BH = OFF_WHH + H * H
OFF_WO = OFF_BH + H
OFF_BY = OFF_WO + V * H
N_W = OFF_BY + V
TRAIN_ENT = ["pump", "valv", "tank", "pipe"]
HELD_ENT = ["hose", "drum", "vent", "bolt"]


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def pack16(s: str) -> str:
    b = s.encode("ascii")
    if len(b) != 16:
        raise ValueError(s)
    return s


def make_split(ents, op):
    rows = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            if op == "F":
                rows.append({"ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "unrel": False})
            else:
                rows.append({"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False})
    return rows


def make_unrel(ents):
    rows = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            other = next(e for e in ents if e != dst and e != src)
            rows.append({"ctx": pack16(f"F {dst} {src}>{other}"), "ans": "no", "unrel": True})
    return rows


class Net:
    def __init__(self, rng: np.random.Generator):
        self.We = rng.normal(0, 0.4, (V, E))
        self.Wxh = rng.normal(0, 0.2, (H, E))
        np.fill_diagonal(self.Wxh[:E, :], 1.5)
        self.Whh = rng.normal(0, 0.1, (H, H))
        np.fill_diagonal(self.Whh, 0.8)
        self.bh = np.zeros(H)
        self.Wo = rng.normal(0, 0.05, (V, H))
        self.by = np.full(V, -8.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -10.0

    def qi(self):
        def q(a):
            return np.clip(np.round(a), -127, 127).astype(np.int32)
        return q(self.We), q(self.Wxh), q(self.Whh), q(self.bh), q(self.Wo), q(self.by)


def step_i(We, Wxh, Whh, bh, h, tok):
    e = We[tok].astype(np.int64)
    acc = bh.astype(np.int64) + (Wxh.astype(np.int64) @ e) + (Whh.astype(np.int64) @ h.astype(np.int64))
    hn = np.clip(acc >> SHR, -127, 127).astype(np.int32)
    return hn, e.astype(np.int32), acc


def logits_i(Wo, by, h):
    return by.astype(np.int64) + (Wo.astype(np.int64) @ h.astype(np.int64))


def softmax(x):
    z = x - x.max()
    e = np.exp(np.clip(z, -30, 30))
    return e / e.sum()


def train_one(m: Net, ctx: bytes, tgt: list[int], lr: float) -> float:
    We, Wxh, Whh, bh, Wo, by = m.qi()
    h = np.zeros(H, dtype=np.int32)
    hs = [h.copy()]
    toks = list(ctx)
    for b in ctx:
        h, _, _ = step_i(We, Wxh, Whh, bh, h, int(b))
        hs.append(h.copy())
    last = 0
    dh = [hs[-1].copy()]
    dtok = [last]
    loss = 0.0
    gWe = np.zeros_like(m.We)
    gWxh = np.zeros_like(m.Wxh)
    gWhh = np.zeros_like(m.Whh)
    gbh = np.zeros_like(m.bh)
    gWo = np.zeros_like(m.Wo)
    gby = np.zeros_like(m.by)
    cache = []
    for t in tgt:
        e = We[last].astype(np.int64)
        acc = bh.astype(np.int64) + (Wxh.astype(np.int64) @ e) + (Whh.astype(np.int64) @ dh[-1].astype(np.int64))
        h = np.clip(acc >> SHR, -127, 127).astype(np.int32)
        lg = logits_i(Wo, by, h).astype(np.float64)
        p = softmax(lg)
        loss += -np.log(max(p[t], 1e-12))
        cache.append((dh[-1].copy(), e.copy(), acc.copy(), h.copy(), last, t, p, lg))
        dh.append(h.copy())
        dtok.append(t)
        last = t
    gh = np.zeros(H, dtype=np.float64)
    for hprev, e, acc, h, last, t, p, lg in reversed(cache):
        ds = p.copy()
        ds[t] -= 1.0
        gby += ds
        gWo += np.outer(ds, h.astype(np.float64))
        gh_out = Wo.T @ ds
        gh_out += gh
        gacc = gh_out / (1 << SHR)
        gbh += gacc
        gWxh += np.outer(gacc, e.astype(np.float64))
        gWhh += np.outer(gacc, hprev.astype(np.float64))
        gWe[last] += m.Wxh.T @ gacc if False else Wxh.astype(np.float64).T @ gacc
        gh = Whh.astype(np.float64).T @ gacc
    for i in range(len(ctx) - 1, -1, -1):
        hprev = hs[i]
        tok = toks[i]
        e = We[tok]
        gacc = gh / (1 << SHR)
        gbh += gacc
        gWxh += np.outer(gacc, e.astype(np.float64))
        gWhh += np.outer(gacc, hprev.astype(np.float64))
        gWe[tok] += Wxh.astype(np.float64).T @ gacc
        gh = Whh.astype(np.float64).T @ gacc
    for arr, g in (
        (m.We, gWe),
        (m.Wxh, gWxh),
        (m.Whh, gWhh),
        (m.bh, gbh),
        (m.Wo, gWo),
        (m.by, gby),
    ):
        arr -= lr * np.clip(g, -20, 20)
        np.clip(arr, -48, 48, out=arr)
    m.by[EOS] = min(float(m.by[EOS]), -10.0)
    return loss


def decode_i(m: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    We, Wxh, Whh, bh, Wo, by = m.qi()
    h = np.zeros(H, dtype=np.int32)
    for b in ctx:
        h, _, _ = step_i(We, Wxh, Whh, bh, h, int(b))
    last = 0
    out = []
    for _ in range(MAX_TOK):
        h, _, _ = step_i(We, Wxh, Whh, bh, h, last)
        lg = logits_i(Wo, by, h)
        v = int(np.argmax(lg))
        out.append(v)
        last = v
        if v == EOS:
            break
    return out


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def eval_rows(m, rows):
    ok = hall = 0
    for r in rows:
        got = body(decode_i(m, r["ctx"].encode(), True))
        if r["unrel"]:
            if got.startswith("no"):
                ok += 1
            else:
                hall += 1
        elif got.startswith(r["ans"]):
            ok += 1
    n = len(rows)
    return {"n": n, "ok": ok, "acc": ok / n if n else 0.0, "hall": hall}


def pack_w(m: Net) -> list[int]:
    We, Wxh, Whh, bh, Wo, by = m.qi()
    w = [0] * N_W
    for v in range(V):
        for e in range(E):
            w[OFF_WE + v * E + e] = sat8(int(We[v, e]))
        for h in range(H):
            w[OFF_WO + v * H + h] = sat8(int(Wo[v, h]))
        w[OFF_BY + v] = sat8(int(by[v]))
    for hi in range(H):
        w[OFF_BH + hi] = sat8(int(bh[hi]))
        for e in range(E):
            w[OFF_WXH + hi * E + e] = sat8(int(Wxh[hi, e]))
        for hh in range(H):
            w[OFF_WHH + hi * H + hh] = sat8(int(Whh[hi, hh]))
    return w


def main():
    bag = Path(__file__).resolve().parent
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:20]
    rng = np.random.default_rng(21)
    m = Net(rng)
    py = random.Random(21)
    for ep in range(200):
        py.shuffle(train)
        tot = 0.0
        lr = 0.05 if ep < 80 else 0.02 if ep < 140 else 0.008
        for r in train:
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            tot += train_one(m, r["ctx"].encode(), tgt, lr)
        if ep % 20 == 0 or ep == 199:
            tr = eval_rows(m, [x for x in train if not x["unrel"]])
            hg = eval_rows(m, held_g)
            print(f"EP {ep} loss={tot/len(train):.3f} train={tr['acc']:.3f} held={hg['acc']:.3f}", flush=True)
    w = pack_w(m)
    hg = eval_rows(m, held_g)
    hu = eval_rows(m, held_u)
    tr = eval_rows(m, [x for x in train if not x["unrel"]])
    tu = eval_rows(m, [x for x in train if x["unrel"]])
    safe = decode_i(m, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    metrics = {
        "n_w": N_W,
        "H": H,
        "E": E,
        "train_g": tr["acc"],
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "train_u": tu["acc"],
        "safe_no": safe == [ord("n"), ord("o"), EOS],
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe == [ord("n"), ord("o"), EOS]) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "cloud": False,
        "c4_master": False,
    }
    hex_path = bag / "a7ng_astra_c4_cond_rnn_h16.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    metrics["hex_sha256"] = hashlib.sha256(hex_path.read_bytes()).hexdigest()
    corpus = {"train": train, "held_grounded": held_g, "held_unrel": held_u,
              "train_entities": TRAIN_ENT, "held_entities": HELD_ENT}
    (bag / "corpus.json").write_text(json.dumps(corpus, indent=2), encoding="utf-8")
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    print("METRICS", json.dumps(metrics), flush=True)
    for r in held_g[:6]:
        seq = decode_i(m, r["ctx"].encode(), True)
        print("S", r["ctx"], r["ans"], body(seq), seq, flush=True)


if __name__ == "__main__":
    main()
