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
  if (-not (Test-Path -LiteralPath $p)) { throw "C1AXIBEAT_FILE_MISSING $p" }
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
  "rtl/native_graph/query/a7ng_query_role_keys_relbind.sv" = "93811ed17adbd9c2adc1a93514faf35b23ba8184d325a7204aee90e09c77057d"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect.sv" = "a912786f6cc0be62a28c4ee1efc7aeca26fc07ae26865249191aa41d1ed6408c"
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
  $failSha = @("# SHA freeze HASH_GATE_FAIL $stamp", "# PROGRAM=NO C1_800K=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN") + $hashLines
  [System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $failSha)
  throw "C1AXIBEAT_HASH_GATE_FAIL do_not_invent"
}

$goldJson = Join-Path $bag "GOLDEN.json"
$goldSvh = Join-Path $bag "query_gold.svh"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$corpus = Join-Path $bag "corpus.json"
$tb = Join-Path $bag "tb_astra_c1_axi_beat_accounting.sv"
$probe = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_rbeat_probe.sv"
$rbKeys = Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_relbind.sv"
$ixSparse = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect.sv"
if (-not (Test-Path -LiteralPath $goldJson)) { throw "C1AXIBEAT_GOLD_MISSING GOLDEN.json" }
if (-not (Test-Path -LiteralPath $goldSvh)) { throw "C1AXIBEAT_GOLD_MISSING query_gold.svh" }
if (-not (Test-Path -LiteralPath $corpus)) { throw "C1AXIBEAT_GOLD_MISSING corpus.json" }
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C1AXIBEAT_GOLD_NOT_HASHED_BEFORE_XVLOG" }
if (-not (Test-Path -LiteralPath $probe)) { throw "C1AXIBEAT_PROBE_MISSING" }
$liveGold = Sha256 $goldJson
$liveSvh = Sha256 $goldSvh
$liveCorpus = Sha256 $corpus
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C1AXIBEAT_GOLD_HASH_DRIFT GOLDEN.json" }
if ($preTxt -notmatch $liveSvh) { throw "C1AXIBEAT_GOLD_HASH_DRIFT query_gold.svh" }
if ($preTxt -notmatch $liveCorpus) { throw "C1AXIBEAT_GOLD_HASH_DRIFT corpus.json" }
if ($liveGold -ne "d3b5b88356bd2fc691398a794b2e8b6470d7b3eef2fd56a5d7aeddab8ccb5625") {
  throw "C1AXIBEAT_GOLD_NOT_KEY_INTERSECT_COPY GOLDEN.json"
}
if ($liveSvh -ne "f16119179191036ba1eb2bd8e451e8fd6691095a08d0ec5f9ff81533a9000f55") {
  throw "C1AXIBEAT_GOLD_NOT_KEY_INTERSECT_COPY query_gold.svh"
}
if ($liveCorpus -ne "e8b4f8ea3a66bee35c0f10c8f23b91bba851933d3764696a7cd573116e300825") {
  throw "C1AXIBEAT_GOLD_NOT_KEY_INTERSECT_COPY corpus.json"
}
Write-Host "GOLD_HASH_LOCKED_BEFORE_XVLOG GOLDEN=$liveGold SVH=$liveSvh CORPUS=$liveCorpus"

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  $rbKeys,
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_axi_mem_model.sv"),
  $ixSparse,
  $probe,
  $tb
)
$includes = @(
  (Join-Path $root "rtl\native_graph\control\a7ng_gate14_crc.svh"),
  (Join-Path $root "rtl\native_graph\query\qse_role_lexicon.svh"),
  $goldSvh
)

foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -match "a7ng_astra_09_integ_path") {
    throw "C1AXIBEAT_LEFTOVER_A09_ON_XVLOG_LIST"
  }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") {
    throw "C1AXIBEAT_FROZEN_AXI_SPARSE_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_axi_sparse_relbind.sv") {
    throw "C1AXIBEAT_RELBIND_SPARSE_MUST_NOT_BE_DUT"
  }
  if ($leaf -match "stream_intersect") {
    throw "C1AXIBEAT_STREAM_INTERSECT_02_FORBIDDEN"
  }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO C1_800K=OPEN CAND_CAP=16 N=256 LAW=qse-v2-intersect-01 POKE_V=0",
  "# DDR_QUERY_BOUND_FINAL=NOT_FROZEN CAND_CAP_FINAL=NOT_FROZEN STREAM_INTERSECT_02=NOT_THIS_BAG",
  "# HASH_GATE MATCH vs C0 FINAL_CONTRACT + KEY-INTERSECT DUT (frozen files not patched)",
  "# FROZEN_RTL"
)
foreach ($rel in @(
    "rtl/native_graph/query/a7ng_query_role_extract.sv",
    "rtl/native_graph/query/qse_role_lexicon.svh",
    "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv",
    "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv",
    "rtl/native_graph/query/a7ng_route_valid_gate.sv",
    "rtl/native_graph/query/a7ng_query_role_keys_relbind.sv",
    "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect.sv"
  )) {
  $p = Join-Path $root ($rel.Replace('/', '\'))
  $pre += "$(Sha256 $p)  $rel"
}
$pre += "# NEW_NAMED_RTL"
$pre += (ShaLine $probe)
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += "# TRANSITIVE_INCLUDES"
foreach ($f in $includes) { $pre += (ShaLine $f) }
$pre += "# INDEPENDENT_GOLD_BEFORE_XVLOG (copy of KEY-INTERSECT; original KEEP)"
$pre += "$liveGold  results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/GOLDEN.json"
$pre += "$liveSvh  results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/query_gold.svh"
$pre += "$liveCorpus  results/A7-NATIVE-GRAPH/ASTRA-C1-AXI-BEAT-ACCOUNTING-01/corpus.json"
$pre += "# BAG"
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += (ShaLine $tb)
$pre += "# FORBIDDEN leftover a7ng_astra_09_integ_path NOT on xvlog DUT list"
$pre += "# FORBIDDEN frozen a7ng_query_axi_sparse.sv NOT compiled as DUT"
$pre += "# FORBIDDEN a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT"
$pre += "# FORBIDDEN qse-v2-stream-intersect-02 NOT this bag"
$pre += "# REDUCTION_X1000 NOT_EMITTED (not 1-CAND_CAP/N); RATIO_x1000 is R_BYTES*1000/AR_BYTES"
$pre += "# DDR_QUERY_BOUND_FINAL NOT_FROZEN"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C1AXIBEAT_SHA_FROZEN_BEFORE_XVLOG"

if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C1AXIBEAT_XVLOG_NOT_FOUND" }
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
  throw "C1AXIBEAT_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -match "a7ng_astra_09_integ_path") {
  throw "C1AXIBEAT_LEFTOVER_A09_COMPILED"
}
if ($xvlogTxt -match "a7ng_query_axi_sparse_relbind") {
  throw "C1AXIBEAT_RELBIND_SPARSE_COMPILED"
}
if ($xvlogTxt -match "Analyzing Verilog file .+\\a7ng_query_axi_sparse\.sv") {
  throw "C1AXIBEAT_FROZEN_AXI_SPARSE_COMPILED"
}
if ($xvlogTxt -match "stream_intersect") {
  throw "C1AXIBEAT_STREAM_INTERSECT_02_COMPILED"
}
& "$bin\xelab.bat" tb_astra_c1_axi_beat_accounting -s astra_c1_axi_beat_accounting -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C1AXIBEAT_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra_c1_axi_beat_accounting -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$hasPass = $false
$hasDiv = $false
$hasRedCap = $false
$hasLeak = $false
$hasBeat = $false
$hasKeyMarker = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C1_AXI_BEAT_XSIM_PASS" -Quiet)
  $hasDiv = [bool](Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet)
  $hasRedCap = [bool](Select-String -Path $xsimLog -Pattern "reduction_x1000=[0-9]" -Quiet)
  $hasLeak = [bool](Select-String -Path $xsimLog -Pattern "FAIL DISTRACTOR_LEAK" -Quiet)
  $hasBeat = [bool](Select-String -Path $xsimLog -Pattern "AXI_BEAT class=" -Quiet)
  $hasKeyMarker = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C1_KEY_INTERSECT_XSIM_PASS" -Quiet)
}
if ($hasRedCap) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if ((Test-Path -LiteralPath $xsimLog) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $xsimLog $r0 -Force
  }
  throw "C1AXIBEAT_REDUCTION_X1000_EMITTED_AS_CAP_N"
}
if ($hasKeyMarker) {
  throw "C1AXIBEAT_WRONG_MARKER_KEY_INTERSECT"
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or $hasDiv -or $hasLeak -or (-not $hasBeat)) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if ((Test-Path -LiteralPath $xsimLog) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $xsimLog $r0 -Force
  }
  throw "C1AXIBEAT_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C1_AXI_BEAT_RUN_OK"
