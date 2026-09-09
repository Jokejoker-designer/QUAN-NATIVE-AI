#!/usr/bin/env python3
"""Python golden for C4_CONTEXT_CONTRACT_V1 materializer. PROGRAM=NO."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

OUT = Path(__file__).resolve().parent


def pack(s: str) -> int:
    b = s.encode("ascii")
    if len(b) != 4:
        raise SystemExit(f"need 4 ascii chars, got {s!r}")
    return b[0] | (b[1] << 8) | (b[2] << 16) | (b[3] << 24)


def materialize(bank_r: bool, src: str, dest: str, src_ovf: bool, dest_ovf: bool) -> dict:
    src_u = "????" if src_ovf else src
    dest_u = "????" if dest_ovf else dest
    if bank_r:
        text = f"R {src_u} {src_u}>{dest_u}"
    else:
        text = f"F {dest_u} {src_u}>{dest_u}"
    if len(text) != 16:
        raise SystemExit(f"layout {len(text)} {text!r}")
    return dict(
        bank_r=int(bank_r),
        src=src,
        dest=dest,
        src_ovf=int(src_ovf),
        dest_ovf=int(dest_ovf),
        src_sym=pack(src),
        dest_sym=pack(dest),
        ovf=int(src_ovf or dest_ovf),
        valid=int(not (src_ovf or dest_ovf)),
        ctx=[int(x) for x in text.encode("ascii")],
        text=text,
    )


def main() -> None:
    cases = [
        materialize(False, "hose", "drum", False, False),
        materialize(True, "hose", "drum", False, False),
        materialize(False, "vent", "drum", False, False),  # replaced src
        materialize(False, "hose", "vent", False, False),  # replaced dest
        materialize(False, "hose", "drum", True, False),
        materialize(True, "bolt", "tank", False, False),
    ]
    payload = dict(schema="C4_MATERIALIZER_GOLDEN_V1", n=len(cases), cases=cases)
    text = json.dumps(payload, indent=2, sort_keys=True)
    digest = hashlib.sha256(text.encode("utf-8")).hexdigest()
    payload["sha256_canonical"] = digest
    (OUT / "GOLDEN.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    lines = [
        "`ifndef A7NG_C4_MAT_GOLDEN_SVH",
        "`define A7NG_C4_MAT_GOLDEN_SVH",
        f"localparam int A7NG_C4_MAT_N = {len(cases)};",
        "localparam logic A7NG_C4_MAT_R [0:A7NG_C4_MAT_N-1] = '{" + ", ".join(str(c["bank_r"]) for c in cases) + "};",
        "localparam logic A7NG_C4_MAT_SO [0:A7NG_C4_MAT_N-1] = '{" + ", ".join(str(c["src_ovf"]) for c in cases) + "};",
        "localparam logic A7NG_C4_MAT_DO [0:A7NG_C4_MAT_N-1] = '{" + ", ".join(str(c["dest_ovf"]) for c in cases) + "};",
        "localparam logic [31:0] A7NG_C4_MAT_SRC [0:A7NG_C4_MAT_N-1] = '{"
        + ", ".join(f"32'h{c['src_sym']:08x}" for c in cases)
        + "};",
        "localparam logic [31:0] A7NG_C4_MAT_DST [0:A7NG_C4_MAT_N-1] = '{"
        + ", ".join(f"32'h{c['dest_sym']:08x}" for c in cases)
        + "};",
        "localparam logic [7:0] A7NG_C4_MAT_CTX [0:A7NG_C4_MAT_N-1][0:15] = '{",
    ]
    for i, c in enumerate(cases):
        comma = "," if i + 1 < len(cases) else ""
        inner = ", ".join(f"8'd{x}" for x in c["ctx"])
        lines.append(f"  '{{{inner}}}{comma}  // {c['text']}")
    lines += [ "};", "`endif", "" ]
    (OUT / "GOLDEN.svh").write_text("\n".join(lines), encoding="ascii")
    print("WROTE", OUT / "GOLDEN.svh", "sha", digest)


if __name__ == "__main__":
    main()
