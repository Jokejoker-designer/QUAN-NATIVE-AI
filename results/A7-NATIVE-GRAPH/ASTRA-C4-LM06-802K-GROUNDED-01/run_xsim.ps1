$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"
$lm = Join-Path $root "rtl\lm"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C4K_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv" = "e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv" = "a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8"
  "rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv" = "b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac"
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/lm/tiny_gpt803k_core.sv" = "dee6d811a63ed65b4d93040eb7ee567bb76d65f49c68d1e701697575df6e7b86"
  "rtl/lm/a7lm06_pkg.sv" = "77b01cbdc4654cf192f35ce6cc378ddec63c35729be7ab2d2ea22e98b878aed5"
  "rtl/native_graph/integrate/a7ng_astra_c4_lm06_byte256.sv" = "f63f35ad5d33210f9387eaba3456105adf222b6e0e9c5c62d78d9e2e2eb8c926"
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
if ($hashFail) { throw "C4K_HASH_GATE_FAIL do_not_edit_keep_or_frozen_lm06" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_lm06_802k_grounded.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_802k_grounded.sv"
$svh = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_802k_grounded.svh"
$b256 = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256.sv"
$hex = Join-Path $root "tests\xsim\a7lm06_wmem.hex"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4K_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4K_GOLD_HASH_DRIFT GOLDEN.json" }
$hexH = Sha256 $hex
if ($hexH -ne "c204e55909d99370387c479c74e28c15f285fddee20239459d7c0ec3373001e0") {
  throw "C4K_CHECKPOINT_SHA_DRIFT $hexH"
}

$files = @(
  (Join-Path $lm "a7lm06_pkg.sv"),
  (Join-Path $lm "weight_bram803k.sv"),
  (Join-Path $lm "weight_tile803k.sv"),
  (Join-Path $lm "act_ram128k16.sv"),
  (Join-Path $lm "snap_ram4k16.sv"),
  (Join-Path $lm "isqrt32.sv"),
  (Join-Path $lm "floordiv_s48.sv"),
  (Join-Path $lm "tiny_gpt803k_core.sv"),
  $b256,
  $dut,
  $tb
)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "a7ng_evidence_compose.sv") { throw "C4K_COMPOSE_RENDERER_AS_DUT" }
  if ($leaf -match "a7ng_astra_09_integ_path") { throw "C4K_LEFTOVER_A09" }
  if ($leaf -eq "a7ng_query_axi_sparse_stream_intersect.sv") { throw "C4K_STREAM02_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C4_MASTER=OPEN LM06_BYTE256=NOT_FROZEN",
  "# LAW=tiny_gpt803k_core SIM_FULL + BYTE256; compose not DUT; 90pct not this-gate"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine $svh)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += (ShaLine $hex)
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C4K_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item $hex (Join-Path $work "a7lm06_wmem.hex") -Force
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C4K_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $inci -i $lm -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C4K_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -notmatch "tiny_gpt803k_core") { throw "C4K_TINYGPT_NOT_ANALYZED" }
if ($xvlogTxt -match "a7ng_evidence_compose") { throw "C4K_COMPOSE_COMPILED" }
if ($xvlogTxt -match "a7ng_astra_09_integ_path") { throw "C4K_A09_COMPILED" }
& "$bin\xelab.bat" tb_astra_c4_lm06_802k_grounded -s c4k -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C4K_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4k -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
$missing = @()
$need = @(
  "CLASS_tinygpt803k_dut HIT",
  "CLASS_not_compose_renderer HIT",
  "CLASS_path_evid_lm_feedback_eos HIT",
  "CLASS_host_next_token_zero HIT",
  "CLASS_eos_or_max HIT",
  "CLASS_acc_reported HIT"
)
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "^ASTRA_C4_LM06_802K_GROUNDED_XSIM_PASS$" -Quiet)
  foreach ($n in $need) {
    if (-not [bool](Select-String -Path $xsimLog -Pattern ([regex]::Escape($n)) -Quiet)) { $missing += $n }
  }
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or ($missing.Count -gt 0)) {
  if (Test-Path -LiteralPath $xsimLog) {
    $r0 = Join-Path $bag "xsim_fail_r0.log"
    if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  }
  throw "C4K_XSIM_FAIL pass=$hasPass exit=$xsimExit missing=$($missing -join ',')"
}
Write-Host "ASTRA_C4_LM06_802K_GROUNDED_RUN_OK PASS_THIS_GATE_ONLY PROGRAM=NO C4_MASTER=OPEN"
