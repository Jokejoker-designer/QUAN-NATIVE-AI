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
  if (-not (Test-Path -LiteralPath $p)) { throw "C6WC_FILE_MISSING $p" }
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
if ($hashFail) { throw "C6WC_HASH_GATE_FAIL do_not_edit_keep_rtl" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tcl = Join-Path $bag "run_impl.tcl"
$wrap = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c6_wholechip.sv"
$xdc = Join-Path $bag "c6_wholechip.xdc"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C6WC_GOLD_NOT_HASHED_BEFORE_VIVADO" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C6WC_GOLD_HASH_DRIFT GOLDEN.json" }

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE vivado $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C6_MASTER=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN",
  "# LAW=in-context route of C5 prod_top + official MIG; A09 is not this top"
) + $hashLines
$pre += "# SCRIPTS"
$pre += (ShaLine $tcl)
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "run_impl.ps1"))
$pre += (ShaLine $wrap)
$pre += (ShaLine $xdc)
$pre += (ShaLine (Join-Path $root "rtl\ddr\mig_native_wrap.sv"))
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C6WC_SHA_FROZEN"

if (-not (Test-Path -LiteralPath "$bin\vivado.bat")) { throw "C6WC_VIVADO_NOT_FOUND" }
$log = Join-Path $bag "vivado.log"
$jou = Join-Path $bag "vivado.jou"
& "$bin\vivado.bat" -mode batch -nojournal -log $log -source $tcl
$vivExit = $LASTEXITCODE
$hasPass = $false
if (Test-Path -LiteralPath $log) {
  $hasPass = [bool](Select-String -Path $log -Pattern "ASTRA_C6_WHOLECHIP_COFIT_PASS" -Quiet)
}
$need = @(
  "CLASS_device_fit HIT",
  "CLASS_wns_ge0 HIT",
  "CLASS_tns_0 HIT",
  "CLASS_whs_ge0 HIT",
  "CLASS_ths_0 HIT",
  "CLASS_unrouted_0 HIT",
  "CLASS_drc_clean HIT",
  "CLASS_mig_user_design HIT",
  "CLASS_c5_prod_inst HIT",
  "CLASS_no_a09_top HIT",
  "CLASS_no_program_hw HIT",
  "CLASS_cdc_reviewed HIT"
)
$miss = @()
if (Test-Path -LiteralPath $log) {
  foreach ($n in $need) {
    if (-not (Select-String -Path $log -Pattern ([regex]::Escape($n)) -Quiet)) { $miss += $n }
  }
} else {
  $miss = $need
}
if ($hasPass -and $miss.Count -eq 0 -and $vivExit -eq 0) {
  Write-Host "ASTRA_C6_WHOLECHIP_COFIT_PASS"
  exit 0
}
Write-Host "C6WC_PS_MISS viv_exit=$vivExit pass_marker=$hasPass miss=$($miss -join ',')"
exit 1
