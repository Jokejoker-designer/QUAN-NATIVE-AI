$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$dut = Join-Path $inci "a7ng_astra_c4_materializer_v2.sv"
$tb = Join-Path $bag "tb_astra_c4_materializer_v2.sv"
$goldSv = Join-Path $bag "GOLDEN.svh"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"

function Sha256([string]$p) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}

if (-not (Test-Path -LiteralPath $goldPre)) { throw "G06A_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldSv
if ([System.IO.File]::ReadAllText($goldPre) -notmatch $liveGold) { throw "G06A_GOLD_HASH_DRIFT" }

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
& "$bin\xvlog.bat" --sv -i $inci -i $bag $dut $tb
if ($LASTEXITCODE -ne 0) { throw "G06A_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c4_materializer_v2 -s c4mat2 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "G06A_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4mat2 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "G06A_XSIM_FAIL" }
if (-not ((Select-String -Path $xsimLog -Pattern "ASTRA_C4_G06A_MATERIALIZER_V2_XSIM_PASS" -Quiet) -and
          (Select-String -Path $xsimLog -Pattern "CLASS_ref_match HIT" -Quiet) -and
          (Select-String -Path $xsimLog -Pattern "PASS ENTITY_INVARIANT_EXCEPT_OPCODE" -Quiet) -and
          (Select-String -Path $xsimLog -Pattern "PASS ENDPOINT_ONCE" -Quiet))) {
  throw "G06A_MARKER_MISSING"
}
Write-Host "ASTRA_C4_G06A_MATERIALIZER_V2_RUN_OK"
