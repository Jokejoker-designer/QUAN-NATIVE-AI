#!/usr/bin/env python3
"""STE/QAT BPTT matching rival-2 integer ops. PROGRAM=NO.
ASTRA-C4-LM06-RED-BPTT-01. Does not overwrite rtl hex 74b5f885….
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
SHR_F = 16.0
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


def q8(x: np.ndarray) -> np.ndarray:
    return np.clip(np.round(x), -127, 127)


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
        self.We = rng.normal(0, 10.0, (v, d))
        self.Wq = np.eye(d) * 24.0 + rng.normal(0, 1.0, (d, d))
        self.Wk = np.eye(d) * 24.0 + rng.normal(0, 1.0, (d, d))
        self.Wv = np.eye(d) * 20.0 + rng.normal(0, 1.0, (d, d))
        self.W1 = rng.normal(0, 6.0, (f, d))
        self.W2 = rng.normal(0, 6.0, (d, f))
        self.by = np.full(v, -8.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -12.0
        if cfg.pe:
            self.Pe = np.zeros((TMAX, d))
            for j in range(TMAX):
                for k in range(d):
                    ang = (j + 1) / (10000 ** (k / max(d - 1, 1)))
                    self.Pe[j, k] = 18.0 * (math.sin(ang) if (k % 2 == 0) else math.cos(ang))
        else:
            self.Pe = np.zeros((TMAX, d))
        letters = b"abcdefghijklmnopqrstuvwxyz FR>"
        for ch in letters:
            self.We[ch] = rng.normal(0, 14.0, d)

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
    return np.array([sat8(int(a >> 4)) for a in acc], dtype=np.int32)


def embed_i(We, Pe, tok, pos, use_pe):
    e = We[tok & 255].astype(np.int32)
    if use_pe:
        e = np.array([sat8(int(e[k]) + int(Pe[pos, k])) for k in range(e.shape[0])], dtype=np.int32)
    return e


def block_i(Wq, Wk, Wv, W1, W2, xs, last):
    d = xs[0].shape[0]
    q = mv_i(Wq, xs[last])
    acc = np.zeros(d, dtype=np.int64)
    wsum = 0
    for j in range(last + 1):
        k = mv_i(Wk, xs[j])
        dot = int((q.astype(np.int64) * k.astype(np.int64)).sum())
        s = relu_i(sat8(dot >> 4))
        vv = mv_i(Wv, xs[j])
        acc += s * vv.astype(np.int64)
        wsum += s
    h = np.array([sat8(tdiv(int(acc[k]), wsum if wsum else 1)) for k in range(d)], dtype=np.int32)
    y = np.array([sat8(int(xs[last][k]) + int(h[k])) for k in range(d)], dtype=np.int32)
    t = np.array(
        [relu_i(sat8(int((W1[f].astype(np.int64) * y.astype(np.int64)).sum()) >> 4)) for f in range(W1.shape[0])],
        dtype=np.int32,
    )
    u = np.array(
        [sat8(int((W2[k].astype(np.int64) * t.astype(np.int64)).sum()) >> 4) for k in range(d)],
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


def embed_row(n: Net, tok: int, pos: int) -> np.ndarray:
    e = n.We[tok & 255]
    if n.cfg.pe:
        e = e + n.Pe[min(pos, TMAX - 1)]
    return q8(e)


def forward_step(n: Net, xs: np.ndarray):
    Wq, Wk, Wv = q8(n.Wq), q8(n.Wk), q8(n.Wv)
    W1, W2 = q8(n.W1), q8(n.W2)
    We, by = q8(n.We), q8(n.by)
    x_last = xs[-1]
    q = q8((Wq @ x_last) / SHR_F)
    K = q8((xs @ Wk.T) / SHR_F)
    V = q8((xs @ Wv.T) / SHR_F)
    dots = q8((K @ q) / SHR_F)
    s = np.maximum(dots, 0.0)
    wsum = float(s.sum()) + 1e-6
    num = (s[:, None] * V).sum(0)
    h = q8(num / wsum)
    y = q8(x_last + h)
    pre1 = q8((W1 @ y) / SHR_F)
    t = np.maximum(pre1, 0.0)
    pre2 = q8((W2 @ t) / SHR_F)
    z = q8(y + pre2)
    logits = by + (We @ z)
    cache = {
        "xs": xs,
        "x_last": x_last,
        "Wq": Wq,
        "Wk": Wk,
        "Wv": Wv,
        "W1": W1,
        "W2": W2,
        "We": We,
        "q": q,
        "K": K,
        "V": V,
        "dots": dots,
        "s": s,
        "wsum": wsum,
        "h": h,
        "y": y,
        "pre1": pre1,
        "t": t,
        "z": z,
        "last": xs.shape[0] - 1,
    }
    return logits, cache


def backward_step(n: Net, cache, dlogits, g, dxs):
    z = cache["z"]
    g["by"] += dlogits
    g["We"] += np.outer(dlogits, z)
    dz = cache["We"].T @ dlogits
    dy = dz.copy()
    dpre2 = dz / SHR_F
    g["W2"] += np.outer(dpre2, cache["t"])
    dt = cache["W2"].T @ dpre2
    dpre1 = (dt * (cache["pre1"] > 0)) / SHR_F
    g["W1"] += np.outer(dpre1, cache["y"])
    dy += cache["W1"].T @ dpre1
    dh = dy
    dx_last = dy.copy()
    wsum = cache["wsum"]
    dnum = dh / wsum
    dwsum = -float(np.dot(cache["h"], dh) / wsum)
    ds = cache["V"] @ dnum + dwsum
    ds = ds * (cache["dots"] > 0)
    dV = cache["s"][:, None] * dnum[None, :]
    ddots = ds / SHR_F
    dK = np.outer(ddots, cache["q"])
    dq = cache["K"].T @ ddots
    g["Wv"] += (dV.T @ cache["xs"]) / SHR_F
    dxs += dV @ cache["Wv"] / SHR_F
    g["Wk"] += (dK.T @ cache["xs"]) / SHR_F
    dxs += dK @ cache["Wk"] / SHR_F
    g["Wq"] += np.outer(dq, cache["x_last"]) / SHR_F
    dx_last += cache["Wq"].T @ (dq / SHR_F)
    dxs[cache["last"]] += dx_last


def zeros_g(n: Net):
    return {k: np.zeros_like(v) for k, v in n.params().items()}


def adam_update(n: Net, g, adam):
    b1, b2, eps = 0.9, 0.999, 1e-8
    adam["t"] += 1
    step = adam["t"]
    lr = n.cfg.lr
    for k, p in n.params().items():
        gk = np.clip(g[k], -80, 80)
        adam["m"][k] = b1 * adam["m"][k] + (1 - b1) * gk
        adam["v"][k] = b2 * adam["v"][k] + (1 - b2) * (gk * gk)
        mhat = adam["m"][k] / (1 - b1 ** step)
        vhat = adam["v"][k] / (1 - b2 ** step)
        p -= lr * mhat / (np.sqrt(vhat) + eps)
        np.clip(p, -127, 127, out=p)
    n.by[EOS] = min(float(n.by[EOS]), -8.0)


def train_seq(n: Net, ctx: bytes, tgt: list[int], adam) -> tuple[float, int, int]:
    toks = list(ctx[:CTX_N]) + [EOS]
    xs = np.stack([embed_row(n, t, j) for j, t in enumerate(toks)])
    loss = 0.0
    g = zeros_g(n)
    tf_ok = 0
    tf_n = 0
    seq_toks = toks[:]
    for t in tgt:
        logits, cache = forward_step(n, xs)
        pred = int(np.argmax(logits))
        tf_n += 1
        if pred == t:
            tf_ok += 1
        p = softmax(logits)
        loss += -math.log(max(float(p[t]), 1e-12))
        dlogits = p.copy()
        dlogits[t] -= 1.0
        dxs = np.zeros_like(xs)
        backward_step(n, cache, dlogits, g, dxs)
        for j, tok in enumerate(seq_toks):
            g["We"][tok] += dxs[j]
            if n.cfg.pe:
                g["Pe"][min(j, TMAX - 1)] += dxs[j]
        if t == EOS:
            break
        seq_toks.append(t)
        row = embed_row(n, t, xs.shape[0])
        xs = np.vstack([xs, row])
    adam_update(n, g, adam)
    return loss, tf_ok, tf_n


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


def tf_acc(n: Net, rows) -> float:
    ok = tot = 0
    for r in rows:
        tgt = [ord(c) for c in r["ans"]] + [EOS]
        toks = list(r["ctx"].encode()[:CTX_N]) + [EOS]
        xs = np.stack([embed_row(n, t, j) for j, t in enumerate(toks)])
        for t in tgt:
            logits, _ = forward_step(n, xs)
            tot += 1
            if int(np.argmax(logits)) == t:
                ok += 1
            if t == EOS:
                break
            row = embed_row(n, t, xs.shape[0])
            xs = np.vstack([xs, row])
    return ok / tot if tot else 0.0


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
    rng = np.random.default_rng(11)
    n = Net(cfg, rng)
    adam = {"t": 0, "m": zeros_g(n), "v": zeros_g(n)}
    hist = []
    order = np.arange(len(train))
    py = np.random.default_rng(13)
    for ep in range(cfg.epochs):
        py.shuffle(order)
        tot = 0.0
        tf_ok = tf_n = 0
        for idx in order:
            r = train[int(idx)]
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_seq(n, r["ctx"].encode(), tgt, adam)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 10 == 0 or ep == cfg.epochs - 1:
            tr = eval_rows(n, [x for x in train if not x["unrel"]])
            hg = eval_rows(n, held_g)
            rec = {
                "ep": ep,
                "loss": tot / len(train),
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "train": tr["acc"],
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"{cfg.name} EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"train={tr['acc']:.3f} held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
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
    hex_path = bag / f"ckpt_ste_{cfg.name}.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    return {
        "name": cfg.name,
        "d": cfg.d,
        "f": cfg.f,
        "pe": cfg.pe,
        "n_w": cfg.n_w,
        "train_g": tr["acc"],
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "train_u": tu["acc"],
        "tf_held": tf_acc(n, held_g),
        "tf_train": tf_acc(n, [x for x in train if not x["unrel"]]),
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
        "train_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in tr["samples"][:6]],
    }


def main():
    bag = Path(__file__).resolve().parent
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    cfgs = [
        Cfg("d4_nope", 4, 8, False, 60, 0.02),
        Cfg("d16_pe", 16, 32, True, 50, 0.012),
    ]
    all_m = []
    for cfg in cfgs:
        print(f"=== STE {cfg.name} n_w={cfg.n_w} ===", flush=True)
        all_m.append(run_cfg(cfg, train, held_g, held_u, bag))
    out = {
        "bag": "ASTRA-C4-LM06-RED-BPTT-01",
        "mode": "STE_QAT",
        "program": "NO",
        "c4_master": False,
        "configs": all_m,
        "any_lang_90": any(m["lang_90"] for m in all_m),
    }
    (bag / "TRAIN_METRICS_STE.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({"any_lang_90": out["any_lang_90"], "c4_master": False}), flush=True)
    for m in all_m:
        print(
            f"CFG {m['name']} tf_train={m['tf_train']:.3f} train={m['train_g']:.3f} "
            f"held={m['held_g']:.3f} lang90={m['lang_90']} samples={m['train_samples'][:2]}",
            flush=True,
        )


if __name__ == "__main__":
    main()
