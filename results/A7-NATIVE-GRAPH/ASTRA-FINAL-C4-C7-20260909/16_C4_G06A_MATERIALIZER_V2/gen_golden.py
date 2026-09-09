#!/usr/bin/env python3
"""G06-A: independent Python golden for proof → V2 context. No C4 decode."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

OUT = Path(__file__).resolve().parent
PAD = "----"
DICT = {1: "drum", 2: "hose", 3: "bolt", 4: "vent"}


def pack(s: str) -> int:
    b = s.encode("ascii")
    if len(b) != 4:
        raise SystemExit(s)
    return b[0] | (b[1] << 8) | (b[2] << 16) | (b[3] << 24)


def lookup(i: int) -> tuple[str, bool]:
    if i not in DICT:
        return "????", True
    return DICT[i], False


def materialize(bank_r: bool, src_id: int, dst_id: int) -> dict:
    src, src_ovf = lookup(src_id)
    dst, dst_ovf = lookup(dst_id)
    ovf = src_ovf or dst_ovf
    op = "R" if bank_r else "F"
    text = f"{op} {src} {dst}>{PAD}"
    if len(text) != 16:
        raise SystemExit(text)
    return dict(
        bank_r=int(bank_r),
        src_id=src_id,
        dst_id=dst_id,
        ovf=int(ovf),
        valid=int(not ovf),
        ctx=[int(x) for x in text.encode("ascii")],
        text=text,
    )


def main() -> None:
    cases = [
        materialize(False, 1, 2),  # F drum hose
        materialize(True, 1, 2),   # R drum hose
        materialize(True, 3, 2),   # R bolt hose
        materialize(True, 4, 2),   # R vent hose
        materialize(False, 1, 2),  # direction pair with case 0
        materialize(False, 9, 2),  # src miss overflow
    ]
    # Independent invariants in the golden itself.
    f, r = cases[0], cases[1]
    if f["ctx"][1:] != r["ctx"][1:] or f["ctx"][0] == r["ctx"][0]:
        raise SystemExit("golden invariance broken")
    if f["text"][2:6] != "drum" or f["text"][7:11] != "hose" or f["text"][12:16] != PAD:
        raise SystemExit("golden layout broken")
    payload = dict(
        schema="C4_MATERIALIZER_V2_G06A_GOLDEN",
        dict={str(k): v for k, v in DICT.items()},
        pad=PAD,
        n=len(cases),
        cases=cases,
        notes="G06-A only. No C4 tokens. No Confirm rows.",
    )
    text = json.dumps({k: v for k, v in payload.items() if k != "sha256_canonical"}, indent=2, sort_keys=True)
    digest = hashlib.sha256(text.encode("utf-8")).hexdigest()
    payload["sha256_canonical"] = digest
    (OUT / "GOLDEN.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    n = len(cases)
    lines = [
        "`ifndef A7NG_C4_MAT2_GOLDEN_SVH",
        "`define A7NG_C4_MAT2_GOLDEN_SVH",
        f"localparam int A7NG_C4_MAT2_N = {n};",
        "localparam logic A7NG_C4_MAT2_R [0:A7NG_C4_MAT2_N-1] = '{" + ", ".join(str(c["bank_r"]) for c in cases) + "};",
        "localparam logic [7:0] A7NG_C4_MAT2_SID [0:A7NG_C4_MAT2_N-1] = '{"
        + ", ".join(f"8'd{c['src_id']}" for c in cases)
        + "};",
        "localparam logic [7:0] A7NG_C4_MAT2_DID [0:A7NG_C4_MAT2_N-1] = '{"
        + ", ".join(f"8'd{c['dst_id']}" for c in cases)
        + "};",
        "localparam logic [7:0] A7NG_C4_MAT2_CTX [0:A7NG_C4_MAT2_N-1][0:15] = '{",
    ]
    for i, c in enumerate(cases):
        comma = "," if i + 1 < n else ""
        inner = ", ".join(f"8'd{x}" for x in c["ctx"])
        lines.append(f"  '{{{inner}}}{comma}  // {c['text']}")
    lines += [ "};", "`endif", "" ]
    (OUT / "GOLDEN.svh").write_text("\n".join(lines), encoding="ascii")
    print("WROTE G06-A golden", digest)


if __name__ == "__main__":
    main()
