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
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_07_scale_narrow.sv"),
  (Join-Path $bag "tb_astra_07_scale_narrow.sv")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_07_scale_narrow.svh")
)
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "A07_FILE_MISSING $p" }
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
$pre += "# PROVENANCE frozen A09/SGD/persist/R2/R3/R4/F3/F2R (not edited)"
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_warm_persist.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r2_evict_highid.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r3_multi_slot.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_06_r4_sess_reuse.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r5_txn_wrap.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r4_axi_drain.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r3_sem_guard.sv"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r2_hs_law.sv"))
$shaPre = Join-Path $bag "SHA256.txt"
[System.IO.File]::WriteAllLines($shaPre, $pre)
Copy-Item $shaPre (Join-Path $bag "SOURCE_HASHES.txt") -Force
Write-Host "A07_SHA_FROZEN $shaPre"
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "A07_XVLOG_NOT_FOUND" }

Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci $files
if ($LASTEXITCODE -ne 0) { throw "A07_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog_dut.log") -Force
& "$bin\xelab.bat" tb_astra_07_scale_narrow -s a07sn -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "A07_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" a07sn -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
foreach ($f in $includes) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_07_SCALE_NARROW_XSIM_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) {
      Copy-Item $xsimLog $r0 -Force
    }
  }
  throw "A07_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_07_SCALE_NARROW_RUN_OK"
