# ASTRA-09-SPARSE-GLUE. BIT=NO PROGRAM=NO COM12=UNTOUCHED
$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $bag
python "$bag\host_astra09_sparse.py" --golden-only
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_SPARSE_HOST_GOLDEN_FAIL" }
$bin = "C:\2026.1\Vivado\bin"
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$pkg  = Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"
$qse1 = Join-Path $root "rtl\native_graph\query\a7ng_query_struct_extract.sv"
$qse2 = Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"
$vg   = Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"
$walk = Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"
$mem  = Join-Path $root "rtl\native_graph\memory\a7ng_axi_mem_model.sv"
$sp   = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"
$eng  = Join-Path $root "rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"
$sgd  = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8.sv"
$cmp  = Join-Path $root "rtl\native_graph\lm\a7ng_evidence_compose.sv"
$pipe = Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"
$tb   = Join-Path $bag "tb_astra09_sparse.sv"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $bag $pkg $qse1 $qse2 $vg $walk $mem $sp $eng $sgd $cmp $pipe $tb
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_SPARSE_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -ErrorAction SilentlyContinue
& "$bin\xelab.bat" tb_astra09_sparse -s astra09s -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_SPARSE_XELAB_FAIL" }
Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -ErrorAction SilentlyContinue
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra09s -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_SPARSE_XSIM_FAIL" }
Set-Location $bag
python "$bag\host_astra09_sparse.py" --compare
if ($LASTEXITCODE -ne 0) { throw "ASTRA09_SPARSE_COMPARE_FAIL" }
Write-Host "ASTRA09_SPARSE_RUN_OK"
