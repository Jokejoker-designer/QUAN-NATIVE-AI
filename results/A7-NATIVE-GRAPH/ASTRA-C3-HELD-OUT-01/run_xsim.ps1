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
  if (-not (Test-Path -LiteralPath $p)) { throw "C3HO_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv" = "09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv" = "5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa"
  "rtl/native_graph/query/a7ng_route_valid_gate.sv" = "49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385"
  "rtl/native_graph/query/a7ng_query_role_keys_ctx.sv" = "124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv" = "8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv" = "14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac"
  "rtl/native_graph/query/qse_relctx_synonym_01.svh" = "551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd"
  "rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv" = "e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv" = "a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8"
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
if ($hashFail) { throw "C3HO_HASH_GATE_FAIL do_not_edit_keep_rtl" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c3_held_out.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.sv"
$svh = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.svh"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C3HO_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C3HO_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv"),
  $dut,
  $tb
)

foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -match "a7ng_astra_09_integ_path") { throw "C3HO_LEFTOVER_A09" }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") { throw "C3HO_C0_SPARSE_AS_DUT" }
  if ($leaf -eq "a7ng_query_axi_sparse_stream_intersect.sv") { throw "C3HO_STREAM02_AS_DUT" }
  if ($leaf -eq "a7ng_query_axi_sparse_intersect_context.sv") { throw "C3HO_CTX_8255a798_AS_DUT" }
  if ($leaf -eq "a7ng_learned_prior_store.sv") { throw "C3HO_PRIOR_STORE" }
  if ($leaf -eq "a7ng_astra_06_warm_persist.sv") { throw "C3HO_ASTRA06" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C3_MASTER=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN",
  "# LAW=qse-v2-relctx-synonym-01 + native-rank-sgd-q8-v1-sym-f2r2 CAND_CAP=16 POKE_V=0",
  "# HASH_GATE MATCH vs C0/C1 KEEP (C0 sparse hashed, not compiled as DUT)"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine $svh)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "tb_oracles.svh"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C3HO_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C3HO_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C3HO_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c3_held_out -s c3ho -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C3HO_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c3ho -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C3_HELD_OUT_XSIM_PASS" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  }
  throw "C3HO_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C3_HELD_OUT_RUN_OK"
