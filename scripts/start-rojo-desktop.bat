@echo off
chcp 65001 >nul
title SeemsGood — Rojo Server

REM === Путь к rojo.exe на рабочем столе ===
set "ROJO=%USERPROFILE%\Desktop\rojo.exe"
if not exist "%ROJO%" set "ROJO=%USERPROFILE%\OneDrive\Desktop\rojo.exe"
if not exist "%ROJO%" set "ROJO=%USERPROFILE%\Рабочий стол\rojo.exe"

if not exist "%ROJO%" (
    echo [ОШИБКА] Не найден rojo.exe на рабочем столе.
    echo Положите rojo.exe на Desktop или укажите путь ниже в этом файле.
    pause
    exit /b 1
)

REM === Папка проекта SeemsGood (измените если у вас другой путь) ===
set "PROJECT=%USERPROFILE%\Desktop\SeemsGood"
if not exist "%PROJECT%\default.project.json" set "PROJECT=%USERPROFILE%\OneDrive\Desktop\SeemsGood"
if not exist "%PROJECT%\default.project.json" set "PROJECT=%~dp0.."

if not exist "%PROJECT%\default.project.json" (
    echo [ОШИБКА] Не найден SeemsGood с default.project.json
    echo Склонируйте: git clone https://github.com/Sikuyka/SeemsGood.git
    echo Или отредактируйте PROJECT= в этом bat-файле.
    pause
    exit /b 1
)

cd /d "%PROJECT%"
echo.
echo Rojo:    %ROJO%
echo Проект:  %PROJECT%
echo.
echo НЕ ЗАКРЫВАЙТЕ это окно. В Studio: Plugins - Rojo - Connect
echo.
"%ROJO%" serve
pause
