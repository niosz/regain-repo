# main.ps1
$child1 = Start-Process -FilePath powershell.exe `
          -ArgumentList '-NoLogo','-ExecutionPolicy','Bypass','-File','.\03_rtsp.ps1' `
          -PassThru     # <-- ci restituisce l’oggetto [System.Diagnostics.Process]

$child2 = Start-Process -FilePath powershell.exe `
          -ArgumentList '-NoLogo','-ExecutionPolicy','Bypass','-File','.\04_ffmpeg.ps1' `
          -PassThru

try {
    Write-Host 'Main: faccio il mio lavoro…'
    Start-Sleep 2147482        # simulazione di attività
}
finally {
    Write-Host 'Main: stop dei processi figli…'
    foreach ($p in @($child1,$child2)) {
        if (-not $p.HasExited) {
            $p.CloseMainWindow() | Out-Null   # tenta chiusura gentile
            Start-Sleep 2
            if (-not $p.HasExited) { $p.Kill() } # kill se serve
        }
        $p.Dispose()
    }
}