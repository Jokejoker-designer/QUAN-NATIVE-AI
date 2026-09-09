$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$hexsrc = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1_mem"

function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C4D32_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}

$goldSv = Join-Path $bag "GOLDEN.svh"
$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_lm06_d32_fr_v1.sv"
$dut = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1.sv"
$svh = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v1.svh"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4D32_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldSv
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4D32_GOLD_HASH_DRIFT GOLDEN.svh" }

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=OPEN C4_MASTER=OPEN D32_FR_V1"
)
$pre += "$(Sha256 $dut)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1.sv"
$pre += "$(Sha256 $svh)  rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1.svh"
$pre += "$(Sha256 $tb)  tb_astra_c4_lm06_d32_fr_v1.sv"
$pre += "$(Sha256 $goldSv)  GOLDEN.svh"
$pre += "$(Sha256 $goldJson)  GOLDEN.json"
Get-ChildItem -LiteralPath $hexsrc -Filter *.hex | ForEach-Object {
  $rel = "rtl/native_graph/integrate/a7ng_astra_c4_lm06_d32_fr_v1_mem/$($_.Name)"
  $pre += "$(Sha256 $_.FullName)  $rel"
}
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C4D32_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C4D32_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $inci -i $bag $dut $tb
if ($LASTEXITCODE -ne 0) { throw "C4D32_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c4_lm06_d32_fr_v1 -s c4d32fr -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C4D32_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4d32fr -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = (Select-String -Path $xsimLog -Pattern "ASTRA_C4_D32_FR_V1_XSIM_PASS" -Quiet) -and
             (Select-String -Path $xsimLog -Pattern "CLASS_ref_match HIT" -Quiet) -and
             (Select-String -Path $xsimLog -Pattern "CLASS_host_tok0 HIT" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
  }
  throw "C4D32_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass"
}
Write-Host "ASTRA_C4_D32_FR_V1_RUN_OK"
