$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$inci = Join-Path $root "rtl\native_graph\integrate"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C4LANG_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/integrate/a7ng_astra_c4_cond_rnn.sv" = "467b0a4b55c913e335eb3718d2ddcb83501faa800245b5d31fa1d1ccf4f78f8b"
  "rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv" = "1fbdc00a4e040b2ffd925dfc8477129f4c14247768ceb0c73cbf3a31d5f2503b"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv" = "c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922"
  "rtl/native_graph/integrate/a7ng_astra_c4_cond_rnn.hex" = "46b81cd7a56a3a7b95d3d031210eea1b737924f7e98b40a2dbf69b08c2712495"
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
  } else { Write-Host "HASH_MATCH $rel" }
}
if ($hashFail) { throw "C4LANG_HASH_GATE_FAIL do_not_edit_rival1_or_keep" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_cond_rnn_lang.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_cond_rnn.sv"
$hex = Join-Path $bag "a7ng_astra_c4_cond_rnn_lang.hex"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4LANG_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4LANG_GOLD_HASH_DRIFT GOLDEN.json" }
$hexH = Sha256 $hex
if ($hexH -ne "e3a1bfb48b8e7eec8701021648e6bc5bd834f9ab81fc9da465ed5c61f6d99c4c") {
  throw "C4LANG_HEX_DRIFT $hexH"
}

$files = @($dut, $tb)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C4LANG_TINYGPT_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C4LANG_LIVE_PROD_TOP_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c4_lm06_grounded_gen.sv") { throw "C4LANG_KEEP_GEN_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C4_MASTER=OPEN LM06_BYTE256=NOT_FROZEN"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_cond_rnn.svh"))
$pre += (ShaLine $hex)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "PLAN.md"))
$pre += (ShaLine (Join-Path $bag "CKPT_PROVENANCE.json"))
$pre += (ShaLine (Join-Path $bag "corpus.json"))
$pre += (ShaLine (Join-Path $bag "tb_heldout.svh"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C4LANG_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item $hex (Join-Path $work "a7ng_astra_c4_cond_rnn.hex") -Force
Set-Location $work
& "$bin\xvlog.bat" --sv -i $inci -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C4LANG_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c4_cond_rnn_lang -s c4lang -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C4LANG_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4lang -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
$post += (ShaLine $hex)
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
$hasSafe = $false
$hasHost = $false
$hasL90 = $false
$hasL95 = $false
$hasL5 = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C4_COND_RNN_LANG_XSIM_PASS" -Quiet)
  $hasSafe = [bool](Select-String -Path $xsimLog -Pattern "CLASS_safe_no HIT" -Quiet)
  $hasHost = [bool](Select-String -Path $xsimLog -Pattern "CLASS_host_tok0 HIT" -Quiet)
  $hasL90 = [bool](Select-String -Path $xsimLog -Pattern "CLASS_lang_90 (HIT|MISS)" -Quiet)
  $hasL95 = [bool](Select-String -Path $xsimLog -Pattern "CLASS_lang_safe95 (HIT|MISS)" -Quiet)
  $hasL5 = [bool](Select-String -Path $xsimLog -Pattern "CLASS_lang_hall5 (HIT|MISS)" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or (-not $hasSafe) -or (-not $hasHost) -or (-not $hasL90) -or (-not $hasL95) -or (-not $hasL5)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
  }
  throw "C4LANG_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass safe=$hasSafe host=$hasHost l90=$hasL90 l95=$hasL95 l5=$hasL5"
}
Write-Host "ASTRA_C4_COND_RNN_LANG_RUN_OK"
