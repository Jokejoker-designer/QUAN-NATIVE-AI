$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$incI = Join-Path $root "rtl\native_graph\integrate"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C2PC_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv" = "09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv" = "5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa"
  "rtl/native_graph/query/a7ng_route_valid_gate.sv" = "49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_stream_intersect.sv" = "14f75db787dee2405dc917604e54b4ab0dbea5cb327d4c4485f5be5cd874f0ac"
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
if ($hashFail) { throw "C2PC_HASH_GATE_FAIL do_not_edit_keep_rtl" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c2_persist_commit.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c2_persist_commit.sv"
$svh = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c2_persist_commit.svh"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C2PC_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C2PC_GOLD_HASH_DRIFT GOLDEN.json" }

$files = @($dut, $tb)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -match "a7ng_astra_09_integ_path") { throw "C2PC_LEFTOVER_A09" }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") { throw "C2PC_C0_SPARSE_AS_DUT" }
  if ($leaf -eq "a7ng_query_axi_sparse_stream_intersect.sv") { throw "C2PC_STREAM02_AS_DUT" }
  if ($leaf -eq "a7ng_learned_prior_store.sv") { throw "C2PC_PRIOR_STORE_AS_DUT" }
  if ($leaf -eq "a7ng_astra_06_warm_persist.sv") { throw "C2PC_ASTRA06_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO",
  "# LAW=astra-c2-persist-id-01 ID_W=20 AXI_JOURNAL PERSIST_BASE=0x06000000",
  "# HASH_GATE MATCH vs C0 (not compiled as DUT)"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $files) { $pre += (ShaLine $f) }
$pre += (ShaLine $svh)
$pre += (ShaLine $goldJson)
$pre += "# FORBIDDEN leftover A09 / C0 sparse / STREAM-02 / prior_store / ASTRA-06 not DUT"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)

function Write-DivLog([string]$code, [string]$detail) {
  [System.IO.File]::WriteAllLines((Join-Path $bag "xsim.log"), @(
    "FIRST_DIVERGENCE $code $detail",
    "RESULT=FAIL",
    "ASTRA_C2_PERSIST_COMMIT_XSIM_PASS ABSENT",
    "PROGRAM=NO BOARD_PASS=NOT_CLAIMED"
  ))
}

if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C2PC_XVLOG_NOT_FOUND" }
if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
& "$bin\xvlog.bat" --sv -i $bag -i $incI $files
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xvlog.log")) {
    Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
  }
  Write-DivLog "XVLOG" "xvlog_exit=$LASTEXITCODE"
  throw "C2PC_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -match "a7ng_astra_09_integ_path") { throw "C2PC_LEFTOVER_A09_COMPILED" }
if ($xvlogTxt -match "a7ng_query_axi_sparse_stream_intersect") { throw "C2PC_STREAM02_COMPILED" }
if ($xvlogTxt -match "a7ng_learned_prior_store") { throw "C2PC_PRIOR_STORE_COMPILED" }
if ($xvlogTxt -match "a7ng_astra_06_warm_persist") { throw "C2PC_ASTRA06_COMPILED" }
if ($xvlogTxt -notmatch "a7ng_astra_c2_persist_commit") { throw "C2PC_DUT_NOT_ANALYZED" }

& "$bin\xelab.bat" tb_astra_c2_persist_commit -s astra_c2_persist_commit -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  Write-DivLog "XELAB" "xelab_exit=$LASTEXITCODE"
  throw "C2PC_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" astra_c2_persist_commit -R -log $xsimLog
if (-not (Test-Path -LiteralPath $xsimLog)) { throw "C2PC_NO_XSIM_LOG" }
$hasPass = [bool](Select-String -Path $xsimLog -Pattern "^ASTRA_C2_PERSIST_COMMIT_XSIM_PASS$" -Quiet)
$hasDiv = [bool](Select-String -Path $xsimLog -Pattern "^FIRST_DIVERGENCE" -Quiet)
$hasHappy = [bool](Select-String -Path $xsimLog -Pattern "CLASS_happy_commit HIT" -Quiet)
$hasHigh = [bool](Select-String -Path $xsimLog -Pattern "CLASS_high_id_identity HIT" -Quiet)
$hasAlias = [bool](Select-String -Path $xsimLog -Pattern "CLASS_alias_attempt HIT" -Quiet)
$hasReload = [bool](Select-String -Path $xsimLog -Pattern "CLASS_reset_after_commit_reload HIT" -Quiet)
$hasZero = [bool](Select-String -Path $xsimLog -Pattern "CLASS_false_success_zero HIT" -Quiet)
$hasAddr = [bool](Select-String -Path $xsimLog -Pattern "CLASS_journal_addr_not_low16 HIT" -Quiet)
if ($hasDiv -or (-not $hasPass) -or (-not $hasHappy) -or (-not $hasHigh) -or (-not $hasAlias) -or (-not $hasReload) -or (-not $hasZero) -or (-not $hasAddr)) {
  $r0 = Join-Path $bag "xsim_fail_r0.log"
  if (-not (Test-Path -LiteralPath $r0)) { Copy-Item $xsimLog $r0 -Force }
  throw "C2PC_XSIM_CONTROL_FAIL pass=$hasPass happy=$hasHappy high=$hasHigh alias=$hasAlias reload=$hasReload zero=$hasZero addr=$hasAddr div=$hasDiv"
}
Write-Host "ASTRA_C2_PERSIST_COMMIT_RUN_OK PASS_THIS_GATE_ONLY PROGRAM=NO"
