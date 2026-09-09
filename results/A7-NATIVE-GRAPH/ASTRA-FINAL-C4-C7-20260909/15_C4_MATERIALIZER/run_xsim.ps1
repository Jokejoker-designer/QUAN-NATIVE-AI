$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$dut = Join-Path $inci "a7ng_astra_c4_materializer_v1.sv"
$tb = Join-Path $bag "tb_astra_c4_materializer_v1.sv"
$goldSv = Join-Path $bag "GOLDEN.svh"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"

function Sha256([string]$p) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}

if (-not (Test-Path -LiteralPath $goldPre)) { throw "MAT_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldSv
if ([System.IO.File]::ReadAllText($goldPre) -notmatch $liveGold) { throw "MAT_GOLD_HASH_DRIFT" }

Write-Host "MAT_SHA_FROZEN $(Sha256 $dut) $(Sha256 $tb) $liveGold"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
& "$bin\xvlog.bat" --sv -i $inci -i $bag $dut $tb
if ($LASTEXITCODE -ne 0) { throw "MAT_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c4_materializer_v1 -s c4mat -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "MAT_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4mat -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "MAT_XSIM_FAIL" }
if (-not ((Select-String -Path $xsimLog -Pattern "ASTRA_C4_MATERIALIZER_V1_XSIM_PASS" -Quiet) -and
          (Select-String -Path $xsimLog -Pattern "CLASS_ref_match HIT" -Quiet) -and
          (Select-String -Path $xsimLog -Pattern "PASS REPLACE_SRC_SLOT_B" -Quiet))) {
  throw "MAT_MARKER_MISSING"
}
Write-Host "ASTRA_C4_MATERIALIZER_V1_RUN_OK"
