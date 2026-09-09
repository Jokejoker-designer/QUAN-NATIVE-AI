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
  if (-not (Test-Path -LiteralPath $p)) { throw "C1SEM16K_FILE_MISSING $p" }
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
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv" = "14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_page_skip.sv" = "dab15d76da42b33a934d8c68c1108665a79b8544d44b4986b840972841135817"
  "rtl/native_graph/query/a7ng_query_role_keys_ctx.sv" = "124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_context.sv" = "8255a7988b902c4fd6d76679cc42ef0726d50099961f7c211010ace54a24d989"
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
  $failSha = @("# SHA freeze HASH_GATE_FAIL $stamp", "# PROGRAM=NO C1_800K=OPEN CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN") + $hashLines
  [System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $failSha)
  throw "C1SEM16K_HASH_GATE_FAIL do_not_invent do_not_edit_keep_rtl"
}

$goldJson = Join-Path $bag "GOLDEN.json"
$goldSvh = Join-Path $bag "query_gold.svh"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$corpus = Join-Path $bag "corpus.json"
$tb = Join-Path $bag "tb_astra_c1_semantic_16k.sv"
$hostPy = Join-Path $bag "host_astra_c1_semantic_16k.py"
$lexNamed = Join-Path $bag "qse_role_lexicon_semantic_16k.svh"
$lexShim = Join-Path $bag "qse_role_lexicon.svh"
$ctxKeys = Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"
$ctxDut = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_context.sv"
$rbKeys = Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_relbind.sv"
$streamDut = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_stream_intersect.sv"
$pageDut = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_page_skip.sv"
$keepIx = Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect.sv"
if (-not (Test-Path -LiteralPath $goldJson)) { throw "C1SEM16K_GOLD_MISSING GOLDEN.json" }
if (-not (Test-Path -LiteralPath $goldSvh)) { throw "C1SEM16K_GOLD_MISSING query_gold.svh" }
if (-not (Test-Path -LiteralPath $corpus)) { throw "C1SEM16K_GOLD_MISSING corpus.json" }
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C1SEM16K_GOLD_NOT_HASHED_BEFORE_XVLOG" }
if (-not (Test-Path -LiteralPath $lexNamed)) { throw "C1SEM16K_LEX_MISSING qse_role_lexicon_semantic_16k.svh" }
if (-not (Test-Path -LiteralPath $lexShim)) { throw "C1SEM16K_LEX_SHIM_MISSING qse_role_lexicon.svh (NEW law include-name, not C0)" }
if (-not (Test-Path -LiteralPath $ctxDut)) { throw "C1SEM16K_DUT_MISSING a7ng_query_axi_sparse_intersect_context.sv" }
if (-not (Test-Path -LiteralPath $ctxKeys)) { throw "C1SEM16K_KEYS_MISSING a7ng_query_role_keys_ctx.sv" }
$liveGold = Sha256 $goldJson
$liveSvh = Sha256 $goldSvh
$liveCorpus = Sha256 $corpus
$liveLex = Sha256 $lexNamed
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C1SEM16K_GOLD_HASH_DRIFT GOLDEN.json" }
if ($preTxt -notmatch $liveSvh) { throw "C1SEM16K_GOLD_HASH_DRIFT query_gold.svh" }
if ($preTxt -notmatch $liveCorpus) { throw "C1SEM16K_GOLD_HASH_DRIFT corpus.json" }
if ($preTxt -notmatch $liveLex) { throw "C1SEM16K_GOLD_HASH_DRIFT qse_role_lexicon_semantic_16k.svh" }
Write-Host "GOLD_HASH_LOCKED_BEFORE_XVLOG GOLDEN=$liveGold SVH=$liveSvh CORPUS=$liveCorpus LEX=$liveLex"
Write-Host "NEW_LEXICON_LAW qse-v2-lex-semantic-16k-01 runtime=bag named file; C0 FILE unedited MATCH"

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  $ctxKeys,
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_axi_mem_model.sv"),
  $ctxDut,
  $tb
)

foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -match "a7ng_astra_09_integ_path") {
    throw "C1SEM16K_LEFTOVER_A09_ON_XVLOG_LIST"
  }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") {
    throw "C1SEM16K_FROZEN_AXI_SPARSE_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_axi_sparse_relbind.sv") {
    throw "C1SEM16K_RELBIND_SPARSE_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_axi_sparse_intersect.sv") {
    throw "C1SEM16K_KEY_INTERSECT_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_axi_sparse_stream_intersect.sv") {
    throw "C1SEM16K_STREAM02_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_axi_sparse_page_skip.sv") {
    throw "C1SEM16K_PAGESKIP_MUST_NOT_BE_DUT"
  }
  if ($leaf -eq "a7ng_query_role_keys_relbind.sv") {
    throw "C1SEM16K_RELBIND_KEYS_MUST_NOT_BE_COMPILED"
  }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO C1_800K=OPEN CAND_CAP=16 N=16384 N_BUCKETS=65536 LAW=qse-v2-intersect-context-02 LEX=qse-v2-lex-semantic-16k-01 POKE_V=0",
  "# CAND_CAP_FINAL=NOT_FROZEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN",
  "# HASH_GATE MATCH vs C0 FINAL_CONTRACT (frozen files not patched)",
  "# XVLOG_INCLUDE bag FIRST then C0 query dir (NEW lexicon law, not silent C0 59-word claim)",
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
$pre += "# KEEP_NOT_DUT"
$pre += (ShaLine $rbKeys)
$pre += (ShaLine $keepIx)
$pre += (ShaLine $streamDut)
$pre += (ShaLine $pageDut)
$pre += "# INSTANTIATE_NOT_EDIT"
$pre += (ShaLine $ctxKeys)
$pre += (ShaLine $ctxDut)
$pre += "# NEW_LEXICON_LAW qse-v2-lex-semantic-16k-01"
$pre += (ShaLine $lexNamed)
$pre += (ShaLine $lexShim)
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += "# TRANSITIVE_INCLUDES"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$pre += "$(Sha256 (Join-Path $incq 'qse_role_lexicon.svh'))  rtl/native_graph/query/qse_role_lexicon.svh  # C0 FILE KEEP unedited; NOT runtime this bag"
$pre += (ShaLine (Join-Path $incc "a7ng_gate14_crc.svh"))
$pre += (ShaLine $goldSvh)
$pre += "# INDEPENDENT_GOLD_BEFORE_XVLOG"
$pre += "$liveGold  results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/GOLDEN.json"
$pre += "$liveSvh  results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/query_gold.svh"
$pre += "$liveCorpus  results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/corpus.json"
$pre += "$liveLex  results/A7-NATIVE-GRAPH/ASTRA-C1-SEMANTIC-16K-01/qse_role_lexicon_semantic_16k.svh"
$pre += "# BAG"
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += (ShaLine $hostPy)
$pre += (ShaLine $tb)
$pre += "# FORBIDDEN leftover a7ng_astra_09_integ_path NOT on xvlog DUT list"
$pre += "# FORBIDDEN frozen a7ng_query_axi_sparse.sv NOT compiled as DUT"
$pre += "# FORBIDDEN a7ng_query_axi_sparse_intersect.sv NOT compiled as DUT (KEEP KEY-INTERSECT)"
$pre += "# FORBIDDEN a7ng_query_axi_sparse_stream_intersect.sv NOT compiled as DUT (KEEP STREAM-02 14f75db7)"
$pre += "# FORBIDDEN a7ng_query_axi_sparse_page_skip.sv NOT compiled as DUT (KEEP PAGE-SKIP dab15d76)"
$pre += "# FORBIDDEN a7ng_query_axi_sparse_relbind.sv NOT compiled as DUT"
$pre += "# FORBIDDEN a7ng_query_role_keys_relbind.sv NOT compiled (ctx keys instantiated)"
$pre += "# NEW_LEXICON_LAW documented; bag qse_role_lexicon.svh is include-name for named semantic table; C0 FILE unedited"
$pre += "# REDUCTION_X1000 NOT_EMITTED (not 1-CAND_CAP/N)"
$pre += "# CAND_CAP_FINAL NOT_FROZEN DDR_QUERY_BOUND_FINAL NOT_FROZEN C1_800K OPEN"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C1SEM16K_SHA_FROZEN_BEFORE_XVLOG"

if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C1SEM16K_XVLOG_NOT_FOUND" }
if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
# Bag include FIRST so frozen extract binds NEW lexicon law (named file via include-name).
# C0 query dir is second: C0 FILE remains unedited and is NOT the runtime table this bag.
& "$bin\xvlog.bat" --sv -i $bag -i $incq -i $incc $files
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xvlog.log")) {
    Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
  }
  throw "C1SEM16K_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -match "a7ng_astra_09_integ_path") {
  throw "C1SEM16K_LEFTOVER_A09_COMPILED"
}
if ($xvlogTxt -match "a7ng_query_axi_sparse_relbind") {
  throw "C1SEM16K_RELBIND_SPARSE_COMPILED"
}
if ($xvlogTxt -match "a7ng_query_role_keys_relbind") {
  throw "C1SEM16K_RELBIND_KEYS_COMPILED"
}
if ($xvlogTxt -match "Analyzing Verilog file .+\\a7ng_query_axi_sparse\.sv") {
  throw "C1SEM16K_FROZEN_AXI_SPARSE_COMPILED"
}
if ($xvlogTxt -match "Analyzing Verilog file .+\\a7ng_query_axi_sparse_intersect\.sv") {
  throw "C1SEM16K_KEY_INTERSECT_COMPILED_AS_DUT"
}
if ($xvlogTxt -match "Analyzing Verilog file .+\\a7ng_query_axi_sparse_stream_intersect\.sv") {
  throw "C1SEM16K_STREAM02_COMPILED_AS_DUT"
}
if ($xvlogTxt -match "Analyzing Verilog file .+\\a7ng_query_axi_sparse_page_skip\.sv") {
  throw "C1SEM16K_PAGESKIP_COMPILED_AS_DUT"
}
if ($xvlogTxt -notmatch "a7ng_query_axi_sparse_intersect_context") {
  throw "C1SEM16K_DUT_NOT_ANALYZED"
}
if ($xvlogTxt -notmatch "a7ng_query_role_keys_ctx") {
  throw "C1SEM16K_CTX_KEYS_NOT_ANALYZED"
}
& "$bin\xelab.bat" tb_astra_c1_semantic_16k -s astra_c1_semantic_16k -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  throw "C1SEM16K_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra_c1_semantic_16k -R -log $xsimLog
$xsimExit = $LASTEXITCODE
$hasPass = $false
$hasDiv = $false
$hasRedCap = $false
$hasLeak = $false
$hasLateMiss = $false
$hasCtxSel = $false
$hasNotSel = $false
$hasDirectFail = $false
$hasIncomp = $false
if (Test-Path -LiteralPath $xsimLog) {
  $hasPass = [bool](Select-String -Path $xsimLog -Pattern "ASTRA_C1_SEMANTIC_16K_XSIM_PASS" -Quiet)
  $hasDiv = [bool](Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet)
  $hasRedCap = [bool](Select-String -Path $xsimLog -Pattern "reduction_x1000=[0-9]" -Quiet)
  $hasLeak = [bool](Select-String -Path $xsimLog -Pattern "FAIL DISTRACTOR_LEAK" -Quiet)
  $hasLateMiss = [bool](Select-String -Path $xsimLog -Pattern "FAIL LATE_GOLD_MISS" -Quiet)
  $hasCtxSel = [bool](Select-String -Path $xsimLog -Pattern "CONTEXT_SELECTIVE class=wrong_context" -Quiet)
  $hasNotSel = [bool](Select-String -Path $xsimLog -Pattern "FAIL WRONG_CONTEXT_NOT_SELECTIVE" -Quiet)
  $hasDirectFail = [bool](Select-String -Path $xsimLog -Pattern "FAIL DIRECT_" -Quiet)
  $hasIncomp = [bool](Select-String -Path $xsimLog -Pattern "SEARCH_INCOMPLETE" -Quiet)
}
if ($hasRedCap) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if ((Test-Path -LiteralPath $xsimLog) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $xsimLog $r0 -Force
  }
  throw "C1SEM16K_REDUCTION_X1000_EMITTED_AS_CAP_N"
}
if (($xsimExit -ne 0) -or (-not $hasPass) -or $hasDiv -or $hasLeak -or $hasLateMiss -or (-not $hasCtxSel) -or $hasNotSel -or $hasDirectFail -or $hasIncomp) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if ((Test-Path -LiteralPath $xsimLog) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $xsimLog $r0 -Force
  }
  throw "C1SEM16K_XSIM_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C1_SEMANTIC_16K_RUN_OK"
