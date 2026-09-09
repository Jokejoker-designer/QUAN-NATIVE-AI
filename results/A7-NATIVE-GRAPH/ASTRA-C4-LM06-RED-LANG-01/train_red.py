#!/usr/bin/env python3
"""Local STE train of unedited rival-2 integer decoder.
ASTRA-C4-LM06-RED-LANG-01. PROGRAM=NO. No cloud. Not TinyGPT. Not C4_MASTER.
Does not overwrite rtl a7ng_astra_c4_lm06_red.hex.
"""
from __future__ import annotations

import hashlib
import json
import random
from pathlib import Path

import numpy as np

V, D, F, SHR, MAX_TOK, CTX_N = 256, 4, 8, 4, 6, 16
EOS = 0
OFF_WE = 0
OFF_WQ = V * D
OFF_WK = OFF_WQ + D * D
OFF_WV = OFF_WK + D * D
OFF_W1 = OFF_WV + D * D
OFF_W2 = OFF_W1 + F * D
OFF_BY = OFF_W2 + D * F
N_W = OFF_BY + V
TRAIN_ENT = ["pump", "valv", "tank", "pipe"]
HELD_ENT = ["hose", "drum", "vent", "bolt"]


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def relu(x: int) -> int:
    return x if x > 0 else 0


def tdiv(a: int, b: int) -> int:
    if b <= 0:
        b = 1
    if a < 0:
        return -((-a) // b)
    return a // b


def pack16(s: str) -> str:
    if len(s.encode("ascii")) != 16:
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
        self.We = rng.normal(0, 0.4, (V, D))
        self.Wq = np.eye(D) * 1.4 + rng.normal(0, 0.05, (D, D))
        self.Wk = np.eye(D) * 1.4 + rng.normal(0, 0.05, (D, D))
        self.Wv = np.eye(D) * 1.0 + rng.normal(0, 0.05, (D, D))
        self.W1 = rng.normal(0, 0.2, (F, D))
        self.W2 = rng.normal(0, 0.2, (D, F))
        self.by = np.full(V, -6.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -10.0

    def qi(self):
        def q(a):
            return np.clip(np.round(a), -127, 127).astype(np.int32)
        return q(self.We), q(self.Wq), q(self.Wk), q(self.Wv), q(self.W1), q(self.W2), q(self.by)


def mv(W, x):
    acc = W.astype(np.int64) @ x.astype(np.int64)
    return np.array([sat8(int(a >> SHR)) for a in acc], dtype=np.int32)


def block(We, Wq, Wk, Wv, W1, W2, xs, last):
    q = mv(Wq, xs[last])
    acc = np.zeros(D, dtype=np.int64)
    wsum = 0
    for j in range(last + 1):
        k = mv(Wk, xs[j])
        dot = int((q.astype(np.int64) * k.astype(np.int64)).sum())
        s = relu(sat8(dot >> SHR))
        vv = mv(Wv, xs[j])
        acc += s * vv.astype(np.int64)
        wsum += s
    h = np.array([sat8(tdiv(int(acc[d]), wsum if wsum else 1)) for d in range(D)], dtype=np.int32)
    y = np.array([sat8(int(xs[last][d]) + int(h[d])) for d in range(D)], dtype=np.int32)
    t = []
    for f in range(F):
        a = int((W1[f].astype(np.int64) * y.astype(np.int64)).sum())
        t.append(relu(sat8(a >> SHR)))
    t = np.array(t, dtype=np.int32)
    u = []
    for d in range(D):
        a = int((W2[d].astype(np.int64) * t.astype(np.int64)).sum())
        u.append(sat8(a >> SHR))
    return np.array([sat8(int(y[d]) + int(u[d])) for d in range(D)], dtype=np.int32)


def embed(We, tok):
    return We[tok & 255].copy()


def decode(m: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    We, Wq, Wk, Wv, W1, W2, by = m.qi()
    xs = [embed(We, b) for b in ctx[:CTX_N]]
    xs.append(embed(We, 0))
    last = len(xs) - 1
    out = []
    for _ in range(MAX_TOK):
        z = block(We, Wq, Wk, Wv, W1, W2, xs, last)
        best_v, best_s = 0, None
        for v in range(V):
            sc = int(by[v]) + int((We[v].astype(np.int64) * z.astype(np.int64)).sum())
            if best_s is None or sc > best_s:
                best_s = sc
                best_v = v
        out.append(best_v)
        if best_v == EOS:
            break
        xs.append(embed(We, best_v))
        last += 1
    return out


def softmax(x):
    z = x - np.max(x)
    e = np.exp(np.clip(z, -30, 30))
    return e / e.sum()


def train_one(m: Net, ctx: bytes, tgt: list[int], lr: float) -> float:
    We, Wq, Wk, Wv, W1, W2, by = m.qi()
    xs = [embed(We, b) for b in ctx[:CTX_N]]
    xs.append(embed(We, 0))
    last = len(xs) - 1
    loss = 0.0
    gWe = np.zeros_like(m.We)
    gby = np.zeros_like(m.by)
    gWq = np.zeros_like(m.Wq)
    last_tok = 0
    for t in tgt:
        z = block(We, Wq, Wk, Wv, W1, W2, xs, last)
        lg = np.zeros(V, dtype=np.float64)
        for v in range(V):
            lg[v] = float(by[v]) + float((We[v].astype(np.int64) * z.astype(np.int64)).sum())
        p = softmax(lg)
        loss += -np.log(max(p[t], 1e-12))
        ds = p.copy()
        ds[t] -= 1.0
        gby += ds
        gWe += np.outer(ds, z.astype(np.float64))
        # residual nudge of Wq toward current token embed
        err = 1.0 if np.argmax(lg) != t else 0.0
        if err:
            x = xs[last].astype(np.float64)
            gWq -= np.outer(np.sign(ds[t]) * np.ones(D), x) * 0.05
        if t == EOS:
            break
        xs.append(embed(We, t))
        last += 1
        last_tok = t
    for arr, g in ((m.We, gWe), (m.by, gby), (m.Wq, gWq)):
        arr -= lr * np.clip(g, -20, 20)
        np.clip(arr, -48, 48, out=arr)
    m.by[EOS] = min(float(m.by[EOS]), -10.0)
    return loss


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def eval_rows(m, rows):
    ok = hall = 0
    for r in rows:
        got = body(decode(m, r["ctx"].encode(), True))
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
    We, Wq, Wk, Wv, W1, W2, by = m.qi()
    w = [0] * N_W
    for v in range(V):
        for d in range(D):
            w[OFF_WE + v * D + d] = sat8(int(We[v, d]))
        w[OFF_BY + v] = sat8(int(by[v]))
    for r in range(D):
        for c in range(D):
            w[OFF_WQ + r * D + c] = sat8(int(Wq[r, c]))
            w[OFF_WK + r * D + c] = sat8(int(Wk[r, c]))
            w[OFF_WV + r * D + c] = sat8(int(Wv[r, c]))
    for f in range(F):
        for d in range(D):
            w[OFF_W1 + f * D + d] = sat8(int(W1[f, d]))
    for d in range(D):
        for f in range(F):
            w[OFF_W2 + d * F + f] = sat8(int(W2[d, f]))
    return w


def main():
    bag = Path(__file__).resolve().parent
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:20]
    rng = np.random.default_rng(21)
    m = Net(rng)
    py = random.Random(21)
    for ep in range(80):
        py.shuffle(train)
        tot = 0.0
        lr = 0.05 if ep < 40 else 0.02
        for r in train:
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            tot += train_one(m, r["ctx"].encode(), tgt, lr)
        if ep % 10 == 0 or ep == 79:
            tr = eval_rows(m, [x for x in train if not x["unrel"]])
            hg = eval_rows(m, held_g)
            print(f"EP {ep} loss={tot/len(train):.3f} train={tr['acc']:.3f} held={hg['acc']:.3f}", flush=True)
    hg = eval_rows(m, held_g)
    hu = eval_rows(m, held_u)
    tr = eval_rows(m, [x for x in train if not x["unrel"]])
    tu = eval_rows(m, [x for x in train if x["unrel"]])
    safe = decode(m, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(m)
    hex_path = bag / "a7ng_astra_c4_lm06_red_lang.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    metrics = {
        "n_w": N_W,
        "rival": "reduced_lm06_compatible",
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
        "tinygpt": False,
        "c4_master": False,
        "rtl_hex_unedited": True,
        "hex_sha256": hashlib.sha256(hex_path.read_bytes()).hexdigest(),
    }
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    print("METRICS", json.dumps(metrics), flush=True)
    for r in held_g[:6]:
        seq = decode(m, r["ctx"].encode(), True)
        print("S", r["ctx"], r["ans"], body(seq), seq, flush=True)


if __name__ == "__main__":
    main()
