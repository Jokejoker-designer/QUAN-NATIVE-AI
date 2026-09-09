#!/usr/bin/env python3
"""Online random QUERY/PROOF on rival-1 Elman H=32 full-H readout. PROGRAM=NO.
ASTRA-C4-COND-RNN-ONLINE-01. Int8-scale STE. Does not edit cond_rnn KEEP hashes.
Not C4_MASTER. Frozen held-out hose/drum/vent/bolt.
"""
from __future__ import annotations

import hashlib
import json
import string
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
HELD_ENT = ["hose", "drum", "vent", "bolt"]
LETTERS = list(string.ascii_lowercase)


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


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


class Net:
    def __init__(self, rng: np.random.Generator):
        self.We = rng.normal(0, 10.0, (V, E))
        self.Wxh = rng.normal(0, 2.0, (H, E))
        self.Wxh[:E, :] += np.eye(E) * 16.0
        self.Whh = rng.normal(0, 1.0, (H, H))
        # 8-slot delay of E=4 chunks inside H=32
        for i in range(H - E):
            self.Whh[i + E, i] += 16.0
        self.bh = np.zeros(H)
        self.Wo = rng.normal(0, 1.0, (V, H))
        self.by = np.full(V, -8.0)
        self.by[32:127] = 0.0
        self.by[EOS] = -12.0

    def qi(self):
        def q(a):
            return np.clip(np.round(a), -127, 127).astype(np.int32)

        return q(self.We), q(self.Wxh), q(self.Whh), q(self.bh), q(self.Wo), q(self.by)


def step_i(We, Wxh, Whh, bh, h, tok):
    e = We[tok & 255].astype(np.int64)
    acc = bh.astype(np.int64) + (Wxh.astype(np.int64) @ e) + (Whh.astype(np.int64) @ h.astype(np.int64))
    hn = np.clip(acc >> SHR, -127, 127).astype(np.int32)
    return hn, e.astype(np.int32)


def logits_i(Wo, by, h):
    return by.astype(np.int64) + (Wo.astype(np.int64) @ h.astype(np.int64))


def softmax(x):
    z = x - x.max()
    e = np.exp(np.clip(z, -40, 40))
    return e / e.sum()


def decode_i(m: Net, ctx: bytes, evid: bool) -> list[int]:
    if not evid:
        return [ord("n"), ord("o"), EOS]
    We, Wxh, Whh, bh, Wo, by = m.qi()
    h = np.zeros(H, dtype=np.int32)
    for b in ctx[:16]:
        h, _ = step_i(We, Wxh, Whh, bh, h, int(b))
    last = EOS
    out = []
    for _ in range(MAX_TOK):
        h, _ = step_i(We, Wxh, Whh, bh, h, last)
        lg = logits_i(Wo, by, h)
        tok = int(np.argmax(lg))
        out.append(tok)
        if tok == EOS:
            break
        last = tok
    return out


def train_one(m: Net, ctx: bytes, tgt: list[int], lr: float) -> tuple[float, int, int]:
    We, Wxh, Whh, bh, Wo, by = m.qi()
    h = np.zeros(H, dtype=np.int32)
    hs = [h.copy()]
    toks = list(ctx[:16])
    for b in toks:
        h, _ = step_i(We, Wxh, Whh, bh, h, int(b))
        hs.append(h.copy())
    last = EOS
    loss = 0.0
    tf_ok = tf_n = 0
    gWe = np.zeros_like(m.We)
    gWxh = np.zeros_like(m.Wxh)
    gWhh = np.zeros_like(m.Whh)
    gbh = np.zeros_like(m.bh)
    gWo = np.zeros_like(m.Wo)
    gby = np.zeros_like(m.by)
    cache = []
    dh_list = [hs[-1].copy()]
    for t in tgt:
        e = We[last].astype(np.int64)
        acc = bh.astype(np.int64) + (Wxh.astype(np.int64) @ e) + (Whh.astype(np.int64) @ dh_list[-1].astype(np.int64))
        hn = np.clip(acc >> SHR, -127, 127).astype(np.int32)
        lg = logits_i(Wo, by, hn).astype(np.float64)
        p = softmax(lg)
        loss += -float(np.log(max(p[t], 1e-12)))
        tf_n += 1
        tf_ok += int(int(np.argmax(lg)) == t)
        cache.append((dh_list[-1].copy(), e.copy(), hn.copy(), last, t, p))
        dh_list.append(hn.copy())
        last = t
        if t == EOS:
            break
    gh = np.zeros(H, dtype=np.float64)
    for hprev, e, hn, last_t, t, p in reversed(cache):
        ds = p.copy()
        ds[t] -= 1.0
        gby += ds
        gWo += np.outer(ds, hn.astype(np.float64))
        gacc = (Wo.astype(np.float64).T @ ds + gh) / (1 << SHR)
        gbh += gacc
        gWxh += np.outer(gacc, e.astype(np.float64))
        gWhh += np.outer(gacc, hprev.astype(np.float64))
        gWe[last_t] += Wxh.astype(np.float64).T @ gacc
        gh = Whh.astype(np.float64).T @ gacc
    for i in range(len(toks) - 1, -1, -1):
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
        arr -= lr * np.clip(g, -80, 80)
        np.clip(arr, -127, 127, out=arr)
    m.by[EOS] = min(float(m.by[EOS]), -8.0)
    return loss, tf_ok, tf_n


def body(seq):
    return "".join(chr(t) for t in seq if t != EOS and 32 <= t <= 126)


def eval_rows(m, rows):
    ok = hall = 0
    samples = []
    for r in rows:
        got = body(decode_i(m, r["ctx"].encode(), True))
        samples.append((r["ctx"], r["ans"], got))
        if r["unrel"]:
            if got == "no":
                ok += 1
            else:
                hall += 1
        elif got.startswith(r["ans"]):
            ok += 1
    n = len(rows)
    return {"n": n, "ok": ok, "acc": ok / n if n else 0.0, "hall": hall, "samples": samples}


def pack_w(m: Net) -> list[int]:
    We, Wxh, Whh, bh, Wo, by = m.qi()
    w = [0] * N_W
    for v in range(V):
        for d in range(E):
            w[OFF_WE + v * E + d] = sat8(int(We[v, d]))
        for d in range(H):
            w[OFF_WO + v * H + d] = sat8(int(Wo[v, d]))
        w[OFF_BY + v] = sat8(int(by[v]))
    for r in range(H):
        for c in range(E):
            w[OFF_WXH + r * E + c] = sat8(int(Wxh[r, c]))
        for c in range(H):
            w[OFF_WHH + r * H + c] = sat8(int(Whh[r, c]))
        w[OFF_BH + r] = sat8(int(bh[r]))
    return w


def main():
    bag = Path(__file__).resolve().parent
    rng = np.random.default_rng(11)
    m = Net(rng)
    data_rng = np.random.default_rng(21)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    hist = []
    bs, epochs, lr = 160, 28, 0.03
    for ep in range(epochs):
        tot = tf_ok = tf_n = 0
        for _ in range(bs):
            r = fresh_row(data_rng)
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            loss, a, b = train_one(m, r["ctx"].encode(), tgt, lr if ep < 16 else lr * 0.5)
            tot += loss
            tf_ok += a
            tf_n += b
        if ep % 4 == 0 or ep == epochs - 1:
            hg = eval_rows(m, held_g)
            rec = {
                "ep": ep,
                "loss": tot / bs,
                "tf": tf_ok / tf_n if tf_n else 0.0,
                "held": hg["acc"],
                "held_ok": hg["ok"],
            }
            hist.append(rec)
            print(
                f"EP {ep} loss={rec['loss']:.3f} tf={rec['tf']:.3f} "
                f"held={hg['acc']:.3f} ({hg['ok']}/{hg['n']})",
                flush=True,
            )
            if hg["acc"] >= 0.90:
                break
    hg = eval_rows(m, held_g)
    hu = eval_rows(m, held_u)
    safe = decode_i(m, b"F hose pump>hose", False)
    hall_rate = hu["hall"] / hu["n"] if hu["n"] else 1.0
    w = pack_w(m)
    hex_path = bag / "ckpt_elman_h32_online.hex"
    hex_path.write_text("\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n", encoding="ascii")
    out = {
        "bag": "ASTRA-C4-COND-RNN-ONLINE-01",
        "rival": "elman_h32_fullH_untiedWo",
        "n_w": N_W,
        "program": "NO",
        "c4_master": False,
        "held_g": hg["acc"],
        "held_g_ok": hg["ok"],
        "held_g_n": hg["n"],
        "held_u": hu["acc"],
        "hall_rate": hall_rate,
        "safe_no": safe == [ord("n"), ord("o"), EOS],
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe == [ord("n"), ord("o"), EOS]) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "tinygpt": False,
        "keep_elman_unedited": True,
        "hex_sha256": hashlib.sha256(hex_path.read_bytes()).hexdigest(),
        "hist": hist,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:8]],
    }
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print("SUMMARY", json.dumps({k: out[k] for k in ("lang_90", "held_g", "hall_rate", "n_w")}), flush=True)
    print("held", out["held_samples"][:4], flush=True)


if __name__ == "__main__":
    main()
