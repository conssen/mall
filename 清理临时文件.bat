@echo off
chcp 65001 >nul 2>&1
title 百度网盘临时文件清理工具

REM ===== 自动请求管理员权限 =====
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM ===== 扫描以下目录（可自行添加，用空格分隔）=====
set "SCAN_PATHS=D:\BaiduNetdiskDownload E:\BaiduNetdiskDownload D:\"

echo ========================================
echo    百度网盘临时文件清理工具
echo ========================================
echo.

set /a total_deleted=0

for %%P in (%SCAN_PATHS%) do (
    if exist %%P (
        echo 正在扫描: %%P
        for /f "delims=" %%F in ('dir /s /b /a-d "%%P\*.baiduyun.p.downloading" 2^>nul') do (
            del /f /q "%%F" >nul 2>&1
            if not exist "%%F" (
                echo   已删除: %%~nxF
                set /a total_deleted+=1
            )
        )
    )
)

echo.
echo ========================================
echo    清理完成！共删除 %total_deleted% 个临时文件
echo ========================================
echo.
pause
