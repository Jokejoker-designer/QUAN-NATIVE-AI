from pathlib import Path

src = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-N800000-SCALE-01\run_xsim.ps1")
dst = Path(r"D:\FPGA\FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH\results\A7-NATIVE-GRAPH\ASTRA-C1-CAND-CAP-SWEEP-01\run_xsim.ps1")
text = src.read_text(encoding="utf-8")
text = text.replace("C1800KS", "C1CCS")
text = text.replace("tb_astra_c1_n800000_scale.sv", "tb_astra_c1_cand_cap_sweep.sv")
text = text.replace("host_astra_c1_n800000_scale.py", "host_astra_c1_cand_cap_sweep.py")
text = text.replace("ASTRA-C1-N800000-SCALE-01", "ASTRA-C1-CAND-CAP-SWEEP-01")
text = text.replace(
    "# PROGRAM=NO CAND_CAP=16 N=800000 N_BUCKETS=65536 LAW=qse-v2-relctx-synonym-01 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PROC_MEM=1",
    "# PROGRAM=NO CAND_CAP_SWEEP=16,64,128,256 N=800000 N_BUCKETS=65536 LAW=qse-v2-relctx-synonym-01 LEX=qse-v2-lex-semantic-800k-01 POKE_V=0 PROC_MEM=1 GOLD_FROZEN_FROM_N800000_SCALE",
)
text = text.replace(
    "# REDUCTION_X1000 NOT_EMITTED",
    "# REDUCTION_VS_N_X1000 required; never reduction_x1000=cap/N tautology",
)
head, sep, _tail = text.partition('& "$bin\\xelab.bat"')
if not sep:
    raise SystemExit("xelab marker missing")
tail = r'''
$caps = @(16, 64, 128, 256)
$combo = New-Object System.Collections.Generic.List[string]
$combo.Add("# ASTRA-C1-CAND-CAP-SWEEP-01 concatenated xsim.log PROGRAM=NO CAND_CAP_FINAL=NOT_FROZEN")
$allOk = $true
foreach ($cap in $caps) {
  $snap = "astra_c1_cand_cap_sweep_$cap"
  Write-Host "C1CCS_XELAB cap=$cap"
  & "$bin\xelab.bat" tb_astra_c1_cand_cap_sweep -generic_top "CAND_CAP_SWEEP=$cap" -s $snap -timescale 1ns/1ps
  if ($LASTEXITCODE -ne 0) {
    if (Test-Path (Join-Path $work "xelab.log")) {
      Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
    }
    Write-DivLog "XELAB" "xelab_exit=$LASTEXITCODE cap=$cap"
    throw "C1CCS_XELAB_FAIL FIRST_DIVERGENCE XELAB cap=$cap"
  }
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab_cap_$cap.log") -Force
  }
  $capLog = Join-Path $bag "xsim_cap_$cap.log"
  & "$bin\xsim.bat" $snap -R -log $capLog
  $xsimExit = $LASTEXITCODE
  $combo.Add("")
  $combo.Add("##### CAP=$cap #####")
  if (Test-Path -LiteralPath $capLog) {
    $combo.AddRange([string[]][System.IO.File]::ReadAllLines($capLog))
  }
  $hasPass = $false
  $hasDiv = $false
  $hasRedCap = $false
  $hasFillFail = $false
  $hasFillHit = $false
  $hasIncomp = $false
  $hasNDrop = $false
  $hasHigh = $false
  $hasLate = $false
  $hasWctx = $false
  $hasRev = $false
  $hasDist = $false
  $hasFail = $false
  $hasN800 = $false
  $hasPoint = $false
  if (Test-Path -LiteralPath $capLog) {
    $hasPass = [bool](Select-String -Path $capLog -Pattern "ASTRA_C1_CAND_CAP_SWEEP_XSIM_PASS cap=$cap" -Quiet)
    $hasDiv = [bool](Select-String -Path $capLog -Pattern "FIRST_DIVERGENCE" -Quiet)
    $hasRedCap = [bool](Select-String -Path $capLog -Pattern "reduction_x1000=[0-9]" -Quiet)
    $hasFillFail = [bool](Select-String -Path $capLog -Pattern "FAIL FILL_TEMPLATE_" -Quiet)
    $hasFillHit = [bool](Select-String -Path $capLog -Pattern "FILL_TEMPLATE_HIT" -Quiet)
    $hasIncomp = [bool](Select-String -Path $capLog -Pattern "SEARCH_INCOMPLETE" -Quiet)
    $hasNDrop = [bool](Select-String -Path $capLog -Pattern "FIRST_DIVERGENCE N_DROP" -Quiet)
    $hasHigh = [bool](Select-String -Path $capLog -Pattern "HIGH_ID_HIT nid=799999" -Quiet)
    $hasLate = [bool](Select-String -Path $capLog -Pattern "LATE_GOLD_HIT nid=799998" -Quiet)
    $hasWctx = [bool](Select-String -Path $capLog -Pattern "WRONG_CONTEXT_SELECTIVE nid=121" -Quiet)
    $hasRev = [bool](Select-String -Path $capLog -Pattern "ROLE_REVERSAL_HIT" -Quiet)
    $hasDist = [bool](Select-String -Path $capLog -Pattern "DISTRACTOR_LEAK_N=0" -Quiet)
    $hasFail = [bool](Select-String -Path $capLog -Pattern "^FAIL " -Quiet)
    $hasN800 = [bool](Select-String -Path $capLog -Pattern "C1_CAND_CAP_SWEEP_N=800000" -Quiet)
    $hasPoint = [bool](Select-String -Path $capLog -Pattern "CAND_CAP_SWEEP_POINT cap=$cap" -Quiet)
  }
  if ($hasRedCap) { throw "C1CCS_REDUCTION_X1000_EMITTED_AS_CAP_N cap=$cap" }
  if ($hasNDrop) { throw "C1CCS_N_DROP_SILENT_16K_FORBIDDEN cap=$cap" }
  if ($hasDiv -or $hasFillFail -or (-not $hasFillHit) -or $hasIncomp -or (-not $hasHigh) -or (-not $hasLate) -or (-not $hasN800) -or (-not $hasWctx) -or (-not $hasRev) -or (-not $hasDist) -or (-not $hasPoint) -or (-not $hasPass) -or $hasFail) {
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if ((Test-Path -LiteralPath $capLog) -and (-not (Test-Path -LiteralPath $r0))) {
      Copy-Item $capLog $r0 -Force
    }
    $allOk = $false
    throw "C1CCS_XSIM_CONTROL_FAIL cap=$cap fillHit=$hasFillHit high=$hasHigh late=$hasLate n800=$hasN800 wctx=$hasWctx rev=$hasRev dist=$hasDist point=$hasPoint pass=$hasPass failTok=$hasFail div=$hasDiv incomp=$hasIncomp exit=$xsimExit"
  }
  Write-Host "C1CCS_CAP_OK cap=$cap"
}
$xsimLog = Join-Path $bag "xsim.log"
[System.IO.File]::WriteAllLines($xsimLog, $combo)
if ($allOk) {
  Write-Host "ASTRA_C1_CAND_CAP_SWEEP_RUN_OK PASS caps=16,64,128,256 CAND_CAP_FINAL=NOT_FROZEN"
}
'''
dst.write_text(head + tail, encoding="utf-8")
print("wrote", dst, "bytes", dst.stat().st_size)
