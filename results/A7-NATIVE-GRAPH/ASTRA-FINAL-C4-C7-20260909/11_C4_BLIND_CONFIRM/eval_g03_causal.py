#!/usr/bin/env python3
"""G03 learned-C4 causal ablations. Gate held ANSWER. Confirm 360 not retuned."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

import torch

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from train_c4_balance_90 import C4, historic_rows, metrics, entities
from train_c4_f_copy_balanced import collect_reserved, load_rows_json, word_at, ALPHABET

CKPT = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01\best_dev.npz")
V3 = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-FINAL-C4-C7-20260909\11_C4_BLIND_CONFIRM\confirm_wo360_v3.json")
OUT = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-FINAL-C4-C7-20260909\11_C4_BLIND_CONFIRM\g03_causal.json")


def acc_fr(ev):
    f, r = ev["groups"]["F"], ev["groups"]["R"]
    n = f["n"] + r["n"]
    k = f["correct"] + r["correct"]
    return dict(k=k, n=n, p=(k / n if n else None), F=f, R=r)


def main():
    reserved = collect_reserved()
    reserved |= entities(json.loads(V3.read_text(encoding="utf-8"))["rows"])
    rng = random.Random(403)
    probe = historic_rows()
    probe = [r for r in probe if r["group"] in ("F", "R")]
    # 32 extra F/R not in confirm/train
    extra = []
    while len(extra) < 32:
        src = "".join(rng.choice(ALPHABET) for _ in range(4))
        dst = "".join(rng.choice(ALPHABET) for _ in range(4))
        if src == dst or src in reserved or dst in reserved:
            continue
        reserved.update((src, dst))
        extra.append(dict(ctx=f"F {dst} {src}>{dst}", ans=src, group="F"))
        extra.append(dict(ctx=f"R {src} {src}>{dst}", ans=dst, group="R"))
        extra = extra[:32]
    rows = probe + extra
    model = C4(CKPT).eval()
    normal = acc_fr(metrics(model, rows, "cpu"))
    zero = C4(CKPT).eval()
    with torch.no_grad():
        zero.We.zero_()
    z = acc_fr(metrics(zero, rows, "cpu"))
    corrupt = C4(CKPT).eval()
    with torch.no_grad():
        corrupt.Wq.add_(4.0)
        corrupt.WqR.add_(-4.0)
    c = acc_fr(metrics(corrupt, rows, "cpu"))
    # Decisive evidence replaced: change copy source (slot B) on F rows.
    replaced = []
    toward = []
    for r in rows:
        if r["group"] != "F":
            continue
        old = r["ctx"][7:11]
        new = old[1:] + old[0]
        if new == old:
            new = old[::-1]
        ctx = r["ctx"][:7] + new + r["ctx"][11:]
        replaced.append(dict(ctx=ctx, ans=r["ans"], group="F"))  # old gold must fail
        toward.append(dict(ctx=ctx, ans=new, group="F"))  # new gold must hit
    rep_old = acc_fr(metrics(model, replaced, "cpu")) if replaced else None
    rep_new = acc_fr(metrics(model, toward, "cpu")) if toward else None
    # wrong bank: swap opcode F<->R on same bytes illegally
    wrong = []
    for r in rows:
        if r["group"] == "F":
            ctx = "R" + r["ctx"][1:]
            wrong.append(dict(ctx=ctx, ans=r["ans"], group="F"))
        else:
            ctx = "F" + r["ctx"][1:]
            wrong.append(dict(ctx=ctx, ans=r["ans"], group="R"))
    wb = acc_fr(metrics(model, wrong, "cpu"))
    drop_z = normal["p"] - z["p"]
    drop_c = normal["p"] - c["p"]
    payload = dict(
        checkpoint_sha256=hashlib.sha256(CKPT.read_bytes()).hexdigest(),
        n=len(rows),
        prereg_min_drop=0.20,
        normal=normal,
        zero_We=z,
        corrupt_Wq=c,
        evidence_replaced_old_gold=rep_old,
        evidence_replaced_new_gold=rep_new,
        wrong_bank=wb,
        zero_drop=drop_z,
        corrupt_drop=drop_c,
        zero_pass=drop_z >= 0.20,
        corrupt_pass=drop_c >= 0.20,
        replaced_old_fails=rep_old["p"] < 0.5 if rep_old else None,
        replaced_new_hits=rep_new["p"] >= 0.9 if rep_new else None,
        wrong_bank_changes=wb["p"] < normal["p"],
        confirm_360_not_used_for_tuning=True,
        C4_MASTER="OPEN",
        PROGRAM="NO",
        note="Safety-gate S_SAFE is G05; this file is learned path with gate held ANSWER.",
    )
    OUT.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print(json.dumps({k: payload[k] for k in ("normal", "zero_drop", "corrupt_drop", "replaced_old_fails", "replaced_new_hits", "wrong_bank_changes")}, indent=2))


if __name__ == "__main__":
    main()
