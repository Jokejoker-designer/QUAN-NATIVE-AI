$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$old = Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-C3-HELD-OUT-800K-01"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C1C3X_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv" = "cfb896325a0911c37281c217cff17878d329627f83a2f794f443131c1b530dfc"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv" = "c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922"
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/native_graph/integrate/a7ng_astra_c5_sgd32_ckpt.sv" = "e419caef0e64d75e399a08cb66f7458eebd1591d352cff2283c804c4d650eead"
  "results/A7-NATIVE-GRAPH/ASTRA-C3-HELD-OUT-800K-01/gen_800k.svh" = "cd3273105a643e073e2b87b531419482598abbbf8a51fada916fb7a1d6972932"
  "results/A7-NATIVE-GRAPH/ASTRA-C3-HELD-OUT-800K-01/query_gold.svh" = "dafe6c39e1eff95b9a8b60290ae886800ec4e9a5d1ef373b5c5ca90b402ab394"
  "results/A7-NATIVE-GRAPH/ASTRA-C3-HELD-OUT-800K-01/a7ng_astra_c3_held_out_nb64k.sv" = "e4c85aab9b0a74c2be8b079e20f7b1546e48189e0514188bc2f0cafa70448e55"
  "results/A7-NATIVE-GRAPH/ASTRA-C3-HELD-OUT-800K-01/c3_800k_facts.svh" = "425714d431a6bfabc96b548ab226ace17b3a972cd5a1be28403c487d72729f0a"
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
if ($hashFail) { throw "C1C3X_HASH_GATE_FAIL do_not_edit_keep_or_old_law" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c1_c3_canonical_image_transfer.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C1C3X_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C1C3X_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt.sv"),
  (Join-Path $old "a7ng_astra_c3_held_out_nb64k.sv"),
  (Join-Path $old "a7ng_axi_mem_c3_800k.sv"),
  $tb
)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C1C3X_FROZEN_LM06_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C1C3X_LIVE_PROD_TOP_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c3_held_out.sv") { throw "C1C3X_KEEP_C3_WRAP_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C1_MASTER=OPEN C3_MASTER=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C1C3X_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C1C3X_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $old -i $bag -i $incq -i $incc -i $inci $files
if ($LASTEXITCODE -ne 0) { throw "C1C3X_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c1_c3_canonical_image_transfer -s c1c3x -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C1C3X_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c1c3x -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
$post += (ShaLine (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"))
$post += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.sv"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
$need = @(
  "CLASS_entities_disjoint HIT",
  "CLASS_arm_A_learner HIT",
  "CLASS_arm_B_frozen HIT",
  "CLASS_arm_C_shuffled HIT",
  "CLASS_arm_D_perid HIT",
  "CLASS_gain_A_over_B HIT",
  "CLASS_exact32_reload HIT",
  "CLASS_flush_zero HIT",
  "CLASS_retention_le5pp HIT",
  "CLASS_no_tb_w131 HIT",
  "CLASS_host_winner_zero HIT",
  "CLASS_bound_not_frozen HIT",
  "ASTRA_C1_C3_CANONICAL_IMAGE_TRANSFER_01_XSIM_PASS"
)
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = $true
  foreach ($p in $need) {
    if (-not (Select-String -Path $xsimLog -Pattern $p -Quiet)) { $hasPass = $false }
  }
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  }
  throw "C1C3X_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass"
}
Write-Host "ASTRA_C1_C3_CANONICAL_IMAGE_TRANSFER_01_RUN_OK"
