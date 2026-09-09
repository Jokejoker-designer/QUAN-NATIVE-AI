#!/usr/bin/env python3
"""Local synthetic integer Elman checkpoint for ASTRA-C4-COND-RNN-BYTE256-01.
PROGRAM=NO. Not trained on cloud. Not C4_MASTER. Writes hex + provenance.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

V, E, H, SHR, MAX_TOK, CTX_N = 256, 4, 8, 4, 6, 16
EOS = 0
OFF_WE = 0
OFF_WXH = V * E
OFF_WHH = OFF_WXH + H * E
OFF_BH = OFF_WHH + H * H
OFF_BY = OFF_BH + H
N_W = OFF_BY + V


def sat8(x: int) -> int:
    if x > 127:
        return 127
    if x < -127:
        return -127
    return int(x)


def clip8(x: int) -> int:
    return sat8(((x + 128) % 256) - 128) if False else sat8(x)


def make_w(seed: int) -> list[int]:
    w = [0] * N_W
    s = seed & 0xFFFFFFFF

    def rnd() -> int:
        nonlocal s
        s = (s * 1664525 + 1013904223) & 0xFFFFFFFF
        return ((s >> 8) % 17) - 8

    for v in range(V):
        for e in range(E):
            w[OFF_WE + v * E + e] = sat8(rnd() + ((v >> e) & 1) * 6 - 3)
    for h in range(H):
        for e in range(E):
            w[OFF_WXH + h * E + e] = 24 if h == e else sat8(rnd())
        for hh in range(H):
            w[OFF_WHH + h * H + hh] = 18 if h == hh else sat8(rnd() // 2)
        w[OFF_BH + h] = sat8(rnd())
    for v in range(V):
        w[OFF_BY + v] = sat8(rnd() - (8 if v == EOS else 0))
    return w


def rnn_step(w: list[int], h: list[int], tok: int) -> list[int]:
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


def decode(w: list[int], ctx: bytes, evid_has: bool, seed_tok: int) -> list[int]:
    if not evid_has:
        return [ord("n"), ord("o"), EOS]
    h = [0] * H
    for b in ctx[:CTX_N]:
        h = rnn_step(w, h, b)
    last = seed_tok & 255
    out: list[int] = []
    for _ in range(MAX_TOK):
        h = rnn_step(w, h, last)
        best_v = 0
        best_s = None
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


def ascii_ok(seq: list[int]) -> bool:
    body = [t for t in seq if t != EOS]
    if len(body) < 3:
        return False
    return all((32 <= t <= 126) or t == EOS for t in seq)


def search() -> tuple[int, list[int], dict]:
    ctx_a = b"valve requires pump"
    ctx_b = b"pump requires valve"
    for seed in range(1, 40000):
        w = make_w(seed)
        sa = decode(w, ctx_a, True, 0)
        sb = decode(w, ctx_a, True, 0x79)
        se = decode(w, ctx_b, True, 0)
        sz = decode([0] * N_W, ctx_a, True, 0)
        safe = decode(w, ctx_a, False, 0)
        if sa == sb:
            continue
        if sa == se:
            continue
        if sa == sz:
            continue
        if safe != [ord("n"), ord("o"), EOS]:
            continue
        if sa[0] == EOS or len(sa) < 3:
            continue
        if se[0] == EOS or len(se) < 3:
            continue
        npr_a = sum(32 <= t <= 126 for t in sa)
        npr_e = sum(32 <= t <= 126 for t in se)
        if npr_a < 3 or npr_e < 3:
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
    raise SystemExit("C4RNN_NO_CKPT_SEED")


def main() -> None:
    bag = Path(__file__).resolve().parent
    root = bag.parents[2]
    hex_path = root / "rtl" / "native_graph" / "integrate" / "a7ng_astra_c4_cond_rnn.hex"
    seed, w, info = search()
    lines = [f"{(b & 0xFF):02x}" for b in w]
    hex_path.write_text("\n".join(lines) + "\n", encoding="ascii")
    raw = hex_path.read_bytes()
    sha = hashlib.sha256(raw).hexdigest()
    info.update(
        {
            "program": False,
            "c4_master": "OPEN",
            "rival": "compact_recurrent_byte256",
            "V": V,
            "E": E,
            "H": H,
            "SHR": SHR,
            "N_W": N_W,
            "hex_sha256": sha,
            "hex_rel": "rtl/native_graph/integrate/a7ng_astra_c4_cond_rnn.hex",
            "training": "none_synthetic_lcg_search",
            "note": "Hand-constructed integer Elman; not 90/95/5 language close.",
        }
    )
    (bag / "CKPT_PROVENANCE.json").write_text(json.dumps(info, indent=2) + "\n", encoding="ascii")
    print(f"C4RNN_CKPT seed={seed} n_w={N_W} sha={sha}")
    print("seq0", info["seq_seed0"])
    print("seqy", info["seq_seed_y"])
    print("seqe", info["seq_ctx_b"])


if __name__ == "__main__":
    main()
