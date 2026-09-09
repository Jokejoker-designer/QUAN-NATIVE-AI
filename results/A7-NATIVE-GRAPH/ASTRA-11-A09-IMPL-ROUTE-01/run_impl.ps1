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
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.sv"),
  (Join-Path $bag "a7ng_astra_11_a09_impl_wrap.sv"),
  (Join-Path $bag "clk50_impl.xdc"),
  (Join-Path $bag "run_impl.tcl")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh")
)
$prov = @(
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_warm_persist.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r2_evict_highid.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r3_multi_slot.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r4_sess_reuse.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r3_sem_guard.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r4_axi_drain.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r5_txn_wrap.sv")
)
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "A11A09_FILE_MISSING $p" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
  return "$h  $(Rel $p)"
}
foreach ($f in $compiled) {
  $bn = [IO.Path]::GetFileName($f)
  if ($bn -eq "a7ng_astra09_pipe.sv" -or $bn -eq "uart_rx.sv" -or $bn -eq "uart_tx.sv" -or $bn -match "pipe_r1|plant128|axi_bram128") {
    throw "FORBIDDEN_DUT_IN_COMPILE_LIST $f"
  }
}
$shaPath = Join-Path $bag "SHA256.txt"
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$lines = @("# SHA freeze BEFORE impl $stamp", "# COMPILED (vivado read_verilog / read_xdc / this tcl)")
foreach ($f in $compiled) { $lines += (ShaLine $f) }
$lines += "# TRANSITIVE_INCLUDES"
foreach ($f in $includes) { $lines += (ShaLine $f) }
$lines += "# CONFIG"
$lines += (ShaLine (Join-Path $bag "PREREG.md"))
$lines += (ShaLine (Join-Path $bag "ACK.json"))
$lines += (ShaLine (Join-Path $bag "run_impl.ps1"))
$lines += "# KEEP_NOT_THIS_WRAPPER (hashed; not copy-paste; astra09_pipe / axi_bram128 / UART not compiled)"
$lines += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"))
$lines += (ShaLine (Join-Path $root "rtl\native_graph\memory\a7ng_axi_bram128.sv"))
$lines += "# PROVENANCE frozen persist/R2/R3/R4/F2R3/F2R4/F2R5 (not compiled; do not edit)"
foreach ($f in $prov) { $lines += (ShaLine $f) }
[System.IO.File]::WriteAllLines($shaPath, $lines)
Copy-Item $shaPath (Join-Path $bag "SOURCE_HASHES.txt") -Force
Write-Host "A11A09_SHA_FROZEN $shaPath"
if (-not (Test-Path -LiteralPath $vivado)) { throw "A11A09_VIVADO_NOT_FOUND $vivado" }

function Invoke-A11A09Vivado {
  param([string]$LogName)
  $log = Join-Path $bag $LogName
  $jou = Join-Path $bag "vivado.jou"
  $tcl = Join-Path $bag "run_impl.tcl"
  Set-Location $bag
  cmd /c "`"$vivado`" -mode batch -notrace -source `"$tcl`" -log `"$log`" -journal `"$jou`""
  return [int]$LASTEXITCODE
}

$exit = Invoke-A11A09Vivado "vivado.log"
$done = $false
if (Test-Path -LiteralPath (Join-Path $bag "vivado.log")) {
  $done = [bool](Select-String -Path (Join-Path $bag "vivado.log") -Pattern "ASTRA_11_A09_IMPL_ROUTE_DONE" -Quiet)
}
if (($exit -ne 0) -or (-not $done)) {
  $r0 = Join-Path $bag "vivado_fail_r0.log"
  if (Test-Path -LiteralPath (Join-Path $bag "vivado.log")) {
    Copy-Item (Join-Path $bag "vivado.log") $r0 -Force
  }
  Write-Host "A11A09_IMPL_FAIL_R0 exit=$exit done=$done one bounded re-run"
  $exit2 = Invoke-A11A09Vivado "vivado_r1.log"
  $done2 = $false
  if (Test-Path -LiteralPath (Join-Path $bag "vivado_r1.log")) {
    $done2 = [bool](Select-String -Path (Join-Path $bag "vivado_r1.log") -Pattern "ASTRA_11_A09_IMPL_ROUTE_DONE" -Quiet)
    Copy-Item (Join-Path $bag "vivado_r1.log") (Join-Path $bag "vivado.log") -Force
  }
  if (($exit2 -ne 0) -or (-not $done2)) {
    throw "A11A09_IMPL_FAIL_AFTER_R1 exit=$exit2 done=$done2"
  }
}
$postStamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$post = @("# SHA verify AFTER impl $postStamp")
foreach ($f in $compiled) { $post += (ShaLine $f) }
foreach ($f in $includes) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
Write-Host "ASTRA_11_A09_IMPL_ROUTE_RUN_OK"
