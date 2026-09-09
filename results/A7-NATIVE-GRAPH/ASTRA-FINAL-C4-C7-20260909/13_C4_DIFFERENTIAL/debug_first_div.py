#!/usr/bin/env python3
"""G04 FIRST_DIVERGENCE: IntegerModel traces vs hex vs sequential MAC."""
from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from quantize_c4_parity import IntegerModel, load_model, rshift

CKPT = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01\best_dev.npz")
MAN = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH"
    r"\ASTRA-FINAL-C4-C7-20260909\10_C4_MODEL_FREEZE\ptq_fcopy_w8a12\quant_manifest.json"
)
HEX = Path(
    r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\rtl\native_graph\integrate"
    r"\a7ng_astra_c4_lm06_d32_fr_v1_mem"
)
CTX = list(b"F drum hose>drum")


def load_hex_i8(name: str, n: int) -> np.ndarray:
    lines = [ln.strip() for ln in (HEX / name).read_text(encoding="ascii").splitlines() if ln.strip()]
    vals = np.array([int(v, 16) if int(v, 16) < 128 else int(v, 16) - 256 for v in lines], dtype=np.int64)
    if vals.size != n:
        raise SystemExit(f"{name} count {vals.size} expected {n}")
    return vals


def main() -> None:
    m = load_model(CKPT)
    man = json.loads(MAN.read_text(encoding="utf-8"))
    im = IntegerModel(m, man["activation_scales"], int(man["activation_bits"]))
    toks = CTX + [0]
    il, tr = im.forward(toks, CTX)
    top = [int(i) for i in np.argsort(-il)[:12]]
    print("INT_DECODE", im.decode(CTX))
    print("INT_ARGMAX", int(il.argmax()), "chr", chr(int(il.argmax())))
    print("INT_LOGIT_g_h_o_s_e", int(il[103]), int(il[104]), int(il[111]), int(il[115]), int(il[101]))
    print("INT_TOP", [(i, chr(i) if 32 <= i < 127 else i, int(il[i])) for i in top])
    print("INT_X0", [int(v) for v in tr["x"][0, :8]])
    print("INT_X7", [int(v) for v in tr["x"][7, :8]])
    print("INT_X16", [int(v) for v in tr["x"][16, :8]])
    print("INT_Q", [int(v) for v in tr["q"][:8]])
    print("INT_DOTS0_7_16", int(tr["dots"][0]), int(tr["dots"][7]), int(tr["dots"][16]))
    print("INT_ATTN7", int(tr["a"][7]))
    print("INT_WE_h0", int(im.w["We"][104, 0]), "WE_0", int(im.w["We"][0, 0]), "WE_F0", int(im.w["We"][70, 0]))
    we_hex = load_hex_i8("We.hex", 256 * 32)
    print("HEX_WE_h0", int(we_hex[104 * 32]), "HEX_WE_0", int(we_hex[0]), "HEX_WE_F0", int(we_hex[70 * 32]))
    print("HEX_MATCH_We", bool(np.array_equal(we_hex, im.w["We"].ravel())))
    # sequential MAC vs vector mm for q
    w = im.w
    x = tr["x"]
    accs = []
    for j in range(32):
        acc = 0
        for i in range(32):
            acc += int(w["Wq"][j, i]) * int(x[-1, i])
        accs.append(acc)
    mm = np.array(accs, np.int64)
    ref = w["Wq"] @ x[-1]
    print("SEQ_Q_MAC_MATCH", bool(np.array_equal(mm, ref)), "maxabs", int(np.max(np.abs(mm - ref))))
    ops = im.ops
    qseq = np.clip(rshift(mm * ops["q"][0], ops["q"][1]), -2047, 2047)
    print("SEQ_Q_MATCH", bool(np.array_equal(qseq, tr["q"])), "maxabs", int(np.max(np.abs(qseq - tr["q"]))))
    # 8-bit index hypothesis
    idx8 = np.array([((t * 32) & 0xFF) for t in toks], dtype=np.int64)
    print("IDX8_toks", [(t, chr(t) if 32 <= t < 127 else t, int(idx8[i])) for i, t in enumerate(toks)])


if __name__ == "__main__":
    main()
