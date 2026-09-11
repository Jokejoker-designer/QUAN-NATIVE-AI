$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$work = Join-Path $bag "xsim_work"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"
$incl = Join-Path $root "rtl\native_graph\learn"
$incm = Join-Path $root "rtl\native_graph\memory"
$incb = Join-Path $root "rtl\board"
$hexsrc = Join-Path $inci "a7ng_astra_c4_lm06_d32_fr_v2_mem"

$files = @(
  (Join-Path $root "rtl\native_graph\pkg\a7ng_pkg.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_extract.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_relctx_synonym.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_query_role_keys_ctx.sv"),
  (Join-Path $root "rtl\native_graph\query\a7ng_route_valid_gate.sv"),
  (Join-Path $root "rtl\native_graph\memory\a7ng_sparse_dir_axi.sv"),
  (Join-Path $root "rtl\native_graph\learn\a7ng_shared_rank_sgd_q8_sym_f2r2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_query_axi_sparse_intersect_synonym.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c3_held_out_pendld.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_ddr_arb.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_axi1b_v1.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_sgd32_ckpt_pend.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_answer_gate_v1.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_entity_alias_v1.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_materializer_v2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_smres_div_mcycle.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_rq_mcycle.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_d32_fr_v2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_prod_wrap_v2.sv"),
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top_final_v1.sv"),
  (Join-Path $bag "tb_astra_c5_final_v1_c4_causal.sv")
)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C5CAUSAL_LIVE_PROD_TOP" }
  if ($leaf -eq "a7ng_astra_c4_lm06_grounded_gen.sv") { throw "C5CAUSAL_GROUNDED_GEN" }
}

function Write-ConstHex([string]$path, [string]$src, [string]$val) {
  $n = @(Get-Content -LiteralPath $src).Count
  if ($n -lt 1) { throw ("C5CAUSAL_HEX_EMPTY " + $path) }
  $lines = for ($i = 0; $i -lt $n; $i++) { $val }
  [System.IO.File]::WriteAllLines($path, $lines)
}

function Invoke-CausalXsim([string]$log, [string[]]$plus) {
  $args = @("c5causv1", "-R", "-log", $log)
  foreach ($p in $plus) { $args += @("-testplusarg", $p) }
  & "$bin\xsim.bat" @args
  if ($LASTEXITCODE -ne 0) { throw ("C5CAUSAL_XSIM_FAIL " + $log) }
}

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $incl -i $incm -i $incb -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "C5CAUSAL_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c5_final_v1_c4_causal -s c5causv1 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "C5CAUSAL_XELAB_FAIL" }

$baseLog = Join-Path $bag "xsim_base.log"
$zeroLog = Join-Path $bag "xsim_zero_we.log"
$wqLog = Join-Path $bag "xsim_corrupt_wq.log"
$xsimLog = Join-Path $bag "xsim.log"

Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Invoke-CausalXsim $baseLog @()
$baseOk = (Select-String -Path $baseLog -Pattern "ASTRA_C5_FINAL_V1_C4_CAUSAL_XSIM_PASS" -Quiet) -and
          (Select-String -Path $baseLog -Pattern "PASS F_LEARNED" -Quiet) -and
          (Select-String -Path $baseLog -Pattern "CLASS_c4_live HIT" -Quiet) -and
          (Select-String -Path $baseLog -Pattern "MODE=BASE" -Quiet)
if (-not $baseOk) { throw "C5CAUSAL_BASE_MARKER_MISSING" }

Copy-Item -Path (Join-Path $hexsrc "We.hex") -Destination (Join-Path $work "We.hex.bak") -Force
Write-ConstHex (Join-Path $work "We.hex") (Join-Path $hexsrc "We.hex") "00"
Invoke-CausalXsim $zeroLog @("ZERO_WE")
$zeroHit = (Select-String -Path $zeroLog -Pattern "ASTRA_C5_FINAL_V1_C4_CAUSAL_XSIM_PASS" -Quiet) -and
           (Select-String -Path $zeroLog -Pattern "CLASS_c4_ablate HIT" -Quiet) -and
           (Select-String -Path $zeroLog -Pattern "CLASS_safe_hide HIT" -Quiet) -and
           (Select-String -Path $zeroLog -Pattern "CLASS_zero_we_done" -Quiet) -and
           (Select-String -Path $zeroLog -Pattern "PASS C3_ANSWER" -Quiet) -and
           (Select-String -Path $zeroLog -Pattern "PASS ALLOWED" -Quiet)
$zeroMissGold = Select-String -Path $zeroLog -Pattern "CLASS_c4_ablate MISS still_gold_tifh" -Quiet
Copy-Item -Path (Join-Path $hexsrc "We.hex") -Destination (Join-Path $work "We.hex") -Force

Write-ConstHex (Join-Path $work "Wq.hex") (Join-Path $hexsrc "Wq.hex") "7f"
Invoke-CausalXsim $wqLog @("CORRUPT_WQ")
$wqHit = (Select-String -Path $wqLog -Pattern "ASTRA_C5_FINAL_V1_C4_CAUSAL_XSIM_PASS" -Quiet) -and
         (Select-String -Path $wqLog -Pattern "CLASS_c4_ablate HIT" -Quiet) -and
         (Select-String -Path $wqLog -Pattern "CLASS_safe_hide HIT" -Quiet) -and
         (Select-String -Path $wqLog -Pattern "CLASS_corrupt_wq_done" -Quiet) -and
         (Select-String -Path $wqLog -Pattern "PASS C3_ANSWER" -Quiet) -and
         (Select-String -Path $wqLog -Pattern "PASS ALLOWED" -Quiet)
$wqMissGold = Select-String -Path $wqLog -Pattern "CLASS_c4_ablate MISS still_gold_tifh" -Quiet
Copy-Item -Path (Join-Path $hexsrc "Wq.hex") -Destination (Join-Path $work "Wq.hex") -Force

$header = @(
  "C5_FINAL_V1_C4_CAUSAL_CONCAT PROGRAM=NO C5_MASTER=OPEN",
  ("BASE_OK=" + $baseOk),
  ("ZERO_WE_HIT=" + $zeroHit),
  ("CORRUPT_WQ_HIT=" + $wqHit),
  ("ZERO_WE_STILL_GOLD=" + [bool]$zeroMissGold),
  ("CORRUPT_WQ_STILL_GOLD=" + [bool]$wqMissGold),
  "CLASS_host_tok_input expected MISS (D32 n_host_tok_o assign 16'd0)",
  "==== BASE ===="
)
$parts = $header + (Get-Content -LiteralPath $baseLog) + @("==== ZERO_WE ====") + (Get-Content -LiteralPath $zeroLog) + @("==== CORRUPT_WQ ====") + (Get-Content -LiteralPath $wqLog)
[System.IO.File]::WriteAllLines($xsimLog, $parts)

if (-not $zeroHit) {
  if ($zeroMissGold) { throw "C5CAUSAL_ZERO_WE_STILL_GOLD" }
  throw "C5CAUSAL_ZERO_WE_MARKER_MISSING"
}
if (-not $wqHit) {
  if ($wqMissGold) { throw "C5CAUSAL_CORRUPT_WQ_STILL_GOLD" }
  throw "C5CAUSAL_CORRUPT_WQ_MARKER_MISSING"
}

Write-Host "ASTRA_C5_FINAL_V1_C4_CAUSAL_RUN_OK"
Write-Host "C5_MASTER=OPEN PROGRAM=NO"
Write-Host "C5-15-18 CLASS_host_tok_input MISS is expected (no D32 host-token input)"
