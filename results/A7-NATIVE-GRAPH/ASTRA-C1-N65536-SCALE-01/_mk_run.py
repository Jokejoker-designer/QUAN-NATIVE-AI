#!/usr/bin/env python3
from pathlib import Path

p = Path(__file__).with_name("run_xsim.ps1")
t = p.read_text(encoding="utf-8")
repls = [
    ("tb_astra_c1_semantic_800k.sv", "tb_astra_c1_n65536_scale.sv"),
    ("host_astra_c1_semantic_800k.py", "host_astra_c1_n65536_scale.py"),
    ("tb_astra_c1_semantic_800k", "tb_astra_c1_n65536_scale"),
    ("astra_c1_semantic_800k", "astra_c1_n65536_scale"),
    ('"n": 800000', '"n": 65536'),
    ("localparam int unsigned G_N = 800000;", "localparam int unsigned G_N = 65536;"),
    ("N=800000", "N=65536"),
    ("ASTRA_C1_SEMANTIC_800K_XSIM_PASS", "ASTRA_C1_N65536_SCALE_XSIM_PASS"),
    ("C1_SEMANTIC_800K_N=800000", "C1_N65536_SCALE_N=65536"),
    ("HIGH_ID_HIT nid=799999", "HIGH_ID_HIT nid=65535"),
    ("C1800K_", "C165K_"),
    ("ASTRA-C1-SEMANTIC-800K-01", "ASTRA-C1-N65536-SCALE-01"),
]
for a, b in repls:
    t = t.replace(a, b)
# keep tautology guard but do not treat REDUCTION_VS_N as tautology (pattern is reduction_x1000=)
# add late-gold requirement
if '$hasLate = $false' not in t:
    t = t.replace("$hasHigh = $false", "$hasHigh = $false\n$hasLate = $false")
t = t.replace(
    '$hasHigh = [bool](Select-String -Path $xsimLog -Pattern "HIGH_ID_HIT nid=65535" -Quiet)',
    '$hasHigh = [bool](Select-String -Path $xsimLog -Pattern "HIGH_ID_HIT nid=65535" -Quiet)\n  $hasLate = [bool](Select-String -Path $xsimLog -Pattern "LATE_GOLD_HIT nid=65534" -Quiet)',
)
t = t.replace(
    "if ($hasDiv -or $hasFillFail -or (-not $hasFillHit) -or $hasIncomp -or (-not $hasHigh) -or (-not $hasN800))",
    "if ($hasDiv -or $hasFillFail -or (-not $hasFillHit) -or $hasIncomp -or (-not $hasHigh) -or (-not $hasLate) -or (-not $hasN800))",
)
t = t.replace("high=$hasHigh n800=$hasN800", "high=$hasHigh late=$hasLate n800=$hasN800")
t = t.replace(
    'Write-Host "ASTRA_C1_SEMANTIC_800K_RUN_OK PASS N=65536 FILL_TEMPLATE_HIT HIGH_ID_HIT"',
    'Write-Host "ASTRA_C1_N65536_SCALE_RUN_OK PASS N=65536 FILL_TEMPLATE_HIT LATE_GOLD_HIT HIGH_ID_HIT"',
)
t = t.replace('throw "C165K_XSIM_CONTROL_FAIL fillHit=$hasFillHit high=$hasHigh n800=$hasN800 div=$hasDiv incomp=$hasIncomp"',
              'throw "C165K_XSIM_CONTROL_FAIL fillHit=$hasFillHit high=$hasHigh late=$hasLate n800=$hasN800 div=$hasDiv incomp=$hasIncomp"')
p.write_text(t, encoding="utf-8")
print("run_xsim patched", "n65536" in t.lower() or "65536" in t)
print("tb name", "tb_astra_c1_n65536_scale" in t)
print("hasLate", "$hasLate" in t)
