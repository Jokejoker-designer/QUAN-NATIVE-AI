$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
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
  (Join-Path $root "constraints\arty_a7_100.xdc"),
  (Join-Path $bag "run_synth.tcl")
)
$shaPath = Join-Path $bag "SHA256_SYNTH.txt"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$lines = @("# SHA freeze BEFORE synth $stamp")
foreach ($f in $files) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_SYNTH_FILE_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
[System.IO.File]::WriteAllLines($shaPath, $lines)
Set-Location $bag
& $vivado -mode batch -source (Join-Path $bag "run_synth.tcl") -log (Join-Path $bag "vivado_synth.log") -journal (Join-Path $bag "vivado_synth.jou")
if ($LASTEXITCODE -ne 0) { throw "WRAP_XSIM_SYNTH_FAIL" }
if (-not (Select-String -Path (Join-Path $bag "vivado_synth.log") -Pattern "WRAP_XSIM_SYNTH_DONE" -Quiet)) {
  throw "WRAP_XSIM_SYNTH_DONE_MISSING"
}
Write-Host "ASTRA_SOC_RTP_WRAP_SYNTH_OK"
