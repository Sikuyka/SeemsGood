@echo off
chcp 65001 >nul
title Установка плагина Rojo в Studio
color 0A

set "ROJO=C:\Users\luxaeterna\Desktop\tools\rojo.exe"
set "PLUGINS=%LOCALAPPDATA%\Roblox\Plugins"
set "ROJO_RBXM=%TEMP%\Rojo.rbxm"
set "ROJO_URL=https://github.com/rojo-rbx/rojo/releases/download/v7.6.1/Rojo.rbxm"

echo.
echo ========================================
echo   Установка Rojo для Roblox Studio
echo ========================================
echo.

if not exist "%ROJO%" (
    echo [X] Не найден: %ROJO%
    echo Положите rojo.exe в Desktop\tools
    pause
    exit /b 1
)

if not exist "%PLUGINS%" mkdir "%PLUGINS%"

echo [1/3] Версия Rojo:
"%ROJO%" --version
echo.

echo [2/3] Установка плагина через rojo...
"%ROJO%" plugin install
echo.

echo [3/3] Резерв: копия Rojo.rbxm в папку плагинов...
powershell -NoProfile -Command ^
  "try { Invoke-WebRequest -Uri '%ROJO_URL%' -OutFile '%ROJO_RBXM%' -UseBasicParsing; Copy-Item -Force '%ROJO_RBXM%' '%PLUGINS%\Rojo.rbxm'; Write-Host 'OK: %PLUGINS%\Rojo.rbxm' } catch { Write-Host 'Скачивание не удалось - используйте шаг 2' }"

echo.
echo ========================================
echo   ГОТОВО
echo ========================================
echo.
echo 1. ЗАКРОЙТЕ Roblox Studio полностью
echo 2. Откройте Studio снова
echo 3. New - Baseplate
echo 4. Вкладка PLUGINS - кнопка Rojo
echo.
echo Ошибку Timedout place 95206881 - ИГНОРИРУЙТЕ.
echo Не жмите Open in Studio на сайте.
echo.
pause
