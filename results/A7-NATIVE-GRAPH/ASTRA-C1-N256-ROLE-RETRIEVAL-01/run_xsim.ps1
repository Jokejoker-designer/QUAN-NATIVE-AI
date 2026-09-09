$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C1_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) {
  return "$(Sha256 $p)  $(Rel $p)"
}

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv" = "09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv" = "5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa"
  "rtl/native_graph/query/a7ng_route_valid_gate.sv" = "49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385"
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
if ($hashFail) {
  $stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
  $failSha = @("# SHA freeze HASH_GATE_FAIL $stamp", "# PROGRAM=NO C1_800K=OPEN") + $hashLines
  [System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $failSha)
  throw "C1_HASH_GATE_FAIL do_not_invent"
}

$goldJson = Join-Path $bag "GOLDEN.json"
$goldSvh = Join-Path $bag "query_gold.svh"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$corpus = Join-Path $bag "corpus.json"
if (-not (Test-Path -LiteralPath $goldJson)) { throw "C1_GOLD_MISSING GOLDEN.json" }
if (-not (Test-Path -LiteralPath $goldSvh)) { throw "C1_GOLD_MISSING query_gold.svh" }
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C1_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$liveSvh = Sha256 $goldSvh
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C1_GOLD_HASH_DRIFT GOLDEN.json" }
if ($preTxt -notmatch $liveSvh) { throw "C1_GOLD_HASH_DRIFT query_gold.svh" }
Write-Host "GOLD_HASH_LOCKED_BEFORE_XVLOG GOLDEN=$liveGold SVH=$liveSvh"

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_axi_mem_model.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse.sv"),
  (Join-Path $bag "tb_astra_c1_n256.sv")
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  (Join-Path $bag "query_gold.svh")
)

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO C1_800K=OPEN CAND_CAP=16 N=256 LAW_SEL=1",
  "# HASH_GATE MATCH vs C0 FINAL_CONTRACT",
  "# FROZEN_RTL"
)
foreach ($rel in @(
    "rtl/native_graph/query/a7ng_query_role_extract.sv",
    "rtl/native_graph/query/qse_role_lexicon.svh",
    "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv",
    "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv",
    "rtl/native_graph/query/a7ng_route_valid_gate.sv"
  )) {
  $p = Join-Path $root ($rel.Replace('/', '\'))
  $pre += "$(Sha256 $p)  $rel"
}
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += "# TRANSITIVE_INCLUDES"
foreach ($f in $includes) { $pre += (ShaLine $f) }
$pre += "# INDEPENDENT_GOLD_BEFORE_XVLOG"
$pre += "$liveGold  results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/GOLDEN.json"
$pre += "$liveSvh  results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/query_gold.svh"
if (Test-Path -LiteralPath $corpus) {
  $pre += "$(Sha256 $corpus)  results/A7-NATIVE-GRAPH/ASTRA-C1-N256-ROLE-RETRIEVAL-01/corpus.json"
}
$pre += "# BAG"
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += (ShaLine (Join-Path $bag "host_astra_c1.py"))
$pre += (ShaLine (Join-Path $bag "tb_astra_c1_n256.sv"))
$pre += "# FORBIDDEN leftover a7ng_astra_09_integ_path NOT on xvlog DUT list"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C1_SHA_FROZEN_BEFORE_XVLOG"

if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C1_XVLOG_NOT_FOUND" }
if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $bag $files
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xvlog.log")) {
    Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
  }
  throw "C1_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
& "$bin\xelab.bat" tb_astra_c1_n256 -s astra_c1_n256 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C1_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra_c1_n256 -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$hasPass = $false
$hasDiv = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C1_N256_XSIM_PASS" -Quiet)
  $hasDiv = [bool](Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet)
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or $hasDiv) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if ((Test-Path -LiteralPath $xsimLog) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $xsimLog $r0 -Force
  }
  throw "C1_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C1_N256_RUN_OK"
