$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_struct_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_v1.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_rtp_f2t.sv"),
  (Join-Path $bag "tb_astra_f2t.sv")
)
& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "F2T_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_f2t -s f2t -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "F2T_XELAB_FAIL" }
$log = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" f2t -R -log $log
if ($LASTEXITCODE -ne 0) { throw "F2T_XSIM_FAIL" }
if (-not (Select-String -Path $log -Pattern "ASTRA_RTP_F2T_XSIM_PASS" -Quiet)) { throw "F2T_PASS_MARKER_MISSING" }
Write-Host "ASTRA_RTP_F2T_RUN_OK"
