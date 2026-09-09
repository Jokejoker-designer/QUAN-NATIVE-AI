$ErrorActionPreference = "Stop"
$bag = Split-Path -Parent $MyInvocation.MyCommand.Path
$portName = "COM12"
$expectMagic = 0xA2
$expectEol = 0x0A
$query = [Text.Encoding]::ASCII.GetBytes("pump requires indirect`n")

function Hex16([byte[]]$b) {
  return (($b | ForEach-Object { $_.ToString("x2") }) -join " ")
}

$ports = [System.IO.Ports.SerialPort]::GetPortNames()
"UART_PORTS=$($ports -join ',')" | Tee-Object -FilePath (Join-Path $bag UART_SMOKE.txt)
if ($ports -notcontains $portName) {
  "FIRST_DIVERGENCE COM12_MISSING ports=$($ports -join ',')" | Tee-Object -FilePath (Join-Path $bag FIRST_DIVERGENCE.txt)
  throw "COM12_MISSING"
}

$p = New-Object System.IO.Ports.SerialPort $portName, 115200, "None", 8, "One"
$p.ReadTimeout = 200
$p.WriteTimeout = 2000
$p.Handshake = [System.IO.Ports.Handshake]::None
$p.DtrEnable = $false
$p.RtsEnable = $false
$p.NewLine = "`n"
Start-Sleep -Seconds 2
$p.Open()
Start-Sleep -Milliseconds 400
$p.DiscardInBuffer()
$p.DiscardOutBuffer()
$p.Write($query, 0, $query.Length)
"QUERY_SENT ascii=pump requires indirect\\n n=$($query.Length)" | Add-Content (Join-Path $bag UART_SMOKE.txt)

$buf = New-Object System.Collections.Generic.List[byte]
$deadline = (Get-Date).AddSeconds(8)
while ((Get-Date) -lt $deadline) {
  try {
    $b = $p.ReadByte()
    $buf.Add([byte]$b) | Out-Null
    if ($buf.Count -ge 16) {
      for ($i = 0; $i -le $buf.Count - 16; $i++) {
        if ($buf[$i] -eq $expectMagic -and $buf[$i + 15] -eq $expectEol) {
          $fr = New-Object byte[] 16
          for ($k = 0; $k -lt 16; $k++) { $fr[$k] = $buf[$i + $k] }
          $p.Close()
          $ans = [int]$fr[2] -bor ([int]$fr[3] -shl 8) -bor (([int]($fr[4] -band 0x0F)) -shl 16)
          $p0  = [int]$fr[5] -bor ([int]$fr[6] -shl 8) -bor (([int]($fr[7] -band 0x0F)) -shl 16)
          $p1  = [int]$fr[8] -bor ([int]$fr[9] -shl 8) -bor (([int]($fr[10] -band 0x0F)) -shl 16)
          $st  = $fr[1] -band 0x0F
          $acc = (($fr[1] -shr 4) -band 1)
          $rov = (($fr[1] -shr 6) -band 1)
          $npath = $fr[11] -band 0x1F
          $hex = Hex16 $fr
          $lines = @(
            "FRAME $hex"
            "DECODE magic=0x$($fr[0].ToString('x2')) st=$st acc=$acc rov=$rov ans=$ans p0=$p0 p1=$p1 npath=$npath eol=0x$($fr[15].ToString('x2'))"
          )
          if ($fr[0] -eq $expectMagic -and $ans -eq 4 -and $p0 -eq 17) {
            $lines += "SMOKE=PASS ans=4 p0=17"
            $lines += "ASTRA_11_A09R8_SILICON_UART_SMOKE_PASS"
            $lines | Set-Content (Join-Path $bag UART_SMOKE.txt)
            Write-Host ($lines -join "`n")
            exit 0
          }
          $why = "SMOKE=FAIL_FRAME ans=$ans p0=$p0 (want 4/17)"
          if ($ans -eq 0 -and $p0 -eq 0) { $why += " NEED_SW0_PLANT_SMOKE" }
          $lines += $why
          $lines | Set-Content (Join-Path $bag UART_SMOKE.txt)
          "FIRST_DIVERGENCE UART_SMOKE_MISMATCH $why" | Set-Content (Join-Path $bag FIRST_DIVERGENCE.txt)
          Write-Host ($lines -join "`n")
          exit 2
        }
      }
    }
  } catch [TimeoutException] {
    continue
  } catch {
    if ($_.Exception.GetType().Name -match "Timeout") { continue }
    throw
  }
}
$p.Close()
$dump = if ($buf.Count -gt 0) { Hex16 $buf.ToArray() } else { "EMPTY" }
@(
  "FRAME_TIMEOUT bytes=$($buf.Count) dump=$dump"
  "NEED_SW0_OR_NO_TX"
) | Set-Content (Join-Path $bag UART_SMOKE.txt)
"FIRST_DIVERGENCE UART_TIMEOUT dump=$dump" | Set-Content (Join-Path $bag FIRST_DIVERGENCE.txt)
Write-Host "UART_TIMEOUT dump=$dump"
exit 3
