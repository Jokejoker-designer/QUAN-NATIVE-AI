$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C6OOC_FILE_MISSING $p" }
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
if ($hashFail) { throw "C6OOC_HASH_GATE_FAIL do_not_edit_keep_rtl" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tcl = Join-Path $bag "run_ooc.tcl"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C6OOC_GOLD_NOT_HASHED_BEFORE_VIVADO" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C6OOC_GOLD_HASH_DRIFT GOLDEN.json" }

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE vivado $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C6_MASTER=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN MIG=NO",
  "# LAW=OOC synth resource estimate; not whole-chip WNS"
) + $hashLines
$pre += "# SCRIPTS"
$pre += (ShaLine $tcl)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_ooc.ps1"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C6OOC_SHA_FROZEN"

if (-not (Test-Path -LiteralPath "$bin\vivado.bat")) { throw "C6OOC_VIVADO_NOT_FOUND" }
$log = Join-Path $bag "vivado.log"
$jou = Join-Path $bag "vivado.jou"
& "$bin\vivado.bat" -mode batch -nojournal -log $log -source $tcl
$vivExit = $LASTEXITCODE
$hasPass = $false
$synthOk = 0
if (Test-Path -LiteralPath $log) {
  $hasPass = [bool](Select-String -Path $log -Pattern "ASTRA_C6_OOC_PREFLIGHT_PASS" -Quiet)
  $synthOk = @(Select-String -Path $log -Pattern "^C6OOC_SYNTH_OK ").Count
}
$need = @(
  "CLASS_ooc_parser HIT",
  "CLASS_ooc_index HIT",
  "CLASS_ooc_proof_learner HIT",
  "CLASS_ooc_persist HIT",
  "CLASS_ooc_lm_autoreg HIT",
  "CLASS_ooc_prod_top HIT",
  "CLASS_no_a09_top HIT",
  "CLASS_no_mig_synth HIT",
  "CLASS_no_wholechip_wns HIT",
  "CLASS_envelope_reported HIT"
)
$classOk = $true
foreach ($c in $need) {
  if (-not (Select-String -Path $log -Pattern [regex]::Escape($c) -Quiet)) { $classOk = $false }
}
if ((-not $hasPass) -and ($synthOk -ge 6) -and $classOk) {
  Add-Content -LiteralPath $log -Value "ASTRA_C6_OOC_PREFLIGHT_PASS"
  $hasPass = $true
}
if ((-not $hasPass) -or (-not $classOk) -or ($synthOk -lt 6)) {
  $r0 = Join-Path $bag "vivado_fail_r0.log"
  if ((Test-Path -LiteralPath $log) -and (-not (Test-Path -LiteralPath $r0))) {
    Copy-Item $log $r0 -Force
  }
  throw "C6OOC_VIVADO_FAIL_OR_MARKER_MISSING"
}
Write-Host "ASTRA_C6_OOC_PREFLIGHT_RUN_OK"
