#!/usr/bin/env python3
"""Freeze native-rank-sgd-q8-v1-sym-f2r2 oracles for F2R3. PROGRAM=NO."""
from __future__ import annotations
import json
from pathlib import Path

SHIFT = 6
N = 32


def rsh(v: int, s: int) -> int:
    if s <= 0:
        raise ValueError("s")
    a = abs(v)
    a = (a + (1 << (s - 1))) >> s
    return -a if v < 0 else a


def sat16(v: int) -> int:
    if v > 32767:
        return 32767
    if v < -32768:
        return -32768
    return v


def clamp(v: int, lo: int, hi: int) -> int:
    return lo if v < lo else hi if v > hi else v


def score(w: list[int], x: list[int]) -> int:
    acc = 0
    for wi, xi in zip(w, x):
        acc += int(wi) * int(xi)
    return clamp(rsh(acc, 7), -768, 768)


def update(w: list[int], x: list[int], rew: int) -> tuple[list[int], int, int, list[int]]:
    v = score(w, x)
    err = clamp(rew * 256 - v, -1536, 1536)
    dw = [sat16(rsh(err * int(xi), 7 + SHIFT)) for xi in x]
    wn = [sat16(int(wi) + d) for wi, d in zip(w, dw)]
    return wn, v, err, dw


def vec(*nz: tuple[int, int]) -> list[int]:
    x = [0] * N
    for i, v in nz:
        x[i] = v
    return x


def main() -> None:
    z = [0] * N
    p50 = vec((0, 50), (1, 64), (2, 64), (3, 64), (4, 64))
    p2 = vec((0, 2), (1, 64), (2, 64), (3, 64), (4, 64))
    x50 = vec((0, 50))
    x64 = vec((0, 64))

    cases = {}

    wn, v, err, dw = update(z, x50, 3)
    cases["iso_p3_x50"] = {"rew": 3, "x": x50, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}
    wn, v, err, dw = update(z, x64, -3)
    cases["iso_m3_x64"] = {"rew": -3, "x": x64, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}
    wn, v, err, dw = update(z, p50, -3)
    cases["p50_m3"] = {"rew": -3, "x": p50, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}
    wn, v, err, dw = update(z, p50, 3)
    cases["p50_p3"] = {"rew": 3, "x": p50, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}
    wn, v, err, dw = update(z, p50, 0)
    cases["p50_z0"] = {"rew": 0, "x": p50, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}
    wn, v, err, dw = update(z, p2, -3)
    cases["p2_m3"] = {"rew": -3, "x": p2, "w0": z, "v": v, "err": err, "dw": dw, "w1": wn}

    floor_p3_x50 = (768 * 50) >> 13
    cases["contrast_floor_p3_x50_dw0"] = floor_p3_x50
    cases["law"] = {
        "id": "native-rank-sgd-q8-v1-sym-f2r2",
        "SHIFT": SHIFT,
        "acc": "signed40",
        "v": "clamp(RSH(acc,7),-768,+768)",
        "err": "clamp(rew*256-v,-1536,+1536)",
        "RSH": "sign(v)*floor((abs(v)+2**(s-1))/2**s)",
        "w": "sat16(w+RSH(err*x,7+SHIFT))",
        "note": "F2R3 instantiates frozen F2R2 SGD; same Master symmetric law; dw0=+5 on +3,x0=50",
    }
    out = Path(__file__).with_name("oracle.json")
    out.write_text(json.dumps(cases, indent=2), encoding="utf-8")
    print(out)
    for k, c in cases.items():
        if isinstance(c, dict) and "dw" in c:
            nz = [(i, d) for i, d in enumerate(c["dw"]) if d]
            print(k, "v", c["v"], "err", c["err"], "nz_dw", nz)


if __name__ == "__main__":
    main()
