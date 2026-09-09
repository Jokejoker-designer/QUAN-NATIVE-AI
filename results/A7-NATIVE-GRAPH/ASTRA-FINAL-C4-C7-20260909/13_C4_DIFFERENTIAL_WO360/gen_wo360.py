#!/usr/bin/env python3
"""WO360 IntegerModel golden for D32 XSim. PROGRAM=NO. Not C4_MASTER."""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from quantize_c4_parity import IntegerModel, load_model

CKPT = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01\best_dev.npz")
MAN = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH"
    r"\ASTRA-FINAL-C4-C7-20260909\10_C4_MODEL_FREEZE\ptq_fcopy_w8a12\quant_manifest.json"
)
CONFIRM = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH"
    r"\ASTRA-FINAL-C4-C7-20260909\11_C4_BLIND_CONFIRM\confirm_wo360_v3.json"
)
LOCK_SHA = "f876633e6daf4ca79317bec55ef9888e12ff726e26d316ad87193eaba74b3e6a"
OUT = Path(__file__).resolve().parent


def canonical_sha(raw: dict) -> str:
    text = json.dumps({k: v for k, v in raw.items() if k != "sha256_canonical"}, indent=2, sort_keys=True)
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def fmt_ctx(s: str) -> str:
    b = list(s.encode("ascii"))
    if len(b) != 16:
        raise SystemExit(f"bad ctx len {len(b)} {s!r}")
    return ", ".join(f"8'd{x}" for x in b)


def fmt_tok(ts) -> str:
    pad = list(ts) + [0] * 8
    return ", ".join(f"8'd{int(x)}" for x in pad[:8])


def main() -> None:
    payload = json.loads(CONFIRM.read_text(encoding="utf-8"))
    live = canonical_sha(payload)
    if live != LOCK_SHA or payload.get("sha256_canonical") != LOCK_SHA:
        raise SystemExit(f"CONFIRM_SHA_DRIFT live={live} embedded={payload.get('sha256_canonical')} lock={LOCK_SHA}")
    rows = payload["rows"]
    if len(rows) != 360:
        raise SystemExit(f"expected 360 rows got {len(rows)}")
    m = load_model(CKPT)
    man = json.loads(MAN.read_text(encoding="utf-8"))
    im = IntegerModel(m, man["activation_scales"], int(man["activation_bits"]))
    cases = []
    for r in rows:
        tok = im.decode(list(r["ctx"].encode("ascii")))
        if tok[-1] != 0:
            raise SystemExit(f"no EOS {r['id']} {tok}")
        cases.append(
            dict(
                id=r["id"],
                ctx=r["ctx"],
                group=r["group"],
                kind=r["kind"],
                allowed=1,
                zero=0,
                tokens=[int(t) for t in tok],
            )
        )
    n = len(cases)
    lines = [
        "`ifndef A7NG_C4D32_GOLDEN_SVH",
        "`define A7NG_C4D32_GOLDEN_SVH",
        f"localparam int A7NG_C4D32_NCASE = {n};",
        "localparam logic [7:0] A7NG_C4D32_GCTX [0:A7NG_C4D32_NCASE-1][0:15] = '{",
    ]
    for i, c in enumerate(cases):
        comma = "," if i + 1 < n else ""
        lines.append(f"  '{{{fmt_ctx(c['ctx'])}}}{comma}  // {c['id']} {c['kind']}")
    lines.append("};")
    lines.append("localparam logic [7:0] A7NG_C4D32_GTOK [0:A7NG_C4D32_NCASE-1][0:7] = '{")
    for i, c in enumerate(cases):
        comma = "," if i + 1 < n else ""
        lines.append(f"  '{{{fmt_tok(c['tokens'])}}}{comma}")
    lines.append("};")
    ns = ", ".join(str(len(c["tokens"])) for c in cases)
    al = ", ".join(str(c["allowed"]) for c in cases)
    zw = ", ".join(str(c["zero"]) for c in cases)
    lines += [
        f"localparam int A7NG_C4D32_GN [0:A7NG_C4D32_NCASE-1] = '{{{ns}}};",
        f"localparam bit A7NG_C4D32_GALLOW [0:A7NG_C4D32_NCASE-1] = '{{{al}}};",
        f"localparam bit A7NG_C4D32_GZERO [0:A7NG_C4D32_NCASE-1] = '{{{zw}}};",
        "`endif",
        "",
    ]
    (OUT / "GOLDEN.svh").write_text("\n".join(lines), encoding="ascii")
    (OUT / "GOLDEN.json").write_text(
        json.dumps(dict(confirm_sha256=live, checkpoint=str(CKPT), n=n, cases=cases), indent=2),
        encoding="utf-8",
    )
    print("WROTE", OUT / "GOLDEN.svh", "n", n, "confirm", live)


if __name__ == "__main__":
    main()
