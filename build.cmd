@echo off
title DCX Launcher Builder
setlocal

:: 设置文件路径变量
set INPUT_FILE=Universal-COM-Starter.ps1
set OUTPUT_FILE=DCX_Run.exe
set ICON_FILE=./Script/Serial.ico

echo ============================================
echo   DCX Launcher Build Script
echo ============================================

:: 1. 检查输入脚本是否存在
if not exist "%INPUT_FILE%" (
    echo [!] Error: %INPUT_FILE% not found!
    pause
    exit /b
)

:: 2. 检查旧文件是否被占用
if exist "%OUTPUT_FILE%" (
    echo [*] Removing old %OUTPUT_FILE%...
    del /f /q "%OUTPUT_FILE%" >nul 2>&1
    if exist "%OUTPUT_FILE%" (
        echo [!] ERROR: %OUTPUT_FILE% is locked!
        echo Please close the running EXE and try again.
        pause
        exit /b
    )
)

:: 3. 调用 PowerShell 进行打包 (使用单行指令，避免 ^ 符号错误)
echo [*] Compiling %INPUT_FILE% to %OUTPUT_FILE%...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module ps2exe; Invoke-PS2EXE -InputFile '%INPUT_FILE%' -OutputFile '%OUTPUT_FILE%' -IconFile '%ICON_FILE%'"

:: 4. 检查结果
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo [OK] Build Successful: %OUTPUT_FILE%
    echo ============================================
) else (
    echo.
    echo [!] Build Failed! 
    echo Please ensure 'ps2exe' module is installed.
    echo (Run: Install-Module ps2exe -Scope CurrentUser)
)

pause