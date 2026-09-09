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
  (Join-Path $root "rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_rtp_pipe.sv"),
  (Join-Path $bag "tb_astra_rtp.sv")
)
& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "RTP_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -ErrorAction SilentlyContinue
& "$bin\xelab.bat" tb_astra_rtp -s rtp -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "RTP_XELAB_FAIL" }
Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -ErrorAction SilentlyContinue
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" rtp -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "RTP_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_RTP_XSIM_PASS" -Quiet)) { throw "RTP_PASS_MARKER_MISSING" }
Write-Host "ASTRA_RTP_RUN_OK"
