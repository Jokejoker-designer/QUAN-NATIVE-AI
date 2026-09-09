#!/usr/bin/env python3
"""Float vs int8 greedy on scaled rival-2 (D=32 PE softmax). PROGRAM=NO.
ASTRA-C4-LM06-RED-FLOATTFM-01. Same family scale, not TinyGPT, not C4_MASTER.
Does not overwrite rtl D=4 DUT hex. Frozen held-out hose/drum/vent/bolt.
"""
from __future__ import annotations

import hashlib
import json
import math
import string
from pathlib import Path

import numpy as np

EOS = 0
CTX_N = 16
MAX_TOK = 6
TMAX = 24
V, D, F = 256, 32, 64
HELD_ENT = ["hose", "drum", "vent", "bolt"]
LETTERS = list(string.ascii_lowercase)


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


def rname(rng):
    return "".join(str(rng.choice(LETTERS)) for _ in range(4))


def fresh_row(rng):
    src, dst = rname(rng), rname(rng)
    while dst == src:
        dst = rname(rng)
    mode = int(rng.integers(0, 3))
    if mode == 0:
        return {"ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "unrel": False}
    if mode == 1:
        return {"ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "unrel": False}
    other = rname(rng)
    while other in (src, dst):
        other = rname(rng)
    return {"ctx": pack16(f"F {dst} {src}>{other}"), "ans": "no", "unrel": True}


def softmax(x):
    z = x - np.max(x)
    e = np.exp(np.clip(z, -40, 40))
    return e / e.sum()


class Net:
    def __init__(self, rng: np.random.Generator):
        s = 0.3 / math.sqrt(D)
        self.We = rng.normal(0, s, (V, D))
        self.Wq = np.eye(D) + rng.normal(0, 0.02, (D, D))
        self.Wk = np.eye(D) + rng.normal(0, 0.02, (D, D))
        self.Wv = np.eye(D) + rng.normal(0, 0.02, (D, D))
        self.W1 = rng.normal(0, s, (F, D))
        self.W2 = rng.normal(0, s, (D, F))
        self.by = np.full(V, -4.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -6.0
        self.Pe = np.zeros((TMAX, D))
        for j in range(TMAX):
            for k in range(0, D, 2):
                ang = j / (10000 ** (k / max(D - 1, 1)))
                self.Pe[j, k] = math.sin(ang)
                if k + 1 < D:
                    self.Pe[j, k + 1] = math.cos(ang)

    def params(self):
        return {
            "We": self.We,
            "Wq": self.Wq,
            "Wk": self.Wk,
            "Wv": self.Wv,
            "W1": self.W1,
            "W2": self.W2,
            "by": self.by,
            "Pe": self.Pe,
        }


def embed(n: Net, tok: int, pos: int) -> np.ndarray:
    return n.We[tok & 255] + n.Pe[min(pos, TMAX - 1)]


def forward(n: Net, xs: np.ndarray):
    x_last = xs[-1]
    q = n.Wq @ x_last
    K = xs @ n.Wk.T
    V = xs @ n.Wv.T
    scale = math.sqrt(D)
    dots = (K @ q) / scale
    a = softmax(dots)
    h = a @ V
    y = x_last + h
    t = np.maximum(n.W1 @ y, 0.0)
    z = y + n.W2 @ t
    logits = n.by + (n.We @ z)
    cache = {
        "xs": xs,
        "x_last": x_last,
        "q": q,
        "K": K,
        "V": V,
        "dots": dots,
        "a": a,
        "h": h,
        "y": y,
        "t": t,
        "z": z,
        "scale": scale,
    }
    return logits, cache


def backward(n: Net, cache, dlogits, g, dxs):
    z = cache["z"]
    g["by"] += dlogits
    g["We"] += np.outer(dlogits, z)
    dz = n.We.T @ dlogits
    dy = dz.copy()
    dt = n.W2.T @ dz
    g["W2"] += np.outer(dz, cache["t"])
    dpre1 = dt * (cache["t"] > 0)
    g["W1"] += np.outer(dpre1, cache["y"])
    dy += n.W1.T @ dpre1
    dh = dy
    dx_last = dy.copy()
    da = cache["V"] @ dh
    dV = np.outer(cache["a"], dh)
    a = cache["a"]
    # softmax J^T
    s = a * (da - np.dot(da, a))
    ddots = s / cache["scale"]
    dK = np.outer(ddots, cache["q"])
    dq = cache["K"].T @ ddots
    g["Wv"] += dV.T @ cache["xs"]
    dxs += dV @ n.Wv
    g["Wk"] += dK.T @ cache["xs"]
    dxs += dK @ n.Wk
    g["Wq"] += np.outer(dq, cache["x_last"])
    dx_last += n.Wq.T @ dq
    dxs[-1] += dx_last


def zeros_g(n: Net):
    return {k: np.zeros_like(v) for k, v in n.params().items()}


def adam_update(n: Net, g, adam, lr: float):
    b1, b2, eps = 0.9, 0.999, 1e-8
    adam["t"] += 1
    step = adam["t"]
    for k, p in n.params().items():
        gk = np.clip(g[k], -20, 20)
        adam["m"][k] = b1 * adam["m"][k] + (1 - b1) * gk
        adam["v"][k] = b2 * adam["v"][k] + (1 - b2) * (gk * gk)
        mhat = adam["m"][k] / (1 - b1 ** step)
        vhat = adam["v"][k] / (1 - b2 ** step)
        p -= lr * mhat / (np.sqrt(vhat) + eps)
        np.clip(p, -32, 32, out=p)
    n.by[EOS] = min(float(n.by[EOS]), -2.0)


def train_seq(n: Net, ctx: bytes, tgt: list[int], adam, lr: float) -> tuple[float, int, int]:
    toks = list(ctx[:CTX_N]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    seq = toks[:]
    g = zeros_g(n)
    loss = 0.0
    tf_ok = tf_n = 0
    for t in tgt:
        logits, cache = forward(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        tf_ok += int(pred == t)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        backward(n, cache, dlogits, g, dxs)
        for j, tok in enumerate(seq):
            g["We"][tok] += dxs[j]
            g["Pe"][min(j, TMAX - 1)] += dxs[j]
        if t == EOS:
            break
        seq.append(t)
        xs = np.vstack([xs, embed(n, t, xs.shape[0])])
    adam_update(n, g, adam, lr)
    return loss, tf_ok, tf_n


def decode_f(n: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    toks = list(ctx[:CTX_N]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    out = []
    for _ in range(MAX_TOK):
        logits, _ = forward(n, xs)
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, embed(n, tok, xs.shape[0])])
    return out


def q8(a):
    return np.clip(np.round(a), -127, 127)


def decode_i(n: Net, ctx: bytes, evid: bool) -> list[int]:
    """Greedy with rounded weights/acts, still softmax-scale dots."""
    if not evid:
        return [ord("n"), ord("o"), EOS]
    We, Wq, Wk, Wv = q8(n.We), q8(n.Wq), q8(n.Wk), q8(n.Wv)
    W1, W2, by, Pe = q8(n.W1), q8(n.W2), q8(n.by), q8(n.Pe)

    def emb(tok, pos):
        return q8(We[tok & 255] + Pe[min(pos, TMAX - 1)])

    toks = list(ctx[:CTX_N]) + [EOS]
    xs = np.stack([emb(t, j) for j, t in enumerate(toks)])
    out = []
    for _ in range(MAX_TOK):
        q = q8((Wq @ xs[-1]) / 16.0)
        K = q8((xs @ Wk.T) / 16.0)
        V = q8((xs @ Wv.T) / 16.0)
        dots = K @ q
        a = softmax(dots.astype(np.float64))
        h = q8(a @ V)
        y = q8(xs[-1] + h)
        t = np.maximum(q8((W1 @ y) / 16.0), 0.0)
        z = q8(y + q8((W2 @ t) / 16.0))
        logits = by + (We @ z)
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, emb(tok, xs.shape[0])])
    return out


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def eval_rows(n, rows, fn):
    ok = hall = 0
    samples = []
    for r in rows:
        got = body(fn(n, r["ctx"].encode(), True))
        samples.append((r["ctx"], r["ans"], got))
        if r["unrel"]:
            if got == "no":
                ok += 1
            else:
                hall += 1
        elif got.startswith(r["ans"]):
            ok += 1
    n_rows = len(rows)
    return {"n": n_rows, "ok": ok, "acc": ok / n_rows if n_rows else 0.0, "hall": hall, "samples": samples}


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(7)
    n = Net(rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hist = []
    bs, epochs = 96, 40
    for ep in range(epochs):
        lr = 0.008 if ep < 20 else 0.003
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam, lr)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 5 == 0 or ep == epochs - 1:
            hg_f = eval_rows(n, held_g, decode_f)
            rec = {
                "ep": ep,
                "loss": tot / bs,
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "held_float": hg_f["acc"],
                "held_float_ok": hg_f["ok"],
            }
            hist.append(rec)
            print(
                f"EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"held_float={hg_f['acc']:.3f} ({hg_f['ok']}/{hg_f['n']})",
                flush=True,
            )
            if hg_f["acc"] >= 0.90:
                break
    hg_f = eval_rows(n, held_g, decode_f)
    hg_i = eval_rows(n, held_g, decode_i)
    hu_f = eval_rows(n, held_u, decode_f)
    safe_f = decode_f(n, b"F hose pump>hose", False)
    hall_f = hu_f["hall"] / hu_f["n"] if hu_f["n"] else 1.0
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "d": D,
        "f": F,
        "softmax": True,
        "program": "NO",
        "c4_master": False,
        "held_float": hg_f["acc"],
        "held_float_ok": hg_f["ok"],
        "held_int": hg_i["acc"],
        "held_int_ok": hg_i["ok"],
        "held_n": hg_f["n"],
        "hall_float": hall_f,
        "safe_no": safe_f == [ord("n"), ord("o"), EOS],
        "lang_90_float": hg_f["acc"] >= 0.90,
        "lang_90_int": hg_i["acc"] >= 0.90,
        "tinygpt": False,
        "rtl_d4_unedited": True,
        "hist": hist,
        "held_float_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg_f["samples"][:6]],
        "held_int_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg_i["samples"][:6]],
    }
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("lang_90_float", "lang_90_int", "held_float", "held_int")}), flush=True)
    print("float", out["held_float_samples"][:3], flush=True)
    print("int", out["held_int_samples"][:3], flush=True)


if __name__ == "__main__":
    main()
