param(
  [switch]$Smoke
)
$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag $(if ($Smoke) { "xsim_work_smoke" } else { "xsim_work" })
$inci = Join-Path $root "rtl\native_graph\integrate"
$hexsrc = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2_mem"

function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C4D32V2_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}

$goldSv = Join-Path $bag "GOLDEN.svh"
$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_lm06_d32_fr_v2.sv"
$dut = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2.sv"
$svh = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2.svh"
$v1svh = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1.svh"
$v1mem = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1_mem"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4D32V2_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldSv
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4D32V2_GOLD_HASH_DRIFT GOLDEN.svh" }

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$shaOut = Join-Path $bag $(if ($Smoke) { "SHA256_SMOKE.txt" } else { "SHA256.txt" })
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=OPEN C4_MASTER=OPEN D32_FR_V2$(if ($Smoke) { ' SMOKE' } else { '' })"
)
$pre += "$(Sha256 $dut)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.sv"
$div = Join-Path $inci "a7ng_astra_c4_smres_div_mcycle.sv"
$pre += "$(Sha256 $div)  rtl/native_graph/integrate/a7ng_astra_c4_smres_div_mcycle.sv"
$rq = Join-Path $inci "a7ng_astra_c4_rq_mcycle.sv"
$pre += "$(Sha256 $rq)  rtl/native_graph/integrate/a7ng_astra_c4_rq_mcycle.sv"
$pre += "$(Sha256 $svh)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2.svh"
$pre += "$(Sha256 $v1svh)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1.svh"
$pre += "$(Sha256 $tb)  tb_astra_c4_lm06_d32_fr_v2.sv"
$pre += "$(Sha256 $goldSv)  GOLDEN.svh"
$pre += "$(Sha256 $goldJson)  GOLDEN.json"
Get-ChildItem -LiteralPath $hexsrc -Filter *.hex | ForEach-Object {
  $rel = "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v2_mem/$($_.Name)"
  $pre += "$(Sha256 $_.FullName)  $rel"
}
Get-ChildItem -LiteralPath $v1mem -Filter *.hex | ForEach-Object {
  $rel = "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1_mem/$($_.Name)"
  $pre += "$(Sha256 $_.FullName)  $rel"
}
[System.IO.File]::WriteAllLines($shaOut, $pre)
Write-Host "C4D32V2_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C4D32V2_XVLOG_NOT_FOUND" }
$xvlogArgs = @("--sv", "-i", $inci, "-i", $bag)
if ($Smoke) { $xvlogArgs += @("-d", "C4D32_SMOKE") }
& "$bin\xvlog.bat" @xvlogArgs $div $rq $dut $tb
if ($LASTEXITCODE -ne 0) { throw "C4D32V2_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag $(if ($Smoke) { "xvlog_smoke.log" } else { "xvlog.log" })) -Force
$simName = if ($Smoke) { "c4d32frv2smoke" } else { "c4d32frv2" }
& "$bin\xelab.bat" tb_astra_c4_lm06_d32_fr_v2 -s $simName -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag $(if ($Smoke) { "xelab_smoke.log" } else { "xelab.log" })) -Force
  }
  throw "C4D32V2_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag $(if ($Smoke) { "xelab_smoke.log" } else { "xelab.log" })) -Force
}
$xsimLog = Join-Path $bag $(if ($Smoke) { "xsim_smoke.log" } else { "xsim.log" })
$marker = if ($Smoke) { "ASTRA_C4_D32_FR_V2_XSIM_SMOKE_PASS" } else { "ASTRA_C4_D32_FR_V2_XSIM_PASS" }
& "$bin\xsim.bat" $simName -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = (Select-String -Path $xsimLog -Pattern $marker -Quiet) -and
             (Select-String -Path $xsimLog -Pattern "CLASS_ref_match HIT" -Quiet) -and
             (Select-String -Path $xsimLog -Pattern "CLASS_host_tok0 HIT" -Quiet) -and
             -not (Select-String -Path $xsimLog -Pattern "ASTRA_NATIVE_AI_BOARD_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag $(if ($Smoke) { "xsim_smoke_fail.log" } else { "xsim_fail.log" })) -Force
  }
  throw "C4D32V2_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass marker=$marker"
}
Write-Host $(if ($Smoke) { "ASTRA_C4_D32_FR_V2_SMOKE_RUN_OK" } else { "ASTRA_C4_D32_FR_V2_RUN_OK" })
