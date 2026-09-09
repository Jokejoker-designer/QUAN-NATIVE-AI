#!/usr/bin/env python3
"""Synthetic reduced LM06-compatible BYTE256 checkpoint.
PROGRAM=NO. No cloud train. Not TinyGPT-802k. Not C4_MASTER.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

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
ROOT = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH")


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def relu(x: int) -> int:
    return x if x > 0 else 0


def make_w(seed: int) -> list[int]:
    w = [0] * N_W
    s = seed & 0xFFFFFFFF

    def rnd() -> int:
        nonlocal s
        s = (s * 1664525 + 1013904223) & 0xFFFFFFFF
        return ((s >> 8) % 17) - 8

    for v in range(V):
        for d in range(D):
            w[OFF_WE + v * D + d] = sat8(rnd() + ((v >> d) & 1) * 7 - 3)
    for r in range(D):
        for c in range(D):
            diag = 28 if r == c else sat8(rnd() // 2)
            w[OFF_WQ + r * D + c] = diag
            w[OFF_WK + r * D + c] = diag
            w[OFF_WV + r * D + c] = 20 if r == c else sat8(rnd() // 2)
    for f in range(F):
        for d in range(D):
            w[OFF_W1 + f * D + d] = 16 if (f % D) == d else sat8(rnd() // 2)
    for d in range(D):
        for f in range(F):
            w[OFF_W2 + d * F + f] = 12 if (f % D) == d else sat8(rnd() // 3)
    for v in range(V):
        w[OFF_BY + v] = sat8(rnd() - (10 if v == EOS else 0))
    return w


def rd(w: list[int], i: int, zw: bool) -> int:
    return 0 if zw else w[i]


def matvec_sat(w: list[int], off: int, rows: int, cols: int, x: list[int], zw: bool) -> list[int]:
    out = [0] * rows
    for r in range(rows):
        acc = 0
        for c in range(cols):
            acc += rd(w, off + r * cols + c, zw) * x[c]
        out[r] = sat8(acc >> SHR)
    return out


def embed(w: list[int], tok: int, zw: bool) -> list[int]:
    t = tok & 255
    return [rd(w, OFF_WE + t * D + d, zw) for d in range(D)]


def block(w: list[int], xs: list[list[int]], last: int, zw: bool) -> list[int]:
    q = matvec_sat(w, OFF_WQ, D, D, xs[last], zw)
    acc = [0] * D
    wsum = 0
    for j in range(last + 1):
        k = matvec_sat(w, OFF_WK, D, D, xs[j], zw)
        dot = 0
        for d in range(D):
            dot += q[d] * k[d]
        s = relu(sat8(dot >> SHR))
        vv = matvec_sat(w, OFF_WV, D, D, xs[j], zw)
        for d in range(D):
            acc[d] += s * vv[d]
        wsum += s
    den = wsum if wsum != 0 else 1

    def tdiv(a: int, b: int) -> int:
        if b <= 0:
            b = 1
        if a < 0:
            return -((-a) // b)
        return a // b

    h = [sat8(tdiv(acc[d], den)) for d in range(D)]
    y = [sat8(xs[last][d] + h[d]) for d in range(D)]
    t = []
    for f in range(F):
        a = 0
        for d in range(D):
            a += rd(w, OFF_W1 + f * D + d, zw) * y[d]
        t.append(relu(sat8(a >> SHR)))
    u = []
    for d in range(D):
        a = 0
        for f in range(F):
            a += rd(w, OFF_W2 + d * F + f, zw) * t[f]
        u.append(sat8(a >> SHR))
    return [sat8(y[d] + u[d]) for d in range(D)]


def decode(w: list[int], ctx: bytes, evid_has: bool, seed_tok: int, zw: bool = False) -> list[int]:
    if not evid_has:
        return [ord("n"), ord("o"), EOS]
    xs: list[list[int]] = []
    for b in ctx[:CTX_N]:
        xs.append(embed(w, b, zw))
    xs.append(embed(w, seed_tok & 255, zw))
    last = len(xs) - 1
    out: list[int] = []
    for _ in range(MAX_TOK):
        z = block(w, xs, last, zw)
        best_v = 0
        best_s = None
        for v in range(V):
            sc = rd(w, OFF_BY + v, zw)
            for d in range(D):
                sc += rd(w, OFF_WE + v * D + d, zw) * z[d]
            if best_s is None or sc > best_s:
                best_s = sc
                best_v = v
        out.append(best_v)
        if best_v == EOS:
            break
        xs.append(embed(w, best_v, zw))
        last += 1
    return out


def search() -> tuple[int, list[int], dict]:
    ctx_a = b"valve requires pump"
    ctx_b = b"pump requires valve"
    for seed in range(1, 8000):
        w = make_w(seed)
        sa = decode(w, ctx_a, True, 0)
        sb = decode(w, ctx_a, True, 0x79)
        se = decode(w, ctx_b, True, 0)
        sz = decode(w, ctx_a, True, 0, True)
        safe = decode(w, ctx_a, False, 0)
        if sa == sb or sa == se or sa == sz:
            continue
        if safe != [ord("n"), ord("o"), EOS]:
            continue
        if sa[0] == EOS or len(sa) < 3 or se[0] == EOS or len(se) < 3:
            continue
        if sum(32 <= t <= 126 for t in sa) < 3:
            continue
        info = {
            "seed": seed,
            "seq_seed0": sa,
            "seq_seed_y": sb,
            "seq_ctx_b": se,
            "seq_zero": sz,
            "seq_safe": safe,
        }
        return seed, w, info
    raise SystemExit("C4L_NO_CKPT_SEED")


def main() -> None:
    bag = Path(__file__).resolve().parent
    hex_path = ROOT / "rtl" / "native_graph" / "integrate" / "a7ng_astra_c4_lm06_red.hex"
    seed, w, info = search()
    hex_path.write_text("\n".join(f"{(b & 0xFF):02x}" for b in w) + "\n", encoding="ascii")
    sha = hashlib.sha256(hex_path.read_bytes()).hexdigest()
    info.update(
        {
            "program": False,
            "c4_master": "OPEN",
            "rival": "reduced_lm06_compatible",
            "tinygpt_802k": "NOT_USED",
            "V": V,
            "D": D,
            "F": F,
            "SHR": SHR,
            "N_W": N_W,
            "hex_sha256": sha,
            "hex_rel": "rtl/native_graph/integrate/a7ng_astra_c4_lm06_red.hex",
            "training": "none_synthetic_lcg_search",
            "bram_assumed": 0,
            "dsp_assumed_sequential": 0,
            "note": "One-layer integer decoder-only. Not 90/95/5 language close.",
        }
    )
    (bag / "CKPT_PROVENANCE.json").write_text(json.dumps(info, indent=2) + "\n", encoding="ascii")
    print(f"C4L_CKPT seed={seed} n_w={N_W} sha={sha}")
    print("seq0", info["seq_seed0"])
    print("seqy", info["seq_seed_y"])
    print("seqe", info["seq_ctx_b"])
    print("seqz", info["seq_zero"])


if __name__ == "__main__":
    main()
