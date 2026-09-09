#!/usr/bin/env python3
"""Refuse probes on frozen 20/20 gated copy net. PROGRAM=NO. Not C4_MASTER.
A: byte-compare wrapper (glue ceiling).
B: We-only mismatch logit bias (token-id equivalent if We is a lookup).
C: Pe-inclusive mismatch logit bias (same feature as failed mix-delta).
"""
from __future__ import annotations

import json
import math
from pathlib import Path

import numpy as np

from train_float import (
    EOS,
    HELD_ENT,
    MAX_TOK,
    Net,
    embed,
    eval_rows,
    forward,
    make_split,
    make_unrel,
    softmax,
)
from train_float_best import restore
from train_gated import copy_attn, eval_gated, install_attn, scores
from train_gated_mix import mismatch_vec
from train_gated_unrel import decode_gated_i, row_u
from train_gated_mix import row_f


def load_gated(bag: Path):
    rng = np.random.default_rng(0)
    n = Net(rng)
    z = np.load(bag / "snap_gated_b.npz")
    restore(n, {k: z[k] for k in ("We", "Wq", "Wk", "Wv", "W1", "W2", "by", "Pe")})
    f_attn = (z["WqF"].copy(), z["WkF"].copy(), z["WvF"].copy())
    r_attn = (z["WqR"].copy(), z["WkR"].copy(), z["WvR"].copy())
    return n, f_attn, r_attn


def decode_copy(n, ctx, evid, f_attn, r_attn):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    r = ctx[:1] == b"R"
    install_attn(n, *(r_attn if r else f_attn))
    toks = list(ctx[:16]) + [EOS]
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


def decode_glue(n, ctx, evid, f_attn, r_attn):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    if ctx[:1] == b"F" and ctx[2:6] != ctx[12:16]:
        return [ord("n"), ord("o"), EOS]
    return decode_copy(n, ctx, evid, f_attn, r_attn)


def we_delta(n: Net, ctx: bytes) -> float:
    a = n.We[np.frombuffer(ctx[2:6], dtype=np.uint8)].mean(axis=0)
    b = n.We[np.frombuffer(ctx[12:16], dtype=np.uint8)].mean(axis=0)
    return float(np.sum((a - b) ** 2))


def decode_bias(n, ctx, evid, f_attn, r_attn, mode: str, alpha: float, beta: float, b_no: np.ndarray):
    if not evid:
        return [ord("n"), ord("o"), EOS]
    r = ctx[:1] == b"R"
    install_attn(n, *(r_attn if r else f_attn))
    toks = list(ctx[:16]) + [EOS]
    xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
    if r:
        d2 = 0.0
        m = 0.0
    elif mode == "we":
        d2 = we_delta(n, ctx)
        m = 1.0 / (1.0 + math.exp(-(alpha * d2 + beta)))
    else:
        d2 = float(np.sum(mismatch_vec(xs) ** 2))
        m = 1.0 / (1.0 + math.exp(-(alpha * d2 + beta)))
    out = []
    for _ in range(MAX_TOK):
        logits, _ = forward(n, xs)
        if not r:
            logits = logits + m * b_no
        tok = int(np.argmax(logits))
        out.append(tok)
        if tok == EOS:
            break
        xs = np.vstack([xs, embed(n, tok, xs.shape[0])])
    return out


def metrics(n, held_g, held_u, fn):
    hg = eval_rows(n, held_g, fn)
    hu = eval_rows(n, held_u, fn)
    n_f, n_r = scores(hg)
    hall = hu["hall"] / hu["n"] if hu["n"] else 1.0
    return {
        "held": hg["acc"],
        "f": n_f,
        "r": n_r,
        "unrel": hu["acc"],
        "hall": hall,
        "lang_90_95_5": hg["acc"] >= 0.90 and hu["acc"] >= 0.95 and hall <= 0.05,
        "held_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hg["samples"][:4]],
        "unrel_samples": [{"ctx": a, "ans": b, "got": c} for a, b, c in hu["samples"][:4]],
    }


def train_bias(n, f_attn, r_attn, mode: str, held_g, held_u, data_rng):
    alpha, beta = 4.0, -2.0
    b_no = np.zeros(256, dtype=np.float64)
    b_no[ord("n")] = 8.0
    b_no[ord("o")] = 8.0
    b_no[EOS] = 4.0
    hist = []
    best = None
    m_a = m_b = v_a = v_b = 0.0
    m_no = np.zeros_like(b_no)
    v_no = np.zeros_like(b_no)
    for ep in range(24):
        lr = 0.05
        for _ in range(64):
            if int(data_rng.integers(0, 2)) == 0:
                ctx, ans = row_f(data_rng)
            else:
                ctx, ans = row_u(data_rng)
            raw = ctx.encode()
            tgt = [ord(c) for c in ans] + [EOS]
            install_attn(n, *f_attn)
            toks = list(raw[:16]) + [EOS]
            xs = np.stack([embed(n, t, j) for j, t in enumerate(toks)])
            if mode == "we":
                d2 = we_delta(n, raw)
            else:
                d2 = float(np.sum(mismatch_vec(xs) ** 2))
            z = alpha * d2 + beta
            m = 1.0 / (1.0 + math.exp(-np.clip(z, -40, 40)))
            g_a = g_b = 0.0
            g_no = np.zeros_like(b_no)
            for t in tgt:
                logits, _ = forward(n, xs)
                logits = logits + m * b_no
                p = softmax(logits)
                dlog = p.copy()
                dlog[t] -= 1.0
                g_no += m * dlog
                dm = float(dlog @ b_no)
                ds = dm * m * (1.0 - m)
                g_a += ds * d2
                g_b += ds
                if t == EOS:
                    break
                xs = np.vstack([xs, embed(n, t, xs.shape[0])])
            m_a = 0.9 * m_a + 0.1 * g_a
            v_a = 0.999 * v_a + 0.001 * (g_a * g_a)
            m_b = 0.9 * m_b + 0.1 * g_b
            v_b = 0.999 * v_b + 0.001 * (g_b * g_b)
            m_no = 0.9 * m_no + 0.1 * g_no
            v_no = 0.999 * v_no + 0.001 * (g_no * g_no)
            alpha -= lr * m_a / (math.sqrt(v_a) + 1e-8)
            beta -= lr * m_b / (math.sqrt(v_b) + 1e-8)
            b_no -= lr * m_no / (np.sqrt(v_no) + 1e-8)
            alpha = float(np.clip(alpha, -32, 32))
            beta = float(np.clip(beta, -32, 32))
            np.clip(b_no, -32, 32, out=b_no)
        def fn(net, ctx, evid, _a=alpha, _b=beta, _bn=b_no.copy()):
            return decode_bias(net, ctx, evid, f_attn, r_attn, mode, _a, _b, _bn)

        rec = metrics(n, held_g, held_u, fn)
        rec = {k: rec[k] for k in ("held", "f", "r", "unrel", "hall", "lang_90_95_5")}
        rec.update({"ep": ep, "alpha": alpha, "beta": beta})
        hist.append(rec)
        print(
            f"BIAS {mode} EP {ep} F={rec['f']} R={rec['r']} unrel={rec['unrel']:.3f} hall={rec['hall']:.3f}",
            flush=True,
        )
        score = (rec["lang_90_95_5"], rec["held"] + rec["unrel"] - rec["hall"])
        if best is None or score > best["score"]:
            best = {"score": score, "alpha": alpha, "beta": beta, "b_no": b_no.copy(), "rec": rec}
        if rec["lang_90_95_5"]:
            break
    def fn_best(net, ctx, evid):
        return decode_bias(net, ctx, evid, f_attn, r_attn, mode, best["alpha"], best["beta"], best["b_no"])

    out = metrics(n, held_g, held_u, fn_best)
    out["hist"] = hist
    out["alpha"] = best["alpha"]
    out["beta"] = best["beta"]
    return out


def d2_stats(n, rows, f_attn, mode: str):
    vals_m = []
    vals_u = []
    for r in rows:
        ctx = r["ctx"].encode()
        install_attn(n, *f_attn)
        xs = np.stack([embed(n, t, j) for j, t in enumerate(list(ctx[:16]) + [EOS])])
        d2 = we_delta(n, ctx) if mode == "we" else float(np.sum(mismatch_vec(xs) ** 2))
        (vals_u if r.get("unrel") else vals_m).append(d2)
    def st(v):
        a = np.array(v, dtype=np.float64)
        return {"n": int(a.size), "min": float(a.min()), "max": float(a.max()), "mean": float(a.mean())}

    return {"match": st(vals_m) if vals_m else None, "unrel": st(vals_u) if vals_u else None}


def main():
    bag = Path(__file__).resolve().parent
    n, f_attn, r_attn = load_gated(bag)
    held_g = (make_split(HELD_ENT, "F") + make_split(HELD_ENT, "R"))[:20]
    held_u = make_unrel(HELD_ENT)[:12]
    copy = metrics(n, held_g, held_u, lambda net, ctx, evid: decode_copy(net, ctx, evid, f_attn, r_attn))
    glue = metrics(n, held_g, held_u, lambda net, ctx, evid: decode_glue(net, ctx, evid, f_attn, r_attn))
    print(f"COPY F={copy['f']} R={copy['r']} unrel={copy['unrel']:.3f}", flush=True)
    print(f"GLUE F={glue['f']} R={glue['r']} unrel={glue['unrel']:.3f} hit={glue['lang_90_95_5']}", flush=True)
    stats_we = d2_stats(n, [r for r in held_g if r["ctx"].startswith("F")] + held_u, f_attn, "we")
    stats_pe = d2_stats(n, [r for r in held_g if r["ctx"].startswith("F")] + held_u, f_attn, "pe")
    rng = np.random.default_rng(21)
    we = train_bias(n, f_attn, r_attn, "we", held_g, held_u, rng)
    pe = train_bias(n, f_attn, r_attn, "pe", held_g, held_u, np.random.default_rng(21))
    hg_i = eval_rows(n, held_g, lambda net, ctx, evid: decode_gated_i(net, ctx, evid, f_attn, r_attn))
    out = {
        "bag": "ASTRA-C4-LM06-RED-FLOATTFM-01",
        "program": "NO",
        "c4_master": False,
        "copy_only": {k: copy[k] for k in ("held", "f", "r", "unrel", "hall", "lang_90_95_5")},
        "byte_compare_glue": {
            **{k: glue[k] for k in ("held", "f", "r", "unrel", "hall", "lang_90_95_5")},
            "glue": True,
            "letter_hit": False,
        },
        "d2_we": stats_we,
        "d2_pe": stats_pe,
        "bias_we": {k: we[k] for k in ("held", "f", "r", "unrel", "hall", "lang_90_95_5", "alpha", "beta", "hist")},
        "bias_pe": {k: pe[k] for k in ("held", "f", "r", "unrel", "hall", "lang_90_95_5", "alpha", "beta", "hist")},
        "copy_int8": hg_i["acc"],
        "note": "byte-compare wrapper is glue, not C4_MASTER even if 90/95/5. We-only d2 is token-id equivalent.",
    }
    (bag / "TRAIN_METRICS_REFUSE.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(
        "SUMMARY",
        json.dumps(
            {
                "glue_hit": glue["lang_90_95_5"],
                "we_hit": we["lang_90_95_5"],
                "pe_hit": pe["lang_90_95_5"],
                "we_f": we["f"],
                "we_u": we["unrel"],
                "pe_f": pe["f"],
                "pe_u": pe["unrel"],
                "int8": hg_i["acc"],
            }
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
