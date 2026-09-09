#!/usr/bin/env python3
"""Constructive BYTE256 AR checkpoint for ASTRA-C4-LM06-BYTE256-ARLANG-01.

Tied int8 embeddings E[v] plus step vectors B[step] plus copy gates G[step].
Does not overwrite tests/xsim/a7lm06_wmem.hex. PROGRAM=NO.
"""
from __future__ import annotations

import random
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HEX = ROOT / "rtl" / "native_graph" / "integrate" / "a7ng_astra_c4_lm06_byte256_arlang.hex"
D = 32
V = 256
SHIFT = 8
YES = (121, 101, 115)


def clamp8(x: int) -> int:
    return max(-127, min(127, int(x)))


def ch(i: int, pos: int) -> int:
    if pos == 0:
        return 0x41 + (i % 26)
    if pos == 1:
        return 0x61 + ((i * 5) % 26)
    return 0x30 + (i % 10)


def add(a, b, scale: int = 1):
    return [clamp8(x + scale * y) for x, y in zip(a, b)]


def main() -> int:
    random.seed(0xC4A11A09)
    E = [[clamp8(int(random.gauss(0, 28))) for _ in range(D)] for _ in range(V)]
    for v in range(V):
        if all(x == 0 for x in E[v]):
            E[v][v % D] = 40

    def score_vec(h):
        best = 0
        bs = None
        for v in range(V):
            acc = sum(E[v][d] * h[d] for d in range(D))
            s = acc >> SHIFT
            if bs is None or s > bs:
                bs = s
                best = v
        return best

    def makeB(tgt: int, last: int):
        return [clamp8(3 * E[tgt][d] - E[last][d]) for d in range(D)]

    B = [[0] * D for _ in range(8)]
    B[0] = makeB(YES[0], 0)
    B[1] = makeB(YES[1], YES[0])
    B[2] = makeB(YES[2], YES[1])
    B[7] = [clamp8(3 * E[0][d]) for d in range(D)]
    G = [[0, 0, 0] for _ in range(8)]
    G[3] = [4, 0, 0]
    G[4] = [0, 4, 0]
    G[5] = [0, 0, 4]

    def run(dst: int, evid: bool):
        last = 0
        out = []
        for step in range(8):
            if (not evid) or step >= 6:
                h = B[7][:]
            else:
                h = add(E[last], B[step])
                o0, o1, o2 = ch(dst, 0), ch(dst, 1), ch(dst, 2)
                g = G[step]
                if g[0]:
                    h = add(h, E[o0], g[0])
                if g[1]:
                    h = add(h, E[o1], g[1])
                if g[2]:
                    h = add(h, E[o2], g[2])
            tok = score_vec(h)
            out.append(tok)
            last = tok
            if tok == 0:
                break
        return out

    def gold(dst, evid):
        if not evid:
            return [0]
        return [121, 101, 115, ch(dst, 0), ch(dst, 1), ch(dst, 2), 0]

    hold_ok = sum(1 for d in range(40, 60) if run(d, True) == gold(d, True))
    un_ok = int(run(40, False) == [0])
    print(f"HOLD {hold_ok}/20 UNSUP {un_ok} d40 {run(40, True)} d50 {run(50, True)}")
    if hold_ok < 20 or un_ok != 1:
        return 2

    lines = []
    for v in range(V):
        for d in range(D):
            lines.append(f"{E[v][d] & 0xFF:02x}")
    for s in range(8):
        for d in range(D):
            lines.append(f"{B[s][d] & 0xFF:02x}")
    for s in range(8):
        for k in range(3):
            lines.append(f"{G[s][k] & 0xFF:02x}")
    HEX.write_text("\n".join(lines) + "\n", encoding="ascii")
    print("WROTE", HEX, "nlines", len(lines))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
