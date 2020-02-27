:: BatchGotAdmin
:: From: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
:-------------------------------------
echo off
cls
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

@REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------- 

set MOUNTPOINT=x

cls

if not exist %MOUNTPOINT%:\EFI\ (
    mountvol %MOUNTPOINT%: /s
)

if exist %MOUNTPOINT%:\EFI\Microsoft\Boot\bootmgfw-orig.efi (
    echo Found Windows boot file. Renaming
    ren %MOUNTPOINT%:\EFI\Microsoft\Boot\bootmgfw-orig.efi bootmgfw.efi
    echo Success
    pause
) ELSE (
    if exist %MOUNTPOINT%:\EFI\Microsoft\Boot\bootmgfw.efi (
        echo Already set to boot from Windows.
        pause
    ) ELSE (
        echo Failed to find Windows boot file.
        pause
        exit
    )
)

CHOICE /N /M "Do you wish to reboot now? (Y/n)"%1
IF ERRORLEVEL ==2 GOTO END
shutdown /r /t 1

:END