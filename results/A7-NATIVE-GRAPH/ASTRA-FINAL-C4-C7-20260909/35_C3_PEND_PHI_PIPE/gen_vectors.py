#!/usr/bin/env python3
"""Host twin of C3 S_PICK c_best_* (c3_pend_phi). Integer KEEP. PROGRAM=NO."""
from __future__ import annotations

from pathlib import Path

BAG = Path(__file__).resolve().parent
NEG = -32768
P_INF = 0xFFFFF


def pick(np: int, pv: list[int], pp0: list[int], pp1: list[int], pans: list[int]) -> dict:
    c_best_v = NEG
    c_second_v = NEG
    c_best_a = 0
    c_best_p0 = P_INF
    c_best_p1 = P_INF
    c_best_idx = 0
    for k in range(4):
        if k < np:
            better = (
                (pv[k] > c_best_v)
                or ((pv[k] == c_best_v) and (pp0[k] < c_best_p0))
                or ((pv[k] == c_best_v) and (pp0[k] == c_best_p0) and (pp1[k] < c_best_p1))
            )
            if better:
                c_second_v = c_best_v
                c_best_v = pv[k]
                c_best_a = pans[k]
                c_best_p0 = pp0[k]
                c_best_p1 = pp1[k]
                c_best_idx = k
            elif pv[k] >= c_second_v:
                c_second_v = pv[k]
    return {
        "idx": c_best_idx,
        "a": c_best_a,
        "p0": c_best_p0,
        "p1": c_best_p1,
        "v": c_best_v,
        "v2": c_second_v,
    }


def phis_slot(slot: int) -> list[int]:
    out = []
    for i in range(32):
        v = ((slot + 1) * 17 + i) % 127 - 63
        out.append(int(v))
    return out


def main() -> int:
    cases = []
    # np=1
    cases.append({"np": 1, "pv": [100, 0, 0, 0], "pp0": [9, 0, 0, 0], "pp1": [8, 0, 0, 0], "pans": [11, 0, 0, 0], "src": [10, 0, 0, 0], "dst": [11, 0, 0, 0]})
    # higher pv wins
    cases.append({"np": 2, "pv": [50, 80, 0, 0], "pp0": [1, 9, 0, 0], "pp1": [2, 9, 0, 0], "pans": [10, 11, 0, 0], "src": [1, 2, 0, 0], "dst": [10, 11, 0, 0]})
    # pv tie → smaller pp0
    cases.append({"np": 2, "pv": [70, 70, 0, 0], "pp0": [5, 3, 0, 0], "pp1": [9, 1, 0, 0], "pans": [10, 11, 0, 0], "src": [1, 2, 0, 0], "dst": [10, 11, 0, 0]})
    # pv+pp0 tie → smaller pp1
    cases.append({"np": 2, "pv": [70, 70, 0, 0], "pp0": [4, 4, 0, 0], "pp1": [8, 2, 0, 0], "pans": [10, 11, 0, 0], "src": [1, 2, 0, 0], "dst": [10, 11, 0, 0]})
    # np=4 mixed
    cases.append({"np": 4, "pv": [10, 40, 40, 20], "pp0": [9, 7, 6, 1], "pp1": [1, 9, 8, 1], "pans": [1, 2, 3, 4], "src": [10, 20, 30, 40], "dst": [11, 21, 31, 41]})

    lines = ["// expected.svh — c3_pend_phi twin. PROGRAM=NO.", "`ifndef ASTRA_C3_PEND_PHI_EXP", "`define ASTRA_C3_PEND_PHI_EXP"]
    lines.append(f"localparam int N_VEC = {len(cases)};")
    lines.append("localparam int ST_PICK = 9;")
    lines.append("localparam int ST_HOLD = 10;")
    lines.append("localparam int ST_COMMIT = 12;")
    lines.append("localparam int ST_CMP = 13;")
    lines.append("localparam logic signed [15:0] EXP_PV [0:N_VEC-1][0:3] = '{")
    for c in cases:
        lines.append("  '{" + ", ".join(str(x) for x in c["pv"]) + "},")
    lines[-1] = lines[-1].rstrip(",")
    lines.append("};")
    for name, key, w in [("EXP_PP0", "pp0", 20), ("EXP_PP1", "pp1", 20), ("EXP_PANS", "pans", 20), ("EXP_SRC", "src", 20), ("EXP_DST", "dst", 20)]:
        lines.append(f"localparam logic [{w-1}:0] {name} [0:N_VEC-1][0:3] = '{{")
        for c in cases:
            lines.append("  '{" + ", ".join(str(x) for x in c[key]) + "},")
        lines[-1] = lines[-1].rstrip(",")
        lines.append("};")
    lines.append("localparam logic [4:0] EXP_NP [0:N_VEC-1] = '{")
    lines.append("  " + ", ".join(str(c["np"]) for c in cases))
    lines.append("};")

    idxs = []
    aa = []
    p0s = []
    p1s = []
    vs = []
    v2s = []
    srcs = []
    dsts = []
    phis = []
    for c in cases:
        w = pick(c["np"], c["pv"], c["pp0"], c["pp1"], c["pans"])
        idxs.append(w["idx"])
        aa.append(w["a"])
        p0s.append(w["p0"])
        p1s.append(w["p1"])
        vs.append(w["v"])
        v2s.append(w["v2"])
        srcs.append(c["src"][w["idx"]])
        dsts.append(c["dst"][w["idx"]])
        slot_phi = [phis_slot(s) for s in range(4)]
        phis.append(slot_phi)

    if idxs != [0, 1, 1, 1, 2]:
        raise SystemExit(f"TWIN_IDX {idxs}")
    if vs != [100, 80, 70, 70, 40]:
        raise SystemExit(f"TWIN_VB {vs}")

    def arr_1d(name: str, vals: list[int], width: str) -> None:
        lines.append(f"localparam {width} {name} [0:N_VEC-1] = '{{")
        lines.append("  " + ", ".join(str(x) for x in vals))
        lines.append("};")

    arr_1d("EXP_IDX", idxs, "logic [1:0]")
    arr_1d("EXP_A", aa, "logic [19:0]")
    arr_1d("EXP_P0", p0s, "logic [19:0]")
    arr_1d("EXP_P1", p1s, "logic [19:0]")
    arr_1d("EXP_VB", vs, "logic signed [15:0]")
    arr_1d("EXP_V2", v2s, "logic signed [15:0]")
    arr_1d("EXP_SRC_W", srcs, "logic [19:0]")
    arr_1d("EXP_DST_W", dsts, "logic [19:0]")

    lines.append("localparam logic signed [7:0] EXP_PHIS [0:N_VEC-1][0:3][0:31] = '{")
    for vi, slot_phi in enumerate(phis):
        lines.append("  '{")
        for s in range(4):
            inner = ", ".join(str(x) for x in slot_phi[s])
            comma = "," if s < 3 else ""
            lines.append(f"    '{{{inner}}}{comma}")
        lines.append("  }" + ("," if vi < len(phis) - 1 else ""))
    lines.append("};")
    lines.append("localparam logic signed [7:0] EXP_PHI_WIN [0:N_VEC-1][0:31] = '{")
    for vi, slot_phi in enumerate(phis):
        inner = ", ".join(str(x) for x in slot_phi[idxs[vi]])
        comma = "," if vi < len(phis) - 1 else ""
        lines.append(f"  '{{{inner}}}{comma}")
    lines.append("};")
    lines.append("`endif")
    (BAG / "expected.svh").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
