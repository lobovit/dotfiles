@echo off
title EasyAntiCheat - Apex Legends
color 0A

echo ========================================
echo   EASYANTICHEAT - APEX LEGENDS
echo ========================================
echo.
echo Pasta: D:\games\fps\Apex\EasyAntiCheat
echo Product ID: 5dcd88f4e2094a698ebffa43438edc33
echo.

:MENU
echo [1] Instalar EasyAntiCheat
echo [2] Reparar EasyAntiCheat (reinstala)
echo [3] Desinstalar EasyAntiCheat
echo [4] Verificar e Instalar (auto)
echo [5] Verificar se esta instalado
echo [6] Reset Completo (remove tudo)
echo [7] Verificar Status do Servico
echo [8] Sair
echo.
set /p choice="Escolha uma opcao (1-8): "

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto REPAIR
if "%choice%"=="3" goto UNINSTALL
if "%choice%"=="4" goto VERIFY_INSTALL
if "%choice%"=="5" goto VERIFY
if "%choice%"=="6" goto FACTORY_RESET
if "%choice%"=="7" goto STATUS
if "%choice%"=="8" goto EXIT

echo Opcao invalida!
pause
goto MENU

:INSTALL
echo.
echo Instalando EasyAntiCheat...
echo.
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" install 5dcd88f4e2094a698ebffa43438edc33
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
echo (reinstala o servico)
echo.
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" repair
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
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" uninstall 5dcd88f4e2094a698ebffa43438edc33
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

:VERIFY_INSTALL
echo.
echo Verificando e instalando se necessario...
echo.
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" verify-and-install 5dcd88f4e2094a698ebffa43438edc33
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo VERIFICADO E INSTALADO!
    echo ========================================
) else (
    echo ========================================
    echo ERRO: %errorlevel%
    echo ========================================
)
pause
goto MENU

:VERIFY
echo.
echo Verificando instalacao...
echo.
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" verify-installation 5dcd88f4e2094a698ebffa43438edc33
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo INSTALACAO VERIFICADA - OK!
    echo ========================================
) else (
    echo ========================================
    echo NAO INSTALADO (erro: %errorlevel%)
    echo ========================================
)
pause
goto MENU

:FACTORY_RESET
echo.
echo ========================================
echo ATENCAO: ISSO REMOVE TUDO!
echo ========================================
echo.
set /p confirm="Confirma? (S/N): "
if /i not "%confirm%"=="S" goto MENU
echo.
echo Executando factory reset...
echo.
"D:\games\fps\Apex\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe" qa-factory-reset
echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo FACTORY RESET CONCLUIDO!
    echo ========================================
    echo.
    echo Reinicie o computador e reinstale via EA App
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