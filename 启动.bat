@echo off
title ����ǩ������ - MyCompany
echo ==========================================
echo       ����ǩ������ - MyCompany
echo ==========================================
echo.

cd /d C:\Users\wy\Desktop\�ҹ��͸������\D-��ɱ\��ɱ-cs-msf\.��֤�����Դ
:: ������ԱȨ��
powershell -Command "if (-not ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')) { exit 1 }"
if %errorLevel% neq 0 (
    echo ���Ҽ��Թ���Ա������д˽ű���
    pause
    exit /b 1
)

:: ��ʾ�û�����Ҫǩ�����ļ���
set /p SIGNFILE=������Ҫǩ�����ļ��������磺a.exe��: 

:: ��������Ƿ�Ϊ��
if "%SIGNFILE%"=="" (
    echo δ�����ļ����������˳���
    pause
    exit /b 1
)

:: ����ļ��Ƿ����
if not exist "%SIGNFILE%" (
    echo �ļ� "%SIGNFILE%" �����ڣ������ļ�·����
    pause
    exit /b 1
)

:: �趨����
setlocal
set PFXPASSWORD=test@123
set PFXFILE=.\codesign.pfx
set FRIENDLYNAME=My 1 Cert
set TIMESTAMPURL=http://timestamp.digicert.com
set SIGNSDK="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe"

:: ���� PowerShell �ű�����֤��
echo ����������ǩ��֤�飬���Ժ�...
powershell -ExecutionPolicy Bypass -File create_cert.ps1 -PfxFile "%PFXFILE%" -PfxPassword "%PFXPASSWORD%" -FriendlyName "%FRIENDLYNAME%"
if not exist "%PFXFILE%" (
    echo ֤������ʧ�ܣ����������Ϣ��
    pause
    exit /b 1
)

:: ǩ��Ŀ���ļ�
echo ����ǩ���ļ� "%SIGNFILE%" ...
%SIGNSDK% sign /f "%PFXFILE%" /p "%PFXPASSWORD%" /t "%TIMESTAMPURL%" "%SIGNFILE%"
if errorlevel 1 (
    echo ǩ��ʧ�ܣ����������Ϣ��
    pause
    exit /b 1
)



echo.
echo ǩ������֤��ɡ�
pause
endlocal
