#!/usr/bin/env python3
"""ASTRA-C4-SLOT-COPY-CAPACITY-01. PROGRAM=NO. Not C4_MASTER.
Capacity + split analysis for the two declared rivals. No third architecture.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

TRAIN_ENT = ["pump", "valv", "tank", "pipe"]
HELD_ENT = ["hose", "drum", "vent", "bolt"]


def pack16(s: str) -> str:
    if len(s.encode("ascii")) != 16:
        raise ValueError(repr(s))
    return s


def rows(ents):
    out = []
    for src in ents:
        for dst in ents:
            if src == dst:
                continue
            out.append({"op": "F", "ctx": pack16(f"F {dst} {src}>{dst}"), "ans": src, "slot0": 7})
            out.append({"op": "R", "ctx": pack16(f"R {src} {src}>{dst}"), "ans": dst, "slot0": 12})
    return out


def prefix_collisions(split):
    seen = set()
    uniq = []
    for a in split:
        for b in split:
            if a is b or a["ans"][0] != b["ans"][0] or a["slot0"] == b["slot0"]:
                continue
            if a["ans"][1:4] == b["ans"][1:4]:
                continue
            key = tuple(sorted((a["ctx"], b["ctx"])))
            if key in seen:
                continue
            seen.add(key)
            uniq.append(
                {
                    "a_ctx": a["ctx"],
                    "b_ctx": b["ctx"],
                    "a_op": a["op"],
                    "b_op": b["op"],
                    "a_ans": a["ans"],
                    "b_ans": b["ans"],
                    "first": a["ans"][0],
                }
            )
    return uniq


def main():
    bag = Path(__file__).resolve().parent
    held = rows(HELD_ENT)
    train = rows(TRAIN_ENT)
    held_names = sorted(set(r["ans"] for r in held))
    train_names = sorted(set(r["ans"] for r in train))
    held_first = sorted({n[0] for n in held_names})
    train_first = sorted({n[0] for n in train_names})
    out = {
        "bag": "ASTRA-C4-SLOT-COPY-CAPACITY-01",
        "program": "NO",
        "c4_master": False,
        "tinygpt": False,
        "third_architecture": False,
        "held_n": len(held),
        "train_n": len(train),
        "held_names": held_names,
        "train_names": train_names,
        "held_first_letters": held_first,
        "train_first_letters": train_first,
        "held_first_letters_unique": len(held_first) == len(held_names),
        "held_names_in_train": sorted(set(held_names) & set(train_names)),
        "held_prefix_collision_pairs": len(prefix_collisions(held)),
        "train_prefix_collision_pairs": len(prefix_collisions(train)),
        "train_shared_initial_example": "pump vs pipe both start with p",
        "held_miss_mode": (
            "closed_set_name_emission: held 4-grams are disjoint from train; "
            "STE D=16 greedy emitted train names (pipe) on held queries. "
            "Held first letters h,d,v,b are unique so F/R prefix-collision "
            "is 0 on this split and is NOT the held 0/20 cause."
        ),
        "rival1_law": "h'=sat8((Wxh@We[last]+Whh@h+bh)>>4); scan We[v]·h[0:E] only; no ctx reread; no ReLU on h",
        "rival2_law": "q=Wq@xs[last]; keys from window; decode does not reread by index",
        "affine_route": (
            "Opcode-dependent gather is bilinear. Fixed Whh cannot switch "
            "src-slot vs dst-slot. That binds pump/pipe continuation and any "
            "split with shared initials; it is extra to the held closed-set miss."
        ),
        "lang_90": False,
        "prior_probes_held_0": [
            "ASTRA-C4-COND-RNN-LANG-01",
            "ASTRA-C4-COND-RNN-H16-01",
            "ASTRA-C4-LM06-RED-LANG-01",
            "ASTRA-C4-LM06-RED-BPTT-01",
        ],
    }
    raw = json.dumps(out, indent=2) + "\n"
    (bag / "CAPACITY.json").write_text(raw, encoding="utf-8")
    digest = hashlib.sha256(raw.encode("utf-8")).hexdigest()
    (bag / "CAPACITY.sha256").write_text(digest + "\n", encoding="ascii")
    print(json.dumps({k: out[k] for k in (
        "held_prefix_collision_pairs",
        "train_prefix_collision_pairs",
        "held_first_letters_unique",
        "held_names_in_train",
        "lang_90",
        "c4_master",
        "program",
    )}))
    print("SHA256", digest, flush=True)


if __name__ == "__main__":
    main()
