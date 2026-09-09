# ASTRA-09 unified pipeline. BIT=NO PROGRAM=NO COM12=UNTOUCHED
$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $bag
python "$bag\host_astra09.py" --golden-only
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_HOST_GOLDEN_FAIL" }
$bin = "C:\2026.1\Vivado\bin"
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$pkg  = Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"
$qse  = Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"
$eng  = Join-Path $root "rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"
$sgd  = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8.sv"
$cmp  = Join-Path $root "rtl\native_graph\lm\a7ng_evidence_compose.sv"
$pipe = Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"
$tb   = Join-Path $bag "tb_astra09_pipe.sv"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $bag $pkg $qse $eng $sgd $cmp $pipe $tb
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -ErrorAction SilentlyContinue
& "$bin\xelab.bat" tb_astra09_pipe -s astra09 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_XELAB_FAIL" }
Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -ErrorAction SilentlyContinue
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra09 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_XSIM_FAIL" }
Set-Location $bag
python "$bag\host_astra09.py" --compare
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_COMPARE_FAIL" }
Write-Host "ASTRA09_RUN_OK"
