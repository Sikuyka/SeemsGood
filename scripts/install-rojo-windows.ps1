# SeemsGood — установка Rojo 7 на Windows + добавление в PATH
# Запуск: ПКМ → "Выполнить с помощью PowerShell"
# Или: powershell -ExecutionPolicy Bypass -File scripts\install-rojo-windows.ps1

$ErrorActionPreference = "Stop"
$RojoVersion = "7.6.1"
$InstallDir = Join-Path $env:LOCALAPPDATA "SeemsGood\rojo"
$ZipUrl = "https://github.com/rojo-rbx/rojo/releases/download/v$RojoVersion/rojo-$RojoVersion-windows-x86_64.zip"
$ZipPath = Join-Path $env:TEMP "rojo-$RojoVersion-windows.zip"

Write-Host "=== SeemsGood: установка Rojo $RojoVersion ===" -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Write-Host "Скачивание..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing

Write-Host "Распаковка в $InstallDir ..." -ForegroundColor Yellow
Expand-Archive -Path $ZipPath -DestinationPath $InstallDir -Force
Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue

$RojoExe = Join-Path $InstallDir "rojo.exe"
if (-not (Test-Path $RojoExe)) {
    throw "rojo.exe не найден после распаковки: $InstallDir"
}

# --- Добавление в PATH (пользователь, без админа) ---
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$paths = $userPath -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }

if ($paths -notcontains $InstallDir) {
    $newPath = if ($userPath) { "$userPath;$InstallDir" } else { $InstallDir }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "PATH обновлён (User): добавлено $InstallDir" -ForegroundColor Green
} else {
    Write-Host "PATH уже содержит $InstallDir" -ForegroundColor Green
}

# Текущая сессия PowerShell тоже видит rojo
$env:Path = "$env:Path;$InstallDir"

Write-Host ""
Write-Host "Проверка версии:" -ForegroundColor Cyan
& $RojoExe --version

Write-Host ""
Write-Host "Установка плагина Studio (если Studio установлена)..." -ForegroundColor Yellow
try {
    & $RojoExe plugin install
    Write-Host "Плагин установлен. Перезапустите Roblox Studio." -ForegroundColor Green
} catch {
    Write-Host "Плагин не установлен автоматически. Поставьте вручную:" -ForegroundColor Yellow
    Write-Host "https://create.roblox.com/marketplace/asset/13916111004/Rojo"
}

Write-Host ""
Write-Host "Готово. Закройте и откройте PowerShell, затем:" -ForegroundColor Cyan
Write-Host "  cd путь\к\SeemsGood" -ForegroundColor White
Write-Host "  rojo serve" -ForegroundColor White
Write-Host ""
Read-Host "Нажмите Enter для выхода"
