from pathlib import Path
import hashlib

bag = Path(__file__).resolve().parent


def sha(n: str) -> str:
    return hashlib.sha256((bag / n).read_bytes()).hexdigest()


names = [
    "GOLDEN.json",
    "query_gold.svh",
    "corpus.json",
    "qse_role_lexicon_semantic_800k.svh",
    "qse_relctx_synonym_01.svh",
]
lines = ["# independent gold hashed BEFORE first xvlog — do not regenerate after FAIL"]
for n in names:
    lines.append(f"{sha(n)}  {n}")
lines.append("")
(bag / "GOLD_HASH_PRE_XVLOG.txt").write_text("\n".join(lines), encoding="utf-8")
print("wrote GOLD_HASH_PRE_XVLOG")
