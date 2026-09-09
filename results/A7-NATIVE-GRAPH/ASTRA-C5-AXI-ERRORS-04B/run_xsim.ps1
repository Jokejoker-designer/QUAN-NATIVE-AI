$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C5RESP_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv" = "c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922"
  "rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv" = "1fbdc00a4e040b2ffd925dfc8477129f4c14247768ceb0c73cbf3a31d5f2503b"
  "rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv" = "cfb896325a0911c37281c217cff17878d329627f83a2f794f443131c1b530dfc"
  "rtl/native_graph/integrate/a7ng_astra_c5_ddr_arb.sv" = "00f58cf58dcbadcbefd9a7e80fea09917ba1fa2b2cd367fc85fee461c711aa82"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top_stream.sv" = "0bd48fe1228065bf0c8e12fee7cc3244784bed861f781ed9bbbc4c51b755989c"
}

$hashFail = $false
$hashLines = @()
foreach ($rel in $expect.Keys) {
  $p = Join-Path $root ($rel.Replace('/', '\'))
  $h = Sha256 $p
  $hashLines += "$h  $rel"
  if ($h -ne $expect[$rel]) {
    Write-Host "HASH_MISMATCH $rel live=$h expected=$($expect[$rel])"
    $hashFail = $true
  } else {
    Write-Host "HASH_MATCH $rel"
  }
}
if ($hashFail) { throw "C5RESP_HASH_GATE_FAIL do_not_edit_keep_or_live_prod_top" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c5_axi_errors_04b.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top_resp.sv"
$ckpt = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C5RESP_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C5RESP_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_grounded_gen.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_ddr_arb.sv"),
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  $ckpt,
  $dut,
  $tb
)

foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C5RESP_LIVE_PROD_TOP_COMPILED" }
  if ($leaf -eq "a7ng_astra_c2_persist_commit.sv") { throw "C5RESP_C2_COMPILED_ON_SAME_MAP" }
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C5RESP_FROZEN_LM06_AS_DUT" }
  if ($leaf -eq "mig_7series_0_mig.v") { throw "C5RESP_SYNTH_MIG_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C5_MASTER=OPEN 04B=XSIM MIG=NO"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top_resp.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"))
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "tb_oracles.svh"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C5RESP_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C5RESP_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C5RESP_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c5_axi_errors_04b -s c5resp -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C5RESP_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c5resp -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
$post += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top.sv"))
$post += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_ddr_arb.sv"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C5_AXI_ERRORS_04B_XSIM_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  }
  throw "C5RESP_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass"
}
Write-Host "ASTRA_C5_AXI_ERRORS_04B_RUN_OK"
