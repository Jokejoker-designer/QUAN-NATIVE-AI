from pathlib import Path
import json

p = Path(__file__).resolve().parent
c = json.loads((p / "corpus.json").read_text(encoding="utf-8"))
hg = c["held_grounded"]
hu = c["held_unrel"]
L = [
    "// frozen with corpus.json before xvlog. PROGRAM=NO.",
    f"localparam int unsigned C4L_NG = {len(hg)};",
    f"localparam int unsigned C4L_NU = {len(hu)};",
]
for i, r in enumerate(hg):
    L.append(f'localparam string C4L_GCTX_{i} = "{r["ctx"]}";')
    L.append(f'localparam string C4L_GANS_{i} = "{r["ans"]}";')
for i, r in enumerate(hu):
    L.append(f'localparam string C4L_UCTX_{i} = "{r["ctx"]}";')
L.append("function automatic string c4l_gctx(input int unsigned i);")
L.append("  unique case (i)")
for i in range(len(hg)):
    L.append(f"    {i}: c4l_gctx = C4L_GCTX_{i};")
L.append("    default: c4l_gctx = C4L_GCTX_0;")
L.append("  endcase")
L.append("endfunction")
L.append("function automatic string c4l_gans(input int unsigned i);")
L.append("  unique case (i)")
for i in range(len(hg)):
    L.append(f"    {i}: c4l_gans = C4L_GANS_{i};")
L.append("    default: c4l_gans = C4L_GANS_0;")
L.append("  endcase")
L.append("endfunction")
L.append("function automatic string c4l_uctx(input int unsigned i);")
L.append("  unique case (i)")
for i in range(len(hu)):
    L.append(f"    {i}: c4l_uctx = C4L_UCTX_{i};")
L.append("    default: c4l_uctx = C4L_UCTX_0;")
L.append("  endcase")
L.append("endfunction")
(p / "tb_heldout.svh").write_text("\n".join(L) + "\n", encoding="ascii")
print("wrote tb_heldout.svh", len(hg), len(hu))
