# ENTITY_ALIAS_V1

PROGRAM=NO. C4_MASTER=OPEN. Production dictionary **OPEN**.

## Purpose

Map a **full-width entity ID** to a V2 4-byte symbol (`hit`, `overflow`) before `a7ng_astra_c4_materializer_v2`.

Materializer `ID_W=8` is a **local slot index** into a tiny dict presented by this layer (slots 0=SRC, 1=DST). It is not the C3 ID width.

## Ports (RTL)

Module: `rtl/native_graph/integrate/a7ng_astra_c4_entity_alias_v1.sv`

| Port | Width | Law |
|---|---|---|
| `id_i` | `ENT_W=20` | Probe key. Compared equal to `key_i[k]`. |
| `key_i[0:N-1]` | 20 | Installed IDs. TB may be synthetic. |
| `sym_i[0:N-1]` | 32 | Little-endian 4-char payload. |
| `valid_i[k]` | 1 | Row occupied. |
| `ovf_i[k]` | 1 | Row exists but overflow/refuse. |
| `hit_o` | 1 | Exactly one valid exact match and not multi-hit. |
| `miss_o` | 1 | Zero matches. |
| `ovf_o` | 1 | Matched row `ovf_i`, or more than one match. |
| `sym_o` | 32 | Symbol, or `????` on miss/ambiguous. |

## Forbidden

- `id_i[7:0]` as the compare
- 256-entry ROM indexed by truncated `proof0` / `ans` / QSE id
- Treating C3 `proof0_o`/`proof1_o` (fact-record IDs) as endpoint keys without a verified map
- Shipping a production table from Confirm-V3 4-char packing, QSE 12-char words, or TB synthetic keys

## TB vs production

| | TB | Production |
|---|---|---|
| Keys | Synthetic 20-bit values with nonzero high bits | **OPEN** |
| Symbols | Packed Confirm-V3 4-char fixtures for decoder smoke | **OPEN** |
| N | 8 | **OPEN** |
| Miss | `valid=0` → wrap `answer_allowed=0` → D32 `S_SAFE` (`n`,`o`,EOS) | same refuse law |

Smoke includes `20'h10001` vs installed `20'hA0001` (same `[7:0]`, different high bits). A truncated ROM would false-hit. Exact-20 must miss.

## Direction

`direction_i==2'd0` is the only encoding proven in live extract (`qse_dir` hardwired 0). Reverse bank is `bank_r_i`, not a parser decode.
