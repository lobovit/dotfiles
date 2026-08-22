@echo off
title EasyAntiCheat - Correcao Completa
color 0C

echo ========================================
echo   CORRECAO COMPLETA EASYANTICHEAT
echo ========================================
echo.
echo PROBLEMA IDENTIFICADO:
echo - Driver EasyAntiCheat_EOSSys.sys esta faltando
echo - Servico nao consegue iniciar
echo.
echo SOLUCAO: Reinstalacao completa via EA App
echo.

echo [1] Desinstalar EasyAntiCheat (limpeza completa)
echo [2] Verificar se ha arquivos restantes
echo [3] Abrir pasta do Apex Legends
echo [4] Sair
echo.
set /p choice="Escolha uma opcao (1-4): "

if "%choice%"=="1" goto CLEAN
if "%choice%"=="2" goto CHECK
if "%choice%"=="3" goto OPEN
if "%choice%"=="4" goto EXIT

echo Opcao invalida!
pause
goto MENU

:CLEAN
echo.
echo Parando servicos...
sc stop EasyAntiCheat_EOS 2>nul
sc delete EasyAntiCheat_EOS 2>nul
sc stop EasyAntiCheat_EOSSys 2>nul
sc delete EasyAntiCheat_EOSSys 2>nul

echo.
echo Removendo arquivos do EasyAntiCheat...
rd /s /q "C:\Program Files (x86)\EasyAntiCheat_EOS" 2>nul
rd /s /q "C:\Program Files (x86)\EasyAntiCheat" 2>nul
rd /s /q "D:\games\fps\Apex\EasyAntiCheat" 2>nul

echo.
echo Limpando registro...
reg delete "HKLM\SOFTWARE\WOW6432Node\EasyAntiCheat" /f 2>nul
reg delete "HKLM\SOFTWARE\EasyAntiCheat" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EasyAntiCheat_EOS" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EasyAntiCheat_EOSSys" /f 2>nul

echo.
echo ========================================
echo LIMPEZA CONCLUIDA!
echo ========================================
echo.
echo PROXIMOS PASSOS:
echo 1. REINICIE O COMPUTADOR
echo 2. Abra o EA App
echo 3. Va em Apex Legends ^> Reparar
echo 4. Ou reinstale o jogo
echo.
echo Os scripts de configuracao estao em:
echo D:\games\fps\Apex\-tools\
echo.
pause
goto MENU

:CHECK
echo.
echo Verificando arquivos restantes...
echo.

if exist "C:\Program Files (x86)\EasyAntiCheat_EOS" (
    echo Encontrado: C:\Program Files (x86)\EasyAntiCheat_EOS
    dir /b "C:\Program Files (x86)\EasyAntiCheat_EOS"
) else (
    echo Nao encontrado: C:\Program Files (x86)\EasyAntiCheat_EOS
)

echo.

if exist "D:\games\fps\Apex\EasyAntiCheat" (
    echo Encontrado: D:\games\fps\Apex\EasyAntiCheat
    dir /b "D:\games\fps\Apex\EasyAntiCheat"
) else (
    echo Nao encontrado: D:\games\fps\Apex\EasyAntiCheat
)

echo.
pause
goto MENU

:OPEN
explorer "D:\games\fps\Apex"
goto MENU

:EXIT
exit