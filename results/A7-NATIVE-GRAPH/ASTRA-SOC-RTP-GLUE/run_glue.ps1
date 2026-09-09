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
  (Join-Path $root "rtl\native_graph\memory\a7ng_axi_rtp_plant128.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_rtp_pipe_r1.sv"),
  (Join-Path $bag "tb_astra_soc_rtp_glue.sv")
)
& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "SOC_RTP_GLUE_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_soc_rtp_glue -s glue -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "SOC_RTP_GLUE_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" glue -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "SOC_RTP_GLUE_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_SOC_RTP_GLUE_XSIM_PASS" -Quiet)) { throw "SOC_RTP_GLUE_PASS_MARKER_MISSING" }
Write-Host "ASTRA_SOC_RTP_GLUE_RUN_OK"
