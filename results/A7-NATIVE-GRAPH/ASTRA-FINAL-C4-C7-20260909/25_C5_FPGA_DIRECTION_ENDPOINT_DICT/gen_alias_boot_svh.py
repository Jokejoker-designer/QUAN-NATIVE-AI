#!/usr/bin/env python3
"""Emit alias boot SVH from ENTITY_ALIAS_PROD_V1.json. PROGRAM=NO. No XSim."""
from __future__ import annotations

import binascii
import hashlib
import json
from pathlib import Path

BAG = Path(__file__).resolve().parent
ROOT = BAG.parents[3]
IMG = BAG / "ENTITY_ALIAS_PROD_V1.json"
SVH = ROOT / "rtl/native_graph/integrate/a7ng_astra_c6_alias_boot_v1.svh"


def main() -> int:
    doc = json.loads(IMG.read_text(encoding="utf-8"))
    n = int(doc["n"])
    keys = [0] * n
    syms = [0] * n
    valid = [0] * n
    ovf = [0] * n
    for row in doc["rows"]:
        i = int(row["idx"])
        keys[i] = int(row["key_u20"])
        syms[i] = int(row["sym_u32"], 16)
        valid[i] = 1 if row["valid"] else 0
        ovf[i] = 1 if row["ovf"] else 0
    blob = bytearray()
    for i in range(n):
        blob += keys[i].to_bytes(4, "little")
        blob += syms[i].to_bytes(4, "little")
        blob += bytes([valid[i], ovf[i], 0, 0])
    crc = binascii.crc32(blob) & 0xFFFFFFFF
    sha = hashlib.sha256(IMG.read_bytes()).hexdigest()
    lines = [
        "`ifndef A7NG_ASTRA_C6_ALIAS_BOOT_V1_SVH",
        "`define A7NG_ASTRA_C6_ALIAS_BOOT_V1_SVH",
        "// Generated. PROGRAM=NO. Do not hand-edit; run gen_alias_boot_svh.py.",
        f"localparam int unsigned A7NG_C6_ALIAS_N = {n};",
        f"localparam logic [31:0] A7NG_C6_ALIAS_CRC32 = 32'h{crc:08x};",
        f"localparam logic [19:0] A7NG_C6_ALIAS_KEY [0:A7NG_C6_ALIAS_N-1] = '{{",
        ", ".join(f"20'h{k:05x}" for k in keys) + "};",
        f"localparam logic [31:0] A7NG_C6_ALIAS_SYM [0:A7NG_C6_ALIAS_N-1] = '{{",
        ", ".join(f"32'h{s:08x}" for s in syms) + "};",
        f"localparam logic A7NG_C6_ALIAS_VALID [0:A7NG_C6_ALIAS_N-1] = '{{",
        ", ".join(f"1'b{v}" for v in valid) + "};",
        f"localparam logic A7NG_C6_ALIAS_OVF [0:A7NG_C6_ALIAS_N-1] = '{{",
        ", ".join(f"1'b{v}" for v in ovf) + "};",
        f"// image_sha256 {sha}",
        "`endif",
        "",
    ]
    SVH.write_text("\n".join(lines), encoding="utf-8")
    meta = {
        "PROGRAM": "NO",
        "crc32": f"{crc:08x}",
        "image_sha256": sha,
        "svh": str(SVH.relative_to(ROOT)).replace("\\", "/"),
    }
    (BAG / "ENTITY_ALIAS_PROD_V1_HASH.json").write_text(json.dumps(meta, indent=2) + "\n", encoding="utf-8")
    print("E1C_SVH", sha, f"crc={crc:08x}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
