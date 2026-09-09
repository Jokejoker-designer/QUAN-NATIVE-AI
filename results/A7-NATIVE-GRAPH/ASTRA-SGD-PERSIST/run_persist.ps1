$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$files = @(
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_v1.sv"),
  (Join-Path $bag "tb_persist.sv")
)
& "$bin\xvlog.bat" --sv $files
if ($LASTEXITCODE -ne 0) { throw "PERSIST_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_persist -s persist -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "PERSIST_XELAB_FAIL" }
$log = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" persist -R -log $log
if (-not (Select-String -Path $log -Pattern "ASTRA_SGD_PERSIST_XSIM_PASS" -Quiet)) { throw "PERSIST_PASS_MARKER_MISSING" }
Write-Host "ASTRA_SGD_PERSIST_RUN_OK"
