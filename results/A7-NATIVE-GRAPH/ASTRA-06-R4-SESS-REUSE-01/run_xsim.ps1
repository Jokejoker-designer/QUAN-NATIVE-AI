$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"
$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_struct_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r4_sess_reuse.sv"),
  (Join-Path $bag "tb_astra_06_r4_sess_reuse.sv")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r4_sess_reuse.svh")
)
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "A06R4_FILE_MISSING $p" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
  return "$h  $(Rel $p)"
}
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @("# SHA freeze BEFORE xvlog $stamp", "# COMPILED")
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += "# TRANSITIVE_INCLUDES"
foreach ($f in $includes) { $pre += (ShaLine $f) }
$pre += "# CONFIG"
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += "# PROVENANCE frozen persist/R2/R3/F3R4/F3R3/F3R2/F3/F2R5/F2R4/F2R3/F2R2 (not compiled; do not edit)"
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_warm_persist.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_warm_persist.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r2_evict_highid.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r2_evict_highid.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r3_multi_slot.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r3_multi_slot.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r4_distinct_hold_phi.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r4_distinct_hold_phi.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r3_sampled_worlds.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r3_sampled_worlds.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r2_ind_worlds.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3r2_ind_worlds.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3_shared_xfer.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f3_shared_xfer.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r5_txn_wrap.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r5_txn_wrap.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r4_axi_drain.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r4_axi_drain.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r3_sem_guard.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r2_hs_law.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_v1_f2r.sv"))
$shaPre = Join-Path $bag "SHA256.txt"
[System.IO.File]::WriteAllLines($shaPre, $pre)
Copy-Item $shaPre (Join-Path $bag "SOURCE_HASHES.txt") -Force
Write-Host "A06R4_SHA_FROZEN $shaPre"
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "A06R4_XVLOG_NOT_FOUND" }

Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci $files
if ($LASTEXITCODE -ne 0) { throw "A06R4_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog_dut.log") -Force
& "$bin\xelab.bat" tb_astra_06_r4_sess_reuse -s a06r4sr -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "A06R4_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" a06r4sr -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
foreach ($f in $includes) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_06_R4_SESS_REUSE_XSIM_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) {
      Copy-Item $xsimLog $r0 -Force
    }
  }
  throw "A06R4_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_06_R4_SESS_REUSE_RUN_OK"
