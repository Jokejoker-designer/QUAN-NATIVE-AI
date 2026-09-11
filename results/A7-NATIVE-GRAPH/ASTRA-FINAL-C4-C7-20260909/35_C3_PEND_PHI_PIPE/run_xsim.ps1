$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..\..")).Path
$bin = "C:\2026.1\Vivado\bin"
$incq = Join-Path $root "rtl\native_graph\query"
$incc = Join-Path $root "rtl\native_graph\control"
$inci = Join-Path $root "rtl\native_graph\integrate"
$incl = Join-Path $root "rtl\native_graph\learn"
$incm = Join-Path $root "rtl\native_graph\memory"

function Get-LicenseHolders {
  @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    ($_.Name -match 'xsim|xelab|xvlog|vivado|hw_server|cs_server') -and
    ($_.CommandLine -notmatch 'run_xsim.ps1')
  })
}

$zeroStreak = 0
while ($zeroStreak -lt 3) {
  $holders = Get-LicenseHolders
  if ($holders.Count -eq 0) {
    $zeroStreak++
    Write-Host ("C3PEND_SETTLE $zeroStreak/3 PROGRAM=NO")
  } else {
    $zeroStreak = 0
    Write-Host ("C3PEND_WAIT n=" + $holders.Count + " PROGRAM=NO")
  }
  Start-Sleep -Seconds 5
}

python (Join-Path $bag "gen_vectors.py")
if ($LASTEXITCODE -ne 0) { throw "C3PEND_TWIN_FAIL" }

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
  (Join-Path $bag "tb_astra_c3_pend_phi_pipe.sv")
)

$work = Join-Path $bag ("xsim_work_" + $PID)
if (Test-Path $work) { Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $work | Out-Null
Set-Location $work
& "$bin\xvlog.bat" --sv -i $incq -i $incc -i $inci -i $incl -i $incm -i $bag @files
if ($LASTEXITCODE -ne 0) { throw "C3PEND_XVLOG_FAIL" }
& "$bin\xelab.bat" tb_astra_c3_pend_phi_pipe -s c3pendphi -timescale 1ns/1ps -debug typical
if ($LASTEXITCODE -ne 0) { throw "C3PEND_XELAB_FAIL" }
$xsimLog = Join-Path $bag "xsim.log"
& "$bin\xsim.bat" c3pendphi -R -log $xsimLog
if ($LASTEXITCODE -ne 0) { throw "C3PEND_XSIM_FAIL" }
$ok = (Select-String -Path $xsimLog -Pattern "ASTRA_C3_PEND_PHI_PIPE_XSIM_PASS" -Quiet) -and
      (-not (Select-String -Path $xsimLog -Pattern "FIRST_DIVERGENCE" -Quiet))
if (-not $ok) { throw "C3PEND_MARKER_MISSING" }
Write-Host "ASTRA_C3_PEND_PHI_PIPE_RUN_OK"
Write-Host "C4_MASTER=OPEN C5_MASTER=OPEN C6_MASTER=OPEN PROGRAM=NO E3AB=DO_NOT_START"
