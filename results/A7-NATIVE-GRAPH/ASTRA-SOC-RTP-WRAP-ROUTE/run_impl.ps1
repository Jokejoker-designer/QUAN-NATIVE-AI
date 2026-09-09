$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
$compiled = @(
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
  (Join-Path $bag "run_impl.tcl")
)
$keep = @(
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"),
  (Join-Path $root "rtl\board\arty_a7_astra09_soc_top.sv")
)
foreach ($f in $compiled) {
  $bn = [IO.Path]::GetFileName($f)
  if ($bn -match "astra09|pipe_r1|plant128") {
    throw "FORBIDDEN_DUT_IN_COMPILE_LIST $f"
  }
}
$shaPath = Join-Path $bag "SHA256.txt"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$lines = @("# SHA freeze BEFORE synth $stamp", "# COMPILED (vivado read_verilog / read_xdc / this tcl)")
foreach ($f in $compiled) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_ROUTE_FILE_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
$lines += "# KEEP_NOT_COMPILED (frozen 09; not this DUT; not read_verilog)"
foreach ($f in $keep) {
  if (-not (Test-Path -LiteralPath $f)) { throw "WRAP_ROUTE_KEEP_MISSING $f" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
  $rel = $f.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $lines += "$h  $rel"
}
[System.IO.File]::WriteAllLines($shaPath, $lines)
Write-Host "SHA256_FROZEN $shaPath"
Set-Location $bag
& $vivado -mode batch -source (Join-Path $bag "run_impl.tcl") -log (Join-Path $bag "vivado.log") -journal (Join-Path $bag "vivado.jou")
if ($LASTEXITCODE -ne 0) { throw "WRAP_ROUTE_VIVADO_FAIL exit=$LASTEXITCODE" }
if (-not (Select-String -Path (Join-Path $bag "vivado.log") -Pattern "ASTRA_SOC_RTP_WRAP_ROUTE_DONE" -Quiet)) {
  throw "WRAP_ROUTE_DONE_MARKER_MISSING"
}
Write-Host "ASTRA_SOC_RTP_WRAP_ROUTE_OK"
