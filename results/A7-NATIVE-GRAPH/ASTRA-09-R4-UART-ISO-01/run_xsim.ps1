$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$glbl = "C:\2026.1\Vivado\data\verilog\src\glbl.v"
$stub = Join-Path $bag "mmcm_stub.sv"
$work = Join-Path $bag "xsim_work"
$frozenA09 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.sv"
$frozenR2  = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.sv"
$frozenSgd = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
$expectA09 = "9fdbe0d642dd5f36d1c43626de71a125cfbf7725ffa9dd81e920ecfebb5c776c"
$expectR2  = "15a919f19226bad2c8dc87f7862246a3869643db022303338cca5f8d8b70ee23"
$expectSgd = "b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac"
$liveA09 = (Get-FileHash -Algorithm SHA256 -LiteralPath $frozenA09).Hash.ToLowerInvariant()
$liveR2  = (Get-FileHash -Algorithm SHA256 -LiteralPath $frozenR2).Hash.ToLowerInvariant()
$liveSgd = (Get-FileHash -Algorithm SHA256 -LiteralPath $frozenSgd).Hash.ToLowerInvariant()
if ($liveA09 -ne $expectA09) { throw "A09R4_FROZEN_A09_HASH_CHANGED $liveA09" }
if ($liveR2  -ne $expectR2)  { throw "A09R4_FROZEN_R2_HASH_CHANGED $liveR2" }
if ($liveSgd -ne $expectSgd) { throw "A09R4_FROZEN_SGD_HASH_CHANGED $liveSgd" }
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
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.sv"),
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  (Join-Path $bag "a7ng_astra_09_r4_uart_iso_wrap.sv"),
  (Join-Path $bag "tb_astra_09_r4_uart_iso.sv")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_lexicon.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_r2_cand_ovf.svh")
)
$keep = @(
  $frozenA09,
  (Join-Path $root "rtl\board\arty_a7_astra_rtp_soc_top.sv"),
  (Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-09-R3-UART-XSIM-01\a7ng_astra_09_r3_uart_wrap.sv")
)
foreach ($f in $files) {
  $bn = [IO.Path]::GetFileName($f)
  if ($bn -match "astra_09_integ_path|astra_rtp_soc_top|astra09_pipe|astra_09_r3_uart") {
    throw "FORBIDDEN_DUT_IN_COMPILE_LIST $f"
  }
}
function Rel([string]$p) {
  return $p.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
}
function ShaLine([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "A09R4_FILE_MISSING $p" }
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
$pre += "# STUB_ON_DISK (xvlog only if unisim xelab fails)"
$pre += (ShaLine $stub)
$pre += "# KEEP_NOT_COMPILED (frozen leftover A09 + R3 UART wrap; not this DUT)"
foreach ($f in $keep) { $pre += (ShaLine $f) }
$pre += "# PROVENANCE frozen A09/SGD/R2 (not edited)"
$pre += (ShaLine $frozenA09)
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_09_integ_path.svh"))
$pre += (ShaLine $frozenSgd)
$pre += (ShaLine $frozenR2)
$shaPre = Join-Path $bag "SHA256.txt"
[System.IO.File]::WriteAllLines($shaPre, $pre)
Copy-Item $shaPre (Join-Path $bag "SOURCE_HASHES.txt") -Force
Write-Host "A09R4_SHA_FROZEN $shaPre PROGRAM=NO PRODUCTION_TOP=UNKNOWN"
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "A09R4_XVLOG_NOT_FOUND" }

Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci $files
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xvlog.log")) {
    Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
    $r0 = Join-Path $bag "xvlog_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) {
      Copy-Item (Join-Path $work "xvlog.log") $r0 -Force
    }
  }
  throw "A09R4_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
if (-not (Test-Path -LiteralPath $glbl)) { throw "A09R4_GLBL_MISSING $glbl" }
& "$bin\xvlog.bat" $glbl
if ($LASTEXITCODE -ne 0) { throw "A09R4_GLBL_XVLOG_FAIL" }

$mmcmMode = "UNISIM_MMCME2_BASE"
& "$bin\xelab.bat" tb_astra_09_r4_uart_iso glbl -s a09r4iso -timescale 1ns/1ps -L unisims_ver --debug typical
if ($LASTEXITCODE -ne 0) {
  Write-Host "UNISIM_XELAB_FAIL trying MMCM_STUB"
  $mmcmMode = "MMCM_STUB"
  & "$bin\xvlog.bat" --sv $stub
  if ($LASTEXITCODE -ne 0) { throw "A09R4_STUB_XVLOG_FAIL" }
  & "$bin\xelab.bat" tb_astra_09_r4_uart_iso glbl -s a09r4iso -timescale 1ns/1ps --debug typical
  if ($LASTEXITCODE -ne 0) {
    if (Test-Path (Join-Path $work "xelab.log")) {
      Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
    }
    throw "A09R4_XELAB_FAIL"
  }
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
@(
  "MMCM_MODE=$mmcmMode",
  "NOT_SILICON_MMCM=1",
  "PROGRAM=NO",
  "PRODUCTION_TOP=UNKNOWN"
) | Set-Content -LiteralPath (Join-Path $bag "MMCM_MODE.txt") -Encoding ascii
Write-Host "MMCM_MODE $mmcmMode"

$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" a09r4iso -R --onerror quit -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
foreach ($f in $includes) { $post += (ShaLine $f) }
$post += (ShaLine $frozenA09)
$post += (ShaLine $frozenR2)
$post += (ShaLine $frozenSgd)
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_09_R4_UART_ISO_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) {
      Copy-Item $xsimLog $r0 -Force
    }
  }
  throw "A09R4_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_09_R4_UART_ISO_RUN_OK PROGRAM=NO PRODUCTION_TOP=UNKNOWN"
