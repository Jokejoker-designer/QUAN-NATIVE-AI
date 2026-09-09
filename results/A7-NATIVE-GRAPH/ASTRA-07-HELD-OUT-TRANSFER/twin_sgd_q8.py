#!/usr/bin/env python3
"""Bit-exact host twin of rtl/native_graph/learn/a7ng_shared_rank_sgd_q8.sv

Law: native-rank-sgd-q8-v1. SHIFT=6. PROGRAM=NO.
Matches RTL RSH (symmetric round-half-away-from-zero on abs), sat16,
v clamp vs (768<<7) before RSH, sequential MAC i=0..N-1.
"""
from __future__ import annotations

N_FEAT = 32
SHIFT_DEFAULT = 6
V_LIM = 768


def rsh40(v: int, s: int) -> int:
    """RTL rsh40: sign(v)*floor((abs(v)+2^(s-1))/2^s)."""
    if s <= 0:
        raise ValueError("rsh40 shift must be >0")
    if v == 0:
        return 0
    a = -v if v < 0 else v
    a = (a + (1 << (s - 1))) >> s
    return -a if v < 0 else a


def sat16(v: int) -> int:
    if v > 32767:
        return 32767
    if v < -32768:
        return -32768
    return int(v)


class SharedRankSgdQ8:
    def __init__(self, n: int = N_FEAT, shift: int = SHIFT_DEFAULT) -> None:
        self.n = n
        self.shift = shift
        self.w = [0] * n

    def reset(self) -> None:
        self.w = [0] * self.n

    def copy_w(self) -> list[int]:
        return list(self.w)

    def load_w(self, w: list[int]) -> None:
        if len(w) != self.n:
            raise ValueError("w length")
        self.w = [sat16(int(x)) for x in w]

    def acc_raw(self, x: list[int]) -> int:
        acc = 0
        for i in range(self.n):
            acc += int(self.w[i]) * int(x[i])
        return acc

    def score(self, x: list[int]) -> int:
        if len(x) != self.n:
            raise ValueError("x length")
        acc = self.acc_raw(x)
        lim = V_LIM << 7
        if acc > lim:
            return V_LIM
        if acc < -lim:
            return -V_LIM
        return rsh40(acc, 7)

    def update(self, x: list[int], reward: int, freeze: bool = False) -> int:
        """Score, then if not freeze: w += RSH(err * x, 7+SHIFT) sat16.

        Returns v_q8 from the pre-update score (RTL latches v then updates).
        """
        v = self.score(x)
        if freeze:
            return v
        rew = int(reward)
        if rew < -4 or rew > 3:
            raise ValueError("reward does not fit signed[2:0] as used by RTL")
        err = sat16(rew * 256 - v)
        s = 7 + self.shift
        for i in range(self.n):
            delta = rsh40(err * int(x[i]), s)
            self.w[i] = sat16(self.w[i] + delta)
        return v


def astra06_unit() -> dict:
    """Replay ASTRA-06 TB: x[i]=64, 16 updates. Expect 0 / 688 / 48."""
    x = [64] * N_FEAT
    frozen = SharedRankSgdQ8()
    v_fr = frozen.score(x)

    en = SharedRankSgdQ8()
    for _ in range(16):
        en.update(x, 3)
    v_en = en.score(x)

    sh = SharedRankSgdQ8()
    for t in range(16):
        sh.update(x, 3 if (t & 1) else -3)
    v_sh = sh.score(x)
    return {
        "v_frozen": v_fr,
        "v_enabled": v_en,
        "v_shuffle": v_sh,
        "match": (v_fr == 0 and v_en == 688 and v_sh == 48),
    }


if __name__ == "__main__":
    r = astra06_unit()
    print("ASTRA06_TWIN", r)
    if not r["match"]:
        raise SystemExit("ASTRA06_TWIN_FAIL")
    print("ASTRA06_TWIN_PASS")
