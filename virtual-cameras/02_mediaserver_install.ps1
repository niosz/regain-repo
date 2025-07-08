# Esegui da PowerShell con permessi amministrativi

$latest = Invoke-RestMethod https://api.github.com/repos/bluenviron/mediamtx/releases/latest
$asset = $latest.assets | Where-Object { $_.name -like "*windows_amd64.zip" }
$url = $asset.browser_download_url
$dest = "$env:USERPROFILE\Downloads\mediamtx.zip"
$installDir = "$env:USERPROFILE\mediamtx"

Invoke-WebRequest -Uri $url -OutFile $dest
Expand-Archive -Path $dest -DestinationPath $installDir -Force

# Rendi la modifica PATH permanente a livello di sistema (richiede privilegi amministrativi)
$systemPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

if (-not ($systemPath.Split(';') -contains $installDir)) {
    $newPath = "$systemPath;$installDir"
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Value $newPath
    Write-Host "PATH di sistema aggiornato. Potrebbe essere necessario riavviare per applicare le modifiche."
} else {
    Write-Host "La cartella è già presente nel PATH di sistema."
}

Write-Host "MediaMTX installato in $installDir"
Write-Host "Esegui con: $installDir\mediamtx.exe"