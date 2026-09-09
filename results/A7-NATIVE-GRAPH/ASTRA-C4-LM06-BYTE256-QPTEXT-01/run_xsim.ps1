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
  if (-not (Test-Path -LiteralPath $p)) { throw "C4Q_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv" = "09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv" = "5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa"
  "rtl/native_graph/query/a7ng_route_valid_gate.sv" = "49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385"
  "rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv" = "e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv" = "a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8"
  "rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv" = "b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac"
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv" = "cfb896325a0911c37281c217cff17878d329627f83a2f794f443131c1b530dfc"
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
if ($hashFail) { throw "C4Q_HASH_GATE_FAIL do_not_edit_keep_or_c3_wrap" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_lm06_byte256_qptext.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256_qptext.sv"
$gen = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256_qptext_gen.sv"
$svh = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256_qptext.svh"
$c3 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.sv"
$b256 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4Q_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4Q_GOLD_HASH_DRIFT GOLDEN.json" }

$dutTxt = [System.IO.File]::ReadAllText($dut)
$genTxt = [System.IO.File]::ReadAllText($gen)
if ($dutTxt -match "a7ng_c4d_ch") { throw "C4Q_DUT_USES_DICT_OBJ_LUT_NAME" }
if ($dutTxt -match "evid_obj") { throw "C4Q_DUT_HAS_EVID_OBJ" }
if ($genTxt -match "a7ng_c4d_ch") { throw "C4Q_GEN_USES_DICT_OBJ_LUT_NAME" }
if ($genTxt -match "evid_obj") { throw "C4Q_GEN_HAS_EVID_OBJ" }
if ($dutTxt -notmatch "a7ng_astra_c3_held_out") { throw "C4Q_DUT_MISSING_C3" }
if ($dutTxt -notmatch "a7ng_c4q_ch") { throw "C4Q_DUT_MISSING_FPGA_DICT" }

$files = @()
$files += (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv")
$files += (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv")
$files += (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv")
$files += (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv")
$files += (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv")
$files += (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv")
$files += (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv")
$files += (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv")
$files += $c3
$files += $b256
$files += $gen
$files += $dut
$files += $tb

foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C4Q_FROZEN_LM06_AS_DUT" }
  if ($leaf -eq "a7ng_evidence_compose.sv") { throw "C4Q_COMPOSE_RENDERER_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c4_lm06_byte256_dict.sv") { throw "C4Q_DICT_LUT_DUT" }
  if ($leaf -match "a7ng_astra_09_integ_path") { throw "C4Q_LEFTOVER_A09" }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") { throw "C4Q_C0_SPARSE_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C4_MASTER=OPEN LM06_BYTE256=NOT_FROZEN",
  "# LAW=C3 QUERY/PROOF FPGA dict then weight glue plus hop-2 object BYTE256"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine $svh)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C4Q_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C4Q_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C4Q_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -match "tiny_gpt803k_core") { throw "C4Q_TINYGPT_COMPILED" }
if ($xvlogTxt -match "a7ng_astra_c4_lm06_byte256_dict") { throw "C4Q_DICT_COMPILED" }
if ($xvlogTxt -notmatch "a7ng_astra_c4_lm06_byte256_qptext") { throw "C4Q_DUT_NOT_ANALYZED" }
if ($xvlogTxt -notmatch "a7ng_astra_c3_held_out") { throw "C4Q_C3_NOT_ANALYZED" }
& "$bin\xelab.bat" tb_astra_c4_lm06_byte256_qptext -s c4q -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C4Q_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4q -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "^ASTRA_C4_LM06_BYTE256_QPTEXT_XSIM_PASS$" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  }
  throw "C4Q_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C4_LM06_BYTE256_QPTEXT_RUN_OK PASS_THIS_GATE_ONLY PROGRAM=NO C4_MASTER=OPEN"
