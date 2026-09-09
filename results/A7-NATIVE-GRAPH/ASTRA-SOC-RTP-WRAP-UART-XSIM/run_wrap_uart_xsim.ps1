$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$glbl = "C:\2026.1\Vivado\data\verilog\src\glbl.v"
$stub = Join-Path $bag "mmcm_stub.sv"
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
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  (Join-Path $root "rtl\board\arty_a7_astra_rtp_soc_top.sv"),
  (Join-Path $bag "tb_astra_soc_rtp_wrap_uart.sv")
)
$keep = @(
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"),
  (Join-Path $root "rtl\board\arty_a7_astra09_soc_top.sv")
)
foreach ($f in $files) {
  $bn = [IO.Path]::GetFileName($f)
  if ($bn -match "astra09|pipe_r1|plant128") {
    throw "FORBIDDEN_DUT_IN_COMPILE_LIST $f"
  }
}

$shaPath = Join-Path $bag "SHA256.txt"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$lines = @("# SHA freeze BEFORE xvlog $stamp", "# COMPILED (xvlog DUT + TB)")
foreach ($f in $files) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_UART_XSIM_FILE_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
if (-not (Test-Path -LiteralPath $stub)) { throw "WRAP_UART_XSIM_STUB_MISSING $stub" }
$hStub = (Get-FileHash -Algorithm SHA256 -LiteralPath $stub).Hash.ToLowerInvariant()
$relStub = $stub.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
$lines += "# STUB_ON_DISK (xvlog only if unisim xelab fails)"
$lines += "$hStub  $relStub"
$lines += "# KEEP_NOT_COMPILED (frozen 09; not this DUT)"
foreach ($f in $keep) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_UART_XSIM_KEEP_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
[System.IO.File]::WriteAllLines($shaPath, $lines)
Write-Host "SHA256_FROZEN $shaPath"

& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "WRAP_UART_XSIM_XVLOG_FAIL" }
if (-not (Test-Path -LiteralPath $glbl)) { throw "WRAP_UART_XSIM_GLBL_MISSING $glbl" }
& "$bin\xvlog.bat" $glbl
if ($LASTEXITCODE -ne 0) { throw "WRAP_UART_XSIM_GLBL_XVLOG_FAIL" }

$mmcmMode = "UNISIM_MMCME2_BASE"
& "$bin\xelab.bat" tb_astra_soc_rtp_wrap_uart glbl -s wrapuart -timescale 1ns/1ps -L unisims_ver --debug typical
if ($LASTEXITCODE -ne 0) {
  Write-Host "UNISIM_XELAB_FAIL trying MMCM_STUB"
  $mmcmMode = "MMCM_STUB"
  & "$bin\xvlog.bat" --sv $stub
  if ($LASTEXITCODE -ne 0) { throw "WRAP_UART_XSIM_STUB_XVLOG_FAIL" }
  & "$bin\xelab.bat" tb_astra_soc_rtp_wrap_uart glbl -s wrapuart -timescale 1ns/1ps --debug typical
  if ($LASTEXITCODE -ne 0) { throw "WRAP_UART_XSIM_XELAB_FAIL" }
}
$modePath = Join-Path $bag "MMCM_MODE.txt"
@(
  "MMCM_MODE=$mmcmMode",
  "NOT_SILICON_MMCM=1",
  "PROGRAM=NO"
) | Set-Content -LiteralPath $modePath -Encoding ascii
Write-Host "MMCM_MODE $mmcmMode"

$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" wrapuart -R --onerror quit -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "WRAP_UART_XSIM_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_SOC_RTP_WRAP_UART_XSIM_PASS" -Quiet)) {
  throw "WRAP_UART_XSIM_PASS_MARKER_MISSING"
}
Write-Host "ASTRA_SOC_RTP_WRAP_UART_XSIM_RUN_OK"
