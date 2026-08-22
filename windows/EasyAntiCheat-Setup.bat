@echo off
title EasyAntiCheat - Apex Legends
color 0A

REM Vai para a pasta do proprio script
cd /d "%~dp0"

echo ========================================
echo   EASYANTICHEAT - APEX LEGENDS
echo ========================================
echo.
echo Pasta: %cd%
echo Product ID: 5dcd88f4e2094a698ebffa43438edc33
echo.

REM Verifica se o executavel existe
if not exist "EasyAntiCheat_EOS_Setup.exe" (
    echo ERRO: EasyAntiCheat_EOS_Setup.exe nao encontrado!
    echo Pasta atual: %cd%
    pause
    exit /b 1
)

:MENU
echo [1] Instalar EasyAntiCheat
echo [2] Reparar EasyAntiCheat  
echo [3] Desinstalar EasyAntiCheat
echo [4] Verificar Status
echo [5] Sair
echo.
set /p choice="Escolha uma opcao (1-5): "

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto REPAIR
if "%choice%"=="3" goto UNINSTALL
if "%choice%"=="4" goto STATUS
if "%choice%"=="5" goto EXIT

echo Opcao invalida!
pause
goto MENU

:INSTALL
echo.
echo Instalando EasyAntiCheat...
echo.
EasyAntiCheat_EOS_Setup.exe install 5dcd88f4e2094a698ebffa43438edc33
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo INSTALACAO CONCLUIDA!
    echo ========================================
) else (
    echo ========================================
    echo ERRO: %errorlevel%
    echo ========================================
)
pause
goto MENU

:REPAIR
echo.
echo Reparando EasyAntiCheat...
echo.
EasyAntiCheat_EOS_Setup.exe repair 5dcd88f4e2094a698ebffa43438edc33
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo REPARO CONCLUIDO!
    echo ========================================
) else (
    echo ========================================
    echo ERRO: %errorlevel%
    echo ========================================
)
pause
goto MENU

:UNINSTALL
echo.
echo Desinstalando EasyAntiCheat...
echo.
EasyAntiCheat_EOS_Setup.exe uninstall 5dcd88f4e2094a698ebffa43438edc33
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo DESINSTALACAO CONCLUIDA!
    echo ========================================
) else (
    echo ========================================
    echo ERRO: %errorlevel%
    echo ========================================
)
pause
goto MENU

:STATUS
echo.
echo Verificando status do servico...
echo.
sc query EasyAntiCheat_EOS
echo.
pause
goto MENU

:EXIT
exit