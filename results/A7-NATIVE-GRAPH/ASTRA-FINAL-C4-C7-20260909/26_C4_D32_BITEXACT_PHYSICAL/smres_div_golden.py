#!/usr/bin/env python3
"""Golden vectors for a7ng_astra_c4_smres_div_mcycle. No XSim while OOC holds license."""
from __future__ import annotations

import json
from pathlib import Path

OUT = Path(
    r"D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH/results/A7-NATIVE-GRAPH/ASTRA-FINAL-C4-C7-20260909/26_C4_D32_BITEXACT_PHYSICAL/smres_div_golden.json"
)


def truncdiv(a: int, b: int) -> int:
    if b == 0:
        raise ZeroDivisionError
    sign = -1 if (a < 0) != (b < 0) else 1
    return sign * (abs(a) // abs(b))


def q(elut: int, eden: int) -> int:
    if eden == 0:
        return 0
    num = elut * 32767 + truncdiv(eden, 2)
    return truncdiv(num, eden)


def main() -> None:
    cases = []
    for elut, eden in [
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
        (32767, 24 * 32767),  # legal envelope: one elut=LutMax, eden=TMAX*LutMax
        (32767, 2**31 - 1),
        (-100, 3),
        (100, -3),
    ]:
        cases.append({"elut": elut, "eden": eden, "q": q(elut, eden)})
    OUT.write_text(json.dumps({"law": "trunc0 (elut*32767+eden//2)/eden", "n": len(cases), "rows": cases}, indent=2) + "\n", encoding="utf-8")
    print("WROTE", OUT, "n", len(cases))


if __name__ == "__main__":
    main()
