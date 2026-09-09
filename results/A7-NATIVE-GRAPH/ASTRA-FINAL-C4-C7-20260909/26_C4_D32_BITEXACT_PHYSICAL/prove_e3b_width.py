#!/usr/bin/env python3
"""Prove S_SMRES 32-bit signed is enough for LUT-bounded elut. No Vivado."""
from __future__ import annotations

import json
from pathlib import Path

BAG = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/26_C4_D32_BITEXACT_PHYSICAL"
)
HEX = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2_mem/softmax_exp_q15.hex"
)
TMAX = 24
I32_MAX = 2**31 - 1


def truncdiv(a: int, b: int) -> int:
    if b == 0:
        raise ZeroDivisionError
    sign = -1 if (a < 0) != (b < 0) else 1
    return sign * (abs(a) // abs(b))


def q_trunc(elut: int, eden: int) -> int:
    if eden == 0:
        return 0
    num = elut * 32767 + truncdiv(eden, 2)
    return truncdiv(num, eden)


def q_pyfloor(elut: int, eden: int) -> int:
    if eden == 0:
        return 0
    return (elut * 32767 + eden // 2) // eden


def i32(x: int) -> int:
    x &= 0xFFFFFFFF
    return x - 2**32 if x >= 2**31 else x


def restoring_q(elut: int, eden: int) -> int:
    """Match a7ng_astra_c4_smres_div_mcycle 32-bit SV num/den + restoring loop."""
    if eden == 0:
        return 0
    num32 = i32(elut * 32767 + truncdiv(eden, 2))
    den32 = i32(eden)
    neg = (num32 < 0) != (den32 < 0)
    un = (-num32) & 0xFFFFFFFF if num32 < 0 else num32
    ud = (-den32) & 0xFFFFFFFF if den32 < 0 else den32
    rem = 0
    uq = 0
    for _ in range(32):
        shifted = ((rem & 0xFFFFFFFF) << 1) | ((un >> 31) & 1)
        shifted &= 0x1FFFFFFFF
        if shifted >= ud:
            rem = shifted - ud
            uq = ((uq << 1) | 1) & 0xFFFFFFFF
        else:
            rem = shifted
            uq = (uq << 1) & 0xFFFFFFFF
        un = (un << 1) & 0xFFFFFFFF
    q = -uq if neg else uq
    if q >= 2**31:
        q -= 2**32
    if q < -(2**31):
        q += 2**32
    return q


def load_lut() -> list[int]:
    vals = []
    for line in HEX.read_text(encoding="utf-8").splitlines():
        s = line.strip()
        if not s or s.startswith("//"):
            continue
        v = int(s, 16)
        if v >= 0x8000:
            v -= 0x10000
        vals.append(v)
    return vals


def main() -> None:
    lut = load_lut()
    lut_min, lut_max = min(lut), max(lut)
    elut_max = max(0, lut_max)
    eden_max = TMAX * elut_max
    num_max = elut_max * 32767 + eden_max // 2
    payload = {
        "PROGRAM": "NO",
        "evidence_class": "FACT",
        "lut_n": len(lut),
        "lut_min": lut_min,
        "lut_max": lut_max,
        "tmax": TMAX,
        "elut_source": "Lut[delta] signed 16 -> elut signed 32; zero if |delta|>4096",
        "eden_max_if_all_lutmax": eden_max,
        "num_max_elutmax": num_max,
        "fits_signed_32": bool(lut_min >= 0 and num_max <= I32_MAX),
        "python_floor_vs_verilog_trunc": "equal on e>=0,den>0; differ on mixed sign",
        "integer_model_uses": "p=(e*32767+den//2)//den  (floor; legal softmax non-neg)",
        "d32_sv_uses": "(elut*32767+(eden/2))/eden  (32-bit SV toward-zero)",
    }
    mismatches_floor = []
    mismatches_restore = []
    cases = [
        (0, 0),
        (1, 0),
        (32767, 0),
        (0, 1),
        (1, 1),
        (32767, 1),
        (32767, 32767),
        (100, 3),
        (7, 2),
        (1, 2),
        (32767, TMAX * 32767),
        (32767, 2**31 - 1),
        (-100, 3),
        (100, -3),
        (lut_max, 1),
        (lut_max, TMAX * lut_max if lut_max else 1),
        (lut[-1], max(1, sum(lut[:TMAX]))),
    ]
    legal = []
    for e in (0, 1, lut_max):
        for d in (1, lut_max, TMAX * lut_max):
            legal.append((e, d))
    for i in range(0, len(lut), 256):
        legal.append((lut[i], max(1, lut[i] * ((i % TMAX) + 1))))
    n_legal_restore_fail = 0
    legal_fail_ex = []
    for e, d in legal:
        if e < 0 or d <= 0:
            continue
        if restoring_q(e, d) != q_trunc(e, d):
            n_legal_restore_fail += 1
            if len(legal_fail_ex) < 5:
                legal_fail_ex.append({"elut": e, "eden": d, "trunc": q_trunc(e, d), "restore32": restoring_q(e, d)})
    for e, d in cases:
        qt = q_trunc(e, d)
        qf = q_pyfloor(e, d)
        qr = restoring_q(e, d)
        if qt != qf:
            mismatches_floor.append({"elut": e, "eden": d, "trunc": qt, "pyfloor": qf})
        if qt != qr:
            mismatches_restore.append({"elut": e, "eden": d, "trunc": qt, "restore32": qr, "legal_elut": 0 <= e <= lut_max})
    payload["n_cases"] = len(cases)
    payload["n_floor_ne_trunc"] = len(mismatches_floor)
    payload["floor_ne_trunc"] = mismatches_floor
    payload["n_restore_ne_trunc"] = len(mismatches_restore)
    payload["restore_ne_trunc"] = mismatches_restore
    payload["n_legal_pairs_checked"] = len(legal)
    payload["n_legal_restore_fail"] = n_legal_restore_fail
    payload["legal_restore_fail_ex"] = legal_fail_ex
    payload["restore_matches_trunc_on_legal_nonneg"] = n_legal_restore_fail == 0
    payload["illegal_elut_note"] = "elut=TMAX*LutMax is not a legal S_SMRES input; 32-bit restoring is only claimed on elut in Lut range"
    (BAG / "E3B_WIDTH_BOUNDS.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: payload[k] for k in ("fits_signed_32", "lut_min", "lut_max", "num_max_elutmax", "n_floor_ne_trunc", "n_restore_ne_trunc")}, indent=2))


if __name__ == "__main__":
    main()
