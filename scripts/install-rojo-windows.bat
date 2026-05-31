@echo off
REM Двойной клик — установит Rojo и добавит в PATH
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-rojo-windows.ps1"
pause
