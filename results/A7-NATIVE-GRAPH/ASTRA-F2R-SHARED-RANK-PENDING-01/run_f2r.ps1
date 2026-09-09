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
$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_struct_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_v1_f2r.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_f2r_rank.sv"),
  (Join-Path $bag "tb_astra_f2r.sv")
)
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "F2R_FILE_MISSING $p" }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
  return "$h  $(Rel $p)"
}
$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @("# SHA freeze BEFORE xvlog $stamp", "# COMPILED (xvlog DUT + TB)")
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += "# CONFIG"
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_f2r.ps1"))
$pre += "# PROVENANCE immutable sequential v1 (not compiled; F2R is a named copy)"
$pre += (ShaLine (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_v1.sv"))
$shaPre = Join-Path $bag "SHA256.txt"
[System.IO.File]::WriteAllLines($shaPre, $pre)
Write-Host "F2R_SHA_FROZEN $shaPre"

Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) { throw "F2R_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog_dut.log") -Force
& "$bin\xelab.bat" tb_astra_f2r -s f2r -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "F2R_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" f2r -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "F2R_XSIM_FAIL" }
if (-not (Select-String -Path $xsimLog -Pattern "ASTRA_F2R_XSIM_PASS" -Quiet)) { throw "F2R_PASS_MARKER_MISSING" }

$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
Write-Host "ASTRA_F2R_RUN_OK"
