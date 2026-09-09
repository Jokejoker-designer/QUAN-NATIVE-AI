#!/usr/bin/env python3
"""Local float-CE then int8 export for ASTRA-C4-COND-RNN-LANG-01.
PROGRAM=NO. Same Elman law as rival-1. No cloud. Not C4_MASTER.
"""
from __future__ import annotations

import hashlib
import json
import random
from pathlib import Path

import numpy as np

V, E, H, SHR, MAX_TOK, CTX_N = 256, 4, 8, 4, 6, 16
EOS = 0
OFF_WE, OFF_WXH, OFF_WHH, OFF_BH, OFF_BY = 0, 1024, 1056, 1120, 1128
N_W = 1384
TRAIN_ENT = ["pump", "valv", "tank", "pipe"]
HELD_ENT = ["hose", "drum", "vent", "bolt"]
SCALE = 16.0


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def pack16(s: str) -> bytes:
    b = s.encode("ascii")
    if len(b) != 16:
        raise ValueError(f"ctx len {len(b)} {s!r}")
    return b


def ctx_f(dst: str, src: str) -> str:
    return pack16(f"F {dst} {src}>{dst}").decode()


def ctx_r(src: str, dst: str) -> str:
    return pack16(f"R {src} {src}>{dst}").decode()


def make_split(ents: list[str], op: str) -> list[dict]:
    rows = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            if op == "F":
                rows.append({"op": "F", "src": src, "dst": dst, "ctx": ctx_f(dst, src),
                             "ans": src, "evid": True, "unrel": False})
            else:
                rows.append({"op": "R", "src": src, "dst": dst, "ctx": ctx_r(src, dst),
                             "ans": dst, "evid": True, "unrel": False})
    return rows


def make_unrel(ents: list[str]) -> list[dict]:
    rows = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            other = next(e for e in ents if e != dst and e != src)
            rows.append({"op": "F", "src": src, "dst": dst,
                         "ctx": pack16(f"F {dst} {src}>{other}").decode(),
                         "ans": "no", "evid": True, "unrel": True})
    return rows


class Elman:
    def __init__(self, rng: np.random.Generator):
        self.We = rng.normal(0, 0.3, (V, E)).astype(np.float64)
        self.Wxh = rng.normal(0, 0.2, (H, E)).astype(np.float64)
        self.Whh = rng.normal(0, 0.2, (H, H)).astype(np.float64)
        np.fill_diagonal(self.Wxh[:E, :], 1.2)
        np.fill_diagonal(self.Whh, 0.6)
        self.bh = np.zeros(H, dtype=np.float64)
        self.by = np.full(V, -6.0, dtype=np.float64)
        self.by[EOS] = -1.0
        for c in range(32, 127):
            self.by[c] = 0.0

    def step(self, h, tok: int):
        e = self.We[tok]
        acc = self.bh + self.Wxh @ e + self.Whh @ h
        hn = np.clip(acc / SCALE, -127.0, 127.0)
        return hn, e, acc

    def logits(self, h):
        return self.by + self.We @ h[:E]


def softmax(x: np.ndarray) -> np.ndarray:
    z = x - x.max()
    e = np.exp(np.clip(z, -20, 20))
    return e / e.sum()


def train_example(m: Elman, ctx: bytes, tgt: list[int], lr: float) -> float:
    h = np.zeros(H, dtype=np.float64)
    hs = [h.copy()]
    toks = []
    for b in ctx:
        h, _, _ = m.step(h, b)
        hs.append(h.copy())
        toks.append(b)
    last = 0
    loss = 0.0
    gWe = np.zeros_like(m.We)
    gWxh = np.zeros_like(m.Wxh)
    gWhh = np.zeros_like(m.Whh)
    gbh = np.zeros_like(m.bh)
    gby = np.zeros_like(m.by)
    gh = np.zeros(H, dtype=np.float64)
    # decode teacher force, accumulate output grads then BPTT encode
    dec_h = [hs[-1].copy()]
    dec_tok = [last]
    for t in tgt:
        h, e, acc = m.step(dec_h[-1], dec_tok[-1])
        lg = m.logits(h)
        p = softmax(lg)
        loss += -np.log(max(p[t], 1e-12))
        ds = p.copy()
        ds[t] -= 1.0
        gby += ds
        gWe += np.outer(ds, h[:E])
        gh_out = np.zeros(H, dtype=np.float64)
        gh_out[:E] += m.We.T @ ds
        # step grads
        # hn = clip(acc/16); ignore clip for STE
        gacc = gh_out / SCALE
        gbh += gacc
        gWxh += np.outer(gacc, e)
        gWhh += np.outer(gacc, dec_h[-1])
        gWe[dec_tok[-1]] += m.Wxh.T @ gacc
        gh = m.Whh.T @ gacc
        dec_h.append(h.copy())
        dec_tok.append(t)
        last = t
    # BPTT through encoder
    for i in range(len(ctx) - 1, -1, -1):
        h_prev = hs[i]
        tok = ctx[i]
        e = m.We[tok]
        gacc = gh / SCALE
        gbh += gacc
        gWxh += np.outer(gacc, e)
        gWhh += np.outer(gacc, h_prev)
        gWe[tok] += m.Wxh.T @ gacc
        gh = m.Whh.T @ gacc
    for arr, g in ((m.We, gWe), (m.Wxh, gWxh), (m.Whh, gWhh), (m.bh, gbh), (m.by, gby)):
        arr -= lr * np.clip(g, -5, 5)
        np.clip(arr, -24, 24, out=arr)
    return loss


def to_int(m: Elman) -> list[int]:
    w = [0] * N_W
    def q(x: float) -> int:
        return sat8(int(np.round(x)))
    for v in range(V):
        for e in range(E):
            w[OFF_WE + v * E + e] = q(m.We[v, e] * 8.0)
        w[OFF_BY + v] = q(m.by[v] * 4.0)
    for h in range(H):
        w[OFF_BH + h] = q(m.bh[h] * 8.0)
        for e in range(E):
            w[OFF_WXH + h * E + e] = q(m.Wxh[h, e] * 8.0)
        for hh in range(H):
            w[OFF_WHH + h * H + hh] = q(m.Whh[h, hh] * 8.0)
    return w


def rnn_step_i(w: list[int], h: list[int], tok: int) -> list[int]:
    emb = [w[OFF_WE + tok * E + e] for e in range(E)]
    hn = [0] * H
    for hi in range(H):
        acc = w[OFF_BH + hi]
        for e in range(E):
            acc += w[OFF_WXH + hi * E + e] * emb[e]
        for hh in range(H):
            acc += w[OFF_WHH + hi * H + hh] * h[hh]
        hn[hi] = sat8(acc >> SHR)
    return hn


def decode_i(w: list[int], ctx: bytes, evid_has: bool) -> list[int]:
    if not evid_has:
        return [ord("n"), ord("o"), EOS]
    h = [0] * H
    for b in ctx[:CTX_N]:
        h = rnn_step_i(w, h, b)
    last = 0
    out: list[int] = []
    for _ in range(MAX_TOK):
        h = rnn_step_i(w, h, last)
        best_v, best_s = 0, None
        for v in range(V):
            sc = w[OFF_BY + v]
            for e in range(E):
                sc += w[OFF_WE + v * E + e] * h[e]
            if best_s is None or sc > best_s:
                best_s = sc
                best_v = v
        out.append(best_v)
        last = best_v
        if best_v == EOS:
            break
    return out


def body_text(seq: list[int]) -> str:
    chars = []
    for t in seq:
        if t == EOS:
            break
        chars.append(chr(t) if 32 <= t <= 126 else "?")
    return "".join(chars)


def eval_rows(w: list[int], rows: list[dict]) -> dict:
    n = len(rows)
    ok = 0
    hall = 0
    for r in rows:
        seq = decode_i(w, r["ctx"].encode(), True)
        got = body_text(seq)
        if r.get("unrel"):
            if got.startswith("no") or got in ("", "n"):
                ok += 1
            else:
                hall += 1
        elif got.startswith(r["ans"]):
            ok += 1
    return {"n": n, "ok": ok, "acc": (ok / n if n else 0.0), "hall_n": hall}


def hex_of(w: list[int]) -> str:
    return "\n".join(f"{(x & 0xFF):02x}" for x in w) + "\n"


def main() -> None:
    bag = Path(__file__).resolve().parent
    train = make_split(TRAIN_ENT, "F") + make_split(TRAIN_ENT, "R") + make_unrel(TRAIN_ENT)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:20]
    rng = np.random.default_rng(11)
    m = Elman(rng)
    py_rng = random.Random(11)
    for ep in range(60):
        py_rng.shuffle(train)
        tot = 0.0
        lr = 0.05 if ep < 20 else 0.02 if ep < 40 else 0.008
        for r in train:
            tgt = [ord(c) for c in r["ans"]] + [EOS]
            tot += train_example(m, r["ctx"].encode(), tgt, lr)
        if ep % 5 == 0 or ep == 59:
            w = to_int(m)
            hg = eval_rows(w, held_g)
            tr = eval_rows(w, [x for x in train if not x.get("unrel")])
            print(f"EP {ep} loss={tot/len(train):.3f} train_g={tr['acc']:.3f} held_g={hg['acc']:.3f}", flush=True)
    w = to_int(m)
    hg = eval_rows(w, held_g)
    hu = eval_rows(w, held_u)
    tr = eval_rows(w, [x for x in train if not x.get("unrel")])
    tu = eval_rows(w, [x for x in train if x.get("unrel")])
    safe = decode_i(w, b"F hose pump>hose", False)
    hall_rate = hu["hall_n"] / hu["n"] if hu["n"] else 1.0
    safe_ok = safe == [ord("n"), ord("o"), EOS]
    metrics = {
        "train_grounded_acc": tr["acc"], "held_grounded_acc": hg["acc"],
        "held_grounded_ok": hg["ok"], "held_grounded_n": hg["n"],
        "held_unrel_acc": hu["acc"], "held_unrel_hall_rate": hall_rate,
        "train_unrel_acc": tu["acc"],
        "safe_no": safe_ok,
        "lang_90": hg["acc"] >= 0.90,
        "lang_safe95": bool(safe_ok) and hu["acc"] >= 0.95,
        "lang_hall5": hall_rate <= 0.05,
        "n_w": N_W, "seed": 11, "epochs": 60, "cloud": False, "c4_master": False,
    }
    hex_path = bag / "a7ng_astra_c4_cond_rnn_lang.hex"
    hex_path.write_text(hex_of(w), encoding="ascii")
    metrics["hex_sha256"] = hashlib.sha256(hex_path.read_bytes()).hexdigest()
    corpus = {"train": train, "held_grounded": held_g, "held_unrel": held_u,
              "train_entities": TRAIN_ENT, "held_entities": HELD_ENT,
              "ctx_law": "16-byte packed F dst src>dst / R src src>dst"}
    (bag / "corpus.json").write_text(json.dumps(corpus, indent=2), encoding="utf-8")
    lines = ["// auto from train_lang.py before xvlog. PROGRAM=NO.",
             f"localparam int unsigned C4L_NG = {len(held_g)};",
             f"localparam int unsigned C4L_NU = {len(held_u)};"]
    for i, r in enumerate(held_g):
        lines.append(f'localparam string C4L_GCTX_{i} = "{r["ctx"]}";')
        lines.append(f'localparam string C4L_GANS_{i} = "{r["ans"]}";')
    for i, r in enumerate(held_u):
        lines.append(f'localparam string C4L_UCTX_{i} = "{r["ctx"]}";')
    (bag / "tb_heldout.svh").write_text("\n".join(lines) + "\n", encoding="ascii")
    (bag / "TRAIN_METRICS.json").write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    print("METRICS", json.dumps(metrics), flush=True)
    samples = []
    for r in held_g[:6]:
        seq = decode_i(w, r["ctx"].encode(), True)
        samples.append({"ctx": r["ctx"], "ans": r["ans"], "got": body_text(seq), "seq": seq})
    print("SAMPLES", json.dumps(samples), flush=True)


if __name__ == "__main__":
    main()
