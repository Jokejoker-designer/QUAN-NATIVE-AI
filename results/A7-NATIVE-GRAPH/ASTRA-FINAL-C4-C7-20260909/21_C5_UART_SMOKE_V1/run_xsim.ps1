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
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_lm06_d32_fr_v2.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c4_prod_wrap_v2.sv"),
  (Join-Path $root "rtl\board\uart_rx.sv"),
  (Join-Path $root "rtl\board\uart_tx.sv"),
  (Join-Path $root "rtl\native_graph\integrate\a7ng_astra_c5_prod_top_final_v1.sv"),
  (Join-Path $bag "tb_astra_c5_final_v1_uart_smoke.sv")
)
foreach ($f in $files) {
  $leaf = Split-Path -Leaf $f
  if ($leaf -eq "a7ng_astra_c5_prod_top.sv") { throw "C5SMOKE_LIVE_PROD_TOP" }
  if ($leaf -eq "a7ng_astra_c4_lm06_grounded_gen.sv") { throw "C5SMOKE_GROUNDED_GEN" }
}

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Copy-Item -Path (Join-Path $hexsrc "*.hex") -Destination $work -Force
Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $incl -i $incm -i $incb -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "C5SMOKE_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c5_final_v1_uart_smoke -s c5smokv1 -timescale 1ns/1ps
if ($LASTEXITCODE -ne 0) { throw "C5SMOKE_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c5smokv1 -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "C5SMOKE_XSIM_FAIL" }
$ok = (Select-String -Path $xsimLog -Pattern "ASTRA_C5_FINAL_V1_UART_SMOKE_XSIM_PASS" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "PASS F_LEARNED" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "PASS R_LEARNED" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "PASS UNK_SAFE" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "PASS ALIAS_MISS_SAFE" -Quiet) -and
      (Select-String -Path $xsimLog -Pattern "CLASS_host_tok0 HIT" -Quiet)
if (-not $ok) { throw "C5SMOKE_MARKER_MISSING" }
Write-Host "ASTRA_C5_FINAL_V1_UART_SMOKE_RUN_OK"
Write-Host "C5_MASTER=OPEN C6_SWITCH=NO PROGRAM=NO PROD_DICT=OPEN"
