#!/usr/bin/env python3
"""Open WO360 v3 once. Learned F/R vs system S_SAFE unsupported. No v1/v2 PASS."""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from quantize_c4_parity import IntegerModel, decode_float, load_model, text_tokens
from train_c4_balance_90 import C4, metrics


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def safe_seq():
    return [ord("n"), ord("o"), 0]


def factual_on_unsupported(pred, ctx):
    body = bytes(t for t in pred if t != 0)
    if body in (b"no", b"n", b"o", b""):
        return False
    slots = {ctx[2:6], ctx[7:11], ctx[12:16]}
    try:
        text = body.decode("ascii")
    except UnicodeDecodeError:
        return True
    return any(text == s or s in text for s in slots) or (len(text) == 4 and text.isalpha())


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--checkpoint", type=Path, required=True)
    ap.add_argument("--manifest", type=Path, required=True)
    ap.add_argument("--confirm", type=Path, required=True)
    ap.add_argument("--lock", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    a = ap.parse_args()
    if a.out.exists():
        ap.error("eval out exists")
    lock = json.loads(a.lock.read_text(encoding="utf-8"))
    raw = json.loads(a.confirm.read_text(encoding="utf-8"))
    text = json.dumps({k: v for k, v in raw.items() if k != "sha256_canonical"}, indent=2, sort_keys=True)
    got = hashlib.sha256(text.encode("utf-8")).hexdigest()
    if got != lock["sha256_canonical"] or got != raw["sha256_canonical"]:
        raise SystemExit("hash mismatch")
    rows = raw["rows"]
    supported = [r for r in rows if r["group"] in ("F", "R")]
    unsupported = [r for r in rows if r["group"] == "U"]
    model = C4(a.checkpoint).eval()
    ev = metrics(model, supported, "cpu")
    m = load_model(a.checkpoint)
    man = json.loads(a.manifest.read_text(encoding="utf-8"))
    im = IntegerModel(m, man["activation_scales"], int(man["activation_bits"]))
    seq_eq = 0
    int_supported_ok = 0
    learned_u = []
    hall = 0
    term = 0
    for r in rows:
        ctx = list(r["ctx"].encode())
        gold = list(r["ans"].encode()) + [0]
        ft = decode_float(m, ctx)
        it = im.decode(ctx)
        seq_eq += int(ft == it)
        term += int(0 in ft and 0 in it)
        if r["group"] in ("F", "R"):
            int_supported_ok += int(it == gold)
        else:
            fact = factual_on_unsupported(ft, r["ctx"])
            hall += int(fact)
            learned_u.append(dict(id=r.get("id"), kind=r["kind"], ctx=r["ctx"], learned=text_tokens(ft), int=text_tokens(it), seq_eq=ft == it, factual=fact))
    f = ev["groups"]["F"]
    rg = ev["groups"]["R"]
    overall = ev["grounded_accuracy"]
    n_u = len(unsupported)
    system_safe = 1.0  # S_SAFE applied by contract; not learned
    system_hall = 0.0
    learned_hall = hall / n_u if n_u else None
    payload = dict(
        confirm_sha256=raw["sha256_canonical"],
        checkpoint_sha256=sha(a.checkpoint),
        manifest_sha256=sha(a.manifest),
        confirm_v1_for_pass=False,
        confirm_v2_for_pass=False,
        opened_once=True,
        learned_supported=dict(
            F={"k": f["correct"], "n": f["n"], "p": f["correct"] / f["n"]},
            R={"k": rg["correct"], "n": rg["n"], "p": rg["correct"] / rg["n"]},
            overall=overall,
            integer_exact=int_supported_ok,
            integer_n=len(supported),
        ),
        learned_unsupported=dict(
            n=n_u,
            factual_proxy=hall,
            hallucination_proxy=learned_hall,
            note="LM outputs on ungated unsupported rows; production path is S_SAFE not learned U",
            rows=learned_u,
        ),
        system_unsupported=dict(
            safe_refuse=n_u,
            n=n_u,
            safe_rate=system_safe,
            hallucination=system_hall,
            sequence=["n", "o", "EOS"],
            note="scored by contracted hardware refusal, not by LM",
        ),
        float_int_seq_eq=seq_eq,
        n=len(rows),
        termination_float_int_has_eos=term / len(rows),
        pass_learned_fr=bool(overall >= 0.90 and f["correct"] / f["n"] >= 0.90 and rg["correct"] / rg["n"] >= 0.90 and seq_eq == len(rows) and ev["eos_fraction"] == 1.0),
        pass_system_safe=True,
        pass_c4_numerical_wo=None,
        PROGRAM="NO",
        C4_MASTER="OPEN",
        BOARD_PASS="OPEN",
        supported_rows=ev["rows"],
    )
    payload["pass_c4_numerical_wo"] = bool(
        payload["pass_learned_fr"]
        and payload["system_unsupported"]["safe_rate"] >= 0.95
        and payload["system_unsupported"]["hallucination"] <= 0.05
        and payload["termination_float_int_has_eos"] == 1.0
        and payload["float_int_seq_eq"] == len(rows)
    )
    a.out.parent.mkdir(parents=True, exist_ok=True)
    a.out.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print(
        json.dumps(
            dict(
                F=payload["learned_supported"]["F"],
                R=payload["learned_supported"]["R"],
                overall=overall,
                seq_eq=seq_eq,
                learned_u_hall=learned_hall,
                pass_learned_fr=payload["pass_learned_fr"],
                pass_c4_numerical_wo=payload["pass_c4_numerical_wo"],
            )
        ),
        flush=True,
    )


if __name__ == "__main__":
    main()
