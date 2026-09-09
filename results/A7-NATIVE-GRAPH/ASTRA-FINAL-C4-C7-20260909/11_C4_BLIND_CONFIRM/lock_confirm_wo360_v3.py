#!/usr/bin/env python3
"""Lock WO 360 Confirm v3 BEFORE any inference. Disjoint from v1/v2/train/dev/historic."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

sys.path.insert(0, r"D:\FPGA\C4_RESCUE_20260909")
from train_c4_balance_90 import entities, historic_rows
from train_c4_f_copy_balanced import collect_reserved, load_rows_json

ALPHABET = "abcdefghijklmnopqrstuvwxyz"
OUT = Path(__file__).resolve().parent
RUN = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\runs\fr_balanced_01")
V2 = Path(r"D:\FPGA\C4_RESCUE_20260909\EXPERIMENTS\F_COPY_BALANCED_01\data\confirm_v2.json")


def word(rng, used):
    for _ in range(8192):
        v = "".join(rng.choice(ALPHABET) for _ in range(4))
        if v not in used:
            return v
    raise RuntimeError("exhausted")


def main():
    reserved = collect_reserved()
    reserved |= entities(load_rows_json(RUN / "dev.json"))
    with (RUN / "train_rows.jsonl").open(encoding="utf-8") as fh:
        for line in fh:
            reserved |= entities(json.loads(line)["rows"])
    reserved |= entities(historic_rows())
    reserved |= entities(load_rows_json(V2))
    rng = random.Random(36009)
    used = set(reserved)
    rows = []

    def take2():
        a = word(rng, used)
        b = word(rng, used | {a})
        used.update((a, b))
        return a, b

    def take3():
        a, b = take2()
        c = word(rng, used)
        used.add(c)
        return a, b, c

    for _ in range(120):
        src, dst = take2()
        rows.append(dict(ctx=f"F {dst} {src}>{dst}", ans=src, group="F", kind="supported_forward"))
    for _ in range(120):
        src, dst = take2()
        rows.append(dict(ctx=f"R {src} {src}>{dst}", ans=dst, group="R", kind="supported_reverse"))
    kinds = (
        ["unrelated"] * 20
        + ["missing_evidence"] * 20
        + ["wrong_context"] * 20
        + ["conflict"] * 20
        + ["ambiguous"] * 20
        + ["search_incomplete"] * 20
    )
    for kind in kinds:
        if kind == "unrelated":
            s, d, o = take3()
            ctx = f"F {d} {s}>{o}"
        elif kind == "missing_evidence":
            s, d = take2()
            ctx = f"F {d} {s}>none"
        elif kind == "wrong_context":
            s, d, o = take3()
            ctx = f"F {o} {s}>{d}"
        elif kind == "conflict":
            s, d, o = take3()
            ctx = f"R {s} {s}>{d}"
            # second dest lives in kind metadata; context stays 16 bytes
        elif kind == "ambiguous":
            s, d, o = take3()
            ctx = f"F {d} {s}>{d}"
        else:
            s, d = take2()
            ctx = f"F {d} {s}>{d}"
        if len(ctx) != 16:
            raise SystemExit(f"bad ctx len {len(ctx)} {ctx!r} {kind}")
        rows.append(dict(ctx=ctx, ans="no", group="U", kind=kind, system_expected=["n", "o", 0]))

    leak = entities(rows) & reserved
    if leak:
        raise SystemExit("reserved leak " + ",".join(sorted(leak)[:12]))
    ids = list(range(len(rows)))
    rng.shuffle(ids)
    for i, r in zip(ids, rows):
        r["id"] = f"c3-{i:04d}"
    counts = {g: sum(1 for r in rows if r["group"] == g) for g in "FRU"}
    kinds_c = {}
    for r in rows:
        kinds_c[r["kind"]] = kinds_c.get(r["kind"], 0) + 1
    if counts != {"F": 120, "R": 120, "U": 120}:
        raise SystemExit(counts)
    payload = dict(
        name="confirm_wo360_v3",
        locked=True,
        opened_for_selection=False,
        prereg=dict(
            n_F=120,
            n_R=120,
            n_U=120,
            grounded_n=240,
            unsupported_n=120,
            overall_min=0.90,
            F_min=0.90,
            R_min=0.90,
            system_safe_min=0.95,
            system_hall_max=0.05,
            termination=1.0,
            float_int=1.0,
            system_refusal="n then o then EOS; not a learned-U claim",
        ),
        seed=36009,
        disjoint_from="historic, confirm_v1, confirm_v2, reverse train/dev, F-copy train/dev",
        kind_counts=kinds_c,
        rows=rows,
    )
    text = json.dumps({k: v for k, v in payload.items() if k != "sha256_canonical"}, indent=2, sort_keys=True)
    digest = hashlib.sha256(text.encode("utf-8")).hexdigest()
    payload["sha256_canonical"] = digest
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "confirm_wo360_v3.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    lock = dict(
        file="confirm_wo360_v3.json",
        sha256_canonical=digest,
        counts=counts,
        kind_counts=kinds_c,
        opened_for_selection=False,
        confirm_v1_for_pass=False,
        confirm_v2_for_pass=False,
    )
    (OUT / "CONFIRM_WO360_V3_LOCK.json").write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
    print("locked", digest, counts, kinds_c)


if __name__ == "__main__":
    main()
