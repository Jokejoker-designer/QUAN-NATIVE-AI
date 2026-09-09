$ErrorActionPreference = "Stop"
$env:XILINXD_LICENSE_FILE = "D:\Xilinx\licenses\vivado_basic.lic"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $bag "..\..\..")).Path
$vivado = "C:\2026.1\Vivado\bin\vivado.bat"
$bit = Join-Path $root "results\A7-NATIVE-GRAPH\ASTRA-11-A09R8-UART-FREEZE-BIT-01\a7ng_astra_11_a09r8_uart_freeze_wrap.bit"
$want = "e51bdca253a7179aa1037695918d0069c43770581a3152665fb8a2739ed461bb"
$got = (Get-FileHash -Algorithm SHA256 -LiteralPath $bit).Hash.ToLowerInvariant()
if ($got -ne $want) { throw "BIT_SHA_MISMATCH $got" }
$ports = [System.IO.Ports.SerialPort]::GetPortNames()
if ($ports -notcontains "COM12") { throw "COM12_MISSING $($ports -join ',')" }
Write-Host "LADDER_PRECHECK_OK sha=$got com12=YES sw0=OWNER_ON"
$log = Join-Path $bag "vivado_program_ladder.log"
$jou = Join-Path $bag "vivado_program_ladder.jou"
$tcl = Join-Path $bag "program.tcl"
Set-Location $bag
cmd /c "`"$vivado`" -mode batch -notrace -source `"$tcl`" -log `"$log`" -journal `"$jou`""
$exit = [int]$LASTEXITCODE
$ok = $false
if (Test-Path $log) {
  $ok = [bool](Select-String -Path $log -Pattern "ASTRA_11_A09R8_SILICON_PROGRAM_PASS" -Quiet)
}
if (($exit -ne 0) -or (-not $ok)) { throw "PROGRAM_FAIL exit=$exit ok=$ok" }
Write-Host "LADDER_PROGRAM_OK"
powershell -NoProfile -File (Join-Path $bag "uart_ladder.ps1")
$ue = [int]$LASTEXITCODE
Write-Host "LADDER_UART_EXIT=$ue"
if ($ue -ne 0) { throw "LADDER_UART_FAIL $ue" }
Write-Host "ASTRA_11_A09R8_PROGRAM_LADDER_OK"
