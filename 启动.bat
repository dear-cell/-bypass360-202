@echo off
title 代码签名工具 - MyCompany
echo ==========================================
echo       代码签名工具 - MyCompany
echo ==========================================
echo.

cd /d C:\Users\wy\Desktop\炜夜渗透工具箱\D-免杀\免杀-cs-msf\.加证书加资源
:: 检查管理员权限
powershell -Command "if (-not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')) { exit 1 }"
if %errorLevel% neq 0 (
    echo 请右键以管理员身份运行此脚本。
    pause
    exit /b 1
)

:: 提示用户输入要签名的文件名
set /p SIGNFILE=请输入要签名的文件名（例如：a.exe）: 

:: 检查输入是否为空
if "%SIGNFILE%"=="" (
    echo 未输入文件名，程序退出。
    pause
    exit /b 1
)

:: 检查文件是否存在
if not exist "%SIGNFILE%" (
    echo 文件 "%SIGNFILE%" 不存在，请检查文件路径。
    pause
    exit /b 1
)

:: 设定变量
setlocal
set PFXPASSWORD=test@123
set PFXFILE=.\codesign.pfx
set FRIENDLYNAME=My 1 Cert
set TIMESTAMPURL=http://timestamp.digicert.com
set SIGNSDK="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe"

:: 调用 PowerShell 脚本生成证书
echo 正在生成自签名证书，请稍候...
powershell -ExecutionPolicy Bypass -File create_cert.ps1 -PfxFile "%PFXFILE%" -PfxPassword "%PFXPASSWORD%" -FriendlyName "%FRIENDLYNAME%"
if not exist "%PFXFILE%" (
    echo 证书生成失败，请检查错误信息。
    pause
    exit /b 1
)

:: 签名目标文件
echo 正在签名文件 "%SIGNFILE%" ...
%SIGNSDK% sign /f "%PFXFILE%" /p "%PFXPASSWORD%" /t "%TIMESTAMPURL%" "%SIGNFILE%"
if errorlevel 1 (
    echo 签名失败，请检查错误信息。
    pause
    exit /b 1
)



echo.
echo 签名和验证完成。
pause
endlocal
