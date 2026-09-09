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
  (Join-Path $root "rtl\native_graph\memory\a7ng_axi_bram128.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_rel_engine_2hop.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_rtp_pipe_r2.sv"),
  (Join-Path $bag "tb_astra_soc_rtp_wrap.sv")
)

$shaPath = Join-Path $bag "SHA256.txt"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$lines = @("# SHA freeze BEFORE xvlog $stamp")
foreach ($f in $files) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_XSIM_FILE_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
[System.IO.File]::WriteAllLines($shaPath, $lines)

& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "WRAP_XSIM_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_soc_rtp_wrap -s wrapxsim -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "WRAP_XSIM_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" wrapxsim -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "WRAP_XSIM_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_SOC_RTP_WRAP_XSIM_PASS" -Quiet)) {
  throw "WRAP_XSIM_PASS_MARKER_MISSING"
}
Write-Host "ASTRA_SOC_RTP_WRAP_XSIM_RUN_OK"
