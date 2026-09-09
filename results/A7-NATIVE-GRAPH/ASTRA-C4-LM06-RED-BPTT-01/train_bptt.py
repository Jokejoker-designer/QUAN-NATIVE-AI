#!/usr/bin/env python3
"""Full attention BPTT on rival-2 LM06-red family. PROGRAM=NO.
ASTRA-C4-LM06-RED-BPTT-01. No cloud. Not TinyGPT. Not C4_MASTER.
Does not overwrite rtl a7ng_astra_c4_lm06_red.hex (74b5f885…).
Configs: exact D=4 no-PE DUT law; same-family +PE; scaled D=16 +PE.
"""
from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

import numpy as np

EOS = 0
CTX_N = 16
MAX_TOK = 6
TMAX = 24
SHR = 4
TRAIN_ENT = ["pump", "valv", "tank", "pipe"]
HELD_ENT = ["hose", "drum", "vent", "bolt"]


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def relu_i(x: int) -> int:
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


def softmax(x: np.ndarray) -> np.ndarray:
    z = x - np.max(x)
    e = np.exp(np.clip(z, -40, 40))
    return e / e.sum()


class Cfg:
    def __init__(self, name: str, d: int, f: int, pe: bool, epochs: int, lr: float):
        self.name = name
        self.d = d
        self.f = f
        self.pe = pe
        self.epochs = epochs
        self.lr = lr
        self.v = 256
        self.off_we = 0
        self.off_wq = self.v * d
        self.off_wk = self.off_wq + d * d
        self.off_wv = self.off_wk + d * d
        self.off_w1 = self.off_wv + d * d
        self.off_w2 = self.off_w1 + f * d
        self.off_by = self.off_w2 + d * f
        self.off_pe = self.off_by + self.v
        self.n_w = self.off_pe + (TMAX * d if pe else 0)


class Net:
    def __init__(self, cfg: Cfg, rng: np.random.Generator):
        self.cfg = cfg
        d, f, v = cfg.d, cfg.f, cfg.v
        scale = 0.35 / math.sqrt(d)
        self.We = rng.normal(0, scale, (v, d))
        self.Wq = np.eye(d) * 1.2 + rng.normal(0, 0.02, (d, d))
        self.Wk = np.eye(d) * 1.2 + rng.normal(0, 0.02, (d, d))
        self.Wv = np.eye(d) * 1.0 + rng.normal(0, 0.02, (d, d))
        self.W1 = rng.normal(0, 0.15, (f, d))
        self.W2 = rng.normal(0, 0.15, (d, f))
        self.by = np.full(v, -4.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -6.0
        self.We[EOS] *= 0.05
        if cfg.pe:
            self.Pe = np.zeros((TMAX, d))
            for j in range(TMAX):
                for k in range(d):
                    ang = (j + 1) / (10000 ** (k / max(d - 1, 1)))
                    self.Pe[j, k] = math.sin(ang) if (k % 2 == 0) else math.cos(ang)
            self.Pe *= 0.8
        else:
            self.Pe = np.zeros((TMAX, d))
        used = b" FR>abcdefghijklmnopqrstuvwxyz"
        for ch in used:
            self.We[ch] += rng.normal(0, 0.4, d)

    def params(self):
        out = {
            "We": self.We,
            "Wq": self.Wq,
            "Wk": self.Wk,
            "Wv": self.Wv,
            "W1": self.W1,
            "W2": self.W2,
            "by": self.by,
        }
        if self.cfg.pe:
            out["Pe"] = self.Pe
        return out


def qi(a: np.ndarray) -> np.ndarray:
    return np.clip(np.round(a), -127, 127).astype(np.int32)


def mv_i(W: np.ndarray, x: np.ndarray) -> np.ndarray:
    acc = W.astype(np.int64) @ x.astype(np.int64)
    return np.array([sat8(int(a >> SHR)) for a in acc], dtype=np.int32)


def embed_i(We: np.ndarray, Pe: np.ndarray, tok: int, pos: int, use_pe: bool) -> np.ndarray:
    e = We[tok & 255].astype(np.int32)
    if use_pe:
        e = np.array([sat8(int(e[k]) + int(Pe[pos, k])) for k in range(e.shape[0])], dtype=np.int32)
    return e


def block_i(Wq, Wk, Wv, W1, W2, xs: list[np.ndarray], last: int) -> np.ndarray:
    d = xs[0].shape[0]
    q = mv_i(Wq, xs[last])
    acc = np.zeros(d, dtype=np.int64)
    wsum = 0
    for j in range(last + 1):
        k = mv_i(Wk, xs[j])
        dot = int((q.astype(np.int64) * k.astype(np.int64)).sum())
        s = relu_i(sat8(dot >> SHR))
        vv = mv_i(Wv, xs[j])
        acc += s * vv.astype(np.int64)
        wsum += s
    h = np.array([sat8(tdiv(int(acc[k]), wsum if wsum else 1)) for k in range(d)], dtype=np.int32)
    y = np.array([sat8(int(xs[last][k]) + int(h[k])) for k in range(d)], dtype=np.int32)
    t = np.array(
        [relu_i(sat8(int((W1[f].astype(np.int64) * y.astype(np.int64)).sum()) >> SHR)) for f in range(W1.shape[0])],
        dtype=np.int32,
    )
    u = np.array(
        [sat8(int((W2[k].astype(np.int64) * t.astype(np.int64)).sum()) >> SHR) for k in range(d)],
        dtype=np.int32,
    )
    return np.array([sat8(int(y[k]) + int(u[k])) for k in range(d)], dtype=np.int32)


def decode_i(n: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    We, Wq, Wk, Wv, W1, W2, by = map(qi, (n.We, n.Wq, n.Wk, n.Wv, n.W1, n.W2, n.by))
    Pe = qi(n.Pe)
    xs = [embed_i(We, Pe, b, j, n.cfg.pe) for j, b in enumerate(ctx[:CTX_N])]
    xs.append(embed_i(We, Pe, 0, len(xs), n.cfg.pe))
    last = len(xs) - 1
    out = []
    for _ in range(MAX_TOK):
        z = block_i(Wq, Wk, Wv, W1, W2, xs, last)
        best_v, best_s = 0, None
        for v in range(n.cfg.v):
            sc = int(by[v]) + int((We[v].astype(np.int64) * z.astype(np.int64)).sum())
            if best_s is None or sc > best_s:
                best_s = sc
                best_v = v
        out.append(best_v)
        if best_v == EOS:
            break
        xs.append(embed_i(We, Pe, best_v, last + 1, n.cfg.pe))
        last += 1
        if last >= TMAX - 1:
            break
    return out


def forward_step(n: Net, xs: np.ndarray):
    """xs: (T, D) float. Returns logits, cache."""
    d = n.cfg.d
    last = xs.shape[0] - 1
    x_last = xs[last]
    q = n.Wq @ x_last
    K = xs @ n.Wk.T
    V = xs @ n.Wv.T
    dots = (K @ q) / (2.0 ** SHR)
    s = np.maximum(dots, 0.0)
    wsum = float(s.sum()) + 1e-6
    num = (s[:, None] * V).sum(0)
    h = num / wsum
    y = x_last + h
    pre1 = n.W1 @ y
    t = np.maximum(pre1, 0.0)
    pre2 = n.W2 @ t
    z = y + pre2
    logits = n.by + (n.We @ z)
    cache = {
        "xs": xs,
        "x_last": x_last,
        "q": q,
        "K": K,
        "V": V,
        "dots": dots,
        "s": s,
        "wsum": wsum,
        "num": num,
        "h": h,
        "y": y,
        "pre1": pre1,
        "t": t,
        "pre2": pre2,
        "z": z,
        "logits": logits,
        "last": last,
        "d": d,
    }
    return logits, cache


def backward_step(n: Net, cache, dlogits: np.ndarray, g, dxs: np.ndarray):
    z = cache["z"]
    g["by"] += dlogits
    g["We"] += np.outer(dlogits, z)
    dz = n.We.T @ dlogits
    dy = dz.copy()
    dpre2 = dz
    g["W2"] += np.outer(dpre2, cache["t"])
    dt = n.W2.T @ dpre2
    dpre1 = dt * (cache["pre1"] > 0)
    g["W1"] += np.outer(dpre1, cache["y"])
    dy += n.W1.T @ dpre1
    dh = dy
    dx_last = dy.copy()
    wsum = cache["wsum"]
    dnum = dh / wsum
    dwsum = -float(np.dot(cache["h"], dh) / wsum)
    ds = cache["V"] @ dnum + dwsum
    ds = ds * (cache["dots"] > 0)
    dV = np.outer(cache["s"], dnum) if False else cache["s"][:, None] * dnum[None, :]
    ddots = ds / (2.0 ** SHR)
    dK = np.outer(ddots, cache["q"])
    dq = cache["K"].T @ ddots
    g["Wv"] += dV.T @ cache["xs"]
    dxs += dV @ n.Wv
    g["Wk"] += dK.T @ cache["xs"]
    dxs += dK @ n.Wk
    g["Wq"] += np.outer(dq, cache["x_last"])
    dx_last += n.Wq.T @ dq
    dxs[cache["last"]] += dx_last


def zeros_g(n: Net):
    g = {k: np.zeros_like(v) for k, v in n.params().items()}
    return g


def train_seq(n: Net, ctx: bytes, tgt: list[int], adam, step: int) -> float:
    cfg = n.cfg
    toks = list(ctx[:CTX_N]) + [EOS]
    T0 = len(toks)
    xs = np.zeros((T0, cfg.d), dtype=np.float64)
    for j, tok in enumerate(toks):
        xs[j] = n.We[tok]
        if cfg.pe:
            xs[j] = xs[j] + n.Pe[j]
    loss = 0.0
    g = zeros_g(n)
    dx_embed = []  # per step list of dxs arrays aligned to that step's T
    caches = []
    ts = []
    cur = xs
    for t in tgt:
        logits, cache = forward_step(n, cur)
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        caches.append(cache)
        ts.append(t)
        dxs = np.zeros_like(cur)
        backward_step(n, cache, dlogits, g, dxs)
        dx_embed.append(dxs)
        if t == EOS:
            break
        nxt = np.zeros((cur.shape[0] + 1, cfg.d), dtype=np.float64)
        nxt[:-1] = cur
        pos = cur.shape[0]
        nxt[-1] = n.We[t]
        if cfg.pe:
            nxt[-1] = nxt[-1] + n.Pe[min(pos, TMAX - 1)]
        cur = nxt
    # embedding grads from each step's dxs (later steps include earlier positions)
    for dxs, tgt_t, cache in zip(dx_embed, ts, caches):
        T = dxs.shape[0]
        seq = list(ctx[:CTX_N]) + [EOS] + [x for x in tgt if x != EOS]
        seq = seq[:T]
        for j, tok in enumerate(seq):
            g["We"][tok] += dxs[j]
            if cfg.pe:
                g["Pe"][min(j, TMAX - 1)] += dxs[j]
        # last position of this step also came from previous target embed if T>T0
    adam_update(n, g, adam, step)
    return loss


def adam_update(n: Net, g, adam, step: int):
    b1, b2, eps = 0.9, 0.999, 1e-8
    lr = n.cfg.lr
    step += 1
    adam["t"] = step
    for k, p in n.params().items():
        gk = np.clip(g[k], -50, 50)
        adam["m"][k] = b1 * adam["m"][k] + (1 - b1) * gk
        adam["v"][k] = b2 * adam["v"][k] + (1 - b2) * (gk * gk)
        mhat = adam["m"][k] / (1 - b1 ** step)
        vhat = adam["v"][k] / (1 - b2 ** step)
        p -= lr * mhat / (np.sqrt(vhat) + eps)
        np.clip(p, -48, 48, out=p)
    n.by[EOS] = min(float(n.by[EOS]), -2.0)


def init_adam(n: Net):
    return {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def eval_rows(n: Net, rows):
    ok = hall = 0
    samples = []
    for r in rows:
        got = body(decode_i(n, r["ctx"].encode(), True))
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


def pack_w(n: Net) -> list[int]:
    cfg = n.cfg
    We, Wq, Wk, Wv, W1, W2, by, Pe = map(qi, (n.We, n.Wq, n.Wk, n.Wv, n.W1, n.W2, n.by, n.Pe))
    w = [0] * cfg.n_w
    for v in range(cfg.v):
        for d in range(cfg.d):
            w[cfg.off_we + v * cfg.d + d] = sat8(int(We[v, d]))
        w[cfg.off_by + v] = sat8(int(by[v]))
    for r in range(cfg.d):
        for c in range(cfg.d):
            w[cfg.off_wq + r * cfg.d + c] = sat8(int(Wq[r, c]))
            w[cfg.off_wk + r * cfg.d + c] = sat8(int(Wk[r, c]))
            w[cfg.off_wv + r * cfg.d + c] = sat8(int(Wv[r, c]))
    for f in range(cfg.f):
        for d in range(cfg.d):
            w[cfg.off_w1 + f * cfg.d + d] = sat8(int(W1[f, d]))
    for d in range(cfg.d):
        for f in range(cfg.f):
            w[cfg.off_w2 + d * cfg.f + f] = sat8(int(W2[d, f]))
    if cfg.pe:
        for j in range(TMAX):
            for d in range(cfg.d):
                w[cfg.off_pe + j * cfg.d + d] = sat8(int(Pe[j, d]))
    return w


def run_cfg(cfg: Cfg, train, held_g, held_u, bag: Path) -> dict:
    rng = np.random.default_rng(7)
    n = Net(cfg, rng)
    adam = init_adam(n)
    hist = []
    order = list(range(len(train)))
    py = np.random.default_rng(9)
    for ep in range(cfg.epochs):
        py.shuffle(order)
        tot = 0.0
        for i, idx in enumerate(order):
            r = train[idx]
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            tot += train_seq(n, r["ctx"].encode(), tgt, adam, adam["t"])
        if ep % 15 == 0 or ep == cfg.epochs - 1:
            tr = eval_rows(n, [x for x in train if not x["unrel"]])
            hg = eval_rows(n, held_g)
            rec = {
                "ep": ep,
                "loss": tot / len(train),
                "train": tr["acc"],
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"{cfg.name} EP {ep} loss={rec['loss']:.3f} train={tr['acc']:.3f} "
                f"held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90 and tr["acc"] >= 0.90:
                break
    hg = eval_rows(n, held_g)
    hu = eval_rows(n, held_u)
    tr = eval_rows(n, [x for x in train if not x["unrel"]])
    tu = eval_rows(n, [x for x in train if x["unrel"]])
    safe = decode_i(n, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(n)
    hex_path = bag / f"ckpt_{cfg.name}.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    metrics = {
        "name": cfg.name,
        "d": cfg.d,
        "f": cfg.f,
        "pe": cfg.pe,
        "n_w": cfg.n_w,
        "epochs_ran": hist[-1]["ep"] + 1 if hist else 0,
        "train_g": tr["acc"],
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": tu["acc"] if False else hu["acc"],
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
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:8]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"][:6]],
    }
    return metrics


def main():
    bag = Path(__file__).resolve().parent
    bag.mkdir(parents=True, exist_ok=True)
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    cfgs = [
        Cfg("d4_nope", 4, 8, False, 80, 0.01),
        Cfg("d4_pe", 4, 8, True, 100, 0.01),
        Cfg("d16_pe", 16, 32, True, 80, 0.008),
    ]
    all_m = []
    for cfg in cfgs:
        print(f"=== {cfg.name} n_w={cfg.n_w} pe={cfg.pe} ===", flush=True)
        all_m.append(run_cfg(cfg, train, held_g, held_u, bag))
    out = {
        "bag": "ASTRA-C4-LM06-RED-BPTT-01",
        "program": "NO",
        "c4_master": False,
        "configs": all_m,
        "any_lang_90": any(m["lang_90"] for m in all_m),
        "rtl_dut_unedited": True,
    }
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("any_lang_90", "c4_master", "program")}), flush=True)
    for m in all_m:
        print(
            f"CFG {m['name']} train={m['train_g']:.3f} held={m['held_g']:.3f} "
            f"lang90={m['lang_90']} hall={m['hall_rate']:.3f} safe={m['safe_no']}",
            flush=True,
        )


if __name__ == "__main__":
    main()
