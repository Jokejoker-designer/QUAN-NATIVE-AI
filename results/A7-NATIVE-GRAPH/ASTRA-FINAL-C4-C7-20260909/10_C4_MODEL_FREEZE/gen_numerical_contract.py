#!/usr/bin/env python3
"""Build C4_D32_NUMERICAL_CONTRACT_V1 from actual PTQ files. No invented scales."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np

KEYS = ("We", "Wq", "Wk", "Wv", "W1", "W2", "by", "Pe", "WqR", "WkR", "WvR")


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--checkpoint", type=Path, required=True)
    ap.add_argument("--manifest", type=Path, required=True)
    ap.add_argument("--ptq-dir", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    a = ap.parse_args()
    man = json.loads(a.manifest.read_text(encoding="utf-8"))
    with np.load(a.checkpoint, allow_pickle=False) as z:
        shapes = {k: list(np.asarray(z[k]).shape) for k in z.files if k in KEYS}
        d = int(z["We"].shape[1])
        f = int(z["W1"].shape[0])
        vocab = int(z["We"].shape[0])
        pe_t = int(z["Pe"].shape[0])
    hex_files = []
    offset = 0
    for item in man["layout"]:
        bits = int(item["bits"])
        n = 1
        for dim in item["shape"]:
            n *= int(dim)
        nbytes = n * (bits // 8)
        hex_path = a.ptq_dir / item["hex"]
        rec = dict(
            name=item["name"],
            hex=item["hex"],
            shape=item["shape"],
            bits=bits,
            order=item.get("order", "C"),
            byte_offset=offset,
            byte_count=nbytes,
            sha256=sha(hex_path) if hex_path.exists() else None,
            missing=not hex_path.exists(),
        )
        if hex_path.exists() and rec["sha256"] != item.get("sha256"):
            rec["sha256_mismatch_vs_manifest"] = item.get("sha256")
        hex_files.append(rec)
        offset += nbytes
    arch_note = None
    if d != 32 or f != 64:
        arch_note = f"actual D={d} F={f}; do not force D32/F64"
    contract = dict(
        schema="C4_D32_NUMERICAL_CONTRACT_V1",
        architecture_version="c4-opcode-conditioned-attention-v1",
        vocab_size=vocab,
        vocab_version="byte-256-ascii-plus-eos0",
        D=d,
        F=f,
        architecture_note=arch_note,
        context_length=int(man["context_bytes"]),
        max_generation_length=int(man["max_tokens"]),
        position_table_length=pe_t,
        seed_token_law="append EOS/BOS byte 0 after the 16 context bytes; first prediction is at index 16",
        eos_token=int(man["eos"]),
        tensor_names=list(shapes.keys()),
        tensor_shapes=shapes,
        bank_selection_law=man["opcode_bank"],
        bank_selection_detail="ctx[0]==82 ('R') selects WqR/WkR/WvR; otherwise F bank Wq/Wk/Wv. No U bank. No gold group. No target_slot.",
        quantization=dict(
            schema=man["schema"],
            weight_storage="INT8 except by INT32",
            activation_bits=man["activation_bits"],
            activation_storage_bits=man["activation_storage_bits"],
            weight_scales=man["weight_scales"],
            activation_scales=man["activation_scales"],
            requant=man["requant"],
            rounding=man["rounding"],
            mac_bits=man["mac_bits"],
            requant_product_bits=man["requant_product_bits"],
            saturation="signed clip to +/-((1<<(activation_bits-1))-1) after each requant",
            softmax=man["softmax"],
        ),
        token_feedback_law="greedy argmax of integer logits appended to token stream until EOS or max_tokens",
        n_host_tok="must be 0; host never supplies next token",
        hex_files=hex_files,
        concatenated_weight_bytes=offset,
        checkpoint_path=str(a.checkpoint),
        checkpoint_sha256=sha(a.checkpoint),
        manifest_path=str(a.manifest),
        manifest_sha256=sha(a.manifest),
        quantized_npz_sha256=sha(a.ptq_dir / "quantized.npz") if (a.ptq_dir / "quantized.npz").exists() else None,
        PROGRAM="NO",
        C4_MASTER="OPEN",
        ASTRA_NATIVE_AI_BOARD_PASS="OPEN",
        warning=man.get("warning"),
    )
    if contract["checkpoint_sha256"] != man.get("checkpoint_sha256"):
        raise SystemExit("checkpoint sha256 != manifest.checkpoint_sha256")
    a.out.parent.mkdir(parents=True, exist_ok=True)
    a.out.write_text(json.dumps(contract, indent=2), encoding="utf-8")
    print("WROTE", a.out, "D", d, "F", f, "ckpt", contract["checkpoint_sha256"][:16])


if __name__ == "__main__":
    main()
