# ASTRA-05 host golden + XSim. BIT=NO PROGRAM=NO COM12=UNTOUCHED
$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $bag
python "$bag\host_astra05.py" --golden-only
if ($LASTEXITCODE -ne 0) { throw "ASTRA05_HOST_GOLDEN_FAIL" }
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$rtl = Join-Path $bag "..\..\..\rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"
$tb  = Join-Path $bag "tb_astra05_perturb.sv"
& "$bin\xvlog.bat" --sv -i $bag $rtl $tb
if ($LASTEXITCODE -ne 0) { throw "ASTRA05_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -ErrorAction SilentlyContinue
& "$bin\xelab.bat" tb_astra05_perturb -s astra05 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "ASTRA05_XELAB_FAIL" }
Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -ErrorAction SilentlyContinue
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra05 -R -log $xsimLog
Set-Location $bag
python "$bag\host_astra05.py" --compare
if ($LASTEXITCODE -ne 0) { throw "ASTRA05_COMPARE_FAIL" }
Write-Host "ASTRA05_RUN_OK"
