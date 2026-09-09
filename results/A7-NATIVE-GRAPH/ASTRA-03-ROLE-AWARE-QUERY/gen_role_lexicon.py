#!/usr/bin/env python3
"""Emit qse_role_lexicon.svh from role_lexicon.py (qse-v2-role-00)."""
from pathlib import Path
from role_lexicon import LEX, MAX_WORD, LAW


def pack_word(w: str) -> int:
    b = w.encode("ascii")
    assert len(b) <= MAX_WORD
    v = 0
    for i, x in enumerate(b):
        v |= x << (8 * i)
    return v


def main() -> None:
    here = Path(__file__).resolve().parent
    n = len(LEX)
    lines = [
        f"// auto-generated from role_lexicon.py — {LAW}. Do not hand-edit.",
        f"localparam int unsigned QSE2_N_LEX = {n};",
        f"localparam int unsigned QSE2_MAX_WORD = {MAX_WORD};",
        "localparam logic [7:0] QSE2_CLS [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{c}" for _, c, _ in LEX) + "};",
        "localparam logic [7:0] QSE2_ID [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{i}" for _, _, i in LEX) + "};",
        "localparam logic [7:0] QSE2_LEN [0:QSE2_N_LEX-1] = '{",
        ",".join(f"8'd{len(w)}" for w, _, _ in LEX) + "};",
        "localparam logic [95:0] QSE2_WORD [0:QSE2_N_LEX-1] = '{",
        ",".join(f"96'h{pack_word(w):024x}" for w, _, _ in LEX) + "};",
        "",
    ]
    text = "\n".join(lines)
    out = here / "qse_role_lexicon.svh"
    out.write_text(text, encoding="utf-8")
    print("WROTE", out, "N", n)


if __name__ == "__main__":
    main()
