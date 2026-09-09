$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
$expectA09 = "9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c"
$expectR2  = "15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23"
$expectSgd = "b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac"
$expectRx  = "8e802d0b4f7466d7683c9b0109d6666ba5b5d77cf67e45f5ab7c0564bcd5369a"
$expectTx  = "b4b7d09758cc95bb52a382bf5c11b5861ddcf0f74055d478824386531b36367b"
$frozenA09 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.sv"
$r2dut     = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.sv"
$sgd       = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
$uartRx    = Join-Path $root "rtl\board\uart_rx.sv"
$uartTx    = Join-Path $root "rtl\board\uart_tx.sv"
$liveA09 = (Get-FileHash -Algorithm SHA256 -LiteralPath $frozenA09).Hash.ToLowerInvariant()
$liveR2  = (Get-FileHash -Algorithm SHA256 -LiteralPath $r2dut).Hash.ToLowerInvariant()
$liveSgd = (Get-FileHash -Algorithm SHA256 -LiteralPath $sgd).Hash.ToLowerInvariant()
$liveRx  = (Get-FileHash -Algorithm SHA256 -LiteralPath $uartRx).Hash.ToLowerInvariant()
$liveTx  = (Get-FileHash -Algorithm SHA256 -LiteralPath $uartTx).Hash.ToLowerInvariant()
if ($liveA09 -ne $expectA09) { throw "A11A09R3_IOBFF_FROZEN_A09_HASH_CHANGED $liveA09" }
if ($liveR2  -ne $expectR2)  { throw "A11A09R3_IOBFF_DUT_HASH_CHANGED $liveR2" }
if ($liveSgd -ne $expectSgd) { throw "A11A09R3_IOBFF_SGD_HASH_CHANGED $liveSgd" }
if ($liveRx  -ne $expectRx)  { throw "A11A09R3_IOBFF_UART_RX_HASH_CHANGED $liveRx" }
if ($liveTx  -ne $expectTx)  { throw "A11A09R3_IOBFF_UART_TX_HASH_CHANGED $liveTx" }
$compiled = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_struct_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.sv"),
  $uartRx,
  $uartTx,
  (Join-Path $bag "a7ng_astra_11_a09r3_uart_iobff_plant.sv"),
  (Join-Path $bag "a7ng_astra_11_a09r3_uart_iobff_wrap.sv"),
  (Join-Path $bag "clk50_uart_iobff.xdc"),
  (Join-Path $bag "run_impl.tcl")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.svh")
)
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "A11A09R3_FILE_MISSING $p" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
  return "$h  $(Rel $p)"
}
foreach ($f in $compiled) {
  $bn = [IO.Path]::GetFileName($f)
  if ($bn -eq "a7ng_astra09_pipe.sv" -or $bn -eq "a7ng_astra_09_integ_path.sv" -or $bn -eq "arty_a7_astra09_soc_top.sv" -or $bn -eq "arty_a7_astra_rtp_soc_top.sv" -or $bn -eq "a7ng_astra_09_r3_uart_wrap.sv" -or $bn -eq "a7ng_astra_11_a09r3_uart_impl_wrap.sv" -or $bn -eq "a7ng_astra_11_a09r3_uart_iodelay_wrap.sv" -or $bn -match "pipe_r1|plant128|axi_bram128") {
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
$lines += "# KEEP_NOT_THIS_WRAPPER (hashed; not copy-paste; leftover A09 / astra09_pipe / axi_bram128 / RTP SoC / XSim wrap / prior UART bags not compiled)"
$lines += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra09_pipe.sv"))
$lines += (ShaLine (Join-Path $root "rtl\native_graph\memory\a7ng_axi_bram128.sv"))
$lines += (ShaLine $frozenA09)
$lines += (ShaLine (Join-Path $root "rtl\board\arty_a7_astra_rtp_soc_top.sv"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R2-IMPL-ROUTE-01\a7ng_astra_11_a09r2_impl_wrap.sv"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R3-UART-IMPL-ROUTE-01\a7ng_astra_11_a09r3_uart_impl_wrap.sv"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R3-UART-IMPL-ROUTE-01\clk50_uart_impl.xdc"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R3-UART-IODELAY-01\a7ng_astra_11_a09r3_uart_iodelay_wrap.sv"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R3-UART-IODELAY-01\clk50_uart_iodelay.xdc"))
$lines += (ShaLine (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-09-R3-UART-XSIM-01\a7ng_astra_09_r3_uart_wrap.sv"))
$lines += "# PROVENANCE frozen persist/R2/R3/R4/F2R3/F2R4/F2R5 (not compiled; do not edit)"
$prov = @(
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_warm_persist.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r2_evict_highid.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r3_multi_slot.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r4_sess_reuse.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r3_sem_guard.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r4_axi_drain.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r5_txn_wrap.sv")
)
foreach ($f in $prov) { $lines += (ShaLine $f) }
[System.IO.File]::WriteAllLines($shaPath, $lines)
Copy-Item $shaPath (Join-Path $bag "SOURCE_HASHES.txt") -Force
Write-Host "A11A09R3_IOBFF_SHA_FROZEN $shaPath"
if (-not (Test-Path -LiteralPath $vivado)) { throw "A11A09R3_IOBFF_VIVADO_NOT_FOUND $vivado" }

$log = Join-Path $bag "vivado.log"
$jou = Join-Path $bag "vivado.jou"
$tcl = Join-Path $bag "run_impl.tcl"
Set-Location $bag
cmd /c "`"$vivado`" -mode batch -notrace -source `"$tcl`" -log `"$log`" -journal `"$jou`""
$exit = [int]$LASTEXITCODE
$done = $false
if (Test-Path -LiteralPath $log) {
  $done = [bool](Select-String -Path $log -Pattern "ASTRA_11_A09R3_UART_IOBFF_DONE" -Quiet)
}
if (($exit -ne 0) -or (-not $done)) {
  $r0 = Join-Path $bag "vivado_fail_r0.log"
  if (Test-Path -LiteralPath $log) { Copy-Item $log $r0 -Force }
  throw "A11A09R3_IOBFF_IMPL_FAIL exit=$exit done=$done"
}
$postStamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$post = @("# SHA verify AFTER impl $postStamp")
foreach ($f in $compiled) { $post += (ShaLine $f) }
foreach ($f in $includes) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
Write-Host "ASTRA_11_A09R3_UART_IOBFF_RUN_OK"
