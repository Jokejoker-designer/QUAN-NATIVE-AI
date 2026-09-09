#!/usr/bin/env python3
"""G06-B: frozen V1-trained IntegerModel on V2 contexts. EXPECTED_OUTCOME=UNKNOWN."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from quantize_c4_parity import IntegerModel, load_model, text_tokens

CKPT = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01\best_dev.npz")
MAN = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH"
    r"\ASTRA-FINAL-C4-C7-20260909\10_C4_MODEL_FREEZE\ptq_fcopy_w8a12\quant_manifest.json"
)
OUT = Path(__file__).resolve().parent

PREREG = [
    dict(id="C1", ctx="F drum hose>----", expected="hose"),
    dict(id="C2", ctx="R drum hose>----", expected="drum"),
    dict(id="C3a", ctx="R bolt hose>----", expected="bolt"),
    dict(id="C3b", ctx="R vent hose>----", expected="vent"),
]


def main() -> None:
    if len(PREREG[0]["ctx"]) != 16:
        raise SystemExit("ctx len")
    im = IntegerModel(load_model(CKPT), json.loads(MAN.read_text(encoding="utf-8"))["activation_scales"], 12)
    rows = []
    all_ok = True
    for spec in PREREG:
        got = text_tokens(im.decode(list(spec["ctx"].encode("ascii"))))
        ok = got == spec["expected"]
        all_ok = all_ok and ok
        rows.append(dict(**spec, got=got, match=ok))
        print(spec["id"], spec["ctx"], "got", got, "exp", spec["expected"], "match", ok)
    # Opcode intervention: C1 bytes with F→R.
    ctx_flip = "R" + PREREG[0]["ctx"][1:]
    got_flip = text_tokens(im.decode(list(ctx_flip.encode("ascii"))))
    flip_ok = got_flip == "drum" and rows[0]["got"] == "hose"
    print("OP_FLIP", ctx_flip, "got", got_flip, "flip_ok", flip_ok)
    same_fr = rows[0]["got"] == rows[1]["got"]
    if all_ok and flip_ok:
        compat = "PASS"
        first = ""
    else:
        compat = "FAIL"
        first = "V1-trained decoder depends on answer-aligned serialization"
    payload = dict(
        EXPECTED_OUTCOME="UNKNOWN",
        OLD_C4_CONTEXT_COMPATIBILITY=compat,
        FIRST_DIVERGENCE=first,
        same_FR_endpoint=same_fr,
        opcode_flip=dict(ctx=ctx_flip, got=got_flip, expected="drum", match=flip_ok),
        rows=rows,
        checkpoint=str(CKPT),
        PROGRAM="NO",
        C4_MASTER="OPEN",
        materializer_unchanged=True,
        confirm_v2_instantiated=False,
    )
    (OUT / "OLD_C4_CONTEXT_COMPATIBILITY.json").write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print("COMPAT", compat, "FIRST_DIVERGENCE", first or "NONE")


if __name__ == "__main__":
    main()
