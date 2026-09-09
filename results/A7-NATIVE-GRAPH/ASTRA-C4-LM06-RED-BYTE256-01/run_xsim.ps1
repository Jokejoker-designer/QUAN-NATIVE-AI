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
  if (-not (Test-Path -LiteralPath $p)) { throw "C4L_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/integrate/a7ng_astra_c4_lm06_grounded_gen.sv" = "1fbdc00a4e040b2ffd925dfc8477129f4c14247768ceb0c73cbf3a31d5f2503b"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv" = "c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922"
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
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
$hex = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_red.hex"
$hexH = Sha256 $hex
$hashLines += "$hexH  rtl/native_graph/integrate/a7ng_astra_c4_lm06_red.hex"
Write-Host "HEX $hexH"
if ($hexH -ne "74b5f885da98382db924c0b2a7e002b126d6517330c23ce164e62695ccdade1d") {
  throw "C4L_HEX_DRIFT $hexH"
}
if ($hashFail) { throw "C4L_HASH_GATE_FAIL do_not_edit_keep" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c4_lm06_red_byte256.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_red.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C4L_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C4L_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @($dut, $tb)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C4L_FROZEN_LM06_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C4L_LIVE_PROD_TOP_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c4_lm06_grounded_gen.sv") { throw "C4L_KEEP_GEN_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c4_lm06_byte256.sv") { throw "C4L_OLD_ADAPTER_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C4_MASTER=OPEN RIVAL2=LM06_RED TINYGPT=NOT_USED"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_red.svh"))
$pre += (ShaLine $hex)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "CKPT_PROVENANCE.json"))
$pre += (ShaLine (Join-Path $bag "gen_ckpt.py"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C4L_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item $hex (Join-Path $work "a7ng_astra_c4_lm06_red.hex") -Force
Set-Location $work
if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C4L_XVLOG_NOT_FOUND" }
& "$bin\xvlog.bat" --sv -i $inci -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C4L_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c4_lm06_red_byte256 -s c4lred -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C4L_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c4lred -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
$post += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_grounded_gen.sv"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
$need = @(
  "CLASS_prefix_changes HIT",
  "CLASS_evidence_changes HIT",
  "CLASS_safe_no HIT",
  "CLASS_seq_ge3 HIT",
  "CLASS_zero_changes HIT",
  "CLASS_host_tok0 HIT",
  "CLASS_ref_match HIT",
  "ASTRA_C4_LM06_RED_BYTE256_XSIM_PASS"
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
  throw "C4L_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass"
}
Write-Host "ASTRA_C4_LM06_RED_BYTE256_RUN_OK"
