$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"
$migroot = Join-Path $root "vivado\ip\mig_7series_0\mig_7series_0"
$migSimInc = Join-Path $migroot "example_design\sim"

function Rel([string]$p) {
  $full = [System.IO.Path]::GetFullPath($p)
  $r = $full.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  return $r
}
function Sha256([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { throw "C5FRM_FILE_MISSING $p" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
}
function ShaLine([string]$p) { return "$(Sha256 $p)  $(Rel $p)" }

$expect = @{
  "rtl/native_graph/query/a7ng_query_role_extract.sv" = "cd7baf49bb433220d7ed3cd1b2fe942f7a1a9ee54f1171cdbb650cecd83a9f27"
  "rtl/native_graph/query/qse_role_lexicon.svh" = "381899749158ecaa0b3209f16f618d6c65f4d8483f7ffff7ce0af3ffa4a50d0c"
  "rtl/native_graph/memory/a7ng_sparse_dir_axi.sv" = "09334e42c3913d4de3a1b59147f48c810481cd634e63b37e64bc669a6c36bb24"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse.sv" = "5a4ad04d498c588b4447431c290a862252abfbecdef8e934ed4215b9b9c5c0fa"
  "rtl/native_graph/query/a7ng_route_valid_gate.sv" = "49a66da21dc075d1487c320d399643ff94e87b02af13f3d6f36d346a1be3a385"
  "rtl/native_graph/query/a7ng_query_role_keys_ctx.sv" = "124be80804b38a1e1a924924091b751a4d13d85e28241695eda00ca5ded500d1"
  "rtl/native_graph/query/qse_relctx_synonym_01.svh" = "551655a1cda97463841a681e34f8073e22b1b2c1beb2ae03847bdc9a5bb41dfd"
  "rtl/native_graph/query/a7ng_query_role_relctx_synonym.sv" = "e862208ce34d8835c34fef1b2f2e4d32a91938a26cf22bc3854593ff852ea922"
  "rtl/native_graph/integrate/a7ng_query_axi_sparse_intersect_synonym.sv" = "a84bbf7e9a2c0b9e3753b3cb2e1ae734c2afde59267d733aa0e52108e47d8ec8"
  "rtl/native_graph/integrate/a7ng_astra_c2_persist_commit.sv" = "86a7a0695712d9aa818bf95aac30b83289fb9af80ddd0bdc2455e935a14d8764"
  "rtl/native_graph/learn/a7ng_shared_rank_sgd_q8_sym_f2r2.sv" = "b66ef32847bae8dceb902b36a2755eae8bcd48289bd00c133fb16f095fc67aac"
  "rtl/ddr/mig_native_wrap.sv" = "97c078b18015e0c6a47ca4d41b659e483f2e983d37f8bb6e579efa4d19e523b5"
  "third_party/digilent/arty-a7-100/E.0/1.0/mig.prj" = "914a9e4bb1b3002837592944cdf49f8dfbaf4d112552dd8b5be48602ff1ac329"
  "rtl/native_graph/integrate/a7ng_lm_graph_arb.sv" = "04b5346ef984af6b7666e43e93fabc442c716f14508fa8545f109e5eb76e3b67"
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
if ($hashFail) { throw "C5FRM_HASH_GATE_FAIL do_not_edit_keep_rtl_or_mig_prj" }

$goldJson = Join-Path $bag "GOLDEN.json"
$goldPre = Join-Path $bag "GOLD_HASH_PRE_XVLOG.txt"
$tb = Join-Path $bag "tb_astra_c5_flush_reload_mig.sv"
$dut = Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top.sv"
$wrap = Join-Path $root "rtl\ddr\mig_native_wrap.sv"
if (-not (Test-Path -LiteralPath $goldPre)) { throw "C5FRM_GOLD_NOT_HASHED_BEFORE_XVLOG" }
$liveGold = Sha256 $goldJson
$preTxt = [System.IO.File]::ReadAllText($goldPre)
if ($preTxt -notmatch $liveGold) { throw "C5FRM_GOLD_HASH_DRIFT GOLDEN.json" }

$svFiles = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c2_persist_commit.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_byte256.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_grounded_gen.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_ddr_arb.sv"),
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  $dut,
  $wrap,
  $tb
)

foreach ($f in $svFiles) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -match "a7ng_astra_09_integ_path") { throw "C5FRM_LEFTOVER_A09" }
  if ($leaf -eq "a7ng_query_axi_sparse.sv") { throw "C5FRM_C0_SPARSE_AS_DUT" }
  if ($leaf -eq "a7ng_query_axi_sparse_stream_intersect.sv") { throw "C5FRM_STREAM02_AS_DUT" }
  if ($leaf -eq "a7ng_query_axi_sparse_intersect_context.sv") { throw "C5FRM_CTX_8255a798_AS_DUT" }
  if ($leaf -eq "a7ng_learned_prior_store.sv") { throw "C5FRM_PRIOR_STORE" }
  if ($leaf -eq "tiny_gpt803k_core.sv") { throw "C5FRM_TINYGPT_AS_DUT" }
  if ($leaf -eq "a7ng_evidence_compose.sv") { throw "C5FRM_COMPOSE_RENDERER_AS_DUT" }
  if ($leaf -eq "mig_7series_0_mig.v") { throw "C5FRM_SYNTH_MIG_AS_DUT" }
  if ($leaf -eq "a7ng_lm_graph_arb.sv") { throw "C5FRM_LM_GRAPH_ARB_AS_DUT" }
}

$stamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffffffK")
$pre = @(
  "# SHA freeze BEFORE xvlog $stamp",
  "# PROGRAM=NO BOARD_PASS=NOT_CLAIMED C5_MASTER=OPEN DDR_QUERY_BOUND_FINAL=NOT_FROZEN",
  "# LAW=astra-c5-flush-reload-mig-01 MIG_XSIM Digilent AXI mig_sim + ddr3_model flush then C2 reload",
  "# HASH_GATE MATCH vs C0/C1/C2 KEEP + SGD KEEP + official mig.prj + lm_graph_arb (not edited)"
) + $hashLines
$pre += "# COMPILED"
foreach ($f in $svFiles) { $pre += (ShaLine $f) }
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top.svh"))
$pre += (ShaLine (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_ddr_arb.svh"))
$pre += (ShaLine $goldJson)
$pre += (ShaLine (Join-Path $bag "PREREG.md"))
$pre += (ShaLine (Join-Path $bag "ACK.json"))
$pre += (ShaLine (Join-Path $bag "tb_oracles.svh"))
$pre += (ShaLine (Join-Path $bag "run_xsim.ps1"))
$pre += "# FORBIDDEN leftover A09 / STREAM-02 / ctx DUT / tiny_gpt803k / synth mig_7series_0_mig.v / a7ng_lm_graph_arb as DUT"
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256.txt"), $pre)
Write-Host "C5FRM_SHA_FROZEN"

function Write-DivLog([string]$code, [string]$detail) {
  [System.IO.File]::WriteAllLines((Join-Path $bag "xsim.log"), @(
    "FIRST_DIVERGENCE $code $detail",
    "RESULT=FAIL",
    "ASTRA_C5_FLUSH_RELOAD_MIG_XSIM_PASS ABSENT",
    "PROGRAM=NO BOARD_PASS=NOT_CLAIMED C5_MASTER=OPEN"
  ))
}

if (-not (Test-Path -LiteralPath "$bin\xvlog.bat")) { throw "C5FRM_XVLOG_NOT_FOUND" }
if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null

$prj = Join-Path $work "c5_flush_reload_mig.prj"
$prjLines = @()
foreach ($f in $svFiles) { $prjLines += "sv work `"$f`"" }
Get-ChildItem -LiteralPath (Join-Path $migroot "user_design\rtl") -Filter "*.v" | Sort-Object Name | ForEach-Object {
  if ($_.Name -eq "mig_7series_0_mig.v" -or $_.Name -eq "mig_7series_0_mig_sim.v") { return }
  $prjLines += "verilog work `"$($_.FullName)`""
}
foreach ($d in @("axi", "clocking", "controller", "ecc", "ip_top", "phy", "ui")) {
  $dir = Join-Path $migroot "user_design\rtl\$d"
  if (Test-Path $dir) {
    Get-ChildItem -LiteralPath $dir -Filter "*.v" | Sort-Object Name | ForEach-Object {
      $prjLines += "verilog work `"$($_.FullName)`""
    }
  }
}
$prjLines += "verilog work `"$(Join-Path $migroot 'user_design\rtl\mig_7series_0_mig_sim.v')`""
$prjLines += "verilog work `"$(Join-Path $migroot 'example_design\sim\wiredly.v')`""
$prjLines += "sv work `"$(Join-Path $migroot 'example_design\sim\ddr3_model.sv')`" -d x2Gb -d sg15E -d x16"
$prjLines += "verilog work `"C:\2026.1\Vivado\data\verilog\src\glbl.v`""
[System.IO.File]::WriteAllLines($prj, $prjLines)

Set-Location $work
& "$bin\xvlog.bat" -prj $prj -i $incq -i $incc -i $inci -i $bag -i $migSimInc
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xvlog.log")) {
    Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
  }
  Write-DivLog "XVLOG" "xvlog_exit=$LASTEXITCODE"
  throw "C5FRM_XVLOG_FAIL"
}
Copy-Item (Join-Path $work "xvlog.log") (Join-Path $bag "xvlog.log") -Force
$xvlogTxt = [System.IO.File]::ReadAllText((Join-Path $bag "xvlog.log"))
if ($xvlogTxt -match "a7ng_astra_09_integ_path") { throw "C5FRM_LEFTOVER_A09_COMPILED" }
if ($xvlogTxt -match "a7ng_query_axi_sparse_stream_intersect") { throw "C5FRM_STREAM02_COMPILED" }
if ($xvlogTxt -match "a7ng_query_axi_sparse_intersect_context") { throw "C5FRM_CTX_COMPILED" }
if ($xvlogTxt -match "tiny_gpt803k_core") { throw "C5FRM_TINYGPT_COMPILED" }
if ($xvlogTxt -match "a7ng_evidence_compose") { throw "C5FRM_COMPOSE_COMPILED" }
if ($xvlogTxt -match "mig_7series_0_mig\.v" -and $xvlogTxt -notmatch "mig_7series_0_mig_sim") { throw "C5FRM_SYNTH_MIG_COMPILED" }
if ($xvlogTxt -notmatch "a7ng_astra_c5_prod_top") { throw "C5FRM_DUT_NOT_ANALYZED" }
if ($xvlogTxt -notmatch "mig_7series_0_mig_sim") { throw "C5FRM_MIG_SIM_NOT_ANALYZED" }
if ($xvlogTxt -notmatch "tb_astra_c5_flush_reload_mig") { throw "C5FRM_TB_NOT_ANALYZED" }

& "$bin\xelab.bat" -mt off -O0 tb_astra_c5_flush_reload_mig glbl -s c5frm -L unisims_ver -L unimacro_ver -L secureip -timescale 1ps/1ps
if ($LASTEXITCODE -ne 0) {
  if (Test-Path (Join-Path $work "xelab.log")) {
    Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
  }
  Write-DivLog "XELAB" "xelab_exit=$LASTEXITCODE"
  throw "C5FRM_XELAB_FAIL"
}
if (Test-Path (Join-Path $work "xelab.log")) {
  Copy-Item (Join-Path $work "xelab.log") (Join-Path $bag "xelab.log") -Force
}
$xsimLog = Join-Path $bag "xsim.log"
$xsimOut = Join-Path $bag "xsim_stdout.txt"
& "$bin\xsim.bat" c5frm -R -log $xsimLog 1> $xsimOut 2>&1
$xsimExit = $LASTEXITCODE
$post = @("# SHA verify AFTER xsim $((Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffffffK'))")
foreach ($f in $svFiles) { $post += (ShaLine $f) }
[System.IO.File]::WriteAllLines((Join-Path $bag "SHA256_POST.txt"), $post)
if (-not (Test-Path -LiteralPath $xsimLog)) { throw "C5FRM_NO_XSIM_LOG" }
$hasPass = [bool](Select-String -Path $xsimLog -Pattern "^ASTRA_C5_FLUSH_RELOAD_MIG_XSIM_PASS$" -Quiet)
$hasDiv = [bool](Select-String -Path $xsimLog -Pattern "^FIRST_DIVERGENCE" -Quiet)
$need = @(
  "CLASS_mig_calib_complete HIT",
  "CLASS_two_hop_answer HIT",
  "CLASS_flush_w0_zero HIT",
  "CLASS_c2_persist_reload HIT",
  "CLASS_one_ddr_owner HIT",
  "CLASS_no_qid_map HIT",
  "CLASS_no_host_winner HIT",
  "CLASS_no_a09_top HIT",
  "CLASS_no_plant_in_dut HIT"
)
$missing = @()
foreach ($n in $need) {
  $pat = [regex]::Escape($n)
  if (-not [bool](Select-String -Path $xsimLog -Pattern $pat -Quiet)) {
    $missing += $n
  }
}
if ($hasDiv -or (-not $hasPass) -or ($xsimExit -ne 0) -or ($missing.Count -gt 0)) {
  $r4 = Join-Path $bag "xsim_fail_r4.log"
  if (-not (Test-Path -LiteralPath $r4)) { Copy-Item $xsimLog $r4 -Force }
  throw "C5FRM_XSIM_CONTROL_FAIL pass=$hasPass div=$hasDiv exit=$xsimExit missing=$($missing -join ',')"
}
Write-Host "ASTRA_C5_FLUSH_RELOAD_MIG_RUN_OK PASS_THIS_GATE_ONLY PROGRAM=NO MIG_XSIM=1 C5_MASTER=OPEN"
