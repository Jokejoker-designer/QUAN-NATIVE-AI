$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"
$incl = Join-Path $root "rtl\native_graph\learn"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C5P_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/native_graph/integrate/a7ng_astra_c5_prod_top.sv" = "c4fcca30c945a550f81f0870025c8d52875cd6097dfbfc459aeb1fe47a367922"
  "rtl/native_graph/integrate/a7ng_astra_c3_held_out.sv" = "cfb896325a0911c37281c217cff17878d329627f83a2f794f443131c1b530dfc"
  "rtl/native_graph/integrate/a7ng_astra_c5_sgd32_ckpt.sv" = "e419caef0e64d75e399a08cb66f7458eebd1591d352cff2283c804c4d650eead"
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
if ($hashFail) { throw "C5P_HASH_GATE_FAIL do_not_edit_keep_or_old_ckpt" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c5_pend_proof_phi.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt_pend.sv"
$sgd = Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C5P_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C5P_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @($sgd, $dut, $tb)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "a7ng_astra_c2_persist_commit.sv") { throw "C5P_C2_KEEP_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C5P_LIVE_PROD_TOP_AS_DUT" }
  if ($leaf -eq "a7ng_astra_c3_held_out.sv") { throw "C5P_C3_KEEP_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C5_MASTER=OPEN PERSIST_SCHEMA_VERSION=NOT_FROZEN"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt_pend.svh"))
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "PLAN.md"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C5P_SHA_FROZEN"

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
& "$bin\xvlog.bat" --sv -i $incc -i $inci -i $incl -i $bag $files
if ($LASTEXITCODE -ne 0) { throw "C5P_XVLOG_FAIL" }
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c5_pend_proof_phi -s c5p -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C5P_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c5p -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $files) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
$hasPass = $false
$hasEx = $false; $hasPend = $false; $hasCrc = $false; $hasSch = $false; $hasB = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C5_PEND_PROOF_PHI_XSIM_PASS" -Quiet)
  $hasEx = [bool](Select-String -Path $xsimLog -Pattern "CLASS_exact32_reload HIT" -Quiet)
  $hasPend = [bool](Select-String -Path $xsimLog -Pattern "CLASS_exact_pend_phi_reload HIT" -Quiet)
  $hasCrc = [bool](Select-String -Path $xsimLog -Pattern "CLASS_crc_no_install HIT" -Quiet)
  $hasSch = [bool](Select-String -Path $xsimLog -Pattern "CLASS_schema1_reject HIT" -Quiet)
  $hasB = [bool](Select-String -Path $xsimLog -Pattern "CLASS_bresp_no_persist HIT" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or (-not $hasEx) -or (-not $hasPend) -or (-not $hasCrc) -or (-not $hasSch) -or (-not $hasB)) {
  if (Test-Path -LiteralPath $xsimLog) {
    Copy-Item $xsimLog (Join-Path $bag "xsim_fail.log") -Force
  }
  throw "C5P_XSIM_FAIL_OR_MARKER_MISSING pass=$hasPass ex=$hasEx pend=$hasPend crc=$hasCrc sch=$hasSch b=$hasB"
}
Write-Host "ASTRA_C5_PEND_PROOF_PHI_RUN_OK"
